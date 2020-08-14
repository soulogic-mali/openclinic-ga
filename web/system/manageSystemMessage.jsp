<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"system.management","all",activeUser)%>

<%
    String sAction = checkString(request.getParameter("Action"));
    
	String sSupportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","fr,en,nl");	
		
	/// DEBUG /////////////////////////////////////////////////////////////////
	if(Debug.enabled){
	    Debug.println("\n************* manageSystemMessage.jsp *************");
	    Debug.println("sAction : "+sAction);
	    Debug.println("--> sSupportedLanguages : "+sSupportedLanguages+"\n");
	}
	///////////////////////////////////////////////////////////////////////////
	
	Hashtable messagesHash = new Hashtable();
	String sMsg = "";

	// load the saved labels
    String[] languages = sSupportedLanguages.split(",");
	Arrays.sort(languages);
  		
    for(int l=0; l<languages.length; l++){
    	String sLabel = ScreenHelper.getTranExists("systemMessages","mainMessage",languages[l]);    	
        messagesHash.put(languages[l].toUpperCase(),sLabel);
	}
    
	
	//--- SAVE MESSAGE ----------------------------------------------------------------------------
	if(sAction.equals("save")){
		// fetch all messages-parameters from request
		String sMessage, sParamName, sParamValue;
		Enumeration messageParams = request.getParameterNames();
		
		while(messageParams.hasMoreElements()){
			sParamName = (String)messageParams.nextElement();
			
			if(sParamName.startsWith("Message")){
				sParamValue = checkString(request.getParameter(sParamName));
				sParamName = sParamName.substring("Message".length());
			    messagesHash.put(sParamName,sParamValue);
			    Debug.println(sParamName+" : "+sParamValue);
			}
		}
		
		// sort
		Vector messageKeys = new Vector(messagesHash.keySet()); // language
		Collections.sort(messageKeys);
		
		String sLanguage;
		
		//***** 1 : save prev message *****
		boolean labelExists = false;
		long ts = new java.util.Date().getTime();
		
		for(int k=0; k<messageKeys.size() && !labelExists; k++){
			sLanguage = ((String)messageKeys.get(k));
			
			if(checkString((String)messagesHash.get(sLanguage)).length() > 0){
				Label label = new Label();
				label.type = "systemMessages";
				label.id = "prevMessage_"+ts; // same id per language
				label.language = sLanguage;
	            label.showLink = "1";	
	            label.updateUserId = activeUser.userid;
				label.value = (String)messagesHash.get(sLanguage);

                labelExists = Label.hasSiblings("systemMessages","prevMessage%",label.value,sLanguage);
                if(!labelExists) label.saveToDB();
			}
		}	

		//***** 2 : save actual message *****
		boolean deleted = false;
		for(int k=0; k<messageKeys.size(); k++){
			sLanguage = ((String)messageKeys.get(k));
			
			if(!deleted && checkString((String)messagesHash.get(sLanguage)).length() > 0){
				Label label = new Label();
				label.type = "systemMessages";
				label.id = "mainMessage";
				label.language = sLanguage;
	            label.showLink = "1";	
	            label.updateUserId = activeUser.userid;
				label.value = ((String)messagesHash.get(sLanguage)).replaceAll("\r"," ").replaceAll("\n"," ");

                label.saveToDB();	            
			}
			else{
				// delete the label (since storing it empty is not allowed)
				Label.delete("systemMessages","mainMessage"); // all languages
				deleted = true;
			}
		}		

	    reloadSingleton(session);
	    
		// compose user-message
		if(deleted){
		    sMsg = "<font color='green'>"+getTranNoLink("web","dataIsDeleted",sWebLanguage)+"</font>";
		}
		else{
		    sMsg = "<font color='green'>"+getTranNoLink("web","dataIsSaved",sWebLanguage)+"</font>";
		}
	}
	//--- DELETE PREV MESSAGE ---------------------------------------------------------------------
	else if(sAction.equals("deletePrevMsg")){
		String sId = checkString(request.getParameter("deleteMsgId"));
		Debug.println("sId : "+sId);
		Label.delete("systemMessages",sId,""); // all languages       
    	reloadSingleton(session);
	    
		// compose user-message
		sMsg = "<font color='green'>"+getTranNoLink("web","dataIsDeleted",sWebLanguage)+"</font>";		
	}
%>

