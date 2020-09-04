<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","all",activeUser)%>
<%@page import="javazoom.upload.MultipartFormDataRequest,
                javazoom.upload.UploadFile,org.dom4j.*,org.dom4j.io.*,
                java.io.*,be.mxs.common.util.system.*,be.mxs.common.util.db.*"%>

<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","c:/temp") %>' />
    <jsp:setProperty name="upBean" property="parser" value="<%= MultipartFormDataRequest.DEFAULTPARSER	 %>"/>
  	<jsp:setProperty name="upBean" property="filesizelimit" value="8589934592"/>
  	<jsp:setProperty name="upBean" property="overwrite" value="true"/>
  	<jsp:setProperty name="upBean" property="dump" value="true"/>
    <jsp:setProperty name="upBean" property="parsertmpdir" value='<%=MedwanQuery.getInstance().getConfigString("tempDirectory","c:/temp") %>'/>
</jsp:useBean>
<%
	MultipartFormDataRequest mrequest;
	if (MultipartFormDataRequest.isMultipartFormData(request)) {
	    // Uses MultipartFormDataRequest to parse the HTTP request.
		mrequest = new MultipartFormDataRequest(request);
		if (mrequest.getParameter("submit")!=null){
            Hashtable files = mrequest.getFiles();
            if (files != null && !files.isEmpty()){
                UploadFile file = (UploadFile) files.get("filename");
                String targetFolder = mrequest.getParameter("targetfolder");
                String filename = file.getFileName();
    			String setupdir=request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\","/");
    			String fullFileName=(setupdir+"/"+targetFolder+"/"+filename).replaceAll("//","/").replaceAll("//","/");
                System.out.println(fullFileName);
                File newFile = new File(fullFileName);
                if(newFile.exists()){
                	newFile.delete();
                }
                FileOutputStream os = new FileOutputStream(newFile);
        	    byte[] b = file.getData();
        	    for(int n=0; n<b.length; n++){
        	        os.write(b[n]);
        	    }
        	    os.flush();
        	    os.close();
            }
		}
	}

%>
<form name='transactionForm' method='post' enctype="multipart/form-data">
	<table width='100%'>
		<tr class='admin'>
			<td class='admin'><%=getTran(request,"web","targetfolder",sWebLanguage) %></td>
			<td class='admin2'>
				<b><%=request.getSession().getServletContext().getRealPath("/").replaceAll("\\\\","/") %></b>
				<input class='text' type='text' size='60' name='targetfolder'/>
			</td>
		</tr>
		<tr class='admin'>
			<td class='admin'><%=getTran(request,"web","filename",sWebLanguage) %></td>
			<td class='admin2'><input class='text' type='file' name='filename'/></td>
		</tr>
	</table>
	<input class='button' type='submit' name='submit' value='<%=getTran(request,"web","save",sWebLanguage) %>'/>
</form>