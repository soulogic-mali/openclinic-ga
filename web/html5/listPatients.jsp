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
	List patients = new Vector();
	String findlastname = checkString(request.getParameter("findlastname"));
	String findfirstname = checkString(request.getParameter("findfirstname"));
	String finddateofbirth = checkString(request.getParameter("finddateofbirth"));
	if(finddateofbirth.split("-").length>1 && finddateofbirth.split("-")[0].length()>2){
		finddateofbirth=ScreenHelper.formatDate(new SimpleDateFormat("yyyy-MM-dd").parse(finddateofbirth));
	}
	String findservice = checkString(request.getParameter("findservice"));
	if(findservice.length()>0){
		patients = AdminPerson.getPatientsInEncounterServiceUID("", "", "", findlastname, findfirstname, finddateofbirth, findservice, "", "");
	}
	else{
		patients = AdminPerson.getAllPatients("", "", "", findlastname, findfirstname, finddateofbirth, "", "");
	}
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","selectpatient",sWebLanguage) %></title>
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
				<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","selectpatient",sWebLanguage) %></td>
			</tr>
			<%
				if(patients.size()==0){
					out.println("<td colspan='2' style='font-size:4vw;text-align: center'>"+getTran(request,"web","nopatientrecordsfound",sWebLanguage)+"</td>");
				}
				else{
					int n=0;
					Iterator iPatients = patients.iterator();
					while(iPatients.hasNext() && n<20){
						AdminPerson person = (AdminPerson)iPatients.next();
						String[] s = AdminPrivateContact.getPrivateDetails(person.personid, new String[10]);
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:6vw'>"+person.personid+"<br/><img onclick='window.location.href=\"../html5/editPatient.jsp?personid="+person.personid+"\"' src='"+sCONTEXTPATH+"/_img/icons/mobile/edit.png'/></td>");
		        		out.println("<td onclick='window.location.href=\""+sCONTEXTPATH+"/html5/getPatient.jsp?searchpersonid="+person.personid+"\"' class='mobileadmin2' style='font-size:5vw'><span style='font-size:5vw;text-decoration: underline; color: darkblue'>"+person.getFullName()+"</span><span style='font-size: 4vw'><br>"+person.dateOfBirth+" - "+getTranNoLink("gender",person.gender.toLowerCase(),sWebLanguage)+"</span></td></tr>");
						out.println("</tr>");
						n++;
					}
					if(patients.size()>20){
						out.println("<td colspan='2' style='font-size:4vw;text-align: center'><img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/> "+getTran(request,"web","morepatientsrefinesearch",sWebLanguage)+"</td>");
					}
				}
			%>
		</table>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>