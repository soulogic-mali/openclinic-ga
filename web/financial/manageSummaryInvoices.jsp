<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sFindConsolidatedPatientInvoiceUID=checkString(request.getParameter("FindConsolidatedPatientInvoiceUID"));
	String sInvoiceUID=checkString(request.getParameter("InvoiceUID"));
	String sInvoiceDate=checkString(request.getParameter("InvoiceDate"));
	java.util.Date dInvoiceDate = ScreenHelper.parseDate(sInvoiceDate);
	String sInvoiceStatus=checkString(request.getParameter("InvoiceStatus"));
	String sInvoiceComment=checkString(request.getParameter("InvoiceComment"));
	String sInvoiceValidation=checkString(request.getParameter("InvoiceValidation"));
	boolean isInsuranceAgent=false;
	if(activeUser!=null && activeUser.getParameter("insuranceagent")!=null && activeUser.getParameter("insuranceagent").length()>0 && MedwanQuery.getInstance().getConfigString("InsuranceAgentAcceptationNeededFor","").indexOf("*"+activeUser.getParameter("insuranceagent")+"*")>-1){
		//This is an insurance agent, limit the functionalities
		isInsuranceAgent=true;
	}
	if(request.getParameter("saveInvoiceButton")!=null){
		//Save this SummaryInvoice content
		SummaryInvoice summaryInvoice = new SummaryInvoice();
		summaryInvoice.setPatientUid(Integer.parseInt(activePatient.personid));
		summaryInvoice.setUpdateDateTime(new java.util.Date());
		summaryInvoice.setUpdateUser(activeUser.userid);
		summaryInvoice.setUid(sInvoiceUID);
		summaryInvoice.setDate(dInvoiceDate);
		summaryInvoice.setStatus(sInvoiceStatus);
		summaryInvoice.setComment(sInvoiceComment);
		summaryInvoice.setValidated(sInvoiceValidation);
		//Also add all linked invoices
		boolean bPatientChanged=false;
		Enumeration parNames = request.getParameterNames();
		while(parNames.hasMoreElements()){
			String parName = (String)parNames.nextElement();
			if(parName.startsWith("cbInv.")){
				String invUid=parName.replaceAll("cbInv.", "");
				summaryInvoice.getItems().add(invUid);
				PatientInvoice patientInvoice = PatientInvoice.get(invUid);
				if(patientInvoice!=null && !patientInvoice.getPatientUid().equalsIgnoreCase(activePatient.personid)){
					bPatientChanged=true;
					break;
				}
			}
		}
		if(bPatientChanged){
			%>
			<script>
				alert('<%=getTranNoLink("web","patienthaschangedunexcpectedly",sWebLanguage)%>');
				window.location.href='<c:url value="logout.do"/>';
			</script>
			<%
			out.flush();
		}
		else {
			summaryInvoice.store();
			sFindConsolidatedPatientInvoiceUID=summaryInvoice.getUid();
		}
	}
	else if(request.getParameter("validateInvoiceButton")!=null && checkString(sInvoiceUID).length()>0){
		SummaryInvoice summaryInvoice = SummaryInvoice.get(sInvoiceUID);
		if(summaryInvoice!=null && summaryInvoice.hasValidUid()){
			summaryInvoice.setUpdateDateTime(new java.util.Date());
			summaryInvoice.setUpdateUser(activeUser.userid);
			summaryInvoice.setValidated(activeUser.userid);
			summaryInvoice.store();
		}
		sFindConsolidatedPatientInvoiceUID=summaryInvoice.getUid();
	}
