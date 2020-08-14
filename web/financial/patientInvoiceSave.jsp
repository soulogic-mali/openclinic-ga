<%@ page import="be.mxs.common.util.system.*,be.openclinic.finance.*,java.util.*
,be.openclinic.adt.Encounter,java.math.BigDecimal" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%

try{
    String sEditDate = checkString(request.getParameter("EditDate"));
    String sEditDeliveryDate = checkString(request.getParameter("EditDeliveryDate"));
    String sEditPatientInvoiceUID = checkString(request.getParameter("EditPatientInvoiceUID"));
    String sEditInvoiceUID = checkString(request.getParameter("EditInvoiceUID"));
    String sEditStatus = checkString(request.getParameter("EditStatus"));
    String sEditBalance = checkString(request.getParameter("EditBalance"));
    String sEditCBs = checkString(request.getParameter("EditCBs"));
    String sEditInvoiceSeries = checkString(request.getParameter("EditInvoiceSeries"));
    String sEditInsurarReference = checkString(request.getParameter("EditInsurarReference"));
    String sEditInvoiceVerifier = checkString(request.getParameter("EditInvoiceVerifier"));
    String sEditInsurarReferenceDate = checkString(request.getParameter("EditInsurarReferenceDate"));
    String sEditReduction = checkString(request.getParameter("EditReduction"));
    String sEditComment = checkString(request.getParameter("EditComment"));
    String sEditLinkedService = checkString(request.getParameter("EditLinkedService"));
    String acceptationuid = checkString(request.getParameter("EditAcceptationUid"));
    String sEditInvoiceDoctor=checkString(request.getParameter("EditInvoiceDoctor"));
    String sEditInvoicePost=checkString(request.getParameter("EditInvoicePost"));
    String sEditInvoiceAgent=checkString(request.getParameter("EditInvoiceAgent"));
    String sEditInvoiceDrugsIdCard=checkString(request.getParameter("EditInvoiceDrugsIdCard"));
    String sEditInvoiceDrugsRecipient=checkString(request.getParameter("EditInvoiceDrugsRecipient"));
    String sEditInvoiceDrugsIdCardPlace=checkString(request.getParameter("EditInvoiceDrugsIdCardPlace"));
    String sEditInvoiceDrugsIdCardDate=checkString(request.getParameter("EditInvoiceDrugsIdCardDate"));
    
    boolean quickInvoice = checkString(request.getParameter("QuickInvoice")).equalsIgnoreCase("true");

    ///// DEBUG /////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n****************** patientInvoiceSave.jsp **************");
        Debug.println("sEditDate            : "+sEditDate);
        Debug.println("sEditDeliveryDate    : "+sEditDeliveryDate);
        Debug.println("sEditPatientInvUID   : "+sEditPatientInvoiceUID);
        Debug.println("sEditInvoiceUID      : "+sEditInvoiceUID);
        Debug.println("sEditStatus          : "+sEditStatus);
        Debug.println("sEditBalance         : "+sEditBalance);
        Debug.println("sEditCBs             : "+sEditCBs);
        Debug.println("sEditInvoiceSeries   : "+sEditInvoiceSeries);
        Debug.println("sEditInsurarRef      : "+sEditInsurarReference);
        Debug.println("sEditInvoiceVerifier : "+sEditInvoiceVerifier);
        Debug.println("sEditInsurarRefDate  : "+sEditInsurarReferenceDate);
        Debug.println("sEditReduction       : "+sEditReduction);
        Debug.println("sEditComment         : "+sEditComment);
        Debug.println("acceptationuid       : "+acceptationuid);
        Debug.println("sEditInvoiceDoctor   : "+sEditInvoiceDoctor);
        Debug.println("sEditInvoicePost     : "+sEditInvoicePost);
        Debug.println("sEditInvoiceAgent    : "+sEditInvoiceAgent);
        Debug.println("sEditInvoiceDrugsIdCard      : "+sEditInvoiceDrugsIdCard);
        Debug.println("sEditInvoiceDrugsRecipient   : "+sEditInvoiceDrugsRecipient);
        Debug.println("sEditInvoiceDrugsIdCardPlace : "+sEditInvoiceDrugsIdCardPlace);
        Debug.println("sEditInvoiceDrugsIdCardDate  : "+sEditInvoiceDrugsIdCardDate);
        Debug.println("quickInvoice         : "+quickInvoice+"\n");
    }
    /////////////////////////////////////////////////////////////////////////////////////

    PatientInvoice patientinvoice = new PatientInvoice();
    AdminPerson invoicePatient=activePatient;
    boolean bUniqueInsurerReferenceRequired=false;
    boolean bUniqueOtherReferenceRequired=false;
    boolean bUniqueDoctorRequired=false;

    if (sEditPatientInvoiceUID.length() > 0) {
        PatientInvoice oldpatientinvoice = PatientInvoice.get(sEditPatientInvoiceUID);
        if(oldpatientinvoice!=null){
            patientinvoice.setCreateDateTime(oldpatientinvoice.getCreateDateTime());
            patientinvoice.setNumber(oldpatientinvoice.getNumber());
            patientinvoice.setAcceptationUid(oldpatientinvoice.getAcceptationUid());
           	patientinvoice.setAcceptationDate(oldpatientinvoice.getAcceptationDate());
            invoicePatient=oldpatientinvoice.getPatient();
        }
    } else {
        patientinvoice.setCreateDateTime(getSQLTime());
        //This is a new invoice. Check if unique reference numbers are really unique
    }
	
	long day = 24*3600*1000;
    if(MedwanQuery.getInstance().getConfigInt("invoiceInsurerReferenceMustBeUnique",0)==1 && sEditInsurarReference.length()>0){
    	String ref = Pointer.getPointerBefore("INV.REF."+sEditInsurarReference,ScreenHelper.parseDate(ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("invoiceInsurerReferenceValidityInDays",1)*day)).substring(0,10)));
    	if(ref.length()>0 && !ref.equalsIgnoreCase(sEditPatientInvoiceUID)){
    		bUniqueInsurerReferenceRequired=true;
    	}
    }
    if(MedwanQuery.getInstance().getConfigInt("invoiceOtherReferenceMustBeUnique",0)==1 && sEditComment.length()>0){
    	String ref = Pointer.getPointerBefore("INV.OTHERREF."+sEditComment,ScreenHelper.parseDate(ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("invoiceOtherReferenceValidityInDays",1)*day)).substring(0,10)));
    	if(ref.length()>0 && !ref.equalsIgnoreCase(sEditPatientInvoiceUID)){
    		bUniqueOtherReferenceRequired=true;
    	}
    }
    if(MedwanQuery.getInstance().getConfigInt("invoiceDoctorMustBeUnique",0)==1 && sEditInvoiceDoctor.length()>0){
    	String ref = Pointer.getPointerBefore("INV.DOCTORREF."+sEditInvoiceDoctor,ScreenHelper.parseDate(ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("invoiceDoctorReferenceValidityInDays",1)*day)).substring(0,10)));
    	if(ref.length()>0 && !ref.equalsIgnoreCase(sEditPatientInvoiceUID)){
    		bUniqueDoctorRequired=true;
    	}
    }

    patientinvoice.setStatus(sEditStatus);
    patientinvoice.setEstimatedDeliveryDate(sEditDeliveryDate);
    patientinvoice.setPatientUid(invoicePatient.personid);
    patientinvoice.setInvoiceUid(sEditInvoiceUID);
    patientinvoice.setDate(ScreenHelper.getSQLDate(sEditDate));
    patientinvoice.setUid(sEditPatientInvoiceUID);
    patientinvoice.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
    patientinvoice.setUpdateUser(activeUser.userid);
    patientinvoice.setInsurarreference(sEditInsurarReference);
    patientinvoice.setInsurarreferenceDate(sEditInsurarReferenceDate);
    patientinvoice.setVerifier(sEditInvoiceVerifier);
    patientinvoice.setComment(sEditComment);
    patientinvoice.setMfpDoctor(sEditInvoiceDoctor);
    patientinvoice.setMfpPost(sEditInvoicePost);
    patientinvoice.setMfpAgent(sEditInvoiceAgent);
    patientinvoice.setMfpDrugReceiver(sEditInvoiceDrugsRecipient);
    patientinvoice.setMfpDrugReceiverId(sEditInvoiceDrugsIdCard);
    patientinvoice.setMfpDrugIdCardDate(sEditInvoiceDrugsIdCardDate);
    patientinvoice.setMfpDrugIdCardPlace(sEditInvoiceDrugsIdCardPlace);
	if(!sEditInvoiceSeries.equalsIgnoreCase("") && checkString(patientinvoice.getNumber()).length()==0){
		patientinvoice.setNumber(sEditInvoiceSeries+"."+MedwanQuery.getInstance().getOpenclinicCounter(sEditInvoiceSeries));
	}
    patientinvoice.setDebets(new Vector());
    patientinvoice.setCredits(new Vector());
    double dTotalCredits = 0;
    double dTotalDebets = 0;
    boolean bReferenceMandatory=false;
    boolean bOtherReferenceMandatory=false;
    
    if (sEditCBs.length() > 0) {
        String[] aCBs = sEditCBs.split(",");
        String sID;
        PatientCredit patientcredit;
        Debet debet;

        for (int i = 0; i < aCBs.length; i++) {
            if (checkString(aCBs[i]).length() > 0) {	
                if (checkString(aCBs[i]).startsWith("cbDebet")) {
                    sID = aCBs[i].substring(7);
                    debet = Debet.get(sID);
                    patientinvoice.getDebets().add(debet);

                    if(sEditStatus.equalsIgnoreCase("canceled")){
                        debet.setAmount(0);
                        debet.setInsurarAmount(0);
                        debet.setCredited(1);
                        debet.store();
                    }

                    if (debet != null) {
                        dTotalDebets += debet.getAmount();
                    }
                } else if (checkString(aCBs[i]).startsWith("cbPatientInvoice")) {
                    sID = aCBs[i].substring(16);
                    patientinvoice.getCredits().add(sID);

                    patientcredit = PatientCredit.get(sID);

                    if (patientcredit != null) {
                        dTotalCredits += patientcredit.getAmount();
                    }
                }
            }
        }
        if(acceptationuid.length()>0){
        	patientinvoice.setAcceptationUid(acceptationuid);
        }
    }
    else{
    	if(quickInvoice){
    		// no checkboxes (cb) specified --> count all open debets    		
    		Vector unassignedDebets = Debet.getUnassignedPatientDebets(activePatient.personid);
    		String sDebetUID; 
    		Debet debet;
	        for(int i=0; i<unassignedDebets.size(); i++){
                sDebetUID = checkString((String)unassignedDebets.get(i));

                if(sDebetUID.length() > 0){
	                debet = Debet.get(sDebetUID);
		
	                if(debet!=null){
		                patientinvoice.getDebets().add(debet);
		                
		                if(sEditStatus.equalsIgnoreCase("canceled")){
		                    debet.setAmount(0);
		                    debet.setInsurarAmount(0);
		                    debet.setCredited(1);
		                    debet.store();
		                }
		                
                        dTotalDebets+= debet.getAmount();
	                }
                }
	        }    		
    	}
    }
    String sMessage="";
    if(!bUniqueInsurerReferenceRequired && !bUniqueOtherReferenceRequired && !bUniqueDoctorRequired){
		if(!quickInvoice){
		    double dBalance = Double.parseDouble(sEditBalance);
		    
			// patient heeft te veel betaald => aanmaken van credit en saldo invoice = 0
		    if (dBalance < 0) {
				Encounter encounter = Encounter.getActiveEncounter(invoicePatient.personid);
				if(encounter==null){
					encounter = Encounter.getLastEncounter(invoicePatient.personid);
				}
		
		        double dCredit = dBalance;
		        dBalance = 0;
		        PatientCredit patientcredit = new PatientCredit();
		        patientcredit.setAmount(dCredit * (-1));
		        patientcredit.setEncounterUid(encounter==null?"":encounter.getUid());
		        patientcredit.setDate(ScreenHelper.getSQLDate(getDate()));
		        patientcredit.setType("transfer.de.credit");
		        patientcredit.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
		        patientcredit.setUpdateUser(activeUser.userid);
		        patientcredit.store();
				
		        PatientCredit credit;
		        String sCreditUid;
		        double dTmpCredits = 0;
		        boolean paymentCovered=false;
				
		        for (int i = 0; i < patientinvoice.getCredits().size(); i++) {
		            sCreditUid = checkString((String) patientinvoice.getCredits().elementAt(i));
		
		            if (sCreditUid.length() > 0) {
		                credit = PatientCredit.get(sCreditUid);
		
		                if (credit != null) {
		                    dTmpCredits += credit.getAmount();
		                    if (dTmpCredits > dTotalDebets) {
		                        if(!paymentCovered){
		                        	credit.setAmount(new BigDecimal("" + (credit.getAmount() - (dTmpCredits - dTotalDebets))).setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue());
		                        }
		                        else {
		                        	credit.setAmount(0);
		                        }
		                        credit.store();
		                        paymentCovered=true;
		                    }
		                }
		            }
		        }
		    }
		    patientinvoice.setBalance(dBalance);
		}
		
	    if (patientinvoice.store()) {
			patientinvoice.createProductionOrders();
	    	if(MedwanQuery.getInstance().getConfigInt("invoiceInsurerReferenceMustBeUnique",0)==1 && sEditInsurarReference.length()>0){
	        	Pointer.deletePointers("INV.REF."+sEditInsurarReference);
	        	Pointer.storePointer("INV.REF."+sEditInsurarReference,patientinvoice.getUid());
	        }
	        if(MedwanQuery.getInstance().getConfigInt("invoiceOtherReferenceMustBeUnique",0)==1 && sEditComment.length()>0){
	        	Pointer.deletePointers("INV.OTHERREF."+sEditComment);
	        	Pointer.storePointer("INV.OTHERREF."+sEditComment,patientinvoice.getUid());
	        }
	        if(MedwanQuery.getInstance().getConfigInt("invoiceDoctorMustBeUnique",0)==1 && sEditInvoiceDoctor.length()>0){
	        	Pointer.deletePointers("INV.DOCTORREF."+sEditInvoiceDoctor);
	        	Pointer.storePointer("INV.DOCTORREF."+sEditInvoiceDoctor,patientinvoice.getUid());
	        }
	        String oldpointer=Pointer.getPointer("INV.SVC."+patientinvoice.getUid());
        	Pointer.deletePointers("INV.SVC."+patientinvoice.getUid());
	        if(sEditLinkedService.length()>0){
	        	Pointer.storePointer("INV.SVC."+patientinvoice.getUid(),sEditLinkedService);
	        	if(MedwanQuery.getInstance().getConfigInt("enableHMK",0)==1 && !oldpointer.equalsIgnoreCase(sEditLinkedService)){
	        		//Also update the serviceuid of the debets
					Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        		PreparedStatement ps = conn.prepareStatement("update oc_debets set oc_debet_serviceuid=? where oc_debet_patientinvoiceuid=?");
	        		ps.setString(1, sEditLinkedService);
	        		ps.setString(2, patientinvoice.getUid());
	        		ps.execute();
	        		ps.close();
	        		conn.close();
	        	}
	        }
	    	//Nu zetten we de reducties op orde
	    	//Eerst verwijderen we de bestaande reducties
	    	if(sEditReduction.length()>0){
	        	PatientCredit.deletePatientInvoiceReductions(patientinvoice.getUid());
	        	
		    	//Bereken de korting
		    	double reduction = Double.parseDouble(sEditReduction);
		    	if(reduction>0){
					Encounter encounter = Encounter.getActiveEncounter(invoicePatient.personid);
					if(encounter==null){
						encounter = Encounter.getLastEncounter(invoicePatient.personid);
					}
			    	PatientCredit credit = new PatientCredit();
			    	credit.setAmount(reduction*patientinvoice.getPatientAmount()/100);
			        credit.setEncounterUid(encounter==null?"":encounter.getUid());
			    	credit.setDate(new java.util.Date());
			    	credit.setInvoiceUid(patientinvoice.getUid());
			    	credit.setPatientUid(patientinvoice.getPatientUid());
			    	credit.setType("reduction");
			    	credit.setUpdateDateTime(new java.util.Date());
			    	credit.setUpdateUser(patientinvoice.getUpdateUser());
			    	credit.setVersion(1);
			    	credit.store();
		    	}
	    	}
	        sMessage = getTran(request,"web", "dataissaved", sWebLanguage);
	    } 
	    else {
	        sMessage = getTran(request,"web.control", "dberror", sWebLanguage);
	    }
    }
%>
{
"Message":"<%=HTMLEntities.htmlentities(sMessage)%>",
"EditPatientInvoiceUID":"<%=patientinvoice.getUid()%>",
"EditComment":"<%=checkString(patientinvoice.getComment())%>",
"EditInsurarReference":"<%=patientinvoice.getInsurarreference()%>",
"EditInsurarReferenceDate":"<%=patientinvoice.getInsurarreferenceDate()%>",
"EditInvoiceUID":"<%=patientinvoice.getInvoiceUid()%>",
"UniqueInsurerReferenceRequired":"<%=bUniqueInsurerReferenceRequired?"1":"0"%>",
"UniqueOtherReferenceRequired":"<%=bUniqueOtherReferenceRequired?"1":"0"%>",
"UniqueDoctorRequired":"<%=bUniqueDoctorRequired?"1":"0"%>",
"TotalDebets":"<%=dTotalDebets%>"
}
<%
}
catch(Exception e){
	e.printStackTrace();
}
%>