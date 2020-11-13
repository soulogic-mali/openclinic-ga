<%@page import="javax.json.JsonObject"%>
<%@page import="javax.json.Json"%>
<%@page import="javax.json.JsonReader"%>
<%@page import="be.openclinic.mobilemoney.*,be.openclinic.system.*"%>
<%
	MTN mm = new MTN();
	String status = mm.getDisbursementStatus(SH.c(request.getParameter("transactionId")));
	JsonReader jr = Json.createReader(new java.io.StringReader(mm.getLastEntity()));
	JsonObject jo = jr.readObject();
	jr.close();
%>
{
	"status":"<%=SH.c(status) %>",
	"financialTransactionId":"<%=SH.c(jo.getString("financialTransactionId")) %>",
	"telephone":"<%=SH.c(jo.getJsonObject("payee").getString("partyId")) %>"
}