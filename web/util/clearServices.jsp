<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	MedwanQuery.getInstance().services.clear();
%>
<%=getTran(request,"web","servicesreloaded",sWebLanguage)%>