%>
<form name='FindForm' id="FindForm" method='POST'>
    <%=writeTableHeader("web","consolidated.patientinvoices",sWebLanguage,"")%>
	<table class="menu" width='100%'>
	    <tr>
	        <td width="<%=sTDAdminWidth%>"><%=getTran(request,"web.finance","invoiceid",sWebLanguage)%></td>
	        <td>
	            <input type="text" class="text" id="FindConsolidatedPatientInvoiceUID" name="FindConsolidatedPatientInvoiceUID" onblur="isNumber(this)" value="<%=sFindConsolidatedPatientInvoiceUID%>">
	            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchConsolidatedPatientInvoice();">
	            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","clear",sWebLanguage)%>" onclick="doClear()">
	            <input type="button" class="button" name="ButtonFind" value="<%=getTran(null,"web","find",sWebLanguage)%>" onclick="doFind()">
	            <% if(!isInsuranceAgent){ %>
	            	<input type="button" class="button" name="ButtonNew" value="<%=getTran(null,"web","new",sWebLanguage)%>" onclick="doNew()">
	            <% } %>
	        </td>
	        <%
	        	String sDefaultServiceUid=MedwanQuery.getInstance().getConfigString("defaultSummaryInvoiceServiceFilter","");
	        %>
	        <td><%=getTran(request,"web","service",sWebLanguage)%></td>
	        <td>
	            <input type="hidden" name="EditInvoiceService" id="EditInvoiceService" value="<%=sDefaultServiceUid%>">
	           	<input class="text" type="text" name="EditInvoiceServiceName" id="EditInvoiceServiceName" readonly size="<%=40%>" value="<%=getTranNoLink("service",sDefaultServiceUid,sWebLanguage)%>">
	           	<img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('EditInvoiceService','EditInvoiceServiceName');">
	           	<img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditInvoiceService').value='';document.getElementById('EditInvoiceServiceName').value='';">
                &nbsp;<input type="button" class="button" name="update2" value="<%=getTran(null,"web","update",sWebLanguage)%>" onclick="findSummaryInvoice();"/>
	        </td>
	    </tr>
	</table>
</form>
<form name="transactionForm" method="POST">
	<div id='invoicedetails'></div>
</form>

<script>
	function searchService(serviceUidField,serviceNameField){
    	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
    }

	function doSign(invoiceuid){
        var today = new Date();
        var url= '<c:url value="/financial/summaryInvoiceSign.jsp"/>?ts='+today;
        new Ajax.Request(url,{
              method: "POST",
              postBody: 'EditInvoiceUID=' + invoiceuid,
              onSuccess: function(resp){
                  $('FindConsolidatedPatientInvoiceUID').value=invoiceuid;
                  findSummaryInvoice();
              },
              onFailure: function(){
                  $('divMessage').innerHTML = "Error in function summaryInvoiceSign() => AJAX";
              }
          }
        );
	}

    function findSummaryInvoice(){
	    var params = '';
	    var today = new Date();
	    var url= '<c:url value="/financial/getSummaryInvoice.jsp"/>?InvoiceUID='+document.getElementById('FindConsolidatedPatientInvoiceUID').value+"&ServiceUID="+document.getElementById("EditInvoiceService").value;
	    document.getElementById('invoicedetails').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    new Ajax.Request(url,{
		  	method: "POST",
	      	parameters: params,
	      	onSuccess: function(resp){
	        	$('invoicedetails').innerHTML=resp.responseText;
	      	}
	    });
	}
	
    function reopenSummaryInvoice(){
	    var params = '';
	    var today = new Date();
	    var url= '<c:url value="/financial/getSummaryInvoice.jsp"/>?reopen=true&InvoiceUID='+document.getElementById('FindConsolidatedPatientInvoiceUID').value+"&ServiceUID="+document.getElementById("EditInvoiceService").value;
	    document.getElementById('invoicedetails').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    new Ajax.Request(url,{
		  	method: "POST",
	      	parameters: params,
	      	onSuccess: function(resp){
	        	$('invoicedetails').innerHTML=resp.responseText;
	      	}
	    });
	}
	
    function printInvoice(uid){
        var url = "<c:url value="/financial/printSummaryInvoice.jsp"/>?SummaryInvoiceUID="+uid+"&invoiceType="+document.getElementById("invoicetype").value;
        printwindow=window.open(url,"SummaryInvoicePdf<%=new java.util.Date().getTime()%>","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
        window.setTimeout("closeDeadWindow();",5000);
    }

    function closeDeadWindow(){
    	if(printwindow.document.URL==""){
    		printwindow.close();
    	}	
    }

    function openPatientInvoice(uid){
        openPopup("/financial/patientInvoiceEdit.jsp&ts=-1605337678&PopupWidth="+(screen.width-200)+"&PopupHeight=600&showpatientname=true&FindPatientInvoiceUID="+uid);
    }

	function doNew(){
		document.getElementById('FindConsolidatedPatientInvoiceUID').value='';
		findSummaryInvoice();
	}
	
	function doFind(){
		findSummaryInvoice();
	}
	
	function searchConsolidatedPatientInvoice(){
		openPopup("/_common/search/searchConsolidatedPatientInvoice.jsp&ts=<%=getTs()%>&ReturnInvoiceUid=FindConsolidatedPatientInvoiceUID&ReturnFunction=findSummaryInvoice()&PopupWidth=600");
	}
	
	<%
		if(sFindConsolidatedPatientInvoiceUID.length()>0){
	%>
	findSummaryInvoice();
	<%
		}
	%>
</script>