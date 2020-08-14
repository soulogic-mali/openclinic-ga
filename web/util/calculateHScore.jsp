<%@page import="be.openclinic.knowledge.*"%>
<%
	double probability = Covid.getHLHProbability(Double.parseDouble(request.getParameter("score")));
%>
{
	"probability":"<%=new java.text.DecimalFormat("#0.00").format(probability) %>"
}