<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%=sCSSNORMAL %>
<%=sJSPROTOTYPE %>
<%
	try{
		org.apache.commons.io.FileUtils.writeStringToFile(new java.io.File(MedwanQuery.getInstance().getConfigString("shutdown.semaphore","/backups/doshutdown")), "ok");
	}
	catch(Exception e){
		e.printStackTrace();
	}
	if(request.getParameter("os_shutdown")!=null){
		out.println("<h4>"+getTran(request,"web","system.shutdown",sWebLanguage)+"...");
		out.flush();
		ProcessBuilder pb = new ProcessBuilder(MedwanQuery.getInstance().getConfigString("shutdownScript","/sbin/shutdown"));
		pb.redirectErrorStream(true); 
		Process p = pb.start();
	}
	else if(request.getParameter("os_reboot")!=null){
		out.println("<h4>"+getTran(request,"web","system.reboot",sWebLanguage)+"...</H4>");
		out.flush();
		ProcessBuilder pb = new ProcessBuilder(MedwanQuery.getInstance().getConfigString("rebootScript","/sbin/reboot"));
		pb.redirectErrorStream(true); 
		Process p = pb.start();
	}
	else{
%>
		<p style='font-size:3vw'><%=getTran(request,"web","system.shutdown",sWebLanguage) %><span style='font-size:3vw' id='shutdownmessage'/></p>
<%
	}
%>

<script>
function doShutdownCheck(){
    var params = "";
    var url = '<c:url value="/system/shutdowncheck.jsp"/>?ts='+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: params,
      onSuccess: function(resp){
    	if(resp.responseText.indexOf("OK")>-1){
            document.getElementById('shutdownmessage').innerHTML += ".";
            window.setTimeout("doShutdownCheck()",1000);
    	}else{
    	    document.getElementById('shutdownmessage').innerHTML += "<br/><%=getTranNoLink("web","finalizing",sWebLanguage)%>...";
  			window.setTimeout("shutdownComplete()",20000);
    	}
      },
      onFailure: function(){
  	      document.getElementById('shutdownmessage').innerHTML += "<br/><%=getTranNoLink("web","finalizing",sWebLanguage)%>...";
    	  window.setTimeout("shutdownComplete()",20000);
      }
    });
}

function shutdownComplete(){
    document.getElementById('shutdownmessage').innerHTML += "<br/><%=getTranNoLink("web","shutdowncomplete",sWebLanguage)%>";
}

doShutdownCheck();
</script>