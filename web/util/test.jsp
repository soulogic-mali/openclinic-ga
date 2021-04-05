<%@page import="be.openclinic.medical.*"%>
<%@page import="java.util.*"%>
<%@page import="org.apache.http.client.utils.URIBuilder"%>
<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,be.openclinic.system.*"%>
<%
	response.setContentType("application/octet-stream; charset=windows-1252");
	response.setHeader("Content-Disposition","Attachment;Filename=\"OpenClinicStatistic"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".csv\"");
	
	ServletOutputStream os = response.getOutputStream();
	byte[] b = BloodGift.getCsvReport(request.getParameter("begin"), request.getParameter("end")).toString().getBytes("ISO-8859-1");
	for(int n=0; n<b.length; n++){
	    os.write(b[n]);
	}
	os.flush();
	os.close();
%>