<%@include file="/mobile/_common/helper.jsp"%>
<head>
	<meta name="viewport" content="width=device-width, max-width=480, initial-scale=1.0">
	<meta name="mobile-web-app-capable" content="yes">
	<link rel="icon" sizes="192x192" href="android-spt-192x192.png">
</head>
<center>
<%
	if(new java.util.Date().before(new SimpleDateFormat("dd/MM/yyyy").parse(be.openclinic.system.SH.cs("minimumSystemDate","01/01/2021")))){
		//System date is not correctly set, redirect to date settings
		%>
			<iframe id='ocframe' style='display: ; padding: 0;width: 100%; height: 5000px' src="setDate.jsp" frameborder="0">
		<%
	}
	if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt") && MedwanQuery.getInstance().getConfigInt("mobile.edition.nologin",0)==1){
		User activeUser = User.get(4);
		reloadSingleton(session);
		session.setAttribute("activeUser",activeUser);
		if(checkString(request.getParameter("init")).equalsIgnoreCase("1")){
			session.setAttribute("activePatient",null);
			session.setAttribute("sptconcepts",null);
			session.setAttribute("spt",null);
            session.setAttribute("WebLanguage",activeUser.person.language);
		}

	%>
		<iframe id='ocframe' style='display: ; padding: 0;width: 100%; height: 5000px' src="welcomespt.jsp" frameborder="0">
	<%
	}
	else{
%>
	<iframe id='ocframe' style='display: ; padding: 0;width: 100%; height: 5000px' src="<%=request.getParameter("page")==null?"loginPage.jsp?searchpersonid="+checkString(request.getParameter("searchpersonid"))+"&logoff="+checkString(request.getParameter("logoff")):request.getParameter("page")+"?init="+checkString(request.getParameter("init"))+"&autoload="+checkString(request.getParameter("autoload"))+"&sptaction="+checkString(request.getParameter("sptaction"))+"&nohome="+checkString(request.getParameter("nohome"))+"&searchpersonid="+checkString(request.getParameter("searchpersonid"))%>" frameborder="0">
<%
	}
%>
	</iframe>
</center>
<script>
	document.getElementById('ocframe').style.maxWidth=<%=MedwanQuery.getInstance().getConfigInt("mobile.maxWidth",480)%>;
</script>