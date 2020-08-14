<%@include file="/includes/validateUser.jsp"%>
<%
	String id = SH.c(request.getParameter("id"));
	String groupid = SH.c(request.getParameter("groupid"));
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from dc_servergroups where dc_servergroup_id=? and dc_servergroup_serverid=?");
	ps.setString(1,groupid);
	ps.setString(2,id);
	ps.execute();
	ps.close();
	conn.close();	
%>