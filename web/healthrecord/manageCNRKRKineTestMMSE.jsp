<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.MMSE.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.MMSE");'/> <%=getTran(request,"cnrkr","test.MMSE",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.MMSE.complete'/></td>
	</tr>
</table>
<div id='test.MMSE'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin2' width='100%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","todaysdate",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichyear",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_1", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichseason",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_2", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichmonth",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_3", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichdayofmonth",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_4", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichdayofweek",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_5", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","place",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichhospital",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_6", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichcity",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_7", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichdepartment",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_8", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichprovince",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_9", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","whichstage",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_10", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","wordstoremember",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","cigar",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orlemon",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","orsofa",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_11", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","flower",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orkey",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","ortulip",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_12", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","door",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orballoon",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","orduck",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_13", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","countfrom100",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","93",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_14", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","86",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_15", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","79",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_16", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","72",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_17", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","65",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_18", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","wordstoremember2",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%' cellspacing='0' cellpadding='0'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","cigar2",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orlemon",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","orsofa",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_19", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%' cellspacing='0' cellpadding='0'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","flower2",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orkey",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","ortulip",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_20", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'>
							<table width='100%' cellspacing='0' cellpadding='0'>
								<tr>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","door2",sWebLanguage) %></td>
									<td width='30%'><%=getTran(request,"cnrkr.mmse","orballoon",sWebLanguage) %></td>
									<td><%=getTran(request,"cnrkr.mmse","orduck",sWebLanguage) %></td>
								</tr>
							</table>
						</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_21", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' colspan='2'><hr/></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","showpen",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_22", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","showwatch",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_23", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","repeat",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_24", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","paperondesk",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","takesheet",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_25", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","foldsheet",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_26", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","throwsheet",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_27", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","readpaper",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","closeeyes",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_28", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","showpenandpaper",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","writesentence",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_29", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
					<tr>
						<td class='admin' colspan='2'><%=getTran(request,"cnrkr.mmse","copydrawingquestion",sWebLanguage) %></td>
					</tr>
					<tr>
						<td class='admin2' nowrap width='1%'><%=getTran(request,"cnrkr.mmse","copydrawing",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.correct", "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_30", sWebLanguage, true, "onchange='calculateMMSE();'") %></td>						
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","reversemonde",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_REVERSEMONDE", 60, 1) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_MMSE_COMMENT", 60, 1) %></td>
	</tr>
</table>
