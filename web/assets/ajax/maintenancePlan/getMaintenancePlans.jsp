<%@page import="be.openclinic.assets.MaintenancePlan,
                be.openclinic.assets.Asset,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>

<%!
    private Hashtable assetCodes = new Hashtable();

    //--- GET ASSETCODE ---------------------------------------------------------------------------
    private String getAssetCode(String sAssetUID){
        String sAssetCode = ScreenHelper.checkString((String)assetCodes.get(sAssetUID));
        
        if(sAssetCode.length()==0){
            sAssetCode = getAssetCodeFromDB(sAssetUID); 
                    
            // add to hash for future use
            assetCodes.put(sAssetUID,sAssetCode);
        }
        
        return sAssetCode;
    }
    
    //--- GET ASSETCODE FROM DB -------------------------------------------------------------------
    private String getAssetCodeFromDB(String sAssetUID){
        return ScreenHelper.checkString(Asset.getCode(sAssetUID));
    }
%>

<%
    // search-criteria
    String sName     = checkString(request.getParameter("name")),
           sAssetUID = checkString(request.getParameter("assetUID")),
           sType	 = checkString(request.getParameter("type")),
           sShowInactive        = checkString(request.getParameter("showinactive")),
           sServiceUid	 = checkString(request.getParameter("serviceuid")),
           sOperator = checkString(request.getParameter("operator"));


    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********** assets/ajax/maintenancePlan/getMaintenancePlans.jsp *********");
        Debug.println("sName     : "+sName);
        Debug.println("sAssetUID : "+sAssetUID);
        Debug.println("sShowInactive : "+sShowInactive);
        Debug.println("sServiceUid : "+sServiceUid);
        Debug.println("sType	 : "+sType);
        Debug.println("sOperator : "+sOperator+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // compose object to pass search criteria with
    MaintenancePlan findObject = new MaintenancePlan();
    findObject.name = sName;
    findObject.assetUID = sAssetUID;
    findObject.operator = sOperator;
    findObject.type 	= sType;
    findObject.setTag(sServiceUid);

    List plans = MaintenancePlan.getList(findObject);
    String sReturn = "";
    int nAccessible=0,nActive=0;
    
    if(plans.size() > 0){
        Hashtable hSort = new Hashtable();
        MaintenancePlan plan;
    
        // sort on plans.code
        for(int i=0; i<plans.size(); i++){
            plan = (MaintenancePlan)plans.get(i);
            Asset asset=plan.getAsset();
            boolean bCanContinue=true;
            if(sShowInactive.equalsIgnoreCase("false") && plan.isInactive()){
            	bCanContinue=false;
            }
            if(!plan.isInactive()){
            	nActive++;
            }
    		boolean bLocked = plan.getObjectId()>-1 && ((plan.getLockedBy()>-1 && plan.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (plan.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
            boolean bAuthorized=true;
            if(asset!=null){
	            bAuthorized=asset.isAuthorizedUser(activeUser.userid);
	            if(!bAuthorized && !activeUser.isAdmin()){
	            	bCanContinue=false;
	            }
	            else{
	            	nAccessible++;
	            }
            }
            
            if(!bCanContinue){
            	continue;
            }
            
            String sOverdue="";
            if(plan.isOverdue()){
            	sOverdue=" <img height='14' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>";
            }
            hSort.put(plan.name+"="+plan.getUid(),
                      " onclick=\"displayMaintenancePlan('"+plan.getUid()+"');\">"+
               		  "<td class='hand'><img src='"+sCONTEXTPATH+"/_img/icons/icon_"+(bLocked?"locked":"unlocked")+".png'/></td>"+
                      "<td class='hand' style='padding-left:5px'>["+plan.assetUID+"] "+getAssetCode(plan.assetUID)+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+getTranNoLink("admin.nomenclature.asset",checkString(plan.getAssetNomenclature()),sWebLanguage)+(!bAuthorized?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+(plan.getAsset()==null?"":"<i>"+plan.getAsset().getServiceuid().toUpperCase()+"</i> - <b>"+getTranNoLink("service",checkString(plan.getAsset().getServiceuid()),sWebLanguage))+"</b></td>"+
                      "<td class='hand' style='padding-left:5px'>"+getTranNoLink("maintenanceplan.type",checkString(plan.getType()),sWebLanguage)+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+checkString(plan.getName())+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+checkString(plan.getComment10()).split(" ")[0]+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+(plan.startDate!=null?ScreenHelper.stdDateFormat.format(plan.startDate):"")+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+getTran(request,"maintenanceplan.frequency",plan.frequency,sWebLanguage)+"</td>"+
                      "<td class='hand' style='padding-left:5px'>"+ScreenHelper.formatDate(plan.getNextOperationDate())+sOverdue+"</td>"+
                      (sShowInactive.equalsIgnoreCase("true")?"<td class='hand'>"+ScreenHelper.formatDate(plan.getEndDate())+"</td>":"")+
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
        sReturn = "<td colspan='6'>"+getTran(request,"web","noRecordsFound",sWebLanguage)+"</td>";
    }
%>

<%
    if(plans.size() > 0){
        %>
<table width="100%" class="sortable" id="searchresults" cellspacing="1" style="border:none;">
    <%-- header --%>
    <tr class="admin" style="padding-left:1px;">    
		<td/>
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web.assets","asset",sWebLanguage))%></asc></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","nomenclature",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","service",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","type",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","name",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","created",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","startDate",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","frequency",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","nextMaintenanceDate",sWebLanguage))%></td>
        <%
        	if(sShowInactive.equalsIgnoreCase("true")){
        %>
		        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","endDate",sWebLanguage))%></td>
        <%
        	}
        %>
    </tr>
    
    <tbody class="hand"><%=sReturn%></tbody>
</table> 
<table width='100%'>
    <tr><td><hr/></td></tr>
</table>
&nbsp;<i><b><%=plans.size()+"</b> "+getTran(request,"web","recordsFound",sWebLanguage)%>, <b><%=nActive %></b> <%=getTran(request,"web","active",sWebLanguage)%>, <b><%=nAccessible%></b> <%=getTran(request,"web","accessiblefor",sWebLanguage)+" "+activeUser.person.getFullName()%></i>
        <%
    }
    else{
        %><%=sReturn%><%
    }
%>