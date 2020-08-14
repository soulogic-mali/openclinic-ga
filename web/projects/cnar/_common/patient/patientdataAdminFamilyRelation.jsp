<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%-- MAIN TABLE ----------------------------------------------------------------------------------%>
<table width='100%' cellspacing="1" class="list">
    <%=(
            setRow(request,"Web","fathername",checkString((String)activePatient.adminextends.get("fathername")),sWebLanguage)
            +setRow(request,"Web","fatherprofession",checkString((String)activePatient.adminextends.get("fatherprofession")),sWebLanguage)
            +setRow(request,"Web","fatheremployer",checkString((String)activePatient.adminextends.get("fatheremployer")),sWebLanguage)
            +setRow(request,"Web","mothername",checkString((String)activePatient.adminextends.get("mothername")),sWebLanguage)
            +setRow(request,"Web","motherprofession",checkString((String)activePatient.adminextends.get("motherprofession")),sWebLanguage)
            +setRow(request,"Web","motheremployer",checkString((String)activePatient.adminextends.get("motheremployer")),sWebLanguage)
            +setRow(request,"Web","spousename",checkString((String)activePatient.adminextends.get("spousename")),sWebLanguage)
            +setRow(request,"Web","spouseprofession",checkString((String)activePatient.adminextends.get("spouseprofession")),sWebLanguage)
            +setRow(request,"Web","spouseemployer",checkString((String)activePatient.adminextends.get("spouseemployer")),sWebLanguage)
        )
    %>
    <tr height='1'><td width='<%=sTDAdminWidth%>'/></tr>
</table>
