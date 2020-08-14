<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td width='70%' class='admin2' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","NEM",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nem1",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NEM1", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nem2",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NEM2", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nem3",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_NEM3", "cnrkr.ease", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","NEMT",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nemt1",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NEMT1", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nemt2",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NEMT2", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nemt3",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_NEMT3", "cnrkr.ease", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin'><%=getTran(request,"cnrkr","walk.caracteristics",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","walk.length",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WALKLENGTH", 3, sWebLanguage) %> m</td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","walk.rithm",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WALKRITHM", 3, sWebLanguage) %> m</td>
								<td class='admin2 colspan='2'/>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WALKERRORS"><%=getTran(request,"cnrkr","walkerrors",sWebLanguage)%></div>
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WALKERRORS", "cnrkr.walkerrors", "keywords7", sCONTEXTPATH, sWebLanguage,request) %>
			      	</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","technicalaid",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.technicalaid", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TECHNICALAID", sWebLanguage, true)%></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","stairs",sWebLanguage) %></td>
					<td class='admin2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","upstairs",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_UPSTAIRS", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","downstairsnoaid",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_DOWNSTAIRSNOAID", "cnrkr.ease", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","downstairswithaid",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_DOWNSTAIRSWITHAID", "cnrkr.ease", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","test.10m",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TEST10M", 3, sWebLanguage) %> s</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","test.6min",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_TEST6MIN", 3, sWebLanguage) %> m</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd7' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords7"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
</table>