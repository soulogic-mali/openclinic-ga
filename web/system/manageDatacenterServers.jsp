<%@page import="be.openclinic.datacenter.DatacenterHelper"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>

<%
	String sGroupId = SH.c(request.getParameter("groupid"));
	String sServerGroupId = SH.c(request.getParameter("servergroupid"));

	if(request.getParameter("saveButton")!=null){
		String sId = request.getParameter("server_id");
		if(sId.equalsIgnoreCase("NEW")){
			sId=MedwanQuery.getInstance().getOpenclinicCounter("DatacenterServer")+"";
		}
		//First save the labels for the server
		Enumeration<String> ePars = request.getParameterNames();
		while(ePars.hasMoreElements()){
			String parName = ePars.nextElement();
			if(parName.startsWith("server_name")){
				Label label = new Label();
				label.type="datacenterserver";
				label.id=sId;
				label.language=parName.split("\\_")[2];
				label.showLink="1";
				label.updateUserId=activeUser.userid;
				label.value=request.getParameter(parName);
				label.saveToDB();
			}
		}
		//Then save the server record
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from dc_servers where dc_server_serverid=?");
		ps.setString(1,sId);
		ps.execute();
		ps.close();
		ps=conn.prepareStatement("insert into dc_servers(dc_server_serverid,dc_server_location,dc_server_zone,dc_server_key) values(?,?,?,?)");
		ps.setString(1,sId);
		ps.setString(2,SH.c(request.getParameter("server_location")));
		ps.setString(3,SH.c(request.getParameter("server_zone")));
		ps.setString(4,SH.c(request.getParameter("server_key")));
		ps.execute();
		ps.close();
		System.out.println("////////////////////////// GroupID =*"+sGroupId+"* ["+sId+"]");
		if(sServerGroupId.length()>0){
			ps = conn.prepareStatement("delete from dc_servergroups where dc_servergroup_id=? and dc_servergroup_serverid=?");
			ps.setString(1,sServerGroupId);
			ps.setString(2,sId);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("insert into dc_servergroups(dc_servergroup_id,dc_servergroup_serverid) values(?,?)");
			ps.setString(1,sServerGroupId);
			ps.setString(2,sId);
			ps.execute();
			ps.close();
		}
		conn.close();	
	}
	else if(request.getParameter("deleteButton")!=null){
		String sId = request.getParameter("server_id");
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from dc_servers where dc_server_serverid=?");
		ps.setString(1,sId);
		ps.execute();
		ps.close();
		conn.close();
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='3'><%=getTran(request,"web.manage","managedatacenterservers",sWebLanguage) %></td>
		</tr>
		<tr>
			<td width=50%' style='vertical-align: top'>
				<table width='100%'>
					<tr>
						<td class='admin' nowrap width='100px'><%=getTran(request,"web","servergroup",sWebLanguage) %>&nbsp;</td>
						<td class='admin2'>
							<select class='text' name='groupid' onchange='window.location.href="<%=sCONTEXTPATH%>/main.jsp?Page=system/manageDatacenterServers.jsp&groupid="+this.value;'>
								<option/>
								<%=SH.writeSelect(request, "datacenterservergroup", sGroupId, sWebLanguage) %>
							</select>
						</td>
					</tr>
				</table>
				<div style='max-height: 250px;overflow: auto'>
					<table width='100%'>
						<%
							Vector<String> servers=new Vector();;
							if(sGroupId.length()==0){
								servers = DatacenterHelper.getServers();
							}
							else{
								servers = DatacenterHelper.getServersForGroup(sGroupId);
							}
							for(int n=0;n<servers.size();n++){
								String id=servers.elementAt(n);
								out.println("<tr>");
								out.println("<td class='admin' width='100px' nowrap><a href='javascript:loadServer("+id+");'>"+id+"</a>&nbsp;</td>");
								out.println("<td class='admin2'><a href='javascript:loadServer("+id+");'>"+getTran(request,"datacenterserver",id,sWebLanguage)+"</a></td>");
								out.println("</tr>");
							}
						%>
					</table>
				</div>
				<br/>
				<center>
					<input class='button' type='button' onclick="loadServer('NEW')" name='newButton' value='<%=getTranNoLink("web","new",sWebLanguage) %>'/>
					&nbsp;&nbsp;&nbsp;<a href="<%=sCONTEXTPATH %>/main.jsp?Page=system/manageDatacenterGroups.jsp"><%=getTran(request,"web.manage","managedatacentergroups",sWebLanguage) %></a>
				</center>
			</td>
			<td width='5%'/>
			<td width='45%' id='tdServer' style='vertical-align: top'>
			</td>
		</tr>
	</table>
</form>

<script>
	function loadServer(id){
	    var url = '<c:url value="/system/loadDatacenterServer.jsp"/>';
		new Ajax.Request(url,{
		parameters: "id="+id+"&ts=<%=getTs()%>",
		onSuccess: function(resp){
		  document.getElementById("tdServer").innerHTML = resp.responseText;
		}
		});
	}
	function addServerGroup(id,groupid){
	    var url = '<c:url value="/system/addDatacenterServerGroup.jsp"/>';
		new Ajax.Request(url,{
		parameters: "id="+id+
					"&groupid="+groupid+
					"&ts=<%=getTs()%>",
		onSuccess: function(resp){
		  loadServer(id);
		}
		});
	}
	function removeServerGroup(id,groupid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = '<c:url value="/system/removeDatacenterServerGroup.jsp"/>';
			new Ajax.Request(url,{
			parameters: "id="+id+
						"&groupid="+groupid+
						"&ts=<%=getTs()%>",
			onSuccess: function(resp){
			  loadServer(id);
			}
			});
		}
	}
</script>
