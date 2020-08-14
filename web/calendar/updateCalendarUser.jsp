<%@include file="/includes/validateUser.jsp"%>
<%
	session.setAttribute("calendarUser",request.getParameter("id"));
%>
{
	"username" : "<%=User.getFullUserName(request.getParameter("id")) %>" 
}