<%@page import="org.apache.commons.io.FileUtils"%>
<%@page import="java.io.*,be.openclinic.archiving.*,org.dcm4che2.data.*,org.apache.commons.fileupload.servlet.*,org.apache.commons.fileupload.disk.*,org.apache.commons.fileupload.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	int i=0;
HashSet patients = new HashSet();
HashSet studies = new HashSet();
HashSet errors = new HashSet();

   String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
   Debug.println("SCANDIR_BASE="+SCANDIR_BASE);
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
      String filename=new java.util.Date().getTime()+"";
      while (itr.hasNext()) {
    	   i++;
           FileItem item = (FileItem) itr.next();
           if (item.isFormField()) {
           } else {
	           try {
	              String fn=SCANDIR_BASE+"/from/"+filename+"_"+i;
	        	  File savedFile = new File(fn);
	        	  InputStream is = item.getInputStream();
	        	  FileUtils.copyInputStreamToFile(is, savedFile);
	              is.close();
	              DicomObject obj = Dicom.getDicomObject(savedFile);
	              if(obj==null){
	            	  errors.add(item.getName());
	              }
	              else{
	            	  patients.add(obj.getString(Tag.PatientID));
	            	  studies.add(obj.getString(Tag.StudyID)+"</td><td>"+obj.getString(Tag.StudyDescription).replaceAll("\\^", ", "));
	              }
              } catch (Exception e) {
                   e.printStackTrace();
              }
	       }
		}
   }	
%>
<table width='100%'>
	<tr>
		<td class='admin'><%=getTran(request,"web","totalfilesreceived",sWebLanguage) %></td>
		<td class='admin2'><%=i %></td>
	</tr>
	<%if(errors.size()>0){ %>
	<tr>
		<td class='admin'><%=getTran(request,"web","errorfilesreceived",sWebLanguage) %></td>
		<td class='admin2'>
		<%
			Iterator iErrors = errors.iterator();
			while(iErrors.hasNext()){
				out.println(iErrors.next()+"<br/>");
			}
		%>
		</td>
	</tr>
	<%} %>
	<tr>
		<td class='admin'><%=getTran(request,"web","patientids",sWebLanguage) %> (<%=patients.size() %>)</td>
		<td class='admin2'>
			<table width='100%'>
		<%
			Iterator iPatients = patients.iterator();
			while(iPatients.hasNext()){
				String personid=(String)iPatients.next();
				out.println("<tr><td>"+AdminPerson.getFullName(personid)+" ("+personid+")</td></tr>");
			}
		%>
			</table>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","studyids",sWebLanguage) %> (<%=studies.size() %>)</td>
		<td class='admin2'>
		<table width='100%'>
		<%
			Iterator iStudies = studies.iterator();
			while(iStudies.hasNext()){
				out.println("<tr><td>"+((String)iStudies.next()).trim()+"</td></tr>");
			}
		%>
		</table>
		</td>
	</tr>
</table>
<script>
	//window.setTimeout("window.close();",3000);
</script>