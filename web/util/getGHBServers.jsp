<%@page import="org.dom4j.*,org.dom4j.tree.*"%>
<%@page import="be.openclinic.system.Encryption"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	Element root = DocumentHelper.createElement("servers");
	String sDomain = checkString(request.getParameter("domain"));
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("select * from GHB_SERVERS where GHB_SERVER_DOMAIN like ?");
	ps.setString(1,sDomain+"%");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		Element server = root.addElement("server");
		server.addElement("serverid").setText(rs.getString("GHB_SERVER_ID"));
		server.addElement("domain").setText(rs.getString("GHB_SERVER_DOMAIN"));
		server.addElement("name").setText(rs.getString("GHB_SERVER_NAME"));
		server.addElement("contact").setText(rs.getString("GHB_SERVER_CONTACT"));
		server.addElement("email").setText(rs.getString("GHB_SERVER_EMAIL"));
		server.addElement("telephone").setText(rs.getString("GHB_SERVER_PHONE"));
		server.addElement("pubkey").setText(rs.getString("GHB_SERVER_PUBKEY"));
	}
	rs.close();
	ps.close();
	conn.close();
	Document document = DocumentHelper.createDocument(root);
	out.print(document.asXML());
%>
