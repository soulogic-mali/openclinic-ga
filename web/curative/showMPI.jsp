<%@page import="be.mxs.common.util.db.*,net.admin.*,ca.uhn.fhir.rest.client.interceptor.*,ca.uhn.fhir.rest.gclient.*,java.util.*,be.hapi.*"%>
<%@page import="ca.uhn.fhir.context.*,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.Identifier.*,org.hl7.fhir.r4.model.Bundle.*,org.hl7.fhir.instance.model.api.*,ca.uhn.fhir.rest.client.api.*,ca.uhn.fhir.rest.api.*"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sMPIID = checkString((String)activePatient.adminextends.get("mpiid"));
	AdminPerson person = AdminPerson.getMPI(sMPIID);
	session.setAttribute("f_person", person);
%>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td class="tabs">&nbsp;</td>
            <td class="tabunselected" width="1%" onclick="activateMPITab('demographics')" id="td0" nowrap>&nbsp;<b><%=getTran(request,"web","demographics",sWebLanguage)%></b>&nbsp;</td>
            <td class="tabs">&nbsp;</td>
            <td class="tabunselected" width="1%" onclick="activateMPITab('identifiers')" id="td1" nowrap>&nbsp;<b><%=getTran(request,"Web","identifiers",sWebLanguage)%></b>&nbsp;</td>
            <td class="tabs" width="100%">&nbsp;</td>
        </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr id="MPI0-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("curative/showMPIDemographics.jsp"),pageContext);%></td>
        </tr>
        <tr id="MPI1-view" style="display:none">
            <td><%ScreenHelper.setIncludePage(customerInclude("curative/showMPIIdentifiers.jsp"),pageContext);%></td>
        </tr>
    </table>

<script>
	activateMPITab("demographics");
</script>
