package be.openclinic.hl7;

import java.io.IOException;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.medical.Labo;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.system.SH;
import ca.uhn.hl7v2.AcknowledgmentCode;
import ca.uhn.hl7v2.DefaultHapiContext;
import ca.uhn.hl7v2.HL7Exception;
import ca.uhn.hl7v2.HapiContext;
import ca.uhn.hl7v2.model.Message;
import ca.uhn.hl7v2.model.Varies;
import ca.uhn.hl7v2.model.v251.group.ORU_R01_OBSERVATION;
import ca.uhn.hl7v2.model.v251.group.ORU_R01_ORDER_OBSERVATION;
import ca.uhn.hl7v2.model.v251.group.OUL_R22_ORDER;
import ca.uhn.hl7v2.model.v251.group.OUL_R22_RESULT;
import ca.uhn.hl7v2.model.v251.group.OUL_R22_SPECIMEN;
import ca.uhn.hl7v2.model.v251.message.ACK;
import ca.uhn.hl7v2.model.v251.message.ORU_R01;
import ca.uhn.hl7v2.model.v251.message.OUL_R22;
import ca.uhn.hl7v2.model.v251.segment.OBX;
import ca.uhn.hl7v2.parser.CanonicalModelClassFactory;
import ca.uhn.hl7v2.parser.Parser;
import ca.uhn.hl7v2.protocol.ReceivingApplication;
import ca.uhn.hl7v2.protocol.ReceivingApplicationException;
import ca.uhn.hl7v2.util.Terser;

public class HL7Receiver implements ReceivingApplication {
	@Override
	public boolean canProcess(Message message) {
	    return true;
	}
	
