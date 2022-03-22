<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"msas.registry.healthychildren","select",activeUser)%>

<%!
	String writeVaccination(HttpServletRequest request,TransactionVO transaction,String vaccine, int minage,int maxage,String language, AdminPerson activePatient){
		String s="";
		if(activePatient.getAgeInMonthsOnDate(transaction.getUpdateTime())>=minage && activePatient.getAgeInMonthsOnDate(transaction.getUpdateTime())<maxage){
			s+="<td class='admin' width='1%' nowrap>"+vaccine.toUpperCase()+"&nbsp;&nbsp;</td><td class='admin2'>";
			s+=SH.writeDefaultSelect(request, transaction, "ITEM_TYPE_VACCINE_"+vaccine.toUpperCase(), "msas.vaccination."+vaccine, language, "");
			s+="</td>";
		}
		return s;
	}
%>

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
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr>
        	<td valign='top'>
	        	<table width='100%'>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "mothername", sWebLanguage)%></td>
			            <td colspan="3" class="admin2">
			                <textarea rows="1" onKeyup="resizeTextarea(this,10);" class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CONSPED_MOTHERNAME" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_MSAS_CONSPED_MOTHERNAME" property="value"/></textarea>
			            </td>
			        </tr>
			        <tr class='admin'><td colspan="4"><%=getTran(request,"web","vaccination",sWebLanguage) %></td></tr>
			        <tr>
			        	<td colspan='2'>
			        		<table width='100%'>
						        <tr class='admin'><td colspan='18'><%=getTran(request,"web","vaccinations",sWebLanguage) %></td></tr>
						        <tr>
							        <%=writeVaccination(request, (TransactionVO)transaction, "hepb", 0, 2, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "bcg", 0, 4, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "vpo", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "vpi", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "penta", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "pneumo", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "rota", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "rr", 0, 25, sWebLanguage,activePatient) %>
							        <%=writeVaccination(request, (TransactionVO)transaction, "vaa", 0, 60, sWebLanguage,activePatient) %>
						        </tr>
			        		</table>
			        	</td>
			        </tr>
			        <tr class='admin'><td colspan="4"><%=getTran(request,"web","screening",sWebLanguage) %></td></tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","oedema",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan='3'>
			            	<%=SH.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_OEDEMA", sWebLanguage, false, "", "") %>
			            </td>
					</tr>			       	
					<tr>
						<td class='admin2' colspan='4'><%writeVitalSigns(pageContext); %></td>
					</tr>	
					<tr>
						<td class='admin'><%=getTran(request,"web","other",sWebLanguage) %></td>
						<td class='admin2'><%=SH.writeDefaultCheckBoxes((TransactionVO)transaction,request,"msas.healthychildren.other","ITEM_TYPE_HEALTHYCHILDREN_OTHER",sWebLanguage,true) %></td>
					</tr>		       
					<tr>
						<td class='admin'><%=getTran(request,"web","nutrition",sWebLanguage) %></td>
						<td class='admin2'><%=SH.writeDefaultRadioButtons((TransactionVO)transaction,request,"msas.healthychildren.nutrition","ITEM_TYPE_HEALTHYCHILDREN_NUTRITION",sWebLanguage,true,"","") %></td>
					</tr>		
					<tr>
						<td class='admin'><%=getTran(request,"web","observation",sWebLanguage) %></td>
			            <td colspan="3" class="admin2">
			                <%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEALTHYCHILDREN_OBSERVATION", 50, 1) %>
			            </td>
					</tr>       
	            </table>
	        </td>
        </tr>
        <tr>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"msas.registry.healthychildren",sWebLanguage)%>
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

  	<% if(activePatient.getAgeInMonthsOnDate(((TransactionVO)transaction).getUpdateTime())<7){%>
  		document.getElementById("ITEM_TYPE_HEALTHYCHILDREN_OTHER.1").disabled=true;
	<% }%>
	<% if(activePatient.getAgeInMonthsOnDate(((TransactionVO)transaction).getUpdateTime())<13){%>
		document.getElementById("ITEM_TYPE_HEALTHYCHILDREN_OTHER.2").disabled=true;
	<% }%>
	<% if(activePatient.getAgeInMonthsOnDate(((TransactionVO)transaction).getUpdateTime())>6){%>
		document.getElementById("ITEM_TYPE_HEALTHYCHILDREN_NUTRITION.1").disabled=true;
	<% }%>
	<% if(activePatient.getAgeInMonthsOnDate(((TransactionVO)transaction).getUpdateTime())>24){%>
		document.getElementById("ITEM_TYPE_HEALTHYCHILDREN_NUTRITION.2").disabled=true;
	<% }%>
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>