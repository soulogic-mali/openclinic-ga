	<%@ page import="be.openclinic.medical.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.gitegaoutpatientfile","select",activeUser)%>

<%!
    //--- GET KEYWORDS HTML -----------------------------------------------------------------------
	private String getKeywordsHTML(TransactionVO transaction, String itemId, String textField,
			                       String idsField, String language){
		StringBuffer sHTML = new StringBuffer();
		ItemVO item = transaction.getItem(itemId);
		if(item!=null && item.getValue()!=null && item.getValue().length()>0){
			String[] ids = item.getValue().split(";");
			String keyword = "";
			
			for(int n=0; n<ids.length; n++){
				if(ids[n].split("\\$").length==2){
					keyword = getTran(null,ids[n].split("\\$")[0],ids[n].split("\\$")[1] , language);
					
					sHTML.append("<a href='javascript:deleteKeyword(\"").append(idsField).append("\",\"").append(textField).append("\",\"").append(ids[n]).append("\");'>")
					      .append("<img width='8' src='"+sCONTEXTPATH+"/_img/themes/default/erase.png' class='link' style='vertical-align:-1px'/>")
					     .append("</a>")
					     .append("&nbsp;<b>").append(keyword.startsWith("/")?keyword.substring(1):keyword).append("</b> | ");
				}
			}
		}
		
		String sHTMLValue = sHTML.toString();
		if(sHTMLValue.endsWith("| ")){
			sHTMLValue = sHTMLValue.substring(0,sHTMLValue.lastIndexOf("| "));
		}
		
		return sHTMLValue;
	}
%>

