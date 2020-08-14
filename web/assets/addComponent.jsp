<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%
	String componentuid = checkString(request.getParameter("componentuid"));
	String assetuid=componentuid.split("\\.")[0]+"."+componentuid.split("\\.")[1];
	String nomenclature = componentuid.replaceAll(assetuid+".", "");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("insert into oc_assetcomponents(oc_component_assetuid,oc_component_nomenclature,oc_component_objectid) values(?,?,?)");
	ps.setString(1, assetuid);
	ps.setString(2, nomenclature);
	ps.setInt(3,MedwanQuery.getInstance().getOpenclinicCounter("ComponentObjectId"));
	ps.execute();
	ps.close();
%>
