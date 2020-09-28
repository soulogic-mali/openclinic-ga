<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	application.setAttribute("wizzeyeRoomId."+request.getParameter("key"), activePatient.personid+"");
%>