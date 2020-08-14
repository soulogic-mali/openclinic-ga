<%@page import="be.openclinic.knowledge.*,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	double bmi=22;
	try{
		bmi=Double.parseDouble(request.getParameter("bmi"));
	}
	catch(Exception e){}
	double temperature=36.8;
	try{
		temperature=Double.parseDouble(request.getParameter("temperature"));
	}
	catch(Exception e){}
	double wflval=0;
	try{
		wflval=Double.parseDouble(request.getParameter("wflval"));
	}
	catch(Exception e){}
	double wfl=0;
	try{
		wfl=Double.parseDouble(request.getParameter("wfl").split(":")[0].split("=")[1]);
	}
	catch(Exception e){}
	if(temperature>=39){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "26", "1",Integer.parseInt(activeUser.userid));
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "91", Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "R50.9");
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode("R50.9");
		diagnosis.setCodeType("icd10");
		diagnosis.setCreateDateTime(new java.util.Date());
		diagnosis.setDate(new java.util.Date());
		diagnosis.setEncounterUID(request.getParameter("encounteruid"));
		Encounter encounter = Encounter.get(request.getParameter("encounteruid"));
		diagnosis.setServiceUid(encounter.getServiceUID());
		diagnosis.setUpdateDateTime(new java.util.Date());
		diagnosis.setUpdateUser(activeUser.userid);
		diagnosis.setFlags("");
		diagnosis.setCertainty(500);
		diagnosis.setGravity(Diagnosis.getGravity("icd10", "R50.9", 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	else if(temperature>=38){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "91", "1",Integer.parseInt(activeUser.userid));
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "26", Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "R50.9");
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode("R50.9");
		diagnosis.setCodeType("icd10");
		diagnosis.setCreateDateTime(new java.util.Date());
		diagnosis.setDate(new java.util.Date());
		diagnosis.setEncounterUID(request.getParameter("encounteruid"));
		Encounter encounter = Encounter.get(request.getParameter("encounteruid"));
		diagnosis.setServiceUid(encounter.getServiceUID());
		diagnosis.setUpdateDateTime(new java.util.Date());
		diagnosis.setUpdateUser(activeUser.userid);
		diagnosis.setFlags("");
		diagnosis.setCertainty(500);
		diagnosis.setGravity(Diagnosis.getGravity("icd10", "R50.9", 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	else{
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "26", Integer.parseInt(activeUser.userid));
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "91", Integer.parseInt(activeUser.userid));
	}
	if(activePatient.getAge()>=19 && bmi>=30){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "218", "1",Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E66");
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode("E66");
		diagnosis.setCodeType("icd10");
		diagnosis.setCreateDateTime(new java.util.Date());
		diagnosis.setDate(new java.util.Date());
		diagnosis.setEncounterUID(request.getParameter("encounteruid"));
		Encounter encounter = Encounter.get(request.getParameter("encounteruid"));
		diagnosis.setServiceUid(encounter.getServiceUID());
		diagnosis.setUpdateDateTime(new java.util.Date());
		diagnosis.setUpdateUser(activeUser.userid);
		diagnosis.setFlags("");
		diagnosis.setCertainty(500);
		diagnosis.setGravity(Diagnosis.getGravity("icd10", "E66", 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	else if(activePatient.getAge()>=19 && bmi>=25){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "218", "1",Integer.parseInt(activeUser.userid));
	}
	else if(activePatient.getAge()>=19){
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "218", Integer.parseInt(activeUser.userid));
	}
	if(wfl<=-3){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "4", "1",Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E43");
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E44");
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode("E43");
		diagnosis.setCodeType("icd10");
		diagnosis.setCreateDateTime(new java.util.Date());
		diagnosis.setDate(new java.util.Date());
		diagnosis.setEncounterUID(request.getParameter("encounteruid"));
		Encounter encounter = Encounter.get(request.getParameter("encounteruid"));
		diagnosis.setServiceUid(encounter.getServiceUID());
		diagnosis.setUpdateDateTime(new java.util.Date());
		diagnosis.setUpdateUser(activeUser.userid);
		diagnosis.setFlags("");
		diagnosis.setCertainty(500);
		diagnosis.setGravity(Diagnosis.getGravity("icd10", "E43", 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	else if(wfl<=-2){
		Ikirezi.storeSymptom(request.getParameter("encounteruid"), "4", "1",Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E44");
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E43");
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode("E44");
		diagnosis.setCodeType("icd10");
		diagnosis.setCreateDateTime(new java.util.Date());
		diagnosis.setDate(new java.util.Date());
		diagnosis.setEncounterUID(request.getParameter("encounteruid"));
		Encounter encounter = Encounter.get(request.getParameter("encounteruid"));
		diagnosis.setServiceUid(encounter.getServiceUID());
		diagnosis.setUpdateDateTime(new java.util.Date());
		diagnosis.setUpdateUser(activeUser.userid);
		diagnosis.setFlags("");
		diagnosis.setCertainty(500);
		diagnosis.setGravity(Diagnosis.getGravity("icd10", "E44", 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	else if(wflval>0){
		Ikirezi.removeSymptom(request.getParameter("encounteruid"), "4",Integer.parseInt(activeUser.userid));
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E44");
		Diagnosis.deleteForEncounter(request.getParameter("encounteruid"), "icd10", "E43");
	}
%>