<%@ include file="/includes/validateUser.jsp" %>
<%
	String sId = checkString(request.getParameter("id"));
	String sResourceId = checkString(request.getParameter("resourceid"));
	
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_reservations where oc_reservation_resourceuid=? and oc_reservation_planninguid=?");
	ps.setString(1,sResourceId);
	ps.setString(2, sId);
	ps.execute();
%>