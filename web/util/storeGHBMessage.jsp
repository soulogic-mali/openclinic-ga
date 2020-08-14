<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	Debug.println("storeGHBMessage called...");
	try{
		MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
		Debug.println("Received GHB message from server "+mrequest.getParameter("sourceserverid")+" for server "+mrequest.getParameter("targetserverid"));
		Connection conn = MedwanQuery.getInstance().getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("insert into GHB_MESSAGES(GHB_MESSAGE_ID,GHB_MESSAGE_SOURCESERVERID,GHB_MESSAGE_SOURCEIP,GHB_MESSAGE_TARGETSERVERID,GHB_MESSAGE_RECEIVEDDATETIME,GHB_MESSAGE_DATA,GHB_MESSAGE_TOKEN) values(?,?,?,?,?,?,?)");
		ps.setInt(1,MedwanQuery.getInstance().getOpenclinicCounter("GHB_MESSAGE_IN"));
		ps.setInt(2,Integer.parseInt(mrequest.getParameter("sourceserverid")));
		ps.setString(3,ScreenHelper.getClientIpAddress(request));
		ps.setInt(4,Integer.parseInt(mrequest.getParameter("targetserverid")));
		ps.setTimestamp(5,new Timestamp(new java.util.Date().getTime()));
		ps.setBytes(6,mrequest.getParameter("data").getBytes());
		ps.setBytes(7,mrequest.getParameter("token").getBytes());
		ps.execute();
		ps.close();
		conn.close();
		Debug.println("Message successfully stored");
		out.println("<ok>");
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>