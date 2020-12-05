<%@page import="be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.ProductSchema,
                be.openclinic.common.KeyValue,
                be.openclinic.finance.*,
                be.mxs.common.util.system.Pointer,
                java.util.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"pharmacy.manageproducts","all",activeUser)%>
<%=sJSSORTTABLE%>

<%!
    //--- OBJECTS TO HTML -------------------------------------------------------------------------
    private StringBuffer objectsToHtml(Vector objects, String sWebLanguage){
        StringBuffer html = new StringBuffer();
        String sClass = "1", sProductUid, sUnit, sUnitPrice, sSupplierUid, sSupplierName, sProductGroup, sProductSubGroup;
        DecimalFormat deci = new DecimalFormat("0.00");
        String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");

        // frequently used translations
        String detailsTran = getTranNoLink("web","showdetails",sWebLanguage),
                deleteTran = getTranNoLink("Web","delete",sWebLanguage);

        // run thru found products
        Product product;
        for (int i = 0; i < objects.size(); i++){
            product = (Product) objects.get(i);
            sProductUid = product.getUid();

            // translate unit
            sUnit = getTran(null,"product.unit",product.getUnit(),sWebLanguage);

            // line unit price out
            sUnitPrice = deci.format(product.getUnitPrice());

            // supplier
            sSupplierUid = checkString(product.getSupplierUid());
            if(sSupplierUid.length() > 0) sSupplierName = getTranNoLink("service",sSupplierUid,sWebLanguage);
            else                          sSupplierName = "";

            // productGroup
            sProductGroup = checkString(product.getProductGroup());
            if(sProductGroup.length() > 0){
                sProductGroup = getTranNoLink("product.productgroup",sProductGroup,sWebLanguage);
            }

            // productSubGroup
            sProductSubGroup = checkString(product.getProductSubGroup());
            if(sProductSubGroup.length() > 0){
                sProductSubGroup = getTranNoLink("product.productsubgroup",sProductSubGroup,sWebLanguage);
            }

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";

            //*** display product in one row ***
            html.append("<tr class='list"+sClass+"' onmouseover=\"this.style.cursor='pointer';\" onmouseout=\"this.style.cursor='default';\" title='"+detailsTran+"'>")
                 .append("<td><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' title='"+deleteTran+"' onclick=\"doDeleteProduct('"+sProductUid+"');\">")
                 .append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+product.getCode()+"</td>")
                 .append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+product.getName()+"</td>")
                 .append(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==0?"":"<td onclick=\"doShowDetails('"+sProductUid+"');\">"+checkString(product.getRxnormcode())+"</td>")
                 .append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+sUnit+"</td>")
                 .append("<td align='right' onclick=\"doShowDetails('"+sProductUid+"');\">"+sUnitPrice.replaceAll(",",".")+" "+sCurrency+"</td>")
                 .append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+sSupplierName+"</td>");
            
            if(MedwanQuery.getInstance().getConfigInt("showProductGroup",1)==1){
                html.append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+sProductGroup+"</td>");
            }
            if(MedwanQuery.getInstance().getConfigInt("showProductCategory",1)==1){
                html.append("<td onclick=\"doShowDetails('"+sProductUid+"');\">"+sProductSubGroup+"</td>");
            }
            
            html.append("</tr>");
        }

        return html;
    }
%>

