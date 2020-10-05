<%@page import="java.text.DecimalFormat"%>
<%@page import="be.openclinic.system.SystemInfo"%>
<%@include file="/includes/helper.jsp"%>
<%@page import="be.mxs.common.util.system.*"%>
<%
	String vpnDomain = checkString(request.getParameter("vpnDomain"));
	String viewAll = checkString(request.getParameter("viewAll"));
	String deleteuid = checkString(request.getParameter("deleteuid"));
	if(deleteuid.length()>0){
		Connection conn = MedwanQuery.getInstance().getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("delete from dc_monitorparameters where dc_monitorparameter_serveruid=? and dc_monitorparameter_parameter='systeminfo' and DC_MONITORPARAMETER_VALUE like '%"+deleteuid.split("=")[1]+"%'");
		ps.setString(1,deleteuid.split("=")[0]);
		ps.execute();
		ps.close();
		conn.close();
	}
%>
<%= sCSSNORMAL %>
<form name='transactionForm' id='transactionForm' method='post'>
	<input type='hidden' name='deleteuid' id='deleteuid'/>
	<input type='hidden' name='vpnDomain' id='vpnDomain' value='<%=vpnDomain %>'/>
	<table width="100%">
		<tr class='admin'>
			<td colspan='9'>
				<a href='javascript:document.getElementById("vpnDomain").value="";window.location.href="<%=sCONTEXTPATH %>/datacenterstatistics/getConnectedHosts.jsp?vpnDomain=";'>root</a>
				<%
					String domain="";
					if(vpnDomain.length()>0){
						for(int n=0;n<vpnDomain.split("\\.").length;n++){
							domain+=vpnDomain.split("\\.")[n];
							%>
								. <a href='javascript:document.getElementById("vpnDomain").value="<%=domain %>";window.location.href="<%=sCONTEXTPATH %>/datacenterstatistics/getConnectedHosts.jsp?vpnDomain=<%=domain%>";'><%=vpnDomain.split("\\.")[n] %></a>
							<%
							domain+=".";
						}
					}
				%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input onchange='transactionForm.submit();' type='checkbox' name='viewAll' id='viewAll' value='1' <%=viewAll.equalsIgnoreCase("1")?"checked":"" %>/>View all
			</td>
		</tr>
	<%
		Connection conn = MedwanQuery.getInstance().getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("select distinct * from dc_monitorparameters where dc_monitorparameter_parameter='systeminfo' and dc_monitorparameter_value like ? order by dc_monitorparameter_value");
		ps.setString(1,vpnDomain+"%");
		ResultSet rs = ps.executeQuery();
		boolean bInit=false;
		HashSet hosts = new HashSet();
		int counter=0, totalusers=0;
		while(rs.next()){
			SystemInfo systemInfo = SystemInfo.parse(rs.getString("dc_monitorparameter_value"));
			String uid = rs.getString("dc_monitorparameter_serveruid");
			if(hosts.contains(uid)){
				continue;
			}
			totalusers+=systemInfo.getUsersConnected();
		}		
		rs.beforeFirst();
		if(totalusers<MedwanQuery.getInstance().getConfigInt("minusers."+vpnDomain,99999999)){
			MedwanQuery.getInstance().setConfigString("minusers."+vpnDomain,totalusers+"");
		}
		if(totalusers>MedwanQuery.getInstance().getConfigInt("maxusers."+vpnDomain,0)){
			MedwanQuery.getInstance().setConfigString("maxusers."+vpnDomain,totalusers+"");
		}
		while(rs.next()){
			SystemInfo systemInfo = SystemInfo.parse(rs.getString("dc_monitorparameter_value"));
			String uid = rs.getString("dc_monitorparameter_serveruid");
			if(hosts.contains(uid)){
				continue;
			}
			//totalusers+=systemInfo.getUsersConnected();
			if(viewAll.equalsIgnoreCase("1") || systemInfo.getVpnDomain().equalsIgnoreCase(vpnDomain)){
				if(!bInit){
					%>
					<tr>
						<td class='admin'>#</td>
						<td class='admin'>VPN Domain</td>
						<td class='admin'>VPN Name</td>
						<td class='admin'>VPN Address</td>
						<td class='admin'>Uptime</td>
						<td class='admin'>Diskspace</td>
						<td class='admin'>Version</td>
						<td class='admin' title='Range = <%=MedwanQuery.getInstance().getConfigInt("minusers."+vpnDomain,0)%> - <%=MedwanQuery.getInstance().getConfigInt("maxusers."+vpnDomain,0)%>'><font color='red'><%=totalusers %></font> Users</td>
						<td class='admin'>Last seen</td>
					</tr>
					<%
					bInit=true;
				}
				//Host
				long delay = (new java.util.Date().getTime()-rs.getTimestamp("dc_monitorparameter_updatetime").getTime())/1000;
				String cls = "admingreen";
				if(delay>18000){
					cls="adminredcontrast";
				}
				else if(delay>1800){
					cls="adminyellow";
				}
				String version="",version2="",diskspace="";
				PreparedStatement ps2 = conn.prepareStatement("select * from dc_monitorservers where dc_monitorserver_serveruid=?");
				ps2.setString(1,rs.getString("dc_monitorparameter_serveruid"));
				ResultSet rs2 = ps2.executeQuery();
				if(rs2.next()){
					version=rs2.getString("dc_monitorserver_softwareversion");
					version2=Integer.parseInt(version)/1000000+"."+Integer.parseInt(version.substring(version.length()-6,version.length()-3))+"."+Integer.parseInt(version.substring(version.length()-3));
					if(Integer.parseInt(version)<5170005){
						version2+=" <img height='14px' title='This version has security vulnerabilities. Please upgrade to at least version 5.170.5.' src='"+sCONTEXTPATH+"/_img/icons/icon_blinkwarning.gif'/>";
					}
				}
				long ndiskspace=systemInfo.getDiskSpace()/(1024*1024);
				diskspace=new DecimalFormat("#,###.###").format(ndiskspace)+" Mb";
				if(ndiskspace<1000){
					diskspace+=" <img height='14px' title='Low diskspace' src='"+sCONTEXTPATH+"/_img/icons/icon_blinkwarning.gif'/>";
				}
				
				rs2.close();
				ps2.close();
				counter++;
				%>
				<tr>
					<td class='<%=cls%>'><span title='<%=uid%>'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' height='14px' onclick='deleteserver("<%=uid+"="+systemInfo.getVpnName()%>")'/><%=counter %></span></td>
					<td class='<%=cls%>'><%=systemInfo.getVpnDomain() %></td>
					<td class='<%=cls%>'><%=systemInfo.getVpnName() %></td>
					<td class='<%=cls%>'><a href='javascript:window.open("http://<%=systemInfo.getVpnAddress()+":"+systemInfo.getVpnPort() %>/openclinic");'><%=systemInfo.getVpnAddress()+":"+systemInfo.getVpnPort() %></a></td>
					<td class='<%=cls%>'><%=systemInfo.getUpTimeFormatted() %></td>
					<td class='<%=cls%>'><%=diskspace %></td>
					<td class='<%=cls%>'><%=version2 %></td>
					<td class='<%=cls%>'><%=systemInfo.getUsersConnected() %></td>
					<td class='<%=cls%>'><%=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("dc_monitorparameter_updatetime"))+" ("+SystemInfo.getUpTimeFormatted(delay)+")" %></td>
				</tr>
				<%
				hosts.add(rs.getString("dc_monitorparameter_serveruid"));
			}
		}
		bInit=false;
		rs.close();
		rs = ps.executeQuery();
		HashSet domains = new HashSet();
		while(rs.next()){
			SystemInfo systemInfo = SystemInfo.parse(rs.getString("dc_monitorparameter_value"));
			if(domains.contains(systemInfo.getVpnDomain().replace(domain, "").split("\\.")[0])){
				continue;
			}
			if(!systemInfo.getVpnDomain().equalsIgnoreCase(vpnDomain)){
				if(!bInit){
					%>
					<tr>
						<td colspan='9'>
							<hr/>
						</td>
					</tr>
					<tr>
						<td class='admin' colspan='9'>Sub domains</td>
					</tr>
					<%
					bInit=true;
				}
				//Domain
				%>
				<tr>
					<td class='admin' colspan='9'>
						<a href='javascript:document.getElementById("vpnDomain").value="<%=domain+systemInfo.getVpnDomain().replace(domain, "").split("\\.")[0] %>";window.location.href="<%=sCONTEXTPATH %>/datacenterstatistics/getConnectedHosts.jsp?vpnDomain=<%=domain+systemInfo.getVpnDomain().replace(domain, "").split("\\.")[0]%>";'><%=systemInfo.getVpnDomain().replace(domain, "").split("\\.")[0] %></a>
					</td>
				</tr>
				<%
				domains.add(systemInfo.getVpnDomain().replace(domain, "").split("\\.")[0]);
			}
		}
		rs.close();
		ps.close();
		conn.close();
	%>
	</table>
</form>
<script>
	function deleteserver(uid){
		document.getElementById('deleteuid').value=uid;
		document.getElementById('transactionForm').submit();
	}
	window.setTimeout("window.location.reload()",30000);
</script>