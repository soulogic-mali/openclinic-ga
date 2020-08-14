<%@page import="be.openclinic.medical.Diagnosis"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="be.openclinic.finance.Debet"%>
<%@page import="be.openclinic.finance.Prestation"%>
<%@page import="pe.gob.sis.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"financial.fua","edit",activeUser)%>
<%
	String encounteruid = checkString(request.getParameter("encounteruid"));
	String fuauid = checkString(request.getParameter("fuauid"));
	FUA fua = null;
	if(fuauid.length()>0){
		fua = FUA.get(fuauid);
		if(checkString(request.getParameter("update")).equalsIgnoreCase("1")){
			fua.update();
		}
		if(request.getParameter("initializeButton")!=null){
			fua.initialize();
		}
	}
	else if(encounteruid.length()>0){
		fua = FUA.createFromEncounter(encounteruid,Integer.parseInt(activeUser.userid));
	}
	if(request.getParameter("submitButton")!=null || request.getParameter("storefingerprint")!=null ){
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parname = (String)pars.nextElement();
			if(parname.startsWith("VALUE_")){
				fua.getAtencion().setValue(Integer.parseInt(parname.substring(6)), request.getParameter(parname));
			}
		}
		if(checkString(request.getParameter("storefingerprint")).equalsIgnoreCase("1")){
			try{
				java.io.ByteArrayOutputStream baos = new java.io.ByteArrayOutputStream();
				javax.imageio.ImageIO.write( (BufferedImage)session.getAttribute("fingerprintjpg"), "jpg", baos );
				baos.flush();
				fua.setPatientFingerPrint(baos.toByteArray());
				fua.setPatientSignatureDateTime(new java.util.Date());
				baos.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		if(checkString(request.getParameter("storefingerprint")).equalsIgnoreCase("2")){
			try{
				fua.setPatientSignatureDateTime(new java.util.Date());
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		if(request.getParameter("status")!=null){
			fua.setStatus(request.getParameter("status"));
		}
		fua.store();
		fuauid=fua.getUid();
	}
	else{
		session.removeAttribute("fingerprintimage");
		session.removeAttribute("fingerprintjpg");
	}
	if(fua != null){
%>
<%
	String sFullName="";
	AdminPerson person = null;
	String natreg = checkString(fua.getAtencion().getValueString(73));
	if(natreg.length()>0){
		person = AdminPerson.getAdminPerson(AdminPerson.getPersonIdByNatReg(fua.getAtencion().getValueString(73)));
	}
	if(person!=null && person.lastname.length()>0){
		sFullName=person.getFullName();
	}
%>
<form name='transactionForm' id='transactionForm' method='post'>
	<input type='hidden' name='status' id='status' value='<%=fua.getStatus() %>'/>
	<input type='hidden' name='fuauid' value='<%=fuauid %>'/>
	<input type='hidden' name='storefingerprint' id='storefingerprint'/>
	<table width='100%' cellspacing='0' cellpadding='0'>
		<tr class="admin">
			<td>
				<%=getTran(request,"web","manageFUA",sWebLanguage) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<%
				String errors=fua.getErrors();
				if(errors.length()>0){
					%>
						<img src='<%=sCONTEXTPATH %>/_img/icons/icon_warning.gif'/> <a href='javascript:showErrors("<%=errors%>")'><%=getTran(request,"web","errorsdetected",sWebLanguage) %></a>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getTran(request,"web","status",sWebLanguage) %>: <%=getTran(request,"fua.status",fua.getStatus(),sWebLanguage) %>
					<%
				}
				else{
					%>
						<img src='<%=sCONTEXTPATH %>/_img/icons/icon_check.gif'/> <%=getTran(request,"web","noerrorsdetected",sWebLanguage) %>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=getTran(request,"seb","status",sWebLanguage) %>: <%=getTran(request,"fua.status",fua.getStatus(),sWebLanguage) %> 
					<%
				}
			%>
			</td>
		</tr>	
		<!-- Administrative header -->
		<tr class="admin">
			<td>
				<%=getTran(request,"web","encounter",sWebLanguage) %>
			</td>
		</tr>
		<tr>
			<td>
				<table width='100%' cellspacing='0'>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","fuaid",sWebLanguage) %></td>
						<% 	if(fuauid.length()==0){ %>
							<td class='admin2bold' nowrap><font style='color: red; font-weight: bolder;font-size: 12px'><%=fua.getAtencion().getValueString(2)+"."+fua.getAtencion().getValueString(3)+".</font><font style='color: gray; font-weight: bold;font-size: 12px;font-style: italic'>"+fua.getAtencion().getValueString(4) %></font></td>
						<%	}else{%>
							<td class='admin2bold' nowrap><font style='color: red; font-weight: bolder;font-size: 12px'><%=fua.getAtencion().getValueString(2)+"."+fua.getAtencion().getValueString(3)+"."+fua.getAtencion().getValueString(4) %></font></td>
						<%	}%>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","encounterid",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(1) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","udr",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(5) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","ipress",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(6) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","catipress",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=getTranNoLink("susalud.catipress",fua.getAtencion().getValueString(7),sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","reviewfuaid",sWebLanguage) %></td>
						<td class='admin2bold'><font style='color: gray; font-weight: bolder;font-size: 12px'><%=fua.getAtencion().getValueString(10).equalsIgnoreCase("N")?"":fua.getAtencion().getValueString(11)+"."+fua.getAtencion().getValueString(12)+"."+fua.getAtencion().getValueString(13) %></font></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","isreview",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(10) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","convention",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(14) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","componente",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("sis.regimen",fua.getAtencion().getValueString(15),sWebLanguage)%></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","formatoaseguid",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(16)+"."+fua.getAtencion().getValueString(17)+"."+fua.getAtencion().getValueString(18) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","correlativo",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(19) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","tabla.contrato",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(20) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","registrationnumber",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(21) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","coverageplan",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(22) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","populationgroup",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("sis.populationgroup",fua.getAtencion().getValueString(23),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","doctypeaseg",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("fua.doctype",fua.getAtencion().getValueString(24),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","docnumberaseg",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(25) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","lastnamefather",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=fua.getAtencion().getValueString(26) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","lastnamemother",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=fua.getAtencion().getValueString(27) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","firstnames",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=fua.getAtencion().getValueString(28) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","nacimiento",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(30) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","gender",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("sis.gender",fua.getAtencion().getValueString(31),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","ubigeoaseg",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(32) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","emr",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(33) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","caretype",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=getTranNoLink("urgency.origin",fua.getAtencion().getValueString(34),sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","fua.caremodality",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'>
							<%if(fua.getAtencion().getValueString(36).length()>0){ %>
							<b><%= getTran(request, "fua.caremodality", fua.getAtencion().getValueString(36), sWebLanguage)%></b>
							<%}else{ %>
							<select class='text' name='VALUE_36' id='VALUE_36'>
								<option/>
								<%=ScreenHelper.writeSelect(request, "fua.caremodality", fua.getAtencion().getValueString(36), sWebLanguage) %>
							</select>
							<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_save.gif' onclick='javascript:saveValue("VALUE_36")'/>
							<%} %>
						</td>
						<%if("*2*3*6*".contains("*"+fua.getAtencion().getValueString(36)+"*")){ %>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","fua.autorization",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><input type='text' class='text' size='15' name='VALUE_37' id='VALUE_37' value='<%=fua.getAtencion().getValueString(37) %>'/></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","fua.autorizationamount",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><input type='text' class='text' size='10' name='VALUE_38' id='VALUE_38' value='<%=fua.getAtencion().getValueString(38) %>'/></td>
						<%}else{ %>
						<td class='admin2' colspan='8'/>
						<%} %>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","caredate",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(39) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","ipressref",sWebLanguage) %></td>
						<td class='admin2bold' title='<%=getTranNoLink("ipress.renaes",fua.getAtencion().getValueString(40),sWebLanguage)%>'><%=fua.getAtencion().getValueString(40) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","refsheet",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(41) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","fua.prestationcode",sWebLanguage) %></td>
						<td class='admin2bold' colspan='5'>
							<%if(fua.getAtencion().getValueString(42).length()>0){ %>
							<b><%= getTran(request, "fua.prestationcode", fua.getAtencion().getValueString(42), sWebLanguage)%></b>
							<%}else{ %>
							<select class='text' name='VALUE_42' id='VALUE_42'>
								<option/>
								<%=ScreenHelper.writeSelect(request, "fua.prestationcode", fua.getAtencion().getValueString(42), sWebLanguage, false, true, 50) %>
							</select>
							<img style='vertical-align: middle' src='<%=sCONTEXTPATH %>/_img/icons/icon_save.gif' onclick='javascript:saveValue("VALUE_42")'/>
							<%} %>
						</td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","admission",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(46) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","discharge",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(47) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","destination",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=getTranNoLink("encounter.outcome.sis",fua.getAtencion().getValueString(45),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","ipress.contraref",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(48) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","sheet.contraref",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(49) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","datedeceased",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(59) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","etnia",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=getTranNoLink("sis.etnia",fua.getAtencion().getValueString(61),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","iafa",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("sis.iafa",fua.getAtencion().getValueString(62),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","iafacode",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(63)%></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","ups",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(64)%></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","corteadmin",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(65) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","udr.autorization",sWebLanguage) %></td>
						<td class='admin2bold' colspan='5'>
							<%if(fua.getAtencion().getValueString(66).length()>0){ %>
							<b><%= getTran(request, "fua.udr", fua.getAtencion().getValueString(66), sWebLanguage)%></b>
							<%}else{ %>
							<select class='text' name='VALUE_66' id='VALUE_66'>
								<option/>
								<%=ScreenHelper.writeSelect(request, "fua.udr", fua.getAtencion().getValueString(66), sWebLanguage, false, true, 50) %>
							</select>
							<%} %>
						</td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","lote.autorization",sWebLanguage) %></td>
						<td class='admin2bold'>
							<%if(fua.getAtencion().getValueString(67).length()>0){ %>
							<b><%= fua.getAtencion().getValueString(67)%></b>
							<%}else{ %>
							<input type='text' class='text' size='2' maxlength="2" name='VALUE_67' id='VALUE_67' value='<%=fua.getAtencion().getValueString(67) %>'/>
							<%} %>
						</td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","seq.autorization",sWebLanguage) %></td>
						<td class='admin2bold'>
							<%if(fua.getAtencion().getValueString(68).length()>0){ %>
							<b><%= fua.getAtencion().getValueString(68)%></b>
							<%}else{ %>
							<input type='text' class='text' size='6' maxlength="6" name='VALUE_68' id='VALUE_68' value='<%=fua.getAtencion().getValueString(68) %>'/>
							<%} %>
						</td>
					</tr>
					<tr>
						<td class='adminright'/>
						<td class='admin2bold'/>
						<%if(fua.getAtencion().getValueString(69).length()*fua.getAtencion().getValueString(70).length()*fua.getAtencion().getValueString(71).length()>0){ %>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","linkedfuauid",sWebLanguage) %></td>
						<td class='admin2bold' colspan='9'>
							<font style='color: gray; font-weight: bolder;font-size: 12px'><%=fua.getAtencion().getValueString(69).length()==0?"":fua.getAtencion().getValueString(69)+"."+fua.getAtencion().getValueString(70)+"."+fua.getAtencion().getValueString(71) %></font>
						</td>
						<%}else{ %>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","linkedfuadisa",sWebLanguage) %></td>
						<td class='admin2bold' colspan='5'>
							<%if(fua.getAtencion().getValueString(69).length()>0){ %>
							<b><%= getTran(request, "fua.disa", fua.getAtencion().getValueString(69), sWebLanguage)%></b>
							<%}else{ %>
							<select class='text' name='VALUE_69' id='VALUE_69'>
								<option/>
								<%=ScreenHelper.writeSelect(request, "fua.disa", fua.getAtencion().getValueString(69), sWebLanguage, false, true, 50) %>
							</select>
							<%} %>
						</td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","linkedfualote",sWebLanguage) %></td>
						<td class='admin2bold'>
							<input type='text' class='text' size='2' maxlength="2" name='VALUE_70' id='VALUE_70' value='<%=fua.getAtencion().getValueString(70) %>'/>
						</td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","linkedfuauid",sWebLanguage) %></td>
						<td class='admin2bold'>
							<input type='text' class='text' size='2' maxlength="2" name='VALUE_71' id='VALUE_71' value='<%=fua.getAtencion().getValueString(71) %>'/>
						</td>
						<%} %>
					</tr>
					
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","doctype.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("fua.doctype",fua.getAtencion().getValueString(72),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","docnumber.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(73) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","type.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("hr.contract.stafftype",fua.getAtencion().getValueString(74),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","specialty.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("hr.contractcode1",fua.getAtencion().getValueString(75),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","left.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=getTranNoLink("hr.contractcode2",fua.getAtencion().getValueString(76),sWebLanguage) %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","council.caregiver",sWebLanguage) %></td>
						<td class='admin2bold'><%=fua.getAtencion().getValueString(77) %></td>
					</tr>
					<tr>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","name.caregiver",sWebLanguage) %></td>
						<td class='admin2bold' colspan='3'><%=sFullName %></td>
						<td class='adminright' width='1%' nowrap><%=getTran(request,"fua","comment",sWebLanguage) %></td>
						<td class='admin2bold' colspan='7'><textarea  onKeyup="resizeTextarea(this,10);limitChars(this,255);" class='text' cols='60' rows="1" name='VALUE_84' id='VALUE_84'><%=fua.getAtencion().getValueString(84) %></textarea></td>
					</tr>
				</table>
			</td>
		</tr>	
		<tr>
			<td class='admin2'>
				<table width = '100%' cellspacing='0' cellpadding='0'>
					<tr>
						<td >
							<table width = '100%' cellspacing='0' cellpadding='0'>
		<!-- Diagnoses -->
		<%
				Hashtable fuadiagnoses = new Hashtable();
				if(fua.getDiagnosticos().size()>0){
		%>
		<tr class="admin">
			<td><%=getTran(request,"web","diagnoses",sWebLanguage) %></td>
		</tr>
		<tr>
			<td>
				<table width='100%' cellspacing='0'>
					<%
						for(int n=0;n<fua.getDiagnosticos().size();n++){
							Diagnosticos diagnosticos = (Diagnosticos)fua.getDiagnosticos().elementAt(n);
							String diag = diagnosticos.getValueString(2);
							if(diag.length()>3){
								diag=diag.substring(0,3)+"."+diag.substring(3);
							}
							fuadiagnoses.put(diagnosticos.getValueString(3),MedwanQuery.getInstance().getCodeTran("icd10code"+diag,sWebLanguage));
							%>
					<tr>
						<td class='admin' width='3%'><%=diagnosticos.getValueString(3) %></td>
						<td class='admin' width='7%'><%=diag %></td>
						<td class='admin2' width='50%'><b><%=fuadiagnoses.get(diagnosticos.getValueString(3)) %></b></td>
						<td class='admin2'><%=getTranNoLink("fua.diagnosistime",diagnosticos.getValueString(4),sWebLanguage) %></td>
						<td class='admin2'><%=getTranNoLink("fua.diagnosistype",diagnosticos.getValueString(5),sWebLanguage) %></td>
					</tr>
							<%	
						}
					%>
				</table>
			</td>
		</tr>
		<%
				}
		%>
		<!-- Drugs -->
		<%
				if(fua.getMedicamentos().size()>0){
		%>
		<tr class="admin">
			<td><%=getTran(request,"web","drugs",sWebLanguage) %></td>
		</tr>
		<tr>
			<td>
				<table width='100%' cellspacing='0'>
					<%
						for(int n=0;n<fua.getMedicamentos().size();n++){
							Medicamentos medicamentos = (Medicamentos)fua.getMedicamentos().elementAt(n);
							String digemid = medicamentos.getValueString(2);
							if(!FUA.isValidDIGEMID(digemid)){
								digemid="<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/>";
							}
							%>
					<tr>
						<td class='admin' width='10%'><%=digemid %></td>
						<td class='admin2' width='50%'><%=medicamentos.getValueString(5) %> x 
							<%
								String sName = "";
								if(medicamentos.getValueString(2).length()>0){
									//Find drugname based on DIGEMID code (nomenclature)
									Vector prestations = Prestation.getPrestationsByCodeAlias(medicamentos.getValueString(2));
									if(prestations.size()>0){
										Prestation prestation = (Prestation)prestations.elementAt(0);
										Debet debet = Debet.get(medicamentos.getValueString(8));
										if(checkString(debet.getInsurarInvoiceUid()).length()==0){
											sName="<font style='font-weight: bold;color: red'>"+prestation.getDescription()+"</font>";
										}
										else{
											sName="<b>"+prestation.getDescription()+"</b>";
										}
									}
								}
								if(sName.length()==0){
									Debet debet = Debet.get(medicamentos.getValueString(8));
									if(debet!=null){
										if(activeUser.getAccessRight("system.manageprestations.edit")){
											sName="<i>[<a href='javascript:managePrestation(\""+debet.getPrestationUid()+"\")'>"+debet.getPrestation().getDescription()+"</a>]</i>";
										}
										else{
											sName="<i>["+debet.getPrestation().getDescription()+"]</i>";
										}
									}
								}
								
							%>
						<%=sName %></td>
						<td class='admin2'><%=fuadiagnoses.get(medicamentos.getValueString(3))==null?"<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/> <a href='javascript:manageDebet(\""+medicamentos.getValueString(8)+"\")'>"+getTran(request,"web","diagnosismissing",sWebLanguage)+"</a>":activeUser.getAccessRight("fua.modifydiagnosis.edit")?"<a href='javascript:manageDebet(\""+medicamentos.getValueString(8)+"\")'>"+fuadiagnoses.get(medicamentos.getValueString(3))+"</a>":"<i>["+fuadiagnoses.get(medicamentos.getValueString(3))+"]</i>" %></td>
					</tr>
							<%	
						}
					%>
				</table>
			</td>
		</tr>
		<%
				}
		%>
		<!-- Consumables -->
		<%
				if(fua.getInsumos().size()>0){
		%>
		<tr class="admin">
			<td><%=getTran(request,"fua","insumos",sWebLanguage) %></td>
		</tr>
		<tr>
			<td>
				<table width='100%' cellspacing='0'>
					<%
						for(int n=0;n<fua.getInsumos().size();n++){
							Insumos insumos = (Insumos)fua.getInsumos().elementAt(n);
							String digemid = insumos.getValueString(2);
							if(!FUA.isValidDIGEMID(digemid)){
								digemid="<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/>";
							}
							%>
					<tr>
						<td class='admin' width='10%'><%=digemid %></td>
						<td class='admin2' width='50%'><%=insumos.getValueString(5) %> x 
							<%
								String sName = "";
								if(insumos.getValueString(2).length()>0){
									//Find drugname based on DIGEMID code (nomenclature)
									Vector prestations = Prestation.getPrestationsByCodeAlias(insumos.getValueString(2));
									if(prestations.size()>0){
										Prestation prestation = (Prestation)prestations.elementAt(0);
										Debet debet = Debet.get(insumos.getValueString(8));
										if(checkString(debet.getInsurarInvoiceUid()).length()==0){
											sName="<font style='font-weight: bold;color: red'>"+prestation.getDescription()+"</font>";
										}
										else{
											sName="<b>"+prestation.getDescription()+"</b>";
										}
									}
								}
								if(sName.length()==0){
									Debet debet = Debet.get(insumos.getValueString(8));
									if(debet!=null){
										if(activeUser.getAccessRight("system.manageprestations.edit")){
											sName="<i>[<a href='javascript:managePrestation(\""+debet.getPrestationUid()+"\")'>"+debet.getPrestation().getDescription()+"</a>]</i>";
										}
										else{
											sName="<i>["+debet.getPrestation().getDescription()+"]</i>";
										}
									}
								}
								
							%>
						<%=sName %></td>
						<td class='admin2'><%=fuadiagnoses.get(insumos.getValueString(3))==null?"<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/> <a href='javascript:manageDebet(\""+insumos.getValueString(8)+"\")'>"+getTran(request,"web","diagnosismissing",sWebLanguage)+"</a>":activeUser.getAccessRight("fua.modifydiagnosis.edit")?"<a href='javascript:manageDebet(\""+insumos.getValueString(8)+"\")'>"+fuadiagnoses.get(insumos.getValueString(3))+"</a>":"<i>["+fuadiagnoses.get(insumos.getValueString(3))+"]</i>" %></td>
					</tr>
							<%	
						}
					%>
				</table>
			</td>
		</tr>
		<%
				}
		%>
		<!-- Procedures -->
		<%
				if(fua.getProcedimientos().size()>0){
		%>
		<tr class="admin">
			<td><%=getTran(request,"fua","procedures",sWebLanguage) %></td>
		</tr>
		<tr>
			<td>
				<table width='100%' cellspacing='0'>
					<%
						for(int n=0;n<fua.getProcedimientos().size();n++){
							Procedimientos procedimientos = (Procedimientos)fua.getProcedimientos().elementAt(n);
							String cpt = procedimientos.getValueString(2);
							if(!FUA.isValidCPT(cpt)){
								cpt="<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/>";
							}
							%>
					<tr>
						<td class='admin' width='10%'><%=cpt %></td>
						<td class='admin2' width='50%'><%=procedimientos.getValueString(5) %> x 
							<%
								String sName = "";
								if(procedimientos.getValueString(2).length()>0){
									//Find procedure based on CPT code (nomenclature)
									Vector prestations = Prestation.getPrestationsByNomenclature(procedimientos.getValueString(2));
									if(prestations.size()>0){
										Prestation prestation = (Prestation)prestations.elementAt(0);
										Debet debet = Debet.get(procedimientos.getValueString(11));
										if(checkString(debet.getInsurarInvoiceUid()).length()==0){
											sName="<font style='font-weight: bold;color: red'>"+prestation.getDescription()+"</font>";
										}
										else{
											sName="<b>"+prestation.getDescription()+"</b>";
										}
									}
								}
								if(sName.length()==0){
									Debet debet = Debet.get(procedimientos.getValueString(11));
									if(debet!=null){
										if(activeUser.getAccessRight("system.manageprestations.edit")){
											sName="<i>[<a href='javascript:managePrestation(\""+debet.getPrestationUid()+"\")'>"+debet.getPrestation().getDescription()+"</a>]</i>";
										}
										else{
											sName="<i>["+debet.getPrestation().getDescription()+"]</i>";
										}
									}
								}
								
							%>
						<%=sName %></td>
						<td class='admin2'><%=fuadiagnoses.get(procedimientos.getValueString(3))==null?"<img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/> <a href='javascript:manageDebet(\""+procedimientos.getValueString(11)+"\")'>"+getTran(request,"web","diagnosismissing",sWebLanguage)+"</a>":activeUser.getAccessRight("fua.modifydiagnosis.edit")?"<a href='javascript:manageDebet(\""+procedimientos.getValueString(11)+"\")'>"+fuadiagnoses.get(procedimientos.getValueString(3))+"</a>":"<i>["+fuadiagnoses.get(procedimientos.getValueString(3))+"]</i>" %></td>
					</tr>
							<%	
						}
					%>
				</table>
			</td>
		</tr>
	<%
			}
	%>
		</table>
		</td>
		<td width='1%' valign='top' class='admin2'>
			<%
				if(fua.getPatientFingerPrint()!=null && fua.getPatientFingerPrint().length>0){
			%>
					<img style='text-align: middle;vertical-align: top;max-height: 150px' src='<%=sCONTEXTPATH%>/util/getFUAFingerprintJpg.jsp?fuauid=<%=fua.getUid()%>'/>
			<%
				}
			%>
		</td>
		</tr>
		</table>
		</td>
		</tr>
		<tr>
			<td>
				<center>
					<%if(!fua.getStatus().equalsIgnoreCase("closed") && errors.length()==0){ %>
						<input class='button' type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
					<%} %>
					<input class='button' type='button' name='listButton' value='<%=getTranNoLink("web","list",sWebLanguage) %>' onclick='loadList()'/>
					<%if(fua.hasValidUid()){ %>
						<%if(fua.getStatus().equalsIgnoreCase("open")){ %>
							<input class='button' type='submit' name='initializeButton' value='<%=getTranNoLink("web","reinitialize",sWebLanguage) %>'/>
						<%}
						  if(fuauid.length()>0){%>
								<input class='button' type='button' name='printButton' value='<%=getTranNoLink("web","print",sWebLanguage) %>' onclick='printFUA()'/>
					<%		}
						}
					  if(fua.getStatus().equalsIgnoreCase("open") && fua.getPatientSignatureDateTime()!=null){
					%>						
						<input class='button' type='button' name='closeButton' value='<%=getTranNoLink("web","close",sWebLanguage) %>'  onclick='closeFUA()'/>
					<%
					  }
					  if(fua.getStatus().equalsIgnoreCase("open") && fua.getPatientSignatureDateTime()==null){
					%>						
						<input class='button' type='button' name='signButton' value='<%=getTranNoLink("web","patientsignature",sWebLanguage) %>'  onclick='readFingerprintFUA()'/>
						<input class='button' type='button' name='signButton' value='<%=getTranNoLink("web","skippatientsignature",sWebLanguage) %>'  onclick='readFingerprintFUA(1)'/>
					<%
					  }
					%>
				</center>
			</td>
		</tr>
		<IFRAME style="display:none" name="hidden-form"></IFRAME>
		<script>
			function managePrestation(uid){
			    openPopup("/system/managePrestations.jsp&ts=<%=getTs()%>&EditPrestationUid="+uid+"&AutoAction=edit&PopupWidth=800&PopupHeight=600");
			}
			function manageDebet(uid){
			    openPopup("/financial/manageDebetDiagnosis.jsp&ts=<%=getTs()%>&uid="+uid+"&PopupWidth=600&PopupHeight=300");
			}
			function showErrors(errors){
			    openPopup("/financial/showFUAErrors.jsp&ts=<%=getTs()%>&errors="+errors+"&PopupWidth=600&PopupHeight=300");
			}
			function saveValue(value){
				window.open("<%=sCONTEXTPATH%>/financial/saveFUAValue.jsp?encounteruid=<%=fua.getEncounteruid()%>&type="+value+"&value="+document.getElementById(value).value,"hidden-form");
			}
			function printFUA(){
				window.open("<%=sCONTEXTPATH%>/financial/printFUA.jsp?fuauid=<%=fua.getUid()%>");
			}
			function closeFUA(){
				document.getElementById('status').value='closed';
				transactionForm.submit();
			}
			function readFingerprintFUA(noread){
			    <%
			        if(checkString(MedwanQuery.getInstance().getConfigString("referringServer")).length()==0){
			            %>openPopup("_common/readFingerPrintFUA.jsp&"+(noread?"noread=1&":"")+"ts=<%=getTs()%>&referringServer=<%="http://"+request.getServerName()+"/"+sCONTEXTPATH%>",400,100);<%
			        }
			        else{
			            %>openPopup("_common/readFingerPrintFUA.jsp&"+(noread?"noread=1&":"")+"ts=<%=getTs()%>&referringServer=<%=MedwanQuery.getInstance().getConfigString("referringServer")+sCONTEXTPATH%>",400,300);<%
			        }
			    %>
			}
			function loadList(){
				window.location.href='<%=sCONTEXTPATH%>/main.jsp?Page=financial/fuaEdit.jsp';
			}
		</script>
	<%
		}
	%>
	</table>
</form>

