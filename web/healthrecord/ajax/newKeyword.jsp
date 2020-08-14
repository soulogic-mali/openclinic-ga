<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String labeltype=request.getParameter("labeltype");
	String labelid="A"+MedwanQuery.getInstance().getOpenclinicCounter("keywords");
%>
<form name='transactionForm' method='POST'>
	<input type='hidden'
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","addnewkeyword",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","labeltype",sWebLanguage) %></td>
			<td class='admin2'><%=labeltype %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","labelid",sWebLanguage) %></td>
			<td class='admin2'><%=labelid %></td>
		</tr>
	</table>
</form>