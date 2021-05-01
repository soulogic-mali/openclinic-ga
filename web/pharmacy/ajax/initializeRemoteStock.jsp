<%@page import="be.openclinic.pharmacy.RemotePharmacy"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String uid=SH.c(request.getParameter("serviceStockUid"));
	be.openclinic.reporting.MessageNotifier.SpoolMessage("http",uid,SH.cs("pharmaSyncServerURL",""),"pharmainit","en");
%>