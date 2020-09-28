<%@page import="be.openclinic.archiving.ArchiveDocument,be.mxs.common.util.db.*,be.mxs.common.util.system.*"%>
<%@page import="java.util.Hashtable,java.io.*,org.apache.commons.io.*,be.openclinic.assets.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
                
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean">
    <jsp:setProperty name="upBean" property="folderstore" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")%>'/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","/tmp")%>'/>
    <jsp:setProperty name="upBean" property="parser" value="<%=MultipartFormDataRequest.CFUPARSER%>"/>
</jsp:useBean>

<%
	Debug.println("Uploading assets");
	if(MultipartFormDataRequest.isMultipartFormData(request)){
	    MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	    try{
	        Hashtable files = mrequest.getFiles();
	        if(files!=null && !files.isEmpty()){
	        	String sFileName = MedwanQuery.getInstance().getConfigString("tempdir","/tmp")+"/"+((UploadFile)files.get("filename")).getFileName();
                if(!SH.isAcceptableUploadFileExtension(sFileName)){
		    		out.println("<ERROR-FORBIDDEN-FILETYPE>");
                }
                else {
		        	Debug.println("working with file "+sFileName);
		        	if(new File(sFileName).exists()){
			        	Debug.println("deleting file "+sFileName);
		        		new File(sFileName).delete();
		        	}
		            upBean.setFolderstore(MedwanQuery.getInstance().getConfigString("tempdir","/tmp"));
		            upBean.setParsertmpdir(MedwanQuery.getInstance().getConfigString("tempdir","/tmp"));
		            upBean.store(mrequest, "filename");
		            StringBuffer xml=new StringBuffer();
		    		xml.append(FileUtils.readFileToString(new File(sFileName)));
		    		Asset.storeXml(xml);
		    		out.println("<OK>");
                }
	        }
	    }
	    catch(Exception e){
	    	e.printStackTrace();
	    }
	}
%>