<%@include file="/includes/validateUser.jsp"%>
<%=sJSTOOLTIP%>
<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='11'><%=getTran(request,"web","mobileMoneyOverview",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class="admin2" style='text-align: right'><%=getTran(request,"web","begin",sWebLanguage) %></td>
			<td class="admin2"><%=SH.writeDateField("begin", "transactionForm", SH.formatDate(SH.getToday()), true, false, sWebLanguage, sCONTEXTPATH) %></td>
			<td class="admin2" style='text-align: right'><%=getTran(request,"web","end",sWebLanguage) %></td>
			<td class="admin2"><%=SH.writeDateField("end", "transactionForm", SH.formatDate(SH.getToday()), true, false, sWebLanguage, sCONTEXTPATH) %></td>
			<td class="admin2" style='text-align: right'><%=getTran(request,"web","operator",sWebLanguage) %></td>
			<td class="admin2">
				<select name='operator' id='operator' class='text'>
					<%=SH.writeSelect(request, "momo.operator", "", sWebLanguage) %>
				</select>
			</td>
			<td class="admin2" style='text-align: right'><%=getTran(request,"web","cashier",sWebLanguage) %></td>
            <td class="admin2">
                <input type="hidden" name="cashier" id="cashier" value="">
                <input class="text" type="text" name="cashiername" id="cashiername" readonly size="30" value="">
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchCashier('cashier','cashiername');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="transactionForm.cashier.value='';transactionForm.cashiername.value='';">
            </td>
            <%if(activePatient!=null){ %>
				<td class="admin2" ><input type='checkbox' class='text' name='activepatient' id='activepatient' value='1' onchange='searchPayments()'/> <b><%=activePatient.getFullName() %></b></td>
			<%}else{ %>
				<input type='hidden' name='activepatient' id='activepatient'/>
			<%} %>
            <td class='admin2'><input type='button' class='button' name='seauchButton' value='<%=getTranNoLink("web","search",sWebLanguage) %>' onclick='searchPayments()'/></td>
            <td class='admin2' width='15px'>&nbsp;</td>
		</tr>
	</table>
	<p/>
	<div id='divPayment' style='overflow-y: scroll'></div>
</form>

<script>
	function searchCashier(managerUidField,managerNameField){
    	openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no");
 	}
	
	function reimbursePayment(transactionid){
	 	var url = "financial/mobilemoney/mobileMoneyDisbursement.jsp&financialtransactionid="+transactionid+"&ts=<%=getTs()%>";
	 	openPopup(url);
	}
	
	function registerMomoDisbursement(cashdesk,message,financialTransactionId){
		if(document.getElementById('img_'+financialTransactionId)) document.getElementById('img_'+financialTransactionId).style.display='none';
		if(document.getElementById('font_'+financialTransactionId)) document.getElementById('font_'+financialTransactionId).style.textDecoration='line-through';
		if(document.getElementById('td_'+financialTransactionId)) document.getElementById('td_'+financialTransactionId).className='red';
	}

	function searchPayments(){
	    document.getElementById('divPayment').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = "begin="+document.getElementById('begin').value
	            	+"&end="+document.getElementById('end').value
   	                +"&operator="+document.getElementById('operator').value
   	                +"&activepatient="+document.getElementById('activepatient').checked
  	                +"&cashier="+document.getElementById('cashier').value;
  	      	    var today = new Date();
  	    var url= '<c:url value="/financial/mobilemoney/getMobileMoneyPayments.jsp"/>?ts='+today;
  		new Ajax.Request(url,{
  		  method: "POST",
  	      parameters: params,
  	      onSuccess: function(resp){
  	    	  document.getElementById('divPayment').innerHTML=resp.responseText;
  	      },
          onError: function(resp){
          	  document.getElementById('divPayment').innerHTML = "ERROR";
          }
  		});
	}
	
	function checkPaymentStatus(transactionId){
		document.getElementById('image_'+transactionId).height=8;
		document.getElementById('image_'+transactionId).src='<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif';
	    var params = "transactionId="+transactionId;
		var today = new Date();
	    var url= '<c:url value="/financial/mobilemoney/getPaymentStatusMTN.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  	method: "POST",
	      	parameters: params,
	      	onSuccess: function(resp){
              	var paymentRequest = eval('('+resp.responseText+')');
           	  	if(paymentRequest.status.length==0 || paymentRequest.status=="SUCCESSFUL" || paymentRequest.status=="FAILED"){
           	  		registerPaymentStatus(transactionId,paymentRequest.status,paymentRequest.financialTransactionId,paymentRequest.telephone);
              	}
           	  	else{
            		document.getElementById('image_'+transactionId).height=16;
              		document.getElementById('image_'+transactionId).src='<%=sCONTEXTPATH %>/_img/icons/icon_reload.png';
           	  	}
	      	},
          	onError: function(resp){
        	  	alert('MTN Status validation error');
        		document.getElementById('image_'+transactionId).height=16;
          		document.getElementById('image_'+transactionId).src='<%=sCONTEXTPATH %>/_img/icons/icon_reload.png';
          	}
		});
	}
	
	function registerPaymentStatus(transactionId,status,financialTransactionId,telephone){
	    var params = "transactionId="+transactionId+"&status="+status+"&financialTransactionId="+financialTransactionId+"&telephone="+telephone;
		var today = new Date();
	    var url= '<c:url value="/financial/mobilemoney/registerPaymentStatusMTN.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  	method: "POST",
	      	parameters: params,
	      	onSuccess: function(resp){
	      		searchPayments();
	      	},
          	onError: function(resp){
        	  	alert('MTN Status registration error');
          	}
		});
	}
	
	function openInvoice(sInvoiceId){
		if(sInvoiceId*1>0){
			openPopup("/financial/patientInvoiceEdit.jsp&ts=<%=getTs()%>&PopupWidth="+(screen.width-200)+"&PopupHeight=600&FindPatientInvoiceUID="+sInvoiceId+"&showpatientname=1");
		}
	}
	
	searchPayments();
</script>