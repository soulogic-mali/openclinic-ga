<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.*,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                java.util.*" %>
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
<input type='hidden' id='evaluations' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_EVALUATIONS" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_EVALUATIONS" property="value"/>'/>

<table class="list" cellspacing="1" cellpadding="0" width="100%">
    <tr class="admin" style="padding:0px;">
        <td colspan="7"><%=getTran(request,"web","evaluations",sWebLanguage)%></td>
    </tr>
	<tr>
		<td colspan='7'>
			<div id='divEvaluations'/>
		</td>
	</tr>
    <tr class="admin" style="padding:0px;">
        <td colspan="7"><%=getTran(request,"web","finalreport",sWebLanguage)%></td>
    </tr>
    <tr>
        <td class="admin" colspan='2'><%=getTran(request,"web","closingdate",sWebLanguage)%></td>
	    <td class="admin2">
	        <input type="hidden" id="closingdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGDATE" property="itemId"/>]>.value"/>
			<%=ScreenHelper.writeDateField("cdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
	    </td>
        <td class="admin"><%=getTran(request,"web","reportingdate",sWebLanguage)%></td>
	    <td class="admin2" colspan='3'>
	        <input type="hidden" id="reportingdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_REPORTINGDATE" property="itemId"/>]>.value"/>
			<%=ScreenHelper.writeDateField("rdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_REPORTINGDATE"), true, false, sWebLanguage, sCONTEXTPATH)%>
	    </td>
    </tr>
    <tr>
        <td class="admin" colspan='2'><%=getTran(request,"web","numberofsessions",sWebLanguage)%></td>
        <td class="admin2" colspan='5'>
            <div id='totalnumberofsessions'/>
        </td>
    </tr>
	<tr>
		<td class='admin' colspan='2'><%=getTran(request,"web","outcome",sWebLanguage) %></td>
		<td class='admin2' colspan='5'>
			<select class='text' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_REPORTOUTCOME" property="itemId"/>]>.value"' id='reportoutcome'>
				<option/>
				<%=ScreenHelper.writeSelect(request, "kine.outcome", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_REPORTOUTCOME"), sWebLanguage, false) %>
			</select>
		</td>
	</tr>
    <tr>
        <td class="admin" colspan='2'><%=getTran(request,"web","closingreason",sWebLanguage)%></td>
        <td class="admin2" colspan='5'>
            <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_CLOSINGREASON")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGREASON" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_CLOSINGREASON" property="value"/></textarea>
        </td>
    </tr>
    <tr>
        <td class="admin" colspan='2'><%=getTran(request,"web","aftercare",sWebLanguage)%></td>
        <td class="admin2" colspan='5'>
            <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_AFTERCARE")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_AFTERCARE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_AFTERCARE" property="value"/></textarea>
        </td>
    </tr>
    <tr>
        <td class="admin" colspan='2'><%=getTran(request,"web","proposedcontinuation",sWebLanguage)%></td>
        <td class="admin2" colspan='5'>
            <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_PROPOSEDCONTINUATION")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PROPOSEDCONTINUATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_PROPOSEDCONTINUATION" property="value"/></textarea>
        </td>
    </tr>
</table>

<script>
	function addEvaluation(date,objectives,functional,comment,sessions,outcome){
		if(document.getElementById('evaluations').value.length>0){
			document.getElementById('evaluations').value+="£";
		}
		document.getElementById('evaluations').value += date+";"+objectives+";"+functional+";"+comment+";"+sessions+";"+outcome;
		writeEvaluations();
	}
	function deleteEvaluation(row){
	    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
			var evaluations = document.getElementById('evaluations').value.split("£");
			for(n=0;n<evaluations.length;n++){
				if(n==row){
					if(n>0){
						document.getElementById('evaluations').value= document.getElementById('evaluations').value.replace('£'+evaluations[n],'');
					}
					else if (evaluations.length>1){
						document.getElementById('evaluations').value= document.getElementById('evaluations').value.replace(evaluations[n]+'£','');
					}
					else{
						document.getElementById('evaluations').value= document.getElementById('evaluations').value.replace(evaluations[n],'');
					}
				}
			}
			writeEvaluations();
	    }
	}
	function editEvaluation(row,date,objectives,functional,comment,sessions,outcome){
		var newEvaluations="";
		var evaluations = document.getElementById('evaluations').value.split("£");
		for(n=0;n<evaluations.length;n++){
			if(n>0){
				newEvaluations+="£";
			}
			if(n==row){
				newEvaluations+= date+";"+objectives+";"+functional+";"+comment+";"+sessions+";"+outcome;
			}
			else{
				newEvaluations+= evaluations[n];
			}
		}
		document.getElementById('evaluations').value = newEvaluations;
		writeEvaluations();
	}
	function writeEvaluations(){
		while(document.getElementById('evaluations').value.indexOf("\n")>-1){
			document.getElementById('evaluations').value=document.getElementById('evaluations').value.replace("\n","<BR/>");
		}
		//Show all the evaluations in tabular format on the form
		//Ajax to be able to translate
		document.getElementById("divEvaluations").innerHTML="";
	    var today = new Date();
	    var url= '<c:url value="/healthrecord/getKineEvaluations.jsp"/>?language=<%=sWebLanguage%>&evaluations='+document.getElementById('evaluations').value+'&ts='+today;
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: "",
	      onSuccess: function(resp){
	    	  document.getElementById("divEvaluations").innerHTML=resp.responseText;
	    	  var totalsessions=0;
	    	  for(n=0;n<document.getElementById('evaluations').value.split("£").length;n++){
	    		  totalsessions+=document.getElementById('evaluations').value.split("£")[n].split(";")[4]*1;
	    	  }
	    	  document.getElementById('totalnumberofsessions').innerHTML="<b>"+totalsessions+"</b>";
	      }
		});
	}
	function addEvaluationLine(){
	  openPopup("/healthrecord/editKineEvaluation.jsp&PopupWidth=500&new=true&language=<%=sWebLanguage%>");
	}
	function editEvaluationLine(row){
		var evaluations = document.getElementById('evaluations').value.split("£");
		for(n=0;n<evaluations.length;n++){
			if(n==row){
				var date = evaluations[n].split(";")[0];
				var objectives = evaluations[n].split(";")[1];
				var functional = evaluations[n].split(";")[2];
				var comment = evaluations[n].split(";")[3];
				var sessions = evaluations[n].split(";")[4];
				var outcome = evaluations[n].split(";")[5];
				openPopup("/healthrecord/editKineEvaluation.jsp&PopupWidth=500&new=false&language=<%=sWebLanguage%>&row="+row+"&date="+date+"&objectives="+objectives+"&functional="+functional+"&comment="+comment+"&sessions="+sessions+"&outcome="+outcome);
				break;
			}
		}
	}
	writeEvaluations();
</script>

</logic:present>
