<%@page import="org.dom4j.*,java.io.*,java.nio.file.*,org.apache.commons.io.*,org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*"%>
<%@page import="be.openclinic.system.Encryption"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	HttpClient client = new HttpClient();
	PostMethod method = new PostMethod(MedwanQuery.getInstance().getConfigString("ghb_ref_updateurl","http://www.globalhealthbarometer.net/globalhealthbarometer/util/getGHBServers.jsp"));
	method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
	NameValuePair[] nvp = new NameValuePair[1];
	nvp [0] = new NameValuePair("domain",checkString(request.getParameter("domain")));
	method.setQueryString(nvp);
	int statusCode = client.executeMethod(method);
	System.out.println("response="+method.getResponseBodyAsString());
	if(method.getResponseBodyAsString().contains("<servers")){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from GHB_SERVERS");
		ps.execute();
		ps.close();
		Document document=DocumentHelper.parseText(method.getResponseBodyAsString().substring(method.getResponseBodyAsString().indexOf("<servers")));
		Element root = document.getRootElement();
		Iterator servers = root.elementIterator("server");
		while(servers.hasNext()){
			Element server = (Element)servers.next();
			ps=conn.prepareStatement("insert into GHB_SERVERS(GHB_SERVER_DOMAIN,GHB_SERVER_NAME,GHB_SERVER_CONTACT,GHB_SERVER_PHONE,GHB_SERVER_EMAIL,GHB_SERVER_PUBKEY,GHB_SERVER_UPDATETIME,GHB_SERVER_ID) values(?,?,?,?,?,?,?,?)");
			ps.setString(1,server.elementText("domain"));
			ps.setString(2,server.elementText("name"));
			ps.setString(3,server.elementText("contact"));
			ps.setString(4,server.elementText("telephone"));
			ps.setString(5,server.elementText("email"));
			ps.setString(6,server.elementText("pubkey"));
			ps.setTimestamp(7, new Timestamp(new java.util.Date().getTime()));
			ps.setInt(8,Integer.parseInt(server.elementText("serverid")));
			ps.execute();
			ps.close();
		}
		ps.close();
		conn.close();
		out.println("Updated "+root.elements("server").size()+" servers");
	}
%>