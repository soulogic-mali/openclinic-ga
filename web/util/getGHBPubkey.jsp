<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("select GHB_SERVER_PUBKEY from GHB_SERVERS where GHB_SERVER_ID=?");
	ps.setInt(1,Integer.parseInt(mrequest.getParameter("serverid")));
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		out.println("<pubkey>"+new String(rs.getBytes("GHB_SERVER_PUBKEY"))+"</pubkey>");
	}
	else{
		out.println("<pubkey error='server "+mrequest.getParameter("serverid")+" does not exist'/>");
	}
	rs.close();
	ps.close();
	conn.close();
%>