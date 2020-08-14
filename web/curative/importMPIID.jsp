<%@include file="/includes/validateUser.jsp"%>
<%
	String mpiid = request.getParameter("mpiid");
	activePatient = AdminPerson.getMPI(mpiid);
	activePatient.updateuserid=activeUser.userid;
	activePatient.sourceid="5";
	activePatient.store();
	session.setAttribute("activePatient",activePatient);
%>