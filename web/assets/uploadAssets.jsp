<%@page import="be.openclinic.archiving.ArchiveDocument,be.mxs.common.util.db.*,be.mxs.common.util.system.*"%>
<%@page import="java.util.Hashtable,java.io.*,org.apache.commons.io.*,be.openclinic.assets.*"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="org.apache.commons.fileupload.servlet.*,java.util.*"%>
<%
	Debug.println("Uploading assets");
	if(ServletFileUpload.isMultipartContent(request)){
	    FileItemFactory factory = new DiskFileItemFactory();
	    ServletFileUpload upload = new ServletFileUpload(factory);
	    List items = null;
	    try {
	        items = upload.parseRequest(request);
		    Iterator itr = items.iterator();
		    while (itr.hasNext()) {
		        FileItem item = (FileItem) itr.next();
                if(!ScreenHelper.isAcceptableUploadFileExtension(item.getName())){
		    		out.println("<ERROR-FORBIDDEN-FILETYPE>");
                }
                else {
                	InputStream is = item.getInputStream();
		    		StringBuffer xml = new StringBuffer();
		    		xml.append(IOUtils.toString(is, Charsets.UTF_8.name()));
		    		Asset.storeXml(xml);
		    		out.println("<OK>");
                }
		    }
        } catch (FileUploadException e) {
             e.printStackTrace();
        }
	 }
%>