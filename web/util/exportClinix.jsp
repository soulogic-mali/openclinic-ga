<%@ page import="be.openclinic.sync.*,org.dom4j.*,be.mxs.common.util.system.SessionMessage,java.text.*" %><%
	response.setContentType("application/octet-stream");
	response.setHeader("Content-Disposition", "Attachment;Filename=\"ClinixRecord."+request.getParameter("personid")+"." + new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()) + ".xml\"");
	ServletOutputStream os = response.getOutputStream();
	OpenclinicSlaveExporter exporter = new OpenclinicSlaveExporter(new SessionMessage());
	Document document = exporter.exportToXML(request.getParameter("personid"));
	byte[] b = document.asXML().getBytes();
	for (int n=0;n<b.length;n++) {
	    os.write(b[n]);
	}
	os.flush();
	os.close();
%>