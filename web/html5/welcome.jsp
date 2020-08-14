<%
if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
	out.println("<script>window.location.href='welcomespt.jsp';</script>");
	out.flush();
}
%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<title>OpenClinic Mobile</title>
<html>
	<body>
<%
    if(activeUser==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
%>
		<table style='width:100%'>
			<tr>
				<td style='text-align:left;'><img style="max-width:100%;max-height:105px;" src='../_img/openclinic_logo.jpg'/></td>
				<td style='color: #004369;vertical-align:middle;text-align:right;font-family: Raleway, Geneva, sans-serif;'>
					<table style='width: 100%;' onclick='openUser()'>
						<tr><td style='font-size:4vw;font-weight:bold'><%=activeUser.person.getFullName() %></td></tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=getTranNoLink("web","userid",sWebLanguage)%>: <%=activeUser.userid %></td></tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=ScreenHelper.formatDate(new java.util.Date(),new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"))%></td></tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=getTranNoLink("web","battery",sWebLanguage)%>: <span  style='font-size:4vw;font-weight:normal' id='batterylevel'>?</span></td></tr>
					</table>
				</td>
			</tr>
		</table>
		<table style='width:100%'>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/nursing/mobileActiveTriage.jsp';">
				<td style='width:25%;font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/triage.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","activetriage",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/nursing/mobileActiveDeliveries.jsp';">
				<td style='width:25%;font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/delivery.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","activedeliveries",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/findPatient.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/searchpatient.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","findpatient",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/sptcomplaints.jsp?doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/knowledge.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","spt",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/ikirezi.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/ikirezi.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","spt.ikirezi",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.parent.location.href='<%=sCONTEXTPATH%>/main.do';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/desktop.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","desktopinterface",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.history.go(0);window.parent.location.replace('<%=sCONTEXTPATH%>/html5/login.jsp');">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/logout.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","logout",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.history.go(0);window.parent.location.replace('<%=sCONTEXTPATH%>/system/shutdown.jsp');">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/stop.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","shutdown",sWebLanguage) %>
				</td>
			</tr>
		</table>
		<script>
			window.onload = function () {
				navigator.getBattery().then(function(battery) {
					document.getElementById("batterylevel").innerHTML=Math.round(battery.level * 100) + "%";
				});
			}
		</script>
		<%
    }
		%>
		<script>
			function openUser(){
				window.location.href='getUser.jsp';
			}
		</script>
	</body>
</html>
