<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String orgunituid = SH.c(request.getParameter("uid"));
	MedwanQuery.getInstance().setConfigString("dhis2_orgunit", orgunituid);
%>