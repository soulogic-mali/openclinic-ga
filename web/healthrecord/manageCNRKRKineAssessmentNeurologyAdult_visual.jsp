<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_VISUALFIELD"><%=getTran(request,"cnrkr","visualfield",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_VISUALFIELD", "cnrkr.visualfield", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","oculomotricity",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_OCULOMOTRICITY", "cnrkr.goodbad", sWebLanguage, "") %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","conjugatedmovements",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_CONJUGATEDMOVEMENTS", "cnrkr.goodbad", sWebLanguage, "") %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","nystagmus",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NYSTAGMUS", "cnrkr.absentpresent", sWebLanguage, "") %>
			      	</td>
				</tr>
				<tr>
					<td class='admin' width='15%'>
						<%=getTran(request,"cnrkr","other",sWebLanguage)%>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_VISUALOTHER", 60, 1) %>
			      	</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd3' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords3"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>