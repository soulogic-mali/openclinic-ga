<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	AdminPerson person = (AdminPerson)session.getAttribute("f_person");
	AdminPrivateContact apc = person.getActivePrivate();
%>
<table width='100%' padding='5px'>
	<tr class='admin'>
		<td nowrap><%=getTran(request,"web","healthfacility",sWebLanguage) %>&nbsp;</td>
		<td><%=getTran(request,"web","recordnumber",sWebLanguage) %></td>
	</tr>
<%
	Enumeration eIds = person.adminextends.keys();
	while(eIds.hasMoreElements()){
		String key = (String)eIds.nextElement();
		if(key.startsWith("facilityid$")){
			%>
			<tr>
				<td class='admin' nowrap width='1%'><%=getTran(request,"mpi.facility",key.replaceAll("facilityid\\$",""),sWebLanguage) %>&nbsp;</td>
				<td class='admin2' colspan='2'><font style='font-size:12px;font-weight: bolder' color='black'><%=checkString((String)person.adminextends.get(key)) %></font></td>
			</tr>
			<%
		}
	}
%>
</table>