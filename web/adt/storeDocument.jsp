<%@page import="be.openclinic.system.FormFile"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page import="java.util.Hashtable"%>
<%
    String sFolderStore = application.getRealPath("/")+MedwanQuery.getInstance().getConfigString("documentsdir","adt/documents/");
    Hashtable hParameters = SH.getMultipartFormParameters(request);
    String sReturnField = (String)hParameters.get("ReturnField");
    FormFile formFile = (FormFile)hParameters.get("filename");
    if(formFile!=null){
        try{
        	if(formFile.isAcceptableUploadFileExtension()){
        		formFile.store(sFolderStore+"/"+formFile.getFilename());
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
        catch(Exception e){
            e.printStackTrace();
        }
    }
%>
<script>
  window.resizeTo(1,1);
  window.opener.document.getElementsByName('<%=sReturnField%>')[0].value='<%=sFileName%>';
  window.close();
</script>