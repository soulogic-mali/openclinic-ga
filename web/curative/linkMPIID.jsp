<%@include file="/includes/validateUser.jsp"%>
<%
	String mpiid = request.getParameter("mpiid");
	String personid = request.getParameter("personid");
	activePatient = AdminPerson.get(personid);
	activePatient.adminextends.put("mpiid",mpiid);
	activePatient.adminextends.put("facilityid$"+MedwanQuery.getInstance().getConfigString("hin.server.identifier","hin.facility.undefined"),personid);
	activePatient.updateuserid=activeUser.userid;
	activePatient.store();
	activePatient.updateMPI();
	session.setAttribute("activePatient",activePatient);
%>