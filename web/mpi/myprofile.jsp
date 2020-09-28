<%@include file="/includes/validateUser.jsp"%>
<%
	if(activeUser.getParameter("patientid").length()>0){
		out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpiMain.jsp?Page=mpi/patientprofile.jsp';</script>");
		out.flush();
	}
	String sLanguage = c(request.getParameter("language"));
	String sPassword = c(request.getParameter("password"));
	String sEmail = c(request.getParameter("email"));
	String sUserProfile="";
	String sUserProfileId=c(activeUser.getParameter("userprofileid"));
	if(sUserProfileId.length()>0){
		UserProfile profile = UserProfile.getUserProfileById(Integer.parseInt(sUserProfileId));
		if(profile!=null){
			sUserProfile=profile.getUserprofilename();
		}
	}
	boolean bUpdateUser=false;
	if(sLanguage.length()>0 && !sLanguage.equalsIgnoreCase(activeUser.getParameter("userlanguage"))){
		activeUser.setParameter("userlanguage", sLanguage);
		bUpdateUser=true;
	}
	if(sPassword.length()>0){
		activeUser.password = activeUser.encrypt(sPassword);
		bUpdateUser = true;
	}
	if(sEmail.length()>0 && !sEmail.equalsIgnoreCase(activeUser.person.getActivePrivate().email)){
		activeUser.person.getActivePrivate().email = sEmail;
		activeUser.person.store();
		bUpdateUser = true;
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='formaction' id='formaction'/>
	<h1><%=getTran(request,"web","profileof",sWebLanguage) %> <%=activeUser.person.getFullName() %></h1>
	<table width='100%'>
		<tr>
			<td width='50%'>
				<table width='100%'>
					<tr>
						<td colspan='2' class='invertedgrey'><%=getTran(request,"web","identification",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","login",sWebLanguage) %></td>
						<td>
							<font style='font-weight: bolder; color: black'>&nbsp;<%=activeUser.userid %></font>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web.userprofile","userprofile",sWebLanguage) %></td>
						<td>
							<font style='font-weight: bolder; color: black'>&nbsp;<%=sUserProfile %></font>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","language",sWebLanguage) %></td>
						<td>
							<select class='inputfind' name='language' id='language'>
								<%
									String[] languages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en").split(",");
									for(int n=0;n<languages.length;n++){
										out.println("<option "+(languages[n].equalsIgnoreCase(activeUser.getParameter("userlanguage"))?"selected":"")+" value='"+languages[n]+"'>"+getTranNoLink("web.language",languages[n],sWebLanguage)+"</option>");							
									}
								%>
							</select>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","password",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='password' name='password' value="" size='30'/>
						</td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","email",sWebLanguage) %></td>
						<td>
							<input class='inputfind' type='text' name='email' value="<%=c(activeUser.person.getActivePrivate().email) %>" size='30'/>
						</td>
					</tr>
					<tr>
						<td/>
						<td>
							<br/>
							<input type='submit' name='updateButton' id='updateButton' value="<%=getTranNoLink("web","update",sWebLanguage) %>"/>&nbsp;
						</td>
					</tr>
				</table>
			</td>
			<td width='50%'>
				<table width='100%'>
					<tr>
						<td colspan='3' class='invertedgrey'><%=getTran(request,"web","accessrights",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","masterpatientindex",sWebLanguage) %></td><td class='tdgrey'><%=getTran(request,"web","readright",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.mpi.select")?"yes":"no",sWebLanguage) %></font></td><td class='tdgrey'><%=getTran(request,"web","write",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.mpi.add")?"yes":"no",sWebLanguage) %></font></td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","pacs",sWebLanguage) %></td><td class='tdgrey'><%=getTran(request,"web","readright",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.pacs.select")?"yes":"no",sWebLanguage) %></font></td><td class='tdgrey'><%=getTran(request,"web","write",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.pacs.add")?"yes":"no",sWebLanguage) %></font></td>
					</tr>
					<tr>
						<td class='tdgrey'><%=getTran(request,"web","fhirapi",sWebLanguage) %></td><td class='tdgrey'><%=getTran(request,"web","readright",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.api.select")?"yes":"no",sWebLanguage) %></font></td><td class='tdgrey'><%=getTran(request,"web","write",sWebLanguage) %>: <font style='color:black; font-weight: bolder'><%=getTran(request,"web",activeUser.getAccessRight("mpi.api.add")?"yes":"no",sWebLanguage) %></font></td>
					</tr>
				</table>				
			</td>
		</tr>
	</table>
</form>
<%
	if(c(request.getParameter("formaction")).equalsIgnoreCase("updated")){
		out.println(getTran(request,"web","theprofilewasupdated",sWebLanguage));
	}
	if(bUpdateUser){
		activeUser.saveToDB();
		session.setAttribute(sAPPTITLE+"WebLanguage",sLanguage);
		out.println("<script>document.getElementById('formaction').value='updated';transactionForm.submit()</script>");
		out.flush();
	}
%>