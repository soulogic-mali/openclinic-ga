<%@page import="java.util.*,be.openclinic.pharmacy.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<ul id="autocompletion">
    <%
        String sDrugName      = checkString(request.getParameter("findDrugName")).toUpperCase(),
               sField     = checkString(request.getParameter("field")),
               sServiceStockUid = checkString(request.getParameter("serviceStockUid")),
               sStyle=checkString(request.getParameter("style"));
		if(sServiceStockUid.length()>0){
	        int iMaxRows = MedwanQuery.getInstance().getConfigInt("MaxSearchFieldsRows",30);
	        List lResults = null;
	        if(sServiceStockUid.equalsIgnoreCase("NONE")){
	        	lResults = Product.getLimitedDrugs(sDrugName,iMaxRows);
	        	sServiceStockUid="";
	        }
	        else {
	        	lResults = Product.getLimitedDrugs(sDrugName,iMaxRows,sServiceStockUid);
	        }
	        String levels="";
	        if(lResults.size() > 0){
	            Iterator it = lResults.iterator();
	            Product product;
	            
	            while(it.hasNext()){
	                product = (Product)it.next();
	                
	                out.write("<li>");
	                if(sServiceStockUid.length()==0){
	                	levels=product.getAccessibleStockLevels();
		                if(levels.equalsIgnoreCase("0/0")){
		                	out.write("<font "+sStyle+" color='lightgray'>"+HTMLEntities.htmlentities(product.getCode())+" "+HTMLEntities.htmlentities(product.getName())+" ("+levels+")</font>");
		                }
		                else if(levels.indexOf("0/")==0){
		                	out.write(HTMLEntities.htmlentities(product.getCode())+" "+HTMLEntities.htmlentities(product.getName())+" ("+levels+")");
		                }
		                else {
		                	out.write("<b "+sStyle+">"+HTMLEntities.htmlentities(product.getCode())+" "+HTMLEntities.htmlentities(product.getName())+"</b> ("+levels+")");
		                }
	                }
	                else{
	                	out.write("<b"+sStyle+">"+HTMLEntities.htmlentities(product.getCode())+" "+HTMLEntities.htmlentities(product.getName())+" ("+product.getAccessibleStockLevel(sServiceStockUid)+")</b>");
	                	
	                }
	                out.write("<span style='display:none'>"+product.getUid()+"-idcache</span>");
	                out.write("</li>");
	            }
	        }
    %>
</ul>
<%
	    boolean hasMoreResults = (lResults.size() >= iMaxRows);
	    if(hasMoreResults){
	        out.write("<ul id='autocompletion'><li>...</li></ul>");
	    }
	}
%>
