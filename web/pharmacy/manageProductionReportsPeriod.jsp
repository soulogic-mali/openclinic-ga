<%@ page import="be.openclinic.pharmacy.*,java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.pdf.general.*,org.dom4j.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId=checkString(request.getParameter("ServiceStockUid"));
	String sReport=checkString(request.getParameter("report"));
%>
	<form name='transactionForm' method='post'>
		<table width='100%'>
			<tr>
				<td class='admin2'>
					<%=getTran(request,"web","begin",sWebLanguage)%> <%=writeDateField("FindBegin", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), sWebLanguage)%>
				</td>
				<td class='admin2'>
					<%=getTran(request,"web","end",sWebLanguage)%> <%=writeDateField("FindEnd", "transactionForm", ScreenHelper.formatDate(new java.util.Date()), sWebLanguage)%>
				</td>
				<td class='admin2'>
					<input type='button' class="button" name='execute' value='<%=getTranNoLink("web","execute",sWebLanguage)%>' onclick='printReport();'/>
				</td>
			</tr>
		</table>
	</form>

	<script>
		function printReport(){
			window.open('<c:url value="pharmacy/getProductionReports.jsp"/>?begin='+document.getElementById('FindBegin').value+'&end='+document.getElementById('FindEnd').value+'&servicestockuid=<%=sServiceStockId%>&report=<%=sReport%>');
			window.close();
		}
	</script>