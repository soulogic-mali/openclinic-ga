<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%
	String componentuid = checkString(request.getParameter("componentuid"));
	String assetuid=componentuid.split("\\.")[0]+"."+componentuid.split("\\.")[1];
	int objectid = Integer.parseInt(componentuid.split("\\.")[2]);
	String nomenclature = componentuid.replaceAll(assetuid+"."+objectid+".", "");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_assetcomponents where oc_component_assetuid=? and oc_component_nomenclature=? and oc_component_objectid=?");
	ps.setString(1, assetuid);
	ps.setString(2, nomenclature);
	ps.setInt(3,objectid);
	ps.execute();
	ps.close();
%>
