<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.physioregistry","select",activeUser)%>

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
        	<td width="50%">
	        	<table width='100%'>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","from",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="from" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_FROM" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.physio.from",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_FROM"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","activities",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <select id="activities" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_ACTIVITIES" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.physio.activities",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_ACTIVITIES"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","visittype",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="2">
			                <select id="visittype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_VISITTYPE" property="itemId"/>]>.value">
				            	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.physio.details",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_VISITTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","staff",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			            	<%
			            		ItemVO item = ((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_USER");
			            		String userid="";
			            		if(item!=null){
			            			userid=item.getValue();
			            		}
			            		
			            	%>
			                <input type="hidden" id="ccbrtuser" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_USER" property="itemId"/>]>.value"/>
			                <input type="hidden" name="diagnosisUser" id="diagnosisUser" value="<%=userid%>">
			                <input class="text" type="text" name="diagnosisUserName" id="diagnosisUserName" readonly size="40" value="<%=User.getFullUserName(userid)%>">
			                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('diagnosisUser','diagnosisUserName');">
			                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('diagnosisUser').value='';document.getElementById('diagnosisUserName').value='';">
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","status",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="3">
			                <select id="status" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_STATUS" property="itemId"/>]>.value">
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.physio.status",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_STATUS"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","statusdetails",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="2">
			                <select id="statusdetails" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_STATUSDETAILS" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.physio.statusdetails",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_STATUSDETAILS"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","referral",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
							<%
								String serviceid=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_REFERRAL");
								String servicename="";
								Service service = Service.getService(serviceid);
								if(service!=null){
									servicename=service.getLabel(sWebLanguage);
								}
							%>
							<input type='hidden' id="ccbrtreferral" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_REFERRAL" property="itemId"/>]>.value" value="<%=serviceid%>"/>
							<input type='hidden' id="referral" name="referral" value="<%=serviceid%>">
							<input class='text' type='text' name='referralname' id='referralname' readonly size='40' value="<%=servicename %>">
							<img src='<c:url value="/_img/icons/icon_search.png"/>' class='link' alt='<%=getTranNoLink("Web","select",sWebLanguage)%>' onclick='searchService("referral","referralname");'>				            
							<img src='<c:url value="/_img/icons/icon_delete.png"/>' class='link' alt='<%=getTranNoLink("Web","clear",sWebLanguage)%>' onclick='document.getElementById("referral").value="";document.getElementById("referralname").value="";'>				            
						</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","nextvisit",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="4">
			                <input type="hidden" id="ccbrtfollowupdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_FOLLOWUPDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("followupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PHYSIO_REGISTRY_FOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			            <td class="admin2" colspan="2">
			            	<a href="javascript:openPopup('planning/findPlanning.jsp&FindDate='+document.getElementById('followupdate').value+'&isPopup=1&FindUserUID='+document.getElementById('diagnosisUser').value,1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
			            </td>
			        </tr>
	            </table>
	        </td>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.physioregistry",sWebLanguage)%>
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
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTPhysioRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }
	function searchService(serviceUidField,serviceNameField){
	    openPopup("_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	    document.getElementsByName(serviceNameField)[0].focus();
	}

  function submitForm(){
	  if(document.getElementById('visittype').value==''){
		  alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
	  }
	  else {
		  document.getElementById("ccbrtuser").value=document.getElementById("diagnosisUser").value;
		  document.getElementById("ccbrtfollowupdate").value=document.getElementById("followupdate").value;
		  document.getElementById("ccbrtreferral").value=document.getElementById("referral").value;
	    transactionForm.saveButton.disabled = true;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  	}
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>