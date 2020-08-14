<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	boolean bReceived=false;
	Enumeration params = request.getParameterNames();
	String sComment=checkString(request.getParameter("comment"));
	while(params.hasMoreElements()){
		String param = (String)params.nextElement();
		if(param.startsWith("receive.") && checkString(request.getParameter("check"+param)).equalsIgnoreCase("1")){
			String deliveryOperationUid = param.split("\\.")[1]+"."+param.split("\\.")[2];
			
			ProductStockOperation deliveryOperation = ProductStockOperation.get(deliveryOperationUid);
			if(deliveryOperation!=null && deliveryOperation.getProductStock()!=null && deliveryOperation.getUnitsChanged()-deliveryOperation.getUnitsReceived()>=Integer.parseInt(request.getParameter(param))){
				//Identify destination product stock
				ProductStock productStock = ProductStock.get(deliveryOperation.getProductStock().getProductUid(),request.getParameter("ServiceStockUid"));
				if(productStock == null){
					//does not exist, create one
					productStock = new ProductStock();
					productStock.setUid("-1");
					productStock.setBegin(deliveryOperation.getDate());
					productStock.setLevel(0);
					productStock.setProductUid(deliveryOperation.getProductStock().getProductUid());
					productStock.setServiceStockUid(request.getParameter("ServiceStockUid"));
					productStock.setUpdateDateTime(new java.util.Date());
					productStock.setUpdateUser(activeUser.userid);
					productStock.setVersion(1);
					productStock.setDefaultImportance(MedwanQuery.getInstance().getConfigString("defaultProductStockImportance","type1native"));
					productStock.setSupplierUid(MedwanQuery.getInstance().getConfigString("defaultProductStockSupplierUid",""));
					productStock.store();
				}
				
				//Create receipt operation
				ProductStockOperation receiptOperation = new ProductStockOperation();
				receiptOperation.setUid("-1");
				receiptOperation.setBatchUid(deliveryOperation.getBatchUid());
				receiptOperation.setBatchEnd(deliveryOperation.getBatchEnd());
				receiptOperation.setBatchNumber(deliveryOperation.getBatchNumber());
				receiptOperation.setDate(new java.util.Date());
				receiptOperation.setDescription("medicationreceipt.1");
				receiptOperation.setProductStockUid(productStock.getUid());
				receiptOperation.setSourceDestination(new ObjectReference("servicestock",deliveryOperation.getProductStock().getServiceStockUid()));
				receiptOperation.setUnitsChanged(Integer.parseInt(request.getParameter(param)));
				receiptOperation.setUpdateDateTime(new java.util.Date());
				receiptOperation.setUpdateUser(activeUser.userid);
				receiptOperation.setVersion(1);
				receiptOperation.setOrderUID(deliveryOperation.getOrderUID());
				receiptOperation.setComment(sComment);
				receiptOperation.store();
				
				//Update delivery operation
				deliveryOperation.setUnitsReceived(deliveryOperation.getUnitsReceived()+Integer.parseInt(request.getParameter(param)));
				deliveryOperation.setReceiveProductStockUid(productStock.getUid());
				deliveryOperation.store();
				bReceived=true;
				if(request.getParameter("return")!=null){
					//The received product has to be returned to the sender
					ProductStockOperation returnOperation = new ProductStockOperation();
					returnOperation.setUid("-1");
					returnOperation.setBatchEnd(deliveryOperation.getBatchEnd());
					returnOperation.setBatchNumber(deliveryOperation.getBatchNumber());
					Batch batch = Batch.getByBatchNumber(productStock.getUid(), deliveryOperation.getBatchNumber());
					returnOperation.setBatchUid(batch==null?null:batch.getUid());
					returnOperation.setDate(new java.util.Date());
					returnOperation.setDescription("medicationdelivery.2");
					returnOperation.setProductStockUid(productStock.getUid());
					returnOperation.setSourceDestination(new ObjectReference("servicestock",deliveryOperation.getProductStock().getServiceStockUid()));
					returnOperation.setUnitsChanged(Integer.parseInt(request.getParameter(param)));
					returnOperation.setUpdateDateTime(new java.util.Date());
					returnOperation.setUpdateUser(activeUser.userid);
					returnOperation.setVersion(1);
					returnOperation.setOrderUID(deliveryOperation.getOrderUID());
					returnOperation.setComment(ScreenHelper.getTran("web","refused",sWebLanguage)+": "+sComment);
					returnOperation.store();
				}
			}
		}
	}
%>

