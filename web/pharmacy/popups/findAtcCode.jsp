<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<script>
	window.location.href='http://www.whocc.no/atc_ddd_index/?name=<%=request.getParameter("initkey")%>';
</script>