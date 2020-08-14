<%@page import="be.openclinic.finance.*,
                java.text.DecimalFormat"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Balance balance = Balance.getActiveBalance(activePatient.personid);
	double saldo = Balance.getPatientBalance(activePatient.personid);
    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");
%>
<table width="100%" cellpadding="0" cellspacing="0">
    <tr class="admin" style='vertical-align: middle;'>
        <td nowrap width='40%'>
            <%=getTran(request,"curative","financial.status.title",sWebLanguage)%>&nbsp;
            <a href="<c:url value='/main.do'/>?Page=financial/editBalance.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_edit2.png'/>" class="link" title="<%=getTranNoLink("web","editBalance",sWebLanguage)%>" ></a>
            <a href="<c:url value='/main.do'/>?Page=financial/debetEdit.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_money2.png'/>" class="link" title="<%=getTranNoLink("web","debetEdit",sWebLanguage)%>" ></a>
            <a href="<c:url value='/main.do'/>?Page=financial/patientInvoiceEdit.jsp&ts=<%=getTs()%>"><img height='16px' style='vertical-align: middle' src="<c:url value='/_img/icons/icon_invoice.png'/>" class="link" title="<%=getTranNoLink("web.finance","patientinvoice",sWebLanguage)%>" ></a>
        </td>
        <td style='text-align: center' width='30%'>
	        <%if(saldo<balance.getMinimumBalance() && MedwanQuery.getInstance().getConfigInt("negativePatientBalanceAllowed",1)==0){%>
	        	<a href='javascript:newFastTransaction("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_PATIENTCREDITREQUEST");'><img height='36px' src="<c:url value='/_img/forbidden.jpg'/>"/></a></td><td nowrap><font style="vertical-align: middle; font-weight:bolder; font-size: 14px; color: #FF9A64">
	        <%}
	          else if(saldo<balance.getMinimumBalance()){%>
	        	<font style="color: #FF9A64">
	        <%} %>
	        <i style='white-space: nowrap;font-weight: normal'><%=getTran(request,"balance","balance",sWebLanguage)%></i>
	        <br/><%=new DecimalFormat("#0.00").format(saldo)+"&nbsp;"+sCurrency%>
	        <%if(saldo<balance.getMinimumBalance()){%>
	        	</font>
	        <%}%>
        </td>
        <td style='text-align: center'><i style='white-space: nowrap;font-weight: normal'><%=getTran(request,"balance","out_of_balance_since",sWebLanguage)%></i>
        <br/>&nbsp;<%=ScreenHelper.getSQLDate(balance.getCreateDateTime(),new java.util.Date())%></td>
    </tr>
    
    <%
    	if(MedwanQuery.getInstance().getConfigInt("enableFinancialStatusPrestations",1)==1){
		    %>
			    <tr class="gray">
			    	<td colspan="3"><b><%=getTran(request,"web","deliveries.in.last.24.hours",sWebLanguage)%></b></td>
			    </tr>
		   	<%

	   		Vector debets = Debet.getPatientDebetPrestations(activePatient.personid,ScreenHelper.formatDate(new java.util.Date()),"","","");
	   		int n=0;
	   		for(;n<debets.size();n++){
	   			if(n%3==0){
	   				if(n>0){
	   	   				out.print("</tr>");
	   				}
	   				out.print("<tr>");
	   			}
	   			
	   			String[] debet = ((String)debets.elementAt(n)).split(";");
	   			String waive="";
	   			if(activeUser.getAccessRight("financial.waivehealthservice.select")){
		   			if(debet.length>1 && debet[1].length()>0 && MedwanQuery.getInstance().getConfigString("waivableInvoiceGroups","cons").toLowerCase().indexOf(debet[1].toLowerCase())>-1){
		   				Debet debetObject = Debet.get(MedwanQuery.getInstance().getConfigString("serverId")+"."+debet[2]);
		   				if(debetObject!=null && debetObject.getAmount()>0){
		   					Encounter encounter = debetObject.getEncounter();
		   					if(encounter!=null && encounter.getService()!=null && !encounter.getService().code3.equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("privateServiceType","privateclinic"))){
		   		   				waive="<img src='"+sCONTEXTPATH+"\\_img\\icons\\icon_free.gif' onclick='doWaive("+debet[2]+",\""+debet[0]+"\")'/>";
		   					}
		   				}
		   			}
	   			}
	   			out.print("<td>"+waive+debet[0]+"</td>");
	   		}
	   		
			if(n>0){
				out.print("</tr>");
			}
    	}
   	%>
</table>

<script>
	function doWaive(debetObjectId,debetName){
	    openPopup("/financial/waiveDebet.jsp&uid=<%=MedwanQuery.getInstance().getConfigString("serverId")%>."+debetObjectId+"&ts=<%=getTs()%>",300,300);
	}
</script>