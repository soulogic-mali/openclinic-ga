<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.EIFEL.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.EIFEL");'/> <%=getTran(request,"cnrkr","test.EIFEL",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.EIFEL.complete'/></td>
	</tr>
</table>
<div id='test.EIFEL'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td colspan='2'>
				<table  width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' width='1%' nowrap id='t1'><%=getTran(request,"cnrkr.eifel","1.1",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_1", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t2'><%=getTran(request,"cnrkr.eifel","1.2",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_2", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t3'><%=getTran(request,"cnrkr.eifel","1.3",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_3", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t4'><%=getTran(request,"cnrkr.eifel","1.4",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_4", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t5'><%=getTran(request,"cnrkr.eifel","1.5",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_5", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t6'><%=getTran(request,"cnrkr.eifel","1.6",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_6", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t7'><%=getTran(request,"cnrkr.eifel","1.7",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_7", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t8'><%=getTran(request,"cnrkr.eifel","1.8",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_8", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t9'><%=getTran(request,"cnrkr.eifel","1.9",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_9", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t10'><%=getTran(request,"cnrkr.eifel","1.10",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_10", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t11'><%=getTran(request,"cnrkr.eifel","1.11",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_11", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t12'><%=getTran(request,"cnrkr.eifel","1.12",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_12", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
							</table>
						</td>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' width='1%' nowrap id='t13'><%=getTran(request,"cnrkr.eifel","1.13",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_13", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t14'><%=getTran(request,"cnrkr.eifel","1.14",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_14", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t15'><%=getTran(request,"cnrkr.eifel","1.15",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_15", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t16'><%=getTran(request,"cnrkr.eifel","1.16",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_16", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t17'><%=getTran(request,"cnrkr.eifel","1.17",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_17", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t18'><%=getTran(request,"cnrkr.eifel","1.18",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_18", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t19'><%=getTran(request,"cnrkr.eifel","1.19",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_19", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t20'><%=getTran(request,"cnrkr.eifel","1.20",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_20", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t21'><%=getTran(request,"cnrkr.eifel","1.21",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_21", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t11'><%=getTran(request,"cnrkr.eifel","1.22",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_22", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t12'><%=getTran(request,"cnrkr.eifel","1.23",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_23", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
								</tr>
								<tr>
									<td class='admin2' width='1%' nowrap id='t12'><%=getTran(request,"cnrkr.eifel","1.24",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_24", "cnrkr.yesno", sWebLanguage, "onchange='calculateEIFEL();'") %></td>
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
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_EIFEL_COMMENT", 60, 1) %></td>
	</tr>
</table>
