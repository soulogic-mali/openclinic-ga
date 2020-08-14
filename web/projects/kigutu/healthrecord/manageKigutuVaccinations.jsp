<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.kigutuvaccinations","select",activeUser)%>

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
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
				<%-- DESCRIPTION --%>
        <tr>
			<td width="60%">
				<table width='100%'>
					<tr>
						<td class="admin"><%=getTran(request,"web","vita1",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VITA1" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"vat.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VITA1"),sWebLanguage,false,true) %>
			                </select>
						</td>
						<td class="admin"><%=getTran(request,"web","vita2",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VITA2" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"vat.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VITA2"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>
					<tr>
						<td class="admin" ><%=getTran(request,"web","bcg",sWebLanguage)%>&nbsp;</td>
					
						<td class="admin2" colspan="3">
							<input type="checkbox" id="bcg" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_BCG" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_BCG;value=true"
                                         property="value"
                                         outputString="checked"/>>
						</td>
					</tr>
					<tr>
						<td class="admin" ><%=getTran(request,"web","hapatiteb",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="3">
							<input type="checkbox" id="bcg" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_HEPATITEB" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_HEPATITEB;value=true"
                                         property="value"
                                         outputString="checked"/>>
						</td>
					</tr>
					<tr>
						<td class="admin"><%=getTran(request,"web","vapo",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VAPO" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"vapo.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VAPO"),sWebLanguage,false,true) %>
			                </select>
						</td>
						<td class="admin"><%=getTran(request,"web","penta",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_PENTA" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"penta.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_PENTA"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>
					
					
					<tr>
						<td class="admin"><%=getTran(request,"web","rota",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_ROTA" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"rota.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_ROTA"),sWebLanguage,false,true) %>
			                </select>
						</td>
						<td class="admin"><%=getTran(request,"web","vapneumo",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="1">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VA" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"vapneumo.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VA"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>
					
					<tr>
						<td class="admin"><%=getTran(request,"web","var",sWebLanguage)%>&nbsp;</td>
						<td class='admin2' colspan="3">
			             <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VAR" property="itemId"/>]>.value">
			             <option/>
				          <%=ScreenHelper.writeSelect(request,"var.period",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VAR"),sWebLanguage,false,true) %>
			                </select>
						</td>
					</tr>
					<tr>
						<td class="admin" ><%=getTran(request,"web","dct4",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="3">
							<input type="checkbox" id="bcg" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_DCT4" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_DCT4;value=true"
                                         property="value"
                                         outputString="checked"/>>
						</td>
					</tr>
					<tr>
						<td class="admin" ><%=getTran(request,"web","child_vaccinated",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="1">						
						<input type="checkbox" id="bcg" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VACCINATEDCHILD" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_VACCINATEDCHILD;value=true"
                                         property="value"
                                         outputString="checked"/>>
										 
						</td>
						<td class="admin" ><%=getTran(request,"web","milda",sWebLanguage)%>&nbsp;</td>
						<td class="admin2" colspan="1">
							<input type="checkbox" id="bcg" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_MILDA" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_KIGUTUVACCINATION_MILDA;value=true"
                                         property="value"
                                         outputString="checked"/>>
						</td>
					</tr>	
				</table>
			</td>
		
	
			<%-- DIAGNOSES --%>
	    	<td class="admin2"colspan="2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
		</tr>
	</table>
    
	        
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.kigutuobprotocol",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>
<script>
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID" property="itemId"/>]>.value&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	
  
<%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    document.transactionForm.submit();
  }

</script>

    
<%=writeJSButtons("transactionForm","saveButton")%>