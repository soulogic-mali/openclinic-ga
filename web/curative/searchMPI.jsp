<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<%
%>

<table width='100%'>
	<tr>
		<td class='admin'><%=getTran(request,"web","manuallyentermpi",sWebLanguage) %></td>
		<td class='admin2'><input type='text' class='text' name='mpiid_value' id='mpiid_value' size='15'> <input type='button' class='button' name='mpiget' onclick='mpiget(document.getElementById("mpiid_value").value);' value='<%=getTranNoLink("web","find",sWebLanguage) %>'/></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","autosearchmpi",sWebLanguage) %></td>
		<td class='admin2'><input type='button' class='button' name='mpisearch' onclick='mpisearch()' value='<%=getTranNoLink("web","probabilisticsearch",sWebLanguage) %>'/></td>
	</tr>
</table>