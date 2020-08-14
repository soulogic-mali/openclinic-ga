<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","extroceptive",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","tactile",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTACTILE", "cnrkr.esthesia", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTACTILE_NERVES"><%=getTran(request,"cnrkr","affected.nerves",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTACTILE_NERVES", "cnrkr.nerves", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","thermal",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTHERMAL", "cnrkr.esthesia", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTHERMAL_NERVES"><%=getTran(request,"cnrkr","affected.nerves",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSTHERMAL_NERVES", "cnrkr.nerves", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","algesic",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSALGESIC", "cnrkr.esthesia", sWebLanguage, "") %>
					</td>
				</tr>
				<tr>
       				<td class='admin' width='20%'>
       					<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSALGESIC_NERVES"><%=getTran(request,"cnrkr","affected.nerves",sWebLanguage)%></div>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSALGESIC_NERVES", "cnrkr.nerves", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
			       	</td>
				</tr>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","proprioceptive",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","proprioceptive",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_SENSPROPRIOCEPTIVE", "cnrkr.proprioceptive", sWebLanguage, "") %>
					</td>
				</tr>
			</table>
		</td>
       	<td id='keywordstd3' class="admin2" style="vertical-align:top;padding:0px;">
       		<div style="height:200px;overflow:auto" id="keywords3"></div>
       	</td>
	</tr>
</table>