<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","globalmobility",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
       						<tr>
       							<td class='admin' width='15%'><%=getTran(request,"cnrkr","shoulder",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SHOULDER", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","elbow",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_ELBOW", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","wrist",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WRIST", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","fingers",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FINGERS", "cnrkr.goodbad", sWebLanguage, "")%></td>
       						</tr>
       						<tr>
       							<td class='admin'><%=getTran(request,"cnrkr","hip",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HIP", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","knee",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_KNEE", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","foot",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FOOT", "cnrkr.goodbad", sWebLanguage, "")%></td>
       							<td class='admin'><%=getTran(request,"cnrkr","toes",sWebLanguage) %></td>
       							<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TOES", "cnrkr.goodbad", sWebLanguage, "")%></td>
       						</tr>
							<tr class='admin'>
								<td colspan='8'><%=getTran(request,"cnrkr","evapain",sWebLanguage) %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","eva",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EVA", sWebLanguage, "", 0, 10) %></td>
								<td class='admin'><%=getTran(request,"cnrkr","en",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EN", sWebLanguage, "", 0, 10) %></td>
								<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
								<td class='admin2' nowrap colspan='3'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CARDIOCOMMENT", 30, 1) %></td>
							</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_MALFORMATIONS"><%=getTran(request,"cnrkr","malformations",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_MALFORMATIONS", "cnrkr.neuroadult.malformations", "keywords4", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd4' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords4"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>