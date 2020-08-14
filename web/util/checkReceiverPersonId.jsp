<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String msg="<img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>"+getTranNoLink("web","noreceiverpersonidavailable",sWebLanguage);
	if(activePatient.hasReceiverPersonId(request.getParameter("receiverid"))){
		msg="<img src='"+sCONTEXTPATH+"/_img/icons/icon_info.gif'/>"+getTranNoLink("web","remotepersonid",sWebLanguage)+" = <b>"+activePatient.getReceiverPersonId(request.getParameter("receiverid"))+"</b>";
	}
%>
{
"msg":"<%=msg%>",
}