<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.ABILHAND.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.ABILHAND");'/> <%=getTran(request,"cnrkr","test.ABILHAND",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.ABILHAND.complete'/></td>
	</tr>
</table>
<div id='test.ABILHAND'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin' width='15%'><%=getTran(request,"cnrkr.abilhand","questionset",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_QUESTIONSET", sWebLanguage, "onchange='setAbilhandOrder(this.value);'", 1, 10) %></td>
		</tr>
		<tr>
			<td colspan='2'>
				<table  width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' colspan='2' style='height: 20px'><u><%=getTran(request,"cnrkr.abilhand","howdifficult",sWebLanguage) %></u></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t1'><%=getTran(request,"cnrkr.abilhand","1.1",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_1", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t2'><%=getTran(request,"cnrkr.abilhand","1.2",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_2", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t3'><%=getTran(request,"cnrkr.abilhand","1.3",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_3", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t4'><%=getTran(request,"cnrkr.abilhand","1.4",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_4", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t5'><%=getTran(request,"cnrkr.abilhand","1.5",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_5", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t6'><%=getTran(request,"cnrkr.abilhand","1.6",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_6", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t7'><%=getTran(request,"cnrkr.abilhand","1.7",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_7", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t8'><%=getTran(request,"cnrkr.abilhand","1.8",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_8", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t9'><%=getTran(request,"cnrkr.abilhand","1.9",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_9", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t10'><%=getTran(request,"cnrkr.abilhand","1.10",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_10", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
							</table>
						</td>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' width='1%' nowrap id='t11'><%=getTran(request,"cnrkr.abilhand","1.11",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_11", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t12'><%=getTran(request,"cnrkr.abilhand","1.12",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_12", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t13'><%=getTran(request,"cnrkr.abilhand","1.13",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_13", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t14'><%=getTran(request,"cnrkr.abilhand","1.14",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_14", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t15'><%=getTran(request,"cnrkr.abilhand","1.15",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_15", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t16'><%=getTran(request,"cnrkr.abilhand","1.16",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_16", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t17'><%=getTran(request,"cnrkr.abilhand","1.17",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_17", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t18'><%=getTran(request,"cnrkr.abilhand","1.18",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_18", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t19'><%=getTran(request,"cnrkr.abilhand","1.19",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_19", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t20'><%=getTran(request,"cnrkr.abilhand","1.20",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_20", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t21'><%=getTran(request,"cnrkr.abilhand","1.21",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_21", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILHAND();'") %></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","missinganswers",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_MISSINGANSWERS", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","linearscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_LINEARSCORE", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILHAND_COMMENT", 60, 1) %></td>
	</tr>
</table>
