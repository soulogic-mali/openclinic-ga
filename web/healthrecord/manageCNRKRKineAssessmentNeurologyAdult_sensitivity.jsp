<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","exteroceptive",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tactile",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request, "cnrkr.neuroadult.exteroceptive","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSTACTILE", sWebLanguage, true) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","thermal",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request, "cnrkr.neuroadult.exteroceptive","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSTHERMAL", sWebLanguage, true) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","algesic",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request, "cnrkr.neuroadult.exteroceptive","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSALGESIC", sWebLanguage, true) %>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","proprioceptive",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","arthrokinetic",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSARTHROKINETIC", "cnrkr.gooddisturbed", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","positional",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSPOSITIONAL", "cnrkr.gooddisturbed", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","vibrating",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SENSVIBRATING", "cnrkr.gooddisturbed", sWebLanguage, "") %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>