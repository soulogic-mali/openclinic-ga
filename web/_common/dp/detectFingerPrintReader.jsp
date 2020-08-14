<%@page import="org.apache.commons.httpclient.HttpClient,
		org.apache.commons.httpclient.NameValuePair,
		org.apache.commons.httpclient.methods.GetMethod,
		org.apache.commons.httpclient.methods.PostMethod"%>
<%@include file="/includes/helper.jsp"%>
<%
	String sPageContent = "";
	HttpClient client = new HttpClient();
	String url = MedwanQuery.getInstance().getConfigString("detectFingerPrintReader.jsp","http://localhost/openclinic/_common/dp/detectFingerPrintReaderSecugen.jsp");
	GetMethod method = new GetMethod(url);
	client.executeMethod(method);
	out.print(method.getResponseBodyAsString());
%>