<%@page import="be.openclinic.pharmacy.PharmacyReports"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%><%
try{
	String report = request.getParameter("report");
	String serviceStockUid = request.getParameter("servicestockuid");
	java.util.Date date = ScreenHelper.parseDate(request.getParameter("date"));
	java.util.Date begin = ScreenHelper.parseDate(request.getParameter("begin"));
	java.util.Date end = ScreenHelper.parseDate(request.getParameter("end"));
	StringBuffer reportContent = new StringBuffer("Unknown report");	
	if(report.equalsIgnoreCase("inventoryAnalysisReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getInventoryAnalysisReport(serviceStockUid,date);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("consumptionReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getConsumptionReport(serviceStockUid,begin,end,sWebLanguage);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("inventoryReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getInventoryReport(serviceStockUid,begin,end,sWebLanguage);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("inventorySummaryReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getInventorySummaryReport(serviceStockUid,begin,end,sWebLanguage);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("specialOrderReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getSpecialOrderReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("productionReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getProductionReport(serviceStockUid,begin,end,sWebLanguage);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("productionSalesOrderReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getProductionSalesOrderReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("salesOrderReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getSalesOrderReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("deliveryReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getDeliveryReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("insuranceReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getInsuranceReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
	else if(report.equalsIgnoreCase("salesAnalysisReport")){
		reportContent = new StringBuffer();
		Vector reportlines=PharmacyReports.getSalesAnalysisReport(serviceStockUid,begin,end);
		for(int n=0;n<reportlines.size();n++){
			reportContent.append(reportlines.elementAt(n));
		}
	}
    response.setContentType("application/octet-stream; charset=windows-1252");
    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".csv\"");
	ServletOutputStream os = response.getOutputStream();
	byte[] b = reportContent.toString().getBytes();
    for(int n=0; n<b.length; n++){
        os.write(b[n]);
    }
    os.flush();
    os.close();
}
catch(Exception e){
	e.printStackTrace();
}
%>