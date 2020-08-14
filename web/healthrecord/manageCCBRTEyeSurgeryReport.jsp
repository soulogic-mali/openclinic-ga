<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"occup.ccbrt.eyesurgery","select",activeUser)%>

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

        <%-- DESCRIPTION --%>
        <tr>
        	<td width="50%" valign='top'>
	        	<table width='100%'>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","starthour",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" id="beginHourSelect" onchange="calculateDuration();">
			                    <option/>
			                    <%for(int i = 0; i < 24; i++){%>
			                    <option value="<%=i%>"><%=i%></option>
			                <%}%>
			                </select> :
			                <select class="text" id="beginMinutSelect" onchange="calculateDuration();">
			                    <option value="00" selected="selected">00</option>
			                    <%
			                    	for(int n=1;n<60;n++){
			                    		String time = ""+n;
			                    		if(n<10){
			                    			time="0"+n;
			                    		}
			                    		out.println("<option value='"+time+"'>"+time+"</option>");
			                    	}
			                    %>
			                </select>
			                <input id="ITEM_TYPE_EYESURGERY_STARTHOUR" type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_STARTHOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_STARTHOUR" property="value"/>"/>
							<script>
							    var setBeginHourIntSelect = function(){
							
							        var hours = $("beginHourSelect").options;
							        var min = $("beginMinutSelect").options;
							        var hourToTest = parseInt($("ITEM_TYPE_EYESURGERY_STARTHOUR").value.split(":")[0]);
							
							        var minToTest = parseInt($("ITEM_TYPE_EYESURGERY_STARTHOUR").value.split(":")[1]);
							        for(var i=0;i<hours.length;i++){
							           if(hours[i].value==hourToTest){
							                $("beginHourSelect").selectedIndex = i;
							               break;
							            }
							        }
							        for(var i=0;i<min.length;i++){
							           if(min[i].value==minToTest){
							               $("beginMinutSelect").selectedIndex = i;
							               break;
							            }
							        }
							    }
							    setBeginHourIntSelect();
							</script>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","endhour",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" id="endHourSelect" onchange="calculateDuration();">
			                    <option/>
			                    <%for(int i = 0; i < 24; i++){%>
			                    <option value="<%=i%>"><%=i%></option>
			                <%}%>
			                </select> :
			                <select class="text" id="endMinutSelect" onchange="calculateDuration();">
			                    <option value="00" selected="selected">00</option>
			                    <%
			                    	for(int n=1;n<60;n++){
			                    		String time = ""+n;
			                    		if(n<10){
			                    			time="0"+n;
			                    		}
			                    		out.println("<option value='"+time+"'>"+time+"</option>");
			                    	}
			                    %>
			                </select>
			                <input id="ITEM_TYPE_EYESURGERY_ENDHOUR" type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_ENDHOUR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_ENDHOUR" property="value"/>"/>
							<script>
							    var setEndHourIntSelect = function(){
							
							        var hours = $("endHourSelect").options;
							        var min = $("endMinutSelect").options;
							        var hourToTest = parseInt($("ITEM_TYPE_EYESURGERY_ENDHOUR").value.split(":")[0]);
							
							        var minToTest = parseInt($("ITEM_TYPE_EYESURGERY_ENDHOUR").value.split(":")[1]);
							        for(var i=0;i<hours.length;i++){
							           if(hours[i].value==hourToTest){
							                $("endHourSelect").selectedIndex = i;
							               break;
							            }
							        }
							        for(var i=0;i<min.length;i++){
							           if(min[i].value==minToTest){
							               $("endMinutSelect").selectedIndex = i;
							               break;
							            }
							        }
							    }
							    setEndHourIntSelect();
							</script>
			            </td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","duration",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<span id='duration'></span>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","laterality",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_LATERALITY" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.eyes",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_LATERALITY"),sWebLanguage,false,false) %>
			                </select>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","intervention",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUTOINVOICE_EYESURGERY_INTERVENTION" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.eyesurgery.intervention",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_AUTOINVOICE_EYESURGERY_INTERVENTION"),sWebLanguage,false,false) %>
			                </select>
			        	</td>
			        </tr>
	            </table>
		        <%-- DIAGNOSES --%>
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	        </td>
	    	<td  valign='top'>
	    		<table width='100%'>
		        	<tr>
			            <td class="admin" colspan="2"><center><%=getTran(request,"web","team",sWebLanguage)%></center></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","surgeon",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_SURGEON")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_SURGEON" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_SURGEON" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","anesthesists",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_ANESTHESISTS")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_ANESTHESISTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_ANESTHESISTS" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","nurses",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_NURSES")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_NURSES" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_NURSES" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin" colspan="2"><center><%=getTran(request,"web","surgery",sWebLanguage)%></center></td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_SURGERYDESCRIPTION")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_SURGERYDESCRIPTION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_SURGERYDESCRIPTION" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","complications",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_COMPLICATIONS")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_COMPLICATIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_COMPLICATIONS" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","postopcare",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_POSTOPCARE")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_POSTOPCARE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_POSTOPCARE" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","remarks",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
		       				<textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_EYESURGERY_REMARKS")%> class="text" rows="1" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_REMARKS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_REMARKS" property="value"/></textarea>
			        	</td>
			        </tr>
		        	<tr>
			            <td class="admin"><%=getTran(request,"web","iol",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select  class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_IOL" property="itemId"/>]>.value">
			                	<option/>
				            	<%=ScreenHelper.writeSelect(request,"ccbrt.cataract.ioltype",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_EYESURGERY_IOL"),sWebLanguage,false,false) %>
			                </select>
			        	</td>
			        </tr>
	    		</table>
	    	</td>
        </tr>
    </table>
            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.ccbrt.eyesurgery",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>

	function calculateDuration(){
		if(document.getElementById('beginHourSelect').value.length>0 && document.getElementById('endHourSelect').value.length>0 && document.getElementById('endHourSelect').value*60+document.getElementById('endMinutSelect').value*1>=document.getElementById('beginHourSelect').value*60+document.getElementById('beginMinutSelect').value*1){
			var minutes=(document.getElementById('endHourSelect').value*60)+(document.getElementById('endMinutSelect').value*1)-(document.getElementById('beginHourSelect').value*60)-(document.getElementById('beginMinutSelect').value*1);
			document.getElementById('duration').innerHTML="<font style='font-size:12px;font-weight: bolder'>"+("0"+(minutes/60).toFixed(0)).substr(("0"+(minutes/60).toFixed(0)).length-2)+":"+("0"+(minutes%60)).substr(("0"+(minutes%60)).length-2)+"</font>";
		}
		else{
			document.getElementById('duration').innerHTML="";
		}
	}	

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
      if($("beginHourSelect").value.length==0){
          $("ITEM_TYPE_EYESURGERY_STARTHOUR").value = '';
      }else{
          $("ITEM_TYPE_EYESURGERY_STARTHOUR").value = $("beginHourSelect").value+":"+$("beginMinutSelect").value;
      }
      if($("endHourSelect").value.length==0){
          $("ITEM_TYPE_EYESURGERY_ENDHOUR").value = '';
      }else{
          $("ITEM_TYPE_EYESURGERY_ENDHOUR").value = $("endHourSelect").value+":"+$("endMinutSelect").value;
      }
      transactionForm.saveButton.disabled = true;
  	  <%
	    SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
	    out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
	  %>
  }
  
  calculateDuration();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>