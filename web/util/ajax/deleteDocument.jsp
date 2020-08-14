<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>

<%
	String serverid=checkString(request.getParameter("serverid"));
	String objectid=checkString(request.getParameter("objectid"));
	ArchiveDocument.delete(serverid+"."+objectid);
%>