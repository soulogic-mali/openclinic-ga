<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%ScreenHelper.setIncludePage(customerInclude("/_common/header.jsp"),pageContext);%>
<script>
	openPopup("pacs/downloadWeasisSoftware.jsp",400,200);
</script>