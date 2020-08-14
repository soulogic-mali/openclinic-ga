<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
       				<td class='admin' width='30%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOOBSERVATION_FACE"><%=getTran(request,"cnrkr","morphology.face",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOOBSERVATION_FACE", "cnrkr.morphology.face", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='30%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOOBSERVATION_PROFILE"><%=getTran(request,"cnrkr","morphology.profile",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOOBSERVATION_PROFILE", "cnrkr.morphology.profile", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='30%'>
       					<%=getTran(request,"cnrkr","morphology.flexlumb",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOFLEXLUMB", 5, sWebLanguage) %> cm
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='30%'>
       					<%=getTran(request,"cnrkr","morphology.flexcerv",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_MORPHOFLEXCERV", 5, sWebLanguage) %> cm
			       	</td>
				</tr>
			</table>
		</td>
       	<td id='keywordstd2' class="admin2" style="vertical-align:top;padding:0px;">
       		<div style="height:200px;overflow:auto" id="keywords2"></div>
       	</td>
	</tr>
</table>