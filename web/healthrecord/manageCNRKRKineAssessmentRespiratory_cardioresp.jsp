<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr","sadoul",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SADOUL", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr>
		<td class='admin' width='15%'><%=getTran(request,"cnrkr","joud",sWebLanguage) %></td>
		<td class='admin2'>
			<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_JOUD", 3, sWebLanguage) %>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","dynamic.evaluation",sWebLanguage) %></center></td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","mobility.rachis.cervical",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","chin.sternum.flex",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CHINSTERNUMFLEX", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","chin.sternum.ext",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CHINSTERNUMEXT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","chin.acro.right",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CHINACRORIGHT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","chin.acro.left",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CHINACROLEFT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","ear.acro.right",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EARACRORIGHT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","ear.acro.left",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EARACROLEFT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","mobility.rachis",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","shober.flex",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SHOBERFLEX", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","shober.ext",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SHOBEREXT", 3, sWebLanguage, sCONTEXTPATH) %>cm</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","sumdif",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><input style='text-align: center' id='diffsum' type='text' class='text' size='3' value='' readonly/> cm</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","axilins",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILINS", 3, sWebLanguage, sCONTEXTPATH, "document.getElementById(\"axildif\").value=document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILINS\").value*1-document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILEX\").value*1;document.getElementById(\"axildif\").onchange();") %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","axilex",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILEX", 3, sWebLanguage, sCONTEXTPATH, "document.getElementById(\"axildif\").value=document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILINS\").value*1-document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_AXILEX\").value*1;document.getElementById(\"axildif\").onchange();") %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","axildif",sWebLanguage) %></td>
					<td class='admin2' nowrap><input style='text-align: center' id='axildif' type='text' class='text' size='3' value='' readonly onchange='document.getElementById("diffsum").value=document.getElementById("axildif").value*1+document.getElementById("xiphdif").value*1;'/> cm</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"cnrkr","xiphin",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHIN", 3, sWebLanguage, sCONTEXTPATH, "document.getElementById(\"xiphdif\").value=document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHIN\").value*1-document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHEX\").value*1;document.getElementById(\"xiphdif\").onchange();") %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","xiphex",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultVisualNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHEX", 3, sWebLanguage, sCONTEXTPATH, "document.getElementById(\"xiphdif\").value=document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHIN\").value*1-document.getElementById(\"ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_XIPHEX\").value*1;document.getElementById(\"xiphdif\").onchange();") %>cm</td>
					<td class='admin'><%=getTran(request,"cnrkr","xiphdif",sWebLanguage) %></td>
					<td class='admin2' nowrap><input style='text-align: center' id='xiphdif' type='text' class='text' size='3' value='' readonly onchange='document.getElementById("diffsum").value=document.getElementById("axildif").value*1+document.getElementById("xiphdif").value*1;'/> cm</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","testing.musculaire",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.abdominal",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCABDO", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.paravertebral",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCPARAVERT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.stercleimastright",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCSTERCLEIMASTRIGHT", sWebLanguage, "", 0, 5) %></td>
				</tr>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.stercleimastleft",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCSTAERCLEIMASTLEFT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.intercostright",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCINTERCOSTRIGHT", 20, 1) %>
					</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.intercostleft",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCINTERCOSTLEFT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.diaphragma",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCDIAPHRAGMA", 20, 1) %>
					</td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.denteleright",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCDENTELERIGHT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.denteleleft",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCDENTELELEFT", sWebLanguage, "", 0, 5) %></td>
				</tr>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.rhomboidright",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCRHOMBOIDRIGHT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.rhomboidleft",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCRHOMBOIDLEFT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.trapeziumright",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCTRAPEZIUMRIGHT", sWebLanguage, "", 0, 5) %></td>
				</tr>
				<tr>
					<td class='admin' width='23%'><%=getTran(request,"cnrkr","muscle.trapeziumleft",sWebLanguage) %></td>
					<td class='admin2' width='10%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_MUSCTRAPEZIUMLEFT", sWebLanguage, "", 0, 5) %></td>
					<td class='admin2' colspan='4'></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","souplesse.musculaire",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","musc.pectoralright",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SOUPLPECTRIGHT", "cnrkr.souplesse",sWebLanguage, "") %></td>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","musc.pectoralleft",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SOUPLPECTLEFT", "cnrkr.souplesse", sWebLanguage, "") %></td>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","muscle.trapeziumright",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SOUPLTRAPEZIUMRIGHT", "cnrkr.souplesse", sWebLanguage, "") %></td>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","muscle.trapeziumleft",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_SOUPLTRAPEZIUMRIGHT", "cnrkr.souplesse", sWebLanguage, "") %></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","cardiac.parameters",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","bloodpressure",sWebLanguage) %></td>
					<td class='admin2' width='32%' nowrap><%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_BP", 10) %> mmHg</td>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","heartfrequency",sWebLanguage) %></td>
					<td class='admin2' width='32%' nowrap><%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_HF", 10) %> <%=getTran(request,"web","bpm",sWebLanguage) %></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class='admin'>
		<td colspan='2'><center><%=getTran(request,"cnrkr","pain",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='2'>
			<table width='100%' cellpadding='0' cellspacing='1'>
				<tr>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","eva",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EVA", sWebLanguage, "", 0, 10) %></td>
					<td class='admin' width='18%'><%=getTran(request,"cnrkr","en",sWebLanguage) %></td>
					<td class='admin2' width='7%' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_EN", sWebLanguage, "", 0, 10) %></td>
					<td class='admin' width='18%'><%=getTran(request,"web","comment",sWebLanguage) %></td>
					<td class='admin2' width='32%' nowrap><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_RESPIRATORY_CARDIOCOMMENT", 30, 1) %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>