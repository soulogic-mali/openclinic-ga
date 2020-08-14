<%@page import="be.openclinic.system.Encryption"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	String formaction = SH.c(request.getParameter("formaction"));
	if(formaction.startsWith("delete")){
		String token = formaction.replaceAll("delete\\.","");
		Connection conn = MedwanQuery.getInstance().getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("delete from ghb_tokens where ghb_token=?");
		ps.setString(1,token);
		ps.execute();
		conn.close();
	}
	else if(formaction.startsWith("create")){
		String sessions = formaction.replaceAll("create\\.","");
		String token = Encryption.getToken(6);
		Connection conn = MedwanQuery.getInstance().getStatsConnection();
		PreparedStatement ps = conn.prepareStatement("insert into ghb_tokens(ghb_token,ghb_token_count,ghb_token_domain) values(?,?,'')");
		ps.setString(1,token);
		ps.setString(2,sessions);
		ps.execute();
		conn.close();
	}
%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<input type='hidden' name='formaction' id='formaction'/>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","manageOpenCarenetTokens",sWebLanguage) %></td>
		</tr>
		<tr class='admin'>
			<td nowrap><%=getTran(request,"web","token",sWebLanguage) %>&nbsp;</td>
			<td><%=getTran(request,"web","numberofsessions",sWebLanguage) %></td>
		</tr>
		<%
			Connection conn = MedwanQuery.getInstance().getStatsConnection();
			PreparedStatement ps = conn.prepareStatement("select * from ghb_tokens where ghb_token_count>0 order by ghb_token");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				out.println("<tr><td class='admin' width='1%' nowrap><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteToken(\""+rs.getString("ghb_token")+"\")'>&nbsp;"+rs.getString("ghb_token")+"&nbsp;</td><td class='admin2'>"+rs.getString("ghb_token_count")+"</td></tr>");
			}
			rs.close();
			ps.close();
			conn.close();
		%>
		<tr>
			<td colspan='2'><center><input type='button' class='button' name='newButton' value='<%=getTranNoLink("web","new",sWebLanguage) %>' onclick='createToken();'/></center></td>
		</tr>
	</table>
</form>

<script>
	function createToken(){
		var sessions = window.prompt('<%=getTranNoLink("web","numberofsessions",sWebLanguage)%>','0');
		if(sessions*1>0){
			document.getElementById('formaction').value='create.'+sessions;
			transactionForm.submit();
		}
	}
	function deleteToken(token){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
			document.getElementById('formaction').value='delete.'+token;
			transactionForm.submit();
		}
	}
</script>