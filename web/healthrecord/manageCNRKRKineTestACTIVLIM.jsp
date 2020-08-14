<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr class='admin'>
		<td colspan='2'><img id='test.ACTIVLIM.img' height='20px' style='vertical-align: middle;' src='<%=sCONTEXTPATH%>/_img/treemenu/minus.gif' onclick='toggleTest("test.ACTIVLIM");'/> <%=getTran(request,"cnrkr","test.ACTIVLIM",sWebLanguage) %> <img height='20px' style='vertical-align: middle;' id='test.ACTIVLIM.complete'/></td>
	</tr>
</table>
<div id='test.ACTIVLIM'>
	<table width='100%' cellspacing='1' cellpadding='0'>
		<tr>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","walkmorethan1km",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_1", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","ringabell",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_2", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","liftweight",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_3", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","pickupsomething",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_4", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","usetoilet",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_5", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","getup",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_6", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","brushteeth",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_7", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","putsocks",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_8", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","takeshower",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_9", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","getoutofcar",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_10", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
				</table>
			</td>
			<td class='admin2' width='50%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellspacing='1' cellpadding='0'>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","turninbed",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_11", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","unleashshoes",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_12", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","getofftshirt",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_13", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","opendoor",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_14", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","vacuumclean",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_15", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","arrangeplates",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_16", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","standup",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_17", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","standuplongtime",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_18", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","climbstairs",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_19", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
					<tr>
						<td class='admin2' width='1%' nowrap><%=getTran(request,"cnrkr.activlim","putkey",sWebLanguage) %></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_20", "cnrkr.activlimoptions", sWebLanguage, "onchange='calculateACTIVLIM();'") %></td>
					</tr>
				</table>
			</td>
			<td colspan='2'>
			</td>
		</tr>
	</table>
</div>
<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr.pass","totalscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_TOTAL", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","missinganswers",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInputReadonly(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_MISSINGANSWERS", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"cnrkr.pass","linearscore",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_LINEARSCORE", 2, sWebLanguage,"") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td><td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_TEST_ACTIVLIM_COMMENT", 60, 1) %></td>
	</tr>
</table>
