<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<option/>
<%
	String children = Service.getChildIdsAsString(SH.c((String)session.getAttribute("activeService")),500); 
	Connection conn = SH.getOpenclinicConnection();	
	PreparedStatement ps = conn.prepareStatement("select distinct oc_asset_nomenclature from oc_assets where oc_asset_service in ("+children+") and oc_asset_nomenclature like '"+SH.p(request,"type")+"%' order by oc_asset_nomenclature");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String label = rs.getString("oc_asset_nomenclature")+" - "+getTran(request,"admin.nomenclature.asset", rs.getString("oc_asset_nomenclature"), sWebLanguage).toUpperCase();
		if(label.length()>30){
			label = label.substring(0,30)+"...";
		}
		out.println("<option "+(SH.p(request,"nomenclature").equalsIgnoreCase(rs.getString("oc_asset_nomenclature"))?"selected":"")+" style='width: 95% !important;font-size: 4vw' value='"+rs.getString("oc_asset_nomenclature")+"'>"+label+"</option>");
	}
	rs.close();
	ps.close();
	conn.close();
%>
