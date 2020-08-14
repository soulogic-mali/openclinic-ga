<%@page import="java.text.DecimalFormat,
                be.openclinic.finance.PatientInvoice,
                be.openclinic.finance.Balance"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    double balance = Balance.getPatientBalance(activePatient.personid);
    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency", "€");
%>
<table width="100%" cellpadding="0" cellspacing="0" class="list">
    <tr class="admin">
        <td width="200">
            <%=getTran(request,"financial","financial.status",sWebLanguage)%>
        </td>
        <td <%=balance<0?" class='letterred'":""%>>
            <%=getTran(request,"balance","balance",sWebLanguage)%>:&nbsp;<%=new DecimalFormat("#0.00").format(balance)+" "+sCurrency%>
        </td>
    </tr>
</table>