<%@page import="be.openclinic.knowledge.*"%>
<%
System.out.println("height="+request.getParameter("height"));
System.out.println("weight="+request.getParameter("weight"));
System.out.println("gender="+request.getParameter("gender"));
	double zindex=Growth.getZScoreWeightForLength(Double.parseDouble(request.getParameter("height")), Double.parseDouble(request.getParameter("weight")), request.getParameter("gender"));
	double zindexLFA=0;
	double zindexWFA=0;
	if(request.getParameter("age")!=null){
		zindexLFA=Growth.getZScoreLengthForAge(Double.parseDouble(request.getParameter("age")), Double.parseDouble(request.getParameter("height")), request.getParameter("gender"));
		zindexWFA=Growth.getZScoreWeightForAge(Double.parseDouble(request.getParameter("age")), Double.parseDouble(request.getParameter("weight")), request.getParameter("gender"));
	}
%>
{
	"zindex":"<%=zindex%>",
	"zindexLFA":"<%=zindexLFA%>",
	"zindexWFA":"<%=zindexWFA%>"
}