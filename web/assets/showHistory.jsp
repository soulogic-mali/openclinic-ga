<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String type=SH.p(request,"type");
	String assetType=SH.p(request,"assetType");
	String uid = SH.p(request,"uid");
	String title = "";
	StringBuffer sResult = new StringBuffer();
	
	if(type.equalsIgnoreCase("asset")){
		title=getTran(request,"web","history",sWebLanguage)+" - "+getTran(request,"web",assetType,sWebLanguage);
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_assetshistory where oc_asset_serverid=? and oc_asset_objectid=? order by oc_asset_historydate desc");
		ps.setInt(1,Integer.parseInt(uid.split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(uid.split("\\.")[1]));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			sResult.append("<tr>");
			sResult.append("<td class='admin'><a href='javascript:showAssetHistoryDate(\""+SH.formatSQLDate(rs.getTimestamp("oc_asset_historydate"),"yyyyMMddHHmmssSSS")+"\")'>"+SH.formatSQLDate(rs.getTimestamp("oc_asset_updatetime"),"dd/MM/yyyy HH:mm")+"</a></td>");
			sResult.append("<td class='admin'>"+User.getFullUserName(rs.getString("oc_asset_updateid"))+"</td>");
			sResult.append("<td class='admin'>"+getTran(request,"web","modifiedby",sWebLanguage)+": "+User.getFullUserName(rs.getString("oc_asset_historyuser"))+" ["+SH.formatSQLDate(rs.getTimestamp("oc_asset_historydate"),"dd/MM/yyyy HH:mm")+"]</td>");
			sResult.append("</tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
	else if(type.equalsIgnoreCase("maintenanceplan")){
		title=getTran(request,"web","history",sWebLanguage)+" - "+getTran(request,"web","maintenanceplan",sWebLanguage);
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceplanshistory where oc_maintenanceplan_serverid=? and oc_maintenanceplan_objectid=? order by oc_maintenanceplan_historydate desc");
		ps.setInt(1,Integer.parseInt(uid.split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(uid.split("\\.")[1]));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			sResult.append("<tr>");
			sResult.append("<td class='admin'><a href='javascript:showPlanHistoryDate(\""+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceplan_historydate"),"yyyyMMddHHmmssSSS")+"\")'>"+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceplan_updatetime"),"dd/MM/yyyy HH:mm")+"</a></td>");
			sResult.append("<td class='admin'>"+User.getFullUserName(rs.getString("oc_maintenanceplan_updateid"))+"</td>");
			sResult.append("<td class='admin'>"+getTran(request,"web","modifiedby",sWebLanguage)+": "+User.getFullUserName(rs.getString("oc_maintenanceplan_historyuser"))+" ["+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceplan_historydate"),"dd/MM/yyyy HH:mm")+"]</td>");
			sResult.append("</tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
	else if(type.equalsIgnoreCase("maintenanceoperation")){
		title=getTran(request,"web","history",sWebLanguage)+" - "+getTran(request,"web.asset","maintenanceoperation",sWebLanguage);
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceoperationshistory where oc_maintenanceoperation_serverid=? and oc_maintenanceoperation_objectid=? order by oc_maintenanceoperation_historydate desc");
		ps.setInt(1,Integer.parseInt(uid.split("\\.")[0]));
		ps.setInt(2,Integer.parseInt(uid.split("\\.")[1]));
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			sResult.append("<tr>");
			sResult.append("<td class='admin'><a href='javascript:showOperationHistoryDate(\""+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceoperation_historydate"),"yyyyMMddHHmmssSSS")+"\")'>"+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceoperation_updatetime"),"dd/MM/yyyy HH:mm")+"</a></td>");
			sResult.append("<td class='admin'>"+User.getFullUserName(rs.getString("oc_maintenanceoperation_updateid"))+"</td>");
			sResult.append("<td class='admin'>"+getTran(request,"web","modifiedby",sWebLanguage)+": "+User.getFullUserName(rs.getString("oc_maintenanceoperation_historyuser"))+" ["+SH.formatSQLDate(rs.getTimestamp("oc_maintenanceoperation_historydate"),"dd/MM/yyyy HH:mm")+"]</td>");
			sResult.append("</tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
	
%>
<table width='100%'>
	<tr class='admin'><td colspan='3'><%=title %></td></tr>
	<%=sResult.toString() %>
</table>
<script>
	function showPlanHistoryDate(timestamp){
		openPopup("assets/manage_maintenancePlans.jsp&timestamp="+timestamp+"&action=history&EditPlanUID=<%=uid%>",1200,600);
	}
	function showAssetHistoryDate(timestamp){
		openPopup("assets/manage_assets.jsp&assetType=<%=assetType%>&timestamp="+timestamp+"&action=history&EditAssetUID=<%=uid%>",1200,600);
	}
	function showOperationHistoryDate(timestamp){
		openPopup("assets/manage_maintenanceOperations.jsp&timestamp="+timestamp+"&action=history&operationUID=<%=uid%>",1200,600);
	}
</script>