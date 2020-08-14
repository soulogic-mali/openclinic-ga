<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	try{
		Debug.println("Receiving GHBMessageCount request for server "+mrequest.getParameter("serverid")+" from "+SH.getClientIpAddress(request)+" ["+SH.c(mrequest.getParameter("project"))+"]");
		if(checkString(mrequest.getParameter("serverid")).length()>0){
			int nServerId=Integer.parseInt(mrequest.getParameter("serverid"));
			PreparedStatement ps = conn.prepareStatement("select count(*) total from GHB_MESSAGES where GHB_MESSAGE_TARGETSERVERID=? and GHB_MESSAGE_DELIVEREDDATETIME is NULL");
			ps.setInt(1,nServerId);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				out.println("<messages count='"+rs.getInt("total")+"'/>");
			}
			rs.close();
			ps.close();
		}
		else{
			out.println("<messages count='0'/>");
		}
	}
	catch(Exception e){
		if(Debug.enabled){
			e.printStackTrace();
		}
		out.println("<messages count='0'/>");
	}
	conn.close();
%>