<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String operationuid=checkString(request.getParameter("operationuid"));
	ProductStockOperation operation = ProductStockOperation.get(operationuid);
	
	if(request.getParameter("submit")!=null){
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		if(quantity<operation.getUnitsChanged()){
			//Er werd minder geleverd dan reeds van de stock voorafgenomen.
			//De stock moet gecompenseerd worden
			//Corrigeer eerst de productstock
			operation.getProductStock().setLevel(operation.getProductStock().getLevel()+operation.getUnitsChanged()-quantity);
			operation.getProductStock().store();
			//Corrigeer dan de geregistreerde stock operatie
			operation.setUnitsChanged(quantity);
		}
		operation.setDeliverytime(new java.util.Date());
		operation.store();
		out.println("<script>window.opener.loadQueueContent();window.close();</script>");
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr>
			<td class='admin'><%=getTran(request,"web","product",sWebLanguage) %></td>
			<td  style='font-size: 16px' class='admin2'><%=operation.getProductStock().getProduct().getName() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batchnumber",sWebLanguage) %></td>
			<td  style='font-size: 16px' class='admin2'><%=checkString(operation.getBatchNumber()) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","quantity.delivered",sWebLanguage) %></td>
			<td class='admin2'>
				<select  style='font-size: 16px' name='quantity' id='quantity'>
					<%
						for(int n = operation.getUnitsChanged();n>=0;n--){
							out.println("<option  style='font-size: 16px' value='"+n+"'>"+n+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
	</table>
	<p/>
	<center><input style='font-size: 16px' type='submit' name='submit' value='<%=getTranNoLink("web","deliver",sWebLanguage)%>'></center>
</form>