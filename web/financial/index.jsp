<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=ScreenHelper.writeTblHeader(getTran(request,"web","financial",sWebLanguage),sCONTEXTPATH)
    +writeTblChild("main.do?Page=financial/managePrestations.jsp",getTran(request,"Web.manage","managePrestations",sWebLanguage))
    +writeTblChild("main.do?Page=financial/managePrestationGroups.jsp",getTran(request,"Web.manage","managePrestationGroups",sWebLanguage))
    +writeTblChild("main.do?Page=financial/manageBalances.jsp",getTran(request,"Web.manage","manageBalances",sWebLanguage))
    +writeTblChild("main.do?Page=financial/wicket/wicketOverview.jsp",getTran(request,"wicket","wicketoverview",sWebLanguage))
    +ScreenHelper.writeTblFooter()
%>