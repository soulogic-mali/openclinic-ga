<%@include file="/includes/validateUser.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>

				<tr>
					<td class='admin'><%=getTran(request,"web","bp",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.bloodpressure", "ITEM_TYPE_PEDIATRICANURSING_BLOODPRESSURE", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"pediatric","respiratory",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.respiratorypattern", "ITEM_TYPE_PEDIATRICANURSING_RESPIRATORYPATTERN", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","oxygentherapy",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_OXYGEN", sWebLanguage, false,"","")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_OXYGENCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","cognitive",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","awareness",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.awareness", "ITEM_TYPE_PEDIATRICANURSING_AWARENESS", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","pupils",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.pupils", "ITEM_TYPE_PEDIATRICANURSING_PUPILS", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","glasgowcomascale",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_GCS", 10) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","tolerance",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin2' colspan='4'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.tolerance", "ITEM_TYPE_PEDIATRICANURSING_TOLERANCE", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","lifeprincipals",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","religion",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "religion", "ITEM_TYPE_PEDIATRICANURSING_RELIGION", sWebLanguage, false,"")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_RELIGIONCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","security",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","skinlesion",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_SKINLESION", sWebLanguage, false,"","")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_SKINLESIONCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","hairdress",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesnona", "ITEM_TYPE_PEDIATRICANURSING_HAIRDRESS", sWebLanguage, false,"","")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","catheter",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_CATHETER", sWebLanguage, false,"","")%>
					</td>
					<td class='admin'><%=getTran(request,"web","type",sWebLanguage) %></td>
					<td class='admin2'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "catheter", "ITEM_TYPE_PEDIATRICANURSING_CATHETERTYPE", sWebLanguage, false,"")%>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","darin",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "drain", "ITEM_TYPE_PEDIATRICANURSING_DRAIN", sWebLanguage, false,"")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_DRAINCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","abprofylaxis",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_AB", sWebLanguage, false,"","")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ABCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin'><%=getTran(request,"pediatric","comfort",sWebLanguage) %></td></tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","pain",sWebLanguage) %></td>
					<td class='admin2' colspan='3'>
						<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICANURSING_PAIN", sWebLanguage, false,"","")%>
						<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_PAINCOMMENT", 20, 1) %>
					</td>
				</tr>
				<tr><td colspan='4' class='admin2'><%=getTran(request,"pediatric","escaladedolor",sWebLanguage) %></td></tr>
				<tr>
					<td colspan='4'>
						<table width='100%'>
							<tr>
								<td id='td1'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain1.png'/><br/>
							            <input onclick='checkPain();' id='pain1' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=0" property="value" outputString="checked"/> value="0">
									</center>
								</td>
								<td id='td2'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain2.png'/><br/>
							            <input onclick='checkPain();' id='pain2' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=1" property="value" outputString="checked"/> value="1">
									</center>
								</td>
								<td id='td3'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain3.png'/><br/>
							            <input onclick='checkPain();' id='pain3' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=2" property="value" outputString="checked"/> value="2">
									</center>
								</td>
								<td id='td4'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain4.png'/><br/>
							            <input onclick='checkPain();' id='pain4' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=3" property="value" outputString="checked"/> value="3">
									</center>
								</td>
								<td id='td5'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain5.png'/><br/>
							            <input onclick='checkPain();' id='pain5' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=4" property="value" outputString="checked"/> value="4">
									</center>
								</td>
								<td id='td6'>
									<center>
										<img width='100%' src='<%=sCONTEXTPATH %>/_img/themes/default/pain6.png'/><br/>
							            <input onclick='checkPain();' id='pain6' type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PEDIATRICANURSING_PAINLEVEL;value=5" property="value" outputString="checked"/> value="5">
									</center>
								</td>
							</tr>
						</table>
					</td>
				</tr>
</logic:present>

<script>
	function checkPain(){
		for(n=1;n<7;n++){
			if(document.getElementById("pain"+n).checked){
				document.getElementById("td"+n).style.backgroundColor='red';
			}
			else{
				document.getElementById("td"+n).style.backgroundColor='white';
			}
		}
	}
	checkPain();
</script>