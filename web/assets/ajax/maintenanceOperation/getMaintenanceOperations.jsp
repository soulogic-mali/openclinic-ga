<%@page import="be.openclinic.assets.*,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>

<%!
    private Hashtable planNames = new Hashtable();

    //--- GET PLANNAME ----------------------------------------------------------------------------
    private String getPlanName(String sPlanUID){
        String sPlanName = "";
        
        sPlanName = ScreenHelper.checkString((String)planNames.get(sPlanUID));
        if(sPlanName.length()==0){
            sPlanName = getPlanNameFromDB(sPlanUID); 
                    
            // add to hash for future use
            planNames.put(sPlanUID,sPlanName);
        }
        
        return sPlanName;
    }
    
    //--- GET PLANNAME FROM DB --------------------------------------------------------------------
    private String getPlanNameFromDB(String sPlanUID){
    	if(sPlanUID.length() > 0){
            return ScreenHelper.checkString(MaintenancePlan.getName(sPlanUID));
    	}
    	else{
    		return "";
    	}
    }
%>

<%
    // search-criteria
    String sPlanUID  = checkString(request.getParameter("planUID")), // to obtain plan-name
           sOperator = checkString(request.getParameter("operator")),
           sAssetUID = checkString(request.getParameter("assetuid")),
           sServiceUID = checkString(request.getParameter("serviceuid")),
           sResult   = checkString(request.getParameter("result"));


    // extra searchcriteria
    String sPeriodPerformedBegin = ScreenHelper.checkString(request.getParameter("periodPerformedBegin")),
           sPeriodPerformedEnd   = ScreenHelper.checkString(request.getParameter("periodPerformedEnd"));


    /// DEBUG ///////////////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********** assets/ajax/maintenanceOperation/getMaintenanceOperations.jsp *********");
        Debug.println("sPlanUID  : "+sPlanUID);
        Debug.println("sOperator : "+sOperator);
        Debug.println("sAssetUID : "+sAssetUID);
        Debug.println("sResult   : "+sResult+"\n");

        // extra searchcriteria
        Debug.println("sPeriodPerformedBegin : "+sPeriodPerformedBegin);
        Debug.println("sPeriodPerformedEnd   : "+sPeriodPerformedEnd+"\n");
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////

    // compose object to pass search criteria with
    MaintenanceOperation findObject = new MaintenanceOperation();
    findObject.maintenanceplanUID = sPlanUID;
    findObject.operator = sOperator;
    findObject.result = sResult;
    findObject.setTag(sAssetUID+";"+sServiceUID);

    List operations = MaintenanceOperation.getList(findObject);
    String sReturn = "";
    
    if(operations.size() > 0){
        Hashtable hSort = new Hashtable();
        MaintenanceOperation operation;
    
        // sort on supplier.code
        for(int i=0; i<operations.size(); i++){
            operation = (MaintenanceOperation)operations.get(i);

            String sPlanName = getPlanName(operation.maintenanceplanUID);
            String nomenclature="";
            MaintenancePlan plan = operation.getMaintenancePlan();
    		boolean bLocked = operation.getObjectId()>-1 && ((operation.getLockedBy()>-1 && operation.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (operation.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
			Debug.println("bLocked for objectid "+operation.getObjectId()+" = "+bLocked);
			Debug.println("operation.getObjectId()>-1 "+(operation.getObjectId()>-1));
			Debug.println("(operation.getLockedBy()>-1 && operation.getLockedBy()!=MedwanQuery.getInstance().getConfigInt('GMAOLocalServerId',-1)) "+(operation.getLockedBy()>-1 && operation.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)));
			Debug.println("(operation.getLockedBy()==-1) "+(operation.getLockedBy()==-1));
			Debug.println("(MedwanQuery.getInstance().getConfigInt('GMAOLocalServerId',-1)!=0) "+(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
			
    		boolean bAuthorized=true;
            if(plan!=null){
            	nomenclature=plan.getAssetCode()+" - "+getTranNoLink("admin.nomenclature.asset",plan.getAssetNomenclature(),sWebLanguage);
                Asset asset=plan.getAsset();
                if(asset!=null){
    	            bAuthorized=asset.isAuthorizedUser(activeUser.userid);
    	            if(!bAuthorized && !activeUser.isAdmin()){
    	            	continue;
    	            }
                }
            }
            
            hSort.put(operation.maintenanceplanUID+"="+operation.getUid(),
                      " onclick=\"displayMaintenanceOperation('"+operation.getUid()+"');\">"+
               		  "<td class='hand'><img src='"+sCONTEXTPATH+"/_img/icons/icon_"+(bLocked?"locked":"unlocked")+".png'/></td>"+
                      "<td class='hand' style='padding-left:5px'>["+operation.getUid()+"]</td>"+
                      "<td class='hand' style='padding-left:5px'>"+nomenclature+(!bAuthorized?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
                      "<td class='hand' style='padding-left:5px'>["+operation.maintenanceplanUID+"] "+sPlanName+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+ScreenHelper.stdDateFormat.format(operation.date)+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+operation.operator+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+getTranNoLink("assets.maintenanceoperations.result",operation.result,sWebLanguage)+"</td>"+
                     "</tr>");
        }
    
        Vector keys = new Vector(hSort.keySet());
        Collections.sort(keys);
        Iterator iter = keys.iterator();
        String sClass = "1";
        
        while(iter.hasNext()){
            // alternate row-style
            if(sClass.length()==0) sClass = "1";
            else                   sClass = "";
            
            sReturn+= "<tr class='list"+sClass+"' "+hSort.get(iter.next());
        }
    }
    else{
        sReturn = "<td colspan='4'>"+getTran(request,"web","noRecordsFound",sWebLanguage)+"</td>";
    }
%>

<%
    if(operations.size() > 0){
        %>
<table width="100%" class="sortable" id="searchresults" cellspacing="1" style="border:none;">
    <%-- header --%>
    <tr class="admin" style="padding-left:1px;">    
    	<td/>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","operation",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","nomenclature",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","maintenancePlan",sWebLanguage))%></td>
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web.assets","date",sWebLanguage))%></asc></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","operator",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","result",sWebLanguage))%></td>
    </tr>
    
    <tbody class="hand"><%=sReturn%></tbody>
</table> 

&nbsp;<i><%=operations.size()+" "+getTran(request,"web","recordsFound",sWebLanguage)%></i>
        <%
    }
    else{
        %><%=sReturn%><%
    }
%>