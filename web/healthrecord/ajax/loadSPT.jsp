<%@page import="be.openclinic.knowledge.*,be.openclinic.medical.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<td>
<%
	String activeSPT = SPT.getSPTPathOpen("activespt."+activePatient.personid, sWebLanguage, "http://localhost/openclinic/_common/xml/pathways.bi.xml");
	if(SH.c(activeSPT).length()>0){
		out.println("<table width='100%'><tr><td class='admin'><img style='vertical-align: middle' height='24px' src='"+sCONTEXTPATH+"/_img/icons/mobile/icon_brain.png'/> "+getTran(request,"web","activespt",sWebLanguage)+"</td></tr>");
		out.println("<tr><td class='admin2'>"+activeSPT+"</td></tr>");
		out.println("</table>");
	}
%>
</td>