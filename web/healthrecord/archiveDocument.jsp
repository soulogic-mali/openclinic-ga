<%@page import="be.openclinic.system.Screen"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"occup.arch.documents","select",activeUser)%>

<form name="transactionForm" id="transactionForm" method="POST" action="<c:url value='/healthrecord/updateTransaction.do'/>?ts=<%=getTs()%>" focus='type'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>

    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp?ts=<%=getTs()%>"/>
   
    <%=writeTableHeader("web.occup",sPREFIX+"TRANSACTION_TYPE_ARCHIVE_DOCUMENT",sWebLanguage,sCONTEXTPATH+"/main.do?Page=healthrecord/index.jsp&ts="+getTs())%>   
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <% TransactionVO tran = (TransactionVO)transaction; %>
    
    <table width='100%' cellspacing="0" cellpadding="0">
    	<tr>
    		<td class='admin2' style='vertical-align:top'>
			    <table class="list" width="100%" cellspacing="1"> 
			        <% String sDocUID = tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UID"); %>
			        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_UID" property="itemId"/>]>.value" value="<%=sDocUID%>">
			        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_PERSONID" property="itemId"/>]>.value" value="<%=activePatient.personid%>">              
			                
			        <%-- date --%>
			        <tr>
			            <td class="admin">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("web.occup","history",sWebLanguage)%>">...</a>&nbsp;<%=getTran(request,"web.occup","medwan.common.date",sWebLanguage)%>&nbsp;*&nbsp;
			            </td>
			            <td class="admin2">
			                <input type="text" class="text" size="12" maxLength="10" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" id="trandate" OnBlur="checkDate(this);">
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			        
			        <%-- UDI (read-only) --%>
			        <%
			            if(!tran.isNew()){
			                %>
						        <tr>
						            <td width="<%=sTDAdminWidth%>" class="admin"><%=getTran(request,"web","udi",sWebLanguage)%>&nbsp;</td>
						            <td class="admin2">
						                <% String sUDI = tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UDI"); %>   
						                <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_UDI" property="itemId"/>]>.value" value="<%=sUDI%>">              
						                <span onClick="printBarcode('<%=sUDI%>');" class="hand"><b><font style="background-color:yellow;border:1px solid orange;padding:2px;height:18px;">&nbsp;<%=sUDI%>&nbsp;</font></b></span>
						            </td>
						        </tr>
						    <%
			            }
			        %>
			        
			        <%-- title --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","title",sWebLanguage)%>&nbsp;*&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" id="title" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_TITLE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_TITLE" property="value"/>" size="50" maxLenght="255">
			            </td>
			        </tr>
			        
			        <%-- description --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <textarea onKeyup="resizeTextarea(this,10);limitChars(this,255);" class="text" cols="46" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_DESCRIPTION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_DESCRIPTION" property="value"/></textarea>
			            </td>
			        </tr>
						        
			        <%-- category --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","category",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <select class="text" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_CATEGORY" property="itemId"/>]>.value" id="category">
			                    <option/>
			                    <%=ScreenHelper.writeSelect(request,"arch.doc.category",tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_CATEGORY"),sWebLanguage)%>
			                </select>
			            </td>
			        </tr>
			        
			        <%-- author --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","author",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" id="author" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_AUTHOR" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_AUTHOR" property="value"/>" size="50" maxLenght="255">
			            </td>
			        </tr>
			        
			        <%-- destination --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","destination",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" id="destination" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_DESTINATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_DESTINATION" property="value"/>" size="50" maxLenght="255">
			            </td>
			        </tr>
			        
			        <%-- reference --%>
			        <tr>
			            <td class="admin"><%=getTran(request,"web","paperReference",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2">
			                <input type="text" class="text" id="reference" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_REFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_REFERENCE" property="value"/>" size="50" maxLenght="50">
			            </td>
			        </tr>
			        
			        <%-- storage-name (read-only) --%>
			        <%
			        	String href="";
			            if(!tran.isNew()){
			            	if(checkString(tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_SENDEREMAIL")).length()>0){
			            		%>
						        <%-- reference --%>
						        <tr>
						            <td class="admin"><%=getTran(request,"web","receivedfrom",sWebLanguage)%>&nbsp;</td>
						            <td class="admin2">
						            	<%=tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_SENDEREMAIL") %>
						            </td>
						        </tr>
			            		<%
			            	}
			                %>
						        <tr>
						            <td class="admin"><%=getTran(request,"web","storageName",sWebLanguage)%>&nbsp;</td>
						            <td class="admin2">
						            	<div id='docpath'>
						            	<%
						            		String sStorageName = tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_STORAGENAME");
						            		if(activeUser.getAccessRight("occup.arch.documents.delete")){
						            	%>
						            		<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' onclick='deleteDocument("<%=tran.getItemValue(ScreenHelper.ITEM_PREFIX+"ITEM_TYPE_DOC_UDI")%>")'/>
						                <% 	}
						            		
						                    if(sStorageName.length()==0){
						                        %><%=getTranNoLink("web.occup","documentIsBeingProcessed",sWebLanguage)%><%
						                    }
						                    else{
						                    	// show link to open document, when server is configured
												String server=MedwanQuery.getInstance().getConfigString("PACSFileServer",(request.isSecure()?"https":"http")+"://"+ request.getServerName())+":"+MedwanQuery.getInstance().getConfigInt("PACSFileServerPort",request.getServerPort());
						                    	String sServer = server+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_url","scan")+"/"+
						                    	                 MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
						                    	if(sServer.length() > 0){
						                    		href=sServer+"/"+sStorageName;
						                            %><a href="<%=href%>" target="_new"><%=sStorageName%></a><%
						                        }
						                        else{
						                            %><%=sStorageName%><%
						                        }
						                    }
						                %>   
						                </div>           
						                <input id='docpathfield' type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_DOC_STORAGENAME" property="itemId"/>]>.value" value="<%=sStorageName%>">
						            </td>
						        </tr>
						    <%
						}
				    %>
			    </table>
			</td>
			<td nowrap width='1px' id='imagetd' class='admin2'>
			</td>
		</tr>
	</table>
    &nbsp;<%=getTran(request,"web","asterisk_fields_are_obligate",sWebLanguage)%>

	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,"occup.arch.documents",sWebLanguage,false)%>
	<%=ScreenHelper.alignButtonsStop()%>
</form>

<script>  
  document.getElementById("title").focus();
  
  <%-- SUBMIT FORM --%>
  function submitForm(){
	if(formComplete()){
	  transactionForm.saveButton.disabled = true; 
  	  transactionForm.backButton.disabled = true;
	
      <%
          SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
          out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
      %>
	}
	else{
	            alertDialog("web.manage","dataMissing");	
	  
	       if(document.getElementById("trandate").value.length==0) document.getElementById("trandate").focus();
      else if(document.getElementById("title").value.length==0) document.getElementById("title").focus();
	}
  }
  
  <%-- FORM COMPLETE --%>
  function formComplete(){
	return (document.getElementById("trandate").value.length>0 &&
			document.getElementById("title").value.length>0);
  }
  function deleteDocument(id){
	    yesnoModalBox("doDeleteDocument(\""+id+"\")","<%=getTranNoLink("web","areYouSureToDelete",sWebLanguage)%>");
	  }

	function doDeleteDocument(id){
    	var params = "documentuid="+id;
		var url = '<c:url value="/healthrecord/ajax/deleteDocument.jsp"/>?ts='+new Date().getTime();
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('docpath').innerHTML='';
			document.getElementById('docpathfield').value='';
		}
		});
	}

  <%-- PRINT BARCODE --%>
  function printBarcode(udi){
	var url = "<%=sCONTEXTPATH%>/archiving/printBarcode.jsp?barcodeValue="+udi+"&numberOfPrints=1";
	var w = 430;
    var h = 200;
    var left = (screen.width/2)-(w/2);
    var topp = (screen.height/2)-(h/2);
    window.open(url,"PrintBarcode<%=getTs()%>","toolbar=no,status=no,scrollbars=yes,resizable=yes,menubar=yes,width="+w+",height="+h+",top="+topp+",left="+left);
  }
  
  function preview(){
	  var imageExtensions=".jpg,.jpeg,.png,.bmp,.tiff,.gif".split(",");
	  for(n=0;n<imageExtensions.length;n++){
		  if('<%=href.toLowerCase()%>'.endsWith(imageExtensions[n])){
			  document.getElementById("imagetd").innerHTML="<a target='_new' href='<%=href%>'><img style='max-height: 300px;max-width: 400px' src='<%=href%>'/></a>";
			  return;
		  }
	  }
	  var imageExtensions=".mp4,.webm,.ogg".split(",");
	  for(n=0;n<imageExtensions.length;n++){
		  if('<%=href.toLowerCase()%>'.endsWith(imageExtensions[n])){
			  document.getElementById("imagetd").innerHTML="<video controls style='max-height: 300px;max-width: 400px'><source src='<%=href%>' type='video/"+imageExtensions[n].replace(".","")+"'/>Sorry, your browser doesn\'t support embedded videos.</video>";
			  return;
		  }
	  }
	  var imageExtensions=".pdf".split(",");
	  for(n=0;n<imageExtensions.length;n++){
		  if('<%=href.toLowerCase()%>'.endsWith(imageExtensions[n])){
			  document.getElementById("imagetd").innerHTML="<iframe style='height: 300px;width: 400px' src='<%=href%>'/>";
			  return;
		  }
	  }
	  document.getElementById("imagetd").innerHTML="<a target='_new' href='<%=href%>'><img style='max-height: 300px;max-width: 400px' src='<%=sCONTEXTPATH%>/_img/no_img.png'/></a>";
  }
  
  preview();
</script>

<%=writeJSButtons("transactionForm","saveButton")%>