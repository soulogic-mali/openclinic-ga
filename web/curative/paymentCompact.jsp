<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","payment",sWebLanguage) %></td></tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","amount",sWebLanguage) %></td>
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
    %>
    <%
    	String encounteruid="",encounterservice="",encounterservicename="",encountertype="",encountermanager="",encountermanagername="",encounterorigin=SH.cs("defaultOrigin","1");
    	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
    	if(encounter!=null && encounter.getEnd()==null){
    		encounterservice=encounter.getServiceUID();
    		encounterservicename=encounter.getService().getLabel(sWebLanguage);
    		encountertype=encounter.getType();
    		encounterorigin=encounter.getOrigin();
    		encounteruid=encounter.getUid();
    		encountermanager=encounter.getManagerUID();
    		if(encounter.getManager()!=null&& encounter.getManager().person!=null){
    			encountermanagername=encounter.getManager().person.getFullName();
    		}
    	}
    	else{
    %>
    <tr>
    	<td colspan='2'><font style='font-weight: bold;color: red'><%=getTran(request,"web","encountermustbecreated",sWebLanguage) %></font></td>
    </tr>
    <%
    	}
    %>
    <tr>
        <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%> *</td>
        <td class='admin2' nowrap>
        	<input type='hidden' name='encounteruid' id='encounteruid' value='<%=encounteruid %>'/>
            <input type="hidden" name="EditEncounterService" id="EditEncounterService" value="<%=encounterservice%>"/>
            <input class="text" type="text" name="EditEncounterServiceName" id="EditEncounterServiceName" value="<%=encounterservicename%>" readonly size="50"/>
            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchService('EditEncounterService','EditEncounterServiceName');">
            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="EditEncounterService.value='';EditEncounterServiceName.value='';">
        </td>
    </tr>
    <tr>
        <td class="admin"><%=getTran(request,"web","manager",sWebLanguage)%> *</td>
        <td class="admin2" nowrap>
            <input type="hidden" name="EditEncounterManager" id="EditEncounterManager" value="<%=encountermanager%>">
            <input class="text" type="text" name="EditEncounterManagerName" id="EditEncounterManagerName" readonly size="50" value="<%=encountermanagername%>">
           
            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchManager('EditEncounterManager','EditEncounterManagerName');">
            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('EditEncounterManager').value='';document.getElementById('EditEncounterManagerName').value='';">
        </td>
    </tr>
    <tr>
        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","type",sWebLanguage)%> *</td>
        <td class='admin2'>
            <select class='text' id='EditEncounterType' name='EditEncounterType' onchange="checkEncounterType();">
            	<option value=''></option>
                <%
                    String encountertypes = MedwanQuery.getInstance().getConfigString("encountertypes","visit,admission");
                    String sOptions[] = encountertypes.split(",");

                    for(int i=0;i<sOptions.length;i++){
                        out.print("<option value='"+sOptions[i]+"' ");
                        if(sOptions[i].equalsIgnoreCase(encountertype)){
                        	out.print("selected");
                        }
                        out.print(">"+getTran(request,"web",sOptions[i],sWebLanguage)+"</option>");
                    }
                %>
            </select>
        </td>
    </tr>
    <tr>
        <td class="admin"><%=getTran(request,"openclinic.chuk","urgency.origin",sWebLanguage)%> *</td>
        <td class="admin2">
            <select class="text" name="EditEncounterOrigin" id="EditEncounterOrigin">
                <option/>
                <%=ScreenHelper.writeSelect(request,"urgency.origin",encounterorigin,sWebLanguage)%>
            </select>
        </td>
    </tr>
	<tr id='payment_tr'>
		<td colspan='2'><center><input type='button' class='button' name='paymentButton' id='paymentButton' value='<%=getTranNoLink("web","paymentreceived",sWebLanguage) %>' onclick='doPayment();'/></center></td>
	</tr>
	<tr id='print_tr' style='display: none'>
		<td colspan='2'><center>
			<input type='button' class='redbutton' name='printButton' id='printButton' value='<%=getTranNoLink("web","print",sWebLanguage)+" "+getTranNoLink("web","receipt",sWebLanguage).toLowerCase() %>' onclick='doPrintReceipt();'/>
			<input type='button' class='redbutton' name='printInvoiceButton' id='printInvoiceButton' value='<%=getTranNoLink("web","print",sWebLanguage)+" "+getTranNoLink("web","invoice",sWebLanguage).toLowerCase() %>' onclick='doPrintInvoice();'/>
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
		if(	document.getElementById("wicketuid").value.length==0||
			document.getElementById("EditEncounterService").value.length==0||
			document.getElementById("EditEncounterType").value.length==0||
			document.getElementById("EditEncounterManager").value.length==0||
			document.getElementById("EditEncounterOrigin").value.length==0){
			alert('<%=getTranNoLink("web","datamissing",sWebLanguage)%>');
		}
		else{
		    var params = 	"prestations="+prestationlist+
		    				"&wicketuid="+document.getElementById('wicketuid').value+
		    				"&amount="+document.getElementById('amount').value+
		    				"&encounteruid="+document.getElementById('encounteruid').value+
		    				"&encounterserviceuid="+document.getElementById('EditEncounterService').value+
		    				"&encountermanager="+document.getElementById('EditEncounterManager').value+
		    				"&encountertype="+document.getElementById('EditEncounterType').value+
		    				"&encounterorigin="+document.getElementById('EditEncounterOrigin').value
		    				;
		    var url= '<c:url value="/curative/ajax/storeDebets.jsp"/>?ts='+new Date();
		    new Ajax.Request(url,{
			  method: "POST",
		      parameters: params,
		      onSuccess: function(resp){
		    	  //Redirect to medical summary
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
</script>