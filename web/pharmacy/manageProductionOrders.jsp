<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.manageproductionorders","all",activeUser)%>
<%
	boolean bActivePatientOnly = activePatient!=null && checkString(request.getParameter("EditActivePatientOnly")).equalsIgnoreCase("1");
	boolean bOpenOrdersOnly = checkString(request.getParameter("EditOpenOrdersOnly")).equalsIgnoreCase("1");
	boolean bAutoFind = bActivePatientOnly && checkString(request.getParameter("autofind")).equalsIgnoreCase("1");
	String sProductStockUid = checkString(request.getParameter("EditProductStockUid"));
	String sProductionOrderUid = checkString(request.getParameter("EditProductionOrderId"));
	String sProductionOrderTechnician = checkString(request.getParameter("EditProductionOrderTechnician"));
	String sMinDate = checkString(request.getParameter("EditMinDate"));
	String sMaxDate = checkString(request.getParameter("EditMaxDate"));
	String sAction = checkString(request.getParameter("action"));
	String sServiceStockUid=checkString(request.getParameter("servicestock"));
	java.util.Date mindate=null,maxdate=null;
	try{
		mindate = ScreenHelper.parseDate(sMinDate);
	}
	catch(Exception e){}
	try{
		maxdate = ScreenHelper.parseDate(sMaxDate);
	}
	catch(Exception e){}
	
	if(sAction.equalsIgnoreCase("create")){
		ProductionOrder newOrder = new ProductionOrder();
		newOrder.setCreateDateTime(new java.util.Date());
		newOrder.setTargetProductStockUid(checkString(request.getParameter("NewProductStockUid")));
		newOrder.setUpdateDateTime(new java.util.Date());
		newOrder.setUpdateUid(Integer.parseInt(activeUser.userid));
		newOrder.store();
		out.println("<script>window.setTimeout('openProductionOrder("+newOrder.getId()+")',500);</script>");
	}
