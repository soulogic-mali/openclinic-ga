<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","payment",sWebLanguage) %></td></tr>
	<tr>
		<td class='admin' width='20%'><%=getTran(request,"web","amount",sWebLanguage) %></td>
		<td class='admin2'><input type='hidden' name='amount' id='amount'/><span style='font-size: 12px;color: red; font-weight: bolder' id='amounttext'>0.00</span> <font style='font-size: 12px;color: red; font-weight: bolder'><%=SH.cs("currency","EUR") %></font></td>
	</tr>
	<%
		String wicketuid=activeUser.getParameter("defaultwicket");
	    if(wicketuid.length()==0){
	    	wicketuid = checkString((String)session.getAttribute("defaultwicket"));
	    }

        Vector userWickets = Wicket.getWicketsForUser(activeUser.userid);
        if(userWickets.size() > 0){
            %>
                <tr>
                    <td class="admin"><%=getTran(request,"wicket","wicket",sWebLanguage)%> *</td>
                    <td class="admin2">
                        <select class="text" id="wicketuid" name="wicketuid">
                            <option value="" selected><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                            <%
                                Iterator iter = userWickets.iterator();
                                Wicket wicket;

                                while(iter.hasNext()){
                                    wicket = (Wicket)iter.next();

                                    %>
                                      <option value="<%=wicket.getUid()%>" <%=wicketuid.equals(wicket.getUid())?" selected":""%>>
                                          <%=wicket.getUid()%>&nbsp;<%=getTranNoLink("service",wicket.getServiceUID(),sWebLanguage)%>
                                      </option>
                                    <%
                                }
                            %>
                        </select>
                    </td>
                </tr>
            <%
        }
        else{
            %><input type="hidden" name="EditCreditWicketUid"/><%
        }
        if(SH.ci("enableCompactPaymentReference",1)==1){
    %>
		    <tr>
			    <td class="admin"><%=getTran(request,"web.finance","otherreference",sWebLanguage)%> <%=SH.ci("patientInvoiceReferenceMandatory",0)==1?"*":"" %></td>
			    <td class="admin2">
			    	<input type='text' class='text' size='50' name='reference' id='reference' onkeyup='checkReference()'/>
			    	<img id='referencewarning' style='display: none;vertical-align: middle' height='16px' src='<%=sCONTEXTPATH %>/_img/icons/icon_blinkwarning.gif' title='<%=getTranNoLink("web","referencealreadyused",sWebLanguage)%>'/>
			    </td>
		    </tr>
    <%
        }
    %>
    <tr>
    	<td colspan='2'>
    		<table width='100%' id='encounterdiv'></table>
    	</td>
    </tr>
	<tr id='payment_tr'>
		<td colspan='2'><center><input type='button' class='button' name='paymentButton' id='paymentButton' value='<%=getTranNoLink("web","paymentreceived",sWebLanguage) %>' onclick='doPayment();'/></center></td>
	</tr>
	<tr id='print_tr' style='display: none'>
		<td colspan='2'><center>
			<input type='button' class='redbutton' name='printButton' id='printButton' value='<%=getTranNoLink("web","print",sWebLanguage)+" "+getTranNoLink("web","receipt",sWebLanguage).toLowerCase() %>' onclick='doPrintReceipt();'/>
			<input type='button' class='redbutton' name='printInvoiceButton' id='printInvoiceButton' value='<%=getTranNoLink("web","print",sWebLanguage)+" "+getTranNoLink("web","invoice",sWebLanguage).toLowerCase() %>' onclick='doPrintInvoice();'/>
			<input type='button' class='button' name='newButton' id='newButton' value='<%=getTranNoLink("web","new",sWebLanguage) %>' onclick='window.location.reload();'/>
		</center></td>
	</tr>
