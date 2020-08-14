<%@page import="be.openclinic.api.*"%>
<%
	ImagingWorklist worklist = new ImagingWorklist(request);
	if(worklist.value("output","body").equalsIgnoreCase("attachment")){
		String s=worklist.get();
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"openclinic_api_"+new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".txt\"");
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = s.getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	else{
		out.println(worklist.get());
	}
%>