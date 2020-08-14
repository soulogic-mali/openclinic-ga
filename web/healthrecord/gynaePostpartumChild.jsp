<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"occup.postpartumchild","select",activeUser)%>

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
			            <td class="admin2" colspan="3">
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2" rowspan="2"><%=getTran(request,"web","sepsisriskassessment",sWebLanguage)%></td>
			            <td class="admin2">
			                <input id='risk1' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK1")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK1" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK1;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk1",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input id='risk2' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK2")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK2" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK2;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk2",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input id='risk3' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK3")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK3" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK3;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk3",sWebLanguage)%>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin2">
			                <input id='risk4' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK4")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK4" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK4;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk4",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input id='risk5' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK5")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK5" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK5;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk5",sWebLanguage)%>
			            </td>
			            <td class="admin2">
			                <input id='risk6' onclick='calculateRisks();' <%=setRightClick(session,"ITEM_TYPE_PPC_SEPSISRISK6")%> type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK6" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SEPSISRISK6;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ppc","sepsisrisk6",sWebLanguage)%>
			            </td>
			        </tr>
			        <tr id='riskmessage' style='display: none'>
			            <td class="admin" colspan="2"/>
			        	<td colspan="3" class="admin2"><center><span style='color: red; font-size: 14px;font-weight: bolder'><%=getTran(request,"web","considerstartingantibiotics",sWebLanguage)%></span></center></td>
			        </tr>
			
			        <%-- weight / temperature --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","weight",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_CHILD_WEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_WEIGHT" property="value"/>" onblur="isNumber(this)"> g&nbsp;&nbsp;&nbsp;
			            </td>
			            <td class="admin"><%=getTran(request,"web","height",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_HEIGHT")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEIGHT" property="value"/>" onblur="isNumber(this)"> cm
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","headcircumference",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_CHILD_HEADCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_HEADCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_HEADCIRCUMFERENCE" property="value"/>" onblur="isNumber(this)"> cm&nbsp;&nbsp;&nbsp;
			            </td>
			            <td class="admin"><%=getTran(request,"web","temperature",sWebLanguage)%></td>
			            <td class="admin2">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_TEMPERATURE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_TEMPERATURE" property="value"/>" onblur="isNumber(this)"> °C
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","fontanelle",sWebLanguage)%></td>
			            <td class="admin2">
            				<select class='text' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_FONTANELLE" property="itemId"/>]>.value">
            					<option/>
            					<%=ScreenHelper.writeSelect(request, "ppc.fontanelle", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHILD_FONTANELLE"), sWebLanguage) %>
            				</select>
			            </td>
			            <td class="admin"><%=getTran(request,"web","reflexes",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_REFLEXES")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REFLEXES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REFLEXES" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin"><%=getTran(request,"web","limbs",sWebLanguage)%></td>
			            <td class="admin"><%=getTran(request,"web","upper",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_UPPERLIMBS")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_UPPERLIMBS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_UPPERLIMBS" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","lower",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_LOWERLIMBS")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_LOWERLIMBS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_LOWERLIMBS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","chest",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_CHEST")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHEST" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CHEST" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","genitalia",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_GENITALIA")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_GENITALIA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_GENITALIA" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"ppc","back",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_BACK")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_BACK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_BACK" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","oral",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_ORAL")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ORAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ORAL" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","skin",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_SKIN")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SKIN" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_SKIN" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","heartandlungs",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_HEART")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEART" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEART" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","head",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_HEAD")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEAD" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_HEAD" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","ears",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_EARS")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_EARS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_EARS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","eyes",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_EYES")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_EYES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_EYES" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","stool.urine",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_STOOL")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_STOOL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_STOOL" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"web","immunization",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_IMMUNIZATION")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_IMMUNIZATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_IMMUNIZATION" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"web","arvprophylaxis",sWebLanguage)%></td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_ARV")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ARV" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ARV" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- umbilicus --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","umbilicus",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_UMBILICUS")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_UMBILICUS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_UMBILICUS" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- paleness.conjunctiva --%>
			        <tr>
			            <td class="admin"  colspan="2"><%=getTran(request,"openclinic.chuk","paleness.conjunctiva",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_CONJUNCTIVA")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CONJUNCTIVA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_CONJUNCTIVA" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- observation --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","observation",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_OBSERVATION")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_OBSERVATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_OBSERVATION" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- treatment --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"openclinic.chuk","treatment",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PPC_TREATMENT")%> class="text" cols="50" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_TREATMENT" property="value"/></textarea>
			            </td>
			        </tr>
			
			        <%-- alimentation --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"gynaeco","alimentation",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_ALIMENTATION_MATERNELLE")%> type="checkbox" id="cbmaternelle" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ALIMENTATION_MATERNELLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ALIMENTATION_MATERNELLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"gynaeco.alimentation","maternelle",sWebLanguage,"cbmaternelle")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_ALIMENTATION_ARTIFICIELLE")%> type="checkbox" id="cbartificielle" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ALIMENTATION_ARTIFICIELLE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ALIMENTATION_ARTIFICIELLE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"gynaeco.alimenation","artificielle",sWebLanguage,"cbartificielle")%>
			                <br/>
			                <%=getTran(request,"gynaeco","regurgitation",sWebLanguage)%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_REGURGITATION")%> type="radio" onDblClick="uncheckRadio(this);" id="regu_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REGURGITATION" property="itemId"/>]>.value" value="medwan.common.yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REGURGITATION;value=medwan.common.yes" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.yes",sWebLanguage,"regu_r1")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_REGURGITATION")%> type="radio" onDblClick="uncheckRadio(this);" id="regu_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REGURGITATION" property="itemId"/>]>.value" value="medwan.common.no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_REGURGITATION;value=medwan.common.no" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.no",sWebLanguage,"regu_r2")%>
			            </td>
			        </tr>
			
			        <%-- ictere --%>
			        <tr>
			            <td class="admin" colspan="2"><%=getTran(request,"gynaeco","ictere",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_ICTERE")%> type="radio" onDblClick="uncheckRadio(this);" id="ictere_r1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ICTERE" property="itemId"/>]>.value" value="medwan.common.yes" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ICTERE;value=medwan.common.yes" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.yes",sWebLanguage,"ictere_r1")%>
			                <input <%=setRightClick(session,"ITEM_TYPE_PPC_ICTERE")%> type="radio" onDblClick="uncheckRadio(this);" id="ictere_r2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ICTERE" property="itemId"/>]>.value" value="medwan.common.no" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PPC_ICTERE;value=medwan.common.no" property="value" outputString="checked"/>><%=getLabel(request,"web.occup","medwan.common.no",sWebLanguage,"ictere_r2")%>
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
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.postpartumchild",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function calculateRisks(){
	  var count=0;
	  for(n=1;n<7 && count<2;n++){
		  id='risk'+n;
		  if(document.getElementById(id) && document.getElementById(id).checked){
			  count++;
		  }
	  }
	  if(count>1){
		  document.getElementById('riskmessage').style.display='';
	  }
	  else{
		  document.getElementById('riskmessage').style.display='none';
	  }
  }
  
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
  
  calculateRisks();
</script>

<%=writeJSButtons("transactionForm","saveButton")%>