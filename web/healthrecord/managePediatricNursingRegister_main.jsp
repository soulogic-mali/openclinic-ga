<%@include file="/includes/validateUser.jsp"%>
<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>

  		<tr class='admin'>
			<td colspan='8'><center><%=getTran(request,"pediatric","surgery",sWebLanguage) %></center></td>
		</tr>
    	<tr>
			<td class='admin'>
				<%=getTran(request,"web","typeofsurgery",sWebLanguage) %> 
			</td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.typeofsurgery", "ITEM_TYPE_PEDIATRICANURSING_TYPEOFSURGERY", sWebLanguage, false,"")%>
			</td>
			<td class='admin'>
				<%=getTran(request,"web","typeofanesthesia",sWebLanguage) %> 
			</td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.typeofanesthesia", "ITEM_TYPE_PEDIATRICANURSING_TYPEOFANESTHESIA", sWebLanguage, false,"")%>
			</td>
    	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","preopdiagnosis",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_PREOPDIAGNOSIS", 40, 1) %>
			</td>
			<td class='admin'><%=getTran(request,"web","postopdiagnosis",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_POSTOPDIAGNOSIS", 40, 1) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","surgerydone",sWebLanguage) %></td>
			<td class='admin2' colspan='7'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_SURGERYDONE", 80, 1) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","mainsurgeon",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_MAINSURGEON", 20, 1) %>
			</td>
			<td class='admin'><%=getTran(request,"web","assistent",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ASSISTENT", 20, 1) %>
			</td>
			<td class='admin'><%=getTran(request,"web","anesthesiologst",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ANESTHESIOLOGIST", 20, 1) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","instrumentnurse",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_INSTRUMENTNURSE", 40, 1) %>
			</td>
			<td class='admin'><%=getTran(request,"web","circulatingnurse",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_CIRCULATINGNURSE", 40, 1) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","entryhour",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ENTRYHOUR", 5) %>
			</td>
			<td class='admin'><%=getTran(request,"web","anesthesiastart",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ANESTHESIASTART", 5) %>
			</td>
			<td class='admin'><%=getTran(request,"web","surgerystart",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_SURGERYSTART", 5) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","surgeryend",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_SURGERYEND", 5) %>
			</td>
			<td class='admin'><%=getTran(request,"web","anesthesiaend",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ANESTHESIAEND", 5) %>
			</td>
			<td class='admin'><%=getTran(request,"web","exithour",sWebLanguage) %></td>
			<td class='admin2'>
				<%=ScreenHelper.writeDefaultTextInput(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_EXITHOUR", 5) %>
			</td>
     	</tr>
  		<tr class='admin'>
			<td colspan='8'><center><%=getTran(request,"pediatric","measurements",sWebLanguage) %></center></td>
		</tr>
        <%-- VITAL SIGNS --%>
        <tr>
            <td class="admin"><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan='7')>
            	<table width="100%">
            		<tr>
            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="alert()calculateBMI();"/> cm</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            <td nowrap><b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %</td>
            		</tr>
            		<tr>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td>
            			<td nowrap><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
            			<td nowrap><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td>
            			<td nowrap><input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td>
            			<td nowrap><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b></td>
            			<td nowrap><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			            <td nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%></b></td>
			            <td nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm
			            </td>
            		</tr>
            	</table>
            </td>
        </tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","bloodgroup",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_BLOODGROUP", "abo",sWebLanguage,"") %>
				Rh<%=ScreenHelper.writeDefaultSelect(request,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_RHESUS", "rhesus",sWebLanguage,"") %>
			</td>
			<td class='admin'><%=getTran(request,"web","surgicalantecedents",sWebLanguage) %></td>
			<td class='admin2' colspan='4'>
				<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICADMISSION_SURGICALANTECEDENTS", sWebLanguage, false,null,"")%>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_SURGICALANTECEDENTSCOMMENT", 40, 1) %>
			</td>
     	</tr>
     	<tr>
			<td class='admin'><%=getTran(request,"web","allergies",sWebLanguage) %></td>
			<td class='admin2' colspan='2'>
				<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICADMISSION_ALLERGIES", sWebLanguage, false,null,"")%>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_ALLERGIESCOMMENT", 40, 1) %>
			</td>
			<td class='admin'><%=getTran(request,"web","patientbrings",sWebLanguage) %></td>
			<td class='admin2' colspan=4>
				<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICANURSING_PATIENTBRINGS", 40, 1) %>
			</td>
     	</tr>
</logic:present>