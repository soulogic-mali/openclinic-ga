<%@page import="be.openclinic.system.FormFile"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="java.util.Hashtable"%>
<%
    Hashtable hParameters = SH.getMultipartFormParameters(request);
	FormFile formFile = (FormFile)hParameters.get("filename");
    if(formFile!=null){
	    if(formFile.isAcceptableUploadFileExtension()){
	        String sUid=(String)hParameters.get("fileuploadid")+formFile.getFilename().substring(formFile.getFilename().lastIndexOf("."));
	        formFile.store(SH.getScanDirectoryFromPath()+"/"+sUid);
            MedwanQuery.getInstance().getObjectCache().removeObject("transaction",(String)hParameters.get("uploadtransactionid"));
	    }
        else{
        	%>
        	<script>
        		alert("<%=getTranNoLink("web","forbiddenfiletype",sWebLanguage)%>");
        		window.close();
        	</script>
        	<%
        }
    }
%>
<script>
  
  var ie7 = (document.all && !window.opera && window.XMLHttpRequest)?true:false;
  if(ie7){     
    // required to close window without prompt for IE7
    window.open('','_parent','');
    window.close();
  }
  else{
    // required to close window without prompt for IE6
    this.focus();
    self.opener = this;
    self.close();
  }
</script>
