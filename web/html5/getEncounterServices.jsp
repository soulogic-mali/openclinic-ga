<%@include file="/includes/helper.jsp"%>
<select name='service' id='service' style='font-size:6vw;max-width: 160px'>
	<option/>
<%
	String type = request.getParameter("type");
	String language = request.getParameter("language");
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = null;
	if(type.equalsIgnoreCase("visit")){
		ps=conn.prepareStatement("select * from services where acceptsVisits=1 order by serviceid");
	}
	else{
		ps=conn.prepareStatement("select * from services where totalbeds>0 order by serviceid");
	}
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String serviceid=rs.getString("serviceid");
		out.println("<option value='"+serviceid+"'>["+serviceid.toUpperCase()+"] "+getTranNoLink("service",serviceid,language)+"</option>");
	}
	rs.close();
	ps.close();
	conn.close();
%>
</select>
