<%@include file="/includes/validateUser.jsp"%>
<%@ page import="be.openclinic.pharmacy.*" %>
<%
	String uid = request.getParameter("batchUid");
	Batch batch = Batch.get(uid);
	if(request.getParameter("submit")!=null && request.getParameter("expires")!=null && ScreenHelper.getSQLDate(request.getParameter("expires"))!=null){
		batch.setBatchNumber(request.getParameter("batchnumber"));
		batch.setEnd(ScreenHelper.getSQLDate(request.getParameter("expires")));
		batch.store();
		%>
		<script>
			window.opener.refreshlist();
			window.close();
		</script>
		<%
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr>
			<td class='admin'><%=getTran(request,"web","batchnumber",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='batchnumber' value='<%=batch.getBatchNumber() %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","expires",sWebLanguage) %></td>
			<td class='admin2'>
				<%=writeDateField("expires","transactionForm",batch.getEnd()==null?"":ScreenHelper.formatDate(batch.getEnd()),sWebLanguage)%>
			</td>
		</tr>
		<tr>
			<td colspan='2' class='admin2'>
				<input type='submit' name='submit' value='<%=getTran(null,"web","save",sWebLanguage) %>'/>
			</td>
		</tr>
	</table>
</form>