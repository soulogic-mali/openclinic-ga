<%@page import="be.openclinic.finance.PatientCredit"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	PatientCredit credit = new PatientCredit();
	credit.setCreateDateTime(new java.util.Date());
    credit.setDate(new java.util.Date());
    credit.setInvoiceUid(SH.c(request.getParameter("invoiceuid")));
    credit.setAmount(Double.parseDouble(SH.c(request.getParameter("amount"))));
    credit.setType("patient.payment");
    try{
    	Integer.parseInt(SH.c(request.getParameter("invoiceuid")));
    	credit.setCategory("1");
    }
    catch(Exception e){
    	credit.setCategory("2");
    }
    credit.setEncounterUid(SH.c(request.getParameter("encounteruid")));
    credit.setComment(SH.c(request.getParameter("comment")));
    credit.setUpdateDateTime(new java.util.Date());
    credit.setUpdateUser(activeUser.userid);
    credit.setCurrency(SH.c(request.getParameter("currency")));
    credit.setPatientUid(SH.c(request.getParameter("patientuid")));
    credit.store();
%>