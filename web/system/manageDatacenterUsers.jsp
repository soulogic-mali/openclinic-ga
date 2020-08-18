<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String userid = SH.c(request.getParameter("userid"));
	if(SH.c(request.getParameter("user_id")).length()>0){
		userid=SH.c(request.getParameter("user_id"));
	}
	String password=SH.c(request.getParameter("user_password"));
	String groups=SH.c(request.getParameter("user_servergroups"));
	String language=SH.c(request.getParameter("user_language"));
	String logo=SH.c(request.getParameter("user_logo"));
	
	if(request.getParameter("saveButton")!=null){
		MedwanQuery.getInstance().setConfigString("datacenterUserPassword."+userid, password);
		MedwanQuery.getInstance().setConfigString("datacenterUserLanguage."+userid, language);
		MedwanQuery.getInstance().setConfigString("datacenterUserServerGroups."+userid, groups);
		MedwanQuery.getInstance().setConfigString("datacenterUserLogo."+userid, logo);
	}
	else if(request.getParameter("deleteButton")!=null){
		MedwanQuery.getInstance().setConfigString("datacenterUserPassword."+userid, "");
		MedwanQuery.getInstance().setConfigString("datacenterUserLanguage."+userid, "");
		MedwanQuery.getInstance().setConfigString("datacenterUserServerGroups."+userid, "");
		MedwanQuery.getInstance().setConfigString("datacenterUserLogo."+userid, "");
		Connection conn = SH.getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("delete from oc_config where oc_key=?");
		ps.setString(1,"datacenterUserPassword."+userid);
		ps.execute();
		ps.setString(1,"datacenterUserLanguage."+userid);
		ps.execute();
		ps.setString(1,"datacenterUserServerGroups."+userid);
		ps.execute();
		ps.setString(1,"datacenterUserLogo."+userid);
		ps.execute();
		ps.close();
		conn.close();
		userid="";
		password="";
		groups="";
		language="";
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","managedatacenterusers",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","selectuser",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' onchange='window.location.href="<%=sCONTEXTPATH%>/main.jsp?Page=system/manageDatacenterUsers.jsp&userid="+this.value;'>
					<option value=''><%=getTranNoLink("web","new",sWebLanguage) %></option>
					<%
						//Add all known users here
						Connection conn = SH.getOpenclinicConnection();
						PreparedStatement ps =conn.prepareStatement("select * from oc_config where oc_key like 'datacenterUserPassword.%' order by oc_key");
						ResultSet rs=ps.executeQuery();
						while(rs.next()){
							String uid = rs.getString("oc_key").replaceAll("datacenterUserPassword\\.", "");
							out.println("<option value='"+uid+"' "+(uid.equalsIgnoreCase(userid)?"selected":"")+">"+uid+"</option>");
						}
						rs.close();
						ps.close();
						conn.close();
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","userid",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' class='text' name='user_id' value='<%=userid %>' size='20'/>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","password",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='password' class='text' name='user_password' value='<%=userid.length()==0?"":SH.cs("datacenterUserPassword."+userid,"") %>' size='20'/>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","language",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='user_language'>
					<option/>
					<%=SH.writeSelect(request, "datacenterLanguages", userid.length()==0?"":SH.cs("datacenterUserLanguage."+userid,""), sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","logo",sWebLanguage) %></td>
			<td class='admin2'>
				<input onkeyup='document.getElementById("logo").src=this.value' type='text' size='60' class='text' name='user_logo' value='<%=userid.length()==0?SH.cs("datacenterUserLogo",sCONTEXTPATH+"/_img/world.png"):SH.cs("datacenterUserLogo."+userid,SH.cs("datacenterUserLogo",sCONTEXTPATH+"/_img/world.png")) %>' size='20'/>
				<br/><img id='logo' style='vertical-align: middle;max-height: 40px;max-width: 200px' src='<%=userid.length()==0?SH.cs("datacenterUserLogo",sCONTEXTPATH+"/_img/world.png"):SH.cs("datacenterUserLogo."+userid,SH.cs("datacenterUserLogo",sCONTEXTPATH+"/_img/world.png")) %>'/>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap width='10%'><%=getTran(request,"web","servergroups",sWebLanguage) %></td>
			<td class='admin2'>
				<input type='text' class='text' name='user_servergroups' value='<%=userid.length()==0?"":SH.cs("datacenterUserServerGroups."+userid,"") %>' size='60'/>
			</td>
		</tr>
	</table>
	<center>
		<input type='submit' class='button' name='saveButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
		<input type='submit' class='button' name='deleteButton' value='<%=getTranNoLink("web","delete",sWebLanguage) %>'/>
	</center>
</form>