<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"msas.registry.postnatal","select",activeUser)%>

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
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)' onchange='calculateAge();'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <tr>
        	<td width="50%" valign='top'>
	        	<table width='100%'>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","age.mother",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><b><%=activePatient.getAgeOnDate(((TransactionVO)transaction).getUpdateTime()) %></b> <%=getTran(request,"web","years",sWebLanguage).toLowerCase() %></td>
			            <td class='admin'><%=getTran(request,"web","parity",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PARITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PARITY" property="value"/>"/></td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web.msas","deliverydate",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
	                        <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYDATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYDATE" property="value" formatType="date"/>" id="deliverydate" onblur='checkDate(this);' onchange='calculateAge();' onfocus='calculateAge();' onkeyup='calculateAge();'/>
	                        <script>writeMyDate("deliverydate", "<c:url value="/_img/icons/icon_agenda.png"/>", "<%=getTran(null,"Web","PutToday",sWebLanguage)%>");</script>
			            </td>
			            <td class='admin'><%=getTran(request,"web","delivery.location",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYLOCATION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.deliverylocation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYLOCATION"),sWebLanguage,false,true) %>
			                </select>
			            </td>
	        		</tr>
	        		<tr>
			            <td class='admin'><%=getTran(request,"web","delivery.type",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYTYPE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.deliverytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_DELIVERYTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class='admin'><%=getTran(request,"web","cpon.order",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<span id="cponorder" name="cponorder"></span>
			            	<input type="hidden" id="cponorderfield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CPONORDER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CPONORDER" property="value"/>"/>
			            </td>
	        		</tr>
	        		<tr class='admin'>
			            <td colspan='4'><%=getTran(request,"web","child",sWebLanguage)%>&nbsp;</td>
	        		</tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>"/></td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>"/></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","temperature",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_TEMPERATURE" property="value"/>"/>°C</td>
			            <td class='admin'><%=getTran(request,"web","child.status",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_CHILDSTATUS" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.childstatus",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_CHILDSTATUS"),sWebLanguage,false,true) %>
			                </select><br/><br/>
				            <input class="text" type="text" size="25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CHILDSTATUSCOMMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CHILDSTATUSCOMMENT" property="value"/>"/>
			            </td>
			        </tr>
		        	<tr>
			            <td class='admin'><%=getTran(request,"web","umbilicus.status",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_UMBILICUSSTATUS" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.umbilicusstatus",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_UMBILICUSSTATUS"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin"><%=getTran(request,"web","infection.treatment",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input class="text" type="text" size="25" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_INFECTIONTREATMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_INFECTIONTREATMENT" property="value"/>"/></td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"web","bcg",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			            	<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_MSAS_POSTNATAL_BCG", sWebLanguage, sCONTEXTPATH) %>
			            </td>
			            <td class='admin'><%=getTran(request,"web","polio",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			            	<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_MSAS_POSTNATAL_POLIO", sWebLanguage, sCONTEXTPATH) %>
			            </td>
			        </tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"web","hepatitisb",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			            	<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_MSAS_POSTNATAL_HEPATITISB", sWebLanguage, sCONTEXTPATH) %>
			            </td>
			            <td class="admin"><%=getTran(request,"web","milda",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_MILDA" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_MILDA;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_MILDA" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_MILDA;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
			        </tr>
					<tr>
						<td colspan="4">
					      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
						</td>
					</tr>
	            </table>
	        </td>
	        <%-- DIAGNOSES --%>
	    	<td valign="top">
	    		<table width="100%">
	        		<tr class='admin'>
			            <td colspan='4'><%=getTran(request,"web","mother",sWebLanguage)%>&nbsp;</td>
	        		</tr>
			        <tr>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_MOTHERWEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_MOTHERWEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_MOTHERWEIGHT" property="value"/>"/></td>
			            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_MOTHERHEIGHT")%> class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_MOTHERHEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_MOTHERHEIGHT" property="value"/>"/></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","temperature",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERTEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERTEMPERATURE" property="value"/>"/>°C</td>
			            <td class="admin"><%=getTran(request,"web","pulse",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'><input class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERPULSE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERPULSE" property="value"/>"/></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","bloodpressure",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2' colspan="3"> 
			            	<input class="text" type="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERSYSTOLICBP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERSYSTOLICBP" property="value"/>"/>/
			            	<input class="text" type="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERDIASTOLICBP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MOTHERDIASTOLICBP" property="value"/>"/>mmHg
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","generalstatus",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERGENERALSTATUS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERGENERALSTATUS" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","mucosa",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERMUCOSA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERMUCOSA" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","oedema",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHEROEDEMA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHEROEDEMA" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","breasts",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERBREASTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERBREASTS" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","uterus.inversion",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERUTERUSINVERSION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERUTERUSINVERSION" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","tv",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERTV" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERTV" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class='admin'><%=getTran(request,"web","mother.condition",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "msas.mothercondition", "ITEM_TYPE_MSAS_POSTNATAL_MOTHERCONDITION", sWebLanguage, true) %>
			                <br/><%=getTran(request,"web","other",sWebLanguage) %>: <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERCONDITIONCOMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_MOTHERCONDITIONCOMMENT" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","vat",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			            	<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_MOTHERVAT", "msas.vatrank", sWebLanguage, "") %>
			            </td>
			            <td class="admin"><%=getTran(request,"web","iron",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_IRON" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_IRON;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_IRON" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_IRON;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","hivtest",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_HIV" property="itemId"/>]>.value" value="medwan.common.positive"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_HIV;value=medwan.common.positive"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","positive",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_HIV" property="itemId"/>]>.value" value="medwan.common.negative"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_HIV;value=medwan.common.negative"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","negative",sWebLanguage) %></label>
			            </td>
			        </tr>
		        	<tr>
			            <td class='admin'><%=getTran(request,"web","breastfeeding",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_BREASTFEEDING" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.breastfeeding",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_BREASTFEEDING"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class='admin'><%=getTran(request,"web","contraception",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_CONTRACEPTION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.contraception",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_CONTRACEPTION"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","pf.analysis",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFANALYSIS" property="itemId"/>]>.value" value="medwan.common.true"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFANALYSIS;value=medwan.common.true"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","yes",sWebLanguage) %></label>
			                <input type="radio" onDblClick="uncheckRadio(this);" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFANALYSIS" property="itemId"/>]>.value" value="medwan.common.false"
			                <mxs:propertyAccessorI18N name="transaction.items" scope="page"
			                                          compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFANALYSIS;value=medwan.common.false"
			                                          property="value" outputString="checked"/>><label><%=getTran(request,"web","no",sWebLanguage) %></label>
			            </td>
			            <td class='admin'><%=getTran(request,"web","pf.followup",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFFOLLOWUP" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"msas.pf",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_PFFOLLOWUP"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class='admin'><%=getTran(request,"web","method",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_MSAS_POSTNATAL_PFMETHOD", 30) %>
			            </td>
			            <td class="admin"><%=getTran(request,"web","pf.timing",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "msas.pftiming", "ITEM_TYPE_MSAS_POSTNATAL_PFTIMING", sWebLanguage, false, "", "") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "consultation.observations", sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <textarea rows="2" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_OBSERVATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_POSTNATAL_OBSERVATIONS" property="value"/></textarea>
			            </td>
			        </tr>
	    		</table>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"msas.registry.postnatal",sWebLanguage)%>
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

  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
  
  function calculateAge(){
    var trandate = new Date();
    var d1 = document.getElementById('trandate').value.split("/");
    if(d1.length == 3){
        // actual transaction date
        trandate.setDate(d1[0]);
        trandate.setMonth(d1[1] - 1);
        trandate.setFullYear(d1[2]);
        var deldate = new Date();
        var d1 = document.getElementById('deliverydate').value.split("/");
        if(d1.length == 3){
        	deldate.setDate(d1[0]);
        	deldate.setMonth(d1[1] - 1);
        	deldate.setFullYear(d1[2]);
            //Calculate number of days elapsed between last menstruation date and actual transaction date 
            var timeElapsed = trandate.getTime() - deldate.getTime();
            timeElapsed = timeElapsed / (1000 * 3600 * 24);
    		if (!isNaN(timeElapsed) && timeElapsed >= 0 && timeElapsed < 4) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 1 / J1-J3</b>";
    			document.getElementById("cponorderfield").value="CPoN 1 (J1-J3)";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 4 && timeElapsed < 9) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 1 / J4-J8</b>";
    			document.getElementById("cponorderfield").value="CPoN 1 (J4-J8)";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 9 && timeElapsed < 16) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 2 / J9-J15</b>";
    			document.getElementById("cponorderfield").value="CPoN 2 (J9-J15)";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 16 && timeElapsed < 42) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 3 / J16-J41</b>";
    			document.getElementById("cponorderfield").value="CPoN 3 (J16-J41)";
    		}
    		else if (!isNaN(timeElapsed) && timeElapsed >= 42) {
    			document.getElementById("cponorder").innerHTML="<b>CPoN 3 / J42</b>";
    			document.getElementById("cponorderfield").value="CPoN 3 (J42)";
    		}
        }
    }
  }
  
  calculateAge();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>