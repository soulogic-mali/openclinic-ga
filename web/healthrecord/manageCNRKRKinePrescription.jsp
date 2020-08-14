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
	//We now search the most recent CNRKR consultation before this one
	java.util.Date date = ((TransactionVO)transaction).getUpdateTime();
	if(date==null){
		date=new java.util.Date();
	}
	String medTranDate="",medTranInstructions="",medTranDiagnosis="",medTranNumberOfSessions="",medTranFrequency="",medTranDuration="";
	TransactionVO medTran = MedwanQuery.getInstance().getLastTransactionsByTypeBefore(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_CONSULTATION",date);
	if(medTran!=null){
		medTranDate=ScreenHelper.formatDate(medTran.getUpdateTime());
		medTranInstructions="<i>"+ScreenHelper.formatDate(medTran.getUpdateTime())+" ("+MedwanQuery.getInstance().getUserName(medTran.getUser().userId)+")</i>: <b>"+checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_INSTRUCTIONS"))+"</b>";
		medTranDiagnosis="";
		if(checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY")).length()>0){
			medTranDiagnosis+=getTranNoLink("cnrkr.pathology",checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY")),sWebLanguage);
		};
		if(checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2")).length()>0){
			if(medTranDiagnosis.length()>0){
				medTranDiagnosis+="<br/>";
			}
			medTranDiagnosis+=getTranNoLink("cnrkr.pathology",checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY2")),sWebLanguage);
		};
		if(checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3")).length()>0){
			if(medTranDiagnosis.length()>0){
				medTranDiagnosis+="<br/>";
			}
			medTranDiagnosis+=getTranNoLink("cnrkr.pathology",checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY3")),sWebLanguage);
		};
		if(checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4")).length()>0){
			if(medTranDiagnosis.length()>0){
				medTranDiagnosis+="<br/>";
			}
			medTranDiagnosis+=getTranNoLink("cnrkr.pathology",checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PATHOLOGY4")),sWebLanguage);
		};
		medTranNumberOfSessions=checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONS"));
		medTranFrequency=checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FREQUENCY"));
		medTranDuration=checkString(medTran.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONDURATION"));
		java.util.Date nextdate = new java.util.Date();
		TransactionVO medTranNext = MedwanQuery.getInstance().getLastTransactionsByTypeAfter(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_CONSULTATION",date);
		if(medTranNext!=null){
			nextdate=ScreenHelper.endOfDay(medTranNext.getUpdateTime());
		}
		//Now find all follow-up consultations between the two base consultations
		Vector medTranFollowUps = MedwanQuery.getInstance().getTransactionsByTypeBetween(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CNRKR_CONSULTATIONFOLLOWUP",medTran.getUpdateTime(),nextdate);
		for(int n=0;n<medTranFollowUps.size();n++){
			TransactionVO tranFollowUp = (TransactionVO)medTranFollowUps.elementAt(n);
			String s = checkString(tranFollowUp.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY"));
			if(s.length()>0){
				medTranInstructions+="<hr/><i>"+ScreenHelper.formatDate(tranFollowUp.getUpdateTime())+" ("+MedwanQuery.getInstance().getUserName(tranFollowUp.getUser().userId)+")</i>: <b>"+s+"</b>";
			}
		}
	}
%>
<table class="list" cellspacing="1" cellpadding="0" width="100%">
    <tr>
        <td style="vertical-align:top" width="50%">                
            <table class="list" cellspacing="1" cellpadding="0" width="100%">
                <%-- MEDICAL SUMMARY --------------------------------------------------------------------%>
		       <tr class="admin" style="padding:0px;">
		           <td colspan="6"><%=getTran(request,"web","prescriptiondata",sWebLanguage)%></td>
		       </tr>
		       <tr>
		           <td class="admin" rowspan='3'><%=getTran(request,"web","prescription",sWebLanguage)%></td>
		           <td class="admin2"><%=getTran(request,"web","date",sWebLanguage)%></td>
		           <td class="admin2"><b><%=medTranDate%></b></td>
		           <td class="admin2"><%=getTran(request,"web","diagnosis",sWebLanguage)%></td>
		           <td class="admin2" colspan='2'><b><%=medTranDiagnosis %></b></td>
		       </tr>
		       <tr>
		           <td class="admin2"><%=getTran(request,"web.occup","localisation",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_LOCATION")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_LOCATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_LOCATION" property="value"/></textarea>
		           </td>
		           <td class="admin2">
		           		<%=getTran(request,"web","numberofsessions",sWebLanguage)%>: <b><%=medTranNumberOfSessions %></b>
		           	</td>
		           <td class="admin2">
		           		<%=getTran(request,"web","frequency",sWebLanguage)%>: <b><%=getTranNoLink("cnrkr.frequency",medTranFrequency,sWebLanguage) %></b>
		           </td>
		           <td class="admin2">
		           		<%=getTran(request,"web.occup","duration",sWebLanguage)%>: <b><%=getTranNoLink("cnrkr.sessionduration",medTranDuration,sWebLanguage) %></b>
		           	</td>
		       </tr>
		       <tr>
		           <td class="admin2"><%=getTran(request,"web","instructions",sWebLanguage)%></td>
		           <td class="admin2" colspan='4'><%=medTranInstructions %></td>
		       </tr>
		       <tr class="admin" style="padding:0px;">
		           <td colspan="6"><%=getTran(request,"web","surgery",sWebLanguage)%></td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","date",sWebLanguage)%></td>
		           <td class="admin2" colspan='5'>
		            	<input type="hidden" id="surgerydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_SURGERYDATE" property="itemId"/>]>.value"/>
						<%=ScreenHelper.writeDateField("sdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_SURGERYDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%></td>
		           <td class="admin2" colspan='5'>
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_SURGERY")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_SURGERY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_SURGERY" property="value"/></textarea>
		           </td>
		       </tr>
        </table>
 	</td>
 </tr>
</table>
</logic:present>
