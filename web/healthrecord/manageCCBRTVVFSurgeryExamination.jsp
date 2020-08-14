<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.vvfsurgery","select",activeUser)%>

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
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","height",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_HEIGHT" translate="false" property="value"/>"/> cm
            </td>
			<td class='admin'><%=getTran(request,"web","hb",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_HB" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_HB" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","weight",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_WEIGHT" translate="false" property="value"/>"/> kg
            </td>
			<td class='admin'><%=getTran(request,"web","bp",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_BP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_BP" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","generalcondition",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="generalcondition" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_GENERALCONDITION" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.generalcondition",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_GENERALCONDITION"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","creatinine",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_CREATININE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_CREATININE" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","fistulaclassification",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="fistulaclassification" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_FISTULACLASSIFICATION" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.fistulaclassification",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_FISTULACLASSIFICATION"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","otherinvestigation",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OTHERINVESTIGATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OTHERINVESTIGATION" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","primarydiagnosis",sWebLanguage) %></td>
            <td class='admin2' colspan='3'>
	            <select id="primarydiagnosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PRIMARYDIAGNOSIS" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.primarydiagnosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PRIMARYDIAGNOSIS"),sWebLanguage,false,true) %>
	            </select>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","operationcode",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="operationcode" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OPERATIONCODE" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.operationcode",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OPERATIONCODE"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","surgerydate",sWebLanguage) %></td>
            <td class='admin2'>
				<%=ScreenHelper.writeDateField("surgerydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_SURGERYDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","preopusi",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="preopusi" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PREOPUSI" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.preopusi",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PREOPUSI"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","timewithcatheter",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_TIMEWITHCATHETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_TIMEWITHCATHETER" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","grade",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="preopgrade" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PREOPUSIGRADE" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.grade",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PREOPUSIGRADE"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","vvfsurgeryoutcome",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="outcome" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OUTCOME" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.outcome",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_OUTCOME"),sWebLanguage,false,true) %>
	            </select>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","bladdersize",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_BLADDERSIZE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_BLADDERSIZE" translate="false" property="value"/>"/> cm
            </td>
			<td class='admin'><%=getTran(request,"web","postopusi",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="postopusi" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_POSTOPUSI" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.postopusi",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_POSTOPUSI"),sWebLanguage,false,true) %>
	            </select>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","urethrallength",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_URETHRALLENGTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_URETHRALLENGTH" translate="false" property="value"/>"/> cm 
            </td>
			<td class='admin'><%=getTran(request,"web","grade",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="postopgrade" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_POSTOPUSIGRADE" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.grade",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_POSTOPUSIGRADE"),sWebLanguage,false,true) %>
	            </select>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","dyetest",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="dyetest" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_DYETEST" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.dyetest",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_DYETEST"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
            <td class='admin2'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_VVF_SURGERY_COMMENT")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_COMMENT" property="value"/></textarea>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","concurrentlesionsrvf",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="concurrentlesionsrvf" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_CONCURRENTLESIONSRVF" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.concurrentlesionsrvf",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_CONCURRENTLESIONSRVF"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","fudate",sWebLanguage) %></td>
            <td class='admin2'>
				<%=ScreenHelper.writeDateField("fudate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_FUDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","paralysisperonealnerve",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="paralysisperonealnerve" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PARALYSISPERONEALNERVE" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.paralysisperonealnerve",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_PARALYSISPERONEALNERVE"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","noofmonth",sWebLanguage) %></td>
            <td class='admin2'>
            	<input type="text" class="text" size="8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_NOOFMONTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_NOOFMONTH" translate="false" property="value"/>"/> 
            </td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","vaginalstenosis",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="vaginalstenosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_VAGINALSTENOSIS" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.vaginalstenosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_VAGINALSTENOSIS"),sWebLanguage,false,true) %>
	            </select>
            </td>
			<td class='admin'><%=getTran(request,"web","vulvalexcoriation",sWebLanguage) %></td>
            <td class='admin2'>
	            <select id="vulvalexcoriation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_VULVALEXCORIATION" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.vulvalexcoriation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERY_VULVALEXCORIATION"),sWebLanguage,false,true) %>
	            </select>
            </td>
		</tr>

    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.vvfsurgery",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>

  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  <%-- SUBMIT FORM --%>
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTOrthoRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}

  function submitForm(){
      transactionForm.saveButton.disabled = true;
      <%
      	SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	  %>
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>