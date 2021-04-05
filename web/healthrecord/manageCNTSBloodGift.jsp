<%@page import="be.mxs.common.util.system.Pointer"%>
<%@page import="be.mxs.common.util.system.HTMLEntities"%>
<%@ page import="be.openclinic.finance.*,be.openclinic.medical.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
<script>var bRejected=false;</script>
<%=sJSPROTOTYPE %>
<%
	TransactionVO tran = (TransactionVO)transaction;
	if(tran.getTransactionId()<0){
		//verify if patient has not been permanently rejected
		boolean bRejected = false;
		Vector bloodgifts = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
		for(int n=0;n<bloodgifts.size();n++){
			TransactionVO bloodgift = (TransactionVO)bloodgifts.elementAt(n);
			bRejected=bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true");
			if(bRejected){
				break;
			}
		}
		if(bRejected){
			out.println("<script>bRejected=true;alert('"+ScreenHelper.getTranNoLink("cnts","patientpermanentlyrejected",sWebLanguage)+"');window.history.go(-1);</script>");
			out.flush();
		}
		
		if(activePatient.comment5.equalsIgnoreCase("1")){
			out.println("<script>bRejected=true;alert('"+ScreenHelper.getTranNoLink("cnts","donorcanceled",sWebLanguage)+"');window.history.go(-1);</script>");
			out.flush();
		}
	}
