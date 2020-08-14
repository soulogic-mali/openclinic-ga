<%@page import="be.openclinic.knowledge.Ikirezi"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String symptom=request.getParameter("symptom");
	String value=request.getParameter("value");
	String encounteruid=checkString(request.getParameter("encounteruid"));
	Ikirezi.storeSymptom(encounteruid, symptom, value,Integer.parseInt(activeUser.userid));
%>