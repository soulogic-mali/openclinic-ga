<%@include file="/includes/helper.jsp"%>
<%
	String sWebLanguage = request.getParameter("language");
%>
<table width='100%'>
	<tr class='admin' style="padding:0px;">
		<td width='30px'><img src='<%=sCONTEXTPATH %>/_img/icons/icon_new.png' onclick='addEvaluationLine()'/></td>
		<td width='10%'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td width='20%'><%=getTran(request,"web","objectivesreached",sWebLanguage) %></td>
		<td width='20%'><%=getTran(request,"web","functionalevaluation",sWebLanguage) %></td>
		<td width='15%'><%=getTran(request,"web","numberofsessions",sWebLanguage) %></td>
		<td width='15%'><%=getTran(request,"web","outcome",sWebLanguage) %></td>
		<td><%=getTran(request,"web","comment",sWebLanguage) %></td>
	</tr>
<%
	if(request.getParameter("evaluations").length()>0){
		String[] evaluations = request.getParameter("evaluations").split("£");
		for(int n=0;n<evaluations.length;n++){
			String objectives="",functional="",comment="",sessions="",outcome="";
			if(evaluations[n].split(";").length>1){
				objectives=evaluations[n].split(";")[1];
			}
			if(evaluations[n].split(";").length>2){
				functional=evaluations[n].split(";")[2];
			}
			if(evaluations[n].split(";").length>3){
				comment=evaluations[n].split(";")[3];
			}
			if(evaluations[n].split(";").length>4){
				sessions=evaluations[n].split(";")[4];
			}
			if(evaluations[n].split(";").length>5){
				outcome=evaluations[n].split(";")[5];
			}
			out.println("<tr>");
			out.println("<td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteEvaluation("+n+")'><img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' onclick='editEvaluationLine("+n+")'></td>");
			out.println("<td class='admin2'>"+evaluations[n].split(";")[0]+"</td>");
			out.println("<td class='admin2'>"+objectives.replaceAll("\r","<BR/>")+"</td>");
			out.println("<td class='admin2'>"+functional.replaceAll("\r","<BR/>")+"</td>");
			out.println("<td class='admin2'>"+sessions.replaceAll("\r","<BR/>")+"</td>");
			out.println("<td class='admin2'>"+getTranNoLink("kine.outcome",outcome,sWebLanguage)+"</td>");
			out.println("<td class='admin2'>"+comment.replaceAll("\r","<BR/>")+"</td>");
			out.println("</tr>");
		}
	}
%>
