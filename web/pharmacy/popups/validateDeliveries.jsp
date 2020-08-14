<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	boolean bModified=false;
	String sServiceStock = checkString(request.getParameter("DestinationServiceStock"));

	if(checkString(request.getParameter("actionValue")).equalsIgnoreCase("validate")){
		Hashtable documents = new Hashtable();
		Enumeration parameters = request.getParameterNames();
		while(parameters.hasMoreElements()){
			String parameter = (String)parameters.nextElement();
			if(parameter.startsWith("cbValidate.")){
				String operationid=parameter.replaceAll("cbValidate\\.", "");
				ProductStockOperation operation = ProductStockOperation.get(operationid);
				if(operation!=null){
					OperationDocument document = (OperationDocument)documents.get(operation.getSourceDestination().getObjectUid());
					if(document==null){
						//we first generate a unique validation document 
						if(MedwanQuery.getInstance().getConfigInt("generateProductStockOperationDocumentOnOutgoingValidation",0)==1){
							document=new OperationDocument();
							document.setCreateDateTime(new java.util.Date());
							document.setDate(new java.util.Date());
							document.setDestinationuid(operation.getSourceDestination().getObjectUid());
							document.setSourceuid(request.getParameter("ServiceStockUid"));
							document.setType("1");
							document.setUpdateDateTime(new java.util.Date());
							document.setUpdateUser(activeUser.userid);
							document.setVersion(1);
							document.setReference("#LOCK#");
							document.store();
							documents.put(operation.getSourceDestination().getObjectUid(),document);
						}
					}
					operation.setValidated(1);
					if(document!=null){
						//Attach the operation to the validation document
						operation.setDocumentUID(document.getUid());
					}
					operation.store();
					bModified=true;
				}
			}
		}
	}
	else if(checkString(request.getParameter("actionValue")).equalsIgnoreCase("delete")){
		Enumeration parameters = request.getParameterNames();
		while(parameters.hasMoreElements()){
			String parameter = (String)parameters.nextElement();
			if(parameter.startsWith("cbValidate.")){
				String operationid=parameter.replaceAll("cbValidate\\.", "");
				ProductStockOperation operation = ProductStockOperation.get(operationid);
				ProductStock stock = operation.getProductStock();
				if(stock!=null){
					stock.setLevel(stock.getLevel()+operation.getUnitsChanged());
					stock.store();
				}
				operation.setComment("canceled "+operation.getUnitsChanged()+" units");
				operation.setUnitsChanged(0);
				operation.setUnitsReceived(0);
				operation.store();
				bModified=true;
			}
		}
	}
	
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='actionValue' id='actionValue'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='8'><%=getTran(request,"web","deliveriestovalidate",sWebLanguage) %></td>
		</tr>
		<tr class='admin'>
			<td colspan='8'>
				<select class='text' name='DestinationServiceStock' id='DestinationServiceStock' onchange='transactionForm.submit()'>
					<option/>
					<%
						//First get all unvalidated deliveries
						Vector unvalidatedOperations = ProductStockOperation.getUnvalidatedServiceStockDeliveries(request.getParameter("ServiceStockUid"),activeUser.userid);
						HashSet stocks = new HashSet();
						for(int n=0;n<unvalidatedOperations.size();n++){
							ProductStockOperation operation = (ProductStockOperation)unvalidatedOperations.elementAt(n);
							stocks.add(operation.getSourceDestination().getObjectUid());
						}
						Vector serviceStocks = ServiceStock.getStocksByValidationUserWithEmpty(activeUser.userid);
						for(int n=0;n<serviceStocks.size();n++){
							ServiceStock serviceStock = (ServiceStock)serviceStocks.elementAt(n);
							if(stocks.contains(serviceStock.getUid()) && !serviceStock.getUid().equalsIgnoreCase(request.getParameter("ServiceStockUid"))){
								out.println("<option "+(serviceStock.getUid().equalsIgnoreCase(sServiceStock)?"selected":"")+" value='"+serviceStock.getUid()+"'>"+serviceStock.getName()+"</option>");
								stocks.remove(serviceStock.getUid());
							}
						}
					%>
				</select>
			</td>
		</tr>
		<tr class='admin'>
			<td>&nbsp;</td>
			<td>ID</td>
			<td><%=getTran(request,"web","date",sWebLanguage)%></td>
			<td><%=getTran(request,"web","product",sWebLanguage)%></td>
			<td><%=getTran(request,"web","destination",sWebLanguage)%></td>
			<td><%=getTran(request,"web","send",sWebLanguage)%></td>
			<td><%=getTran(request,"web","remaining",sWebLanguage)%></td>
			<td><a href='javascript:toggleValidates()'><%=getTran(request,"web","select",sWebLanguage)%></a></td>
	    </tr>
		<%
			for(int n=0;n<unvalidatedOperations.size();n++){
				String comment="";
				ProductStockOperation operation = (ProductStockOperation)unvalidatedOperations.elementAt(n);
				if(operation.getSourceDestination().getObjectUid().startsWith(sServiceStock)){
					if(checkString(operation.getComment()).length()>0){
						comment="<img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif' title='"+operation.getComment().replaceAll("'","´").replaceAll("\"", "´")+"'/>";
					}
					%>
					<tr>
						<td class='admin2'>&nbsp;</td>
						<td class='admin2'><%=operation.getUid() %></td>
						<td class='admin2'><%=ScreenHelper.formatDate(operation.getDate())%></td>
						<td class='admin2'><%=operation.getProductStock().getProduct().getName()+comment%></td>
						<td class='admin2'><%=operation.getSourceDestinationName()%></td>
						<td class='admin2'><%=operation.getUnitsChanged()%></td>
						<td class='admin2'><%=operation.getProductStock().getLevel()%></td>
						<td class='admin2'><input class='text' type='checkbox' name='cbValidate.<%=operation.getUid() %>' value='1'/></td>
				    </tr>
					<%
				}					
			}
		%>
	</table>
	<input class='button' type='button' name='validate' onclick='doValidate()' value='<%=getTran(request,"web","validate",sWebLanguage) %>'/>
	<input class='button' type='button' name='delete' onclick='doDelete()' value='<%=getTran(request,"web","delete",sWebLanguage) %>'/>
    <input type="button" name="closeButton" class="button" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onClick="window.close();"/>
</form>

<script>
	function doValidate(){
		document.getElementById('actionValue').value='validate';
		transactionForm.submit();
	}
	function doDelete(){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
			document.getElementById('actionValue').value='delete';
			transactionForm.submit();
		}
	}
	function toggleValidates(){
		var elements = document.getElementsByTagName("*");
		for(n=0;n<elements.length;n++){
			if(elements[n].name && elements[n].name.indexOf('cbValidate')>-1){
				elements[n].checked=!elements[n].checked;
			}
		}
	}
	
    <%if(bModified){ %>
		window.opener.location.reload();
	<%}%>

</script>