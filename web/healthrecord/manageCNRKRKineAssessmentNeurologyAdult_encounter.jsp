<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","complaints",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request, "cnrkr.neuroadult.complaints","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_COMPLAINTS", sWebLanguage, true) %>
						&nbsp;&nbsp;<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_COMPLAINTSTEXT", 30, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","symptoms.evolution",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SYMPTOMSEVOLUTION", 60, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_EVENTMODE"><%=getTran(request,"cnrkr","eventmode",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_EVENTMODE", "cnrkr.eventmode", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOCIATEDSIGNS"><%=getTran(request,"cnrkr","associatedsigns",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ASSOCIATEDSIGNS", "cnrkr.associatedsigns", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
	    		<div id=test'></div>
    		<div style="height:200px;overflow:auto;position: sticky" id="keywords"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>