<%@include file="/includes/validateUser.jsp"%>
<%=sJSPROTOTYPE %>
<%
	String operator = SH.c(request.getParameter("operator"),"MTN");
	String amount = "0";
	try{
		amount=Double.parseDouble(request.getParameter("amount"))+"";
	}
	catch(Exception e){
		e.printStackTrace();
	}
	String currency = SH.c(request.getParameter("currency"),"RWF");
	String invoiceid = SH.c(request.getParameter("invoiceid"));
	if(invoiceid.length()==0){
		invoiceid="AP"+MedwanQuery.getInstance().getOpenclinicCounter("AdvancePayments");
	}
	if(invoiceid.split("\\.").length>1){
		invoiceid=invoiceid.split("\\.")[1];
	}
	String payerphone = activePatient.getActivePrivate().telephone.replaceAll(" ", "").replaceAll("\\.", "").replaceAll("\\-", "").replaceAll("\\(","").replaceAll("\\)", "").replaceAll("/", "").replaceAll("\\+", "");
	String payermessage = SH.cs("momo.payermessageprefix","Hospital invoice ")+invoiceid;
	String payeemessage = activePatient.personid+"_"+activePatient.getFullName()+"_"+activeUser.userid+"_"+invoiceid;
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
			<td class='admin2'><input size='15' type='text' class='text' name='phone' id='phone' value='<%=payerphone %>'/></td>
		</tr>
		<% if(Double.parseDouble(amount)>0){ %>
			<tr>	
				<td><div id='divPayment' name='divPayment'></div></td>
				<td><input type='button' class='button' value='<%=getTranNoLink("web","send",sWebLanguage) %>' name='requestPayment' onclick='requestPaymentMTN()'/></td>
			</tr>
		<% } %>
	<% } %>
</table>

<script>
	function requestPaymentMTN(){
	    document.getElementById('divPayment').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = "amount=<%=amount%>"
            +"&currency=<%=currency%>"
            +"&invoiceid=<%=invoiceid%>"
            +"&telephone="+document.getElementById("phone").value
            +"&payermessage=<%=payermessage%>"
            +"&payeemessage=<%=payeemessage%>"
            +"&patientuid=<%=activePatient.personid%>"
            +"&userid=<%=activeUser.userid%>";
	    var today = new Date();
	    var url= '<c:url value="/financial/mobilemoney/requestPaymentMTN.jsp"/>?ts='+today;
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
	    var url= '<c:url value="/financial/mobilemoney/getPaymentStatusMTN.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
              var paymentRequest = eval('('+resp.responseText+')');
              if(paymentRequest.status.length>0 && paymentRequest.status=="SUCCESSFUL"){
            	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_ok.gif"/>'> <%=getTranNoLink("web","paymentsuccessful",sWebLanguage)%>";
            	  window.opener.registerMomoPayment('<%=SH.cs("momo.cashdesk.mtn","")%>','MTN Mobile Money - '+paymentRequest.telephone+" - #"+paymentRequest.financialTransactionId,paymentRequest.financialTransactionId);
            	  window.close();
              }
              else if(paymentRequest.status.length>0 && paymentRequest.status=="FAILED"){
            	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","paymentfailed",sWebLanguage)%>";
              }
              else{
            	  window.setTimeout("checkPaymentMTN('"+transactionId+"');",500);
              }
	      },
          onError: function(resp){
        	  document.getElementById('divPayment').innerHTML = "<img height='14px' src='<c:url value="/_img/icons/icon_error.gif"/>'> <%=getTranNoLink("web","nopaymentregistered",sWebLanguage)%>";
          }
		});
	}
</script>