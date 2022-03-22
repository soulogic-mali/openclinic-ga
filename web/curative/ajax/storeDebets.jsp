<%@page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String[] prestations = SH.p(request,"prestations").split("\\|");
	String wicketuid = SH.p(request,"wicketuid");
	String encounteruid = SH.p(request,"encounteruid");
	String encounterserviceuid = SH.p(request,"encounterserviceuid");
	String encountertype = SH.p(request,"encountertype");
	String encountermanager = SH.p(request,"encountermanager");
	String encounterorigin = SH.p(request,"encounterorigin");
	String reference = SH.p(request,"reference");
	String amount = SH.p(request,"amount");
	String invoiceuid = "";
	session.setAttribute("defaultwicket",wicketuid);
	
	//Step 1: make sure there is an active encounter
	if(encounteruid.length()==0){
		//Create a new encounter
		Encounter encounter = new Encounter();
		encounter.setBegin(new java.util.Date());
		encounter.setCreateDateTime(new java.util.Date());
		encounter.setOrigin(encounterorigin);
		encounter.setPatientUID(activePatient.personid);
		encounter.setServiceUID(encounterserviceuid);
		encounter.setSituation(SH.cs("defaultEncounterSituation","1"));
		encounter.setType(encountertype);
		encounter.setManagerUID(encountermanager);
		encounter.setUpdateUser(activeUser.userid);
		encounter.setVersion(1);
		encounter.store();
		encounteruid=encounter.getUid();
	}
	//Step 2: store all debets
	Vector<Debet> debets = new Vector<Debet>();
	Insurance insurance = Insurance.getDefaultInsuranceForPatient(activePatient.personid);
	for(int n=0;n<prestations.length;n++){
		String[] components = prestations[n].split("\\~");
		if(components.length>3){
			Prestation prestation = Prestation.get(components[0]);
			if(prestation!=null){
				Debet debet = new Debet();
				debet.setPrestationUid(prestation.getUid());
				debet.setInsuranceUid(insurance.getUid());
				debet.setQuantity(Double.parseDouble(components[2]));
				if(insurance.getExtraInsurarUid().length()>0){
					debet.setAmount(0);
					debet.setExtraInsurarUid(insurance.getExtraInsurarUid());
					debet.setExtraInsurarAmount(debet.getQuantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter(),encountertype));
				}
				else{
					debet.setAmount(debet.getQuantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter(),encountertype));
				}
				debet.setInsurarAmount(debet.getQuantity()*prestation.getInsurarPrice(insurance, insurance.getInsuranceCategoryLetter(),encountertype));
				debet.setCreateDateTime(new java.util.Date());
				debet.setDate(new java.util.Date());
				debet.setEncounterUid(encounteruid);
				if(SH.c(prestation.getServiceUid()).length()>0){
					debet.setServiceUid(prestation.getServiceUid());
				}
				else{
					debet.setServiceUid(encounterserviceuid);
				}
				debet.setUpdateUser(activeUser.userid);
				debet.setVersion(1);
				debet.store();
				debets.add(debet);
			}
		}
	}
	//Step 3: register the payment
	Vector<String> credits = new Vector<String>();
	PatientCredit credit = new PatientCredit();
	WicketCredit wcredit = new WicketCredit();
	if(debets.size()>0){
		credit.setAmount(Double.parseDouble(amount));
		credit.setCreateDateTime(new java.util.Date());
		credit.setCategory(SH.cs("defaultCreditCategory","1"));
		credit.setCurrency(SH.cs("currency","EUR"));
		credit.setDate(new java.util.Date());
		credit.setEncounterUid(encounteruid);
		credit.setPatientUid(activePatient.personid);
		credit.setType("patient.payment");
		credit.setUpdateUser(activeUser.userid);
		credit.setVersion(1);
		credit.store();
		credits.add(credit.getUid());
	}
	//Step 4: if debets have been stored, then create invoice and create cash entry
	if(debets.size()>0){
		PatientInvoice invoice = new PatientInvoice();
		invoice.setBalance(0);
		invoice.setClosureDate(SH.formatDate(new java.util.Date()));
		invoice.setCreateDateTime(new java.util.Date());
		invoice.setCredits(credits);
		invoice.setDate(new java.util.Date());
		invoice.setDebets(debets);
		invoice.setPatientUid(activePatient.personid);
		invoice.setStatus("closed");
		invoice.setUpdateUser(activeUser.userid);
		invoice.setVersion(1);
		invoice.setComment(reference);
		invoice.store();
		invoiceuid=invoice.getUid();
		wcredit.setAmount(credit.getAmount());
		wcredit.setCategory(credit.getCategory());
		wcredit.setCreateDateTime(credit.getCreateDateTime());
		wcredit.setCurrency(credit.getCurrency());
		wcredit.setOperationDate(new Timestamp(credit.getDate().getTime()));
		wcredit.setOperationType(credit.getType());
		wcredit.setReferenceObject(new ObjectReference("PatientCredit",credit.getUid()));
		wcredit.setUpdateUser(activeUser.userid);
		wcredit.setVersion(1);
		wcredit.setWicketUID(wicketuid);
		wcredit.setComment(activePatient.lastname+" "+activePatient.firstname+" - "+invoice.getInvoiceNumber());
		wcredit.store();
	}
%>
{
	"invoiceuid":"<%=invoiceuid %>"
}
