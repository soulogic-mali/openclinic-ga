<%@include file="/includes/validateUser.jsp"%>

<%-- TABS --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabselected' width="1%" onclick="activateTab2(11)" id="td11" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","pain",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(12)" id="td12" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","morphostatic",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(13)" id="td13" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","dynamic",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(14)" id="td14" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","sensitive",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(15)" id="td15" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","muscular",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(16)" id="td16" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","specific",sWebLanguage)%></b>&nbsp;</td>
        <td width="*" class='tabs'>&nbsp;</td>
    </tr>
</table>
<%-- HIDEABLE --%>

<table id="contentpane" style="vertical-align:top;" width="100%" border="0" cellspacing="0">
    <tr id="tr11-view" style="display:">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_pain.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr12-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_morphostatic.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr13-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_dynamic.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr14-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_sensitive.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr15-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_muscular.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr16-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology_specific.jsp"),pageContext);%></td>
    </tr>
</table>
