<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name='uploadForm' method='post' enctype='multipart/form-data' action='<c:url value="popup.jsp?Page=archiving/uploadfiles.jsp&PopupHeight=400&PopupWidth=600"/>'>
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"web","uploaddocuments",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><input type='file' name='uf' id='uf' multiple='multiple'/><input type='submit' name='submit' class='button' value='<%=getTran(null,"web", "send", sWebLanguage)%>'/></td>
		</tr>
	</table>
</form>