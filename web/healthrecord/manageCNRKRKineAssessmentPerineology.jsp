<%@include file="/includes/validateUser.jsp"%>

<%-- TABS --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabselected' width="1%" onclick="activateTab2(11)" id="td11" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","foodhabits",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(12)" id="td12" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","urinairy",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(13)" id="td13" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","gastroenterology",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(14)" id="td14" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","gynecology",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(15)" id="td15" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","morphostatic",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(16)" id="td16" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","abdominal",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(17)" id="td17" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","perineum",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(18)" id="td18" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","psychologic",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(19)" id="td19" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","functional",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='*'>&nbsp;</td>
    </tr>
</table>
<%-- HIDEABLE --%>

<table id="contentpane" style="vertical-align:top;" width="100%" border="0" cellspacing="0">
    <tr id="tr11-view" style="display:">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_foodhabits.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr12-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_urinary.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr13-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_gastroenterology.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr14-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_gynecology.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr15-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_morphostatic.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr16-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_abdominal.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr17-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_perineum.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr18-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_psychologic.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr19-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentPerineology_functional.jsp"),pageContext);%></td>
    </tr>
</table>
