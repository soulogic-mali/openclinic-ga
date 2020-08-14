<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_BLOODCOLLECTIONS where OC_BLOODCOLLECTION_ID=?");
	ps.setInt(1,Integer.parseInt(request.getParameter("giftid")));
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
%>
		{
			"giftid":"<%=rs.getString("OC_BLOODCOLLECTION_ID")%>",
			"receptiondate":"<%=ScreenHelper.formatDate(rs.getDate("OC_BLOODCOLLECTION_DATE"))%>",
			"location":"<%=rs.getString("OC_BLOODCOLLECTION_LOCATION")%>",
			"collectionunit":"<%=rs.getString("OC_BLOODCOLLECTION_COLLECTIONUNIT")%>",
			"lastname":"<%=rs.getString("OC_BLOODCOLLECTION_PATIENTNAME")%>",
			"firstname":"<%=rs.getString("OC_BLOODCOLLECTION_PATIENTFIRSTNAME")%>",
			"dateofbirth":"<%=ScreenHelper.formatDate(rs.getDate("OC_BLOODCOLLECTION_PATIENTDATEOFBIRTH"))%>",
			"gender":"<%=rs.getString("OC_BLOODCOLLECTION_PATIENTGENDER")%>",
			"telephone":"<%=rs.getString("OC_BLOODCOLLECTION_PATIENTTELEPHONE")%>",
			"address":"<%=rs.getString("OC_BLOODCOLLECTION_PATIENTADDRESS")%>",
			"volume":"<%=rs.getString("OC_BLOODCOLLECTION_VOLUME")%>",
			"comment":"<%=rs.getString("OC_BLOODCOLLECTION_COMMENT")%>"
		}
<%
	}
	rs.close();
	ps.close();
	conn.close();
%>