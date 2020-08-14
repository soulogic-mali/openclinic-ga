<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.cataractfollowup","select",activeUser)%>

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
    
    <table  width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="15%">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
            </td>
            <td class="admin2" width="15%">
                <input type="text" id="followupdatefield" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
			<td class="admin" width="30%"/>
			<td class="admin" width="20%"> <%=getTran(request,"web","followuptype",sWebLanguage)%></td>
			<td class="admin2" width="20%"colspan="2"> 
				<select class="text" id="followuptype" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_TYPE" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataractfollowup.type",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_TYPE"),sWebLanguage,false,false) %>
				</select>
			</td>
        </tr>
		<tr>
            <td class="admin" width="15%"><%=getTran(request,"ccbrt.ortho","examiner",sWebLanguage)%>&nbsp;</td>
            <td class="admin2" colspan="2">
				<select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_USER" property="itemId"/>]>.value">
                	<option/>
	            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.examiner",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_USER"),sWebLanguage,false,false) %>
                </select>
            </td>
            <td class="admin"><%=getTran(request,"web","surgerydate",sWebLanguage)%>&nbsp;</td>
            <%
            	java.util.Date dLastCataractSurgery=ScreenHelper.parseDate(MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_SURGERYDATE",((TransactionVO)transaction).getUpdateTime()));
            	long dayInMilliseconds = 24*3600*1000;
            	long weekInMilliseconds = 7*dayInMilliseconds;
            	String sDelay ="";
				
            	if(dLastCataractSurgery!=null){
            		long lDelayInWeeks=(((TransactionVO)transaction).getUpdateTime().getTime()-dLastCataractSurgery.getTime())/weekInMilliseconds;
            		sDelay=ScreenHelper.formatDate(dLastCataractSurgery)+"&nbsp;&nbsp;<i>("+lDelayInWeeks+" "+getTran(request,"web","weeks",sWebLanguage)+")</i>";
            		if(((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_TYPE").trim().length()==0){
	            		if(lDelayInWeeks>=4 && lDelayInWeeks<12){
	            			out.println("<script>document.getElementById('followuptype').value=1;</script>");
	            		}
	            		else if(lDelayInWeeks>=12){
	            			out.println("<script>document.getElementById('followuptype').value=2;</script>");
	            		}
					}
            	}	
            %>
            <td class="admin2" colspan="2"><%=sDelay %></td>
        </tr>
		
		<tr>
   			<td class='admin' colspan='1'></td>
			<td class='admin' colspan='1'><%=getTran(request,"web","RIGHT",sWebLanguage)%></td>
   			<td class='admin' colspan='1'><%=getTran(request,"web","LEFT",sWebLanguage)%></td>
			<td class='admin' colspan='1'></td>
			<td class='admin' colspan='1'><%=getTran(request,"web","RIGHT",sWebLanguage)%></td>
			<td class='admin' colspan='1'><%=getTran(request,"web","LEFT",sWebLanguage)%></td>	
   		</tr>
		<tr>
		<td class='admin' colspan='1'><%=getTran(request,"web","presentingva",sWebLanguage)%></td>
		<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_PRESENTINGVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_PRESENTINGVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_PRESENTINGVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_PRESENTINGVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class='admin' colspan='1'><%=getTran(request,"web","bestcorrectedva",sWebLanguage)%></td>
						
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_BESTCORRECTEDVA_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_BESTCORRECTEDVA_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_BESTCORRECTEDVA_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_BESTCORRECTEDVA_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
		</tr>
		
		
		<tr>
		<td class='admin' colspan='1'><%=getTran(request,"web","refracted",sWebLanguage)%></td>
		<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_REFRACTED_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_REFRACTED_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_REFRACTED_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_REFRACTED_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class='admin' colspan='1'><%=getTran(request,"web","dilated",sWebLanguage)%></td>
						
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DILATED_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DILATED_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DILATED_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.va",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DILATED_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
		</tr>
		
		<tr>
		<td class='admin' colspan='1'><%=getTran(request,"web","iop",sWebLanguage)%></td>
		<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_IOP_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_IOP_RIGHT" property="value"/>" class="text" size="5" >mmHg
			            </td>
						<td class="admin2" colspan="1">
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_IOP_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_IOP_LEFT" property="value"/>" class="text" size="5" >mmHg
			            </td>
						<td class='admin' colspan='1'><%=getTran(request,"web","causeoflowva",sWebLanguage)%></td>
						
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_LOWREASON_RIGHT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lowvareason",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_LOWREASON_RIGHT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
						<td class="admin2" colspan="1">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_LOWREASON_LEFT" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.lowvareason",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_LOWREASON_LEFT"),sWebLanguage,false,false) %>
			                </select>
			            </td>
		</tr>
		
		
		<tr>
			      <td class="admin" colspan="6"><%=getTran(request,"ccbrt.cataract","postoprefraction",sWebLanguage)%></td>
		</tr>
		<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","Right",sWebLanguage)%></td>
			            <td class="admin2" nowrap>
			                <%=getTran(request,"ccbrt.cataract","sph",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='sphright' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_SPH_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_SPH_RIGHT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="1">
			                <%=getTran(request,"ccbrt.cataract","cyl",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='cylright' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_CYL_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_CYL_RIGHT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="1">
			                <%=getTran(request,"ccbrt.cataract","axis",sWebLanguage)%>:
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_AXIS_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_AXIS_RIGHT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="2">
			                <%=getTran(request,"ccbrt.cataract","dse",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='dseright' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DSE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DSE_RIGHT" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
			<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.cataract","Left",sWebLanguage)%></td>
			            <td class="admin2" nowrap>
			                <%=getTran(request,"ccbrt.cataract","sph",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='sphleft' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_SPH_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_SPH_LEFT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="1">
			                <%=getTran(request,"ccbrt.cataract","cyl",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='cylleft' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_CYL_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_CYL_LEFT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="1">
			                <%=getTran(request,"ccbrt.cataract","axis",sWebLanguage)%>:
			                <input type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_AXIS_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_AXIS_LEFT" property="value"/>" class="text" size="5" >
			            </td>
			            <td class="admin2" nowrap colspan="2">
			                <%=getTran(request,"ccbrt.cataract","dse",sWebLanguage)%>:
			                <input onkeyup='calculateDSE();' id='dseleft' type="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DSE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_CATARACT_FOLLOWUP_DSE_LEFT" property="value"/>" class="text" size="5" >
			            </td>
			        </tr>
		<tr>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2" style='vertical-align:top;' colspan="6">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
        <%-- DESCRIPTION --%>
        
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.cataractfollowup",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
function calculateDSE(){
	var target = 0;
	if(document.getElementById('sphright').value.length>0){
		document.getElementById('dseright').value=document.getElementById('sphright').value*1+document.getElementById('cylright').value*1/2-target;
		if(document.getElementById('dseright').value=='NaN'){
			document.getElementById('dse4right').value='';
		}
	}
	if(document.getElementById('sphleft').value.length>0){
		document.getElementById('dseleft').value=document.getElementById('sphleft').value*1+document.getElementById('cylleft').value*1/2-target;
		if(document.getElementById('dseleft').value=='NaN'){
			document.getElementById('dseleft').value='';
		}
	}
}
}
</script>
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
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>    
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>