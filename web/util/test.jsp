<%@include file="/includes/validateUser.jsp"%>
<%
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select oc_wicket_credit_operationdate as DATE from oc_wicket_credits limit 1");
	ResultSet rs = ps.executeQuery();
	rs.next();
	Object o = rs.getObject("DATE");
	out.println(o.getClass().getName());
	rs.close();
	ps.close();
	conn.close();
%>
