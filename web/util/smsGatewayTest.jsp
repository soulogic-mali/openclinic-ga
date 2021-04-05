<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String to=SH.c(request.getParameter("to"));
	String gw=SH.c(request.getParameter("gateway"));
	String txt=SH.c(request.getParameter("message"),"OpenClinic GA\nTest message");
	if(request.getParameter("send")!=null){
		be.mxs.common.util.tools.SendSMS.sendSMS(to, txt+"\n> > >\nGateway = "+gw, gw);
	}

%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","testsmsgateways",sWebLanguage) %></td></tr>
		<tr><td class='admin' width='1%' nowrap><%=getTran(request,"web","destinationmobile",sWebLanguage) %>&nbsp;</td><td class='admin2'><input name='to' type='text' class='text' size='20' value='<%=SH.c(request.getParameter("to"))%>'/></td></tr>
		<tr><td class='admin' width='1%' nowrap><%=getTran(request,"web","message",sWebLanguage) %>&nbsp;</td><td class='admin2'><textarea name='message' class='text' cols='40'><%=txt %></textarea></td></tr>
		<tr><td class='admin' width='1%' nowrap><%=getTran(request,"web","gateway",sWebLanguage) %>&nbsp;</td><td class='admin2'>
			<select name='gateway' class='text'>
				<option <%=gw.equalsIgnoreCase("africastalking")?"selected":"" %> value='africastalking'>africastalking</option>
				<option <%=gw.equalsIgnoreCase("smsglobal")?"selected":"" %> value='smsglobal'>smsglobal</option>
				<option <%=gw.equalsIgnoreCase("bulksms")?"selected":"" %> value='bulksms'>bulksms</option>
				<option <%=gw.equalsIgnoreCase("experttexting")?"selected":"" %> value='experttexting'>experttexting</option>
				<option <%=gw.equalsIgnoreCase("hqsms")?"selected":"" %> value='hqsms'>hqsms</option>
				<option <%=gw.equalsIgnoreCase("d7")?"selected":"" %> value='d7'>d7</option>
				<option <%=gw.equalsIgnoreCase("releans")?"selected":"" %> value='releans'>releans</option>
			</select>
			
		</td></tr>
	</table>
	<input type='submit' class='button' name='send' value='Send'>
</form>