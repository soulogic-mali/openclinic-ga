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
<%=sJSPROTOTYPE %>
<%
	String personid = checkString(request.getParameter("searchpersonid"));
	String persid = checkString(request.getParameter("searchpersid"));
	String natreg = checkString(request.getParameter("searchnatreg"));
	if(persid.length()>0){
		try{
			activePatient=null;
			activePatient = AdminPerson.getAdminPerson(Integer.parseInt(persid)+"");
	        session.setAttribute("activePatient",activePatient);
		    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
	        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
		    sessionContainerWO.setPersonVO(person);
		    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
		}
		catch(Exception e){}
	}
	else if(natreg.length()>0){
		if(natreg.length()>0){
			try{
				activePatient=null;
				personid=AdminPerson.getPersonIdByNatReg(natreg);
				if(personid!=null){
					activePatient = AdminPerson.getAdminPerson(Integer.parseInt(personid)+"");
			        session.setAttribute("activePatient",activePatient);
				    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
			        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
				    sessionContainerWO.setPersonVO(person);
				    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
				}
			}
			catch(Exception e){}
		}
	}
	else if(personid.length()>0){
		try{
			activePatient=null;
			activePatient = AdminPerson.getAdminPerson(Integer.parseInt(personid)+"");
	        session.setAttribute("activePatient",activePatient);
		    PersonVO person = MedwanQuery.getInstance().getPerson(activePatient.personid);
	        SessionContainerWO sessionContainerWO= (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName() );
		    sessionContainerWO.setPersonVO(person);
		    sessionContainerWO.setHealthRecordVO(MedwanQuery.getInstance().loadHealthRecord(person, null, sessionContainerWO));
		}
		catch(Exception e){}
	}
	session.removeAttribute("sptconcepts");
	if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
		out.println("<script>window.location.href='"+sCONTEXTPATH+"/html5/sptcomplaints.jsp?doc="+MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")+"';</script>");
		out.flush();
	}
%>
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
					<%
						if(activePatient==null){
							out.println(getTran(request,"web","patientrecorddoesnotexist",sWebLanguage));
					        if( natreg.length()>0 && MedwanQuery.getInstance().getConfigInt("enableSIS",0)==1 && activeUser.getAccessRight("patient.administration.add")){
						        %>
					            <br><br>
					            <img src="<%=sCONTEXTPATH%>/_img/themes/default/pijl.gif"/>&nbsp;<a href="javascript:loadFromSIS('<%=natreg%>')"  style='font-size:6vw;'><%=getTran(request,"web","create_person_from_sis",sWebLanguage)%></a><br/>[<%=getTran(request,"web","natreg",sWebLanguage)+": "+natreg%>]
					            <br/><span id='sisloader'/>
					        <%
					        }
						}
						else{
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						}
					%>
				</td>
			</tr>
			<%	
				if(activePatient!=null){
			%>
			<%	
				if(MedwanQuery.getInstance().getConfigInt("enableSIS",0)==1){
					Insurance insurance = Insurance.getDefaultInsuranceForPatient(activePatient.personid);
					if(insurance!=null && insurance.getInsurar().getAccreditationMechanism().equalsIgnoreCase("sis")){
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
								%>
								<tr onclick="window.location.href='getAccreditation.jsp';">
									<td style='font-size:6vw;text-align:right;padding:10px'>
										<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/check.png'/>
									</td>
									<td style='font-size:6vw;text-align:left;padding:10px'>
										<%=getTran(request,"web","accreditation",sWebLanguage) %>
									</td>
								</tr>
							<%
							}
							else{
							%>
								<tr onclick="getAccreditation()">
									<td style='font-size:6vw;text-align:right;padding:10px'>
										<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/accreditation.png'/>
									</td>
									<td style='font-size:6vw;text-align:left;padding:10px'>
										<%=getTran(request,"web","accreditation",sWebLanguage) %> <span id='accrdiv'/>
									</td>
								</tr>
							<%
							}
						}
						else{
							%>
							<tr onclick="getAccreditation()">
								<td style='font-size:6vw;text-align:right;padding:10px'>
									<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/accreditation.png'/>
								</td>
								<td style='font-size:6vw;text-align:left;padding:10px'>
									<%=getTran(request,"web","accreditation",sWebLanguage) %> <span id='accrdiv'/>
								</td>
							</tr>
						<%
						}
					}
				}
			%>
			<%if(Encounter.getActiveEncounter(activePatient.personid)!=null){ %>
			<tr onclick="window.location.href='getEncounter.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/encounter.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","activeencounter",sWebLanguage) %>
				</td>
			</tr>
			<%	}
			else{
			%>
			<tr onclick="window.location.href='createEncounter.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img style='opacity:0.3' src='<%=sCONTEXTPATH%>/_img/icons/mobile/encounter.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px;color:lightgrey'>
					<%=getTran(request,"web","activeencounter",sWebLanguage) %>
				</td>
			</tr>
			<%} %>
			<tr onclick="window.location.href='getAdmin.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/admin.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","admindata",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getVitalSigns.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/thermometer.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"openclinic.chuk","vital.signs",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getVaccinations.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/vacc.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","vaccinations",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getLab.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/lab.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","labresults",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getDrugs.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/drugs.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","drugprescriptions",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getImaging.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/xray.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","imaging",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='getExaminations.jsp';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/exam.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","examinations",sWebLanguage) %>
				</td>
			</tr>
			<tr onclick="window.location.href='<%=sCONTEXTPATH%>/html5/sptcomplaints.jsp?doc=<%=MedwanQuery.getInstance().getConfigString("templateSource")+MedwanQuery.getInstance().getConfigString("clinicalPathwayFiles","pathways.bi.xml")%>';">
				<td style='font-size:6vw;text-align:right;padding:10px'>
					<img src='<%=sCONTEXTPATH%>/_img/icons/mobile/knowledge.png'/>
				</td>
				<td style='font-size:6vw;text-align:left;padding:10px'>
					<%=getTran(request,"web","spt",sWebLanguage) %>
				</td>
			</tr>
			<%	
				}
			%>
		</table>
		<script>
			function loadFromSIS(dni){
				document.getElementById('sisloader').innerHTML="<img height='10px' src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/>";
				var url = '<%=sCONTEXTPATH%>/util/createPatientFromSIS.jsp?dni='+dni+'&ts='+new Date().getTime();
				new Ajax.Request(url,{
				  	method: "POST",
				  	postBody: '',
				  	onSuccess: function(resp){
					    var s=eval('('+resp.responseText+')');
					    if(s.success==1){
					    	window.location.href='getPatient.jsp?searchpersid='+s.personid;
				    	}
					    else {
					    	document.getElementById('sisloader').innerHTML="<br/><span style='font-size:4vw;'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_error.gif'/> "+s.error+"</span>";
					    }
				  	},
				  	onFailure: function(){
				    	document.getElementById('sisloader').innerHTML="<br/><span style='font-size:4vw;'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_error.gif'/> <%=getTranNoLink("web","error.searching.sis.database",sWebLanguage)%></span>";
				  	}
				});
			}
			
			function getAccreditation(){
				document.getElementById('accrdiv').innerHTML="<img height='10px' src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/>";
				window.location.href='getAccreditation.jsp';
			}
		</script>
		
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>