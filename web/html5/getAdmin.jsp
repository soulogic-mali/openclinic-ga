<%@page import="be.mxs.common.util.system.Picture,
                java.io.File,
                java.io.FileOutputStream"%>
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
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","patientfile",sWebLanguage) %></title>
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
				<%
				    boolean pictureExists = Picture.exists(Integer.parseInt(activePatient.personid));
				    if(pictureExists){
				        Picture picture = new Picture(Integer.parseInt(activePatient.personid));
				        
				        try{
				        	String sDocumentsFolder = MedwanQuery.getInstance().getConfigString("DocumentsFolder","c:/projects/openclinic/documents");
				            File file = new File(sDocumentsFolder+"/"+activeUser.userid+".jpg");
				            FileOutputStream fileOutputStream = new FileOutputStream(file);
				            fileOutputStream.write(picture.getPicture());
				            fileOutputStream.close();
				            
				            // extra row and cell for picture
				            %>
								<tr>
									<td colspan='2' style='text-align:center;padding:10px;max-width:160px'>
										<img border="0" style='max-width:100%' src='<c:url value="/"/>documents/<%=activeUser.userid%>.jpg?ts=<%=getTs()%>'/>
									</td>
								</tr>
				            <%
				        }
				        catch(Exception e){
				        	pictureExists = false;
				        }
				    }
				%>
				<tr>
					<td colspan='2' style='font-size:6vw;font-weight: bolder;text-align: center;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("web","admindata",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","dateofbirth",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=activePatient.dateOfBirth%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","gender",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("gender",activePatient.gender,sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","nationality",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=ScreenHelper.capitalize(getTranNoLink("country",activePatient.nativeCountry,sWebLanguage))%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","civilstatus",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("civil.status",activePatient.comment2,sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","language",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=getTranNoLink("web.language",activePatient.language,sWebLanguage)%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","telephone",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=activePatient.getActivePrivate()==null?"":activePatient.getActivePrivate().telephone%></td>
				</tr>
				<tr>
					<td class='mobileadmin2' style='font-size:6vw'><%=getTranNoLink("web","mobile",sWebLanguage) %></td>
					<td class='mobileadmin2' style='font-size:6vw;font-weight: bold'><%=activePatient.getActivePrivate()==null?"":activePatient.getActivePrivate().mobile%></td>
				</tr>
			</table>
			<table width='100%'>
				<%
					Vector insurances = Insurance.getCurrentInsurances(activePatient.personid);
					if(insurances.size()>0){
						%>
							<tr>
								<td colspan='2'><hr/></td>
							</tr>
							<tr>
								<td colspan='2' style='font-size:6vw;font-weight: bolder;text-align: center;background-color:#C3D9FF;padding:10px'><%=getTranNoLink("web","activeinsurances",sWebLanguage) %></td>
							</tr>
						<%
						for(int n=0;n<insurances.size();n++){
							Insurance insurance = (Insurance)insurances.elementAt(n);
							%>
							<tr>
								<td colspan='2' class='mobileadmin' style='font-size:6vw;font-weight: bold'><%=insurance.getInsurar().getName()%></td>
							</tr>
							<%if(checkString(insurance.getInsuranceNr()).length()>0){ %>
							<tr>
								<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","number",sWebLanguage) %></td>
								<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=insurance.getInsuranceNr()%></td>
							</tr>
							<%} %>
							<%if(checkString(insurance.getMember()).length()>0){ %>
							<tr>
								<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("insurance","member",sWebLanguage) %></td>
								<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=insurance.getMember()%></td>
							</tr>
							<%} %>
							<tr>
								<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","coverageplan",sWebLanguage) %></td>
								<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=(100-Integer.parseInt(insurance.getInsuranceCategory().getPatientShare()))+"%"%></td>
							</tr>
							<%
						}
					}
				%>
			</table>
		</form>
		<%
    }
		%>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>		
