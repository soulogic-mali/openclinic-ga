<!DOCTYPE html>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.File"%>
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
<title>OpenClinic GMAO Mobile</title>
<html>
	<body>
<%
    if(activeUser==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
    	if(session.getAttribute("activeService")==null){
    		session.setAttribute("activeService",activeUser.getParameter("defaultserviceid"));
    	}
%>
		<table style='width:100%'>
			<tr>
				<td style='text-align:left;'><img style="max-width:100%;max-height:105px;max-width:200px;" src='../_img/spt_logo.png'/></td>
				<td style='color: #004369;vertical-align:middle;text-align:right;font-family: Raleway, Geneva, sans-serif;'>
					<table style='width: 100%;' onclick='openUser()'>
						<tr><td style='font-size:4vw;font-weight:normal'><%=ScreenHelper.formatDate(new java.util.Date(),new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"))%></td></tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=getTranNoLink("web","battery",sWebLanguage)%>: <span  style='font-size:4vw;font-weight:normal' id='batterylevel'>?</span></td></tr>
					</table>
				</td>
			</tr>
		</table>
		<br/><br/><br/><br/>
		<table style='width:100%'>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/manageService.jsp';">
				<td style='font-size:6vw;text-align:center;padding:10px'>
					<img style='max-height: 32px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/building.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","healthstructure",sWebLanguage) %><br>
					<span style='font-size:3vw'>[<%=(String)session.getAttribute("activeService")+" - "+getTranNoLink("service",(String)session.getAttribute("activeService"),sWebLanguage) %>]</span>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/manageAssets.jsp';">
				<td style='font-size:6vw;text-align:center;padding:10px'>
					<img style='max-height: 32px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/inventory.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","assets",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/manageMaintenancePlans.jsp';">
				<td style='font-size:6vw;text-align:center;padding:10px'>
					<img style='max-height: 32px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/planning.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","maintenanceplans",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/manageDashboard.jsp';">
				<td style='font-size:6vw;text-align:center;padding:10px'>
					<img style='max-height: 32px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/icon_dashboard.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"asset","dashboard",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.history.go(0);window.parent.location.replace('<%=sCONTEXTPATH%>/html5/login.jsp');">
				<td style='font-size:6vw;text-align:center;padding:10px'>
					<img style='max-height: 32px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/logout.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","logout",sWebLanguage) %>
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
	<% }%>
	</body>
</html>
