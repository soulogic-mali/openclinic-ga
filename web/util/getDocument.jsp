<%@page import="java.nio.file.Files"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String document = checkString(request.getParameter("document"));
	response.setContentType("application/octet-stream");
	File file = new File(document);
	if(file.exists()){
		response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinicLibrary"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+"."+file.getName());
	    ServletOutputStream os = response.getOutputStream();
	    byte[] b = Files.readAllBytes(file.toPath());
	    for(int n=0; n<b.length; n++){
	        os.write(b[n]);
	    }
	    os.flush();
	    os.close();
	}
%>