<%@page import="be.openclinic.knowledge.*,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	try{
		Diagnosis diagnosis = new Diagnosis();
		diagnosis.setAuthorUID(activeUser.userid);
		diagnosis.setCode(request.getParameter("icd10"));
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
		diagnosis.setGravity(Diagnosis.getGravity("icd10", request.getParameter("icd10"), 0));
		diagnosis.setLateralisation(new StringBuffer(""));
		diagnosis.store();
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
