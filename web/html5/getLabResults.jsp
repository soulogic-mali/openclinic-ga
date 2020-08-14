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
	String uid=request.getParameter("uid");
    if(activeUser==null || activeUser.person==null){
        out.println("<script>window.location.href='login.jsp';</script>");
        out.flush();
    }
    else{
    	TransactionVO transactionVO = MedwanQuery.getInstance().loadTransaction(Integer.parseInt(uid.split("\\.")[0]), Integer.parseInt(uid.split("\\.")[1]));
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
						<img onclick="window.location.href='getLab.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/lab.png'/>
						<img onclick="window.location.href='getPatient.jsp?searchpersonid=<%=activePatient.personid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/patient.png'/>
						<img onclick="window.location.href='findPatient.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/find.png'/>
						<img onclick="window.location.href='getLabResults.jsp?uid=<%=uid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/refresh.png'/>
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
					<td colspan='2' class='mobileadmin' style='font-size:6vw;'><%=getTran(request,"web","labresults",sWebLanguage) %> <%=ScreenHelper.formatDate(transactionVO.getUpdateTime()) %> <span style='font-size: 4vw;font-weight: normal'>[#<%=uid.split("\\.")[1] %>]</span></td>
				</tr>
				<%
					Vector results = RequestedLabAnalysis.find(transactionVO.getServerId()+"", transactionVO.getTransactionId()+"", activePatient.personid, "", "", "", "", "", "", "", "", "", "", "", "analysiscode", "", false, "");
					for(int n=0;n<results.size();n++){
						RequestedLabAnalysis analysis = (RequestedLabAnalysis)results.elementAt(n);
						String editor=LabAnalysis.getLabAnalysisByLabcode(analysis.getAnalysisCode()).getEditor();
						String value="";
						if(analysis.getFinalvalidationdatetime()!=null){
							value=analysis.getResultValue();
						}
						out.println("<tr>");
						out.println("<td class='mobileadmin2' style='font-size:"+(value.length()>0 || (editor.startsWith("antibio") && analysis.getFinalvalidationdatetime()!=null)?"6vw":"4vw")+";'>"+LabAnalysis.labelForCode(analysis.getAnalysisCode(),sWebLanguage)+"</td>");
						out.println("<td class='mobileadmin2' style='font-size:6vw;"+(MedwanQuery.getInstance().getConfigString("abnormalModifiers","*+*++*+++*-*--*---*h*hh*hhh*l*ll*lll*").contains("*"+analysis.getResultModifier()+"*")?"font-weight: bold;color:red;":"")+"'>"+(editor.startsWith("antibio") && analysis.getFinalvalidationdatetime()!=null?getTranNoLink("web","antibiogram",sWebLanguage)+" <img onclick='window.location.href=\"getAntibiogramme.jsp?uid="+analysis.getServerId()+"."+analysis.getTransactionId()+"."+analysis.getAnalysisCode()+"\";' src='"+sCONTEXTPATH+"/_img/icons/mobile/info.png'/>":value)+(value.length()>0?" <span style='font-size: 4vw'>"+analysis.getResultUnit()+(MedwanQuery.getInstance().getConfigString("abnormalModifiers","*+*++*+++*-*--*---*h*hh*hhh*l*ll*lll*").contains("*"+analysis.getResultModifier()+"*")?"&nbsp;&nbsp;&nbsp;&nbsp;"+analysis.getResultModifier()+"</span>":"")+(analysis.getResultRefMin().length()>0?"<span style='font-size: 4vw'><br/>[ "+analysis.getResultRefMin()+" - "+analysis.getResultRefMax()+" ]</span>":""):"")+"</td>");
						out.println("</tr>");
					}
				%>
			</table>
		</form>
	</body>
</html>
<%
    }
%>