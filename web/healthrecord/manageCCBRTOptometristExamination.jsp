<%@page import="be.openclinic.medical.Problem, java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"occupophtalmology","select",activeUser)%>

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
	    
	    <%-- 0 - physician --%>
	    <tr>
	        <td class="admin"><%=getTran(request,"web","cdo.physician",sWebLanguage)%>&nbsp;*&nbsp;</td>
	        <td class="admin2" nowrap colspan="5">
	            <select id='physician' class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PHYSICIAN" property="itemId"/>]>.value" >
	                <option></option>
	                <%=ScreenHelper.writeSelectUpperCase("optometrist.physician",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PHYSICIAN"),sWebLanguage,false,true)%>
	            </select>
	        </td>
	    </tr>
		
		<%-- 1 - History bloc --%>
	    <tr>
        	<td width="100%" colspan="6">
		      	<table width='100%' cellpadding='0' cellspacing='1'>
	        		<tr class='admin'>
			            <td colspan='13'><%=getTran(request,"web","history",sWebLanguage)%>&nbsp;</td>
	        		</tr>
					<%-- 1 - title of complaints --%>
					<tr>
	        			<td class='admin' width='9%'/>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","location",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","location",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","location",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","complaint",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","Duration",sWebLanguage) %></td>
	        			<td class='admin' width='9%'><%=getTran(request,"eye.metrics","location",sWebLanguage) %></td>
	        		</tr>
				<%-- 1 -  complaints(label) --%>
					<tr>
						<td class="admin" rowspan="6"><%=getTran(request,"web","actual.complaints",sWebLanguage)%>&nbsp;*&nbsp;</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1;value=true"
	                                        property="value"
	                                        outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "1", sWebLanguage, "actions_1")%>
						</td>
						<td class="admin">
							<select id="select_1" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_1b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_1_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_7" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "7", sWebLanguage, "actions_7")%>
						</td>
						<td class="admin">
							<select id="select_7" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7_DURATION"),sWebLanguage,false,true) %>
							</select>

						</td>
						<td class="admin2">
						<select id="select_7b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_7_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_13" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "13", sWebLanguage, "actions_13")%>
						</td>
						<td class="admin">
							<select id="select_13" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_13b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_13_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_19" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "19", sWebLanguage, "actions_19")%>
						</td>
						<td class="admin">
							<select id="select_19" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_19b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_19_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
					</tr>
					<tr>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "2", sWebLanguage, "actions_2")%>
						</td>
						<td class="admin">
							<select id="select_2" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_2b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_2_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_8" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "8", sWebLanguage, "actions_8")%>
						</td>
						<td class="admin">
							<select id="select_8" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_8b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_8_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_14" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "14", sWebLanguage, "actions_14")%>
						</td>
						<td class="admin">
							<select id="select_14" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_14b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_14_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_20" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "20", sWebLanguage, "actions_20")%>
						</td>
						<td class="admin">
							<select id="select_20" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
						<select id="select_20b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20_LOCATION" property="itemId"/>]>.value">
                            <option/>
                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_20_LOCATION"),sWebLanguage,false,true) %>
                        </select>
						</td>
					</tr>
					<tr>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "3", sWebLanguage, "actions_3")%>
						</td>
						<td class="admin">
							<select id="select_3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_3b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_3_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_9" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "9", sWebLanguage, "actions_9")%>
						</td>
						<td class="admin">
							<select id="select_9" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_9b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_9_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "15", sWebLanguage, "actions_15")%>
						</td>
						<td class="admin">
							<select id="select_15" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_15b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_15_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_21" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "21", sWebLanguage, "actions_21")%>
						</td>
						<td class="admin">
							<select id="select_21" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_21b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_21_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
					</tr>
					<tr>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "4", sWebLanguage, "actions_4")%>
						</td>
						<td class="admin">
							<select id="select_4" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_4b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_4_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "10", sWebLanguage, "actions_10")%>
						</td>
						<td class="admin">
							<select id="select_10" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_10b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_10_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_16" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "16", sWebLanguage, "actions_16")%>
						</td>
						<td class="admin">
							<select id="select_16" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_16b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_16_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_22" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "22", sWebLanguage, "actions_22")%>
						</td>
						<td class="admin">
							<select id="select_22" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_22b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_22_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
					</tr>
					<tr>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "5", sWebLanguage, "actions_5")%>
						</td>
						<td class="admin">
							<select id="select_5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_5b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_5_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_11" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "11", sWebLanguage, "actions_11")%>
						</td>
						<td class="admin">
							<select id="select_11" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_11b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_11_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_17" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "17", sWebLanguage, "actions_17")%>
						</td>
						<td class="admin">
							<select id="select_17" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_17b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_17_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_23" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "23", sWebLanguage, "actions_23")%>
						</td>
						<td class="admin">
							<select id="select_23" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_23b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_23_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
					</tr>
					<tr>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "6", sWebLanguage, "actions_6")%>
						</td>
						<td class="admin">
							<select id="select_6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_6b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_6_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_12" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "12", sWebLanguage, "actions_12")%>
						</td>
						<td class="admin">
							<select id="select_12" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_12b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_12_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
							<input type="checkbox" onclick='setSelects();' id="actions_18" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18" property="itemId"/>]>.value" value="true"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
							compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18;value=true"
                                         property="value"
                                         outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.complaint", "18", sWebLanguage, "actions_18")%>
						</td>
						<td class="admin">
							<select id="select_18" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18_DURATION" property="itemId"/>]>.value">
		                	<option/>
			            	<%=ScreenHelper.writeSelect(request,"ccbrt.optometrist.duration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18_DURATION"),sWebLanguage,false,true) %>
							</select>
						</td>
						<td class="admin2">
							<select id="select_18b" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18_LOCATION" property="itemId"/>]>.value">
	                            <option/>
	                            <%=ScreenHelper.writeSelect(request,"ccbrt.ent.location",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINT_18_LOCATION"),sWebLanguage,false,true) %>
	                        </select>
						</td>
						<td class="admin2">
						</td>
						<td class="admin">
						</td>
						<td class="admin2">
						</td>
					</tr>						
					<tr>
						<td class='admin' width='9%'><%=getTran(request,"web", "comment", sWebLanguage)%></td>
						<td class='admin2' colspan="12">
							<textarea <%=setRightClickMini("ITEM_TYPE_OPTOMETRIST_COMPLAINTS_COMMENT")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINTS_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINTS_COMMENT" translate="false" property="value"/></textarea>
						</td>
					</tr>
					<%-- 2 - localisation --%>
					<!-- <tr>
						<td class="admin"><%=getTran(request,"web","localisation",sWebLanguage)%>&nbsp;*&nbsp;</td>
						<td class="admin2" colspan="9" nowrap>
							<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_LOCALISATION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"cdo.2",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_LOCALISATION"),sWebLanguage,false,true) %>
								</select>
							
							<input onKeyup="this.value=this.value.toUpperCase();" type="text" id="localisation_comment" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_LOCALISATION_COMMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_LOCALISATION_COMMENT" translate="false" property="value"/>"/>
						</td>
					</tr> -->
					<%-- 3 - MEDECINES --%>
					<tr>
						<td class="admin"><%=getTran(request,"web","medecine",sWebLanguage)%></td>
						<td class='admin2' colspan="12">
							<textarea <%=setRightClickMini("ITEM_TYPE_OPTOMETRIST_MEDICINES")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_MEDICINES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_MEDICINES" translate="false" property="value"/></textarea>
						</td>
					</tr>
					
					
					<%-- 4 - History --%>
					<tr>
						<td class="admin"><%=getTran(request,"web","history",sWebLanguage)%></td>
						<td class='admin2' colspan="12">
							<textarea <%=setRightClickMini("ITEM_TYPE_OPTOMETRIST_COMPLAINTS_HISTORY")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINTS_HISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINTS_HISTORY" translate="false" property="value"/></textarea>
						</td>
					
					</tr>
	
				</table>
			</td>
		</tr>
		
		
		<%-- VA & TRIAGE BLOC --%>
		<tr>
        	<td width="100%" colspan="11">
				<table width='100%'>
					<tr class='admin'>
					
			            <td colspan='11'><%=getTran(request,"web","ccbrt.va",sWebLanguage)%>&nbsp;</td>
					</tr>
		      	
	        		
					<%-- VA & TRIAGE BLOC (1st ligne VA) --%>
					<tr>
			            <td class="admin"><%=getTran(request,"web","ccbrt.va",sWebLanguage)%></td>
			            <td class="admin"><%=getTran(request,"ccbrt.eye","right",sWebLanguage)%></td>
						
						<td class="admin2" colspan="2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RIGHT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						<td class="admin"><%=getTran(request,"ccbrt.eye","left",sWebLanguage)%></td>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_LEFT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						
						
						<td class="admin"><%=getTran(request,"ccbrt.eye","dil",sWebLanguage)%></td>
						<td class="admin2">
								RE<input onclick='if(this.checked){var date=new Date();document.getElementById("dilrtime").value=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear()+" "+date.getHours()+":"+date.getMinutes();}else{document.getElementById("dilrtime").value="";}'  type="checkbox" id="actions_24" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_RIGHT" property="itemId"/>]>.value" value="true"
								<mxs:propertyAccessorI18N name="transaction.items" scope="page"
								compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_RIGHT;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.dil", "", sWebLanguage, "actions_24")%>
												  
								<input  id="dilrtime" class="text" type="text" size="15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_RIGHT_TIMESTAMP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_RIGHT_TIMESTAMP" property="value"/>"/>	  
									  
								
								
							LE<input onclick='if(this.checked){var date=new Date();document.getElementById("dilLtime").value=date.getDate()+"/"+(date.getMonth()+1)+"/"+date.getFullYear()+" "+date.getHours()+":"+date.getMinutes();}else{document.getElementById("dilLtime").value="";}'   type="checkbox" id="actions_25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_LEFT" property="itemId"/>]>.value" value="true"
								<mxs:propertyAccessorI18N name="transaction.items" scope="page"
								compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_LEFT;value=true"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"ccbrt.optometrist.dil", "", sWebLanguage, "actions_25")%>
										  
						<input id="dilLtime" class="text" type="text" size="15" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_LEFT_TIMESTAMP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_LEFT_TIMESTAMP" property="value"/>"/>	
										  
								
								
						</td>
			        </tr>
					
					<%-- VA & TRIAGE BLOC (2nd ligne VA +gl) --%>
					<tr>
			            <td class="admin"><%=getTran(request,"web","ccbrt.vagl",sWebLanguage)%></td>
			            <td class="admin"><%=getTran(request,"ccbrt.eye","right",sWebLanguage)%></td>
			            <td class="admin2" colspan="2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VAGL_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VAGL_RIGHT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						<td class="admin"><%=getTran(request,"ccbrt.eye","left",sWebLanguage)%></td>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VAGL_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VAGL_LEFT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						<td class="admin"><%=getTran(request,"ccbrt.eye","dm",sWebLanguage)%></td>
						<td class="admin2" colspan="2">
						<input type="radio" onDblClick="uncheckRadio(this);" id="dm1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DM" property="itemId"/>]>.value" value="yes"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DM;value=yes"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "yes", sWebLanguage, "dm1")%>
						<input type="radio" onDblClick="uncheckRadio(this);" id="dm2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DM" property="itemId"/>]>.value" value="no"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DM;value=no"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "no", sWebLanguage, "dm2")%>
						</td>
			        </tr>
					
					<%-- VA & TRIAGE BLOC (3eme ligne VA +gl) --%>
					
					
					<tr>
			            <td class="admin"><%=getTran(request,"web","ccbrt.ph",sWebLanguage)%></td>
			            <td class="admin"><%=getTran(request,"ccbrt.eye","right",sWebLanguage)%></td>
			            <td class="admin2" colspan="2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PH_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PH_RIGHT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						<td class="admin"><%=getTran(request,"ccbrt.eye","left",sWebLanguage)%></td>
			            <td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PH_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_PH_LEFT"),sWebLanguage,false,true) %>
			                </select>
			            </td>
						<td class="admin"><%=getTran(request,"ccbrt.eye","HT",sWebLanguage)%></td>
						<td class="admin2" colspan="2">
						<input type="radio" onDblClick="uncheckRadio(this);" id="ht1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_HT" property="itemId"/>]>.value" value="yes"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_HT;value=yes"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "yes", sWebLanguage, "ht1")%>
						<input type="radio" onDblClick="uncheckRadio(this);" id="ht2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_HT" property="itemId"/>]>.value" value="no"
							<mxs:propertyAccessorI18N name="transaction.items" scope="page"
                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_HT;value=no"
                                          property="value"
                                          outputString="checked"/>><%=getLabel(request,"web", "no", sWebLanguage, "ht2")%>
						</td>
			        </tr>
					<tr>
						<td class="admin"><%=getTran(request,"web","ccbrt.IOP",sWebLanguage)%></td>
				        <td class="admin2" colspan="3">
				        	<input <%=setRightClickMini("iop")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_IOP_VALUE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_IOP_VALUE" property="value"/>"/>mmHg
				        </td>
						<td class="admin"><%=getTran(request,"web","bp",sWebLanguage)%></td>
						<td class='admin2' colspan="4">
						<input <%=setRightClickMini("iop")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_IOP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_IOP" property="value"/>"/>mmHg
						</td>
					</tr>
					
				</table>
			</td>
		</tr>
		
		<%-- REFRACTION BLOC --%>
		<tr>
        	<td width="100%" colspan="11">
				<table width='100%'>
					<tr class='admin'>
					
			            <td colspan='11'><%=getTran(request,"web","refraction",sWebLanguage)%>&nbsp;</td>
					</tr>
				<!-- 	<tr>
									
									<td class="admin"></td>
									<td class="admin" width="1%"></td>
									<td class="admin2" colspan="1"><%=getTran(request,"web","cdo.correction.sph",sWebLanguage)%>
									</td>
									<td class="admin2" colspan="1"><%=getTran(request,"web","cdo.correction.cyl",sWebLanguage)%>
									</td>
									<td class="admin2" colspan="1"><%=getTran(request,"web","cdo.correction.axis",sWebLanguage)%>
									</td>
									<td class="admin" colspan="4" width="60%"></td>
					</tr> -->
					<tr>
						<td class="admin"><%=getTran(request,"web","cdo.correction.previousrx",sWebLanguage)%></td>
						<td colspan='10'>
							<table width='100%'>
								<tr>
									
									<td class="admin" width='10%'></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='10%'><%=getTran(request,"web","cdo.correction.sph",sWebLanguage)%></td>
											<td width='10%'><%=getTran(request,"web","cdo.correction.cyl",sWebLanguage)%></td>
											<td width='*'><%=getTran(request,"web","cdo.correction.axis",sWebLanguage)%></td>
										</table>
									</td>
								</tr>
								<tr>
									<td class="admin"><%=getTran(request,"web","cdo.RE",sWebLanguage)%></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_1" translate="false" property="value"/>"/> =</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_2" translate="false" property="value"/>"/> /</td>
											<td width='*'><input style='text-align: center' onblur="isNumber(this)" type="text" size="3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_3" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_RIGHT_3" translate="false" property="value"/>"/>°</td>
										</table>
									</td>
								</tr>
								<tr>
									<td class="admin">
									<%=getTran(request,"web","cdo.LE",sWebLanguage)%></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_1" translate="false" property="value"/>"/> =</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_2" translate="false" property="value"/>"/> /</td>
											<td width='*'><input style='text-align: center' onblur="isNumber(this)" type="text" size="3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_3" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_LEFT_3" translate="false" property="value"/>"/>°</td>
										</table>
									</td>
								</tr>
								
								<tr>
									<td class="admin" ><%=getTran(request,"web","cdo.ADD",sWebLanguage)%></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='15%'>
												<%=getTran(request,"web","cdo.addplus.L",sWebLanguage)%>
												<input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_ADD_L" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_ADD_L" translate="false" property="value"/>"/>
											</td>
											<td width='*'>
												<%=getTran(request,"web","cdo.addplus.R",sWebLanguage)%>
												<input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_ADD_R" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_WORNCORRECTION_ADD_R" translate="false" property="value"/>">
											</td>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					
					<tr>
						<td class="admin"><%=getTran(request,"web","cdo.refraction.measured",sWebLanguage)%></td>
						<td colspan='10'>
							<table width='100%'>
								<tr>
									<td class="admin" width='10%'><%=getTran(request,"web","cdo.RE",sWebLanguage)%></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_1" translate="false" property="value"/>"/> =</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_2" translate="false" property="value"/>"/> /</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_3" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_RIGHT_3" translate="false" property="value"/>"/>°</td>
											<td width='*'>
												<%=getTran(request,"web","cdo.VA",sWebLanguage)%>
								                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RE" property="itemId"/>]>.value">
								                	<option/>
									            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RE"),sWebLanguage,false,true) %>
								                </select>
											</td>
										</table>
									</td>
								</tr>
								<tr>
									<td class="admin"><%=getTran(request,"web","cdo.LE",sWebLanguage)%></td>
									<td class="admin2" colspan="2">
										<table width='100%'>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_1" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_1" translate="false" property="value"/>"/> =</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_2" translate="false" property="value"/>"/> /</td>
											<td width='10%'><input style='text-align: center' onblur="isNumber(this)" type="text" size="3" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_3" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_LEFT_3" translate="false" property="value"/>"/>°</td>
											<td width='*'>
												<%=getTran(request,"web","cdo.VA",sWebLanguage)%>
								                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RE" property="itemId"/>]>.value">
								                	<option/>
									            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_LE"),sWebLanguage,false,true) %>
								                </select>
											</td>
										</table>
									</td>
								</tr>
								
								<tr>
									<td class="admin" ><%=getTran(request,"web","cdo.ADD",sWebLanguage)%></td>
									<td class="admin2" colspan="11">
										<table width='100%'>
											<td width='15%'>
												<%=getTran(request,"web","cdo.addplus.L",sWebLanguage)%>
												<input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_L" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_L" translate="false" property="value"/>"/>											
											</td>
											<td width='15%'>
												<%=getTran(request,"web","cdo.addplus.R",sWebLanguage)%>
												<input style='text-align: center' onblur="isNumber(this)" type="text" size="5" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_R" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REFRACTION_ADD_R" translate="false" property="value"/>"/>
											</td>
											<td width='*'>
												<%=getTran(request,"web","cdo.VA",sWebLanguage)%>
								                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_ADD" property="itemId"/>]>.value">
								                	<option/>
									            	<%=ScreenHelper.writeSelect(request,"ccbrt.va.lr",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_ADD"),sWebLanguage,false,true) %>
								                </select>
											</td>
										</table>
						            </td>
								</tr>
							</table>
						</td>
					</tr>
					
					
					<tr>
						<td class="admin"><%=getTran(request,"web","pd.distance.recommandation",sWebLanguage)%></td>
						<td class="admin2" colspan="2"><input onblur="isNumber(this)" type="text" size="6" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_RECOMMANDATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_RECOMMANDATION" translate="false" property="value"/>"/>
						
					</tr>
					<tr>
						<td class="admin"><%=getTran(request,"web","remarks",sWebLanguage)%></td>
						<td class='admin2'>
							<textarea <%=setRightClickMini("ITEM_TYPE_OPTOMETRIST_REMARKS")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="80" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REMARKS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_REMARKS" translate="false" property="value"/></textarea>
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
	    <%=getButtonsHtml(request,activeUser,activePatient,"occupophtalmology",sWebLanguage)%>
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
function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }		
  
  function setSelects(){
	  for(n=1;n<24;n++){
		  cb = document.getElementById('actions_'+n);
		  cs = document.getElementById('select_'+n);
		  cs2 = document.getElementById('select_'+n+'b');
		  if(cb && cs){
			  if(cb.checked){
				  cs.disabled='';
				  cs2.disabled='';
			  }
			  else{
				  cs.value='';
				  cs.disabled='disabled';
				  cs2.value='';
				  cs2.disabled='disabled';
			  }
		  }
	  }
  }
  
  setSelects();
  
</script>

<%=writeJSButtons("transactionForm","saveButton")%>