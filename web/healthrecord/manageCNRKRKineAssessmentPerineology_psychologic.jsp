<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","incontinenceimpact",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","patient",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_PSYPATIENT", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","compagnon",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_PSYCOMPAGNON", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","peers",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_PSYPEERS", 60, 1) %>
			      	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>