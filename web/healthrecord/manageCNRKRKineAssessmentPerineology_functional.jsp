<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","padtest",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PADTEST", 3, sWebLanguage) %> ml
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","stoppipi",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STOPPIPI","cnrkr.posneg", sWebLanguage, "") %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","ditrovie",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_DITROVIE", 3, sWebLanguage) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","mictioncalendar",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_MICTIONCALENDAR", 60, 1) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","physicaldeconditioning",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PHYSDECON","cnrkr.physicaldeconditioning", sWebLanguage, "") %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","dailyactivities",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_DAILYACTIVITIES","cnrkr.dailyactivities", sWebLanguage, "") %>
			      	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>