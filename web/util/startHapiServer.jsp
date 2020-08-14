<%@page import="be.hapi.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	RestfulServlet restfulServlet = new RestfulServlet();
%>
RestfulServlet started...