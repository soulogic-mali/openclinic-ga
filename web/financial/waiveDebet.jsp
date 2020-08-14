<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Debet debet = Debet.get(request.getParameter("uid"));
	if(checkString(request.getParameter("formaction")).equalsIgnoreCase("waive")){
		debet.setAmount(0);
		debet.store();	
		out.println("<script>window.opener.location.reload();</script>");
		out.println("<script>window.close();</script>");
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='formaction' id='formaction'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","waivehealthservice",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","prestation",sWebLanguage) %></td>
			<td class='admin2'><%=debet.getPrestation().getDescription() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
			<td class='admin2'><%=debet.getQuantity() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","amount",sWebLanguage) %></td>
			<td class='admin2'><%=debet.getAmount() %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","reason",sWebLanguage) %>*</td>
			<td class='admin2'>
				<select class='text' name='reason' id='reason'>
					<option/>
					<%=ScreenHelper.writeSelect(request, "waiverreason", "", sWebLanguage) %>
				</select>
			</td>
		</tr>
	</table>
	<input class='button' type='button' name='waivebutton' value='<%=getTranNoLink("web","waive",sWebLanguage) %>' onclick='dowaive()'/>
	<input class='button' type='button' name='closebutton' value='<%=getTranNoLink("web","close",sWebLanguage) %>' onclick='window.close()'/>
</form>

<script>
	function dowaive(){
		if(document.getElementById("reason").value==''){
			alert('<%=getTranNoLink("web","reasonismandatory",sWebLanguage) %>');
		}
		else{
			document.getElementById("formaction").value="waive";
			transactionForm.submit();
		}
	}
</script>