%>
<%=checkPermission(out,"occup.cnts.bloodgift","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    <%=writeHistoryFunctions(tran.getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2">
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <tr>
        	<td colspan="2">
	        	<table width='100%'>
		        	<tr>
	        		<% 
	        			if(tran.getTransactionId()>=0){
	        		%>
			            <td class="admin"><%=getTran(request,"bloodgift","sampleid",sWebLanguage)%></td>
			            <td class="admin2">
			                <font style="font-size:14px;font-weight:bold"><%=tran.getTransactionId() %></font>
			            </td>
	        		<%	}
	        			else{
					%>
						<td class="admin2" colspan="2"/>
					<%        				
	        			}
	        		%>
			            <td class="admin"><%=getTran(request,"bloodgift","totalgifts",sWebLanguage)%></td>
			            <td class="admin2">
			            	<table width='100%' cellspacing='0' cellpadding='0'>
			            		<tr>
			                		<td><b><span id="totalblooddonations"></span></b></td>
			                		<td class='admin' width='1%' nowrap><%=getTran(request,"web","beforeict",sWebLanguage) %>&nbsp;</td>
			                		<td class='admin2'>
			                			<a href='javascript:setOldBloodDonations()'><span id="oldblooddonations"></span></a>
			                		</td>
			                	</tr>
			                </table>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","location",sWebLanguage)%></td>
			            <%
				            String sDefaultLocation=SH.c((String)session.getAttribute("defaultCNTSLocation"));
				            if(((TransactionVO)transaction).getTransactionId()>0){
				            	sDefaultLocation=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_LOCATIONPRESET");
				            }
				        %>
			            <td class="admin2">
			                <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_LOCATIONPRESET" property="itemId"/>]>.value" id="searchServiceUid" value="<%=sDefaultLocation%>"/>
			                <input class="text" type="text" name="searchServiceName" id="searchServiceName" readonly size="50" value="<%=getTranNoLink("service",sDefaultLocation,sWebLanguage)%>" >
			                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('searchServiceUid','searchServiceName');">
			                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('searchServiceUid').value='';document.getElementById('searchServiceName').value='';">
			                <input class="text" type="text" id="cntslocation" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_LOCATION" property="itemId"/>]>.value" size="40" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_LOCATION" property="value"/>"/>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","collectionunit",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_CNTSBLOODGIFT_COLLECTIONUNIT","cnts.collectionunit", sWebLanguage, "",SH.c((String)session.getAttribute("defaultCNTSCollectionUnit"))) %>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","donortype",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "cnts.donortype", "ITEM_TYPE_CNTSBLOODGIFT_DONORTYPE", sWebLanguage, false, "", "")%>
			            </td>
			        </tr>
			        <tr class='admin'><td colspan='4'><%=getTran(request,"bloodgift","rejectioncriteria",sWebLanguage) %></td></tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","rejectioncriteria",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnts.bloodgift.rejectioncriteria", "ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA", sWebLanguage, true, "onchange='checkCriteria();'")%>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","permanentrejection",sWebLanguage)%></td>
			            <td class="admin2">
			                <input onchange='checkCriteria(true);' class="text" type="checkbox" id='permanentrejection' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION" property="itemId"/>]>.value" size="40" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","temporaryrejection",sWebLanguage)%></td>
			            <td class="admin2">
			                <input onchange='checkCriteria(true);' class="text" type="checkbox" id='temporaryrejection' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION" property="itemId"/>]>.value" size="40" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/>
			            </td>
			        </tr>
			        <tr class='admin'><td colspan='4'><%=getTran(request,"bloodgift","medicalevaluation",sWebLanguage) %></td></tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","lastdonation",sWebLanguage)%></td>
			            <td class="admin2" colspan="3">
							<%
								TransactionVO lastTran = MedwanQuery.getInstance().getLastTransactionByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNTS_BLOODGIFT");
								if(lastTran!=null && lastTran.getTransactionId()!=((TransactionVO)transaction).getTransactionId()){
									((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_LASTDONATION").setValue(SH.formatDate(lastTran.getUpdateTime()));
								}
							%>
			            	<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNTSBLOODGIFT_LASTDONATION", sWebLanguage, sCONTEXTPATH,"onchange='checkCriteria();' onfocus='checkCriteria();'") %>
			            	&nbsp;&nbsp;<b><%=getTran(request,"web","results",sWebLanguage)%></b>: <%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_CNTSBLOODGIFT_LASTDONATIONRESULTS", 30, 1) %>
			            	&nbsp;&nbsp;<b><%=getTran(request,"web","goodshape",sWebLanguage)%></b>: <%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_GOODSHAPE", sWebLanguage, true, "", "") %>
			            </td>
			        </tr>
			        <%	if(activePatient.gender.equalsIgnoreCase("f")){ %>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","lastperiod",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_CNTSBLOODGIFT_LASTPERIOD", sWebLanguage, sCONTEXTPATH) %>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","pregnant",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_PREGNANT", sWebLanguage, true, "","") %>
			            </td>
			        </tr>
			        <%	} %>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","std",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_CNTSBLOODGIFT_STD", 40, 2)%>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","sexlast6months",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_SEXLAST6MONTHS", sWebLanguage, true, "","") %>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","multiplesexualpartnerslast3months",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_MULTIPLEPARTNERS", sWebLanguage, true, "","") %>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","preservatives",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_PRESERVATIVES", sWebLanguage, true, "","") %>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","weightloss",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_WEIGHTLOSS", sWebLanguage, true, "","") %>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","skinchange",sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_CNTSBLOODGIFT_SKINCHANGE", sWebLanguage, true, "","") %>
			            </td>
			        </tr>
			        <%-- VITAL SIGNS --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<table width="100%">
			            		<tr>
			            			<td><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b> <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
			            			<td><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b> <input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="calculateBMI();"/> cm</td>
			            			<td><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b> <input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
			            			<td><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b> <input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            		</tr>
			            		<tr>
			            			<td><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b> <input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
			            			<td><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b> <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min</td>
			            			<td><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b> <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
			            		</tr>
			            	</table>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","diseases",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<%=SH.writeDefaultCheckBoxes((TransactionVO)transaction, request, "cnts.bloodgift.diseases", "ITEM_TYPE_CNTSBLOODGIFT_DISEASES", sWebLanguage, true, "onchange='checkCriteria();'")%>
			            </td>
			        </tr>
			        <%-- TEXT FIELDS --%>
			        <tr>
			            <td class="admin" nowrap><%=getTran(request,"Web.Occup","rmh.clinical.history",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_CLINICALHISTORY")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALHISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALHISTORY" property="value"/></textarea>
			            </td>
			            <td class="admin" nowrap><%=getTran(request,"Web.Occup","rmh.clinical.medication",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_MEDICATION")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_MEDICATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_MEDICATION" property="value"/></textarea>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"bloodgift","physical.examination",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_PHYSICALEXAM")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PHYSICALEXAM" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_PHYSICALEXAM" property="value"/></textarea>
			            </td>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.clinical.summary",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_RMH_CLINICALSUMMARY")%> class="text" cols="40" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALSUMMARY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_RMH_CLINICALSUMMARY" property="value"/></textarea>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.final.diagnosis",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <input class="text" type="radio" id='fit' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_FIT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_FIT;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true" ondblclick="this.checked=false"/><%=getTran(request,"web","yes",sWebLanguage) %>
			                <input class="text" type="radio" id='unfit' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_FIT" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_FIT;value=medwan.common.false" property="value" outputString="checked"/> value="medwan.common.false"  ondblclick="this.checked=false"/><%=getTran(request,"web","no",sWebLanguage) %>
			            </td>
			        </tr>
			        <tr class='admin'><td colspan='4'><%=getTran(request,"bloodgift","donation",sWebLanguage) %></td></tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"bloodgift","receptiondate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="hidden" id="receptiondate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEPTIONDATE" property="itemId"/>]>.value"/>
			            	<%=ScreenHelper.writeDateField("cntsreceptiondate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEPTIONDATE"), true, false, sWebLanguage, sCONTEXTPATH,"calculateExpiryDate();")%>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","volume",sWebLanguage)%></td>
			            <td class="admin2">
			                <input class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_VOLUME" property="itemId"/>]>.value" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_VOLUME" property="value"/>"/> ml
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","expirydate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="hidden" id="expirydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_EXPIRYDATE" property="itemId"/>]>.value"/>
			            	<%=ScreenHelper.writeDateField("cntsexpirydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_EXPIRYDATE"), false, true, sWebLanguage, sCONTEXTPATH)%>
			            </td>
			            <td class="admin"><%=getTran(request,"bloodgift","numberofpockets",sWebLanguage)%></td>
			            <td class="admin2">
			            	<select class='text' id="cntspockets" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_POCKETS" property="itemId"/>]>.value">
			            		<option value="1" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_POCKETS;value=1" property="value" outputString="selected"/>>1</option>
			            		<option value="0" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_POCKETS;value=0" property="value" outputString="selected"/>>0</option>
			            	</select>
			            </td>
			        </tr>
			        <!-- Bloedwaarden voor deze gift -->
			        <%
			        	String cntsABO="?",cntsRhesus="?",cntsHIV="?",cntsHBS="?",cntsHCV="?",cntsBW="?";	
			        	RequestedLabAnalysis analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(activePatient.personid), MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO"));
			        	if(analysis!=null) cntsABO=analysis.getResultValue()+" "+analysis.getResultUnit();
			        	analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(activePatient.personid), MedwanQuery.getInstance().getConfigString("cntsRhesusCode","Rh"));
			        	if(analysis!=null) cntsRhesus=analysis.getResultValue()+" "+analysis.getResultUnit();
			        	analysis = RequestedLabAnalysis.getByObjectid(tran.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsHIVCode","HIV"));
			        	if(analysis!=null) cntsHIV=analysis.getResultValue()+" "+analysis.getResultUnit();
			        	analysis = RequestedLabAnalysis.getByObjectid(tran.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsHBSCode","HBS"));
			        	if(analysis!=null) cntsHBS=analysis.getResultValue()+" "+analysis.getResultUnit();
			        	analysis = RequestedLabAnalysis.getByObjectid(tran.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsHCVCode","HCV"));
			        	if(analysis!=null) cntsHCV=analysis.getResultValue()+" "+analysis.getResultUnit();
			        	analysis = RequestedLabAnalysis.getByObjectid(tran.getTransactionId(), MedwanQuery.getInstance().getConfigString("cntsBWCode","BW"));
			        	if(analysis!=null) cntsBW=analysis.getResultValue()+" "+analysis.getResultUnit();
			        %>
		        	<tr>
			            <td class="admin"><%=getTran(request,"bloodgift","labresults",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			            	<table width='100%'>
			            		<tr>
			            			<td class='admin' width='16%'><%=getTranNoLink("cnts","ABO",sWebLanguage) %></td> 
			            			<td class='admin' width='16%'><%=getTranNoLink("cnts","Rhesus",sWebLanguage) %></td> 
			            			<td class='admin' width='16%'><%=getTranNoLink("cnts","HIV",sWebLanguage) %></td> 
			            			<td class='admin' width='16%'><%=getTranNoLink("cnts","HBS",sWebLanguage) %></td> 
			            			<td class='admin' width='16%'><%=getTranNoLink("cnts","HCV",sWebLanguage) %></td> 
			            			<td class='admin'><%=getTranNoLink("cnts","BW",sWebLanguage) %></td> 
			            		</tr>
			            		<tr>
			            			<td class='admin2'><input type='text' id='abo' disabled value='<%=cntsABO %>'/></td> 
			            			<td class='admin2'><input type='text' id='rhesus' disabled value='<%=cntsRhesus %>'/></td> 
			            			<td class='admin2'><input type='text' id='hiv' disabled value='<%=cntsHIV %>'/></td> 
			            			<td class='admin2'><input type='text' id='hbs' disabled value='<%=cntsHBS %>'/></td> 
			            			<td class='admin2'><input type='text' id='hcv' disabled value='<%=cntsHCV %>'/></td> 
			            			<td class='admin2'><input type='text' id='bw' disabled value='<%=cntsBW %>'/></td> 
			            		</tr>
			            	</table>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"lab","comment",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="3">
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_CNTSBLOODGIFT_COMMENT")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTSBLOODGIFT_COMMENT" property="value"/></textarea>
			        </tr>
	            </table>
	        </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.cnts.bloodgift",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
    <%if(tran.getTransactionId()>-1){ %>
     <!-- Show delivered blood products here -->
     <table width='100%'>
     	<tr class='admin'><td colspan="6"><%=getTran(request,"cnts","deliveredbloodproducts",sWebLanguage) %></td></tr>
     	<tr>
     		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","location",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","product",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","pockets",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"cnts","patient",sWebLanguage) %></td>
     		<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
     	</tr>
     	<%
     		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
     		PreparedStatement ps = conn.prepareStatement("select * from OC_BLOODDELIVERIES where OC_BLOODDELIVERY_ID=? order by OC_BLOODDELIVERY_DATE"); 
     		ps.setInt(1,tran.getTransactionId());
     		ResultSet rs = ps.executeQuery();
     		boolean bResults = false;
     		while(rs.next()){
     			bResults=true;
     			out.println("<tr><td class='admin2'>"+ScreenHelper.formatDate(rs.getDate("OC_BLOODDELIVERY_DATE"))+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_LOCATION")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PRODUCT")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_POCKETS")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PATIENTNAME")+", "+rs.getString("OC_BLOODDELIVERY_PATIENTFIRSTNAME")+" - "+ScreenHelper.formatDate(rs.getDate("OC_BLOODDELIVERY_PATIENTDATEOFBIRTH"))+" - "+rs.getString("OC_BLOODDELIVERY_PATIENTGENDER")+"</td>"+
     					"<td class='admin2'>"+rs.getString("OC_BLOODDELIVERY_PATIENTTELEPHONE")+"</td>"+
     					"</tr>");
     		}
     		rs.close();
     		ps.close();
     		conn.close();
     		if(!bResults){
     			out.println("<tr><td colspan='6'>"+getTran(request,"web","none",sWebLanguage)+"</td></tr>");
     		}
     	%>
     </table>
  <%} %>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>

function printBloodgiftLabel(){
	window.open("<c:url value="/healthrecord/createBloodgiftLabelPdf.jsp"/>?transactiondata="+encodeURIComponent(document.getElementById("abo").value+";"+document.getElementById("rhesus").value+";"+document.getElementById("cntsreceptiondate").value+";"+document.getElementById("cntsexpirydate").value+";<%=tran.getTransactionId()%>;"+document.getElementById("cntspockets").value));	
}

function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  if(!bRejected &&  document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  <%-- SUBMIT FORM --%>
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTPORegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function searchService(serviceUidField,serviceNameField){
	 	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField+"&needsvisits=1");
		document.getElementById(serviceNameField).focus();
  }

  function submitForm(){
	  setSessionAttribute('defaultCNTSLocation',document.getElementById('searchServiceUid').value);
	  setSessionAttribute('defaultCNTSCollectionUnit',document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_COLLECTIONUNIT').value);
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_COLLECTIONUNIT').value.length==0){
		  alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
		  document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_COLLECTIONUNIT').focus();
	  }
	  else if(document.getElementById('cntsreceptiondate').value.length>0 && document.getElementById('cntsexpirydate').value==''){
		  alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
		  document.getElementById('cntsexpirydate').focus();
	  }
	  else {
	    transactionForm.saveButton.disabled = true;
	    document.getElementById("receptiondate").value=document.getElementById("cntsreceptiondate").value;
	    document.getElementById("expirydate").value=document.getElementById("cntsexpirydate").value;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
	  }
  }
  
  <%-- CALCULATE BMI --%>
  function calculateBMI(){
    var _BMI = 0;
    var heightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value')[0];
    var weightInput = document.getElementsByName('currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value')[0];

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

  function calculateExpiryDate(){
	  if(document.getElementById('cntsreceptiondate').value.length==10){
		  var d=document.getElementById('cntsreceptiondate').value;
		  var expirydate = new Date(d.substring(6,10),d.substring(3,5)*1-1,d.substring(0,2),0,0,0,0);
		  var day = 24*3600*1000;
		  expirydate.setTime(expirydate.getTime()+<%=MedwanQuery.getInstance().getConfigInt("cntsDefaultBloodExpiryDays",90)%>*day);
		  document.getElementById('cntsexpirydate').value=expirydate.getDate()+"/"+(expirydate.getMonth()+1)+"/"+expirydate.getFullYear();
		  document.getElementById('cntsexpirydate').onblur();
	  }
  }
  
  function verifyPermanentRejection(){
	  if(document.getElementById('rejectioncriteria.1').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
  }
  
  function setOldBloodDonations(){
	  var n = window.prompt('<%=getTranNoLink("web.occup","total-number",sWebLanguage)%>','<%=Pointer.getPointer("oldblooddonations."+activePatient.personid,"0") %>');
	  countBloodDonations(n);
  }
  
  function setSessionAttribute(id,value){
	  var params = "id="+id+"&value="+value;
	  var url = '<c:url value="/system/setSessionAttribute.jsp"/>?ts='+new Date().getTime();
	  new Ajax.Request(url,{
		  	method: "POST",
		    parameters: params,
			onSuccess: function(resp){
		  }
	  });
  }
  
  function countBloodDonations(setVal){
      var params = "";
      if(setVal){
    	  params="setold="+setVal;
      }
	  var url = '<c:url value="/cnts/countBloodDonations.jsp"/>?ts='+new Date().getTime();
	  new Ajax.Request(url,{
		  	method: "POST",
		    parameters: params,
			onSuccess: function(resp){
                var label = eval('('+resp.responseText+')');
				document.getElementById("totalblooddonations").innerHTML = label.total;
				document.getElementById("oldblooddonations").innerHTML = label.old;
		  }
	  });
  }
  
  countBloodDonations();
  calculateBMI();
  <%
  	if(tran.getTransactionId()<0){
  %>
  	document.getElementById('cntsreceptiondate').value='<%=ScreenHelper.formatDate(new java.util.Date())%>';
  	window.setTimeout("calculateExpiryDate();",500);
  <%
  	}
  %>
  
  function checkCriteria(bReset){
	  if(!bReset){
		  document.getElementById('permanentrejection').checked=false;
		  document.getElementById('temporaryrejection').checked=false;
	  }
	  <% if(activePatient.gender.equalsIgnoreCase("m")){%>
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.10').checked=false;
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.10').disabled=true;
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.10').parentElement.style.color='white';
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.11').checked=false;
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.11').disabled=true;
	  	document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.11').parentElement.style.color='white';
	  <% }%>
	  //Last donation check
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_LASTDONATION').value.length=10){
		  var ld = document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_LASTDONATION').value;
		  year=ld.substring(6,10);
		  month=ld.substring(3,5)*1-1;
		  day=ld.substring(0,2);
		  var lastdonation=new Date(year,month,day);
		  var day=24*3600*1000;
		  document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.1').checked=(new Date()-lastdonation)/day<84;
		  document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.1').onclick();
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.1').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.3').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.4').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.5').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.6').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.7').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.8').checked){
		  document.getElementById('permanentrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.9').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.10').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.11').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  if(document.getElementById('ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA.12').checked){
		  document.getElementById('temporaryrejection').checked=true;
	  }
	  var allelements = document.all;
	  for(n=0;n<allelements.length;n++){
		  if(allelements[n].id){
			  if(allelements[n].id.indexOf('ITEM_TYPE_CNTSBLOODGIFT_DISEASES')>-1 && allelements[n].checked){
				  document.getElementById('permanentrejection').checked=true;
				  break;
			  }
		  }
	  }
  }
  checkCriteria();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>