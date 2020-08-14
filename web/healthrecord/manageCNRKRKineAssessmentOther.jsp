<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='25%'>
						<%=getTran(request,"cnrkr","diagnosis",sWebLanguage)%>
					</td>
					<td class='admin'>
						<%=getTran(request,"cnrkr","results",sWebLanguage)%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG1", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT1", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG2", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT2", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG3", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT3", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG4", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT4", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG5", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT5", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG6", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT6", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG7", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT7", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERDIAG8", 30, 1) %>
			      	</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_OTHERRESULT8", 60, 1) %>
			      	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>