<%@page import="be.mxs.common.util.io.ExportSAP_AR_INV"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
try{
	String sDate=checkString(request.getParameter("erdate"));
	if(sDate.length()==0){
		sDate=ScreenHelper.getDate();
	}
	String sCurrency=checkString(request.getParameter("ercurrency"));
	String sRate=checkString(request.getParameter("errate"));
	String sMessage="";
	if(request.getParameter("submit")!=null){
		ExportSAP_AR_INV.setExchangeRate(sCurrency, sDate, sRate);
	}
%>
<%=sJSPROTOTYPE %>
<form name='transactionForm' method='post'>
	<table width='400px'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","setexchangerate",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("erdate", "transactionForm", sDate, true, false, sWebLanguage, sCONTEXTPATH,"checkrate();") %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","currency",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='ercurrency' onchange='checkrate();'>
					<%=ScreenHelper.writeSelect(request,"currency", sCurrency, sWebLanguage) %>
				</select>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","exchangerate",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='errate' id='errate' size='20' value='<%=sRate%>'/> <%=MedwanQuery.getInstance().getConfigString("currency","") %></td>
		</tr>
	</table>
	<input type='submit' name='submit' value='<%=getTran(null,"web","save",sWebLanguage) %>'/>
</form>

<script>
	function checkrate(){
	    var params = 'date=' + transactionForm.erdate.value
	                +"&currency="+transactionForm.ercurrency.value;
	    var today = new Date();
	    var url= '<c:url value="/financial/getExchangeRate.jsp"/>?ts='+today;
		new Ajax.Request(url,{
		  method: "GET",
	      parameters: params,
	      onSuccess: function(resp){
	        $('errate').value=resp.responseText.trim();
	      },
        onFailure: function(data){
        }
		});
	}
	checkrate();
</script>
<%
}
catch(Exception e){
	e.printStackTrace();
}
%>