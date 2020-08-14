<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.postpartummother","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>

    <table class="list" width="100%" cellspacing="1">
		<tr>
			<td style="vertical-align:top;padding:0" class="admin2" width="50%">
			    <table class="list" width="100%" cellspacing="1">
			        <%-- DATE --%>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
			            </td>
			            <td class="admin2" colspan="5">
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <%-- bloodpressure --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","bloodpressure",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onblur="isNumber(this)">
			                / <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onblur="isNumber(this)"> mmHg
			            </td>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","weight",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_BIOMETRY_WEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onblur="isNumber(this)"> Kg
			            </td>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","respiration",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_BIOMETRY_RESPIRATORYRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_RESPIRATORYRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_RESPIRATORYRATE" property="value"/>" onblur="isNumber(this)"> /min
			            </td>
			        </tr>
			
			        <%-- temperature --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_BIOMETRY_TEMPERATURE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_TEMPERATURE" property="value"/>" onblur="isNumber(this)"> °C
			            </td>
			            <td class="admin"><%=getTran(request,"web","heartrate",sWebLanguage)%></td>
			            <td class="admin2"colspan="3">
			                <input <%=setRightClick(session,"ITEM_TYPE_BIOMETRY_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEARTRATE" property="value"/>" onblur="isNumber(this)"> /min
			            </td>
			        </tr>
			
			        <%-- paleness.conjunctiva --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","paleness.conjunctiva",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_CONJUNCTIVA")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONJUNCTIVA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONJUNCTIVA" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- ppm loss --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","loss",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_LOSS")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LOSS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LOSS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- ppm breast --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","breast",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_BREAST")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_BREAST" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_BREAST" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","abdomen",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_ABDOMEN")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ABDOMEN" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ABDOMEN" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" rowspan="2"><%=getTran(request,"openclinic.chuk","perineum",sWebLanguage)%></td>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","bleeding",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_PERINEUM_BLEEDING")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_PERINEUM_BLEEDING" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_PERINEUM_BLEEDING" property="value"/></textarea>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"openclinic.chuk","tears",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_PERINEUM_TEARS")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_PERINEUM_TEARS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_PERINEUM_TEARS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","legs",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_LEGS")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LEGS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LEGS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- observation --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","observation",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_OBSERVATION")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_OBSERVATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_OBSERVATION" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- treatment --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","treatment",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_TREATMENT")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_TREATMENT" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- LOCHIES ----------------------------------------------------------------------------%>
			        <%-- aspect --%>
			        <tr>
			            <td class="admin" rowspan="4" width="40"><%=getTran(request,"gynaeco","lochies",sWebLanguage)%></td>
			            <td class="admin" width="40"><%=getTran(request,"gynaeco","lochies.aspect",sWebLanguage)%></td>
			            <td class="admin2"  colspan="5">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_ASPECT")%> type="radio" onDblClick="uncheckRadio(this);" id="aspect_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ASPECT" property="itemId"/>]>.value" value="medwan.common.normal" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ASPECT;value=medwan.common.normal" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.normal",sWebLanguage,"aspect_r1")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_ASPECT")%> type="radio" onDblClick="uncheckRadio(this);" id="aspect_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ASPECT" property="itemId"/>]>.value" value="medwan.common.anormal" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ASPECT;value=medwan.common.anormal" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.anormal",sWebLanguage,"aspect_r2")%>
			            </td>
			        </tr>
			        
			        <%-- odeur --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"gynaeco","lochies.odeur",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_ODEUR")%> type="radio" onDblClick="uncheckRadio(this);" id="odeur_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ODEUR" property="itemId"/>]>.value" value="medwan.common.normal" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ODEUR;value=medwan.common.normal" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.normal",sWebLanguage,"odeur_r1")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_ODEUR")%> type="radio" onDblClick="uncheckRadio(this);" id="odeur_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ODEUR" property="itemId"/>]>.value" value="medwan.common.anormal" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_ODEUR;value=medwan.common.anormal" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.anormal",sWebLanguage,"odeur_r2")%>
			            </td>
			        </tr>
			
			        <%-- lochies.conclusion --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"gynaeco","lochies.conclusion",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_CONCLUSION")%> type="radio" onDblClick="uncheckRadio(this);" id="conclusion_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONCLUSION" property="itemId"/>]>.value" value="gynaeco.conclusion.nonpathologique" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONCLUSION;value=gynaeco.conclusion.nonpathologique" property="value" outputString="checked"/>><%=getLabel(request,"gynaeco.conclusion","nonpathologique",sWebLanguage,"conclusion_r1")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPM_CONCLUSION")%> type="radio" onDblClick="uncheckRadio(this);" id="conclusion_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONCLUSION" property="itemId"/>]>.value" value="gynaeco.conclusion.pathologique" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_CONCLUSION;value=gynaeco.conclusion.pathologique" property="value" outputString="checked"/>><%=getLabel(request,"gynaeco.conclusion","pathologique",sWebLanguage,"conclusion_r2")%>
			            </td>
			        </tr>
			
			        <%-- lochies.remark --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"gynaeco","lochies.remark",sWebLanguage)%></td>
			            <td class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPM_LOCHIES_CONCLUSION_REMARK")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LOCHIES_CONCLUSION_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPM_LOCHIES_CONCLUSION_REMARK" property="value"/></textarea>
			            </td>
			        </tr>
			    </table>
			</td>
			
			<%-- DIAGNOSES --%>
			<td style="vertical-align:top;padding:0" class="admin2">
                <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
			</td>
		</tr>
    </table>
        
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.postpartummother",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
	  alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
	  searchEncounter();
	}	
    else{
	  document.getElementById("buttonsDiv").style.visibility = "hidden";
	  var temp = Form.findFirstElement(transactionForm);//for ff compatibility
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
</script>

<%=writeJSButtons("transactionForm","saveButton")%>