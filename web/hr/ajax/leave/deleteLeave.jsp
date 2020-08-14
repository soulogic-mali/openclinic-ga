<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.hr.Leave"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sLeaveUid = checkString(request.getParameter("LeaveUid"));
       
    /// DEBUG /////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n***************** deleteLeave.jsp *****************");
        Debug.println("sLeaveUid : "+sLeaveUid+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////

    
    boolean errorOccurred = Leave.delete(sLeaveUid);
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