<%@page import="be.openclinic.assets.Asset,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../../assets/includes/commonFunctions.jsp"%>

<%
    // search-criteria
    String sNomenclatureCode    = checkString(request.getParameter("nomenclature"));

    Vector assets = Asset.getDefaultAssets(sNomenclatureCode);
    String sReturn = "";
    
    if(assets.size() > 0){
        Hashtable hSort = new Hashtable();
        Asset asset;
    	int i=0;
        // sort on asset.code
        for(i=0; i<assets.size(); i++){
            asset = (Asset)assets.get(i);
            hSort.put(asset.code+"="+asset.getUid(),
                      " onclick=\"displayAsset('"+asset.getUid()+"');\">"+
                      "<td class='hand'>"+asset.getUid()+"</td>"+
                      "<td class='hand'>"+asset.code+"</td>"+
                      "<td class='hand'>"+asset.description+"</td>"+
                      "<td class='hand' width='1px' nowrap>"+checkString(asset.nomenclature)+"</td>"+
                      "<td class='hand'>"+getTranNoLink("admin.nomenclature.asset", asset.nomenclature,sWebLanguage)+"</td>"+
                     "</tr>");
            if(i>=MedwanQuery.getInstance().getConfigInt("maxAssetRecords",100)){
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

       	sReturn+="</table><table><tr><td colspan='6'><i>"+assets.size()+" "+getTran(request,"web","recordsFound",sWebLanguage)+"</i></td></tr>";
        
    }
    else{
        sReturn = "<tr><td colspan='6'>"+getTran(request,"web","noRecordsFound",sWebLanguage)+"</td></tr>";
    }
%>

<%
    if(assets.size() > 0){
        %>
		<table width="100%" class="sortable" id="searchresults" cellspacing="1" cellpadding="5" style="border:none;">
		    <%-- header --%>
		    <tr class="admin" style="padding-left:1px;">    
		        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","id",sWebLanguage))%></asc></td>
		        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","code",sWebLanguage))%></asc></td>
		        <td nowrap><asc><%=HTMLEntities.htmlentities(getTran(request,"web","name",sWebLanguage))%></asc></td>
		        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","nomenclature",sWebLanguage))%></td>
		        <td nowrap><%=HTMLEntities.htmlentities(getTran(request,"web","label",sWebLanguage))%></td>
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
