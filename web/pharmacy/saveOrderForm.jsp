<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String fields= checkString(request.getParameter("fields"));
	String supplier= checkString(request.getParameter("supplier"));
	String supplierinvoice= checkString(request.getParameter("supplierinvoice"));
	String date= checkString(request.getParameter("date"));
	String uid= checkString(request.getParameter("uid"));
	
	OrderForm orderForm = OrderForm.get(uid);
	if(orderForm==null){
		orderForm= new OrderForm();
	}
	orderForm.setUid(uid);
	orderForm.setSupplier(supplier);
	orderForm.setSupplierinvoice(supplierinvoice);
	orderForm.setDate(ScreenHelper.parseDate(date));
	orderForm.setUpdateUser(activeUser.userid);
	orderForm.store();
	
	//Now link all productorder to this new OrderForm
	for(int n=0;n<fields.split(";").length;n++){
		ProductOrder order = ProductOrder.get(fields.split(";")[n]);
		if(order!=null){
			order.setFormuid(orderForm.getUid());
			order.store();
		}
	}
%>