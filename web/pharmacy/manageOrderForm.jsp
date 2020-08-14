<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sOrderFormUid=checkString(request.getParameter("uid"));
	OrderForm orderForm = OrderForm.get(sOrderFormUid);
	if(orderForm==null){
		orderForm=new OrderForm();
		orderForm.setUid("-1");
	}
%>
<form name='editOrderForm' method='post'>
	<table width='100%'>
		<input type='hidden' name='uid' id='uid' value='<%=orderForm.getUid()%>'>
		<%if(!orderForm.getUid().equalsIgnoreCase("-1")){ %>
		<tr>
			<td class='admin'><%=getTran(request,"web","number",sWebLanguage) %></td>
			<td class='admin2'><%=orderForm.getUid().split("\\.")[1] %></td>
		</tr>
		<%} %>
		<tr>
			<td class='admin'><%=getTran(request,"web","supplier",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='supplier' id='supplier' size='60' value='<%=checkString(orderForm.getSupplier()) %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("date", "editOrderForm", ScreenHelper.formatDate(orderForm.getDate()), true, false, sWebLanguage, sCONTEXTPATH) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","supplierinvoice",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='supplierinvoice' id='supplierinvoice' size='60' value='<%=checkString(orderForm.getSupplierinvoice()) %>'/></td>
		</tr>
	</table>
	<input type='button' name='submitOrderForm' value='<%=getTranNoLink("web","save",sWebLanguage) %>' onclick='saveOrderForm();'/>
	<input type='button' name='hideOrderForm' value='<%=getTranNoLink("web","close",sWebLanguage) %>' onclick='Modalbox.hide();'/>
	<%if(!orderForm.getUid().equalsIgnoreCase("-1")){ %>
		<input type='button' name='printOrderForm' value='<%=getTranNoLink("web","printorderform",sWebLanguage) %>' onclick="printMyOrderForm('<%=orderForm.getUid() %>');"/>
		<input type='button' name='printDeliveryForm' value='<%=getTranNoLink("web","printdeliveryform",sWebLanguage) %>' onclick="printMyDeliveryForm('<%=orderForm.getUid() %>');"/>
	<%} %>		
</form>

