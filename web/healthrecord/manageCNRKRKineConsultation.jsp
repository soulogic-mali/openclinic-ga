<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.*,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>

	<%
	    if (session.getAttribute("sessionCounter")==null){
	        session.setAttribute("sessionCounter",new Integer(0));
	    }
	    else {
	        session.setAttribute("sessionCounter",new Integer(((Integer)session.getAttribute("sessionCounter")).intValue()+1));
	    }
	%>
	<table class="list" cellspacing="1" cellpadding="0" width="100%">
	    <tr>
	        <td style="vertical-align:top" width="50%">                
	            <table class="list" cellspacing="1" cellpadding="0" width="100%">
	                <%-- MEDICAL SUMMARY --------------------------------------------------------------------%>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="3"><%=getTran(request,"web","general",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","cardtype",sWebLanguage)%></td>
			           <td class="admin2" colspan='2'>
				            <select <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_CARDTYPE")%> id="cardtype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CARDTYPE" property="itemId"/>]>.value">
				               	<option/>
				            	<%=ScreenHelper.writeSelect(request,"cardtype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CARDTYPE"),sWebLanguage,false,false) %>
				            </select>
			           </td>
			       </tr>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="3"><%=getTran(request,"web","anamnesis",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","carerequest",sWebLanguage)%></td>
			           <td class="admin2" colspan='2'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_CAREREQUEST")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CAREREQUEST" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CAREREQUEST" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","functionalproblems",sWebLanguage)%></td>
			           <td class="admin2" width='1%' nowrap>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FUNCTIONALPROBLEMS")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALPROBLEMS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALPROBLEMS" property="value"/></textarea>
			           </td>
			           <td class="admin2">
			           		<%=getTran(request,"web.occup","severity",sWebLanguage)%>
				            <select <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FUNCTIONALSEVERITY")%> id="functionalseverity" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALSEVERITY" property="itemId"/>]>.value">
				               	<option/>
				            	<%=ScreenHelper.writeSelect(request,"functionalseverity",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALSEVERITY"),sWebLanguage,false,false) %>
				            </select>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","influencingfactors",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_INFLUENCINGFACTORS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_INFLUENCINGFACTORS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_INFLUENCINGFACTORS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="4"><%=getTran(request,"web","history",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","associateddiseases",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_ASSOCIATEDDISEASES")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_ASSOCIATEDDISEASES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_ASSOCIATEDDISEASES" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","previousdiseases",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_PREVIOUSDISEASES")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PREVIOUSDISEASES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PREVIOUSDISEASES" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","familyhistory",sWebLanguage)%></td>
			           <td class="admin2" colspan='2'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FAMILYHISTORY")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FAMILYHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FAMILYHISTORY" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","medicines",sWebLanguage)%></td>
			           <td class="admin2" colspan='2'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_MEDICINES")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_MEDICINES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_MEDICINES" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","previousparamedicalcare",sWebLanguage)%></td>
			           <td class="admin2" colspan='2'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_PREVPARAMEDCARE")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PREVPARAMEDCARE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PREVPARAMEDCARE" property="value"/></textarea>
			           </td>
			       </tr>
	        	</table>
	 		</td>
	    	<td style="vertical-align:top" width="50%">                
	    		<table class="list" cellspacing="1" cellpadding="0" width="100%">
		          	<%-- MEDICAL SUMMARY --------------------------------------------------------------------%>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="4"><%=getTran(request,"web","baseexamination",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","diagnosticacts",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			           	   <%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNRKR_KINE_DIAGNOSTICACTS", "cnrkr.diagnosticacts", sWebLanguage, "onchange='if(window.confirm(\""+getTranNoLink("web","switchtoassessment",sWebLanguage)+"\")){activateTab(5)};'",MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY").split("\\.")[0]) %>	
			           </td>
			       </tr>
			       <tr>
			           <td class="admin" rowspan="4"><%=getTran(request,"web","diagnostictests",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_KINE_TEST1","cnrkr.tests", 40, sWebLanguage,sCONTEXTPATH, "onchange='activateTab(6)'") %>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin2" colspan='3'>
			           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_KINE_TEST2","cnrkr.tests", 40, sWebLanguage,sCONTEXTPATH, "onchange='activateTab(6)'") %>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin2" colspan='3'>
			           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_KINE_TEST3","cnrkr.tests", 40, sWebLanguage,sCONTEXTPATH, "onchange='activateTab(6)'") %>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin2" colspan='3'>
			           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_KINE_TEST4","cnrkr.tests", 40, sWebLanguage,sCONTEXTPATH, "onchange='activateTab(6)'") %>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","diagnisticresults",sWebLanguage)%></td>
			           <td class="admin2">
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_DIAGNOSTICRESULTS")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_DIAGNOSTICRESULTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_DIAGNOSTICRESULTS" property="value"/></textarea>
			           </td>
			           <td class="admin2"><%=getTran(request,"web.occup","severity",sWebLanguage)%></td>
			           <td class='admin2'>
				            <select <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_DIAGNOSTICSEVERITY")%> id="diagnosticseverity" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_DIAGNOSTICSEVERITY" property="itemId"/>]>.value">
				               	<option/>
				            	<%=ScreenHelper.writeSelect(request,"functionalseverity",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_DIAGNOSTICSEVERITY"),sWebLanguage,false,false) %>
				            </select>
			           </td>
			       </tr>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="4"><%=getTran(request,"web","physiotherapydiagnosis",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","functionallimitations",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FUNCTIONALLIMITATIONS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALLIMITATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALLIMITATIONS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","functionaldisorders",sWebLanguage)%></td>
			           <td class="admin2">
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERS")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERS" property="value"/></textarea>
			           </td>
			           <td class="admin2"><%=getTran(request,"web.occup","severity",sWebLanguage)%></td>
			           <td class='admin2'>
				            <select  <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERSEVERITY")%> id="functionaldisorderseverity" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERSEVERITY" property="itemId"/>]>.value">
				               	<option/>
				            	<%=ScreenHelper.writeSelect(request,"functionalseverity",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FUNCTIONALDISORDERSEVERITY"),sWebLanguage,false,false) %>
				            </select>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","externalfactors",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_EXTERNALFACTORS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_EXTERNALFACTORS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_EXTERNALFACTORS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","personalfactors",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_PERSONALFACTORS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PERSONALFACTORS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PERSONALFACTORS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","medicalfactors",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_MEDICALFACTORS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_MEDICALFACTORS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_MEDICALFACTORS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","conclusion",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_CONCLUSIONS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CONCLUSIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CONCLUSIONS" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr class="admin" style="padding:0px;">
			           <td colspan="4"><%=getTran(request,"web","treatmentplan",sWebLanguage)%></td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","objectives",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_OBJECTIVES")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_OBJECTIVES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_OBJECTIVES" property="value"/></textarea>
			           </td>
			       </tr>
			       <tr>
			           <td class="admin"><%=getTran(request,"web","foreseenacts",sWebLanguage)%></td>
			           <td class="admin2" colspan='3'>
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_FORESEENACTS")%> class="text" cols="60" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FORESEENACTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_FORESEENACTS" property="value"/></textarea>
			           </td>
			       </tr>
	        	</table>
	 		</td>
	 	</tr>
	</table>
</logic:present>
