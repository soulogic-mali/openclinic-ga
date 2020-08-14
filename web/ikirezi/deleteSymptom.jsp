<%@page import="be.openclinic.knowledge.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_ikirezisymptoms where oc_symptom_id=? and oc_symptom_encounteruid=?");
	ps.setString(1,request.getParameter("symptomid"));
	ps.setString(2,request.getParameter("encounteruid"));
	ps.execute();
	ps.close();
	conn.close();
%>