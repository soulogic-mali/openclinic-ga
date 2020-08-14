<%@ page import="be.openclinic.adt.Queue" %>
<%@include file="/includes/validateUser.jsp"%>

<%
	Queue.closeTicket(Integer.parseInt(request.getParameter("objectid")), request.getParameter("reason"), Integer.parseInt(activeUser.userid));
%>