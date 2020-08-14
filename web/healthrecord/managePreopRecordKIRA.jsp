<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.kirapreop","select",activeUser)%>

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
  
  	<script>
	    <%-- VALIDATE WEIGHT --%>
	    <%
	        int minWeight = 0;
	        int maxWeight = 500;
	
	        String weightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight.validationerror",sWebLanguage);
	        weightMsg = weightMsg.replaceAll("#min#",minWeight+"");
	        weightMsg = weightMsg.replaceAll("#max#",maxWeight+"");
	    %>
	    function validateWeight(weightInput){
	      isNumber(weightInput);
	      weightInput.value = weightInput.value.replace(",",".");
	      if(weightInput.value.length > 0){
	        var min = <%=minWeight%>;
	        var max = <%=maxWeight%>;
	
	        if(isNaN(weightInput.value) || weightInput.value < min || weightInput.value > max){
	          alertDialogDirectText("<%=weightMsg%>");
	        }
	      }
	    }
	
	    <%-- VALIDATE HEIGHT --%>
	    <%
	        int minHeight = 0;
	        int maxHeight = 300;
	
	        String heightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.height.validationerror",sWebLanguage);
	        heightMsg = heightMsg.replaceAll("#min#",minHeight+"");
	        heightMsg = heightMsg.replaceAll("#max#",maxHeight+"");
	    %>
	    function validateHeight(heightInput){
	      isNumber(heightInput);
	      heightInput.value = heightInput.value.replace(",",".");
	      if(heightInput.value.length > 0){
	        var min = <%=minHeight%>;
	        var max = <%=maxHeight%>;
	
	        if(isNaN(heightInput.value) || heightInput.value < min || heightInput.value > max){
	      	alertDialogDirectText("<%=heightMsg%>");
	        }
	      }
	    }
	
	    <%-- CALCULATE BMI --%>
	    function calculateBMI(){
	      var _BMI = 0;
	      var heightInput = document.getElementById('height');
	      var weightInput = document.getElementById('weight');
	
	      if(heightInput.value > 0){
	        _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
	        if (_BMI > 100 || _BMI < 5){
	          document.getElementsByName('BMI')[0].value = "";
	        }
	        else {
	          document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	        }
	      }
	    }
  	</script>
  	
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" colspan="2" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" colspan="8">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="2"><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="validateWeight(this);calculateBMI();"/></td>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="2"><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="validateHeight(this);calculateBMI();"/></td>
            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="3"><input tabindex="-1" class="text" type="text" size="10" readonly name="BMI"></td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","anesthesia.indication",sWebLanguage)%></td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_INDICATION_EMERGENCY")%> type="checkbox" id="cbindicationemergency" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_EMERGENCY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_EMERGENCY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","emergency",sWebLanguage,"cbindicationemergency")%>
			</td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_INDICATION_PROGRAMMED")%> type="checkbox" id="cbindicationprogrammed" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_PROGRAMMED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_PROGRAMMED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","programmed",sWebLanguage,"cbindicationprogrammed")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_INDICATION_AMBULANT")%> type="checkbox" id="cbindicationambulant" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_AMBULANT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_AMBULANT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","ambulant",sWebLanguage,"cbindicationambulant")%>
            </td>
            <td class="admin2" colspan="6">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_INDICATION_FULLSTOMAC")%> type="checkbox" id="cbindicationfullstomac" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_FULLSTOMAC" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INDICATION_FULLSTOMAC;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","fullstomac",sWebLanguage,"cbindicationefullstomac")%>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","history.medical",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_HISTORY_MEDICAL")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_MEDICAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_MEDICAL" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","history.surgical",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_HISTORY_SURGICAL")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_SURGICAL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_SURGICAL" property="value"/></textarea>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","history.go",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_HISTORY_GO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_GO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_GO" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","history.family",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_HISTORY_FAMILY")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_FAMILY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_FAMILY" property="value"/></textarea>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","history.anesthesia",sWebLanguage)%></td>
            <td class="admin2" colspan="9">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_HISTORY_ANESTHESIA")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_ANESTHESIA" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HISTORY_ANESTHESIA" property="value"/></textarea>
            </td>
        </tr>
        <tr class='admin'>
            <td colspan="10"><%=getTran(request,"openclinic.chuk","lifestyle",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","alcohol",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="2"><input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_ALCOHOL")%> id="alcohol" class="text" type="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ALCOHOL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ALCOHOL" property="value"/>"/></td>
        	<td class='admin'><%=getTran(request,"Web.Occup","tobacco",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="2"><input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_TOBACCO")%> id="tobacco" class="text" type="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TOBACCO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TOBACCO" property="value"/>"/></td>
        	<td class='admin'><%=getTran(request,"Web.Occup","drugs",sWebLanguage)%>&nbsp;</td>
            <td class='admin2' colspan="3"><input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_DRUGS")%> id="drugs" class="text" type="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DRUGS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DRUGS" property="value"/>"/></td>
        </tr>
        <tr>
            <td colspan="10"><hr/></td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","treatment",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TREATMENT")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TREATMENT" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","allergy",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_ALLERGY")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ALLERGY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ALLERGY" property="value"/></textarea>
            </td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","bloodgroup",sWebLanguage)%>&nbsp;</td>
            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_ABO")%> id="abo" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ABO" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ABO" property="value"/>"/></td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_ACCEPTSTRANSUSION")%> type="checkbox" id="cbacceptstransfusion" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ACCEPTSTRANSUSION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ACCEPTSTRANSUSION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","acceptstransfusion",sWebLanguage,"cbacceptstransfusion")%>
			</td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_BLOODREQUEST")%> type="checkbox" id="cbbloodrequest" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BLOODREQUEST" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BLOODREQUEST;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","bloodrequest",sWebLanguage,"cbbloodrequest")%>
			</td>
        	<td class='admin2' colspan='2'><%=getTran(request,"Web.Occup","totalblood",sWebLanguage)%>&nbsp;<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_TOTALBLOOD")%> id="totalblood" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TOTALBLOOD" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TOTALBLOOD" property="value"/>"/></td>
        	<td class='admin2' colspan='2'><%=getTran(request,"Web.Occup","cg",sWebLanguage)%>&nbsp;<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_CG")%> id="cg" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CG" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CG" property="value"/>"/></td>
        	<td class='admin2' colspan='2'><%=getTran(request,"Web.Occup","quantity",sWebLanguage)%>&nbsp;<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_BLOODQUANTITY")%> id="bloodquantity" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BLOODQUANTITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BLOODQUANTITY" property="value"/>"/></td>
        </tr>
        <tr class='admin'>
            <td colspan="10"><%=getTran(request,"openclinic.chuk","parameters",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","fc",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_HF")%> id="hf" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HF" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_HF" property="value"/>"/>
        		<%=getTran(request,"Web.Occup","bpm",sWebLanguage)%>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","fr",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_RF")%> id="rf" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_RF" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_RF" property="value"/>"/>
        		<%=getTran(request,"Web.Occup","cpm",sWebLanguage)%>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","ta",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_BP")%> id="bp" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BP" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_BP" property="value"/>"/>
        		<%=getTran(request,"Web.Occup","mmHg",sWebLanguage)%>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","temp",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_TEMPERATURE")%> id="temp" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TEMPERATURE" property="value"/>"/>
        		<%=getTran(request,"Web.Occup","degreescelsius",sWebLanguage)%>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","spo2",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_SPO2")%> id="spo2" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_SPO2" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_SPO2" property="value"/>"/>
        	</td>
        </tr>
        <tr class='admin'>
            <td colspan="10"><%=getTran(request,"openclinic.chuk","clinicalexamination",sWebLanguage)%></td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","cardiovascular",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_CARDIO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_CARDIO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_CARDIO" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","pulmonary",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_PNEUMO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_PNEUMO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_PNEUMO" property="value"/></textarea>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","digestive",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_DIGESTIVE")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_DIGESTIVE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_DIGESTIVE" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","neurologic",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_NEURO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_NEURO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_NEURO" property="value"/></textarea>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","endocrinology",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_ENDOCRINO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_ENDOCRINO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_ENDOCRINO" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"openclinic.chuk","urologic",sWebLanguage)%></td>
            <td class="admin2" colspan="4">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EC_URO")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_URO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EC_URO" property="value"/></textarea>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"openclinic.chuk","orl",sWebLanguage)%></td>
            <td class="admin2" colspan="9">
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_ORL")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ORL" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ORL" property="value"/></textarea>
            </td>
        </tr>
        <tr><td colspan='10'><hr/></td></tr>
        <tr>
        	<td class='admin'><%=getLabel(request,"openclinic.chuk","openclinic.anesthesia.mallampati",sWebLanguage,"class r1")%></td>
        	<td class='admin2'>
                <select <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_CLASS_MALLAMPATI")%> class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_MALLAMPATI" property="itemId"/>]>.value" class="text">
                	<option/>
                	<%=ScreenHelper.writeSelect(request, "mallampati", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_MALLAMPATI"), sWebLanguage) %>
                </select>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","dtm",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_DTM")%> id="temp" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DTM" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DTM" property="value"/>"/>
        		<%=getTran(request,"Web.Occup","mm",sWebLanguage)%>
        	</td>
        	<td class='admin2' colspan='2'>
        		<%=getTran(request,"Web.Occup","dentition",sWebLanguage)%>&nbsp;
        		<input <%=setRightClickMini("ITEM_TYPE_ANESTHESIA_DENTITION")%> id="temp" class="text" type="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DENTITION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_DENTITION" property="value"/>"/>
        	</td>
            <td class="admin2" colspan="4">
            	<%=getLabel(request,"openclinic.chuk","openclinic.anesthesia.asa",sWebLanguage,"class r1")%>																										      			
                <select <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_CLASS_ASA")%> class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_ASA" property="itemId"/>]>.value" class="text">
                	<option/>
                	<%=ScreenHelper.writeSelect(request, "asa", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_ASA"), sWebLanguage) %>
                </select>
        		<%=getTran(request,"Web.Occup","comment",sWebLanguage)%>&nbsp;
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_COMMENT")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_COMMENT" property="value"/></textarea>
            </td>
        </tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","thromborisk",sWebLanguage)%></td>
        	<td class='admin2' colspan='3'>
                <select <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_CLASS_THROMBORISK")%> class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_THROMBORISK" property="itemId"/>]>.value" class="text">
                	<option/>
                	<%=ScreenHelper.writeSelect(request, "thromborisk", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_THROMBORISK"), sWebLanguage) %>
                </select>
        		<%=getTran(request,"Web.Occup","comment",sWebLanguage)%>&nbsp;
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_THROMBOCOMMENT")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_THROMBOCOMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_THROMBOCOMMENT" property="value"/></textarea>
            </td>
        	<td class='admin'><%=getTran(request,"Web.Occup","apfelscore",sWebLanguage)%></td>
        	<td class='admin2'>
                <select <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_CLASS_APFEL")%> class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_APFEL" property="itemId"/>]>.value" class="text">
                	<option/>
                	<%=ScreenHelper.writeSelect(request, "apfelscore", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CLASS_APFEL"), sWebLanguage) %>
                </select>
            </td>
        	<td class='admin'><%=getTran(request,"Web.Occup","othertests",sWebLanguage)%></td>
        	<td class='admin2' colspan='3'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_OTHERTESTS")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_OTHERTESTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_OTHERTESTS" property="value"/></textarea>
            </td>
        </tr>
        <tr class='admin'>
            <td colspan="10"><%=getTran(request,"openclinic.chuk","explorations",sWebLanguage)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","ecg",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_ECG")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ECG" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ECG" property="value"/></textarea>
            </td>
        	<td class='admin'><%=getTran(request,"Web.Occup","chest.xray",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_CHESTXRAY")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CHESTXRAY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_CHESTXRAY" property="value"/></textarea>
            </td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","echographie",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_ECHO")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ECHO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_ECHO" property="value"/></textarea>
            </td>
        	<td class='admin'><%=getTran(request,"Web.Occup","fo",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_FO")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_FO" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_FO" property="value"/></textarea>
            </td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","efr",sWebLanguage)%></td>
        	<td class='admin2' colspan='9'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_LUNGFUNCTION")%> class="text" cols="20" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_LUNGFUNCTION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_LUNGFUNCTION" property="value"/></textarea>
            </td>
        </tr>
        <tr class='admin'>
            <td colspan="10"><%=getTran(request,"openclinic.chuk","anesthesiatype",sWebLanguage)%></td>
        </tr>
        <tr>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_GA")%> type="checkbox" id="cbga" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_GA" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_GA;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.ga",sWebLanguage,"cbga")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_INTUBATION")%> type="checkbox" id="cbintubation" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_INTUBATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_INTUBATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.intubation",sWebLanguage,"cbintubation")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_LARYNXMASK")%> type="checkbox" id="cblarynxmask" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_LARYNXMASK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_LARYNXMASK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.larynxmask",sWebLanguage,"cblarynxmask")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_FACIALMASK")%> type="checkbox" id="cbfacialmask" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_FACIALMASK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_FACIALMASK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.facialmask",sWebLanguage,"cbfacialmask")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_SEDATION")%> type="checkbox" id="cbsedation" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_SEDATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_SEDATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.sedation",sWebLanguage,"cbsedation")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_ALR")%> type="checkbox" id="cbalr" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_ALR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_ALR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.alr",sWebLanguage,"cbalr")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_RACHI")%> type="checkbox" id="cbrachi" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_RACHI" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_RACHI;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.rachi",sWebLanguage,"cbrachi")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_PERIDURAL")%> type="checkbox" id="cbperidural" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_PERIDURAL" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_PERIDURAL;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.peridural",sWebLanguage,"cbperidural")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_ALRIV")%> type="checkbox" id="cbalriv" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_ALRIV" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_ALRIV;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.alriv",sWebLanguage,"cbalriv")%>
            </td>
            <td class="admin2">
            	<input <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_NERVEBLOCK")%> type="checkbox" id="cbnerveblock" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_NERVEBLOCK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_NERVEBLOCK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getLabel(request,"openclinic.kira","anesthesia.type.nerveblock",sWebLanguage,"cbnerveblock")%>
            </td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","comment",sWebLanguage)%></td>
        	<td class='admin2' colspan='9'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_TYPE_COMMENT")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_TYPE_COMMENT" property="value"/></textarea>
            </td>
        </tr>
        <tr><td colspan='10'><hr/></td></tr>
        <tr>
        	<td class='admin'><%=getTran(request,"Web.Occup","extrainvestigations",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_EXTRAINVESTIGATIONS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EXTRAINVESTIGATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_EXTRAINVESTIGATIONS" property="value"/></textarea>
            </td>
        	<td class='admin'><%=getTran(request,"Web.Occup","instructions",sWebLanguage)%></td>
        	<td class='admin2' colspan='4'>
                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_ANESTHESIA_INSTRUCTIONS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INSTRUCTIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ANESTHESIA_INSTRUCTIONS" property="value"/></textarea>
            </td>
        </tr>
        <tr>
	        <%-- DIAGNOSIS --%>
	    	<td class="admin" colspan="10">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
    
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>                    
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.kirapreop",sWebLanguage)%>
    <%=ScreenHelper.alignButtonsStop()%>
			                
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  function submitForm(){
    document.getElementById("buttonsDiv").style.visibility = "hidden";
    var temp = Form.findFirstElement(transactionForm); //for ff compatibility
    document.transactionForm.submit();
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>