<form name='bulkreceiveForm' method='post'>
	<input type='hidden' name='ServiceStockUid' id='ServiceStockUid' values='<%=request.getParameter("ServiceStockUid") %>'/>
	
	<table width="100%" class="list" cellpadding="0" cellspacing="1">
	    <%-- TITLE --%>
	    <tr class="admin">
	       <td colspan="10"><%=getTran(request,"web","bulkReceive",sWebLanguage)%></td>
	    </tr>
	       
	<%
		Vector operations = new Vector();
		ServiceStock serviceStock = ServiceStock.get(checkString(request.getParameter("ServiceStockUid")));
		if(serviceStock!=null){
			operations=ProductStockOperation.getOpenServiceStockDeliveries(request.getParameter("ServiceStockUid"));	    
		}
	    if(operations.size() > 0){
	    	%>
	    		<%-- header --%>
				<tr class='admin'>
					<td>&nbsp;</td>
					<td>ID</td>
					<td><%=getTran(request,"web","date",sWebLanguage)%></td>
					<td><%=getTran(request,"web","source",sWebLanguage)%></td>
					<td><%=getTran(request,"web","product",sWebLanguage)%></td>
					<td><%=getTran(request,"web","sent",sWebLanguage)%></td>
					<td><%=getTran(request,"web","received",sWebLanguage)%></td>
					<td><%=getTran(request,"web","batch",sWebLanguage)%></td>
					<td><%=getTran(request,"web","expires",sWebLanguage)%></td>
					<td><%=getTran(request,"web","remains",sWebLanguage)%></td>
			    </tr>
	    	<%
	    }
	
	    // list operations
		for(int n=0; n<operations.size(); n++){
			ProductStockOperation operation = (ProductStockOperation)operations.elementAt(n);
			String servicename="?",productname="?",comment="";
			if(operation.getProductStock()!=null && operation.getProductStock().getServiceStock()!=null){
				servicename=operation.getProductStock().getServiceStock().getName();
			}
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				productname=operation.getProductStock().getProduct().getName();
			}
			if(checkString(operation.getProductionOrderUid()).length()>0){
				comment+=" ["+getTran(request,"web","PO",sWebLanguage)+" #"+operation.getProductionOrderUid()+"]";
			}
			if(checkString(operation.getComment()).length()>0){
				comment+=" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif' title='"+operation.getComment().replaceAll("'","´").replaceAll("\"", "´")+"'/>";
			}
			
			out.print("<tr class='admin2'>");
			if(activeUser.getAccessRight("bulkreceive.delete")){
				out.print("<td><img src='_img/icons/icon_delete.png' onclick='javascript:doDelete(\""+operation.getUid()+"\");' class='link'/></td>");
			}
			else{
				out.print("<td></td>");
			}
			 out.print("<td>"+operation.getUid()+"</td>");
			 out.print("<td>"+ScreenHelper.formatDate(operation.getDate())+"</td>");
			 out.print("<td>"+servicename+"</td>");
			 out.print("<td>"+productname+comment+"</td>");
			 out.print("<td>"+operation.getUnitsChanged()+"</td>");
			 out.print("<td>"+operation.getUnitsReceived()+"</td>");
			 out.print("<td>"+(operation.getBatchNumber()!=null?operation.getBatchNumber():"")+"</td>");
			 out.print("<td>"+(operation.getBatchEnd()!=null?operation.getBatchEnd():"")+"</td>");
			 out.print("<td><input type='text' class='text' size='5' onchange='if(!validatemax("+(operation.getUnitsChanged()-operation.getUnitsReceived())+",this.value)){this.value=0;document.getElementById(\"checkreceive."+operation.getUid()+"\").checked=false;}' name='receive."+operation.getUid()+"' id='receive."+operation.getUid()+"' value='"+(operation.getUnitsChanged()-operation.getUnitsReceived())+"'><input type='checkbox' name='checkreceive."+operation.getUid()+"' id='checkreceive."+operation.getUid()+"' onclick='if(document.getElementById(\"receive."+operation.getUid()+"\").value==0){this.checked=false}' value='1'/></td>");
			out.print("</tr>");
		}

	    %>
    	    </table>
    	<%
	    
	    if(operations.size() > 0){
	        %>
			<br/>
			<%=getTran(request,"web","comment",sWebLanguage) %>: <textarea class='text' name='comment' id='comment' cols='80' rows='2'></textarea>
	        <br/><br/>
	        <input type="submit" name="submit" class="button" value="<%=getTranNoLink("web","receiveproducts",sWebLanguage)%>"/>
	        <input type="submit" name="return" class="button" value="<%=getTranNoLink("web","returnproducts",sWebLanguage)%>"/>
	        <%
		}
		else{
            %>
		        <label class="text"><%=getTran(request,"web","noRecordsFound",sWebLanguage)%></label>
		    <%if(bReceived){ %>
				<script>window.opener.location.reload();</script>
			<%}
		}
	%>	
</form>

<%=ScreenHelper.alignButtonsStart()%>
    <input type="button" name="closeButton" class="button" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onClick="window.close();"/>
<%=ScreenHelper.alignButtonsStop()%>

<script>
  <%-- VALIDATE MAX --%>
  function validatemax(maxval,thisval){
    if(maxval*1 < thisval*1){
      alertDialogDirectText('<%=getTran(null,"web","value.must.be",sWebLanguage)%> <='+maxval);
      return false;
    }
    else if(thisval*1<0){
        alertDialogDirectText('<%=getTran(null,"web","value.must.be",sWebLanguage)%> >=0');
        return false;
    }
    return true;
  }
	
  <%-- DO DELETE --%>
  function doDelete(operationuid){    
    var url = '<c:url value="/pharmacy/closeProductStockOperation.jsp"/>?operationuid='+operationuid+'&ts='+new Date();
    new Ajax.Request(url,{
	  method: "GET",
      parameters: "", 
      onSuccess: function(resp){
        window.location.reload();
      }
    });
  }
</script>