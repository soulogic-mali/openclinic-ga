<%@ page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.patientcreditrequest","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    <%
	    String sMailTo = MedwanQuery.getInstance().getConfigString("patientCreditRequestMailAddress","");
    	Encounter encounter = Encounter.getActiveEncounterOnDate(new Timestamp(((TransactionVO)transaction).getUpdateTime().getTime()),activePatient.personid);
    	if(encounter!=null && encounter.getLastEncounterService()!=null){
    		Service service = Service.getService(encounter.getLastEncounterService().serviceUID);
    		while(service !=null){
    			if(service.contactemail!=null && service.contactemail.length()>0){
    				sMailTo=service.contactemail;
    				break;
    			}
    			else if(service.parentcode!=null && service.parentcode.length()>0){
    				service=Service.getService(service.parentcode);
    			}
    			else {
    				service=null;
    			}
    		}
    	}
    %>
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

        <%-- DESCRIPTION --%>
        <tr>
        	<td colspan="2">
	        	<table width='100%'>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","criteria",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6"><table width='100%'>
			            	<%
			            		String activecriteria=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_CRITERIA");
			            		Hashtable labels=MedwanQuery.getInstance().getLabels();
			            		Hashtable hLang=(Hashtable)labels.get(sWebLanguage.toLowerCase());
			            		if(hLang!=null){
			            			Hashtable values = (Hashtable)hLang.get("patientcreditcriteria");
				            		if(values!=null){
				            			Enumeration e = values.keys();
				            			while(e.hasMoreElements()){
				            				String id = (String)e.nextElement();
				            				out.println("<tr><td><input name='criteria."+id+"' type='checkbox' "+(("*"+activecriteria+"*").indexOf("*"+id+"*")>-1?"checked":"")+"/>"+getTran(request,"patientcreditcriteria",id,sWebLanguage)+"</td></tr>");
				            			}
				            		}
			            		}
			            	%>
			            	</table>
			                <input type='hidden' id="criteria" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_CRITERIA" property="itemId"/>]>.value"/>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","required.credit.amount",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <input class="text" type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_AMOUNT" property="itemId"/>]>.value" size="10" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_AMOUNT" property="value"/>"/>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="6">
			               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" <%=setRightClick(session,"ITEM_TYPE_PATIENTCREDITREQUEST_COMMENT")%> class="text" cols="50" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_COMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PATIENTCREDITREQUEST_COMMENT" property="value"/></textarea>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","sendmailto",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="6">
							<%=sMailTo %>
			            </td>
			        </tr>
	            </table>
	        </td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.patientcreditrequest",sWebLanguage)%>
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

  <%-- SUBMIT FORM --%>
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTPORegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
	    transactionForm.saveButton.disabled = true;
	    document.getElementById('criteria').value="*";
	    for(n=0;n<document.all.length;n++){
	    	var el = document.all[n];
	    	if(el.name && el.name.indexOf("criteria.")>-1 && el.checked){
	    		document.getElementById('criteria').value+=el.name.replace("criteria.","")+"*";
	    	}
	    }
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>