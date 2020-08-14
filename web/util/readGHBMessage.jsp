<%@page import="java.util.Hashtable,java.io.*,
                javazoom.upload.UploadFile,
                javazoom.upload.MultipartFormDataRequest"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
	Connection conn = MedwanQuery.getInstance().getStatsConnection();
	PreparedStatement ps = conn.prepareStatement("select * from GHB_MESSAGES where GHB_MESSAGE_ID=?");
	ps.setInt(1,Integer.parseInt(mrequest.getParameter("messageid")));
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		out.println("<message id='"+rs.getInt("GHB_MESSAGE_ID")+"'>");
		out.println("<targetserverid>"+rs.getInt("GHB_MESSAGE_TARGETSERVERID")+"</targetserverid>");
		out.println("<sourceserverid>"+rs.getInt("GHB_MESSAGE_SOURCESERVERID")+"</sourceserverid>");
		out.println("<token>"+new String(rs.getBytes("GHB_MESSAGE_TOKEN"))+"</token>");
		out.println("<data>"+new String(rs.getBytes("GHB_MESSAGE_DATA"))+"</data>");
		out.println("</message>");
	}
	rs.close();
	ps.close();
	conn.close();
%>