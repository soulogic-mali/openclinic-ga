<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'><td colspan='2'><%=getTran(request,"cnrkr","drinks",sWebLanguage) %></td></tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","quality",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_QUALITY", "cnrkr.drinks", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","water",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_WATER", sWebLanguage,"", 0,10)%> <%=getTran(request,"cnrkr","literperday",sWebLanguage) %></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","soda",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_SODA", sWebLanguage,"", 0,10)%> <%=getTran(request,"cnrkr","literperday",sWebLanguage) %></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","beer",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_BEER", sWebLanguage,"", 0,10)%> <%=getTran(request,"cnrkr","literperday",sWebLanguage) %></td> 
			    </tr>
				<tr class='admin'><td colspan='2'><%=getTran(request,"cnrkr","food",sWebLanguage) %></td></tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","fruit",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_FRUIT", "cnrkr.foodquantity", sWebLanguage,"")%></td>
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","vegetables",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VEGETABLES", "cnrkr.foodquantity", sWebLanguage,"")%></td> 
			    </tr>
			</table>
		</td>
	</tr>
</table>