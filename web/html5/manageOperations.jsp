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
	String planuid = SH.p(request,"planuid");
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
							<img style='max-height: 40px' onclick="window.location.href='manageMaintenancePlans.jsp?planuid=<%=planuid %>'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/planning.png'/>
							<img style='max-height: 40px' onclick="window.location.href='welcomegmao.jsp'" src='<%=sCONTEXTPATH%>/_img/icons/mobile/home.png'/>
						</td>
					</tr>
					<tr>
						<td colspan='2' class='mobileadmin' style='font-size:6vw;'>
							<%=getTranNoLink("web","searchmaintenanceoperations",sWebLanguage)%>
							<% 
								if(planuid.length()>0){ 
									MaintenancePlan plan = MaintenancePlan.get(planuid);
							%>
								[<%=plan.getUid()+" - "+plan.getName() +" - "+plan.getAssetName()%>]
								<img onclick='newOperation("<%=planuid %>");' style='max-width:10%;height:auto;vertical-align:middle' src='<%=sCONTEXTPATH %>/_img/icons/mobile/new.png'/>
							<% 	} %>
						</td>
					</tr>
				</table>
			</form>
			<p/>
			<table width='100%'>
			<%
				if(planuid.length()>0){
					//Search maintenance plans for an asset
					Connection conn = SH.getOpenClinicConnection();
					PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_maintenanceplanuid=? order by oc_maintenanceoperation_date desc");
					ps.setString(1,planuid);
					ResultSet rs = ps.executeQuery();
					boolean bFirst=true;
					while(rs.next()){
						MaintenanceOperation operation = MaintenanceOperation.get(rs.getInt("oc_maintenanceoperation_serverid")+"."+rs.getInt("oc_maintenanceoperation_objectid"));
						out.println("<tr>");
						out.println("<td class='mobileadmin' style='font-size:4vw;text-align: left'>"+SH.formatDate(rs.getDate("oc_maintenanceoperation_date"))+"</td>");
						out.println("<td class='mobileadmin2' rowspan='2'><a href='javascript:editOperation(\""+operation.getUid()+"\");' style='font-size:4vw;text-align: left'>"+SH.c(operation.getOperator()).toUpperCase()+" - "+getTranNoLink("assets.maintenanceoperations.result",operation.getResult(),sWebLanguage)+"</td>");
						out.println("</tr>");
						out.println("<tr>");
						if(bFirst && operation.getNextDate()!=null && operation.getNextDate().before(new java.util.Date())){
							out.println("<td class='mobileadmin' style='background-color: red;color: white;font-size:4vw;text-align: left'>"+SH.formatDate(operation.getNextDate())+"</td>");
						}
						else{
							out.println("<td class='mobileadmin' style='font-size:3vw;text-align: left'>"+SH.formatDate(operation.getNextDate())+"</td>");
						}
						bFirst=false;
						out.println("</tr>");
					}
					rs.close();
					ps.close();
					conn.close();
				}
			%>
			</table>
		</div>
		<script>
			function editOperation(uid){
				window.location.href='editMaintenanceOperation.jsp?operationuid='+uid;
			}
			function newOperation(uid){
				window.location.href='editMaintenanceOperation.jsp?planuid='+uid;
			}
		</script>
	</body>
</html>