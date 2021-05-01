<%@page import="be.openclinic.pharmacy.*,
                be.openclinic.medical.Prescription,
                java.util.Vector,be.mxs.common.util.system.*,
                be.openclinic.pharmacy.ProductOrder"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pharmacy.manageproductstocks","all",activeUser)%>
<%=sJSSORTTABLE%>
<%=sJSPROTOTYPE %>

<%!
    //--- OBJECTS TO HTML (layout 1) --------------------------------------------------------------
    private StringBuffer objectsToHtml1(Vector objects, String sWebLanguage, String userid){
        StringBuffer html = new StringBuffer();
        String sClass = "1", sStockUid = "", sServiceStockName = "", sProductName = "", sStockBegin = "",
               sOrderLevel = "", sMinimumLevel = "";
        Product product;
        int stockLevel;

        // frequently used translations
        String detailsTran = getTranNoLink("web","showdetails",sWebLanguage),
                deleteTran = getTranNoLink("Web","delete",sWebLanguage);

        // run thru found productstocks
        ProductStock productStock;
        for(int i=0; i<objects.size(); i++){
            productStock = (ProductStock)objects.get(i);
            sStockUid = productStock.getUid();

            // get service stock name
            ServiceStock serviceStock = productStock.getServiceStock();
            if(serviceStock!=null){
                sServiceStockName = serviceStock.getName();
            }
            else{
                sServiceStockName = "<font color='red'>"+getTran(null,"web","nonexistingserviceStock",sWebLanguage)+"</font>";
            }

            // get product name
            product = productStock.getProduct();
            if(product!=null){
                sProductName = product.getName();
            }
            else{
                sProductName = "<font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font>";
            }

            // format begin date
            java.util.Date tmpDate = productStock.getBegin();
            if(tmpDate!=null) sStockBegin = ScreenHelper.formatDate(tmpDate);

            // levels
            stockLevel = productStock.getLevel();
            sOrderLevel = (productStock.getOrderLevel()<0?"":productStock.getOrderLevel()+"");
            sMinimumLevel = (productStock.getMinimumLevel()<0?"":productStock.getMinimumLevel()+"");

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else sClass = "";

            // display stock in one row
            html.append("<tr class='list"+sClass+"' onmouseover=\"this.style.cursor='pointer';\" onmouseout=\"this.style.cursor='default';\" title='"+detailsTran+"'>");
        	//Only show delete button if user is stock manager
        	if(productStock.getServiceStock()!=null && productStock.getServiceStock().getStockManagerUid().equalsIgnoreCase(userid)){
                 html.append("<td onclick=\"doShowDetails('"+sStockUid+"');\" align='center'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' alt='"+deleteTran+"' onclick=\"doDelete('"+sStockUid+"');\"></td>");
        	}
            else{
            	html.append("<td/>");
            }
            html.append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+sServiceStockName+"</td>")
                 .append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+sProductName+"</td>");

            if(sMinimumLevel.length() > 0 && sOrderLevel.length() > 0){
                int minimumLevel = Integer.parseInt(sMinimumLevel),
                        orderLevel = Integer.parseInt(sOrderLevel);

                // indicate level in orange or red
                if(stockLevel <= minimumLevel){
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\"><font color='red'>"+stockLevel+"</font>&nbsp;&nbsp;</td>");
                }
                else if(stockLevel <= orderLevel){
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\"><font color='orange'>"+stockLevel+"</font>&nbsp;&nbsp;</td>");
                }
                else {
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+stockLevel+"&nbsp;&nbsp;</td>");
                }
            }
            else {
                html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+stockLevel+"&nbsp;&nbsp;</td>");
            }

            html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+sOrderLevel+"&nbsp;&nbsp;</td>")
                .append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+sStockBegin+"</td>")
                .append("</tr>");
}

        return html;
    }

    //--- OBJECTS TO HTML (layout 2) --------------------------------------------------------------
    private StringBuffer objectsToHtml2(Vector objects, String serviceUid, String sWebLanguage,User activeUser){
        StringBuffer html = new StringBuffer();
        String sClass = "1", sStockUid = "", sProductUid = "", sProductName = "", sStockBegin = "";
        Product product;

        // frequently used translations
        String detailsTran = getTranNoLink("web","showdetails",sWebLanguage),
               deleteTran = getTranNoLink("Web","delete",sWebLanguage),
               incomingTran = getTranNoLink("Web","incoming",sWebLanguage),
               orderTran = getTranNoLink("Web","order",sWebLanguage),
               batchesTran = getTranNoLink("web","batches",sWebLanguage),
               inTran = getTranNoLink("Web.manage","changeLevel.in",sWebLanguage),
               outTran = getTranNoLink("Web.manage","changeLevel.out",sWebLanguage),
               transferTran = getTranNoLink("Web.manage","changeLevel.transfer",sWebLanguage),
               orderThisProductTran = getTranNoLink("Web.manage","orderthisproduct",sWebLanguage),
               changeLevelInTran = getTranNoLink("Web.manage","changeLevelIn",sWebLanguage),
               ficheTran = getTranNoLink("Web","productfiche",sWebLanguage),
               changeLevelOutTran = getTranNoLink("Web.manage","changeLevelOut",sWebLanguage);

        // run thru found productstocks
        HashSet opendeliveries = ProductStockOperation.getOpenProductStockDeliveries();
        Hashtable productnames = Product.getProductNames();
        Hashtable openquantities = ProductOrder.getOpenOrderedQuantity();
        ProductStock productStock;
        for (int i=0; i<objects.size(); i++){
            productStock = (ProductStock)objects.get(i);
            sStockUid = productStock.getUid();

            if(productnames.get(productStock.getProductUid()) != null) {
                sProductName = (String)productnames.get(productStock.getProductUid());
                sProductUid = productStock.getProductUid();
            } 
            else{
                sProductName = "<font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font>";
            }

            // format begin date
            java.util.Date tmpDate = productStock.getBegin();
            if(tmpDate!=null) sStockBegin = ScreenHelper.formatDate(tmpDate);

            double nPUMP = productStock.getProduct().getLastYearsAveragePrice(ScreenHelper.endOfDay(new java.util.Date()));
            int commandLevel = 0;
            if(openquantities.get(productStock.getUid())!=null){
            	commandLevel=(Integer)openquantities.get(productStock.getUid());
            }
            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";
            
            //*** display stock in one row ***
            html.append("<tr class='list"+sClass+"'>")
                 .append("<td width='16'>"+(activeUser.getAccessRight("pharmacy.manageproductstocks.delete") && (productStock.getServiceStock()!=null && productStock.getServiceStock().getStockManagerUid().equalsIgnoreCase(activeUser.userid))?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' alt='"+deleteTran+"' onclick=\"doDelete('"+sStockUid+"');\" title='"+deleteTran+"'></td>":"</td>"))
		         .append("<td width='16'>"+(activeUser.getAccessRight("pharmacy.viewproductstockfiches.select")?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' class='link' onclick=\"printFiche('"+sStockUid+"');\" title='"+ficheTran+"'></td>":"<td/>"));
            if(opendeliveries.contains(productStock.getServiceStockUid()+"$"+productStock.getProductUid())){
                html.append("<td width='16'><img src='"+sCONTEXTPATH+"/_img/icons/icon_incoming.gif' class='link' alt='"+incomingTran+"' onclick='javascript:receiveProduct(\""+sStockUid+"\",\""+sProductName+"\");'/>&nbsp;</td>");
            }
            else {
            	html.append("<td/>");
            }

            // non-existing productname in red
            if(sProductName.length() == 0) {
                html.append("<td>&nbsp;</td>"); //No product code
                html.append("<td onclick=\"doShowDetails('"+sStockUid+"');\"><font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font></td>");
            } 
            else {
                html.append("<td onclick=\"doShowDetails('"+sStockUid+"');\">&nbsp;"+checkString(productStock.getProduct().getCode())+"</td>");
                html.append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+sProductName+"</td>");
            }

            // level
            int stockLevel = productStock.getLevel();
            String sOrderLevel = (productStock.getOrderLevel()<0?"":productStock.getOrderLevel()+""),
                   sMinimumLevel = (productStock.getMinimumLevel()<0?"":productStock.getMinimumLevel()+""),
                   sMaximumLevel = (productStock.getMaximumLevel()<0?"":productStock.getMaximumLevel()+"");

            if(sMinimumLevel.length() > 0 && sOrderLevel.length() > 0){
                int minimumLevel = Integer.parseInt(sMinimumLevel),
                    orderLevel = Integer.parseInt(sOrderLevel);

                // indicate level in orange or red
                if(stockLevel <= minimumLevel){
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\"><font color='red'>"+stockLevel+"</font>&nbsp;&nbsp;</td>");
                } 
                else if(stockLevel <= orderLevel){
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\"><font color='orange'>"+stockLevel+"</font>&nbsp;&nbsp;</td>");
                } 
                else if(stockLevel > productStock.getMaximumLevel()){
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\"><font style='background-color: black; color: white'>"+stockLevel+"</font>&nbsp;&nbsp;</td>");
                } 
                else{
                    html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+stockLevel+"&nbsp;&nbsp;</td>");
                }
            }
            else{
                html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+stockLevel+"&nbsp;&nbsp;</td>");
            }

            html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+commandLevel+"&nbsp;&nbsp;</td>");
            html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+sMinimumLevel+"&nbsp;&nbsp;</td>");
            html.append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+sMaximumLevel+"&nbsp;&nbsp;</td>")
                 .append("<td align='right' onclick=\"doShowDetails('"+sStockUid+"');\">"+sOrderLevel+"&nbsp;&nbsp;</td>")
                 .append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+sStockBegin+"</td>")
                 .append("<td onclick=\"doShowDetails('"+sStockUid+"');\">"+(nPUMP>0?new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(nPUMP)+" "+MedwanQuery.getInstance().getConfigString("currency","EUR"):"?")+"</td>");

            // 3 buttons
            html.append("<td style=\"text-align:right;\" nowrap>&nbsp;");

            // no buttons for unexisting product
            if(productnames.get(productStock.getProductUid()) != null){
                if(productStock.getLevel() > 0 && productStock.getServiceStock().isDispensingUser(activeUser.userid)){
                	//Verify if products are to expire
                	if(productStock.hasExpiringProducts(MedwanQuery.getInstance().getConfigInt("pharmacyExpiryWarningInDays",90))){
                        html.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'>&nbsp;");
                	}
                    html.append("<input type='button' title='"+changeLevelOutTran+"' class='button' style='width:30px;' value=\""+outTran+"\" onclick=\"deliverProduct('"+sStockUid+"','"+sProductName+"','"+stockLevel+"');\">&nbsp;");
                    if(SH.cs("edition","openclinic").equalsIgnoreCase("bloodbank")){
                    	html.append("<input type='button' class='button' style='width:40px;' value=\""+transferTran+"\" onclick=\"transferProduct('"+sStockUid+"','"+sProductName+"','"+stockLevel+"');\">&nbsp;");
                    }
                }
                if(productStock.getServiceStock().isReceivingUser(activeUser.userid)){
                	html.append("<input type='button' title='"+changeLevelInTran+"' class='button' style='width:30px;' value=\""+inTran+"\" onclick=\"receiveProduct('"+sStockUid+"','"+sProductName+"');\">&nbsp;");
                }
                html.append("<input type='button' title='"+orderThisProductTran+"' class='button' value=\""+orderTran+"\" onclick=\"orderProduct('"+sStockUid+"','"+sProductName+"');\">&nbsp;");
                html.append("<input type='button' title='"+batchesTran+"' class='button' value=\""+batchesTran+"\" onclick=\"batchesList('"+sStockUid+"');\">&nbsp;");
            }

            html.append("</td>");
            html.append("</tr>");
        }

        return html;
    }
    
    //--- OBJECTS TO HTML (layout 3) --------------------------------------------------------------
    private StringBuffer objectsToHtml3(Vector objects, String serviceUid, String sWebLanguage,User activeUser){
        StringBuffer html = new StringBuffer();
        String sClass = "1", sStockUid = "", sProductUid = "", sProductName = "", sStockBegin = "";
        Product product;
        long day=24*3600*1000;

        Hashtable productnames = Product.getProductNames();
        ProductStock productStock;
        for (int i=0; i<objects.size(); i++){
            productStock = (ProductStock)objects.get(i);
            sStockUid = productStock.getUid();

            if(productnames.get(productStock.getProductUid()) != null) {
                sProductName = (String)productnames.get(productStock.getProductUid());
                sProductUid = productStock.getProductUid();
            } 
            else{
                sProductName = "<font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font>";
            }
			
            int stocklevel = productStock.getLevel();
            boolean bHasNegative=false;
           	//We must write a row for each batch with a level<>0
           	Vector batches = Batch.getAllBatches(productStock.getUid());
           	for(int n=0;n<batches.size();n++){
           		Batch batch = (Batch)batches.elementAt(n);
           		if(batch.getLevel()==0){
           			continue;
           		}
           		else if(batch.getLevel()<0){
           			bHasNegative=true;
           		}
           		stocklevel-=batch.getLevel();
	            // alternate row-style
	            if(sClass.equals("")) sClass = "1";
	            else                  sClass = "";
	            
	            //*** display stock in one row ***
	            html.append("<tr class='list"+sClass+"'>");
	
	            // non-existing productname in red
	            if(sProductName.length() == 0) {
	                html.append("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"); //No product code
	                html.append("<td><font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font></td>");
	                html.append("<td/>");
	            } 
	            else {
	                html.append("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;"+checkString(productStock.getProduct().getCode())+"</td>");
	                html.append("<td><b>"+sProductName+(batch.getLevel()<0?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>":"")+"</b></td>");
	                html.append("<td><b>"+batch.getBatchNumber()+"</b></td>");
	            }
	
	            // level
				double physicallevel=batch.getLevel();
	            String s = Pointer.getPointer("physical."+sStockUid+"."+batch.getUid());
	            String difference="0";
	            if(s.length()>0){
	            	physicallevel=Double.parseDouble(s);
	            	difference=(physicallevel-batch.getLevel())+"";
	            }
	            html.append("<td><input type='hidden' id='theoretical."+sStockUid+"."+batch.getUid()+"' name='theoretical."+sStockUid+"."+batch.getUid()+"' value='"+batch.getLevel()+"'>"+batch.getLevel()+"</td>");
	            html.append("<td><input size='8' type='text' class='"+(Double.parseDouble(difference)==0?"text":"red")+"' id='physical."+sStockUid+"."+batch.getUid()+"' name='physical."+sStockUid+"."+batch.getUid()+"' value='"+physicallevel+"' onkeyup='calculateDifference(this)'></td>");
	            html.append("<td><input size='8' type='text' class='readonly' readonly id='difference."+sStockUid+"."+batch.getUid()+"' name='difference."+sStockUid+"."+batch.getUid()+"' value='"+difference+"'></td>");
	            double lp=productStock.getProduct().getLooseLastYearsAveragePrice(ScreenHelper.endOfDay(new java.util.Date()));
	            if(lp==0){
	            	html.append("<td><input size='8' type='text' class='text' id='pump."+sStockUid+"."+batch.getUid()+"' name='pump."+sStockUid+"."+batch.getUid()+"' value=''>"+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
	            }
	            else{
	            	html.append("<td>"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(lp)+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
	            }
	            html.append("</tr>");
           	}
           	if(stocklevel!=0){
	            // alternate row-style
	            if(sClass.equals("")) sClass = "1";
	            else                  sClass = "";
	            
	            //*** display stock in one row ***
	            html.append("<tr class='list"+sClass+"'>");
	
	            // non-existing productname in red
	            if(sProductName.length() == 0) {
	                html.append("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td>"); //No product code
	                html.append("<td><font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font></td>");
	                html.append("<td/>");
	            } 
	            else {
	                html.append("<td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;"+checkString(productStock.getProduct().getCode())+"</td>");
	                html.append("<td><b>"+sProductName+(bHasNegative?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>":"")+"</b></td>");
	                html.append("<td><b>?</b></td>");
	            }
	
	            // level
				double physicallevel=stocklevel;
	            String difference="0";
	            String s = Pointer.getPointer("physical."+sStockUid);
	            if(s.length()>0){
	            	physicallevel=Double.parseDouble(s);
	            	difference=(physicallevel-stocklevel)+"";
	            }
	            html.append("<td><input type='hidden' id='theoretical."+sStockUid+"' name='theoretical."+sStockUid+"' value='"+stocklevel+"'>"+stocklevel+"</td>");
	            html.append("<td><input size='8' type='text' class='"+(Double.parseDouble(difference)==0?"text":"red")+"' id='physical."+sStockUid+"' name='physical."+sStockUid+"' value='"+physicallevel+"' onkeyup='calculateDifference(this)'></td>");
	            html.append("<td><input size='8' type='text' class='readonly' readonly id='difference."+sStockUid+"' name='difference."+sStockUid+"' value='"+difference+"'></td>");
	            double lp=productStock.getProduct().getLooseLastYearsAveragePrice(ScreenHelper.endOfDay(new java.util.Date()));
	            if(lp==0){
		            html.append("<td><input size='8' type='text' class='text' id='pump."+sStockUid+"' name='pump."+sStockUid+"' value=''>"+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
	            }
	            else{
	            	html.append("<td>"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(lp)+" "+MedwanQuery.getInstance().getConfigString("currency","EUR")+"</td>");
	            }
	            html.append("</tr>");
           	}
        }

        return html;
    }
%>

<%
	long day = 24*3600*1000;
	long year = 365*day;

    String sAction = checkString(request.getParameter("Action"));

    // retreive form data
    String sEditStockUid          = checkString(request.getParameter("EditStockUid")),
           sEditServiceStockUid   = checkString(request.getParameter("EditServiceStockUid")),
           sEditProductUid        = checkString(request.getParameter("EditProductUid")),
           sEditLevel             = checkString(request.getParameter("EditLevel")),
           sEditMinimumLevel      = checkString(request.getParameter("EditMinimumLevel")),
           sEditMaximumLevel      = checkString(request.getParameter("EditMaximumLevel")),
           sEditOrderLevel        = checkString(request.getParameter("EditOrderLevel")),
           sEditBegin             = checkString(request.getParameter("EditBegin")),
           sEditEnd               = checkString(request.getParameter("EditEnd")),
           sEditDefaultImportance = checkString(request.getParameter("EditDefaultImportance")),
           sEditLocation          = checkString(request.getParameter("EditLocation")),
           sEditSupplierUid       = checkString(request.getParameter("EditSupplierUid"));

    // afgeleide data
    String sEditServiceStockName = checkString(request.getParameter("EditServiceStockName")),
           sEditProductName      = checkString(request.getParameter("EditProductName")),
           sEditSupplierName     = checkString(request.getParameter("EditSupplierName"));

    // external data
    String sServiceId = checkString(request.getParameter("ServiceId"));
	
    if(sAction.equalsIgnoreCase("showDetailsNew")){
    	sEditStockUid="-1";
    }
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************** pharmacy/manageProductStocks.jsp *******************");
        Debug.println("sAction                : "+sAction);
        Debug.println("sEditStockUid          : "+sEditStockUid);
        Debug.println("sEditServiceStockUid   : "+sEditServiceStockUid);
        Debug.println("sEditProductUid        : "+sEditProductUid);
        Debug.println("sEditLevel             : "+sEditLevel);
        Debug.println("sEditMinimumLevel      : "+sEditMinimumLevel);
        Debug.println("sEditMaximumLevel      : "+sEditMaximumLevel);
        Debug.println("sEditOrderLevel        : "+sEditOrderLevel);
        Debug.println("sEditBegin             : "+sEditBegin);
        Debug.println("sEditEnd               : "+sEditEnd);
        Debug.println("sEditDefaultImportance : "+sEditDefaultImportance);
        Debug.println("sEditSupplierUid       : "+sEditSupplierUid);
        Debug.println("sEditServiceStockName  : "+sEditServiceStockName);
        Debug.println("sEditSupplierName      : "+sEditSupplierName);
        Debug.println("sEditLocation          : "+sEditLocation);
        Debug.println("sEditProductName       : "+sEditProductName+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String msg = "", sFindServiceStockUid = "", sFindProductUid = "", sFindLevel = "",
           sFindMinimumLevel = "", sFindMaximumLevel = "", sFindOrderLevel = "", sFindBegin = "",
           sFindEnd = "", sFindDefaultImportance = "", sSelectedServiceStockUid = "", sSelectedProductUid = "",
           sSelectedLevel = "", sSelectedMinimumLevel = "", sSelectedMaximumLevel = "", sSelectedOrderLevel = "",
           sSelectedBegin = "", sSelectedEnd = "", sSelectedServiceStockName = "",
           sSelectedProductName = "", sFindSupplierUid = "", sFindSupplierName = "",
           sSelectedSupplierUid = "", sSelectedSupplierName = "", sSelectedLocation = "";
    
    String sSelectedDefaultImportance = MedwanQuery.getInstance().getConfigString("productStockDefaultImportance","type1native");

    int foundStockCount = 0;
    StringBuffer stocksHtml = null;

    // display options
    boolean displayEditFields = false, displayFoundRecordsLayout1 = false, displayFoundRecordsLayout2 = false;

    String sDisplaySearchFields = checkString(request.getParameter("DisplaySearchFields"));
    if(sDisplaySearchFields.length()==0) sDisplaySearchFields = "true"; // default
    boolean displaySearchFields = sDisplaySearchFields.equalsIgnoreCase("true");

    String sDisplayLowStocks = checkString(request.getParameter("DisplayLowStocks"));
    if(sDisplayLowStocks.length()==0) sDisplayLowStocks = "false"; // default
    boolean displayLowStocks = sDisplayLowStocks.equalsIgnoreCase("true");


    //*********************************************************************************************
    //*** process actions *************************************************************************
    //*********************************************************************************************

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditStockUid.length()>0){    	
        // create productStock
        ProductStock stock = new ProductStock();
        stock.setUid(sEditStockUid);
        stock.setServiceStockUid(sEditServiceStockUid);
        stock.setProductUid(sEditProductUid);
        stock.setDefaultImportance(sEditDefaultImportance);
        stock.setSupplierUid(sEditSupplierUid);
        stock.setUpdateUser(activeUser.userid);
        stock.setLocation(sEditLocation);

        if(sEditLevel.length() > 0)        stock.setLevel(Integer.parseInt(sEditLevel));
        if(sEditMinimumLevel.length() > 0) stock.setMinimumLevel(Integer.parseInt(sEditMinimumLevel));
        if(sEditMaximumLevel.length() > 0) stock.setMaximumLevel(Integer.parseInt(sEditMaximumLevel));
        if(sEditOrderLevel.length() > 0)   stock.setOrderLevel(Integer.parseInt(sEditOrderLevel));
        if(sEditBegin.length() > 0)        stock.setBegin(ScreenHelper.parseDate(sEditBegin));
        if(sEditEnd.length() > 0)          stock.setEnd(ScreenHelper.parseDate(sEditEnd));

        // does product exist ?
        String existingStockUid = stock.exists();
        boolean stockExists = (existingStockUid.length()>0 && Double.parseDouble(existingStockUid)>-1);
        Debug.println("stockExists : "+stockExists);

        if(sEditStockUid.equals("-1")){
            //***** insert new stock *****
            if(!stockExists){
                stock.store();

                // show saved data
                sAction = "findShowOverview"; // showDetails
                msg = getTran(request,"web","dataissaved",sWebLanguage);
            }
            //***** reject new addition thru update *****
            else{
                // show rejected data
                sAction = "showDetailsAfterAddReject";
                msg = "<font color='red'>"+getTran(request,"web.manage","stockexists",sWebLanguage)+"</font>";
            }
        }
        else{
            //***** update existing stock *****
            if(!stockExists){
                stock.store();

                // show saved data
                sAction = "findShowOverview"; // showDetails
                msg = getTran(request,"web","dataissaved",sWebLanguage);
            }
            //***** reject double record thru update *****
            else{
                if(sEditStockUid.equals(existingStockUid)){
                    // nothing : just updating a record with its own data
                    if(stock.changed()){
                        stock.store();
                        msg = getTran(request,"web","dataissaved",sWebLanguage);
                    }
                    sAction = "findShowOverview"; // showDetails
                }
                else{
                    // tried to update one stock with exact the same data as an other stock
                    // show rejected data
                    sAction = "showDetailsAfterUpdateReject";
                    msg = "<font color='red'>"+getTran(request,"web.manage","stockexists",sWebLanguage)+"</font>";
                }
            }
        }

        sEditStockUid = stock.getUid();
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete") && sEditStockUid.length()>0){
        ProductStock.delete(sEditStockUid);
        msg = getTran(request,"web","dataisdeleted",sWebLanguage);
        sAction = "findShowOverview"; // display overview even if only one record remains
    }
    else if(sAction.equals("storeinventory")){
    	Enumeration params = request.getParameterNames();
    	while(params.hasMoreElements()){
    		String parname = (String)params.nextElement();
    		if(parname.startsWith("physical") && (Pointer.getPointer(parname).length()>0 || Double.parseDouble(request.getParameter(parname))!=Double.parseDouble(request.getParameter(parname.replaceAll("physical", "theoretical"))))){
				//The physical stock is different from the theoretical one!
				Pointer.deletePointers(parname);
				Pointer.storePointer(parname, request.getParameter(parname));
    		}
    	}
        sAction = "findShowOverview"; // showDetails
    }
    else if(sAction.equals("updateinventory")){
    	Enumeration params = request.getParameterNames();
    	while(params.hasMoreElements()){
    		String parname = (String)params.nextElement();
    		if(parname.startsWith("difference") && new Double(request.getParameter(parname))!=0){
    			try{
    				//We need to make an inventory correction in the database
    				int nDifference = new Double(request.getParameter(parname)).intValue();
    				ProductStockOperation operation = new ProductStockOperation();
    				operation.setCreateDateTime(new java.util.Date());
    				operation.setDate(new java.util.Date());
    				if(nDifference<0){
    					operation.setDescription("medicationdelivery.3");
        				operation.setUnitsChanged(-nDifference);
    				}
    				else{
    					operation.setDescription("medicationreceipt.3");
        				operation.setUnitsChanged(nDifference);
    				}
    				if(parname.split("\\.").length>4){
    					operation.setBatchUid(parname.split("\\.")[3]+"."+parname.split("\\.")[4]);
    				}
    				operation.setProductStockUid(parname.split("\\.")[1]+"."+parname.split("\\.")[2]);
    				operation.setUid("-1");
    				operation.setUpdateDateTime(new java.util.Date());
    				operation.setUpdateUser(activeUser.userid);
    				operation.setVersion(1);
    				operation.setSourceDestination(new ObjectReference("",""));
    				operation.store();
    				Pointer.deletePointers(parname.replaceAll("difference","physical"));
    			}
    			catch(Exception e){
    				e.printStackTrace();
    			}
    		}
    		else if(parname.startsWith("pump") && request.getParameter(parname).trim().length()>0 && !request.getParameter(parname).equalsIgnoreCase("0")){
    			try{
    				if(Double.parseDouble(request.getParameter(parname.replaceAll("pump","physical")))>0){
		    			ProductStock productStock = ProductStock.get(parname.split("\\.")[1]+"."+parname.split("\\.")[2]);
		    			Pointer.storePointer("pump."+productStock.getProductUid(), request.getParameter(parname));
		    			Pointer.storePointer("drugprice."+productStock.getProductUid()+".0.0", request.getParameter(parname.replaceAll("pump","physical"))+";"+request.getParameter(parname));
    				}
    			}
    			catch(Exception e){
    				e.printStackTrace();
    			}
    		}
    	}
        sAction = "findShowOverview"; // showDetails
    }
    
    //--- FIND ------------------------------------------------------------------------------------
    if(sAction.startsWith("find")){
        if(sAction.equals("findShowOverview")){
            displayEditFields = false;
        }

        // get data from form
        sFindServiceStockUid   = checkString(request.getParameter("FindServiceStockUid"));
        sFindProductUid        = checkString(request.getParameter("FindProductUid"));
        sFindLevel             = checkString(request.getParameter("FindLevel"));
        sFindMinimumLevel      = checkString(request.getParameter("FindMinimumLevel"));
        sFindMaximumLevel      = checkString(request.getParameter("FindMaximumLevel"));
        sFindOrderLevel        = checkString(request.getParameter("FindOrderLevel"));
        sFindBegin             = checkString(request.getParameter("FindBegin"));
        sFindEnd               = checkString(request.getParameter("FindEnd"));
        sFindDefaultImportance = checkString(request.getParameter("FindDefaultImportance"));
        sFindSupplierUid       = checkString(request.getParameter("FindSupplierUid"));
        if(SH.c(request.getParameter("hideZeroLevel")).equalsIgnoreCase("1")){
        	sFindLevel="1";
        }
        // get supplier name
        if(sFindSupplierUid.length() > 0) sFindSupplierName = getTran(request,"service",sFindSupplierUid,sWebLanguage);
        else                              sFindSupplierName = "";

        // search all products for a specified productStock
        if(sServiceId.length() > 0) {
        	sFindServiceStockUid = sEditServiceStockUid;
        }
        else if(sEditServiceStockUid.length()>0){
        	ServiceStock serviceStock = ServiceStock.get(sEditServiceStockUid);
        	if(serviceStock!=null){
        		sServiceId=serviceStock.getServiceUid();
            	sFindServiceStockUid = sEditServiceStockUid;
        	}
        }

        Vector productStocks = ProductStock.find(sFindServiceStockUid,sFindProductUid,sFindLevel,sFindMinimumLevel,
                                                 sFindMaximumLevel,sFindOrderLevel,sFindBegin,sFindEnd,sFindDefaultImportance,
                                                 sFindSupplierUid,"","OC_PRODUCT_NAME","ASC");

        // display other layout if stocks of only one service are shown
        if(sServiceId.length()==0) {
        	stocksHtml = objectsToHtml1(productStocks,sWebLanguage,activeUser.userid);
        }
        else if(request.getParameter("updateInventory")==null){
        	stocksHtml = objectsToHtml2(productStocks,sServiceId,sWebLanguage,activeUser);
        }
        else {
        	stocksHtml = objectsToHtml3(productStocks,sServiceId,sWebLanguage,activeUser);
        }

        foundStockCount = productStocks.size();

        // what layout to use
        if(sServiceId.length() > 0){
            displayFoundRecordsLayout1 = false;
            displayFoundRecordsLayout2 = true;
        }
        else{
            displayFoundRecordsLayout1 = true;
            displayFoundRecordsLayout2 = false;
        }
    }

    //--- SHOW DETAILS ----------------------------------------------------------------------------
    if(sAction.startsWith("showDetails")){
        displayEditFields = true;
        displaySearchFields = false;

        // get specified record
        if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
            ProductStock productStock = ProductStock.get(sEditStockUid);

            if(productStock!=null){
                sSelectedServiceStockUid   = checkString(productStock.getServiceStockUid());
                sSelectedProductUid        = checkString(productStock.getProduct().getUid());
                sSelectedLevel             = (productStock.getLevel()<0?"":productStock.getLevel()+"");
                sSelectedMinimumLevel      = (productStock.getMinimumLevel()<0?"":productStock.getMinimumLevel()+"");
                sSelectedMaximumLevel      = (productStock.getMaximumLevel()<0?"":productStock.getMaximumLevel()+"");
                sSelectedOrderLevel        = (productStock.getOrderLevel()<0?"":productStock.getOrderLevel()+"");
                sSelectedDefaultImportance = checkString(productStock.getDefaultImportance());
                sSelectedSupplierUid       = checkString(productStock.getSupplierUid());
                sSelectedLocation          = checkString(productStock.getLocation());

                // format begin date
                java.util.Date tmpDate = productStock.getBegin();
                if(tmpDate!=null) sSelectedBegin = ScreenHelper.formatDate(tmpDate);

                // format end date
                tmpDate = productStock.getEnd();
                if(tmpDate!=null) sSelectedEnd = ScreenHelper.formatDate(tmpDate);

                // afgeleide data
                sSelectedServiceStockName = productStock.getServiceStock().getName();

                // productname
                Product product = productStock.getProduct();
                if(product!=null) sSelectedProductName = product.getName();
                else              sSelectedProductName = productStock.getProductUid();

                // supplier
                if(sSelectedSupplierUid.length() > 0){
                    sSelectedSupplierName = getTranNoLink("service",sSelectedSupplierUid,sWebLanguage);
                }
            }
        }
        else if(sAction.equals("showDetailsAfterAddReject")){
            // do not get data from DB, but show data that were allready on form
            sSelectedServiceStockUid   = sEditServiceStockUid;
            sSelectedProductUid        = sEditProductUid;
            sSelectedLevel             = sEditLevel;
            sSelectedMinimumLevel      = sEditMinimumLevel;
            sSelectedMaximumLevel      = sEditMaximumLevel;
            sSelectedOrderLevel        = sEditOrderLevel;
            sSelectedBegin             = sEditBegin;
            sSelectedEnd               = sEditEnd;
            sSelectedDefaultImportance = sEditDefaultImportance;
            sSelectedSupplierUid       = sEditSupplierUid;
            sSelectedLocation          = sEditLocation;

            // afgeleide data
            sSelectedServiceStockName = sEditServiceStockName;
            sSelectedProductName      = sEditProductName;
            sSelectedSupplierName     = sEditSupplierName;
        }
    }

    // compose form action
    String sFormActionParams = "";
    if(sServiceId.length() > 0){
        sFormActionParams+= "&ServiceId="+sServiceId;
    }

    if(sEditServiceStockUid.length() > 0){
        sFormActionParams+= "&EditServiceStockUid="+sEditServiceStockUid;
    }

    // onclick : when editing, save, else search when pressing 'enter'
    String sOnKeyDown = "";
    if(sAction.startsWith("showDetails")){
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSave();}\"";
    }
    else{
        if(!sAction.equals("findShowOverview")){
            sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSearch();}\"";
        }
    }
%>
<form name="transactionForm" id="transactionForm" method="post" action='<c:url value="/main.do"/>?Page=pharmacy/manageProductStocks.jsp<%=sFormActionParams%>&ts=<%=getTs()%>' <%=sOnKeyDown%> <%=(displaySearchFields||sAction.equals("findShowOverview")?"onClick=\"clearMessage();\"":"onclick=\"setSaveButton(event);clearMessage();\" onkeyup=\"setSaveButton(event);\"")%>>
    <input type='hidden' name='DisplaySearchFields' value='<%=checkString(request.getParameter("DisplaySearchFields")) %>'/>
    <%=writeTableHeader("Web.manage","ManageProductStocks",sWebLanguage,(sAction.equals("findShowOverview")?"":"doBack();"))%>
    
    <%-- display servicename and servicestockname --%>
    <%
        String sServiceName = "", sServiceStockName = "";
        if(sServiceId.length() > 0 || sEditServiceStockUid.length() > 0){
            %>
                <table class="list" width="100%" cellspacing="1">
                    <%
                        // Servicename
                        if(sServiceId.length() > 0){
                            sServiceName = getTran(request,"Service",sServiceId,sWebLanguage);
                        }

                        if(sServiceName.length() > 0){
	                        %>
		                        <tr>
		                            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","service",sWebLanguage)%>&nbsp;</td>
		                            <td class="admin2" colspan='2'><%=sServiceName%></td>
		                        </tr>
	                        <%
                        }

                        // ServicestockName
                        ServiceStock serviceStock = new ServiceStock();
                        serviceStock = serviceStock.get(sEditServiceStockUid);
                        if(serviceStock!=null) sServiceStockName = serviceStock.getName();

                        if(sServiceStockName.length() > 0){
	                        %>
		                        <tr>
		                            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","servicestock",sWebLanguage)%>&nbsp;</td>
		                            <td class="admin2"><%=sServiceStockName%> (<%=serviceStock.getUid() %>)</td>
			                        <td class="admin2">
			                        <% if(activeUser.getAccessRight("pharmacy.updateinventory.select")){%>
			                        	<input class="text" type="checkbox" name="updateInventory" id="updateInventory" value='1' <%=request.getParameter("updateInventory")!=null?"checked":"" %> onclick="document.getElementById('Action').value='findShowOverview';transactionForm.submit();"><%=getTran(request,"Web","updateinventory",sWebLanguage)%>
			                        <% }%>
			                        	<input class="text" type="checkbox" name="hideZeroLevel" id="hideZeroLevel" value='1' <%=SH.c(request.getParameter("hideZeroLevel")).equalsIgnoreCase("1")?"checked":"" %> onclick="document.getElementById('Action').value='findShowOverview';transactionForm.submit();"><%=getTran(request,"Web","hideZeroLevelstocks",sWebLanguage)%>
			                        </td>
		                        </tr>
	                        <%
                        }
                    %>
                    
                    <tr id="filtersection">
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","productstock",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2"><input type='text' class='text' name='filter' id='filter' onkeyup='showSearchResults(this.value)' value='' size='10'/></td>
                        <td class="admin2"><input class="button" type="button" name="returnButton0" value='<%=getTranNoLink("Web.manage","manageservicestocks",sWebLanguage)%>' onclick="doBackToPrevModule();"></td>
                    </tr>
                    
                </table>
                
                <%-- display message --%>
                <%
                    if(sAction.equals("findShowOverview")){
                        %><span id="msgArea"><%=msg%></span><%
                        if(msg.length()>0){
                            %><br><%
                        }
                    }
                %>
                <br>
            <%
        }
    %>

    <%
        //*****************************************************************************************
        //*** process display options *************************************************************
        //*****************************************************************************************

        //--- SEARCH FIELDS -----------------------------------------------------------------------
        if(displaySearchFields){
            // afgeleide data
            String sFindServiceStockName = checkString(request.getParameter("FindServiceStockName")),
                   sFindProductName      = checkString(request.getParameter("FindProductName"));

            %>
                <table width="100%" class="list" cellspacing="1" onClick="transactionForm.onkeydown='if(enterEvent(event,13)){doSearch();}';" onKeyDown="if(enterEvent(event,13)){doSearch();}">
                    <%-- Service Stock --%>
                    <tr>
                        <td class="admin2" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","servicestock",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="hidden" name="FindServiceStockUid" value="<%=sFindServiceStockUid%>">
                            <input class="text" type="text" name="FindServiceStockName" readonly size="<%=sTextWidth%>" value="<%=sFindServiceStockName%>">

                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchServiceStock('FindServiceStockUid','FindServiceStockName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindServiceStockUid.value='';transactionForm.FindServiceStockName.value='';">
                        </td>
                    </tr>
                    <%-- Product --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","product",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="hidden" name="FindProductUid" value="<%=sFindProductUid%>">
                            <input class="text" type="text" name="FindProductName" readonly size="<%=sTextWidth%>" value="<%=sFindProductName%>">
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProduct('FindProductUid','FindProductName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindProductUid.value='';transactionForm.FindProductName.value='';">
                        </td>
                    </tr>
                    <%-- Level --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","Level",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindLevel" size="5" maxLength="5" value="<%=sFindLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    <%-- MinimumLevel --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","MinimumLevel",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindMinimumLevel" size="5" maxLength="5" value="<%=sFindMinimumLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    <%-- MaximumLevel --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","MaximumLevel",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindMaximumLevel" size="5" maxLength="5" value="<%=sFindMaximumLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    <%-- OrderLevel --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","OrderLevel",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindOrderLevel" size="5" maxLength="5" value="<%=sFindOrderLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    <%-- Begin --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","begindate",sWebLanguage)%></td>
                        <td class="admin2"><%=writeDateField("FindBegin","transactionForm",sFindBegin,sWebLanguage)%></td>
                    </tr>
                    <%-- End --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","enddate",sWebLanguage)%></td>
                        <td class="admin2"><%=writeDateField("FindEnd","transactionForm",sFindEnd,sWebLanguage)%></td>
                    </tr>
                    <%-- DefaultImportance (dropdown : native|low|high) --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","DefaultImportance",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="FindDefaultImportance">
                                <option value=""></option>
                                <%=ScreenHelper.writeSelectUnsorted(request,"productstock.defaultimportance",sFindDefaultImportance,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    <%-- supplier --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","supplier",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                        	<select class='text' name='FindSupplierUid' id='FindSupplierUid'>
                        		<option value=''/>
                        		<%
                        			try{
	                        			Vector servicestocks = ServiceStock.findAll();
	                        			for(int n=0;n<servicestocks.size();n++){
	                        				ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
	                        				out.println("<option value='"+stock.getUid()+"' "+(sFindSupplierUid.equalsIgnoreCase(stock.getUid())?"selected":"")+">"+stock.getName()+"</option>");
	                        			}
                        			}
                        			catch(Exception r){
                        				r.printStackTrace();
                        			}
                        		%>
                        	</select>
                        </td>
                    </tr>
                    
                    <%-- SEARCH BUTTONS --%>
                    <tr>
                        <td class="admin2">&nbsp;</td>
                        <td class="admin2">
                            <input type="button" class="button" name="searchButton" value="<%=getTranNoLink("Web","search",sWebLanguage)%>" onclick="doSearch();">
                            <input type="button" class="button" name="clearButton" value="<%=getTranNoLink("Web","Clear",sWebLanguage)%>" onclick="clearSearchFields();">
                            <input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNew();">&nbsp;
                           
                            <%-- display message --%>
                            <span id="msgArea"><%=msg%></span>
                        </td>
                    </tr>
                </table>
                <br>
            <%
        }

        //--- SEARCH RESULTS (layout 1) -----------------------------------------------------------
        if(displayFoundRecordsLayout1){
            if(foundStockCount > 0){
                %>
                    <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                        <%-- header --%>
                        <tr class="admin">
                            <td/>
                            <td><%=getTran(request,"Web","servicestock",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","productName",sWebLanguage)%></td>
                            <td align="right"><%=getTran(request,"Web","level",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td align="right"><%=getTran(request,"Web","orderlevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td><SORTTYPE:DATE><%=getTran(request,"Web","begindate",sWebLanguage)%></SORTTYPE:DATE></td>
                        </tr>
                        <tbody class="hand"><%=stocksHtml%></tbody>
                    </table>
                    
                    <%-- number of records found --%>
                    <span style="width:49%;text-align:left;">
                        <%=foundStockCount%> <%=getTran(request,"web","recordsfound",sWebLanguage)%>
                    </span>
                    
                    <%
                        if(foundStockCount > 20){
                            // link to top of page
                            %>
                                <span style="width:51%;text-align:right;">
                                    <a href="#topp" class="topbutton">&nbsp;</a>
                                </span>
                                <br>
                            <%
                        }
                    %>
                    <br><br>
                <%
            }
            else{
	            // no records found
	            %><%=getTran(request,"web","norecordsfound",sWebLanguage)%><br><br><%
            }
        }

        //--- SEARCH RESULTS (layout 2) -----------------------------------------------------------
        // used for showing productStocks in one serviceStock
        if(displayFoundRecordsLayout2){
            if(foundStockCount > 0){
            	if(request.getParameter("updateInventory")==null){
                %>
                    <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                        <%-- header --%>
                        <tr class="admin">
                            <td/>
                            <td/>
                            <td/>
                            <td><%=getTran(request,"web","code",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","productName",sWebLanguage)%></td>
                            <td style="text-align:right"><%=getTran(request,"Web","level",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td style="text-align:right"><%=getTran(request,"Web","openorders",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td style="text-align:right"><%=getTran(request,"Web","minimumlevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td style="text-align:right"><%=getTran(request,"Web","maximumlevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td style="text-align:right"><%=getTran(request,"Web","orderlevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                            <td><SORTTYPE:DATE><%=getTran(request,"Web","begindate",sWebLanguage)%></SORTTYPE:DATE></td>
                            <td><%=getTran(request,"Web.manage","PUMP",sWebLanguage)%></td>
                            <td/>
                        </tr>
                        <tbody class="hand"><%=stocksHtml%></tbody>
                    </table>
                    
                    <%-- number of records found --%>
                    <span style="width:49%;text-align:left;">
                        <%=foundStockCount%> <%=getTran(request,"web","recordsfound",sWebLanguage)%>
                    </span>
                    
                    <%
                        if(foundStockCount > 20){
                            // link to top of page
                            %>
                                <span style="width:51%;text-align:right;">
                                    <a href="#topp" class="topbutton">&nbsp;</a>
                                </span>
                                <br>
                            <%
                        }
                    %>
                    
                    <%-- BUTTONS --%>
                    <%=ScreenHelper.alignButtonsStart()%>
                        <input class="button" type="button" name="calculateButton" value='<%=getTranNoLink("Web.manage","calculateOrder",sWebLanguage)%>' onclick="doCalculateOrder('<%=sEditServiceStockUid%>','<%=sServiceStockName%>');">
                        <input class="button" type="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNew();">
                        <input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web.manage","manageservicestocks",sWebLanguage)%>' onclick="doBackToPrevModule();">
                    <%=ScreenHelper.alignButtonsStop()%>
                <%
            	}
                else{
				%>
                	<table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                    <%-- header --%>
                    <tr class="admin">
                        <td/>
                        <td/>
                        <td/>
                        <td><%=getTran(request,"web","code",sWebLanguage)%></td>
                        <td><%=getTran(request,"Web","productName",sWebLanguage)%></td>
                        <td><%=getTran(request,"Web","batch",sWebLanguage)%></td>
                        <td><%=getTran(request,"Web","theoreticallevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                        <td><%=getTran(request,"Web","physicallevel",sWebLanguage)%>&nbsp;&nbsp;</td>
                        <td><%=getTran(request,"Web","difference",sWebLanguage)%>&nbsp;&nbsp;</td>
                        <td><%=getTran(request,"Web","pump",sWebLanguage)%>&nbsp;&nbsp;</td>
                    </tr>
                    <tbody class="hand"><%=stocksHtml%></tbody>
                </table>
                
                <%-- number of records found --%>
                <span style="width:49%;text-align:left;">
                    <%=foundStockCount%> <%=getTran(request,"web","recordsfound",sWebLanguage)%>
                </span>
                
                <%
                    if(foundStockCount > 20){
                        // link to top of page
                        %>
                            <span style="width:51%;text-align:right;">
                                <a href="#topp" class="topbutton">&nbsp;</a>
                            </span>
                            <br>
                        <%
                    }
                %>
                
                <%-- BUTTONS --%>
                <%=ScreenHelper.alignButtonsStart()%>
                    <input class="button" type="button" name="storeinventory" value='<%=getTranNoLink("web","save",sWebLanguage)%>' onclick="doStoreInventory();">
                    <input class="button" type="button" name="update" value='<%=getTranNoLink("web","update",sWebLanguage)%>' onclick="doUpdateInventory();">
                    <input class="button" type="button" name="printdifferences" value='<%=getTranNoLink("web","printdifferences",sWebLanguage)%>' onclick="doPrintDifferences();">
                    <input class="button" type="button" name="printall" value='<%=getTranNoLink("web","printall",sWebLanguage)%>' onclick="doPrintAll();">
                <%=ScreenHelper.alignButtonsStop()%>
				<%
                }
            }
            else{
                // no records found
                %>
                    <%=getTran(request,"web.manage","noproductsfound",sWebLanguage)%>
                    
                    <%-- BUTTONS --%>
                    <%=ScreenHelper.alignButtonsStart()%>
                        <input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNew();">
                        <input type="button" class="button" name="returnButton" value='<%=getTranNoLink("Web.manage","manageservicestocks",sWebLanguage)%>' onclick="doBackToPrevModule();">
                    <%=ScreenHelper.alignButtonsStop()%>
                <%
            }
        }
        
        // do not show service-stock-selector if serviceStock is yet specified
        if(sEditServiceStockUid.length()==0){
	        %>
	            <input type="hidden" name="EditServiceStockUid" id="EditServiceStockUid" value="<%=sSelectedServiceStockUid%>">
	            <input type="hidden" name="ServiceId" id="ServiceId" value="<%=sServiceId%>">
	        <%
        }
        else{
	        %>
	            <input type="hidden" name="EditServiceStockUid" id="EditServiceStockUid" value="<%=sEditServiceStockUid%>">
	            <input type="hidden" name="ServiceId" id="ServiceId" value="<%=sServiceId%>">
	        <%
        }
        
        //--- EDIT FIELDS -------------------------------------------------------------------------
        if(displayEditFields){
            %>
                <table class="list" width="100%" cellspacing="1">
                    <%
                        // do not show service-stock-selector if serviceStock is yet specified
                        if(sEditServiceStockUid.length()==0){
	                        %>
	                        <%-- Service Stock --%>
	                        <tr>
	                            <td class="admin" nowrap><%=getTran(request,"Web","servicestock",sWebLanguage)%> *</td>
	                            <td class="admin2">
	                                <input class="text" type="text" name="EditServiceStockName" readonly size="<%=sTextWidth%>" value="<%=sSelectedServiceStockName%>">
	
	                                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchServiceStock('EditServiceStockUid','EditServiceStockName');">
	                                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditServiceStockUid.value='';transactionForm.EditServiceStockName.value='';">
	                            </td>
	                        </tr>
	                        <%
                        }
                        else{
                            %><%-- hidden Service Stock --%><%
                        }
                    %>
                    
                    <%-- Product --%>
	                <tr class="gray">
                        <td colspan="2">&nbsp;<%=getTran(request,"Web","productstockid",sWebLanguage)%>: <%=sEditStockUid.equalsIgnoreCase("-1")?"":sEditStockUid %></td>
                    </tr>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","product",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input type="hidden" name="EditProductUid" id="EditProductUid" value="<%=sSelectedProductUid%>">
                            <input class="text" type="text" name="EditProductName" id="EditProductName" readonly size="<%=sTextWidth%>" value="<%=sSelectedProductName%>">

                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProduct('EditProductUid','EditProductName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditProductUid.value='';transactionForm.EditProductName.value='';">
                        </td>
                    </tr>
                    
                    <%-- Level (required) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","Level",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="greytext" type="text" name="EditLevel" readonly size="10" maxLength="10" value="<%=sSelectedLevel.length()>0?sSelectedLevel:"0"%>">
                        </td>
                    </tr>
                    
                    <%-- MinimumLevel (required) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","MinimumLevel",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditMinimumLevel" size="10" maxLength="10" value="<%=sSelectedMinimumLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- MaximumLevel (implied) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","MaximumLevel",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditMaximumLevel" size="10" maxLength="10" value="<%=sSelectedMaximumLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- OrderLevel (required) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","OrderLevel",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditOrderLevel" size="10" maxLength="10" value="<%=sSelectedOrderLevel%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- Begin --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","begindate",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2"><%=writeDateField("EditBegin","transactionForm",sSelectedBegin,sWebLanguage)%>
                            <%
                                // if new productstock : set today as default value for begindate
                                if(sAction.equals("showDetailsNew")){
                                    %><script>getToday(document.getElementsByName('EditBegin')[0]);</script><%
                                }
                            %>
                        </td>
                    </tr>
                    
                    <%-- End --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","enddate",sWebLanguage)%></td>
                        <td class="admin2"><%=writeDateField("EditEnd","transactionForm",sSelectedEnd,sWebLanguage)%></td>
                    </tr>
                    
                    <%-- DefaultImportance (dropdown : native|low|high) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","DefaultImportance",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <select class="text" name="EditDefaultImportance">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelectUnsorted(request,"productstock.defaultimportance",sSelectedDefaultImportance,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    
                    <%-- supplier --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","supplier",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                        	<select class='text' name='EditSupplierUid' id='EditSupplierUid'>
                        		<option value=''/>
                        		<%
                        			try{
	                        			Vector servicestocks = ServiceStock.findAll();
	                        			for(int n=0;n<servicestocks.size();n++){
	                        				ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
	                        				if(stock!=null && !stock.getUid().equalsIgnoreCase(sEditServiceStockUid)){
	                        					out.println("<option value='"+stock.getUid()+"' "+(sSelectedSupplierUid.equalsIgnoreCase(stock.getUid())?"selected":"")+">"+stock.getName()+"</option>");
	                        				}
	                        			}
                        			}
                        			catch(Exception r){
                        				r.printStackTrace();
                        			}
                        		%>
                        	</select>
                        </td>
                    </tr>
                    <%	if(SH.ci("enableBloodbank",0)==1){ %>
	                    <%-- location --%>
	                    <tr>
	                        <td class="admin" nowrap><%=getTran(request,"Web","bloodproducttype",sWebLanguage)%>&nbsp;</td>
	                        <td class="admin2">
								<select name="EditLocation" id="EditLocation" class='text'>
									<option/>
									<%=SH.writeSelect(request, "bloodproducts", sSelectedLocation, sWebLanguage) %>
								</select>
	                        </td>
	                    </tr>
                    <%	}
                    	else{
                    %>
	                    <%-- location --%>
	                    <tr>
	                        <td class="admin" nowrap><%=getTran(request,"Web","location",sWebLanguage)%>&nbsp;</td>
	                        <td class="admin2">
	                            <input class="text" type="text" name="EditLocation" id="EditLocation" size="<%=sTextWidth%>" value="<%=sSelectedLocation%>">
	                        </td>
	                    </tr>
	                <%	} %>
                    <%if(!sEditStockUid.equals("-1")){ %>
	                    <tr>
	                        <td class="admin" nowrap><%=getTran(request,"Web","pharmacy.kit",sWebLanguage)%></td>
	                        <td class="admin2">
	                        	<input type='text' class='text' size='2' name='EditSourceProductStockQuantity' id='EditSourceProductStockQuantity' value='0'/> x
					            <input type="hidden" name="EditSourceProductStockUid" id="EditSourceProductStockUid">
					            <input type="text" size="80" class="text" name="EditSourceProductStockName" id="EditSourceProductStockName"/>
					            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditSourceProductStockUid','EditSourceProductStockName');">
					            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditSourceProductStockUid.value='';transactionForm.EditSourceProductStockName.value='';">
	                            <input type='button' class='button' name='addKitButton' value='<%=getTranNoLink("web","add",sWebLanguage) %>' onclick='addToKit();'/>
	                            <div id='divKit'/>
	                        </td>
	                    </tr>
                    <%} %>

                    <%-- EDIT BUTTONS --%>
                    <tr>
                        <td class="admin">&nbsp;</td>
                        <td class="admin2">
                            <%
                                if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
                                    // existing productStock : display saveButton with save-label
                                    %>
                                        <input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave();">
                                    <% 
                                    	//Only show delete button if user is stock manager
                                    	ProductStock productStock = ProductStock.get(sEditStockUid);
                                    	if(productStock!=null && productStock.getServiceStock()!=null && productStock.getServiceStock().getStockManagerUid().equalsIgnoreCase(activeUser.userid)){
                                    %>
                                        	<input class="button" type="button" name="deleteButton" value='<%=getTranNoLink("Web","delete",sWebLanguage)%>' onclick="doDelete('<%=sEditStockUid%>');">
                                    <%
                                    	}
                                }
                                else if(sAction.equals("showDetailsNew") || sAction.equals("showDetailsAfterAddReject")){
                                    // new productStock : display saveButton with add-label
                                    %>
                                        <input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","add",sWebLanguage)%>' onclick="doAdd();">
                                    <%
                                }
                            %>
                            <%-- BACK TO OVERVIEW --%>
                            <input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","backtooverview",sWebLanguage)%>' onclick="doBackToOverview();">
                            <input class="button" type="button" name="printBarcodeButton" value='<%=getTranNoLink("Web","printbarcode",sWebLanguage)%>' onclick="doPrintBarcode('<%=sEditStockUid%>');">
                            <%-- display message --%>
                            <span id="msgArea"><%=msg%></span>
                        </td>
                    </tr>
                </table>
                
                <%-- indication of obligated fields --%>
                <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>
                <br><br>
                
                <table>
                	<tr>
                		<td class='text'><a href="javascript:printFiche('<%=sEditStockUid %>','<%=sSelectedProductName %>')"><%=getTran(request,"web","productstockfile.interactive",sWebLanguage)%></a></td>
                		<td class='text'><a href="javascript:printPDFFiche('<%=sEditStockUid %>')"><%=getTran(request,"web","productstockfile.pdf",sWebLanguage)%></a></td>
                	</tr>
                </table>
            <%
        }
    %>
    
    <%-- hidden fields --%>
    <input type="hidden" name="Action" id="Action">
    <input type="hidden" name="EditStockUid" id="EditStockUid" value="<%=sEditStockUid%>">
    <input type="hidden" name="DisplaySearchFields" id="DisplaySearchFields" value="<%=displaySearchFields%>">
    <input type="hidden" name="DisplayLowStocks" id="DisplayLowStocks" value="<%=displayLowStocks%>">
</form>

<%-- SCRIPTS ------------------------------------------------------------------------------------%>
<script>  
  <%
      // default focus field
      if(displayEditFields){
          if(sEditServiceStockUid.length() == 0){
              %>transactionForm.EditServiceStockName.focus();<%
          }
          else{
              %>transactionForm.EditProductName.focus();<%
          }
      }
      else{
          if(displaySearchFields){
              %>transactionForm.FindServiceStockName.focus();<%
          }
      }
  %>

	function searchProductStock(productStockUidField,productStockNameField){
    	openPopup("/_common/search/searchProductStock2.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField);
  	}
	
	function addToKit(){
		if(document.getElementById('EditSourceProductStockQuantity').value*1>0 && document.getElementById('EditSourceProductStockUid').value.length>0){
		    var url = '<c:url value="/pharmacy/ajax/addSourceProductToKit.jsp"/>?EditTargetProductStockUid=<%=sEditStockUid%>&EditSourceProductStockQuantity='+document.getElementById("EditSourceProductStockQuantity").value+'&EditSourceProductStockUid='+document.getElementById("EditSourceProductStockUid").value+'&ts='+new Date();
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: "",
		      onSuccess: function(resp){
		    	  document.getElementById('EditSourceProductStockUid').value='';
		    	  document.getElementById('EditSourceProductStockName').value='';
		    	  loadKitProducts();
		      }
		    });
		}
	}
	
	function loadKitProducts(){
		if(document.getElementById('divKit')){
			document.getElementById('divKit').innerHTML='<img src="<%=sCONTEXTPATH%>/_img/themes/default/ajax-loader.gif"/>';
		    var url = '<c:url value="/pharmacy/ajax/loadKitProducts.jsp"/>?EditTargetProductStockUid=<%=sEditStockUid%>&ts='+new Date();
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: "",
		      onSuccess: function(resp){
		    	  document.getElementById('divKit').innerHTML=resp.responseText;
		      }
		    });
		}
	}
	
	function deleteKitProduct(id){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = '<c:url value="/pharmacy/ajax/removeProductFromKit.jsp"/>?EditTargetProductStockUid=<%=sEditStockUid%>&EditSourceProductStockUid='+id+'&ts='+new Date();
		    new Ajax.Request(url,{
		      method: "POST",
		      parameters: "",
		      onSuccess: function(resp){
		    	  loadKitProducts();
		      }
		    });
		}
	}
  <%-- DO ADD --%>
  function doAdd(){
    transactionForm.EditStockUid.value = "-1";
    doSave();
  }

  <%-- DO SAVE --%>
  function doSave(){
    if(checkStockFields()){
      transactionForm.saveButton.disabled = true;
      transactionForm.Action.value = "save";
      transactionForm.submit();
    }
    else{
      if(transactionForm.EditServiceStockUid.value.length==0){
    	  transactionForm.EditServiceStockName.focus();
      }
      else if(transactionForm.EditProductUid.value.length==0){
        transactionForm.EditProductName.focus();
      }
      else if(transactionForm.EditLevel.value.length==0){
        transactionForm.EditLevel.focus();
      }
      else if(transactionForm.EditMinimumLevel.value.length==0){
        transactionForm.EditMinimumLevel.focus();
      }
      else if(transactionForm.EditBegin.value.length==0){
        transactionForm.EditBegin.focus();
      }
      else if(transactionForm.EditOrderLevel.value.length==0){
        transactionForm.EditOrderLevel.focus();
      }
      else if(transactionForm.EditDefaultImportance.value.length==0){
        transactionForm.EditDefaultImportance.focus();
      }
    }
  }

  <%-- CHECK STOCK FIELDS --%>
  function checkStockFields(){
    var maySubmit = true;
    <%-- required fields --%>
    if(!transactionForm.EditServiceStockUid.value.length>0 ||
       !transactionForm.EditProductUid.value.length>0 ||
       !transactionForm.EditLevel.value.length>0 ||
       !transactionForm.EditMinimumLevel.value.length>0 ||
       !transactionForm.EditOrderLevel.value.length>0 ||
       !transactionForm.EditBegin.value.length>0 ||
       !transactionForm.EditDefaultImportance.value.length>0){
      maySubmit = false;
      alertDialog("web.manage","dataMissing");
    }
    else{
      <%-- check levels --%>
      if(maySubmit){
        if(transactionForm.EditMaximumLevel.value.length>0 && transactionForm.EditMinimumLevel.value.length>0){
          var maxLevel = parseInt(transactionForm.EditMaximumLevel.value),
              minLevel = parseInt(transactionForm.EditMinimumLevel.value);

          if(maxLevel >= minLevel){
            maySubmit = true;
          }
          else{
            alertDialog("web","maxmustbelargerthanmin");
            transactionForm.EditMaximumLevel.focus();
            maySubmit = false;
          }
        }
      }

      <%-- check dates --%>
      if(maySubmit){
        if(transactionForm.EditBegin.value.length>0 && transactionForm.EditEnd.value.length>0){
          var dateBegin = transactionForm.EditBegin.value,
              dateEnd   = transactionForm.EditEnd.value;

          if(before(dateBegin,dateEnd)){
            maySubmit = true;
          }
          else{
            alertDialog("web.occup","endMustComeAfterBegin");
            transactionForm.EditEnd.focus();
            maySubmit = false;
          }
        }
      }
    }

    return maySubmit;
  }

  <%-- DO DELETE --%>
  function doDelete(stockUid){
      if(yesnoDeleteDialog()){
      transactionForm.EditStockUid.value = stockUid;
      transactionForm.Action.value = "delete";
      transactionForm.submit();
    }
  }

  <%-- DO NEW --%>
  function doNew(){
    <%
    	if(displayEditFields){
            %>clearEditFields();<%
        }

        if(displaySearchFields){
            %>clearSearchFields();<%
        }
    %>

    if(transactionForm.searchButton!=undefined) transactionForm.searchButton.disabled = true;
    if(transactionForm.clearButton!=undefined) transactionForm.clearButton.disabled = true;
    if(transactionForm.newButton!=undefined) transactionForm.newButton.disabled = true;

    transactionForm.Action.value = "showDetailsNew";
    transactionForm.submit();
  }

  <%-- DO SHOW DETAILS --%>
  function doShowDetails(stockUid){
    if(transactionForm.searchButton!=undefined) transactionForm.searchButton.disabled = true;
    if(transactionForm.clearButton!=undefined) transactionForm.clearButton.disabled = true;
    if(transactionForm.newButton!=undefined) transactionForm.newButton.disabled = true;

    transactionForm.EditStockUid.value = stockUid;
    transactionForm.Action.value = "showDetails";
    transactionForm.submit();
  }

  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    transactionForm.FindServiceStockUid.value = "";
    transactionForm.FindServiceStockName.value = "";

    transactionForm.FindProductUid.value = "";
    transactionForm.FindProductName.value = "";

    transactionForm.FindLevel.value = "";
    transactionForm.FindMinimumLevel.value = "";
    transactionForm.FindMaximumLevel.value = "";
    transactionForm.FindOrderLevel.value = "";
    transactionForm.FindBegin.value = "";
    transactionForm.FindEnd.value = "";
    transactionForm.FindDefaultImportance.value = "";

    transactionForm.FindSupplierUid.value = "";
    transactionForm.FindSupplierName.value = "";
  }

  <%-- CLEAR EDIT FIELDS --%>
  function clearEditFields(){
	<% if(sEditServiceStockUid.length() == 0){ %>
		transactionForm.EditServiceStockUid.value = "";
	    transactionForm.EditServiceStockName.value = "";
	<% } %>
    transactionForm.EditProductUid.value = "";
    transactionForm.EditProductName.value = "";

    transactionForm.EditLevel.value = "";
    transactionForm.EditMinimumLevel.value = "";
    transactionForm.EditMaximumLevel.value = "";
    transactionForm.EditOrderLevel.value = "";
    transactionForm.EditBegin.value = "";
    transactionForm.EditEnd.value = "";
    transactionForm.EditDefaultImportance.value = "";

    transactionForm.EditSupplierUid.value = "";
    transactionForm.EditDefaultSupplierName.value = "";
  }
  
  <%-- DO SEARCH --%>
  function doSearch(){
    if(transactionForm.FindServiceStockUid.value.length>0 ||
       transactionForm.FindProductUid.value.length>0 ||
       transactionForm.FindLevel.value.length>0 ||
       transactionForm.FindMinimumLevel.value.length>0 ||
       transactionForm.FindMaximumLevel.value.length>0 ||
       transactionForm.FindOrderLevel.value.length>0 ||
       transactionForm.FindSupplierUid.value.length>0 ||
       transactionForm.FindDefaultImportance.value.length>0){
      transactionForm.searchButton.disabled = true;
      transactionForm.clearButton.disabled = true;
      transactionForm.newButton.disabled = true;

      transactionForm.Action.value = "find";
      openSearchInProgressPopup();
      transactionForm.submit();
    }
    else{
      alertDialog("web.manage","dataMissing");
    }
  }

  <%-- popup : search service stock --%>
  function searchServiceStock(serviceStockUidField,serviceStockNameField){
    openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField="+serviceStockUidField+"&ReturnServiceStockNameField="+serviceStockNameField);
  }

  <%-- popup : order product --%>
  function orderProduct(productStockUid,productName){
    openPopup("pharmacy/popups/orderProduct.jsp&EditProductStockUid="+productStockUid+"&EditProductName="+encodeURIComponent(productName)+"&ts=<%=getTs()%>");
  }

  <%-- popup : order product --%>
  function batchesList(productStockUid){
    openPopup("pharmacy/popups/batchList.jsp&EditProductStockUid="+productStockUid+"&ts=<%=getTs()%>",400,500);
  }

  <%-- popup : receive product --%>
  function receiveProduct(productStockUid,productName){
    openPopup("pharmacy/medication/popups/receiveMedicationPopup.jsp&EditProductStockUid="+productStockUid+"&EditProductName="+productName+"&ts=<%=getTs()%>",750,400);
  }

  <%-- popup : deliver product --%>
  function deliverProduct(productStockUid,productName,stockLevel){
    if(stockLevel <= 0){
      alertDialog("web.manage","insufficientStock");
    }
    else{
      openPopup("pharmacy/medication/popups/deliverMedicationPopup.jsp&EditProductStockUid="+productStockUid+"&EditProductName="+encodeURIComponent(productName)+"&ts=<%=getTs()%>",750,400);
    }
  }

  <%-- popup : transfer product --%>
  function transferProduct(productStockUid,productName,stockLevel){
    if(stockLevel <= 0){
      alertDialog("web.manage","insufficientStock");
    }
    else{
      openPopup("pharmacy/medication/popups/deliverMedicationPopupCNTS.jsp&EditProductStockUid="+productStockUid+"&EditProductName="+encodeURIComponent(productName)+"&ts=<%=getTs()%>",1000,500);
    }
  }

  <%-- popup : search supplier --%>
  function searchSupplier(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&SearchExternalServices=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  }

  <%-- popup : search supplier --%>
  function printFiche(productStockUid,productStockName){
	openPopup("pharmacy/viewProductStockFiches.jsp&ts=<%=getTs()%>&Action=find&FindProductStockUid="+productStockUid+"&GetYear=<%=new SimpleDateFormat("yyyy").format(new java.util.Date())%>&FindServiceStockName=<%=sServiceStockName%>",700,500);
  }

  function printPDFFiche(productStockUid){
	openPopup("statistics/pharmacy/getProductStockFile.jsp&ts=<%=getTs()%>&ProductStockUid="+productStockUid,200,200);
  }

  <%-- popup : CALCULATE ORDER --%>
  function doCalculateOrder(serviceStockUid,serviceStockName){
    openPopup("pharmacy/popups/calculateOrder.jsp&ServiceStockUid="+serviceStockUid+"&ServiceStockName="+serviceStockName+"&ts=<%=getTs()%>",700,400);
  }

  <%-- CLEAR MESSAGE --%>
  function clearMessage(){
    <%
        if(msg.length() > 0){
            %>document.getElementById('msgArea').innerHTML = "";<%
        }
    %>
  }

  <%-- DO BACK TO OVERVIEW --%>
  function doBackToOverview(){
    if(checkSaveButton()){
      transactionForm.Action.value = "findShowOverview";
      transactionForm.DisplaySearchFields.value = "false";
      transactionForm.returnButton.disabled = true;
      transactionForm.submit();
    }
  }

  <%-- SHOW SEARCH RESULTS --%>
  function showSearchResults(s){
	table = document.getElementById("searchresults");
	rows = table.rows;
	for(var n=1;n<rows.length;n++){
	  cell = rows[n].cells[3];
	  if(cell.firstChild.nodeValue.toLowerCase().indexOf(s.toLowerCase())>=0){
		 rows[n].style.display = "";
      }
	  else{
		  cell = rows[n].cells[4];
		  if(cell.firstChild.nodeValue.toLowerCase().indexOf(s.toLowerCase())>=0){
			 rows[n].style.display = "";
	      }
		  else{
		    rows[n].style.display = "none";
		  }
	  }
	}
  }
  
  <%-- DO BACK TO PREVious MODULE --%>
  function doBackToPrevModule(){
    window.location.href = "<%=sCONTEXTPATH%>/main.do?Page=pharmacy/manageServiceStocks.jsp&DisplaySearchFields=true&ts=<%=getTs()%>";
  }

  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<%=sCONTEXTPATH%>/main.do?Page=pharmacy/manageProductStocks.jsp&DisplaySearchFields=true&ts=<%=getTs()%>";
  }

  if('<%=sAction%>'=='findShowOverview' || '<%=sAction%>'=='find'){
    if(document.getElementById('filtersection')!=null){
      document.getElementById('filtersection').style.display = '';
    }
     
	<%-- close "search in progress"-popup that might still be open --%>
	var popup = window.open("","Searching","width=1,height=1");
	popup.close();
	if(document.getElementById("filter")){
      window.setTimeout("document.getElementById('filter').focus()",500);
    }
  }
  else{
	if(document.getElementById('filtersection')!=null){
      document.getElementById('filtersection').style.display = 'none';
	}
  }

  <%-- popup : search product --%>
  function searchProduct(productUidField,productNameField,productUnitField,unitsPerTimeUnitField,
		                 unitsPerPackageField,productStockUidField,serviceStockUidField){
    var url = "/_common/search/searchProduct.jsp&ts=<%=getTs()%>"+
              "&loadschema=true&ReturnProductUidField="+productUidField+
              "&ReturnProductNameField="+productNameField+"&DisplayProductsOfService=true&resetServiceStockUid=false";

    if(productUnitField!=undefined){
      url+= "&ReturnProductUnitField="+productUnitField;
    }

    if(unitsPerTimeUnitField!=undefined){
      url+= "&ReturnUnitsPerTimeUnitField="+unitsPerTimeUnitField;
    }

    if(unitsPerPackageField!=undefined){
      url+= "&ReturnUnitsPerPackageField="+unitsPerPackageField;
    }

    if(productStockUidField!=undefined){
      url+= "&ReturnProductStockUidField="+productStockUidField;
    }

    if(serviceStockUidField!=undefined){
      url+= "&ReturnServiceStockUidField="+serviceStockUidField;
    }

    openPopup(url);
  }
  
  <%-- popup : search userProduct --%>
  function searchUserProduct(productUidField,productNameField,productUnitField,
		                     unitsPerTimeUnitField,unitsPerPackageField,productStockUidField,serviceStockUidField){
    var url = "/_common/search/searchUserProduct.jsp&ts=<%=getTs()%>"+
    		  "&loadschema=true"+
    		  "&ReturnProductUidField="+productUidField+
    		  "&ReturnProductNameField="+productNameField;

    if(productUnitField!=undefined){
      url+= "&ReturnProductUnitField="+productUnitField;
    }

    if(unitsPerTimeUnitField!=undefined){
      url+= "&ReturnUnitsPerTimeUnitField="+unitsPerTimeUnitField;
    }

    if(unitsPerPackageField!=undefined){
      url+= "&ReturnUnitsPerPackageField="+unitsPerPackageField;
    }

    if(productStockUidField!=undefined){
      url+= "&ReturnProductStockUidField="+productStockUidField;
    }

    if(serviceStockUidField!=undefined){
      url+= "&ReturnServiceStockUidField="+serviceStockUidField;
    }

    openPopup(url);
  }

  <%-- popup : search product in service stock --%>
  function searchProductInServiceStock(productUidField,productNameField,productUnitField,unitsPerTimeUnitField,
		                               unitsPerPackageField,productStockUidField,serviceStockUidField){
    var url = "/_common/search/searchProductInStock.jsp&ts=<%=getTs()%>"+
              "&loadschema=true"+
              "&DisplayProductsOfPatientService=true"+
              "&ReturnProductUidField="+productUidField+
              "&ReturnProductNameField="+productNameField;

    if(productUnitField!=undefined){
      url+= "&ReturnProductUnitField="+productUnitField;
    }

    if(unitsPerTimeUnitField!=undefined){
      url+= "&ReturnUnitsPerTimeUnitField="+unitsPerTimeUnitField;
    }

    if(unitsPerPackageField!=undefined){
      url+= "&ReturnUnitsPerPackageField="+unitsPerPackageField;
    }

    if(productStockUidField!=undefined){
      url+= "&ReturnProductStockUidField="+productStockUidField;
    }

    if(serviceStockUidField!=undefined){
      url+= "&ReturnServiceStockUidField="+serviceStockUidField;
    }

    openPopup(url);
  }
  
  function calculateDifference(el){
	  document.getElementById(el.name.replace('physical','difference')).value=el.value*1-document.getElementById(el.name.replace('physical','theoretical')).value*1;
  }
  
  function doUpdateInventory(){
	if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
		document.getElementById("Action").value='updateinventory';
		transactionForm.submit();
	}
  }
	  
  function doStoreInventory(){
		document.getElementById("Action").value='storeinventory';
		transactionForm.submit();
  }
  
  function doPrintBarcode(productStockUid){
      var url = "<c:url value='/pharmacy/createProductStockLabelPdf.jsp'/>?productStockUid="+productStockUid;
      printwindow=window.open(url,"ProductStockLabelPdf<%=new java.util.Date().getTime()%>","height=300,width=400,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }
  function doPrintDifferences(productStockUid){
      var url = "<c:url value='/pharmacy/createInventoryUpdatePdf.jsp'/>?serviceStockUid=<%=sEditServiceStockUid%>";
      printwindow=window.open(url,"createInventoryUpdatePdf<%=new java.util.Date().getTime()%>","height=300,width=400,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }
  function doPrintAll(productStockUid){
      var url = "<c:url value='/pharmacy/createInventoryUpdatePdf.jsp'/>?serviceStockUid=<%=sEditServiceStockUid%>&printall=1";
      printwindow=window.open(url,"createInventoryUpdatePdf<%=new java.util.Date().getTime()%>","height=300,width=400,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");
  }
  
  window.setTimeout("loadKitProducts();",250);
</script>
