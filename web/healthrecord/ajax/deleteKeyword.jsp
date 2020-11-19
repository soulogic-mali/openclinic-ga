<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String labeltype=request.getParameter("labeltype");
	String labelid=request.getParameter("labelid");
	Label label =Label.get(labeltype, labelid, sWebLanguage);
	label.value="<deleted>"+label.value;
	label.updateUserId=activeUser.userid;
	label.saveToDB();
%>