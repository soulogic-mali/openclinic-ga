<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","fuaerrors",sWebLanguage) %></td>
	</tr>
<%
	String[] errors = checkString(request.getParameter("errors")).split(",");
	String chapter="";
	for(int n=0;n<errors.length;n++){
		if(!chapter.equalsIgnoreCase(errors[n].substring(0,1))){
			chapter=errors[n].substring(0,1);
		%>
			<tr><td class='admin' colspan='2'><%=getTran(request,"fua.error",chapter,sWebLanguage) %></td></tr>
		<%
		}
		%>
		<tr>
			<td class='admin2'><%=errors[n]%></td>
			<td class='admin2'><b><%=getTran(request,"fua.error",errors[n],sWebLanguage) %></b></td>
		</tr>
		<%
	}
%>
</table>
