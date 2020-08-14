<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServers = checkString(request.getParameter("servers"));
	String sBegin = checkString(request.getParameter("from"));
	if(sBegin.length()==0){
		sBegin="01/01/"+new SimpleDateFormat("yyyy").format(new java.util.Date());
	}
	String sEnd = checkString(request.getParameter("to"));
	if(sEnd.length()==0){
		sEnd=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
	}
	String sServerGroups=MedwanQuery.getInstance().getConfigString("datacenterUserServerGroups."+session.getAttribute("datacenteruser"),"");
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td>
				<%=getTran(request,"web","from",sWebLanguage) %>
				<%=ScreenHelper.writeDateField("from", "transactionForm", sBegin, true, false, sWebLanguage, sCONTEXTPATH) %>
				
				<%=getTran(request,"web","to",sWebLanguage) %>
				<%=ScreenHelper.writeDateField("to", "transactionForm", sEnd, true, false, sWebLanguage, sCONTEXTPATH) %>
			</td>
			<td>
				<%=getTran(request,"web","servers",sWebLanguage) %>
				<select class='text' name='servers' id='servers' size='3' multiple>
					<option value='all'><%=getTran(request,"web","all",sWebLanguage) %></option>
					<option value='1'>A</option>
					<option value='2'>B</option>
				</select>
				<input type='submit' name='submit' value='<%=getTran(null,"web","search",sWebLanguage) %>'/>
			</td>
		</tr>
	</table>
</form>
<script>
	alert('<%=sServers%>');
</script>