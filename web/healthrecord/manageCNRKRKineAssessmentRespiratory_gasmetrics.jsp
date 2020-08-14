<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin'>PaO2</td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_PAO2",  sWebLanguage, "",0,10) %>
		</td>
	</tr>
	<tr>
		<td class='admin'>PaCO2</td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_PACO2",  sWebLanguage, "",0,10) %>
		</td>
	</tr>
	<tr>
		<td class='admin'>Sa(p)O2</td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SAPAO2",  sWebLanguage, "",0,10) %>
		</td>
	</tr>
	<tr>
		<td class='admin'>PH</td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_PH",  sWebLanguage, "",0,10) %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_GASOMETRYCOMMENT", 60, 1) %>
		</td>
	</tr>
</table>