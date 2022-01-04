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
				<td style='text-align:left;'><img style="max-width:100%;max-height:105px;max-width:200px;" src='../_img/spt_logo.png'/></td>
				<td style='color: #004369;vertical-align:middle;text-align:right;font-family: Raleway, Geneva, sans-serif;'>
					<table style='width: 100%;' onclick='openUser()'>
						<tr>
							<td style='font-size:4vw;font-weight:bolder'>
							<%
								if(activePatient!=null && activePatient.lastname.length()>0){
									out.println("["+activePatient.personid+"] "+activePatient.getFullName());
								}
							%>
							</td>
						</tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=ScreenHelper.formatDate(new java.util.Date(),new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"))%></td></tr>
						<tr><td style='font-size:4vw;font-weight:normal'><%=getTranNoLink("web","battery",sWebLanguage)%>: <span  style='font-size:4vw;font-weight:normal' id='batterylevel'>?</span></td></tr>
					</table>
				</td>
			</tr>
		</table>
		<br/><br/><br/><br/>
		<table style='width:100%'>
			<% if(MedwanQuery.getInstance().getConfigInt("sptRestricted",0)==0){ %>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/findPatient.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/searchpatient.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","findpatient",sWebLanguage) %>
				</td>
			</tr>
			<% } %>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/sptcomplaints.jsp?doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/knowledge.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","spt",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/initspt.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/delete.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","initialize",sWebLanguage) %>
				</td>
			</tr>
			<%
				if(checkString(request.getParameter("config")).equalsIgnoreCase("1")){
			%>
			<tr>
				<td colspan='2'><br/></td>
			</tr>
			<tr>
				<td colspan='2'><br/></td>
			</tr>
			<tr>
				<td colspan='2'><br/></td>
			</tr>
			<tr onclick="window.history.go(0);window.parent.location.replace('<%=sCONTEXTPATH%>/system/shutdown.jsp');">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/stop.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","shutdown",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/changePassword.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/password.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web.userprofile","changepassword",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/setDate.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/calendar.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web.userprofile","setdate",sWebLanguage) %>
				</td>
			</tr>
			<%
			  boolean bReachable=SH.isHostReachable(SH.cs("sptCentralHost", "cloud.hnrw.org"));
			  boolean bDataToPost=bReachable && SH.hasSPTDataToPost();
			  if(bReachable && bDataToPost){ %>
				<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/postSPTData.jsp';">
					<td style='font-size:6vw;text-align:right;padding:10px'>
						<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/uploadcloud.png'/>
					</td>
					<td style='font-size:6vw;text-align:left;padding:10px'>
						<%=getTran(request,"web","postsptdata",sWebLanguage) %>
					</td>
				</tr>
			<%}else{ 
				String sMessage="";
				if(!bReachable){
					sMessage=SH.cs("sptCentralHost", "cloud.hnrw.org")+" "+getTran(request,"web","isunreachable",sWebLanguage);
				}
				else{
					sMessage=getTran(request,"web","nonewdatatopost",sWebLanguage);
				}
				%>
				<tr>
					<td style='font-size:6vw;text-align:right;padding:10px'>
						<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/uploadcloud.png'/>
					</td>
					<td style='color:lightgrey;font-size:6vw;text-align:left;padding:10px'>
						<%=getTran(request,"web","postsptdata",sWebLanguage) %>
						<span style='font-size:4vw;color: darkgrey'><br/>[<%=sMessage %>]</span>
					</td>
				</tr>
			<%} %>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/updateLogic.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img style='max-width: 40px' src='<%=sCONTEXTPATH%>/_img/icons/mobile/icon_brain.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web.userprofile","update",sWebLanguage) %>
				</td>
			</tr>
			<%
				}
			%>
		</table>
		<br/><br/><br/><br/><br/>
		<center>
			<%
				if(checkString(request.getParameter("config")).equalsIgnoreCase("1")){
			%>
			<img height='24px' onclick='window.location.href="welcomespt.jsp?config=0";' src='<%=sCONTEXTPATH %>/_img/icons/mobile/icon_noconfig.png'/>
			<%
				}
				else{
			%>
			<img height='24px' onclick='window.location.href="welcomespt.jsp?config=1";' src='<%=sCONTEXTPATH %>/_img/icons/mobile/icon_config.png'/>
			<%
				}
			%>
			<%
				if(new File(MedwanQuery.getInstance().getConfigString("lastbackup.semaphore","/backups/lastbackup")).exists()){
					BufferedReader br = new BufferedReader(new FileReader(MedwanQuery.getInstance().getConfigString("lastbackup.semaphore","/backups/lastbackup")));
					String line = br.readLine();
					try{
						java.util.Date lastBackup = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(line);
						%>
						<font style='font-size:3vw;'><%=getTran(request,"web","lastbackup",sWebLanguage) %>: <%=line %><br/>
						<%
						long day = 24*3600*1000;
						if(lastBackup!=null && new java.util.Date().getTime()-lastBackup.getTime()>day){
							if(new File(MedwanQuery.getInstance().getConfigString("dobackup.semaphore","/backups/dobackup")).exists()){
								%>
								<font style='font-size:3vw;color: red'><%=getTran(request,"web","verifynas",sWebLanguage) %></font>
								<%
							}
							else{
								org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(MedwanQuery.getInstance().getConfigString("dobackup.semaphore","/backups/dobackup")), "ok");
								%>
								<font style='font-size:3vw;color: red'><%=getTran(request,"web","backuprequested",sWebLanguage) %></font>
								<%
							}
						}
					}
					catch(Exception e){
						e.printStackTrace();
					}
				}
			%>
		</center>
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
			window.parent.parent.scrollTo(0,0);
		</script>	</body>
</html>
