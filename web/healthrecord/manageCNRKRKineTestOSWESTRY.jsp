<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.OSWESTRY.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.OSWESTRY");'/> <%=getTran(request,"cnrkr","test.OSWESTRY",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.OSWESTRY.complete'/></td>
	</tr>
</table>
<div id='test.OSWESTRY'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_1_TD'><%=getTran(request,"cnrkr.oswestry","question1",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.1", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_1", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_2_TD'><%=getTran(request,"cnrkr.oswestry","question2",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.2", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_2", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_3_TD'><%=getTran(request,"cnrkr.oswestry","question3",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.3", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_3", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_4_TD'><%=getTran(request,"cnrkr.oswestry","question4",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.4", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_4", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_5_TD'><%=getTran(request,"cnrkr.oswestry","question5",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.5", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_5", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
				</table>
			</td>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_6_TD'><%=getTran(request,"cnrkr.oswestry","question6",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.6", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_6", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_7_TD'><%=getTran(request,"cnrkr.oswestry","question7",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.7", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_7", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_8_TD'><%=getTran(request,"cnrkr.oswestry","question8",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.8", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_8", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_9_TD'><%=getTran(request,"cnrkr.oswestry","question9",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.9", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_9", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='adminwhite'></td>
					</tr>
					<tr>
						<td class='admin' id='ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_10_TD'><%=getTran(request,"cnrkr.oswestry","question10",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnrkr.oswestry.10", "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_10", sWebLanguage, true, "onchange='calculateOSWESTRY();'", "<br/>") %>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_OSWESTRY_COMMENT", 60, 1) %></td>
	</tr>
</table>
