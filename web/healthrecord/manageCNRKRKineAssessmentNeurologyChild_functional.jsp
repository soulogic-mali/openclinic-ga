<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='0' cellpadding='0'>
	<tr>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='1' cellpadding='0'>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","global.motricity",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","returning",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_RETURNING", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","ramped",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_RAMPED", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","sittingground2",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SITTINGGROUND", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","sittinghandsandfeet",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SITTINGHANDSANDFEET", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","walkinghandsandfeet",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_WALINKINGHANDSANDFEET", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","chevalierhandsandfeet",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_CHEVALIERHANDSANDFEET", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","sitstand",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SITSTAND", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' nowrap width='1%'><%=getTran(request,"cnrkr","walking",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_WALKING", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='7'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_COMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","displacement",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='0' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","level",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_DISPLACEMENTLEVEL", "cnrkr.displacementlevel", sWebLanguage, "") %></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","finemotricity",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","handclosing",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HANDCLOSING", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","handeyecoordination",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HANDEYECOORDINATION", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","armsinfront",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_ARMSINFRONT", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","shoulderweight",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SHOULDERWEIGHT", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","handobject",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HANDOBJECT", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","takeobject",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_TAKEOBJECT", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","handgrip",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HANDGRIP", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","thumbopposition",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_THUMBOPPOSITION", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","handprecise",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HANDPRECISE", "cnrkr.aquired", sWebLanguage, "") %></td>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='5'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_FINEMOTRICITYCOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","communication",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","nonverbal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_NONVERBAL", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","visualcontact",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_VISUALCONTACT", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","smile",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SMILE", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","grimace",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_GRIMACE", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","verbal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_VERBAL", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","simpleinstructions",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SIMPLEINSTR", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","withoutwords",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_WITHOUTWORDS", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","normalspeach",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_NORMALSPEACH", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='7'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_COMMUNICATIONCOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","socialdevelopment",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","ownbody",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_OWNBODY", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","objectdiscovery",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_OBJECTDISCOVERY", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","play",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_PLAY", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","concentrate",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_CONCENTRATE", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='7'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SOCDEVCOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","intelligence",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","recognizeobjects",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_RECOGNIZEOBJECTS", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","recognizepersons",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_RECOGNIZEPERSONS", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","problemsolving",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_PROBLEMSOLVING", "cnrkr.aquired", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","followinstructions",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_FOLLOWINSTRUCTIONS", "cnrkr.aquired", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","learnconcepts",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_LEARNCONCEPTS", "cnrkr.aquired", sWebLanguage, "") %></td>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='5'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_INTELLIGENCECOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr class='admin'>
					<td colspan='2'><center><%=getTran(request,"cnrkr","activitiesofdailyliving",sWebLanguage) %></center></td>
				</tr>
				<tr>
       				<td colspan='2'>
       					<table width='100%' cellspacing='1' cellpadding='0'>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","eat",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_EAT", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","drink",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_DRINK", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","dress",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_DRESS", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","undress",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_UNDRESS", "cnrkr.dependency", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","toilet",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_TOILET", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","washhands",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_WASHHANDS", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","bath",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_BATH", "cnrkr.dependency", sWebLanguage, "") %></td>
								<td class='admin' ><%=getTran(request,"cnrkr","household",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_HOUSEHOLD", "cnrkr.dependency", sWebLanguage, "") %></td>
							</tr>
							<tr>
								<td class='admin' width='15%'><%=getTran(request,"cnrkr","sociprofessionnal",sWebLanguage) %></td>
								<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_SOCIOPROFESSIONNAL", "cnrkr.dependency", sWebLanguage, "") %></td>
			       				<td class='admin'>
			       					<%=getTran(request,"web","comment",sWebLanguage)%>
			       				</td>
			       				<td class='admin2' colspan='5'>
			       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_NEUROCHILD_FUNC_DAILYLIVINGCOMMENT", 60, 1) %>
						       	</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>