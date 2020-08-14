<%@ page import="be.openclinic.adt.Queue" %>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<form name='transactionForm' method='post'>
	<table>
		<tr>
			<td class='admin'>
				<select name='queueendreason' class='text'>
					<%=ScreenHelper.writeSelect(request,"queueendreason",MedwanQuery.getInstance().getConfigString("defaultResetQueueEndReason","99"),sWebLanguage) %>
				</select>
				<input class='button' type='submit' name='resetqueue' value='<%=getTran(null,"web","reset",sWebLanguage) %>'/>
			</td>
		</tr>
	</table>
</form>

<%
	if(request.getParameter("resetqueue")!=null){
		Queue.resetQueues(request.getParameter("queueendreason"),Integer.parseInt(activeUser.userid));
		out.println(getTran(request,"web","queueshavebeenreset",sWebLanguage));
	}
%>