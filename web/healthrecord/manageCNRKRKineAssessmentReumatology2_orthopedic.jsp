<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ORTHODEFORM"><%=getTran(request,"cnrkc","deformations",sWebLanguage) %></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_ORTHODEFORM", "cnrkr.deformations", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
				   	</td>
				</tr>
			</table>
		</td>
       	<td id='keywordstd3' class="admin2" style="vertical-align:top;padding:0px;">
       		<div style="height:200px;overflow:auto" id="keywords3"></div>
       	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>	