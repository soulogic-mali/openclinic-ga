<%
	String id = request.getParameter("id");
	String value = request.getParameter("value");
	session.setAttribute(id, value);
%>