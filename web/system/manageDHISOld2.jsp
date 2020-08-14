<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td><%=getTran(request,"web.manage","manageDHIS2",sWebLanguage) %></td></tr>
		<tr><td class='admin2'><a href='javascript:manageDataSets()'><%=getTran(request,"dhis2","managedatasets",sWebLanguage) %></a></td></tr>
		<tr><td class='admin2'><a href='javascript:manageDataElements()'><%=getTran(request,"dhis2","managedataelements",sWebLanguage) %></a></td></tr>
		<tr><td class='admin2'><a href='javascript:manageCategoryComboOptions()'><%=getTran(request,"dhis2","managecategories",sWebLanguage) %></a></td></tr>
	</table>
</form>

<script>
	function manageDataSets(){
	    openPopup("dhis2/manageDataSets.jsp&ts=<%=getTs()%>",700,400);
	}
	function manageDataElements(){
	    openPopup("dhis2/manageDataElements.jsp&ts=<%=getTs()%>",700,400);
	}
	function manageCategoryComboOptions(){
	    openPopup("dhis2/manageCategoryComboOptions.jsp&ts=<%=getTs()%>",700,400);
	}
</script>