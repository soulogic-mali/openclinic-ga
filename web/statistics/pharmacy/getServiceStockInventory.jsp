<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,be.mxs.common.util.pdf.general.*,org.dom4j.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sDate = checkString(request.getParameter("FindDate"));
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<td class='admin2'>
					<%=getTran(request,"web","from",sWebLanguage)%> <%=writeDateField("FindBeginDate","transactionForm",ScreenHelper.formatDate(new java.util.Date()),sWebLanguage)%>
					<%=getTran(request,"web","to",sWebLanguage)%> <%=writeDateField("FindEndDate","transactionForm",ScreenHelper.formatDate(new java.util.Date()),sWebLanguage)%>
				</td>
				<td class='admin2'>
					<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
				</td>
			</tr>
			<tr>
				<td class='admin'>
					<%=getTran(request,"web","format",sWebLanguage)%>
				</td>
				<td class='admin2'>
					<select name='outputformat' id='outputformat' class='text'>
						<option value='pdf'>PDF</option>
						<option value='excel'>Excel</option>
					</select>
				</td>
			</tr>
		</table>
	</form>

	<script>
		function printReport(){
			window.open('<c:url value="pharmacy/printServiceStockInventory.jsp"/>?outputformat='+document.getElementById('outputformat').value+'&FindBeginDate='+document.getElementById('FindBeginDate').value+'&FindEndDate='+document.getElementById('FindEndDate').value+'&ServiceStockUid=<%=sServiceStockId%>');
			window.close();
		}
	</script>