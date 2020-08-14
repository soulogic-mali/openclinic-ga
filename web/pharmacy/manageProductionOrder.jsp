<%@page import="be.openclinic.finance.*,be.mxs.common.util.system.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.manageproductionorders","all",activeUser)%>
<%
	String sProductionOrderUid=checkString(request.getParameter("productionOrderUid"));
	ProductionOrder order = null;
	if(sProductionOrderUid.length()>0){
		try{
			order=ProductionOrder.get(Integer.parseInt(sProductionOrderUid));
		}
		catch(Exception e){}
	}
	if(order==null){
		order= new ProductionOrder();
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("reopen")){
		order.setCloseDateTime(null);
		order.store();
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("cancel")){
		//Now close the production order
		order.setUpdateDateTime(new java.util.Date());
		order.setQuantity(0);
		order.setComment("CANCELED");
		order.setPatientUid(-1);
		order.setTargetProductStockUid("");
		order.setUpdateUid(Integer.parseInt(activeUser.userid));
		order.store();
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("close")){
		java.util.Date dClose = ScreenHelper.parseDate(request.getParameter("ProductionOrderCloseDateTime"));
		if(dClose==null){
			dClose=new java.util.Date();
		}
		int nQuantity=0;
		try{
			nQuantity=Integer.parseInt(request.getParameter("ProductionOrderQuantity"));
		}
		catch(Exception e){}
		//First add produced quantity to product stock
		if(nQuantity>0){
			if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){
				//Remove used raw materials from their stocks
				//Reduce source stock with taken quantity
				Vector materials = order.getUnusedMaterialsSummary();
				for(int n=0;n<materials.size();n++){
					ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(n);
					//we don't store new operations for raw materials that have already been used
					if(material.getDateUsed()==null){
						ProductStock productStock = ProductStock.get(material.getProductStockUid());
						ProductStockOperation operation = new ProductStockOperation();
						operation.setUid("-1");
						operation.setCreateDateTime(new java.util.Date());
						operation.setDate(new java.util.Date());
						operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockDeliveryOperationDescription","medicationdelivery.production"));
						//Link operation to productionorder
						operation.setSourceDestination(new ObjectReference("production",sProductionOrderUid));
						operation.setProductStockUid(productStock.getUid());
						operation.setUnitsChanged(new Double(material.getQuantity()).intValue());
						operation.setVersion(1);
						operation.setUpdateUser(activeUser.userid);
						operation.store();
						//Now mark the material as having been used
						material.setUsed(material.getProductionOrderId(),material.getProductStockUid(),new java.util.Date());
					}
				}
			}
			//If personalized batch doesn't exist, create it
			String sBatchId="";
			if(order.getPatientUid()>-1){
				sBatchId=order.getPatientUid()+"";
				if(!Batch.exists(order.getTargetProductStockUid(), sBatchId)){
					Batch batch = new Batch();
					batch.setUid("-1");
					batch.setBatchNumber(order.getPatientUid()+"");
					batch.setCreateDateTime(new java.util.Date());
					batch.setLevel(0);
					batch.setProductStockUid(order.getTargetProductStockUid());
					batch.setType("production");
					batch.setUpdateDateTime(new java.util.Date());
					batch.setUpdateUser(activeUser.userid);
					batch.setComment(AdminPerson.getFullName(order.getPatientUid()+""));
					batch.store();
				}
			}
			else{
				sBatchId="O"+order.getId();
				if(!Batch.exists(order.getTargetProductStockUid(), "O"+order.getId())){
					Batch batch = new Batch();
					batch.setUid("-1");
					batch.setBatchNumber(sBatchId);
					batch.setCreateDateTime(new java.util.Date());
					batch.setLevel(0);
					batch.setProductStockUid(order.getTargetProductStockUid());
					batch.setType("production");
					batch.setUpdateDateTime(new java.util.Date());
					batch.setUpdateUser(activeUser.userid);
					batch.setComment("O"+order.getId());
					batch.store();
				}
			}
			//Add produced goods to stock
			//First check the already registered produced good for this order
			int nOrderQuantity = ProductStockOperation.getProducedQuantity(Integer.parseInt(sProductionOrderUid),order.getTargetProductStockUid());
			if(nQuantity!=nOrderQuantity){
				ProductStockOperation operation = new ProductStockOperation();
				operation.setUid("-1");
				operation.setCreateDateTime(new java.util.Date());
				operation.setDate(new java.util.Date());
				operation.setDescription(MedwanQuery.getInstance().getConfigString("productionStockReceiptOperationDescription","medicationreceipt.production"));
				//Link operation to productionorder
				operation.setSourceDestination(new ObjectReference("production",sProductionOrderUid));
				operation.setProductStockUid(order.getTargetProductStockUid());
				//We first detect the produced quantity that has already been registered for this production order
				operation.setUnitsChanged(nQuantity-nOrderQuantity);
				operation.setVersion(1);
				operation.setUpdateUser(activeUser.userid);
				//Add person data to batch information
				operation.setBatchUid(Batch.getByBatchNumber(order.getTargetProductStockUid(), sBatchId).getUid());
				operation.store();
				
				//****************************************************
				//Update the purchase price of the finished good based on the raw materials value
				//First calculate total cost of raw materials
				double totalcost = 0;
				Vector mats = order.getMaterialsSummary();
				for(int n=0;n<mats.size();n++){
					ProductionOrderMaterial mat = (ProductionOrderMaterial)mats.elementAt(n);
					if(mat.getProductStock()!=null && mat.getProductStock().getProduct()!=null){
						double cost = mat.getProductStock().getProduct().getLastYearsAveragePrice();
						totalcost+=cost*mat.getQuantity();
					}
				}
				//Now update the pointers for the drugprice and the PUMP
            	try{
            		Pointer.deletePointers("drugprice."+operation.getProductStock().getProduct().getUid()+"."+operation.getUid());
            		Pointer.storePointer("drugprice."+operation.getProductStock().getProduct().getUid()+"."+operation.getUid(),nQuantity+";"+(totalcost/nQuantity));
        			//Recalculate PUMP
        			//Get previous PUMP
        			double dPump=operation.getProductStock().getProduct().getLastYearsAveragePrice();
        			if(dPump>0){
        				//Find existing quantity for the product
        				int nExisting = operation.getProductStock().getProduct().getTotalQuantityAvailable()-nQuantity; //new delivery was already added to stocks
        				dPump = (nExisting*dPump+totalcost)/(nExisting+nQuantity);
        			}
        			else{
        				dPump=totalcost;
        			}
            		Pointer.storePointer("pump."+operation.getProductStock().getProduct().getUid(),(dPump/nQuantity)+"");
            	}
            	catch(Exception e){
            		//e.printStackTrace();
            	}
				//**************************************************
			}
			//Now close the production order
			order.setCloseDateTime(dClose);
			order.setUpdateDateTime(new java.util.Date());
			order.setQuantity(nQuantity);
			order.setComment(request.getParameter("ProductionOrderComment"));
			order.setTechnician(request.getParameter("ProductionOrderTechnician"));
			order.setDestination(request.getParameter("ProductionOrderDestination"));
			order.store();
		}
	}
	else if(checkString(request.getParameter("action")).equalsIgnoreCase("save")){
		int nQuantity=0;
		try{
			nQuantity=Integer.parseInt(request.getParameter("ProductionOrderQuantity"));
		}
		catch(Exception e){}
		//Now save the production order
		order.setQuantity(nQuantity);
		order.setComment(checkString(request.getParameter("ProductionOrderComment")));
		order.setTechnician(request.getParameter("ProductionOrderTechnician"));
		order.setDestination(request.getParameter("ProductionOrderDestination"));
		order.setEstimatedDelivery(checkString(request.getParameter("ProductionOrderEstimatedDelivery")));
		order.store();
	}
	sTDAdminWidth="20%";
	PatientInvoice invoice=null;
	Debet debet=null;
	if(order.getDebetUid()!=null){
		debet = Debet.get(order.getDebetUid());
		if(debet!=null){
			invoice = debet.getPatientInvoice();
		}
	}
	if(invoice==null){
		invoice=new PatientInvoice();
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='4'><%=getTran(request,"web.manage","manageproductionorder",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionof",sWebLanguage) %></td>
			<td class='admin2'><%=order.getProductStock()==null||order.getProductStock().getProduct()==null?"?":order.getProductStock().getProduct().getName().toUpperCase()+" ("+order.getProductStock().getServiceStock().getName()+")"%></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderclosed",sWebLanguage) %></td>
			<td class='admin2'><%=order.getCloseDateTime()!=null?ScreenHelper.formatDate(order.getCloseDateTime()):ScreenHelper.writeDateField("ProductionOrderCloseDateTime", "transactionForm", ScreenHelper.formatDate(order.getCloseDateTime()), true, false, sWebLanguage, sCONTEXTPATH)%></td>
		</tr>
		<tr>
			<%if(order.getPatientUid()>-1){ %>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderid",sWebLanguage) %></td>
				<td class='admin2'><%=order.getId()>0?order.getId()+"":"" %><input type='hidden' name='ProductionOrderId' value='<%=order.getId()%>'/></td>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","patient",sWebLanguage) %></td>
				<td class='admin2'><%=AdminPerson.getFullName(order.getPatientUid()+"") %></td>
			<%}else{ %>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderid",sWebLanguage) %></td>
				<td class='admin2' colspan='3'><%=order.getId()>0?order.getId()+"":"" %><input type='hidden' name='ProductionOrderId' value='<%=order.getId()%>'/></td>
			<%} %>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","technician",sWebLanguage) %></td>
			<td class='admin2'>
				<select <%=order.getCloseDateTime()!=null?"disabled":"" %> class='text' name='ProductionOrderTechnician' id='ProductionOrderTechnician'/>
					<option/>
					<%=ScreenHelper.writeSelect(request,"productiontechnician", order.getTechnician(), sWebLanguage) %>
				</select>
			</td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","destination",sWebLanguage) %></td>
			<td class='admin2'>
				<select <%=order.getCloseDateTime()!=null?"disabled":"" %> class='text' name='ProductionOrderDestination' id='ProductionOrderDestination'/>
					<option/>
					<%=ScreenHelper.writeSelect(request,"productiondestination", order.getDestination(), sWebLanguage) %>
				</select>
			</td>
		</tr>
		<%if(order.getPatientUid()>-1){ %>
			<tr>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","invoice",sWebLanguage) %></td>
				<td class='admin2'>
					<table width='100%'>
						<tr>
							<td width='33%'><a href='javascript:openInvoice("<%=invoice.getUid() %>");'><%=invoice.getUid() %></a></td>
							<td class='admin'><%=getTran(request,"web","estimateddeliverydate",sWebLanguage) %></td>
							<td class='admin2'><%=order.getCloseDateTime()!=null?order.getEstimatedDelivery():ScreenHelper.writeDateField("ProductionOrderEstimatedDelivery", "transactionForm", order.getEstimatedDelivery(), true, true, sWebLanguage, sCONTEXTPATH)%></td>
						</tr>
					</table>
				</td>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","invoicedate",sWebLanguage) %></td>
				<td class='admin2'><%=ScreenHelper.formatDate(invoice.getDate()) %></td>
			</tr>
			<tr>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderprescription",sWebLanguage)%></td>
				<td class='admin2'><a href='javascript:viewProductionOrderPrescriptions("<%=debet==null||debet.getPrestation()==null?-1:debet.getPrestation().getProductionOrderPrescription()%>")'><%=debet==null||debet.getPrestation()==null?"":getTranNoLink("examination",debet.getPrestation().getProductionOrderPrescription()+"",sWebLanguage)%></a></td>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","linkedprestation",sWebLanguage) %></td>
				<td class='admin2'><%=debet==null||debet.getPrestation()==null?"":debet.getPrestation().getDescription() %></td>
			</tr>
		<%} %>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","comment",sWebLanguage) %></td>
			<td class='admin2'><textarea <%=order.getCloseDateTime()!=null?"readonly":"" %> class='text' cols='80' rows='2' name='ProductionOrderComment' id='ProductionOrderComment'><%=checkString(order.getComment()) %></textarea></td>
			<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","quantityproduced",sWebLanguage) %> <%=debet==null?"":"("+getTran(request,"web","ordered",sWebLanguage).toLowerCase()+": "+debet.getQuantity()+")" %></td>
			<td class='admin2'><input <%=order.getCloseDateTime()!=null?"readonly":"" %> type='text' class='text' size='5' name='ProductionOrderQuantity' id='ProductionOrderQuantity' value='<%=order.getQuantity()%>'><%=order.getPatientUid()<0 || order.getCloseDateTime()==null?"":" <a href='javascript:traceBatch();'><img src='"+sCONTEXTPATH+"/_img/icons/icon_search.png'/></a>"%></td>
		</tr>
		<tr class='admin'>
			<td><%=getTran(request,"web","billofmaterials",sWebLanguage) %></td>
			<td colspan='2'>
				<%if(order.getCloseDateTime()==null){ %>
					<input class='button' type='button' name='addmaterial' id='addmaterial' value='<%=getTran(null,"web","addmaterials",sWebLanguage) %>' onclick='addMaterials()'/>
					<input class='button' type='button' name='addmaterialquick' id='addmaterialquick' value='<%=getTran(null,"web","quicklist",sWebLanguage) %>' onclick='addMaterialsQuickList()'/>
					<input class='button' type='button' name='saveButton' id='saveButton' value='<%=getTran(null,"web","save",sWebLanguage) %>' onclick='doSave()'/>
				<%} %>
					<input class='button' type='button' name='printButton' id='printButton' value='<%=getTran(null,"web","print",sWebLanguage) %>' onclick='doPrintOrder()'/>
			</td>
			<td>
				<%
					if(order.canClose(activeUser)){
				%>
					<input class='button' type='button' name='closeButton' id='closeButton' value='<%=getTran(null,"web","closeorder",sWebLanguage) %>' onclick='closeProductionOrder()'/>
				<%	
					}
					if(order.canCancel()){
				%>
					<input class='button' type='button' name='cancelButton' id='cancelButton' value='<%=getTranNoLink("web","cancelorder",sWebLanguage) %>' onclick='cancelProductionOrder()'/>
				<%	
					}
					if(order.getCloseDateTime()!=null && activeUser.getAccessRightNoSA("pharmacy.reopenproductionorder.select")){
				%>
					<input class='button' type='button' name='reopenButton' id='reopenButton' value='<%=getTranNoLink("web","reopen",sWebLanguage) %>' onclick='reopenProductionOrder()'/>
				<%} %>
			</td>
		</tr>
		<tr>
			<td colspan='4'>
				<div name='divMaterials' id='divMaterials'/>
			</td>
		</tr>
	</table>
</form>

<script>
	function traceBatch(){
		<%
			String batchuid="";
			String productstockuid="";
			if(order!=null){
				productstockuid=order.getProductStock().getUid();
				Batch batch = Batch.getByBatchNumber(productstockuid, order.getPatientUid()+"");
				if(batch!=null){
					batchuid=batch.getUid();
				}
			}
		%>
        openPopup("/pharmacy/popups/batchOperationList.jsp&batchUid=<%=batchuid%>&productStockUid=<%=productstockuid%>&ts=<%=getTs()%>&PopupWidth=800&PopupHeight=400");
	}
	function openInvoice(sInvoiceId){
        openPopup("/financial/patientInvoiceEdit.jsp&ts=<%=getTs()%>&PopupWidth="+(screen.width-200)+"&PopupHeight=600&FindPatientInvoiceUID="+sInvoiceId+"&showpatientname=1&nosave=1");
  	}

	function closeProductionOrder(){
		var bCanClose=false;
		if(document.getElementById('ProductionOrderQuantity').value*1<=0){
			bCanClose=window.confirm("<%=getTranNoLink("web","quantityzero.areyousure",sWebLanguage)%>");
		}
		<%if(debet!=null){%>
		else if(document.getElementById('ProductionOrderQuantity').value*1!=<%=debet.getQuantity()%>){
			bCanClose=window.confirm("<%=getTranNoLink("web","quantitydifferentfromorder.areyousure",sWebLanguage)%>");
		}
		<%}%>
		else {
			bCanClose=true;
		}
		if(bCanClose){
			document.getElementById('action').value='close';
			transactionForm.submit();
		}
	}
	
	function cancelProductionOrder(){
		document.getElementById('action').value='cancel';
		transactionForm.submit();
	}
	
	function reopenProductionOrder(){
		document.getElementById('action').value='reopen';
		transactionForm.submit();
	}
	
	function doSave(){
		document.getElementById('action').value='save';
		transactionForm.submit();
	}

	function addMaterials(){
		  openPopup("/pharmacy/addMaterials.jsp&PopupHeight=200&PopupWidth=600&productionOrderId="+transactionForm.ProductionOrderId.value);
	}
	
	function addMaterialsQuickList(){
		  openPopup("/_common/search/searchMaterials.jsp&PopupHeight=400&PopupWidth=600&productionOrderId="+transactionForm.ProductionOrderId.value);
	}
	
	function doPrintOrder(){
		  window.open("<c:url value="/"/>pharmacy/printProductionOrder.jsp?productionOrderId="+transactionForm.ProductionOrderId.value,"ProductionOrder","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	}
	
	function loadMaterials(){
	    document.getElementById('divMaterials').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = 'productionOrderId=' + transactionForm.ProductionOrderId.value;
	    var today = new Date();
	    var url= '<c:url value="/pharmacy/ajax/getProductionOrderMaterials.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        $('divMaterials').innerHTML=resp.responseText;
	      }
		});
	}

	function viewProductionOrderPrescriptions(examinationid){
		openPopup("/pharmacy/viewProductionOrderPrescriptions.jsp&PopupHeight=400&PopupWidth=600&examinationid="+examinationid);
	}
	
	window.setTimeout('loadMaterials();',200);
</script>