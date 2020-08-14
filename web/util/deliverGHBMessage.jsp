<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("update GHB_MESSAGES set GHB_MESSAGE_TARGETIP=?, GHB_MESSAGE_DELIVEREDDATETIME=? where GHB_MESSAGE_ID=?");
	ps.setString(1,ScreenHelper.getClientIpAddress(request));
	ps.setTimestamp(2,new java.sql.Timestamp(new java.util.Date().getTime()));
	ps.setInt(3,Integer.parseInt(mrequest.getParameter("messageid")));
	ps.execute();
	ps.close();
	conn.close();
%>