<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%= AdminPerson.getFullName(request.getParameter("PatientID"))%>