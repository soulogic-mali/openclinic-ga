<%@include file="/includes/validateUser.jsp"%>
<%
	String encounteruid=SH.c(request.getParameter("encounteruid"));
	Encounter encounter = Encounter.get(encounteruid);
	if(encounter!=null){
		encounter.setEnd(new java.util.Date());
		encounter.setUpdateUser(activeUser.userid);
		encounter.store();
		out.println("<CLOSED>");
	}
%>