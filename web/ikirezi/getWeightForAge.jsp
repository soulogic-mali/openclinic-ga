<%@page import="be.openclinic.knowledge.*"%>
<%
	double zindex=Growth.getZScoreWeightForAge(Double.parseDouble(request.getParameter("age")), Double.parseDouble(request.getParameter("weight")), request.getParameter("gender"));
%>
{
	"zindex":"<%=zindex%>"
}