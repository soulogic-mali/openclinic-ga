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
<title><%=getTran(request,"web","labresults",sWebLanguage) %></title>
<html>
	<body>
		<form name='transactionForm' method='post'>
			<input type='hidden' name='formaction' id='formaction'/>
			<table width='100%'>
				<tr>
					<td colspan='2' style='font-size:8vw;text-align: right'>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getImaging.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
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
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","imagestore",sWebLanguage) %></td>
				</tr>
				<%
					Vector transactions = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PACS");
					HashSet uids = new HashSet();
					for(int n=0;n<transactions.size();n++){
						TransactionVO transactionVO = (TransactionVO)transactions.elementAt(n);
						String uid=transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYUID")+";"+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_SERIESID");
						if(!uids.contains(uid)){
							out.println("<tr onclick='window.location.href=\"getImage.jsp?excludeFromFilter=1&uid="+uid+";"+ScreenHelper.formatDate(transactionVO.getUpdateTime())+"\";'>");
							out.println("<td class='mobileadmin2' style='font-size:6vw;'>"+ScreenHelper.formatDate(transactionVO.getUpdateTime())+"</td>");
							out.println("<td class='mobileadmin2' style='font-size:6vw;'>"+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_STUDYDESCRIPTION").replaceAll("\\_"," ").replaceAll("\\^"," ")+
										"<span style='font-size:4vw'><br/>"+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PACS_MODALITY")+"</span>"+
										"</td>");
							out.println("</tr>");
							uids.add(uid);
						}
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
