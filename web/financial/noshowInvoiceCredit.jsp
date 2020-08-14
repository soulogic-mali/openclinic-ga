<%@ page import="be.openclinic.finance.*,be.openclinic.adt.Encounter,java.text.*,be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String invoiceuid = request.getParameter("patientinvoiceuid");
	if(request.getParameter("creditButton")!=null){
		String reason = request.getParameter("reason");
		if(reason.split(",").length==2){
			//Make a credit note for this invoice
			double percentage = Double.parseDouble(reason.split(",")[1]);
			if(percentage>0){
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				if(invoice!=null){
					if(invoice.getStatus().equalsIgnoreCase("closed")){
						PatientInvoice creditNote = new PatientInvoice();
						creditNote.setBalance(-invoice.getPatientAmount()*percentage/100);
						creditNote.setCreateDateTime(new java.util.Date());
						creditNote.setDate(new java.util.Date());
						creditNote.setPatientUid(invoice.getPatientUid());
						creditNote.setStatus("open");
						creditNote.setUid("-1");
						creditNote.setUpdateDateTime(new java.util.Date());
						creditNote.setUpdateUser(activeUser.userid);
						creditNote.setVersion(1);
						creditNote.setComment(getTranNoLink("web","noshow",sWebLanguage)+" "+getTranNoLink("web.finance","patientinvoice",sWebLanguage)+" #"+invoice.getInvoiceNumber());
						Vector debets = new Vector();
						Debet debet = new Debet();
						debet.setAmount(-invoice.getPatientAmount()*percentage/100);
						debet.setInsurarAmount(-invoice.getInsurarAmount()*percentage/100);
						debet.setExtraInsurarAmount(-invoice.getExtraInsurarAmount()*percentage/100);
						debet.setCreateDateTime(new java.util.Date());
						debet.setDate(new java.util.Date());
						debet.setEncounterUid(Encounter.getLastEncounter(activePatient.personid).getUid());
						debet.setInsuranceUid(invoice.getInsuranceUid());
						debet.setPrestationUid(MedwanQuery.getInstance().getConfigString("noshowCreditHealthService",""));
						debet.setQuantity(1);
						debet.setRefUid(invoice.getInvoiceNumber());
						debet.setServiceUid(Encounter.getLastEncounter(activePatient.personid).getServiceUID());
						debet.setUid("-1");
						debet.setUpdateDateTime(new java.util.Date());
						debet.setUpdateUser(activeUser.userid);
						debet.setVersion(1);
						debet.store();
						debets.add(debet);
						creditNote.setDebets(debets);
						creditNote.store();
						invoiceuid=creditNote.getUid();
					}
					else{
						Debet debet = new Debet();
						debet.setAmount(-invoice.getPatientAmount()*percentage/100);
						debet.setInsurarAmount(-invoice.getInsurarAmount()*percentage/100);
						debet.setExtraInsurarAmount(-invoice.getExtraInsurarAmount()*percentage/100);
						debet.setCreateDateTime(new java.util.Date());
						debet.setDate(new java.util.Date());
						debet.setEncounterUid(Encounter.getLastEncounter(activePatient.personid).getUid());
						debet.setInsuranceUid(invoice.getInsuranceUid());
						debet.setPrestationUid(MedwanQuery.getInstance().getConfigString("noshowCreditHealthService",""));
						debet.setQuantity(1);
						debet.setRefUid(invoice.getInvoiceNumber());
						debet.setServiceUid(Encounter.getLastEncounter(activePatient.personid).getServiceUID());
						debet.setUid("-1");
						debet.setUpdateDateTime(new java.util.Date());
						debet.setUpdateUser(activeUser.userid);
						debet.setVersion(1);
						debet.store();
						invoice.getDebets().add(debet);
					}
					invoice.setVerifier("credited");
					invoice.store();
					//Now open the invoice in the window opener
					%>
						<script>
							if(window.opener.setPatientInvoice){
								window.opener.setPatientInvoice('<%=invoiceuid%>');
							}
							window.close();
						</script>
					<%
				}
			}
		}
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='patientinvoiceuid' value='<%=invoiceuid%>'/>
	<table width='100%'>
		<tr class='admin'>
			<td colspan='2'><%=getTran(request,"web","noshowinvoicecredit",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","reason",sWebLanguage) %></td>
			<td class='admin2'>
				<select class='text' name='reason' id='reason'>
					<%=ScreenHelper.writeSelect(request,"noshowinvoicecredit.reason","",sWebLanguage) %>
				</select>
			</td>
		</tr>
	</table>
	<input type='submit' class='button' name='creditButton' value='<%=getTranNoLink("web","makecreditnote",sWebLanguage)%>'%>
</form>