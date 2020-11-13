<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE %>
<%
	String financialTransactionId = SH.c(request.getParameter("financialtransactionid"));
	Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_momo where oc_momo_financialtransactionid=? and oc_momo_amount>0");
	ps.setString(1,financialTransactionId);
	ResultSet rs = ps.executeQuery();
	if(rs.next()){
		String operator = rs.getString("oc_momo_operator");
		String amount = rs.getDouble("oc_momo_amount")+"";
		String currency = rs.getString("oc_momo_currency");
		String invoiceid = rs.getString("oc_momo_invoiceuid");
		String payeephone = rs.getString("oc_momo_payerphone");
		String patientuid = rs.getString("oc_momo_patientuid");
		String useruid = rs.getString("oc_momo_updateuid");
		String origintransactionid = rs.getString("oc_momo_transactionid");
		String payeemessage = "REIMBURSEMENT "+invoiceid;
		String payermessage = rs.getString("oc_momo_payeemessage")+"_REIMBURSEMENT";
		rs.close();
		ps.close();
		conn.close();

		%>
		<table width='100%'>
			<tr class='admin'><td colspan='2'><%=getTran(request,"web","mobilepayment",sWebLanguage)+" - "+operator %></td></tr>
			<% if(operator.equalsIgnoreCase("mtn")){ %>
				<tr>
					<td colspan='2'><img height='75%' src='<%=sCONTEXTPATH%>/_img/themes/default/mtnmomopay.png'/></td>
				</tr>
				<tr>
					<td class='admin' width='90%'><%=getTran(request,"web","amount",sWebLanguage) %></td>
					<td class='admin2'><font style='font-size: 14px; font-weight: bolder'><%=SH.getPriceFormat(Double.parseDouble(amount))+" "+currency %></font></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","invoice",sWebLanguage) %> #</td>
					<td class='admin2'><%=invoiceid %></td>
				</tr>
				<tr>
					<td class='admin'><%=getTran(request,"web","telephone",sWebLanguage) %></td>
					<td class='admin2'><input size='15' type='text' class='text' name='phone' id='phone' value='<%=payeephone %>'/></td>
				</tr>
				<% if(Double.parseDouble(amount)>0){ %>
					<tr>	
						<td><div id='divPayment' name='divPayment'></div></td>
						<td><input type='button' class='button' value='<%=getTranNoLink("web","send",sWebLanguage) %>' name='DisbursePayment' onclick='disbursePaymentMTN()'/></td>
					</tr>
				<% } %>
			<% } %>
		</table>
		
		<script>
			function disbursePaymentMTN(){
			    document.getElementById('divPayment').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
			    var params = "amount=<%=amount%>"
		            +"&currency=<%=currency%>"
		            +"&invoiceid=<%=invoiceid%>"
		            +"&telephone="+document.getElementById("phone").value
		            +"&payermessage=<%=payermessage%>"
		            +"&payeemessage=<%=payeemessage%>"
		            +"&patientuid=<%=patientuid%>"
		            +"&origintransactionid=<%=origintransactionid%>"
		            +"&userid=<%=useruid%>";
			    var today = new Date();
			    var url= '<c:url value="/financial/mobilemoney/disbursePaymentMTN.jsp"/>?ts='+today;
				new Ajax.Request(url,{
				  method: "POST",
			      parameters: params,
			      onSuccess: function(resp){
		              var paymentRequest = eval('('+resp.responseText+')');
		              if(paymentRequest.transactionId.length>0){
		            	  document.getElementById('divPayment').innerHTML = "<b><%=getTran(request,"web","waitingforpayment",sWebLanguage)%></b> #"+paymentRequest.transactionId+"<br/><img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
		            	  checkPaymentMTN(paymentRequest.transactionId);
		              }
		              else{
		            	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","errorsendingpaymentrequest",sWebLanguage)%>";
		              }
			      },
		          onError: function(resp){
		        	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","errorsendingpaymentrequest",sWebLanguage)%>";
		          }
				});
			}
			
			function checkPaymentMTN(transactionId){
			    var params = "transactionId="+transactionId;
				var today = new Date();
			    var url= '<c:url value="/financial/mobilemoney/getDisbursementStatusMTN.jsp"/>?ts='+today;
				new Ajax.Request(url,{
				  method: "POST",
			      parameters: params,
			      onSuccess: function(resp){
		              var paymentRequest = eval('('+resp.responseText+')');
		              if(paymentRequest.status.length>0 && paymentRequest.status=="SUCCESSFUL"){
		            	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_ok.gif"/>'> <%=getTranNoLink("web","paymentsuccessful",sWebLanguage)%>";
		            	  window.opener.registerMomoDisbursement('<%=SH.cs("momo.cashdesk.mtn","")%>','MTN Mobile Money - '+paymentRequest.telephone+' - #'+paymentRequest.financialTransactionId,'<%=financialTransactionId%>');
		            	  window.close();
		              }
		              else if(paymentRequest.status.length>0 && paymentRequest.status=="FAILED"){
		            	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","paymentfailed",sWebLanguage)%>";
		              }
		              else{
		            	  window.setTimeout("checkPaymentMTN('"+paymentRequest.transactionId+"');",500);
		              }
			      },
		          onError: function(resp){
		        	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","nopaymentregistered",sWebLanguage)%>";
		          }
				});
			}
		</script>

	<%
	}
	else{
		rs.close();
		ps.close();
		conn.close();
		out.println("<script>window.close();</script>");
		out.flush();
	}
%>