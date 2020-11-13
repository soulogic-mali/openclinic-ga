<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*"%>
<%
	HttpClient client = new HttpClient();
	PostMethod method = new PostMethod("http://openclinic.chuk.hnrw.org/openclinic/util/sendGmailMessage.jsp");
	NameValuePair[] nvp = new NameValuePair[9];
	nvp[0]= new NameValuePair("user","frank@ict4d.be");
	nvp[1]= new NameValuePair("password","Bigo4ever");
	nvp[2]= new NameValuePair("from","frank@ict4d.be");
	nvp[3]= new NameValuePair("fromName","KHIN Server");
	nvp[4]= new NameValuePair("to","frank@ict4d.be");
	nvp[5]= new NameValuePair("replyto","frank@ict4d.be");
	nvp[6]= new NameValuePair("subject","KHIN Login");
	nvp[7]= new NameValuePair("message","*<img width='120px' src=\"cid:image_logo\">* Testcontent");
	nvp[8]= new NameValuePair("logo","/var/tomcat/webapps/openclinic/projects/khin/_img/logo_khin.gif");
	method.setQueryString(nvp);
	int statusCode = client.executeMethod(method);
%>