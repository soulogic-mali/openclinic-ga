<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sProductionOrderId=checkString(request.getParameter("productionOrderId"));
	String sAction = checkString(request.getParameter("action"));
	String sShowAllMaterials = checkString(request.getParameter("showAllMaterials"));
	Debug.println("sProductionOrderId = "+sProductionOrderId);
	if(request.getParameter("submitButton")!=null && sShowAllMaterials.length()==0){
		Enumeration pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parName = (String)pars.nextElement();
			if(parName.startsWith("material.")){
				//Add material to bill of materials
				String sProductStockUid = parName.replaceAll("material.","");
				java.util.Date dDate =new java.util.Date();
				int quantity = 0;
				try{
					quantity=new Double(Double.parseDouble(request.getParameter(parName))).intValue();
				}
				catch(Exception e){}
				if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){
					if(sProductStockUid.length()>0){
						ProductStock productStock = ProductStock.get(sProductStockUid);
						if(productStock!=null && productStock.getProduct()!=null){
							//if an open productorder already exists for this material, add it to the existing one
							//if not, create a new productorder
							ProductOrder order = null;
							Vector orders = ProductOrder.findProductOrdersForProductionOrder(false, true, Integer.parseInt(sProductionOrderId), sProductStockUid, MedwanQuery.getInstance().getConfigString("mainProductionWarehouseUID",""));
							if(orders.size()>0){
								order = (ProductOrder)orders.elementAt(0);
								order.setPackagesOrdered(order.getPackagesOrdered()+quantity);
								order.store();
							}
							else{
								order = new ProductOrder();
								order.setCreateDateTime(new java.util.Date());
								order.setDateOrdered(new java.util.Date());
								order.setDescription(productStock.getProduct().getName()+" ("+getTranNoLink("web","productionorder",sWebLanguage)+" #"+sProductionOrderId+")");
								order.setFrom(MedwanQuery.getInstance().getConfigString("mainProductionWarehouseUID",""));
								order.setImportance("type1native");
								order.setPackagesOrdered(quantity);
								order.setProductStockUid(sProductStockUid);
								order.setUpdateDateTime(new java.util.Date());
								order.setUpdateUser(activeUser.userid);
								order.setUid("-1");
								order.setVersion(1);
								order.setProductionorderuid(sProductionOrderId);
								order.store();
							}
							//Add materials to productionorder
							ProductionOrderMaterial material = new ProductionOrderMaterial();
							material.setCreateDateTime(order.getCreateDateTime());
							material.setProductionOrderId(Integer.parseInt(sProductionOrderId));
							material.setProductStockUid(order.getProductStockUid());
							material.setQuantity(quantity);
							material.setUpdateDateTime(new java.util.Date());
							material.setUpdateUid(Integer.parseInt(activeUser.userid));
							material.setComment(request.getParameter("EditMaterialComment"));
							material.store();
						}
					}
				}
				else if(quantity!=0){
					//Reduce source stock with taken quantity
					ProductStockOperation operation = new ProductStockOperation();
					operation.setUid("-1");
					operation.setCreateDateTime(new java.util.Date());
					operation.setDate(dDate);
					operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockOperationDescription","medicationdelivery.production"));
					//Link operation to productionorder
					operation.setSourceDestination(new ObjectReference("production",sProductionOrderId));
					operation.setProductStockUid(sProductStockUid);
					operation.setUnitsChanged(quantity);
					operation.setVersion(1);
					operation.setUpdateUser(activeUser.userid);
					operation.store();
					//Add materials to productorder
					ProductionOrderMaterial material = new ProductionOrderMaterial();
					material.setCreateDateTime(operation.getCreateDateTime());
					material.setProductionOrderId(Integer.parseInt(sProductionOrderId));
					material.setProductStockUid(operation.getProductStockUid());
					material.setQuantity(operation.getUnitsChanged());
					material.setUpdateDateTime(new java.util.Date());
					material.setUpdateUid(Integer.parseInt(activeUser.userid));
					material.setComment(request.getParameter("EditMaterialComment"));
					material.store();
					%>
					<script>
						window.opener.loadMaterials();
						window.close();
					</script>
					<%
					out.flush();
				}
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='showAllMaterials' id='showAllMaterials'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='3'><%=getTran(request,"web","findmaterials",sWebLanguage) %></td>
			<%
				if(sShowAllMaterials.equalsIgnoreCase("1") || (sShowAllMaterials.length()==0 && MedwanQuery.getInstance().getConfigInt("productionUsePredefinedMaterialsLists",0)==0)){
			%>
					<td colspan='1'><a href='javascript:document.getElementById("showAllMaterials").value=0;transactionForm.submit();'><%=getTran(request,"web","showpredefined",sWebLanguage) %></a></td>
			<%
				}
				else{
			%>
					<td colspan='1'><a href='javascript:document.getElementById("showAllMaterials").value=1;transactionForm.submit();'><%=getTran(request,"web","showall",sWebLanguage) %></a></td>
			<%
				}
			%>
			<td><input type='submit' name='submitButton' value='<%=getTran(null,"web","save",sWebLanguage)%>'/></td>
		</tr>
		<%
			Vector materials = ProductStock.findMaterials();
			if(materials.size()>0){
				//Print header
				%>
				<tr>
					<td class='admin'><%=getTran(request,"web","productname",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"web","unit",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"web","level",sWebLanguage) %></td>
					<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
				</tr>
				<%
			}
			boolean bFound = false;
			if(sShowAllMaterials.equalsIgnoreCase("0") || (sShowAllMaterials.length()==0 && MedwanQuery.getInstance().getConfigInt("productionUsePredefinedMaterialsLists",0)==1)){
				//Add materials for any of the other elements that have been invoiced on the same invoice
				Hashtable mats = new Hashtable();
				ProductionOrder order = ProductionOrder.get(Integer.parseInt(sProductionOrderId));
				if(order!=null){
					Debet debet = order.getDebet();
					if(debet!=null){
						PatientInvoice invoice = debet.getPatientInvoice();
						if(invoice!=null){
							Vector debets = invoice.getDebets();
							for(int n=0;n<debets.size();n++){
								Debet d = (Debet)debets.elementAt(n);
								if(d.getPrestation()!=null && ScreenHelper.checkString(d.getPrestation().getProductionOrderRawMaterials()).length()>0){
									//Materials have been specified
									String[] m = d.getPrestation().getProductionOrderRawMaterials().split(",");
									for(int i=0;i<m.length;i++){
										int quantity = 0;
										if(m[i].split(":").length>1){
											try{
												quantity=Integer.parseInt(m[i].split(":")[1]);
											}
											catch(Exception e){}
										}
										if(mats.get(m[i].split(":")[0])==null){
											mats.put(m[i].split(":")[0],quantity);
										}
										else{
											mats.put(m[i].split(":")[0],((Integer)mats.get(m[i].split(":")[0]))+quantity);
										}
									}
								}
							}
						}
					}
				}
				Enumeration e = mats.keys();
				while(e.hasMoreElements()){
					String materialCode = (String)e.nextElement();
					int quantity = (Integer)mats.get(materialCode);
					//Now reduce the quantity with the number of items that already have been ordered
					Vector existingMaterials=order.getMaterials();
					for(int n=0;n<existingMaterials.size();n++){
						ProductionOrderMaterial material = (ProductionOrderMaterial)existingMaterials.elementAt(n);
						if(material.getProductStockUid().equalsIgnoreCase(materialCode)){
							quantity-=material.getQuantity();
						}
					}
					if(quantity<0){
						quantity=0;
					}
					ProductStock productStock = ProductStock.get(materialCode);
					if(productStock!=null){
						Product product = productStock.getProduct();
						ServiceStock serviceStock = productStock.getServiceStock();
						if(product!=null && serviceStock!=null){
							bFound=true;
							out.println("<tr>");
							out.println("<td>"+product.getName()+"</td>");
							out.println("<td>"+serviceStock.getName()+"</td>");
							out.println("<td>"+getTran(request,"product.unit",product.getUnit(),sWebLanguage)+"</td>");
							out.println("<td>"+productStock.getLevel()+"</td>");
							out.println("<td><input type='text' class='text' name='material."+productStock.getUid()+"' size='5' value='"+quantity+"'/></td>");
							out.println("</tr>");
						}
					}
				}
			}
			if(!bFound){
				for(int n=0;n<materials.size();n++){
					ProductStock productStock = (ProductStock)materials.elementAt(n);
					Product product = productStock.getProduct();
					ServiceStock serviceStock = productStock.getServiceStock();
					if(product!=null && serviceStock!=null){
						out.println("<tr>");
						out.println("<td>"+product.getName()+"</td>");
						out.println("<td>"+serviceStock.getName()+"</td>");
						out.println("<td>"+getTran(request,"product.unit",product.getUnit(),sWebLanguage)+"</td>");
						out.println("<td>"+productStock.getLevel()+"</td>");
						out.println("<td><input type='text' class='text' name='material."+productStock.getUid()+"' size='5' value='0'/></td>");
						out.println("</tr>");
					}
				}
			}
		%>
	</table>
</form>