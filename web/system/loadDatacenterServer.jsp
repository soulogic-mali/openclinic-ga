<%@page import="be.openclinic.datacenter.DatacenterHelper"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>

<%
	String sId = SH.c(request.getParameter("id"));
	String sLocation="",sZone="",sKey="";
	if(sId.length()>0){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from dc_servers where dc_server_serverid=?");
		ps.setString(1,sId);
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			sLocation = SH.c(rs.getString("dc_server_location"));
			sZone=SH.c(rs.getString("dc_server_zone"));
			sKey=SH.c(rs.getString("dc_server_key"));
		}
		rs.close();
		ps.close();
		conn.close();
	}
%>

<table width='100%'>
	<tr>
		<td class='admin' width='1%' nowrap><%=getTran(request,"web","id",sWebLanguage) %>&nbsp;</td>
		<td class='admin2'><%=sId.equalsIgnoreCase("NEW")?"":sId %><input type='hidden' name='server_id' value='<%= sId %>'/></td>
	</tr>
	<%
		String[] supportedLanguages = SH.cs("supportedLanguages","en").split(",");
		for(int n=0;n<supportedLanguages.length;n++){
			out.println("<tr>");
			out.println("<td class='admin'>"+supportedLanguages[n].toUpperCase()+"</td>");
			if(sId.equalsIgnoreCase("NEW")){
				out.println("<td class='admin2'><input type='text' class='text' name='server_name_"+supportedLanguages[n].toLowerCase()+"' value='' size='40'/></td>");
			}
			else{
				out.println("<td class='admin2'><input type='text' class='text' name='server_name_"+supportedLanguages[n].toLowerCase()+"' value='"+getTranNoLink("datacenterserver",sId,supportedLanguages[n].toLowerCase())+"' size='40'/></td>");
			}
			out.println("</tr>");
		}
		int associatedServers = DatacenterHelper.getServersForGroup(sId).size();
	%>
	<tr>
		<td class='admin' width='1%' nowrap><%=getTran(request,"web","location",sWebLanguage) %>&nbsp;</td>
		<td class='admin2'><input type='text' class='text' name='server_location' value='<%=sLocation%>' size='60'/></td>
	</tr>
	<tr>
		<td class='admin' width='1%' nowrap><%=getTran(request,"web","zone",sWebLanguage) %>&nbsp;</td>
		<td class='admin2'><input type='text' class='text' name='server_zone' value='<%=sZone%>' size='60'/></td>
	</tr>
	<tr>
		<td class='admin' width='1%' nowrap><%=getTran(request,"web","key",sWebLanguage) %>&nbsp;</td>
		<td class='admin2'><input type='text' class='text' name='server_key' value='<%=sKey%>' size='60'/></td>
	</tr>
	<% if(!sId.equalsIgnoreCase("NEW")){ %>
		<tr>
			<td class='admin' width='1%' nowrap rowspan='2'><%=getTran(request,"web","groupslinked",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'>
				<select class='text' name='groupid' id='groupid'>
					<option/>
					<%=SH.writeSelect(request, "datacenterservergroup", "", sWebLanguage) %>
				</select>
				<input type='button' class='button' name='addGroupButton' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addServerGroup(<%=sId %>,document.getElementById("groupid").value)'/>
			</td>
		</tr>
		<tr>
			<td class='admin2'>
				<table width='100%'>
					<%
						Vector<String> groups = DatacenterHelper.getGroupsForServer(sId);
						for(int n=0;n<groups.size();n++){
							String groupid = groups.elementAt(n);
							out.println("<tr>");
							out.println("<td width='1%' nowrap><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='removeServerGroup("+sId+","+groupid+")'/>&nbsp;</td>");
							out.println("<td>"+getTran(request,"datacenterservergroup",groupid,sWebLanguage)+"</td>");
							out.println("</tr>");
						}
					%>
				</table>
			</td>
		</tr>
	<% 
		}
	else{
	%>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","grouplinked",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'>
				<select class='text' name='servergroupid' id='servergroupid'>
					<option/>
					<%=SH.writeSelect(request, "datacenterservergroup", "", sWebLanguage) %>
				</select>
			</td>
		</tr>
	<%} %>
	<tr>
		<td/>
		<td>
			<input type='submit' class='button' name='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
			<%if(!sId.equalsIgnoreCase("NEW") && associatedServers==0){%>
				<input type='submit' class='button' name='deleteButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
			<%} %>
		</td>
	</tr>
</table>
