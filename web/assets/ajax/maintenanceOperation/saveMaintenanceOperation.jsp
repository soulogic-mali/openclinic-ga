<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.MaintenanceOperation,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sEditOperationUID = checkString(request.getParameter("EditOperationUID"));

    String sMaintenancePlanUID = ScreenHelper.checkString(request.getParameter("maintenancePlanUID")),
           sDate               = ScreenHelper.checkString(request.getParameter("date")),
           sOperator           = ScreenHelper.checkString(request.getParameter("operator")),
           sSupplier           = ScreenHelper.checkString(request.getParameter("supplier")),
           sResult             = ScreenHelper.checkString(request.getParameter("result")),
           sComment            = ScreenHelper.checkString(request.getParameter("comment")),
           sComment1            = ScreenHelper.checkString(request.getParameter("comment1")),
           sComment2            = ScreenHelper.checkString(request.getParameter("comment2")),
           sComment3            = ScreenHelper.checkString(request.getParameter("comment3")),
           sComment4            = ScreenHelper.checkString(request.getParameter("comment4")),
           sComment5            = ScreenHelper.checkString(request.getParameter("comment5")),
           sLockedBy            = checkString(request.getParameter("lockedby")),
           sNextDate           = ScreenHelper.checkString(request.getParameter("nextDate"));
        
    
    /// DEBUG ///////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********** assets/ajax/maintenanceOperation/saveMaintenanceOperation.jsp *********");
        Debug.println("sEditOperationUID     : "+sEditOperationUID);
        Debug.println("sMaintenancePlanUID   : "+sMaintenancePlanUID);
        Debug.println("sDate                 : "+sDate);
        Debug.println("sOperator             : "+sOperator);
        Debug.println("sSupplier             : "+sSupplier);
        Debug.println("sResult               : "+sResult);
        Debug.println("sComment              : "+sComment);
        Debug.println("sNextDate             : "+sNextDate+"\n");
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////


    MaintenanceOperation operation = new MaintenanceOperation();
    String sMessage = "";
    
    if(sEditOperationUID.length() > 0){
        operation.setUid(sEditOperationUID);
    }
    else{
        operation.setUid("-1");
        operation.setCreateDateTime(getSQLTime());
    }

    operation.maintenanceplanUID = sMaintenancePlanUID;
    
    // date
    if(sDate.length() > 0){
        operation.date = ScreenHelper.stdDateFormat.parse(sDate);
    }
    try{
    	operation.lockedBy=Integer.parseInt(sLockedBy);
    }
    catch(Exception e){
    	operation.lockedBy=-1;
    }

    operation.operator = sOperator;
    operation.result = sResult;
    operation.comment = sComment;
    operation.comment1 = sComment1;
    operation.comment2 = sComment2;
    operation.comment3 = sComment3;
    operation.comment4 = sComment4;
    operation.comment5 = sComment5;
    operation.supplier = sSupplier;
    
    // nextDate
    if(sNextDate.length() > 0){
        operation.nextDate = ScreenHelper.stdDateFormat.parse(sNextDate);
    }

    operation.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
    operation.setUpdateUser(activeUser.userid);
    
    boolean errorOccurred = operation.store(activeUser.userid);
    
    if(!errorOccurred){
        sMessage = "<font color='green'>"+getTranNoLink("web","dataIsSaved",sWebLanguage)+"</font>";
    }
    else{
        sMessage = "<font color='red'>"+getTranNoLink("web","error",sWebLanguage)+"</font>";
    }
%>

{
  "message":"<%=HTMLEntities.htmlentities(sMessage)%>",
  "newUID":"<%=operation.getUid()%>"
}