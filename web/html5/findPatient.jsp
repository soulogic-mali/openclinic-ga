<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
	if(request.getParameter("find")!=null){
		if(checkString(request.getParameter("findid")).length()>0){
			out.println("<script>window.location.href='getPatient.jsp?searchpersid="+request.getParameter("findid")+"'</script>");
			out.flush();
		}
		else if(checkString(request.getParameter("findnatreg")).length()>0){
			out.println("<script>window.location.href='getPatient.jsp?searchnatreg="+request.getParameter("findnatreg")+"'</script>");
			out.flush();
		}
		else if(checkString(request.getParameter("findlastname")).length()>0 || checkString(request.getParameter("findfirstname")).length()>0 || checkString(request.getParameter("finddateofbirth")).length()>0 || checkString(request.getParameter("findservice")).length()>0){
			out.println("<script>window.location.href='listPatients.jsp?findlastname="+request.getParameter("findlastname")+"&findfirstname="+request.getParameter("findfirstname")+"&finddateofbirth="+request.getParameter("finddateofbirth")+"&findservice="+request.getParameter("findservice")+"'</script>");
			out.flush();
		}
	}
%>
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
    <script>
      function initBarcode2(){
	    window.open("zxing://scan/?ret=<%="http://"+request.getServerName()+":"+request.getServerPort()+request.getRequestURI().replaceAll(request.getServletPath(),"")%>/html5/getPatient.jsp\?searchpersonid={CODE}")
      }
	</script>
</head>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","findpatient",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<table width='100%'>
				<tr>
					<td style='font-size:8vw;text-align: left'></td>
					<td style='font-size:8vw;text-align: right'>
					<%
						if(!MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
					%>
						<img onclick="initBarcode2();" src='<%=sCONTEXTPATH%>/_img/icons/mobile/qr.png'/>
					<%
						}
					%>
						<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","findpatient",sWebLanguage) %></td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>ID:&nbsp;</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='findid' size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'><%=getTran(request,"web","natreg",sWebLanguage) %>:&nbsp;</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='findnatreg' size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","lastname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='findlastname' size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","firstname",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='findfirstname' size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","dateofbirth",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='date' name='finddateofbirth' size='10'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<%=getTranNoLink("web","service",sWebLanguage) %>:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<select style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6;width: 155px' name='findservice'>
							<option/>
							<%
			                    Service service;
			                    for (int i=0; i<activeUser.vServices.size(); i++){
			                        service = (Service)activeUser.vServices.elementAt(i);
			                        if(service!=null && service.code.length()>0){
			                        	%><option style='font-size:5vw' value="<%=service.code%>"><%=service.code+": "+getTranNoLink("Service",service.code,sWebLanguage)%></option><%
			                        }
			                    }
		                    %>
	                    </select>
					</td>
				</tr>
				<tr>
					<td width='30%'></td>
					<td width='70%'>
						<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='submit' name='find' value='<%=getTranNoLink("web","find",sWebLanguage) %>'/>
						<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='button' name='new' value='<%=getTranNoLink("web","new",sWebLanguage) %>' onclick='window.location.href="newPatient.jsp";'/>
					</td>
				</tr>
			</table>
			<br/><br/>
			<table width='100%'>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:5vw;'><%=getTranNoLink("web","recentrecords",sWebLanguage) %></td>
				</tr>
			<%
				long day=24*3600*1000;
	        	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	        	PreparedStatement ps = conn.prepareStatement("select accesscode, max(accesstime) accesstime, count(*) number from accesslogs where userid=? and accesscode like 'A.%' and accesstime>? group by accesscode order by max(accesstime) desc");
	        	ps.setInt(1,Integer.parseInt(activeUser.userid));
	        	ps.setTimestamp(2,new Timestamp(new java.util.Date().getTime()-7*day));
	        	ResultSet rs = ps.executeQuery();
	        	int counter=0;
				try{
		        	while(rs.next() && counter<MedwanQuery.getInstance().getConfigInt("maxMostRecentHealthrecords",20)){
		        		String patientid = rs.getString("accesscode").replaceAll("A.", "");
		        		AdminPerson patient = AdminPerson.getAdminPerson(patientid);
		        		if(patient!=null && patient.lastname!=null && patient.lastname.length()>0){
		            		counter++;
			        		out.println("<tr><td class='mobileadmin2' style='font-size:5vw'>"+patient.personid+"<br/><img height='50%' onclick='window.location.href=\"../html5/editPatient.jsp?personid="+patient.personid+"\"' src='"+sCONTEXTPATH+"/_img/icons/mobile/edit.png'/></td>");
			        		out.println("<td onclick='window.location.href=\""+sCONTEXTPATH+"/html5/getPatient.jsp?searchpersonid="+patient.personid+"\"' class='mobileadmin2' style='font-size:5vw'><span onmouseover='this.style.cursor=\"pointer\"' onmouseout='this.style.cursor=\"default\"' style='font-size:5vw;text-decoration: underline; color: darkblue'>"+patient.getFullName()+"</span><span style='font-size: 4vw'><br>"+patient.dateOfBirth+" - "+getTranNoLink("gender",patient.gender.toLowerCase(),sWebLanguage)+"</span></td></tr>");
		        		}
		        	}
				}
				catch(Exception e){
					e.printStackTrace();
				}
	        	rs.close();
	        	ps.close();
	        	conn.close();
			%>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>