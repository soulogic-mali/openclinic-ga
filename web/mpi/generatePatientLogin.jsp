<%@include file="/includes/validateUser.jsp"%>
<%
	if(activePatient.getID("candidate").length()==0){
		activePatient.setID("candidate", SH.getRandomPassword());
		activePatient.store();
	}
	activePatient.sendMPIRegistrationMessage();
%>