<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","pain",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAIN", "cnrkr.yesno", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINLOCATION"><%=getTran(request,"cnrkr","pain.location",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINLOCATION", "cnrkr.pain.location2", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","scheme",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINSCHEME", "cnrkr.painscheme", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINTYPE"><%=getTran(request,"cnrkr","pain.type",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINTYPE", "cnrkr.pain.type2", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINCAUSINGFACTORS"><%=getTran(request,"cnrkr","pain.causingfactors",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINCAUSINGFACTORS", "cnrkr.pain.causingfactors", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINWORSENINGFACTORS"><%=getTran(request,"cnrkr","pain.worseningfactors",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINWORSENINGFACTORS", "cnrkr.pain.worseningfactors", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINMITIGATINGFACTORS"><%=getTran(request,"cnrkr","pain.mitigatingfactors",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINMITIGATINGFACTORS", "cnrkr.pain.mitigatingfactors", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINMOBILISATION"><%=getTran(request,"cnrkr","pain.mobilisation",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINMOBILISATION", "cnrkr.pain.mobilisation2", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","pain.palpation",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
       							<td width='50%'>
			       					<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pain.palpation", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINPALPATION", sWebLanguage, true) %>
			       				</td>
			       				<td>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINPALPATIONTEXT", 30, 1) %>
			       				</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","pain.projected",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
       							<td width='50%'>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINPROJECTED", "cnrkr.yesno", sWebLanguage, "") %>
			       				</td>
			       				<td>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAINPROJECTEDTEXT", 30, 1) %>
			       				</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","pain.intensity",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%'>
       						<tr>
       							<td width='25%'>
       								<%=getTran(request,"cnrkr","evarest",sWebLanguage) %>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAININTENSITY_EVAREST", "cnrkr.pain.intensity", sWebLanguage, "") %>
			       				</td>
       							<td width='25%'>
       								<%=getTran(request,"cnrkr","enrest",sWebLanguage) %>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAININTENSITY_ENREST", "cnrkr.pain.intensity", sWebLanguage, "") %>
			       				</td>
       							<td width='25%'>
       								<%=getTran(request,"cnrkr","evaactivity",sWebLanguage) %>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAININTENSITY_EVAACTIVITY", "cnrkr.pain.intensity", sWebLanguage, "") %>
			       				</td>
       							<td width='25%'>
       								<%=getTran(request,"cnrkr","enactivity",sWebLanguage) %>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY2_PAININTENSITY_ENACTIVITY", "cnrkr.pain.intensity", sWebLanguage, "") %>
			       				</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
			</table>
		</td>
       	<td width='30%' id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
	    	<div id=test'></div>
    		<div style="height:200px;overflow:auto;position: sticky" id="keywords"></div>
       	</td>
	</tr>
</table>