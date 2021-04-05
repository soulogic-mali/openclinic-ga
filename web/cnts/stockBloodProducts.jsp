<%@page import="be.openclinic.medical.RequestedLabAnalysis"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String giftid = SH.c(request.getParameter("giftid"));
	String type = SH.c(request.getParameter("type"));
	String quantity = SH.c(request.getParameter("quantity"));
	String end = SH.c(request.getParameter("end"));
	if(request.getParameter("submitButton")!=null){
		int tfQuantity = Integer.parseInt(request.getParameter("tf_quantity"));
		String stockuid = SH.c(request.getParameter("stockuid"));
		ProductStock stock = ProductStock.get(stockuid);
		if(stock!=null){
			ProductStockOperation operation = new ProductStockOperation();
			Batch batch = Batch.getByBatchNumber(stock.getUid(), giftid+"."+type);
			if(batch==null){
				batch = new Batch();
				batch.setUid("-1");
				batch.setBatchNumber(giftid+"."+type);
				batch.setCreateDateTime(new java.util.Date());
				batch.setLevel(0);
				batch.setEnd(SH.parseDate(end));
				batch.setProductStockUid(stock.getUid());
				batch.setUpdateUser(activeUser.userid);
				batch.setVersion(1);
				batch.setComment(getTranNoLink("web","bloodbankproduction",sWebLanguage));
				batch.store();
			}
			operation.setUid("-1");
			operation.setBatchUid(batch.getUid());
			operation.setCreateDateTime(new java.util.Date());
			operation.setDate(new java.util.Date());
			operation.setDescription("medicationreceipt.2");
			operation.setProductStockUid(stock.getUid());
			operation.setReceiveProductStockUid(stock.getUid());
			operation.setReceiveComment("BloodBank Production");
			operation.setSourceDestination(new ObjectReference("patient",activePatient.personid));
			operation.setUnitsChanged(tfQuantity);
			operation.setUpdateDateTime(new java.util.Date());
			operation.setUpdateUser(activeUser.userid);
			operation.setVersion(1);
			operation.store();
			out.println("<script>window.opener.checkStockedProducts();window.opener.checkPharmacyLink('"+type+"','"+type+"div');window.close();</script>");
			out.flush();
		}
	}
	//Find the list of all products of this type
	Vector productstocks = new Vector();
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_productstocks where oc_stock_location=?");
	ps.setString(1,type);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		productstocks.add(ProductStock.get(rs.getInt("oc_stock_serverid")+"."+rs.getInt("oc_stock_objectid")));
	}
	rs.close();
	ps.close();
	conn.close();
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='giftid' value='<%=giftid %>'/>
	<input type='hidden' name='type' value='<%=type %>'/>
	<input type='hidden' name='end' value='<%=end %>'/>
	<table width='100%'>
		<tr class='admin'><td colspan="2"><%=getTran(request,"bloodproducts",type,sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","expirydate",sWebLanguage) %></td>
			<td class='admin2'><%=end %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
			<td class='admin2'>
				<select name='tf_quantity' id='tf_quantity' class='text'>
					<%
						for(int n=1;n<Integer.parseInt(quantity)+1;n++){
							out.println("<option "+(n==Integer.parseInt(quantity)?"selected":"")+" value='"+n+"'>"+n+"</option>");
						}
					%>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","destinationstock",sWebLanguage) %></td>
			<td class='admin2'>
				<%
				String sOptions="";
				for(int n=0;n<productstocks.size();n++){
					ProductStock stock = (ProductStock)productstocks.elementAt(n);
					Product product = stock.getProduct();
					if(SH.cs("edition","openclinic").equalsIgnoreCase("bloodbank") && product.getAtccode().length()>0){
			        	String cntsABO="",cntsRhesus="";
						RequestedLabAnalysis analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(activePatient.personid), MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO"));
			        	if(analysis!=null){
			        		cntsABO=analysis.getResultValue().toLowerCase();
			        	}
			        	else{
			        		continue;
			        	}
			        	analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(activePatient.personid), MedwanQuery.getInstance().getConfigString("cntsRhesusCode","Rh"));
			        	if(analysis!=null){
			        		cntsRhesus=analysis.getResultValue().toLowerCase();
			        	}
			        	else{
			        		continue;
			        	}
			        	if(cntsRhesus.equalsIgnoreCase("-")||cntsRhesus.equalsIgnoreCase("neg")){
			        		cntsABO+=cntsRhesus;
			        	}
			        	if(!cntsABO.equalsIgnoreCase(product.getAtccode())){
			        		continue;
			        	}
					}
					if(product!=null && stock.getServiceStock().isReceivingUser(activeUser.userid)){
						sOptions+="<option value='"+stock.getUid()+"'>"+stock.getServiceStock().getName()+" | "+product.getName()+"</option>";
					}
				}
				if(sOptions.length()>0){
				%>
					<select name='stockuid' id='stockuid' class='text'>
						<%=sOptions %>
					</select>
				<%	}
					else {%>
					<font color='red'><b><%=getTran(request,"web","nomatchingproductstocks",sWebLanguage) %></b></font>
				<%} %>
			</td>
		</tr>
	</table>
	<center>
		<input class='button' type='button' onclick='window.close();' value='<%=getTranNoLink("web","close",sWebLanguage) %>'/>
		<% if(request.getParameter("submitButton")==null && productstocks.size()>0 && !SH.parseDate(end).before(new java.util.Date())){ %>
			<input class='button' type='submit' name='submitButton' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
		<%} %>
	</center>
</form>