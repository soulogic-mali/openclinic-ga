<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td><%=getTran(request,"dhis2","managedatasets",sWebLanguage) %></td></tr>
	</table>
</form>
