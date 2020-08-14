<%@page import="java.io.*,java.nio.file.*,org.apache.commons.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	String name = request.getParameter("name");
	HttpClient client = new HttpClient();
	GetMethod method = new GetMethod("http://bigo.mxs.hnrw.org/globalhealthbarometer/util/getCertificateCertificate.jsp?name="+name);
	method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
	int statusCode = client.executeMethod(method);
	byte[] responseBody = method.getResponseBody();
	FileUtils.writeByteArrayToFile(new File("/etc/openvpn/pibox.crt"), responseBody);
	method = new GetMethod("http://bigo.mxs.hnrw.org/globalhealthbarometer/util/getCertificateKey.jsp?name="+name);
	method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
	statusCode = client.executeMethod(method);
	responseBody = method.getResponseBody();
	FileUtils.writeByteArrayToFile(new File("/etc/openvpn/pibox.key"), responseBody);
%>