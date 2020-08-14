<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.BBS.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.BBS");'/> <%=getTran(request,"cnrkr","test.BBS",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.BBS.complete'/></td>
	</tr>
</table>
<div id='test.BBS'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_1_TD'><%=getTran(request,"cnrkr.bbs","sittingtostanding",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.1", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_1", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_2_TD'><%=getTran(request,"cnrkr.bbs","staystanding",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.2", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_2", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_3_TD'><%=getTran(request,"cnrkr.bbs","staysitting",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.3", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_3", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_4_TD'><%=getTran(request,"cnrkr.bbs","standup",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.4", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_4", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_5_TD'><%=getTran(request,"cnrkr.bbs","transfers",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.5", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_5", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_6_TD'><%=getTran(request,"cnrkr.bbs","staystandingeyesclosed",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.6", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_6", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_7_TD'><%=getTran(request,"cnrkr.bbs","staystandingfeettogether",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.7", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_7", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
				</table>
			</td>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_8_TD'><%=getTran(request,"cnrkr.bbs","walkarmsstretched",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.8", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_8", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_9_TD'><%=getTran(request,"cnrkr.bbs","pickupobject",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.9", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_9", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_10_TD'><%=getTran(request,"cnrkr.bbs","lookbehind",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.10", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_10", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_11_TD'><%=getTran(request,"cnrkr.bbs","pivot",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.11", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_11", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_12_TD'><%=getTran(request,"cnrkr.bbs","alternatefeet",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.12", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_12", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_13_TD'><%=getTran(request,"cnrkr.bbs","staystandinfeetinline",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.13", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_13", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_BBS_14_TD'><%=getTran(request,"cnrkr.bbs","staystandingoneleg",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.bbs.14", "ITEM_TYPE_CNRKR_KINE_TEST_BBS_14", sWebLanguage, true, "onchange='calculateBBS();'", "<br/>") %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_BBS_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_BBS_COMMENT", 60, 1) %></td>
	</tr>
</table>
