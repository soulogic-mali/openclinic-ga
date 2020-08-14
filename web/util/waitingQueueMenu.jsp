<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<head>
    <%=sCSSNORMAL%>
</head>
<table width='100%'>
	<tr class='admin'><td><%=getTran(request,"web","numberofframes",sWebLanguage) %>: <a href='javascript:showFrames(4,2);'>4</a> - <a href='javascript:showFrames(2,1)'>2</a> - <a href='javascript:showFrames(1,1)'>1</a></td></tr>
</table>

<script>
	function showFrames(number,verticalFrames){
		window.parent.location.href='<c:url value="/util/manageQueues.jsp"/>?numberOfFrames='+number+"&verticalFrames="+verticalFrames;
	}
	

</script>