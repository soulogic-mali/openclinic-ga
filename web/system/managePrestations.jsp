<%@page import="be.openclinic.system.*"%>
<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.manageprestations","all",activeUser)%>
<script src='<%=sCONTEXTPATH%>/_common/_script/prototype.js'></script>
<script src='<%=sCONTEXTPATH%>/_common/_script/stringFunctions.js'></script>
<%=sJSSORTTABLE%>
<%!
    private StringBuffer addCategoryLine(int iTotal,String sCategoryName,String sPrice,String sWebLanguage){
        StringBuffer sTmp = new StringBuffer();
        sTmp.append("<tr id='rowCategory"+iTotal+"'>")
             .append("<td class='admin2' width='40'>")
             .append("<a href='javascript:deleteCategory(rowCategory"+iTotal+")'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' alt='" + getTran(null,"Web.Occup","medwan.common.delete",sWebLanguage) + "' border='0'></a> ")
             .append("</td>")
             .append("<td class='admin2' width='25%'>&nbsp;" + getTranNoLink("insurance.types",sCategoryName,sWebLanguage) + "</td>")
             .append("<td class='admin2' width='25%'>&nbsp;" + sPrice + "</td>")
             .append("<td class='admin2'>")
             .append("</td>")
            .append("</tr>");

        return sTmp;
    }
