<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String serviceStockUid=SH.p(request,"serviceStockUid");

	if(request.getParameter("submitButton")!=null){
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parName = (String)pars.nextElement();
			if(parName.startsWith("cb.")){
				String uid=parName.split("\\.")[1]+"."+parName.split("\\.")[2];
				ProductStock productStock = new ProductStock();
				productStock.setUid("-1");
				productStock.setBegin(new java.util.Date());
				productStock.setCreateDateTime(new java.util.Date());
				productStock.setLevel(0);
				productStock.setMaximumLevel(Integer.parseInt(request.getParameter("max."+uid)));
				productStock.setMinimumLevel(Integer.parseInt(request.getParameter("min."+uid)));
				productStock.setOrderLevel(Integer.parseInt(request.getParameter("order."+uid)));
				productStock.setProductUid(uid);
				productStock.setServiceStockUid(serviceStockUid);
				productStock.setUpdateDateTime(new java.util.Date());
				productStock.setUpdateUser(activeUser.userid);
				productStock.setVersion(1);
				productStock.setDefaultImportance("type1native");
				productStock.store();
			}
		}
		out.println("<script>window.opener.document.getElementById('hideZeroLevel').checked=false;window.opener.document.getElementById('Action').value='findShowOverview';window.opener.transactionForm.submit();window.close();</script>");
		out.flush();
	}

	ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
	Vector productstocks = serviceStock.getProductStocks();
	HashSet products =new HashSet();
	for(int n=0;n<productstocks.size();n++){
		ProductStock productStock = (ProductStock)productstocks.elementAt(n);
		products.add(productStock.getProductUid());
	}

%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='serviceStockUid' value='<%=serviceStockUid%>'/>
	<table width='100%'>
		<tr class='admin'>
			<td><a href='javascript:toggleSelect();'><%=getTran(request,"web","select",sWebLanguage) %></a></td>
			<td><%=getTran(request,"web","code",sWebLanguage) %></td>
			<td><%=getTran(request,"web","product",sWebLanguage) %></td>
			<td><a href='javascript:setMinimum();'><%=getTran(request,"web","minimum",sWebLanguage) %></a></td>
			<td><a href='javascript:setMaximum();'><%=getTran(request,"web","maximum",sWebLanguage) %></a></td>
			<td><a href='javascript:setOrderLevel();'><%=getTran(request,"web","orderlevel",sWebLanguage) %></a></td>
		</tr>
		<%
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_products order by oc_product_name");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String uid=rs.getString("oc_product_serverid")+"."+rs.getString("oc_product_objectid");
				if(!products.contains(uid)){
					out.println("<tr>");
					out.println("<td class='admin'><input class='text' type='checkbox' name='cb."+uid+"'/></td>");
					out.println("<td class='admin'>"+rs.getString("oc_product_code")+"</td>");
					out.println("<td class='admin'>"+rs.getString("oc_product_name")+"</td>");
					out.println("<td class='admin2'><input type='text' class='text' size='5' name='min."+uid+"' id='min."+uid+"' value='0' onchange='calculateorderlevel(\""+uid+"\");'/></td>");
					out.println("<td class='admin2'><input type='text' class='text' size='5' name='max."+uid+"' id='max."+uid+"' value='0' onchange='calculateorderlevel(\""+uid+"\");'/></td>");
					out.println("<td class='admin2'><input type='text' class='text' size='5' name='order."+uid+"' id='order."+uid+"' value='0'/></td>");
					out.println("</tr>");
				}
			}
			rs.close();
			ps.close();
			conn.close();
		%>
	</table>
	<p>
	<center><input type='submit' class='button' name='submitButton' value='<%=getTranNoLink("web","copy",sWebLanguage) %>'/></center>
</form>
<script>
	function toggleSelect(){
		var els = document.all;
		for(n=0;n<els.length;n++){
			element = els[n];
			if(element.name && element.name.startsWith('cb.')){
				element.checked=!element.checked;
			}
		}
	}
	
	function setMinimum(){
		var els = document.all;
		var min=0;
		for(n=0;n<els.length;n++){
			element = els[n];
			if(element.name && element.name.startsWith('min.')){
				if(element.value*1>0){
					min=element.value*1;
				}
				else{
					element.value=min;
				}
			}
		}
	}
	function setMaximum(){
		var els = document.all;
		var max=0;
		for(n=0;n<els.length;n++){
			element = els[n];
			if(element.name && element.name.startsWith('max.')){
				if(element.value*1>0){
					max=element.value*1;
				}
				else{
					element.value=max;
				}
			}
		}
	}
	
	function setOrderLevel(){
		var els = document.all;
		var max=0;
		for(n=0;n<els.length;n++){
			element = els[n];
			if(element.name && element.name.startsWith('max.')){
				if(element.value*1>0){
					calculateorderlevel(element.name.replace('max.',''));
				}
			}
		}
	}

	function calculateorderlevel(id){
		if((document.getElementById('max.'+id).value*1)>(document.getElementById('min.'+id).value*1)){
			document.getElementById('order.'+id).value=((document.getElementById('min.'+id).value*1)+((document.getElementById('max.'+id).value*1)-(document.getElementById('min.'+id).value*1))/5).toFixed(0);
		}
	}
</script>