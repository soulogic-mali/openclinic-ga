<%@page import="java.text.SimpleDateFormat,
                be.openclinic.pharmacy.Product,
                be.openclinic.medical.Prescription,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.*,
                be.openclinic.common.KeyValue,
                be.openclinic.pharmacy.PrescriptionSchema,
                be.openclinic.pharmacy.ProductSchema,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp" %>
<form name="transactionForm">
	<table width='100%'>
		<tr class='admin'>
			<td colspan='3'><%=getTran(request,"web","selectservicestock",sWebLanguage) %></td>
		</tr>
		<tr class='admin'>
			<td/>
			<td><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
			<td><%=getTran(request,"web","level",sWebLanguage) %></td>
		</tr>
	<%
		String productUid=checkString(request.getParameter("EditProductUid"));
		double packages=0;
		try{
			packages=Integer.parseInt(request.getParameter("EditRequiredPackages"));
		}
		catch(Exception e){}
		if(checkString(request.getParameter("EditPrescrUid")).split("\\.").length>1){
			Prescription prescription = Prescription.get(request.getParameter("EditPrescrUid"));
			if(checkString(prescription.getPatientUid()).length()>0){
				//The prescription already exists, only request for the added packages
				packages=packages-prescription.getRequiredPackages();
			}
		}
		out.println("<tr><td class='admin'><input ondblclick='this.checked=false;' "+(checkString((String)session.getAttribute("activeDispensingStock")).equals("-1")?"checked":"")+" type='radio' name='dispensingstockuid' value='-1'/></td><td class='admin'>"+getTran(request,"web","donotselectdispensingsock",sWebLanguage)+"</td><td class='admin2'></td></tr>");
		Vector stocks = ProductStock.find("", productUid, "1", "", "", "", "", "", "", "", "", "OC_STOCK_OBJECTID", "");
		for(int n=0;n<stocks.size();n++){
			ProductStock stock = (ProductStock)stocks.elementAt(n);
			if(packages>stock.getAvailableLevel()){
				out.println("<tr><td class='admin'><input ondblclick='this.checked=false;' type='radio' disabled name='dispensingstockuid' value='"+stock.getServiceStockUid()+"'/></td><td class='admin'>"+stock.getServiceStock().getName()+"</td><td class='admin2'>"+stock.getAvailableLevel()+" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif' title='"+getTranNoLink("web","insufficient.stock",sWebLanguage)+"'/></td></tr>");
			}
			else{
				out.println("<tr><td class='admin'><input ondblclick='this.checked=false;' "+(checkString((String)session.getAttribute("activeDispensingStock")).equals(stock.getServiceStockUid())?"checked":"")+" type='radio' name='dispensingstockuid' value='"+stock.getServiceStockUid()+"'/></td><td class='admin'>"+stock.getServiceStock().getName()+"</td><td class='admin2'>"+stock.getAvailableLevel()+"</td></tr>");
			}
		}
	%>
	</table>
</form>
<br/>
<center>
	<input type='button' class='button' name='selectButton' value='<%=getTran(request,"web","save",sWebLanguage) %>' onclick='selectStock();'/>
	<input type='button' class='button' name='cancelButton' value='<%=getTran(request,"web","cancel",sWebLanguage) %>' onclick='cancel();'/>
</center>

<script>
function selectStock(){
	if(transactionForm.elements["dispensingstockuid"].value.length>0){
		window.opener.document.getElementById("DispensingStockUID").value=transactionForm.elements["dispensingstockuid"].value;
		window.opener.addDispensingOperation();
		window.close();
	}
	else{
		alert('<%=getTranNoLink("web","selectservicestock",sWebLanguage) %>');
	}
}
function cancel(){
	window.close();
}
</script>