<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","lasegue.lumbar",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECLASEGUELUMBAR", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","lasegue.real",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECLASEGUEREAL", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","lasegue.bragard",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECLASEGUEBRAGARD", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","lasegue.crossed",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECLASEGUECROSSED", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","vasalva",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECVASALVA", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","roger.bikila",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECROGERBIKILA", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
			</table>
		</td>
		<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","leri",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECLERI", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","compression",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECCOMPRESSION", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","decompression",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECDECOMPRESSION", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","convergence",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECCONVERGENCE", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","divergence",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPECDIVERGENCE", "cnrkr.posneg", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SPEC_COMMENT", 30, 1) %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>