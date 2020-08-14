<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.vvf6monthsurvey","select",activeUser)%>

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

        <%-- INTRO --%>
       	<tr>
            <td colspan="2"><%=getTran(request,"web","ccbrt.vvfscreening.intro1",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td colspan="2"><%=getTran(request,"web","ccbrt.vvfscreening.intro2",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question1",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea id="question1" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION1")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION1" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION1" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question2",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question2" onchange="evaluateQuestion2()" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION2" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION2"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="question3">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","question3",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION3" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION3"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="question4">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","question4",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION4" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION4"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="question5">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","question5",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION5" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION5"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question6",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION6" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype2",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION6"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question7",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
            	<table width="100%">
            		<tr>
            			<td nowrap>
			                <textarea id="question7" onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION7")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION7" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION7" property="value"/></textarea>
            			</td>
            		</tr>
            		<tr>
            			<td nowrap>
							<input id="question7none" type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION7NONE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION7NONE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"web","none",sWebLanguage) %>			            
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question8",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question8" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION8" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype3",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION8"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question9",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question9" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION9" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype3",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION9"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question10",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question10" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION10" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype3",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION10"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question11",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question11" onchange="evaluateQuestion11()" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION11" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION11"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr id="question12">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","question12",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION12")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION12" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION12" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question13",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question13" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION13" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype3",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION13"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question14",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
            			<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_1" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_1;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"ccbrt.vvf","answer14_1",sWebLanguage) %>			            
            			</td>
            		</tr>
            		<tr>
            			<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_2" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_2;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"ccbrt.vvf","answer14_2",sWebLanguage) %>			            
            			</td>
            		</tr>
            		<tr>
            			<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_3" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_3;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"ccbrt.vvf","answer14_3",sWebLanguage) %>			            
            			</td>
            		</tr>
            		<tr>
            			<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_4" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_4;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"ccbrt.vvf","answer14_4",sWebLanguage) %>			            
            			</td>
            		</tr>
            		<tr>
            			<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_5" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_5;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" onclick="evaluateQuestion7()"/><%=getTran(request,"ccbrt.vvf","answer14_5",sWebLanguage) %>			            
            			</td>
            		</tr>
            		<tr>
            			<td nowrap>
			                <%=getTran(request,"web","other",sWebLanguage) %>: <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_OTHER")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_OTHER" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION14_OTHER" property="value"/></textarea>
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question15",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION15" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION15"),sWebLanguage,false,false) %>
                </select>
                <%=getTran(request,"ccbrt.vvf","question15_2",sWebLanguage)%>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question16",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION16" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype4",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION16"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question17",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION17")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION17" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION17" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","questionB1",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="questionB1" onchange="evaluateQuestionB1()" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB1" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB1"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB11">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB11",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select id="questionB11select" class="text" onchange="evaluateQuestionB11()" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB11" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB11"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB12">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB12",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB12")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB12" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB12" property="value"/></textarea>
            </td>
        </tr>
       	<tr id="questionB13">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB13",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB13")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB13" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB13" property="value"/></textarea>
            </td>
        </tr>
       	<tr id="questionB14">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB14",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select  id="questionB14select" class="text" onchange="evaluateQuestionB14()" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB14" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB14"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB15">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB15",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB15")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB15" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB15" property="value"/></textarea>
            </td>
        </tr>
       	<tr id="questionB16">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB16",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select  id="questionB16select" class="text" onchange="evaluateQuestionB16()" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB16" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB16"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB17">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB17",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select  id="questionB17select" class="text" onchange="evaluateQuestionB17()" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB17" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB17"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB18">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB18",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB18")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB18" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB18" property="value"/></textarea>
            </td>
        </tr>
       	<tr id="questionB19">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB19",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB19" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB19"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr id="questionB20">
            <td class="admin2">&nbsp;<%=getTran(request,"ccbrt.vvf","questionB20",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB20" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype1",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTIONB20"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td colspan="2"><%=getTran(request,"web","ccbrt.vvfscreening.intro3",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr class="admin">
            <td colspan="2"><%=getTran(request,"web","ccbrt.vvfscreening.afterinterviewremarks",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question18",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION18" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION18"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question19",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION19" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION19"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question20",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION20" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION20"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question21",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION21" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION21"),sWebLanguage,false,false) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","question22",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION22")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION22" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVF6MONTHSURVEY_QUESTION22" property="value"/></textarea>
            </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.vvf6monthsurvey",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  function evaluateQuestion7(){
	  if(document.getElementById("question7none").checked){
		  document.getElementById("question7").value="";
		  document.getElementById("question7").style.display="none";
	  }
	  else{
		  document.getElementById("question7").style.display="";
	  }
  }
  function evaluateQuestion2(){
	  if(document.getElementById("question2").value=="2"){
		  document.getElementById("question3").style.display="";
		  document.getElementById("question4").style.display="";
		  document.getElementById("question5").style.display="";
	  }
	  else{
		  document.getElementById("question3").style.display="none";
		  document.getElementById("question4").style.display="none";
		  document.getElementById("question5").style.display="none";
	  }
  }

  function evaluateQuestionB1(){
	  if(document.getElementById("questionB1").value=="1"){
		  document.getElementById("questionB11").style.display="";
		  document.getElementById("questionB12").style.display="";
		  document.getElementById("questionB13").style.display="";
		  document.getElementById("questionB14").style.display="";
		  document.getElementById("questionB15").style.display="";
		  document.getElementById("questionB16").style.display="";
		  document.getElementById("questionB17").style.display="";
		  document.getElementById("questionB18").style.display="";
		  document.getElementById("questionB19").style.display="";
		  document.getElementById("questionB20").style.display="";
		  evaluateQuestionB11();
		  evaluateQuestionB14();
		  evaluateQuestionB16();
		  evaluateQuestionB17();
	  }
	  else{
		  document.getElementById("questionB11").style.display="none";
		  document.getElementById("questionB12").style.display="none";
		  document.getElementById("questionB13").style.display="none";
		  document.getElementById("questionB14").style.display="none";
		  document.getElementById("questionB15").style.display="none";
		  document.getElementById("questionB16").style.display="none";
		  document.getElementById("questionB17").style.display="none";
		  document.getElementById("questionB18").style.display="none";
		  document.getElementById("questionB19").style.display="none";
		  document.getElementById("questionB20").style.display="none";
	  }
  }

  function evaluateQuestionB11(){
	  if(document.getElementById("questionB11select").value=="1"){
		  document.getElementById("questionB12").style.display="";
	  }
	  else{
		  document.getElementById("questionB12").style.display="none";
	  }
  }

  function evaluateQuestionB14(){
	  if(document.getElementById("questionB14select").value=="2"){
		  document.getElementById("questionB15").style.display="";
	  }
	  else{
		  document.getElementById("questionB15").style.display="none";
	  }
  }

  function evaluateQuestionB16(){
	  if(document.getElementById("questionB16select").value=="1"){
		  document.getElementById("questionB17").style.display="";
	  }
	  else{
		  document.getElementById("questionB17").style.display="none";
	  }
  }

  function evaluateQuestionB17(){
	  if(document.getElementById("questionB17select").value=="2"){
		  document.getElementById("questionB18").style.display="";
	  }
	  else{
		  document.getElementById("questionB18").style.display="none";
	  }
  }

  function evaluateQuestion11(){
	  if(document.getElementById("question11").value=="2"){
		  document.getElementById("question12").style.display="";
	  }
	  else{
		  document.getElementById("question12").style.display="none";
	  }
  }

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
	  if(document.getElementById('question13').value.trim().length>0 && document.getElementById('question11').value.trim().length>0 && document.getElementById('question10').value.trim().length>0 && document.getElementById('question9').value.trim().length>0 && document.getElementById('question2').value.trim().length>0 && document.getElementById('question6').value.trim().length>0 && document.getElementById('question8').value.trim().length>0){
	      transactionForm.saveButton.disabled = true;
  		    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
		    %>
  	  }
	  else {
		  alert('<%=getTran(null,"web","somedataismissing",sWebLanguage)%>')
	  }
  }
  evaluateQuestion2();
  evaluateQuestion7();
  evaluateQuestion11();
  evaluateQuestionB1();
  evaluateQuestionB11();
  evaluateQuestionB14();
  evaluateQuestionB16();
  evaluateQuestionB17();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>