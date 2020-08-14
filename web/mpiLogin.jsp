<%@page import="be.mxs.common.util.system.UpdateSystem"%>
<%@include file="/includes/helper.jsp"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
	MedwanQuery.getInstance();
	String sWebLanguage="en";
	if(request.getParameter("language")!=null){
		sWebLanguage=request.getParameter("language");
	}
	UpdateSystem.reloadSingletonNoSession();
	String sUserName = checkString(request.getParameter("username"));
	String sPassword = checkString(request.getParameter("password"));
	String sMessage="";
	
	if(sUserName.length()>0 && sPassword.length()>0){
		byte[] aUserPassword = User.encrypt(sPassword);
		if(User.validate(sUserName, aUserPassword)){
			User user = null;
			int nUserId = User.getUseridByAlias(sUserName);
			if(nUserId>-1){
				user = User.getByAlias(sUserName);
			}
			else{
				try{
					user=User.get(Integer.parseInt(sUserName));
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
			if(user!=null && user.userid.length()>0 && User.hasPermission(user.userid,ScreenHelper.getSQLDate(new java.util.Date()))){
				session.setAttribute("activeUser",user);
                MedwanQuery.setSession(session,user);
				out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpi/mpiMain.jsp';</script>");
				out.flush();
			}
			else{
				sMessage=getTran(request,"web","invalidlogin",sWebLanguage);
			}
		}
		else{
			//Maybe this is patient login
			int personid = SH.convertFromUUID(sUserName);
			if(personid>-1){
				AdminPerson person = AdminPerson.get(personid+"");
				if(person.getID("candidate").equalsIgnoreCase(sPassword)){
					//This is patient login. We load a dummy user and set the parameter "patientid"
					User user = User.get(ci("mpiPatientUserId",4));
					user.setParameter("patientid", personid+"");
					user.setParameter("userlanguage", SH.c(person.language).length()>0 && SH.cs("supportedLanguages", "en").toLowerCase().contains(person.language.toLowerCase())?person.language.toLowerCase():"en");
					user.person=person;
					session.setAttribute("activeUser",user);
					session.setAttribute("activePatient",person);
	                MedwanQuery.setSession(session,user);
					out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpi/mpiMain.jsp';</script>");
					out.flush();
				}
				else if(person.comment.contains("*"+sPassword+"*")){
					//This is a one time login. We load a dummy user and set the parameter "patientid"
					User user = User.get(ci("mpiPatientUserId",4));
					user.setParameter("patientid", personid+"");
					user.setParameter("onetime", "1");
					user.setParameter("userlanguage", SH.c(person.language).length()>0 && SH.cs("supportedLanguages", "en").toLowerCase().contains(person.language.toLowerCase())?person.language.toLowerCase():"en");
					user.person=person;
					session.setAttribute("activeUser",user);
					session.setAttribute("activePatient",person);
	                MedwanQuery.setSession(session,user);
	                user.person.comment=user.person.comment.replaceAll("\\*"+sPassword+"\\*", "");
	                user.person.store();
					out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpi/mpiMain.jsp';</script>");
					out.flush();
				}
				else{
					sMessage=getTran(request,"web","invalidlogin",sWebLanguage);
				}
			}
			else{
				sMessage=getTran(request,"web","invalidlogin",sWebLanguage);
			}
		}
	}
	
	
%>
<%=sCSSNORMAL %>
<title><%=getTranNoLink("web","KHIN",sWebLanguage) %></title>
<html>
	<head>
		<%=sKHINFAVICON %>
	</head>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			    <tr>
			        <td align="center" style="vertical-align:top;" width="1%">
			            <img height='200px' src="<%=MedwanQuery.getInstance().getConfigString("mpiLoginLogo","https://khin.rw/khin/projects/khin/_img/logo_print.gif") %>" border="0">
						<br/>&nbsp;<br/>&nbsp;<br/>&nbsp;<br/>
			        </td>
			    </tr>
				<tr>
					<td>
						<center>
							<table>
								<tr>
									<td nowrap style='font-size: 1.5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<%=getTranNoLink("web","login",sWebLanguage) %>:&nbsp;
									</td>
									<td nowrap style='font-size: 1.5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<input style='padding:5px; font-size: 1.5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='username' value="" size='15'/>
									</td>
								</tr>
								<tr>
									<td nowrap style='font-size: 1.5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<%=getTranNoLink("web","password",sWebLanguage) %>:&nbsp;
									</td>
									<td nowrap style='font-size: 1.5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<input style='padding:5px; font-size: 1.5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='password' name='password' value="" size='15'/>
									</td>
								</tr>
								<tr>
									<td/>
									<td nowrap style='font-size: 1.5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<input style='padding:5px; font-size: 1.5vw;border: 1px solid #cccccc' type='submit' name='<%=getTranNoLink("web","login",sWebLanguage) %>' value="Login"/>
									</td>
								</tr>
								<% if(sMessage.length()>0){ %>
								<tr>
									<td colspan='2' style='font-size: 1.5vw;text-align:center;color=red;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<font style='padding:5px; font-size: 1.5vw;color: red;font-weight: bolder'><%=sMessage %></font>
									</td>
								</tr>
								<% } %>
								<tr>
									<td colspan='2' style='font-size: 1vw;border-bottom:1px solid lightgrey;text-align: center'><br/><a href='mpi/forgotPassword.jsp'><font style='font-size: 1vw;'><%=getTranNoLink("web","forgotpassword",sWebLanguage) %>?</font></a><br/>&nbsp;<br/>&nbsp;<br/></td>
								</tr>
								<tr>
									<td colspan='2' style='text-align: center'>
										&nbsp;<br/><img height='40px' src='<%=MedwanQuery.getInstance().getConfigString("mpiCredits","https://khin.rw/khin/projects/khin/_img/credits.png") %>'/>
									</td>
								</tr>
							</table>
						</center>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
