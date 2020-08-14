<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%=checkPermission(out,"system.permissions","select",activeUser)%>

<%
    out.print(ScreenHelper.writeTblHeader(getTran(request,"Web","Permissions",sWebLanguage),sCONTEXTPATH));
    int rowIdx = 0;

    out.print(
        writeTblChild("main.do?Page=permissions/profiles.jsp",getTran(request,"Web.UserProfile","UserProfile",sWebLanguage),rowIdx++)+
        writeTblChild("main.do?Page=permissions/searchProfile.jsp",getTran(request,"Web.UserProfile","usersPerProfile",sWebLanguage),rowIdx++)
    );

    if(activePatient!=null && activePatient.lastname!=null && activePatient.lastname.trim().length()>0){
        out.print(
            writeTblChild("main.do?Page=permissions/userpermission.jsp",getTran(request,"Web.Permissions","PermissionsFor",sWebLanguage)+" "+activePatient.lastname+" "+activePatient.firstname,rowIdx++)
        );
    }

    out.print(ScreenHelper.writeTblFooter());
%>