<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	ArchiveDocument.initializeUDI(request.getParameter("uid"));
%>
<script>
	if(window.opener.opener){
		window.opener.opener.location.reload();
	}
	window.opener.location.reload();
	window.opener.alert('<%=getTranNoLink("web","documentremoved",sWebLanguage)%>');
	window.close();
</script>