<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr","alimentation",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_ALIMENTATION","cnrkr.alimentation",  sWebLanguage, "") %>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","difficulties",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","locution",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_LOCUTION","cnrkr.alimentation",  sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","avj",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AVJ","cnrkr.alimentation",  sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","stairsup",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_STAIRSUP","cnrkr.difficulties",  sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","stairsdown",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_STAIRSDOWN","cnrkr.difficulties",  sWebLanguage, "") %></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","6minuteswalk",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='25%'>SpO2</td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","start",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SPO2START", 4, sWebLanguage) %> %</td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","arrival",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SPO2END", 4, sWebLanguage) %> %</td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","8minutes",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SPO28MIN", 4, sWebLanguage) %> %</td>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","heartfrequency",sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","start",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_HFSTART", 4, sWebLanguage) %> <%=getTran(request,"web","bpm",sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","arrival",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_HFEND", 4, sWebLanguage) %> <%=getTran(request,"web","bpm",sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","8minutes",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_HF8MIN", 4, sWebLanguage) %> <%=getTran(request,"web","bpm",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","respiratoryfrequency",sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","start",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RFSTART", 4, sWebLanguage) %> /min</td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","arrival",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RFEND", 4, sWebLanguage) %> /min</td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","8minutes",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RF8MIN", 4, sWebLanguage) %> /min</td>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","dyspnoe",sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","start",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DYSPNOESTART", 4, sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","arrival",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DYSPNOEEND", 4, sWebLanguage) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","8minutes",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DYSPNOE8MIN", 4, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","distance",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DISTANCE", 4, sWebLanguage) %> m</td>
					<td class='admin2' colspan='5'/>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","distance.theoretical",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DISTANCETHEORETICAL", 4, sWebLanguage) %> m</td>
					<td class='admin2' colspan='5'/>
				</tr>
				<tr>
					<td class='admin' width='25%'><%=getTran(request,"cnrkr","distance.limit",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_DISTANCELIMIT", 4, sWebLanguage) %> m</td>
					<td class='admin2' colspan='5'/>
				</tr>
			</table>
		</td>
	</tr>
</table>