<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"occup.sstdischarge","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value='/healthrecord/updateTransaction.do'/>?ts=<%=getTs()%>" focus='type'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width='100%' border='0' cellspacing="1">
        <tr valign='top'>
            <td style="vertical-align:top;" width="50%">
                <table width="100%" cellpadding="1" cellspacing="1">
				    <%-- DATE --%>
				    <tr>
				        <td class="admin">
				            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
				            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
				        </td>
				        <td class="admin2">
				            <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur='checkDate(this)'> <script>writeTranDate();</script>
				        </td>
				    </tr>
				    
				    <%--  DONNEES CLINIQUES --%>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" rowspan="2" class='admin'><%=getTran(request,"web","treatmentresult",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
			            	<select name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENTRESULT" property="itemId"/>]>.value" class="text">
			            		<option/>
			            		<%=ScreenHelper.writeSelect(request, "sst.treatmentresult", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENTRESULT"), sWebLanguage) %>
			            	</select>&nbsp;&nbsp;
			            	<%=getTran(request,"sst","masnumber",sWebLanguage)%>: <%=ScreenHelper.writeDefaultTextInputSticky(session, (TransactionVO)transaction, "ITEM_TYPE_SST_MASNUMBER", 10,"if(this.value==''){this.value='-';}") %>
				        </td>
				    </tr>
				    <tr>
				        <td class='admin2'>
				            <%=getTran(request,"web","comment",sWebLanguage)%>: <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"ITEM_TYPE_SST_TREATMENTRESULTCOMMENT")%> class="text" cols="60" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENTRESULTCOMMENT" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_TREATMENTRESULTCOMMENT" property="value"/></textarea>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"sst","remark",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_SST_REMARK", 60, 2) %>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"sst","staname",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_SST_STANAME", 60) %>
				        </td>
				    </tr>
				    <tr>
				        <td width ="<%=sTDAdminWidth%>" class='admin'><%=getTran(request,"sst","stacode",sWebLanguage)%>&nbsp;</td>
				        <td class='admin2'>
				        	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_SST_STACODE", 20) %>
				        </td>
				    </tr>
	                <tr class="admin">
	                    <td align="center" colspan="2"><%=getTran(request,"web","healtheducation",sWebLanguage)%></td>
	                </tr>
				    <tr>
				        <td class='admin2' colspan="2">
				        	<table width='100%'>
				        		<tr>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION1" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION1;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.1",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION2" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION2;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.2",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION3" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION3;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.3",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION4" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION4;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.4",sWebLanguage) %>
				        			</td>
				        		</tr>
				        		<tr>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION5" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION5;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.5",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION6" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION6;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.6",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION7" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION7;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.7",sWebLanguage) %>
				        			</td>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION8" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION8;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.8",sWebLanguage) %>
				        			</td>
				        		</tr>
				        		<tr>
				        			<td colspan="4">
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION9" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_EDUCATION9;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","education.9",sWebLanguage) %>
				        			</td>
				        		</tr>
				        		<tr>
				        			<td colspan="4"><hr/></td>
				        		</tr>
				        		<tr>
				        			<td>
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_VACCINATIONSOK" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_VACCINATIONSOK;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","vaccinationsok",sWebLanguage) %>
				        			</td>
				        			<td colspan="3">
						                <input type="checkbox" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BREASTFEEDINGATDISCHARGE" property="itemId"/>]>.value" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_SST_BREASTFEEDINGATDISCHARGE;value=medwan.common.true" property="value" outputString="checked"/> value="medwan.common.true"/><%=getTran(request,"sst","breastfeedingatdischarge",sWebLanguage) %>
				        			</td>
				        		</tr>
				        	</table>
				        </td>
				    </tr>
				</table>
				
		    </td>
   
	        <%-- DIAGNOSIS --%>
	    	<td class="admin">
		      	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
	    	</td>
	    </tr>
    </table>
        
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.sstdischarge",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>

    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
<%-- SUBMIT FORM --%> 
	function submitForm(){
		  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
				alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
				searchEncounter();
			  }	
		  else {
		    transactionForm.saveButton.disabled = true;
		    <%
		        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
		        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
		    %>
		  }
	}    
	  <%-- CALCULATE BMI --%>
	  function calculateBMI(){
	    var _BMI = 0;
	    var heightInput = document.getElementById('height');
	    var weightInput = document.getElementById('weight');
		  document.getElementById("zvalue").value="";
		  document.getElementById("wflinfo").title="";
		  document.getElementById("wflinfo").style.display='none';
    	  document.getElementById('WFL').value ='';
		  document.getElementById("WFL").className="text";
	      document.getElementsByName('BMI')[0].value = "";

	    if(heightInput.value > 0){
	      _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
	      if (_BMI > 100 || _BMI < 5){
	        document.getElementsByName('BMI')[0].value = "";
	      }
	      else {
	        document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      }
	      var wfl=(weightInput.value*1/heightInput.value*1);
	      if(wfl>0){
	    	  document.getElementById('WFL').value = wfl.toFixed(2);
	    	  checkWeightForHeight(heightInput.value,weightInput.value);
	      }
	    }
	  }

		function checkWeightForHeight(height,weight){
		      var today = new Date();
		      var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&gender=<%=activePatient.gender%>&ts='+today;
		      new Ajax.Request(url,{
		          method: "POST",
		          postBody: "",
		          onSuccess: function(resp){
		              var label = eval('('+resp.responseText+')');
		    		  if(label.zindex>-999){
		    			  if(label.zindex<-4){
		    				  document.getElementById("WFL").className="darkredtext";
		    				  document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-3){
		    				  document.getElementById("WFL").className="darkredtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-2){
		    				  document.getElementById("WFL").className="orangetext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex<-1){
		    				  document.getElementById("WFL").className="yellowtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex>2){
		    				  document.getElementById("WFL").className="orangetext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else if(label.zindex>1){
		    				  document.getElementById("WFL").className="yellowtext";
		    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
		    				  document.getElementById("wflinfo").style.display='';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    			  else{
		    				  document.getElementById("WFL").className="text";
		    				  document.getElementById("wflinfo").style.display='none';
		    				  document.getElementById("zvalue").value=(label.zindex*1).toFixed(2);
		    			  }
		    		  }
	    			  else{
	    				  document.getElementById("WFL").className="text";
	    				  document.getElementById("wflinfo").style.display='none';
	    				  document.getElementById("zvalue").value="";
	    			  }
		          },
		          onFailure: function(){
    				  document.getElementById("zvalue").value="";
		          }
		      }
			  );
		  	}

	  function searchEncounter(){
	      openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&Varcode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
	  }
	  calculateBMI();
  if(<%=((TransactionVO)transaction).getServerId()%>==1 && document.getElementById('encounteruid').value=='' <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
		alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
		searchEncounter();
}	

</script>

<%=writeJSButtons("transactionForm","saveButton")%>