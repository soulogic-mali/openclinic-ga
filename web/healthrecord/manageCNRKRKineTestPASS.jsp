<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.PASS.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.PASS");'/> <%=getTran(request,"cnrkr","test.PASS",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.PASS.complete'/></td>
	</tr>
	<tr id='test.PASS'>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='15%' rowspan='11'><%=getTran(request,"cnrkr.pass","mobility",sWebLanguage) %></td>
					<td class='admin' colspan='2'><%=getTran(request,"cnrkr","lyingonback",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","turnonhemiplegicside",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_1", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","turnonhealthyside",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_2", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","turnonbobathplan",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_3", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin' colspan='2'><%=getTran(request,"cnrkr.pass","sittingonbobathplan",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","lyingonback",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_4", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","gettingup",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_5", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin' colspan='2'><%=getTran(request,"cnrkr.pass","standing",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","sittingdown",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_6", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","pickupobject",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_7", "cnrkr.pass.mobility", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><b><%=getTran(request,"cnrkr.pass","totalon21",sWebLanguage) %></b></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL1", 2, sWebLanguage,"") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' width='15%' rowspan='6'><%=getTran(request,"cnrkr.pass","balance",sWebLanguage) %></td>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","sitwithoutsupport",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_8", "cnrkr.pass.sitting", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","standwithsupport",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_9", "cnrkr.pass.standingwithsupport", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","standwithoutsupport",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_10", "cnrkr.pass.standingwithoutsupport", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","monopodalhemiplegic",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_11", "cnrkr.pass.monopodal", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.pass","monopodalhealthy",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_12", "cnrkr.pass.monopodal", sWebLanguage, "onchange='calculatePASS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='1%' nowrap><b><%=getTran(request,"cnrkr.pass","totalon15",sWebLanguage) %></b></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL2", 2, sWebLanguage,"") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_PASS_COMMENT", 60, 1) %></td>
	</tr>
</table>