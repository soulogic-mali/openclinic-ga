<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
%>
<form name='transactionForm'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","generateanonymousticket",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","waitingqueue",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='queue' id='queue'>
					<%=ScreenHelper.writeSelect(request,"anonymousqueue", checkString((String)session.getAttribute("activequeue")), sWebLanguage) %>
				</select>
			</td>
		</tr>
	</table>
	<input accesskey="G" type='button' class='button' name='generateticket' value='<%=getTranNoLink("web","generateticket",sWebLanguage) %>' onclick='generateTicket()'/>
</form>

<script>
	function generateTicket(){
        var url = "<c:url value='/util/createTicketPdf.jsp'/>?objectid=NEW&queue="+document.getElementById('queue').value+"&ts="+new Date().getTime()+"&PrintLanguage=<%=sWebLanguage%>";
        window.open(url,"TicketPdf<%=new java.util.Date().getTime()%>","height=300,width=400,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	}
	
	window.setTimeout("window.location.reload()",600000);
</script>