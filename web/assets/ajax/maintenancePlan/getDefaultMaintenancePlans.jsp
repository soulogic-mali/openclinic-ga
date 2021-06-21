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
<table width="100%" class="sortable" id="searchresults" cellspacing="1" style="border:none;">
<%
    // search-criteria
    String sName     = checkString(request.getParameter("name")),
           sNomenclature = checkString(request.getParameter("nomenclature")),
           sType	 = checkString(request.getParameter("type"));


    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********** assets/ajax/maintenancePlan/getMaintenancePlans.jsp *********");
        Debug.println("sNomenclature     : "+sNomenclature);
        Debug.println("sName     : "+sName);
        Debug.println("sType	 : "+sType);
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // compose object to pass search criteria with
    List plans = new Vector();
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature like ? and oc_maintenanceplan_name like ? and oc_maintenanceplan_frequency like ? order by oc_maintenanceplan_name,oc_maintenanceplan_uid");
	ps.setString(1,sNomenclature+"%");
	ps.setString(2,sName.length()==0?"%":sName);
	ps.setString(3,sType.length()==0?"%":sType);
	ResultSet rs = ps.executeQuery();
    String sClass = "1";
    boolean bInit=false;
	while(rs.next()){
        // alternate row-style
        if(sClass.length()==0) sClass = "1";
        else                   sClass = "";
        if(!bInit){
        	bInit=true;
        	%>
            <%-- header --%>
            <tr class="admin" style="padding-left:1px;">    
                <td nowrap>ID</td>
                <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","nomenclature",sWebLanguage))%></td>
                <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","type",sWebLanguage))%></td>
                <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","name",sWebLanguage))%></td>
                <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","frequency",sWebLanguage))%></td>
            </tr>        
            <%
        }
        
		out.println(
        "<tr class='list"+sClass+"' onclick=\"displayMaintenancePlan('"+rs.getString("oc_maintenanceplan_uid")+"');\">"+
        "	<td class='hand' style='padding-left:5px'>"+rs.getString("oc_maintenanceplan_uid")+"</td>"+
        "	<td class='hand' style='padding-left:5px'>"+getTranNoLink("admin.nomenclature.asset",checkString(rs.getString("oc_maintenanceplan_nomenclature")),sWebLanguage)+"</td>"+
        "	<td class='hand' style='padding-left:5px'>"+getTranNoLink("maintenanceplan.type",checkString(rs.getString("oc_maintenanceplan_type")),sWebLanguage)+"</td>"+
        "	<td class='hand' style='padding-left:5px'>"+checkString(rs.getString("oc_maintenanceplan_name"))+"</td>"+
        "	<td class='hand' style='padding-left:5px'>"+getTran(request,"maintenanceplan.frequency",rs.getString("oc_maintenanceplan_frequency"),sWebLanguage)+"</td>"+
       "</tr>");
	}
	rs.close();
	ps.close();
	conn.close();
%>
</table>