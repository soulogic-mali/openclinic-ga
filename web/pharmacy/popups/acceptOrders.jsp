<%@page errorPage="/includes/error.jsp"%>
<%@include file="/_common/templateAddIns.jsp"%>
<form name="transactionForm" method="post">
	<table width="100%">
		<tr class='admin'><td><%=getTran(request,"web","receivedorders",sWebLanguage) %></td></tr>
		<%
			String sServiceStockUid=request.getParameter("ServiceStockUid");
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			String sql="select p.oc_stock_servicestockuid,s.oc_stock_name,count(*) total from oc_productorders o,oc_productstocks p, oc_servicestocks s"+
						" where"+
						" o.oc_order_from=? and"+
						" o.oc_order_processed=0 and"+
						" p.oc_stock_objectid=replace(o.oc_order_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','') and"+
						" s.oc_stock_objectid=replace(p.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
						" group by p.oc_stock_servicestockuid,s.oc_stock_name order by s.oc_stock_name";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sServiceStockUid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				out.println("<tr><td class='admin'><a href='"+sCONTEXTPATH+"/popup.jsp?Page=/pharmacy/popups/acceptOrder.jsp&PopupWidth=700&PopuHeight=400&ServiceStockUid="+sServiceStockUid+"&RequestingServiceStockUid="+rs.getString("oc_stock_servicestockuid")+"'>"+rs.getString("oc_stock_name")+"</a> ("+rs.getInt("total")+" "+getTran(request,"web","products",sWebLanguage)+")</td></tr>");
			}
			rs.close();
			ps.close();
			conn.close();
		%>
	</table>
	<center>
		<p/>
		<input type='button' class='button' name='closebutton' value='<%=getTran(request,"web","close",sWebLanguage) %>' onclick='window.close()'/>
	</center>
</form>
