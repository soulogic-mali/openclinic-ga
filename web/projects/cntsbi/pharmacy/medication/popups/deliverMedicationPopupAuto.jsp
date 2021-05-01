<%@page import="java.awt.Color"%>
<%@page import="be.openclinic.pharmacy.*,be.openclinic.finance.*,
                be.openclinic.medical.Prescription"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"medication.medicationdelivery","all",activeUser)%>
<%
	String sEditOrderUid = SH.c(request.getParameter("EditOrderUid"));
	String sEditProductStockUid = SH.c(request.getParameter("EditProductStockUid"));
	String sQuantity=SH.c(request.getParameter("EditUnitsChanged"));
	String sDestinationStockUid = SH.c(request.getParameter("EditSrcDestUid"));
	
	ProductStock productStock = ProductStock.get(sEditProductStockUid);
	
	if(request.getParameter("submitButton")!=null){
		int nProductsToBeInvoiced = 0;
		String destination = request.getParameter("destination");
		ServiceStock destinationStock = ServiceStock.get(destination);
		Enumeration<String> pars = request.getParameterNames();
		while(pars.hasMoreElements()){
			String parName = pars.nextElement();
			String batchUid = "";
			if(parName.startsWith("cb.") || parName.startsWith("sb.")){
				batchUid=parName.substring(3);
				int quantity = Integer.parseInt(request.getParameter(parName));
				Batch batch = Batch.get(batchUid);
				if(batch!=null && quantity>0){
					//We now must transfer the product quantity from the source to the destination serviceStock
					if(destinationStock!=null){
						ProductStock sourceProductStock = ProductStock.get(batch.getProductStockUid());
						ProductStock destinationProductStock = null;
						Vector<ProductStock> destinationProductStocks = ProductStock.find(destination, sourceProductStock.getProductUid(), "", "", "", "", "", "", "", "", "", "", "");
						//First check if product stock for this product already exists at destination
						if(destinationProductStocks.size()>0){
							//Yes exists
							destinationProductStock=destinationProductStocks.elementAt(0);
						}
						else{
							//No, doesn't exist so create it
							destinationProductStock = new ProductStock();
							destinationProductStock.setUid("-1");
							destinationProductStock.setBegin(new java.util.Date());
							destinationProductStock.setCreateDateTime(new java.util.Date());
							destinationProductStock.setDefaultImportance(sourceProductStock.getDefaultImportance());
							destinationProductStock.setLevel(0);
							destinationProductStock.setLocation("");
							destinationProductStock.setProductUid(sourceProductStock.getProductUid());
							destinationProductStock.setServiceStockUid(destination);
							destinationProductStock.setUpdateDateTime(new java.util.Date());
							destinationProductStock.setUpdateUser(sourceProductStock.getUpdateUser());
							destinationProductStock.store();
						}
						//First remove products from source stock
						ProductStockOperation operation = new ProductStockOperation();
				        operation.setUid("");
				        operation.setDescription("medicationdelivery.2");
				        operation.setBatchUid(batchUid);
				        operation.setDocumentUID("");
				        operation.setEncounterUID("");
				        operation.setComment("");
				        ObjectReference sourceDestination = new ObjectReference();
				        sourceDestination.setObjectType("servicestock");
				        sourceDestination.setObjectUid(destination);
				        operation.setSourceDestination(sourceDestination);
				        operation.setDate(new java.util.Date());
				        operation.setProductStockUid(sourceProductStock.getUid());
				        operation.setUnitsChanged(quantity);
				        operation.setUpdateUser(activeUser.userid);
				        operation.setValidated(1);
				        operation.setUnitsReceived(quantity); //Automatically mark the products as received by the destination stock
				        operation.setReceiveProductStockUid(destinationProductStock.getUid());
						operation.store();
						
						//Then add products to destination stock
						operation = new ProductStockOperation();
				        operation.setUid("");
				        operation.setDescription("medicationreceipt.1");
				        operation.setBatchUid(batchUid);
				        operation.setDocumentUID("");
				        operation.setEncounterUID("");
				        operation.setComment("");
				        sourceDestination = new ObjectReference();
				        sourceDestination.setObjectType("servicestock");
				        sourceDestination.setObjectUid(sourceProductStock.getServiceStockUid());
				        operation.setSourceDestination(sourceDestination);
				        operation.setDate(new java.util.Date());
				        operation.setProductStockUid(destinationProductStock.getUid());
				        operation.setUnitsChanged(quantity);
				        operation.setUpdateUser(activeUser.userid);
				        operation.setValidated(1);
						operation.store();					
						
						//If the destination stock is linked to a virtual account, then the products will have to be invoiced to that account
						nProductsToBeInvoiced+=quantity;
					}
				}
			}
		}
		ProductOrder order = ProductOrder.get(sEditOrderUid);
		order.setPackagesDelivered(order.getPackagesDelivered()+nProductsToBeInvoiced);
		order.setDateDelivered(new java.util.Date());
		if(order.getPackagesDelivered()>=order.getPackagesOrdered()){
			order.setStatus("closed");
			order.setProcessed(1);
		}
		order.store();
		System.out.println(1);
		if(SH.c(productStock.getServiceStock().getVirtualInvoicingAccount()).length()==0 && SH.c(destinationStock.getVirtualInvoicingAccount()).length()>0 && nProductsToBeInvoiced>0){
			System.out.println(2);
			//We must invoice these deliveries
			String prestationCode = SH.c(productStock.getProduct().getPrestationcode());
			if(prestationCode.length()>0){
				System.out.println(3);
				Prestation prestation = Prestation.get(prestationCode);
				Insurance insurance = Insurance.getMostInterestingInsuranceForPatient(destinationStock.getVirtualInvoicingAccount());
				if(prestation!=null && insurance!=null){
					System.out.println(4);
					Debet debet = new Debet();
					debet.setPrestationUid(prestation.getUid());
					debet.setInsuranceUid(insurance.getUid());
					debet.setQuantity(new Double(nProductsToBeInvoiced));
					if(insurance.getExtraInsurarUid().length()>0){
						debet.setAmount(0);
						debet.setExtraInsurarUid(insurance.getExtraInsurarUid());
						debet.setExtraInsurarAmount(debet.getQuantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter()));
					}
					else{
						debet.setAmount(debet.getQuantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter()));
					}
					debet.setInsurarAmount(debet.getQuantity()*prestation.getInsurarPrice(insurance, insurance.getInsuranceCategoryLetter()));
					debet.setCreateDateTime(new java.util.Date());
					debet.setDate(new java.util.Date());
					Encounter encounter = Encounter.getLastEncounter(destinationStock.getVirtualInvoicingAccount());
					if(encounter==null || !SH.formatDate(encounter.getBegin()).equalsIgnoreCase(SH.formatDate(new java.util.Date()))){
						System.out.println(5);
						//We must create a new encounter for this linked virtual account
						encounter = new Encounter();
						encounter.setBegin(new java.util.Date());
						encounter.setCreateDateTime(new java.util.Date());
						encounter.setEnd(new java.util.Date());
						encounter.setPatientUID(destinationStock.getVirtualInvoicingAccount());
						encounter.setServiceUID(SH.cs("virtualInvoicingDefaultEncounterServiceUID",prestation.getServiceUid()));
						encounter.setType("visit");
						encounter.setUpdateDateTime(new java.util.Date());
						encounter.setUpdateUser(activeUser.userid);
						encounter.setVersion(1);
						encounter.store();
					}
					debet.setEncounterUid(encounter.getUid());
					if(SH.c(prestation.getServiceUid()).length()>0){
						System.out.println(6);
						debet.setServiceUid(prestation.getServiceUid());
					}
					else{
						System.out.println(7);
						debet.setServiceUid(encounter.getServiceUID());
					}
					debet.setUpdateUser(activeUser.userid);
					debet.setVersion(1);
					debet.store();
				}
			}
		}
		out.println("<script>window.opener.location.reload();window.close();</script>");
		out.flush();
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='source' id='source' value='<%=productStock.getServiceStockUid() %>'/>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web.manage","transferproducts",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"Web","product",sWebLanguage)%>&nbsp;</td>
			<td class='admin2'><b><%=productStock.getProduct().getName() %></b></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"Web","source",sWebLanguage)%>&nbsp;</td>
			<td class='admin2'><%=productStock.getServiceStock().getName() %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"Web","destination",sWebLanguage)%>&nbsp;</td>
			<td class='admin2'>
				<input type='hidden' name='destination' id='destination' value='<%=sDestinationStockUid%>'/>
				<%=ServiceStock.get(sDestinationStockUid).getName() %>
			</td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"Web","orderedquantity",sWebLanguage)%>&nbsp;</td>
			<td class='admin2'><%=sQuantity %></td>
		</tr>
		<tr>
			<td class='admin' nowrap><%=getTran(request,"Web","selectedquantity",sWebLanguage)%>&nbsp;</td>
			<td class='admin2'><span style='font-size: 12px;font-weight: bolder;vertical-align: middle' id='selectedQuantity'>0</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input class='button' type='submit' name='submitButton' id='submitButton' style='display: none;vertical-align: middle' value='<%=getTranNoLink("cnts","transfer",sWebLanguage)%>'/></td>
		</tr>
		<tr>
			<td colspan='2' style='vertical-align: top'>
				<table width='100%'>
					<tr>
					<%
						int nWarningPeriod = SH.ci("bloodbankExpiryWarningPeriodInDays",14);
						Vector<Batch> batches = productStock.getActiveBatches();
						for(int n=0;n<batches.size() && n<40;n++){
							Batch batch = batches.elementAt(n);
							if(n==0){
								out.println("<td width='20%' style='vertical-align: top'><table width=100%'><tr class='admin'><td>#</td><td>"+getTran(request,"web","expiry",sWebLanguage)+"</td><td>"+getTran(request,"web","batchnumber",sWebLanguage)+"</td></tr>");
							}
							else if(n%10==0){
								out.println("</table></td><td width='20%' style='vertical-align: top'><table width=100%'><tr class='admin'><td>#</td><td>"+getTran(request,"web","expiry",sWebLanguage)+"</td><td>"+getTran(request,"web","batchnumber",sWebLanguage)+"</td></tr>");
							}
							String backcolor="white",forecolor="black";
							if(SH.dateDiffInDays(new java.util.Date(), batch.getEnd())<nWarningPeriod){
								backcolor="#"+Integer.toHexString(new Color(255,new Double(100+SH.dateDiffInDays(new java.util.Date(), batch.getEnd())*155/nWarningPeriod).intValue(),new Double(100+SH.dateDiffInDays(new java.util.Date(), batch.getEnd())*155/nWarningPeriod).intValue()).getRGB()).substring(2);
							}
							if(SH.dateDiffInDays(new java.util.Date(), batch.getEnd())*155/nWarningPeriod<30){
								forecolor="white";
							}
							String levelstring="<input class='text' type='checkbox' name='cb."+batch.getUid()+"' value='1' onchange='countSelected()'/>";
							if(batch.getLevel()>1){
								levelstring="<select class='text' name='sb."+batch.getUid()+"' onchange='countSelected()'>";
								for(int i=0;i<=batch.getLevel() && i<500;i++){
									levelstring+="<option value='"+i+"'>"+i+"</option>";
								}
								levelstring+="<select>";
							}
							out.println("<tr style='color: "+forecolor+";background-color: "+backcolor+"'><td width='1%'>"+levelstring+"</td><td height='25px' width='1%'>&nbsp;"+SH.formatDate(batch.getEnd())+"&nbsp;</td><td>&nbsp;<b>"+batch.getBatchNumber()+"</b></td></tr>");
						}
						out.println("</table></td>");
					%>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>

<script>
	function countSelected(){
		var nChecked=0;
		var els = document.getElementsByTagName("*");
		for(n=1;n<els.length;n++){
			if(els[n].name && els[n].name.indexOf('cb.')>-1 && els[n].checked){
				nChecked++;
			}
			else if(els[n].name && els[n].name.indexOf('sb.')>-1 && els[n].value>0){
				nChecked+=els[n].value*1;
			}
		}
		document.getElementById('selectedQuantity').innerHTML=nChecked;
		if(document.getElementById('destination').value.length>0 && nChecked>0){
			document.getElementById('submitButton').style.display='';
		}
		else{
			document.getElementById('submitButton').style.display='none';
		}
		if(nChecked><%=sQuantity%>){
			document.getElementById('submitButton').style.display='none';
		}
		return nChecked;
	}
	
	countSelected();
</script>