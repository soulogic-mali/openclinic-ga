<%@page import="be.mxs.common.util.db.MedwanQuery,
                be.mxs.common.util.system.ScreenHelper,
                be.mxs.common.util.system.Debug"%>
<%@include file="commonFunctions.jsp"%>

<%    
    int snoozeTimeInMillis = MedwanQuery.getInstance().getConfigInt("messageCheckerSnoozeTimeInMinutes",5)*60*1000,
        checkTimeInMillis  = MedwanQuery.getInstance().getConfigInt("messageCheckerTimeout",10*1000); // 10 seconds

    /*
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
	    Debug.println("\n********************* includes/messageChecker.jsp *********************");
	    Debug.println("snoozeTimeInMillis : "+snoozeTimeInMillis);
	    Debug.println("checkTimeInMillis  : "+checkTimeInMillis+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
    */
%>   
                   
<script>  
  var snoozeTimeInMillis = "<%=snoozeTimeInMillis%>",
      checkTimeInMillis = "<%=checkTimeInMillis%>";
  var interval,heartbeat;   
  heartbeat = window.setTimeout("heartBeat()",500);
  <%
      Long snoozeDueTime = 0L;
  	  if(ScreenHelper.getTranExists("systemMessages","mainMessage","en").length()==0){
  		session.removeAttribute("snoozeDueTime");
  	  }
      if(session.getAttribute("snoozeDueTime")!=null){
    	  // message displayed before, only check for message when snooze due time is passed
    	  snoozeDueTime = Long.parseLong((String)session.getAttribute("snoozeDueTime"));

    	  if(snoozeDueTime==0){
    		  // stop checking for messages when snoozeDueTime is 0    		  
    	  }
    	  else{    		  
			  long remainingMillisTillSnoozeDueTime = (new java.util.Date(snoozeDueTime).getTime()-new java.util.Date().getTime());
	     	  Debug.println(" --> remainingMillisTillSnoozeDueTime : "+remainingMillisTillSnoozeDueTime);
	    	  
	    	  if(remainingMillisTillSnoozeDueTime < 0){
	    		  %>checkForMessage();<%
	    	  }
	    	  else{
	      	      %>interval = window.setInterval("checkForMessage()",<%=remainingMillisTillSnoozeDueTime%>);<% 
	    	  }
    	  }
      }
      else{
    	  // message NOT displayed before
          %>checkForMessage();<%    
      }
  %>
  
  <%-- CHECK FOR MESSAGE --%>
  function checkForMessage(){
	    var url = "<c:url value='/includes/ajax/checkForMessage.jsp'/>?ts="+new Date().getTime();
	   
	    new Ajax.Request(url,{
	      onSuccess: function(resp){
	        var data = eval("("+resp.responseText+")");
            window.clearInterval(interval);
	    	if(data.labelType.length > 0){	
	          yesnoModalbox(data.message);
	    	}
	    	else{    	  
	    	  <%-- continue --%>
	  	      interval = window.setInterval("checkForMessage()",checkTimeInMillis);  	      
	    	}
	      }
	    });
  }
	    
  function heartBeat(){
	    if(!window.sessionStorage.getItem('tabid')){
	    	window.sessionStorage.setItem('tabid',new Date().getMilliseconds());
	    }
	    var url = "<c:url value='/includes/ajax/heartBeat.jsp'/>?tabid="+window.sessionStorage.getItem('tabid')+"&ts="+new Date().getTime();
	    new Ajax.Request(url,{
	      onSuccess: function(resp){
	        var data = eval("("+resp.responseText+")");
            window.clearInterval(heartbeat);
	    	if(data.action.length>0){	
	    		if(data.action=="invalidate"){
	    			alert('<%=getTranNoLink("web","cannothaveseveraltabsopen",sWebLanguage)%>');
	    			window.location.href='<%=sCONTEXTPATH%>/login.jsp';
	    		}
	    	}
	    	else{    	  
	          heartbeat = window.setInterval("heartBeat()",2000);  	      
	    	}
	      }
	    });
  }
	    
  <%-- DO SNOOZE (yes-button) --%>
  function doSnooze(){
    window.clearInterval(interval);
    interval = window.setInterval("checkForMessage()",snoozeTimeInMillis);
    setSnoozeInSession();
  }
  
  <%-- DO NOT SNOOZE (no-button) --%>
  function doNotSnooze(){
	window.clearInterval(interval);
	clearSnoozeInSession();
  }
    
  <%-- SET SNOOZE IN SESSION (after doSnooze) --%>
  function setSnoozeInSession(){
    var url = "<c:url value='/includes/ajax/setSnoozeInSession.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      parameters: "Action=set"
    });
  }
  
  <%-- SET SNOOZE IN SESSION (after doSnooze) --%>
  function clearSnoozeInSession(){
    var url = "<c:url value='/includes/ajax/setSnoozeInSession.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      parameters: "Action=clear"
    });
  }
  
  function logmessage(msg){
    var url = "<c:url value='/includes/logmessage.jsp'/>";
    new Ajax.Request(url,{
    	method: 'post',
      parameters: "msg="+msg
    });
  }
  
  <%-- OBSERVERS for yesNoModalbox --%>
  var yesObserver = doSnooze.bindAsEventListener(Modalbox),
      noObserver  = doNotSnooze.bindAsEventListener(Modalbox);
  
  function setObservers(){
	$("yesButton").observe("click",yesObserver);
	$("noButton").observe("click",noObserver);
  }
  
  function removeObservers(){
	$("yesButton").stopObserving("click",yesObserver);
	$("noButton").stopObserving("click",noObserver);
  }
  
  <%-- YESNO MODALBOX (2 buttons) --%>
  function yesnoModalbox(msg){
    var html = "<div style='border:1px solid #bbccff;padding:1px;'>"+ // class="warning"
                "<p>"+msg+"</p>"+
                "<p style='text-align:center'>"+
                 "<input type='button' class='button' id='yesButton' style='padding-left:7px;padding-right:7px' value='<%=getTranNoLink("web","yes",sWebLanguage)%>' onclick='Modalbox.hide();'/>&nbsp;&nbsp;"+
                 "<input type='button' class='button' id='noButton' style='padding-left:7px;padding-right:7px' value='<%=getTranNoLink("web","no",sWebLanguage)%>' onclick='Modalbox.hide();'/>"+
                "</p>"+
               "</div>";
    Modalbox.show(html,{title:'<%=getTranNoLink("web","message",sWebLanguage)%>',width:300,afterLoad:setObservers,onHide:removeObservers});
  }
</script>