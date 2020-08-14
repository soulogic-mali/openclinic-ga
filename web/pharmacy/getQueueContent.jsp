<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<td colspan='2'><table width='100%'>
	<tr class='admin'>
	<% 
		String unconfirmed = checkString(request.getParameter("unconfirmed"));
		if(unconfirmed.equalsIgnoreCase("1")){%>
			<td width='10%' colspan='2'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td width='30%'><%=getTran(request,"web","product",sWebLanguage) %></td>
		<%}
		else{%>
			<td width='40%' colspan='2'><%=getTran(request,"web","product",sWebLanguage) %></td>
			<td width='10%'><%=getTran(request,"web","user",sWebLanguage) %></td>
		<%}%>
		<td width='10%'><%=getTran(request,"web","batch",sWebLanguage) %></td>
		<td width='5%'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
		<td width='5%'><%=getTran(request,"web","level",sWebLanguage) %></td>
		<td><%=getTran(request,"web","patient",sWebLanguage) %></td>
	</tr>
<%
	try{
		String servicestockuid=checkString(request.getParameter("servicestockuid"));
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		String sSql="";
		if(unconfirmed.equalsIgnoreCase("1")){
			sSql="select "+MedwanQuery.getInstance().getConfigString("dateFunction","now()")+" oc_operation_date,personid,lastname,firstname,oc_list_quantity oc_operation_unitschanged, oc_list_batchuid oc_operation_batchuid,oc_list_serverid oc_operation_serverid,oc_list_objectid oc_operation_objectid,oc_stock_serverid,oc_stock_objectid from oc_drugsoutlist,oc_productstocks,adminview where "+
				" oc_stock_objectid=replace(oc_list_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
				" '1900-01-01'<? and"+
				" personid=oc_list_patientuid and"+
				" oc_stock_servicestockuid=?"+
				" order by lastname,firstname,oc_list_patientuid";
		}
		else{
			sSql="select * from oc_productstockoperations,oc_productstocks,adminview where"+
						" oc_operation_date>=? and"+
						" oc_operation_description like 'medicationdelivery%' and"+
						" oc_operation_srcdesttype='patient' and"+
						" personid=oc_operation_srcdestuid and"+
						" oc_operation_deliverytime is null and"+
						" oc_stock_objectid=replace(oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"+
						" oc_stock_servicestockuid=?"+
						" order by lastname,firstname,oc_operation_date";
		}
		PreparedStatement ps = conn.prepareStatement(sSql);
		ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(ScreenHelper.getDate()).getTime()));
		ps.setString(2,servicestockuid);
		ResultSet rs = ps.executeQuery();
		Vector queue = new Vector();
		Hashtable stocks = new Hashtable(), quantities= new Hashtable();
		while(rs.next()){
			String uid=rs.getInt("oc_stock_serverid")+"."+rs.getInt("oc_stock_objectid");
			String operationuid=rs.getString("oc_operation_serverid")+"."+rs.getString("oc_operation_objectid");
			if(stocks.get(uid)==null){
				ProductStock stock = ProductStock.get(uid);
				if(stock!=null){
					stocks.put(stock.getUid(),stock);
				}
			}
			String personid=rs.getString("personid");
			String patient = personid+" - "+rs.getString("lastname").toUpperCase()+", "+rs.getString("firstname");
			int quantity=rs.getInt("oc_operation_unitschanged");
			if(quantities.get(uid)==null){
				quantities.put(uid,0);
			}
			quantities.put(uid,((Integer)quantities.get(uid))+quantity);
			String date="?";
			String userName="";
			if(unconfirmed.equalsIgnoreCase("1")){
				date=ScreenHelper.formatDate(rs.getDate("oc_operation_date"));
			}
			else{
				userName=MedwanQuery.getInstance().getUserName(rs.getInt("oc_operation_updateuid"));
			}
			queue.add(uid+";"+rs.getString("oc_operation_batchuid")+";"+quantity+";"+patient+";"+operationuid+";"+date+";"+userName+";"+personid+";");
		}
		for(int n=0;n<queue.size();n++){
			String queueItem = (String)queue.elementAt(n);
			ProductStock stock = (ProductStock)stocks.get(queueItem.split(";")[0]);
			if(stock!=null){
				String productName = stock.getProduct().getName();
				String batchNumber = "";
				Batch batch = Batch.get(queueItem.split(";")[1]);
				if(batch!=null){
					batchNumber=batch.getBatchNumber();
				}
				int quantity = Integer.parseInt(queueItem.split(";")[2]);
				String date = queueItem.split(";")[5];
				int level = stock.getLevel()+(Integer)quantities.get(queueItem.split(";")[0]);
				String patient = queueItem.split(";")[3];
				String personid=queueItem.split(";")[7];
				if(unconfirmed.equalsIgnoreCase("1")){
					if(activeUser.getAccessRightNoSA("pharmacy.unconfirmedwaitinglist.delete")){
						out.println("<tr><td class='admin' onmouseover=\"this.style.cursor='hand';\" onmouseout=\"this.style.cursor='default';\" nowrap ><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick=\"deleteProduct('"+queueItem.split(";")[4]+"');\"/></td><td class='admin2'><font style='font-size:14px'>< "+date+"</font></td><td class='admin2'><font style='font-size:14px'>"+productName+"</font></td><td class='admin2'><font style='font-size:14px'>"+batchNumber+"</font></td><td class='admin2'><font style='font-size:14px'>"+quantity+"</font></td><td class='admin2'><font style='font-size:14px'>"+level+"</font></td><td class='admin2'><font style='font-size:10px'><a href='javascript:selectPatient("+personid+");'>"+patient+"</a></font></td></tr>");
					}
					else{
						out.println("<tr><td class='admin2' colspan='2' nowrap><font style='font-size:14px'>< "+date+"</font></td><td class='admin'><font style='font-size:14px'>"+productName+"</font></td><td class='admin2'><font style='font-size:14px'>"+batchNumber+"</font></td><td class='admin2'><font style='font-size:14px'>"+quantity+"</font></td><td class='admin2'><font style='font-size:14px'>"+level+"</font></td><td class='admin2'><font style='font-size:10px'><a href='javascript:selectPatient("+personid+");'>"+patient+"</a></font></td></tr>");
					}
				}
				else{
					String userName=queueItem.split(";")[6];
					out.println("<tr><td class='admin' onmouseover=\"this.style.cursor='hand';\" onmouseout=\"this.style.cursor='default';\" ><img src='"+sCONTEXTPATH+"/_img/icons/icon_order.gif' onclick=\"deliverProduct('"+queueItem.split(";")[4]+"');\"/></td><td class='admin'><font style='font-size:14px'>"+productName+"</font></td><td class='admin2'><font style='font-size:14px'>"+userName+"</font></td><td class='admin2'><font style='font-size:14px'>"+batchNumber+"</font></td><td class='admin2'><font style='font-size:14px'>"+quantity+"</font></td><td class='admin2'><font style='font-size:14px'>"+level+"</font></td><td class='admin2'><font style='font-size:10px'>"+patient+"</font></td></tr>");
				}
			}
		}
		rs.close();
		ps.close();
		conn.close();
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</table></td>