<form name="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
	<% TransactionVO tran = (TransactionVO)transaction; %>
	   
	<%
	    // this transaction seems to "loose" some items, in rare cases; thus this debug lines
		Vector tmpItems = (Vector)tran.getItems();
		for(int i=0; i<tmpItems.size(); i++){
			ItemVO item = (ItemVO)tmpItems.get(i);
		}
	%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
   
    <%=writeHistoryFunctions(tran.getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    <% SH.loadRecentItems((TransactionVO)transaction,activePatient); %>
   
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="10%" nowrap>
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
				<!-- Add time section -->
                <%
                	java.util.Date date = ((TransactionVO)transaction).getUpdateTime();
                	if(date==null){
                		date=new java.util.Date();
                	}
                	String sTime=new SimpleDateFormat("HH:mm").format(date);
                %>
                <input type='text' class='text' size='5' maxLength='5' name='trantime' id='trantime' value='<%=sTime%>'/>
                <!-- End time section -->
            </td>
            <td class="admin2" colspan='2'>&nbsp;</td>
        </tr>
    </table>
    <div style="padding-top:5px;"></div>
         
    <%-- BIOMETRICS -----------------------------------------------------------------------------%>
    <table class="list" width='100%' cellpadding="1" cellspacing="1"> 
        <%-- VITAL SIGNS --%>
        <tr>
            <td class="admin" rowspan='2'><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" rowspan='2'>
            	<table width="100%">
            		<tr>
            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="calculateBMI();"/> cm</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
            		</tr>
	                <tr>
			            <td nowrap><b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %</td>
			            <td nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm</td>
			            <td nowrap><b><%=getTran(request,"web","fhr",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_FOETAL_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="value"/>"/></td>
			            <td nowrap><b><%=getTran(request,"web","armcircumferenceshort",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_ARM_CIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ARM_CIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ARM_CIRCUMFERENCE" property="value"/>"/> cm</td>
	                </tr>
            		<tr>
            			<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td>
            			<td nowrap colspan='2'><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td>
            			<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td>
            			<td nowrap colspan='2'><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b></td>
            		</tr>
            		<tr>
            			<td nowrap colspan='2'><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
            			<td nowrap colspan='2'><input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min</td>
            			<td nowrap colspan='2'><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
            			<td nowrap colspan='2'><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
            		</tr>
            	</table>
            </td>
            <td class="admin"><%=getTran(request,"Web.Occup","rmh.clinical.patienttype",sWebLanguage)%>&nbsp;</td>
            <td class="admin2">
            	<table width='100%'>
            		<tr valign='top'>
            			<td>
			                <select class="text" id='patienttype' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE" property="itemId"/>]>.value">
			                	<%=ScreenHelper.writeSelect(request,"outpatient.type",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE"),sWebLanguage) %>
			                </select>
            			</td>
            			<td>
			                <select class="text" id='patienttype2' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE2" property="itemId"/>]>.value">
								<option/>
			                	<%=ScreenHelper.writeSelect(request,"outpatient.type3",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PATIENTTYPE2"),sWebLanguage) %>
			                </select>
			                <%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "outpatient.type4", "ITEM_TYPE_RMH_PATIENTTYPE4", sWebLanguage, false) %>
            			</td>
            		</tr>
            		<tr>
            			<td>
			                <%=getTran(request,"web","pregnancyduration",sWebLanguage) %>
            			</td>
            			<td>
	            			<input <%=setRightClick(session,"ITEM_TYPE_DELIVERY_AGE")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DELIVERY_AGE" property="value"/>" > <%=getTran(request,"web","weeks",sWebLanguage) %>
            			</td>
            		</tr>
            	</table>
            </td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"gynecology", "timemdcalled", sWebLanguage)%></td>
			<td class='admin2'>
				<table width='100%' cellpadding="0" cellspacing="0">
					<tr>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_CALLED", 5) %> h</td>
						<td class='admin' width='1%' nowrap><%=getTran(request,"gynecology", "timemdarrived", sWebLanguage)%>&nbsp;&nbsp;&nbsp;</td>
						<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_DELIVERY_MD_ARRIVED", 5) %> h</td>
					</tr>
				</table>
		</tr>
    </table>
    <div style="padding-top:5px;"></div>
    
    <%-- KEYWORDS for DIAGNOSES -----------------------------------------------------------------%>
    <table class="list" width='100%' cellpadding="1" cellspacing="1">
        <tr> 
         	<td class="admin2" colspan='3' width='70%' style="vertical-align:top;padding:0px;">
         		<table width="100%" cellpadding="1" cellspacing="1">
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","antecedents",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea <%=SH.cdm() %> onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_CLINICALHISTORY")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALHISTORY" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
         			<%-- Functional signs --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="title1"><%=getTran(request,"web","functional.signs",sWebLanguage)%></div>
         				</td>
         				<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("functional.signs.ids","functional.signs.text","ikirezi2.functional.signs","keywords",this)'>
			         				<td class='admin2'>
			         					<textarea <%=SH.cdm("functional.signs.ids") %> class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FUNCTIONALSIGNS_COMMENT" property="itemId"/>]>.value" id='functional.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FUNCTIONALSIGNS_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='1%' nowrap style="text-align:center">
			         				    <img width='16' id='key1' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='functional.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_FUNCTIONALSIGNS_IDS","functional.signs.text","functional.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='functional.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FUNCTIONALSIGNS_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FUNCTIONALSIGNS_IDS" property="value"/>"/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
         			</tr>
         			
         			<%-- Inspection --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="title2"><%=getTran(request,"web","inspection",sWebLanguage)%></div>
         				</td>
         				<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("inspection.ids","inspection.text","ikirezi2.inspection","keywords",this)'>
			         				<td class='admin2'>
			         					<textarea <%=SH.cdm("inspection.ids") %> class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_COMMENT" property="itemId"/>]>.value" id='inspection.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_COMMENT" property="value"/></textarea> 
			         				</td>
			         				<td class='admin2' width='1%' style="text-align:center">
			         				    <img width='16' id='key2' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='inspection.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_INSPECTION_IDS","inspection.text","inspection.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='inspection.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_INSPECTION_IDS" property="value"/>"/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
         			</tr>
         			
         			<%-- Palpation --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="title3"><%=getTran(request,"web","palpation",sWebLanguage)%></div>
         				</td>
         				<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("palpation.ids","palpation.text","ikirezi2.palpation","keywords",this)'>
			         				<td class='admin2'>
			         					<textarea <%=SH.cdm("palpation.ids") %> class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_COMMENT" property="itemId"/>]>.value" id='palpation.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_COMMENT" property="value"/></textarea> 
			         				</td>
			         				<td class='admin2' width='1%' style="text-align:center">
			         				    <img width='16' id='key3' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='palpation.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_PALPATION_IDS","palpation.text","palpation.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='palpation.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PALPATION_IDS" property="value"/>"/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
         			</tr>
         			
         			<%-- Heart ausculation --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="title4"><%=getTran(request,"web","auscultation",sWebLanguage)%></div>
         				</td>
         				<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("auscultation.ids","auscultation.text","ikirezi2.auscultation","keywords",this)'>
			         				<td class='admin2'>
			         					<textarea <%=SH.cdm("auscultation.ids") %> class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_COMMENT" property="itemId"/>]>.value" id='auscultation.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_COMMENT" property="value"/></textarea> 
			         				</td>
			         				<td class='admin2' width='1%' style="text-align:center">
			         				    <img width='16' id='key4' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='auscultation.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_HEARTAUSCULTATION_IDS","auscultation.text","auscultation.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='auscultation.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_HEARTAUSCULTATION_IDS" property="value"/>"/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
         			</tr>
         			
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.clinical.summary",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea id='commenttext' onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_CLINICALSUMMARY")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALSUMMARY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALSUMMARY" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.investigations",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_INVESTIGATIONS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_INVESTIGATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_INVESTIGATIONS" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.precancerlesions",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2' width='1%' nowrap>
						                <%= SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_RMH_UTERUSPRECANCER_SCREENING", "") %>
						                <%=getTran(request,"web","uterusprecancerscreening",sWebLanguage) %>&nbsp;
									</td>
			         				<td class='admin2' width='1%' nowrap>
						                <%= SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_RMH_UTERUSPRECANCER_POSITIVE", "") %>
						                <%=getTran(request,"web","uterusprecancerpositive",sWebLanguage) %>&nbsp;
									</td>
			         				<td class='admin2'>
						                <%= SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_RMH_UTERUSPRECANCER_TREATMENT", "") %>
						                <%=getTran(request,"web","uterusprecancertreatment",sWebLanguage) %>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.treatment",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <%= SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_RMH_SMALLSURGERY", "") %>
						                <%=getTran(request,"web","smallsurgery",sWebLanguage) %>
									</td>
								</tr>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea <%=SH.cdm() %> onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_TREATMENT")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_TREATMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_TREATMENT" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.final.diagnosis",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea <%=SH.cdm() %> onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_FINALDIAGNOSIS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_FINALDIAGNOSIS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_FINALDIAGNOSIS" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
                	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/sptField.jsp"),pageContext);%>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.followup",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_FOLLOWUP")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_FOLLOWUP" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_FOLLOWUP" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","rmhcomment",sWebLanguage)%>&nbsp;</td>
			            <td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("","","","keywords")'>
			         				<td class='admin2'>
						                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_COMMENT")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_COMMENT" property="value"/></textarea>
									</td>
								</tr>
							</table>
			            </td>
			        </tr>         			
         			<%-- Reference --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="title6"><%=getTran(request,"web","reference",sWebLanguage)%></div>
         				</td>
         				<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("reference.ids","reference.text","reference","keywords",this)'>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERENCE_COMMENT" property="itemId"/>]>.value" id='reference.comment' cols='45'><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERENCE_COMMENT" property="value"/></textarea> 
			         				</td>
			         				<td class='admin2' width='1%' style="text-align:center">
			         				    <img width='16' id='key6' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='reference.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_REFERENCE_IDS","reference.text","reference.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='reference.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERENCE_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERENCE_IDS" property="value"/>"/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
         			</tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","evolution",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<%
			            		Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
			            		if(activeEncounter!=null && checkString(activeEncounter.getOutcome()).length()>0){
			            			out.println(getTran(request,MedwanQuery.getInstance().getConfigString("encounterOutcomeType","encounter.outcome"),activeEncounter.getOutcome(),sWebLanguage)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			            		}
			            	%>
			            	<a href='javascript:openEncounter()'><%=getTran(request,"web","editencounter",sWebLanguage) %></a>
			            </td>
			        </tr>
         		</table>
         	</td>
         	
         	<%-- KEYWORDS --%>
         	<td id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
         		<div id='test'></div>
         		<div style="height:300px;overflow:auto;position: sticky;top: 0" id="keywords"></div>
         	</td>
         </tr>
    </table>
    <div style="padding-top:5px;"></div>
    
    <%-- DIAGNOSES --%>
    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncodingWide.jsp"),pageContext);%>            
    	    
    <%-- BUTTONS --%>
    <%=ScreenHelper.alignButtonsStart()%>
    <%=getButtonsHtml(request,activeUser,activePatient,"occup.healthcenter.contact",sWebLanguage)%>
    <%=ScreenHelper.alignButtonsStop()%>
        
	<%=ScreenHelper.contextFooter(request)%>
  <input type='hidden' name='activeDestinationIdField' id='activeDestinationIdField'/>
  <input type='hidden' name='activeDestinationTextField' id='activeDestinationTextField'/>
  <input type='hidden' name='activeLabeltype' id='activeLabeltype'/>
  <input type='hidden' name='activeDivld' id='activeDivld'/>

</form>

<script>
function openEncounter(){
    openPopup("adt/editEncounter.jsp&ReloadParent=no&Popup=yes&EditEncounterUID=" + document.getElementById('encounteruid').value + "&ts=<%=getTs()%>",800);
  }
  <%-- SUBMIT FORM --%>
  function submitForm(){
	  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
			alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
			searchEncounter();
		  }	
	  else {
	    transactionForm.saveButton.disabled = true;
	    document.getElementById('trandate').value+=' '+document.getElementById('trantime').value;
	    addIkireziBiometrics();
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
	    %>
	  }
  }    

  function addIkireziBiometrics(){
	    var url = '<c:url value="/ikirezi/addBiometrics.jsp"/>'+
			    '?encounteruid='+document.getElementById('encounteruid').value+
			    '&temperature='+document.getElementById('temperature').value+
			    '&wfl='+document.getElementById('wflinfo').title+
			    '&wflval='+document.getElementById('WFL').value+
			    '&bmi='+document.getElementById('BMI').value+
	              '&ts='+new Date().getTime();
	    new Ajax.Request(url,{
	      parameters: "",
	      onSuccess: function(resp){
	    	  //Fine
	      }
	    });
	  }

  <%-- SELECT KEYWORDS --%>
  function selectKeywords(destinationidfield,destinationtextfield,labeltype,divid,element){	
	if(element){
		//document.getElementById("keywordstd").style="position: absolute;top: "+element.getBoundingClientRect().top;

	}
    var bShowKeywords=true;
	document.getElementById("activeDestinationIdField").value=destinationidfield;
	document.getElementById("activeDestinationTextField").value=destinationtextfield;
	document.getElementById("activeLabeltype").value=labeltype;
	document.getElementById("activeDivld").value=divid;
	
    document.getElementById("key1").width = "16";
    document.getElementById("key2").width = "16";
    document.getElementById("key3").width = "16";
    document.getElementById("key4").width = "16";
    document.getElementById("key6").width = "16";
    
    document.getElementById("title1").style.textDecoration = "none";
    document.getElementById("title2").style.textDecoration = "none";
    document.getElementById("title3").style.textDecoration = "none";
    document.getElementById("title4").style.textDecoration = "none";
    document.getElementById("title6").style.textDecoration = "none";
    
    if(labeltype=='ikirezi2.functional.signs'){
        document.getElementById("title1").style.textDecoration = "underline";
	  	document.getElementById('key1').width = '32';
	  	//document.getElementById('keywordstd').style = "vertical-align:top";
	}
    else if(labeltype=='ikirezi2.inspection'){
      document.getElementById("title2").style.textDecoration = "underline";
	  document.getElementById('key2').width = '32';
	  	//document.getElementById('keywordstd').style = "vertical-align:top";
	}
    else if(labeltype=='ikirezi2.palpation'){
      document.getElementById("title3").style.textDecoration = "underline";
	  document.getElementById('key3').width = '32';
	  	//document.getElementById('keywordstd').style = "vertical-align:top";
	}
    else if(labeltype=='ikirezi2.auscultation'){
      document.getElementById("title4").style.textDecoration = "underline";
	  document.getElementById('key4').width = '32';
	  	//document.getElementById('keywordstd').style = "vertical-align:top";
	}
    else if(labeltype=='reference'){
      document.getElementById("title6").style.textDecoration = "underline";
	  document.getElementById('key6').width = '32';
	  	//document.getElementById('keywordstd').style = "vertical-align:bottom";
	}
    else{
    	bShowKeywords=false;
    }
    
    if(bShowKeywords){
	    var params = "";
	    var today = new Date();
	    var url = '<c:url value="/healthrecord/ajax/getKeywords.jsp"/>'+
	              '?destinationidfield='+destinationidfield+
	              '&destinationtextfield='+destinationtextfield+
	              '&labeltype='+labeltype+
	              '&filetype=new'+
	              '&ts='+today;
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        $(divid).innerHTML = resp.responseText;
	    	  if(resp.responseText.indexOf("<recheck/>")>-1){
	    		  window.setTimeout('storekeywordsubtype(document.getElementById("keywordsubtype").value);',200);
	    	  }
	    	  <%
	    	  	if(checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){%>
	            	myselect=document.getElementById('keywordsubtype');
	            	myselect.style='border:2px solid black; border-style: dotted';
	            	myselect.onclick=function(){window.open('<%=request.getRequestURI().replaceAll(request.getServletPath(),"")%>/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType=keywordsubtypes.'+labeltype+'&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};
	    	  <%
	    	  	}
	    	  %>
	      },
	      onFailure: function(){
	        $(divid).innerHTML = "";
	      }
	    });
    }
    else{
        $(divid).innerHTML = "";
    }
  }

  function newkeyword(){
      openPopup("/healthrecord/ajax/newKeyword.jsp&ts=<%=getTs()%>&labeltype="+document.getElementById("activeLabeltype").value+"."+document.getElementById("keywordsubtype").value);
  }
  
  function deletekeyword(labeltype,labelid){
	if(confirm("<%=getTranNoLink("web","areyousure",sWebLanguage)%>")){
	    var params = "";
	    var today = new Date();
	    var url = '<c:url value="/healthrecord/ajax/deleteKeyword.jsp"/>'+
	              '?labeltype='+labeltype+'&labelid='+labelid;
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  refreshKeywords();
	      },
	      onFailure: function(){
	      }
	    });
	}
  }
  
  function refreshKeywords(){
	  selectKeywords(document.getElementById("activeDestinationIdField").value,
			  document.getElementById("activeDestinationTextField").value,
			  document.getElementById("activeLabeltype").value,
			  document.getElementById("activeDivld").value);
  }
  
  <%-- ADD KEYWORD --%>
  function addKeyword(id,label,destinationidfield,destinationtextfield){
	while(document.getElementById(destinationtextfield).innerHTML.indexOf('&nbsp;')>-1){
		document.getElementById(destinationtextfield).innerHTML=document.getElementById(destinationtextfield).innerHTML.replace('&nbsp;','');
	}
	var ids = document.getElementById(destinationidfield).value;
	if((ids+";").indexOf(id+";")<=-1){
	  document.getElementById(destinationidfield).value = ids+";"+id;
	  
	  if(document.getElementById(destinationtextfield).innerHTML.length > 0){
		if(!document.getElementById(destinationtextfield).innerHTML.endsWith("| ")){
          document.getElementById(destinationtextfield).innerHTML+= " | ";
	    }
	  }
	  
	  document.getElementById(destinationtextfield).innerHTML+= "<span style='white-space: nowrap;'><a href='javascript:deleteKeyword(\""+destinationidfield+"\",\""+destinationtextfield+"\",\""+id+"\");'><img width='8' src='<c:url value="/_img/themes/default/erase.png"/>' class='link' style='vertical-align:-1px'/></a> <b>"+label+"</b></span> | ";
	}
  }

  function storekeywordsubtype(s){
    var params = "";
    var today = new Date();
    var url = '<c:url value="/healthrecord/ajax/storeKeywordSubtype.jsp"/>'+
              '?subtype='+s;
    new Ajax.Request(url,{
      method: "POST",
      parameters: params,
      onSuccess: function(resp){
    	  selectKeywords(document.getElementById("activeDestinationIdField").value,
    			  document.getElementById("activeDestinationTextField").value,
    			  document.getElementById("activeLabeltype").value,
    			  document.getElementById("activeDivld").value);
      },
      onFailure: function(){
      }
    });
  }

  <%-- DELETE KEYWORD --%>
  function deleteKeyword(destinationidfield,destinationtextfield,id){
	var newids = "";
	
	var ids = document.getElementById(destinationidfield).value.split(";");
	for(n=0; n<ids.length; n++){
	  if(ids[n].indexOf("$")>-1){
		if(id!=ids[n]){
		  newids+= ids[n]+";";
		}
	  }
	}
	
	document.getElementById(destinationidfield).value = newids;
	var newlabels = "";
	var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
    for(n=0;n<labels.length;n++){
	  if(labels[n].trim().length>0 && labels[n].indexOf(id)<=-1){
	    newlabels+=labels[n]+" | ";
	  }
	}
    
	document.getElementById(destinationtextfield).innerHTML = newlabels;	
  }
  
  <%-- SET BP --%>
  function setBP(oObject,sbp,dbp){
    if(oObject.value.length>0){
      if(!isNumberLimited(oObject,40,300)){
        alertDialog("Web.Occup","out-of-bounds-value");
      }
      else if((sbp.length>0)&&(dbp.length>0)){
        isbp = document.getElementsByName(sbp)[0].value*1;
        idbp = document.getElementsByName(dbp)[0].value*1;
        if(idbp>isbp){
          alertDialog("Web.Occup","error.dbp_greather_than_sbp");
        }
      }
    }
  }

  <%-- SET HF --%> 
  function setHF(oObject){
    if(oObject.value.length>0){
      if(!isNumberLimited(oObject,30,300)){
        alertDialog("web.occup","out-of-bounds-value");
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
      var wfl=(weightInput.value*1/heightInput.value*1);
      if(wfl>0){
    	  document.getElementById('WFL').value = wfl.toFixed(2);
    	  checkWeightForHeight(heightInput.value,weightInput.value);
      }
    }
  }

	function checkWeightForHeight(height,weight){
	      var today = new Date();
	      var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
	      new Ajax.Request(url,{
	          method: "POST",
	          postBody: "",
	          onSuccess: function(resp){
	              var label = eval('('+resp.responseText+')');
	    		  if(label.zindex>-999){
	    			  if(label.zindex<-4){
	    				  document.getElementById("WFL").className="darkredtext";
	    				  document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-3){
	    				  document.getElementById("WFL").className="darkredtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-2){
	    				  document.getElementById("WFL").className="orangetext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex<-1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>2){
	    				  document.getElementById("WFL").className="orangetext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else if(label.zindex>1){
	    				  document.getElementById("WFL").className="yellowtext";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			  }
	    			  else{
	    				  document.getElementById("WFL").className="text";
	    				  document.getElementById("wflinfo").style.display='none';
	    			  }
	    		  }
    			  else{
    				  document.getElementById("WFL").className="text";
    				  document.getElementById("wflinfo").style.display='none';
    			  }
	          },
	          onFailure: function(){
	          }
	      }
		  );
	  	}

	  function searchEncounter(){
	      openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
	  }
	  
	  calculateBMI();
	  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
			alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
			searchEncounter();
	  }	
</script>