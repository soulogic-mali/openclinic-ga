<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","stoolfrequency",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STOOLFREQUENCY", sWebLanguage,"",0,10)%> /<%=getTran(request,"web","day",sWebLanguage) %></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","stoolconsitency",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STOOLCONSISTENCY","cnrkr.stoolconsitency", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","dyschesia",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_DYSCHESIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","incontinence",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_STOOLINCONTINENCE","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
			</table>
		</td>
	</tr>
</table>