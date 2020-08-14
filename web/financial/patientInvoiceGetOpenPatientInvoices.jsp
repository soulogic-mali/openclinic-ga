<%@ page import="be.openclinic.finance.PatientInvoice,java.util.*,be.mxs.common.util.system.HTMLEntities" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency", "€");
    String sPatientId = checkString(request.getParameter("PatientId"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n########## financial/patientInvoiceGetOpenPatientInvoices.jsp ##########");
        Debug.println("sCurrency  : "+sCurrency);
        Debug.println("sPatientId : "+sPatientId+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    Vector vOpenPatientInvoices = PatientInvoice.getPatientInvoicesWhereDifferentStatus(sPatientId, "'closed','canceled'");
    String sReturn = "";
    Hashtable hSort = new Hashtable();
    PatientInvoice patientinvoice;

    for(int i=0; i<vOpenPatientInvoices.size(); i++){
        patientinvoice = (PatientInvoice)vOpenPatientInvoices.elementAt(i);

        if (patientinvoice!=null){
            hSort.put(patientinvoice.getDate().getTime()+"="+patientinvoice.getUid()," onclick=\"setPatientInvoice('"+patientinvoice.getUid().split("\\.")[1]+"');\">"
                 +"<td class='hand'>&nbsp;"+ScreenHelper.getSQLDate(patientinvoice.getDate())+"</td>"
                 +"<td class='hand'>&nbsp;"+patientinvoice.getUid().split("\\.")[1]+"</td>"
                 +"<td class='hand' style='text-align:right;'>"+patientinvoice.getBalance()+"&nbsp;</td>"
                 +"<td class='hand'>&nbsp;"+getTran(request,"finance.patientinvoice.status",patientinvoice.getStatus(),sWebLanguage)+"</td></tr>");
        }
    }

    Vector keys = new Vector(hSort.keySet());
    Collections.sort(keys);
    Collections.reverse(keys);
    Iterator it = keys.iterator();
    String sClass = "";
    while(it.hasNext()){
        if(sClass.equals("")) sClass = "1";
        else                  sClass = "";
        
        sReturn+= "<tr class='list"+sClass+ "' "+hSort.get(it.next());
    }
%>
<table id="searchresults" width="100%" cellspacing="0">
    <tr class="admin">
        <td width="100" nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","date",sWebLanguage))%></td>
        <td width="120" nowrap><%=HTMLEntities.htmlentities(getTran(request,"web", "invoicenumber", sWebLanguage))%></td>
        <td width="150" nowrap style="text-align:right;"><%=HTMLEntities.htmlentities(getTran(request,"web","balance",sWebLanguage))%>&nbsp;<%=sCurrency%></td>
        <td><%=HTMLEntities.htmlentities(getTran(request,"Web.finance","patientinvoice.status",sWebLanguage))%></td>
    </tr>
    <tbody class="hand">
        <%=sReturn%>
    </tbody>
</table>