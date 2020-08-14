<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%= getTran(request,"web","projectdocuments",sWebLanguage)%></td>
	</tr>
	<%if(MedwanQuery.getInstance().getConfigInt("enableCNRKR",0)==1){ %>
		<tr>
			<td class='admin'>CNRKR</td>
			<td class='admin2'>
				<select class='text' id='cnrkrreports'>
					<%=ScreenHelper.writeSelect(request, "cnrkr.reports", "", sWebLanguage) %>
				</select>
				<input type='button' class='button' value='<%=getTranNoLink("web","execute",sWebLanguage) %>' onclick='xmlReport(document.getElementById("cnrkrreports").value);window.close();'/>
			</td>
	<%} %>
</table>
