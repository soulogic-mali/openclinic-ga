<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String prestationuid = request.getParameter("prestationuid");
	String extrainsurance = checkString(request.getParameter("extrainsurance"));
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","negociatedtariffs",sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web.finance","amount.patient",sWebLanguage) %></td>
		<td class='admin2' nowrap><input type='text' name='patientvalue' id='patientvalue' onkeyup='validatePatientValue()'/><%=MedwanQuery.getInstance().getConfigString("currency","RWF") %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web.finance","amount.complementaryinsurar",sWebLanguage) %></td>
		<td class='admin2' nowrap><input type='text' name='insurervalue' id='insurervalue' onkeyup='validateInsurerValue()'/><%=MedwanQuery.getInstance().getConfigString("currency","RWF") %></td>
	</tr>
</table>
<p>
<center><input type='button' class='button' onclick='updateDebet()' value='<%=getTran(null,"web","update",sWebLanguage) %>'/></center>
</p>
<script>
	document.getElementById('patientvalue').value=Math.round(100*(window.opener.document.getElementById('PPP_<%=prestationuid%>').value.replace(',','.').replace(' ','')))/100;
	document.getElementById('insurervalue').value=Math.round(100*(window.opener.document.getElementById('PPE_<%=prestationuid%>').value.replace(',','.').replace(' ','')))/100;
	var totalvalue=document.getElementById('patientvalue').value*1+document.getElementById('insurervalue').value*1;
	
	function validatePatientValue(){
		document.getElementById('insurervalue').value=Math.round(100*(totalvalue-document.getElementById('patientvalue').value))/100;
	}
	
	function validateInsurerValue(){
		document.getElementById('patientvalue').value=Math.round(100*(totalvalue-document.getElementById('insurervalue').value))/100;
	}
	
	function updateDebet(){
		window.opener.document.getElementById('PPP_<%=prestationuid%>').value=document.getElementById('patientvalue').value;
		window.opener.document.getElementById('TPPP_<%=prestationuid%>').innerHTML=document.getElementById('patientvalue').value;
		window.opener.document.getElementById('PPE_<%=prestationuid%>').value=document.getElementById('insurervalue').value;
		window.opener.document.getElementById('TPPE_<%=prestationuid%>').innerHTML=document.getElementById('insurervalue').value;
		window.close();
	}
</script>