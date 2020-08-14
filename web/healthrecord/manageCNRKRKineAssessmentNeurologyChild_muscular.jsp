<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","tonus",sWebLanguage) %></center></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","normal",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.tonus.locations", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_TONUSNORMAL", sWebLanguage, true) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","hypotonie",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.tonus.locations", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_TONUSHYPOTONIE", sWebLanguage, true) %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","hypertonie",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<td width='15%'>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_HYPERTONIE", "cnrkr.hypertonie", sWebLanguage, "") %>
			       				</td>
			       				<td>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_HYPERTONIETEXT", 30, 1) %>
			       				</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","fluctuation",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FLUCTUATION", "cnrkr.yesno", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","elasticity",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","shoulderflexors",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_SHOULDERFLEXORSHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_SHOULDERFLEXORSNORMO", sWebLanguage, true) %></td>
       							<td class='admin'><%=getTran(request,"cnrkr","deltoidabductor",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_DELTOIDABDHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_DELTOIDABDNORMO", sWebLanguage, true) %></td>
       						</tr>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","shoulderadductor",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_SHOULDERADDHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_SHOULDERADDNORMO", sWebLanguage, true) %></td>
       							<td class='admin'><%=getTran(request,"cnrkr","rhomboids",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_RHOMBOIDSHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_RHOMBOIDSNORMO", sWebLanguage, true) %></td>
       						</tr>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","elbowflexors",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ELBOWFLEXHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ELBOWFLEXNORMO", sWebLanguage, true) %></td>
       							<td class='admin'><%=getTran(request,"cnrkr","wristflex",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_WRISTFLEXHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_WRISTFLEXNORMO", sWebLanguage, true) %></td>
       						</tr>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","hipadductors",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_HIPADDHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_HIPADDNORMO", sWebLanguage, true) %></td>
       							<td class='admin'><%=getTran(request,"cnrkr","rightanterior",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_RIGHTADDHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_RIGHTADDNORMO", sWebLanguage, true) %></td>
       						</tr>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","iliopsoas2",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ILIOPSOASHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ILIOPSOASNORMO", sWebLanguage, true) %></td>
       							<td class='admin'><%=getTran(request,"cnrkr","ischioleg",sWebLanguage) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","hypoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ISCHIOLEGHYPO", sWebLanguage, true) %></td>
       							<td class='admin2'><%=getTran(request,"cnrkr","normoextensible",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.rightleft", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ISCHIOLEGNORMO", sWebLanguage, true) %></td>
       						</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='9'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_ELASTICITYCOMMENT", 60, 1) %>
						       	</td>
							</tr>
       					</table>
			       	</td>
				</tr>
			</table>
		</td>
	</tr>
</table>