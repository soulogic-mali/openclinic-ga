<%@page import="java.io.File"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="be.openclinic.finance.*,be.mxs.common.util.system.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String invoiceUid=request.getParameter("invoiceuid");
	InsurarInvoice invoice = InsurarInvoice.get(invoiceUid);
	if(request.getParameter("send")!=null){
		//Send the invoice
		%>
			<%=getTran(request,"web","sendinvoice",sWebLanguage)%>...<br/>
			<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>
		<%
		out.flush();
		String xml = invoice.exportToXML("paodes", "", "");
		PrintWriter writer = new PrintWriter(invoice.getUid()+".xml");
		writer.write(xml);
		writer.close();
		Mail.sendMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), 
				MedwanQuery.getInstance().getConfigString("SA.MailAddress"), 
				request.getParameter("email"), 
				getTranNoLink("web","sendInsurerInvoiceTitle",sWebLanguage), 
				"ID: "+invoice.getUid(), 
				invoice.getUid()+".xml", 
				invoice.getUid()+".xml");
		File file = new File(invoice.getUid()+".xml");
		file.delete();
		%>
			<script>
				alert('<%=getTranNoLink("web","invoice.successfully.sent",sWebLanguage)+" "+request.getParameter("email")%>');
				window.close();
			</script>
		<%
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","sendinvoice",sWebLanguage) %></td></tr>
		<tr>
			<td><%=getTran(request,"web","email",sWebLanguage) %></td>
			<td><input size='30' type='text' class='text' name='email' value='<%=checkString(invoice.getInsurar().getContact())%>'/></td>
		</tr>
	</table>
	<input type='submit' class='button' name='send' value='<%=getTranNoLink("web","send",sWebLanguage) %>'/>
</form>