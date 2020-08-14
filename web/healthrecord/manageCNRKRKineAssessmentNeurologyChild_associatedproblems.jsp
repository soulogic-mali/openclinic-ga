<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.sensitive",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.associatedproblems.sensitive", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_SENSITIVE", sWebLanguage, true) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.epilepsy",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_EPILEPSY", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.sphincter",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_SPHINCTER", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.mutism",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_MUTISM", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.nutrion",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_NUTRITION", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.digestive",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_DIGESTIVE", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","problems.respiratory",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_RESPIRATORY", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"web","other",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ASSOCIATEDPROBLEMS_OTHER", 60, 1) %>
			       	</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd2' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords2"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>