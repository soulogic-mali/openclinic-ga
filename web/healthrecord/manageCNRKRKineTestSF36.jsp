<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.SF36.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.SF36");'/> <%=getTran(request,"cnrkr","test.SF36",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.SF36.complete'/></td>
	</tr>
	<tr id='test.SF36'>
		<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
					<td class='admin' width='30%'><%=getTran(request,"cnrkr.sf36","chapter1",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_1", "cnrkr.sf36.options1", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","chapter2",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_2", "cnrkr.sf36.options2", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='10'><%=getTran(request,"cnrkr.sf36","chapter3",sWebLanguage) %></td>
					<td class='admin' width='30%'><%=getTran(request,"cnrkr.sf36","question3a",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_3", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3b",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_4", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3c",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_5", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3d",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_6", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3e",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_7", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3f",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_8", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3g",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_9", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3h",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_10", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3i",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_11", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question3j",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_12", "cnrkr.sf36.options3", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='4'><%=getTran(request,"cnrkr.sf36","chapter4",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question4a",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_13", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question4b",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_14", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question4c",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_15", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question4d",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_16", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='3'><%=getTran(request,"cnrkr.sf36","chapter5",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question5a",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_17", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question5b",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_18", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question5c",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_19", "cnrkr.sf36.yesno", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","chapter6",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_20", "cnrkr.sf36.options4", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","chapter7",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_21", "cnrkr.sf36.options5", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","chapter8",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_22", "cnrkr.sf36.options4", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='9'><%=getTran(request,"cnrkr.sf36","chapter9",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9a",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_23", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9b",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_24", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9c",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_25", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9d",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_26", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9e",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_27", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9f",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_28", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9g",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_29", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9h",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_30", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question9i",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_31", "cnrkr.sf36.options6", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","chapter10",sWebLanguage) %></td>
					<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_32", "cnrkr.sf36.options8", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='3'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='9'><%=getTran(request,"cnrkr.sf36","chapter11",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question11a",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_33", "cnrkr.sf36.options7", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question11b",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_34", "cnrkr.sf36.options7", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question11c",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_35", "cnrkr.sf36.options7", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr.sf36","question11d",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_36", "cnrkr.sf36.options7", sWebLanguage, "onchange='calculateSF36();'") %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_SF36_COMMENT", 60, 1) %></td>
	</tr>
</table>