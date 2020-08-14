<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%=sJSPROTOTYPE %>
<%
	String sBegin = SH.formatDate(SH.getPreviousMonthBegin());
	String sEnd = SH.formatDate(SH.getPreviousMonthEnd());
%>

<form name='transactionForm' method='post'>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"asset","dashboard",sWebLanguage) %></td></tr>
		<tr>
		    <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
		    <td class="admin2">
	            <%
	            	if(checkString(request.getParameter("serviceuid")).length()>0){
	            		session.setAttribute("activeservice", request.getParameter("serviceuid"));
	            	}
	            	String sServiceUid = checkString((String)session.getAttribute("activeservice"));
	            	if(sServiceUid.length()==0){   	
	            		sServiceUid=activeUser.getParameter("defaultserviceid");
	            	}
	            %>
		        <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sServiceUid%>">
		        <input class="text" type="text" name="servicename" id="servicename" readonly size="60" value="<%=getTranNoLink("service",sServiceUid,sWebLanguage) %>" >
		        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
		    </td>                        
		</tr>
		<tr>
		    <td class="admin"><%=getTran(request,"web","period",sWebLanguage)%></td>
		    <td class='admin2'>
		    	<%= SH.writeDateField("dashboardBegin", "transactionForm", sBegin, true, false, sWebLanguage, sCONTEXTPATH)%>
		    	<%= SH.writeDateField("dashboardEnd", "transactionForm", sEnd, true, false, sWebLanguage, sCONTEXTPATH)%>
		    	<input type='button' onclick='doAnalyze()' name='submitButton' class='button' value='<%=getTranNoLink("web","analyze",sWebLanguage) %>'/>
		    </td>
		</tr>
	</table>
	<div id='divDashboard'></div>
</form>

<script>
	function doAnalyze(){
	    document.getElementById('divDashboard').innerHTML = "<img height='14px' src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/>";
	    var params = "service="+document.getElementById("serviceuid").value+"&begin="+document.getElementById("dashboardBegin").value+"&end="+document.getElementById("dashboardEnd").value;
	    var url = "<%=sCONTEXTPATH%>/assets/ajax/generateDashboard.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divDashboard').innerHTML=resp.responseText;
		}
		});
	}
	
	function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
    }


</script>