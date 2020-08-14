<%@include file="/includes/validateUser.jsp"%>
<%
	String mpiid = checkString(request.getParameter("mpiid"));
	activePatient.adminextends.put("mpiid",mpiid);
	activePatient.store();
%>