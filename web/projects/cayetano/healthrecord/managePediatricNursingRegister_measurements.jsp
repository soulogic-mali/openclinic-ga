<%@include file="/includes/validateUser.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>
	<tr class='admin'>
		<td colspan='8'><center><%=getTran(request,"pediatric","dataperdomain",sWebLanguage) %></center></td>
	</tr>
	<tr>
		<td colspan='4' valign='top'>
			<table width=100%'>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","healthpromotion",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","informedconsent",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_INFORMEDCONSENT", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'>
						<%=getTran(request,"web","hygiene",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.hygiene", "ITEM_TYPE_PEDIATRICANURSING_HYGIENE", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","nutrition",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","hemoglobine",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_HGB", 10) %>
					</td>
					<td class='admin'><%=getTran(request,"web","glucosis",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_GLUCOSIS", 10) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","breakfasttime",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_BREAKFASTTIME", 10) %>h
					</td>
					<td class='admin'>
						<%=getTran(request,"web","sngsog",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_SNG", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","skinandmucosa",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "pediatric.skin", "ITEM_TYPE_PEDIATRICANURSING_SKIN", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'>
						<%=getTran(request,"web","turgence",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "pediatric.turgence", "ITEM_TYPE_PEDIATRICANURSING_TURGENCE", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","oedema",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_OEDEMA", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_OEDEMALOCATION", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","fontanella",sWebLanguage) %> 
					</td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "fontanella", "ITEM_TYPE_PEDIATRICANURSING_FONTANELLA", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","abdomen",sWebLanguage) %> 
					</td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.abdomen", "ITEM_TYPE_PEDIATRICANURSING_ABDOMEN", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","fluidtherapy",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_FLUIDTHERAPY", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'>
						<%=getTran(request,"web","equipment",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "fluidtherapy", "ITEM_TYPE_PEDIATRICANURSING_FLUIDTHERAPYEQUIPMENT", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'>
						<%=getTran(request,"web","nacl",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_NACL", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'>
						<%=getTran(request,"web","dextrose",sWebLanguage) %> 
					</td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_DEXTROSE", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","topass",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_TOPASS", 10) %>cc
					</td>
					<td class='admin'><%=getTran(request,"web","otherfluids",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_OTHERFLUIDS", 20, 1) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","fluidsmanagement",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","vesicaldrain",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_VESICALDRAIN", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","urinecaracteristics",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "pediatric.urine", "ITEM_TYPE_PEDIATRICANURSING_URINE", sWebLanguage, false,"","")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_URINECOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","ostomia",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_OSTOMIA", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'><%=getTran(request,"web","details",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_OSTOMIACOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","airways",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.airways", "ITEM_TYPE_PEDIATRICANURSING_AIRWAYS", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","activity",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","bonelesion",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.bonelesion", "ITEM_TYPE_PEDIATRICANURSING_BONELESION", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","affectedlocation",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.location", "ITEM_TYPE_PEDIATRICANURSING_BONELESIONLOCATION", sWebLanguage, false,"")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_BONELESIONLOCATIONCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","comeswith",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.comeswith", "ITEM_TYPE_PEDIATRICANURSING_COMESWITH", sWebLanguage, false,"")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_COMESWITHCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","skin",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.boneskin", "ITEM_TYPE_PEDIATRICANURSING_BONESKIN", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","pulse",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.pulse", "ITEM_TYPE_PEDIATRICANURSING_PULSE", sWebLanguage, false,"")%>
					</td>
					<td class='admin'><%=getTran(request,"web","capillar",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.capillar", "ITEM_TYPE_PEDIATRICANURSING_CAPILLAR", sWebLanguage, false,"")%>
					</td>
				</tr>
			</table>
		</td>
		<td colspan='4' valign='top'>
			<table width='100%'>
				<%ScreenHelper.setIncludePage(customerInclude("healthrecord/managePediatricNursingRegister_measurements2.jsp"),pageContext);%>
			</table>
		</td>
	</tr>

</logic:present>