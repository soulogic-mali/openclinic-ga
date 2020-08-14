<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.STARTBACK.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.STARTBACK");'/> <%=getTran(request,"cnrkr","test.STARTBACK",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.STARTBACK.complete'/></td>
	</tr>
	<tr id='test.STARTBACK'>
		<td class='admin2' width='100%' style="vertical-align:top;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_1", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_2", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_3", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_4", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_5", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_6", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_7", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.8",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_8", "cnrkr.startback", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
				</tr>
				<tr>
					<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.pass","startback.9",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_9", "cnrkr.startback2", sWebLanguage, "onchange='calculateSTARTBACK();'") %></td>
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
		<td class='admin' nowrap width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_STARTBACK_COMMENT", 60, 1) %></td>
	</tr>
</table>
