<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.ophtalmologyConsultation","select",activeUser)%>

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
            <td colspan='2' class="admin" width="<%=sTDAdminWidth%>">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <%-- DESCRIPTION --%>
        <tr>
        	<td width="60%">
	        	<table width='100%'>
	        		 <tr>
	           			<%
	           				//Find last optometric examination
	           				TransactionVO optometry = MedwanQuery.getInstance().getLastTransactionByType(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_CCBRT_OPTOMETRIST_EXAMINATION");
	           			%>
			            <td class="admin"><%=getTran(request,"ccbrt.va","va",sWebLanguage)+(optometry!=null?"<br/><b>("+ScreenHelper.formatDate(optometry.getUpdateTime())+")</b>":"")%>&nbsp;</td>
			            <td class="admin2" colspan="6"> 
			            	<table width='100%'>
		            			<%
		            				if(optometry!=null){
		            					String sUrl="javascript:window.open(\""+sCONTEXTPATH+"/healthrecord/viewTransaction.jsp?Page=healthrecord/manageCCBRTOptometristExamination.jsp&be.mxs.healthrecord.createTransaction.transactionType="+optometry.getTransactionType()+"&be.mxs.healthrecord.transaction_id="+optometry.getTransactionId()+"&be.mxs.healthrecord.server_id="+optometry.getServerId()+"&useTemplate=no&ts="+getTs()+"&NoBackButton=true\",\"View\",\"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600,menubar=no\")";
		            			%>
			            		<tr>
			            			<td width='1%' nowrap><%=getTran(request,"ccbrt.eye","right",sWebLanguage)%>&nbsp;</td>
			            			<td><b><%=getTran(request,"ccbrt.va.lr",optometry.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_RIGHT"),sWebLanguage) %></b></td>
			            			<td width='1%' nowrap><%=getTran(request,"ccbrt.eye","left",sWebLanguage)%>&nbsp;</td>
			            			<td><b><%=getTran(request,"ccbrt.va.lr",optometry.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_VA_LEFT"),sWebLanguage) %></b></td>
			            			<td width='1%' nowrap><%=getTran(request,"ccbrt.eye","dil",sWebLanguage)%> <%=getTran(request,"ccbrt.eye","right",sWebLanguage)%>&nbsp;</td>
				            		<td><b><%=getTran(request,"web",optometry.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_RIGHT").length()>0?"yes":"no",sWebLanguage) %></b></td>
			            			<td width='1%' nowrap><%=getTran(request,"ccbrt.eye","dil",sWebLanguage)%> <%=getTran(request,"ccbrt.eye","left",sWebLanguage)%>&nbsp;</td>
				            		<td><b><%=getTran(request,"web",optometry.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_DIL_LEFT").length()>0?"yes":"no",sWebLanguage) %></b></td>
			            		</tr>
			            		<tr>
			            			<td colspan='8'>
			            				<a href='<%=sUrl%>'><%=getTran(request,"web.occup",optometry.getTransactionType(),sWebLanguage) %></a>
			            			</td>
			            		</tr>
			            		<%	}%>
			            	</table>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.eye","from",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="from" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_FROM" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.eye.from",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_FROM"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
			        
			        <tr>
			            <td class="admin">
			                <%=getTran(request,"ccbrt.eye","attendencytype",sWebLanguage)%>
			            </td>
			            <td class="admin2" colspan="6">
			                <select id="attendencytype" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_ATTENDENCYTYPE" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.attendencytype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_ATTENDENCYTYPE"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin" rowspan="1"><%=getTran(request,"web","history",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6"><textarea <%=setRightClickMini("ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_HISTORY")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="60" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_HISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_HISTORY" translate="false" property="value"/></textarea></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.va","allergies",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			                <select id="vaassessment" class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_ALLERGIES" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.allergies",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_ALLERGIES"),sWebLanguage,false,true) %>
			                </select>
			            </td>
			        </tr>
			        <!- DRAWING ITEM-->
			        <tr>
			            <td class="admin" style='vertical-align: top' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","drawing",sWebLanguage) %> <img src='<%=sCONTEXTPATH%>/_img/icons/icon_minus.png' onclick='document.getElementById("drawing").style.display="none";'/> <img src='<%=sCONTEXTPATH%>/_img/icons/icon_plus.png' onclick='document.getElementById("drawing").style.display="";'/></td>
			        	<td class='admin2' colspan='6'>
			        		<div id='drawing' style='display: <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING").length()>0?"":"none"%>'>
								<%=ScreenHelper.createDrawingDiv(request, "canvasDiv", "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING", transaction,MedwanQuery.getInstance().getConfigString("defaultEyeDiagram","/_img/eyes.png"),"eyes.image") %>
							</div>
			        	</td>
			        </tr>
			        <tr>
			            <td class="admin" rowspan="1"><%=getTran(request,"web","observation",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6"><textarea <%=setRightClickMini("ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_OBSERVATION")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="60" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_OBSERVATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_OBSERVATION" translate="false" property="value"/></textarea></td>
			        </tr>
			          <tr>
			            <td class="admin" rowspan="1"><%=getTran(request,"web","conclusions",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6"><textarea <%=setRightClickMini("ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_CONCLUSION")%> onKeyup="this.value=this.value.toUpperCase();resizeTextarea(this,10);" id="complaints_comment" class="text" cols="60" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_CONCLUSION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OPTOMETRIST_COMPLAINTS_COMMENT" translate="false" property="value"/></textarea></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.va","examiner",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="6">
			            	<%
			            		ItemVO item = ((TransactionVO)transaction).getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_USER");
			            		String userid="";
			            		if(item!=null){
			            			userid=item.getValue();
			            		}
			            		
			            	%>
			                <input type="hidden" id="ccbrtuser" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_OPHTALMOLOGYCONSULTATION_USER" property="itemId"/>]>.value"/>
			                <input type="hidden" name="diagnosisUser" id="diagnosisUser" value="<%=userid%>">
			                <input class="text" type="text" name="diagnosisUserName" id="diagnosisUserName" readonly size="40" value="<%=User.getFullUserName(userid)%>">
			                <img src="<c:url value="/_img/icons/icon_search.gif"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('diagnosisUser','diagnosisUserName');">
			                <img src="<c:url value="/_img/icons/icon_delete.gif"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('diagnosisUser').value='';document.getElementById('diagnosisUserName').value='';">
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"ccbrt.va","followup",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="4">
			            	<select class='text' id='frequency' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='1'>1</option>
			            		<option value='2'>2</option>
			            		<option value='3'>3</option>
			            		<option value='4'>4</option>
			            		<option value='5'>5</option>
			            		<option value='6'>6</option>
			            		<option value='7'>7</option>
			            		<option value='8'>8</option>
			            		<option value='9'>9</option>
			            		<option value='10'>10</option>
			            		<option value='11'>11</option>
			            		<option value='12'>12</option>
			            	</select>
			            	<select class='text' id='frequencytype' onchange='calculateNextDate()'>
			            		<option/>
			            		<option value='week'><%=getTran(request,"web","weeks",sWebLanguage) %></option>
			            		<option value='month'><%=getTran(request,"web","months",sWebLanguage) %></option>
			            		<option value='year'><%=getTran(request,"web","year",sWebLanguage) %></option>
			            	</select>
			                <input type="hidden" id="ccbrtdate" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_EYE_REGISTRY_VAFOLLOWUPDATE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("vafollowupdate", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CCBRT_EYE_REGISTRY_VAFOLLOWUPDATE"), false, true, sWebLanguage, sCONTEXTPATH))%>
			            </td>
			            <td class="admin2" colspan="2">
			            	<a href="javascript:openPopup('planning/findPlanning.jsp&isPopup=1&FindDate='+document.getElementById('vafollowupdate').value+'&FindUserUID='+document.getElementById('diagnosisUser').value,1024,600,'Agenda','toolbar=no,status=yes,scrollbars=no,resizable=yes,width=1024,height=600,menubar=no');void(0);"><%=getTran(request,"web","findappointment",sWebLanguage) %></a>
			            </td>
			        </tr>
			        
			        
	            </table>
	        </td>
	        <%-- DIAGNOSES --%>
	    	<td class="admin2" style='vertical-align: top'>
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.ophtalmologyConsultation",sWebLanguage)%>
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
  function calculateNextDate(){
	  var nextdate = new Date();
	  if(document.getElementById('frequencytype').value.length>0 && document.getElementById('frequency').value.length>0){
		  if(document.getElementById('frequencytype').value=='month'){
			  nextdate.setMonth(nextdate.getMonth()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='year'){
			  nextdate.setYear(nextdate.getFullYear()+document.getElementById('frequency').value*1);
		  }
		  else if(document.getElementById('frequencytype').value=='week'){
			  nextdate.setDate(nextdate.getDate()+document.getElementById('frequency').value*7);
		  }
		  document.getElementById('vafollowupdate').value=("0"+nextdate.getDate()).substring(("0"+nextdate.getDate()).length-2,("0"+nextdate.getDate()).length)+"/"+("0"+(nextdate.getMonth()+1)).substring(("0"+(nextdate.getMonth()+1)).length-2,("0"+(nextdate.getMonth()+1)).length)+"/"+nextdate.getFullYear();
  	 }
  }
  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
		if(document.getElementById("drawing").style.display=='none'){
	    	document.getElementById("canvasDivDrawing").value='';
	    }

	  document.getElementById("ccbrtuser").value=document.getElementById("diagnosisUser").value;
	  document.getElementById("ccbrtdate").value=document.getElementById("vafollowupdate").value;
	    <%
	        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	    %>
  	
	  
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>