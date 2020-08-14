<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	if(request.getParameter("submit")!=null){
		if(checkString(request.getParameter("patientbegindate")).length()>0 && checkString(request.getParameter("patientcounter")).length()>0){
			MedwanQuery.getInstance().setConfigString("PatientInvoiceType",checkString(request.getParameter("patientcounter")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("patientcounter"))+"ResetDate",checkString(request.getParameter("patientbegindate")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("patientcounter"))+"AddPrefix",checkString(request.getParameter("patientprefix")).equalsIgnoreCase("1")?"1":"0");	
		}
		else{
			MedwanQuery.getInstance().setConfigString("PatientInvoiceType","PatientInvoice");
			MedwanQuery.getInstance().setConfigString("PatientInvoiceResetDate","");
			MedwanQuery.getInstance().setConfigString("PatientInvoiceAddPrefix","");	
		}
		if(checkString(request.getParameter("insurerbegindate")).length()>0 && checkString(request.getParameter("insurercounter")).length()>0){
			MedwanQuery.getInstance().setConfigString("InsurerInvoiceType",checkString(request.getParameter("insurercounter")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("insurercounter"))+"ResetDate",checkString(request.getParameter("insurerbegindate")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("insurercounter"))+"AddPrefix",checkString(request.getParameter("insurerprefix")).equalsIgnoreCase("1")?"1":"0");	
		}
		else{
			MedwanQuery.getInstance().setConfigString("InsurerInvoiceType","InsurerInvoice");
			MedwanQuery.getInstance().setConfigString("InsurerInvoiceResetDate","");
			MedwanQuery.getInstance().setConfigString("InsurerInvoiceAddPrefix","");	
		}
		if(checkString(request.getParameter("extrainsurerbegindate")).length()>0 && checkString(request.getParameter("extrainsurercounter")).length()>0){
			MedwanQuery.getInstance().setConfigString("ExtraInsurerInvoiceType",checkString(request.getParameter("extrainsurercounter")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("extrainsurercounter"))+"ResetDate",checkString(request.getParameter("extrainsurerbegindate")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("extrainsurercounter"))+"AddPrefix",checkString(request.getParameter("extrainsurerprefix")).equalsIgnoreCase("1")?"1":"0");	
		}
		else{
			MedwanQuery.getInstance().setConfigString("ExtraInsurerInvoiceType","ExtraInsurerInvoice");
			MedwanQuery.getInstance().setConfigString("ExtraInsurerInvoiceResetDate","");
			MedwanQuery.getInstance().setConfigString("ExtraInsurerInvoiceAddPrefix","");	
		}
		if(checkString(request.getParameter("extrainsurer2begindate")).length()>0 && checkString(request.getParameter("extrainsurer2counter")).length()>0){
			MedwanQuery.getInstance().setConfigString("ExtraInsurer2InvoiceType",checkString(request.getParameter("extrainsurer2counter")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("extrainsurer2counter"))+"ResetDate",checkString(request.getParameter("extrainsurer2begindate")));
			MedwanQuery.getInstance().setConfigString(checkString(request.getParameter("extrainsurer2counter"))+"AddPrefix",checkString(request.getParameter("extrainsurer2prefix")).equalsIgnoreCase("1")?"1":"0");	
		}
		else{
			MedwanQuery.getInstance().setConfigString("ExtraInsurer2InvoiceType","ExtraInsurer2Invoice");
			MedwanQuery.getInstance().setConfigString("ExtraInsurer2InvoiceResetDate","");
			MedwanQuery.getInstance().setConfigString("ExtraInsurer2InvoiceAddPrefix","");	
		}
	}
%>