<form name="msgForm" method="post">
    <input type="hidden" name="deleteMsgId" value=""/>
    <input type="hidden" name="Action" value="">

    <%-- 1 : ACTIVE MESSAGE -------------------------------------------%>
    <%=writeTableHeader("web.manage","activeSystemMessage",sWebLanguage,"doBack();")%>                
    <table width="100%" align="center" cellspacing="1" class="list">
        <%-- a MESSAGE for each supported language --%>
        <%        		
            boolean msgSet = false;
        		
	    	for(int l=0; l<languages.length; l++){
	    		String sMessage = checkString((String)messagesHash.get(languages[l].toUpperCase()));
	    		if(sMessage.length() > 0) msgSet = true;
	    			
                %>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","message",sWebLanguage)%>&nbsp;<%=languages[l].toUpperCase()%>&nbsp;</td>
			            <td class="admin2"><%=sMessage%></td>
			        </tr>
			    <%
		    }
		%>
            
        <%-- BUTTONS --%>
        <tr>     
            <td class="admin"/>
            <td class="admin2" colspan="2">
                <input class="button" type="button" name="clearButton" <%=(msgSet?"":"disabled")%> value="<%=getTranNoLink("web.manage","inactivateMessage",sWebLanguage)%>" onclick="clearAll();">&nbsp;&nbsp;
            </td>
        </tr>
    </table>
    <br>
    
    <%-- 2 : EDIT MESSAGE ---------------------------------------------%>
    <%=writeTableHeader("web.manage","manageSystemMessage",sWebLanguage,"doBack();")%>                
    <table width="100%" align="center" cellspacing="1" class="list">
        <%-- a MESSAGE for each supported language --%>
        <%        		
	    	for(int l=0; l<languages.length; l++){
                %>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","message",sWebLanguage)%>&nbsp;<%=languages[l].toUpperCase()%>&nbsp;</td>
			            <td class="admin2">
			                <textarea class="text" name="Message<%=languages[l].toUpperCase()%>" cols="80" rows="4" onKeyup="limitChars(this,255);resizeTextarea(this,4);"><%=checkString((String)messagesHash.get(languages[l].toUpperCase()))%></textarea>
			            </td>
			        </tr>
			    <%
		    }
		%>
            
        <%-- BUTTONS --%>
        <tr>     
            <td class="admin"/>
            <td class="admin2" colspan="2">
                <input class="button" type="button" name="saveButton" value="<%=getTranNoLink("web.manage","setMessage",sWebLanguage)%>" onclick="doSave();">
            </td>
        </tr>
    </table>
    
    <%
        //-- MESSAGE --
        if(sMsg.length() > 0){
            %><%=sMsg%><br><%    	
        }
    %>
    <br>
    
    <%-- 3 : HISTORY OF USED MESSAGES ---------------------------------%>
    <%=writeTableHeaderDirectText(getTran(request,"web","usedMessages",sWebLanguage)+" ("+sWebLanguage.toUpperCase()+")",sWebLanguage,"doBack();")%>
    <table width="100%" align="center" cellspacing="1" class="list">
        <%-- a MESSAGE for each supported language --%>
        <%        		
            Vector prevMessages = Label.getLabels("systemMessages","prevMessage%","",sWebLanguage,"OC_LABEL_UPDATETIME DESC");
            int prevMsgCount = 0;
        	String sClass = "1";
        		
        	if(prevMessages.size() > 0){
        		%><tbody class="hand"><%
        		
        		for(int i=0; i<prevMessages.size(); i++){
		    		Label prevMsg = (Label)prevMessages.get(i);
		    		
		    		if(prevMsg.id.indexOf("_") > -1){
			    		String sTs = prevMsg.id.substring(prevMsg.id.indexOf("_")+1);
			    		java.util.Date msgDate = new java.util.Date();
			    		msgDate.setTime(Long.parseLong(sTs));
			    		prevMsgCount++;
	
		            	// alternate row-style
		                if(sClass.equals("")) sClass = "1";
		                else                  sClass = "";
		            	
		            	String sMsgValue = prevMsg.value;
		            	if(sMsgValue.length() > 80){
		            		sMsgValue = sMsgValue.substring(0,80)+".. [more]";
		            	}
		            	
		                %>
					        <tr class="list<%=sClass%>">
					            <td width="20"><img src="<%=sCONTEXTPATH%>/_img/icons/icon_delete.png" class="link" onClick="deleteMsg('<%=prevMsg.id%>');" alt="<%=getTranNoLink("web","delete",sWebLanguage)%>"/></td>
					            <td width="110"><%=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(msgDate)%>&nbsp;</td>
					            <td onClick="editMsg('<%=prevMsg.id%>','<%=prevMsg.language%>');" id="prevMsg_<%=prevMsg.id%>"><%=sMsgValue%></td>
					        </tr>
					    <%
		    		}
			    }
        		
        		%></tbody><%
        	}
		%>
    </table>
    <%=prevMsgCount%> <%=getTran(request,"web","recordsFound",sWebLanguage)%>
</form>

<%=ScreenHelper.alignButtonsStart()%>
      <input class="button" type="button" name="backButton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBack();">&nbsp;
<%=ScreenHelper.alignButtonsStop()%>
       

