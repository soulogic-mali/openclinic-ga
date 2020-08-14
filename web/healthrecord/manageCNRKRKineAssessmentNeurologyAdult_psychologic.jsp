<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","concentrationloss",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_CONCENTRATIONLOSS", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","depression",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_DEPRESSION", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","emotion",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_EMOTION", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","apathie",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_APATHIA", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","anxiety",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ANXIETY", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_PSYCHO_COMMENT", 60, 1) %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>