<%@page import="be.mxs.common.util.system.UpdateSystem"%>
<%@include file="/includes/helper.jsp"%>
<%
String sWebLanguage="en";
if(request.getParameter("language")!=null){
	sWebLanguage=request.getParameter("language");
}
boolean bMessageSent = false;
String sMessage="";
String sUserName=c(request.getParameter("username"));
if(c(request.getParameter("sendPassword")).length()>0 && sUserName.length()>0){
	int nUserId = User.getUseridByAlias(sUserName);
	if(nUserId>-1){
		User user = User.getByAlias(sUserName);
		if(user!=null && user.person!=null && c(user.person.getActivePrivate().email).length()>0 && SH.isValidEmailAddress(user.person.getActivePrivate().email)){
			bMessageSent=user.person.sendMPIRegistrationMessage();
		}
	}
	else{
		try{
			User user=User.get(Integer.parseInt(sUserName));
			if(user!=null && user.person!=null && c(user.person.getActivePrivate().email).length()>0 && SH.isValidEmailAddress(user.person.getActivePrivate().email)){
				bMessageSent=user.person.sendMPIRegistrationMessage();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	if(!bMessageSent){
		int personid = SH.convertFromUUID(sUserName);
		if(personid>-1){
			AdminPerson person = AdminPerson.get(personid+"");
			if(person!=null && c(person.getActivePrivate().email).length()>0 && SH.isValidEmailAddress(person.getActivePrivate().email)){
				bMessageSent=person.sendMPIRegistrationMessage();
			}
		}
	}
	if(bMessageSent){
		sMessage=getTranNoLink("web","passwordmessagesent",sWebLanguage);
	}
	else{
		sMessage=getTranNoLink("web","passwordmessagenotsent",sWebLanguage);
	}
}

%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%=sCSSNORMAL %>
<title><%=getTranNoLink("web","KHIN",sWebLanguage) %></title>
<html>
	<head>
		<%=sKHINFAVICON %>
	</head>
	<body>
		<form name='transactionForm' method='post'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#FFFFFF">
			    <tr>
			        <td align="center" style="vertical-align:top;" width="1%">
			            <a href='https://khin.rw'><img height='200px' src="<%=MedwanQuery.getInstance().getConfigString("mpiLoginLogo","https://khin.rw/khin/projects/khin/_img/logo_print.gif") %>" border="0"></a>
						<br/>&nbsp;<br/>&nbsp;<br/>&nbsp;<br/>
			        </td>
			    </tr>
					<td>
						<center>
							<table>
								<tr>
									<td nowrap style='font-size: 1.5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<%=getTranNoLink("web","login",sWebLanguage) %>:&nbsp;
									</td>
									<td nowrap style='font-size: 1.5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<input style='padding:5px; font-size: 1.5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='text' name='username' value="<%=sUserName %>" size='15'/>
									</td>
								</tr>
								<tr>
									<td/>
									<td nowrap style='font-size: 1.5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<input style='padding:5px; font-size: 1.5vw;border: 1px solid #cccccc' type='submit' name='sendPassword' value="<%=getTranNoLink("web","sendpassword",sWebLanguage) %>"/>
									</td>
								</tr>
							</table>
							<table>
								<% if(sMessage.length()>0){ %>
								<tr>
									<td colspan='2' style='font-size: 1.5vw;text-align:center;color=red;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
										<font style='padding:5px; font-size: 1.5vw;color: red;font-weight: bolder'><%=sMessage %></font>
									</td>
								</tr>
								<% } %>
								<tr>
									<td colspan='2' style='font-size: 1vw;border-bottom:1px solid lightgrey;text-align: center'><br/>&nbsp;<br/>&nbsp;<br/></td>
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