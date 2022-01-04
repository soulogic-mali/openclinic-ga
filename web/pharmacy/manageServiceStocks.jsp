<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*,
                java.util.StringTokenizer,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"pharmacy.manageservicestocks","select",activeUser)%>
<%=sJSSORTTABLE%>
<%=sJSPROTOTYPE %>

<%!
//--- ADD AUTHORIZED USER ---------------------------------------------------------------------
private String addAuthorizedUser(int userIdx, String userName, String sWebLanguage){
  StringBuffer html = new StringBuffer();

  html.append("<tr id='rowAuthorizedUsers"+userIdx+"'>")
       .append("<td width='18'>")
        .append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteAuthorizedUser(rowAuthorizedUsers"+userIdx+");' class='link' alt='"+getTranNoLink("web","delete",sWebLanguage)+"'>")
       .append("</td>")
       .append("<td>"+userName+"</td>")
      .append("</tr>");

  return html.toString();
}

//--- ADD RECEIVING USER ---------------------------------------------------------------------
private String addReceivingUser(int userIdx, String userName, String sWebLanguage){
  StringBuffer html = new StringBuffer();

  html.append("<tr id='rowReceivingUsers"+userIdx+"'>")
       .append("<td width='18'>")
        .append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteReceivingUser(rowReceivingUsers"+userIdx+");' class='link' alt='"+getTranNoLink("web","delete",sWebLanguage)+"'>")
       .append("</td>")
       .append("<td>"+userName+"</td>")
      .append("</tr>");

  return html.toString();
}

//--- ADD DISPENSING USER ---------------------------------------------------------------------
private String addDispensingUser(int userIdx, String userName, String sWebLanguage){
  StringBuffer html = new StringBuffer();

  html.append("<tr id='rowDispensingUsers"+userIdx+"'>")
       .append("<td width='18'>")
        .append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteDispensingUser(rowDispensingUsers"+userIdx+");' class='link' alt='"+getTranNoLink("web","delete",sWebLanguage)+"'>")
       .append("</td>")
       .append("<td>"+userName+"</td>")
      .append("</tr>");

  return html.toString();
}

//--- ADD DISPENSING USER ---------------------------------------------------------------------
private String addValidationUser(int userIdx, String userName, String sWebLanguage){
  StringBuffer html = new StringBuffer();

  html.append("<tr id='rowValidationUsers"+userIdx+"'>")
       .append("<td width='18'>")
        .append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteValidationUser(rowValidationUsers"+userIdx+");' class='link' alt='"+getTranNoLink("web","delete",sWebLanguage)+"'>")
       .append("</td>")
       .append("<td>"+userName+"</td>")
      .append("</tr>");

  return html.toString();
}

    //--- OBJECTS TO HTML -------------------------------------------------------------------------
    private StringBuffer objectsToHtml(Vector objects, String sWebLanguage, User activeUser,String showHidden,boolean bActivePatientPrescription,String showUnauthorized){
        StringBuffer html = new StringBuffer();
        Vector authorizedUserIds, receivingUserIds;
        String sClass = "1", sServiceStockUid = "", sServiceUid = "", sServiceName = "", sAuthorizedUserIds, sReceivingUserIds,
               sManagerUid = "", sPreviousManagerUid = "", sManagerName = "";
        StringTokenizer tokenizer;

        // frequently used translations
        String detailsTran        = getTranNoLink("web","showdetails",sWebLanguage),
               deleteTran         = getTranNoLink("Web","delete",sWebLanguage),
               productStockTran   = getTranNoLink("web.manage","productstockmanagement",sWebLanguage),
               calculateOrderTran = getTranNoLink("Web.manage","calculateOrder",sWebLanguage);

        // run thru found serviceStocks
        ServiceStock serviceStock;
        for(int i=0; i<objects.size(); i++){
            serviceStock = (ServiceStock) objects.get(i);
            if(showUnauthorized==null && !serviceStock.isAuthorizedUser(activeUser.userid)){
            	continue;
            }
            if(serviceStock.getHidden()<1 || showHidden!=null){
	            sServiceStockUid = serviceStock.getUid();
	
	            // translate service name
	            sServiceUid = serviceStock.getServiceUid();
	            sServiceName = getTranNoLink("Service",sServiceUid,sWebLanguage);
	
	            // only search manager-name when different manager-UID
	            sManagerUid = checkString(serviceStock.getStockManagerUid());
	            if(sManagerUid.length() > 0){
	                if(!sManagerUid.equals(sPreviousManagerUid)){
	                    sPreviousManagerUid = sManagerUid;
	                    sManagerName = ScreenHelper.getFullUserName(sManagerUid);
	                }
	            }
	
	            // number of products in serviceStock
	            int productCount = ServiceStock.getProductStockCount(sServiceStockUid);
	
	            // alternate row-style
	            if(sClass.equals("")) sClass = "1";
	            else                  sClass = "";
	
	            //*** display stock in one row ***
	            html.append("<tr class='list"+sClass+"' title='"+detailsTran+"'>")
	                 .append("<td>");
	            
	            if((serviceStock.isAuthorizedUser(activeUser.userid) || activeUser.getAccessRight("sa")) && activeUser.getAccessRight("pharmacy.manageservicestocks.delete")){
	                html.append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' class='link' onclick=\"doDelete('"+sServiceStockUid+"');\" title='"+deleteTran+"'/>").
	                     append("<img src='"+sCONTEXTPATH+"/_img/icons/icon_edit.png' class='link' onclick=\"printFiche('"+sServiceStockUid+"','"+serviceStock.getName()+"');\" title='"+getTranNoLink("web","stockfiche",sWebLanguage)+"'/>");
	            }
	            
	            if(serviceStock.getNosync()==0){
	                html.append("&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/icon_sync.gif' class='link' alt='"+getTranNoLink("web","sync",sWebLanguage)+"'/>");
	            }
	            if(serviceStock.isReceivingUser(activeUser.userid) && serviceStock.hasOpenDeliveries()){
	                html.append("&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/icon_incoming.gif' class='link' alt='"+getTranNoLink("web","incoming",sWebLanguage)+"'' onclick='javascript:bulkReceive(\""+serviceStock.getUid()+"\");'/></a>");
	            }
	            if(serviceStock.hasOpenOrders()){
	                html.append("&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/icon_order.gif' class='link' alt='"+getTranNoLink("web","orders",sWebLanguage)+"'' onclick='javascript:acceptOrders(\""+serviceStock.getUid()+"\");'/></a>");
	            }
	            if(serviceStock.isValidationUser(activeUser.userid) && serviceStock.hasUnvalidatedDeliveries(activeUser.userid)){
	                html.append("&nbsp;<img src='"+sCONTEXTPATH+"/_img/icons/icon_validate.png' class='link' alt='"+getTranNoLink("web","validate",sWebLanguage)+"'' onclick='javascript:validateDeliveries(\""+serviceStock.getUid()+"\");'/></a>");
	            }
	            html.append("</td>");
	            
	            html.append("<td onclick=\"doShowDetails('"+sServiceStockUid+"');\">"+serviceStock.getUid()+" "+serviceStock.getName()+"</td>")
	                .append("<td onclick=\"doShowDetails('"+sServiceStockUid+"');\">"+sServiceName+"</td>")
	                .append("<td onclick=\"doShowDetails('"+sServiceStockUid+"');\">"+sManagerName+"</td>")
	                .append("<td onclick=\"doShowDetails('"+sServiceStockUid+"');\">"+productCount+"</td>");
	
	            // display "manage product stocks"-button when user is authorized
	            if(serviceStock.isAuthorizedUser(activeUser.userid)){
	                html.append("<td>");
	                //If the patient has outstanding prescriptions, show the 'patient' button
	                if(bActivePatientPrescription){
		                html.append("<input type='button' class='button' value='"+getTran(null,"web","patient",sWebLanguage)+"' onclick=\"doPatientPrescription('"+sServiceStockUid+"');\">&nbsp;");
	                }
	                html.append("<input type='button' class='button' value='"+calculateOrderTran+"' onclick=\"doCalculateOrder('"+sServiceStockUid+"','"+sServiceName+"');\">&nbsp;")
	                     .append("<input type='button' class='button' value='"+productStockTran+"' onclick=\"displayProductStockManagement('"+sServiceStockUid+"','"+sServiceUid+"');\">&nbsp;")
	                     .append(activeUser.getAccessRight("patient.copypharmacystocks.select")?"<input type='button' class='button' value='"+getTranNoLink("web","copy",sWebLanguage)+"' onclick=\"copyProducts('"+sServiceStockUid+"');\">&nbsp;":"")
	                    .append("</td>");
	            } 
	            else{
	                html.append("<td onclick=\"doShowDetails('"+sServiceStockUid+"');\">&nbsp;</td>");
	            }
	
	            html.append("</tr>");
            }
        }

        return html;
    }
%>

