<%@page import="be.openclinic.medical.Problem, java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"occup.ccbrt.entexamination","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width="100%" cellspacing="2">
        <%-- DATE --%>
        <tr>
            <td class="admin">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" colspan="5">
                <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur='checkDate(this)'> <script>writeTranDate();</script>
            </td>
        </tr>
        
        <%-- 1 - History bloc --%>
        <tr>
            <td width="100%" colspan="6">
                <table width='100%' cellpadding='0' cellspacing='1'>
                    <tr class='admin'>
                        <td colspan='9'><%=getTran(request,"web","complaints",sWebLanguage)%>&nbsp;</td>
                    </tr>
                     
                    <tr>
                        <td class='admin'></td>
                        <td class="admin2" colspan="3"><%=getTran(request,"web","ear",sWebLanguage)%></td>
                        <td class='admin2' colspan="2"><%=getTran(request,"web","nose",sWebLanguage)%></td>
                        <td class='admin2' colspan="2"><%=getTran(request,"web","throat",sWebLanguage)%></td>
                    </tr>
    
                    <%-- 1 - title of complaints --%>
                    <tr>
                        <td class='admin' width='9%'/>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"ent.metrics","Location",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
                        <td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
                    </tr>
                <%-- 1 -  complaints(label) --%>
                    <tr>
                        <td class="admin" rowspan="11"><%=getTran(request,"web","actual.complaints",sWebLanguage)%>&nbsp;*&nbsp;</td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1;value=true"
                                            property="value"
                                            outputString="checked"/>><%=getLabel(request,"ccbrt.ent.complaint", "1", sWebLanguage, "actions_1")%>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_LOCATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_7" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_7;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ent.complaint", "7", sWebLanguage, "actions_7")%>
                        </td>
                        <td class="admin">
                            <select id="select_7" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_7_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_7_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_18" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_18;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "18", sWebLanguage, "actions_18")%>
                        </td>
                        <td class="admin">
                            <select id="select_18" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_18_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_18_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                       
                    </tr>
                    <tr>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ent.complaint", "2", sWebLanguage, "actions_2")%>
                        </td>
                        <td class="admin">
                            <select id="select_2" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_2_LOCATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_8" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_8;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "8", sWebLanguage, "actions_8")%>
                        </td>
                        <td class="admin">
                            <select id="select_8" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_8_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_8_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_19" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_19;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "19", sWebLanguage, "actions_19")%>
                        </td>
                        <td class="admin">
                            <select id="select_19" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_19_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_19_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "3", sWebLanguage, "actions_3")%>
                        </td>
                        <td class="admin">
                            <select id="select_3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_3_LOCATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_9" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_9;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "9", sWebLanguage, "actions_9")%>
                        </td>
                        <td class="admin">
                            <select id="select_9" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_9_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_9_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_20" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_20;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "20", sWebLanguage, "actions_20")%>
                        </td>
                        <td class="admin">
                            <select id="select_20" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_20_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_20_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                       
                    </tr>
                    <tr>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "4", sWebLanguage, "actions_4")%>
                        </td>
                        <td class="admin">
                            <select id="select_4" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_4_LOCATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_10" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_10;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "10", sWebLanguage, "actions_10")%>
                        </td>
                        <td class="admin">
                            <select id="select_10" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_10_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_10_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_21" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_21;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "21", sWebLanguage, "actions_21")%>
                        </td>
                        <td class="admin">
                            <select id="select_21" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_21_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_21_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        
                    </tr>
                    <tr>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "5", sWebLanguage, "actions_5")%>
                        </td>
                        <td class="admin">
                            <select id="select_5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_5_LOCATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_11" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_11;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "11", sWebLanguage, "actions_11")%>
                        </td>
                        <td class="admin">
                            <select id="select_11" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_11_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_11_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_22" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_22;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "22", sWebLanguage, "actions_22")%>
                        </td>
                        <td class="admin">
                            <select id="select_22" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_22_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_22_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                       
                    </tr>
                    <tr>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_6" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_6;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "6", sWebLanguage, "actions_6")%>
                        </td>
                        <td class="admin">
                            <select id="select_6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_6_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_6_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin">
                            <select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_1_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_12" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_12;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "12", sWebLanguage, "actions_12")%>
                        </td>
                        <td class="admin">
                            <select id="select_12" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_12_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_12_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_23" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_23;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "23", sWebLanguage, "actions_23")%>
                        </td>
                        <td class="admin">
                            <select id="select_23" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_23_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_23_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                        <td class="admin"></td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_13" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_13;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "13", sWebLanguage, "actions_13")%>
                        </td>
                        <td class="admin">
                            <select id="select_13" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_13_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_13_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_24" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_24;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "24", sWebLanguage, "actions_24")%>
                        </td>
                        <td class="admin">
                            <select id="select_24" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_24_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_24_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                        <td class="admin"></td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_14" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_14;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "14", sWebLanguage, "actions_14")%>
                        </td>
                        <td class="admin">
                            <select id="select_14" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_14_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_14_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_25" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_25;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "25", sWebLanguage, "actions_25")%>
                        </td>
                        <td class="admin">
                            <select id="select_25" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_25_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_25_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                        <td class="admin"></td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_15" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_15;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "15", sWebLanguage, "actions_15")%>
                        </td>
                        <td class="admin">
                            <select id="select_15" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_15_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_15_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_26" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_26" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_26;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "26", sWebLanguage, "actions_26")%>
                        </td>
                        <td class="admin">
                            <select id="select_26" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_26_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_26_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                        <td class="admin"></td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_16" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_16;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "16", sWebLanguage, "actions_16")%>
                        </td>
                        <td class="admin">
                            <select id="select_16" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_16_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_16_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                    </tr> 
                    <tr>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                        <td class="admin"></td>
                        <td class="admin2">
                            <input type="checkbox" onclick='setSelects();' id="actions_17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_17" property="itemId"/>]>.value" value="true"
                            <mxs:propertyAccessorI18N name="transaction.items" scope="page"
                            compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_17;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.ENT.complaint", "17", sWebLanguage, "actions_17")%>
                        </td>
                        <td class="admin">
                            <select id="select_17" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_17_DURATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ENT.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINT_17_DURATION"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                        <td class="admin2"></td>
                        <td class="admin"></td>
                    </tr>                        
                    <tr>
                        <td class='admin' width='9%'><%=getTran(request,"web", "remarks", sWebLanguage)%></td>
                        <td class='admin2' colspan="8">
                            <textarea <%=setRightClickMini("ITEM_TYPE_ENT_COMPLAINTS_COMMENT")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINTS_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINTS_COMMENT" translate="false" property="value"/></textarea>
                        </td>
                    </tr>
                
                    <%-- 4 - History --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","history",sWebLanguage)%></td>
                        <td class='admin2' colspan="8">
                            <textarea <%=setRightClickMini("ITEM_TYPE_ENT_COMPLAINTS_HISTORY")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINTS_HISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ENT_COMPLAINTS_HISTORY" translate="false" property="value"/></textarea>
                        </td>
                    
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"ccbrt.eye","from",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" colspan="7">
                            <select id="from" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_FROM" property="itemId"/>]>.value">
                                <option/>
                                <%=ScreenHelper.writeSelect(request,"ccbrt.eye.from",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_FROM"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin">
                            <%=getTran(request,"ccbrt.eye","attendencytype",sWebLanguage)%>
                        </td>
                        <td class="admin2" colspan="7">
                            <select id="attendencytype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_ATTENDENCYTYPE" property="itemId"/>]>.value">
                                <option/>
                                <%=ScreenHelper.writeSelect(request,"ccbrt.attendencytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_ATTENDENCYTYPE"),sWebLanguage,false,true) %>
                            </select>
                        </td>
                    </tr>
                   
                    <tr>
                        <td class="admin"><%=getTran(request,"ccbrt.va","examiner",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" colspan="7">
                            <%
                                ItemVO item = ((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_USER");
                                String userid="";
                                if(item!=null){
                                    userid=item.getValue();
                                }
                                
                            %>
                            <input type="hidden" id="ccbrtuser" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_USER" property="itemId"/>]>.value"/>
                            <input type="hidden" name="diagnosisUser" id="diagnosisUser" value="<%=userid%>">
                            <input class="text" type="text" name="diagnosisUserName" id="diagnosisUserName" readonly size="40" value="<%=User.getFullUserName(userid)%>">
                            <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('diagnosisUser','diagnosisUserName');">
                            <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('diagnosisUser').value='';document.getElementById('diagnosisUserName').value='';">
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"ccbrt.va","followup",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" colspan="5">
                            <select class='text' id='frequency' onchange='calculateNextDate()'>
                                <option/>
                                <option value='1'>1</option>
                                <option value='2'>2</option>
                                <option value='3'>3</option>
                                <option value='4'>4</option>
                                <option value='5'>5</option>
                                <option value='6'>6</option>
                                <option value='7'>7</option>
                                <option value='8'>8</option>
                                <option value='9'>9</option>
                                <option value='10'>10</option>
                                <option value='11'>11</option>
                                <option value='12'>12</option>
                            </select>
                            <select class='text' id='frequencytype' onchange='calculateNextDate()'>
                                <option/>
                                <option value='week'><%=getTran(request,"web","weeks",sWebLanguage) %></option>
                                <option value='month'><%=getTran(request,"web","months",sWebLanguage) %></option>
                                <option value='year'><%=getTran(request,"web","year",sWebLanguage) %></option>
                            </select>
                            <input type="hidden" id="ccbrtdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_FOLLOWUPDATE" property="itemId"/>]>.value"/>
                            <%=(ScreenHelper.writeDateField("vafollowupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_ENT_FOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
                        </td>
                        <td class="admin2" colspan="2">
                            <a href="javascript:openPopup('planning/findPlanning.jsp&isPopup=1&FindDate='+document.getElementById('vafollowupdate').value+'&FindUserUID='+document.getElementById('diagnosisUser').value,1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        
                </table>
            </td>
        </tr>
        
        <tr>
        <%-- DIAGNOSES --%>
            <td class="admin2" colspan='10'>
                <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
            </td>
        </tr>
    </table>
        
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
        <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.entexamination",sWebLanguage)%>
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
   function searchUser(managerUidField,managerNameField){
      openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
    alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
    searchEncounter();
  }     
  
  function setSelects(){
      for(n=1;n<27;n++){
          cb = document.getElementById('actions_'+n);
          cs = document.getElementById('select_'+n);
          if(cb && cs){
              if(cb.checked){
                  cs.disabled='';
              }
              else{
                  cs.value='';
                  cs.disabled='disabled';
              }
          }
      }
  }
  
  setSelects();
  
</script>

<%=writeJSButtons("transactionForm","saveButton")%>