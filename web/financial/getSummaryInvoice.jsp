<%@ page import="be.openclinic.finance.*,be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	boolean isInsuranceAgent=false;
	if(activeUser!=null && activeUser.getParameter("insuranceagent")!=null && activeUser.getParameter("insuranceagent").length()>0 && MedwanQuery.getInstance().getConfigString("InsuranceAgentAcceptationNeededFor","").indexOf("*"+activeUser.getParameter("insuranceagent")+"*")>-1){
		//This is an insurance agent, limit the functionalities
		isInsuranceAgent=true;
	}
	String sInvoiceUID = request.getParameter("InvoiceUID");
 	String sServiceUID = checkString(request.getParameter("ServiceUID"));
	SummaryInvoice invoice = null;
	String sMessage="";
	if(sInvoiceUID.length()>0){
		invoice=SummaryInvoice.get(sInvoiceUID);
		if(checkString(request.getParameter("reopen")).equalsIgnoreCase("true")){
			invoice.setStatus("open");
			invoice.store();
		}
	}
	if(invoice==null || !invoice.hasValidUid()){
		if(sInvoiceUID.length()>0){
			sMessage=getTran(request,"web","cannotfindsummaryinvoice",sWebLanguage)+": "+sInvoiceUID;
		}
		invoice=new SummaryInvoice();
	}
%>
<table width='100%'>
	<tr>
		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td class='admin2'>
			<%if(checkString(invoice.getStatus()).equalsIgnoreCase("closed")){ %>
			<%=invoice.getDate()==null?"?":ScreenHelper.formatDate(invoice.getDate()) %>
			<%}else{ %>
			<%=ScreenHelper.writeDateField("InvoiceDate", "transactionForm", invoice.getDate()==null?ScreenHelper.formatDate(new java.util.Date()):ScreenHelper.formatDate(invoice.getDate()), true, false, sWebLanguage, sCONTEXTPATH) %>
			<%} %>
		</td>
		<td class='admin'><%=getTran(request,"web","invoicestatus",sWebLanguage) %></td>
		<td class='admin2'>
			<% 	if(checkString(invoice.getStatus()).equalsIgnoreCase("closed")){ %>
			 <%=getTran(request,"summaryinvoicestatus","closed",sWebLanguage) %>
			<%
				if(activeUser.getAccessRight("financial.reopensummaryinvoice.select")){
			%>
				<input type='button' class='button' name='reopen' value='<%=getTranNoLink("web","reopen",sWebLanguage) %>' onclick='reopenSummaryInvoice("<%=invoice.getUid()%>")'/>
			<%
				}
				}else{
			%>
			<select class='text' name='InvoiceStatus' id='InvoiceStatus'>
				<option/>
				<%=ScreenHelper.writeSelect(request,"summaryinvoicestatus",ScreenHelper.checkString(invoice.getStatus()).length()==0?"open":invoice.getStatus(),sWebLanguage) %>
			</select> 
			<%} %>
		</td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","comment",sWebLanguage) %></td>
		<td class='admin2'>
			<textarea <%=checkString(invoice.getStatus()).equalsIgnoreCase("closed")?"readonly":"" %> class="text" name="InvoiceComment" id="InvoiceComment" cols="80" rows="2"><%=ScreenHelper.checkString(invoice.getComment()) %></textarea>
		</td>
		<td class='admin'><%=getTran(request,"web","invoicevalidation",sWebLanguage) %></td>
		<td class='admin2'><%= ScreenHelper.checkString(invoice.getValidated()).length()>0?User.getFullUserName(invoice.getValidated()):getTran(request,"summaryinvoicevalidation","unvalidated",sWebLanguage)%></td>
	</tr>
    <%	
    	if(invoice!=null && invoice.hasValidUid()){
    		String signatures="";
    		Vector pointers=Pointer.getFullPointers("SUMINVSIGN."+invoice.getUid());
    		for(int n=0;n<pointers.size();n++){
    			if(n>0){
    				signatures+=", ";
    			}
    			String ptr=(String)pointers.elementAt(n);
    			signatures+=ptr.split(";")[0]+" - "+ScreenHelper.fullDateFormat.format(new SimpleDateFormat("yyyyMMddHHmmSSsss").parse(ptr.split(";")[1]));
    		}
    		if(signatures.length()>0){
 	        %>
 	        <tr>
 	            <td class="admin" nowrap><%=getTran(request,"web.finance","signed.by",sWebLanguage)%></td>
 	            <td class="admin2" colspan="3">
 	                <%=signatures %>
 	            </td>
 	        </tr>
 	        <%
    		}
    	}
    %>
