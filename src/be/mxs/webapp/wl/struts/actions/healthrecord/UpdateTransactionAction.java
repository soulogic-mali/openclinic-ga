package be.mxs.webapp.wl.struts.actions.healthrecord;

import be.dpms.medwan.common.model.vo.authentication.UserVO;
import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import be.mxs.common.model.vo.IdentifierFactory;
import be.mxs.common.model.vo.ValueObjectHelper;
import be.mxs.common.model.vo.ValueObjectHelperException;
import be.mxs.common.model.vo.healthrecord.IConstants;
import be.mxs.common.model.vo.healthrecord.ItemContextVO;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.model.vo.healthrecord.util.TransactionFactory;
import be.mxs.common.model.vo.healthrecord.util.TransactionFactoryGeneral;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.webapp.wl.exceptions.SessionContainerFactoryException;
import be.mxs.webapp.wl.servlet.http.RequestParameterParser;
import be.mxs.webapp.wl.session.SessionContainerFactory;
import be.openclinic.adt.Encounter;
import be.openclinic.archiving.ArchiveDocument;
import be.openclinic.common.ObjectReference;
import be.openclinic.finance.Debet;
import be.openclinic.finance.Prestation;
import be.openclinic.hl7.HL7Server;
import be.openclinic.knowledge.Ikirezi;
import be.openclinic.medical.Diagnosis;
import be.openclinic.medical.LabAnalysis;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.reporting.LabresultsNotifier;
import be.openclinic.system.SH;
import net.admin.User;
import net.admin.AdminPerson;
import net.admin.Service;
import net.admin.UserParameter;
import net.admin.system.AccessLog;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.*;

public class UpdateTransactionAction extends org.apache.struts.action.Action {

    //--- INNER CLASS ------------------------------------------------------------------------------
    private class DummyTransactionFactory extends TransactionFactory {
        public TransactionVO createTransactionVO(UserVO userVO) {
            return null;
        }
    }

