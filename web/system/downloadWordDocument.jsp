<%@include file="/includes/helper.jsp"%><%
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select * from worddocuments where name=?");
	ps.setString(1,new String(Base64.getDecoder().decode(checkString(request.getParameter("name")))));
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"OpenClinic_MSWord"+new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date())+".docx\"");
	    ServletOutputStream os = response.getOutputStream();
		byte[] b = rs.getBytes("document"); 
		rs.close();
		ps.close();
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	else{
		rs.close();
		ps.close();
	}
%>