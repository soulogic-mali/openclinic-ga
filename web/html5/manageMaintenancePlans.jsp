<%@page import="be.openclinic.assets.*"%>
<%@include file="/includes/validateUser.jsp"%>
<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<head>
	<link rel="apple-touch-icon" sizes="180x180" href="/openclinic/apple-touch-icon.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/openclinic/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/openclinic/favicon-16x16.png">
	<link rel="manifest" href="/openclinic/site.webmanifest">
	<link rel="mask-icon" href="/openclinic/safari-pinned-tab.svg" color="#5bbad5">
	<meta name="msapplication-TileColor" content="#da532c">
	<meta name="theme-color" content="#ffffff">
</head>
<%=sCSSNORMAL %>
<%=sJSPROTOTYPE %>
<%
	String assetuid = SH.p(request,"assetuid");
%>
<html>
	<body onresize='window.parent.document.getElementById("ocframe").style.height=screen.height;'>
		<div>
			<form name='transactionForm' method='post'>
				<input type='hidden' name='highlight' id='highlight' value='<%=SH.p(request,"highlight")%>'/>
				<table width='100%'>
					<tr>
						<td style='font-size:4vw;text-align: left' nowrap>
							<%=SH.c((String)session.getAttribute("activeService")).toUpperCase() %><br/>
							<b style='font-size:4vw;text-align: left'><%=getTranNoLink("service",SH.c((String)session.getAttribute("activeService")),sWebLanguage) %></b>
						</td>
						<td style='font-size:8vw;text-align: right' nowrap>
							<img style='max-height: 40px' onclick="window.location.href='manageAssets.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/inventory.png'/>
							<img style='max-height: 40px' onclick="window.location.href='welcomegmao.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","searchmaintenanceplans",sWebLanguage)%>
							<% 
								if(assetuid.length()>0){ 
									Asset asset = Asset.get(assetuid);
							%>
								[<%=asset.getUid()+" - "+asset.getDescription() %>]
								<img onclick='newPlan("<%=assetuid %>");' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
							<% 	} %>
						</td>
					</tr>
				</table>
			</form>
			<p/>
			<table width='100%'>
			<%
				long day = 24*3600*1000;
				SortedMap plans = new TreeMap();
				if(assetuid.length()>0){
					//Search maintenance plans for an asset
					Connection conn = SH.getOpenClinicConnection();
					PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceplans where oc_maintenanceplan_assetuid=?");
					ps.setString(1,assetuid);
					ResultSet rs = ps.executeQuery();
					while(rs.next()){
						MaintenancePlan plan = MaintenancePlan.get(rs.getInt("oc_maintenanceplan_serverid")+"."+rs.getInt("oc_maintenanceplan_objectid"));
						if(plan!=null){
							java.util.Date nextDate = plan.getNextOperationDate();
							if(nextDate!=null){
								plans.put(SH.formatSQLDate(nextDate,"yyyyMMddHHmmssSSS")+"."+plan.getUid(),plan);
							}
						}
					}
					rs.close();
					ps.close();
					conn.close();
				}
				else{
					//Search next 50 maintenanceplans ordered by next intervention date
					int maxplans=SH.ci("maxMaintenancePlanCounter",100);
					Connection conn = SH.getOpenClinicConnection();
					String children = Service.getChildIdsAsString(SH.c((String)session.getAttribute("activeService")),500); 
					PreparedStatement ps = conn.prepareStatement("select p.* from oc_maintenanceplans p,oc_assets a where oc_asset_objectid=replace(oc_maintenanceplan_assetuid,'1.','') and oc_asset_service in ("+children+")");
					ResultSet rs = ps.executeQuery();
					int counter=0;
					while(rs.next() && counter<maxplans){
						MaintenancePlan plan = MaintenancePlan.get(rs.getInt("oc_maintenanceplan_serverid")+"."+rs.getInt("oc_maintenanceplan_objectid"));
						if(plan!=null){
							java.util.Date nextDate = plan.getNextOperationDate();
							if(nextDate!=null && nextDate.before(new java.util.Date(new java.util.Date().getTime()+7*day))){
								counter++;
								plans.put(SH.formatSQLDate(nextDate,"yyyyMMddHHmmssSSS")+"."+plan.getUid(),plan);
							}
						}
					}
					rs.close();
					ps.close();
					conn.close();
				}
				Iterator iPlans = plans.keySet().iterator();
				while(iPlans.hasNext()){
					String color="";
					String key = (String)iPlans.next();
					if(SH.parseDate(key.split("\\.")[0],"yyyyMMddHHmmssSSS").after(new java.util.Date(new java.util.Date().getTime()+7*day))){
						color=";color:gray;text-decoration: line-through";
					}
					MaintenancePlan plan = (MaintenancePlan)plans.get(key);
					out.println("<tr>");
					out.println("<td class='mobileadmin' style='font-size:4vw;text-align: left"+color+"'>"+SH.formatDate(SH.parseDate(key.split("\\.")[0],"yyyyMMddHHmmssSSS"))+"</td>");
					out.println("<td class='mobileadmin2' rowspan='2'><a href='javascript:editPlan(\""+plan.getUid()+"\");' style='font-size:4vw;text-align: left"+color+"'>"+SH.capitalize(plan.getName())+" - "+getTranNoLink("maintenanceplan.frequency",plan.getFrequency(),sWebLanguage)+" ["+plan.getAssetName()+"]"+"</td>");
					out.println("</tr>");
					out.println("<tr>");
					out.println("<td class='mobileadmin' style='font-size:4vw;text-align: left"+color+"'>"+plan.getUid()+"</td>");
					out.println("</tr>");
				}
			%>
			</table>
		</div>
		<script>
			function newPlan(uid){
				window.location.href="editMaintenancePlan.jsp?assetuid="+uid;
			}
			function editPlan(uid){
				window.location.href="editMaintenancePlan.jsp?planuid="+uid;
			}
		</script>
		<script>
			window.parent.parent.scrollTo(0,0);
		</script>
	</body>
</html>