	@Override
 	public Message processMessage(Message message, Map<String, Object> theMetadata) throws ReceivingApplicationException, HL7Exception {
        String sError="";
        HapiContext context = new DefaultHapiContext();
        CanonicalModelClassFactory mcf = new CanonicalModelClassFactory("2.5.1");
        context.setModelClassFactory(mcf);			
 		String encodedMessage = context.getPipeParser().encode(message);
        System.out.println("\n\n\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\nReceived message:\n" + encodedMessage.replaceAll("\r","\r\n") + "\n\n");
        //Process the message
        Terser terser = new Terser(message);
        String messageType=terser.get("/.MSH-9-1");
        String messageSubType=terser.get("/.MSH-9-2");
        System.out.println("message type = "+messageType+"^"+messageSubType);
        System.out.println("storing received message in OC_HL7IN log");
        HL7Server.storeReceivedMessage(messageType+"_"+messageSubType, message);
        if(messageType.equalsIgnoreCase("OML") && messageSubType.equalsIgnoreCase("O21")) {
        	/*
        	 * Process a lab order message
        	 * Only relevant when OpenClinic GA is being used as the LIMS
        	 */
        	HL7Server.setReceivedMessageProcessed(message);
        }
        else if(messageType.equalsIgnoreCase("OUL") && messageSubType.equalsIgnoreCase("R22")) {
        	/*
        	 * Process a lab results message
        	 * We process LOINC codes and Internal Labanalyzer codes
        	 */
        	OUL_R22 labresults = (OUL_R22)message;
        	String personid = labresults.getPATIENT().getPID().getPid3_PatientIdentifierList(0).getIDNumber().getValue();
        	List specimens = labresults.getSPECIMENAll();
        	System.out.println("Total number of specimen: "+specimens.size());
        	Iterator iSpecimens = specimens.iterator();
        	while(iSpecimens.hasNext()) {
        		OUL_R22_SPECIMEN specimen = (OUL_R22_SPECIMEN)iSpecimens.next();
        		String barcodeid = HL7Server.checkString(specimen.getSPM().getSpecimenID().getPlacerAssignedIdentifier().getEi1_EntityIdentifier().getValue());
            	System.out.println("BarcodeID: "+barcodeid);
        		String specimenid="";
        		try {
					java.sql.Connection conn = SH.getOpenClinicConnection();
	        		specimenid = Labo.getLabSpecimenId(barcodeid,conn);
	        		conn.close();
				} catch (SQLException e2) {
					// TODO Auto-generated catch block
					e2.printStackTrace();
				}
        		if(specimenid==null) {
        			System.out.println("OUL^R22 Error: invalid specimenid: "+barcodeid);
        			continue;
        		}
        		else {
        			System.out.println("Valid specimen ID: "+barcodeid+" (Lab order ID = "+specimenid.split("\\.")[0]+"."+specimenid.split("\\.")[1]+")");
        		}
        		String serverid = specimenid.split("\\.")[0];
        		String transactionid = specimenid.split("\\.")[1];
        		try {
                    String id=terser.get("/.MSH-10");
        			System.out.println("Setting transactionId = "+transactionid+" for message "+id+" in OC_HL7IN");
        			HL7Server.storeReceivedMessageTransactionId(id, Integer.parseInt(transactionid));
                	System.out.println("TransactionId stored");
        		}
        		catch(Exception e) {
        			e.printStackTrace();
        		}
    			try {
					if(!(HL7Server.getTransactionPersonId(Integer.parseInt(serverid), Integer.parseInt(transactionid))+"").equalsIgnoreCase(personid)) {
	        			System.out.println("OUL^R22 Error: no matching lab order for personid/specimenid = "+personid+"/"+barcodeid);
						continue;
					}
	        		else {
	        			System.out.println("Valid personid: "+personid);
	        		}
				} catch (NumberFormatException | SQLException e1) {
					e1.printStackTrace();
				}
        		List orders = specimen.getORDERAll();
        		Iterator iOrders = orders.iterator();
        		while(iOrders.hasNext()) {
        			OUL_R22_ORDER order = (OUL_R22_ORDER)iOrders.next();
        			List results = order.getRESULTAll();
        			Iterator iResults = results.iterator();
        			while(iResults.hasNext()) {
        				OUL_R22_RESULT result = (OUL_R22_RESULT)iResults.next();
        				OBX obx = result.getOBX();
            			String analysercode = HL7Server.checkString(obx.getObservationIdentifier().getCe1_Identifier().getValue());
            			String labcode="";
            			try {
							if(HL7Server.getConfigString("labanalysercodemapping","loinc").equalsIgnoreCase("loinc")) {
								labcode = HL7Server.getLabCodeByMedidocCode(analysercode);
							}
							else {
								labcode = HL7Server.getLabCodeByAnalyserCode(analysercode);
							}
							if(labcode.length()==0) {
								if(HL7Server.getConfigInt("labanalysercodemappingallowmismatches",0)==1) {
									labcode= HL7Server.getLabCode(labcode);
								}
							}
							if(labcode.length()==0) {
			        			System.out.println("OUL^R22 Error: invalid analysercode: "+analysercode);
								continue;
							}
			        		else {
			        			System.out.println("Valid labcode: "+labcode);
			        		}
						} catch (SQLException e) {
							e.printStackTrace();
						}
            			String value = HL7Server.checkString(obx.getObservationValue(0).encode());
            			String unit = HL7Server.checkString(obx.getUnits().encode());
            			String abnormal = HL7Server.checkString(obx.getAbnormalFlags(0).getValue());
            			String analyser = HL7Server.checkString(obx.getEquipmentInstanceIdentifier()[0].getEi1_EntityIdentifier()+"");
            			System.out.println("++++ Analayser ID = "+analyser);
            			try {
							if(!HL7Server.existsRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode)) {
			        			System.out.println("OUL^R22 Error: no matching lab analysis order for personid/specimenid/labcode = "+personid+"/"+barcodeid+"/"+labcode);
			        			if(HL7Server.getConfigInt("autocreateHL7results", 0)==1) {
				        			System.out.println("Creating new analysis order: "+personid+"/"+barcodeid+"/"+labcode);
			        				RequestedLabAnalysis analysis = new RequestedLabAnalysis();
			        				analysis.setAnalysisCode(labcode);
			        				analysis.setPatientId(personid);
			        				analysis.setRequestDate(new java.sql.Date(new java.util.Date().getTime()));
			        				analysis.setComment("###"+analyser);
			        				analysis.setRequestUserId(HL7Server.getConfigString("defaultLabTechnicianId","4"));
			        				analysis.setServerId(serverid);
			        				analysis.setTransactionId(transactionid);
			        				analysis.setUpdatetime(new java.sql.Date(new java.util.Date().getTime()));
			        				analysis.setObjectid(-1);
			        		    	java.sql.Connection conn =SH.getOpenClinicConnection();
			        				analysis.store(false, conn);
			        				conn.close();
			        			}
			        			else {
			        				continue;
			        			}
							}
			        		else {
			        			System.out.println("Valid lab analysis order: "+personid+"/"+barcodeid+"/"+labcode);
			        		}
						} catch (NumberFormatException | SQLException e) {
							e.printStackTrace();
						}
						//Set the date/time of the result
						java.util.Date resultDate = new java.util.Date();
						try {
							resultDate=new java.util.Date(obx.getDateTimeOfTheObservation().getTime().getValueAsCalendar().getTimeInMillis());
						}
						catch(Exception ed) {
							try {
								resultDate=new java.util.Date(obx.getDateTimeOfTheAnalysis().getTime().getValueAsCalendar().getTimeInMillis());
							}
							catch(Exception ed2) {
								ed.printStackTrace();
							}
						}
						try {
							HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultDate", resultDate);
		        			System.out.println("Stored resultDate: "+resultDate);
						} catch (NumberFormatException | SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
						//Set the analyser
						try {
							HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "Comment", "###"+analyser);
		        			System.out.println("Stored analyser: "+analyser);
						} catch (NumberFormatException | SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						//Set the value of the result
						String resultType = HL7Server.checkString(obx.getValueType().getValue());
						if(resultType.equalsIgnoreCase("NM")) {
							try {
								HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultValue", value);
			        			System.out.println("Stored resultValue: "+value);
							} catch (NumberFormatException | SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							String references = HL7Server.checkString(obx.getReferencesRange().getValue());
							if(references.split(" - ").length==2) {
								try {
									HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultrefmin", references.split(" - ")[0]);
				        			System.out.println("Stored resultrefmin: "+references.split(" - ")[0]);
								} catch (NumberFormatException | SQLException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								try {
									HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultrefmax", references.split(" - ")[1]);
				        			System.out.println("Stored resultrefmax: "+references.split(" - ")[1]);
								} catch (NumberFormatException | SQLException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
							else if(HL7Server.checkString(references).length()>0){
								try {
									HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultrefmin", references);
									HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultrefmax", "");
				        			System.out.println("Stored resultrefmin: "+references);
								} catch (NumberFormatException | SQLException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
						}
						else {
							String resultValue="";
							for (Varies varies : obx.getObservationValue()) {
								if(resultValue.length()>0) {
									resultValue+=", ";
								}
								resultValue+=varies.encode();
							}
							try {
								HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultValue", resultValue);
			        			System.out.println("Stored resultvalue: "+resultValue);
							} catch (NumberFormatException | SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						try {
							HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "technicalvalidationdatetime", resultDate);
		        			System.out.println("Stored technicalvalidationdatetime: "+resultDate);
						} catch (NumberFormatException | SQLException e1) {
							// TODO Auto-generated catch block
							e1.printStackTrace();
						}
						try {
							HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "technicalvalidator", HL7Server.getConfigInt("defaultLabTechnicianId",4));
		        			System.out.println("Stored technicalvalidator: "+HL7Server.getConfigInt("defaultLabTechnicianId",4));
						} catch (SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						try {
							if(resultType.equalsIgnoreCase("NM") && HL7Server.checkString(abnormal).length()>0 && HL7Server.getConfigString("abnormalModifiersExtended", "*+*++*+++*-*--*---*h*hh*hhh*l*ll*lll*n*").contains("*"+abnormal+"*")) {
								HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultmodifier",abnormal);
			        			System.out.println("Stored resultmodifier: "+abnormal);
							}
							else if(abnormal.length()>0 && HL7Server.getConfigString("abnormalflagcodemapping","none").equalsIgnoreCase("ams")) {
	            				try {
	            					int iAbnormal = Integer.parseInt(abnormal) % 10;
	            					abnormal="";
	            					if(iAbnormal==0) {
	            						abnormal="n";
	            					}
	            					else if(iAbnormal==1) {
	            						abnormal="!";
	            					}
	            					else if(iAbnormal==2) {
	            						abnormal="!!";
	            					}
	            					else if(iAbnormal==3) {
	            						abnormal="!!!";
	            					}
	            					if(abnormal.length()>0) {
	    								HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultmodifier",abnormal);
	    			        			System.out.println("Stored resultmodifier: "+abnormal);
	            					}
	            				}
	            				catch (Exception e) {
	            					e.printStackTrace();
								}
	            			}
							else {
								if(resultType.equalsIgnoreCase("NM")){
									if(HL7Server.checkString(abnormal).length()>0) {
					        			System.out.println("Invalid resultmodifier: "+abnormal);
									}
									else {
										System.out.println("Missing resultmodifier");
									}
			        		    	java.sql.Connection conn =SH.getOpenClinicConnection();
			        		    	try {
					        			RequestedLabAnalysis analysis = RequestedLabAnalysis.get(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode,conn);
					        			analysis.calculateModifier(true,conn);
					        			System.out.println("Calculated resultmodifier: "+analysis.getUnverifiedResultModifier());
			        		    	}
			        		    	catch(Exception q) {
			        		    		q.printStackTrace();
			        		    	}
				        			conn.close();
								}
								else {
									HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultmodifier","");
								}
							}
						} catch (NumberFormatException | SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						try {
							HL7Server.updateRequestedLabanalysis(Integer.parseInt(serverid), Integer.parseInt(transactionid), labcode, "resultunit",unit);
		        			System.out.println("Stored resultunit: "+unit);
						} catch (NumberFormatException | SQLException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
        			}
        		}
        	}
        	HL7Server.setReceivedMessageProcessed(message);
        }
        else if(messageType.equalsIgnoreCase("ACK")) {
        	System.out.println("Received ACK");
        	ACK ack = (ACK)message;
	    	if("*AA*CA*".contains(ack.getMSA().getAcknowledgmentCode().getValue().toUpperCase())) {
        		try {
					HL7Server.setTransactionACK(ack.getMSA().getMessageControlID().getValue(), ack.getMSH().getDateTimeOfMessage().getTime().getValueAsCalendar().getTime());
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
        	}
        	else {
        		Parser p = context.getPipeParser();
        		String error = p.encode(ack);
        		try {
					HL7Server.setTransactionError(ack.getMSA().getMessageControlID().getValue(), error);
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
        	}
        	HL7Server.setReceivedMessageProcessed(message);
        }
        else {
        	//TODO: Any other message type
        	HL7Server.setReceivedMessageProcessed(message);
        }
        // Now generate a simple acknowledgment message and return it
        try {
        	if(sError.length()==0) {
        		return message.generateACK();
        	}
        	else {
        		return message.generateACK(AcknowledgmentCode.AE, new HL7Exception(sError));
        	}
        } catch (IOException e) {
            throw new HL7Exception(e);
        }
    }
}
