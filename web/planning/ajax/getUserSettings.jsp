<%@include file="/includes/validateUser.jsp" %>
<%
	String userid = request.getParameter("userid");
	User user = User.get(Integer.parseInt(userid)); 
%>
{
"PlanningFindZoom":"<%=checkString(user.getParameter("PlanningFindZoom")).equals("")?"40":checkString(user.getParameter("PlanningFindZoom"))%>",
"PlanningFindFrom":"<%=user.getParameter("PlanningFindFrom")%>",
"PlanningFindUntil":"<%=user.getParameter("PlanningFindUntil")%>",
"PlanningExamDuration":"<%=user.getParameter("PlanningExamDuration")%>"
}