%>
<form name='transactionForm' method='post' action="<c:url value="main.do?Page=pharmacy/manageProductionOrders.jsp"/>">
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","manageproductionorders",sWebLanguage) %></td>
		</tr>
		<%if(activePatient!=null){ %>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"web","activepatientonly",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='checkbox' value ='1' name='EditActivePatientOnly' id='EditActivePatientOnly' <%=bActivePatientOnly?"checked":"" %> onclick="transactionForm.EditProductionOrderId.value='';"/></td>
		</tr>
		<%} %>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"web","openordersonly",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='checkbox' value ='1' name='EditOpenOrdersOnly' id='EditOpenOrdersOnly' <%=bOpenOrdersOnly?"checked":"" %> onclick="transactionForm.EditProductionOrderId.value='';"/></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","productionorderid",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='text' name='EditProductionOrderId' id='EditProductionOrderId' value='<%=sProductionOrderUid%>'  onblur="if(this.value.length>0){transactionForm.EditProductStockUid.value='';transactionForm.EditProductStockName.value='';transactionForm.EditMinDate.value='';transactionForm.EditMaxDate.value='';transactionForm.EditActivePatientOnly.checked=false;}"/></td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","finishedgoodsstock",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'>
				<select class='text' name='servicestock' id='servicestock' onchange='setDefaultPharmacy();'>
					<option/>
					<%
						//Add all servicestocks where the user has access to
                        String defaultPharmacy = (String)session.getAttribute("defaultPharmacy");
                        Vector servicestocks = ServiceStock.getStocksByUser(activeUser.userid);
                        String main="";
                    	if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){
                    		main=MedwanQuery.getInstance().getConfigString("mainProductionWarehouseUID","");;
                    	}
                        
                        ServiceStock serviceStock;
                        for(int n=0; n<servicestocks.size(); n++){
                        	serviceStock = (ServiceStock)servicestocks.elementAt(n);
                        	if(main.length()>0 && main.equalsIgnoreCase(serviceStock.getUid())){
                        		continue;
                        	}
                            out.print("<option value='"+serviceStock.getUid()+"' "+(serviceStock.getUid().equals(defaultPharmacy)?"selected":"")+">"+serviceStock.getName().toUpperCase()+"</option>");
                        }
                    %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","finishedgood",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><input type='hidden' name='EditProductStockUid' id='EditProductStockUid' value='<%=sProductStockUid%>'  onchange="transactionForm.EditProductionOrderId.value='';"/>
			<%
				String sProductStockName="";
				if(sProductStockUid.length()>0){
					ProductStock productStock=ProductStock.get(sProductStockUid);
					if(productStock!=null && productStock.getProduct()!=null){
						sProductStockName=productStock.getProduct().getName();
					}
				}
			%>
	        <input type="text" size="80" class="text" name="EditProductStockName" id="EditProductStockName" value="<%=sProductStockName%>"/>
	        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditProductStockUid','EditProductStockName');">
	        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditProductStockUid.value='';transactionForm.EditProductStockName.value='';">
	        </td>
		</tr>
		<tr>
			<td class='admin' width='1%' nowrap><%=getTran(request,"web","technician",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'>
				<select class='text' name='EditProductionOrderTechnician' id='EditProductionOrderTechnician'/>
					<option/>
					<%=ScreenHelper.writeSelect(request,"productiontechnician", sProductionOrderTechnician, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"web","begindate",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><%=ScreenHelper.writeDateField("EditMinDate", "transactionForm", "", true, false, sWebLanguage, sCONTEXTPATH,"transactionForm.EditProductionOrderId.value=\"\"") %></td>
		</tr>
		<tr>
			<td class='admin' width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"web","begindate",sWebLanguage) %>&nbsp;</td>
			<td class='admin2'><%=ScreenHelper.writeDateField("EditMaxDate", "transactionForm", "", true, false, sWebLanguage, sCONTEXTPATH,"transactionForm.EditProductionOrderId.value=\"\"") %></td>
		</tr>
		<tr>
			<td>
				<input type='button' class='button' name='find' id='find' onclick='document.getElementById("action").value="find";transactionForm.submit()' value='<%=getTran(null,"web","find",sWebLanguage)%>'/>
				<input type='button' class='button' name='new' id='new' onclick='document.getElementById("action").value="new";transactionForm.submit()' value='<%=getTran(null,"web","new",sWebLanguage)%>'/>
			</td>
		</tr>
	</table>
	
<%
	if(sAction.equalsIgnoreCase("find") || bAutoFind){
		if(sProductionOrderUid.length()>0){
			ProductionOrder order = ProductionOrder.get(Integer.parseInt(sProductionOrderUid));
			if(order!=null){
				ProductStock stock = order.getProductStock();
				if(stock!=null){
					%>
					<table width="100%">
						<tr class='admin'>
							<td><%=getTran(request,"web","id",sWebLanguage) %></td>
							<td><%=getTran(request,"web","date",sWebLanguage) %></td>
							<td><%=getTran(request,"web","patient",sWebLanguage) %></td>
							<td><%=getTran(request,"web","productstock",sWebLanguage) %></td>
							<td><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
							<td><%=getTran(request,"web","quantity",sWebLanguage) %></td>
							<td><%=getTran(request,"web","productionclosed",sWebLanguage) %></td>
							<td><%=getTran(request,"web","comment",sWebLanguage) %></td>
						</tr>
						<tr>
							<td class='admin'><%=order.getId() %></td>
							<td class='admin2'><a href='javascript:openProductionOrder("<%=order.getId() %>");'><%=ScreenHelper.formatDate(order.getCreateDateTime()) %></a></td>
							<td class='admin2'><%=AdminPerson.getFullName(""+order.getPatientUid()) %></td>
							<td class='admin2'><%=stock.getProduct().getName() %></td>
							<td class='admin2'><%=stock.getServiceStock().getName() %></td>
							<td class='admin2'><%=order.getQuantity() %></td>
							<td class='admin2'><%=ScreenHelper.formatDate(order.getCloseDateTime())%></td>
							<td class='admin2'><%=checkString(order.getComment()) %></td>
						</tr>
					<%
				}
			}
		}
		else{
			Vector productionOrders =  null;
			if(bOpenOrdersOnly){
				productionOrders=ProductionOrder.getOpenProductionOrders(bActivePatientOnly?activePatient.personid:null, sProductStockUid,null, mindate, maxdate);
			}
			else{
				productionOrders=ProductionOrder.getProductionOrders(bActivePatientOnly?activePatient.personid:null, sProductStockUid,null, mindate, maxdate);
			}
			boolean bHasContent =productionOrders.size()>0;
			if(sServiceStockUid.length()>0){
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder order = (ProductionOrder)productionOrders.elementAt(n);
					if(sProductionOrderTechnician.length()==0 || sProductionOrderTechnician.equalsIgnoreCase(order.getTechnician())){
						if(order.getProductStock()!=null && order.getProductStock().getServiceStockUid()!=null && order.getProductStock().getServiceStockUid().equalsIgnoreCase(sServiceStockUid)){
							bHasContent=true;
							break;
						}
					}
				}
			}
			if(bHasContent){
				%>
				<table width="100%">
					<tr class='admin'>
						<td><%=getTran(request,"web","id",sWebLanguage) %></td>
						<td><%=getTran(request,"web","date",sWebLanguage) %></td>
						<td><%=getTran(request,"web","patient",sWebLanguage) %></td>
						<td><%=getTran(request,"web","productstock",sWebLanguage) %></td>
						<td><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
						<td><%=getTran(request,"web","quantity",sWebLanguage) %></td>
						<td><%=getTran(request,"web","productionclosed",sWebLanguage) %></td>
						<td><%=getTran(request,"web","comment",sWebLanguage) %></td>
					</tr>
				<%
				int counter=0;
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder order = (ProductionOrder)productionOrders.elementAt(n);
					if(sProductionOrderTechnician.length()>0 && !sProductionOrderTechnician.equalsIgnoreCase(order.getTechnician())){
						continue;
					}
					if(order.getProductStock()==null || order.getProductStock().getServiceStockUid()==null || (sServiceStockUid.length()>0 && !order.getProductStock().getServiceStockUid().equalsIgnoreCase(sServiceStockUid))){
						continue;	
					}
					counter++;
					ProductStock stock = order.getProductStock();
					%>
					<tr>
						<td class='admin'><%=order.getId() %></td>
						<td class='admin2'><a href='javascript:openProductionOrder("<%=order.getId() %>");'><%=ScreenHelper.formatDate(order.getCreateDateTime()) %></a></td>
						<td class='admin2'><%=AdminPerson.getFullName(""+order.getPatientUid()) %></td>
						<td class='admin2'><%=stock==null||stock.getProduct()==null?"":stock.getProduct().getName() %></td>
						<td class='admin2'><%=stock==null||stock.getServiceStock()==null?"":stock.getServiceStock().getName() %></td>
						<td class='admin2'><%=order.getQuantity() %></td>
						<td class='admin2'><%=ScreenHelper.formatDate(order.getCloseDateTime())%></td>
						<td class='admin2'><%=checkString(order.getComment()) %></td>
					</tr>
					<%
					if(counter>MedwanQuery.getInstance().getConfigInt("MaximumProductionOrdersOnScreen",500)){
						%>
						<tr>
							<td colspan="7">><%=MedwanQuery.getInstance().getConfigInt("MaximumProductionOrdersOnScreen",500)+" "+getTran(request,"web","recordsfound",sWebLanguage)%></td>
						</tr>
						<%
						break;
					}
				}
				%>
				</table>
				<%
			}
		}
	}
	else if(sAction.equals("new")){
		%>
		<table width="100%">
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web.manage","newproductionorder",sWebLanguage) %></td>
		</tr>
			<tr>
				<td class='admin' width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionof",sWebLanguage) %></td>
				<td class='admin2'>
					<input type='hidden' name='NewProductStockUid' id='NewProductStockUid'/>
					<input type='text' class='text' size='80' name='NewProductStockName' id='NewProductStockName'/>
			        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('NewProductStockUid','NewProductStockName');">
			        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.NewProductStockUid.value='';transactionForm.NewProductStockName.value='';">
				</td>
			</tr>
			<tr>
				<td>
					<input type='button' class='button' name='create' id='create' onclick='document.getElementById("action").value="create";transactionForm.submit()' value='<%=getTran(null,"web","save",sWebLanguage)%>'/>
				</td>
			</tr>
		</table>
		<%
	}
%>
</form>

<script>
	function openProductionOrder(uid){
		window.location.href="<c:url value="main.do?Page=pharmacy/manageProductionOrder.jsp"/>&productionOrderUid="+uid;
	}
	
	function searchProductStock(productStockUidField,productStockNameField){
    	openPopup("/_common/search/searchProductStock2.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField);
  	}
	function setDefaultPharmacy(){
		  var url = '<c:url value="/pharmacy/setDefaultPharmacy.jsp"/>?serviceStockUid='+document.getElementById("servicestock").value+'&ts='+new Date();
		  new Ajax.Request(url,{
		    method: "GET",
		    parameters: "",
		    onSuccess: function(resp){
		    }
		  });
		}

	document.getElementById("EditProductionOrderId").onblur();
</script>