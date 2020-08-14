<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<%String m="VENTRALLYING"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="DORSALLYING"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="LATERALLYING"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="LATERALLYINGUP"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="VENTRALLYINGELBOW"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       						<tr>
       							<% m="VENTRALLYINGHANDS"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       							<% m="SITTINGGROUND"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="SITTINGCHAIR"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="FEETANDHANDS"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="CHEVALIER"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
       						<tr>
       							<% m="STANDING"; %>
       							<td class='admin' width='20%'><%=getTran(request,"cnrkr",m,sWebLanguage) %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","axialcontrol",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_AXIALCONTROL", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","stability",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_STABILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","mobility",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_MOBILITY", "cnrkr.goodbad", sWebLanguage, "") %></td>
       							<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr","positionchange",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_"+m+"_POSITIONCHANGE", "cnrkr.goodbad", sWebLanguage, "") %></td>
       						</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","other",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='8'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_POSTURALOTHER", 60, 1) %>
						       	</td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='8'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_POSTURALCOMMENT", 60, 1) %>
						       	</td>
							</tr>
       					</table>
			       	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>