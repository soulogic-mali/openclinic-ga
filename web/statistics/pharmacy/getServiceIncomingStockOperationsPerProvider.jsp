<%@page import="be.openclinic.pharmacy.*,
                java.io.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.pdf.general.*,
                org.dom4j.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sServiceStockId = checkString(request.getParameter("ServiceStockUid"));
	long day = 24*3600*1000;
	long year = 365*day;

	String sBegin = "01/01/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1),
		   sEnd   = "31/12/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);

	// US-date
    if(ScreenHelper.stdDateFormat.toPattern().equals("MM/dd/yyyy")){
        sEnd = "12/31/"+(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1);
    }

    /// DEBUG ///////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n****** statistics/pharmacy/getServiceIncomingStockOperationsPerProvider.jsp *******");
    	Debug.println("sServiceStockId : "+sServiceStockId);
    	Debug.println("sBegin          : "+sBegin);
    	Debug.println("sEnd            : "+sEnd+"\n");
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////
    
%>
<form name='transactionForm' method='post'>
	<table width="100%" cellpadding="0" cellspacing="1" class="list">
	    <%-- PERIOD --%>
		<tr>
			<td class='admin2' nowrap colspan='2'>
				<%=getTran(request,"web","from",sWebLanguage)%> <%=writeDateField("FindBeginDate","transactionForm",sBegin,sWebLanguage)%>
				<%=getTran(request,"web","to",sWebLanguage)%> <%=writeDateField("FindEndDate","transactionForm",sEnd,sWebLanguage)%>
			</td>
		</tr>
		<tr>
			<td class='admin2' colspan='2'>
				<%=getTran(request,"web","provider",sWebLanguage)%>: 
            	<input type='text' class='text' name='providerUid' id='providerUid' size='30'/>
            	
				<div id="autocomplete_provider" class="autocomple"></div>
				
			</td>
		</tr>
		<tr>
			<td class='admin'>
				<%=getTran(request,"web","format",sWebLanguage)%>
			</td>
			<td class='admin2'>
				<select name='outputformat' id='outputformat' class='text'>
					<option value='pdf'>PDF</option>
					<option value='excel'>Excel</option>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin2' colspan='2'>
				<input type='button' class="button" name='print' value='<%=getTranNoLink("web","print",sWebLanguage)%>' onclick='printReport();'/>
			</td>
		</tr>
	</table>
</form>

<script>

	new Ajax.Autocompleter('providerUid','autocomplete_provider','pharmacy/ajax/getProviders.jsp',{
		minChars:1,
		method:'post',
		afterUpdateElement:afterAutoComplete,
		callback:composeCallbackURL
	});
		
	function afterAutoComplete(field,item){
		var regex = new RegExp(':none">.*-idcache','i');
		var nomimage = regex.exec(item.innerHTML);
		var id = nomimage[0].replace('-idcache','').replace(':none">','');
		document.getElementById("providerUid").value = id;
	}
	
	function composeCallbackURL(field,item){
		var url = "";
		if(field.id=="providerUid"){
			url = "findProviderName="+field.value+"&findServiceStockUid=<%=sServiceStockId%>";
		}
		return url;
	}

	function printReport(){
		window.open('<c:url value="pharmacy/printServiceIncomingStockOperationsPerProvider.jsp"/>?outputformat='+document.getElementById('outputformat').value+'&FindBeginDate='+document.getElementById('FindBeginDate').value+'&FindEndDate='+document.getElementById('FindEndDate').value+'&ServiceStockUid=<%=sServiceStockId%>&provider='+document.getElementById('providerUid').value);
		window.close();
	}
</script>