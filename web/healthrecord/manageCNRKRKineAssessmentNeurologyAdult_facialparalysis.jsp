<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","static.face.evaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","wrinkledisappearance",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WRINKLEDISAPPEARENCE", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","lowereyebrow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LOWEREEYEBROW", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","lowereyelid",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_LOWEREYELID", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","largeeyebrowslot",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_LARGEEYEBROWSLOT", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","nofurrow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_NOFURROW", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","lowerlip",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LOWERLIP", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","mouthdeviation",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_MOUTHDEVIATION", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","facialassymetry",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIALASSYMETRY", "cnrkr.pronounced", sWebLanguage, "") %></td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='7'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACECOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","dynamicevaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","observation.conversation",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_OBSERVATIONCONVERSATION", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td class='admin' colspan='2'><center><%=getTran(request,"cnrkr","muscularevaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","tonus",sWebLanguage) %></td>
								<td class='admin2' colspan='6'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TONUS", "cnrkr.tonus", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","extensibility",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","muscleretraction",sWebLanguage) %></td>
								<td class='admin2' colspan='5'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_MUSCLERETRACTION", "cnrkr.tonus", sWebLanguage, "") %> <%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_MUSCLERETRACTIONTEXT", 30) %></td>
							</tr>
							<tr>
								<td class='admin' width='15%' rowspan='5'><%=getTran(request,"cnrkr","testing",sWebLanguage) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","frontal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTFRONTAL", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","canin",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTCANIN", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","orbicular",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTORBICULAR", sWebLanguage, "",0,3) %></td>
							</tr>
							<tr>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","wrinkle",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTWRINKLE", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","risorius",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTRISORIUS", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","buccinator",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTBUCCINATOR", sWebLanguage, "",0,3) %></td>
							</tr>
							<tr>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nasal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTNASAL", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","zygoma",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTZYGOMA", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","chin",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTCHIN", sWebLanguage, "",0,3) %></td>
							</tr>
							<tr>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","nose",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTNOSE", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","upperlip",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTUPPERLIP", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","liptriangle",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTLIPTRIANGLE", sWebLanguage, "",0,3) %></td>
							</tr>
							<tr>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","pyramidal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTPYRAMIDAL", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","chinsquare",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTCHINSQUARE", sWebLanguage, "",0,3) %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","liporbicular",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TESTLIPORBICULAR", sWebLanguage, "",0,3) %></td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='6'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACE_TESTCOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","housebrackmann",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","housebrackmann",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HOUSEBRACKMANN", "cnrkr.housebrackmann", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","sensitiveevaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","exteroceptive",sWebLanguage) %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","tactile",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_TACTILE", "cnrkr.esthesia", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","thermal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_THERMAL", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","algesic",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_FACIAL_ALGESIC", "cnrkr.goodbad", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","associatedproblems",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","hyperaguesia",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HYPERAGUESIA", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","hypersalivation",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HYPERSALIVATION", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","drymouth",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_DRYMOUTH", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","hyperacousia",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HYPERACOUSIA", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","hypertears",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HYPERTEARS", "cnrkr.yesno", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","hypotears",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_HYPOTEARS", "cnrkr.yesno", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","functionalevaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","communication",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","locution",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LOCUTION", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","smile",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SMILE", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","laugh",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LAUGH", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","whistle",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_WHISTLE", "cnrkr.goodbad", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","deglutition",sWebLanguage) %></td>
								<td class='admin' width='1%'><%=getTran(request,"cnrkr","drink",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LOCUTION", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","chew",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_SMILE", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","swallow",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_LAUGH", "cnrkr.goodbad", sWebLanguage, "") %></td>
								<td class='admin' colspan='2'/>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","eyeprotection",sWebLanguage) %></td>
								<td class='admin2' colspan='7'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_EYEPROTECTION", "cnrkr.ease", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","psychologicevaluation",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","psychologicevaluation",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROADULT_PSYCHOLOGYEVAL", 60, 2) %></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>