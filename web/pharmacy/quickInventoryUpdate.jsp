<%@page import="be.openclinic.pharmacy.*,
                be.openclinic.medical.Prescription,
                java.util.Vector,be.mxs.common.util.system.*,
                be.openclinic.pharmacy.ProductOrder"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pharmacy.updateinventory","all",activeUser)%>
<%
	String sBarcode=checkString(request.getParameter("barcode"));
	ProductStock productStock = null;
	if(request.getParameter("updateButton")!=null){
		//Register an inventory correction
		try{
			int nDifference = Integer.parseInt(request.getParameter("physicallevel"))-Integer.parseInt(request.getParameter("level"));
			ProductStockOperation operation = new ProductStockOperation();
			operation.setCreateDateTime(new java.util.Date());
			operation.setDate(new java.util.Date());
			if(nDifference<0){
				operation.setDescription("medicationdelivery.3");
				operation.setUnitsChanged(-nDifference);
			}
			else{
				operation.setDescription("medicationreceipt.3");
				operation.setUnitsChanged(nDifference);
			}
			operation.setProductStockUid(sBarcode);
			operation.setUid("-1");
			operation.setUpdateDateTime(new java.util.Date());
			operation.setUpdateUser(activeUser.userid);
			operation.setVersion(1);
			operation.setSourceDestination(new ObjectReference("",""));
			operation.store();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	if(sBarcode.length()>0){
		productStock = ProductStock.get(sBarcode);
	}
%>
<form name='transactionForm' method='post' onkeydown="if(enterKeyPressed(event)){transactionForm.submit();}">
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","quickinventoryupdate",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admincentered' colspan='2'><%=getTran(request,"web","barcode",sWebLanguage) %><br/><input class='barcode' type='text' size='8' name='barcode' id='barcode' value='<%=sBarcode%>' onkeyup="if((event.which?event.which:window.event.keyCode)==65){document.getElementById('barcode').value=''};"/></td>
		</tr>
		<%if(productStock!=null){ %>
		<tr>
			<td class='bigadmin' colspan='2'><%=productStock.getServiceStock().getName() %></td>
		</tr>
		<tr>
			<td class='bigadmin' colspan='2'><%=(checkString(productStock.getProduct().getCode()).length()>0?productStock.getProduct().getCode()+" - ":"")+productStock.getProduct().getName() %></td>
		</tr>
		<tr>
			<td colspan='2'><center><h3><%=getTran(request,"web","theoreticallevel",sWebLanguage) %></h3></center></td>
		</tr>
		<tr>
			<td class='bigadmin' colspan='2'><input type='hidden' name='level' id='level' value='<%=productStock.getLevel() %>'/><%=productStock.getLevel() %></td>
		</tr>
		<tr>
			<td colspan='2'><center><h3><%=getTran(request,"web","physicallevel",sWebLanguage) %></h3></center></td>
		</tr>
		<tr>
			<td class='bigadmin' colspan='2'><input class='barcode' type='text' size='8' name='physicallevel' id='physicallevel' value='<%=productStock.getLevel()%>' onkeyup='checkButton()'/></td>
		</tr>
		<tr>
			<td colspan='2'>&nbsp;<br/><center><input style='display: none' class='bigbutton' type='submit' id='updateButton' name='updateButton' value='<%=getTran(request,"web","update",sWebLanguage)%>'/></center></td>
		</tr>
		<%} %>
	</table>
</form>
<script>
	document.getElementById('barcode').focus();
	
	function checkButton(){
		if(document.getElementById('level').value!=document.getElementById('physicallevel').value){
			document.getElementById('updateButton').style.display='';
		}
		else {
			document.getElementById('updateButton').style.display='none';
		}
	}
</script>