<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","endovaginalmaterial",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ENDOVAGINALMATERIAL","cnrkr.endovaginalmaterial", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","dyspareunia",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_DYSPAREUNIA","cnrkr.dispareunia", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","vaginisme",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VAGINISM","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","apareunia",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_APAREUNIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","anorgasmia",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ANORGASMIA","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","menopause",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_MENOPAUSE","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","frigidity",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_FRIGIDITY","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","impotence",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_IMPOTENCE","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","ejaculation",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction,request,"cnrkr.ejaculation", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_EJACULATION", sWebLanguage,true)%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","priapism",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PRIAPISM","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
				<tr>
       				<td class='admin' width='15%'><%=getTran(request,"cnrkr","peyronie",sWebLanguage)%></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PEYRONIE","cnrkr.yesno", sWebLanguage,"")%></td> 
			    </tr>
			</table>
		</td>
	</tr>
</table>