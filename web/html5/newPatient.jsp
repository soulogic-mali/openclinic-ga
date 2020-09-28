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
			AdminPerson p = new AdminPerson();
			p.begin=ScreenHelper.getSQLDate(new java.util.Date());
			p.dateOfBirth=request.getParameter("dateofbirth").split("-")[2]+"/"+request.getParameter("dateofbirth").split("-")[1]+"/"+request.getParameter("dateofbirth").split("-")[0];
			p.firstname=request.getParameter("firstname");
			p.lastname=request.getParameter("lastname");
			p.gender=request.getParameter("gender");
			p.updateuserid="4";
			p.sourceid="1";
			AdminPrivateContact pc = new AdminPrivateContact();
			pc.address=request.getParameter("address");
			p.privateContacts=new Vector();
			p.privateContacts.add(pc);
			p.store();
			activePatient=p;
	        session.setAttribute("activePatient",activePatient);
		    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
	        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
		    sessionContainerWO.setPersonVO(person);
		    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
		}
		catch(Exception e){}
		if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
			out.println("<script>window.location.href='"+sCONTEXTPATH+"/html5/sptcomplaints.jsp?doc="+MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")+"';</script>");
			out.flush();
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
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","newpatient",sWebLanguage) %></td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","lastname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='lastname' size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","firstname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='firstname' size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","dateofbirth",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='date' name='dateofbirth' size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","gender",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<select style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6;width: 155px' name='gender'>
							<option/>
							<option value='m'><%=getTranNoLink("web","male",sWebLanguage) %></option>
							<option value='f'><%=getTranNoLink("web","female",sWebLanguage) %></option>
						</select>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","address",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='address' size='15'/>
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