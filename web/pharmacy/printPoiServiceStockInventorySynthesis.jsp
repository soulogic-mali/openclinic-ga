<%@ page import="be.openclinic.reporting.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	java.util.Date date = ScreenHelper.getEndOfMonth(ScreenHelper.parseDate("15/"+request.getParameter("FindMonth")+"/"+request.getParameter("FindYear")));
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
	response.setContentType("application/octet-stream; charset=windows-1252");
	response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicReport"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".xlsx\"");
	PharmacySynthesis report = new PharmacySynthesis();
	report.setServiceUids(sServiceStockId);
	ServletOutputStream os = response.getOutputStream();
	try{
		report.generateReport(date, os, sWebLanguage);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	os.flush();
	os.close();
%>