<%
    String centralPharmacyCode = MedwanQuery.getInstance().getConfigString("centralPharmacyCode");
	long day = 24*3600*1000;
	long prescriptionvalidity=MedwanQuery.getInstance().getConfigInt("activePrescriptionValidityPeriodInDays",30);
	java.util.Date dStart = new java.util.Date(new java.util.Date().getTime()-prescriptionvalidity*day);
	boolean bHasActivePrescriptions = activePatient==null?false:Prescription.findUndelivered(activePatient.personid,ScreenHelper.formatDate(dStart)).size()>0;

    String sAction = checkString(request.getParameter("Action"));
    if(sAction.length()==0){
    	sAction = "find";
    }

    // retreive form data
    String sEditStockUid           = checkString(request.getParameter("EditStockUid")),
           sEditStockName          = checkString(request.getParameter("EditStockName")),
           sEditServiceUid         = checkString(request.getParameter("EditServiceUid")),
           sEditBegin              = checkString(request.getParameter("EditBegin")),
           sEditEnd                = checkString(request.getParameter("EditEnd")),
           sEditManagerUid         = checkString(request.getParameter("EditManagerUid")),
           sEditVirtualInvoicingAccountUid         = checkString(request.getParameter("EditVirtualInvoicingAccountUid")),
           sEditDefaultSupplierUid = checkString(request.getParameter("EditDefaultSupplierUid")),
           sEditOrderPeriod        = checkString(request.getParameter("EditOrderPeriodInMonths")),
           sEditHidden        	   = checkString(request.getParameter("EditHidden")),
           sEditValidateOutgoing   = checkString(request.getParameter("EditValidateOutgoing")),
           sEditRemoteSyncId   	   = checkString(request.getParameter("EditRemoteSyncId")),
    	   sEditNosync        	   = checkString(request.getParameter("EditNosync"));
    

	   if(sEditHidden.equalsIgnoreCase("")){
		   sEditHidden = "0";
	   }

	   if(sEditValidateOutgoing.equalsIgnoreCase("")){
		   sEditValidateOutgoing = "0";
	   }

    // afgeleide data
    String sEditServiceName         = checkString(request.getParameter("EditServiceName")),
           sEditManagerName         = checkString(request.getParameter("EditManagerName")),
           sEditVirtualInvoicingAccountName         = checkString(request.getParameter("EditVirtualInvoicingAccountName")),
           sEditDefaultSupplierName = checkString(request.getParameter("EditDefaultSupplierName"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************* pharmacy/manageServiceStocks.jsp *******************");
        Debug.println("sEditStockUid        : "+sEditStockUid);
        Debug.println("sEditStockName       : "+sEditStockName);
        Debug.println("sEditServiceUid      : "+sEditServiceUid);
        Debug.println("sEditBegin           : "+sEditBegin);
        Debug.println("sEditEnd             : "+sEditEnd);
        Debug.println("sEditManagerUi       : "+sEditManagerUid);
        Debug.println("sEditDefSupplierUid  : "+sEditDefaultSupplierUid);
        Debug.println("sEditOrderPeriod     : "+sEditOrderPeriod);
        Debug.println("sEditServiceName     : "+sEditServiceName);
        Debug.println("sEditManagerName     : "+sEditManagerName);
        Debug.println("sEditHidden          : "+sEditHidden);
        Debug.println("sEditValidateOutgoing: "+sEditValidateOutgoing);
        Debug.println("sEditDefSupplierName : "+sEditDefaultSupplierName+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String msg = "", sFindStockName = "", sFindServiceUid = "", sFindServiceName = "",
           sFindBegin = "", sFindEnd = "", sFindManagerUid = "", sSelectedStockName = "",
           sSelectedServiceUid = "", sSelectedBegin = "", sSelectedEnd = "", sSelectedManagerUid = "", sSelectedVirtualInvoicingAccountUid="",sSelectedVirtualInvoicingAccountName="",
           sSelectedServiceName = "", sSelectedManagerName = "", authorizedUserId = "", receivingUserId = "", dispensingUserId = "", validationUserId="",
           authorizedUserName = "", receivingUserName = "", dispensingUserName = "", validationUserName="", sFindDefaultSupplierUid = "", sFindDefaultSupplierName = "",
           sSelectedDefaultSupplierUid = "", sSelectedDefaultSupplierName = "", sSelectedOrderPeriod = "",
           sSelectedNosync="",sSelectedHidden="",sSelectedValidateOutgoing="";

    StringBuffer stocksHtml = null;
    int foundStockCount = 0, authorisedUsersIdx = 1, receivingUsersIdx = 1, dispensingUsersIdx = 1, validationUsersIdx=1;
    StringBuffer authorizedUsersHTML = new StringBuffer(),
            authorizedUsersJS = new StringBuffer(),
            authorizedUsersDB = new StringBuffer();

    StringBuffer receivingUsersHTML = new StringBuffer(),
            receivingUsersJS = new StringBuffer(),
            receivingUsersDB = new StringBuffer();

    StringBuffer dispensingUsersHTML = new StringBuffer(),
    		dispensingUsersJS = new StringBuffer(),
    		dispensingUsersDB = new StringBuffer();

    StringBuffer validationUsersHTML = new StringBuffer(),
    		validationUsersJS = new StringBuffer(),
    				validationUsersDB = new StringBuffer();

    // display options
    boolean displayEditFields = false, displayFoundRecords = false;

    String sDisplaySearchFields = checkString(request.getParameter("DisplaySearchFields"));
    if(sDisplaySearchFields.length()==0) sDisplaySearchFields = "true"; // default
    boolean displaySearchFields = sDisplaySearchFields.equalsIgnoreCase("true");
    Debug.println("@@@ displaySearchFields : "+displaySearchFields);

    String sDisplayActiveServiceStocks = checkString(request.getParameter("DisplayActiveServiceStocks"));
    if(sDisplayActiveServiceStocks.length()==0) sDisplayActiveServiceStocks = "true"; // default
    boolean displayActiveServiceStocks = sDisplayActiveServiceStocks.equalsIgnoreCase("true");
    Debug.println("@@@ displayActiveServiceStocks : "+displayActiveServiceStocks);

    //*********************************************************************************************
    //*** process actions *************************************************************************
    //*********************************************************************************************

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditStockUid.length()>0){
        // create service stock
        ServiceStock stock = new ServiceStock();
        stock.setUid(sEditStockUid);
        stock.setName(sEditStockName);
        stock.setServiceUid(sEditServiceUid);
        if(sEditBegin.length() > 0)       stock.setBegin(ScreenHelper.parseDate(sEditBegin));
        if(sEditEnd.length() > 0)         stock.setEnd(ScreenHelper.parseDate(sEditEnd));
        if(sEditOrderPeriod.length() > 0) stock.setOrderPeriodInMonths(Integer.parseInt(sEditOrderPeriod));
        stock.setNosync(Integer.parseInt(SH.c(sEditNosync).length()==0?"0":sEditNosync));
        if(sEditHidden.length() > 0) stock.setHidden(Integer.parseInt(sEditHidden));
        if(sEditValidateOutgoing.length() > 0) stock.setValidateoutgoingtransactions(Integer.parseInt(sEditValidateOutgoing));
        stock.setStockManagerUid(sEditManagerUid);
        stock.setVirtualInvoicingAccount(sEditVirtualInvoicingAccountUid);
        stock.setDefaultSupplierUid(sEditDefaultSupplierUid);

        // authorized users
        User authorizedUserObj;
        String authorizedUserIds = checkString(request.getParameter("EditAuthorizedUsers"));
        if(authorizedUserIds.length() > 0){
            authorisedUsersIdx = 1;
            StringTokenizer idTokenizer = new StringTokenizer(authorizedUserIds,"$");
            while(idTokenizer.hasMoreTokens()){
                authorizedUserId = idTokenizer.nextToken();
                authorizedUserObj = User.get(Integer.parseInt(authorizedUserId));
                stock.addAuthorizedUser(authorizedUserObj);
            }
        }

        // authorized users
        User receivingUserObj;
        String receivingUserIds = checkString(request.getParameter("EditReceivingUsers"));
        if(receivingUserIds.length() > 0){
            receivingUsersIdx = 1;
            StringTokenizer idTokenizer = new StringTokenizer(receivingUserIds,"$");
            while(idTokenizer.hasMoreTokens()){
                receivingUserId = idTokenizer.nextToken();
                receivingUserObj = User.get(Integer.parseInt(receivingUserId));
                stock.addReceivingUser(receivingUserObj);
            }
        }

        // dispensing users
        User dispensingUserObj;
        String dispensingUserIds = checkString(request.getParameter("EditDispensingUsers"));
        if(dispensingUserIds.length() > 0){
        	dispensingUsersIdx = 1;
            StringTokenizer idTokenizer = new StringTokenizer(dispensingUserIds,"$");
            while(idTokenizer.hasMoreTokens()){
            	dispensingUserId = idTokenizer.nextToken();
            	dispensingUserObj = User.get(Integer.parseInt(dispensingUserId));
                stock.addDispensingUser(dispensingUserObj);
            }
        }

        // validation users
        User validationUserObj;
        String validationUserIds = checkString(request.getParameter("EditValidationUsers"));
        if(validationUserIds.length() > 0){
        	validationUsersIdx = 1;
            StringTokenizer idTokenizer = new StringTokenizer(validationUserIds,"$");
            while(idTokenizer.hasMoreTokens()){
            	validationUserId = idTokenizer.nextToken();
            	validationUserObj = User.get(Integer.parseInt(validationUserId));
                stock.addValidationUser(validationUserObj);
            }
        }

        stock.setUpdateUser(activeUser.userid);

        // does stock exist ?
        String existingStockUid = stock.exists();
        boolean stockExists = existingStockUid.length()>0;

        if(sEditStockUid.equals("-1")){
            //***** insert new stock *****
            if(!stockExists){
                stock.store();

                // show saved data
                sAction = "findShowOverview"; // showDetails
                msg = " | "+getTran(request,"web","dataissaved",sWebLanguage);
            }
            //***** reject new addition thru update *****
            else{
                // show rejected data
                sAction = "showDetailsAfterAddReject";
                msg = " | <font color='red'>"+getTran(request,"web.manage","stockexists",sWebLanguage)+"</font>";
            }
        }
        else{
            //***** update existing stock *****
            if(!stockExists){
                stock.store();

                // show saved data
                sAction = "findShowOverview"; // showDetails
                msg = " | "+getTran(request,"web","dataissaved",sWebLanguage);
            }
            //***** reject double record thru update *****
            else{
                if(sEditStockUid.equals(existingStockUid)){
                    // nothing : just updating a record with its own data
                    if(stock.changed()){
                        stock.store();
                        msg = " | "+getTran(request,"web","dataissaved",sWebLanguage);
                    }
                    sAction = "findShowOverview"; // showDetails
                }
                else{
                    // tried to update one stock with exact the same data as an other stock
                    // show rejected data
                    sAction = "showDetailsAfterUpdateReject";
                    msg = " | "+"<font color='red'>"+getTran(request,"web.manage","stockexists",sWebLanguage)+"</font>";
                }
            }
        }

        sEditStockUid = stock.getUid();
        MedwanQuery.getInstance().setConfigString("remoteSyncId."+stock.getUid(),sEditRemoteSyncId);
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete") && sEditStockUid.length()>0){
    	ServiceStock serviceStock = ServiceStock.get(sEditStockUid);
    	if(serviceStock!=null){
    		serviceStock.setUpdateUser(activeUser.userid);
    		serviceStock.store();
    	}
        ServiceStock.deleteProductStocks(sEditStockUid);
        ServiceStock.delete(sEditStockUid);
        msg = " | "+getTran(request,"web","dataisdeleted",sWebLanguage);
        sAction = "findShowOverview"; // display overview even if only one record remains
    }
   if(SH.c(sEditNosync).length()==0){
	   sEditNosync = "1";
   }

    //--- FIND ------------------------------------------------------------------------------------
    if(sAction.startsWith("find")){
        displayActiveServiceStocks = false;
        displayEditFields = false;
        displayFoundRecords = true;

        if(sAction.equals("findShowOverview")){
            displaySearchFields = true;
        }

        // get data from form
        sFindStockName          = checkString(request.getParameter("FindStockName"));
        sFindBegin              = checkString(request.getParameter("FindBegin"));
        sFindEnd                = checkString(request.getParameter("FindEnd"));
        sFindManagerUid         = checkString(request.getParameter("FindManagerUid"));
        sFindServiceUid         = checkString(request.getParameter("FindServiceUid"));
        sFindDefaultSupplierUid = checkString(request.getParameter("FindDefaultSupplierUid"));

        Vector serviceStocks = ServiceStock.find(sFindStockName,sFindServiceUid,sFindBegin,sFindEnd,
                                                 sFindManagerUid,sFindDefaultSupplierUid,"OC_STOCK_NAME","ASC");
        stocksHtml = objectsToHtml(serviceStocks,sWebLanguage,activeUser,request.getParameter("showhidden"),bHasActivePrescriptions,request.getParameter("showunauthorized"));
        foundStockCount = serviceStocks.size();
    }

    //--- SHOW DETAILS ----------------------------------------------------------------------------
    if(sAction.startsWith("showDetails")){
        displayEditFields = true;
        displaySearchFields = false;

        // get specified record
        if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
            ServiceStock serviceStock = ServiceStock.get(sEditStockUid);

            if(serviceStock!=null){
                sSelectedStockName          = checkString(serviceStock.getName());
                sSelectedServiceUid         = checkString(serviceStock.getServiceUid());
                sSelectedManagerUid         = checkString(serviceStock.getStockManagerUid());
                sSelectedVirtualInvoicingAccountUid         = checkString(serviceStock.getVirtualInvoicingAccount());
                sSelectedDefaultSupplierUid = checkString(serviceStock.getDefaultSupplierUid());
                sSelectedOrderPeriod        = (serviceStock.getOrderPeriodInMonths()<0?"":serviceStock.getOrderPeriodInMonths()+"");
				sSelectedNosync				= serviceStock.getNosync()+"";
				sSelectedHidden				= serviceStock.getHidden()+"";
				sSelectedValidateOutgoing   = serviceStock.getValidateoutgoingtransactions()+"";

                // format dates
                java.util.Date tmpDate = serviceStock.getBegin();
                if(tmpDate!=null) sSelectedBegin = ScreenHelper.formatDate(tmpDate);

                tmpDate = serviceStock.getEnd();
                if(tmpDate!=null) sSelectedEnd = ScreenHelper.formatDate(tmpDate);

                // authorized users
                String authorizedUserIds = checkString(serviceStock.getAuthorizedUserIds());
                if(authorizedUserIds.length() > 0){
                    authorisedUsersIdx = 1;
                    StringTokenizer idTokenizer = new StringTokenizer(authorizedUserIds,"$");
                    while(idTokenizer.hasMoreTokens()){
                        authorizedUserId = idTokenizer.nextToken();
                        authorizedUserName = ScreenHelper.getFullUserName(authorizedUserId);
                        authorisedUsersIdx++;

                        authorizedUsersJS.append("rowAuthorizedUsers"+authorisedUsersIdx+"="+authorizedUserId+"£"+authorizedUserName+"$");
                        authorizedUsersHTML.append(addAuthorizedUser(authorisedUsersIdx,authorizedUserName,sWebLanguage));
                        authorizedUsersDB.append(authorizedUserId+"$");
                    }
                }

                // receiving users
                String receivingUserIds = checkString(serviceStock.getReceivingUserIds());
                if(receivingUserIds.length() > 0){
                    receivingUsersIdx = 1;
                    StringTokenizer idTokenizer = new StringTokenizer(receivingUserIds,"$");
                    while(idTokenizer.hasMoreTokens()){
                        receivingUserId = idTokenizer.nextToken();
                        receivingUserName = ScreenHelper.getFullUserName(receivingUserId);
                        receivingUsersIdx++;

                        receivingUsersJS.append("rowReceivingUsers"+receivingUsersIdx+"="+receivingUserId+"£"+receivingUserName+"$");
                        receivingUsersHTML.append(addReceivingUser(receivingUsersIdx,receivingUserName,sWebLanguage));
                        receivingUsersDB.append(receivingUserId+"$");
                    }
                }

                // dispensing users
                String dispensingUserIds = checkString(serviceStock.getDispensingUserIds());
                if(dispensingUserIds.length() > 0){
                	dispensingUsersIdx = 1;
                    StringTokenizer idTokenizer = new StringTokenizer(dispensingUserIds,"$");
                    while(idTokenizer.hasMoreTokens()){
                    	dispensingUserId = idTokenizer.nextToken();
                    	dispensingUserName = ScreenHelper.getFullUserName(dispensingUserId);
                    	dispensingUsersIdx++;

                    	dispensingUsersJS.append("rowDispensingUsers"+dispensingUsersIdx+"="+dispensingUserId+"£"+dispensingUserName+"$");
                    	dispensingUsersHTML.append(addDispensingUser(dispensingUsersIdx,dispensingUserName,sWebLanguage));
                    	dispensingUsersDB.append(dispensingUserId+"$");
                    }
                }

                // validation users
                String validationUserIds = checkString(serviceStock.getValidationUserIds());
                if(validationUserIds.length() > 0){
                	validationUsersIdx = 1;
                    StringTokenizer idTokenizer = new StringTokenizer(validationUserIds,"$");
                    while(idTokenizer.hasMoreTokens()){
                    	validationUserId = idTokenizer.nextToken();
                    	validationUserName = ScreenHelper.getFullUserName(validationUserId);
                    	validationUsersIdx++;

                    	validationUsersJS.append("rowValidationUsers"+validationUsersIdx+"="+validationUserId+"£"+validationUserName+"$");
                    	validationUsersHTML.append(addValidationUser(validationUsersIdx,validationUserName,sWebLanguage));
                    	validationUsersDB.append(validationUserId+"$");
                    }
                }

                // afgeleide data
                if(sSelectedServiceUid.length() > 0){
                    sSelectedServiceName = getTranNoLink("service",sSelectedServiceUid,sWebLanguage);
                }

                if(sSelectedManagerUid.length() > 0){
                    sSelectedManagerName = ScreenHelper.getFullUserName(sSelectedManagerUid);
                }
                if(sSelectedVirtualInvoicingAccountUid.length() > 0){
                    sSelectedVirtualInvoicingAccountName = AdminPerson.getFullName(sSelectedVirtualInvoicingAccountUid);
                }
                if(sSelectedDefaultSupplierUid.length() > 0){
                    sSelectedDefaultSupplierName = getTranNoLink("service",sSelectedDefaultSupplierUid,sWebLanguage);
                }
            }
        }
        else if(sAction.equals("showDetailsAfterAddReject")){
            // do not get data from DB, but show data that were allready on form
            sSelectedStockName          = sEditStockName;
            sSelectedServiceUid         = sEditServiceUid;
            sSelectedBegin              = sEditBegin;
            sSelectedEnd                = sEditEnd;
            sSelectedManagerUid         = sEditManagerUid;
            sSelectedVirtualInvoicingAccountUid         = sEditVirtualInvoicingAccountUid;
            sSelectedDefaultSupplierUid = sEditDefaultSupplierUid;
            sSelectedOrderPeriod        = sEditOrderPeriod;
            sSelectedNosync				= sEditNosync;

            sSelectedHidden				= sEditHidden;
            sSelectedValidateOutgoing	= sEditValidateOutgoing;

            // afgeleide data
            sSelectedServiceName         = sEditServiceName;
            sSelectedManagerName         = sEditManagerName;
            sSelectedVirtualInvoicingAccountName         = sEditManagerName;
            sSelectedDefaultSupplierName = sEditDefaultSupplierName;
        }
        else if(sAction.equals("showDetailsNew")){
        	sEditStockUid = "";
            // default defaultSupplier is centralPharmacy
            if(sEditDefaultSupplierUid.length()==0) sEditDefaultSupplierUid = centralPharmacyCode;

            // default orderPeriodInMonths
            if(sEditOrderPeriod.length()==0) sEditOrderPeriod = "12"; // todo : needed ?

            // default Nosync
            if(SH.c(sEditNosync).length()==0) sEditNosync = "1"; // todo : needed ?
            sSelectedNosync				= sEditNosync;
            if(sEditHidden.length()==0) sEditHidden = "0"; // todo : needed ?
            if(sEditValidateOutgoing.length()==0) sEditValidateOutgoing = "0"; // todo : needed ?

            // active user service as default service
            sSelectedServiceUid = activeUser.activeService.code;
            sSelectedServiceName = getTranNoLink("service",sSelectedServiceUid,sWebLanguage);

            // active user as default manager
            sSelectedManagerUid = activeUser.person.personid;
            sSelectedManagerName = ScreenHelper.getFullUserName(sSelectedManagerUid);

            // central pharmacy as default defaultSupplier
            sSelectedDefaultSupplierUid = centralPharmacyCode;
            if(sSelectedDefaultSupplierUid.length() > 0){
                sSelectedDefaultSupplierName = getTranNoLink("service",sSelectedDefaultSupplierUid,sWebLanguage);
            }
        }
    }

    // onclick : when editing, save, else search when pressing 'enter'
    String sOnKeyDown = "";
    if(sAction.startsWith("showDetails")){
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSave();}\"";
    }
    else{
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSearch();}\"";
    }
