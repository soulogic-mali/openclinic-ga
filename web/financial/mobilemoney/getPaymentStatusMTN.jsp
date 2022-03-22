<%@page import="javax.json.JsonObject"%>
<%@page import="javax.json.Json"%>
<%@page import="javax.json.JsonReader"%>
<%@page import="be.openclinic.mobilemoney.*,be.openclinic.system.*"%>
<%
	MTN mm = new MTN();
	String status = mm.getPaymentStatus(SH.c(request.getParameter("transactionId")));
	System.out.println(mm.getLastEntity());
	JsonReader jr = Json.createReader(new java.io.StringReader(mm.getLastEntity()));
	JsonObject jo = jr.readObject();
	jr.close();
%>
{
	"status":"<%=SH.c(status) %>",
	"financialTransactionId":"<%=jo.getJsonString("financialTransactionId") %>",
	"telephone":"<%=SH.c(jo.getJsonObject("payer")==null?"":jo.getJsonObject("payer").getString("partyId")) %>"
}