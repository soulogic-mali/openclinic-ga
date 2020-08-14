
<%@ page import="be.openclinic.medical.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"cnrkr.consultation","select",activeUser)%>


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
					     .append("&nbsp;<b>").append(keyword).append("</b> | ");
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
	
	
	<%-- =writeHistoryFunctions(tran.getTransactionType(),sWebLanguage)--%>
    <%--=contextHeader(request,sWebLanguage)--%>
   
    
 <div style="padding-top:5px;"></div>
 <table class="list" width='100%' cellpadding="1" cellspacing="1"> 
     	<%-- title --%>
     	<tr class="gray">
            <td>&nbsp;<b><%=getTran(request,"web","biometrics",sWebLanguage)%></b></td>
        </tr> 
		<tr>
			<td class="admin2" width='100%' style="padding:0px;">
         	    <table width="100%" cellpadding="1" cellspacing="1">
         			<tr>
         				<td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
						<td class='admin2'>
         					<%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%> 
         					<input id="sbpr" <%=setRightClick("ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> /
                        	<input id="dbpr" <%=setRightClick("ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg
                        </td>
						<td class='admin2' colspan='2'>
	                        <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%>
	                        <input id="sbpl" <%=setRightClick("ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> /
	                        <input id="dbpl" <%=setRightClick("ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> mmHg
                        </td>
						<td class='admin' colspan="2"><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
			            <td class='admin2'>
			                <input <%=setRightClickMini("ITEM_TYPE_CNRKR_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_WEIGHT" property="value"/>"/>
			            </td>
                        <td width="30%">&nbsp;</td>
					</tr>
					<tr>
         				<td class='admin'><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
         				<td class='admin2'>
                        	<input id="temperature" <%=setRightClick("ITEM_TYPE_CNRKR_BIOMETRY_TEMPERATURE")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_TEMPERATURE" property="value"/>"> °C
                        </td>
						<td class='admin'><%=getTran(request,"openclinic.chuk","height",sWebLanguage)%></td>
         				<td class='admin2'>
                        	<input id="height" <%=setRightClick("ITEM_TYPE_CNRKR_BIOMETRY_HEIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_HEIGHT" property="value"/>"> cm
                        </td>
						<td class='admin' colspan="2"><%=getTran(request,"openclinic.chuk","heartfrequency",sWebLanguage)%></td>
         				<td class='admin2'>
                            <input id="hearthfreq" <%=setRightClick("ITEM_TYPE_CNRKR_BIOMETRY_HEARTFREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_HEARTFREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BIOMETRY_HEARTFREQUENCY" property="value"/>">/min
                        </td>
                        <td width="30%">&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
</table>
 <table class="list" width='100%' cellpadding="1" cellspacing="1">
  	<%-- title --%>
  	<tr class="gray">
         <td colspan="2">&nbsp;<b><%=getTran(request,"web","diagnosis",sWebLanguage)%></b></td>
     </tr> 
     <tr>
         <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
         <td class="admin2">
         		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
         </td>
     </tr>
     <tr>
         <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
         <td class="admin2">
         		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY2","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
         </td>
     </tr>
     <tr>
         <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
         <td class="admin2">
         		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY3","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
         </td>
     </tr>
     <tr>
         <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
         <td class="admin2">
         		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY4","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
         </td>
     </tr>
     <tr>
         <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
         <td class="admin2">
         		<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_COMMENT", 80, 2) %>
         </td>
     </tr>
</table>
   <div style="padding-top:5px;"></div>
 <%-- KEYWORDS for DIAGNOSES -----------------------------------------------------------------%>
    <table class="list" width='100%' cellpadding="1" cellspacing="1">
     	<%-- title --%>
     	<tr class="gray">
            <td colspan="5">&nbsp;<b><%=getTran(request,"web","keywords",sWebLanguage)%></b></td>
        </tr> 
		<tr> 
         	<td class="admin2" colspan='3' width='70%' style="vertical-align:top;padding:0px;">
         		<table width="100%" cellpadding="1" cellspacing="1">
				
				
				<%-- History signs --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title1"><%=getTran(request,"web","history",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("history.signs.ids","history.signs.text","history.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='history.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_HISTORY_IDS","history.signs.text","history.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='history.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY_COMMENT" property="itemId"/>]>.value" id='functional.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key1' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
					
					
					<%-- symptoms --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title2"><%=getTran(request,"web","symptoms",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("symptoms.signs.ids","symptoms.signs.text","symptoms.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='symptoms.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_SYMPTOMS_IDS","symptoms.signs.text","symptoms.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='symptoms.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS_COMMENT" property="itemId"/>]>.value" id='symptoms.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key2' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
						
				<%-- performedexaminations --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title3"><%=getTran(request,"web","performedexaminations",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("exams.signs.ids","exams.signs.text","exams.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='exams.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_EXAMS_IDS","exams.signs.text","exams.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='exams.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS_COMMENT" property="itemId"/>]>.value" id='exams.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key3' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
						
						
						
						<%-- Clinical exams --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title4"><%=getTran(request,"web","clinicalexamination",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("clinicalexamination.signs.ids","clinicalexamination.signs.text","clinicalexamination.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='clinicalexamination.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_CLINICALEXAM_IDS","clinicalexamination.signs.text","clinicalexamination.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='clinicalexamination.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM_COMMENT" property="itemId"/>]>.value" id='clinicalexamination.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key4' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
					
					<%-- Requested exams --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title5"><%=getTran(request,"web","requestedexams",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("requestedexams.signs.ids","requestedexams.signs.text","requestedexams.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='requestedexams.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_REQUESTEDEXAM_IDS","requestedexams.signs.text","requestedexams.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='requestedexams.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REQUESTEDEXAM_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REQUESTEDEXAM_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REQUESTEDEXAM_COMMENT" property="itemId"/>]>.value" id='requestedexams.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REQUESTEDEXAM_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key5' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
					
					
					<%-- workingdiagnosis --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title6"><%=getTran(request,"web","workingdiagnosis",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("workingdiagnosis.signs.ids","workingdiagnosis.signs.text","workingdiagnosis.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='workingdiagnosis.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS_IDS","workingdiagnosis.signs.text","workingdiagnosis.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='workingdiagnosis.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS_COMMENT" property="itemId"/>]>.value" id='workingdiagnosis.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key6' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
					
					
					<%-- therapy --%>
         			<tr height="40">
         				<td class='admin' width='20%'>
         					<div id="Title7"><%=getTran(request,"web","therapy",sWebLanguage)%></div>
         				</td>
						<td>
         					<table width='100%'>
         						<tr onclick='selectKeywords("therapy.signs.ids","therapy.signs.text","therapy.signs","keywords")'>
			         				<td class='admin2' width='50%' style="vertical-align:top;">
			         					<div id='therapy.signs.text'><%=getKeywordsHTML(tran,ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_CNRKR_THERAPY_IDS","therapy.signs.text","therapy.signs.ids",sWebLanguage)%></div>
			         					<input type='hidden' id='therapy.signs.ids' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY_IDS" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY_IDS" property="value"/>"/>
			         				</td>
			         				<td class='admin2'>
			         					<textarea class="text" onkeyup="resizeTextarea(this,10)" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY_COMMENT" property="itemId"/>]>.value" id='therapy.signs.comment' cols='45' ><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY_COMMENT" property="value"/></textarea>
			         				</td>
			         				<td class='admin2' width='40' nowrap style="text-align:center">
			         				    <img width='16' id='Key7' class="link" src='<c:url value="/_img/themes/default/keywords.jpg"/>'/>
			         				</td>
			         			</tr>
         					</table>
         				</td>
					</tr> 
					
				</table>
			</td>
			 <td class="admin2" style="vertical-align:top;padding:0px;">
         		<div style="height:300px;overflow:auto" id="keywords"></div>
         	</td>
	
		</tr>
	</table>
				
	
	<%-- Prescription --%>	
			
	   <table class="list" width='100%' cellpadding="1" cellspacing="1">
			<%-- title --%>
     	<tr class="gray">
            <td colspan="5">&nbsp;<b><%=getTran(request,"web","prescription",sWebLanguage)%></b></td>
        </tr> 
		 <tr>
           <td class="admin"><%=getTran(request,"web","reeducation",sWebLanguage)%></td>
           <td class="admin2">
           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REEDUCATION" property="itemId"/>]>.value' id ='reeducation'>
           		<option/>
           		<%=ScreenHelper.writeSelect(request,"cnrkr.reeducation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REEDUCATION"),sWebLanguage) %>
           	</select>
           </td>
       </tr>
		<tr>
           <td class="admin"><%=getTran(request,"web","numberofsessions",sWebLanguage)%></td>
           <td class="admin2">
           		<input type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONS" property="itemId"/>]>.value' value='<%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONS")%>'/>
           </td>
       </tr>
		<tr>
           <td class="admin"><%=getTran(request,"web","frequency",sWebLanguage)%></td>
           <td class="admin2">
           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FREQUENCY" property="itemId"/>]>.value' id ='frequency'>
           		<option/>
           		<%=ScreenHelper.writeSelect(request,"cnrkr.frequency",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FREQUENCY"),sWebLanguage) %>
           	</select>
           </td>
       </tr>
	   
	   
	   <tr>
           <td class="admin"><%=getTran(request,"web","sessionduration",sWebLanguage)%></td>
           <td class="admin2">
           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONDURATION" property="itemId"/>]>.value' id ='sessionduration'>
           		<option/>
           		<%=ScreenHelper.writeSelect(request,"cnrkr.sessionduration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONDURATION"),sWebLanguage) %>
           	</select>
           </td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","instructions",sWebLanguage)%></td>
           <td class="admin2">
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick("ITEM_TYPE_CNRKR_INSTRUCTIONS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_INSTRUCTIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_INSTRUCTIONS" property="value"/></textarea>
           </td>
       </tr>
		</table>
	<div style="padding-top:5px;"></div>
    
    <%-- DIAGNOSES --%>
    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncodingWide.jsp"),pageContext);%>            
	<%=ScreenHelper.contextFooter(request)%>
</form>	
		
 <script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    document.transactionForm.submit();
  }
    
  <%-- SELECT KEYWORDS --%>
  function selectKeywords(destinationidfield,destinationtextfield,labeltype,divid){	
    document.getElementById("Key1").width = "16";
	document.getElementById("Key2").width = "16";
	document.getElementById("Key3").width = "16";
	document.getElementById("Key4").width = "16";
	document.getElementById("Key5").width = "16";
	document.getElementById("Key6").width = "16";
	document.getElementById("Key7").width = "16";
    
    
    document.getElementById("Title1").style.textDecoration = "none";
	document.getElementById("Title2").style.textDecoration = "none";
	document.getElementById("Title3").style.textDecoration = "none";
	document.getElementById("Title4").style.textDecoration = "none";
	document.getElementById("Title5").style.textDecoration = "none";
	document.getElementById("Title6").style.textDecoration = "none";
	document.getElementById("Title7").style.textDecoration = "none";

    
    
    if(labeltype=='history.signs'){
        document.getElementById("Title1").style.textDecoration = "underline";
	  document.getElementById('Key1').width = '32';
	}
	if(labeltype=='symptoms.signs'){
        document.getElementById("Title2").style.textDecoration = "underline";
	  document.getElementById('Key2').width = '32';
	}
	if(labeltype=='exams.signs'){
        document.getElementById("Title3").style.textDecoration = "underline";
	  document.getElementById('Key3').width = '32';
	}
	
	if(labeltype=='clinicalexamination.signs'){
        document.getElementById("Title4").style.textDecoration = "underline";
	  document.getElementById('Key4').width = '32';
	}
	if(labeltype=='requestedexams.signs'){
        document.getElementById("Title5").style.textDecoration = "underline";
	  document.getElementById('Key5').width = '32';
	}
	if(labeltype=='workingdiagnosis.signs'){
        document.getElementById("Title6").style.textDecoration = "underline";
	  document.getElementById('Key6').width = '32';
	}
	if(labeltype=='therapy.signs'){
        document.getElementById("Title7").style.textDecoration = "underline";
	  document.getElementById('Key7').width = '32';
	}
    
    
    var params = "";
    var today = new Date();
    var url = '<c:url value="/healthrecord/ajax/getKeywords.jsp"/>'+
              '?destinationidfield='+destinationidfield+
              '&destinationtextfield='+destinationtextfield+
              '&labeltype='+labeltype+
              '&ts='+today;
    new Ajax.Request(url,{
      method: "POST",
      parameters: params,
      onSuccess: function(resp){
        $(divid).innerHTML = resp.responseText;
      },
      onFailure: function(){
        $(divid).innerHTML = "";
      }
    });
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

  selectKeywords("history.signs.ids","history.signs.text","history.signs","keywords");
</script>
