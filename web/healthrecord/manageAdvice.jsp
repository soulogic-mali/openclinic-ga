<%@page import="be.dpms.medwan.webapp.wo.common.system.SessionContainerWO,
                be.mxs.webapp.wl.session.SessionContainerFactory"%>
<%@page import="java.util.StringTokenizer"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pediatric.advice","select",activeUser)%>

<script>
	function selectKeywords(destinationidfield,destinationtextfield,labeltype,divid,titleid,keyid,mousey){	
		var bShowKeywords=true;
		document.getElementById("activeDestinationIdField").value=destinationidfield;
		document.getElementById("activeDestinationTextField").value=destinationtextfield;
		document.getElementById("activeLabeltype").value=labeltype;
		document.getElementById("activeDivld").value=divid;
		
		var allElements = document.getElementsByTagName("*");
		for(n=0;n<allElements.length;n++){
			if(allElements[n].id && allElements[n].id.indexOf("keywords_title")==0){
				allElements[n].style.textDecoration = "none";
			}
			else if(allElements[n].id && allElements[n].id.indexOf("keywords_key")==0){
				allElements[n].width = "16";
			}
		}
	  	if(document.getElementById(titleid) && document.getElementById(keyid)){
	  	    document.getElementById(titleid).style.textDecoration = "underline";
	  	  	document.getElementById(keyid).width = '32';
	  	  	document.getElementById('keywordstd').style = "vertical-align:top";
		}
	    else{
	    	bShowKeywords=false;
	    }
	    
	    if(bShowKeywords){
		    var params = "";
		    var today = new Date();
		    var url = '<c:url value="/healthrecord/ajax/getKeywords.jsp"/>'+
		              '?destinationidfield='+destinationidfield+
		              '&destinationtextfield='+destinationtextfield+
		              '&labeltype='+labeltype+
		              '&ts='+today;
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  document.getElementById(divid).innerHTML = resp.responseText;
		    	  setPosition(divid);
		      },
		      onFailure: function(){
		    	  document.getElementById(divid).innerHTML = "";
		      }
		    });
	    }
	    else{
	    	document.getElementById(divid).innerHTML = "";
	    }
	}
	
	function setPosition(divid){
		document.getElementById(divid).style.width=(document.getElementById(divid).parentElement.getBoundingClientRect().right-document.getElementById(divid).parentElement.getBoundingClientRect().left)-15;
		document.getElementById(divid).style.position='absolute';
		var topvalue = (document.getElementById("Juist").getBoundingClientRect().top*1)+100;
		var minus = document.getElementById("Juist").scrollTop*1;
		if(minus>100) { minus=100;};
		topvalue = topvalue*1 - minus*1;
		document.getElementById(divid).style.top=topvalue;
	}

  <%-- ADD KEYWORD --%>
  function addKeyword(id,label,destinationidfield,destinationtextfield){
	while(document.getElementById(destinationtextfield).innerHTML.indexOf('&nbsp;')>-1){
		document.getElementById(destinationtextfield).innerHTML=document.getElementById(destinationtextfield).innerHTML.replace('&nbsp;','');
	}
	var ids = document.getElementById(destinationidfield).value;
	if((ids+";").indexOf(id+";")<=-1){
	  document.getElementById(destinationidfield).value = ids+";"+id;
	  
	  if(document.getElementById(destinationtextfield).innerHTML.length > 0){
		if(!document.getElementById(destinationtextfield).innerHTML.endsWith("| ")){
          document.getElementById(destinationtextfield).innerHTML+= " | ";
	    }
	  }
	  
	  document.getElementById(destinationtextfield).innerHTML+= "<span style='white-space: nowrap;'><a href='javascript:deleteKeyword(\""+destinationidfield+"\",\""+destinationtextfield+"\",\""+id+"\");'><img width='8' src='<c:url value="/_img/themes/default/erase.png"/>' class='link' style='vertical-align:-1px'/></a> <b>"+label+"</b></span> | ";
	}
  }

  function storekeywordsubtype(s){
    var params = "";
    var today = new Date();
    var url = '<c:url value="/healthrecord/ajax/storeKeywordSubtype.jsp"/>'+
              '?subtype='+s;
    new Ajax.Request(url,{
      method: "POST",
      parameters: params,
      onSuccess: function(resp){
    	  selectKeywords(document.getElementById("activeDestinationIdField").value,
    			  document.getElementById("activeDestinationTextField").value,
    			  document.getElementById("activeLabeltype").value,
    			  document.getElementById("activeDivld").value);
      },
      onFailure: function(){
      }
    });
  }

  <%-- DELETE KEYWORD --%>
  function deleteKeywordCoded(kw){
	  destinationidfield=kw.split("\~")[0];
	  destinationtextfield=kw.split("\~")[1];
	  id=kw.split("\~")[2];
	  keyname=kw.split("\~")[3];
	  
		var newids = "";
		var ids = document.getElementById(destinationidfield).value.split(";");
		for(n=0; n<ids.length; n++){
		  if(ids[n].indexOf("$")>-1){
			if(id!=ids[n]){
			  newids+= ids[n]+";";
			}
		  }
		}
		
		document.getElementById(destinationidfield).value = newids;
		var newlabels = "";
		var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
	    for(n=0;n<labels.length;n++){
		  if(labels[n].trim().length>0 && labels[n].indexOf(keyname)<=-1){
		    newlabels+=labels[n]+" | ";
		  }
		}
	    
		document.getElementById(destinationtextfield).innerHTML = newlabels;
  }

  function deleteKeyword(destinationidfield,destinationtextfield,id){
	var newids = "";
	var ids = document.getElementById(destinationidfield).value.split(";");
	for(n=0; n<ids.length; n++){
	  if(ids[n].indexOf("$")>-1){
		if(id!=ids[n]){
		  newids+= ids[n]+";";
		}
	  }
	}
	
	document.getElementById(destinationidfield).value = newids;
	var newlabels = "";
	var labels = document.getElementById(destinationtextfield).innerHTML.split(" | ");
    for(n=0;n<labels.length;n++){
	  if(labels[n].trim().length>0 && labels[n].indexOf(id)<=-1){
	    newlabels+=labels[n]+" | ";
	  }
	}
    
	document.getElementById(destinationtextfield).innerHTML = newlabels;	
  }
