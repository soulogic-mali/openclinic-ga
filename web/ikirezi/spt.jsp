<%@include file="/includes/helper.jsp"%>
<%@include file="/includes/SingletonContainer.jsp"%>
<%
	autoLogin("4","overmeire",request);
	reloadSingleton(session);
%>
<script>
	window.location.href='../popup.jsp?Page=ikirezi/clinicalPathwaysMain.jsp';
</script>