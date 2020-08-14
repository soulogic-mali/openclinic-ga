<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	out.println("<messages>");
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("select * from GHB_MESSAGES where GHB_MESSAGE_TARGETSERVERID=? and GHB_MESSAGE_DELIVEREDDATETIME is NULL");
	ps.setInt(1,Integer.parseInt(mrequest.getParameter("serverid")));
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		out.println("<message id='"+rs.getInt("GHB_MESSAGE_ID")+"'/>");
	}
	rs.close();
	ps.close();
	conn.close();
	out.println("</messages>");
%>