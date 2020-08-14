<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"cnrkc","exteroceptive.sensitivity",sWebLanguage) %>
		</td>
		<td class='admin2'>
			<table width='100%'>
				<tr>
					<td width='30%'>
 						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSEXTEROCEPTIVE", "cnrkr.esthesia", sWebLanguage, "") %>
 					</td>
 					<td>
 						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSEXTEROCEPTIVETEXT", 30, 1) %>
 					</td>
	   			</tr>
	   		</table>
	   	</td>
	</tr>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"cnrkc","propioceptive.sensitivity",sWebLanguage) %>
		</td>
		<td class='admin2'>
			<table width='100%'>
				<tr>
					<td width='30%'>
 						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSPROPRIOCEPTIVE", "cnrkr.sensitivity.propioceptive", sWebLanguage, "") %>
 					</td>
 					<td>
 						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSPROPIOCEPTIVETEXT", 30, 1) %>
 					</td>
	   			</tr>
	   		</table>
	   	</td>
	</tr>
	<tr>
		<td class='admin' width='20%'>
			<%=getTran(request,"cnrkc","paresthesia",sWebLanguage) %>
		</td>
		<td class='admin2'>
			<table width='100%'>
				<tr>
					<td width='30%'>
 						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSPARESTESIA", "cnrkr.yesno", sWebLanguage, "") %>
 					</td>
 					<td>
 						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_SENSPARESTESIATEXT", 30, 1) %>
 					</td>
	   			</tr>
	   		</table>
	   	</td>
	</tr>
</table>	