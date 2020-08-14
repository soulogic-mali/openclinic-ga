<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","weight",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_WEIGHT", 4, sWebLanguage, "if(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value*1>0) document.getElementById(\"bmi\").value=(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_WEIGHT\").value*1/(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value*document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value)).toFixed(1);")%> kg</td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","height",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT", 4, sWebLanguage, "if(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value*1>0) document.getElementById(\"bmi\").value=(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_WEIGHT\").value*1/(document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value*document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_HEIGHT\").value)).toFixed(1);")%> m</td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","bmi",sWebLanguage)%></td>
					<td class='admin2'><input type='text' id='bmi' size='4'/></td> 
					<td class='admin2' colspan='2'/> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","lumbararrow",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_LUMBARARROW", 4, sWebLanguage, "")%> cm</td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","cervicalarrow",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CERVICALARROW", 4, sWebLanguage, "")%> cm</td> 
					<td class='admin2' colspan='4'/> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","anteriorsuspension",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ANTERIORSUSPENSION","cnrkr.yesno", sWebLanguage,"")%></td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","posteriorsuspension",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_POSTERIORSUSPENSION","cnrkr.yesno", sWebLanguage,"")%></td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","anteversion",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ANTEVERSION","cnrkr.yesno", sWebLanguage,"")%></td> 
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","retroversion",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_RETROVERSION","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
			</table>
		</td>
	</tr>
</table>