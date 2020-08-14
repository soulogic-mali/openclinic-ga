<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td width='70%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'>
									<div id="keywords_title_ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PAIN"><%=getTran(request,"cnrkr","perinealpain",sWebLanguage)%></div>
								</td>
								<td class='admin2'>
									<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PAIN", "cnrkr.perinealpain", "keywords3", sCONTEXTPATH, sWebLanguage,request) %>
						      	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><%=getTran(request,"cnrkr","generalaspect",sWebLanguage) %></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","cleanness",sWebLanguage) %></td>
								<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.cleanness", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CLEANNESS", sWebLanguage, true) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","peranttroph",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERANTTROPH", "cnrkr.goodbad",sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","perantlubr",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERANTLUBR","cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"web","perantcolor",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERANTCOLOR","cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"web","perpostasp",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERPOSTASP","cnrkr.perpostaspect", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","perdesc",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERDESC", "cnrkr.yesno",sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","perbomb",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERBOMB","cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"web","perbad",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERBAD","cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"web","pergood",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PERGOOD","cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","interfold",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_INTERFOLD", "cnrkr.yesno",sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","fistula",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_FISTULA","cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' width='15%'><%=getTran(request,"web","anovulvardistance",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ANOVULVARDISTANCE", 4, sWebLanguage) %>cm</td>
								<td class='admin' width='15%'><%=getTran(request,"web","scar",sWebLanguage) %></td>
								<td class='admin2' nowrap><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request,"cnrkr.perineumscars", "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_SCAR", sWebLanguage, true) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","vulvargap",sWebLanguage) %></td>
								<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VULVARGAP", "cnrkr.vulvargap", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","organdescent",sWebLanguage) %></td>
								<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnrkr.organdescent","ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ORGANDESCENT", sWebLanguage, true) %>&nbsp;&nbsp;<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ORGANDESCENTTEXT", 30, 1) %></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
    	<td width="30%" id='keywordstd3' class="admin2" style="vertical-align:top;padding:0px;">
    		<div style="height:200px;overflow:auto;" id="keywords3"></div>
    	</td>
    	<td>
			<div style="height:200px;overflow:auto;"/>
    	</td>
	</tr>
	<tr>
		<td colspan='3' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='8'><%=getTran(request,"cnrkr","superficialsensitivity",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","sensS2",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_S2", "cnrkr.esthesia",sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","sensS3",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_S3","cnrkr.esthesia", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","sensS4",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_S4","cnrkr.esthesia", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","sens5",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_S5","cnrkr.esthesia", sWebLanguage, "") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='8'><%=getTran(request,"cnrkr","reflexes",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","clitoridoanal",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CLITORIDOANAL", "cnrkr.absentpresent",sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","cremaster",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CREMASTER","cnrkr.absentpresent", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","bulbocavern",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_BULBOCAVERN","cnrkr.absentpresent", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","reflexcough",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_REFLEXCOUGH","cnrkr.absentpresent", sWebLanguage, "") %></td>
				</tr>
				<tr class='admin'>
					<td colspan='8'><%=getTran(request,"cnrkr","functionaltests",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","vismobact",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CLITORIDOANAL", "cnrkr.vismobact",sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","vismobpass",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CREMASTER","cnrkr.vismobpass", sWebLanguage, "") %></td>
					<td colspan='4' class='admin2'/>
				</tr>
				<tr class='admin'>
					<td colspan='8'><%=getTran(request,"cnrkr","touchervaginal",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","vaginaltonicity",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VAGINALTONICITY", "cnrkr.tv.tonicity",sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","centralfibrcore",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CENTRALFIBRCORE","cnrkr.tv.tonicity", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","muscleelasticity",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_MUSCLEELASTICITY","cnrkr.tv.extensibility", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","profsens",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_PROFSENS","cnrkr.goodbad", sWebLanguage, "") %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.bulbcavern",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVBULBCAVERN", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.ischiocavern",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVISCHIOCAVERN", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.transvers",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVTRANSVERS", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.verge",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVVERGE", sWebLanguage, "",0,5) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.analsphinc",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVANALSPHINC", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.uretsphinc",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVURETSPHINC", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.coccyg",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVCOCCYG", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.relanus",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVRELANUS", sWebLanguage, "",0,5) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.ischiococcyg",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVISCHIOCOCCYG", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.balonnet",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVBALONNET","cnrkr.posneg", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.bonnet",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TVBONNET","cnrkr.posneg", sWebLanguage, "") %></td>
					<td class='admin2' colspan='2'/>
				</tr>
				<tr class='admin'>
					<td colspan='8'><%=getTran(request,"cnrkr","toucherrectal",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","sphinctertonicity",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_SPHINCTERTONICITY", "cnrkr.tv.tonicity",sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","endocanaltonicity",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_ENDOCANALTONICITY","cnrkr.tv.tonicity", sWebLanguage, "") %></td>
					<td class='admin'><%=getTran(request,"cnrkr","capanal",sWebLanguage) %></td>
					<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_CAPANAL", 30, 1) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.bulbcavern",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRBULBCAVERN", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.ischiocavern",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRISCHIOCAVERN", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.transvers",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRTRANSVERS", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.verge",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRVERGE", sWebLanguage, "",0,5) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.analsphinc",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRANALSPHINC", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.uretsphinc",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRURETSPHINC", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.coccyg",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRCOCCYG", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.relanus",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRRELANUS", sWebLanguage, "",0,5) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tv.ischiococcyg",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRISCHIOCOCCYG", sWebLanguage, "",0,5) %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tr.elytrocele",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRELYTROCELE","cnrkr.yesno", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tr.alcock",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRALCOCK","cnrkr.yesno", sWebLanguage, "") %></td>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","tr.mobcoccyg",sWebLanguage) %></td>
					<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRMOBCOCCYG","cnrkr.goodbad", sWebLanguage, "") %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","prostate",sWebLanguage) %></td>
					<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRPROSTATE", 30, 1) %></td>
				</tr>
				<tr>
					<td class='admin' width='15%'><%=getTran(request,"cnrkr","coccyx",sWebLanguage) %></td>
					<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_TRCOCCYX", 30, 1) %></td>
				</tr>
			</table>
    					<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='11'><%=getTran(request,"cnrkr","biofeedback",sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' width='15%'></td>
					<td class='admin' colspan='2' style='text-align: center'>R0</td>
					<td class='admin' colspan='2' style='text-align: center'>R1</td>
					<td class='admin' colspan='2' style='text-align: center'>R2</td>
					<td class='admin' colspan='2' style='text-align: center'>R3</td>
					<td class='admin' colspan='2' style='text-align: center'>R4</td>
				</tr>
				<tr>
					<td class='admin' rowspan='4'><%=getTran(request,"cnrkr","vaginalprobe",sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R0_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R1_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R2_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R3_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R4_1", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R0_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R1_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R2_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R3_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R4_2", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R0_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R1_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R2_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R3_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R4_3", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R0_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R1_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R2_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R3_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_VP_R4_4", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2' colspan='11'><hr/></td>
				</tr>
				<tr>
					<td class='admin' rowspan='4'><%=getTran(request,"cnrkr","analprobe",sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R0_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R1_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R2_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R3_1", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","basetonus",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R4_1", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R0_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R1_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R2_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R3_2", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","volontarycontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R4_2", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R0_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R1_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R2_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R3_3", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","endurance",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R4_3", 3, sWebLanguage) %></td>
				</tr>
				<tr>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R0_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R1_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R2_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R3_4", 3, sWebLanguage) %></td>
					<td class='admin2'><%=getTran(request,"cnrkr","rapidcontraction",sWebLanguage) %></td>
					<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_PERINEOLOGY_AP_R4_4", 3, sWebLanguage) %></td>
				</tr>
			</table>
		</td>
	</tr>
</table>