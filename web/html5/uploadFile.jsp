<%@page import="java.io.*,be.openclinic.archiving.*,org.dcm4che2.data.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
try {
   String directory = MedwanQuery.getInstance().getConfigString("html5UploadFolder","/var/tomcat/webapps/openclinic/_common/xml");
   boolean isMultipart = ServletFileUpload.isMultipartContent(request);
   if (!isMultipart) {
	   Debug.println("NOT MULTIPART");
   }
   else{
      FileItemFactory factory = new DiskFileItemFactory();
      ServletFileUpload upload = new ServletFileUpload(factory);
      List items = null;
      try {
          items = upload.parseRequest(request);
          } catch (FileUploadException e) {
               e.printStackTrace();
          }
      Iterator itr = items.iterator();
      while (itr.hasNext()) {
           FileItem item = (FileItem) itr.next();
           if(!item.isFormField() && item.getName()!=null){
              System.out.println("File name = "+item.getName());
        	  File savedFile = new File(directory+"/"+item.getName());
        	  if(savedFile.exists()){
        		  savedFile.delete();
        	  }
              item.write(savedFile);
           }
		}
   	}	
   out.print("<script>window.location.href='welcomespt.jsp';</script>");
}
catch(Exception e){
 e.printStackTrace();
}
%>
