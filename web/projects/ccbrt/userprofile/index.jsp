<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<% int rowIdx = 0; %>
<%=
 (
    ScreenHelper.writeTblHeader(getTran(request,"Web","MyProfile",sWebLanguage),sCONTEXTPATH)
    +writeTblChild("main.do?Page=userprofile/changepassword.jsp",getTran(request,"Web.UserProfile","ChangePassword",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changedefaultpage.jsp",getTran(request,"Web.UserProfile","ChangeDefaultPage",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changedefaultfocus.jsp",getTran(request,"Web.UserProfile","Change",sWebLanguage)+" "+getTran(request,"Web.UserProfile","Focus",sWebLanguage).toLowerCase(),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changetimeout.jsp",getTran(request,"Web.UserProfile","Change",sWebLanguage)+" "+getTran(request,"Web.UserProfile","timeout",sWebLanguage).toLowerCase(),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changeservice.jsp",getTran(request,"Web.UserProfile","ChangeService",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changelanguage.jsp",getTran(request,"Web.UserProfile","ChangeLanguage",sWebLanguage),rowIdx++)
    //+writeTblChild("main.do?Page=userprofile/manageExaminations.jsp",getTranNoLink("Web.UserProfile","ManageExaminations",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/managePlanning.jsp",getTranNoLink("Web.UserProfile","ManagePlanning",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=system/manageQuickList.jsp&UserQuickList=1",getTran(request,"Web.UserProfile","ManageQuickList",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=system/manageQuickLabList.jsp&UserQuickLabList=1",getTran(request,"Web.UserProfile","ManageQuickLabList",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=system/manageShortcuts.jsp&UserQuickList=1",getTran(request,"Web.UserProfile","manage.contact.shortcuts",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/manageUserShortcuts.jsp",getTran(request,"web.userProfile","manage.general.shortcuts",sWebLanguage),rowIdx++)
    +writeTblChild("main.do?Page=userprofile/changeTheme.jsp",getTran(request,"web.userProfile","changeTheme",sWebLanguage),rowIdx++)
    +ScreenHelper.writeTblFooter()
 )
%>
