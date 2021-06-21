<%@page import="be.openclinic.assets.*,java.text.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String uid = request.getParameter("MaintenancePlanUID");
	String date = request.getParameter("date");
	String format = SH.p(request,"format");
	if(format.length()==0){
		format="dd/MM/yyyy";
	}
	MaintenanceOperation operation = new MaintenanceOperation();
	operation.setMaintenanceplanUID(uid);
	java.util.Date nextdate = operation.getNextOperationDate(new SimpleDateFormat(format).parse(date));
	String sNextDate="";
	if(nextdate!=null){
		try{
			sNextDate = new SimpleDateFormat(format).format(nextdate);
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
{
	"nextdate" : "<%=sNextDate %>"
}

