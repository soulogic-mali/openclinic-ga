<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_CONSCIENCE"><%=getTran(request,"cnrkr","conscience",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_CONSCIENCE", "cnrkr.conscience", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LANGUAGEPROBLEMS"><%=getTran(request,"cnrkr","languageproblems",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LANGUAGEPROBLEMS", "cnrkr.languageproblems", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_AGNOSIA"><%=getTran(request,"cnrkr","agnosia",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_AGNOSIA", "cnrkr.agnosia", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_APRAXIA"><%=getTran(request,"cnrkr","apraxia",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_APRAXIA", "cnrkr.apraxia", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_MEMORYPROBLEMS"><%=getTran(request,"cnrkr","memoryproblems",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_MEMORYPROBLEMS", "cnrkr.memoryproblems", "keywords2", sCONTEXTPATH, sWebLanguage,request) %>
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