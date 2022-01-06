<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sServiceStockUid=SH.p(request,"ServiceStockUid");
	ServiceStock stock = ServiceStock.get(sServiceStockUid);
	java.util.Date end = new java.util.Date();
	java.util.Date begin = new java.util.Date(end.getTime()-7*24*3600*1000);
	if(SH.p(request,"begin").length()>0){
		begin=SH.parseDate(SH.p(request,"begin"));
	}
%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='3'>
				<%=getTran(request,"web","synchronisationhistory",sWebLanguage) %>: <%=stock.getName() %>&nbsp;&nbsp;&nbsp;
				<%=getTran(request,"web","after",sWebLanguage) %>
				<%=SH.writeDateField("begin", "transactionForm", SH.formatDate(begin), true, false, sWebLanguage, sCONTEXTPATH)%>
				<input class='button' type='submit' name='submitButton' value='<%= getTranNoLink("web","search",sWebLanguage) %>'/>
			</td>
		</tr>
		<tr class='admin'>
			<td><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td><%=getTran(request,"web","operationtype",sWebLanguage) %></td>
			<td><%=getTran(request,"web","details",sWebLanguage) %></td>
		</tr>
		<%
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_pharmasynclogs where oc_error_servicestockuid=? and oc_error_updatetime between ? and ? order by oc_error_updatetime desc,oc_error_id desc");
			ps.setString(1,sServiceStockUid);
			ps.setTimestamp(2,SH.getSQLTimestamp(begin));
			ps.setTimestamp(3,SH.getSQLTimestamp(end));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				out.println("<tr>");
				out.println("<td class='admin' nowrap>"+SH.formatSQLDate(rs.getTimestamp("oc_error_updatetime"), "dd/MM/yyyy HH:mm:ss")+"&nbsp;</td>");
				out.println("<td class='admin2'>"+getTran(request,"pharmasyncerror",rs.getString("oc_error_code"),sWebLanguage)+"</td>");
				out.println("<td class='admin2'><i style='color: darkblue; font-family: courier'>"+SH.c(rs.getString("oc_error_comment"))+"</i></td>");
				out.println("</tr>");
			}
			SH.close(conn,ps,rs);
		%>
	</table>
</form>
