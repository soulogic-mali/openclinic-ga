<%@page import="be.openclinic.knowledge.*"%>
<%
	double zindex=Growth.getZScoreLengthForAge(Double.parseDouble(request.getParameter("age")), Double.parseDouble(request.getParameter("height")), request.getParameter("gender"));
%>
{
"zindex":"<%=zindex%>"
}