<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ndhadmission","select",activeUser)%>

<%!
    //--- GET KEYWORDS HTML -----------------------------------------------------------------------
	private String getKeywordsHTML(TransactionVO transaction, String itemId, String textField,
			                       String idsField, String language){
		StringBuffer sHTML = new StringBuffer();
		ItemVO item = transaction.getItem(itemId);
		if(item!=null && item.getValue()!=null && item.getValue().length()>0){
			String[] ids = item.getValue().split(";");
			String keyword = "";
			
			for(int n=0; n<ids.length; n++){
				if(ids[n].split("\\$").length==2){
					keyword = getTran(null,ids[n].split("\\$")[0],ids[n].split("\\$")[1] , language);
					
					sHTML.append("<a href='javascript:deleteKeyword(\"").append(idsField).append("\",\"").append(textField).append("\",\"").append(ids[n]).append("\");'>")
					      .append("<img width='8' src='"+sCONTEXTPATH+"/_img/themes/default/erase.png' class='link' style='vertical-align:-1px'/>")
					     .append("</a>")
					     .append("&nbsp;<b>").append(keyword.startsWith("/")?keyword.substring(1):keyword).append("</b> | ");
				}
			}
		}
		
		String sHTMLValue = sHTML.toString();
		if(sHTMLValue.endsWith("| ")){
			sHTMLValue = sHTMLValue.substring(0,sHTMLValue.lastIndexOf("| "));
		}
		
		return sHTMLValue;
	}
