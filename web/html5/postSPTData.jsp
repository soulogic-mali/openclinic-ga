<%@page import="be.openclinic.knowledge.SPT"%>
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
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    if(activeUser==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
%>
		<%=sCSSNORMAL %>
		<title><%=getTran(request,"web","activeencounter",sWebLanguage) %></title>
		<table style='width:100%'><tr>
			<tr>
				<td style='font-size:8vw;text-align: right'>
					<img onclick="window.location.href='../html5/welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
				</td>
			</tr>
		<%
			if(SPT.postSPTData()){
		%>
			<td style='font-size:6vw;text-align:center;padding:10px'>
				<%=getTran(request,"web","sptpostsuccessful",sWebLanguage) %>
			</td>
			
		<%
			}
			else{
		%>
			<td style='font-size:6vw;text-align:center;padding:10px'>
				<%=getTran(request,"web","sptpostnotsuccessful",sWebLanguage) %>
			</td>
		<%
			}
		%>
		</tr></table>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
		
<%
    }
%>