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
			            <td class="admin"><%=getTran(request,"web","bloodgroupreceiver",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_BLOODGROUPRECEIVER")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODGROUPRECEIVER" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODGROUPRECEIVER" property="value"/>">
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
			                     <option value="6" <%=rn.equalsIgnoreCase("6")?"selected":""%>>6</option>
			                     <option value="7" <%=rn.equalsIgnoreCase("7")?"selected":""%>>7</option>
			                     <option value="8" <%=rn.equalsIgnoreCase("8")?"selected":""%>>8</option>
			                     <option value="9" <%=rn.equalsIgnoreCase("9")?"selected":""%>>9</option>
			                     <option value="10" <%=rn.equalsIgnoreCase("10")?"selected":""%>>10</option>
			                 </select>
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","volume",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_REQUESTEDVOLUME")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDVOLUME" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_REQUESTEDVOLUME" property="value"/>">ml
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","producttype",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_PRODUCTTYPE")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_PRODUCTTYPE" property="itemId"/>]>.value" class="text" size="40" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_PRODUCTTYPE" property="value"/>">
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
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODREQUESTREASON" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"cnts.bloodrequestreason",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODREQUESTREASON"),sWebLanguage,false,true) %>
			                </select>
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
			            <td class="admin"><%=getTran(request,"web","bloodgroupdonor",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_BLOODGROUPDONOR")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODGROUPDONOR" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BLOODGROUPDONOR" property="value"/>">
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
			                     <option value="6" <%=rcn.equalsIgnoreCase("6")?"selected":""%>>6</option>
			                     <option value="7" <%=rcn.equalsIgnoreCase("7")?"selected":""%>>7</option>
			                     <option value="8" <%=rcn.equalsIgnoreCase("8")?"selected":""%>>8</option>
			                     <option value="9" <%=rcn.equalsIgnoreCase("9")?"selected":""%>>9</option>
			                     <option value="10" <%=rcn.equalsIgnoreCase("10")?"selected":""%>>10</option>
			                 </select>
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","bagnumbers",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_BAGNUMBERS")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BAGNUMBERS" property="itemId"/>]>.value" class="text" size="40" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_BAGNUMBERS" property="value"/>">
			            </td>
			        </tr>
			         <tr>
			            <td class="admin"><%=getTran(request,"web","volume",sWebLanguage)%></td>
			            <td class="admin2">
			                 <input <%=setRightClick(session,"ITEM_TYPE_CNTS_RECEIVEDVOLUME")%> type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDVOLUME" property="itemId"/>]>.value" class="text" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEIVEDVOLUME" property="value"/>">ml
			            </td>
			        </tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","complications",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_CHILLS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_CHILLS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","chills",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_FEVER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_FEVER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","fever",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_PAIN" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_PAIN;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"cnts","pain",sWebLanguage) %>&nbsp;			            
							<BR/>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DYSPNOE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DYSPNOE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","dyspnoe",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_NAUSEA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_NAUSEA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","nausea",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_VOMITING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_VOMITING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","vomiting",sWebLanguage) %>&nbsp;			            
							<BR/>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_FAINTING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_FAINTING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","fainting",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_CONVULSIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_CONVULSIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","convulsions",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_URTICARIA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_URTICARIA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","urticaria",sWebLanguage) %>&nbsp;			            
							<BR/>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_TRANSFUSIONACCIDENT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_TRANSFUSIONACCIDENT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","dead_transfusion_accident",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_DURINGTRANSFUSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_DURINGTRANSFUSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","dead_during_transfusion",sWebLanguage) %>&nbsp;			            
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_NOTENOUGHBLOOD" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_COMPLICATION_DEAD_NOTENOUGHBLOOD;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","dead_not_enough_blood",sWebLanguage) %>&nbsp;			            
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