<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>
    <%String type="";int level; %>
	<table class="list" width="100%" border="0" cellspacing="1" cellpadding="0">
		<tr>
			<td class='admin'><%=getTran(request,"triage","priority",sWebLanguage) %></td>
			<td class='triagelarge2'><span style='font-size: 12px' id='triage.phase3.priority'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"triage","prioritydescription",sWebLanguage) %></td>
			<td class='triagelarge2'><span style='font-size: 12px' id='triage.phase3.prioritydescription'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"triage","waitingtime",sWebLanguage) %></td>
			<td class='triagelarge2'><span style='font-size: 12px' id='triage.phase3.waitingtime'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"triage","evaluationfrequency",sWebLanguage) %></td>
			<td class='triagelarge2'><span style='font-size: 12px' id='triage.phase3.evaluationfrequency'/></td>
		</tr>
    </table>
</logic:present>