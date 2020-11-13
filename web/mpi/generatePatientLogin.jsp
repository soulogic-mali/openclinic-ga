<%@include file="/includes/validateUser.jsp"%>
<%
	if(activePatient.getID("candidate").length()==0){
		activePatient.setID("candidate", SH.getRandomPassword());
		activePatient.store();
	}
	System.out.println("Calling Gmail function");
	activePatient.sendMPIRegistrationMessage();
%>