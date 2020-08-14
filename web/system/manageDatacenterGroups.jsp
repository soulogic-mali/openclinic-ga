<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>

<%
	if(request.getParameter("saveButton")!=null){
		String sId = request.getParameter("group_id");
		if(sId.equalsIgnoreCase("NEW")){
			sId=MedwanQuery.getInstance().getOpenclinicCounter("DatacenterServerGroup")+"";
		}
		Enumeration<String> ePars = request.getParameterNames();
		while(ePars.hasMoreElements()){
			String parName = ePars.nextElement();
			if(parName.startsWith("group_name")){
				Label label = new Label();
				label.type="datacenterservergroup";
				label.id=sId;
				label.language=parName.split("\\_")[2];
				label.showLink="1";
				label.updateUserId=activeUser.userid;
				label.value=request.getParameter(parName);
				label.saveToDB();
			}
		}
	}
	else if(request.getParameter("deleteButton")!=null){
		String sId = request.getParameter("group_id");
		Label.delete("datacenterservergroup", sId);
		MedwanQuery.getInstance().reloadLabels();
	}
%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='3'><%=getTran(request,"web.manage","managedatacentergroups",sWebLanguage) %></td>
		</tr>
		<tr>
			<td width=50%' style='vertical-align: top'>
				<div style='max-height: 250px;overflow: auto'>
					<table width='100%'>
						<%
							SortedSet nids = new TreeSet();
							SortedSet ids = ScreenHelper.getLabelIds("datacenterservergroup", sWebLanguage);
							Iterator<String> iIds = ids.iterator();
							while(iIds.hasNext()){
								nids.add(Integer.parseInt(iIds.next()));
							}
							Iterator<Integer> iNids = nids.iterator();
							while(iNids.hasNext()){
								String id=iNids.next()+"";
								out.println("<tr>");
								out.println("<td class='admin' width='1%' nowrap><a href='javascript:loadServerGroup("+id+");'>"+id+"</a>&nbsp;</td>");
								out.println("<td class='admin2'><a href='javascript:loadServerGroup("+id+");'>"+getTran(request,"datacenterservergroup",id,sWebLanguage)+"</a></td>");
								out.println("</tr>");
							}
						%>
					</table>
				</div>
				<br/>
				<center>
					<input class='button' type='button' onclick="loadServerGroup('NEW')" name='newButton' value='<%=getTranNoLink("web","new",sWebLanguage) %>'/>
					&nbsp;&nbsp;&nbsp;<a href="<%=sCONTEXTPATH %>/main.jsp?Page=system/manageDatacenterServers.jsp"><%=getTran(request,"web.manage","managedatacenterservers",sWebLanguage) %></a>
				</center>
			</td>
			<td width='5%'/>
			<td width='45%' id='tdServerGroup' style='vertical-align: top'>
			</td>
		</tr>
	</table>
</form>

<script>
	function loadServerGroup(id){
	    var url = '<c:url value="/system/loadDatacenterServerGroup.jsp"/>';
		new Ajax.Request(url,{
		parameters: "id="+id+"&ts=<%=getTs()%>",
		onSuccess: function(resp){
		  document.getElementById("tdServerGroup").innerHTML = resp.responseText;
		}
		});
	}
</script>