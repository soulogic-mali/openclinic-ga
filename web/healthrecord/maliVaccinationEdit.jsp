<%@page import="be.openclinic.medical.Vaccination"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String date = checkString(request.getParameter("date"));
	if(date.length()==0){
		date=ScreenHelper.formatDate(new java.util.Date());
	}
	String type = checkString(request.getParameter("type"));
	String batchnumber = checkString(request.getParameter("batchnumber"));
	String expirydate = checkString(request.getParameter("expirydate"));
	String observationselector = checkString(request.getParameter("observationselector"));
	String observationcomment = checkString(request.getParameter("observationcomment"));
	String modifier = checkString(request.getParameter("modifier"));
	String vaccinationlocation = checkString(request.getParameter("vaccinationlocation"))+":"+checkString(request.getParameter("vaccinationlocationtext"));
	
	if(request.getParameter("submit")!=null){
		//Save this vaccination record
		Vaccination vaccination = new Vaccination();
		vaccination.personid=activePatient.personid;
		vaccination.type=type;
		vaccination.date=date;
		vaccination.batchnumber=batchnumber;
		vaccination.expiry=expirydate;
		vaccination.location=vaccinationlocation;
		vaccination.observation=observationselector+";"+observationcomment;
		vaccination.modifier=modifier;
		vaccination.save();
		out.println("<script>window.location.href='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/main.do?Page=/healthrecord/maliVaccinationCard.jsp';</script>");
		out.flush();
	}
	if(request.getParameter("delete")!=null){
		//Save this vaccination record
		Vaccination vaccination = new Vaccination();
		vaccination.personid=activePatient.personid;
		vaccination.type=type;
		vaccination.delete();
		out.println("<script>window.location.href='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/main.do?Page=/healthrecord/maliVaccinationCard.jsp';</script>");
		out.flush();
	}
	Vaccination vaccination = (Vaccination)Vaccination.getVaccinations(activePatient.personid).get(type);
	if(vaccination!=null && vaccination.date!=null && vaccination.date.trim().length()>0){
		if(vaccination.date!=null && vaccination.date.length()>0){
			date=vaccination.date;
		}
		batchnumber=vaccination.batchnumber;
		vaccinationlocation=vaccination.location;
		expirydate=vaccination.expiry;
		observationselector=checkString(vaccination.observation).split(";")[0];
		if(checkString(vaccination.observation).split(";").length>1){
			observationcomment=checkString(vaccination.observation).split(";")[1];
		}
		modifier=vaccination.modifier;
	}
	else {
		vaccinationlocation=MedwanQuery.getInstance().getConfigString("defaultVaccinationLocation","")+":";
	}
%>
<form name='transactionForm' method='post'>
	<table>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","editvaccination",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDateField("date", "transactionForm", date, true, false, sWebLanguage, sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='hidden' name="type" id="type" value="<%=type %>"/><%=getTran(request,"web",type,sWebLanguage) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batchnumber",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' name='batchnumber' id='batchnumber' value='<%=batchnumber%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","expirydate",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' name='expirydate' id='expirydate' value='<%=expirydate%>'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","vaccinationlocation",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='vaccinationlocation' id='vaccinationlocation' onchange='if(this.value==1){document.getElementById("vaccinationlocationtext").style.visibility="visible"} else {document.getElementById("vaccinationlocationtext").value="";document.getElementById("vaccinationlocationtext").style.visibility="hidden"}'>
					<%
						Hashtable labels=(Hashtable)((Hashtable)(MedwanQuery.getInstance().getLabels())).get(sWebLanguage.toLowerCase());
						if(labels!=null) labels=(Hashtable)labels.get("vaccinationlocation");
						if(labels!=null){
							Enumeration en = labels.keys();
							while(en.hasMoreElements()){
								String key = (String)en.nextElement();
								out.println("<option value='"+key+"' "+(key.equalsIgnoreCase(vaccinationlocation.length()>1?vaccinationlocation.substring(0,1):"")?"selected":"")+">"+((Label)labels.get(key)).value+"</option>");
							}
						}
					%>
					<option value='1' <%=(vaccinationlocation.length()>1 && vaccinationlocation.substring(0,1).equalsIgnoreCase("1"))?"selected":"" %>><%=getTran(request,"web","other",sWebLanguage) %></option>
				</select>
				<input type='text' name='vaccinationlocationtext' id='vaccinationlocationtext' value='<%=vaccinationlocation.length()>1?vaccinationlocation.substring(2):""%>'  size='80'/>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","observation",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='observationselector' id='observationselector' onchange='if(this.value==4){document.getElementById("observationcomment").style.visibility="visible"} else {document.getElementById("observationcomment").value="";document.getElementById("observationcomment").style.visibility="hidden"}'>
					<%=ScreenHelper.writeSelect(request,"malivaccinationobservations", observationselector, sWebLanguage) %>
				</select>
				<input type='text' name='observationcomment' id='observationcomment' value='<%=observationcomment%>'/>
			</td>
		</tr>
		<%
			if(type.toLowerCase().startsWith("polio")){
		%>
		<tr>
			<td class='admin'><%=getTran(request,"web","vaccinationmodifier",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='modifier' id='modifier'>
					<%=ScreenHelper.writeSelect(request,"malivaccinationmodifiers", modifier, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<%
			}
		%>
	</table>
	<input type='submit' class='button' name='submit' value='<%=getTran(null,"web","save",sWebLanguage)%>'/>
	<input type='submit' class='button' name='delete' value='<%=getTran(null,"web","delete",sWebLanguage)%>'/>
</form>
<script>
	if(document.getElementById("vaccinationlocation").value==1){document.getElementById("vaccinationlocationtext").style.visibility="visible"} else {document.getElementById("vaccinationlocationtext").value="";document.getElementById("vaccinationlocationtext").style.visibility="hidden"};
	document.getElementById("observationselector").onchange();
</script>