%>
<%
    String sAction = checkString(request.getParameter("Action"));
	if(sAction.length()==0){
		sAction = checkString(request.getParameter("AutoAction"));
	}
    String sCurrency = MedwanQuery.getInstance().getConfigParam("currency","€");
    String msg = "";
    String sCategory = "";
    int iCategoryTotal = 0;

    String sFindPrestationUid   = checkString(request.getParameter("FindPrestationUid")),
           sFindPrestationCode  = checkString(request.getParameter("FindPrestationCode")),
           sFindPrestationDescr = checkString(request.getParameter("FindPrestationDescr")),
           sFindPrestationType  = checkString(request.getParameter("FindPrestationType")),
           sFindPrestationPrice = checkString(request.getParameter("FindPrestationPrice"));

    String sEditPrestationUid   = checkString(request.getParameter("EditPrestationUid")),
           sEditPrestationCode  = checkString(request.getParameter("EditPrestationCode")),
           sEditPrestationCodeAlias  = checkString(request.getParameter("EditPrestationCodeAlias")),
           sEditPrestationDescr = checkString(request.getParameter("EditPrestationDescr")),
           sEditPrestationType  = checkString(request.getParameter("EditPrestationType")),
           sEditPrestationUpdatetime  = checkString(request.getParameter("EditPrestationUpdatetime")),
           sEditPrestationCategories  = checkString(request.getParameter("EditPrestationCategories")),
           sEditPrestationFamily  = checkString(request.getParameter("EditPrestationFamily")),
           sEditPrestationInvoiceGroup  = checkString(request.getParameter("EditPrestationInvoiceGroup")),
           sEditPrestationATCCode  = checkString(request.getParameter("EditPrestationATCCode")),
           sEditPrestationTimeslot  = checkString(request.getParameter("EditPrestationTimeslot")),
           sEditPrestationCostcenter  = checkString(request.getParameter("EditPrestationCostcenter")),
           sEditPrestationMfpPercentage  = checkString(request.getParameter("EditPrestationMfpPercentage")),
           sEditPrestationMfpAdmissionPercentage  = checkString(request.getParameter("EditPrestationMfpAdmissionPercentage")),
           sEditPrestationAnesthesiaPercentage  = checkString(request.getParameter("EditPrestationAnesthesiaPercentage")),
           sEditPrestationHideFromDefaultList  = checkString(request.getParameter("EditPrestationHideFromDefaultList")),
           sEditPrestationAnesthesiaSupplementPercentage  = checkString(request.getParameter("EditPrestationAnesthesiaSupplementPercentage")),
           sEditPrestationSupplement  = checkString(request.getParameter("EditPrestationSupplement")),
           sEditPrestationClass  = checkString(request.getParameter("EditPrestationClass")),
           sEditPrestationVariablePrice = checkString(request.getParameter("EditPrestationVariablePrice")),
           sEditPrestationInactive  = checkString(request.getParameter("EditPrestationInactive")),
           sEditPrestationPrice = checkString(request.getParameter("EditPrestationPrice")),
           sEditPrestationFlag1 = checkString(request.getParameter("EditPrestationFlag1")),
           sEditPrestationServiceUid = checkString(request.getParameter("EditPrestationServiceUid")),
           sEditPrestationNomenclature = checkString(request.getParameter("EditPrestationNomenclature")),
           sEditPrestationDHIS2Code = checkString(request.getParameter("EditPrestationDHIS2Code")),
           sEditPrestationKeywords = checkString(request.getParameter("EditPrestationKeywords")),
           sEditPrestationProductionOrder = checkString(request.getParameter("EditPrestationProductionOrder")),
           sEditPrestationProductionOrderPaymentLevel = checkString(request.getParameter("EditPrestationProductionOrderPaymentLevel")),
           sEditPrestationProductionOrderPrescription = checkString(request.getParameter("EditPrestationProductionOrderPrescription")),
           sEditPrestationProductionOrderRawMaterials = checkString(request.getParameter("EditPrestationProductionOrderRawMaterials")),
		   sEditCareProvider = checkString(request.getParameter("EditCareProvider")),
		   sEditReservedForServiceType = checkString(request.getParameter("EditReservedForServiceType"));
		if(sEditPrestationVariablePrice.length()==0){
			sEditPrestationVariablePrice="0";
		}
		
	   try{
		   String s =""+Double.parseDouble(sEditPrestationTimeslot);
	   }
	   catch(Exception e){
		   sEditPrestationTimeslot="0";
	   }

	   try{
		   sEditPrestationPrice =""+Double.parseDouble(sEditPrestationPrice);
	   }
	   catch(Exception e){
		   sEditPrestationPrice="0";
	   }

	   try{
		   sEditPrestationProductionOrderPaymentLevel =""+Double.parseDouble(sEditPrestationProductionOrderPaymentLevel);
	   }
	   catch(Exception e){
		   sEditPrestationProductionOrderPaymentLevel="0";
	   }

	   try{
		   sEditPrestationProductionOrderPrescription =""+Double.parseDouble(sEditPrestationProductionOrderPrescription);
	   }
	   catch(Exception e){
		   sEditPrestationProductionOrderPrescription="0";
	   }

	   try{
		   sEditPrestationSupplement =""+Double.parseDouble(sEditPrestationSupplement);
	   }
	   catch(Exception e){
		   sEditPrestationSupplement="0";
	   }

	   if(!sEditPrestationInactive.equals("1")){
		   sEditPrestationInactive="0";
	   }
	   try{
		   sEditPrestationMfpPercentage =""+Integer.parseInt(sEditPrestationMfpPercentage);
	   }
	   catch(Exception e){
		   sEditPrestationMfpPercentage="0";
	   }
	   try{
		   sEditPrestationMfpAdmissionPercentage =""+Double.parseDouble(sEditPrestationMfpAdmissionPercentage);
	   }
	   catch(Exception e){
		   sEditPrestationMfpAdmissionPercentage="0";
	   }
	   try{
		   sEditPrestationAnesthesiaPercentage =""+Double.parseDouble(sEditPrestationAnesthesiaPercentage);
	   }
	   catch(Exception e){
		   sEditPrestationAnesthesiaPercentage="0";
	   }
	   try{
		   sEditPrestationHideFromDefaultList =""+Integer.parseInt(sEditPrestationHideFromDefaultList);
	   }
	   catch(Exception e){
		   sEditPrestationHideFromDefaultList="0";
	   }
	   try{
		   sEditPrestationAnesthesiaSupplementPercentage =""+Double.parseDouble(sEditPrestationAnesthesiaSupplementPercentage);
	   }
	   catch(Exception e){
		   sEditPrestationAnesthesiaSupplementPercentage="0";
	   }
	   String sEditPrestationServiceName="";
	   if(sEditPrestationServiceUid.length()>0){
		   Service service = Service.getService(sEditPrestationServiceUid);
		   if(service!=null){
			   sEditPrestationServiceName=service.getLabel(sWebLanguage);
		   }
	   }

    // DEBUG //////////////////////////////////////////////////////////////////
    Debug.println("\n### mngPrestations ############################");
    Debug.println("# sAction              : "+sAction);
    Debug.println("# sFindPrestationUid   : "+sFindPrestationUid);
    Debug.println("# sFindPrestationCode  : "+sFindPrestationCode);
    Debug.println("# sFindPrestationDescr : "+sFindPrestationDescr);
    Debug.println("# sFindPrestationType  : "+sFindPrestationType);
    Debug.println("# sFindPrestationPrice : "+sFindPrestationPrice+"\n");
    Debug.println("# sEditPrestationUid   : "+sEditPrestationUid);
    Debug.println("# sEditPrestationCode  : "+sEditPrestationCode);
    Debug.println("# sEditPrestationDescr : "+sEditPrestationDescr);
    Debug.println("# sEditPrestationType  : "+sEditPrestationType);
    Debug.println("# sEditPrestationCategories  : "+sEditPrestationCategories);
    Debug.println("# sEditPrestationFamily: "+sEditPrestationFamily);
    Debug.println("# sEditPrestationInvoiceGroup: "+sEditPrestationInvoiceGroup);
    Debug.println("# sEditPrestationCostcenter: "+sEditPrestationCostcenter);
    Debug.println("# sEditPrestationTimeslot: "+sEditPrestationTimeslot);
    Debug.println("# sEditPrestationPrice : "+sEditPrestationPrice+"\n");
    ///////////////////////////////////////////////////////////////////////////


    //--- SAVE ------------------------------------------------------------------------------------
    // delete all categories for the specified prestation,
    // then add all selected categories (those in request)
    if(sAction.equals("save")){
        Prestation prestation;

        if(sEditPrestationUid.equals("-1")){
            // new prestation
            prestation = new Prestation();
            prestation.setUpdateUser(activeUser.userid);
        }
        else{
            // existing prestation
            prestation = Prestation.get(sEditPrestationUid);
        }

        // store prestation
        prestation.setCode(sEditPrestationCode);
        prestation.setDescription(sEditPrestationDescr);
        prestation.setType(sEditPrestationType);
        prestation.setCategories(sEditPrestationCategories);
        prestation.setPrice(Double.parseDouble(sEditPrestationPrice));
        prestation.setReferenceObject(new ObjectReference(sEditPrestationFamily,sEditPrestationCodeAlias)); 
        prestation.setInvoiceGroup(sEditPrestationInvoiceGroup);
        prestation.setMfpPercentage(Integer.parseInt(sEditPrestationMfpPercentage));
        prestation.setMfpAdmissionPercentage(Double.parseDouble(sEditPrestationMfpAdmissionPercentage));
        prestation.setAnesthesiaPercentage(Double.parseDouble(sEditPrestationAnesthesiaPercentage));
        prestation.setHideFromDefaultList(Integer.parseInt(sEditPrestationHideFromDefaultList));
        prestation.setAnesthesiaSupplementPercentage(Double.parseDouble(sEditPrestationAnesthesiaSupplementPercentage));
        prestation.setSupplement(Double.parseDouble(sEditPrestationSupplement));
        prestation.setInactive(Integer.parseInt(sEditPrestationInactive));
        prestation.setPerformerUid(sEditCareProvider);
        prestation.setVariablePrice(Integer.parseInt(sEditPrestationVariablePrice));
        prestation.setPrestationClass(sEditPrestationClass);
        prestation.setServiceUid(sEditPrestationServiceUid);
        prestation.setATCCode(sEditPrestationATCCode);
        prestation.setNomenclature(sEditPrestationNomenclature);
        prestation.setCostCenter(sEditPrestationCostcenter);
        prestation.setDhis2code(sEditPrestationDHIS2Code);
        prestation.setKeywords(sEditPrestationKeywords);
        prestation.setProductionOrder(sEditPrestationProductionOrder);
        prestation.setProductionOrderPaymentLevel(new Double(Double.parseDouble(sEditPrestationProductionOrderPaymentLevel)).intValue());
        prestation.setProductionOrderPrescription(new Double(Double.parseDouble(sEditPrestationProductionOrderPrescription)).intValue());
        prestation.setProductionOrderRawMaterials(sEditPrestationProductionOrderRawMaterials);
        prestation.setFlag1(sEditPrestationFlag1);
        prestation.setReservedForServiceType(sEditReservedForServiceType);
        prestation.setTimeslot(sEditPrestationTimeslot);
        try{
        	prestation.setUpdateDateTime(ScreenHelper.parseDate(sEditPrestationUpdatetime));
        }
        catch(Exception e){}
        prestation.store();
        sEditPrestationUid = prestation.getUid();
        msg = getTran(request,"web","dataIsSaved",sWebLanguage);
        sAction = "search";
        if(checkString(request.getParameter("AutoAction")).length()>0){
        	out.println("<script>window.opener.location.reload();window.close();</script>");
        	out.flush();
        }
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete")){
        Prestation.delete(sEditPrestationUid);
        msg = getTran(request,"web","dataIsDeleted",sWebLanguage);
        sAction = "search";
    }

    // keydown
    String sOnKeyDown, sBackFunction;
    if(sAction.equals("edit") || sAction.equals("new")){
        sOnKeyDown = "";
        sBackFunction = "doBack();";
    }
    else{
        sOnKeyDown = "onkeydown='if(enterEvent(event,13)){searchPrestation();}'";
        sBackFunction = "doBackToMenu();";
    }
