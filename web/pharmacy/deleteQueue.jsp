<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String listuid=checkString(request.getParameter("listuid"));
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_drugsoutlist where oc_list_serverid=? and oc_list_objectid=?");
	ps.setString(1, listuid.split("\\.")[0]);
	ps.setString(2, listuid.split("\\.")[1]);
	ps.execute();
	ps.close();
	conn.close();
%>