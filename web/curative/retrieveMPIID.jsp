<%@page import="be.openclinic.mpi.SearchPatient"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>

<%
	String mpiid = checkString(request.getParameter("mpiid"));
	AdminPerson person = AdminPerson.getMPI(mpiid);
	if(person!=null && person.adminextends.get("mpiid")!=null){
		AdminPrivateContact apc = person.getActivePrivate();
%>
	<table width='100%'>
		<tr>
			<td width='50%'>
				<table width='100%'>
					<tr class='admin'>
						<td><%=getTran(request,"web","field",sWebLanguage) %></td>
						<td colspan='2'><%=getTran(request,"web","mpivalue",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","MPIID",sWebLanguage) %></td>
						<td class='admin2'><font style='font-size:14px;font-weight: bolder' color='red'><%=checkString((String)person.adminextends.get("mpiid")) %></font></td>
						<td class='admin2'><input type='button' class='redbutton' name='importmpiidButton' onclick='importmpiid("<%=checkString((String)person.adminextends.get("mpiid")) %>");' value='<%=getTranNoLink("web","importthisid",sWebLanguage)%>'/></td>
					</tr>
					<tr valign='middle'>
						<td class='admin' nowrap><%=getTran(request,"web","natreg",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><b><%=person.getID("natreg")%></b></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","lastname",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><b><%=checkString(person.lastname)%></b></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","firstname",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><b><%=checkString(person.firstname).toUpperCase()%></b></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","dateofbirth",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><b><%=checkString(person.dateOfBirth)%></b></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","gender",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=getTranNoLink("gender",checkString(person.gender),sWebLanguage)%></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","language",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=getTranNoLink("web.language",checkString(person.language),sWebLanguage)%></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","address",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.address)%></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","city",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.city)%></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","zipcode",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.zipcode)%></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","district",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.district) %></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","country",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=getTranNoLink("country",checkString(apc.country),sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","telephone",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.telephone) %></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","mobile",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.mobile) %></td>
					</tr>
					<tr>
						<td class='admin' nowrap><%=getTran(request,"web","email",sWebLanguage) %></td>
						<td class='admin2' colspan='2' nowrap><%=checkString(apc.email) %></td>
					</tr>
				</table>
			</td>
			<td width='50%' style='vertical-align: top'>
				<table width='100%'>
					<tr class='admin'>
						<td colspan="4"><%=getTran(request,"web","possibleexistingmatches",sWebLanguage) %></td>
					</tr>
					<%
						try{
							SearchPatient searchPatient = new SearchPatient(mpiid, MedwanQuery.getInstance().getConfigString("hin.server.identifier","hin.facility.undefined"), checkString(person.adminextends.get(MedwanQuery.getInstance().getConfigString("hin.server.identifier","hin.facility.undefined"))), checkString(person.lastname), checkString(person.firstname), checkString(person.dateOfBirth), checkString(person.getActivePrivate().telephone), checkString(person.getActivePrivate().email), checkString(person.getID("natreg")));
							Hashtable<String,AdminPerson> h = new Hashtable<String,AdminPerson>();
							SortedMap<String,AdminPerson> pm = searchPatient.searchProbabilistic(h);
							Iterator<String> iPatients = pm.keySet().iterator();
							while(iPatients.hasNext()) {
								String key = iPatients.next();
								AdminPerson p = pm.get(key);
								String score = "";
								if(p.adminextends.get("mpimatch")!=null){
									score="<br/><table width='80%' cellpadding='0' cellspacing='2px'><tr class='border_box'><td style='background-color: green' height='10px' width='"+(Double.parseDouble((String)p.adminextends.get("mpimatch"))*100/1340)+"%'></td><td style='background-color: white' width='*'></td><tr></table>";
								}
	
						%>
								<tr style='vertical-align: top'>
									<td class='admin' style='vertical-align: top'><b style='color:red;font-size: 12px'><%=checkString((String)p.adminextends.get("mpiid")).length()>0?p.adminextends.get("mpiid"):"<input type='button' class='button' value='"+getTranNoLink("web", "linkto", sWebLanguage)+" "+mpiid+"' onclick='linkMPIID(\""+mpiid+"\",\""+p.personid+"\",\"["+p.personid+"] "+p.getFullName()+" \")'" %></b><%=score %></td>
									<td class='admin2' style='vertical-align: top'><b>[<a style='font-weight: bolder' href='javascript:selectpatient(<%=p.personid%>)'><%=p.personid%></a>] <%=p.getFullName() %></b><br>°<%=p.dateOfBirth %> <%=getTranNoLink("gender",p.gender,sWebLanguage) %></td>
									<td class='admin2' style='vertical-align: top'><%=checkString(p.getID("natreg")) %></td>
									<td class='admin2' style='vertical-align: top'><%=checkString(p.getActivePrivate().telephone) %><br><%=checkString(p.getActivePrivate().email) %></td>
								</tr>
						<%
							}
						}
					catch(Exception e){
						e.printStackTrace();
					}
					%>
				</table>
			</td>
		</tr>
	</table>
<%
	}
	else{
%>
	<img src='<%=sCONTEXTPATH%>/_img/icons/icon_warning.gif'> <font style='font-size: 12px;color: red;font-weight:normal'><%=getTran(request,"web","personwithmpiid",sWebLanguage)+" </font><font style='font-size: 12px;color: red;font-weight:bolder'>"+mpiid+"</font><font style='font-size: 12px;color: red;font-weight:normal'> "+getTran(request,"web","doesnotexist",sWebLanguage) %></font>
	<% if(person.updateStatus.length()>0){ %>
		<br/><%=person.updateStatus %>
	<%} %>
<%
	}
%>