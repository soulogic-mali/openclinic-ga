<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","healthfacilities",sWebLanguage) %></td>
	</tr>
<%
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from ghb_servers order by ghb_server_domain,ghb_server_name");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String id = rs.getString("ghb_server_id");
		if(!id.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("ghb_ref_serverid","-"))){
			String domain = rs.getString("ghb_server_domain");
			String name = rs.getString("ghb_server_name");
			out.println("<tr>");
			out.println("<td class='admin'>"+domain.toLowerCase()+"</td>");
			out.println("<td class='admin2'><a href='javascript:selectServer("+id+",\""+name+"\")'>"+name+"</a></td>");
			out.println("</tr>");
		}
	}
	rs.close();
	ps.close();
%>
</table>

<script>
	function selectServer(id,name){
		window.opener.document.getElementById('destinationid').value=id;
		window.opener.document.getElementById('destination').value=name;
		window.close();
	}
</script>