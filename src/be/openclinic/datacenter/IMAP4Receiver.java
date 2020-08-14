package be.openclinic.datacenter;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;
import java.util.Vector;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.io.IOUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.model.vo.IdentifierFactory;
import be.mxs.common.model.vo.healthrecord.IConstants;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.archiving.ArchiveDocument;
import be.openclinic.finance.Insurance;
import net.admin.AdminPerson;
import net.admin.Label;

public class IMAP4Receiver extends Receiver {

	public void receive(){
        String host = MedwanQuery.getInstance().getConfigString("datacenterPOP3Host","localhost");
        String username = MedwanQuery.getInstance().getConfigString("datacenterPOP3Username","");
        String password = MedwanQuery.getInstance().getConfigString("datacenterPOP3Password","");
        Debug.println("logging in to "+host+" with "+username+"/"+password);
    	Properties props=System.getProperties();
    	if(Debug.enabled){
    		//props.put("mail.debug","true");
    	}
	    try {
	        Session session = Session.getInstance(props, null);
	    	Store store = session.getStore("imap");
			store.connect(host, username, password);
		    Folder folder = store.getFolder("INBOX");
		    folder.open(Folder.READ_WRITE);
		    Message message[] = folder.getMessages();
		    Debug.println("Found "+message.length+" messages");
		    for (int i=0, n=message.length; i<n && i<100; i++) {
		    	boolean deletemessage=false;
		    	if(message[i].getSubject().contains("datacenter.content")){
		    		Debug.println("Subject: "+message[i].getSubject());
			    	//Store the message in the oc_imports database here and delete it if successful
		            SAXReader reader = new SAXReader(false);
		            try{
		            	String theMessage = new String(message[i].getContent().toString());
		            	if(theMessage.indexOf("</message>")>-1 && theMessage.indexOf("</message>")<theMessage.length()-10){
		            		theMessage = theMessage.substring(0,theMessage.indexOf("</message>")+10);
		            	}
						Document document = reader.read(new ByteArrayInputStream(theMessage.getBytes()));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						Vector ackMessages=new Vector();
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
							Debug.println("data = "+data.asXML());
					    	ImportMessage msg = new ImportMessage(data);
							msg.setType(root.attributeValue("type"));
							Debug.println("type = "+root.attributeValue("type"));
					    	msg.setReceiveDateTime(new java.util.Date());
					    	msg.setRef("SMTP:"+message[i].getFrom()[0]);
							Debug.println("ref = "+"SMTP:"+message[i].getFrom()[0]);
					    	try {
					    		Debug.println("Storing...");
								msg.store();
								Debug.println("Stored");
								deletemessage=true;
						    	ackMessages.add(msg);
								Debug.println("ACK Added");
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
				    	//Set ackDateTime for all received messages in mail
						ImportMessage.sendAck(ackMessages);
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
		    	else if (message[i].getSubject().contains("datacenter.ack")){
		            SAXReader reader = new SAXReader(false);
		            try{
			            Document document = reader.read(new ByteArrayInputStream(message[i].getContent().toString().getBytes("UTF-8")));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
					    	AckMessage msg = new AckMessage(data);
					    	if(msg.serverId==MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)){
					    		ExportMessage.updateAckDateTime(msg.getObjectId(), msg.getAckDateTime());
					    	}
					    	else {
					    		//TODO: send warning to system administrator 
					    		//ACK received addressed to other server!
					    		if(MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)>=0 && msg.getServerId()>0){
						    		String error="Server "+MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)+" received SMTP ACK message intended for server "+msg.getServerId();
						    		SMTPSender.sendSysadminMessage(error, msg);
					    		}
					    	}
						}
				    	deletemessage=true;
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
		    	else if (message[i].getSubject().contains("datacenter.importack")){
		            SAXReader reader = new SAXReader(false);
		            try{
			            Document document = reader.read(new ByteArrayInputStream(message[i].getContent().toString().getBytes("UTF-8")));
						Element root = document.getRootElement();
						Iterator msgs = root.elementIterator("data");
						while(msgs.hasNext()){
							Element data = (Element)msgs.next();
					    	ImportAckMessage msg = new ImportAckMessage(data);
					    	if(msg.serverId==MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)){
					    		ExportMessage.updateImportAckDateTime(msg.getObjectId(), msg.getImportAckDateTime());
					    		ExportMessage.updateImportDateTime(msg.getObjectId(), msg.getImportDateTime());
					    		ExportMessage.updateErrorCode(msg.getObjectId(), msg.getError());
					    	}
					    	else {
					    		//TODO: send warning to system administrator 
					    		//Import ACK received addressed to other server!
					    		if(MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)>=0 && msg.getServerId()>0){
						    		String error="Server "+MedwanQuery.getInstance().getConfigInt("datacenterServerId",0)+" received SMTP ACK message intended for server "+msg.getServerId();
						    		SMTPSender.sendSysadminMessage(error, msg);
					    		}
					    	}
						}
				    	deletemessage=true;
		            }
		            catch(MessagingException e){
		            	Debug.println(e.getMessage());
		            } catch (UnsupportedEncodingException e) {
		            	Debug.println(e.getMessage());
		    		} catch (DocumentException e) {
		            	Debug.println(e.getMessage());
		    		} catch (IOException e) {
		            	Debug.println(e.getMessage());
		    		}
		    	}
		    	else {
		            SAXReader reader = new SAXReader(false);
		    		try {
						Multipart multipart = (Multipart) message[i].getContent();
					    for (int o = 0; o < multipart.getCount(); o++) {
					    	BodyPart bodyPart = multipart.getBodyPart(o);
					        if(!Part.ATTACHMENT.equalsIgnoreCase(bodyPart.getDisposition()) &&
					               ScreenHelper.checkString(bodyPart.getFileName()).length()==0) {
					            continue; // dealing with attachments only
					        } 
					        try{
				            	Document document = reader.read(bodyPart.getInputStream());
				            	Element root = document.getRootElement();
				            	if(root.getName().equalsIgnoreCase("message") && root.attributeValue("type").equalsIgnoreCase("patientid")){
				            		AdminPerson person=null;
				            		boolean bFound=false,bStorePatient=false;
				            		//Try to identify the local patient
				            		if(ScreenHelper.checkString(root.attributeValue("receiverpersonids")).length()>0){
				            			//First check based on receiver personid
				            			String[] receiverpersonids=root.attributeValue("receiverpersonids").split(";");
				            			for(int q=0;q<receiverpersonids.length;q++){
				            				String receiverpersonid=receiverpersonids[q];
					            			if(receiverpersonid.split(":").length==2 && receiverpersonid.split(":")[0].equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("datacenterSMTPFrom"))){
						            			//We are sure that the personid is coming from this server
					            				person = AdminPerson.getAdminPerson(receiverpersonid.split(":")[1]);
						            			if(person!=null && ScreenHelper.checkString(person.lastname).length()>0){
						            				bFound=true;
						            				break;
						            			}
					            			}
				            			}
				            		}
				            		if(!bFound && ScreenHelper.checkString(root.attributeValue("insurancenumber")).length()>0){
				            			//If receiver personid not found, check insurancenumber
				            			Vector insurances = Insurance.findInsurances("", "", MedwanQuery.getInstance().getConfigString("referenceInsurarUid",""), root.attributeValue("insurancenumber"));
				            			if(insurances.size()>0){
				            				Insurance insurance = (Insurance)insurances.elementAt(0);
				            				person = insurance.getPatient();
				            				bFound=true;
				            			}
				            		}
				            		if(!bFound && ScreenHelper.checkString(root.attributeValue("natreg")).length()>0){
				            			//If receiver insurancenumber not found, check natreg
				            			String pid = AdminPerson.getPersonIdByNatReg(root.attributeValue("natreg"));
				            			if(ScreenHelper.checkString(pid).length()>0) {
				            				person=AdminPerson.getAdminPerson(pid);
				            				bFound=true;
				            			}
				            		}
				            		if(!bFound){
				            			//Patient was not found
				            			//Create a new patient object from the data provided in the XML document
				            			person = new AdminPerson();
				            			person.fromXmlElement(root.element("patient"), false);
				            			person.setID("natreg",ScreenHelper.checkString(root.attributeValue("natreg")));
				            			bStorePatient=true;
				            			bFound=true;
				            		}
				            		if(bFound){
				            			//Add senderpersonid to local receiverpersonids (in case we want to send information back)
				            			if(bStorePatient || person.addReceiverPersonId(root.attributeValue("senderpersonid"))){
				            				person.store();
				            			}
				            			//Integrate document
				            			//First create a document transaction
				            			int tranId = MedwanQuery.getInstance().getOpenclinicCounter("TransactionID");
				            			TransactionVO transaction = new TransactionVO(tranId,"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ARCHIVE_DOCUMENT",new java.util.Date(),new java.util.Date(),IConstants.TRANSACTION_STATUS_CLOSED,MedwanQuery.getInstance().getUser("4"),new Vector());
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_TITLE",
                                                root.elementText("document"),new Date(),null));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_REFERENCE",
                                                root.attributeValue("senderpersonid"),new Date(),null));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_PERSONID",
                                                person.personid,new Date(),null));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_STORAGENAME",
                                                "",new Date(),null));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_SENDEREMAIL",
                                                root.element("sender").elementText("email")+" - "+root.element("sender").elementText("name"),new Date(),null));
				                    	
				            			ArchiveDocument archDoc = ArchiveDocument.save(true,transaction,MedwanQuery.getInstance().getUser("4"));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UID",
                                                archDoc.getUid(),new Date(),null));
				            			transaction.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UDI",
                                                archDoc.udi,new Date(),null));
				                        MedwanQuery.getInstance().updateTransaction(Integer.parseInt(person.personid),transaction);
				                        
				                        //Now we must store the document with the right udi
				                        String storagename=archDoc.getUid()+".pdf";
				                        //Try to figure out if we also have a PDF attachment with the same filename
				                        String xmlfilename=bodyPart.getFileName();
				                        String pdffilename=xmlfilename.replaceAll(".xml", ".pdf");
				                        String path=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirFrom","from");
									    for (int k = 0; k < multipart.getCount(); k++) {
									    	BodyPart pdfBodyPart = multipart.getBodyPart(k);
									    	if(pdfBodyPart.getFileName()!=null && pdfBodyPart.getFileName().equalsIgnoreCase(pdffilename)){
									    		//We found the matching PDF attachment, now store it on disk
									    		File outputFile = new File(path+"/"+archDoc.udi+".pdf");
									    		FileOutputStream os =new FileOutputStream(outputFile);
									    		IOUtils.copy(pdfBodyPart.getInputStream(),os);
									    		os.close();
									    		break;
									    	}
									    }
									    //Also add the sender of the document to the destinations (if he doesn't exist yet)
									    Label label = new Label();
									    label.type="sendRecordDestinations";
									    label.id=root.element("sender").elementText("email");
									    label.language=MedwanQuery.getInstance().getConfigString("DefaultLanguage","en");
									    label.value=root.element("sender").elementText("name");
									    label.updateUserId="4";
									    label.saveToDB();
				            		}
				            		else{
				            			//Put document in waiting list
				            			//Forward by e-mail?
				            		}
				            	}
				            	else if(root.attributeValue("type").equalsIgnoreCase("invoicefollowup")){
				            		//Store a pointer with invoice follow-up information
				            		Iterator invoices = root.elementIterator("invoice");
				            		while(invoices.hasNext()){
				            			Element invoice = (Element)invoices.next();
					            		Pointer pointer = new Pointer();
					            		String key="INSINVXML."+invoice.attributeValue("id");
					            		String value=invoice.attributeValue("date")+";"+invoice.attributeValue("status")+";"+invoice.attributeValue("progress");
					            		pointer.storeUniquePointer(key,value,new java.util.Date());
				            		}
				            	}
				            	else if(root.attributeValue("type").equalsIgnoreCase("beneficiaries")){
			            			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				            		if(root.attributeValue("subtype").equalsIgnoreCase("0")){
				            			//Modification
					            		Iterator beneficiaries = root.elementIterator("beneficiary");
					            		while(beneficiaries.hasNext()){
					            			Element beneficiary = (Element)beneficiaries.next();
					            			String sql="delete from OC_BENEFICIARIES where OC_BENEFICIARY_ID=?";
					            			PreparedStatement ps = conn.prepareStatement(sql);
					            			ps.setString(1, beneficiary.attributeValue("insurancecode"));
					            			ps.execute();
					            			ps.close();
					            			if(beneficiary.attributeValue("status").equalsIgnoreCase("1")){
					            				sql="insert into oc_beneficiaries(oc_beneficiary_id,oc_beneficiary_firstname,oc_beneficiary_lastname,oc_beneficiary_gender,oc_beneficiary_dateofbirth,oc_beneficiary_idcard,oc_beneficiary_picture,oc_beneficiary_address,oc_beneficiary_region,oc_beneficiary_department,oc_beneficiary_town,oc_beneficiary_telephone) values(?,?,?,?,?,?,?,?,?,?,?,?)";
					            				ps=conn.prepareStatement(sql);
					            				ps.setString(1, beneficiary.attributeValue("insurancecode"));
					            				ps.setString(2, beneficiary.elementText("firstname"));
					            				ps.setString(3, beneficiary.elementText("lastname"));
					            				ps.setString(4, beneficiary.elementText("gender"));
					            				ps.setString(5, beneficiary.elementText("dateofbirth"));
					            				ps.setString(6, beneficiary.elementText("idcard"));
					            				ps.setString(7, beneficiary.elementText("picture"));
					            				ps.setString(8, beneficiary.elementText("address"));
					            				ps.setString(9, beneficiary.elementText("region"));
					            				ps.setString(10, beneficiary.elementText("department"));
					            				ps.setString(11, beneficiary.elementText("town"));
					            				ps.setString(12, beneficiary.elementText("telephone"));
					            				ps.execute();
					            				ps.close();
					            			}
					            		}
				            		}
				            		else if(root.attributeValue("subtype").equalsIgnoreCase("1")){
				            			//Full list
					            		Iterator beneficiaries = root.elementIterator("beneficiary");
				            			String sql="delete from OC_BENEFICIARIES";
				            			PreparedStatement ps = conn.prepareStatement(sql);
				            			ps.execute();
				            			ps.close();
					            		while(beneficiaries.hasNext()){
					            			Element beneficiary = (Element)beneficiaries.next();
					            			if(beneficiary.attributeValue("status").equalsIgnoreCase("1")){
					            				sql="insert into oc_beneficiaries(oc_beneficiary_id,oc_beneficiary_firstname,oc_beneficiary_lastname,oc_beneficiary_gender,oc_beneficiary_dateofbirth,oc_beneficiary_idcard,oc_beneficiary_picture,oc_beneficiary_address,oc_beneficiary_region,oc_beneficiary_department,oc_beneficiary_town,oc_beneficiary_telephone) values(?,?,?,?,?,?,?,?,?,?,?,?)";
					            				ps=conn.prepareStatement(sql);
					            				ps.setString(1, beneficiary.attributeValue("insurancecode"));
					            				ps.setString(2, beneficiary.elementText("firstname"));
					            				ps.setString(3, beneficiary.elementText("lastname"));
					            				ps.setString(4, beneficiary.elementText("gender"));
					            				ps.setString(5, beneficiary.elementText("dateofbirth"));
					            				ps.setString(6, beneficiary.elementText("idcard"));
					            				ps.setString(7, beneficiary.elementText("picture"));
					            				ps.setString(8, beneficiary.elementText("address"));
					            				ps.setString(9, beneficiary.elementText("region"));
					            				ps.setString(10, beneficiary.elementText("department"));
					            				ps.setString(11, beneficiary.elementText("town"));
					            				ps.setString(12, beneficiary.elementText("telephone"));
					            				ps.execute();
					            				ps.close();
					            			}
					            		}
				            		}
				            		conn.close();
				            	}
					        }
					        catch(Exception r){
					        	r.printStackTrace();
					        	//Not an xml file
					        	//Skip
					        }
					    }
					    deletemessage=true;
		    		}
					catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						deletemessage=true;
					}
		    	}
			    if(deletemessage){
					try{
						message[i].setFlag(Flags.Flag.DELETED, true);
						Debug.println("DELETED");
					}
					catch(javax.mail.FolderClosedException a){
						a.printStackTrace();
					}
			    }
		    }
	
		    // Close connection 
		    folder.close(true);
		    store.close();
		} catch (MessagingException e1) {
			// TODO Auto-generated catch block
			Debug.println(e1.getMessage());
		}
	}
}
