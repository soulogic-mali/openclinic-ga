<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.hr.Career"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sCareerUid = checkString(request.getParameter("CareerUid"));
       
    /// DEBUG /////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n***************** deleteCareer.jsp *****************");
        Debug.println("sCareerUid : "+sCareerUid+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////

    
    boolean errorOccurred = Career.delete(sCareerUid);
    String sMessage = "";
    
    if(!errorOccurred){
        sMessage = getTran(request,"web","dataIsDeleted",sWebLanguage);
    }
    else{
        sMessage = getTran(request,"web","error",sWebLanguage);
    }
%>

{
  "message":"<%=HTMLEntities.htmlentities(sMessage)%>"
}