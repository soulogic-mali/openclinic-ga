<%@ page import="java.util.Vector" %>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<table width="100%" class="list" cellspacing="1" id="tblInformation">
    <%
        String sServiceID = checkString(request.getParameter("ServiceID")).toUpperCase();

        if (sServiceID.length() > 0) {
            Service service = Service.getService(sServiceID);

            if (service != null) {
                // translate country code
                String sCountry = service.country;
                if (sCountry.length() > 0) {
                    sCountry = getTran(request,"Country", sCountry, sWebLanguage);
                }

                // header with service ans its parents
                String sServiceLabel = getTran(request,"Service", sServiceID, sWebLanguage);
                Vector serviceParents = Service.getParentIds(sServiceID);
                String sParentServiceID;
                String arrow = "<img src='" + sCONTEXTPATH + "/_img/themes/default/pijl.gif'/>&nbsp;";
                for (int i = serviceParents.size() - 1; i >= 0; i--) {
                    sParentServiceID = (String) serviceParents.get(i);
                    sServiceLabel = getTran(request,"Service", sParentServiceID, sWebLanguage) + "&nbsp;" + arrow + sServiceLabel;
                }

    %>
    <tr class='admin'>
        <td colspan='2'>&nbsp;<%=sServiceLabel%>
        </td>
    </tr>
    <%

        out.print(setRow(request,"Web", "Address", checkString(service.address), sWebLanguage) +
                setRow(request,"Web", "zipcode", checkString(service.zipcode), sWebLanguage) +
                setRow(request,"Web", "city", checkString(service.city), sWebLanguage) +
                setRow(request,"Web", "country", sCountry, sWebLanguage) +
                setRow(request,"Web", "telephone", checkString(service.telephone), sWebLanguage) +
                setRow(request,"Web", "fax", checkString(service.fax), sWebLanguage) +
                setRow(request,"Web", "contract", checkString(service.contract), sWebLanguage) +
                setRow(request,"Web", "contracttype", checkString(service.contracttype), sWebLanguage) +
                setRow(request,"Web", "contactperson", checkString(service.contactperson), sWebLanguage) +
                setRow(request,"Web", "comment", checkString(service.comment), sWebLanguage));

    %>
    <tr height="1">
        <td width="30%"></td>
    </tr>
    <%
            }
        }
    %>
</table>

<br>

<%-- BUTTON --%>
<center>
    <input type="button" class="button" name="buttonclose" value='<%=getTranNoLink("Web","Close",sWebLanguage)%>'
           onclick='window.close()'>
</center>

<script>
    window.resizeTo(550, ((parseInt(document.getElementsByName('tblInformation')[0].rows.length) - 1) * 27) + 100);
</script>
