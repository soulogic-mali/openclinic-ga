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
	if(checkString(request.getParameter("formaction")).equalsIgnoreCase("save")){
    	Encounter encounter = new Encounter();
    	encounter.setPatientUID(activePatient.personid);
    	encounter.setVersion(1);
    	encounter.setUpdateUser(activeUser.userid);
    	encounter.setUpdateDateTime(new java.util.Date());
    	encounter.setCreateDateTime(new java.util.Date());
		encounter.setType(request.getParameter("encountertype"));
		encounter.setBegin(new SimpleDateFormat("yyyy-MM-dd").parse(request.getParameter("encounterdate")));
		encounter.setServiceUID(request.getParameter("service"));
		encounter.setOrigin(request.getParameter("origin"));
		encounter.setSituation(request.getParameter("situation"));
		encounter.store();
        out.println("<script>window.location.href='getPatient.jsp?searchpersonid="+activePatient.personid+"';</script>");
        out.flush();
		
	}
	else if(activeUser==null || activePatient==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
%>
<%=sCSSNORMAL %>
<%=sJSPROTOTYPE %>
<title><%=getTran(request,"web","activeencounter",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='../html5/getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='../html5/findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
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
					<td colspan='2' style='font-size:6vw;font-weight: bolder;text-align: center;background-color:#C3D9FF;padding:10px'>
						<%=getTranNoLink("web","newencounter",sWebLanguage) %>
						<img onclick='save();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/save.png'/>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","encountertype",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'>
						<select name='encountertype' id='encountertype' style='max-width: 160px;font-size:6vw' onchange='updateservices();'>
							<option/>
							<option value='visit'><%=getTranNoLink("encountertype","visit",sWebLanguage) %></option>
							<option value='admission'><%=getTranNoLink("encountertype","admission",sWebLanguage) %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","service",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'>
						<div id='servicesdiv'/>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","begin",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'>
						<input class='mobileadmin2' style='font-size:6vw;max-width:160px' type='date' name='encounterdate' id='encounterdate' value='<%=new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>'/>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","origin",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'>
		                <select name="origin" id="origin" style='max-width: 160px;font-size:6vw'>
		                    <option/>
		                    <%=ScreenHelper.writeSelect(request,"urgency.origin","",sWebLanguage)%>
		                </select>
					</td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","situation",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'>
		                <select name="situation" id="situation" style='max-width: 160px;font-size:6vw'>
		                    <option/>
		                    <%=ScreenHelper.writeSelect(request,"encounter.situation","",sWebLanguage)%>
		                </select>
					</td>
				</tr>
			</table>
		</form>
		<script>
			function updateservices(){
			     var params = "type="+document.getElementById("encountertype").value+"&language=<%=sWebLanguage%>";
			     var url = '<c:url value="/html5/getEncounterServices.jsp"/>?ts='+new Date().getTime();
			     new Ajax.Request(url,{
			       method: "POST",
			       parameters: params,
			       onSuccess: function(resp){
			         document.getElementById("servicesdiv").innerHTML = resp.responseText;
			       }
			     });
			}
			function save(){
				if(document.getElementById('encountertype').value.length*document.getElementById('service').value.length*document.getElementById('encounterdate').value.length*document.getElementById('origin').value.length*document.getElementById('situation').value.length==0){
					alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
				}
				else{
					document.getElementById("formaction").value="save";
					transactionForm.submit();
				}
			}
		</script>
	</body>
</html>
<%} %>

