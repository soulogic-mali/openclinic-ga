<%@include file="/includes/validateUser.jsp"%>
<%
	session.invalidate();
	out.println("<script>window.location.href='"+sCONTEXTPATH+"/mpiLogin.jsp';</script>");
	out.flush();
%>