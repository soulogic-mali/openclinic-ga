<%@page import="be.openclinic.mpi.SearchPatient"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE %>
<%
	boolean bDoSearch=false;
	String selectmpiid = checkString(request.getParameter("selectmpiid"));
	SearchPatient sp = new SearchPatient(checkString(request.getParameter("mpiid")),
			checkString(request.getParameter("healthfacility")),
			checkString(request.getParameter("healthfacilityid")),
			checkString(request.getParameter("lastname")),
			checkString(request.getParameter("firstname")),
			checkString(request.getParameter("dateofbirth")),
			checkString(request.getParameter("telephone")),
			checkString(request.getParameter("email")),
			checkString(request.getParameter("natreg")));

	if(sp.isEmpty() && activePatient!=null){
		selectmpiid=ScreenHelper.convertToUUID(activePatient.personid);
		bDoSearch=true;
	}
	
	Hashtable<String,AdminPerson> persons = new Hashtable();
	boolean bShowResults = false;
	SortedMap sortedPatients = new TreeMap();
	
	if(bDoSearch || request.getParameter("searchExactButton")!=null){
		bShowResults=true;
		String oldmpiid=sp.mpiid;
		if(selectmpiid.length()>0){
			sp.mpiid=selectmpiid;
		}
		sortedPatients = sp.searchExact(persons);
		if(selectmpiid.length()>0){
			sp.mpiid=oldmpiid;
		}
	}
	else if(request.getParameter("searchMPIButton")!=null){
		bShowResults=true;
		String oldmpiid=sp.mpiid;
		if(selectmpiid.length()>0){
			sp.mpiid=selectmpiid;
		}
		sortedPatients = sp.searchProbabilistic(persons);
		if(selectmpiid.length()>0){
			sp.mpiid=oldmpiid;
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='selectmpiid' id='selectmpiid' value=''/>
	<h1><%=getTran(request,"web","searchpatient",sWebLanguage) %></h1>
	<table width='100%'>
		<tr>
			<td width='50%'>
				<table>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","mpiid",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='mpiid' id='mpiid' value="<%=sp.mpiid %>" size='15'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","natreg",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='natreg' value="<%=sp.natreg %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","lastname",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='lastname' value="<%=sp.lastname %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","firstname",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='firstname' value="<%=sp.firstname %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","dateofbirth",sWebLanguage) %></td>
						<td>
							<%=ScreenHelper.writeDateFieldMPI("dateofbirth", "transactionForm", sp.dateofbirth, true, false, sWebLanguage, sCONTEXTPATH,"20	px") %>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='telephone' value="<%=sp.telephone %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","email",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='email' value="<%=sp.email %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","healthfacilityid",sWebLanguage) %></td>
						<td nowrap>
							<select class='inputfind' name='healthfacility'>
								<option/>
								<%= ScreenHelper.writeSelect(request, "mpi.facility", sp.healthfacility, sWebLanguage)%>
							</select>
							<input class='inputfind' type='text' name='healthfacilityid' value="<%=sp.healthfacilityid %>" size='15'/>
						</td>
					</tr>
					<tr>
						<td/>
						<td>
							<br/>
							<input type='submit' name='searchExactButton' id='searchExactButton' value="<%=getTranNoLink("web","searchexact",sWebLanguage) %>"/>&nbsp;
							<input type='submit' name='searchMPIButton' id='searchMPIButton' value="<%=getTranNoLink("web","searchmpi",sWebLanguage) %>"/>
						</td>
					</tr>
				</table>
			</td>
			<td>
			<% 	
				if(bShowResults){
					out.println("<table width='100%' style='padding-left: 15px'>");
					if(persons.size()==0){
						out.println("<tr><td><img height='24px' style='vertical-align:middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/delete.png'> "+getTran(request,"web","noresultsfound",sWebLanguage)+"</td></tr>");
					}
					else if(persons.size()==1){
						out.println("<script>document.getElementById('menu_pacs').style.display='';</script>");
						AdminPerson p = persons.get(persons.keys().nextElement());
						session.setAttribute("activePatient",p);
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","mpiid",sWebLanguage)+":&nbsp;</td><td class='tdredbold'>"+ScreenHelper.convertToUUID(p.personid)+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","lastname",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.lastname+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","firstname",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.firstname+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","dateofbirth",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.dateOfBirth+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","gender",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+getTranNoLink("gender",p.gender,sWebLanguage)+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","telephone",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.getActivePrivate().telephone+"</td></tr>");
						out.println("<tr><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","mobile",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.getActivePrivate().mobile+"</td></tr>");
						out.println("<tr class='border_bottom'><td class='tdgrey' nowrap width='1%'>"+getTran(request,"web","email",sWebLanguage)+":&nbsp;</td><td class='tdblackbold'>"+p.getActivePrivate().email+(activeUser.isAdmin() && c(p.getActivePrivate().email).length()>0?"&nbsp;&nbsp;&nbsp;<input type='button' onclick='generateLogin()' name='generateButton' value='"+getTranNoLink("web","generatelogin",sWebLanguage)+"'/>":"")+"</td></tr>");
						//Now print all alternate identifiers
						StringBuffer sIdentifiers = new StringBuffer();
						Iterator<String> iExtends = p.adminextends.keySet().iterator();
						while(iExtends.hasNext()){
							String key = iExtends.next();
							if(key.startsWith("facilityid$")){
								String sValue=(String)p.adminextends.get(key);
								sIdentifiers.append("<tr><td class='smallgrey' nowrap width='1%'>"+getTran(request,"mpi.facility",key.replaceAll("facilityid\\$",""),sWebLanguage)+":&nbsp;</td><td class='smallblackbold'>"+sValue+"</td></tr>");
							}
						}
						if(sIdentifiers.length()>0){
							out.println("<tr style='background-color: #808080;color:white;font-size: 1vw;font-weight: bolder;text-align: center'><td colspan='2'>"+getTran(request,"web","healthfacilityids",sWebLanguage)+"</td></tr>"+sIdentifiers.toString());
						}
						
					}
					else{
						Iterator iPatients = sortedPatients.keySet().iterator();
						while(iPatients.hasNext()){
							String key=(String)iPatients.next();
							AdminPerson p = (AdminPerson)sortedPatients.get(key);
							out.println("<tr class='border_bottom'>");
							String score="";
							if(p.adminextends.get("mpimatch")!=null){
								score="<table width='80%' cellpadding='0' cellspacing='0'><tr class='border_box'><td style='background-color: green' height='15px' width='"+(Double.parseDouble((String)p.adminextends.get("mpimatch"))*100/1340)+"%'></td><td style='background-color: white' width='*'></td><tr></table>";
							}
							out.println("<td><a href='javascript:find(\""+ScreenHelper.convertToUUID(p.personid)+"\")'><font class='smallredbold'>"+ScreenHelper.convertToUUID(p.personid)+"</font></a><br/>"+score+"</td>");
							out.println("<td><font class='smallblackbold'>"+p.getFullName()+"</font><br/><font class='smallgrey'>"+p.getID("natreg")+"</font></td>");
							out.println("<td class='smallgrey'>"+getTranNoLink("gender",p.gender,sWebLanguage)+"<br/>"+p.getActivePrivate().telephone+"</td>");
							out.println("<td class='smallgrey'>"+p.dateOfBirth+"<br/>"+p.getActivePrivate().email+"</td>");
							out.println("</tr>");
						}
					}
					out.println("</table>");
				} 
			%>
			</td>
		</tr>
	</table>	
</form>

<script>
	function find(mpiid){
		document.getElementById("selectmpiid").value=mpiid;
		document.getElementById("searchExactButton").click();
	}

<% if(activePatient!=null){%>
  function generateLogin(){
	  var params="";
	  var elements = document.all;
		var url = "<%=sCONTEXTPATH%>/mpi/generatePatientLogin.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			alert('<%=getTranNoLink("web","loginsentto",sWebLanguage)+" "+activePatient.getActivePrivate().email%>');
		}
		});
  }
<%}%>
</script>
