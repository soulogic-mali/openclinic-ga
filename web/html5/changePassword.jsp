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
<%
	if(checkString(request.getParameter("adminpassword")).length()>0){
		User user = User.getByAlias("admin");
		byte[] aNewPassword = user.encrypt(request.getParameter("adminpassword"));
	    user.password = aNewPassword;
	    user.savePasswordToDB();
	}
	if(checkString(request.getParameter("userpassword")).length()>0){
		User user = User.getByAlias("user");
		byte[] aNewPassword = user.encrypt(request.getParameter("userpassword"));
        user.password = aNewPassword;
        user.savePasswordToDB();
	}
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web.userprofile","changepassword",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<table width='100%'>
				<tr>
					<td style='font-size:8vw;text-align: left'></td>
					<td style='font-size:8vw;text-align: right'>
						<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='../html5/welcomespt.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web.userprofile","changepassword",sWebLanguage) %></td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						admin:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='password' name='adminpassword' value="" size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%' style='font-size: 5vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						user:&nbsp;
					</td>
					<td width='70%' style='font-size: 5vw;text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'>
						<input style='padding:5px; font-size: 5vw;border: 1px solid #cccccc;background-color: #ffffe6' type='password' name='userpassword' value="" size='15'/>
					</td>
				</tr>
				<tr>
					<td width='30%'></td>
					<td width='70%'>
						<input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>
