<%@page import="be.openclinic.assets.*,java.text.*"%>
<%
	String uid = request.getParameter("MaintenancePlanUID");
	String date = request.getParameter("date");
	MaintenanceOperation operation = new MaintenanceOperation();
	operation.setMaintenanceplanUID(uid);
	java.util.Date nextdate = operation.getNextOperationDate(new SimpleDateFormat("dd/MM/yyyy").parse(date));
	String sNextDate="";
	try{
		sNextDate = new SimpleDateFormat("dd/MM/yyyy").format(nextdate);
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
{
	"nextdate" : "<%=sNextDate %>"
}

