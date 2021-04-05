<%@include file="/includes/helper.jsp"%>
<%@include file="/includes/SingletonContainer.jsp"%>
<%
	User activeUser = (User)session.getAttribute("activeUser");
	if(activeUser ==null){
		activeUser = new User();
		activeUser.initialize(4);
		session.setAttribute("activeUser",activeUser);
	}
	session.setAttribute(sAPPTITLE+"WebLanguage",SH.cs("sptLanguage","fr"));
	reloadSingleton(session);
%>
<script>
	window.location.href='sptcomplaints.jsp?doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>';
</script>