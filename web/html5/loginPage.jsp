<!DOCTYPE html>
<%@include file="/mobile/_common/helper.jsp"%>
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<style>
	TD.mobileadmin {
	 color:#505050;
	 font-family: Raleway, Geneva, sans-serif;
	 font-weight:bolder;
	 text-align:center;
	 padding:10px;
	 border-left:5px solid #C3D9FF;
	 background-color:#C3D9FF;
	}
</style>
<link href='../_common/_css/raleway.css' rel='stylesheet'>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OpenClinic Login</title>
<%	
    // log in
    if(request.getParameter("login")!=null && request.getParameter("login").equalsIgnoreCase("1")){
		session.setAttribute("activeUser",null);
    }
	String username = request.getParameter("username"),
	       password = request.getParameter("password");

	String sMsg = "";
	if(username!=null && password!=null && username.length()>0 && password.length()>0){
		User activeUser = new User();
		
		// fetch user
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		if(activeUser.initialize(conn,username,password)){
			reloadSingleton(session);
			session.setAttribute("activeUser",activeUser);
            session.setAttribute("WebLanguage",activeUser.person.language.toLowerCase());
        	if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("spt")){
				out.print("<script>window.location.href='welcomespt.jsp';</script>");
        	}
        	if(MedwanQuery.getInstance().getConfigString("mobile.edition","").equalsIgnoreCase("gmao")){
				out.print("<script>window.location.href='welcomegmao.jsp';</script>");
        	}
        	else{
				out.print("<script>window.location.href='welcome.jsp';</script>");
        	}
			out.flush();
		}
		else{
			sMsg = "Invalid credentials"; // no user, no language
		}
	}
	else if((username!=null && username.length()>0) || (password!=null && password.length()>0)){
		sMsg = "Incomplete credentials"; // no user, no language
	}
%>

<html>
	<body>
		<form name='transactionForm' method='post'>
			<table width='100%' cellpadding='0' cellspacing='0'>
				<tr>
					<td colspan='2' style='text-align:center;'><img style="max-width:100%;max-height:150px;" src='<%=MedwanQuery.getInstance().getConfigString("mobileLoginLogo","../_img/openclinic_logo.jpg") %>'/></td>
				</tr>
				<tr>
					<td colspan='2'>
						<table width='100%' style='border: 1px solid #004369;background-color: #f2f2f2'>
							<tr>
								<td colspan='2'><br/></td>
							</tr>
							<tr>
								<td width='30%' style='font-size: 4vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>Login:</td>
								<td width='70%' style='text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'><input style='padding:5px; font-size: 6vw;border: 1px solid #cccccc;background-color: #ffffe6;color: #cccccc' type='text' name='username' size='10'/></td>
							</tr>
							<tr>
								<td colspan='2'><br/></td>
							</tr>
							<tr>
								<td width='30%' style='font-size: 4vw;text-align:right;padding=10px;font-family: Raleway, Geneva, sans-serif;'>Password:</td>
								<td width='70%' style='text-align:left;padding=10px;font-family: Raleway, Geneva, sans-serif;'><input style='padding:5px; font-size: 6vw;border: 1px solid #cccccc;background-color: #ffffe6;color: #cccccc' type='password' name='password' size='10'/></td>
							</tr>
							<tr>
								<td colspan='2'><br/></td>
							</tr>
							<tr>
								<td width='30%'></td>
								<td width='70%'><input style='font-size: 5vw;height: 8vw;padding=10px;font-family: Raleway, Geneva, sans-serif;' type='submit' name='login' value='Login'/></td>
							</tr>
							<tr>
								<td colspan='2'><br/></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan='2'>&nbsp;</td>
				</tr>
				<tr>
					<td colspan='2' style='text-align:center;padding=10px;font-family: Raleway, Geneva, sans-serif;'><%=sMsg %></td>
				</tr>
			</table>
		</form>
	</body>
</html>
