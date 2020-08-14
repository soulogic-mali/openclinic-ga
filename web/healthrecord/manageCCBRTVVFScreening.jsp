<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.vvfscreening","select",activeUser)%>

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
            <td class="admin"><%=getTran(request,"ccbrt.vvf","ambassadorname",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_AMBASSADORNAME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_AMBASSADORNAME" property="value"/>">
            </td>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","ambassadorphone",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_AMBASSADORPHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_AMBASSADORPHONE" property="value"/>">
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion1",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2">
                <select id="question1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION1" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION1"),sWebLanguage,false,true) %>
                </select>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion2",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION2" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION2"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","personalfollowupphone",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_PERSONALFOLLOWUPPHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_PERSONALFOLLOWUPPHONE" property="value"/>">
            </td>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","husbandfollowupphone",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_HUSBANDFOLLOWUPPHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_HUSBANDFOLLOWUPPHONE" property="value"/>">
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","neighbourfollowupphone",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_NEIGHBOURFOLLOWUPPHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_NEIGHBOURFOLLOWUPPHONE" property="value"/>">
            </td>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","friendfollowupphone",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_FRIENDFOLLOWUPPHONE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_FRIENDFOLLOWUPPHONE" property="value"/>">
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion3",sWebLanguage)%> <img height="12" src='<c:url value="_img/icons/icon_warning.gif"/>' title='<%=getTran(request,"web","ismandatory",sWebLanguage)%>'/>&nbsp;</td>
            <td class="admin2" colspan="3">
                <select id="question3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION3" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype6",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION3"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
       	<tr>
            <td colspan="4"><%=getTran(request,"web","ccbrt.vvfscreening.intro5",sWebLanguage)%>&nbsp;</td>
        </tr>
        <tr>
        	<td colspan="4">
        		<table width="100%">
        			<tr>
        				<td/>
        				<td class='admin'><%=getTran(request,"web","doesntaffectme",sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web","sometimesaffectsme",sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web","oftenaffectsme",sWebLanguage) %></td>
        				<td class='admin'><%=getTran(request,"web","affectsmeallthetime",sWebLanguage) %></td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","feelingwet",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX1;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","painfulskin",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX2;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","otherpain",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX3;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","smellingbad",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX4;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","traumatisedfromdelivery",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX5;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","babyalive",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0;value=1"
			                                          property="value" outputString="checked"/>><%=getTran(request,"web","no",sWebLanguage) %>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0;value=2"
			                                          property="value" outputString="checked"/>><%=getTran(request,"web","yes",sWebLanguage) %>
			            </td>
        				<td	class="admin2" colspan="2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6.0;value=3"
			                                          property="value" outputString="checked"/>><%=getTran(request,"web","yesdiedbefore7days",sWebLanguage) %>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","losingbaby",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX6;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","nocommunityparticipation",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX7;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","isolatedfromfamily",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX8;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","isolatedfromhusband",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX9;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","isolatedfromcommunity",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX10;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","lackingselftrust",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX11;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","notbeingabletowork",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX12;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","feelingdepressed",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX13;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","feelinguseless",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX14;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
        			<tr>
        				<td class="admin"><%=getTran(request,"web","unkindness",sWebLanguage) %></td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15" property="itemId"/>]>.value" value="1"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15;value=1"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15" property="itemId"/>]>.value" value="2"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15;value=2"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15" property="itemId"/>]>.value" value="3"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15;value=3"
			                                          property="value" outputString="checked"/>>
			            </td>
        				<td	class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15" property="itemId"/>]>.value" value="4"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15;value=4"
			                                          property="value" outputString="checked"/>>
			            </td>
        			</tr>
         			<tr>
        				<td class="admin"><%=getTran(request,"web","unkindnessbywhom",sWebLanguage) %></td>
        				<td	class="admin2" colspan="5">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15_BYWHOM")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15_BYWHOM" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_MATRIX15_BYWHOM" property="value"/></textarea>
			            </td>
        			</tr>
        		</table>
        	</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion4",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="3">
                 <textarea onKeyup="resizeTextarea(this,10);limitChars(this,512);" <%=setRightClick(session,"ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION4")%> class="text" cols='80' rows='2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION4" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION4" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion5",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION5" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION5"),sWebLanguage,false,true) %>
                </select>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt.vvf","screeningquestion6",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION6" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.questiontype5",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_VVFSCREENING_QUESTION6"),sWebLanguage,false,true) %>
                </select>
            </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.vvfscreening",sWebLanguage)%>
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
	  if(document.getElementById('question1').value.trim().length>0 && document.getElementById('question3').value.trim().length>0){
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
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>