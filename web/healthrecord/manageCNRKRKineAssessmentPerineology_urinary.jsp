<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","cleanage",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CLEANAGE", 2, sWebLanguage)%> <%=getTran(request,"web","years",sWebLanguage) %></td>
			    </tr>
				<tr>
					<td class='admin' width='15%'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_INCONTINENCE"><%=getTran(request,"cnrkr","incontinence",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_INCONTINENCE", "cnrkr.incontinence", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","pollakiuria",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_POLLAKIURIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","nycturia",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_NYCTURIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","dysuria",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_DYSURIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","retention",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_RETENTION","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","garniture",sWebLanguage)%></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_GARNITURE", "cnrkr.yesno",sWebLanguage,"")%>
						&nbsp;&nbsp;<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_GARNITUREFREQ", sWebLanguage,"",0,10)%> /<%=getTran(request,"web","day",sWebLanguage) %>
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