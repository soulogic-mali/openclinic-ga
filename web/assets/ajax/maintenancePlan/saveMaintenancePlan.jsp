<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.MaintenancePlan,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String sEditPlanUID = checkString(request.getParameter("EditPlanUID"));

    String sName           = ScreenHelper.checkString(request.getParameter("name")),
           sAssetUID       = ScreenHelper.checkString(request.getParameter("assetUID")),
           sStartDate      = ScreenHelper.checkString(request.getParameter("startDate")),
           sEndDate        = ScreenHelper.checkString(request.getParameter("endDate")),
           sFrequency      = ScreenHelper.checkString(request.getParameter("frequency")),
           sOperator       = ScreenHelper.checkString(request.getParameter("operator")),
           sType       	   = ScreenHelper.checkString(request.getParameter("type")),
           sComment1            = checkString(request.getParameter("comment1")),
           sComment2            = checkString(request.getParameter("comment2")),
           sComment3            = checkString(request.getParameter("comment3")),
           sComment4            = checkString(request.getParameter("comment4")),
           sComment5            = checkString(request.getParameter("comment5")),
           sComment6            = checkString(request.getParameter("comment6")),
           sComment7            = checkString(request.getParameter("comment7")),
           sComment8            = checkString(request.getParameter("comment8")),
           sComment9            = checkString(request.getParameter("comment9")),
           sComment10            = checkString(request.getParameter("comment10")),
           sLockedBy            = checkString(request.getParameter("lockedby")),
           sPlanManager    = ScreenHelper.checkString(request.getParameter("planManager")),
           sInstructions   = ScreenHelper.checkString(request.getParameter("instructions"));

    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********* assets/ajax/maintenancePlan/saveMaintenanceplan.jsp *********");
        Debug.println("sEditPlanUID  : "+sEditPlanUID);
        Debug.println("sAssetUID     : "+sAssetUID);
        Debug.println("sStartDate    : "+sStartDate);
        Debug.println("sEndDate      : "+sEndDate);
        Debug.println("sFrequency    : "+sFrequency);
        Debug.println("sOperator     : "+sOperator);
        Debug.println("sPlanManager  : "+sPlanManager);
        Debug.println("sType		 : "+sType);
        Debug.println("sComment1          : "+sComment1);
        Debug.println("sComment2          : "+sComment2);
        Debug.println("sComment3          : "+sComment3);
        Debug.println("sComment4          : "+sComment4);
        Debug.println("sComment5          : "+sComment5);
        Debug.println("sComment6          : "+sComment6);
        Debug.println("sComment7          : "+sComment7);
        Debug.println("sComment8          : "+sComment8);
        Debug.println("sComment9          : "+sComment9);
        Debug.println("sComment10          : "+sComment10);
        Debug.println("sInstructions : "+sInstructions+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////


    MaintenancePlan plan = new MaintenancePlan();
    String sMessage = "";
    
    if(sEditPlanUID.length() > 0){
        plan.setUid(sEditPlanUID);
    }
    else{
        plan.setUid("-1");
        plan.setCreateDateTime(getSQLTime());
    }

    plan.name = sName;
    plan.assetUID = sAssetUID;
    
    // startDate
    if(sStartDate.length() > 0){
        plan.startDate = ScreenHelper.parseDate(sStartDate);
    }
    else{
    	plan.startDate=null;
    }
    // endDate
    if(sEndDate.length() > 0){
        plan.endDate = ScreenHelper.parseDate(sEndDate);
    }
    else{
    	plan.endDate=null;
    }
    try{
    	plan.lockedBy=Integer.parseInt(sLockedBy);
    }
    catch(Exception e){
    	plan.lockedBy=-1;
    }

    plan.frequency = sFrequency;
    plan.operator = sOperator;
    plan.planManager = sPlanManager;
    plan.instructions = sInstructions;
    plan.setType(sType);
    plan.setComment1(sComment1);
    plan.setComment2(sComment2);
    plan.setComment3(sComment3);
    plan.setComment4(sComment4);
    plan.setComment5(sComment5);
    plan.setComment6(sComment6);
    plan.setComment7(sComment7);
    plan.setComment8(sComment8);
    plan.setComment9(sComment9);
    plan.setComment10(sComment10);

    plan.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
    plan.setUpdateUser(activeUser.userid);
    
    boolean errorOccurred = plan.store(activeUser.userid);
    
    if(!errorOccurred){
        sMessage = "<font color='green'>"+getTranNoLink("web","dataIsSaved",sWebLanguage)+"</font>";
    }
    else{
        sMessage = "<font color='red'>"+getTranNoLink("web","error",sWebLanguage)+"</font>";
    }
%>

{
  "message":"<%=HTMLEntities.htmlentities(sMessage)%>",
  "newUID":"<%=plan.getUid()%>"
}