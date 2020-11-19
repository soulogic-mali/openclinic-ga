<%@page import="net.admin.Service"%>
<%
	String servicecode=request.getParameter("servicecode");
	if(Service.getService(servicecode)!=null){
		out.println("<EXISTS>");
	}
%>