%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value='/healthrecord/updateTransaction.do'/>?ts=<%=getTs()%>" focus='type'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
	<%TransactionVO tran = (TransactionVO)transaction; %>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width='100%' border='0' cellspacing="1">
        <tr>
            <td style="vertical-align:top;" width="50%">
                <table width="100%" cellpadding="1" cellspacing="1">
				    <%-- DATE --%>
				    <tr>
				        <td class="admin">
				            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
				            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
				        </td>
				        <td class="admin2">
				            <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur='checkDate(this)'> <script>writeTranDate();</script>
							<!-- Add time section -->
			                <%
			                	java.util.Date date = ((TransactionVO)transaction).getUpdateTime();
			                	if(date==null){
			                		date=new java.util.Date();
			                	}
			                	String sTime=new SimpleDateFormat("HH:mm").format(date);
			                %>
			                <input type='text' class='text' size='5' maxLength='5' name='trantime' id='trantime' value='<%=sTime%>'/>
			                <!-- End time section -->
				        </td>
				    </tr>
				    
				    <%--  DONNEES CLINIQUES --%>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","reasonforadmission",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_REASONFORADMISSION")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_REASONFORADMISSION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_REASONFORADMISSION" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","diseasehistory",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_DISEASEHISTORY")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DISEASEHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DISEASEHISTORY" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr class='admin'>
				        <td colspan="2"><%=getTran(request,"web","antecedents",sWebLanguage)%>&nbsp;</td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'> - <%=getTran(request,"web","familyantecedents",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_ANTECEDENTS_FAMILY")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_FAMILY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_FAMILY" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'> - <%=getTran(request,"web","medicalantecedents",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_ANTECEDENTS_MEDICAL")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_MEDICAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_MEDICAL" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'> - <%=getTran(request,"web","surgeryantecedents",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_ANTECEDENTS_SURGERY")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_SURGERY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_SURGERY" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'> - <%=getTran(request,"web","goantecedents",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_ANTECEDENTS_GO")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_GO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_ANTECEDENTS_GO" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","lifestyle",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_LIFESTYLE")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_LIFESTYLE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_LIFESTYLE" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","generalcondition",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				            <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_GENERALCONDITION")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_GENERALCONDITION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_GENERALCONDITION" property="value"/></textarea>
				        </td>
				    </tr>
				</table>
		    </td>
   
            <td style="vertical-align:top;" width="50%">
                <table width="100%" cellpadding="1" cellspacing="1">
	                <tr class="admin">
	                    <td align="center" colspan="4"><%=getTran(request,"Web.Occup","nurseexamination",sWebLanguage)%></td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"web","temperature",sWebLanguage)%>&nbsp;(°C)</td>
			            <td class='admin2'><input <%=setRightClickMini("[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> id="temperature" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>"/></td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
			            <td class='admin2' nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(30,220,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}"> /min
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="nex-r9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"nex-r9")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="nex-r10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"nex-r10")%>
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="validateWeight(this);calculateBMI();"/></td>
			            <td class="admin">
			                <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>
			            	<%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%>
			            </td>
			            <%-- right --%>
			            <td class="admin2" nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(30,220,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}"> /
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(30,220,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}"> mmHg
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="validateHeight(this);calculateBMI();"/></td>
			            <td class="admin">
			            	<%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>
			            	<%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%>
			            </td>
			            <td class="admin2" nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(30,220,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}"> /
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(30,220,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}"> mmHg
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input tabindex="-1" class="text" type="text" size="5" readonly name="BMI"></td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.respiratory.frequence-respiratoire",sWebLanguage)%></td>
			            <td class='admin2' nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_FREQUENCY" property="value"/>"> /min
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="nex-r9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"nex-r9")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="nex-r10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_RESPIRATORY_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"nex-r10")%>
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%>&nbsp;<img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			            <td class='admin2'><input tabindex="-1" class="text" type="text" size="5" readonly name="WFL" id="WFL"></td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.brachial.circumference",sWebLanguage)%></td>
			            <td class='admin2' nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_BRACHIAL_CIRCUMFERENCE")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BRACHIAL_CIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BRACHIAL_CIRCUMFERENCE" property="value"/>"/> cm
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%></td>
			            <td class='admin2' nowrap>
			                <input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %
			            </td>
			            <td class='admin'><%=getTran(request,"web","abdomencircumference",sWebLanguage)%></td>
			            <td class='admin2' nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm
			            </td>
	                </tr>
	                <tr>
			            <td class='admin'><%=getTran(request,"web","fhr",sWebLanguage)%></td>
			            <td class='admin2' colspan='3' nowrap>
			                <input <%=setRightClick(session,"ITEM_TYPE_FOETAL_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="value"/>"/>
			            </td>
	                </tr>

				</table>
	    	</td>
	    </tr>
	</table>
	<table width='100%' cellpadding="1" cellspacing="1">
		<tr class="admin">
		    <td colspan="2"><%=getTran(request,"web","physicalexamination",sWebLanguage)%></td>
		</tr>
		<tr>
         	<td class="admin2" width='70%' style="vertical-align:top;padding:0px;">
				<table width='100%' cellpadding="0" cellspacing="0">
					<%-- Inspection --%>
					<tr height="40">
						<td class='admin' width ="<%=sTDAdminWidth%>">
							<div id="title2"><%=getTran(request,"web","inspection",sWebLanguage)%></div>
						</td>
						<td>
							<table width='100%'>
								<tr onclick='selectKeywords("inspection.ids","inspection.text","ikirezi2.inspection","keywords",this)'>
				 				<td class='admin2'>
				 					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_COMMENT" property="itemId"/>]>.value" id='inspection.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_COMMENT" property="value"/></textarea> 
				 				</td>
				 				<td class='admin2' width='1%' style="text-align:center">
				 				    <img width='16' id='key2' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
				 				</td>
				 				<td class='admin2' width='50%' style="vertical-align:top;">
				 					<div id='inspection.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_INSPECTION_IDS","inspection.text","inspection.ids",sWebLanguage)%></div>
				 					<input type='hidden' id='inspection.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_IDS" property="value"/>"/>
				 				</td>
				 			</tr>
							</table>
						</td>
					</tr>
					
					<%-- Palpation --%>
					<tr height="40">
						<td class='admin'>
							<div id="title3"><%=getTran(request,"web","palpation",sWebLanguage)%></div>
						</td>
						<td>
							<table width='100%'>
								<tr onclick='selectKeywords("palpation.ids","palpation.text","ikirezi2.palpation","keywords",this)'>
					 				<td class='admin2'>
					 					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_COMMENT" property="itemId"/>]>.value" id='palpation.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_COMMENT" property="value"/></textarea> 
					 				</td>
					 				<td class='admin2' width='1%' style="text-align:center">
					 				    <img width='16' id='key3' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
					 				</td>
					 				<td class='admin2' width='50%' style="vertical-align:top;">
					 					<div id='palpation.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_PALPATION_IDS","palpation.text","palpation.ids",sWebLanguage)%></div>
					 					<input type='hidden' id='palpation.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_IDS" property="value"/>"/>
					 				</td>
					 			</tr>
							</table>
						</td>
					</tr>
					
					<%-- Heart ausculation --%>
					<tr height="40">
						<td class='admin'>
							<div id="title4"><%=getTran(request,"web","auscultation",sWebLanguage)%></div>
						</td>
						<td>
							<table width='100%'>
								<tr onclick='selectKeywords("auscultation.ids","auscultation.text","ikirezi2.auscultation","keywords",this)'>
				 				<td class='admin2'>
				 					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_COMMENT" property="itemId"/>]>.value" id='auscultation.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_COMMENT" property="value"/></textarea> 
				 				</td>
				 				<td class='admin2' width='1%' style="text-align:center">
				 				    <img width='16' id='key4' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
				 				</td>
				 				<td class='admin2' width='50%' style="vertical-align:top;">
				 					<div id='auscultation.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_HEARTAUSCULTATION_IDS","auscultation.text","auscultation.ids",sWebLanguage)%></div>
				 					<input type='hidden' id='auscultation.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_IDS" property="value"/>"/>
				 				</td>
				 			</tr>
							</table>
						</td>
					</tr>
					
					<%-- Percussion --%>
					<tr height="40">
						<td class='admin'>
							<div id="title7"><%=getTran(request,"web","percussion",sWebLanguage)%></div>
						</td>
						<td>
							<table width='100%'>
								<tr onclick='selectKeywords("percussion.ids","percussion.text","ikirezi2.percussion","keywords",this)'>
				 				<td class='admin2'>
				 					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PERCUSSION_COMMENT" property="itemId"/>]>.value" id='auscultation.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PERCUSSION_COMMENT" property="value"/></textarea> 
				 				</td>
				 				<td class='admin2' width='1%' style="text-align:center">
				 				    <img width='16' id='key7' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
				 				</td>
				 				<td class='admin2' width='50%' style="vertical-align:top;">
				 					<div id='percussion.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_PERCUSSION_IDS","percussion.text","percussion.ids",sWebLanguage)%></div>
				 					<input type='hidden' id='percussion.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PERCUSSION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PERCUSSION_IDS" property="value"/>"/>
				 				</td>
				 			</tr>
							</table>
						</td>
					</tr>
					
					<tr>
					    <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","summary",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="3">
						    <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_SUMMARY")%> class="text" cols="45" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_SUMMARY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_SUMMARY" property="value"/></textarea>
					    </td>
					</tr>
					<tr>
					    <td class='admin'><%=getTran(request,"web","diagnosis",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="3">
						    <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_DIAGNOSIS")%> class="text" cols="45" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DIAGNOSIS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_DIAGNOSIS" property="value"/></textarea>
					    </td>
					</tr>
			         <tr class="admin">
			             <td colspan="2"><%=getTran(request,"web","other",sWebLanguage)%></td>
			         </tr>
					<tr>
					    <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"web","complementaryexaminations",sWebLanguage)%>&nbsp;</td>
						<td class='admin2'>
						    <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_EXAMINATIONS")%> class="text" cols="45" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_EXAMINATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_EXAMINATIONS" property="value"/></textarea>
					    </td>
					</tr>
					<tr>
					    <td class='admin'><%=getTran(request,"web","treatment",sWebLanguage)%>&nbsp;</td>
						<td class='admin2'>
						    <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_TREATMENT")%> class="text" cols="45" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_TREATMENT" property="value"/></textarea>
					    </td>
					</tr>
					<tr>
					    <td class='admin'><%=getTran(request,"web","hprccomment",sWebLanguage)%>&nbsp;</td>
						<td class='admin2'>
						    <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_HPRC_COMMENT")%> class="text" cols="45" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_COMMENT" property="value"/></textarea>
					    </td>
					</tr>
					<tr>
					    <td class='admin'><%=getTran(request,"web","integration",sWebLanguage)%>&nbsp;</td>
					     <td class='admin2'>
							<select class='text' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_INTEGRATION" property="itemId"/>]>.value">
								<option/>
								<%=ScreenHelper.writeSelect(request, "bi.integration", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HPRC_INTEGRATION"), sWebLanguage) %>
							</select>
					     </td>
					 </tr>
				</table>
			</td>
         	<%-- KEYWORDS --%>
         	<td id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
         		<div id='test'></div>
         		<div style="height:300px;overflow:auto;position: sticky;top: 0" id="keywords"></div>
         	</td>
		</tr>
	</table>
	<table width='100%' cellpadding="1" cellspacing="1">
	    <tr>
			<td colspan='2'>
	    	   	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
	    </tr>
    </table>
        
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.hprcadmission",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
  <input type='hidden' name='activeDestinationIdField' id='activeDestinationIdField'/>
  <input type='hidden' name='activeDestinationTextField' id='activeDestinationTextField'/>
  <input type='hidden' name='activeLabeltype' id='activeLabeltype'/>
  <input type='hidden' name='activeDivld' id='activeDivld'/>


</form>

<script>
	<%-- SUBMIT FORM --%> 
	function submitForm(){
		  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
				alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
				searchEncounter();
			  }	
		  else {
		    transactionForm.saveButton.disabled = true;
		    document.getElementById('trandate').value+=' '+document.getElementById('trantime').value;
		    <%
		        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
		        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
		    %>
		  }
	}    
	  function searchEncounter(){
	      openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
	  }
	  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
			alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
			searchEncounter();
	}	

  <%-- VALIDATE WEIGHT --%>
  <%
      int minWeight = 0;
      int maxWeight = 500;

      String weightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight.validationerror",sWebLanguage);
      weightMsg = weightMsg.replaceAll("#min#",minWeight+"");
      weightMsg = weightMsg.replaceAll("#max#",maxWeight+"");
  %>
  function validateWeight(weightInput){
    isNumber(weightInput);
    weightInput.value = weightInput.value.replace(",",".");
    if(weightInput.value.length > 0){
      var min = <%=minWeight%>;
      var max = <%=maxWeight%>;

      if(isNaN(weightInput.value) || weightInput.value < min || weightInput.value > max){
        alertDialogDirectText("<%=weightMsg%>");
        //weightInput.value = "";
        //weightInput.focus();
      }
    }
  }

  <%-- VALIDATE HEIGHT --%>
  <%
      int minHeight = 0;
      int maxHeight = 300;

      String heightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.height.validationerror",sWebLanguage);
      heightMsg = heightMsg.replaceAll("#min#",minHeight+"");
      heightMsg = heightMsg.replaceAll("#max#",maxHeight+"");
  %>
  function validateHeight(heightInput){
    isNumber(heightInput);
    heightInput.value = heightInput.value.replace(",",".");
    if(heightInput.value.length > 0){
      var min = <%=minHeight%>;
      var max = <%=maxHeight%>;

      if(isNaN(heightInput.value) || heightInput.value < min || heightInput.value > max){
    	alertDialogDirectText("<%=heightMsg%>");
        //heightInput.focus();
      }
    }
  }

  <%-- CALCULATE BMI --%>
  function calculateBMI(){
    var _BMI = 0, _WFL=0;
    var heightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value')[0];
    var weightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value')[0];

    if(heightInput.value > 0){
        _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
        _WFL = (weightInput.value) / (heightInput.value);
      if (_BMI > 100 || _BMI < 5){
          document.getElementsByName('BMI')[0].value = "";
      }
      else {
          document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
      }
      if(_WFL>0){
          document.getElementsByName('WFL')[0].value = _WFL.toFixed(2);
    	  checkWeightForHeight(heightInput.value,weightInput.value);
      }
      else{
          document.getElementsByName('WFL')[0].value = "";
      }
    }
  }
	function checkWeightForHeight(height,weight){
	      var today = new Date();
	      var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
	      new Ajax.Request(url,{
	          method: "POST",
	          postBody: "",
	          onSuccess: function(resp){
	              var label = eval('('+resp.responseText+')');
	    		  if(label.zindex>-999){
	    			  if(label.zindex<-4){
	    				  document.getElementById("WFL").className="darkredtext";
	    				  document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-3){
	    				  document.getElementById("WFL").className="darkredtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-2){
	    				  document.getElementById("WFL").className="orangetext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>2){
	    				  document.getElementById("WFL").className="orangetext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else{
	    				  document.getElementById("WFL").className="text";
	    				  document.getElementById("wflinfo").style.display='none';
	    			  }
	    		  }
  			  else{
  				  document.getElementById("WFL").className="text";
  				  document.getElementById("wflinfo").style.display='none';
  			  }
	          },
	          onFailure: function(){
	          }
	      }
		  );
	  	}

	  <%-- SELECT KEYWORDS --%>
	  function selectKeywords(destinationidfield,destinationtextfield,labeltype,divid,element){	
		if(element){
			//document.getElementById("keywordstd").style="position: absolute;top: "+element.getBoundingClientRect().top;

		}
	    var bShowKeywords=true;
		document.getElementById("activeDestinationIdField").value=destinationidfield;
		document.getElementById("activeDestinationTextField").value=destinationtextfield;
		document.getElementById("activeLabeltype").value=labeltype;
		document.getElementById("activeDivld").value=divid;
		
	    //document.getElementById("key0").width = "16";
	    //document.getElementById("key1").width = "16";
	    document.getElementById("key2").width = "16";
	    document.getElementById("key3").width = "16";
	    document.getElementById("key4").width = "16";
	    //document.getElementById("key6").width = "16";
	    document.getElementById("key7").width = "16";
	    //document.getElementById("key8").width = "16";
	    
	    //document.getElementById("title0").style.textDecoration = "none";
	    //document.getElementById("title1").style.textDecoration = "none";
	    document.getElementById("title2").style.textDecoration = "none";
	    document.getElementById("title3").style.textDecoration = "none";
	    document.getElementById("title4").style.textDecoration = "none";
	    //document.getElementById("title6").style.textDecoration = "none";
	    document.getElementById("title7").style.textDecoration = "none";
	    //document.getElementById("title8").style.textDecoration = "none";

	    if(labeltype=='ikirezi2.general.signs'){
	        document.getElementById("title0").style.textDecoration = "underline";
		  	document.getElementById('key0').width = '32';
		  	//document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else if(labeltype=='ikirezi2.chugtfunctional.signs'){
	        document.getElementById("title1").style.textDecoration = "underline";
		  	document.getElementById('key1').width = '32';
		  	//document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else if(labeltype=='ikirezi2.inspection'){
	      document.getElementById("title2").style.textDecoration = "underline";
		  document.getElementById('key2').width = '32';
		  	//document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else if(labeltype=='ikirezi2.palpation'){
	      document.getElementById("title3").style.textDecoration = "underline";
		  document.getElementById('key3').width = '32';
		  	//document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else if(labeltype=='ikirezi2.auscultation'){
	      document.getElementById("title4").style.textDecoration = "underline";
		  document.getElementById('key4').width = '32';
		  	//document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else if(labeltype=='reference'){
	        document.getElementById("title6").style.textDecoration = "underline";
	  	  document.getElementById('key6').width = '32';
	  	  	//document.getElementById('keywordstd').style = "vertical-align:bottom";
	  	}
	    else if(labeltype=='ikirezi2.percussion'){
	        document.getElementById("title7").style.textDecoration = "underline";
	  	  document.getElementById('key7').width = '32';
	  	  	//document.getElementById('keywordstd').style = "vertical-align:bottom";
	  	}
	    else if(labeltype=='ikirezi2.trtv'){
	        document.getElementById("title8").style.textDecoration = "underline";
	  	  document.getElementById('key8').width = '32';
	  	  	//document.getElementById('keywordstd').style = "vertical-align:bottom";
	  	}
	    else{
	    	bShowKeywords=false;
	    }
	    
	    if(bShowKeywords){
		    var params = "";
		    var today = new Date();
		    var url = '<c:url value="/healthrecord/ajax/getKeywords.jsp"/>'+
		              '?destinationidfield='+destinationidfield+
		              '&destinationtextfield='+destinationtextfield+
		              '&labeltype='+labeltype+
		              '&filetype=new'+
		              '&ts='+today;
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		        $(divid).innerHTML = resp.responseText;
		    	  if(resp.responseText.indexOf("<recheck/>")>-1){
		    		  window.setTimeout('storekeywordsubtype(document.getElementById("keywordsubtype").value);',200);
		    	  }
		    	  <%
		    	  	if(checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){%>
		            	myselect=document.getElementById('keywordsubtype');
		            	myselect.style='border:2px solid black; border-style: dotted';
		            	myselect.onclick=function(){window.open('<%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType=keywordsubtypes.'+labeltype+'&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};
		    	  <%
		    	  	}
		    	  %>
		      },
		      onFailure: function(){
		        $(divid).innerHTML = "";
		      }
		    });
	    }
	    else{
	        $(divid).innerHTML = "";
	    }
	  }

	  function newkeyword(){
	      openPopup("/healthrecord/ajax/newKeyword.jsp&ts=<%=getTs()%>&labeltype="+document.getElementById("activeLabeltype").value+"."+document.getElementById("keywordsubtype").value);
	  }
	  
	  function deletekeyword(labeltype,labelid){
		if(confirm("<%=getTranNoLink("web","areyousure",sWebLanguage)%>")){
		    var params = "";
		    var today = new Date();
		    var url = '<c:url value="/healthrecord/ajax/deleteKeyword.jsp"/>'+
		              '?labeltype='+labeltype+'&labelid='+labelid;
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  refreshKeywords();
		      },
		      onFailure: function(){
		      }
		    });
		}
	  }
	  
	  function refreshKeywords(){
		  selectKeywords(document.getElementById("activeDestinationIdField").value,
				  document.getElementById("activeDestinationTextField").value,
				  document.getElementById("activeLabeltype").value,
				  document.getElementById("activeDivld").value);
	  }
	  
	  <%-- ADD KEYWORD --%>
	  function addKeyword(id,label,destinationidfield,destinationtextfield){
		while(document.getElementById(destinationtextfield).innerHTML.indexOf('&nbsp;')>-1){
			document.getElementById(destinationtextfield).innerHTML=document.getElementById(destinationtextfield).innerHTML.replace('&nbsp;','');
		}
		var ids = document.getElementById(destinationidfield).value;
		if((ids+";").indexOf(id+";")<=-1){
		  document.getElementById(destinationidfield).value = ids+";"+id;
		  
		  if(document.getElementById(destinationtextfield).innerHTML.length > 0){
			if(!document.getElementById(destinationtextfield).innerHTML.endsWith("| ")){
	          document.getElementById(destinationtextfield).innerHTML+= " | ";
		    }
		  }
		  
		  document.getElementById(destinationtextfield).innerHTML+= "<span style='white-space: nowrap;'><a href='javascript:deleteKeyword(\""+destinationidfield+"\",\""+destinationtextfield+"\",\""+id+"\");'><img width='8' src='<c:url value="/_img/themes/default/erase.png"/>' class='link' style='vertical-align:-1px'/></a> <b>"+label+"</b></span> | ";
		}
	  }

	  function storekeywordsubtype(s){
	    var params = "";
	    var today = new Date();
	    var url = '<c:url value="/healthrecord/ajax/storeKeywordSubtype.jsp"/>'+
	              '?subtype='+s;
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  selectKeywords(document.getElementById("activeDestinationIdField").value,
	    			  document.getElementById("activeDestinationTextField").value,
	    			  document.getElementById("activeLabeltype").value,
	    			  document.getElementById("activeDivld").value);
	      },
	      onFailure: function(){
	      }
	    });
	  }

	  <%-- DELETE KEYWORD --%>
	  function deleteKeyword(destinationidfield,destinationtextfield,id){
		var newids = "";
		
		var ids = document.getElementById(destinationidfield).value.split(";");
		for(n=0; n<ids.length; n++){
		  if(ids[n].indexOf("$")>-1){
			if(id!=ids[n]){
			  newids+= ids[n]+";";
			}
		  }
		}
		
		document.getElementById(destinationidfield).value = newids;
		var newlabels = "";
		var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
	    for(n=0;n<labels.length;n++){
		  if(labels[n].trim().length>0 && labels[n].indexOf(id)<=-1){
		    newlabels+=labels[n]+" | ";
		  }
		}
	    
		document.getElementById(destinationtextfield).innerHTML = newlabels;	
	  }

  calculateBMI();

</script>

<%=writeJSButtons("transactionForm","saveButton")%>