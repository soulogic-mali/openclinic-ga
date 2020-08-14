<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.TAMPAEKT.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.TAMPAEKT");'/> <%=getTran(request,"cnrkr","test.TAMPAEKT",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.TAMPAEKT.complete'/></td>
	</tr>
</table>
<div id='test.TAMPAEKT'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td colspan='2'>
				<table  width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' id='t1'><%=getTran(request,"cnrkr.tampaekt","1.1",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_1", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t2'><%=getTran(request,"cnrkr.tampaekt","1.2",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_2", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t3'><%=getTran(request,"cnrkr.tampaekt","1.3",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_3", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t4'><%=getTran(request,"cnrkr.tampaekt","1.4",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_4", "cnrkr.tampaektoptionsinv", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t5'><%=getTran(request,"cnrkr.tampaekt","1.5",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_5", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t6'><%=getTran(request,"cnrkr.tampaekt","1.6",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_6", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t7'><%=getTran(request,"cnrkr.tampaekt","1.7",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_7", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t8'><%=getTran(request,"cnrkr.tampaekt","1.8",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_8", "cnrkr.tampaektoptionsinv", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t9'><%=getTran(request,"cnrkr.tampaekt","1.9",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_9", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
							</table>
						</td>
						<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
							<table width='100%' cellspacing='1' cellpadding='0'>
								<tr>
									<td class='admin2' id='t10'><%=getTran(request,"cnrkr.tampaekt","1.10",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_10", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t11'><%=getTran(request,"cnrkr.tampaekt","1.11",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_11", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t12'><%=getTran(request,"cnrkr.tampaekt","1.12",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_12", "cnrkr.tampaektoptionsinv", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t13'><%=getTran(request,"cnrkr.tampaekt","1.13",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_13", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t14'><%=getTran(request,"cnrkr.tampaekt","1.14",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_14", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t15'><%=getTran(request,"cnrkr.tampaekt","1.15",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_15", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t16'><%=getTran(request,"cnrkr.tampaekt","1.16",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_16", "cnrkr.tampaektoptionsinv", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
								</tr>
								<tr>
									<td class='admin2' id='t17'><%=getTran(request,"cnrkr.tampaekt","1.17",sWebLanguage) %></td>
									<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_17", "cnrkr.tampaektoptions", sWebLanguage, "onchange='calculateTampaEKT();'") %></td>
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
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_TAMPAEKT_COMMENT", 60, 1) %></td>
	</tr>
</table>
