<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.ABILOCO.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.ABILOCO");'/> <%=getTran(request,"cnrkr","test.ABILOCO",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.ABILOCO.complete'/></td>
	</tr>
</table>
<div id='test.ABILOCO'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin' width='15%'><%=getTran(request,"cnrkr.abiloco","questionset",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_QUESTIONSET", sWebLanguage, "onchange='setAbilocoOrder(this.value);'", 1, 10) %></td>
		</tr>
		<tr>
			<td colspan='2'>
				<table  width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' colspan='2' style='height: 20px'><u><%=getTran(request,"cnrkr.abiloco","howdifficult",sWebLanguage) %></u></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t1'><%=getTran(request,"cnrkr.abiloco","1.1",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_1", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t2'><%=getTran(request,"cnrkr.abiloco","1.2",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_2", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t3'><%=getTran(request,"cnrkr.abiloco","1.3",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_3", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t4'><%=getTran(request,"cnrkr.abiloco","1.4",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_4", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t5'><%=getTran(request,"cnrkr.abiloco","1.5",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_5", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t6'><%=getTran(request,"cnrkr.abiloco","1.6",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_6", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t7'><%=getTran(request,"cnrkr.abiloco","1.7",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_7", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t8'><%=getTran(request,"cnrkr.abiloco","1.8",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_8", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t9'><%=getTran(request,"cnrkr.abiloco","1.9",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_9", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t10'><%=getTran(request,"cnrkr.abiloco","1.10",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_10", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateABILOCO();'") %></td>
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
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","missinganswers",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_MISSINGANSWERS", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","linearscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_LINEARSCORE", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ABILOCO_COMMENT", 60, 1) %></td>
	</tr>
</table>
