<%@include file="/includes/validateUser.jsp"%>

<%-- TABS --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabselected' width="1%" onclick="activateTab2(11)" id="td11" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","observation",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(12)" id="td12" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","orthopedic",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(13)" id="td13" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","articular",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(14)" id="td14" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","muscular",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(15)" id="td15" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","postural",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(16)" id="td16" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","reflexes",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(17)" id="td17" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","functional",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(18)" id="td18" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","sensitivity",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(19)" id="td19" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","associatedproblems",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='*'>&nbsp;</td>
    </tr>
</table>
<%-- HIDEABLE --%>

<table id="contentpane" style="vertical-align:top;" width="100%" border="0" cellspacing="0">
    <tr id="tr11-view" style="display:">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_observation.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr12-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology2_orthopedic.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr13-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentReumatology2_articular.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr14-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_muscular.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr15-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_postural.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr16-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_reflexes.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr17-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_functional.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr18-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_sensitivity.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr19-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentNeurologyChild_associatedproblems.jsp"),pageContext);%></td>
    </tr>
</table>
