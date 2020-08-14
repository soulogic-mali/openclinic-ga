<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_VESICOSPHINCTER"><%=getTran(request,"cnrkr","vesico.sphincter",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_VESICOSPHINCTER", "cnrkr.vesicosphincter", "keywords6", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_CUTANEOTROPHIC"><%=getTran(request,"cnrkr","cutaneotrophic.problems",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_CUTANEOTROPHIC", "cnrkr.cutaneotrophic", "keywords6", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"cnrkr","sensitiveproblems",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.neuroadult.sensproblems", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_SENSPROBLEMS", sWebLanguage, true) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"cnrkr","respiratoryproblems",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.neuroadult.respproblems", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOC_RESPPROBLEMS", sWebLanguage, true,"","") %>
			      	</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd6' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords6"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>