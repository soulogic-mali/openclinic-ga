<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","general.state",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
       						<tr>
       							<td width='50%'>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_GENERALSTATE", "cnrkr.general.state", sWebLanguage, "") %>
			       				</td>
			       				<td>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_GENERALSTATETEXT", 30, 1) %>
			       				</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","patient.eye",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EYE", "cnrkr.eye", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","mucosa.color",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUCOSACOLOR", "cnrkr.mucosacolor", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","respiratoryfrequency",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPFREQUENCY", sWebLanguage, "",1,60) %> /min
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTYPE"><%=getTran(request,"cnrkr","respirationtype",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTYPE", "cnrkr.respirationtype", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTIRAGE"><%=getTran(request,"cnrkr","tirage",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTIRAGE", "cnrkr.tirage", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPOTHERSIGNS"><%=getTran(request,"cnrkr","othersigns",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPOTHERSIGNS", "cnrkr.respothersigns", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","morphostaticevaluation",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTHORAXMALFORMATION"><%=getTran(request,"cnrkr","thoraxmalformation",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPTHORAXMALFORMATION", "cnrkr.thoraxmalformation", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPRACHISMALFORMATION"><%=getTran(request,"cnrkr","rachismalformation",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPRACHISMALFORMATION", "cnrkr.rachismalformation", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","expectoration",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","present",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONPRESENT", "cnrkr.yesno", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","numberofexpectorations",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONNUMBER", 3,sWebLanguage) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","volumeofexpectorations",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONVolume", 3,sWebLanguage) %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","vomic",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONVOMIC", "cnrkr.yesno", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","quality",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table>
       						<tr>
       							<td>
       								<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.expectorans.type","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONQUALITY", sWebLanguage,true) %>
       							</td>
       						</tr>
       						<tr>
       							<td>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONQUALITYTEXT", 60, 1) %>
       							</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","odor",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPEXPECTORATIONODOR", "cnrkr.odor", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","other",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","percussion",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_RESPPERCUSSIONR", "cnrkr.percussion", sWebLanguage, "") %>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","auscultation.rightlung",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table>
       						<tr>
       							<td colspan='2' width='33%' class='admin'><%=getTran(request,"cnrkc","upperlobe",sWebLanguage) %></td>
       							<td colspan='2' width='33%' class='admin'><%=getTran(request,"cnrkc","middlelobe",sWebLanguage) %></td>
       							<td colspan='2' class='admin'><%=getTran(request,"cnrkc","lowerlobe",sWebLanguage) %></td>
       						</tr>
       						<tr>
       							<td class='admin2' nowrap><%=getTran(request,"cnrkc","vesicalmurmur",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCUPPERMURMURRIGHT", "cnrkr.auscultation.vesicular", sWebLanguage, "") %>
       							</td>
       							<td class='admin2' nowrap><%=getTran(request,"cnrkc","vesicalmurmur",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCMIDDLEMURMURRIGHT", "cnrkr.auscultation.vesicular", sWebLanguage, "") %>
       							</td>
       							<td class='admin2' nowrap><%=getTran(request,"cnrkc","vesicalmurmur",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCLOWERMURMURRIGHT", "cnrkr.auscultation.vesicular", sWebLanguage, "") %>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin2'><%=getTran(request,"cnrkc","rales",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCUPPERRALERIGHT", "cnrkr.auscultation.rales", sWebLanguage, "") %>
       							</td>
       							<td class='admin2'><%=getTran(request,"cnrkc","rales",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCMIDDLERALERIGHT", "cnrkr.auscultation.rales", sWebLanguage, "") %>
       							</td>
       							<td class='admin2'><%=getTran(request,"cnrkc","rales",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCLOWERRALERIGHT", "cnrkr.auscultation.rales", sWebLanguage, "") %>
       							</td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","auscultation.leftlung",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<table>
       						<tr>
       							<td colspan='2' width='33%' class='admin'><%=getTran(request,"cnrkc","upperlobe",sWebLanguage) %></td>
       							<td colspan='2' width='33%' class='admin'><%=getTran(request,"cnrkc","lowerlobe",sWebLanguage) %></td>
       							<td colspan='2'></td>
       						</tr>
       						<tr>
       							<td class='admin2' nowrap><%=getTran(request,"cnrkc","vesicalmurmur",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCUPPERMURMURLEFT", "cnrkr.auscultation.vesicular", sWebLanguage, "") %>
       							</td>
       							<td class='admin2' nowrap><%=getTran(request,"cnrkc","vesicalmurmur",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCLOWERMURMURLEFT", "cnrkr.auscultation.vesicular", sWebLanguage, "") %>
       							</td>
       							<td colspan='2'></td>
       						</tr>
       						<tr>
       							<td class='admin2'><%=getTran(request,"cnrkc","rales",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCUPPERRALELEFT", "cnrkr.auscultation.rales", sWebLanguage, "") %>
       							</td>
       							<td class='admin2'><%=getTran(request,"cnrkc","rales",sWebLanguage) %></td>
       							<td>
			       					<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AUSCLOWERRALELEFT", "cnrkr.auscultation.rales", sWebLanguage, "") %>
       							</td>
       							<td colspan='2'></td>
       						</tr>
       					</table>
			       	</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<%=getTran(request,"cnrkr","comment",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_OBSCOMMENT", 60, 1) %>
			       	</td>
				</tr>
			</table>
		</td>
       	<td width="30%" id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
	    	<div id=test'></div>
    		<div style="height:200px;overflow:auto;position: sticky" id="keywords"></div>
       	</td>
	</tr>
</table>