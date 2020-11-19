<%@page import="be.openclinic.pharmacy.ProductStock"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	try{
		String sEditTargetProductStockUid = SH.c(request.getParameter("EditTargetProductStockUid"));
		String sEditTargetProductStockQuantity = SH.c(request.getParameter("EditTargetProductStockQuantity"));
		if(Integer.parseInt(sEditTargetProductStockQuantity)>0){
			ProductStock stock = ProductStock.get(sEditTargetProductStockUid);
			stock.createKits(Integer.parseInt(sEditTargetProductStockQuantity), activeUser.userid);
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>