%>

<form id="transactionForm" name="transactionForm" onsubmit="return false;" method="post" <%=sOnKeyDown%>>
    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="FindPrestationUid">
    <input type="hidden" name="EditPrestationUid" value="<%=sEditPrestationUid%>">
    <input type="hidden" name="EditPrestationCategories">
    <%=writeTableHeader("Web.manage","ManagePrestations",sWebLanguage," doBackToMenu();")%>
    <%-- SEARCH FIELDS --%>
    <table width="100%" class="menu" cellspacing="0">
        <tr>
            <td width="<%=sTDAdminWidth%>"><%=getTran(request,"web","code",sWebLanguage)%></td>
            <td>
                <input type="text" class="text" name="FindPrestationCode" size="20" maxlength="50" value="<%=sFindPrestationCode%>">
            </td>
        </tr>
        <tr>
            <td><%=getTran(request,"web","description",sWebLanguage)%></td>
            <td>
                <input type="text" class="text" name="FindPrestationDescr" size="80" maxlength="80" value="<%=sFindPrestationDescr%>">
            </td>
        </tr>
        <tr>
            <td><%=getTran(request,"web","type",sWebLanguage)%></td>
            <td>
                <select class="text" name="FindPrestationType">
                    <option value=""></option>
                    <%=ScreenHelper.writeSelect(request,"prestation.type",sFindPrestationType,sWebLanguage)%>
                </select>
            </td>
        </tr>
        <tr>
            <td><%=getTran(request,"web","price",sWebLanguage)%></td>
            <td>
                <input type="text" class="text" name="FindPrestationPrice" size="10" maxlength="8" onKeyUp="if(!isNumber(this)){this.value='';}" value="<%=sFindPrestationPrice%>">&nbsp;<%=sCurrency%>
            </td>
        </tr>
        <tr>
            <td><%=getTran(request,"web","sort",sWebLanguage)%></td>
            <td>
                <select class="text" name="FindPrestationSort">
                    <option value="OC_PRESTATION_CODE"><%=getTran(request,"web","code",sWebLanguage)%></option>
                    <option value="OC_PRESTATION_DESCRIPTION"><%=getTran(request,"web","description",sWebLanguage)%></option>
                    <option value="OC_PRESTATION_PRICE"><%=getTran(request,"web","price",sWebLanguage)%></option>
                </select>
            </td>
        </tr>
       <tr>
           <td/>
           <td>
               <input type="button" class="button" name="editButton" value="<%=getTranNoLink("Web","Search",sWebLanguage)%>" onClick="transactionForm.Action.value='search';searchPrestation();">&nbsp;
               <input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","New",sWebLanguage)%>" onClick="newPrestation();">&nbsp;
               <input type="button" class="button" name="clearButton" value="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onClick="clearSearchFields();">&nbsp;
               <input type="button" class="button" name="backButton" value="<%=getTranNoLink("Web","Back",sWebLanguage)%>" onClick="<%=sBackFunction%>">
               <input type="button" class="button" name="test" value="+" onClick="document.getElementById('divFindRecords').style.height='350px';">
               <input type="button" class="button" name="test" value="-" onClick="document.getElementById('divFindRecords').style.height='150px';">
           </td>
       </tr>
    </table>
    <br>
	    <div style="height:150px;" class="searchResults" id="divFindRecords"></div>
    <%
        //--- SHOW ONE PRESTATION IN DETAIL ----------------------------------------------------------
        if(sAction.equals("edit") || sAction.equals("new")){
            Prestation prestation;
            String sCategoryHtml = "";

            // load specified prestation
            if(sAction.equals("edit")){
            	MedwanQuery.getInstance().getObjectCache().removeObject("prestation", sEditPrestationUid);
            	prestation = Prestation.get(sEditPrestationUid);
                if(prestation!=null){
                	sEditPrestationServiceUid=prestation.getServiceUid();
                	if(sEditPrestationServiceUid!=null && sEditPrestationServiceUid.length()>0){
                		Service service = Service.getService(sEditPrestationServiceUid);
                		if(service!=null){
                			sEditPrestationServiceName=service.getLabel(sWebLanguage);
                		}
                	}
                }
            }
            else{
                // ..or create a new one
                prestation = new Prestation();
            }
        	if(prestation.getUpdateDateTime()!=null){
        		sEditPrestationUpdatetime=ScreenHelper.stdDateFormat.format(prestation.getUpdateDateTime());
        	}
        	else {
        		sEditPrestationUpdatetime=ScreenHelper.stdDateFormat.format(new java.util.Date());
        	}

            if (checkString(prestation.getCategories()).length()>0){
                sCategory = checkString(prestation.getCategories());
                String[] aCategories = prestation.getCategories().split(";");
                String[] aCategory;

                for (int i=0;i<aCategories.length;i++){
                    aCategory = aCategories[i].split("=");
                    
                    if (aCategory.length==2){
                        sCategoryHtml += addCategoryLine(iCategoryTotal,aCategory[0],aCategory[1],sWebLanguage);
                        iCategoryTotal++;
                    }
                }
            }
            sTDAdminWidth="20%";

            %>
               <br>
                <%-- EDIT FIELDS ----------------------------------------------------------------%>
                <table width="100%" cellspacing="1" cellpadding="0" class="list">
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>">ID</td>
                        <td class="admin2"><%=checkString(prestation.getUid())%></td>
                    </tr>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","validfrom",sWebLanguage)%>&nbsp;*&nbsp;</td>
                        <td class="admin2">
                        	<%=writeDateField("EditPrestationUpdatetime","transactionForm",sEditPrestationUpdatetime,sWebLanguage)%>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","code",sWebLanguage)%>&nbsp;*&nbsp;</td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationCode" size="20" maxlength="50" value="<%=checkString(prestation.getCode())%>">
                        </td>
                    </tr>
                   	<% if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==1 || MedwanQuery.getInstance().getConfigInt("automatedDebet",0)==1){ %>
	                    <tr>
	                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","code.alias",sWebLanguage)%></td>
	                        <td class="admin2">
                            	<input type="text" class="text" name="EditPrestationCodeAlias" size="80" maxlength="250" value="<%=prestation.getReferenceObject()==null?"":checkString(prestation.getReferenceObject().getObjectUid())%>">
	                       </td>
	                   </tr>
                    <%} %>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","code.nomenclature",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationNomenclature" size="80" maxlength="250" value="<%=checkString(prestation.getNomenclature())%>">
                        </td>
                    </tr>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","keywords",sWebLanguage)%></td>
                        <td class="admin2">
                        	<select class="text" name="EditPrestationKeywords">
                        		<option value=''></option>
                        		<%=ScreenHelper.writeSelect(request,"prestation.keyword",checkString(prestation.getKeywords()),sWebLanguage,80) %>
                        	</select>
                        </td>
                    </tr>
                       	<%	if(MedwanQuery.getInstance().getConfigInt("enableDHIS2",0)==1){ %>
		                    <tr>
		                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","dhis2code",sWebLanguage)%></td>
		                        <td class="admin2">
		                        	<%	if(MedwanQuery.getInstance().getConfigInt("enableBurundi",0)==1){ %>
			                        	<select class="text" name="EditPrestationDHIS2Code">
			                        		<option value=''></option>
			                        		<%=ScreenHelper.writeSelect(request,"dhis2nomenclature",checkString(prestation.getDhis2code()),sWebLanguage,80) %>
			                        	</select>
			                        <%	}
		                        		else {
		                        	%>
		                            <input type="text" class="text" name="EditPrestationDHIS2Code" size="80" maxlength="250" value="<%=checkString(prestation.getDhis2code())%>">
		                            <%	} %>
		                        </td>
		                    </tr>
		                <%	} %>
                       	<%	if(MedwanQuery.getInstance().getConfigInt("enableProductionOrders",0)==1){ %>
                       		<tr>
                       			<td colspan='2' style='border:solid #000 1px;border-color: grey;'>
		                       		<table width='100%' cellspacing="1" cellpadding="0" class="list">
					                    <tr>
					                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","generateproductionitem",sWebLanguage)%></td>
					                        <td class="admin2">
					                            <input type="hidden" name="EditPrestationProductionOrder" value="<%=checkString(prestation.getProductionOrder())%>">
					                            <input type="text" size="80" class="text" name="EditPrestationProductOrderProductName" id="EditPrestationProductOrderProductName" value="<%=prestation.getProductionOrderProductName() %>"/>
					                            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditPrestationProductionOrder','EditPrestationProductOrderProductName');">
					                            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditPrestationProductionOrder.value='';transactionForm.EditPrestationProductOrderProductName.value='';">
					                        </td>
					                    </tr>
					                    <tr>
					                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderpaymentlevel",sWebLanguage)%></td>
					                        <td class="admin2">
					                            <input type="text" size="5" class="text" name="EditPrestationProductionOrderPaymentLevel" id="EditPrestationProductionOrderPaymentLevel" value="<%=prestation.getProductionOrderPaymentLevel() %>"/>%
					                        </td>
					                    </tr>
					                    <tr>
					                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderrawmaterials",sWebLanguage)%> <input type='button' class='button' name='addRawMaterial' onclick='addRawMaterials()' value='<%=getTran(request,"web","add",sWebLanguage)%>'/></td>
					                        <td class="admin2">
					                        	<div id='divRawMaterials'></div>
					                            <input type="hidden" name="EditPrestationProductionOrderRawMaterials" id="EditPrestationProductionOrderRawMaterials" value="<%=prestation.getProductionOrderRawMaterials() %>"/>
					                        </td>
					                    </tr>
					                    <tr>
					                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","productionorderprescription",sWebLanguage)%></td>
					                        <td class="admin2">
					                        	<select class='text' name='EditPrestationProductionOrderPrescription' id='EditPrestationProductionOrderPrescription'>
					                        		<option/>
					                        		<%
					                        			Vector vResults = Examination.searchAllExaminations();
					                        			SortedMap vExams = new TreeMap();
					                        			for(int n=0;n<vResults.size();n++){
					                        				Hashtable h = (Hashtable)vResults.elementAt(n);
					                        				vExams.put(getTran(request,"examination",(String)h.get("id"),sWebLanguage)+"."+h.get("id"),h.get("id"));
					                        			}
					                        			Iterator iExams = vExams.keySet().iterator();
					                        			while(iExams.hasNext()){
					                        				String id = (String)vExams.get((String)iExams.next());
					                        				out.println("<option value='"+id+"' "+(id.equalsIgnoreCase(""+prestation.getProductionOrderPrescription())?"selected":"")+">"+getTran(request,"examination",id,sWebLanguage)+"</option>");
					                        			}
					                        		%>
					                        	</select>
					                        </td>
					                    </tr>
					                </table>
					            </td>
					        </tr>
		                <%	} %>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%>&nbsp;*&nbsp;</td>
                        <td class="admin2">
                            <textarea  onKeyup="resizeTextarea(this,10);limitChars(this,255);" class="text" name="EditPrestationDescr" cols="80" rows="2" maxlength="255"><%=checkString(prestation.getDescription())%></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","type",sWebLanguage)%>&nbsp;*&nbsp;</td>
                        <td class="admin2">
                            <select class="text" name="EditPrestationType">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelect(request,"prestation.type",checkString(prestation.getType()),sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    <%
                        // prevent 0 from showing for new records
                        String sPrice = prestation.getPrice()+"";
                        if(sEditPrestationUid.equals("-1")){
                            double price = prestation.getPrice();
                            if(price==0) sPrice = "";
                        }
                    %>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","family",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationFamily" size="<%=MedwanQuery.getInstance().getConfigInt("maxprestationfamilysize",10) %>" maxlength="<%=MedwanQuery.getInstance().getConfigInt("maxprestationfamilysize",10)-2 %>" value="<%=prestation.getReferenceObject()==null?"":prestation.getReferenceObject().getObjectType()%>">
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","invoicegroup",sWebLanguage)%></td>
                        <td class="admin2">
                        	<%
                        		if(MedwanQuery.getInstance().getConfigInt("enableSAP",0)==1){
                        	%>
	                            <select class="text" name="EditPrestationInvoiceGroup">
	                                <%=ScreenHelper.writeSelect(request,"prestation.invoicegroup",checkString(prestation.getInvoicegroup()),sWebLanguage,false,true)%>
	                            </select>
                        	<%
                        		}
                        		else {
                        	%>
                            	<input type="text" class="text" name="EditPrestationInvoiceGroup" size="10" maxlength="50" value="<%=prestation.getInvoiceGroup()==null?"":prestation.getInvoiceGroup()%>">
                            <%
                        		}
                            %>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","atccode",sWebLanguage)%></td>
                        <td class="admin2">
                           	<input type="text" class="text" name="EditPrestationATCCode" size="10" maxlength="50" value="<%=prestation.getATCCode()%>">
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","timeslot",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="EditPrestationTimeslot">
                            	<option/>
                                <%=ScreenHelper.writeSelect(request,"timeslot",checkString(prestation.getTimeslot()),sWebLanguage,false,true)%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","costcenter",sWebLanguage)%></td>
                        <td class="admin2">
                            <select class="text" name="EditPrestationCostcenter">
                            	<option/>
                                <%=ScreenHelper.writeSelect(request,"costcenter",checkString(prestation.getCostCenter()),sWebLanguage,false,true)%>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","class",sWebLanguage)+(MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1?" *":"")%></td>
                        <td class="admin2">
                            <select class="text" name="EditPrestationClass">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelect(request,"prestation.class",checkString(prestation.getPrestationClass()),sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                    <%
                    	if(MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1){
                    %>
	                    <tr>
	                        <td class="admin"><%=getTran(request,"web","cnarclass",sWebLanguage)%> *</td>
	                        <td class="admin2">
	                            <select class="text" name="EditPrestationFlag1">
	                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
	                                <%=ScreenHelper.writeSelect(request,"prestation.cnarclass",prestation.getFlag1(),sWebLanguage)%>
	                            </select>
	                        </td>
	                    </tr>
	                <%
                    	}
	                %>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","defaultprice",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationPrice" size="10" maxlength="10" value="<%=sPrice%>" onKeyup="if(!isNumber(this)){this.value='';}">&nbsp;<%=sCurrency%>
							<%if(MedwanQuery.getInstance().getConfigInt("allowVariablePrestationPrices",0)==1){ %>
                            	&nbsp;<%=getTran(request,"web","variable",sWebLanguage)%> <input type="checkbox" value="1" name="EditPrestationVariablePrice" id="EditPrestationVariablePrice" <%=prestation!=null && prestation.getVariablePrice()==1?"checked":"" %>/>
                            <%} %>
                        </td>
                    </tr>
                    <%
                    	if(MedwanQuery.getInstance().getConfigInt("enableMFP",0)==1){
                    %>
	                    <tr>
	                        <td class="admin"><%=getTran(request,"web","mfppercentage",sWebLanguage)%></td>
	                        <td class="admin2">
	                            <input type="text" class="text" name="EditPrestationMfpPercentage" size="4" maxlength="6" value="<%=prestation.getMfpPercentage()%>" onKeyup="if(!isNumber(this)){this.value='';}">%
	                        </td>
	                    </tr>
                    <%
                    		if(MedwanQuery.getInstance().getConfigInt("enableMFPAdmission",0)==1){
                    %>
		                    <tr>
		                        <td class="admin"><%=getTran(request,"web","mfpadmissionpercentage",sWebLanguage)%></td>
		                        <td class="admin2">
		                            <input type="text" class="text" name="EditPrestationMfpAdmissionPercentage" size="4" maxlength="6" value="<%=prestation.getMfpAdmissionPercentage()%>" onKeyup="if(!isNumber(this)){this.value='';}">%
		                        </td>
		                    </tr>
                    <%
                    		}
                    	}
                    %>
                    <%
                    	if(MedwanQuery.getInstance().getConfigString("anesthesiaPrestationUid","").length()>0){
                    %>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","anesthesiapercentage",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationAnesthesiaPercentage" size="4" maxlength="6" value="<%=prestation.getAnesthesiaPercentage()%>" onKeyup="if(!isNumber(this)){this.value='';}">%
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","anesthesiasupplementpercentage",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationAnesthesiaSupplementPercentage" size="4" maxlength="6" value="<%=prestation.getAnesthesiaSupplementPercentage()%>" onKeyup="if(!isNumber(this)){this.value='';}">%
                        </td>
                    </tr>
                    <%
                    	}
                    %>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","supplement",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPrestationSupplement" size="10" maxlength="10" value="<%=prestation.getSupplement()%>" onKeyup="if(!isNumber(this)){this.value='';}">&nbsp;<%=sCurrency%>
                        </td>
                    </tr>
                    <tr>
			            <td class='admin'><%=getTran(request,"web","invoicingcareprovider",sWebLanguage)%></td>
			            <td class='admin2'>
			            	<select class='text' name='EditCareProvider' id='EditCareProvider'>
			            		<option value=''></option>
					            <%
					            	Vector users = UserParameter.getUserIdsExtended("invoicingcareprovider", "on");
					            	SortedSet usernames = new TreeSet();
					            	for(int n=0;n<users.size();n++){
					            		usernames.add(users.elementAt(n));
					            	}
					            	//Determine selected value
				            		String sSelectedValue=checkString(prestation.getPerformerUid());
					            	Iterator i = usernames.iterator();
					            	while(i.hasNext()){
					            		String u=(String)i.next();
					            		out.println("<option value='"+u.split(";")[2]+"'"+(sSelectedValue.equals(u.split(";")[2])?" selected":"")+">"+u.split(";")[0].toUpperCase()+", "+u.split(";")[1]+"</option>");
					            	}
					            %>
			            	</select>
			            </td>
			        </tr>
			       <tr id="Service">
			           <td class="admin"><%=getTran(request,"Web","linked.service",sWebLanguage)%></td>
			           <td class='admin2'>
			               <input type="hidden" name="EditPrestationServiceUid" id="EditPrestationServiceUid" value="<%=sEditPrestationServiceUid%>">
			               <input class="text" type="text" name="EditPrestationServiceName" id="EditPrestationServiceName" readonly size="<%=sTextWidth%>" value="<%=sEditPrestationServiceName%>" >
			               <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('EditPrestationServiceUid','EditPrestationServiceName');">
			               <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="document.getElementById('EditPrestationServiceUid').value='';document.getElementById('EditPrestationServiceName').value='';">
			           </td>
			       </tr>
                <tr>
                    <td class="admin"> <%=getTran(request,"Web","reservedforservicetype",sWebLanguage)%></td>
                    <td class="admin2">
		                <select class="text" name="EditReservedForServiceType" style="vertical-align:top;">
		                	<option/>
		                	<%=ScreenHelper.writeSelect(request,"servicetypes", prestation.getReservedForServiceType(), sWebLanguage) %>
		                </select>
                    </td>
                </tr>
                    
                    <tr>
                        <td class="admin"><%=getTran(request,"web","inactive",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" name="EditPrestationInactive" value="1" <%=prestation.getInactive()==1?"checked":"" %>/>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","hidefromdefaultlist",sWebLanguage)%></td>
                        <td class="admin2">
                            <input type="checkbox" name="EditPrestationHideFromDefaultList" <%=prestation.getHideFromDefaultList()==1?"checked":""%> value="1"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"><%=getTran(request,"web","categories",sWebLanguage)%></td>
                        <td class="admin2">
                            <%
                                prestation.getCategories();
                            %>
                            <table id="tblCategories" width="100%" cellspacing="1" cellpadding="0" class="list">
                                <%-- HEADER --%>
                                <tr class="admin">
                                    <td width="40"/>
                                    <td><%=getTran(request,"system.manage","category",sWebLanguage)%></td>
                                    <td><%=getTran(request,"web","price",sWebLanguage)%></td>
                                    <td/>
                                </tr>
                                <tr>
                                    <td class="admin"/>
                                    <td class="admin" width='25%'>
                                        <select name="EditCategoryName" class="text">
                                            <%=ScreenHelper.writeSelect(request,"insurance.types","",sWebLanguage)%>
                                        </select>
                                    </td>
                                    <td class="admin" width='25%'>
                                        <input type="text" class="text" name="EditCategoryPrice" size="10" onKeyUp="if(!isNumber(this))this.value = '';"> <%=sCurrency%>
                                    </td>
                                    <td class="admin">
                                        <input type="button" class="button" name="addCategoryButton" value="<%=getTranNoLink("web","add",sWebLanguage)%>" onClick="addCategory();">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                	<td class='admin2' colspan='4'>
                                		<table width='100%' id='categorytbl'>
                                          <%=sCategoryHtml%>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td class="admin"/>
                        <td class="admin2">
                            <button accesskey="<%=ScreenHelper.getAccessKey(getTranNoLink("accesskey","save",sWebLanguage))%>" class="buttoninvisible" onclick="savePrestation();"></button>
                            <button class="button" name="saveButton" onclick="savePrestation();"><%=getTranNoLink("accesskey","save",sWebLanguage)%></button>&nbsp;
                            <%
                                // no delete button for new prestation
                                if(!sEditPrestationUid.equals("-1")){
                                	boolean bExists=false;
                                	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
                                	PreparedStatement ps = conn.prepareStatement("select * from (select 1 as uid) a where exists (select * from oc_debets where oc_debet_prestationuid=? and 1=a.uid);");
                                	ps.setString(1,sEditPrestationUid);
                                	ResultSet rs = ps.executeQuery();
                                	bExists=rs.next() && rs.getInt("uid")==1;
                                	rs.close();
                                	ps.close();
                                	conn.close();
                                	if(!bExists){
	                                    %><input class="button" type="button" name="deleteButton" value="<%=getTranNoLink("Web","delete",sWebLanguage)%>" onclick="deletePrestation('<%=prestation.getUid()%>');">&nbsp;<%
                                	}
                                }
                            %>
                        </td>
                    </tr>
                </table>
                <br>
                <%
                // display message
                if(msg.length() > 0){
                    %><%=msg%><br><%
                }
        }
    %>
</form>
<script>
  var iCategoryIndex = <%=iCategoryTotal%>;
  var sCategory = "<%=sCategory%>";
  var editCategoryRowid = "";

  function newPrestation(){
    clearSearchFields();
    if(document.getElementById("EditPrestationVariablePrice")) document.getElementById("EditPrestationVariablePrice").checked=false;
    transactionForm.EditPrestationPrice="";
    transactionForm.EditPrestationUid.value = "-1";
    transactionForm.Action.value = "new";
    transactionForm.submit();
  }

  function editPrestation(sPrestationUid){
    transactionForm.EditPrestationUid.value = sPrestationUid;
    transactionForm.Action.value = "edit";
    transactionForm.submit();
  }

  function deletePrestation(sPrestationUid){
      if(yesnoDeleteDialog()){
      transactionForm.EditPrestationUid.value = sPrestationUid;
      transactionForm.Action.value = "delete";
      transactionForm.submit();
    }
  }
  function searchPrestation(){
    document.getElementById('divFindRecords').innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br/>Loading";
    var today = new Date();
    var desc=transactionForm.FindPrestationDescr.value;
    var params = 'FindPrestationCode=' + transactionForm.FindPrestationCode.value
          +"&FindPrestationDescr="+transactionForm.FindPrestationDescr.value
          +"&FindPrestationType="+transactionForm.FindPrestationType.value
          +"&FindPrestationSort="+transactionForm.FindPrestationSort.value
          +"&FindPrestationPrice="+transactionForm.FindPrestationPrice.value;
     var url= '<c:url value="/system/managePrestationsFind.jsp"/>?ts=' + today;
    new Ajax.Request(url,{
            method: "POST",
            parameters: params,
            onSuccess: function(resp){
                $('divFindRecords').innerHTML=resp.responseText;
            }
        }
    );  }

  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=system/managePrestations.jsp";
  }

  function doBackToMenu(){
    window.location.href = "<c:url value='/main.do'/>?Page=system/menu.jsp";
  }

  function clearSearchFields(){
    transactionForm.FindPrestationUid.value = "";
    transactionForm.FindPrestationCode.value = "";
    transactionForm.FindPrestationDescr.value = "";
    transactionForm.FindPrestationType.value = "";
    transactionForm.FindPrestationPrice.value = "";
  }

  function savePrestation(){
    if(transactionForm.EditPrestationCode.value.length > 0 && transactionForm.EditPrestationDescr.value.length > 0 &&
       transactionForm.EditPrestationType.value.length > 0 <%=MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1?"&& transactionForm.EditPrestationClass.value.length > 0 && transactionForm.EditPrestationFlag1.value.length > 0":""%>){
      if(transactionForm.EditPrestationUid.value.length==0){
          transactionForm.EditPrestationUid.value = "-1";
      }

      if (transactionForm.EditCategoryPrice.value.length>0){
          addCategory();
      }

      if (sCategory.length<3){
          sCategory = "";
      }

      transactionForm.EditPrestationCategories.value = sCategory;
      var temp = Form.findFirstElement(transactionForm);//for ff compatibility
      transactionForm.saveButton.style.visibility = "hidden";
      transactionForm.Action.value = "save";

      <%
          SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
          out.print(takeOverTransaction(sessionContainerWO, activeUser,"document.transactionForm.submit();"));
      %>
    }
    else{
      if(transactionForm.EditPrestationCode.value.length==0){
        transactionForm.EditPrestationCode.focus();
      }
      else if(transactionForm.EditPrestationDescr.value.length==0){
        transactionForm.EditPrestationDescr.focus();
      }
      else if(transactionForm.EditPrestationType.value.length==0){
        transactionForm.EditPrestationType.focus();
      }
      else if(transactionForm.EditPrestationPrice.value.length==0){
        transactionForm.EditPrestationPrice.focus();
      }
      <%
      	if(MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1){
      %>
	    else if(transactionForm.EditPrestationClass.value.length==0){
    	    transactionForm.EditPrestationClass.focus();
        }
	    else if(transactionForm.EditPrestationFlag1.value.length==0){
    	    transactionForm.EditPrestationFlag1.focus();
        }
      <%
      	}
      %>

      alertDialog("web.manage","dataMissing");
    }
  }

  function addCategory(){
    if(isAtLeastOneCategoryFieldFilled()){
      iCategoryIndex++;

      sCategory+=transactionForm.EditCategoryName.value+"="
                               +transactionForm.EditCategoryPrice.value+";";
      var tr;
      tr = tblCategories.insertRow(tblCategories.rows.length);
      tr.id = "rowCategory"+iCategoryIndex;

      var td = tr.insertCell(0);
      td.innerHTML = "<a href='javascript:deleteCategory(rowCategory"+iCategoryIndex+")'><img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' alt='<%=getTranNoLink("Web.Occup","medwan.common.delete",sWebLanguage)%>' border='0'></a>";
      tr.appendChild(td);

      td = tr.insertCell(1);
      td.innerHTML = "&nbsp;"+transactionForm.EditCategoryName.value;
      tr.appendChild(td);

      td = tr.insertCell(2);
      td.innerHTML = "&nbsp;"+transactionForm.EditCategoryPrice.value;
      tr.appendChild(td);

      td = tr.insertCell(3);
      td.innerHTML = "&nbsp;";
      tr.appendChild(td);

      setCellStyle(tr);

      clearCategoryFields();
    }
    return true;
  }

  function isAtLeastOneCategoryFieldFilled(){
    if(transactionForm.EditCategoryName.value != "") return true;
    if(transactionForm.EditCategoryPrice.value != "") return true;
    return false;
  }

  function clearCategoryFields(){
    transactionForm.EditCategoryName.selectedIndex = -1;
    transactionForm.EditCategoryPrice.value = "";
  }

  function deleteCategory(rowid){
      if(yesnoDeleteDialog()){
      	  sCategory = deleteRowFromArrayString(sCategory,rowid.rowIndex);
      	  document.getElementById('categorytbl').deleteRow(rowid.rowIndex);
      	  clearCategoryFields();
    	}
  }

  function deleteRowFromArrayString(sArray,rowid){
    var array = sArray.split(";");
    for(var i=0; i<array.length; i++){
      if(i==rowid){
        array.splice(i,1);
      }
    }
    var sTmp = array.join(";");

    if (!sTmp.endsWith(";")){
        sTmp += ";";
    }
    return sTmp;
  }

  function setCellStyle(row){
    for(var i=0; i<row.cells.length; i++){
      row.cells[i].style.color = "#333333";
      row.cells[i].style.fontFamily = "arial";
      row.cells[i].style.fontSize = "10px";
      row.cells[i].style.fontWeight = "normal";
      row.cells[i].style.textAlign = "left";
      row.cells[i].style.paddingLeft = "5px";
      row.cells[i].style.paddingRight = "1px";
      row.cells[i].style.paddingTop = "1px";
      row.cells[i].style.paddingBottom = "1px";
      row.cells[i].style.backgroundColor = "#E0EBF2";
    }
  }
  
  function searchService(serviceUidField,serviceNameField){
      openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
      document.getElementById(serviceNameField).focus();
  }

  function searchProductStock(productStockUidField,productStockNameField){
	    openPopup("/_common/search/searchProductStock.jsp&ts=<%=getTs()%>&PopupWidth=600&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField);
	  }

  <%
  if (sAction.length()>0){
    out.print("  searchPrestation();");
  }
  %>
	function addRawMaterials(){
	    openPopup("/_common/search/searchRawMaterial.jsp&ts=<%=getTs()%>&PopupWidth=600");
	}
	function addRawMaterialFunction(productstockid,quantity){
		//Add the product to the raw materials list
		if(document.getElementById("EditPrestationProductionOrderRawMaterials").value.length>0){
			document.getElementById("EditPrestationProductionOrderRawMaterials").value=document.getElementById("EditPrestationProductionOrderRawMaterials").value+",";
		}
		document.getElementById("EditPrestationProductionOrderRawMaterials").value=document.getElementById("EditPrestationProductionOrderRawMaterials").value+productstockid+":"+quantity;
		loadRawMaterialsFunction();
	}
	function deleteRawMaterial(id){
	    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
			document.getElementById("EditPrestationProductionOrderRawMaterials").value=document.getElementById("EditPrestationProductionOrderRawMaterials").value.replace(id,'');
			document.getElementById("EditPrestationProductionOrderRawMaterials").value=document.getElementById("EditPrestationProductionOrderRawMaterials").value.replace(',,',',');
			loadRawMaterialsFunction();
	    }
	}
	function loadRawMaterialsFunction(){
	    var params = "materials="+document.getElementById("EditPrestationProductionOrderRawMaterials").value;
      var url = '<c:url value="/pharmacy/loadRawMaterials.jsp"/>?ts='+new Date().getTime();
      new Ajax.Request(url,{
        method: "POST",
        parameters: params,
        onSuccess: function(resp){
          document.getElementById('divRawMaterials').innerHTML = resp.responseText;
        }
      });
	}

  window.setTimeout('loadRawMaterialsFunction();',500);
</script>
<%=writeJSButtons("transactionForm","saveButton")%>