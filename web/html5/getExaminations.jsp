<%@page import="be.openclinic.medical.*"%>
<%@page import="be.dpms.medwan.common.model.vo.administration.PersonVO"%>
<%@page import="be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO"%>
<%@page import="be.mxs.common.model.vo.healthrecord.*,be.mxs.common.model.vo.healthrecord.util.*"%>
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
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
%>
<%=sCSSNORMAL %>
<title><%=getTran(request,"web","examinations",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getExaminations.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
						<img onclick="window.location.href='welcome.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
						<%
							out.println("["+activePatient.personid+"] "+activePatient.getFullName());
						%>
					</td>
				</tr>
				<tr>
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","examinations",sWebLanguage) %> <%=getTran(request,"web","since",sWebLanguage) %> 30 <%=getTran(request,"web","days",sWebLanguage) %></td>
				</tr>
				<%
					long day=24*3600*1000;
					Vector transactions = MedwanQuery.getInstance().getTransactionsAfter(Integer.parseInt(activePatient.personid), new java.util.Date(new java.util.Date().getTime()-30*day));
					for(int n=0;n<transactions.size();n++){
						TransactionVO transactionVO = (TransactionVO)transactions.elementAt(n);
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;'>"+ScreenHelper.formatDate(transactionVO.getUpdateTime())+"</td>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;'>"+getTranNoLink("web.occup",transactionVO.getTransactionType(),sWebLanguage)+
						"<span style='font-size: 4vw'><br/>"+activeUser.person.getFullName()+"</span>"+
									"</td>");
						out.println("</tr>");
					}
				%>
			</table>
		</form>
	</body>
</html>
<script>
	window.parent.parent.scrollTo(0,0);
</script>
<%
	}
%>
				