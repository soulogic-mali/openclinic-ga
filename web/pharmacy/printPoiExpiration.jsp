<%@ page import="be.openclinic.reporting.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	try{
		java.util.Date begin = ScreenHelper.parseDate(request.getParameter("begin"));
		java.util.Date end = ScreenHelper.parseDate(request.getParameter("end"));
		String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
		response.setContentType("application/octet-stream; charset=windows-1252");
		response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicReport"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".xlsx\"");
		PharmacyExpiration report = new PharmacyExpiration();
		report.setServiceUids(sServiceStockId);
		ServletOutputStream os = response.getOutputStream();
		try{
			report.generateReport(begin,end, os, sWebLanguage);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		os.flush();
		os.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>