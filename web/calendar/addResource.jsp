<%@ include file="/includes/validateUser.jsp" %>
<%
	String sId = checkString(request.getParameter("id"));
	String sResourceId = checkString(request.getParameter("resourceid"));
	
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_reservations where oc_reservation_resourceuid=? and oc_reservation_planninguid=?");
	ps.setString(1,sResourceId);
	ps.setString(2, sId);
	ps.execute();
	ps=conn.prepareStatement(	"insert into oc_reservations(oc_reservation_serverid,oc_reservation_objectid,oc_reservation_resourceuid,oc_reservation_planninguid,"+
								" oc_reservation_updatetime,oc_reservation_updateuid,oc_reservation_createdatetime,oc_reservation_version)"+
								" values(?,?,?,?,?,?,?,1)");
	ps.setString(1,SH.sid());
	ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("OC_RESERVATIONS"));
	ps.setString(3,sResourceId);
	ps.setString(4, sId);
	ps.setTimestamp(5, new Timestamp(new java.util.Date().getTime()));
	ps.setString(6,activeUser.userid);
	ps.setTimestamp(7, new Timestamp(new java.util.Date().getTime()));
	ps.execute();
	ps.close();
	conn.close();
%>