</table>
<input type='hidden' id='invoiceuid' name='invoiceuid'/>
<script>
	function searchService(serviceUidField,serviceNameField){
    	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarSelectDefaultStay=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    	document.getElementById(serviceNameField).focus();
  	}
	
	function doPayment(){
		if(	document.getElementById("prestationlist").innerHTML.length<40 ||
			document.getElementById("wicketuid").value.length==0||
			<% if(SH.ci("patientInvoiceReferenceMandatory",0)==1){%>
				document.getElementById("reference").value.length==0||
			<% }%>
			document.getElementById("EditEncounterService").value.length==0||
			document.getElementById("EditEncounterType").value.length==0||
			document.getElementById("EditEncounterOrigin").value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
		}
		else{
			document.getElementById("paymentButton").disabled= true;
		    var params = 	"prestations="+prestationlist+
		    				"&wicketuid="+document.getElementById('wicketuid').value+
		    				"&amount="+document.getElementById('amount').value+
		    				"&encounteruid="+document.getElementById('encounteruid').value+
		    				"&encounterserviceuid="+document.getElementById('EditEncounterService').value+
		    				"&encountermanager="+document.getElementById('EditEncounterManager').value+
		    				"&encountertype="+document.getElementById('EditEncounterType').value+
		    				"&reference="+document.getElementById('reference').value+
		    				"&encounterorigin="+document.getElementById('EditEncounterOrigin').value
		    				;
		    var url= '<c:url value="/curative/ajax/storeDebets.jsp"/>?ts='+new Date();
		    new Ajax.Request(url,{
			  method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  //Redirect to medical summary
		    	  loadEncounter();
		    	  var label = eval('('+resp.responseText+')');
		    	  document.getElementById('invoiceuid').value=label.invoiceuid;
		    	  document.getElementById('payment_tr').style.display='none';
		    	  document.getElementById('print_tr').style.display='';
		    	  document.getElementById('printButton').value=document.getElementById('printButton').value+" "+label.invoiceuid.replace('1.','');
		    	  document.getElementById('printInvoiceButton').value=document.getElementById('printInvoiceButton').value+" "+label.invoiceuid.replace('1.','');
		      },
			  onFailure: function(){
			    alert('error');
		      }
		    });
		}
	}

	function doPrintReceipt(){
        var url = "<c:url value='/financial/createPatientInvoiceReceiptPdf.jsp'/>?InvoiceUid="+document.getElementById('invoiceuid').value+"&ts=<%=getTs()%>&PrintLanguage=<%=sWebLanguage%>";
        window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
	}
	
    function doPrintInvoice(){
        var url = "<c:url value='/financial/createPatientInvoicePdf.jsp'/>?Proforma=no&InvoiceUid="+document.getElementById('invoiceuid').value+"&ts=<%=getTs()%>&PrintLanguage=<%=sWebLanguage%>";
        window.open(url,"PatientInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
    }

    <%-- SEARCH MANAGER --%>
    function searchManager(managerUidField,managerNameField){
      openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID="+document.getElementById("EditEncounterService").value+"&FindServiceName="+document.getElementById("EditEncounterServiceName").value);
      EditEncounterForm.EditEncounterManagerName.focus();
    }
    
    function closeEncounter(){
	    var url= '<c:url value="/curative/ajax/closeEncounter.jsp"/>?ts='+new Date();
	    var params = 'encounteruid='+document.getElementById('encounteruid').value;
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  if((resp.responseText).indexOf('<CLOSED>')>-1){
	    		  loadEncounter();
	    	  }
	      },
		  onFailure: function(){
		    alert('error');
	      }
	    });
    }
    function checkReference(){
	    var url= '<c:url value="/curative/ajax/checkReference.jsp"/>?ts='+new Date();
	    var params = 'reference='+document.getElementById('reference').value;
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  if((resp.responseText).indexOf('<EXISTS>')>-1){
	    		  document.getElementById('paymentButton').style.display='none';
	    		  document.getElementById('reference').style.color='white';
	    		  document.getElementById('reference').style.backgroundColor='red';
	    		  document.getElementById('referencewarning').style.display='';
	    	  }
	    	  else{
	    		  document.getElementById('paymentButton').style.display='';
	    		  document.getElementById('reference').style.color='black';
	    		  document.getElementById('reference').style.backgroundColor='white';
	    		  document.getElementById('referencewarning').style.display='none';
	    	  }
	      },
		  onFailure: function(){
		    alert('error');
	      }
	    });
    }
    function loadEncounter(){
	    var url= '<c:url value="/curative/ajax/loadCompactEncounter.jsp"/>?ts='+new Date();
	    var params = '';
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  document.getElementById("encounterdiv").innerHTML=resp.responseText;
      	      setMyAutoCompleter();
      	      checkEncounterType();
	      },
		  onFailure: function(){
		    alert('error');
	      }
	    });
    }
    loadEncounter();
</script>