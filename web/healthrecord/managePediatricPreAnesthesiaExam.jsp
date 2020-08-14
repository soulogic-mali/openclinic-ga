<%@page import="be.dpms.medwan.webapp.wo.common.system.SessionContainerWO,
                be.mxs.webapp.wl.session.SessionContainerFactory"%>
<%@page import="java.util.StringTokenizer"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pediatric.preanesthesia","select",activeUser)%>

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
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","diagnosis",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_DIAGNOSIS", 60, 4) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_OPERATION"><%=getTran(request,"preanesthesia","indicatedoperation",sWebLanguage) %></div></td>
						<td class='admin2'><%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_OPERATION", "advice.operation", "keywords", sCONTEXTPATH, sWebLanguage,request) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","surgeons",sWebLanguage) %></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNomenclatureField(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_SURGEON1", "doctor", 30, sWebLanguage, sCONTEXTPATH, "") %>
        					<%=ScreenHelper.writeDefaultNomenclatureField(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_SURGEON2", "doctor", 30, sWebLanguage, sCONTEXTPATH, "") %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_INFORMANT"><%=getTran(request,"preanesthesia","informant",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_INFORMANT", "informant", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"preanesthesia","history",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_PASTDISEASES"><%=getTran(request,"preanesthesia","pastdiseases",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_PASTDISEASES", "preanesthesia.pastdiseases", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","pasttransfusions",sWebLanguage) %></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PREANESTHESIA_PASTTRANSFUSIONS", sWebLanguage, true) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_SURGERY"><%=getTran(request,"preanesthesia","surgery",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_SURGERY", "preanesthesia.surgery", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_ANESTHESIA"><%=getTran(request,"preanesthesia","anesthesia",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_ANESTHESIA", "preanesthesia.anesthesia", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"preanesthesia","exam",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_GENERALEXAM"><%=getTran(request,"preanesthesia","generalexam",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_GENERALEXAM", "preanesthesia.generalexam", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","glasgow",sWebLanguage) %></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_GLASGOW", 20) %>
        				</td>
        			</tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			            	<table width="100%">
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="height" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="alert()calculateBMI();"/> cm</td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td><td nowrap><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td><td nowrap><input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this)" size="5"/> /min</td>
			            		</tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b></td><td nowrap><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			            		</tr>
				                <tr>
						            <td>
						            	<b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>"/> %
						            </td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","sober",sWebLanguage)%>:</b></td>
			            			<td nowrap><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_SOBER", 5, sWebLanguage) %></td>
				                </tr>
			            	</table>
			            </td>
			        </tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_GENERALSTATUS"><%=getTran(request,"preanesthesia","generalstatus",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_GENERALSTATUS", "preanesthesia.generalstatus", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_SKIN"><%=getTran(request,"preanesthesia","skin",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_SKIN", "preanesthesia.skin", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_HEAD"><%=getTran(request,"preanesthesia","head",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_HEAD", "preanesthesia.head", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_NECK"><%=getTran(request,"preanesthesia","neck",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_NECK", "preanesthesia.neck", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_MOUTH"><%=getTran(request,"preanesthesia","mouth",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_MOUTH", "preanesthesia.mouth", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_THORAX"><%=getTran(request,"preanesthesia","thorax",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_THORAX", "preanesthesia.thorax", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_RESPIRATORY"><%=getTran(request,"preanesthesia","respiratory",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_RESPIRATORY", "preanesthesia.respiratory", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_CARDIOVASCULAR"><%=getTran(request,"preanesthesia","cardiovascular",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_CARDIOVASCULAR", "preanesthesia.cardiovascular", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_ABDOMEN"><%=getTran(request,"preanesthesia","abdomen",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_ABDOMEN", "preanesthesia.abdomen", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_GENITALS"><%=getTran(request,"preanesthesia","genitals",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_GENITALS", "preanesthesia.genitals", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_MUSCULARMASS"><%=getTran(request,"preanesthesia","muscularmass",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_MUSCULARMASS", "preanesthesia.muscularmass", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_EXTREMITIES"><%=getTran(request,"preanesthesia","extremities",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_EXTREMITIES", "preanesthesia.extremities", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_VERTEBRALCOLUMN"><%=getTran(request,"preanesthesia","vertebralcolumn",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_VERTEBRALCOLUMN", "preanesthesia.vertebralcolumn", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_NEUROLOGICAL"><%=getTran(request,"preanesthesia","neurological",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_NEUROLOGICAL", "preanesthesia.neurological", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"preanesthesia","labexams",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin2' colspan='2'>
        					<table width='100%'>
        						<tr>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","hto",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_HTO", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","glycemia",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_GLYCEMIA", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","hbs",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_HBS", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","hiv",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_HIV", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","inr",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_INR", 8) %>
        							</td>
        						</tr>
        						<tr>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","bloodgroup",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_BLOODGROUP", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","rh",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_RH", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","crosstests",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_CROSSTESTS", 8) %>
        							</td>
        							<td width='20%'>
        								<%=getTran(request,"preanesthesia","platelets",sWebLanguage) %>
        								<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_LAB_PLATELETS", 8) %>
        							</td>
        							<td width='20%'>
        							</td>
        						</tr>
        					</table>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","pediatricadvice",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_PEDIATRICADVICE", 60, 4) %></td>
        			</tr>
	        		<tr class='admin'><td colspan='2'><%=getTran(request,"preanesthesia","anesthesia",sWebLanguage) %></td></tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","difficultintubation",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_PREANESTHESIA_DIFFICULTINTUBATION", sWebLanguage, true, "", "") %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","asa",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_ASA", 8) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><div id="keywords_title_ITEM_TYPE_PREANESTHESIA_PREMEDICATION"><%=getTran(request,"preanesthesia","premedication",sWebLanguage) %></div></td>
        				<td class='admin2'>
							<%=ScreenHelper.writeDefaultKeywordField(session,(TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_PREMEDICATION", "preanesthesia.premedication", "keywords", sCONTEXTPATH, sWebLanguage,request) %>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"preanesthesia","observations",sWebLanguage) %></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_PREANESTHESIA_OBSERVATIONS", 60, 4) %></td>
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
	    <%=getButtonsHtml(request,activeUser,activePatient,"pediatric.preanesthesia",sWebLanguage)%>
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