<form name="transactionForm" id="transactionForm" method="post">
    <%=writeTableHeader("Web.manage","setinvoicecounters",sWebLanguage," doBack();")%>
	<table>
		<tr class='admin'>
			<td><%=getTran(request,"web","type",sWebLanguage) %></td>
			<td><%=getTran(request,"web","counter",sWebLanguage) %></td>
			<td><%=getTran(request,"web","begindate",sWebLanguage) %><br/><%=getTran(request,"web","nodateisinactive",sWebLanguage) %></td>
			<td><%=getTran(request,"web","prefix",sWebLanguage) %></td>
			<td><%=getTran(request,"web","value",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","patientinvoices",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='patientcounter' size='30' value='<%=MedwanQuery.getInstance().getConfigString("PatientInvoiceType","PatientInvoice") %>'/></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("patientbegindate", "transactionForm", MedwanQuery.getInstance().getConfigString(MedwanQuery.getInstance().getConfigString("PatientInvoiceType","PatientInvoice")+"ResetDate",""), true, true, sWebLanguage, sCONTEXTPATH) %></td>
			<td class='admin2'><input type='checkbox' class='text' name='patientprefix' value='1' <%=MedwanQuery.getInstance().getConfigInt(MedwanQuery.getInstance().getConfigString("PatientInvoiceType","PatientInvoice")+"AddPrefix",1)==1?"checked":"" %>/></td>
			<td class='admin2'><input readonly type='text' class='text' name='patientcountervalue' size='30' value='<%=Invoice.getInvoiceNumberCounterNoIncrement("PatientInvoice") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","insurarinvoices",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='insurercounter' size='30' value='<%=MedwanQuery.getInstance().getConfigString("InsurerInvoiceType","InsurerInvoice") %>'/></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("insurerbegindate", "transactionForm", MedwanQuery.getInstance().getConfigString(MedwanQuery.getInstance().getConfigString("InsurerInvoiceType","InsurerInvoice")+"ResetDate",""), true, true, sWebLanguage, sCONTEXTPATH) %></td>
			<td class='admin2'><input type='checkbox' class='text' name='insurerprefix' value='1' <%=MedwanQuery.getInstance().getConfigInt(MedwanQuery.getInstance().getConfigString("InsurerInvoiceType","InsurerInvoice")+"AddPrefix",1)==1?"checked":"" %>/></td>
			<td class='admin2'><input readonly type='text' class='text' name='insurercountervalue' size='30' value='<%=Invoice.getInvoiceNumberCounterNoIncrement("InsurerInvoice") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","extrainsurarinvoices",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='extrainsurercounter' size='30' value='<%=MedwanQuery.getInstance().getConfigString("ExtraInsurerInvoiceType","ExtraInsurerInvoice") %>'/></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("extrainsurerbegindate", "transactionForm", MedwanQuery.getInstance().getConfigString(MedwanQuery.getInstance().getConfigString("ExtraInsurerInvoiceType","ExtraInsurerInvoice")+"ResetDate",""), true, true, sWebLanguage, sCONTEXTPATH) %></td>
			<td class='admin2'><input type='checkbox' class='text' name='extrainsurerprefix' value='1' <%=MedwanQuery.getInstance().getConfigInt(MedwanQuery.getInstance().getConfigString("ExtraInsurerInvoiceType","ExtraInsurerInvoice")+"AddPrefix",1)==1?"checked":"" %>/></td>
			<td class='admin2'><input readonly type='text' class='text' name='extrainsurercountervalue' size='30' value='<%=Invoice.getInvoiceNumberCounterNoIncrement("ExtraInsurerInvoice") %>'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","extrainsurar2invoices",sWebLanguage) %></td>
			<td class='admin2'><input type='text' class='text' name='extrainsurer2counter' size='30' value='<%=MedwanQuery.getInstance().getConfigString("ExtraInsurer2InvoiceType","ExtraInsurer2Invoice") %>'/></td>
			<td class='admin2'><%=ScreenHelper.writeDateField("extrainsurer2begindate", "transactionForm", MedwanQuery.getInstance().getConfigString(MedwanQuery.getInstance().getConfigString("ExtraInsurer2InvoiceType","ExtraInsurer2Invoice")+"ResetDate",""), true, true, sWebLanguage, sCONTEXTPATH) %></td>
			<td class='admin2'><input type='checkbox' class='text' name='extrainsurer2prefix' value='1' <%=MedwanQuery.getInstance().getConfigInt(MedwanQuery.getInstance().getConfigString("ExtraInsurer2InvoiceType","ExtraInsurer2Invoice")+"AddPrefix",1)==1?"checked":"" %>/></td>
			<td class='admin2'><input readonly type='text' class='text' name='extrainsurer2countervalue' size='30' value='<%=Invoice.getInvoiceNumberCounterNoIncrement("ExtraInsurer2Invoice") %>'/></td>
		</tr>
			<td class='admin' colspan='5'><input type='submit' class='button' name='submit' value='<%=getTran(null,"web","save",sWebLanguage)%>'/></td>
		<tr>
		</tr>
	</table>
</form>