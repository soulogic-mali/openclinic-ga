<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","currentvolume",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CURRENTVOLUME", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","vitalcapacity",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_VITALCAPACITY", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","tiffeneau",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_TIFFENEAU", 5, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","inspiratoryreserve",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_INSPRESERVE", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","residualcapacity",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESIDUALCAPACITY", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","expiratory.peakflow",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EXPEAKFLOW", 5, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","expiratoryreserve",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EXPRESERVE", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","inspiratorycapacity",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_INSPCAPACITY", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","expiratory.peakflow.forced",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EXPEAKFLOWFORCED", 5, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr","totallungcapacity",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_TOTALLUNG", 5, sWebLanguage) %> ml
		</td>
		<td class='admin'><%=getTran(request,"cnrkr","1second",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_1SECOND", 5, sWebLanguage) %> ml
		</td>
		<td class='admin2' colspan='2'></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2' colspan='5'>
			<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_FUNCCOMMENT", 60, 1) %>
		</td>
	</tr>
</table>