<%
    String sAction = checkString(request.getParameter("Action"));

    // retreive form data
    String sEditProductUid       = checkString(request.getParameter("EditProductUid")),
           sEditProductName      = checkString(request.getParameter("EditProductName")),
           sEditProductDose      = checkString(request.getParameter("EditProductDose")),
           sEditProductCode      = checkString(request.getParameter("EditProductCode")),
           sEditProductDHIS2     = checkString(request.getParameter("EditProductDHIS2")),
           sEditUnit             = checkString(request.getParameter("EditUnit")),
           sEditRoute            = checkString(request.getParameter("EditRoute")),
           sEditUnitPrice        = checkString(request.getParameter("EditUnitPrice")),
           sEditPackageUnits     = checkString(request.getParameter("EditPackageUnits")),
           sEditMinOrderPackages = checkString(request.getParameter("EditMinOrderPackages")),
           sEditSupplierUid      = checkString(request.getParameter("EditSupplierUid")),
           sEditTimeUnit         = checkString(request.getParameter("EditTimeUnit")),
           sEditTimeUnitCount    = checkString(request.getParameter("EditTimeUnitCount")),
           sEditUnitsPerTimeUnit = checkString(request.getParameter("EditUnitsPerTimeUnit")),
           sEditTotalUnits       = checkString(request.getParameter("EditTotalUnits")),
           sEditBarcode          = checkString(request.getParameter("EditBarcode")),
           sEditAtccode          = checkString(request.getParameter("EditAtccode")),
           sEditRxnormcode          = checkString(request.getParameter("EditRxnormcode")),
           sEditPrestationCode   = checkString(request.getParameter("EditPrestationCode")),
           sEditPrestationQuantity = checkString(request.getParameter("EditPrestationQuantity")),
           sEditMargin           = checkString(request.getParameter("EditMargin")),
           sEditApplyLowerPrices = checkString(request.getParameter("EditApplyLowerPrices")),
           sEditAutomaticInvoicing = checkString(request.getParameter("EditAutomaticInvoicing")),
           sEditProductGroup     = checkString(request.getParameter("EditProductGroup")),
   		   sEditProductSubGroup  = checkString(request.getParameter("EditProductSubGroup")),
		   sEditNoWarehouseOrder  = checkString(request.getParameter("EditNoWarehouseOrder"));
    String sEditProductSubGroupDescr = "";

    String  sTime1 = checkString(request.getParameter("time1")),
            sTime2 = checkString(request.getParameter("time2")),
            sTime3 = checkString(request.getParameter("time3")),
            sTime4 = checkString(request.getParameter("time4")),
            sTime5 = checkString(request.getParameter("time5")),
            sTime6 = checkString(request.getParameter("time6"));

    String  sQuantity1 = checkString(request.getParameter("quantity1")),
            sQuantity2 = checkString(request.getParameter("quantity2")),
            sQuantity3 = checkString(request.getParameter("quantity3")),
            sQuantity4 = checkString(request.getParameter("quantity4")),
            sQuantity5 = checkString(request.getParameter("quantity5")),
            sQuantity6 = checkString(request.getParameter("quantity6"));

    ProductSchema productSchema = new ProductSchema();
    if(sTime1.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime1,sQuantity1));
    }
    if(sTime2.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime2,sQuantity2));
    }
    if(sTime3.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime3,sQuantity3));
    }
    if(sTime4.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime4,sQuantity4));
    }
    if(sTime5.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime5,sQuantity5));
    }
    if(sTime6.length() > 0){
        productSchema.getTimequantities().add(new KeyValue(sTime6,sQuantity6));
    }

    String sEditSupplierName = checkString(request.getParameter("EditSupplierName"));

    String msg = "", sFindProductName, sFindProductCode, sFindUnit, sFindUnitPriceMin,
           sFindProductGroup, sFindUnitPriceMax, sFindPackageUnits, sFindMinOrderPackages = "",
           sFindSupplierUid, sSelectedProductName = "", sSelectedProductDose = "", sSelectedProductDHIS2 = "", sSelectedProductCode = "", sSelectedUnit = "", sSelectedUnitPrice = "",
           sSelectedPackageUnits = "", sSelectedMinOrderPackages = "", sSelectedSupplierUid = "",
           sSelectedTimeUnit = "", sFindSupplierName, sSelectedTimeUnitCount = "", sAverageUnitPrice="0",
           sSelectedUnitsPerTimeUnit = "", sSelectedSupplierName = "", sSelectedProductGroup = "",
           sSelectedProductSubGroup = "", sSelectedBarcode = "", sSelectedAtccode = "", sSelectedRxnormcode = "", sSelectedPrestationCode = "", 
           sSelectedPrestationQuantity = "", sSelectedApplyLowerPrices = "", sSelectedAutomaticInvoicing = "", sSelectedTotalUnits="", sSelectedRoute="";
    String sSelectedMargin = MedwanQuery.getInstance().getConfigString("defaultProductsMargin","");

    // get data from form
    sFindProductName  = checkString(request.getParameter("FindProductName"));
    sFindProductCode  = checkString(request.getParameter("FindProductCode"));
    sFindUnit         = checkString(request.getParameter("FindUnit"));
    sFindUnitPriceMin = checkString(request.getParameter("FindUnitPriceMin"));
    sFindUnitPriceMax = checkString(request.getParameter("FindUnitPriceMax"));
    sFindPackageUnits = checkString(request.getParameter("FindPackageUnits"));
    sFindMinOrderPackages = checkString(request.getParameter("FindMinOrderPackages"));
    sFindSupplierUid  = checkString(request.getParameter("FindSupplierUid"));
    sFindSupplierName = checkString(request.getParameter("FindSupplierName"));
    sFindProductGroup = checkString(request.getParameter("FindProductGroup"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n********************** pharmacy/manageProducts.jsp *********************");
        Debug.println("sAction               : "+sAction);
        Debug.println("sEditProductUid       : "+sEditProductUid);
        Debug.println("sEditProductName      : "+sEditProductName);
        Debug.println("sEditProductDHIS2      : "+sEditProductDHIS2);
        Debug.println("sEditProductDose      : "+sEditProductDose);
        Debug.println("sEditProductCode      : "+sEditProductCode);
        Debug.println("sEditUnit             : "+sEditUnit);
        Debug.println("sEditUnitPrice        : "+sEditUnitPrice);
        Debug.println("sEditPackageUnits     : "+sEditPackageUnits);
        Debug.println("sEditMinOrderPackages : "+sEditMinOrderPackages);
        Debug.println("sEditSupplierUid      : "+sEditSupplierUid);
        Debug.println("sEditTimeUnit         : "+sEditTimeUnit);
        Debug.println("sEditTimeUnitCount    : "+sEditTimeUnitCount);
        Debug.println("sEditUnitsPerTimeUnit : "+sEditUnitsPerTimeUnit);
        Debug.println("sEditTotalUnits       : "+sEditTotalUnits);
        Debug.println("sEditProductGroup     : "+sEditProductGroup+"\n");
        Debug.println("sFindProductName      : "+sFindProductName);
        Debug.println("sFindUnit             : "+sFindUnit);
        Debug.println("sFindUnitPriceMin     : "+sFindUnitPriceMin);
        Debug.println("sFindUnitPriceMax     : "+sFindUnitPriceMax);
        Debug.println("sFindPackageUnits     : "+sFindPackageUnits);
        Debug.println("sFindMinOrderPackages : "+sFindMinOrderPackages);
        Debug.println("sFindSupplierUid      : "+sFindSupplierUid);
        Debug.println("sFindProductGroup     : "+sFindProductGroup+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    int foundProductCount = 0;
    StringBuffer productsHtml = null;
    boolean displayEditFields = false, displayFoundRecords = false;

    String sDisplaySearchFields = checkString(request.getParameter("DisplaySearchFields"));
    if(sDisplaySearchFields.length()==0) sDisplaySearchFields = "true"; // default
    boolean displaySearchFields = sDisplaySearchFields.equalsIgnoreCase("true");
    Debug.println("@@@ displaySearchFields : "+displaySearchFields);

    //*********************************************************************************************
    //*** process actions *************************************************************************
    //*********************************************************************************************

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditProductUid.length() > 0){
        // create product
        Product product = new Product();
        
        product.setUid(sEditProductUid);
        product.setCode(sEditProductCode);
        product.setName(sEditProductName);
        product.setDose(sEditProductDose);
        product.setDhis2code(sEditProductDHIS2);
        product.setRoute(sEditRoute);
        product.setUnit(sEditUnit);
        product.setSupplierUid(sEditSupplierUid);
        product.setTimeUnit(sEditTimeUnit);
        product.setUpdateUser(activeUser.userid);
        product.setProductGroup(sEditProductGroup);
        product.setProductSubGroup(sEditProductSubGroup);
        product.setBarcode(sEditBarcode);
        product.setAtccode(sEditAtccode);
        product.setRxnormcode(sEditRxnormcode);
        product.setPrestationcode(sEditPrestationCode);
        
        if(sEditUnitPrice.length() > 0) product.setUnitPrice(Double.parseDouble(sEditUnitPrice));
        if(sEditPackageUnits.length() > 0) product.setPackageUnits(Integer.parseInt(sEditPackageUnits));
        if(sEditMinOrderPackages.length() > 0) product.setMinimumOrderPackages(Integer.parseInt(sEditMinOrderPackages));
        if(sEditPrestationQuantity.length() > 0) product.setPrestationquantity(Integer.parseInt(sEditPrestationQuantity));
        if(sEditTimeUnitCount.length() > 0) product.setTimeUnitCount(Integer.parseInt(sEditTimeUnitCount));
        if(sEditUnitsPerTimeUnit.length() > 0) product.setUnitsPerTimeUnit(Double.parseDouble(sEditUnitsPerTimeUnit));
        if(sEditTotalUnits.length() > 0) product.setTotalUnits(Double.parseDouble(sEditTotalUnits));
        if(sEditMargin.length() > 0) product.setMargin(Double.parseDouble(sEditMargin));
		if(sEditApplyLowerPrices.length()>0) product.setApplyLowerPrices(Integer.parseInt(sEditApplyLowerPrices)==1);
		if(sEditAutomaticInvoicing.length()>0) product.setAutomaticInvoicing(Integer.parseInt(sEditAutomaticInvoicing)==1);
		if(sEditNoWarehouseOrder.length()>0) {
			Pointer.storePointer("nowarehouseorder."+sEditProductUid, "1");
		}
		else{
			Pointer.deletePointers("nowarehouseorder."+sEditProductUid);
		}
		
		// does product exist ?
        String existingProductUid = product.exists();
        boolean productExists = existingProductUid.length() > 0;

        if(sEditProductUid.equals("-1")){
            //***** insert new product *****
            if(!productExists){
                product.store();

                // save schema
                productSchema.setProductuid(product.getUid());
                productSchema.store();

                // show saved data
                sAction = "findShowOverview"; // showDetails
                msg = getTran(request,"web","dataissaved",sWebLanguage);
            }
            //***** reject new addition thru update *****
            else{
                // show rejected data
                sAction = "showDetailsAfterAddReject";
                msg = "<font color='red'>"+getTran(request,"web.manage","productexists",sWebLanguage)+"</font>";
            }
        }
        else{
            //***** update existing product *****
            product.store(false);

            // save schema
            productSchema.setProductuid(product.getUid());
            productSchema.store();

            // show saved data
            sAction = "findShowOverview"; // showDetails
            msg = getTran(request,"web","dataissaved",sWebLanguage);
        }

        sEditProductUid = product.getUid();
        
        // Update pump
        if(request.getParameter("pump.price")!=null && request.getParameter("pump.quantity")!=null){
        	double pump_price = 0, pump_quantity = 0;
        	String pump_date=checkString(request.getParameter("pump_date"));
        	try{
        		pump_price = Double.parseDouble(request.getParameter("pump.price"));
        		pump_quantity = Double.parseDouble(request.getParameter("pump.quantity"));
        		
        		if(pump_price > 0 && pump_quantity > 0){
        			Pointer.deleteLoosePointers("drugprice."+product.getUid()+".");
        			Pointer.deleteLoosePointers("pump."+product.getUid());
        			if(pump_date.length()>0){
            			Pointer.storePointer("drugprice."+product.getUid()+".0.0",pump_quantity+";"+pump_price,ScreenHelper.parseDate(pump_date));
        				Pointer.storePointer("pump."+product.getUid(),pump_price+"",ScreenHelper.parseDate(pump_date));
        			}
        			else{
            			Pointer.storePointer("drugprice."+product.getUid()+".0.0",pump_quantity+";"+pump_price);
        				Pointer.storePointer("pump."+product.getUid(),pump_price+"");
        			}
        		}
        	}
        	catch(Exception e){
        		e.printStackTrace();
        	}
        }
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete") && sEditProductUid.length() > 0){
        Product.delete(sEditProductUid);
        ProductSchema productSchemaToDelete = ProductSchema.getSingleProductSchema(sEditProductUid);
        productSchemaToDelete.delete();

        msg = getTran(request,"web","dataisdeleted",sWebLanguage);
        sAction = "findShowOverview"; // display overview even if only one record remains
    }

    //-- FIND -------------------------------------------------------------------------------------
    if(sAction.startsWith("find")){
        displaySearchFields = true;
        displayFoundRecords = true;

        if(sAction.equals("findShowOverview")){
            displayEditFields = false;

            sFindProductName = "";
            sFindUnit = "";
            sFindUnitPriceMin = "";
            sFindUnitPriceMax = "";
            sFindPackageUnits = "";
            sFindMinOrderPackages = "";
            sFindSupplierUid = "";
            sFindProductGroup = "";
        }

        Vector products = Product.findWithCode(sFindProductCode,sFindProductName,sFindUnit,sFindUnitPriceMin,sFindUnitPriceMax,sFindPackageUnits,
                                       sFindMinOrderPackages,sFindSupplierUid,sFindProductGroup,"OC_PRODUCT_NAME","ASC");
        productsHtml = objectsToHtml(products,sWebLanguage);
        foundProductCount = products.size();

        // do not get data from DB, but show data that were allready in the search-form
        sSelectedProductName = sFindProductName;
        sSelectedProductCode = sFindProductCode;
        sSelectedUnit = sFindUnit;
        sSelectedRoute = "";
        sSelectedUnitPrice = "";
        sSelectedProductDose="";
        sSelectedPackageUnits = sFindPackageUnits;
        sSelectedMinOrderPackages = sFindMinOrderPackages;
        sSelectedSupplierUid = sFindSupplierUid;
        sSelectedTimeUnit = "";
        sSelectedTimeUnitCount = "";
        sSelectedUnitsPerTimeUnit = "";
        sSelectedBarcode = "";
        sSelectedAtccode = "";
        sSelectedRxnormcode = "";
        sSelectedPrestationCode = "";
        sSelectedPrestationQuantity = "0";
        sSelectedMargin = MedwanQuery.getInstance().getConfigString("defaultProductsMargin","");
        sSelectedApplyLowerPrices = "0";
        sSelectedAutomaticInvoicing = "0";

        sSelectedProductGroup = sFindProductGroup;
        sSelectedProductSubGroup = "";
        sSelectedSupplierName = sFindSupplierName;
    }

    //--- SHOW DETAILS ----------------------------------------------------------------------------
    if(sAction.startsWith("showDetails")){
        displayEditFields = true;
        displaySearchFields = false;

        // get specified record
        if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
            Product product = Product.get(sEditProductUid);

            if(product!=null){
                sSelectedProductName = checkString(product.getName());
                sSelectedProductDose = checkString(product.getDose());
                sSelectedProductDHIS2 = checkString(product.getDhis2code());
                sSelectedProductCode = checkString(product.getCode());
                sSelectedUnit = checkString(product.getUnit());
                sSelectedRoute = checkString(product.getRoute());
                sSelectedUnitPrice = (product.getUnitPrice() < 0 ? "" : product.getUnitPrice()+"");
                sSelectedPackageUnits = (product.getPackageUnits() <= 0 ? "" : product.getPackageUnits()+"");
                sSelectedMinOrderPackages = (product.getMinimumOrderPackages() < 0 ? "" : product.getMinimumOrderPackages()+"");
                sSelectedSupplierUid = checkString(product.getSupplierUid());
                sSelectedTimeUnit = checkString(product.getTimeUnit());
                sSelectedTimeUnitCount = (product.getTimeUnitCount() < 0 ? "" : product.getTimeUnitCount()+"");
                sSelectedUnitsPerTimeUnit = (product.getUnitsPerTimeUnit() < 0 ? "" : product.getUnitsPerTimeUnit()+"");
                sSelectedTotalUnits = (product.getTotalUnits() < 0 ? "" : product.getTotalUnits()+"");
                sSelectedProductGroup = checkString(product.getProductGroup());
                sSelectedProductSubGroup = checkString(product.getProductSubGroup());
                sSelectedSupplierName = getTranNoLink("Service",sSelectedSupplierUid,sWebLanguage);
                sSelectedBarcode = checkString(product.getBarcode());
                sSelectedAtccode = checkString(product.getAtccode());
                sSelectedRxnormcode = checkString(product.getRxnormcode());
                sSelectedPrestationCode = checkString(product.getPrestationcode());
                sAverageUnitPrice = product.getLastYearsAveragePrice()+"";
                sSelectedPrestationQuantity = product.getPrestationquantity()+"";
                sSelectedMargin = product.getMargin()+"";
                sSelectedApplyLowerPrices = product.isApplyLowerPrices()?"1":"0";
                sSelectedAutomaticInvoicing = product.isAutomaticInvoicing()?"1":"0";
                sEditProductSubGroup = checkString(product.getProductSubGroup());
            }

            productSchema = ProductSchema.getSingleProductSchema(product.getUid());
        }
        else if(sAction.equals("showDetailsAfterAddReject")){
            // do not get data from DB, but show data that were allready on form
            sSelectedProductName = sEditProductName;
            sSelectedProductDose = sEditProductDose;
            sSelectedProductDHIS2 = sEditProductDHIS2;
            sSelectedProductCode = sEditProductCode;
            sSelectedUnit = sEditUnit;
            sSelectedRoute = sEditRoute;
            sSelectedUnitPrice = sEditUnitPrice;
            sSelectedPackageUnits = sEditPackageUnits;
            sSelectedMinOrderPackages = sEditMinOrderPackages;
            sSelectedSupplierUid = sEditSupplierUid;
            sSelectedTimeUnit = sEditTimeUnit;
            sSelectedTimeUnitCount = sEditTimeUnitCount;
            sSelectedUnitsPerTimeUnit = sEditUnitsPerTimeUnit;
            sSelectedTotalUnits = sEditTotalUnits;
            sSelectedProductGroup = sEditProductGroup;
            sSelectedProductSubGroup = sEditProductSubGroup;
            sSelectedSupplierName = sEditSupplierName;
            sSelectedBarcode = sEditBarcode;
            sSelectedAtccode = sEditAtccode;
            sSelectedRxnormcode = sEditRxnormcode;
            sSelectedPrestationCode = sEditPrestationCode;
            sSelectedPrestationQuantity = sEditPrestationQuantity;
            sSelectedMargin = sEditMargin;
            sSelectedApplyLowerPrices = sEditApplyLowerPrices;
            sSelectedAutomaticInvoicing = sEditAutomaticInvoicing;
        }
        else{
            // do not get data from DB, but show data that were allready in the search-form
            sSelectedProductName = sFindProductName;
            sSelectedProductCode = sFindProductCode;
            sSelectedProductDose = "";
            sSelectedProductDHIS2 = "";
            sSelectedUnit = sFindUnit;
            sSelectedRoute = "";
            sSelectedUnitPrice = "";
            sSelectedPackageUnits = sFindPackageUnits;
            sSelectedMinOrderPackages = sFindMinOrderPackages;
            sSelectedSupplierUid = sFindSupplierUid;
            sSelectedTimeUnit = "";
            sSelectedTimeUnitCount = "";
            sSelectedUnitsPerTimeUnit = "";
            sSelectedBarcode = "";
            sSelectedAtccode = "";
            sSelectedRxnormcode = "";
            sSelectedPrestationCode = "";
            sSelectedPrestationQuantity = "0";
            sSelectedMargin=MedwanQuery.getInstance().getConfigString("defaultProductsMargin","");
            sSelectedApplyLowerPrices = "0";
            sSelectedAutomaticInvoicing = "0";

            sSelectedProductGroup = sFindProductGroup;
            sSelectedProductSubGroup = "";
            sSelectedSupplierName = sFindSupplierName;
        }
    }

    // onclick : when editing, save, else search when pressing 'enter'
    String sOnKeyDown;
    if(sAction.startsWith("showDetails")){
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSaveProduct();}\"";
    }
    else{
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSearchProduct();}\"";
    }
