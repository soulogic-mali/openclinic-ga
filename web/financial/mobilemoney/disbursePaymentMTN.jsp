<%@page import="be.openclinic.mobilemoney.*,be.openclinic.system.*,be.mxs.common.util.db.*"%>
<%
	Double amount = Double.parseDouble(request.getParameter("amount"));
	String currency = SH.c(request.getParameter("currency"));
	String invoiceid = SH.c(request.getParameter("invoiceid"));
	String telephone = SH.c(request.getParameter("telephone"));
	String payermessage = SH.c(request.getParameter("payermessage"));
	String payeemessage = SH.c(request.getParameter("payeemessage"));
	String patientuid = SH.c(request.getParameter("patientuid"));
	String userid = SH.c(request.getParameter("userid"));
	String origintransactionid = SH.c(request.getParameter("origintransactionid"));
	MTN mm = new MTN();
	String paymentId=mm.disbursePayment(amount, currency, invoiceid, telephone, payermessage, payeemessage,patientuid,userid,origintransactionid);
%>
{
"transactionId":"<%=SH.c(paymentId) %>"
}
