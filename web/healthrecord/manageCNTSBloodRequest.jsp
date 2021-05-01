<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.cnts.bloodrequest","select",activeUser)%>

<form id="transactionForm" name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
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
    <%
	String rn=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDNUMBEROFBAGS");
	String rcn=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDNUMBEROFBAGS");
    %>
    <table width='100%'>
        <tr>
            <td class="admin" colspan='2'>
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
    	<tr>
    		<td width='50%' valign='top'>
    			<table width='100%'>
    				<tr class='admin'>
    					<td colspan='2'><%=getTran(request,"web","requested",sWebLanguage) %></td>
    				</tr>
			         <tr>
			            <td class="admin" width='30%'><%=getTran(request,"web","bloodgroupreceiver",sWebLanguage)%></td>
			            <td class="admin2">
			            	 <%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNTS_BLOODGROUPRECEIVER", "abobloodgroup", sWebLanguage, "") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","numberofbags",sWebLanguage)%></td>
			            <td class="admin2">
			                 <select <%=setRightClick(session,"ITEM_TYPE_CNTS_REQUESTEDNUMBEROFBAGS")%> id="numberofbags" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDNUMBEROFBAGS" property="itemId"/>]>.value" class="text">
			                     <option/>
			                     <option value="1" <%=rn.equalsIgnoreCase("1")?"selected":""%>>1</option>
			                     <option value="2" <%=rn.equalsIgnoreCase("2")?"selected":""%>>2</option>
			                     <option value="3" <%=rn.equalsIgnoreCase("3")?"selected":""%>>3</option>
			                     <option value="4" <%=rn.equalsIgnoreCase("4")?"selected":""%>>4</option>
			                     <option value="5" <%=rn.equalsIgnoreCase("5")?"selected":""%>>5</option>
			                 </select>
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","volume",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_REQUESTEDVOLUME")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDVOLUME" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDVOLUME" property="value"/>"> ml
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","producttype",sWebLanguage)%></td>
			            <td class="admin2">
			                 <%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNTS_PRODUCTTYPE", "cnts.producttype", sWebLanguage, "") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","allreadytransfused",sWebLanguage)%></td>
			            <td class="admin2">
			                 <select <%=setRightClick(session,"ITEM_TYPE_CNTS_ALLREADYTRANSFUSED")%> id="numberofbags" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_ALLREADYTRANSFUSED" property="itemId"/>]>.value" class="text">
			                     <option/>
			                     <option value="0" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_ALLREADYTRANSFUSED").equalsIgnoreCase("0")?"selected":""%>><%=getTranNoLink("web","no",sWebLanguage) %></option>
			                     <option value="1" <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_ALLREADYTRANSFUSED").equalsIgnoreCase("1")?"selected":""%>><%=getTranNoLink("web","yes",sWebLanguage) %></option>
			                 </select>
			            </td>
			        </tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","reason",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "bloodtransfusion.reason", "ITEM_TYPE_CNTS_BLOODREQUESTREASON", sWebLanguage, true) %>
			            </td>
	        		</tr>
				    <%-- DIAGNOSIS --%>
				    <tr>
				    	<td class="admin" colspan="2">
					      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
				    	</td>
				    </tr>
    			</table>
    		</td>
    		<td width='50%' valign='top'>
			    <table class="list" cellspacing="1" cellpadding="0" width="100%">
    				<tr class='admin'>
    					<td colspan='2'><%=getTran(request,"web","received",sWebLanguage) %></td>
    				</tr>
			         <tr>
			            <td class="admin" width='30%'><%=getTran(request,"web","bloodgroupdonor",sWebLanguage)%></td>
			            <td class="admin2">
			            	 <%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNTS_BLOODGROUPDONOR", "abobloodgroup", sWebLanguage, "") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","numberofbags",sWebLanguage)%></td>
			            <td class="admin2">
			                 <select <%=setRightClick(session,"ITEM_TYPE_CNTS_RECEIVEDNUMBEROFBAGS")%> id="numberofbags" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDNUMBEROFBAGS" property="itemId"/>]>.value" class="text">
			                     <option/>
			                     <option value="0" <%=rcn.equalsIgnoreCase("0")?"selected":""%>>0</option>
			                     <option value="1" <%=rcn.equalsIgnoreCase("1")?"selected":""%>>1</option>
			                     <option value="2" <%=rcn.equalsIgnoreCase("2")?"selected":""%>>2</option>
			                     <option value="3" <%=rcn.equalsIgnoreCase("3")?"selected":""%>>3</option>
			                     <option value="4" <%=rcn.equalsIgnoreCase("4")?"selected":""%>>4</option>
			                     <option value="5" <%=rcn.equalsIgnoreCase("5")?"selected":""%>>5</option>
			                 </select>
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","bagnumbers",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BLOODPOCKET_NUMBER1", 8) %>&nbsp;
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BLOODPOCKET_NUMBER2", 8) %>&nbsp;
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BLOODPOCKET_NUMBER3", 8) %>&nbsp;
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BLOODPOCKET_NUMBER4", 8) %>&nbsp;
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BLOODPOCKET_NUMBER5", 8) %>&nbsp;
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","volume",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_RECEIVEDVOLUME")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDVOLUME" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDVOLUME" property="value"/>"> ml
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
			            <td class="admin2">
			                 <%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNTS_SERVICE", "transfusion.department", sWebLanguage, "") %>
			            </td>
			        </tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","complications",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "bloodtransfusion.undesiredeffects", "ITEM_TYPE_BLOODTRANSFUSION_UNDESIREDEFFECTS", sWebLanguage, true) %>
						</td>			            
	        		</tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,10000);" <%=setRightClick(session,"ITEM_TYPE_CNTS_COMMENT")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMMENT" property="value"/></textarea>
			            </td>
			        </tr>
				</table>
    		</td>
    	</tr>
<%-- BUTTONS --%>
        <tr>
            <td class="admin2" colspan='2'>
                <%=getButtonsHtml(request,activeUser,activePatient,"occup.cnts.bloodrequest",sWebLanguage)%>
            </td>
        </tr>
    </table>

    <%=ScreenHelper.contextFooter(request)%>
</form>
<script>
  function submitForm(){
    document.getElementById("buttonsDiv").style.visibility = "hidden";
    var temp = Form.findFirstElement(transactionForm);//for ff compatibility
    document.transactionForm.submit();
  }
</script>
<%=writeJSButtons("transactionForm","saveButton")%>