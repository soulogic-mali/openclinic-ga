<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%-- MEDICAL --%>
<%=ScreenHelper.writeTblHeader(getTran(request,"Web","medical",sWebLanguage),sCONTEXTPATH)
    +writeTblChild("main.do?Page=medical/managePrescriptions.jsp",getTran(request,"Web.Manage","managePrescriptions",sWebLanguage))
    +writeTblChild("main.do?Page=medical/manageDiagnosesPatient.jsp",getTran(request,"Web","manageDiagnosesPatient",sWebLanguage))
    +writeTblChild("main.do?Page=medical/manageDiagnosesPop.jsp",getTran(request,"Web","manageDiagnosesPop",sWebLanguage))
    +ScreenHelper.writeTblFooter()
%>