<script>
  msgForm.elements[2].focus(); <%-- first textarea --%>

  <%-- CLEAR ALL textareas --%>
  function clearAll(){
    if(yesnoDeleteDialog()){
	  <%
	      for(int l=0; l<languages.length; l++){
	          %>msgForm.Message<%=languages[l].toUpperCase()%>.value = "";<%
	      }
	  %>
      msgForm.saveButton.disabled = true;
	  msgForm.clearButton.disabled = true;
	  msgForm.Action.value = "save";
	  msgForm.submit();
	}
  }  
  
  <%-- DO SAVE --%>
  function doSave(){
	var okToSubmit = true;
	var totalMessages = <%=languages.length%>;
	var emptyMessages = 0;

    <%-- check each message for content --> all empty or all not-empty --%>
	if(okToSubmit){
      <%
	      for(int l=0; l<languages.length; l++){
              %>
	            if(msgForm.Message<%=languages[l].toUpperCase()%>.value.length==0){
	      	      emptyMessages++;
	            }
	          <%
	      }
      %>

      if(emptyMessages > 0 && emptyMessages!=totalMessages){
        alertDialog("web.manage","allMessagesShouldBeSpecified");
        okToSubmit = false;
      }
	}
	
	if(okToSubmit){
      msgForm.saveButton.disabled = true;
      msgForm.clearButton.disabled = true;
      
	  msgForm.Action.value = "save";
	  msgForm.submit();
	}
  }
  
  <%-- EDIT MSG --%>
  function editMsg(msgId){
      <%
          for(int t=0; t<languages.length; t++){
              %>setLabelValue(msgId,"<%=languages[t]%>");<%
          }
      %>
  }
  
  <%-- SET LABEL VALUE --%>
  function setLabelValue(labelId,labelLang){
    var url = "<c:url value='/_common/getLabel.jsp'/>?ts=<%=getTs()%>"+
    		  "&LabelType=systemMessages"+
    		  "&LabelId="+labelId+
    		  "&LabelLang="+labelLang;
    new Ajax.Request(url,{
      onSuccess:function(resp){
    	  var rr=eval('('+resp.responseText+')');
          var label = rr.label.trim();
        label = convertSpecialChars(label);
        eval("msgForm.Message"+rr.language.toUpperCase()+".value = label;");
      }
    });
  }
  
  function convertSpecialChars(text){
	  // accents
	  text = replaceAll(text,"&eacute;","é");
	  text = replaceAll(text,"&egrave;","è");
	  text = replaceAll(text,"&aacute;","á");
	  text = replaceAll(text,"&agrave;","à");
	  text = replaceAll(text,"&uacute;","ú");
	  text = replaceAll(text,"&ugrave;","ù");
	  text = replaceAll(text,"&oacute;","ó");
	  text = replaceAll(text,"&ograve;","ò");
	  text = replaceAll(text,"&iacute;","í");
	  text = replaceAll(text,"&igrave;","ì");

	  text = replaceAll(text,"&Eacute;","É");
	  text = replaceAll(text,"&Egrave;","È");
	  text = replaceAll(text,"&Aacute;","Á");
	  text = replaceAll(text,"&Agrave;","À");
	  text = replaceAll(text,"&Uacute;","Ú");
	  text = replaceAll(text,"&Ugrave;","Ù");
	  text = replaceAll(text,"&Oacute;","Ó");
	  text = replaceAll(text,"&Ograve;","Ò");
	  text = replaceAll(text,"&Iacute;","Í");
	  text = replaceAll(text,"&Igrave;","Ì");

	  // trema
	  text = replaceAll(text,"&iuml;","ï");
	  text = replaceAll(text,"&euml;","ë");
	  text = replaceAll(text,"&ouml;","ö");
	  text = replaceAll(text,"&auml;","ä");
	  text = replaceAll(text,"&uuml;","ü");

	  text = replaceAll(text,"&Iuml;","Ï");
	  text = replaceAll(text,"&Euml;","Ë");
	  text = replaceAll(text,"&Ouml;","Ö");
	  text = replaceAll(text,"&Auml;","Ä");
	  text = replaceAll(text,"&Uuml;","Ü");

	  // hat
	  text = replaceAll(text,"&ecirc;","ê");
	  text = replaceAll(text,"&acirc;","â");
	  text = replaceAll(text,"&ucirc;","û");
	  text = replaceAll(text,"&ocirc;","ô");
	  text = replaceAll(text,"&icirc;","î");

	  text = replaceAll(text,"&Ecirc;","Ê");
	  text = replaceAll(text,"&Acirc;","Â");
	  text = replaceAll(text,"&Ucirc;","Û");
	  text = replaceAll(text,"&Ocirc;","Ô");
	  text = replaceAll(text,"&Icirc;","Î");

	  // varia


	  return text;
	}

  <%-- DELETE MSG --%>
  function deleteMsg(msgId){
    if(yesnoDeleteDialog()){
      msgForm.saveButton.disabled = true;
      msgForm.clearButton.disabled = true;
	      
      msgForm.Action.value = "deletePrevMsg";
      msgForm.deleteMsgId.value = msgId;
      msgForm.submit();
    }
  }

  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "main.do?Page=system/menu.jsp";
  }
</script>