<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.HOOS.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.HOOS");'/> <%=getTran(request,"cnrkr","test.HOOS",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.HOOS.complete'/></td>
	</tr>
	<tr id='test.HOOS'>
		<td class='admin2' width='100%' style="vertical-align:top;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","symptoms",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","s1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_1", "cnrkr.koos.options1", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","s2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_2", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","s3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_3", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","rigidity.hoos",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","s4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_4", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","s5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_5", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","pain",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_6", "cnrkr.koos.options3", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='2'><%=getTran(request,"cnrkr","painimportance",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_7", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_8", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_9", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_10", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_11", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_12", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p8",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_13", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p9",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_14", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","p10",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_15", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","dailylife",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_16", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_17", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_18", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_19", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a5",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_20", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a6",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_21", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a7",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_22", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a8",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_23", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a9",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_24", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a10",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_25", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a11",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_26", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a12",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_27", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a13",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_28", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a14",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_29", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a15",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_30", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a16",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_31", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","a17",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_32", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","sports",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","sp1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_33", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","sp2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_34", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","sp3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_35", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","sp4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_36", "cnrkr.koos.options2", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","qualityoflife",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","q1",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_37", "cnrkr.koos.options3", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","q2",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_38", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","q3",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_39", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
				<tr>
					<td class='admin2' width='50%'><%=getTran(request,"cnrkr.hoos","q4",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_40", "cnrkr.koos.options4", sWebLanguage, "onchange='calculateHOOS();'") %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_HOOS_COMMENT", 60, 1) %></td>
	</tr>
</table>
