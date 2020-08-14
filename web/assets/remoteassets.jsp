<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String url=MedwanQuery.getInstance().getConfigString("remoteAssetURL","http://localhost/openclinic/assets/enterAssets.jsp")+"?autologin="+activeUser.getParameter("remotelogingmao")+";"+activeUser.getParameter("remotepasswordgmao");
%>
<script>
	window.location.href='<%=url%>';
</script>