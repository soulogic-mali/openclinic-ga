<%@ page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.poregistry","select",activeUser)%>

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
			                <select id="from" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_FROM" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.eye.from",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_FROM"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.physio","visittype",sWebLanguage)%>*&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="visittype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_VISITTYPE" property="itemId"/>]>.value">
				            	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.po.visittype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_VISITTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","prescription",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="prescription" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_PRESCRIPTION" property="itemId"/>]>.value">
			                	<option/>
								<%
									Vector prestations = Prestation.searchActivePrestations("", "", MedwanQuery.getInstance().getConfigString("prosthesisPrestationType","7"), "");
									for(int n=0;n<prestations.size();n++){
										Prestation prestation = (Prestation)prestations.elementAt(n);
										out.println("<option value='"+prestation.getCode()+"'"+(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_PRESCRIPTION").equalsIgnoreCase(prestation.getCode())?" selected":"")+">"+prestation.getDescription()+"</option>");
									}
								%>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","measuredate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <input type="hidden" id="ccbrtmeasuredate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_MEASUREDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("measuredate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_MEASUREDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","fittingdate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <input type="hidden" id="ccbrtfittingdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_FITTINGDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("fittingdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_FITTINGDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","technician",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			            	<%
			            		ItemVO item = ((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_TECHNICIAN");
			            		String userid="";
			            		if(item!=null){
			            			userid=item.getValue();
			            		}
			            		
			            	%>
			                <input type="hidden" id="ccbrtuser" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_TECHNICIAN" property="itemId"/>]>.value"/>
			                <input type="hidden" name="diagnosisUser" id="diagnosisUser" value="<%=userid%>">
			                <input class="text" type="text" name="diagnosisUserName" id="diagnosisUserName" readonly size="40" value="<%=User.getFullUserName(userid)%>">
			                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('diagnosisUser','diagnosisUserName');">
			                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('diagnosisUser').value='';document.getElementById('diagnosisUserName').value='';">
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","deliverydate",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <input type="hidden" id="ccbrtdeliverydate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_DELIVERYDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("deliverydate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_DELIVERYDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.po","other",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_AMPUTATIONS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_AMPUTATIONS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","amputations",sWebLanguage) %>
						</td>			            
			            <td class="admin2">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_ORTHOSIS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_ORTHOSIS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","orthosis",sWebLanguage) %>
						</td>			            
			            <td class="admin2" colspan="4">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_MINING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_MINING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","mining",sWebLanguage) %>			            
						</td>	
					</tr>
					<tr>		            
			            <td class="admin"><%=getTran(request,"ccbrt.po","accessto",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_SPORTS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_SPORTS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","sportsaccess",sWebLanguage) %>			            
						</td>			            
			            <td class="admin2">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_ECONOMICPROGRAMS" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_ECONOMICPROGRAMS;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","economicprogramsaccess",sWebLanguage) %>			            
						</td>			            
			            <td class="admin2">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_VOCATIONALTRAINING" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_VOCATIONALTRAINING;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","vocationaltrainingaccess",sWebLanguage) %>			            
						</td>			            
			            <td class="admin2" colspan="3">
							<input type="checkbox" class="hand" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_EDUCATION" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_PO_REGISTRY_EDUCATION;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"web","educationaccess",sWebLanguage) %>			            
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
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.poregistry",sWebLanguage)%>
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
	  if(document.getElementById('visittype').value==''){
		  alert('<%=getTranNoLink("web","somedataismissing",sWebLanguage)%>');
	  }
	  else {
		  document.getElementById("ccbrtuser").value=document.getElementById("diagnosisUser").value;
		  document.getElementById("ccbrtmeasuredate").value=document.getElementById("measuredate").value;
		  document.getElementById("ccbrtfittingdate").value=document.getElementById("fittingdate").value;
		  document.getElementById("ccbrtdeliverydate").value=document.getElementById("deliverydate").value;
	    transactionForm.saveButton.disabled = true;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
	  }	    
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>