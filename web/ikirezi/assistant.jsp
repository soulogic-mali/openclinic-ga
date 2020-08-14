<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sType = checkString(request.getParameter("type"));
	
	if(sType.equalsIgnoreCase("investigations")){
		out.println("Investigations");
	}
%>