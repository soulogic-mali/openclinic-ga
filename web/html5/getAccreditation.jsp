<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*"%>
<%@page import="be.openclinic.finance.Insurance"%>
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
<%
	if(activePatient!=null){
		Insurance actinsurance = Insurance.getDefaultInsuranceForPatient(activePatient.personid);
		if(actinsurance!=null && actinsurance.getInsurar().getAccreditationMechanism().equalsIgnoreCase("sis")){
			SIS_Object acreditacion = Acreditacion.getLast(Integer.parseInt(activePatient.personid));
			if(acreditacion!=null){
				long day=24*3600*1000;
				boolean bValid=false;
				SimpleDateFormat deci = new SimpleDateFormat("yyyyMMddHHmmss");
				java.util.Date dValidUntil = new java.util.Date(acreditacion.getValueTimestamp(32).getTime()+day);
				if(dValidUntil.after(new java.util.Date())){
					bValid = true;
				}
				else if(MedwanQuery.getInstance().getConfigInt("enableAccreditationValidityPerEncounter",0)==1){
					Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
					if(activeEncounter!=null){
						bValid = dValidUntil.after(activeEncounter.getBegin());
					}
				}
				if(bValid){
					//Simply show the content
					%>
					<title><%=getTran(request,"web","accreditation",sWebLanguage) %></title>
					<html>
						<body>
							<table width='100%'>
								<tr>
									<td style='font-size:8vw;text-align: left'></td>
									<td style='font-size:8vw;text-align: right'>
										<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
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
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","AcNo",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(2)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Contrato",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(16)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Tipo",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(14)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Estado",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(18)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","begin",sWebLanguage) %></td>
									<%
										String s = acreditacion.getValueString(8);
										if(s.length()>=8){
											s=s.substring(6,8)+"/"+s.substring(4,6)+"/"+s.substring(0,4);
										}
									%>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=s%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","end",sWebLanguage) %></td>
									<%
										s = acreditacion.getValueString(17);
										if(s.length()>=8){
											s=s.substring(6,8)+"/"+s.substring(4,6)+"/"+s.substring(0,4);
										}
									%>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=s%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Reg",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(21)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Plan",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(29)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","sis.ees",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(9)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Descr EES",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(10)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Ubi EES",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(11)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","sis.regimen",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=getTranNoLink("sis.regimen",acreditacion.getValueString(13),sWebLanguage)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","Pobl",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=getTranNoLink("sis.populationgroup",acreditacion.getValueString(30),sWebLanguage)%></td>
								</tr>
								<tr>
									<td class='mobileadmin2' style='font-size:4vw'><%=getTranNoLink("web","DISA",sWebLanguage) %></td>
									<td class='mobileadmin2' style='font-size:4vw;font-weight: bold'><%=acreditacion.getValueString(25)%></td>
								</tr>
							</table>
						</body>
					</html>
					
					<%
				}
				else{
					String accreditationmechanism="SIS";
					String accreditationwarning="";
					Debug.println("Checking personid="+activePatient.personid);
					ResultQueryAsegurado insurance = SIS.getAffiliationInformation(Integer.parseInt(activePatient.personid));
					Debug.println("INSURANCE="+insurance);
					Debug.println("DATA="+insurance.getResultado());
					Debug.println("ERROR="+insurance.getIdError());
					String dob="";
					if(checkString(insurance.getFecNacimiento()).length()>=8){
						dob=insurance.getFecNacimiento().substring(6,8)+"/"+insurance.getFecNacimiento().substring(4,6)+"/"+insurance.getFecNacimiento().substring(0,4);
					}
					//Now check if authorization was obtained
					if(checkString(insurance.getEstado()).equalsIgnoreCase("ACTIVO")){
						//Check that this is the same patient
						if(!checkString(request.getParameter("ignorewarnings")).equalsIgnoreCase("true")){
							if(!activePatient.lastname.toLowerCase().contains(insurance.getApePaterno().toLowerCase())
								|| !activePatient.lastname.toLowerCase().contains(insurance.getApeMaterno().toLowerCase())		
								|| !activePatient.firstname.toLowerCase().contains(insurance.getNombres().toLowerCase())		
								){
									accreditationwarning="<li><input type='hidden' id='accwarning' value='name'/>"+getTran(request,"web","patientname",sWebLanguage)+" <font color='red'>"+
									activePatient.lastname+", "+activePatient.firstname+"</font> "+getTran(request,"web","differsfrominsurancepatientname",sWebLanguage)+" <font color='red'>"+
									insurance.getApePaterno()+" "+insurance.getApeMaterno()+", "+insurance.getNombres()+"</font><br/>";
							}
							if(!activePatient.dateOfBirth.equalsIgnoreCase(dob)
								){
									accreditationwarning+="<li><input type='hidden' id='accwarning' value='dateofbirth'/>"+getTran(request,"web","patientdateofbirth",sWebLanguage)+" <font color='red'>"+
										activePatient.dateOfBirth+"</font> "+getTran(request,"web","differsfrominsurancepatientdateofbirth",sWebLanguage)+" <font color='red'>"+
										dob+"</font><br/>";
							}
							if(accreditationwarning.length()==0){
								Acreditacion.store(insurance,Integer.parseInt(activePatient.personid),new java.util.Date(),accreditationmechanism);
							}
						}
						else{
							Acreditacion.store(insurance,Integer.parseInt(activePatient.personid),new java.util.Date(),accreditationmechanism);
						}
					}
					else{
						accreditationwarning=getTran(request,"accreditationerrors","sis."+insurance.getIdError(),sWebLanguage);
					}
					if(accreditationwarning.length()==0){
						%>
							<script>window.location.href='getPatient.jsp';</script>
						<%
					}
					else{
						%>
							<script>alert('<%=accreditationwarning%>');window.location.href='getPatient.jsp';</script>
						<%
					}
				}
			}
			else{
				String accreditationmechanism="SIS";
				String accreditationwarning="";
				Debug.println("Checking personid="+activePatient.personid);
				ResultQueryAsegurado insurance = SIS.getAffiliationInformation(Integer.parseInt(activePatient.personid));
				Debug.println("INSURANCE="+insurance);
				Debug.println("DATA="+insurance.getResultado());
				Debug.println("ERROR="+insurance.getIdError());
				String dob="";
				if(checkString(insurance.getFecNacimiento()).length()>=8){
					dob=insurance.getFecNacimiento().substring(6,8)+"/"+insurance.getFecNacimiento().substring(4,6)+"/"+insurance.getFecNacimiento().substring(0,4);
				}
				//Now check if authorization was obtained
				if(checkString(insurance.getEstado()).equalsIgnoreCase("ACTIVO")){
					//Check that this is the same patient
					if(!checkString(request.getParameter("ignorewarnings")).equalsIgnoreCase("true")){
						if(!activePatient.lastname.toLowerCase().contains(insurance.getApePaterno().toLowerCase())
							|| !activePatient.lastname.toLowerCase().contains(insurance.getApeMaterno().toLowerCase())		
							|| !activePatient.firstname.toLowerCase().contains(insurance.getNombres().toLowerCase())		
							){
								accreditationwarning="<li><input type='hidden' id='accwarning' value='name'/>"+getTran(request,"web","patientname",sWebLanguage)+" <font color='red'>"+
								activePatient.lastname+", "+activePatient.firstname+"</font> "+getTran(request,"web","differsfrominsurancepatientname",sWebLanguage)+" <font color='red'>"+
								insurance.getApePaterno()+" "+insurance.getApeMaterno()+", "+insurance.getNombres()+"</font><br/>";
						}
						if(!activePatient.dateOfBirth.equalsIgnoreCase(dob)
							){
								accreditationwarning+="<li><input type='hidden' id='accwarning' value='dateofbirth'/>"+getTran(request,"web","patientdateofbirth",sWebLanguage)+" <font color='red'>"+
									activePatient.dateOfBirth+"</font> "+getTran(request,"web","differsfrominsurancepatientdateofbirth",sWebLanguage)+" <font color='red'>"+
									dob+"</font><br/>";
						}
						if(accreditationwarning.length()==0){
							Acreditacion.store(insurance,Integer.parseInt(activePatient.personid),new java.util.Date(),accreditationmechanism);
						}
					}
					else{
						Acreditacion.store(insurance,Integer.parseInt(activePatient.personid),new java.util.Date(),accreditationmechanism);
					}
				}
				else{
					accreditationwarning=getTran(request,"accreditationerrors","sis."+insurance.getIdError(),sWebLanguage);
				}
				if(accreditationwarning.length()==0){
					%>
						<script>window.location.href='getPatient.jsp';</script>
					<%
				}
				else{
					%>
					<script>alert('<%=accreditationwarning%>');window.location.href='getPatient.jsp';</script>
					<%
				}
			}
		}
	}
%>