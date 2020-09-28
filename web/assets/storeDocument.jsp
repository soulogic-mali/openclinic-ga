<%@page import="be.openclinic.archiving.ArchiveDocument,be.mxs.common.util.db.*,be.mxs.common.util.system.*"%>
<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
                
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean">
    <jsp:setProperty name="upBean" property="folderstore" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")%>'/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")%>'/>
    <jsp:setProperty name="upBean" property="parser" value="<%=MultipartFormDataRequest.CFUPARSER%>"/>
</jsp:useBean>

<%
	String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
    String sFolderStore = SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
    String sFileName = "";
    if(MultipartFormDataRequest.isMultipartFormData(request)){
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        try{
            Hashtable files = mrequest.getFiles();
            if(files!=null && !files.isEmpty()){
                UploadFile file = (UploadFile)files.get("filename");
                sFileName = file.getFileName();
                if(SH.isAcceptableUploadFileExtension(sFileName)){
                	out.println("<ERROR-FORBIDDEN-FILETYPE>");
                }
                else if(!new File(sFolderStore+"/"+mrequest.getParameter("folder")+"/"+sFileName).exists()){
                	if(!new File(sFolderStore+"/"+mrequest.getParameter("folder")).exists()){
                		new File(sFolderStore+"/"+mrequest.getParameter("folder")).mkdirs();
                	}
	                upBean.setFolderstore(sFolderStore+"/"+mrequest.getParameter("folder"));
	                upBean.setParsertmpdir(application.getRealPath("/")+"/"+MedwanQuery.getInstance().getConfigString("tempdir","/tmp/"));
	                upBean.store(mrequest, "filename");
	                out.println("<OK>");
                }
                else{
                	out.println("<ERROR>");
                }
            }
        }
        catch(Exception e){
        	e.printStackTrace();
        }
    }
%>
