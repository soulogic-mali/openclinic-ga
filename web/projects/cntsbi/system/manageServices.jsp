<%@page import="java.util.Enumeration,
                be.openclinic.pharmacy.ServiceStock,
                java.util.*,
                be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%=checkPermission(out,"system.manageservices","all",activeUser)%>
<%=sJSPROTOTYPE %>
<%
    String sAction = checkString(request.getParameter("Action"));

    String sFindServiceCode    = checkString(request.getParameter("FindServiceCode")),
           sFindServiceText    = checkString(request.getParameter("FindServiceText")),
           sEditOldServiceCode = checkString(request.getParameter("EditOldServiceCode"));

    // DEBUG //////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n************************ system/manageServices.jsp *********************");
        Debug.println("sAction             : "+sAction);
        Debug.println("sFindServiceCode    : "+sFindServiceCode);
        Debug.println("sFindServiceText    : "+sFindServiceText);
        Debug.println("sEditOldServiceCode : "+sEditOldServiceCode+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String tmpLang;

    // supported languages
    String supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages");
    if(supportedLanguages.length()==0) supportedLanguages = "nl,fr";
    supportedLanguages = supportedLanguages.toLowerCase();

    // get all params starting with 'EditLabelValueXX', representing labels in different languages
    Hashtable labelValues = new Hashtable();
    Enumeration paramEnum = request.getParameterNames();
    String tmpParamName, tmpParamValue;

    if(sAction.equals("save")){
        while (paramEnum.hasMoreElements()){
            tmpParamName = (String)paramEnum.nextElement();

            if(tmpParamName.startsWith("EditLabelValue")){
                tmpParamValue = request.getParameter(tmpParamName);
                labelValues.put(tmpParamName.substring(14),tmpParamValue); // language, value
            }
        }
    }
    else if(sAction.equals("edit")){
        StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
        while(tokenizer.hasMoreTokens()){
            tmpLang = tokenizer.nextToken();
            labelValues.put(tmpLang,getTranDb("service",sFindServiceCode,tmpLang)); // language, value
        }
    }

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditOldServiceCode.length() > 0){
        String sEditServiceCode = checkString(request.getParameter("EditServiceCode")),
               sEditServiceAddress = checkString(request.getParameter("EditServiceAddress")),
               sEditServiceCity = checkString(request.getParameter("EditServiceCity")),
               sEditServiceZipcode = checkString(request.getParameter("EditServiceZipcode")),
               sEditServiceCountry = checkString(request.getParameter("EditServiceCountry")),
               sEditServiceTelephone = checkString(request.getParameter("EditServiceTelephone")),
               sEditServiceFax = checkString(request.getParameter("EditServiceFax")),
               sEditServiceComment = checkString(request.getParameter("EditServiceComment")),
               sEditServiceEmail = checkString(request.getParameter("EditServiceEmail")),
               sEditServiceParentID = checkString(request.getParameter("EditServiceParentCode")),
               sEditServiceInscode = checkString(request.getParameter("EditServiceInscode")),
               sEditServiceShowOrder = checkString(request.getParameter("EditServiceShowOrder")),
               sEditServiceLanguage = checkString(request.getParameter("EditServiceLanguage")),
               sEditServiceContract = checkString(request.getParameter("EditServiceContract")),
               sEditServiceContractType = checkString(request.getParameter("EditServiceContractType")),
               sEditServiceContactPerson = checkString(request.getParameter("EditServiceContactPerson")),
               sEditServiceContractDate = checkString(request.getParameter("EditServiceContractDate")),
               sEditServiceDefaultContext = checkString(request.getParameter("EditServiceDefaultContext")),
               sEditDefaultServiceStockUid = checkString(request.getParameter("EditDefaultServiceStockUid")),
               sEditTotalBeds = checkString(request.getParameter("EditTotalBeds")),
               sEditServiceAdmissionLimit = checkString(request.getParameter("EditServiceAdmissionLimit")),
               sEditServiceWicket = checkString(request.getParameter("EditServiceWicket")),
               sEditServiceCostcenter = checkString(request.getParameter("EditServiceCostcenter")),
               sEditServiceAcceptsVisits = checkString(request.getParameter("EditServiceAcceptsVisits")),
               sEditCareProvider = checkString(request.getParameter("EditCareProvider")),
               sEditStayPrestationUid = checkString(request.getParameter("EditStayPrestationUid")),
               sEditServiceInactive =checkString(request.getParameter("EditServiceInactive"));
		
        try{
        	int i = Integer.parseInt(sEditServiceAdmissionLimit);
        }
        catch (Exception e){
        	sEditServiceAdmissionLimit="0";
        }
        try{
        	int i = Integer.parseInt(sEditTotalBeds);
        }
        catch (Exception e){
        	sEditTotalBeds="0";
        }
        // codes
        String //sEditServiceCode1 = checkString(request.getParameter("EditServiceCode1")),
                //sEditServiceCode2 = checkString(request.getParameter("EditServiceCode2")),
                sEditServiceCode3 = checkString(request.getParameter("EditServiceCode3")), // NACE
                //sEditServiceCode4 = checkString(request.getParameter("EditServiceCode4")),
                sEditServiceCode5 = checkString(request.getParameter("EditServiceCode5"));

        // contact data ('post-adres')
        String sEditContactAddress = checkString(request.getParameter("EditContactAddress")),
               sEditContactZipcode = checkString(request.getParameter("EditContactZipcode")),
               sEditContactCity    = checkString(request.getParameter("EditContactCity")),
               sEditContactCountry = checkString(request.getParameter("EditContactCountry")),
               sEditContactTelephone = checkString(request.getParameter("EditContactTelephone")),
               sEditContactFax     = checkString(request.getParameter("EditContactFax")),
               sEditContactEmail   = checkString(request.getParameter("EditContactEmail"));

        boolean isExternalService = Service.isExternalService(sEditServiceCode);

        // new
        if(sEditOldServiceCode.equals("-1")){
            //*** INSERT SERVICE **********************************************
            Hashtable hServiceInfo = new Hashtable();
            hServiceInfo.put("serviceid",sEditServiceCode.toUpperCase());
            hServiceInfo.put("address",sEditServiceAddress);
            hServiceInfo.put("city",sEditServiceCity);
            hServiceInfo.put("zipcode",sEditServiceZipcode);
            hServiceInfo.put("country",sEditServiceCountry);
            hServiceInfo.put("telephone",sEditServiceTelephone);
            hServiceInfo.put("fax",sEditServiceFax);
            hServiceInfo.put("comment",sEditServiceComment);
            hServiceInfo.put("updatetime",getSQLTime());
            hServiceInfo.put("email",sEditServiceEmail);
            hServiceInfo.put("serviceparentid",sEditServiceParentID);
            hServiceInfo.put("inscode",sEditServiceInscode);
            hServiceInfo.put("serviceorder",sEditServiceShowOrder);
            hServiceInfo.put("servicelanguage",sEditServiceLanguage);
            hServiceInfo.put("updateuserid",activeUser.userid);
            hServiceInfo.put("contract",sEditServiceContract);
            hServiceInfo.put("contracttype",sEditServiceContractType);
            hServiceInfo.put("contactperson",sEditServiceContactPerson);
            hServiceInfo.put("contractdate",sEditServiceContractDate);
            hServiceInfo.put("defaultcontext",sEditServiceDefaultContext);
            hServiceInfo.put("defaultservicestockuid",sEditDefaultServiceStockUid);
            hServiceInfo.put("contactaddress",sEditContactAddress);
            hServiceInfo.put("contactzipcode",sEditContactZipcode);
            hServiceInfo.put("contactcity",sEditContactCity);
            hServiceInfo.put("contactcountry",sEditContactCountry);
            hServiceInfo.put("contacttelephone",sEditContactTelephone);
            hServiceInfo.put("contactfax",sEditContactFax);
            hServiceInfo.put("contactemail",sEditContactEmail);
            hServiceInfo.put("costcenter",sEditServiceCostcenter);
            hServiceInfo.put("performeruid",sEditCareProvider);
            hServiceInfo.put("stayprestationuid",sEditStayPrestationUid);
            try{
                hServiceInfo.put("totalbeds",new Integer(sEditTotalBeds));
            }
            catch(Exception a){
                hServiceInfo.put("totalbeds",new Integer(0));
            }
            try{
                hServiceInfo.put("serviceadmissionlimit",new Integer(sEditServiceAdmissionLimit));
            }
            catch(Exception a){
                hServiceInfo.put("serviceadmissionlimit",new Integer(0));
            }
            
            // codes
            hServiceInfo.put("code3",sEditServiceCode3);
            hServiceInfo.put("code5",sEditServiceCode5);
            if(sEditServiceWicket.equals("on")){
                hServiceInfo.put("wicket",new Integer(1));
            }
            else{
                hServiceInfo.put("wicket",new Integer(0));
            }
            
            if(sEditServiceAcceptsVisits.equals("on")){
                hServiceInfo.put("acceptsVisits",new Integer(1));
            }
            else{
                hServiceInfo.put("acceptsVisits",new Integer(0));
            }
            
            if(sEditServiceInactive.equals("on")){
                hServiceInfo.put("inactive",new Integer(1));
            }
            else{
                hServiceInfo.put("inactive",new Integer(0));
            }
            hServiceInfo.put("users","");

            Service.manageServiceSave(hServiceInfo);

            Label objLabel;
            StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
            while(tokenizer.hasMoreTokens()){
                tmpLang = tokenizer.nextToken();

                objLabel = new Label();
                objLabel.type = "Service";
                objLabel.id = sEditServiceCode;
                objLabel.language = tmpLang;
                objLabel.value = checkString((String) labelValues.get(tmpLang));
                objLabel.showLink = "0";
                objLabel.updateUserId = activeUser.userid;

                objLabel.saveToDB();

                if(isExternalService){
                    MedwanQuery.getInstance().removeLabelFromCache("externalService",sEditServiceCode,tmpLang);
                    MedwanQuery.getInstance().getLabel("externalService",sEditServiceCode,tmpLang);
                }
                else{
                    MedwanQuery.getInstance().removeLabelFromCache("service",sEditServiceCode,tmpLang);
                    MedwanQuery.getInstance().getLabel("service",sEditServiceCode,tmpLang);
                }
            }
        }
        //*** UPDATE SERVICE **************************************************
        else{
            Hashtable hServiceInfo = new Hashtable();
            hServiceInfo.put("serviceid",sEditServiceCode);
            hServiceInfo.put("address",sEditServiceAddress);
            hServiceInfo.put("city",sEditServiceCity);
            hServiceInfo.put("zipcode",sEditServiceZipcode);
            hServiceInfo.put("country",sEditServiceCountry);
            hServiceInfo.put("telephone",sEditServiceTelephone);
            hServiceInfo.put("fax",sEditServiceFax);
            hServiceInfo.put("comment",sEditServiceComment);
            hServiceInfo.put("updatetime",getSQLTime());
            hServiceInfo.put("email",sEditServiceEmail);
            hServiceInfo.put("serviceparentid",sEditServiceParentID);
            hServiceInfo.put("inscode",sEditServiceInscode);
            hServiceInfo.put("serviceorder",sEditServiceShowOrder);
            hServiceInfo.put("servicelanguage",sEditServiceLanguage);
            hServiceInfo.put("updateuserid",activeUser.userid);
            hServiceInfo.put("contract",sEditServiceContract);
            hServiceInfo.put("contracttype",sEditServiceContractType);
            hServiceInfo.put("contactperson",sEditServiceContactPerson);
            hServiceInfo.put("contractdate",sEditServiceContractDate);
            hServiceInfo.put("defaultcontext",sEditServiceDefaultContext);
            hServiceInfo.put("defaultservicestockuid",sEditDefaultServiceStockUid);

            hServiceInfo.put("contactaddress",sEditContactAddress);
            hServiceInfo.put("contactzipcode",sEditContactZipcode);
            hServiceInfo.put("contactcity",sEditContactCity);
            hServiceInfo.put("contactcountry",sEditContactCountry);
            hServiceInfo.put("contacttelephone",sEditContactTelephone);
            hServiceInfo.put("contactfax",sEditContactFax);
            hServiceInfo.put("contactemail",sEditContactEmail);
            hServiceInfo.put("totalbeds",sEditTotalBeds);
            hServiceInfo.put("serviceadmissionlimit",sEditServiceAdmissionLimit);
            hServiceInfo.put("costcenter",sEditServiceCostcenter);
            hServiceInfo.put("performeruid",sEditCareProvider);
            hServiceInfo.put("stayprestationuid",sEditStayPrestationUid);

            hServiceInfo.put("code3",sEditServiceCode3);// NACE
            hServiceInfo.put("code5",sEditServiceCode5);// MED CENTRE
            if(sEditServiceAcceptsVisits.equals("on")){
                hServiceInfo.put("acceptsVisits",new Integer(1));
            } else{
                hServiceInfo.put("acceptsVisits",new Integer(0));
            }
            if(sEditServiceWicket.equals("on")){
                hServiceInfo.put("wicket",new Integer(1));
            } else{
                hServiceInfo.put("wicket",new Integer(0));
            }
            if(sEditServiceInactive.equals("on")){
                hServiceInfo.put("inactive",new Integer(1));
            } else{
                hServiceInfo.put("inactive",new Integer(0));
            }
            hServiceInfo.put("oldserviceid",sEditOldServiceCode);
            hServiceInfo.put("users","");

            Service.manageServiceUpdate(hServiceInfo);

            //***** update labels for all supported languages *****

            StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
            Label objLabel;
            while(tokenizer.hasMoreTokens()){
                tmpLang = tokenizer.nextToken();

                objLabel = new Label();
                objLabel.type = "Service";
                objLabel.id = sEditServiceCode;
                objLabel.language = tmpLang;
                objLabel.value = checkString((String) labelValues.get(tmpLang));
                objLabel.showLink = "0";
                objLabel.updateUserId = activeUser.userid;

                objLabel.saveToDB();

                MedwanQuery.getInstance().removeLabelFromCache("service",sEditServiceCode,tmpLang);
                MedwanQuery.getInstance().getLabel("service",sEditServiceCode,tmpLang);
            }
        }

        reloadSingleton(session);

        sFindServiceCode = sEditServiceCode;
        if(sFindServiceCode.length() > 0){
            sFindServiceText = getTranNoLink("service",sEditServiceCode,sWebLanguage);
        }
        MedwanQuery.getInstance().removeServiceExaminations(sEditServiceCode);
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete")){
        //*** delete service **********
        try {
            if(sFindServiceCode.length() > 0){
                Service service = Service.getService(sFindServiceCode);
                if(service != null){
                  	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                    service.delete(ad_conn);
                    ad_conn.close();
                    MedwanQuery.getInstance().removeServiceExaminations(sFindServiceCode);
                }
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }

        //*** delete label ************
        try {
            if(sFindServiceCode.length() > 0){
                StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
                while (tokenizer.hasMoreTokens()){
                    tmpLang = tokenizer.nextToken();
                    Label.delete("service",sFindServiceCode,tmpLang);
                }
                labelValues = new Hashtable();
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }

        sAction = "";
        sFindServiceCode = "";
        sFindServiceText = "";
    }
%>
<%=sJSEMAIL%>

<form name="transactionForm" id="transactionForm" method="post">
<input type="hidden" name="Action">

<%-- SEARCH FIELDS ------------------------------------------------------------------------------%>
<%
    // only display header when not editing the data
    if(sAction.equals("") || sAction.equals("save")){
        %>
            <%=writeTableHeader("Web.manage","ManageServices",sWebLanguage," doBackToMenu();")%>

            <table width="100%" class="list" cellspacing="0">
                <tr>
                    <td class="admin2" width="160">&nbsp;<%=getTran(request,"web","service",sWebLanguage)%></td>
                    <td class="admin2">
                        <input class="text" type="text" name="FindServiceText" READONLY size="<%=sTextWidth%>" title="<%=sFindServiceText%>" value="<%=sFindServiceText%>">
                        <input type="hidden" name="FindServiceCode" value="<%=sFindServiceCode%>">
                       
                        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('FindServiceCode','FindServiceText');">
                        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.FindServiceCode.value='';transactionForm.FindServiceText.value='';">&nbsp;&nbsp;&nbsp;
                                          
                        <%-- BUTTONS --%>
                        <input type="button" class="button" name="editButton" value="<%=getTranNoLink("web","edit",sWebLanguage)%>" onClick="doEdit(transactionForm.FindServiceCode.value);">
                        <input type="button" class="button" name="clearButton" value="<%=getTranNoLink("web","clear",sWebLanguage)%>" onClick="clearFields();">
                        <input type="button" class="button" name="newButton" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onClick="doNew();">
                        <input type="button" class="button" name="deleteButton" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onClick="doDelete(transactionForm.FindServiceCode.value);">
                        <input type="button" class="button" name="backButton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onClick="doBackToMenu();">
                    </td>
                </tr>
            </table>
        <%
    }
%>

<script>
  <%-- popup : search service --%>
  function searchService(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&showinactive=1&VarCode="+serviceUidField+"&VarText="+serviceNameField+"&SearchExternalServices=true&SearchInternalServices=true");
  }

  <%-- DO EDIT --%>
  function doEdit(serviceId){
    if(serviceId.length > 0){
      transactionForm.Action.value = "edit";
      transactionForm.submit();
    }
  }

  <%-- DO DELETE --%>
  function doDelete(serviceId){
    if(serviceId.length > 0){
        if(yesnoDeleteDialog()){
        transactionForm.Action.value = "delete";
        transactionForm.submit();
      }
    }
  }

  <%-- DO BACK --%>
  function doBackToMenu(){
    window.location.href = "<%=sCONTEXTPATH%>/main.jsp?Page=system/menu.jsp";
  }

  function doBack(){
    window.location.href = "<%=sCONTEXTPATH%>/main.jsp?Page=system/manageServices.jsp";
  }

  <%-- DO NEW --%>
  function doNew(){
    clearFields();

    transactionForm.Action.value = "new";
    transactionForm.submit();
  }

  <%-- CLEAR FIELDS --%>
  function clearFields(){
    transactionForm.FindServiceCode.value = "";
    transactionForm.FindServiceText.value = "";
  }
</script>
<%
    if(sAction.equals("new")){
        sFindServiceCode = "-1";
        sAction = "edit";
    }

    //--- DISPLAY SPECIFIED SERVICE ---------------------------------------------------------------
    if(sAction.equals("edit") && sFindServiceCode.length() > 0){
        String sServiceParentCodeText = "", sServiceCountryText = "", sContactCountryText = "";
        Label label = new Label();
        Service service;
        service = Service.getService(sFindServiceCode);
        if(service!=null){
            // translate
            if(service.parentcode.trim().length()>0){
                sServiceParentCodeText = getTran(request,"service",service.parentcode,sWebLanguage);
            }
            if(service.country.trim().length()>0){
                sServiceCountryText = getTran(request,"Country",service.country,sWebLanguage);
            }
            if(service.contactcountry.trim().length()>0){
                sContactCountryText = getTran(request,"Country",service.contactcountry,sWebLanguage);
            }
            
            StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
            Label objLabel;
            while(tokenizer.hasMoreTokens()){
                tmpLang = tokenizer.nextToken();
                objLabel = new Label();
                Label.get("service",service.code,tmpLang);
                service.labels.add(objLabel);
                service.labels.add(label);
            }
        }
        else{
            service = new Service();
        }
        %>
            <input type="hidden" name="EditOldServiceCode" id="EditOldServiceCode" value="<%=sFindServiceCode%>">
            <%-- page title --%>
            <%=writeTableHeader("Web.manage","ManageServices",sWebLanguage," doBackToMenu();")%>
            
            <%-- SERVICE DETAILS ----------------------------------------------------------------%>
            <table width="100%" class="list" cellspacing="1">
                <%-- Service --%>
                <tr>
                    <td class="admin" width="<%=sTDAdminWidth%>"> <%=getTran(request,"Web.Manage.Service","ID",sWebLanguage)%> *</td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceCode" id="EditServiceCode" value="<%=service.code%>" size="<%=sTextWidth%>" onblur="validateCode()">
                    </td>
                </tr>
                <%-- ParentID --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web.Manage.Service","ParentID",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" readonly class="text" name="EditServiceParentCode" value="<%=service.parentcode%>"> <input type="text" readonly class="text" name="EditServiceParentText" value="<%=sServiceParentCodeText%>" size="<%=sTextWidth%>">
                        <%=ScreenHelper.writeServiceButton("buttonService","EditServiceParentCode","EditServiceParentText",sWebLanguage,sCONTEXTPATH)%>
                    </td>
                </tr>
                <%-- ShowOrder --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web.manage.Service","ShowOrder",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceShowOrder" value="<%=service.showOrder%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Language --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Language",sWebLanguage)%></td>
                    <td class="admin2">
                        <select name="EditServiceLanguage" select-one class="text">
                            <%
                                StringTokenizer stokenizer = new StringTokenizer(supportedLanguages,",");
                                while(stokenizer.hasMoreTokens()){
                                    tmpLang = stokenizer.nextToken();

                                    %><option value='<%=tmpLang%>' <%=(service.language.equalsIgnoreCase(tmpLang)?"SELECTED":"")%>><%=getTran(request,"Web.Language",tmpLang,sWebLanguage)%></option><%
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <%-- Inscode --%>
                <% 	if(MedwanQuery.getInstance().getConfigInt("enableDHIS2",0)==1){ %>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web.Manage.Service","dhis2code",sWebLanguage)%></td>
                    <td class="admin2">
                        <select class="text" name="EditServiceInscode" id="EditServiceInscode">
                        	<option value=""></option>
                        	<%=ScreenHelper.writeSelect(request,"dhis2services", service.inscode, sWebLanguage,false,true,60) %>
                        </select>
                    </td>
                </tr>
                <% 	}
                   	else{
                %>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web.Manage.Service","Inscode",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceInscode" value="<%=service.inscode%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%
                   }
                    // display input field for each of the supported languages
                    StringTokenizer tokenizer = new StringTokenizer(supportedLanguages,",");
                    while(tokenizer.hasMoreTokens()){
                        tmpLang = tokenizer.nextToken();

                        %>
                            <tr>
                                <td class="admin"> <%=getTran(request,"Web","Description",sWebLanguage)%> <%=tmpLang%> *</td>
                                <td class="admin2">
                                    <input type="text" class="text" name="EditLabelValue<%=tmpLang%>" value="<%=checkString((String)labelValues.get(tmpLang))%>" size="<%=sTextWidth%>">
                                </td>
                            </tr>
                        <%
                    }
                %>
                <%-- Address --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Address",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceAddress" value="<%=service.address%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Zipcode --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Zipcode",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceZipcode" value="<%=service.zipcode%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- City --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","City",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceCity" value="<%=service.city%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Country --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Country",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" readonly class="text" name="EditServiceCountryText" value="<%=sServiceCountryText%>" size="<%=sTextWidth%>">
                        <%=ScreenHelper.writeSearchButton("buttonCountry","Country","EditServiceCountry","EditServiceCountryText","",sWebLanguage,sCONTEXTPATH)%>
                        <input type="hidden" name="EditServiceCountry" value="<%=service.country%>">
                    </td>
                </tr>
                <%-- Telephone --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Telephone",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceTelephone" value="<%=service.telephone%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Fax --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Fax",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceFax" value="<%=service.fax%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Email --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Email",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceEmail" value="<%=service.email%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- contract --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","environment",sWebLanguage)%></td>
                    <td class="admin2">
                    	<select class='text' name="EditServiceContract" id="EditServiceContract">
                    		<option/>
                    		<%=SH.writeSelect(request, "cnts.environment", service.contract, sWebLanguage) %>
                    	</select>
                    </td>
                </tr>
                <%-- contracttype --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","contracttype",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceContractType" value="<%=service.contracttype%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- contractdate --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","contractdate",sWebLanguage)%></td>
                    <td class="admin2"><%=writeDateField("EditServiceContractDate","transactionForm",checkString(service.contractdate),sWebLanguage)%></td>
                </tr>
                <%-- contactperson --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","contactperson",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceContactPerson" value="<%=service.contactperson%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- NACE (code3) --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","servicetype",sWebLanguage)%></td>
                    <td class="admin2">
		                <select class="text" name="EditServiceCode3" style="vertical-align:top;">
		                	<option/>
		                	<%=ScreenHelper.writeSelect(request,"servicetypes", checkString(service.code3), sWebLanguage) %>
		                </select>
                    </td>
                </tr>
                <%-- Total beds --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","totalbeds",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditTotalBeds" value="<%=service.totalbeds%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%-- Service admission limit --%>
                <% if(MedwanQuery.getInstance().getConfigInt("autoCloseAdmissions", 0)==1){ %>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","serviceadmissionlimit",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceAdmissionLimit" value="<%=service.serviceadmissionlimit%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <%} %>
                <%-- MEDICAL CENTRE (code5) --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","medicalcentre",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceCode5" value="<%=service.code5%>" size="<%=sTextWidth%>">
                    </td>
                </tr>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","stayprestation",sWebLanguage)%></td>
                    <td class="admin2">
		                <select class="text" name="EditStayPrestationUid" style="vertical-align:top;">
		                	<option value=''></option>
		                    <%
		                        Vector prestations = Prestation.getPrestationsByClass("stay");
		                        for(int n=0; n<prestations.size(); n++){
		                            Prestation prestation = (Prestation)prestations.elementAt(n);
		                            if(prestation!=null){
		                                out.println("<option value='"+prestation.getUid()+"' "+(checkString(service.stayprestationuid).equalsIgnoreCase(prestation.getUid())?"selected":"")+">"+prestation.getCode()+": "+prestation.getDescription()+"</option>");
		                            }
		                        }
		                    %>
		                </select>
                    </td>
                </tr>
                
	            <tr>
		            <td class='admin'><%=getTran(request,"web","invoicingcareprovider",sWebLanguage)%></td>
		            <td class='admin2'>
		            	<select class='text' name='EditCareProvider' id='EditCareProvider'>
		            		<option value=''></option>
				            <%
				            	Vector users = UserParameter.getUserIds("invoicingcareprovider","on");
				            	SortedMap usernames = new TreeMap();
				            	for(int n=0; n<users.size(); n++){
				            		User user = User.get(Integer.parseInt((String)users.elementAt(n)));
				            		usernames.put(user.person.lastname.toUpperCase()+", "+user.person.firstname,user.userid);
				            	}
				            	
			            		String sSelectedValue = checkString(service.performeruid);
				            	Iterator i = usernames.keySet().iterator();
				            	while(i.hasNext()){
				            		String username = (String)i.next();
				            		out.print("<option value='"+usernames.get(username)+"'"+(sSelectedValue.equals(usernames.get(username))?" selected":"")+">"+username+"</option>");
				            	}
				            %>
		            	</select>
		            </td>
		        </tr>
                
                <%-- Costcenter --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","costcenter",sWebLanguage)%></td>
                    <td class="admin2">
                    	<select name="EditServiceCostcenter" class="text">
                    	<option value=''/>
                    	<%=ScreenHelper.writeSelect(request,"costcenter",checkString(service.costcenter),sWebLanguage,false,true) %>
                    	</select>
                    </td>
                </tr>
                
                <%--- for internal services only (exclude external services) --------------------%>
                <%
                    if(!Service.isExternalService(service.code)){
                        %>
                            <%-- DEFAULT CONTEXT --%>
                            <tr>
                                <td class="admin"> <%=getTran(request,"Web","defaultcontext",sWebLanguage)%></td>
                                <td class="admin2">
                                    <select name="EditServiceDefaultContext" select-one class="text">
                                        <option value="">
                                        <%
                                            // list possible contexts from XML-file
                                            String sDoc = MedwanQuery.getInstance().getConfigString("templateSource")+"contexts.xml";
                                            if(sDoc.length() > 0){
                                                SAXReader reader = new SAXReader(false);
                                                Document document = reader.read(new URL(sDoc));
                                                Iterator elements = document.getRootElement().elementIterator("context");

                                                Element element;
                                                while(elements.hasNext()){
                                                    element = (Element)elements.next();
                                                    out.println("<option value='"+element.attribute("id").getValue()+"' "+(element.attribute("id").getValue().equalsIgnoreCase(service.defaultContext)?"selected":"")+"/>"+getTran(request,"Web.Occup",element.attribute("id").getValue(),sWebLanguage));
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <%-- Default ServiceStock --%>
                            <%
                                String serviceStockName = "";
                                if(service.defaultServiceStockUid.length() > 0){
                                    ServiceStock serviceStock = ServiceStock.get(service.defaultServiceStockUid);
                                    if(serviceStock!=null){
                                        serviceStockName = serviceStock.getName();
                                    }
                                }
                            %>
                            <tr>
                                <td class="admin" nowrap><%=getTran(request,"Web","defaultServiceStock",sWebLanguage)%>&nbsp;</td>
                                <td class="admin2">
                                    <input type="hidden" name="EditDefaultServiceStockUid" value="<%=service.defaultServiceStockUid%>">
                                    <input class="text" type="text" name="EditDefaultServiceStockName" readonly size="<%=sTextWidth%>" value="<%=serviceStockName%>">

                                    <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchServiceStock('EditDefaultServiceStockUid','EditDefaultServiceStockName');">
                                    <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditDefaultServiceStockUid.value='';transactionForm.EditDefaultServiceStockName.value='';">
                                </td>
                            </tr>
                        <%
                    }
                %>
                <%-- WICKET --%>
                <%
                    String sChecked = "";
                    if(service.wicket.equals("1")){
                        sChecked = " checked";
                    }
                %>
                <tr>
                    <td class="admin"><%=getTran(request,"web","wicket",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="checkbox" class="hand" name="EditServiceWicket" <%=sChecked%>/>
                    </td>
                </tr>
                <%
	                sChecked = "";
                    if(checkString(service.acceptsVisits).equals("1")){
                        sChecked = " checked";
                    }
                %>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","acceptsvisits",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="checkbox" class="hand" name="EditServiceAcceptsVisits" <%=sChecked%>/>
                    </td>
                </tr>
                <%-- INACTIVE --%>
                <%
                    sChecked = "";
                    if(service.inactive.equals("1")){
                        sChecked = " checked";
                    }
                %>
                <tr>
                    <td class="admin"><%=getTran(request,"web","inactive",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="checkbox" class="hand" name="EditServiceInactive" <%=sChecked%>/>
                    </td>
                </tr>
                <%-- COMMENT --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Comment",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditServiceComment" value="<%=service.comment%>" size="<%=sTextWidth%>">
                        <BR/><%=getTran(request,"web","noexams",sWebLanguage)%>
                    </td>
                </tr>
                <%-- spacer --%>
                <tr><td colspan="2">&nbsp;</td></tr>

                <%-- contact-section ------------------------------------------------------------%>
                <tr>
                    <td colspan="2" class="admin" height="22"><%=getTran(request,"web","service.contactaddress",sWebLanguage)%></td>
                </tr>
                <%-- ContactAddress --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","address",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactAddress" value="<%=service.contactaddress%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- ContactZipcode --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","zipcode",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactZipcode" value="<%=service.contactzipcode%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- ContactCity --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","city",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactCity" value="<%=service.contactcity%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- ContactCountry --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","Country",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" readonly class="text" name="EditContactCountryText" value="<%=sContactCountryText%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                        <%=ScreenHelper.writeSearchButton("buttonContactCountry","Country","EditContactCountry","EditContactCountryText","",sWebLanguage,sCONTEXTPATH)%>
                        <input type="hidden" name="EditContactCountry" value="<%=service.contactcountry%>">
                    </td>
                </tr>
                <%-- ContactTelephone --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","telephone",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactTelephone" value="<%=service.contacttelephone%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- ContactFax --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","fax",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactFax" value="<%=service.contactfax%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
                <%-- ContactEmail --%>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","email",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" name="EditContactEmail" value="<%=service.contactemail%>" size="<%=sTextWidth%>" onblur="limitLength(this);">
                    </td>
                </tr>
            </table>
            
            <%-- indication of obligated fields --%>
            <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>
            
            <%-- EDIT BUTTONS --%>
            <%=ScreenHelper.alignButtonsStart()%>
                <input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","Save",sWebLanguage)%>' onclick="doSave();">
                <input type="button" class="button" name="deleteButton" value="<%=getTranNoLink("Web","delete",sWebLanguage)%>" onclick="doDelete(transactionForm.EditServiceCode.value);">
                <input class="button" type="button" name="backButton" value='<%=getTranNoLink("Web","Back",sWebLanguage)%>' OnClick='doBack();'>
            <%=ScreenHelper.alignButtonsStop()%>
            
            <script>
              transactionForm.EditServiceCode.focus();

              function validateCode(){
            	  if(document.getElementById("EditServiceCode").value.length>0 && document.getElementById("EditOldServiceCode").value!=document.getElementById("EditServiceCode").value){
					  //Check if new code does not exist yet
            		    var today = new Date();
            		    var url= '<c:url value="/system/serviceCodeExists.jsp"/>?servicecode='+document.getElementById("EditServiceCode").value+'&ts=' + today;
            		    new Ajax.Request(url,{
            		            method: "POST",
            		            params: "",
            		            onSuccess: function(resp){
            		                if((resp.responseText).indexOf("<EXISTS>")>-1){
            		                	  alert('<%=getTranNoLink("web","servicecode.already.exists",sWebLanguage)%>');
            		            		  document.getElementById("EditServiceCode").focus();
            		                }
            		            }
            		        }
            		    ); 
            	  }
              }
              <%-- DO SAVE --%>
              function doSave(){
                var maySubmit = true;

                if(maySubmit){
                  <%-- check for valid email --%>
                  if(transactionForm.EditServiceEmail.value.length > 0){
                    if(!validEmailAddress(transactionForm.EditServiceEmail.value)){
                      maySubmit = false;
                      alertDialog("web","invalidEmailAddress");
                      transactionForm.EditServiceEmail.focus();
                    }
                  }
                }

                if(maySubmit){
                  <%-- check for valid contact-email --%>
                  if(transactionForm.EditContactEmail.value.length > 0){
                    if(!validEmailAddress(transactionForm.EditContactEmail.value)){
                      maySubmit = false;
                      alertDialog("web","invalidEmailAddress");
                      transactionForm.EditContactEmail.focus();
                    }
                  }
                }

                if(maySubmit){
                    <%-- check for valid contact-email --%>
                    if(transactionForm.EditServiceCode.value==transactionForm.EditServiceParentCode.value){
                        maySubmit = false;
                        alertDialog("web","codeandparentmaynotbeidentical");
                        transactionForm.EditServiceCode.focus();
                    }
                }	
                
                if(maySubmit){
                  if(transactionForm.EditServiceCode.value.length>0){
                    var allLabelsHaveAValue = true;
                    var emptyLabelField = "";

                    <%
                        tokenizer = new StringTokenizer(supportedLanguages,",");
                        while(tokenizer.hasMoreTokens()){
                            tmpLang = tokenizer.nextToken();

                            %>
                                transactionForm.EditLabelValue<%=tmpLang%>.value = trim(transactionForm.EditLabelValue<%=tmpLang%>.value);

                                if(allLabelsHaveAValue){
                                  if(transactionForm.EditLabelValue<%=tmpLang%>.value.length==0){
                                    allLabelsHaveAValue = false;
                                    emptyLabelField = transactionForm.EditLabelValue<%=tmpLang%>;
                                  }
                                }
                            <%
                        }
                    %>

                    if(allLabelsHaveAValue){
                      transactionForm.saveButton.disabled = true;
                      transactionForm.Action.value = "save";
                      transactionForm.submit();
                    }
                    else{
                        alertDialog("web.manage","dataMissing");
                        emptyLabelField.focus();
                    }
                  }
                  else{
                    alertDialog("web.manage","dataMissing");
                    
                    if(transactionForm.EditServiceCode.value.length==0){
                      transactionForm.EditServiceCode.focus();
                    }
                    <%
                        tokenizer = new StringTokenizer(supportedLanguages,",");
                        while(tokenizer.hasMoreTokens()){
                            tmpLang = tokenizer.nextToken();

                            %>
                              else if(transactionForm.EditLabelValue<%=tmpLang%>.value.length==0){
                                transactionForm.EditLabelValue<%=tmpLang%>.focus();
                              }
                            <%
                        }
                    %>
                  }
                }
              }

              <%-- popup : search service stock --%>
              function searchServiceStock(serviceStockUidField,serviceStockNameField){
                openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField="+serviceStockUidField+"&ReturnServiceStockNameField="+serviceStockNameField);
              }

            </script>
        <%
    }
%>
</form>