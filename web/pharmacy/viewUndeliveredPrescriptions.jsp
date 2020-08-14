<%@page import="be.openclinic.pharmacy.*,
                be.openclinic.medical.*,
                be.openclinic.common.KeyValue"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp" %>
<%
	String sServiceStockUid = checkString(request.getParameter("FindServiceStockUid"));
	ServiceStock serviceStock = ServiceStock.get(sServiceStockUid);
	long day = 24*3600*1000;
	long prescriptionvalidity=MedwanQuery.getInstance().getConfigInt("activePrescriptionValidityPeriodInDays",30);
	java.util.Date dStart = new java.util.Date(new java.util.Date().getTime()-prescriptionvalidity*day);
	Vector undeliveredPrescriptions = Prescription.findUndelivered(activePatient.personid, ScreenHelper.formatDate(dStart));
%>
<form name="transactionForm" method="post">
	<input type='hidden' name='serviceStockUid' value='<%=sServiceStockUid%>'/>
	<table width='100%'>
		<tr class='admin'>
			<td><%=getTran(request,"Web","product",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","begindate",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","enddate",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","authorizedreceiver",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","prescriber",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","quantity",sWebLanguage)%></td>
			<td><%=getTran(request,"Web","tobedelivered.quantity",sWebLanguage)%></td>
			<td/>
		</tr>
	<%
		if(undeliveredPrescriptions.size()==0){
	%>
		<tr><td colspan='8'><%=getTran(request,"pharmacy","noundeliveredprescriptions",sWebLanguage) %></td></tr>
	<%			
			if(checkString(request.getParameter("undeliveredPrescriptions")).equalsIgnoreCase("reload")){
				out.println("<script>window.opener.location.reload();</script>");
			}
		}
		else {
			for (int n=0;n<undeliveredPrescriptions.size();n++){
				Prescription prescription = (Prescription)undeliveredPrescriptions.elementAt(n);
				if(prescription.getProduct()!=null){
					double nDeliveredQuantity=prescription.getDeliveredQuantity();
					%>
					<tr>
						<td class='admin'><%=prescription.getProduct().getName() %></td>
						<td class='admin2'><%=prescription.getBegin()==null?"?":ScreenHelper.formatDate(prescription.getBegin()) %></td>
						<td class='admin2'><%=prescription.getEnd()==null?"?":ScreenHelper.formatDate(prescription.getEnd()) %></td>
						<td class='admin2'><%=ScreenHelper.checkString(prescription.getAuthorization()) %></td>
						<td class='admin2'><%=ScreenHelper.checkString(User.getFullUserName(prescription.getPrescriberUid())) %></td>
						<td class='admin2'><%=prescription.getRequiredPackages() %></td>
						<td class='admin2'><%=prescription.getRequiredPackages()-nDeliveredQuantity %></td>
						<%
							ProductStock productStock=serviceStock.getProductStock(prescription.getProductUid());
							if(productStock!=null && productStock.getLevel()>0){
						%>
								<td class='admin2'><input type='button' class='button' value='<%=getTran(null,"Web.manage","changeLevel.out",sWebLanguage) %>' 
								onclick='deliverProduct("<%=productStock.getUid()%>","<%=productStock.getProduct().getName()%>","<%=prescription.getUid()%>")'/></td>
						<%
							}
							else{
						%>
								<td class='admin2'><img src='<c:url value="_img/icons/icon_error.gif"/>' title='<%=getTranNoLink("web","productnotavailableinthisstock",sWebLanguage)%>'/></td>
						<%
							}
						%>
					</tr>
					<%
				}
			}
		}
	%>
	</table>
	<input type='hidden' name='undeliveredPrescriptions' id='undeliveredPrescriptions'/>
</form>

<script>
	function deliverProduct(productStockUid,productName,prescriptionUid){
	    openPopup("pharmacy/medication/popups/deliverMedicationPopup.jsp&EditProductStockUid="+productStockUid+"&EditProductName="+encodeURIComponent(productName)+"&EditPrescriptionUid="+prescriptionUid+"&ts=<%=getTs()%>",750,400);
	}
</script>