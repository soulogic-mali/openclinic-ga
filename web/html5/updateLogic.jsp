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
<%=sCSSNORMAL%>
<%=sJSPROTOTYPE%>
<%=sJSSCRPTACULOUS%>

<title><%=getTran(request,"web.userprofile","update",sWebLanguage) %></title>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='uploadForm' method='post' enctype='multipart/form-data' action='<c:url value="uploadFile.jsp"/>'>
				<input type='hidden' name='formaction' id='formaction'/>
				<table width='100%'>
					<tr>
						<td colspan='2' style='font-size:8vw;text-align: right'>
							<img onclick="window.location.reload()" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
							<img onclick="window.location.href='welcomespt.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTran(request,"web.userprofile","update",sWebLanguage) %>
							<img onclick='uploadForm.submit();' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/upload.png'/>
						</td>
					</tr>
					<tr>
		                <td nowrap>
							<input style='font-size:4vw;height: 30px' type='file' name='uploadFile'/>
		                </td>
		            </tr>
				</table>
			</form>
		</div>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>