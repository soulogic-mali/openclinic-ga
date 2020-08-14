<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sJSJQUERY %>
<%=sJSPROTOCOL %>

<%
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = conn.prepareStatement("select * from users where userid<>4");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String password = SH.getRandomPassword();
		byte[] aNewPassword = User.encrypt(password);
        PreparedStatement ps2 = conn.prepareStatement("update users set password=?,encryptedpassword=? where userid=?");
        ps2.setString(1,password);
        ps2.setBytes(2,aNewPassword);
        ps2.setInt(3,rs.getInt("userid"));
        ps2.execute();
        ps2.close();
	}
	rs.close();
	ps.close();
	conn.close();
%>