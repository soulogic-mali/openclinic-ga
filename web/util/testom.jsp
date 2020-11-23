<%@page import="java.nio.charset.StandardCharsets,be.openclinic.mobilemoney.*"%>
<%@page import="org.apache.http.util.EntityUtils"%>
<%@page import="org.apache.http.entity.*,org.apache.commons.codec.binary.*,javax.crypto.*,javax.crypto.spec.*,org.apache.http.client.*,org.apache.http.client.methods.*,
				org.apache.http.client.utils.*,java.net.*,org.apache.http.impl.client.*,org.apache.http.*"%>
<%
	HttpClient httpclient = HttpClients.createDefault();
	String baseurl="https://test-emoney-services.w-ha.com/api";
	URIBuilder builder = new URIBuilder(baseurl+"/transfers/authorize");
	URI uri = builder.build();
	HttpPost req = new HttpPost(uri);
	String body = "{"+
		    "\"partner_ref\" : \"INV-1888-202011201988654\","+
		    "\"tag\" : \"Facture CHU GT\","+
		    "\"receiver_wallet_id\" : \"WE-8942338340250714\","+
		    "\"sender_wallet_id\" : \"WE-4592801805723662\","+
		    "\"amount\" : 105,"+
		    "\"auth_timeout_delay\" : 86400"+
			"}";
	System.out.println(body);
    req.setHeader("Authorization", Orange.getAuthorization(body));
    req.setHeader("Content-Type", "application/json");
    StringEntity reqEntity = new StringEntity(body);
    req.setEntity(reqEntity);
    HttpResponse resp = httpclient.execute(req);
    HttpEntity entity = resp.getEntity();
    String responseBody = EntityUtils.toString(resp.getEntity(), StandardCharsets.UTF_8);
    out.println("Response: " + responseBody);
%>