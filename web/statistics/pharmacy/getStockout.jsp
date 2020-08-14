<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.pdf.general.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId = checkString(request.getParameter("ServiceStockUid"));
	long day=24*3600*1000;
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
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
			<td class='admin2'>
				<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
			</td>
		</tr>
	</table>
</form>

<script>
  function printReport(){
	window.open('<c:url value="pharmacy/printStockOut.jsp"/>?outputformat='+document.getElementById('outputformat').value+'&ServiceStockUid=<%=sServiceStockId%>');
	window.close();
  }
</script>