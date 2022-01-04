<%@include file="/includes/helper.jsp"%>
<table border='1'>
<%
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select count(*) total from adminview");
	int n=0;
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		n=rs.getInt("total");
	}
	rs.close();
	ps.close();
%>
	<tr>
		<td>Patients</td>
		<td><%=n %></td>
	</tr>
<%
	long day= 24*3600*1000;
	ps = conn.prepareStatement("select count(*) total from transactions where ts>?");
	ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()-180*day));
	n=0;
	rs = ps.executeQuery();
	if(rs.next()){
		n=rs.getInt("total");
	}
	rs.close();
	ps.close();
%>
	<tr>
		<td>Documents dans les 6 derniers mois</td>
		<td><%=n %></td>
	</tr>
	<tr><td colspan='2' style='background-color:lightgrey'>Par type de document</td></tr>
<%
	ps = conn.prepareStatement("select count(*) total,transactiontype from transactions where ts>? group by transactiontype order by count(*) desc");
	ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()-180*day));
	n=0;
	rs = ps.executeQuery();
	while(rs.next()){
		%>
		<tr>
			<td>&nbsp;&nbsp;<i><%=getTranNoLink("web.occup",rs.getString("transactiontype"),"fr") %></i></td>
			<td><%=rs.getInt("total") %></td>
		</tr>
	<%
	}
	rs.close();
	ps.close();
%>
	<tr><td colspan='2' style='background-color:lightgrey'>Par semaine d'encodage</td></tr>
<%
	ps = conn.prepareStatement("select count(*) total,week(ts) week from transactions where ts>? group by week(ts) order by week(ts) asc");
	ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()-180*day));
	n=0;
	rs = ps.executeQuery();
	while(rs.next()){
		%>
		<tr>
			<td>&nbsp;&nbsp;<i>Semaine <%=rs.getString("week")%></i></td>
			<td><%=rs.getInt("total") %></td>
		</tr>
	<%
	}
	rs.close();
	ps.close();
%>
	<tr><td colspan='2' style='background-color:lightgrey'>Par utilisateur</td></tr>
<%
	ps = conn.prepareStatement("select count(*) total,firstname,lastname from transactions t,usersview u,adminview a where a.personid=u.personid and u.userid=t.userid and ts>? group by firstname,lastname order by count(*) desc");
	ps.setTimestamp(1,new java.sql.Timestamp(new java.util.Date().getTime()-180*day));
	n=0;
	rs = ps.executeQuery();
	while(rs.next()){
		%>
		<tr>
			<td>&nbsp;&nbsp;<i><%=SH.capitalize(rs.getString("firstname")+"")+" "+(rs.getString("lastname")+"").toUpperCase()%></i></td>
			<td><%=rs.getInt("total") %></td>
		</tr>
	<%
	}
	rs.close();
	ps.close();
%>
<%
	conn.close();
%>
</table>