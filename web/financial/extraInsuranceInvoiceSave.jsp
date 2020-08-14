<%@ page import="be.mxs.common.util.system.HTMLEntities,java.util.*,be.openclinic.finance.InsurarInvoice" %>
<%@ page import="be.openclinic.finance.ExtraInsurarInvoice" %>
<%@ page import="be.openclinic.finance.Debet" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sEditInsurarInvoiceUID = checkString(request.getParameter("EditInsurarInvoiceUID"));
    String sEditDate = checkString(request.getParameter("EditDate"));
    String sEditInsurarUID = checkString(request.getParameter("EditInsurarUID"));
    String sEditInvoiceUID = checkString(request.getParameter("EditInvoiceUID"));
    String sEditStatus = checkString(request.getParameter("EditStatus"));
    String sEditBalance = checkString(request.getParameter("EditBalance"));
    String sEditCBs = checkString(request.getParameter("EditCBs"));
    String sEditNumber = checkString(request.getParameter("EditNumber"));

    ExtraInsurarInvoice insurarinvoice = new ExtraInsurarInvoice();
    insurarinvoice.setBalance(Double.parseDouble(sEditBalance));

    if (sEditInsurarInvoiceUID.length() > 0) {
        InsurarInvoice oldpatientinvoice = InsurarInvoice.get(sEditInsurarInvoiceUID);
        insurarinvoice.setCreateDateTime(oldpatientinvoice.getCreateDateTime());
    } else {
        insurarinvoice.setCreateDateTime(getSQLTime());
    }

    insurarinvoice.setStatus(sEditStatus);
    insurarinvoice.setInsurarUid(sEditInsurarUID);
    insurarinvoice.setInvoiceUid(sEditInvoiceUID);
    insurarinvoice.setDate(ScreenHelper.getSQLDate(sEditDate));
    insurarinvoice.setUid(sEditInsurarInvoiceUID);
    insurarinvoice.setUpdateDateTime(new java.util.Date());
    insurarinvoice.setUpdateUser(activeUser.userid);
    insurarinvoice.setNumber(sEditNumber);

    insurarinvoice.setDebets(new Vector());
    insurarinvoice.setCredits(new Vector());

    if (sEditCBs.length() > 0) {
        String[] aCBs = sEditCBs.split(",");
        String sID;
        for (int i = 0; i < aCBs.length; i++) {
            if (checkString(aCBs[i]).length() > 0) {
                Debet debet = new Debet();
                if (checkString(aCBs[i]).startsWith("d")) {
                    sID = aCBs[i].substring(1);
                    debet.setUid(sID);
                    insurarinvoice.getDebets().add(debet);
                } else if (checkString(aCBs[i]).startsWith("c")) {
                    sID = aCBs[i].substring(1);
                    insurarinvoice.getCredits().add(sID);
                }
            }
        }
    }

    String sMessage;
    if (insurarinvoice.store()) {
        sMessage = getTran(request,"web", "dataissaved", sWebLanguage);
    } else {
        sMessage = getTran(request,"web.control", "dberror", sWebLanguage);
    }
%>
{
"Message":"<%=HTMLEntities.htmlentities(sMessage)%>",
"EditInsurarInvoiceUID":"<%=insurarinvoice.getUid()%>",
"EditInvoiceUID":"<%=insurarinvoice.getInvoiceUid()%>"
}