%>
<form name="transactionForm" id="transactionForm" method="post" <%=sOnKeyDown%> <%=(displaySearchFields?"onClick=\"clearMessage();\"":"onClick=\"setSaveButton();clearMessage();\" onKeyUp=\"setSaveButton();\"")%>>
    <%=writeTableHeader("Web.manage","ManageProducts",sWebLanguage," doBack();")%>
    
    <%
        //*****************************************************************************************
        //*** process display options *************************************************************
        //*****************************************************************************************

        //--- SEARCH FIELDS -----------------------------------------------------------------------
        if(displaySearchFields){
            %>
                <table width="100%" class="list" cellspacing="1" onClick="transactionForm.onkeydown='if(enterEvent(event,13)){doSearchProduct();}';" onKeyDown="if(enterEvent(event,13)){doSearchProduct();}">
                    <%-- product name --%>
                    <tr>
                        <td class="admin2" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","productCode",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindProductCode" size="<%=sTextWidth%>" maxLength="255" value="<%=sFindProductCode%>">
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="admin2" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","productName",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindProductName" size="<%=sTextWidth%>" maxLength="255" value="<%=sFindProductName%>">
                        </td>
                    </tr>
                    
                    <%-- unit --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","unit",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <select class="text" name="FindUnit"  >
                                <option value=""></option>
                                <%=ScreenHelper.writeSelect(request,"product.unit",sFindUnit,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    
                    <%-- UnitPrice --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","UnitPrice",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%=getTran(request,"web","from",sWebLanguage)%>&nbsp;<input class="text" type="text" name="FindUnitPriceMin" size="15" maxLength="15" value="<%=sFindUnitPriceMin%>" onKeyUp="isNumber(this);">
                            <%=getTran(request,"web","till",sWebLanguage)%>&nbsp;<input class="text" type="text" name="FindUnitPriceMax" size="15" maxLength="15" value="<%=sFindUnitPriceMax%>" onKeyUp="isNumber(this);">
                            <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
                        </td>
                    </tr>
                    
                    <%-- PackageUnits --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","PackageUnits",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input class="text" type="text" name="FindPackageUnits" size="5" maxLength="5" value="<%=sFindPackageUnits%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- MinOrderPackages (long translation, so force widths) --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","MinOrderPackages",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" width="100%">
                            <input class="text" type="text" name="FindMinOrderPackages" size="5" maxLength="5" value="<%=sFindMinOrderPackages%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>

                    <%-- supplier --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","supplier",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input type="hidden" name="FindSupplierUid" value="<%=sFindSupplierUid%>">
                            <input class="text" type="text" name="FindSupplierName" readonly size="<%=sTextWidth%>" value="<%=sFindSupplierName%>">

                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchSupplier('FindSupplierUid','FindSupplierName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindSupplierUid.value='';transactionForm.FindSupplierName.value='';">
                        </td>
                    </tr>
                    
                    <%-- productGroup --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","productgroup",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <select class="text" name="FindProductGroup">
                                <option value=""></option>
                                <%=ScreenHelper.writeSelect(request,"product.productgroup",sSelectedProductGroup,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    
                    <%-- SEARCH BUTTONS --%>
                    <tr>
                        <td class="admin2">&nbsp;</td>
                        <td class="admin2">
                            <input type="button" class="button" name="searchButton" value="<%=getTranNoLink("Web","search",sWebLanguage)%>" onclick="doSearchProduct();">
                            <input type="button" class="button" name="clearButton" value="<%=getTranNoLink("Web","Clear",sWebLanguage)%>" onclick="clearSearchFields();">
                            <input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNewProduct();">
                           
                            <%-- display message --%>
                            <span id="msgArea"><%=msg%></span>
                        </td>
                    </tr>
                </table>
                <br>
            <%
        }
        else{
            //*** search fields as hidden fields to be able to revert to the overview ***
            %>
                <input type="hidden" name="FindProductName" value="<%=sFindProductName%>">
                <input type="hidden" name="FindProductCode" value="<%=sFindProductCode%>">
                <input type="hidden" name="FindUnit" value="<%=sFindUnit%>">
                <input type="hidden" name="FindUnitPriceMin" value="<%=sFindUnitPriceMin%>">
                <input type="hidden" name="FindUnitPriceMax" value="<%=sFindUnitPriceMax%>">
                <input type="hidden" name="FindPackageUnits" value="<%=sFindPackageUnits%>">
                <input type="hidden" name="FindMinOrderPackages" value="<%=sFindMinOrderPackages%>">
                <input type="hidden" name="FindSupplierUid" value="<%=sFindSupplierUid%>">
                <input type="hidden" name="FindSupplierName" value="<%=sFindSupplierName%>">
                <input type="hidden" name="FindProductGroup" value="<%=sFindProductGroup%>">
            <%
        }

        //--- SEARCH RESULTS ----------------------------------------------------------------------
        if(displayFoundRecords){
            if(foundProductCount > 0){                
                %>
                    <table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                        <%-- header --%>
                        <tr class="admin">
                            <td width="20">&nbsp;</td>
                            <td><%=getTran(request,"Web","productCode",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","productName",sWebLanguage)%></td>
                            <%
                            	if(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==1){
                            %>
	                            <td><%=getTran(request,"Web","rxnormcode",sWebLanguage)%></td>
                            <%
                            	}
                            %>
                            <td><%=getTran(request,"Web","Unit",sWebLanguage)%></td>
                            <td align="right"><%=getTran(request,"Web","unitprice",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","supplier",sWebLanguage)%></td>
                            <%
                            	if(MedwanQuery.getInstance().getConfigInt("showProductGroup",1)==1){
                                    %><td><%=getTran(request,"Web","productGroup",sWebLanguage)%></td><%
                            	}
	                            if(MedwanQuery.getInstance().getConfigInt("showProductCategory",1)==1){
                                    %><td><%=getTran(request,"Web","productSubGroup",sWebLanguage)%></td><%
	                            }
                            %>
                        </tr>
                        <tbody class="hand"><%=productsHtml%></tbody>
                    </table>
                    
                    <%-- number of records found --%>
                    <span style="width:49%;text-align:left;">
                        <%=foundProductCount%> <%=getTran(request,"web","recordsfound",sWebLanguage)%>
                    </span>
                <%
                
                if(foundProductCount > 20){
                    // link to top of page
                    %>
                        <span style="width:51%;text-align:right;">
                            <a href="#topp" class="topbutton">&nbsp;</a>
                        </span>
                        <br>
                    <%
                }
            }
            else{
                // no records found
                %><%=getTran(request,"web","norecordsfound",sWebLanguage)%><%
            }
        }

        //--- EDIT FIELDS -------------------------------------------------------------------------
        if(displayEditFields){
            DecimalFormat doubleFormat = new DecimalFormat("#.#");
            
            %>
                <table class="list" width="100%" cellspacing="1">
                    <%-- UnitPrice --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","id",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input disabled class="greytext" type="text" name="Code" size="15" maxLength="15" value="<%=sEditProductUid%>"/>
                        </td>
                    </tr>
                    
                    <%-- product code --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","productCode",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditProductCode" id="EditProductCode" size="<%=sTextWidth%>" maxLength="255" value="<%=sSelectedProductCode%>">
                            <%if(activeUser.getAccessRight("pharmacy.mergeproducts.select") && sSelectedProductCode.trim().length()>0 && Product.findWithCode(sSelectedProductCode, "", "", "", "", "", "", "", "", "OC_PRODUCT_CODE", "ASC").size()>1){%>
                            	<input type='button' class='button' name='mergebutton' id='mergebutton' value='<%=getTranNoLink("web","merge",sWebLanguage) %>' onclick='mergeproducts()'/> <div id='mergediv'/>
                            <%} %>
                        </td>
                    </tr>
                    
                    <%-- dosage --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","dhis2code",sWebLanguage)%></td>
                        <td class="admin2">
                        	<%	
                        		if(MedwanQuery.getInstance().getConfigInt("enableBurundi",0)==1){ 
                        			out.println("<select class='text' name='EditProductDHIS2' id='EditProductDHIS2'>");
                        			out.println("<option/>");
    								SortedMap drugs = new TreeMap();
                        			String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
                        	        SAXReader reader = new SAXReader(false);
                        	        Document document;
                        			try {
                        				document = reader.read(new java.io.File(dhis2document));
                        				Element root = document.getRootElement();
                        				Iterator i = root.elementIterator("dataset");
                        				while(i.hasNext()){
                        					Element dataset = (Element)i.next();
                        					if(checkString(dataset.attributeValue("type")).equalsIgnoreCase("pharmacy")){
                        						Iterator dataElements = dataset.element("dataelements").elementIterator("dataelement");
                        						while(dataElements.hasNext()){
                        							Element dataElement = (Element)dataElements.next();
                        							if(checkString(dataElement.attributeValue("productcode")).length()>0){
                        								drugs.put(checkString(dataElement.attributeValue("label")).trim(),checkString(dataElement.attributeValue("productcode")));
                        							}
                        						}
                        					}	
                        				}
                        			} catch (Exception e) {
                        				e.printStackTrace();
                        			}
                        			Iterator iDrugs =drugs.keySet().iterator();
                        			while(iDrugs.hasNext()){
                        				String key = (String)iDrugs.next();
                        				out.println("<option value='"+drugs.get(key)+"' "+(sSelectedProductDHIS2.equalsIgnoreCase((String)drugs.get(key))?"selected":"")+">"+key+"</option>");
                        			}
                        			out.println("</select>");
                        		}
                        		else {
                        	%>
	                            	<input class="text" type="text" name="EditProductDHIS2" id="EditProductDHIS2" size="15" value="<%=sSelectedProductDHIS2%>">
	                        <%	} %>
                        </td>
                    </tr>

                    <%-- product name --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","productName",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditProductName" id="EditProductName" size="<%=sTextWidth%>" maxLength="255" value="<%=sSelectedProductName%>">
                        </td>
                    </tr>
                    
                    <%-- dosage --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","dose",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditProductDose" id="EditProductDose" size="15" value="<%=sSelectedProductDose%>">
                        </td>
                    </tr>
                    
                    <%-- route --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","route",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="EditRoute">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelect(request,"product.route",sSelectedRoute,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    
                    <%-- unit --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","unit",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <select class="text" name="EditUnit" onChange="setEditUnitsPerTimeUnitLabel();">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelect(request,"product.unit",sSelectedUnit,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    
                    <%-- UnitPrice --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","UnitPrice",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditUnitPrice" size="15" maxLength="15" value="<%=sSelectedUnitPrice%>" onKeyUp="isNumber(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
                        </td>
                    </tr>
                    
                    <%-- AverageUnitPrice --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","lastyearsaverageprice",sWebLanguage)%></td>
                        <td class="admin2">
                            <input disabled class="greytext" type="text" name="AverageUnitPrice" size="15" maxLength="15" value="<%=ScreenHelper.getPriceFormat(Double.parseDouble(sAverageUnitPrice))%>" onKeyUp="isNumber(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
                        </td>
                    </tr>
                    <%
                    	long day=24*3600*1000;
                    %>
                    <%-- Last Year Average Price --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","reinitialize.lastyearsaverageprice",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" name="pump.price" size="15" maxLength="15" value="" onKeyUp="isNumber(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>
                            &nbsp; <%=getTran(request,"Web","quantity",sWebLanguage)+(Product.get(sEditProductUid)==null?"":" (max <b>"+Product.get(sEditProductUid).getTotalQuantityAvailable()+"</b>)")%>: <input type="text" name="pump.quantity" size="15" maxLength="15" value="" onKeyUp="isNumber(this);">
                            &nbsp; <%=getTran(request,"Web","date",sWebLanguage)%>: <%=ScreenHelper.writeDateField("pump_date", "transactionForm", ScreenHelper.formatDate(new java.util.Date(new java.util.Date().getTime()-365*day)), true, false, sWebLanguage, sCONTEXTPATH) %>
                        </td>
                    </tr>
                    
                    <%-- PackageUnits --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","PackageUnits",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditPackageUnits" size="5" maxLength="5" value="<%=sSelectedPackageUnits%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- MinOrderPackages (long translation, so force widths) --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","MinOrderPackages",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2" width="100%">
                            <input class="text" type="text" name="EditMinOrderPackages" size="5" maxLength="5" value="<%=sSelectedMinOrderPackages%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    <%-- supplier --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","supplier",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input type="hidden" name="EditSupplierUid" value="<%=sSelectedSupplierUid%>">
                            <input class="text" type="text" name="EditSupplierName" readonly size="<%=sTextWidth%>" value="<%=sSelectedSupplierName%>">

                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchSupplier('EditSupplierUid','EditSupplierName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditSupplierUid.value='';transactionForm.EditSupplierName.value='';">
                        </td>
                    </tr>
                    
                    <%
                    	if(MedwanQuery.getInstance().getConfigInt("showProductGroup",1)==1){
                    %>
                    <%-- productGroup --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","productGroup",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="EditProductGroup" id="EditProductGroup">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelect(request,"product.productgroup",sSelectedProductGroup,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    <%
                    	}
                    
                    	if(MedwanQuery.getInstance().getConfigInt("showProductCategory",1)==1){
                    %>
                    <%-- productSubGroup --%>
                    <%
	                    if(sEditProductSubGroup.length()>0){
	                    	sEditProductSubGroupDescr = getTranNoLink("drug.category",sEditProductSubGroup,sWebLanguage);
	                    }
                    %>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","productSubGroup",sWebLanguage)%></td>
                        <td class="admin2">
		                    <input type="text" readonly class="text" name="EditProductSubGroupText" value="<%=sEditProductSubGroup+" "+sEditProductSubGroupDescr%>" size="120">
		                 
		                    <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchCategory('EditProductSubGroup','EditProductSubGroupText');">
		                    <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditProductSubGroup.value='';EditProductSubGroupText.value='';">
		                    <input type="hidden" name="EditProductSubGroup" id="EditProductSubGroup" value="<%=sEditProductSubGroup%>" onchange="updateDrugCategoryParents(this.value)">
		                    <div name="drugcategorydiv" id="drugcategorydiv"></div>
                        </td>
                    </tr>
                    <%
                    	}
                    %>
                    
                    <%-- prescription-rule --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","defaultprescriptionrule",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%-- Units Per Time Unit --%>
                            <input type="text" class="text" style="vertical-align:-1px;" name="EditUnitsPerTimeUnit" value="<%=(sSelectedUnitsPerTimeUnit.length()>0?(doubleFormat.format(Double.parseDouble(sSelectedUnitsPerTimeUnit))).replaceAll(",","."):"")%>" size="5" maxLength="5" onKeyUp="isNumber(this);">
                            <span id="EditUnitsPerTimeUnitLabel"></span>
                            <%-- Time Unit Count --%>
                            &nbsp;<%=getTran(request,"web","per",sWebLanguage)%>
                            <input type="text" class="text" style="vertical-align:-1px;" name="EditTimeUnitCount" value="<%=sSelectedTimeUnitCount%>" size="5" maxLength="5" onKeyUp="isInteger(this);"/>
                            <%-- Time Unit (dropdown : Hour|Day|Week|Month) --%>
                            <select class="text" name="EditTimeUnit" onChange="setEditUnitsPerTimeUnitLabel();setEditTimeUnitCount();" style="vertical-align:-3px;">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelectUnsorted(request,"prescription.timeunit",sSelectedTimeUnit,sWebLanguage)%>
                            </select>
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" style="vertical-align:-4px;" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="clearDescriptionRule();">
                        </td>
                    </tr>
                    <%-- Default units --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","defaultunits",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditTotalUnits" size="15" maxLength="15" value="<%=(sSelectedTotalUnits.length()>0?(doubleFormat.format(Double.parseDouble(sSelectedTotalUnits))).replaceAll(",","."):"")%>" onKeyUp="isNumber(this);">
                        </td>
                    </tr>
                    
                    
                    <%-- schema --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","schema",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <table>
                                <tr>
                                    <td><input class="text" type="text" name="time1" value="<%=productSchema.getTimeQuantity(0).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                    <td><input class="text" type="text" name="time2" value="<%=productSchema.getTimeQuantity(1).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                    <td><input class="text" type="text" name="time3" value="<%=productSchema.getTimeQuantity(2).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                    <td><input class="text" type="text" name="time4" value="<%=productSchema.getTimeQuantity(3).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                    <td><input class="text" type="text" name="time5" value="<%=productSchema.getTimeQuantity(4).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                    <td><input class="text" type="text" name="time6" value="<%=productSchema.getTimeQuantity(5).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                                </tr>
                                <tr>
                                    <td><input class="text" type="text" name="quantity1" value="<%=productSchema.getTimeQuantity(0).getValue()%>" size="2">#</td>
                                    <td><input class="text" type="text" name="quantity2" value="<%=productSchema.getTimeQuantity(1).getValue()%>" size="2">#</td>
                                    <td><input class="text" type="text" name="quantity3" value="<%=productSchema.getTimeQuantity(2).getValue()%>" size="2">#</td>
                                    <td><input class="text" type="text" name="quantity4" value="<%=productSchema.getTimeQuantity(3).getValue()%>" size="2">#</td>
                                    <td><input class="text" type="text" name="quantity5" value="<%=productSchema.getTimeQuantity(4).getValue()%>" size="2">#</td>
                                    <td><input class="text" type="text" name="quantity6" value="<%=productSchema.getTimeQuantity(5).getValue()%>" size="2">#</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    
                    <%-- Barcode --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","barcode",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditBarcode" size="50" maxLength="50" value="<%=sSelectedBarcode%>" >
                        </td>
                    </tr>
                    
                    <%if(MedwanQuery.getInstance().getConfigString("edition").equalsIgnoreCase("bloodbank")){ %>
                    <%-- Bloodgroup --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","bloodgroup",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="EditAtccode" id="EditAtccode">
                            	<option/>
                            	<%=ScreenHelper.writeSelect(request,"abobloodgroup", sSelectedAtccode, sWebLanguage) %>
                            </select>
                        </td>
                    </tr>
                    <%}
                      else {
                    %>
                    <%-- ATCcode --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","atccode",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditAtccode" id="EditAtccode" size="50" maxLength="50" value="<%=sSelectedAtccode%>" >
                            <img src='<c:url value="_img/icons/icon_search.png"/>' onclick='findAtcCodes()'/>
                        </td>
                    </tr>
                    <%} %>
                    <%-- RxNorm --%>
                    <%
                    	if(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==1){
                    %>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","rxnormcode",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditRxnormcode" id="EditRxnormcode" size="50" maxLength="50" value="<%=sSelectedRxnormcode%>" >
                            <img src='<c:url value="_img/icons/icon_search.png"/>' title='<%=getTranNoLink("web","find_rxnorm_codes",sWebLanguage) %>' onclick='findRxNormCodes()'/>
                            <img src='<c:url value="_img/icons/icon_interactions.png"/>' title='<%=getTranNoLink("web","find_interactions",sWebLanguage) %>' onclick='findRxNormInteractions()'/>
                            <div id='rxnormcodediv'></div>
                        </td>
                    </tr>
                    <%
                    	}
                    	else {
                    %>
                    	<input type='hidden' value="<%=sSelectedRxnormcode%>" name="EditRxnormcode" id="EditRxnormcode" />
                    <%
                    	}
                    %>
                    <%-- PrestationCode --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","prestation",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditPrestationCode" id="EditPrestationCode" size="10" maxLength="50" value="<%=sSelectedPrestationCode%>" ><img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrestation();"> x <input class="text" type="text" name="EditPrestationQuantity" size="3" maxLength="10" value="<%=sSelectedPrestationQuantity%>" >
                            <%
                            	String sEditPrestationName = "";
                            	if(sSelectedPrestationCode.length() > 0){
                            		Prestation prestation = Prestation.get(sSelectedPrestationCode);
                            		if(prestation!=null){
                            			sEditPrestationName = checkString(prestation.getDescription());
                            		}
                            	}
                            %>
                            <input class="greytext" readonly disabled type="text" name="EditPrestationName" id="EditPrestationName" value="<%=sEditPrestationName%>" size="50"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","automatic.invoicing",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" class="hand" name="EditAutomaticInvoicing" value="1" <%=sSelectedAutomaticInvoicing.equalsIgnoreCase("1")?"checked":"" %>>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","margin",sWebLanguage)%></td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditMargin" size="15" maxLength="15" value="<%=sSelectedMargin%>" onKeyUp="isNumber(this);">% <%=getTran(request,"web","zero.is.nocalculation",sWebLanguage)%>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","apply.lower.prices",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" class="hand" name="EditApplyLowerPrices" value="1" <%=sSelectedApplyLowerPrices.equalsIgnoreCase("1")?"checked":"" %>>
                        </td>
                    </tr>
                    <%if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==1){%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","nowarehouseorder",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" class="hand" name="EditNoWarehouseOrder" value="1" <%=Pointer.getPointer("nowarehouseorder."+sEditProductUid).length()>0?"checked":"" %>>
                        </td>
                    </tr>
                    <%} %>
                    
                    <%-- EDIT BUTTONS --%>
                    <tr>
                        <td class="admin2"/>
                        <td class="admin2">
                            <%
                                if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
                                    // existing product : display saveButton with save-label
                                    %>
                                        <input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSaveProduct();">
                                        <input class="button" type="button" name="deleteButton" value='<%=getTranNoLink("Web","delete",sWebLanguage)%>' onclick="doDeleteProduct('<%=sEditProductUid%>');">
                                        <input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","backtooverview",sWebLanguage)%>' onclick="doBackToOverview();">
                                    <%
                                }
                                else if(sAction.equals("showDetailsNew") || sAction.equals("showDetailsAfterAddReject")){
                                    // new product : display saveButton with add-label
                                    %>
                                        <input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","add",sWebLanguage)%>' onclick="doAddProduct();">
                                        <input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","back",sWebLanguage)%>' onclick="doBack();">
                                    <%
                                }
                            %>
                            <%-- display message --%>
                            <span id="msgArea"><%=msg%></span>
                        </td>
                    </tr>
                </table>
                
                <script>
                  setEditUnitsPerTimeUnitLabel();

                  <%-- set editUnitsPerTimeUnitLabel --%>
                  function setEditUnitsPerTimeUnitLabel(){
                    var unitTran;

                    if(transactionForm.EditUnit.value.length==0){
                      unitTran = '<%=getTranNoLink("web","units",sWebLanguage)%>';
                    }
                    else{
                      <%
                          Vector unitTypes = ScreenHelper.getProductUnitTypes(sWebLanguage);
                          for(int i=0; i<unitTypes.size(); i++){
                              %>
                                  var unitTran<%=(i+1)%> = "<%=getTran(null,"product.units",(String)unitTypes.get(i),sWebLanguage).toLowerCase()%>"
                                  if(transactionForm.EditUnit.value=="<%=unitTypes.get(i)%>") unitTran = unitTran<%=(i+1)%>;
                              <%
                          }
                      %>
                    }
                    document.getElementById("EditUnitsPerTimeUnitLabel").innerHTML = unitTran;
                  }

                  <%-- set setEditTimeUnitCount --%>
                  function setEditTimeUnitCount(){
                    if(transactionForm.EditTimeUnit.selectedIndex > 0){
                      if(transactionForm.EditTimeUnitCount.value.length==0){
                        transactionForm.EditTimeUnitCount.value = "1";
                      }
                    }
                  }

                  <%-- clear description rule --%>
                  function clearDescriptionRule(){
                    transactionForm.EditUnitsPerTimeUnit.value = "";
                    transactionForm.EditTimeUnitCount.value = "";
                    transactionForm.EditTimeUnit.value = "";
					transactionForm.EditTotalUnits.value="";
                  }
                </script>

                <%-- indication of obligated fields --%>
                <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>
            <%
        }
    %>
    
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="EditProductUid" value="<%=sEditProductUid%>">
    <input type="hidden" name="DisplaySearchFields" value="<%=displaySearchFields%>">
</form>

<%-- SCRIPTS ------------------------------------------------------------------------------------%>
<script>
  <%-- FILL GROUP --%>
  function fillGroup(selectname,type,selectedvalue){
	document.getElementById(selectname).options.length = 0;
	
	<%
		Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
		if(labelTypes!=null){
			Hashtable labelIds = (Hashtable)labelTypes.get("product.productgroup");
			if(labelIds!=null){
				Enumeration e = labelIds.keys();
				while(e.hasMoreElements()){
					String type = (String)e.nextElement();
					out.print("if(type=='"+type+"'){");
					
					// Voor dit type gaan we nu de opties zetten
					Hashtable options = (Hashtable)labelTypes.get("product.productsubgroup."+type.toLowerCase());
					if(options!=null){
						SortedMap treeset = new TreeMap();
						Enumeration oe = options.elements();
						while(oe.hasMoreElements()){
							Label lbl = (Label)oe.nextElement();
							treeset.put(lbl.value,lbl);
						}
						
						Iterator soe = treeset.keySet().iterator();
						int counter = 0;
						while(soe.hasNext()){
							Label lbl = (Label)treeset.get(soe.next());
							String optionkey=lbl.id.replace("'","´");
							String optionvalue=lbl.value.replace("'","´");
							out.println("document.getElementById(selectname).options["+counter+"] = new Option('"+optionvalue+"','"+optionkey+"',false,selectedvalue=='"+optionkey+"');");
							counter++;
						}
					}
					out.print("document.getElementById(selectname).onchange();");
					out.print("}");
				}
			}
		}
	%>
  }

  <%
      // default focus field
      if(displayEditFields){
          %>transactionForm.EditProductName.focus();<%
      }

      if(displaySearchFields){
          %>transactionForm.FindProductName.focus();<%
      }
  %>

  <%-- DO ADD PRODUCT --%>
  function doAddProduct(){
    transactionForm.EditProductUid.value = "-1";
    doSaveProduct();
  }

  <%-- DO SAVE PRODUCT --%>
  function doSaveProduct(){
    if(checkProductFields()){
      transactionForm.saveButton.disabled = true;
      transactionForm.Action.value = "save";
      transactionForm.submit();
    }
    else{
      if(transactionForm.EditProductName.value.length==0){
        transactionForm.EditProductName.focus();
      }
      else if(transactionForm.EditUnit.value.length==0){
        transactionForm.EditUnit.focus();
      }
      else if(transactionForm.EditUnitPrice.value.length==0){
        transactionForm.EditUnitPrice.focus();
      }
      else if(transactionForm.EditPackageUnits.value.length==0){
        transactionForm.EditPackageUnits.focus();
      }
    }
  }

  <%-- CHECK PRODUCT FIELDS --%>
  function checkProductFields(){
    var maySubmit = true;

    <%-- required fields --%>
    if(!transactionForm.EditProductName.value.length>0 ||
       !transactionForm.EditUnit.value.length>0 ||
       !transactionForm.EditUnitPrice.value.length>0 ||
       !transactionForm.EditPackageUnits.value.length>0){
      maySubmit = false;
      alertDialog("web.manage","dataMissing");
    }

    <%-- one rule-field specified -> all rule-fields specified --%>
    if(transactionForm.EditUnitsPerTimeUnit.value.length > 0 ||
       transactionForm.EditTimeUnitCount.value.length > 0 ||
       transactionForm.EditTimeUnit.value.length > 0){
      if(!transactionForm.EditUnitsPerTimeUnit.value.length > 0 ||
         !transactionForm.EditTimeUnitCount.value.length > 0 ||
         !transactionForm.EditTimeUnit.value.length > 0){
        maySubmit = false;
        alertDialog("web.manage","dataMissing");

        if(transactionForm.EditUnitsPerTimeUnit.value.length==0){
          transactionForm.EditUnitsPerTimeUnit.focus();
        }
        else if(transactionForm.EditTimeUnitCount.value.length==0){
          transactionForm.EditTimeUnitCount.focus();
        }
        else{
          transactionForm.EditTimeUnit.focus();
        }
      }
    }

    return maySubmit;
  }

  <%-- DO DELETE PRODUCT --%>
  function doDeleteProduct(productUid){
      if(yesnoDeleteDialog()){
      transactionForm.EditProductUid.value = productUid;
      transactionForm.Action.value = "delete";
      transactionForm.submit();
    }
  }

  <%-- DO NEW PRODUCT --%>
  function doNewProduct(){
    transactionForm.searchButton.disabled = true;
    transactionForm.clearButton.disabled = true;
    transactionForm.newButton.disabled = true;

    transactionForm.Action.value = "showDetailsNew";
    transactionForm.submit();
  }

  <%-- DO SHOW DETAILS --%>
  function doShowDetails(productUid){
    if(transactionForm.searchButton!=undefined) transactionForm.searchButton.disabled = true;
    if(transactionForm.clearButton!=undefined) transactionForm.clearButton.disabled = true;
    if(transactionForm.newButton!=undefined) transactionForm.newButton.disabled = true;

    transactionForm.EditProductUid.value = productUid;
    transactionForm.Action.value = "showDetails";
    transactionForm.DisplaySearchFields.value = "true";
    transactionForm.submit();
  }

  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    transactionForm.FindProductCode.value = "";
    transactionForm.FindProductName.value = "";
    transactionForm.FindUnit.value = "";
    transactionForm.FindUnitPriceMin.value = "";
    transactionForm.FindUnitPriceMax.value = "";
    transactionForm.FindPackageUnits.value = "";
    transactionForm.FindMinOrderPackages.value = "";
    transactionForm.FindProductGroup.value = "";

    transactionForm.FindSupplierUid.value = "";
    transactionForm.FindSupplierName.value = "";
  }

  <%-- SEARCH PRESTATION --%>
  function searchPrestation(){
    transactionForm.EditPrestationCode.value = "";
    openPopup("/_common/search/searchPrestation.jsp&ts=<%=getTs()%>&ReturnFieldUid=EditPrestationCode&ReturnFieldDescr=EditPrestationName");
  }

  function findRxNormCodes(){
	    document.getElementById('rxnormcodediv').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
	    
	    var params = 'initkey='+document.getElementById("EditProductName").value.replace("%","pct")+'&returnField=EditRxnormcode';
	    var url = '<c:url value="/pharmacy/popups/findRxNormCode.jsp"/>?ts='+new Date()+'&PopupWidth=800&PopupHeight=600';
		new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	  	    openPopup("/pharmacy/popups/showpopup.jsp&ts=<%=getTs()%>",800,600);
		    $('rxnormcodediv').innerHTML = "";
	      },
		  onFailure: function(resp){
		    $('rxnormcodediv').innerHTML = "";
	      }
		});
	}

  function findRxNormInteractions(){
	    openPopup("/pharmacy/popups/findRxNormInteractions.jsp&ts=<%=getTs()%>&initkey="+document.getElementById("EditRxnormcode").value,800,600);
	}

  function findAtcCodes(){
	    window.open('<%=MedwanQuery.getInstance().getConfigString("FindATCCodeURL","http://www.whocc.no/atc_ddd_index/?")%>name='+document.getElementById("EditProductName").value.replace("%",""),"ATC","toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=600,menubar=no");
  }

  <%-- CLEAR EDIT FIELDS --%>
  function clearEditFields(){
    transactionForm.EditProductName.value = "";
    transactionForm.EditProductCode.value = "";
    transactionForm.EditUnit.value = "";
    transactionForm.EditUnitPrice.value = "";
    transactionForm.EditPackageUnits.value = "";
    transactionForm.EditMinOrderPackages.value = "";

    transactionForm.EditSupplierUid.value = "";
    transactionForm.EditSupplierName.value = "";

    transactionForm.EditTimeUnit.value = "";
    transactionForm.EditTimeUnitCount.value = "";
    transactionForm.EditUnitsPerTimeUnit.value = "";
    transactionForm.EditTotalUnits.value = "";
    transactionForm.EditProductGroup.value = "";
  }

  <%-- DO SEARCH PRODUCT --%>
  function doSearchProduct(){
    if(transactionForm.FindProductName.value.length>0 ||
       transactionForm.FindProductCode.value.length>0 ||
       transactionForm.FindUnit.value.length>0 ||
       transactionForm.FindUnitPriceMin.value.length>0 ||
       transactionForm.FindUnitPriceMax.value.length>0 ||
       transactionForm.FindPackageUnits.value.length>0 ||
       transactionForm.FindMinOrderPackages.value.length>0 ||
       transactionForm.FindSupplierUid.value.length>0 ||
       transactionForm.FindProductGroup.value.length>0){
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

  <%-- popup : search supplier --%>
  function searchSupplier(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&SearchExternalServices=true&VarCode="+serviceUidField+"&VarText="+serviceNameField+"&FindParentCode=<%=checkString(MedwanQuery.getInstance().getConfigString("serviceGroupProviders"))%>");
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
      transactionForm.Action.value = "find";
      transactionForm.DisplaySearchFields.value = "true";
      transactionForm.submit();
    }
  }

  <%-- DO BACK --%>
  function doBack(){
    <%
        // close if this window is a popup
        if(checkString(request.getParameter("Close")).length() > 0){
            out.print("window.close();");
        }
    %>
    window.location.href = "<c:url value='/main.do'/>?Page=pharmacy/manageProducts.jsp&DisplaySearchFields=true&ts=<%=getTs()%>";
  }
  
  <%-- SEARCH CATEGORY --%>
  function searchCategory(CategoryUidField,CategoryNameField){
    openPopup("/_common/search/searchDrugCategory.jsp&ts=<%=getTs()%>&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
  }

  <%-- UPDATE DRUG CATEGORY PARENTS --%>
  function updateDrugCategoryParents(code){
	    document.getElementById('drugcategorydiv').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading..";
	    
	    var params = 'code='+code+'&language=<%=sWebLanguage%>';
	    var url = '<c:url value="/pharmacy/updateDrugCategoryParents.jsp"/>?ts='+new Date();
		new Ajax.Request(url,{
	      method: "GET",
	      parameters: params,
	      onSuccess: function(resp){
	        $('drugcategorydiv').innerHTML = resp.responseText;
	      },
		  onFailure: function(resp){
		    $('drugcategorydiv').innerHTML = "";
	      }
		});
	  }

  function mergeproducts(){
	    openPopup("/pharmacy/mergeProducts.jsp&ts=<%=getTs()%>&productUid=<%=sEditProductUid%>",400,300);
	  }

  if(document.getElementById('EditProductSubGroup')!=null){
    window.setTimeout("updateDrugCategoryParents(document.getElementById('EditProductSubGroup').value)",500);
  }

  <%-- close "search in progress"-popup that might still be open --%>
  var popup = window.open("","Searching","width=1,height=1");
  popup.close();
</script>

<%=writeJSButtons("transactionForm","saveButton")%>
