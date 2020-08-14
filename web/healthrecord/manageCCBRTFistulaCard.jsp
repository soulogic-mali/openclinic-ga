<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.vvfrecord","select",activeUser)%>
<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
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
            <td class="admin"><%=getTran(request,"ccbrt","athomeliveswith",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <select id="athomeliveswith" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_ATHOMELIVESWITH" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.athomeliveswith",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_ATHOMELIVESWITH"),sWebLanguage,false,true) %>
	            </select>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","educationofpatient",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <select id="patienteducation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PATIENTEDUCATION" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.education",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PATIENTEDUCATION"),sWebLanguage,false,true) %>
	            </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","occupation",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <select id="patientoccupation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OCCUPATION" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.causes",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OCCUPATION"),sWebLanguage,false,true) %>
	            </select>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","educationofpartner",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <select id="partnereducation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_EDUCATIONPARTNER" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.education",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_EDUCATIONPARTNER"),sWebLanguage,false,true) %>
	            </select>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","problems",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMURINE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMURINE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","problemwithurine",sWebLanguage) %>			            
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMFAECES" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMFAECES;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","problemwithfaeces",sWebLanguage) %>			            
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMLEAKAGE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PROBLEMLEAKAGE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","canurinenormallyandleakage",sWebLanguage) %>			            
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","leakagestarted",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<input type="hidden" id="leakagestartfield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGESTART" property="itemId"/>]>.value"/>
				<%=ScreenHelper.writeDateField("leakagestart", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGESTART"), true, false, sWebLanguage, sCONTEXTPATH)%>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AFTERDELIVERY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AFTERDELIVERY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","afterdelivery",sWebLanguage) %>			            
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","ageatwhichfistuladeveloped",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AGEDEVELOPED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_AGEDEVELOPED" translate="false" property="value"/>"/> <%=getTran(request,"web","years",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","durationofleakage",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" translate="false" property="value"/>"/> <%=getTran(request,"web","years",sWebLanguage) %> <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEAKAGEDURATION" translate="false" property="value"/>"/> <%=getTran(request,"web","months",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","parityfistuladeveloped",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PARITYDEVELOPED" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PARITYDEVELOPED" translate="false" property="value"/>"/>
			            </td>
			            <td class="admin" width="30%"><%=getTran(request,"ccbrt","dateofdelivery",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<input type="hidden" id="dateofdeliveryfield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DATEOFDELIVERY" property="itemId"/>]>.value"/>
							<%=ScreenHelper.writeDateField("dateofdelivery", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DATEOFDELIVERY"), true, false, sWebLanguage, sCONTEXTPATH)%>
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran(request,"ccbrt","causenonobstetricfistula",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CAUSENONOBSTETRIC" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CAUSENONOBSTETRIC" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","placeofdelivery",sWebLanguage)%>&nbsp;</td>
	        <td class="admin2" width="35%">
	            <select id="placeofdelivery" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLACEOFDELIVERY" property="itemId"/>]>.value">
	               	<option/>
	            	<%=ScreenHelper.writeSelect(request,"vvf.placeofdelivery2",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PLACEOFDELIVERY"),sWebLanguage,false,true) %>
	            </select>
	        </td>
	        <td class="admin"><%=getTran(request,"ccbrt","nameofhospital",sWebLanguage)%>&nbsp;</td>
	        <td class="admin2" width="35%">
	            <input type="text" class="text" size="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_NAMEHOSPITAL" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_NAMEHOSPITAL" translate="false" property="value"/>"/>
	        </td>
		</tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","deliveredby",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="deliveredby" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DELIVEREDBY" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.deliveredby",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DELIVEREDBY"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","modeofdelivery",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="modeofdelivery" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MODEOFDELIVERY" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.modeofdelivery2",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MODEOFDELIVERY"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
       	<tr class="admin">
            <td colspan="4"><%=getTran(request,"ccbrt","historyoflabour",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","durationofcontractionhome",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CONTRACTIONHOME" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CONTRACTIONHOME" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","timetofacility",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETOFACILITY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETOFACILITY" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage)+":"+getTran(request,"web","minutes",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","timetillbirth",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETILLBIRTH" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMETILLBIRTH" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage)+":"+getTran(request,"web","minutes",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","referral",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REFERRED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REFERRED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","referred",sWebLanguage) %>
       			| <%=getTran(request,"ccbrt","timreferraltodelivery",sWebLanguage)%><input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEREFERRALTODELIVERY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEREFERRALTODELIVERY" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage)+":"+getTran(request,"web","minutes",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","totaltimeinlabor",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEINLABOR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEINLABOR" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage)+":"+getTran(request,"web","minutes",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","comments",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="comment" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_COMMENT" translate="false" property="value"/></textarea>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","outcomeofbaby",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
			               	<select id="outcomebaby" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_STILLBIRTH" property="itemId"/>]>.value">
			               		<option/>
			            		<%=ScreenHelper.writeSelect(request,"vvf.outcomebaby",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_STILLBIRTH"),sWebLanguage,false,true) %>
			               	</select>
			            </td>
			            <td class="admin" width="30%"><%=getTran(request,"ccbrt","gender",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			               	<select id="genderbaby" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYGENDER" property="itemId"/>]>.value">
			               		<option/>
			            		<%=ScreenHelper.writeSelect(request,"gender",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYGENDER"),sWebLanguage,false,true) %>
			               	</select>
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran(request,"ccbrt","babyweight",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="6" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYWEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BABYWEIGHT" translate="false" property="value"/>"/> kg
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","intervalleakage",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="3">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_INTERVALLEAKAGE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_INTERVALLEAKAGE" translate="false" property="value"/>"/> <%=getTran(request,"web","days",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","numberofchildren",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDREN" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDREN" translate="false" property="value"/>"/>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","numberofchildrenallive",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDRENALIVE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CHILDRENALIVE" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","catheter",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HADCATHETER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HADCATHETER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","hadcatheter",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","timewithcatheter",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEWITHCATHETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_TIMEWITHCATHETER" translate="false" property="value"/>"/> <%=getTran(request,"web","days",sWebLanguage) %>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","leggweaknessafterdelivery",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSLEFT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSLEFT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","left",sWebLanguage) %>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRIGHT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRIGHT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","right",sWebLanguage) %>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRESOLVED" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LEGWEAKNESSRESOLVED;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","resolved",sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","menstruation",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<input type="hidden" id="lmpfield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LMP" property="itemId"/>]>.value"/>
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MENSTRUATIONREGULAR" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MENSTRUATIONREGULAR;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","regular",sWebLanguage) %>
				| <%=getTran(request,"web","LMP",sWebLanguage)%> <%=ScreenHelper.writeDateField("lmp", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LMP"), true, false, sWebLanguage, sCONTEXTPATH)%>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","previousfistularepair",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="history" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PREVIOUSFISTULAREPAIR" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PREVIOUSFISTULAREPAIR" translate="false" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","medicalhistory",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="history" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MEDICALHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_MEDICALHISTORY" translate="false" property="value"/></textarea>
            </td>
        </tr>
       	<tr class="admin">
            <td colspan="4"><%=getTran(request,"ccbrt","relevantexamination",sWebLanguage)%>&nbsp;</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","height",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr>
			            <td class="admin2" width="30%">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HEIGHT" translate="false" property="value"/>"/> cm
			            </td>
			            <td class="admin" width="30%"><%=getTran(request,"ccbrt","weight",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_WEIGHT" translate="false" property="value"/>"/> kg
			            </td>
			        </tr>
			    </table>
			</td>
            <td class="admin"><%=getTran(request,"ccbrt","bloodpressure",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPSYS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPSYS" translate="false" property="value"/>"/> / <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPDIA" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BPDIA" translate="false" property="value"/>"/> mmHg
            </td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","generalcondition",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="generalcondition" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_GENERALCONDITION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.generalcondition",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_GENERALCONDITION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","fistulaclassification",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="fistulaclassification" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CLASSIFICATION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.fistulaclassification",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CLASSIFICATION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
        <!- DRAWING ITEM-->
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","diagram",sWebLanguage) %></td>
        	<td class='admin2' colspan='4'>
				<%=ScreenHelper.createDrawingDiv(request, "canvasDiv", "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING", transaction,MedwanQuery.getInstance().getConfigString("defaultVVFDiagram","/_img/vvf_diagram2.png"),"vvf.image") %>
        	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","dyetest",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="dyetest" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DYETEST" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.dyetest",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DYETEST"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","concurrentlesions",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RVF" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RVF;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","RVF",sWebLanguage) %>
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","peronealright",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALRIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALRIGHT" translate="false" property="value"/>"/> / 5
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","peronealleft",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALLEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PERONEALLEFT" translate="false" property="value"/>"/> / 5
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","vaginalstenosis",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="vaginalstenosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VAGINALSTENOSIS" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.vaginalstenosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VAGINALSTENOSIS"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","vulvalexcoriation",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="vulvalexcoriation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VULVALEXCORIATION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.vulvalexcoriation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_VULVALEXCORIATION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","historyoffgm",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
				<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FGMHISTORY" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_ITEM_TYPE_VVF_FGMHISTORY;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","typeoffgm",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="fgmtype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FGMTYPE" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.fgmtype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FGMTYPE"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","lastpreviousrepair",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="lastpreviousrepair" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LASTPREVIOUSREPAIR" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.lastpreviousrepair",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_LASTPREVIOUSREPAIR"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","reasonfordiversion",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="reasonfordiversion" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REASONFORDIVERSION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.reasonfordiversion",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_REASONFORDIVERSION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","rectaltest",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="rectaltest" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RECTALTEST" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.rectaltest",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_RECTALTEST"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","bladdersize",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BLADDERSIZE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_BLADDERSIZE" translate="false" property="value"/>"/> cm
           	</td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","durationofsurgery",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DURATIONOFSURGERY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DURATIONOFSURGERY" translate="false" property="value"/>"/> <%=getTran(request,"web","hours",sWebLanguage)+":"+getTran(request,"web","minutes",sWebLanguage) %>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","durationofhospitalstay",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
                <input type="text" class="text" size="4" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DURATIONHOSPITALSTAY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_DURATIONHOSPITALSTAY" translate="false" property="value"/>"/> <%=getTran(request,"web","days",sWebLanguage)%>
           	</td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","postopcomplications",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="comment" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_POSTOPCOMPLICATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_POSTOPCOMPLICATIONS" translate="false" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","hb",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HB" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_HB" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","preopusu",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_USU" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_USU" translate="false" property="value"/>"/>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","creatinine",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CREATININE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_CREATININE&" translate="false" property="value"/>"/>
            </td>
        </tr>
       	<tr>
            <td class="admin"><%=getTran(request,"ccbrt","otherinvestigations",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
	            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="comment" class="text" cols="40" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OTHERINVESTIGATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OTHERINVESTIGATIONS" translate="false" property="value"/></textarea>
            </td>
            <td class="admin"><%=getTran(request,"ccbrt","timewithcatheter",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
                <input type="text" class="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_POSTOPTIMEWITHCATHETER" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_POSTOPTIMEWITHCATHETER" translate="false" property="value"/>"/> <%=getTran(request,"web","days",sWebLanguage)%>
            </td>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","followup6months",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2" colspan='3'>
        		<table width='100%'>
        			<tr>
        				<td>
			               	<select id="followup6months" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUP6MONTHS" property="itemId"/>]>.value">
			               		<option/>
			            		<%=ScreenHelper.writeSelect(request,"vvf.followup6months",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUP6MONTHS"),sWebLanguage,false,true) %>
			               	</select>
			            </td>
        				<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPNOCOMPLICATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPNOCOMPLICATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ccbrt","nocomplications",sWebLanguage)%>
			            </td>
        				<td>
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPOTHER" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPOTHER;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"ccbrt","other",sWebLanguage)%>
				            <textarea onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="comment" class="text" rows="1" cols="30" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPOTHERTEXT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_FOLLOWUPOTHERTEXT" translate="false" property="value"/></textarea>
			            </td>
			        </tr>
			    </table>
			</td>
		</tr>
		<tr class="admin">
			<td colspan="4"><%=getTran(request,"ccbrt","surgeryandprocedure",sWebLanguage)%>&nbsp;</td>
		</tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","primarydiagnosis",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="primarydiagnosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYDIAGNOSIS" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.primarydiagnosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYDIAGNOSIS"),sWebLanguage,false,true) %>
               	</select>
           	</td>
            <td class="admin"><%=getTran(request,"ccbrt","primaryprocedure",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="primaryprocedure" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYPROCEDURE" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.primaryprocedure",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_PRIMARYPROCEDURE"),sWebLanguage,false,true) %>
               	</select>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","secondarydiagnosis",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="secondarydiagnosis" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SECONDARYDIAGNOSIS" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.primarydiagnosis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SECONDARYDIAGNOSIS"),sWebLanguage,false,true) %>
               	</select>
           	</td>
			<td class="admin"><%=getTran(request,"ccbrt","secondaryprocedure",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="secondaryprocedure" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SECONDARYPROCEDURE" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.primaryprocedure",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SECONDARYPROCEDURE"),sWebLanguage,false,true) %>
               	</select>
        </tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","surgerydifficulty",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="surgerydifficulty" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERYDIFFICULTY" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.difficulty",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGERYDIFFICULTY"),sWebLanguage,false,true) %>
               	</select>
           	</td>
			<td class="admin"><%=getTran(request,"ccbrt","outcomeoperation",sWebLanguage)%>&nbsp;</td>
        	<td class="admin2">
               	<select id="outcomeoperation" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OUTCOMEOPERATION" property="itemId"/>]>.value">
               		<option/>
            		<%=ScreenHelper.writeSelect(request,"vvf.outcomeoperation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_OUTCOMEOPERATION"),sWebLanguage,false,true) %>
               	</select>
           	</td>
		</tr>
		<tr>
            <td class="admin"><%=getTran(request,"ccbrt","surgeryincharge",sWebLanguage)%>&nbsp;</td>
            <td colspan='4' class='admin2'>
               	<select id="surgeonincharge" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGEONINCHARGE" property="itemId"/>]>.value">
               		<option/>
               		<%
               			String u = checkString(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_VVF_SURGEONINCHARGE"));
               			Connection conn = MedwanQuery.getInstance().getAdminConnection();
               			PreparedStatement ps = conn.prepareStatement("select  a.personid, a.lastname, a.firstname, u.userid from admin a, users u,userparameters p"+
               														" where a.personid = u.personid and u.userid = p.userid and p.parameter='training' and"+ 
               														" p.value = 'surgeon'");
               			ResultSet rs = ps.executeQuery();
               			while(rs.next()){
               				out.println("<option value='"+rs.getString("userid")+"' "+(u.equalsIgnoreCase(rs.getString("userid"))?"selected":"")+">"+rs.getString("lastname").toUpperCase()+", "+rs.getString("firstname")+"</option>");
               			}
               			rs.close();
               			ps.close();
               			conn.close();
               		%>
               	</select>
            </td>
		</tr>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">&nbsp;</td>
            <td class="admin2" colspan="3">
				<%-- BUTTONS --%>
			    <%
			      	if (activeUser.getAccessRight("occup.ccbrt.vvfrecord.add") || activeUser.getAccessRight("occup.ccbrt.vvfrecord.edit")){
			    %>
			    	<INPUT class="button" type="button" name="saveButton" value="<%=getTranNoLink("Web.Occup","medwan.common.record",sWebLanguage)%>" onclick="doSubmit();"/>
			    <%
			      	}
			    %>
                <INPUT class="button" type="button" value="<%=getTranNoLink("Web","back",sWebLanguage)%>" onclick="if(checkSaveButton()){window.location.href='<c:url value="/main.do?Page=curative/index.jsp"/>&ts=<%=getTs()%>'}">
            </td>
        </tr>
    </table>
	<%=ScreenHelper.contextFooter(request)%>
</form>
<script>
    function doSubmit(){
        transactionForm.saveButton.disabled = true;
        document.getElementById("leakagestartfield").value=document.getElementById("leakagestart").value;
        document.getElementById("dateofdeliveryfield").value=document.getElementById("dateofdelivery").value;
        document.getElementById("lmpfield").value=document.getElementById("lmp").value;
        document.transactionForm.submit();
    }
    
</script>
