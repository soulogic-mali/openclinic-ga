<%@ page import="be.openclinic.finance.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='4'><%=getTran(request,"web","consolidated.patientinvoices",sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","invoiceid",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","invoicestatus",sWebLanguage) %></td>
		<td class='admin'><%=getTran(request,"web","validated",sWebLanguage) %></td>
	</tr>
	<%
		Vector invoices = SummaryInvoice.getSummarizedInvoices(activePatient.personid);
		for(int n=0;n<invoices.size();n++){
			SummaryInvoice invoice = (SummaryInvoice)invoices.elementAt(n);
			out.println("<tr>");
			out.println("<td class='admin'><a href='javascript:selectInvoice(\""+invoice.getUid()+"\")'>"+invoice.getUid()+"</a></td>");
			out.println("<td class='admin2'>"+ScreenHelper.formatDate(invoice.getDate())+"</td>");
			out.println("<td class='admin2'>"+getTran(request,"summaryinvoicestatus",invoice.getStatus(),sWebLanguage)+"</td>");
			out.println("<td class='admin2'>"+(ScreenHelper.checkString(invoice.getValidated()).length()>0?User.getFullUserName(invoice.getValidated()):getTran(request,"summaryinvoicevalidation","unvalidated",sWebLanguage))+"</td>");
			out.println("</tr>");
		}
	%>
</table>

<script>
	function selectInvoice(uid){
		if('<%=checkString(request.getParameter("ReturnInvoiceUid"))%>'.length>0){
			window.opener.document.getElementById('<%=checkString(request.getParameter("ReturnInvoiceUid"))%>').value=uid;
		}
		if('<%=checkString(request.getParameter("ReturnFunction"))%>'.length>0){
			window.opener.<%=checkString(request.getParameter("ReturnFunction"))%>;
		}
		window.close();
	}
</script>