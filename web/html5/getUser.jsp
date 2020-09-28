<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
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
<title><%=getTran(request,"web","patientfile",sWebLanguage) %></title>
<html>
	<body>
		<table width='100%'>
			<tr>
				<td style='font-size:8vw;text-align: left'></td>
				<td style='font-size:8vw;text-align: right'>
					<img onclick="window.location.href='../html5/findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
					<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
			<tr>
				<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
					<%="["+activeUser.userid+"] "+activeUser.person.getFullName()%>
				</td>
			</tr>
			<tr>
				<td class='mobileadmin2' style='width:50%;font-size:6vw'><%=getTranNoLink("web","myprofile",sWebLanguage) %></td>
				<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=UserProfile.getUserProfileById(Integer.parseInt(activeUser.getParameter("userprofileid"))).getUserprofilename()%></td>
			</tr>
			<tr>
				<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","alias",sWebLanguage) %></td>
				<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=activeUser.getParameter("alias")%></td>
			</tr>
			<tr>
				<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web.userprofile","defaultpage",sWebLanguage) %></td>
				<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("defaultpage",activeUser.getParameter("DefaultPage"),sWebLanguage)%></td>
			</tr>
			<tr>
				<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","service",sWebLanguage) %></td>
				<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("service",activeUser.getParameter("defaultserviceid"),sWebLanguage)%></td>
			</tr>
			<tr>
				<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","organizationid",sWebLanguage) %></td>
				<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=activeUser.getParameter("organisationid")%></td>
			</tr>
		</table>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>