</table>
<table width='100%'>
	<%
		//Now we add all linked PatientInvoices
		//If a new SummaryInvoice, also add unlinked patientinvoices
		HashSet linkedinvoices = new HashSet();
		Vector unlinkedinvoices = new Vector();
		if(invoice==null || !invoice.hasValidUid() || !invoice.getStatus().equalsIgnoreCase("closed")){
			unlinkedinvoices=SummaryInvoice.getUnsummarizedPatientInvoices(activePatient.personid);
		}
		if(invoice.getPatientInvoices().size()+unlinkedinvoices.size()>0){
			out.println("<tr class='admin'>");
			out.println("<td>"+getTran(request,"web","invoiceid",sWebLanguage)+"</td>");
			out.println("<td>"+getTran(request,"web","date",sWebLanguage)+"</td>");
			out.println("<td>"+getTran(request,"web","insurarreference",sWebLanguage)+"</td>");
			out.println("<td>"+getTran(request,"web","service",sWebLanguage)+"</td>");
			out.println("<td>"+getTran(request,"web","invoicestatus",sWebLanguage)+"</td>");
			out.println("<td>"+getTran(request,"web","balance",sWebLanguage)+"</td>");
			out.println("</tr>");
		}
		for(int n=0;n<invoice.getPatientInvoices().size();n++){
			PatientInvoice patientInvoice = (PatientInvoice)invoice.getPatientInvoices().elementAt(n);
			linkedinvoices.add(patientInvoice.getUid());
			out.println("<tr>");
			if(checkString(invoice.getStatus()).equalsIgnoreCase("closed")){
				out.println("<td class='admin'><img src='"+sCONTEXTPATH+"/_img/themes/default/check.gif'/>&nbsp;"+patientInvoice.getUid()+"</td>");
			}
			else{
				out.println("<td class='admin'><input type='checkbox' name='cbInv."+patientInvoice.getUid()+"' id='cbInv."+patientInvoice.getUid()+"' checked/>"+patientInvoice.getUid()+"</td>");
			}
			out.println("<td class='admin2'><a href='javascript:openPatientInvoice(\""+patientInvoice.getUid()+"\")'>"+ScreenHelper.formatDate(patientInvoice.getDate())+"</a></td>");
			out.println("<td class='admin2'>"+patientInvoice.getInsurarreference()+"</td>");
			out.println("<td class='admin2'>"+patientInvoice.getServicesAsString(sWebLanguage)+"</td>");
			out.println("<td class='admin2'>"+getTran(request,"finance.patientinvoice.status",patientInvoice.getStatus(),sWebLanguage)+(!patientInvoice.getStatus().equalsIgnoreCase("closed")?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>":"")+"</td>");
			out.println("<td class='admin2'>"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(patientInvoice.getBalance())+"</td>");
			out.println("</tr>");
		}
		if(invoice.getPatientInvoices().size()>0){
			out.println("<tr><td colspan='6'><hr/></td></tr>");
		}
		for(int n=0;n<unlinkedinvoices.size();n++){
			PatientInvoice patientInvoice = (PatientInvoice)unlinkedinvoices.elementAt(n);
			if(sServiceUID.length()==0 || patientInvoice.getServices().contains(sServiceUID)){
				out.println("<tr>");
				out.println("<td class='admin'><input type='checkbox' name='cbInv."+patientInvoice.getUid()+"' id='cbInv."+patientInvoice.getUid()+"'/>"+patientInvoice.getUid()+"</td>");
				out.println("<td class='admin2'><a href='javascript:openPatientInvoice(\""+patientInvoice.getUid()+"\")'>"+ScreenHelper.formatDate(patientInvoice.getDate())+"</a></td>");
				out.println("<td class='admin2'>"+patientInvoice.getInsurarreference()+"</td>");
				out.println("<td class='admin2'>"+patientInvoice.getServicesAsString(sWebLanguage)+"</td>");
				out.println("<td class='admin2'>"+getTran(request,"finance.patientinvoice.status",patientInvoice.getStatus(),sWebLanguage)+(!patientInvoice.getStatus().equalsIgnoreCase("closed")?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>":"")+"</td>");
				out.println("<td class='admin2'>"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(patientInvoice.getBalance())+"</td>");
				out.println("</tr>");
			}
		}
	%>
</table>
<input type='hidden' name='InvoiceUID' id='InvoiceUId' value='<%=sInvoiceUID%>'/>
<%	if(!isInsuranceAgent && sMessage.length()==0 && !checkString(invoice.getStatus()).equalsIgnoreCase("closed")){ %>
		<input type='submit' name='saveInvoiceButton' value='<%=getTran(null,"web","save",sWebLanguage) %>'/>
<%
	}
	if(isInsuranceAgent && checkString(invoice.getStatus()).equalsIgnoreCase("closed") && checkString(invoice.getValidated()).length()==0){ %>
		<input type='submit' class='button' name='validateInvoiceButton' value='<%=getTran(null,"web","validate",sWebLanguage) %>'/>
		<input type='button' class='button' name='printInvoiceButton' value='<%=getTran(null,"web","proforma",sWebLanguage) %>' onclick='printInvoice("<%=invoice.getUid()%>");'/>
		<%=getTran(request,"web","invoiceformat",sWebLanguage) %>:
		<select name='invoicetype' id='invoicetype' class='text'>
			<option value='default'><%=getTran(request,"web","defaultmodel",sWebLanguage) %></option>
			<option value='MFPSummary'><%=getTran(request,"web","mfpmodel",sWebLanguage) %></option>
		</select>
	<%
	}
	else if(checkString(invoice.getStatus()).equalsIgnoreCase("closed")){ %>
        <input class="button" type="button" name="buttonSignature" value='<%=getTranNoLink("Web.finance","signature",sWebLanguage)%>' onclick="doSign('<%=invoice.getUid()%>');">
		<input type='button' class='button' name='printInvoiceButton' value='<%=getTran(null,"web","print",sWebLanguage) %>' onclick='printInvoice("<%=invoice.getUid()%>");'/>
		<%=getTran(request,"web","invoiceformat",sWebLanguage) %>:
		<select name='invoicetype' id='invoicetype' class='text'>
			<option value='default'><%=getTran(request,"web","defaultmodel",sWebLanguage) %></option>
			<option value='MFPSummary'><%=getTran(request,"web","mfpmodel",sWebLanguage) %></option>
		</select>
	<%
	}
	if(sMessage.length()>0){
		out.println("<br/><hr/>"+sMessage);
	}
%>
