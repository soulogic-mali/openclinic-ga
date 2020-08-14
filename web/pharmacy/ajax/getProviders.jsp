<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
<%
	try{
	String sServiceStockUid = checkString(request.getParameter("findServiceStockUid")).toUpperCase();
	String sProviderName = checkString(request.getParameter("findProviderName")).toUpperCase();
    int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = null;
  	if(MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","all").indexOf("all")>=0){
		ps=conn.prepareStatement("SELECT distinct oc_operation_srcdestuid FROM oc_productstockoperations o,oc_productstocks where oc_operation_description like 'medicationreceipt%' and oc_operation_srcdestuid like '%"+sProviderName+"%' and oc_operation_srcdesttype in ('supplier') and oc_stock_objectid=replace(oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and oc_stock_servicestockuid='"+sServiceStockUid+"'"+
								" union"+
								" SELECT distinct s.oc_stock_name as oc_operation_srcdestuid FROM oc_productstockoperations o,oc_productstocks p,oc_servicestocks s where oc_operation_description like 'medicationreceipt%' and s.oc_stock_name like '%"+sProviderName+"%' and oc_operation_srcdesttype in ('servicestock') and p.oc_stock_objectid=replace(oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and s.oc_stock_objectid=replace(oc_operation_srcdestuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and p.oc_stock_servicestockuid='"+sServiceStockUid+"'"+
								" order by oc_operation_srcdestuid");
  	}
  	else if(MedwanQuery.getInstance().getConfigString("stockOperationDocumentServiceSources","all").indexOf("4")<0){
		ps=conn.prepareStatement("SELECT distinct oc_operation_srcdestuid FROM oc_productstockoperations o where oc_operation_description like 'medicationreceipt%' and oc_operation_srcdesttype ='supplier' and oc_operation_srcdestuid like '%"+sProviderName+"%' order by oc_operation_srcdestuid");
  	}
  	else {
  		ps = conn.prepareStatement("SELECT distinct OC_DOCUMENT_SOURCEUID as oc_operation_srcdestuid FROM oc_productstockoperationdocuments o where oc_document_type=4 and OC_DOCUMENT_SOURCEUID like '%"+sProviderName+"%'");
  	}
	ResultSet rs = ps.executeQuery();
	int counter = 0;
	while(rs.next() && counter<iMaxRows){
	    String provideruid=rs.getString("oc_operation_srcdestuid");
	    out.write("<li>");
	    out.write("<b>"+HTMLEntities.htmlentities(provideruid)+"</b>");
	    out.write("<span style='display:none'>"+provideruid+"-idcache</span>");
	    out.write("</li>");
    }
	rs.close();
	ps.close();
	conn.close();
%>
</ul>
<%
    boolean hasMoreResults = (counter >= iMaxRows);
    if(hasMoreResults){
        out.write("<ul id='autocompletion'><li>...</li></ul>");
    }
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>