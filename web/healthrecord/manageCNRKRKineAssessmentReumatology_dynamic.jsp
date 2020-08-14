<%@include file="/includes/validateUser.jsp"%>

<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>

<table width='100%' cellspacing='1' cellpadding='0'>
	<tr>
		<td width='50%' style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","rachis.cervical",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.chin.sternum.flex",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTCHINSTERNUMFLEX", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.chin.sternum.ext",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTCHINSTERNUMEXT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.chin.acromion.right",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTCHINACROMIONRIGHT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.chin.acromion.left",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTCHINACROMIONLEFT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.ear.acromion.right",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTEARACROMIONRIGHT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","distance.ear.acromion.left",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNDISTEARACROMIONLEFT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","rachis.global",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","schoeber.flex",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNSCHOEBERFLEX", 5, sWebLanguage) %>
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","schoeber.ext",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNSCHOEBEREXT", 5, sWebLanguage) %>
			       	</td>
			    </tr>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","rachis.dorsal",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","rachis.dorsal",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNRACHISDORS", 45, 2)%>
			       	</td>
			    </tr>
			</table>
		</td>
		<td style="vertical-align:top;padding:0px;">
			<table width='100%' cellspacing='0' cellpadding='0'>
				<tr class='admin'>
       				<td colspan='2'>
       					<center><%=getTran(request,"cnrkr","rachis.lumbar",sWebLanguage)%></center>
       				</td>
				</tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","schoeber.lomb.flex",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNLOMBSCHOEBERFLEX", 5, sWebLanguage) %>
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","schoeber.lomb.ext",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNLOMBSCHOEBEREXT", 5, sWebLanguage) %>
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","hand.floor.anteflex",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNHANDFLOORANTEFLEX", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","hand.floor.latflex.right",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNHANDFLOORLATFLEXRIGHT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","hand.floor.latflex.left",sWebLanguage)%>
       				</td>
       				<td class='admin2'>
       					<%=ScreenHelper.writeDefaultNumericInput(session,(TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNHANDFLOORLATFLEXLEFT", 5, sWebLanguage) %> cm
			       	</td>
			    </tr>
				<tr>
       				<td class='admin'>
       					<%=getTran(request,"cnrkr","star.maigne",sWebLanguage)%>
       				</td>
       				<td>
       					<table width='100%'>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.flex",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNEFLEX", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.ext",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNEEXT", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.rotleft",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNEROTLEFT", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.rotright",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNEROTRIGHT", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.latflexleft",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNELATFLEXLEFT", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       						<tr>
       							<td class='admin'>
       								<%=getTran(request,"cnrkr","maigne.latflexright",sWebLanguage)%>
       							</td>
       							<td class='admin2'>
       								<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_ASSESSMENT_REUMATOLOGY_DYNMAIGNELATFLEXRIGHT", "cnrkr.maigne", sWebLanguage, "")%>
       							</td>
       						</tr>
       					</table>
			       	</td>
			    </tr>
			</table>
		</td>
	</tr>
</table>