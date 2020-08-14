<%@include file="/includes/validateUser.jsp"%>

<%-- TABS --%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabselected' width="1%" onclick="activateTab2(11)" id="td11" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","gasmetrics",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(12)" id="td12" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","respfunctests",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(13)" id="td13" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","observation",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(14)" id="td14" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","cardioresp",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='5'>&nbsp;</td>
        <td class='tabunselected' width="1%" onclick="activateTab2(15)" id="td15" nowrap>&nbsp;<b><%=getTran(request,"cnrkr","functioneval",sWebLanguage)%></b>&nbsp;</td>
        <td class='tabs' width='*'>&nbsp;</td>
    </tr>
</table>
<%-- HIDEABLE --%>

<table id="contentpane" style="vertical-align:top;" width="100%" border="0" cellspacing="0">
    <tr id="tr11-view" style="display:">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory_gasmetrics.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr12-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory_respfunctests.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr13-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory_observation.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr14-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory_cardioresp.jsp"),pageContext);%></td>
    </tr>
    <tr id="tr15-view" style="display:none">
        <td><%ScreenHelper.setIncludePage(customerInclude("healthrecord/manageCNRKRKineAssessmentRespiratory_functioneval.jsp"),pageContext);%></td>
    </tr>
</table>
