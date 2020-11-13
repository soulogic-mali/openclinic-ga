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
<%
	if(request.getParameter("submitButton")!=null){
		try{
			//Todo: create new AdminPerson
			String personid = checkString(request.getParameter("personid"));
			activePatient = AdminPerson.getAdminPerson(personid);
			activePatient.begin=ScreenHelper.getSQLDate(new java.util.Date());
			activePatient.dateOfBirth=request.getParameter("dateofbirth").split("-")[2]+"/"+request.getParameter("dateofbirth").split("-")[1]+"/"+request.getParameter("dateofbirth").split("-")[0];
			activePatient.firstname=request.getParameter("firstname").toUpperCase();
			activePatient.lastname=request.getParameter("lastname").toUpperCase();
			activePatient.gender=request.getParameter("gender");
			activePatient.updateuserid="4";
			activePatient.sourceid="1";
			AdminPrivateContact pc = new AdminPrivateContact();
			pc.address=request.getParameter("address").toUpperCase();
			activePatient.privateContacts=new Vector();
			activePatient.privateContacts.add(pc);
			activePatient.store();
			session.setAttribute("activePatient", activePatient);
		    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
	        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
		    sessionContainerWO.setPersonVO(person);
		    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
		}
		catch(Exception e){}
		if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
			session.removeAttribute("sptconcepts");
			out.println("<script>window.location.href='"+sCONTEXTPATH+"/html5/sptcomplaints.jsp?doc="+MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")+"';</script>");
			out.flush();
		}
	}
	else{
		String personid = checkString(request.getParameter("personid"));
		activePatient = AdminPerson.getAdminPerson(personid);
		long day = 24*3600*1000;
		long year = 365*day;
		if(activePatient!=null && activePatient.dateOfBirth!=null && ScreenHelper.parseDate(activePatient.dateOfBirth)!=null && ScreenHelper.parseDate(activePatient.dateOfBirth).before(new java.util.Date(new java.util.Date().getTime()-200*year))){
			activePatient.dateOfBirth=ScreenHelper.formatDate(new java.util.Date());
		}
	}
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","patientfile",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
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
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","editpatient",sWebLanguage) %></td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>ID:&nbsp;</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%= activePatient.personid%>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","lastname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='lastname' value="<%=activePatient.lastname %>" size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","firstname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='firstname' value="<%=activePatient.firstname %>" size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","dateofbirth",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='date' name='dateofbirth' value="<%=activePatient.dateOfBirth.split("/").length>2?activePatient.dateOfBirth.split("/")[2]+"-"+activePatient.dateOfBirth.split("/")[1]+"-"+activePatient.dateOfBirth.split("/")[0]:"" %>" size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","gender",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<select style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6;width: 155px' name='gender' >
							<option/>
							<option <%=activePatient.gender.equalsIgnoreCase("m")?"selected":"" %> value='m'><%=getTranNoLink("web","male",sWebLanguage) %></option>
							<option <%=activePatient.gender.equalsIgnoreCase("f")?"selected":"" %>value='f'><%=getTranNoLink("web","female",sWebLanguage) %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","address",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='address'  value="<%=activePatient.getActivePrivate().address %>"size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%'></td>
					<td width='70%'>
						<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>