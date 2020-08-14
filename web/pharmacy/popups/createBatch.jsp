<%@page import="be.openclinic.pharmacy.*"%>
<%@page import="java.util.Vector"%>
<%@include file="/_common/templateAddIns.jsp"%>
<%
	String sProductStockUid = checkString(request.getParameter("productStockUid"));
	ProductStock stock = ProductStock.get(sProductStockUid);
	int unbatched = stock.getUnbatchedLevel();
	
	if(checkString(request.getParameter("action")).equalsIgnoreCase("submit")){
		String sBatchNumber=checkString(request.getParameter("batchnumber"));
		String sBatchEnd=checkString(request.getParameter("batchend"));
		String sBatchComment=checkString(request.getParameter("batchcomment"));
		try{
			int nBatchQuantity=Integer.parseInt(checkString(request.getParameter("batchquantity")));
			Batch batch = Batch.getByBatchNumber(sProductStockUid, sBatchNumber);
			if(batch==null){
				batch = new Batch();
				batch.setUid("-1");
				batch.setBatchNumber(sBatchNumber);
				batch.setComment(sBatchComment);
				batch.setCreateDateTime(new java.util.Date());
				batch.setEnd(ScreenHelper.parseDate(sBatchEnd));
				batch.setLevel(0);
				batch.setProductStockUid(sProductStockUid);
				batch.setUpdateDateTime(new java.util.Date());
				batch.setUpdateUser(activeUser.userid);
				batch.setVersion(1);
			}
			batch.setLevel(batch.getLevel()+nBatchQuantity);
			batch.store();
			out.println("<script>");
			out.println("window.opener.location.reload();");
			out.println("window.close();");
			out.println("</script>");
			out.flush();
		}
		catch(Exception e){
			out.println("<script>alert('"+getTranNoLink("web","wrongvalue",sWebLanguage)+"');</script>");
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action' value=''/>
	<input type='hidden' name='productStockUid' value='<%=request.getParameter("productStockUid")%>'/>
	<table width='100%'>
		<tr>
			<td class='admin'><%=getTran(request,"web","product",sWebLanguage) %></td>
			<td class='admin2'><%=stock.getProduct().getName() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batch.number",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='batchnumber' width='20'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batch.expiration",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("batchend", "transactionForm", "", true, true, sWebLanguage, sCONTEXTPATH)  %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batch.quantity",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='batchquantity' id='batchquantity' width='10'/> (<=<%=unbatched %>)</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
			<td class='admin2'><textarea class='text' name='batchcomment' cols='20' rows='2'></textarea></td>
		</tr>
	</table>
	<center>
		<input type='button' class='button' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>' onclick='validatequantity();'/>
	</center>
</form>

<script>
	function validatequantity(){
		if(document.getElementById("batchquantity").value*1><%=unbatched%>){
			alert('<%=getTranNoLink("web","quantitymustbe",sWebLanguage)%> <=<%=unbatched%>');
		}
		else{
			document.getElementById('action').value='submit';
			transactionForm.submit();
		}
	}
</script>