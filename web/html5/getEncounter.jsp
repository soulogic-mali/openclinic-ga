<%@page import="be.openclinic.medical.ReasonForEncounter"%>
<%@page import="be.openclinic.finance.Insurance"%>
<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*"%>
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
<%
    if(activeUser==null || activePatient==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
    	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","activeencounter",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getEncounter.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						%>
					</td>
				</tr>
				<tr>
					<td colspan='2' style='font-size:6vw;font-weight: bolder;text-align: center;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("web","activeencounter",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","encountertype",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("encountertype",encounter.getType(),sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","service",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=encounter.getService().getLabel(sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","begin",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=ScreenHelper.formatDate(encounter.getBegin())%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","origin",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("urgency.origin",encounter.getOrigin(),sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","situation",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("encounter.situation",encounter.getSituation(),sWebLanguage)%></td>
				</tr>
			<%
				String reasons = ReasonForEncounter.getReasonsForEncounterAsText(encounter.getUid(), sWebLanguage);
				if(reasons.length()>0){
			%>
				<tr>
					<td colspan='2' style='font-size:6vw;font-weight: bolder;text-align: center;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("mobile","reasonsforencounter",sWebLanguage) %></td>
				</tr>
			<%
				reasons=reasons.replace("\n", "$");
				for(int n=0;n<reasons.split("\\$").length;n++){
					String line = reasons.split("\\$")[n];
					String code= line.split("-")[0].trim();
					String text = line.substring(code.length()+3).trim();
			%>	
				<tr>
					<td class='mobileadmin2'  style='font-size:4vw'><%=code%></td>
					<td class='mobileadmin2'  style='font-size:4vw;font-weight:bold'><%=text%></td>
				</tr>
			<% 	
				}
				}
			%>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>
<%} %>

