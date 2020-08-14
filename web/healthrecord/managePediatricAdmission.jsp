<%@page import="be.dpms.medwan.webapp.wo.common.system.SessionContainerWO,
                be.mxs.webapp.wl.session.SessionContainerFactory"%>
<%@page import="java.util.StringTokenizer"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pediatric.admission","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
  
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
   
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RECRUITMENT_CONVOCATION_ID" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table width="100%" cellspacing="1" cellpadding="0">
	    <%-- DATE --%>
	    <tr>
	        <td class="admin" width="20%">
	            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
	            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
	        </td>
	        <td class="admin2">
	            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
	            <script>writeTranDate();</script>
	        </td>
	    </tr>
	</table>
	<div style="padding-top:5px;"></div>
			    
    <table width="100%" cellspacing="1" cellpadding="0">
    	<tr>
        	<td style="vertical-align:top;" width='50%'>
        		<table width='100%'>
        			<tr class='admin'>
        				<td colspan='4'><%=getTran(request,"web","actualdisease",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","reasonforencounter",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_RFE", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","diseasetime",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_DISEASETIME", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","chronologichistory",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_RELATOCHRONOLOGICO", 40, 1) %>
						</td>
        			</tr>
			        <%-- VITAL SIGNS --%>
        			<tr class='admin'>
        				<td colspan='4'><%=getTran(request,"web","clinicalexamination",sWebLanguage) %></td>
        			</tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<table width="100%">
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="alert()calculateBMI();"/> cm</td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td><td nowrap><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td><td nowrap><input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min</td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b></td><td nowrap><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			            		</tr>
				                <tr>
						            <td nowrap><b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %</td>
						            <td nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm</td>
				                </tr>
			            	</table>
			            </td>
			        </tr>
			    </table>
			    <table width='100%'>
        			<tr>
						<td class='admin'><%=getTran(request,"web","generalaspect",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_GENERAL", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","skinandadnexes",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_SKIN", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","tcsc",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_TCSC", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","lyphsystem",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_LYMPH", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","head",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_HEAD", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","neck",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_NECK", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","thorax",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_THORAX", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","lungs",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_LUNGS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","cardiovascularsystem",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_CARDIO", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","abdomen",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_ABDOMEN", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","genitourinarysystem",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_URINARY", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","anorectal",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_ANORECTAL", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","muscularsystem",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_MUSCULAR", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","nervoussystem",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_NERVOUS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","summary",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_SUMMARY", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","presumptivediagnosis",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_PRESUMPTDIAGNOSIS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","workplan",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CLINICALEXAM_WORKPLAN", 40, 1) %>
						</td>
        			</tr>
        		</table>
    		</td>
        	<td style="vertical-align:top;" width='50%'>
        		<table width='100%'>
        			<tr class='admin'>
        				<td colspan='4'><%=getTran(request,"pediatric","antecedents",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin' colspan='4'><%=getTran(request,"web","physiologic",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","prenatalantecedents",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_PRENATAL_ANTECEDENTS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin' rowspan='3'><%=getTran(request,"web","partum",sWebLanguage) %></td>
						<td class='admin2'>
							<%=getTran(request,"web","type",sWebLanguage) %>
						</td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_PARTUMTYPE", "partum.type", sWebLanguage, "") %>
						</td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_PARTUMTYPE_COMMENT", 20, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin2'>
							<%=getTran(request,"web","location",sWebLanguage) %>: 
						</td>
						<td class='admin2' colspan='2'>
							<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_PARTUMLOCATION", "partum.location", sWebLanguage, "") %>
						</td>
        			</tr>
        			<tr>
						<td class='admin2'>
							<%=getTran(request,"web","birthweight",sWebLanguage) %>: 
						</td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_PARTUMWEIGHT", 5, sWebLanguage) %>g
						</td>
						<td class='admin2'>
							<%=getTran(request,"web","birthasphyxia",sWebLanguage) %>
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "birthasphyxia", "ITEM_TYPE_PEDIATRICADMISSION_PARTUMASPHYXIA", sWebLanguage, false,null,"")%>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","lactation",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_LACTATION", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","ablactation",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_ABLACTATION", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin' rowspan='2'><%=getTran(request,"web","vaccinations",sWebLanguage) %></td>
						<td class='admin2'>
							<%=getTran(request,"web","BCG",sWebLanguage) %><br/>
							<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_BCG", 10)  %>
						</td>
						<td class='admin2'>
							<%=getTran(request,"web","DPT",sWebLanguage) %><br/>
							<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_DPT", 10)  %>
						</td>
						<td class='admin2'>
							<%=getTran(request,"web","Polio",sWebLanguage) %><br/>
							<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_POLIO", 10)  %>
						</td>
        			</tr>
        			<tr>
						<td class='admin2'>
							<%=getTran(request,"web","antisarampion",sWebLanguage) %><br/>
							<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_ANTISARAMPION", 10)  %>
						</td>
						<td class='admin2'>
							<%=getTran(request,"web","other",sWebLanguage) %>
						</td>
						<td class='admin2' colspan='2'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_VACCINATION_OTHER", 20, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin' colspan='2'>
							<%=getTran(request,"web","psychomotordevelopmentproblems",sWebLanguage) %>
						</td>
						<td class='admin2' colspan="2">
							<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PEDIATRICADMISSION_PSYCHOMOTORDEVPROBLEMS", sWebLanguage, true, "", "")  %>
						</td>
        			</tr>
        			<tr>
						<td class='admin' colspan='4'><%=getTran(request,"web","pathologies",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin'>
							<%=getTran(request,"web","diseases",sWebLanguage) %> 
						</td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.antecedents.diseases", "ITEM_TYPE_PEDIATRICADMISSION_DISEASES", sWebLanguage, false,"")%>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","allergies",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_ALLERGIES", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","other",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_OTHERDISEASES", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin' colspan='4'><%=getTran(request,"pediatric","family",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","father",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_FATHER", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","mother",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_MOTHER", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","civilstateparents",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_CIVILSTATEPARENTS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","occupationfather",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_OCCUPATIONFATHER", 20, 1) %>
						</td>
						<td class='admin'><%=getTran(request,"web","occupationmother",sWebLanguage) %></td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_OCCUPATIONMOTHER", 20, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","brothersandsisters",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_BROTHERSANDSISTERS", 40, 1) %>
						</td>
        			</tr>
        			<tr>
						<td class='admin'>
							<%=getTran(request,"web","diseases",sWebLanguage) %> 
						</td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.familyantecedents.diseases", "ITEM_TYPE_PEDIATRICADMISSION_FAMILYDISEASES", sWebLanguage, false,"")%>
						</td>
        			</tr>
        			<tr>
						<td class='admin' colspan='4'><%=getTran(request,"pediatric","generalantecedents",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin'>
							<%=getTran(request,"web","living",sWebLanguage) %> 
						</td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "pediatric.living", "ITEM_TYPE_PEDIATRICADMISSION_LIVING", sWebLanguage, false,"")%>
						</td>
        			</tr>
        			<tr>
						<td class='admin'><%=getTran(request,"web","socieconomic",sWebLanguage) %></td>
						<td class='admin2' colspan='3'>
							<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction, "ITEM_TYPE_PEDIATRICADMISSION_SOCIOECONOMIC", 40, 1) %>
						</td>
        			</tr>
        		</table>
    		</td>
    	</tr>
    	<tr>
	        <%-- DIAGNOSES --%>
	        <td style="vertical-align:top;" colspan='2'>
	            <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	        </td>
	    </tr>
	</table>
    
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"pediatric.admission",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	    
	<%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>