<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	StringBuffer sResult = new StringBuffer();
	int assets=0,plans=0,operations=0;
	if(SH.p(request,"submitButton").length()>0 && SH.p(request,"begin").length()>0 && SH.p(request,"end").length()>0){
		String userid = SH.p(request,"user");
		long day = 24*3600*1000;
		java.util.Date begin = SH.parseDate(SH.p(request,"begin"));
		java.util.Date end = new java.util.Date(SH.parseDate(SH.p(request,"end")).getTime()+day-1);
		System.out.println("begin="+begin);
		System.out.println("end="+end);
		StringBuffer sql = new StringBuffer();
		sql.append("SELECT 'asset' type,oc_asset_serverid serverid,oc_asset_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_asset_updatetime updatetime,");
		sql.append(" oc_asset_description name");
		sql.append(" ,null timestamp");
		sql.append(" from oc_assets");
		sql.append(" WHERE oc_asset_updateid=? AND");
		sql.append(" oc_asset_updatetime>=? AND");
		sql.append(" oc_asset_updatetime<? AND");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" UNION");
		sql.append(" SELECT 'asset.history' type,oc_asset_serverid serverid,oc_asset_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_asset_updatetime updatetime,");
		sql.append(" oc_asset_description name");
		sql.append(" ,oc_asset_historydate timestamp");
		sql.append(" from oc_assetshistory");
		sql.append(" WHERE oc_asset_updateid=? AND");
		sql.append(" oc_asset_updatetime>=? AND");
		sql.append(" oc_asset_updatetime<? AND");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" UNION");
		sql.append(" SELECT 'plan' type,oc_maintenanceplan_serverid serverid,oc_maintenanceplan_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_maintenanceplan_updatetime updatetime,");
		sql.append(" oc_maintenanceplan_name||' ['||oc_asset_description||']' NAME");
		sql.append(" ,null timestamp");
		sql.append(" from oc_assets,oc_maintenanceplans");
		sql.append(" WHERE ");
		sql.append(" oc_asset_objectid=REPLACE(oc_maintenanceplan_assetuid,'1.','') and");
		sql.append(" oc_maintenanceplan_updateid=? AND");
		sql.append(" oc_maintenanceplan_updatetime>=? AND");
		sql.append(" oc_maintenanceplan_updatetime<? and");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" UNION");
		sql.append(" SELECT 'plan.history' type,oc_maintenanceplan_serverid serverid,oc_maintenanceplan_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_maintenanceplan_updatetime updatetime,");
		sql.append(" oc_maintenanceplan_name||' ['||oc_asset_description||']' NAME");
		sql.append(" ,oc_maintenanceplan_historydate timestamp");
		sql.append(" from oc_assets,oc_maintenanceplanshistory");
		sql.append(" WHERE ");
		sql.append(" oc_asset_objectid=REPLACE(oc_maintenanceplan_assetuid,'1.','') and");
		sql.append(" oc_maintenanceplan_updateid=? AND");
		sql.append(" oc_maintenanceplan_updatetime>=? AND");
		sql.append(" oc_maintenanceplan_updatetime<? and");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" UNION");
		sql.append(" SELECT 'operation' type,oc_maintenanceoperation_serverid serverid,oc_maintenanceoperation_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_maintenanceoperation_updatetime updatetime,");
		sql.append(" oc_maintenanceplan_name||' ['||oc_asset_description||']' NAME");
		sql.append(" ,null timestamp");
		sql.append(" from oc_assets,oc_maintenanceplans,oc_maintenanceoperations");
		sql.append(" WHERE ");
		sql.append(" oc_asset_objectid=REPLACE(oc_maintenanceplan_assetuid,'1.','') AND");
		sql.append(" oc_maintenanceplan_objectid=REPLACE(oc_maintenanceoperation_maintenanceplanuid,'1.','') AND");
		sql.append(" oc_maintenanceoperation_updateid=? AND");
		sql.append(" oc_maintenanceoperation_updatetime>=? AND");
		sql.append(" oc_maintenanceoperation_updatetime<? and");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" UNION");
		sql.append(" SELECT 'operation.history' type,oc_maintenanceoperation_serverid serverid,oc_maintenanceoperation_objectid objectid,");
		sql.append(" oc_asset_service serviceid,oc_maintenanceoperation_updatetime updatetime,");
		sql.append(" oc_maintenanceplan_name||' ['||oc_asset_description||']' NAME");
		sql.append(" ,oc_maintenanceoperation_historydate timestamp");
		sql.append(" from oc_assets,oc_maintenanceplans,oc_maintenanceoperationshistory");
		sql.append(" WHERE ");
		sql.append(" oc_asset_objectid=REPLACE(oc_maintenanceplan_assetuid,'1.','') AND");
		sql.append(" oc_maintenanceplan_objectid=REPLACE(oc_maintenanceoperation_maintenanceplanuid,'1.','') AND");
		sql.append(" oc_maintenanceoperation_updateid=? AND");
		sql.append(" oc_maintenanceoperation_updatetime>=? AND");
		sql.append(" oc_maintenanceoperation_updatetime<? and");
		sql.append(" LENGTH(oc_asset_service)>0");
		sql.append(" order by updatetime");
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement(sql.toString());
		int idx=1;
		for(int n=0;n<6;n++){
			ps.setString(idx++,userid);
			ps.setTimestamp(idx++,new java.sql.Timestamp(begin.getTime()));
			ps.setTimestamp(idx++,new java.sql.Timestamp(end.getTime()));
		}
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			String type = rs.getString("type");
			String serverid = rs.getString("serverid");
			String objectid = rs.getString("objectid");
			String serviceid = rs.getString("serviceid");
			java.util.Date updatetime = rs.getTimestamp("updatetime");
			String name = rs.getString("name");
			String timestamp = SH.formatSQLDate(rs.getTimestamp("timestamp"),"yyyyMMddHHmmssSSS");
			System.out.println("type="+type);
			if(type.startsWith("asset")){
				sResult.append("<tr>");
				if(type.contains("history")){
					sResult.append("<td class='admin'><a style='color: gray;font-weight: bold' href='javascript:showAssetHistoryDate(\""+serverid+"."+objectid+"\",\""+timestamp+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2' style='color: gray'>"+getTran(request,"web","inventory",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+serviceid+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+name+"</td>");
				}
				else{
					sResult.append("<td class='admin'><a style='font-weight: bold' href='javascript:showAsset(\""+serverid+"."+objectid+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2'>"+getTran(request,"web","inventory",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2'>"+serviceid+"</td>");
					sResult.append("<td class='admin2'>"+name+"</td>");
				}
				sResult.append("</tr>");
				assets++;
			}
			else if(type.startsWith("plan")){
				sResult.append("<tr>");
				if(type.contains("history")){
					sResult.append("<td class='admin'><a style='color: gray;font-weight: bold' href='javascript:showPlanHistoryDate(\""+serverid+"."+objectid+"\",\""+timestamp+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2' style='color: gray'>"+getTran(request,"web","maintenanceplan",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+serviceid+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+name+"</td>");
				}
				else{
					sResult.append("<td class='admin'><a style='font-weight: bold' href='javascript:showPlan(\""+serverid+"."+objectid+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2' >"+getTran(request,"web","maintenanceplan",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2'>"+serviceid+"</td>");
					sResult.append("<td class='admin2'>"+name+"</td>");
				}
				sResult.append("</tr>");
				plans++;
			}
			else if(type.startsWith("operation")){
				sResult.append("<tr>");
				if(type.contains("history")){
					sResult.append("<td class='admin'><a style='color: gray;font-weight: bold' href='javascript:showOperationHistoryDate(\""+serverid+"."+objectid+"\",\""+timestamp+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2' style='color: gray'>"+getTran(request,"web","maintenanceoperation",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+serviceid+"</td>");
					sResult.append("<td class='admin2' style='color: gray'>"+name+"</td>");
				}
				else{
					sResult.append("<td class='admin'><a style='font-weight: bold' href='javascript:showOperation(\""+serverid+"."+objectid+"\");'>"+SH.formatSQLDate(updatetime,"dd/MM/yyyy HH:mm")+"</a></td>");
					sResult.append("<td class='admin2'>"+getTran(request,"web","maintenanceoperation",sWebLanguage)+"</td>");
					sResult.append("<td class='admin2'>"+serviceid+"</td>");
					sResult.append("<td class='admin2'>"+name+"</td>");
				}
				sResult.append("</tr>");
				operations++;
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","useractivity",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","user",sWebLanguage) %></td>
			<td class='admin2'>
                <input type="hidden" name="user" id="user" value="<%=SH.p(request,"user")%>">
                <input class="text" type="text" name="username" id="username" readonly size="<%=sTextWidth%>" value="<%=SH.p(request,"username")%>">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchUser('user','username');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="transactionForm.user.value='';transactionForm.username.value='';">
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
			<td class='admin2'>
				<%=SH.writeDateField("begin", "transactionForm", SH.p(request,"begin"), true, true, sWebLanguage, sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
			<td class='admin2'>
				<%=SH.writeDateField("end", "transactionForm", SH.p(request,"end"), true, true, sWebLanguage, sCONTEXTPATH) %>
			</td>
		</tr>
		<tr>
			<td colspan='2'><input type='submit' name='submitButton' value='<%=getTranNoLink("web","search",sWebLanguage)%>'/></td>
		</tr>
	</table>
</form>
<%	if(sResult.length()>0){%>
<p/>
<table><tr>
	<td><b><%=getTran(request,"web","updates",sWebLanguage)%>:&nbsp;&nbsp;&nbsp;</b></td>
	<td>#<%=getTran(request,"web","inventory",sWebLanguage)+": <b>"+assets %></b>&nbsp;&nbsp;&nbsp;</td>
	<td>#<%=getTran(request,"web","maintenanceplan",sWebLanguage)+": <b>"+plans %></b>&nbsp;&nbsp;&nbsp;</td>
	<td>#<%=getTran(request,"web","maintenanceoperation",sWebLanguage)+": <b>"+operations %></b></td>
</tr></table>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td><%=getTran(request,"web","activity",sWebLanguage) %></td>
		<td><%=getTran(request,"web","service",sWebLanguage) %></td>
		<td><%=getTran(request,"web","description",sWebLanguage) %></td>
	</tr>
<%=sResult.toString() %>
</table>
<%	} %>

<script>
	function searchUser(managerUidField,managerNameField){
		openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no",650,600);
	}
	function showPlanHistoryDate(uid,timestamp){
		openPopup("assets/manage_maintenancePlans.jsp&timestamp="+timestamp+"&action=history&EditPlanUID="+uid,1200,600);
	}
	function showAssetHistoryDate(uid,timestamp){
		openPopup("assets/manage_assets.jsp&timestamp="+timestamp+"&action=history&EditAssetUID="+uid,1200,600);
	}
	function showOperationHistoryDate(uid,timestamp){
		openPopup("assets/manage_maintenanceOperations.jsp&timestamp="+timestamp+"&action=history&operationUID="+uid,1200,600);
	}
	function showPlan(uid){
		openPopup("assets/manage_maintenancePlans.jsp&readonly=true&action=edit&EditPlanUID="+uid,1200,600);
	}
	function showAsset(uid){
		openPopup("assets/manage_assets.jsp&action=edit&readonly=true&EditAssetUID="+uid,1200,600);
	}
	function showOperation(uid){
		openPopup("assets/manage_maintenanceOperations.jsp&readonly=true&action=edit&operationUID="+uid,1200,600);
	}
</script>