    //--- PERFORM ----------------------------------------------------------------------------------
    public ActionForward perform(ActionMapping mapping,
                               ActionForm form,
                               HttpServletRequest request,
                               HttpServletResponse response)
        throws IOException, ServletException {

        ActionForward actionForward = mapping.findForward("failure");
        SessionContainerWO sessionContainerWO;

        
        try {
            sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
            if (sessionContainerWO.getHealthRecordVO()!=null){
                sessionContainerWO.getHealthRecordVO().setUpdated(true);
            }

            //*** send e-mail **********************************************************************
            try{
                String sMailTo = ScreenHelper.checkString(request.getParameter("MailTo"));
                String sMailMessage = ScreenHelper.checkString(request.getParameter("MailMessage"));

                if (sMailMessage.length()>0 && sMailTo.length()>0){
                    if (sMailTo.indexOf("@")==-1){
                        // only id : search email address
                        User user = new User();
                        user.initialize(Integer.parseInt(sMailTo));
                        sMailTo = "";
                    }

                    if (sMailTo.length()>0){
                        String sMailFrom = ScreenHelper.checkString(request.getParameter("MailFrom"));
                        if (sMailFrom.length()==0){
                            sMailFrom = MedwanQuery.getInstance().getConfigString("DefaultFromMailAddress");
                        }

                        String sMailSubject = ScreenHelper.checkString(request.getParameter("MailSubject"));
                        if (sMailSubject.length()==0){
                            sMailSubject = "OpenClinic";
                        }

                        // send messages
                        String sMailServer = MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer");
                        Mail.sendMail(sMailServer,sMailFrom,sMailTo,sMailSubject,sMailMessage,null,null);
                    }
                }
            }
            catch (Exception e){
                Debug.println(e.getMessage());
            }

            Vector items = new Vector();
            
            boolean bIsNewTrans = sessionContainerWO.getCurrentTransactionVO().getTransactionId().intValue()<0;              // save accesslog

            if (sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_GENERAL_CLINICAL_EXAMINATION)
                 || sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_OPTHALMOLOGY_EX_WITH_STEREOSCOPY)
                 || sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_OPHTALMOLOGY)){
                Iterator it = sessionContainerWO.getCurrentTransactionVO().getItems().iterator();
                ItemVO oldItem, newItem;

                while (it.hasNext()){
                    oldItem = (ItemVO)it.next();
                    if (oldItem.getValue() != null){
                        if (oldItem.getValue().trim().length()>0){
                            newItem = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), oldItem.getType(),"",new Date(),oldItem.getItemContext());
                            newItem.setValue(oldItem.getValue());
                            newItem.setItemId(oldItem.getItemId());
                            newItem.setDate(oldItem.getDate());
                            newItem.setItemContext(oldItem.getItemContext());
                            newItem.setType(oldItem.getType());
                            items.add(newItem);
                        }
                    }
                }
            }

            // copy the CurrentTransactionVO
            TransactionVO oldTransaction = new TransactionVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()),sessionContainerWO.getCurrentTransactionVO().getTransactionType(),new Date(),new Date(),IConstants.TRANSACTION_STATUS_CLOSED, sessionContainerWO.getCurrentTransactionVO().getUser(),items,sessionContainerWO.getCurrentTransactionVO().getServerId(),sessionContainerWO.getCurrentTransactionVO().getVersion(),sessionContainerWO.getCurrentTransactionVO().getVersionserverId(),sessionContainerWO.getCurrentTransactionVO().getTimestamp());

            Hashtable dirtyRequestParameters = RequestParameterParser.getInstance().parseRequestParameters(request, "currentTransactionVO");
            Hashtable requestParameters = new Hashtable();
            Enumeration dirtypars = dirtyRequestParameters.keys();
            while(dirtypars.hasMoreElements()){
            	String key = (String)dirtypars.nextElement();
            	if(key.indexOf("_currentTransactionVO")<0){
            		requestParameters.put(key,dirtyRequestParameters.get(key));
            	}
            }

            String actionForwardKey;

            Collection valueObjectContainers = ValueObjectHelper.getInstance().updateModel(sessionContainerWO, requestParameters);
            Collection newTransactions = ValueObjectHelper.getInstance().getValueObjectsInPath(valueObjectContainers, "currentTransactionVO");

            Iterator iterator = newTransactions.iterator();
            DummyTransactionFactory df;
            TransactionVO newTransactionVO, baseTransactionVO, returnedTransactionVO;
            String factoryClass, subClass, key, value, sOldContext, code;
            Iterator i,ICPCItems;
            TransactionVO baseTransactionVO2;
            Vector newItems;
            ItemVO item, oldItem;
            Enumeration enumeration;
            ItemContextVO itemContextVO;
            Hashtable ICD10Codes, ICPCCodes, DSM4Codes;

            while (iterator.hasNext()) {
                df = new DummyTransactionFactory();
                newTransactionVO = (TransactionVO) iterator.next();
                factoryClass = null;
                subClass = null;

                if (sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_GENERAL_CLINICAL_EXAMINATION)){
                    factoryClass = "be.mxs.common.model.vo.healthrecord.util.TransactionFactoryClinicalExamination";
                    subClass = request.getParameter("subClass");
                }

                if (sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_VACCINATION)){
                    sessionContainerWO.setPersonalVaccinationsInfoVO(null);
                }

                if (sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_OPHTALMOLOGY)){
                    factoryClass = "be.mxs.common.model.vo.healthrecord.util.TransactionFactoryOphtalmologyExaminationWithStereoscopy";
                    subClass = request.getParameter("subClass");
                }

                if (sessionContainerWO.getCurrentTransactionVO().getTransactionType().equals(be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2)){
                    subClass = request.getParameter("subClass");
                }

                if (factoryClass != null){
                    try{
                        //baseTransactionVO2=null;
                        if (factoryClass.equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.util.TransactionFactoryClinicalExamination")){
                            baseTransactionVO = TransactionFactory.createTransactionFactory(factoryClass).createTransactionVO(subClass);
                            baseTransactionVO2 = new TransactionFactoryGeneral().createTransactionVO(sessionContainerWO.getUserVO(),sessionContainerWO.getCurrentTransactionVO().getTransactionType(),false);
                        }
                        else {
                            baseTransactionVO = TransactionFactory.createTransactionFactory(factoryClass).createTransactionVO(subClass);
                            baseTransactionVO2 = TransactionFactory.createTransactionFactory(factoryClass).createTransactionVO((String)null);
                        }

                        i = baseTransactionVO.getItems().iterator();
                        while (i.hasNext()){
                            ((ItemVO)i.next()).setValue(null);
                        }

                        i = baseTransactionVO2.getItems().iterator();
                        while (i.hasNext()){
                            ((ItemVO)i.next()).setValue(null);
                        }

                        baseTransactionVO.setCreationDate(sessionContainerWO.getCurrentTransactionVO().getCreationDate());
                        baseTransactionVO.setStatus(sessionContainerWO.getCurrentTransactionVO().getStatus());
                        baseTransactionVO.setTransactionId(sessionContainerWO.getCurrentTransactionVO().getTransactionId());
                        baseTransactionVO.setServerId(sessionContainerWO.getCurrentTransactionVO().getServerId());
                        baseTransactionVO.setTransactionType(sessionContainerWO.getCurrentTransactionVO().getTransactionType());
                        baseTransactionVO.setUpdateTime(sessionContainerWO.getCurrentTransactionVO().getUpdateTime());
                        baseTransactionVO.setUser(sessionContainerWO.getCurrentTransactionVO().getUser());
                        baseTransactionVO.setVersion(sessionContainerWO.getCurrentTransactionVO().getVersion());

                        baseTransactionVO2.setCreationDate(sessionContainerWO.getCurrentTransactionVO().getCreationDate());
                        baseTransactionVO2.setStatus(sessionContainerWO.getCurrentTransactionVO().getStatus());
                        baseTransactionVO2.setTransactionId(sessionContainerWO.getCurrentTransactionVO().getTransactionId());
                        baseTransactionVO2.setServerId(sessionContainerWO.getCurrentTransactionVO().getServerId());
                        baseTransactionVO2.setTransactionType(sessionContainerWO.getCurrentTransactionVO().getTransactionType());
                        baseTransactionVO2.setUpdateTime(sessionContainerWO.getCurrentTransactionVO().getUpdateTime());
                        baseTransactionVO2.setUser(sessionContainerWO.getCurrentTransactionVO().getUser());
                        baseTransactionVO2.setVersion(sessionContainerWO.getCurrentTransactionVO().getVersion());

                        df.populateTransaction(baseTransactionVO,newTransactionVO);
                        df.populateTransaction(oldTransaction,baseTransactionVO);
                        df.populateTransactionPreserve(oldTransaction,baseTransactionVO2);

                        newTransactionVO = oldTransaction;
                    }
                    catch (Exception e){
                        e.printStackTrace();
                    }
                }
                else {
                	if(newTransactionVO.getTransactionId()<0 
            			&& new SimpleDateFormat("HH:mm").format(newTransactionVO.getUpdateTime()).equalsIgnoreCase("00:00")
            			&& new SimpleDateFormat("dd/MM/yyyy").format(newTransactionVO.getUpdateTime()).equalsIgnoreCase(new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()))
            			) {
                		newTransactionVO.setUpdateTime(newTransactionVO.getCreationDate());
                	}
                }


                if (request.getParameter("be.mxs.healthrecord.updateTransaction.preserve")==null){
                    df.populateTransaction(oldTransaction,newTransactionVO);
                }
                else {
                    df.populateTransactionPreserve(oldTransaction,newTransactionVO);
                }

                if (request.getParameter("be.mxs.healthrecord.updateTransaction.actionForwardKey").indexOf("be.mxs.healthrecord.transaction_id=currentTransaction")<=0){
                	df.cleanTransaction(oldTransaction);
                    // Alle oude ICPCCodes en ICD10Codes en DSM4Codes wissen
                    newItems = new Vector();
                    ICPCItems = oldTransaction.getItems().iterator();

                    while (ICPCItems.hasNext()){
                        item = (ItemVO)ICPCItems.next();
                        if (item.getType().indexOf("ICPCCode")==-1 && item.getType().indexOf("ICD10Code")==-1 && item.getType().indexOf("DSM4Code")==-1){
                            newItems.add(item);
                        }
                    }
                    oldTransaction.setItems(newItems);

                    // ICPCCodes toevoegen
                    ICPCCodes = RequestParameterParser.getInstance().parseRequestParameters(request, "ICPCCode");
                    enumeration=ICPCCodes.keys();
                    itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
                    while (enumeration.hasMoreElements()){
                        code=(String)enumeration.nextElement();
                        if (code.indexOf("ICPCCode")==0 || code.indexOf("GravityICPCCode")==0 || code.indexOf("CertaintyICPCCode")==0 || code.indexOf("POAICPCCode")==0 || code.indexOf("NCICPCCode")==0 || code.indexOf("ServiceICPCCode")==0 || code.indexOf("FlagsICPCCode")==0){
                            oldTransaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), code,(String)ICPCCodes.get(code),new Date(),itemContextVO));
                        }
                    }
                    // DSM4Codes toevoegen
                    DSM4Codes = RequestParameterParser.getInstance().parseRequestParameters(request, "DSM4Code");
                    enumeration=DSM4Codes.keys();
                    itemContextVO = new ItemContextVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", "");
                    while (enumeration.hasMoreElements()){
                        code=(String)enumeration.nextElement();
                        if (code.indexOf("DSM4Code")==0 || code.indexOf("GravityDSM4Code")==0 || code.indexOf("CertaintyDSM4Code")==0 || code.indexOf("POADSM4Code")==0 || code.indexOf("NCDSM4Code")==0 || code.indexOf("ServiceDSM4Code")==0 || code.indexOf("FlagsDSM4Code")==0){
                            oldTransaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), code,(String)DSM4Codes.get(code),new Date(),itemContextVO));
                        }
                    }
                    // ICD10Codes toevoegen
                    ICD10Codes = RequestParameterParser.getInstance().parseRequestParameters(request, "ICD10Code");
                    enumeration=ICD10Codes.keys();
                    while (enumeration.hasMoreElements()){
                        code=(String)enumeration.nextElement();
                        if (code.indexOf("ICD10Code")==0 || code.indexOf("GravityICD10Code")==0 || code.indexOf("CertaintyICD10Code")==0 || code.indexOf("POAICD10Code")==0 || code.indexOf("NCICD10Code")==0 || code.indexOf("ServiceICD10Code")==0 || code.indexOf("FlagsICD10Code")==0){
                            oldTransaction.getItems().add(new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier()), code,(String)ICD10Codes.get(code),new Date(),itemContextVO));
                        }
                    }
                    TransactionVO previousTransaction=null;
                    if (oldTransaction.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY")){
                    	previousTransaction = MedwanQuery.getInstance().loadTransaction(oldTransaction.getServerId(), oldTransaction.getTransactionId().intValue());
                    }

                    String privatetransaction = ScreenHelper.checkString(request.getParameter("privatetransaction"));
                    ItemVO privateItem=oldTransaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PRIVATETRANSACTION");
                    if(privateItem==null){
                        privateItem = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
                        , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PRIVATETRANSACTION"
                        ,sessionContainerWO.getPersonVO().personId.intValue()+""
                        ,new Date()
                        ,new ItemContextVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()), "", ""));
                    	oldTransaction.getItems().add(privateItem);
                    }
                    privateItem.setValue(privatetransaction);
                    
                    //Voor een nieuwe lab aanvraag, controleer of er een bericht moet worden gestuurd
                    boolean bNewLabrequest=oldTransaction.getTransactionType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST") && oldTransaction.getTransactionId()<0;
                    //Sla de transactie op
                    returnedTransactionVO = MedwanQuery.getInstance().updateTransaction(sessionContainerWO.getPersonVO().personId.intValue(),oldTransaction);
                    if(bNewLabrequest) {
                    	if(oldTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS").length()>0 && SH.cs("labsmsnotification", "").length()>0) {
                    		String sMessage=SH.cs("labsmsnotification", "").replaceAll("#date#",SH.formatDate(returnedTransactionVO.getUpdateTime())).replaceAll("#transactionid#", returnedTransactionVO.getTransactionId()+"").replaceAll("<br>", "\n").replace("#patient#", sessionContainerWO.getPersonVO().lastname.toUpperCase()+" "+sessionContainerWO.getPersonVO().firstname);
                    		LabresultsNotifier.SpoolMessage(returnedTransactionVO.getTransactionId(), "sms", sMessage, oldTransaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS"));
                    	}
                    }
                    if(returnedTransactionVO.getVersion()>1){
                    	Pointer.storePointer("TU."+returnedTransactionVO.getServerId()+"."+returnedTransactionVO.getTransactionId()+"."+returnedTransactionVO.getVersion(),sessionContainerWO.getUserVO().userId+"");
                    }
                    if (MedwanQuery.getInstance().getConfigInt("automatedDebet",0)==1){
                        ItemVO ctxt=returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT");
                        try{
                        	Prestation.registerPrestationsAsDebetTransactions("TRAN."+returnedTransactionVO.getTransactionType()+"."+(ctxt!=null?ctxt.getValue():""),null,returnedTransactionVO.getUpdateTime(),null,new ObjectReference("Person",returnedTransactionVO.getUser().getPersonVO().getPersonId()+""),new ObjectReference("Transaction",returnedTransactionVO.getObjectUid()),returnedTransactionVO.getUser().getUserId()+"",sessionContainerWO.getPersonVO().getPersonId()+"");
                        }
                        catch(Exception a){}
                    }
                    if (MedwanQuery.getInstance().getConfigInt("exportEnabled")==1){
                        request.getSession().setAttribute("exportActivityCheck","");
                        if (request.getSession().getAttribute("nightShift")!=null && ((String)request.getSession().getAttribute("nightShift")).length()>0){
                            MedwanQuery.getInstance().exportTransaction(sessionContainerWO.getPersonVO().personId.intValue(),returnedTransactionVO,sessionContainerWO.getUserVO().getUserId().toString(),true,(String)request.getSession().getAttribute("activeMedicalCenter"),(String)request.getSession().getAttribute("activeMD"),(String)request.getSession().getAttribute("activePara"));
                        }
                        else {
                            MedwanQuery.getInstance().exportTransaction(sessionContainerWO.getPersonVO().personId.intValue(),returnedTransactionVO,sessionContainerWO.getUserVO().getUserId().toString(),false,(String)request.getSession().getAttribute("activeMedicalCenter"),(String)request.getSession().getAttribute("activeMD"),(String)request.getSession().getAttribute("activePara"));
                        }
                    }
// bij geboorte, kind aanmaken + transactie registreren
                    if (returnedTransactionVO.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_DELIVERY")){
                        ItemVO previousLastName=null;
                        if(previousTransaction!=null){
                        	previousLastName=previousTransaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME");
                        }
                    	if (previousLastName==null || ScreenHelper.checkString(previousLastName.getValue()).length()==0){
                            ItemVO itemChildLastname = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_LASTNAME");
                            if ((itemChildLastname!=null)&&(ScreenHelper.checkString(itemChildLastname.getValue()).length()>0)){
                                ItemVO itemChildFirstname = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_FIRSTNAME");
                                ItemVO itemChildDOB = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_CHILD_DOB");
                                ItemVO itemChildGender = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_GENDER");

                                AdminPerson personChild = new AdminPerson();

                                if ((itemChildGender!=null)&&(ScreenHelper.checkString(itemChildGender.getValue()).length()>0)){
                                    if (itemChildGender.getValue().equalsIgnoreCase("male")){
                                        personChild.gender = "M";
                                    }
                                    else if (itemChildGender.getValue().equalsIgnoreCase("female")){
                                        personChild.gender = "F";
                                    }
                                }

                                personChild.lastname = itemChildLastname.getValue();
                                personChild.firstname = ScreenHelper.checkString(itemChildFirstname.getValue());
                                personChild.dateOfBirth = ScreenHelper.checkString(itemChildDOB.getValue());
                                personChild.sourceid = MedwanQuery.getInstance().getConfigString("PatientEditSourceID");
                                personChild.updateuserid = returnedTransactionVO.getUser().getUserId().intValue()+"";
                            	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                                personChild.saveToDB(ad_conn);
                                try {
									ad_conn.close();
								} catch (SQLException e) {
									e.printStackTrace();
								}

                                if (ScreenHelper.checkString(personChild.personid).length()>0){
                                    Vector vChildItems = new Vector();

                                    ItemVO itemChildPersonId = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
                                            , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PERSONID"
                                            ,sessionContainerWO.getPersonVO().personId.intValue()+""
                                            ,new Date()
                                            ,itemChildFirstname.getItemContext());
                                    vChildItems.add(itemChildPersonId);

                                    ItemVO itemChildTransactionId = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
                                            , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TRANSACTIONID"
                                            ,returnedTransactionVO.getTransactionId().intValue()+""
                                            ,new Date()
                                            ,itemChildFirstname.getItemContext());
                                    vChildItems.add(itemChildTransactionId);

                                    ItemVO itemChildServerId = new ItemVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
                                            , "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SERVERID"
                                            ,returnedTransactionVO.getServerId()+""
                                            ,new Date()
                                            ,itemChildFirstname.getItemContext());
                                    vChildItems.add(itemChildServerId);

                                    TransactionVO transactionDelivery = new TransactionVO(new Integer( IdentifierFactory.getInstance().getTemporaryNewIdentifier())
                                            ,"be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PEDIATRY_DELIVERY"
                                            ,new Date()
                                            ,new Date()
                                            ,IConstants.TRANSACTION_STATUS_CLOSED, sessionContainerWO.getCurrentTransactionVO().getUser()
                                            ,vChildItems
                                            ,sessionContainerWO.getCurrentTransactionVO().getServerId()
                                            ,sessionContainerWO.getCurrentTransactionVO().getVersion()
                                            ,sessionContainerWO.getCurrentTransactionVO().getVersionserverId()
                                            ,sessionContainerWO.getCurrentTransactionVO().getTimestamp());

                                    MedwanQuery.getInstance().updateTransaction(Integer.parseInt(personChild.personid),transactionDelivery);

                                }
                            }
                        }
                    }
                    else if(returnedTransactionVO.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_MIR2")){
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_TYPE");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                            if(MedwanQuery.getInstance().getConfigInt("enableAutomaticImagingInvoicing",0)==1){
                            	String performerUid = returnedTransactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MIR2_INTERNALPRESCRIBER");
                            	if(performerUid.length()==0) {
                            		Debet.createAutomaticDebetByAlias("MIRPREST."+returnedTransactionVO.getTransactionId(), sessionContainerWO.getPersonVO().personId+"", "mir_type."+item.getValue(), sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticImagingInvoicingDelayInHours",24)*3600*1000);
                            	}
                            	else {
                            		Debet.createAutomaticDebetByAlias("MIRPREST."+returnedTransactionVO.getTransactionId(), sessionContainerWO.getPersonVO().personId+"", "mir_type."+item.getValue(), sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticImagingInvoicingDelayInHours",24)*3600*1000, performerUid);
                            	}
                            }
                    	}
                    }
                    else if(returnedTransactionVO.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_OPERATION_PROTOCOL")){
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT1");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                            if(MedwanQuery.getInstance().getConfigInt("enableAutomaticSurgeryInvoicing",0)==1){
                            	Debet.createAutomaticDebetByAlias("SURGERYPREST."+returnedTransactionVO.getTransactionId(), sessionContainerWO.getPersonVO().personId+"", "surgicalacts."+item.getValue(), sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticSurgeryInvoicingDelayInHours",24)*3600*1000);
                            }
                    	}
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT2");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                            if(MedwanQuery.getInstance().getConfigInt("enableAutomaticSurgeryInvoicing",0)==1){
                            	Debet.createAutomaticDebetByAlias("SURGERYPREST."+returnedTransactionVO.getTransactionId(), sessionContainerWO.getPersonVO().personId+"", "surgicalacts."+item.getValue(), sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticSurgeryInvoicingDelayInHours",24)*3600*1000);
                            }
                    	}
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPERATION_PROTOCOL_SURGICAL_ACT3");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                            if(MedwanQuery.getInstance().getConfigInt("enableAutomaticSurgeryInvoicing",0)==1){
                            	Debet.createAutomaticDebetByAlias("SURGERYPREST."+returnedTransactionVO.getTransactionId(), sessionContainerWO.getPersonVO().personId+"", "surgicalacts."+item.getValue(), sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticSurgeryInvoicingDelayInHours",24)*3600*1000);
                            }
                    	}
                    }
                    else if(returnedTransactionVO.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PATIENTCREDITREQUEST")){
                        try{
                            String sMailTo = MedwanQuery.getInstance().getConfigString("patientCreditRequestMailAddress","");
                            AdminPerson patient = (AdminPerson)(request.getSession().getAttribute("activePatient"));
                        	Encounter encounter = Encounter.getActiveEncounterOnDate(new Timestamp(returnedTransactionVO.getUpdateTime().getTime()),patient.personid);
                        	if(encounter!=null && encounter.getLastEncounterService()!=null){
                        		Service service = Service.getService(encounter.getLastEncounterService().serviceUID);
                        		while(service !=null){
                        			if(service.contactemail!=null && service.contactemail.length()>0){
                        				sMailTo=service.contactemail;
                        				break;
                        			}
                        			else if(service.parentcode!=null && service.parentcode.length()>0){
                        				service=Service.getService(service.parentcode);
                        			}
                        		}
                        	}
                            if(sMailTo.length()>0){
	                            String sMailMessage = MedwanQuery.getInstance().getConfigString("patientCreditRequestMessage","");
	                            sMailMessage = sMailMessage.replaceAll("#PatientName#", patient.getFullName());
	                            sMailMessage = sMailMessage.replaceAll("#PatientID#", patient.personid);
	                            if (sMailMessage.length()>0){
                                    String sMailFrom = MedwanQuery.getInstance().getConfigString("patientCreditRequestFromMailAddress","");
                                    if (sMailFrom.length()==0){
                                        sMailFrom = MedwanQuery.getInstance().getConfigString("DefaultFromMailAddress");
                                    }

                                    String sMailSubject = MedwanQuery.getInstance().getConfigString("patientCreditRequestSubject","Patient Credit Request for "+patient.getFullName());
                                    // send messages
                                    String sMailServer = MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer");
                                    Mail.sendMail(sMailServer,sMailFrom,sMailTo,sMailSubject,sMailMessage,null,null);
	                            }
                            }
                        }
                        catch (Exception e){
                            Debug.println(e.getMessage());
                        }
                    }
                    else if(returnedTransactionVO.getTransactionType().equals("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST")){
                    	//Bewaar SMS en e-mail in user profiel
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_SMS");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                    		UserParameter.saveUserParameter("lastLabSMS", item.getValue(), returnedTransactionVO.getUser().userId);
                    	}
                    	item = returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_EMAIL");
                    	if(item!=null && ScreenHelper.checkString(item.getValue()).length()>0){
                    		UserParameter.saveUserParameter("lastLabEmail", item.getValue(), returnedTransactionVO.getUser().userId);
                    	}
                    	if(MedwanQuery.getInstance().getConfigInt("enableHL7",0)==1){
                    		try {
								HL7Server.storeTransaction(returnedTransactionVO);
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
                    	}
                    }
                    //If AUTOINVOICE items exist in the transaction, then automatically invoice the items
                    Collection invoiceItems = returnedTransactionVO.getItems();
                    Iterator iInvoiceItems = invoiceItems.iterator();
                    while(iInvoiceItems.hasNext()){
                    	ItemVO itemVO = (ItemVO)iInvoiceItems.next();
                    	if(itemVO.getType().contains("AUTOINVOICE")){
                    		Debug.println("AUTOINVOICE item detected: "+itemVO.getType());
                    		String sPrestationData = itemVO.getValue();
                    		int quantity=1;
                    		if(sPrestationData.split("\\.").length>1){
                    			quantity=Integer.parseInt(sPrestationData.split("\\.")[1]);
                    			sPrestationData=sPrestationData.split("\\.")[0];
                    		}
                    		Debug.println("AUTOINVOICING "+quantity+" x "+sPrestationData);
                    		//First find out if a Debet has not been generated by this transaction yet
                    		String existingDebetUid=ScreenHelper.checkString(Pointer.getPointer(returnedTransactionVO.getTransactionId()+";"+itemVO.getType()));
                    		if(existingDebetUid.length()==0 || Debet.get(existingDebetUid)==null || Debet.get(existingDebetUid).getCredited()==0){
                        		Debug.println("AUTOINVOICING step 1");
                    			Debet.createAutomaticDebetByAlias(returnedTransactionVO.getTransactionId()+";"+itemVO.getType(), sessionContainerWO.getPersonVO().personId+"", sPrestationData, sessionContainerWO.getUserVO().userId+"",MedwanQuery.getInstance().getConfigInt("automaticGenericInvoicingDelayInHours",24)*3600*1000,quantity);
                    		}
                    	}
                    }
                    //If DRAWING items exist in the transaction, store their content in OC_DRAWINGS
                    invoiceItems = returnedTransactionVO.getItems();
                    iInvoiceItems = invoiceItems.iterator();
                    while(iInvoiceItems.hasNext()){
                    	ItemVO itemVO = (ItemVO)iInvoiceItems.next();
                    	Debug.println("Checking item: "+itemVO.getType());
                    	if(itemVO.getType().contains("OCDRAWING")){
                    		Debug.println("OCDRAWING item detected: "+itemVO.getType());
                    		//The name of the field that contains the drawing is in the value
                    		String drawingitemname = itemVO.getValue();
                    		if(request.getParameter(drawingitemname)!=null){
                    			String inlineImage = request.getParameter(drawingitemname);
                    			try{
                    				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
                    				PreparedStatement ps = conn.prepareStatement("delete from OC_DRAWINGS where OC_DRAWING_SERVERID=? and OC_DRAWING_TRANSACTIONID=? and OC_DRAWING_ITEMTYPE=?");
                    				ps.setInt(1, returnedTransactionVO.getServerId());
                    				ps.setInt(2, returnedTransactionVO.getTransactionId());
                    				ps.setString(3, itemVO.getType());
                    				ps.execute();
                    				ps.close();
                    				ps = conn.prepareStatement("insert into OC_DRAWINGS(OC_DRAWING_SERVERID,OC_DRAWING_TRANSACTIONID,OC_DRAWING_ITEMTYPE,OC_DRAWING_DRAWING) values(?,?,?,?)");
                    				ps.setInt(1, returnedTransactionVO.getServerId());
                    				ps.setInt(2, returnedTransactionVO.getTransactionId());
                    				ps.setString(3, itemVO.getType());
                    				ps.setBytes(4, ScreenHelper.base64Compress(inlineImage));
                    				ps.execute();
                    				ps.close();
                    				conn.close();
                    			}
                    			catch(Exception o){
                    				o.printStackTrace();
                    			}
                    		}
                    	}
                    }
                    
                    //If IKIREZI linked items exist in the transaction, store their content in Ikirezi
                    invoiceItems = returnedTransactionVO.getItems();
                    iInvoiceItems = invoiceItems.iterator();
                    String encounteruid=returnedTransactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID");
                    if(encounteruid.length()>0){
	                    while(iInvoiceItems.hasNext()){
	                    	ItemVO itemVO = (ItemVO)iInvoiceItems.next();
	                    	if( itemVO.getType().contains("ITEM_TYPE_GENERALSIGNS_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_FUNCTIONALSIGNS_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_FUNCTIONALSIGNS_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_INSPECTION_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_PALPATION_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_PERCUSSION_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_TRTV_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_HEARTAUSCULTATION_IDS")||
	                    		itemVO.getType().contains("ITEM_TYPE_LUNGAUSCULTATION_IDS")){
	                    		String[] inspectionids = ScreenHelper.checkString(itemVO.getValue()).split(";");
	                    		for(int n=0;n<inspectionids.length;n++){
	                    			if(inspectionids[n].split("\\$").length>1){
		                    			String id = inspectionids[n].split("\\$")[1];
		                    			if(id.split("\\.").length>1){
		                    				String ikireziId=id.split("\\.")[1];
		                    				Ikirezi.storeSymptom(encounteruid, ikireziId, "1",sessionContainerWO.getUserVO().userId);
		                    			}
	                    			}
	                    		}
	                    	}
	                    }
                    }

                    //Delete diagnoses from OC_DIAGNOSES and ADD all+new again
                    Diagnosis.deleteDiagnosesByReferenceUID(returnedTransactionVO.getServerId()+"."+returnedTransactionVO.getTransactionId(),"Transaction");
                    ItemVO encounterItem=returnedTransactionVO.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID");
                    if(encounterItem!=null){
                    	Encounter encounter = Encounter.get(encounterItem.getValue());
                    	if(encounter!=null){
                    		saveDiagnosesToTable(RequestParameterParser.getInstance().parseRequestParameters(request, "ICPCCode"),RequestParameterParser.getInstance().parseRequestParameters(request, "ICD10Code"),RequestParameterParser.getInstance().parseRequestParameters(request, "DSM4Code"),returnedTransactionVO.getUpdateTime(),returnedTransactionVO.getServerId()+"."+returnedTransactionVO.getTransactionId(),sessionContainerWO,encounter);
                    	}
                    }

                    if(returnedTransactionVO.getTransactionType().equals(ScreenHelper.ITEM_PREFIX+"TRANSACTION_TYPE_ARCHIVE_DOCUMENT")){
                        boolean isNewTran = (sessionContainerWO.getCurrentTransactionVO().getTransactionId() < 0);
                        
                    	//*** duplicate data in an ArchiveDocument-record ***
                    	ArchiveDocument archDoc = ArchiveDocument.save(isNewTran,returnedTransactionVO,sessionContainerWO.getUserVO());
                    	// returned object contains only UID and UDI !
                    	
                    	if(isNewTran){
                        	// register UID in transaction = link to document
                        	returnedTransactionVO.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
                                                                 ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UID",
                                                                 archDoc.getUid(),new Date(),null));
                        	
	                    	// register udi in transaction
	                    	returnedTransactionVO.getItems().add(new ItemVO(new Integer(IdentifierFactory.getInstance().getTemporaryNewIdentifier()),
	                                                             ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UDI",
	                                                             archDoc.udi,new Date(),null));
                    	}
                    	
                        MedwanQuery.getInstance().updateTransaction(sessionContainerWO.getPersonVO().personId,returnedTransactionVO);
                    }

                    sessionContainerWO.setCurrentTransactionVO(returnedTransactionVO);
                    requestParameters = RequestParameterParser.getInstance().parseRequestParameters(request, "inactiveDiagnosis");
                    enumeration = requestParameters.keys();

                    while (enumeration.hasMoreElements()) {
                        key = (String) enumeration.nextElement();
                        value = (String)requestParameters.get(key);
                        if (value.equalsIgnoreCase("medwan.common.true")){
                            key = key.replaceAll("inactiveDiagnosis.","");
                            MedwanQuery.getInstance().inactivateDiagnosis(sessionContainerWO.getPersonVO().personId.intValue(),key,sessionContainerWO.getCurrentTransactionVO().getUpdateTime());
                        }
                    }

                    //Bewaar de actieve diagnoses
                    MedwanQuery.getInstance().activateDiagnosis(sessionContainerWO.getPersonVO().personId.intValue(),sessionContainerWO.getCurrentTransactionVO().getTransactionId().intValue(),sessionContainerWO.getCurrentTransactionVO().getServerId(),sessionContainerWO.getCurrentTransactionVO().getUpdateTime());
                }
                else {
                    sessionContainerWO.setCurrentTransactionVO(oldTransaction);
                }

                oldItem = oldTransaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT");
                if (oldItem!=null){
                    sOldContext = ScreenHelper.checkString(oldItem.getValue());
                    sessionContainerWO.getFlags().setContext(sOldContext);
                }
            }

            // action forward
            actionForwardKey = request.getParameter("be.mxs.healthrecord.updateTransaction.actionForwardKey");
            if (actionForwardKey==null){
                actionForwardKey = "";
            }

            // add ts if not present
            if (actionForwardKey.indexOf("ts=")<0){
                actionForwardKey+= (request.getParameter("be.mxs.healthrecord.updateTransaction.actionForwardKey").indexOf("?")>-1?"&":"?")+"ts=" + new java.util.Date().hashCode();
            }

            //update exitmessage if it exists
            String exitmessage = request.getParameter("exitmessage");
            if(exitmessage!=null){
                actionForwardKey+="&exitmessage="+request.getParameter("exitmessage")+"."+sessionContainerWO.getCurrentTransactionVO().getServerId()+"."+sessionContainerWO.getCurrentTransactionVO().getTransactionId();
            }
            if (actionForwardKey != null) {
                if (actionForwardKey.indexOf("ForwardUpdateTransactionId")>-1){
                    returnedTransactionVO = sessionContainerWO.getCurrentTransactionVO();
                    actionForwardKey+= "&be.mxs.healthrecord.createTransaction.transactionType="+returnedTransactionVO.getTransactionType()+"&be.mxs.healthrecord.transaction_id="+returnedTransactionVO.getTransactionId()+"&be.mxs.healthrecord.server_id="+returnedTransactionVO.getServerId();
                }
                actionForward = new ActionForward(actionForwardKey, true);
            }
            sessionContainerWO.getHealthRecordVO().setUpdated(true);
            // INSERT ACCESS LOG
            if(bIsNewTrans){
            	AccessLog.insert(sessionContainerWO.getCurrentTransactionVO().getUser().getUserId()+"","T."+sessionContainerWO.getCurrentTransactionVO().getServerId()+"."+sessionContainerWO.getCurrentTransactionVO().getTransactionId().intValue());
            }
        }
        catch (SessionContainerFactoryException e) {
            try {
                e.printStackTrace();

                StringWriter writer = new StringWriter();
                e.printStackTrace(new PrintWriter(writer));

                sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
                sessionContainerWO.resetErrorMessage();
                sessionContainerWO.addErrorMessage("Exception in " + this.getClass().getName() + "\nCause: \n" + e.getCause().getMessage() + "\nMessage: \n" + e.getMessage());
                sessionContainerWO.addErrorMessage(""+writer.getBuffer());

            }
            catch (SessionContainerFactoryException e1) {
                e1.printStackTrace();
            }

            actionForward = mapping.findForward( "failure" );
        }
        catch (ValueObjectHelperException e) {
            try {
                e.printStackTrace();

                StringWriter writer = new StringWriter();
                e.printStackTrace(new PrintWriter(writer));

                sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
                sessionContainerWO.resetErrorMessage();
                sessionContainerWO.addErrorMessage(""+writer.getBuffer());

            }
            catch (SessionContainerFactoryException e1) {
                e1.printStackTrace();
            }
            actionForward = mapping.findForward("failure");
        }

        return actionForward;
    }

    public static void saveDiagnosesToTable(Hashtable ICPCCodes,Hashtable ICD10Codes,Hashtable DSM4Codes,java.util.Date updatetime, String sTransactionUID,SessionContainerWO sessionContainerWO,Encounter encounter){

        Enumeration enumeration;
        String code;
        enumeration=ICPCCodes.keys();
        while (enumeration.hasMoreElements()){
            code=(String)enumeration.nextElement();
            if (code.indexOf("ICPCCode")==0){
                if(ScreenHelper.checkString((String)ICPCCodes.get("Gravity"+code)).length() > 0 && ScreenHelper.checkString((String)ICPCCodes.get("Certainty"+code)).length() > 0){
                    Diagnosis.saveTransactionDiagnosisWithServiceAndFlags(code,
                                                      ScreenHelper.checkString((String)ICPCCodes.get(code)),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("Gravity"+code)),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("Certainty"+code)),
                                                      sessionContainerWO.getPersonVO().personId.toString(),
                                                      "ICPCCode",
                                                      "icpc",
                                                      new java.sql.Timestamp(updatetime.getTime()),
                                                      sTransactionUID,
                                                      sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("User"+code)).length() > 0? Integer.parseInt(ScreenHelper.checkString((String)ICPCCodes.get("User"+code))):sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      encounter,
                                                      ScreenHelper.checkString((String)ICPCCodes.get("POA"+code)),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("NC"+code)),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("Service"+code)),
                                                      ScreenHelper.checkString((String)ICPCCodes.get("Flags"+code))
                    );
                }
            }
        }
        enumeration=DSM4Codes.keys();
        while (enumeration.hasMoreElements()){
            code=(String)enumeration.nextElement();
            if (code.indexOf("DSM4Code")==0){
                if(ScreenHelper.checkString((String)DSM4Codes.get("Gravity"+code)).length() > 0 && ScreenHelper.checkString((String)DSM4Codes.get("Certainty"+code)).length() > 0){
                    Diagnosis.saveTransactionDiagnosisWithServiceAndFlags(code,
                                                      ScreenHelper.checkString((String)DSM4Codes.get(code)),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("Gravity"+code)),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("Certainty"+code)),
                                                      sessionContainerWO.getPersonVO().personId.toString(),
                                                      "DSM4Code",
                                                      "dsm4",
                                                      new java.sql.Timestamp(updatetime.getTime()),
                                                      sTransactionUID,
                                                      sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("User"+code)).length() > 0? Integer.parseInt(ScreenHelper.checkString((String)DSM4Codes.get("User"+code))):sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      encounter,
                                                      ScreenHelper.checkString((String)DSM4Codes.get("POA"+code)),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("NC"+code)),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("Service"+code)),
                                                      ScreenHelper.checkString((String)DSM4Codes.get("Flags"+code))
                    );
                }
            }
        }
        // ICD10Codes toevoegen
        enumeration=ICD10Codes.keys();

        while (enumeration.hasMoreElements()){
            code=(String)enumeration.nextElement();
            if (code.indexOf("ICD10Code")==0){
                if(ScreenHelper.checkString((String)ICD10Codes.get("Gravity"+code)).length() > 0 && ScreenHelper.checkString((String)ICD10Codes.get("Certainty"+code)).length() > 0){
                    Diagnosis.saveTransactionDiagnosisWithServiceAndFlags(code,
                                                      ScreenHelper.checkString((String)ICD10Codes.get(code)),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("Gravity"+code)),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("Certainty"+code)),
                                                      sessionContainerWO.getPersonVO().personId.toString(),
                                                      "ICD10Code",
                                                      "icd10",
                                                      new java.sql.Timestamp(updatetime.getTime()),
                                                      sTransactionUID,
                                                      sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("User"+code)).length() > 0? Integer.parseInt(ScreenHelper.checkString((String)ICD10Codes.get("User"+code))):sessionContainerWO.getUserVO().getUserId().intValue(),
                                                      encounter,
                                                      ScreenHelper.checkString((String)ICD10Codes.get("POA"+code)),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("NC"+code)),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("Service"+code)),
                                                      ScreenHelper.checkString((String)ICD10Codes.get("Flags"+code))

                    );
                }
            }
        }
    }
}