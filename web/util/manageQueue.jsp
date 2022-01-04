<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(request.getParameter("showWaitingQueuePatientName")!=null){
		session.setAttribute("showWaitingQueuePatientName", "1");
	}
	else if (request.getParameter("wasloaded")!=null){
		session.setAttribute("showWaitingQueuePatientName", "0");
	}
	int verticalFrames=1;
	if(request.getParameter("verticalFrames")!=null){
		verticalFrames=Integer.parseInt(request.getParameter("verticalFrames"));
	}
%>
<head>
    <%=sCSSNORMAL%>
    <%=sJSCHAR%>
    <%=sJSDATE%>
    <%=sJSPOPUPSEARCH%>
    <%=sJSDROPDOWNMENU%>
    <%=sJSPROTOTYPE%>
    <%=sJSNUMBER%>
    <%=sJSTOGGLE%>
</head>
<form name="transactionForm" method="post">
	<input type='hidden' name='wasloaded' value='1'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'>
			<%
			try{
			%>
				<select class='text' name='queue' id='queue' onchange='loadtickets();'>
					<%=ScreenHelper.writeSelect(request,"queue", checkString((String)session.getAttribute("activequeue")), sWebLanguage) %>
				</select>
			<%
			}
			catch(Exception e){
				e.printStackTrace();
			}
			%>
				<input type='checkbox' name='showWaitingQueuePatientName' value='1' onchange="transactionForm.submit();" <%="1".equals(((String)session.getAttribute("showWaitingQueuePatientName")))?"checked":"" %>/>
				<%= getTran(request,"web","showpatientnames",sWebLanguage) %>
			</td>
		</tr>
		<tr>
			<td>
				<div id='tickets'></div>
			<td>
		</tr>
	</table>
</form>
<%System.out.println(9);
 %>
<script>
	loadtickets();
	window.setInterval("loadtickets();",5000);
	activeresponse="";
	
	function loadtickets(){
	    var params = 'queueid=' + document.getElementById("queue").value;
	    var today = new Date();
	    var url= '<c:url value="/util/getQueueTickets.jsp"/>?ts='+today+"&verticalFrames=<%=verticalFrames%>";
		new Ajax.Request(url,{
		  method: "GET",
	      parameters: params,
	      onSuccess: function(resp){
	    	var txt = resp.responseText;
	    	if(txt!=activeresponse){
	    		$('tickets').innerHTML=txt;
	    		activeresponse=txt;
	    		var els=document.all;
	    		for(n=0;n<els.length;n++){
	    			if(els[n].id && els[n].id.indexOf("resizeFont.")>-1){
	    				els[n].style.fontSize=els[n].style.fontSize.replace('px','')*window.innerHeight/598;
	    			}
	    			else if(els[n].id && els[n].id.indexOf("resizeImage.")>-1){
	    				els[n].height=els[n].height*window.innerHeight/598;
	    			}
	    		}
	    	}
	      }
		});
	}
	
	function loadparent(personid,ticketobjectid,ticketnumber){
        if(yesnoDialogDirectText('<%=getTranNoLink("web","registerticket",sWebLanguage)%> '+ticketnumber+' <%=getTranNoLink("web","as",sWebLanguage)%> ´<%=getTranNoLink("queueendreason",MedwanQuery.getInstance().getConfigString("queueSeenValue","1"),sWebLanguage).toUpperCase()%>´')){
		    var params = 'queueid=' + document.getElementById("queue").value;
		    var today = new Date();
		    var url= '<c:url value="/util/closeTicket.jsp"/>?objectid='+ticketobjectid+'&reason=<%=MedwanQuery.getInstance().getConfigInt("queueSeenValue",1)%>';
			new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
					window.parent.opener.location.href='<c:url value="/main.do"/>?Page=curative/index.jsp&PersonID='+personid;
					window.parent.close();
		      }
			});
        }
        else{
			window.parent.opener.location.href='<c:url value="/main.do"/>?Page=curative/index.jsp&PersonID='+personid;
			window.parent.close();
        }
	}

	function registerseen(ticketobjectid,ticketnumber){
        if(yesnoDialogDirectText('<%=getTranNoLink("web","registerticket",sWebLanguage)%> '+ticketnumber+' <%=getTranNoLink("web","as",sWebLanguage)%> ´<%=getTranNoLink("queueendreason",MedwanQuery.getInstance().getConfigString("queueSeenValue","1"),sWebLanguage).toUpperCase()%>´')){
		    var params = 'queueid=' + document.getElementById("queue").value;
		    var today = new Date();
		    var url= '<c:url value="/util/closeTicket.jsp"/>?objectid='+ticketobjectid+'&reason=<%=MedwanQuery.getInstance().getConfigInt("queueSeenValue",1)%>';
			new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		    	loadtickets();
		      }
			});
        }
	}

	function registeraway(ticketobjectid,ticketnumber){
        if(yesnoDialogDirectText('<%=getTranNoLink("web","registerticket",sWebLanguage)%> '+ticketnumber+' <%=getTranNoLink("web","as",sWebLanguage)%> ´<%=getTranNoLink("queueendreason",MedwanQuery.getInstance().getConfigString("queueAwayValue","2"),sWebLanguage).toUpperCase()%>´')){
		    var params = 'queueid=' + document.getElementById("queue").value;
		    var today = new Date();
		    var url= '<c:url value="/util/closeTicket.jsp"/>?objectid='+ticketobjectid+'&reason=<%=MedwanQuery.getInstance().getConfigInt("queueAwayValue",2)%>';
			new Ajax.Request(url,{
			  method: "GET",
		      parameters: params,
		      onSuccess: function(resp){
		    	loadtickets();
		      }
			});
        }
	}

	  <%-- YESNO DIALOG DIRECT TEXT --%>
	  function yesnoDialogDirectText(labelText){
	    var answer = "";
	    
	    if(window.showModalDialog){
	      var popupUrl = "<c:url value='/_common/search/yesnoPopup.jsp'/>?ts="+new Date().getTime()+"&labelValue="+labelText;
	      var modalities = "dialogWidth:266px;dialogHeight:163px;center:yes;scrollbars:no;resizable:no;status:no;location:no;";
	      answer = window.showModalDialog(popupUrl,"",modalities);
	    }
	    else{
	      answer = window.confirm(labelText);          
	    }
	    
	    return answer; // FF
	  }
</script>