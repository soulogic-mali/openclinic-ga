<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
%>
<table width='100%'>
	<tr class='admin'>
		<td>
			<input type='text' name='patientname' id='patientname' size="60" readonly/>
			<input type='hidden' name='patientid' id='patientid'/>
			<img src="<c:url value="/_img/icons/icon_person.png"/>" onclick="searchPatient()" onmouseout='this.style.cursor = "default";' onmouseover='this.style.cursor = "pointer";'/>
		</td>
	</tr>
</table>
<hr/>
<div id='message'></div>

<script>
	function searchPatient(){
		openPopup("/_common/search/searchPatient.jsp&ts=<%=getTs()%>&ReturnName=patientname&ReturnPersonID=patientid&ReturnFunction=checkEligibility()&displayImmatNew=no&isUser=no");
	}
	
	function checkEligibility(){
	    var params = 'personid='+document.getElementById("patientid").value+"&language=<%=sWebLanguage%>";
	    var url = '<c:url value="/cnts/checkDonorEligibility.jsp"/>?ts='+new Date();
	    new Ajax.Request(url,{
		 	method: "GET",
		    parameters: params,
		    onSuccess: function(resp){
		    	document.getElementById("message").innerHTML=resp.responseText;
		    }
	    });
	}
	searchPatient();
</script>