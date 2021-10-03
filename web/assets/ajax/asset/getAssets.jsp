<%@page import="be.openclinic.assets.Asset,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>

<%
    String sPatientId = checkString(request.getParameter("PatientId"));
	int skip = Integer.parseInt(request.getParameter("skip"));

    // search-criteria
    String sCode                = checkString(request.getParameter("code")),
           sNomenclatureCode    = checkString(request.getParameter("nomenclature")),
           sCompNomenclatureCode    = checkString(request.getParameter("compnomenclature")),
           sServiceUid		    = checkString(request.getParameter("serviceuid")),
           sDescription         = checkString(request.getParameter("description")),
           sSerialnumber        = checkString(request.getParameter("serialnumber")),
           sAssetType         	= checkString(request.getParameter("assetType")),
           sAssetStatus         = checkString(request.getParameter("assetStatus")),
           sAssetFunctionality  = checkString(request.getParameter("assetFunctionality")),
           sComponentStatus     = checkString(request.getParameter("componentStatus")),
           sSupplierUID         = checkString(request.getParameter("supplierUID")),
           sShowInactive        = checkString(request.getParameter("showinactive")),
           sPurchasePeriodBegin = checkString(request.getParameter("purchasePeriodBegin")),
           sPurchasePeriodEnd   = checkString(request.getParameter("purchasePeriodEnd"));
    
	if(checkString(request.getParameter("serviceuid")).length()>0){
		session.setAttribute("activeservice", request.getParameter("serviceuid"));
	}

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************* assets/ajax/asset/getAssets.jsp *******************");
        Debug.println("sCode         		: "+sCode);
        Debug.println("sNomenclature 		: "+sNomenclatureCode);
        Debug.println("sServiceUid	 		: "+sServiceUid);
        Debug.println("sDescription  		: "+sDescription);
        Debug.println("sShowInactive 		: "+sShowInactive);
        Debug.println("sSerialnumber 		: "+sSerialnumber);
        Debug.println("sAssetStatus  		: "+sAssetStatus);
        Debug.println("sAssetFunctionality  : "+sAssetFunctionality);
        Debug.println("sSupplierUID  		: "+sSupplierUID);
        Debug.println("sPurchasePeriodBegin : "+sPurchasePeriodBegin);
        Debug.println("sPurchasePeriodEnd   : "+sPurchasePeriodEnd+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // compose object to pass search criteria with
    Asset findObject = new Asset();
    findObject.code = sCode;
    findObject.nomenclature = sNomenclatureCode;
    findObject.description = sDescription;
    findObject.serialnumber = sSerialnumber;
    findObject.comment7 = sAssetFunctionality;
    findObject.comment9 = sAssetStatus;
    findObject.supplierUid = sSupplierUID;
    findObject.serviceuid = sServiceUid;
    findObject.comment15=sCompNomenclatureCode;
    findObject.comment16=sComponentStatus;
    
    if(sPurchasePeriodBegin.length() > 0){
        findObject.purchasePeriodBegin = ScreenHelper.parseDate(sPurchasePeriodBegin);
    }

    if(sPurchasePeriodEnd.length() > 0){    
        findObject.purchasePeriodEnd = ScreenHelper.parseDate(sPurchasePeriodEnd);
    }
    
    List assets = Asset.getList(findObject);
    String sReturn = "";
    
    if(assets.size() > 0){
        Hashtable hSort = new Hashtable();
        Asset asset;
    	int i=0,nActive=0,nAccessible=0;
        // sort on asset.code
        for(i=skip; i<assets.size(); i++){
            asset = (Asset)assets.get(i);
            boolean bCanContinue=true;
            if(sShowInactive.equalsIgnoreCase("false") && asset.isInactive()){
            	bCanContinue=false;
            }
            if(!asset.isInactive()){
            	nActive++;
            }
            boolean bAuthorized=asset.isAuthorizedUser(activeUser.userid);
            if(!bAuthorized && !activeUser.isAdmin()){
    			System.out.println("NOT authorized for asset "+asset.getUid());
    			bCanContinue=false;
            }
            else{
            	nAccessible++;
            }
            if(!bCanContinue){
            	continue;
            }
    		boolean bLocked = asset.getObjectId()>-1 && ((asset.getLockedBy()>-1 && asset.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (asset.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
    		String pd = "";
    		try{
    			pd=ScreenHelper.formatDate(asset.purchaseDate);
    		}
    		catch(Exception e){}
    		String ud = "";
    		try{
    			ud=ScreenHelper.formatDate(asset.getUpdateDateTime());
    		}
    		catch(Exception e){}
            hSort.put(asset.code+"="+asset.getUid(),
                      " onclick=\"displayAsset('"+asset.getUid()+"');\">"+
            		  "<td class='hand'><img src='"+sCONTEXTPATH+"/_img/icons/icon_"+(bLocked?"locked":"unlocked")+".png'/></td>"+
                      "<td class='hand'>["+asset.getUid()+"] "+asset.code+"</td>"+
                      "<td class='hand'>"+asset.description+"</td>"+
                      "<td class='hand' width='1px' nowrap>"+checkString(asset.nomenclature)+"</td>"+
                      "<td class='hand'>"+getTranNoLink("admin.nomenclature.asset", asset.nomenclature,sWebLanguage)+"</td>"+
                      "<td class='hand'>"+asset.serviceuid+" - "+getTranNoLink("service",asset.serviceuid,sWebLanguage)+(!bAuthorized?" <img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
                      "<td class='hand'>"+(sAssetType.equalsIgnoreCase("equipment")?getTranNoLink("assets.functionality",checkString(asset.comment7),sWebLanguage):getTranNoLink("assets.status",checkString(asset.comment9),sWebLanguage))+"</td>"+
                      "<td class='hand'>"+pd+"</td>"+
                      "<td class='hand'>"+ud+"</td>"+
                      (sShowInactive.equalsIgnoreCase("true")?"<td class='hand'>"+ScreenHelper.formatDate(asset.saleDate)+"</td>":"")+
                     "</tr>");
            if(i>=skip+MedwanQuery.getInstance().getConfigInt("maxAssetRecords",99)){
            	break;
            }
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
        if(i>=MedwanQuery.getInstance().getConfigInt("maxAssetRecords",99)){
            sReturn+= "</table><table><tr><td colspan='6'><i>&gt;"+(i+1)+" "+getTran(request,"web","records",sWebLanguage)+" ("+(skip+1)+" - "+i+" "+getTran(request,"web","of",sWebLanguage)+" "+assets.size()+"), <b>"+nActive+"</b> "+getTran(request,"web","active",sWebLanguage)+", <b>"+nAccessible+"</b> "+getTran(request,"web","accessiblefor",sWebLanguage)+" "+activeUser.person.getFullName()+"</i>";
			if(skip>0){
				sReturn+=" <a href='javascript:searchAssets("+(skip-MedwanQuery.getInstance().getConfigInt("maxAssetRecords",100))+")'>"+getTran(request,"web","previous",sWebLanguage)+"</a>";
			}
			if(i<assets.size()){
				sReturn+=" <a href='javascript:searchAssets("+(skip+MedwanQuery.getInstance().getConfigInt("maxAssetRecords",100))+")'>"+getTran(request,"web","next",sWebLanguage)+"</a>";
			}
            sReturn+="</td></tr>";
        }
        else{
        	sReturn+="</table><table><tr><td colspan='6'><i><b>"+assets.size()+"</b> "+getTran(request,"web","recordsFound",sWebLanguage)+", <b>"+nActive+"</b> "+getTran(request,"web","active",sWebLanguage)+", <b>"+nAccessible+"</b> "+getTran(request,"web","accessiblefor",sWebLanguage)+" "+activeUser.person.getFullName()+"</i></td></tr>";
        }
        
    }
    else{
        sReturn = "<tr><td colspan='6'>"+getTran(request,"web","noRecordsFound",sWebLanguage)+"</td></tr>";
    }
%>

<%
    if(assets.size() > 0){
        %>
<table width="100%" class="sortable" id="searchresults" cellspacing="1" style="border:none;">
    <%-- header --%>
    <tr class="admin" style="padding-left:1px;">    
        <td/>
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","code",sWebLanguage))%></asc></td>
        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","name",sWebLanguage))%></asc></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","nomenclature",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","label",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","service",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","status",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","purchaseDate",sWebLanguage))%></td>
        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"gmao","updatetime",sWebLanguage))%></td>
        <%
        	if(sShowInactive.equalsIgnoreCase("true")){
        %>
		        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web.assets","saleDate",sWebLanguage))%></td>
        <%
        	}
        %>
    </tr>
    
    <tbody class="hand">
        <%=sReturn%>
    </tbody>
</table> 

        <%
    }
    else{
        %><%=sReturn%><%
    }
%>