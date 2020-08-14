<%@page import="java.io.*,java.nio.file.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/helper.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_certificates where oc_certificate_used is null and oc_certificate_id=?");
	ps.setString(1,request.getParameter("name"));
	ResultSet rs = ps.executeQuery();
	byte[] b = null;
	if(rs.next()){
		b = rs.getBytes("oc_certificate_key");
	}
	rs.close();
	ps.close();
	conn.close();

	response.setContentType("application/octet-stream; charset=windows-1252");
    response.setHeader("Content-Disposition", "Attachment;Filename=\"pibox.key\"");
    ServletOutputStream os = response.getOutputStream();
    for(int n=0; n<b.length; n++){
        os.write(b[n]);
    }
    os.flush();
    os.close();
%>