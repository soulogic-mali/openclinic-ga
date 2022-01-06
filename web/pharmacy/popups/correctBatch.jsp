<%@page import="be.openclinic.pharmacy.*"%>
<%@page import="java.util.Vector"%>
<%@include file="/_common/templateAddIns.jsp"%>
<%
	String sOperationUid = checkString(request.getParameter("OperationUid"));
	ProductStockOperation operation = ProductStockOperation.get(sOperationUid);
	
	if(request.getParameter("submitButton")!=null){
		String sBatchNumber=checkString(request.getParameter("batchnumber"));
		String sBatchEnd=checkString(request.getParameter("batchend"));
		String sBatchComment=checkString(request.getParameter("batchcomment"));
		Batch batch = Batch.getByBatchNumber(operation.getProductStockUid(), sBatchNumber);
		if(batch==null){
			//the batch doesn't exist yet, create it 
			batch = new Batch();
			batch.setCreateDateTime(new java.util.Date());
			batch.setLevel(0);
			batch.setProductStockUid(operation.getProductStockUid());
			batch.setUpdateDateTime(new java.util.Date());
			batch.setUpdateUser(activeUser.userid);
			batch.setVersion(1);
		}
		batch.setBatchNumber(sBatchNumber);
		batch.setComment(sBatchComment);
		batch.setEnd(ScreenHelper.parseDate(sBatchEnd));
		batch.store();
		String sOldBatchUid = checkString(operation.getBatchUid());
		operation.setBatchUid(batch.getUid());
        operation.setBatchComment(sBatchComment);
        operation.setBatchNumber(sBatchNumber);
        operation.setBatchEnd(ScreenHelper.parseDate(sBatchEnd));
        operation.store();
        Batch.calculateBatchLevel(sOldBatchUid);
        Batch.calculateBatchLevel(operation.getBatchUid());
		out.println("<script>");
		out.println("window.opener.location.reload();");
		out.println("window.close();");
		out.println("</script>");
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr>
			<td class='admin'><%=getTran(request,"web","operationuid",sWebLanguage) %></td>
			<td class='admin2'><%=sOperationUid %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batch.number",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='batchnumber' width='20' value='<%=checkString(operation.getBatchNumber()) %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","batch.expiration",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("batchend", "transactionForm", ScreenHelper.formatDate(operation.getBatchEnd()), true, true, sWebLanguage, sCONTEXTPATH)  %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
			<td class='admin2'><textarea class='text' name='batchcomment' cols='20' rows='2'><%=operation.getBatchComment() %></textarea></td>
		</tr>
	</table>
	<center>
		<input type='submit' class='button' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
	</center>
</form>