%>
<form name="transactionForm" id="transactionForm" method="post" action='<c:url value="/main.do"/>?Page=pharmacy/manageServiceStocks.jsp&ts=<%=getTs()%>' <%=sOnKeyDown%> <%=(displaySearchFields?"onClick=\"clearMessage();\"":"onclick=\"setSaveButton(event);clearMessage();\" onkeyup=\"setSaveButton(event);\"")%>>
    <%=writeTableHeader("Web.manage","ManageServiceStocks",sWebLanguage," doBack();")%>
    
    <%
        //*****************************************************************************************
        //*** process display options *************************************************************
        //*****************************************************************************************

        //--- SEARCH FIELDS -----------------------------------------------------------------------
        // afgeleide data
        String sFindManagerName         = checkString(request.getParameter("FindManagerName"));
               sFindServiceName         = checkString(request.getParameter("FindServiceName"));
               sFindDefaultSupplierName = checkString(request.getParameter("FindDefaultSupplierName"));

        if(displaySearchFields){
            // active service as default service to search on
            if(displayActiveServiceStocks){
                sFindServiceUid = activeUser.activeService.code;
                sFindServiceName = getTranNoLink("service",sFindServiceUid,sWebLanguage);
            }

            %>
                <table width="100%" class="list" cellspacing="1" onClick="transactionForm.onkeydown='if(enterEvent(event,13)){doSearch();}';" onKeyDown="if(enterEvent(event,13)){doSearch();}">
                    <%-- Stock Name --%>
                    <tr>
                        <td class="admin2" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","Name",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input type="text" class="text" name="FindStockName" size="<%=sTextWidth%>" maxLength="255" value="<%=sFindStockName%>">
                        </td>
                    </tr>
                    <%-- Service --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","service",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input type="hidden" name="FindServiceUid" value="<%=sFindServiceUid%>">
                            <input class="text" type="text" name="FindServiceName" readonly size="<%=sTextWidth%>" value="<%=sFindServiceName%>">
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('FindServiceUid','FindServiceName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindServiceUid.value='';transactionForm.FindServiceName.value='';">
                        </td>
                    </tr>
                    <%-- Begin --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","begindate",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2"><%=writeDateField("FindBegin","transactionForm",sFindBegin,sWebLanguage)%></td>
                    </tr>
                    <%-- End --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","enddate",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2"><%=writeDateField("FindEnd","transactionForm",sFindEnd,sWebLanguage)%></td>
                    </tr>
                    <%-- Manager --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","stockmanager",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <input type="hidden" name="FindManagerUid" value="<%=sFindManagerUid%>">
                            <input class="text" type="text" name="FindManagerName" readonly size="<%=sTextWidth%>" value="<%=sFindManagerName%>">
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchManager('FindManagerUid','FindManagerName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindManagerUid.value='';transactionForm.FindManagerName.value='';">
                        </td>
                    </tr>
                    <%-- default supplier --%>
                    <tr>
                        <td class="admin2" nowrap><%=getTran(request,"Web","defaultsupplier",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                        	<select class='text' name='FindDefaultSupplierUid' id='FindDefaultSupplierUid'>
                        		<option value=''/>
                        		<%
                        			try{
	                        			Vector servicestocks = ServiceStock.findAll();
	                        			for(int n=0;n<servicestocks.size();n++){
	                        				ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
	                        				out.println("<option value='"+stock.getUid()+"' "+(sFindDefaultSupplierUid.equalsIgnoreCase(stock.getUid())?"selected":"")+">"+stock.getName()+"</option>");
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
                        <td class="admin2"/>
                        <td class="admin2">
                            <input type="button" class="button" name="searchButton" value="<%=getTranNoLink("Web","search",sWebLanguage)%>" onclick="doSearch();">
                            <input type="button" class="button" name="clearButton" value="<%=getTranNoLink("Web","Clear",sWebLanguage)%>" onclick="clearSearchFields();">
                            <%
                                if(activeUser.getAccessRight("pharmacy.manageservicestocks.add")){
                                    %><input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNew();"><%
                                }
                            %>
                            <input type="checkbox" name="showhidden" id="showhidden" <%=request.getParameter("showhidden")!=null?"checked":"" %> onclick="doSearch();"/><%=getTran(request,"web","hidden",sWebLanguage) %>
                            <input type="checkbox" name="showunauthorized" id="showunauthorized" <%=request.getParameter("showunauthorized")!=null?"checked":"" %> onclick="doSearch();"/><%=getTran(request,"web","unauthorized",sWebLanguage) %>
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

            // get data from form
            sFindStockName          = checkString(request.getParameter("FindStockName"));
            sFindServiceUid         = checkString(request.getParameter("FindServiceUid"));
            sFindBegin              = checkString(request.getParameter("FindBegin"));
            sFindEnd                = checkString(request.getParameter("FindEnd"));
            sFindManagerUid         = checkString(request.getParameter("FindManagerUid"));
            sFindDefaultSupplierUid = checkString(request.getParameter("FindDefaultSupplierUid"));

            %>
                <input type="hidden" name="FindStockName" value="<%=sFindStockName%>">
                <input type="hidden" name="FindServiceUid" value="<%=sFindServiceUid%>">
                <input type="hidden" name="FindServiceName" value="<%=sFindServiceName%>">
                <input type="hidden" name="FindBegin" value="<%=sFindBegin%>">
                <input type="hidden" name="FindEnd" value="<%=sFindEnd%>">
                <input type="hidden" name="FindManagerUid" value="<%=sFindManagerUid%>">
                <input type="hidden" name="FindManagerName" value="<%=sFindManagerName%>">
                <input type="hidden" name="FindDefaultSupplierUid" value="<%=sFindDefaultSupplierUid%>">
                <input type="hidden" name="FindDefaultSupplierName" value="<%=sFindDefaultSupplierName%>">
            <%
        }

        //--- SEARCH RESULTS ----------------------------------------------------------------------
        if(displayFoundRecords){
            if(foundStockCount > 0){
            	%>
                    <table width='100%' cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                        <%-- header --%>
                        <tr class="admin">
                            <td width="90" nowrap>&nbsp;</td>
                            <td><%=getTran(request,"Web","name",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","service",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web","manager",sWebLanguage)%></td>
                            <td><%=getTran(request,"Web.manage","productstockcount",sWebLanguage)%></td>
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
                <%
            }
            else{
                // no records found
                %><%=getTran(request,"web","norecordsfound",sWebLanguage)%><br><br><%
            }
        }

        //--- EDIT FIELDS -------------------------------------------------------------------------
        if(displayEditFields){
            %>
                <table class="list" width="100%" cellspacing="1">
                    <%-- Stock Name --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","ID",sWebLanguage)%></td>
                        <td class="admin2"><%=sEditStockUid%></td>
                    </tr>
                   	<%
                   		if(SH.c(sEditStockUid).length()>0 && !sSelectedNosync.equalsIgnoreCase("1")){
                			//This stock must be synchronised, if no UID exists, generate one
                			if(SH.cs("serviceStockUID."+sEditStockUid,"").length()==0){
                				MedwanQuery.getInstance().setConfigString("serviceStockUID."+sEditStockUid, SH.getRandomPassword(4)+"-"+SH.getRandomPassword(4)+"-"+SH.getRandomPassword(4)+"-"+SH.getRandomPassword(4));
                			}
                   	%>
	                    <tr>
	                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","syncid",sWebLanguage)%></td>
	                        <td class="admin2"><b><%=SH.cs("serviceStockUID."+sEditStockUid,"")%></b></td>
	                    </tr>
	                    <tr>
	                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","remotesyncid",sWebLanguage)%></td>
	                        <td class="admin2">
	                            <input class="text" type="text" name="EditRemoteSyncId" size="<%=sTextWidth%>" maxLength="255" value="<%=SH.cs("remoteSyncId."+sEditStockUid,"")%>">
								<input type="button" class="button" name="initializeButton" value="<%=getTranNoLink("web","initializeremote",sWebLanguage) %>" onclick="initializeRemote();"/><div id='divInitializeRemote'/>
	                        </td>
	                    </tr>
                   	<%
                   		}
                   	%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>" nowrap><%=getTran(request,"Web","Name",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditStockName" size="<%=sTextWidth%>" maxLength="255" value="<%=sSelectedStockName%>">
                        </td>
                    </tr>
                    
                    <%-- Service --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","service",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2">
                            <input type="hidden" name="EditServiceUid" value="<%=sSelectedServiceUid%>">
                            <input class="text" type="text" name="EditServiceName" readonly size="<%=sTextWidth%>" value="<%=sSelectedServiceName%>">
                         
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('EditServiceUid','EditServiceName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditServiceUid.value='';transactionForm.EditServiceName.value='';">
                        </td>
                    </tr>
                    
                    <%-- Begin date --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","begindate",sWebLanguage)%>&nbsp;*</td>
                        <td class="admin2"><%=writeDateField("EditBegin","transactionForm",sSelectedBegin,sWebLanguage)%>
                            <%
                                // if new order : set today as default value for begindate
                                if(sAction.equals("showDetailsNew")){
                                    %><script>getToday(document.getElementsByName('EditBegin')[0]);</script><%
                                }
                            %>
                        </td>
                    </tr>
                    
                    <%-- End date --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","enddate",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2"><%=writeDateField("EditEnd","transactionForm",sSelectedEnd,sWebLanguage)%></td>
                    </tr>
                    
                    <%-- Manager --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","stockmanager",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input type="hidden" name="EditManagerUid" value="<%=sSelectedManagerUid%>">
                            <input class="text" type="text" name="EditManagerName" readonly size="<%=sTextWidth%>" value="<%=sSelectedManagerName%>">
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchManager('EditManagerUid','EditManagerName');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditManagerName.value='';transactionForm.EditManagerUid.value='';">
                        </td>
                    </tr>
                    
                    <%-- Authorized users --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","Authorizedusers",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%-- add row --%>
                            <input type="hidden" name="AuthorizedUserIdAdd" value="">
                            <input class="text" type="text" name="AuthorizedUserNameAdd" size="<%=sTextWidth%>" value="" readonly>
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchAuthorizedUser('AuthorizedUserIdAdd','AuthorizedUserNameAdd');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.AuthorizedUserIdAdd.value='';transactionForm.AuthorizedUserNameAdd.value='';">
                            <img src="<c:url value="/_img/icons/icon_add.gif"/>" class="link" alt="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addAuthorizedUser();">
                            <table width="100%" cellspacing="1" id="tblAuthorizedUsers">
                                <%=authorizedUsersHTML%>
                            </table>
                            <input type="hidden" name="EditAuthorizedUsers" value="<%=authorizedUsersDB%>">
                        </td>
                    </tr>

                    <%-- Receiving users --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","Receivingusers",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%-- add row --%>
                            <input type="hidden" name="ReceivingUserIdAdd" value="">
                            <input class="text" type="text" name="ReceivingUserNameAdd" size="<%=sTextWidth%>" value="" readonly>
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchReceivingUser('ReceivingUserIdAdd','ReceivingUserNameAdd');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.ReceivingUserIdAdd.value='';transactionForm.ReceivingUserNameAdd.value='';">
                            <img src="<c:url value="/_img/icons/icon_add.gif"/>" class="link" alt="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addReceivingUser();">
                            <table width="100%" cellspacing="1" id="tblReceivingUsers">
                                <%=receivingUsersHTML%>
                            </table>
                            <input type="hidden" name="EditReceivingUsers" value="<%=receivingUsersDB%>">
                        </td>
                    </tr>

                    <%-- Dispensing users --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","dispensingusers",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%-- add row --%>
                            <input type="hidden" name="DispensingUserIdAdd" value="">
                            <input class="text" type="text" name="DispensingUserNameAdd" size="<%=sTextWidth%>" value="" readonly>
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchDispensingUser('DispensingUserIdAdd','DispensingUserNameAdd');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.DispensingUserIdAdd.value='';transactionForm.DispensingUserNameAdd.value='';">
                            <img src="<c:url value="/_img/icons/icon_add.gif"/>" class="link" alt="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addDispensingUser();">
                            <table width="100%" cellspacing="1" id="tblDispensingUsers">
                                <%=dispensingUsersHTML%>
                            </table>
                            <input type="hidden" name="EditDispensingUsers" value="<%=dispensingUsersDB%>">
                        </td>
                    </tr>

                    <%-- Validation users --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","validationusers",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2">
                            <%-- add row --%>
                            <input type="hidden" name="ValidationUserIdAdd" value="">
                            <input class="text" type="text" name="ValidationUserNameAdd" size="<%=sTextWidth%>" value="" readonly>
                           
                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchValidationUser('ValidationUserIdAdd','ValidationUserNameAdd');">
                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.ValidationUserIdAdd.value='';transactionForm.ValidationUserNameAdd.value='';">
                            <img src="<c:url value="/_img/icons/icon_add.gif"/>" class="link" alt="<%=getTranNoLink("Web","add",sWebLanguage)%>" onclick="addValidationUser();">
                            <table width="100%" cellspacing="1" id="tblValidationUsers">
                                <%=validationUsersHTML%>
                            </table>
                            <input type="hidden" name="EditValidationUsers" value="<%=validationUsersDB%>">
                        </td>
                    </tr>

                    <%-- default supplier --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web","defaultsupplier",sWebLanguage)%></td>
                        <td class="admin2">
                        	<select class='text' name='EditDefaultSupplierUid' id='EditDefaultSupplierUid'>
                        		<option value=''/>
                        		<%
                        			try{
	                        			Vector servicestocks = ServiceStock.findAll();
	                        			for(int n=0;n<servicestocks.size();n++){
	                        				ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
	                        				out.println("<option value='"+stock.getUid()+"' "+(sSelectedDefaultSupplierUid.equalsIgnoreCase(stock.getUid())?"selected":"")+">"+stock.getName()+"</option>");
	                        			}
                        			}
                        			catch(Exception r){
                        				r.printStackTrace();
                        			}
                        		%>
                        	</select>
                        </td>
                    </tr>
                    
					<% if(SH.cs("edition","openclinic").equalsIgnoreCase("bloodbank")){ %>                    
	                    <%-- Virtual invoicing account --%>
	                    <tr>
	                        <td class="admin" nowrap><%=getTran(request,"Web","virtualinvoicingaccount",sWebLanguage)%>&nbsp;</td>
	                        <td class="admin2">
	                            <input type="hidden" name="EditVirtualInvoicingAccountUid" value="<%=sSelectedVirtualInvoicingAccountUid%>">
	                            <input class="text" type="text" name="EditVirtualInvoicingAccountName" readonly size="<%=sTextWidth%>" value="<%=sSelectedVirtualInvoicingAccountName%>">
	                           
	                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPerson('EditVirtualInvoicingAccountUid','EditVirtualInvoicingAccountName');">
	                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditVirtualInvoicingAccountUid.value='';transactionForm.EditVirtualInvoicingAccountName.value='';">
	                        </td>
	                        </td>
	                    </tr>
					<% } %>
                    <%-- orderPeriodInMonths --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web.manage","orderPeriodInMonths",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input class="text" type="text" name="EditOrderPeriodInMonths" size="5" maxLength="5" value="<%=sSelectedOrderPeriod%>" onKeyUp="isInteger(this);">
                        </td>
                    </tr>
                    
                    <%-- Nosync --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web.manage","nosync",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" name="EditNosync" class="hand" <%=sSelectedNosync!=null && sSelectedNosync.equalsIgnoreCase("1")?"checked":""%> value="1" onKeyUp="isInteger(this);">
                        </td>
                    </tr>
                    
                    <%-- Hidden --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web.manage","hidden",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" name="EditHidden" class="hand" <%=sSelectedHidden!=null && sSelectedHidden.equalsIgnoreCase("1")?"checked":""%> value="1" onKeyUp="isInteger(this);">
                        </td>
                    </tr>
                    
                    <%-- ValidateOutgoing --%>
                    <tr>
                        <td class="admin" nowrap><%=getTran(request,"Web.manage","validateoutgoing",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" name="EditValidateOutgoing" class="hand" <%=sSelectedValidateOutgoing!=null && sSelectedValidateOutgoing.equalsIgnoreCase("1")?"checked":""%> value="1" onKeyUp="isInteger(this);">
                        </td>
                    </tr>
                    
                    <%-- EDIT BUTTONS --%>
                    <tr>
                        <td class="admin2"/>
                        <td class="admin2">
                        <%
                            if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
                                // existing serviceStock : display saveButton with save-label
                                ServiceStock serviceStock = ServiceStock.get(sEditStockUid);
                                if(serviceStock.isAuthorizedUser(activeUser.userid) || activeUser.getAccessRight("sa")){
                                    if(activeUser.getAccessRight("pharmacy.manageservicestocks.edit")){
		                                %><input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave();">&nbsp;<%
                                    }
                                    if(activeUser.getAccessRight("pharmacy.manageservicestocks.delete")){
		                                %><input class="button" type="button" name="deleteButton" value='<%=getTranNoLink("Web","delete",sWebLanguage)%>' onclick="doDelete('<%=sEditStockUid%>');">&nbsp;<%
                                    }
                                }
                                %><input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","backtooverview",sWebLanguage)%>' onclick="doBackToOverview();">&nbsp;<%
                            }
                            else if(sAction.equals("showDetailsNew") || sAction.equals("showDetailsAfterAddReject")){
                                // new serviceStock : display saveButton with add-label
                                if(activeUser.getAccessRight("pharmacy.manageservicestocks.add")){
                                    %><input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","add",sWebLanguage)%>' onclick="doAdd();">&nbsp;<%
                                }
                                %><input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","back",sWebLanguage)%>' onclick="doBack();">&nbsp;<%
                            }
                        %>
                        
                        <%-- display message --%>
                        <span id="msgArea"><%=msg%></span>
                    </td>
                </tr>
            </table>
            
            <%-- indication of obligated fields --%>
            <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>
            <br><br>
            
            <table width='100%'>
            	<tr>
            		<td class='text'><a href="javascript:printInventory('<%=sEditStockUid %>')"><%=getTran(request,"web","servicestockinventory.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printInventorySummary('<%=sEditStockUid %>')"><%=getTran(request,"web","servicestockinventorysummary.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printStockOperations('<%=sEditStockUid %>')"><%=getTran(request,"web","servicestockoperations.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printOutgoingStockOperations('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceoutgoingstockoperations.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printOutgoingStockOperationsListing('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceoutgoingstockoperationslisting.pdf",sWebLanguage)%></a></td>
				</tr>
				<tr>
            		<td class='text'><a href="javascript:printOutgoingStockOperationsListingPerService('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceoutgoingstockoperationslistingperservice.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printMonthlyConsumption('<%=sEditStockUid %>')"><%=getTran(request,"web","monthlyconsumption.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printExpiration('<%=sEditStockUid %>')"><%=getTran(request,"web","expiration.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printStockOut('<%=sEditStockUid %>')"><%=getTran(request,"web","stockout.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printIncomingStockOperations('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceincomingstockoperations.pdf",sWebLanguage)%></a></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:printIncomingStockOperationsPerOrder('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceincomingstockoperationsperorder.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printIncomingStockOperationsPerItem('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceincomingstockoperationsperitem.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printIncomingStockOperationsPerProvider('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceincomingstockoperationsperprovider.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printIncomingStockOperationsPerCategoryItem('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceincomingstockoperationspercategoryitem.pdf",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printOutgoingStockOperationsPerService('<%=sEditStockUid %>')"><%=getTran(request,"web","serviceoutgoingstockoperationsperservice.pdf",sWebLanguage)%></a></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:printProductionReportPeriod('consumptionReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.consumptionReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printStockContent('<%=sEditStockUid %>')"><%=getTran(request,"web","production.stockContent.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printInventoryCsv('<%=sEditStockUid %>')"><%=getTran(request,"web","servicestockinventory.csv",sWebLanguage)%></a></td>
            		<td class='text' colspan="2"><a href="javascript:printInventorySummaryCsv('<%=sEditStockUid %>')"><%=getTran(request,"web","servicestockinventorysummary.csv",sWebLanguage)%></a></td>
            	</tr>
            	
            <%
            	if(MedwanQuery.getInstance().getConfigInt("enableBurundi",0)==1){
            %>
            	<tr>
            		<td colspan="5"><br/></td>
            	</tr>
            	<tr>
            		<td colspan="5" class='admin'><%=getTran(request,"web","msplsreports",sWebLanguage) %><hr/></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:poiPharmacyInventory('<%=sEditStockUid %>')"><%=getTran(request,"web","poi.inventoryReport",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:poiPharmacySynthesis('<%=sEditStockUid %>')"><%=getTran(request,"web","poi.inventorySynthesis",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:poiPharmacyValorisation('<%=sEditStockUid %>')"><%=getTran(request,"web","poi.inventoryValorisation",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:poiPharmacyExpiration('<%=sEditStockUid %>')"><%=getTran(request,"web","poi.inventoryExpiration",sWebLanguage)%></a></td>
            	</tr>
            <%
            	}
            	if(MedwanQuery.getInstance().getConfigInt("enablePharmacyProductionReports",0)==1){
            %>
            	<tr>
            		<td colspan="5"><br/></td>
            	</tr>
            	<tr>
            		<td colspan="5" class='admin'><%=getTran(request,"web","productionreports",sWebLanguage) %><hr/></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:printProductionReport('inventoryAnalysisReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.inventoryAnalysisReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printProductionReportPeriod('specialOrderReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.specialOrderReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printProductionReportPeriod('productionReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.productionReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printProductionReportPeriod('productionSalesOrderReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.productionSalesOrderReport.csv",sWebLanguage)%></a></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:printProductionReportPeriod('insuranceReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.insuranceReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printProductionReportPeriod('salesAnalysisReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.salesAnalysisReport.csv",sWebLanguage)%></a></td>
            	</tr>
            	<tr>
            		<td colspan="5" class='admin'><%=getTran(request,"web","salesreports",sWebLanguage) %><hr/></td>
            	</tr>
				<tr>
            		<td class='text'><a href="javascript:printProductionReportPeriodService('salesOrderReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.salesOrderReport.csv",sWebLanguage)%></a></td>
            		<td class='text'><a href="javascript:printProductionReportPeriod('deliveryReport','<%=sEditStockUid %>')"><%=getTran(request,"web","production.deliveryReport.csv",sWebLanguage)%></a></td>
            	</tr>
            <%
            	}
            %>
            </table>
            <%
        }

        //--- DISPLAY ACTIVE SERVICE STOCKS -------------------------------------------------------
        if(displayActiveServiceStocks){
            // search stocks in service of active user by default
            sFindServiceUid = activeUser.activeService.code;
            sFindServiceName = getTranNoLink("service",sFindServiceUid,sWebLanguage);

            Vector serviceStocks = Service.getActiveServiceStocks(sFindServiceUid);
            stocksHtml = objectsToHtml(serviceStocks,sWebLanguage,activeUser,request.getParameter("showhidden"),bHasActivePrescriptions,request.getParameter("showunauthorized"));
            foundStockCount = serviceStocks.size();

            //*** display found records ***
            if(foundStockCount > 0){
                %>
                    <%-- title --%>
                    <table width="100%" cellspacing="0">
                        <tr>
                            <td class="titleadmin">&nbsp;<%=getTran(request,"Web.manage","ActiveServiceStocks",sWebLanguage)%>&nbsp;(<%=sFindServiceName%>)</td>
                        </tr>
                    </table>
                    
                    <table width='100%' cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
                        <%-- header --%>
                        <tr class="admin">
                            <td width="22"/>
                            <td width="20%"><%=getTran(request,"Web","name",sWebLanguage)%></td>
                            <td width="35%"><%=getTran(request,"Web","service",sWebLanguage)%></td>
                            <td width="25%"><%=getTran(request,"Web","manager",sWebLanguage)%></td>
                            <td width="15%"><%=getTran(request,"Web.manage","productstockcount",sWebLanguage)%></td>
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
                    <br>
                <%
            }
            else{
                // no records found
                %>
                    <%-- sub title --%>
                    <table width='100%' cellspacing='0'>
                        <tr class='admin'>
                            <td><%=getTran(request,"Web.manage","ActiveServiceStocks",sWebLanguage)%>&nbsp;(<%=sFindServiceName%>)</td>
                        </tr>
                    </table>
                    
                    <%=getTran(request,"web.manage","noservicestocksfoundinactiveservice",sWebLanguage)%>
                    <br><br>
                <%
            }
        }
    %>
    
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="EditStockUid" value="<%=sEditStockUid%>">
    <input type="hidden" name="DisplaySearchFields" value="<%=displaySearchFields%>">
    <input type="hidden" name="DisplayActiveServiceStocks" value="<%=displayActiveServiceStocks%>">
</form>

<%-- SCRIPTS ------------------------------------------------------------------------------------%>
<script>
  <%
      // default focus field
      if(displayEditFields){
          %>transactionForm.EditStockName.focus();<%
      }

      if(displaySearchFields){
          %>transactionForm.FindStockName.focus();<%
      }
  %>

  <%-- AUTHORIZED USERS FUNCTIONS ---------------------------------------------------------------%>
  var iAuthorizedUsersIdx = <%=authorisedUsersIdx%>;
  var sAuthorizedUsers = "<%=authorizedUsersJS%>";
 
  var iReceivingUsersIdx = <%=receivingUsersIdx%>;
  var sReceivingUsers = "<%=receivingUsersJS%>";
 
  var iDispensingUsersIdx = <%=dispensingUsersIdx%>;
  var sDispensingUsers = "<%=dispensingUsersJS%>";
 
  var iValidationUsersIdx = <%=validationUsersIdx%>;
  var sValidationUsers = "<%=validationUsersJS%>";
 
	function searchPerson(pid,personName){
	  	var url = "<c:url value="/popup.jsp?Page=_common/search/searchPatient.jsp"/>&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400"+
	            "&ReturnPersonID="+pid+
	            "&ReturnName="+personName+
	            "&displayImmatNew=no"+
	            "&hasTracnetId=yes"+
	            "&isUser=false"+
	            "&IncludedDossiersSelectable=false";
	
	  	window.open(url,"searchPatientPopup","height=1,width=1,toolbar=no,status=no,scrollbars=no,resizable=no,menubar=no");
	}

  <%-- ADD VALIDATION USER --%>
  function addValidationUser(){
    if(transactionForm.ValidationUserIdAdd.value.length > 0){
      iValidationUsersIdx++;

      sValidationUsers+= "rowValidationUsers"+iValidationUsersIdx+"£"+
                         transactionForm.ValidationUserIdAdd.value+"£"+
                         transactionForm.ValidationUserNameAdd.value+"$";
      var tr = tblValidationUsers.insertRow(tblValidationUsers);
      tr.id = "rowValidationUsers"+iValidationUsersIdx;

      var td = tr.insertCell(0);
      td.width = 16;
      td.innerHTML = "<a href='javascript:deleteValidationUser(rowValidationUsers"+iValidationUsersIdx+")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web","delete",sWebLanguage)%>' border='0'></a>";
      tr.appendChild(td);

      td = tr.insertCell(1);
      td.innerHTML = transactionForm.ValidationUserNameAdd.value;
      tr.appendChild(td);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditValidationUsers.value = transactionForm.EditValidationUsers.value+transactionForm.ValidationUserIdAdd.value+"$";

      clearValidationUserFields();
    }
    else{
        alertDialog("web","firstselectaperson");
        transactionForm.ValidationUserNameAdd.focus();
    }
  }

  <%-- CLEAR VALIDATION USER FIELDS --%>
  function clearValidationUserFields(){
    transactionForm.ValidationUserIdAdd.value = "";
    transactionForm.ValidationUserNameAdd.value = "";
  }

  <%-- DELETE VALIDATION USER --%>
  function deleteValidationUser(rowid){
      if(yesnoDeleteDialog()){
      sValidationUsers = deleteRowFromArrayString(sValidationUsers,rowid.id);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditValidationUsers.value = extractUserIds(sValidationUsers);

      tblValidationUsers.deleteRow(rowid.rowIndex);
      clearValidationUserFields();
    }
  }

  <%-- ADD DISPENSING USER --%>
  function addDispensingUser(){
    if(transactionForm.DispensingUserIdAdd.value.length > 0){
      iDispensingUsersIdx++;

      sDispensingUsers+= "rowDispensingUsers"+iDispensingUsersIdx+"£"+
                         transactionForm.DispensingUserIdAdd.value+"£"+
                         transactionForm.DispensingUserNameAdd.value+"$";
      var tr = tblDispensingUsers.insertRow(tblDispensingUsers);
      tr.id = "rowDispensingUsers"+iDispensingUsersIdx;

      var td = tr.insertCell(0);
      td.width = 16;
      td.innerHTML = "<a href='javascript:deleteDispensingUser(rowDispensingUsers"+iDispensingUsersIdx+")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web","delete",sWebLanguage)%>' border='0'></a>";
      tr.appendChild(td);

      td = tr.insertCell(1);
      td.innerHTML = transactionForm.DispensingUserNameAdd.value;
      tr.appendChild(td);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditDispensingUsers.value = transactionForm.EditDispensingUsers.value+transactionForm.DispensingUserIdAdd.value+"$";

      clearDispensingUserFields();
    }
    else{
        alertDialog("web","firstselectaperson");
        transactionForm.DispensingUserNameAdd.focus();
    }
  }

  <%-- CLEAR DISPENSING USER FIELDS --%>
  function clearDispensingUserFields(){
    transactionForm.DispensingUserIdAdd.value = "";
    transactionForm.DispensingUserNameAdd.value = "";
  }

  <%-- DELETE DISPENSING USER --%>
  function deleteDispensingUser(rowid){
      if(yesnoDeleteDialog()){
      sDispensingUsers = deleteRowFromArrayString(sDispensingUsers,rowid.id);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditDispensingUsers.value = extractUserIds(sDispensingUsers);

      tblDispensingUsers.deleteRow(rowid.rowIndex);
      clearDispensingUserFields();
    }
  }

  <%-- ADD AUTHORIZED USER --%>
  function addAuthorizedUser(){
    if(transactionForm.AuthorizedUserIdAdd.value.length > 0){
      iAuthorizedUsersIdx++;

      sAuthorizedUsers+= "rowAuthorizedUsers"+iAuthorizedUsersIdx+"£"+
                         transactionForm.AuthorizedUserIdAdd.value+"£"+
                         transactionForm.AuthorizedUserNameAdd.value+"$";
      var tr = tblAuthorizedUsers.insertRow(tblAuthorizedUsers);
      tr.id = "rowAuthorizedUsers"+iAuthorizedUsersIdx;

      var td = tr.insertCell(0);
      td.width = 16;
      td.innerHTML = "<a href='javascript:deleteAuthorizedUser(rowAuthorizedUsers"+iAuthorizedUsersIdx+")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web","delete",sWebLanguage)%>' border='0'></a>";
      tr.appendChild(td);

      td = tr.insertCell(1);
      td.innerHTML = transactionForm.AuthorizedUserNameAdd.value;
      tr.appendChild(td);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditAuthorizedUsers.value = transactionForm.EditAuthorizedUsers.value+transactionForm.AuthorizedUserIdAdd.value+"$";

      clearAuthorizedUserFields();
 }
    else{
        alertDialog("web","firstselectaperson");
        transactionForm.AuthorizedUserNameAdd.focus();
    }
  }

  <%-- CLEAR AUTHORIZED USER FIELDS --%>
  function clearAuthorizedUserFields(){
    transactionForm.AuthorizedUserIdAdd.value = "";
    transactionForm.AuthorizedUserNameAdd.value = "";
  }

  <%-- DELETE AUTHORIZED USER --%>
  function deleteAuthorizedUser(rowid){
      if(yesnoDeleteDialog()){
      sAuthorizedUsers = deleteRowFromArrayString(sAuthorizedUsers,rowid.id);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditAuthorizedUsers.value = extractUserIds(sAuthorizedUsers);

      tblAuthorizedUsers.deleteRow(rowid.rowIndex);
      clearAuthorizedUserFields();
    }
  }

  <%-- ADD RECEIVING USER --%>
  function addReceivingUser(){
    if(transactionForm.ReceivingUserIdAdd.value.length > 0){
      iReceivingUsersIdx++;

      sReceivingUsers+= "rowReceivingUsers"+iReceivingUsersIdx+"£"+
                         transactionForm.ReceivingUserIdAdd.value+"£"+
                         transactionForm.ReceivingUserNameAdd.value+"$";
      var tr = tblReceivingUsers.insertRow(tblReceivingUsers);
      tr.id = "rowReceivingUsers"+iReceivingUsersIdx;

      var td = tr.insertCell(0);
      td.width = 16;
      td.innerHTML = "<a href='javascript:deleteReceivingUser(rowReceivingUsers"+iReceivingUsersIdx+")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web","delete",sWebLanguage)%>' border='0'></a>";
      tr.appendChild(td);

      td = tr.insertCell(1);
      td.innerHTML = transactionForm.ReceivingUserNameAdd.value;
      tr.appendChild(td);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditReceivingUsers.value = transactionForm.EditReceivingUsers.value+transactionForm.ReceivingUserIdAdd.value+"$";

      clearReceivingUserFields();
 }
    else{
        alertDialog("web","firstselectaperson");
        transactionForm.ReceivingUserNameAdd.focus();
    }
  }

  <%-- CLEAR AUTHORIZED USER FIELDS --%>
  function clearReceivingUserFields(){
    transactionForm.ReceivingUserIdAdd.value = "";
    transactionForm.ReceivingUserNameAdd.value = "";
  }

  <%-- DELETE AUTHORIZED USER --%>
  function deleteReceivingUser(rowid){
      if(yesnoDeleteDialog()){
      sReceivingUsers = deleteRowFromArrayString(sReceivingUsers,rowid.id);

      <%-- update the hidden field containing just the userids --%>
      transactionForm.EditReceivingUsers.value = extractUserIds(sReceivingUsers);

      tblReceivingUsers.deleteRow(rowid.rowIndex);
      clearReceivingUserFields();
    }
  }

  <%-- EXTRACT USER IDS (between '=' and '£') --%>
  function extractUserIds(sourceString){
    var array = sourceString.split("$");
    for(var i=0;i<array.length;i++){
       array[i] = array[i].substring(array[i].indexOf("=")+1,array[i].indexOf("£"));
    }
    return array.join("$");
  }

  <%-- DELETE ROW FROM ARRAY STRING --%>
  function deleteRowFromArrayString(sArray,rowid){
    var array = sArray.split("$");
    for(var i=0;i<array.length;i++){
      if(array[i].indexOf(rowid)>-1){
        array.splice(i,1);
      }
    }
    return array.join("$");
  }

  <%-- DO ADD SERVICE STOCK --%>
  function doAdd(){
    transactionForm.EditStockUid.value = "-1";
    doSave();
  }

  <%-- DO SAVE SERVICE STOCK --%>
  function doSave(){
    if(transactionForm.AuthorizedUserIdAdd.value.length > 0){
        addAuthorizedUser();
    }
    if(transactionForm.ReceivingUserIdAdd.value.length > 0){
        addReceivingUser();
    }
    if(transactionForm.DispensingUserIdAdd.value.length > 0){
        addDispensingUser();
    }
    if(transactionForm.ValidationUserIdAdd.value.length > 0){
        addValidationUser();
    }

    if(checkStockFields()){
      transactionForm.saveButton.disabled = true;
      transactionForm.Action.value = "save";
      transactionForm.submit();
    }
    else{
      if(transactionForm.EditStockName.value.length==0){
        transactionForm.EditStockName.focus();
      }
      else if(transactionForm.EditServiceUid.value.length==0){
        transactionForm.EditServiceName.focus();
      }
      else if(transactionForm.EditDefaultSupplierName.value.length==0){
        transactionForm.EditDefaultSupplierName.focus();
      }
      else if(transactionForm.EditManagerUid.value.length==0){
          transactionForm.EditManagerUid.focus();
        }
      else if(transactionForm.EditBegin.value.length==0){
          transactionForm.EditBegin.focus();
        }
      else if(transactionForm.EditOrderPeriodInMonths.value.length==0){
        transactionForm.EditOrderPeriodInMonths.focus();
      }
    }
  }
  
  <%-- CHECK STOCK FIELDS --%>
  function checkStockFields(){
    var maySubmit = true;

    <%-- required fields --%>
    if(!transactionForm.EditStockName.value.length>0 || !transactionForm.EditServiceUid.value.length>0 ||
       !transactionForm.EditBegin.value.length>0 || !transactionForm.EditManagerUid.value.length>0 ||
       !transactionForm.EditOrderPeriodInMonths.value.length>0){
      maySubmit = false;
      alertDialog("web","somedataismissing");
    }
    else{
      <%-- check dates --%>
      if(transactionForm.EditBegin.value.length>0 && transactionForm.EditEnd.value.length>0){
        var dateBegin = transactionForm.EditBegin.value;
        var dateEnd   = transactionForm.EditEnd.value;

        if(before(dateBegin,dateEnd)){
          maySubmit = true;
        }
        else{
          alertDialog("web.Occup","endMustComeAfterBegin");
          transactionForm.EditEnd.focus();
          maySubmit = false;
        }
      }
    }

    return maySubmit;
  }

  <%-- DO DELETE SERVICE STOCK --%>
  function doDelete(stockUid){
      if(yesnoDeleteDialog()){
      transactionForm.EditStockUid.value = stockUid;
      transactionForm.Action.value = "delete";
      transactionForm.submit();
    }
  }

  <%-- DO NEW SERVICE STOCK --%>
  function doNew(){
    <%
        if(displayEditFields){
            %>clearEditFields();<%
        }

        if(displaySearchFields){
            %>clearSearchFields();<%
        }
    %>
    transactionForm.searchButton.disabled = true;
    transactionForm.clearButton.disabled = true;
    transactionForm.newButton.disabled = true;

    transactionForm.Action.value = "showDetailsNew";
    transactionForm.submit();
  }

  <%-- DO SHOW SERVICE STOCK DETAILS --%>
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
    transactionForm.FindStockName.value = "";

    transactionForm.FindServiceUid.value = "";
    transactionForm.FindServiceName.value = "";

    transactionForm.FindBegin.value = "";
    transactionForm.FindEnd.value = "";

    transactionForm.FindManagerUid.value = "";
    transactionForm.FindManagerName.value = "";

    transactionForm.FindDefaultSupplierUid.value = "";
}

  <%-- CLEAR EDIT FIELDS --%>
  function clearEditFields(){
    transactionForm.FindStockName.value = "";

    transactionForm.EditServiceUid.value = "";
    transactionForm.EditServiceName.value = "";

    transactionForm.EditBegin.value = "";
    transactionForm.EditEnd.value = "";

    transactionForm.EditManagerUid.value = "";
    transactionForm.EditManagerName.value = "";

    transactionForm.EditDefaultSupplierUid.value = "";
    transactionForm.EditDefaultSupplierName.value = "";
    transactionForm.EditOrderPeriodInMonths.value = "";
  }

  <%-- DO SEARCH SERVICE STOCK --%>
  function doSearch(){
    if(true || transactionForm.FindStockName.value.length>0 || transactionForm.FindServiceUid.value.length>0 ||
       transactionForm.FindBegin.value.length>0 || transactionForm.FindEnd.value.length>0 ||
       transactionForm.FindManagerUid.value.length>0 || transactionForm.FindDefaultSupplierUid.value.length>0){
      transactionForm.searchButton.disabled = true;
      transactionForm.clearButton.disabled = true;
      transactionForm.newButton.disabled = true;

      transactionForm.Action.value = "find";
      openSearchInProgressPopup();
      transactionForm.submit();
    }
    else{
      alertDialog("web","datamissing");
    }
  }

  <%-- popup : search manager --%>
  function searchManager(managerUidField,managerNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no");
  }

  <%-- popup : search authorized user --%>
  function searchAuthorizedUser(userUidField,userNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+userUidField+"&ReturnName="+userNameField+"&displayImmatNew=no");
  }

  <%-- popup : search authorized user --%>
  function searchReceivingUser(userUidField,userNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+userUidField+"&ReturnName="+userNameField+"&displayImmatNew=no");
  }

  <%-- popup : search dispensing user --%>
  function searchDispensingUser(userUidField,userNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+userUidField+"&ReturnName="+userNameField+"&displayImmatNew=no");
  }

  <%-- popup : search validation user --%>
  function searchValidationUser(userUidField,userNameField){
    openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+userUidField+"&ReturnName="+userNameField+"&displayImmatNew=no");
  }

  <%-- DISPLAY PRODUCT STOCK MANAGEMENT --%>
  function displayProductStockManagement(serviceStockUid,serviceId){
    window.location.href = "<%=sCONTEXTPATH%>/main.do?Page=pharmacy/manageProductStocks.jsp&Action=findShowOverview&hideZeroLevel=<%=MedwanQuery.getInstance().getConfigString("defaultHideZeroLevelProductStocks","1")%>&EditServiceStockUid="+serviceStockUid+"&DisplaySearchFields=false&ServiceId="+serviceId+"&ts=<%=getTs()%>";
  }

  <%-- popup : search (external) supplier --%>
  function searchSupplier(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&SearchInternalServices=true&SearchExternalServices=true&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  }

  <%-- popup : search service --%>
  function searchService(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
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
      <%
          if(displayActiveServiceStocks){
              %>
                transactionForm.Action.value = "";
                transactionForm.DisplayActiveServiceStocks.value = "true";
              <%
          }
          else{
              %>
                transactionForm.Action.value = "findShowOverview";
                transactionForm.DisplayActiveServiceStocks.value = "false";
              <%
          }
      %>
      transactionForm.DisplaySearchFields.value = "true";
      transactionForm.submit();
    }
  }

  <%-- popup : CALCULATE ORDER --%>
  function doCalculateOrder(serviceStockUid,serviceStockName){
    openPopup("pharmacy/popups/calculateOrder.jsp&ServiceStockUid="+serviceStockUid+"&ServiceStockName="+serviceStockName+"&ts=<%=getTs()%>",700,400);
  }

  function printInventory(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceStockInventory.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printInventoryCsv(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceStockInventoryCsv.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printInventorySummary(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceStockInventorySummary.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,700,500);
	  }

  function poiPharmacyInventory(serviceStockUid){
		openPopup("statistics/pharmacy/getPoiServiceStockInventorySummary.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,700,500);
	  }

  function poiPharmacySynthesis(serviceStockUid){
		openPopup("statistics/pharmacy/getPoiServiceStockInventorySynthesis.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,700,500);
	  }

  function poiPharmacyValorisation(serviceStockUid){
		openPopup("statistics/pharmacy/getPoiServiceStockInventoryValorisation.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,700,500);
	  }

  function poiPharmacyExpiration(serviceStockUid){
		openPopup("statistics/pharmacy/getPoiExpiration.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,700,500);
	  }

  function printInventorySummaryCsv(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceStockInventorySummaryCsv.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printStockOperations(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceStockOperations.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printOutgoingStockOperations(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceOutgoingStockOperations.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printOutgoingStockOperationsPerService(serviceStockUid){
		openPopup("statistics/pharmacy/getServiceOutgoingStockOperationsPerService.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printIncomingStockOperations(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceIncomingStockOperations.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printIncomingStockOperationsPerOrder(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceIncomingStockOperationsPerOrder.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printIncomingStockOperationsPerItem(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceIncomingStockOperationsPerItem.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printIncomingStockOperationsPerCategoryItem(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceIncomingStockOperationsPerCategoryItem.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printIncomingStockOperationsPerProvider(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceIncomingStockOperationsPerProvider.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printOutgoingStockOperationsListing(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceOutgoingStockOperationsListing.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printOutgoingStockOperationsListingPerService(serviceStockUid){
	openPopup("statistics/pharmacy/getServiceOutgoingStockOperationsListingPerService.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printMonthlyConsumption(serviceStockUid){
		openPopup("statistics/pharmacy/getMonthlyConsumption.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printStockContent(serviceStockUid){
		window.open("pharmacy/exportstock.jsp?ts=<%=getTs()%>&servicestockuid="+serviceStockUid);
	  }

  function copyProducts(serviceStockUid){
		openPopup("pharmacy/copyProducts.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printExpiration(serviceStockUid){
	openPopup("statistics/pharmacy/getExpiration.jsp&ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
  }

  function printStockOut(serviceStockUid){
	  openPopup("statistics/pharmacy/getStockout.jsp?ts=<%=getTs()%>&ServiceStockUid="+serviceStockUid,500,200);
	  }

  function printProductionReport(report,serviceStockUid){
	  openPopup("pharmacy/manageProductionReports.jsp?ts=<%=getTs()%>&report="+report+"&ServiceStockUid="+serviceStockUid,400,200);
	  }

  function printProductionReportPeriod(report,serviceStockUid){
	  openPopup("pharmacy/manageProductionReportsPeriod.jsp?ts=<%=getTs()%>&report="+report+"&ServiceStockUid="+serviceStockUid,400,200);
	  }

  function printProductionReportPeriodService(report,serviceStockUid){
	  openPopup("pharmacy/manageProductionReportsPeriodService.jsp?ts=<%=getTs()%>&report="+report+"&ServiceStockUid="+serviceStockUid,600,200);
	  }

  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<%=sCONTEXTPATH%>/main.do?Page=pharmacy/manageServiceStocks.jsp&DisplaySearchFields=true&ts=<%=getTs()%>";
  }

  function bulkReceive(serviceStockUid){
	    openPopup("pharmacy/popups/bulkReceive.jsp&ServiceStockUid="+serviceStockUid+"&ts=<%=getTs()%>",700,400);
	}

  function validateDeliveries(serviceStockUid){
	    openPopup("pharmacy/popups/validateDeliveries.jsp&ServiceStockUid="+serviceStockUid+"&ts=<%=getTs()%>",700,400);
	}

  function acceptOrders(serviceStockUid){
	    openPopup("pharmacy/popups/acceptOrders.jsp&ServiceStockUid="+serviceStockUid+"&ts=<%=getTs()%>",700,400);
	}
  function doPatientPrescription(serviceStockUid){
		openPopup("pharmacy/viewUndeliveredPrescriptions.jsp&ts=<%=getTs()%>&FindServiceStockUid="+serviceStockUid,800,300);
  }
  function printFiche(serviceStockUid,serviceStockName){
	openPopup("pharmacy/viewServiceStockFiches.jsp&ts=<%=getTs()%>&Action=find&FindServiceStockUid="+serviceStockUid+"&GetYear=<%=new SimpleDateFormat("yyyy").format(new java.util.Date())%>&FindServiceStockName="+serviceStockName,800,500);
  }

  function initializeRemote(){
	    document.getElementById('divInitializeRemote').innerHTML = "<img src='<c:url value="/_img/themes/default/ajax-loader.gif"/>'/><br/>Loading";
	    var params = 'serviceStockUid=<%=sEditStockUid%>';
	    var url= '<c:url value="/pharmacy/ajax/initializeRemoteStock.jsp"/>';
		new Ajax.Request(url,{
		  method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	    	  document.getElementById('divInitializeRemote').innerHTML = '';
	    	  alert('<%=getTranNoLink("web","initializeremote.successful",sWebLanguage)%>');
	      },
	      onError: function(resp){
	    	  document.getElementById('divInitializeRemote').innerHTML = '';
	    	  alert('<%=getTranNoLink("web","initializeremote.failed",sWebLanguage)%>');
	      }
		});
	  }

  <%-- close "search in progress"-popup that might still be open --%>
  var popup = window.open("","Searching","width=1,height=1");
  popup.close();
</script>