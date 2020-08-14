<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(request.getParameter("submitButton")!=null){
		String token=checkString(request.getParameter("token"));
		String sessions=checkString(request.getParameter("sessions"));
		int iSessions = -1;
		try{
			iSessions = Integer.parseInt(sessions);
		}
		catch(Exception e){}
		if(token.length()>0 && iSessions>-1){
			Connection conn = MedwanQuery.getInstance().getStatsConnection();
			PreparedStatement ps = conn.prepareStatement("delete from GHB_TOKENS where GHB_TOKEN=?");
			ps.setString(1, token);
			ps.execute();
			ps.close();
			ps=conn.prepareStatement("insert into GHB_TOKENS(GHB_TOKEN,GHB_TOKEN_COUNT,GHB_TOKEN_DOMAIN) values(?,?,'')");
			ps.setString(1,token);
			ps.setInt(2,iSessions);
			ps.execute();
			ps.close();
			conn.close();
		}
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","initializetoken",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","token",sWebLanguage) %></td>
			<td class='admin2'><input type='text' size='20' name='token' id='token'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","sessions",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' size='10' name='sessions' id='sessions' value='100'/></td>
		</tr>
	</table>
	<input type='submit' name='submitButton' class='button' value='<%=getTran(request,"web","save",sWebLanguage) %>'/>
	<hr/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","activetokens",sWebLanguage) %></td>
		</tr>
		<%
			Connection conn = MedwanQuery.getInstance().getStatsConnection();
			PreparedStatement ps = conn.prepareStatement("select * from GHB_TOKENS where GHB_TOKEN_COUNT>0");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				out.println("<tr><td class='admin'>"+rs.getString("GHB_TOKEN")+"</td>");
				out.println("<td class='admin2'>"+rs.getString("GHB_TOKEN_COUNT")+"</td></tr>");
			}
			rs.close();
			ps.close();
		%>
	</table>
</form>