<%@page import="be.openclinic.reporting.*,java.io.*,java.text.*"%>
<%
	String uid = request.getParameter("uid");
	Report report = Report.get(uid);
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "Attachment;Filename=\""+report.getName()+".jrxml\"");
	ServletOutputStream os = response.getOutputStream();
    byte[] b = report.getReportxml().getBytes();
    for (int n=0;n<b.length;n++) {
        os.write(b[n]);
    }
    os.flush();
    os.close();
%>