</script>

<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

	<input type='hidden' name='activeDestinationIdField' id='activeDestinationIdField'/>
	<input type='hidden' name='activeDestinationTextField' id='activeDestinationTextField'/>
	<input type='hidden' name='activeLabeltype' id='activeLabeltype'/>
	<input type='hidden' name='activeDivld' id='activeDivld'/>
  
    <input id="transactionId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input id="serverId" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input id="transactionType" type="hidden" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
   
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_DEPARTMENT" translate="false" property="value"/>"/>
    <input type="hidden" readonly name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_CONTEXT" translate="false" property="value"/>"/>

	<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_DEPARTMENT") %>
	<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_CONTEXT") %>
	<%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_ENCOUNTERUID") %>
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table width="100%" cellspacing="1" cellpadding="0">
	    <%-- DATE --%>
	    <tr>
	        <td class="admin" width="20%">
	            <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
	            <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
	        </td>
	        <td class="admin2">
	            <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
	            <script>writeTranDate();</script>
	        </td>
	    </tr>
	</table>
	<div style="padding-top:5px;"></div>
			    
    <table width="100%" cellspacing="1" cellpadding="0">
    	<tr>
	        <td style="vertical-align:top;height: 200px" width="70%">
	        	<table width="100%">
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"advice","request",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","destination",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNomenclatureField(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_DESTINATION", "service.destination", 60, sWebLanguage, sCONTEXTPATH, "") %></td>
        			</tr>
        			<tr>
						<td class='admin'>
							<div id="keywords_title_ITEM_TYPE_ADVICE_REASON"><%=getTran(request,"advice","reasonfield",sWebLanguage)%></div>
						</td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_ADVICE_REASON", "advice.reason", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
				      	</td>
        			</tr>
        			<tr>
						<td class='admin'>
							<div id="keywords_title_ITEM_TYPE_ADVICE_CLINICALHISTORY"><%=getTran(request,"advice","clinicalhistoryfield",sWebLanguage)%></div>
						</td>
						<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_ADVICE_CLINICALHISTORY", "advice.clinicalhistory", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
				      	</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","doctor",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNomenclatureField(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_REQUESTINGDOCTOR", "doctor", 60, sWebLanguage, sCONTEXTPATH, "") %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","daterequest",sWebLanguage) %></td>
        				<td class='admin2'>
			                <input type="hidden" id="daterequestfield" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADVICE_DATEREQUEST" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("daterequest", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADVICE_DATEREQUEST"), true, false, sWebLanguage, sCONTEXTPATH))%>
			            	&nbsp;&nbsp;<%=getTran(request,"advice","hour",sWebLanguage) %> <%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_HOURREQUEST", 5) %>
        				</td>
        			</tr>
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"advice","answer",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","report",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_REPORT", 60, 4) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","doctor",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNomenclatureField(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_RESPONDINGDOCTOR", "doctor", 60, sWebLanguage, sCONTEXTPATH, "") %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"advice","daterequest",sWebLanguage) %></td>
        				<td class='admin2'>
			                <input type="hidden" id="daterequestfield2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADVICE_DATERESPONSE" property="itemId"/>]>.value"/>
			            	<%=(ScreenHelper.writeDateField("daterequest2", "transactionForm", ((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ADVICE_DATERESPONSE"), true, false, sWebLanguage, sCONTEXTPATH))%>
			            	&nbsp;&nbsp;<%=getTran(request,"advice","hour",sWebLanguage) %> <%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_ADVICE_HOURRESPONSE", 5) %>
        				</td>
        			</tr>
	        	</table>
	        </td>
	        <%-- KEYWORDS --%>
	    	<td width="30%" id='keywordstd' class="admin2" style="vertical-align:top;padding:0px;">
	    		<div id=test'></div>
	    		<div style="height:200px;overflow:auto;position: sticky" id="keywords"></div>
	    	</td>
	    </tr>
   		<tr>
   			<td colspan='2'>
       			<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
       		</td>
       	</tr>
	</table>
    
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"pediatric.advice",sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	    
	<%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  <%-- SUBMIT FORM --%>
  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
    %>
  }
</script>

<%=writeJSButtons("transactionForm","saveButton")%>