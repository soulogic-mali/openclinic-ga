<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
      
<%	if(SH.ci("enableSPT",0)==1){ %>
	<tr>
    	<td class="admin">
    		<%=getTran(request,"web","spt",sWebLanguage)%>&nbsp;
    		<a href="javascript:doSPT();"><img height='16px' src="<c:url value='/_img/icons/mobile/icon_brain.png'/>" class="link" title="<%=getTranNoLink("web","spt",sWebLanguage)%>" style="vertical-align:-4px;"></a>
    	</td>
    	<td class='admin2' colspan="3">
   			<%session.removeAttribute("sptexit"); %>
    		<table width='100%' cellspacing='0' cellpadding='0'>
    			<tr>
      				<td width='1%' nowrap>
     					<%=SH.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_SPTEXIT", 10,"onkeyup='showSPTPath();'") %>
     					<%=SH.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_SPTPATH") %>
         				&nbsp;
         			</td>
         			<td>
         				<div id='sptpath'/>
         			</td>
				</tr>
			</table>
			<script>
				function getSptExit(){
				   var params = "";
				   var today = new Date();
				   var url = '<c:url value="/healthrecord/ajax/getSptExit.jsp"/>';
				   new Ajax.Request(url,{
				     method: "POST",
				     parameters: params,
				     onSuccess: function(resp){
						var label = eval('('+resp.responseText+')');
						if(label.sptexit && label.sptexit.length>0){
							document.getElementById("ITEM_TYPE_SPTEXIT").value=label.sptexit;
							document.getElementById("ITEM_TYPE_SPTPATH").value=label.sptpath;
							document.getElementById("sptpath").innerHTML="<b><i>"+document.getElementById("ITEM_TYPE_SPTPATH").value.split("$")[0]+"</i></b>";
						}
				     },
				     onFailure: function(){
				     }
				   });
				}
				function showSPTPath(){
 					if(document.getElementById("ITEM_TYPE_SPTPATH").value.toLowerCase().endsWith("$"+document.getElementById("ITEM_TYPE_SPTEXIT").value.toLowerCase())){
		  				document.getElementById("sptpath").innerHTML="<b><i>"+document.getElementById("ITEM_TYPE_SPTPATH").value.split("$")[0]+"</i></b>";
 					}
 					else{
  						document.getElementById("sptpath").innerHTML='';
 					}
				}
				showSPTPath();
				window.setInterval("getSptExit();",2000);
			</script>	  
        </td>
    </tr>
<%	} %>