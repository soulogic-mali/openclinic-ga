<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=ScreenHelper.writeTblHeader(getTran(request,"web","adt",sWebLanguage),sCONTEXTPATH)
    +writeTblChild("main.do?Page=adt/manageBeds.jsp",getTran(request,"Web.manage","manageBeds",sWebLanguage))
    //+writeTblChild("main.do?Page=adt/manageEncounters.jsp",getTran(request,"Web.manage","manageEncounters",sWebLanguage))todo update manageEncounters.jsp to current version
    +ScreenHelper.writeTblFooter()
%>