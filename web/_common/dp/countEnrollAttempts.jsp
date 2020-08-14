<%@page import="org.apache.commons.httpclient.HttpClient,
		org.apache.commons.httpclient.NameValuePair,
		org.apache.commons.httpclient.methods.GetMethod,
		org.apache.commons.httpclient.methods.PostMethod"%>
<%@include file="/includes/helper.jsp"%>
<%
	HttpClient client = new HttpClient();
	String url = MedwanQuery.getInstance().getConfigString("enrollFingerPrint.jsp","http://localhost/openclinic/_common/dp/countEnrollAttemptsRemote.jsp");
	GetMethod method = new GetMethod(url);
	client.executeMethod(method);
	out.print(method.getResponseBodyAsString());
%>