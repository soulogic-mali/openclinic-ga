<%@ page import="be.openclinic.reporting.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	try{
		java.util.Date date = ScreenHelper.getEndOfMonth(ScreenHelper.parseDate("15/"+request.getParameter("FindMonth")+"/"+request.getParameter("FindYear")));
		String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
		response.setContentType("application/octet-stream; charset=windows-1252");
		response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicReport"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".xlsx\"");
		PharmacyValorisation report = new PharmacyValorisation();
		report.setServiceUids(sServiceStockId);
		ServletOutputStream os = response.getOutputStream();
		try{
			report.generateReport(date, os, "fr");
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