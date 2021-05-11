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
	System.out.println("sptconcepts before="+session.getAttribute("sptconcepts"));
	if(SH.c(request.getParameter("init")).equalsIgnoreCase("1")){
		session.removeAttribute("sptconcepts");
		session.removeAttribute("spt");
		session.removeAttribute("sptpatient");
	}
	System.out.println("init="+request.getParameter("init"));
	System.out.println("sptconcepts after="+session.getAttribute("sptconcepts"));
	
%>
<script>
	window.location.href='sptcomplaints.jsp?doreset=<%=SH.c(request.getParameter("doreset"))%>&autoload=<%=SH.c(request.getParameter("autoload"))%>&nohome=<%=SH.c(request.getParameter("nohome"))%>&doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>';
</script>