<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.spectacleprescription","select",activeUser)%>

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
			<td style="vertical-align:top;padding:0;" class="admin2">    
			    <table class="list" width="100%" cellspacing="1">
			        <%-- DATE --%>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("web.occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <%-- SPECTACLE PRESCRIPTION --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","prescription",sWebLanguage)%>&nbsp;</td>
			        	<td>
			        		<table width='100%' cellspacing='0' cellpadding='0'>
			        			<tr>
			        				<td colspan='2'/>
			            			<td class="admin" width='15%'><%=getTran(request,"web.optical","sphere",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='15%'><%=getTran(request,"web.optical","cylinder",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='15%'><%=getTran(request,"web.optical","axis",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='15%'><%=getTran(request,"web.optical","prism",sWebLanguage)%>&nbsp;</td>
			            			<td class="admin" width='15%'><%=getTran(request,"web.optical","base",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			            			<td class="admin" rowspan='2'><h2><%=getTran(request,"web.optical","distance",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin"><h2><%=getTran(request,"web.optical","od",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_SPHERE" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_CYLINDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_CYLINDER" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_AXIS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_AXIS" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_PRISM" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_PRISM" property="value"/>"></td>
			        				<td class="admin2"><select name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_BASE" property="itemId"/>]>.value'><%=ScreenHelper.writeSelect(request,"spectacles.base",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OD_BASE"),sWebLanguage,false,true) %></select></td>
			        			</tr>
			        			<tr>
			            			<td class="admin"><h2><%=getTran(request,"web.optical","os",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_SPHERE" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_CYLINDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_CYLINDER" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_AXIS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_AXIS" property="value"/>"></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_PRISM" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_PRISM" property="value"/>"></td>
			        				<td class="admin2"><select name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_BASE" property="itemId"/>]>.value'><%=ScreenHelper.writeSelect(request,"spectacles.base",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DISTANCE_OS_BASE"),sWebLanguage,false,true) %></select></td>
			        			</tr>
			        			<tr><td colspan="7"><hr/></td></tr>
			        			<tr>
			            			<td class="admin" rowspan='2'><h2><%=getTran(request,"web.optical","add",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin"><h2><%=getTran(request,"web.optical","od",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OD_SPHERE" property="value"/>"></td>
			            			<td class="admin" colspan="4"><%=getTran(request,"web.optical","additionalinformation",sWebLanguage)%>&nbsp;</td>
			        			</tr>
			        			<tr>
			            			<td class="admin"><h2><%=getTran(request,"web.optical","os",sWebLanguage)%>&nbsp;</h2></td>
			            			<td class="admin2"><input size="5" class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_SPHERE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_OS_SPHERE" property="value"/>"></td>
			            			<td class="admin" colspan="4"><textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ADD_COMMENT")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADD_COMMENT" property="value"/></textarea></td>
			        			</tr>
			        		</table>
			        	</td>
			        </tr>
			        
                </table>
			</td>
		</tr>
    </table>
    
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.medicalcare",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
  
  <%-- SEARCH MANAGER --%>
  function searchManager(managerUidField,managerNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("socialServiceID","CNAR.SOC")%>");
    EditEncounterForm.EditEncounterManagerName.focus();
  }      
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>