<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.KOOS.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.KOOS");'/> <%=getTran(request,"cnrkr","test.KOOS",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.KOOS.complete'/></td>
	</tr>
	<tr id='test.KOOS'>
		<td class='admin2' width='100%' style="vertical-align:top;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","symptoms",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_1", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_2", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_3", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_4", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_5", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","rigidity",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_6", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","s7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_7", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","pain",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_8", "cnrkr.koos.options3", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='2'><%=getTran(request,"cnrkr","painimportance",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_9", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_10", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_11", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_12", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_13", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_14", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p8",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_15", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","p9",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_16", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","dailylife",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_17", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_18", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_19", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_20", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_21", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_22", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_23", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a8",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_24", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a9",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_25", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a10",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_26", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a11",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_27", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a12",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_28", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a13",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_29", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a14",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_30", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a15",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_31", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a16",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_32", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","a17",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_33", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","sports",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","sp1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_34", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","sp2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_35", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","sp3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_36", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","sp4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_37", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","sp5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_38", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","qualityoflife",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","q1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_39", "cnrkr.koos.options3", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","q2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_40", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","q3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_41", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.koos","q4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_42", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateKOOS();'") %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_KOOS_COMMENT", 60, 1) %></td>
	</tr>
</table>
