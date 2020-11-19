<%@page import="be.openclinic.medical.Diagnosis"%>
<%@page import="java.text.SimpleDateFormat,
                be.openclinic.pharmacy.Product,
                be.openclinic.medical.Prescription,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.ServiceStock,
                be.openclinic.common.KeyValue,
                be.openclinic.pharmacy.PrescriptionSchema,
                be.openclinic.pharmacy.ProductSchema,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp" %>

<script>
  function reloadOpener(){
    if(isModified && window.opener.document.getElementById('patientmedicationsummary')!=undefined){
      window.opener.location.reload();
    }
  }
</script>

<body onbeforeunload="reloadOpener()">
	<script>var isModified = false;</script>
	<%=checkPermissionPopup(out,"prescriptions.drugs","select",activeUser)%>
	<%=sJSSORTTABLE%>
	<%=sJSDROPDOWNMENU%>

<%!
    //--- OBJECTS TO HTML -------------------------------------------------------------------------
    private StringBuffer objectsToHtml(Vector objects, String sWebLanguage, User activeUser, HttpServletRequest request){
	StringBuffer html = new StringBuffer();
        String sClass = "1", sDateBeginFormatted, sDateEndFormatted, sProductName = "", sProductUid,
               sPreviousProductUid = "", sTimeUnit, sTimeUnitCount, sUnitsPerTimeUnit, sPrescrRule = "",
               sProductUnit, timeUnitTran, sSupplyingServiceName, sSupplyingServiceUid,
               sServiceStockUid, sServiceStockName, sAuthorized;
        DecimalFormat unitCountDeci = new DecimalFormat("#.#");
        Product product = null;
        java.util.Date tmpDate;

        // frequently used translations
        String detailsTran = getTranNoLink("web","showdetails",sWebLanguage),
               deleteTran  = getTranNoLink("Web","delete",sWebLanguage);

        // run thru found prescriptions
        Hashtable productDeliveries = new Hashtable();
        Prescription prescr;
        for(int i=0; i<objects.size(); i++){
        	try{
            prescr = (Prescription) objects.get(i);
            // format date begin
            tmpDate = prescr.getBegin();
            if(tmpDate!=null) sDateBeginFormatted = ScreenHelper.formatDate(tmpDate);
            else sDateBeginFormatted = "";

            // format date end
            tmpDate = prescr.getEnd();
            if(tmpDate!=null) sDateEndFormatted = ScreenHelper.formatDate(tmpDate);
            else sDateEndFormatted = "";

            // only search product-name when different product-UID
            sProductUid = prescr.getProductUid();
            if(!sProductUid.equals(sPreviousProductUid)){
                sPreviousProductUid = sProductUid;
                product = Product.get(sProductUid);

                if(product!=null){
                    sProductName = product.getName();
                } 
                else{
                    sProductName = "<font color='red'>"+getTran(null,"web","nonexistingproduct",sWebLanguage)+"</font>";
                }
            }

            //*** compose prescriptionrule (gebruiksaanwijzing) ***
            // unit-stuff
            sTimeUnit = prescr.getTimeUnit();
            sTimeUnitCount = prescr.getTimeUnitCount()+"";
            sUnitsPerTimeUnit = prescr.getUnitsPerTimeUnit()+"";
            sAuthorized = checkString(prescr.getAuthorization());

            // only compose prescriptio-rule if all data is available
            if(!sTimeUnitCount.equals("0") && !sUnitsPerTimeUnit.equals("0") && product!=null){
                sPrescrRule = getTran(null,"web.prescriptions","prescriptionrule",sWebLanguage);
                sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#",unitCountDeci.format(Double.parseDouble(sUnitsPerTimeUnit)));

                // productunits
                if(Double.parseDouble(sUnitsPerTimeUnit)==1){
                    sProductUnit = getTran(null,"product.unit",product.getUnit(),sWebLanguage);
                }
                else{
                    sProductUnit = getTran(null,"product.unit",product.getUnit(),sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#productunit#",sProductUnit.toLowerCase());

                // timeunits
                if(Integer.parseInt(sTimeUnitCount)==1){
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#","");
                    timeUnitTran = getTran(null,"prescription.timeunit",sTimeUnit,sWebLanguage);
                }
                else{
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#",sTimeUnitCount);
                    timeUnitTran = getTran(null,"prescription.timeunits",sTimeUnit,sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#timeunit#",timeUnitTran.toLowerCase());
            }
            // supplying service name
            sSupplyingServiceUid = checkString(prescr.getSupplyingServiceUid());
            if(sSupplyingServiceUid.length() > 0){
                sSupplyingServiceName = getTran(null,"service",sSupplyingServiceUid,sWebLanguage);
            }
            else{
                sSupplyingServiceName = "";
            }

            // service stock name
            sServiceStockUid = prescr.getServiceStockUid();
            ServiceStock serviceStock = ServiceStock.get(sServiceStockUid);
            if(sServiceStockUid.length() > 0 && serviceStock!=null){
                sServiceStockName = serviceStock.getName();
            }
            else{
                sServiceStockName = "";
            }

            // alternate row-style
            if(sClass.equals("")) sClass = "1";
            else                  sClass = "";
            double deliveredQuantity=prescr.getDeliveredQuantity();
            Encounter activeEncounter= Encounter.getActiveEncounterOnDate(new java.sql.Timestamp(prescr.getBegin().getTime()), prescr.getPatientUid());
            boolean available = Product.isInStock(prescr.getProductUid(),prescr.getServiceStockUid());
            double openQuantity = prescr.getRequiredPackages() - deliveredQuantity;
            if(openQuantity<0 || (prescr.getEnd()!=null && prescr.getEnd().before(ScreenHelper.parseDate(ScreenHelper.formatDate(new java.util.Date()))))){
                openQuantity = 0;
            }
            deliveredQuantity-=prescr.getRequiredPackages();
            if(deliveredQuantity<0){
            	deliveredQuantity=0;
            }
			if(activeEncounter!=null){
	            productDeliveries.put(activeEncounter.getUid()+"."+prescr.getProductUid(),deliveredQuantity);
			}
			if(checkString(request.getParameter("showDiagnosis")).equalsIgnoreCase("1")){
				sAuthorized = "";
				if(checkString(prescr.getDiagnosisUid()).length()>0){
					Diagnosis diagnosis = Diagnosis.get(prescr.getDiagnosisUid());
					if(diagnosis!=null){
						sAuthorized=diagnosis.getCode()+" - "+diagnosis.getLabel(sWebLanguage);
					}
				}
			}
            //*** display prescription in one row ***
            html.append("<tr class='list"+sClass+"' onmouseover=\"this.style.cursor='pointer';\" onmouseout=\"this.style.cursor='default';\" title='"+detailsTran+"'>")
                 .append("<td>"+(((prescr==null || (prescr!=null && prescr.getDeliveredQuantity()==0))) && (activeUser.getAccessRight("prescriptions.drugs.delete"))?"<img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' border='0' title='"+deleteTran+"' onclick=\"doDelete('"+prescr.getUid()+"');\">":"")+"</td>")
                 .append("<td><input "+(openQuantity>0?"checked":"")+" type='checkbox' class='text' name='"+prescr.getProduct().getName()+"' id='cb_"+prescr.getUid()+"'/><span onclick=\"doShowDetails('"+prescr.getUid()+"');\"><b>"+sProductName.toUpperCase()+"</b></span></td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+sDateBeginFormatted+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+sDateEndFormatted+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+sAuthorized+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+User.getFullUserName(prescr.getPrescriberUid())+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+sPrescrRule.toLowerCase()+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\">"+(prescr.getRequiredPackages()-openQuantity)+"</td>")
                 .append("<td onclick=\"doShowDetails('"+prescr.getUid()+"');\" "+(openQuantity>0?" bgcolor='#ff9999'":"")+"><font style='color: black;'>"+openQuantity+"</font></a></td>")
                .append("</tr>");
        	}
        	catch(Exception a){
        		a.printStackTrace();
        		continue;
        	}

        }
		//Excess deliveries
		boolean bInit=false;
		Enumeration eDeliveries = productDeliveries.keys();
		while(eDeliveries.hasMoreElements()){
			String key = (String)eDeliveries.nextElement();
			double quantity = (Double)productDeliveries.get(key);
			if(quantity>0){
				if(!bInit){
		            html.append("<tr class='admin'>")
	                .append("<td colspan='9'>"+getTranNoLink("web","excessdelivery",sWebLanguage)+"</td>")
	               .append("</tr>");
		            bInit=true;
				}
	            if(sClass.equals("")) sClass = "1";
	            else                  sClass = "";
	            Encounter enc = Encounter.get(key.split("\\.")[0]+"."+key.split("\\.")[1]);
	            html.append("<tr class='list"+sClass+"'>")
                .append("<td/>")
                .append("<td><b>"+sProductName+"</b></td>")
                .append("<td colspan='4'>"+ScreenHelper.formatDate(enc.getBegin())+"</td>")
                .append("<td colspan='2'>"+getTranNoLink("web","encounter",sWebLanguage)+": "+key.split("\\.")[0]+"."+key.split("\\.")[1]+"</td>")
                .append("<td bgcolor='#ff9999'>"+quantity+"</td>")
               .append("</tr>");
			}
		}
        return html;
    }
%>

<%
    String sDefaultSortCol = "OC_PRESCR_BEGIN",
           sDefaultSortDir = "DESC";
    String sAction = checkString(request.getParameter("Action"));

    // retreive form data
    String sEditPrescrUid           = checkString(request.getParameter("EditPrescrUid")),
           sEditPrescriberUid       = checkString(request.getParameter("EditPrescriberUid")),
           sEditProductUid          = checkString(request.getParameter("EditProductUid")),
           sEditDateBegin           = checkString(request.getParameter("EditDateBegin")),
           sEditDateEnd             = checkString(request.getParameter("EditDateEnd")),
           sEditTimeUnit            = checkString(request.getParameter("EditTimeUnit")),
           sEditTimeUnitCount       = checkString(request.getParameter("EditTimeUnitCount")),
           sEditUnitsPerTimeUnit    = checkString(request.getParameter("EditUnitsPerTimeUnit")),
           sEditSupplyingServiceUid = checkString(request.getParameter("EditSupplyingServiceUid")),
           sEditServiceStockUid     = checkString(request.getParameter("EditServiceStockUid")),
           sEditAuthorization       = checkString(request.getParameter("EditAuthorization")),
           sEditDiagnosis       = checkString(request.getParameter("EditDiagnosis")),
           sDispensingStockUID  = checkString(request.getParameter("DispensingStockUID")),
           sEditRequiredPackages    = checkString(request.getParameter("EditRequiredPackages"));
    
    if(activePatient==null && sEditPrescrUid.length() > 0){
        activePatient = Prescription.get(sEditPrescrUid).getPatient();
    }
    if(sDispensingStockUID.length()>0){
    	session.setAttribute("activeDispensingStock", sDispensingStockUID);
    }

    double originalQuantity=0;

    String sTime1 = checkString(request.getParameter("time1")),
           sTime2 = checkString(request.getParameter("time2")),
           sTime3 = checkString(request.getParameter("time3")),
           sTime4 = checkString(request.getParameter("time4")),
           sTime5 = checkString(request.getParameter("time5")),
           sTime6 = checkString(request.getParameter("time6"));

    String sQuantity1 = checkString(request.getParameter("quantity1")),
           sQuantity2 = checkString(request.getParameter("quantity2")),
           sQuantity3 = checkString(request.getParameter("quantity3")),
           sQuantity4 = checkString(request.getParameter("quantity4")),
           sQuantity5 = checkString(request.getParameter("quantity5")),
           sQuantity6 = checkString(request.getParameter("quantity6"));

    PrescriptionSchema prescriptionSchema = new PrescriptionSchema();
    if(sTime1.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime1,sQuantity1));
    }
    if(sTime2.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime2,sQuantity2));
    }
    if(sTime3.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime3,sQuantity3));
    }
    if(sTime4.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime4,sQuantity4));
    }
    if(sTime5.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime5,sQuantity5));
    }
    if(sTime6.length() > 0){
        prescriptionSchema.getTimequantities().add(new KeyValue(sTime6,sQuantity6));
    }

    // afgeleide data
    String sEditPatientFullName      = checkString(request.getParameter("EditPatientFullName")),
           sEditPrescriberFullName   = checkString(request.getParameter("EditPrescriberFullName")),
           sEditProductName          = checkString(request.getParameter("EditProductName")),
           sEditSupplyingServiceName = checkString(request.getParameter("EditSupplyingServiceName"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n***************** medical/managePrescriptionsPopup.jsp *****************");
        Debug.println("sAction                   : "+sAction);
        Debug.println("sEditPrescrUid            : "+sEditPrescrUid);
        Debug.println("sEditPrescriberUid        : "+sEditPrescriberUid);
        Debug.println("sEditProductUid           : "+sEditProductUid);
        Debug.println("sEditDateBegin            : "+sEditDateBegin);
        Debug.println("sEditDateEnd              : "+sEditDateEnd);
        Debug.println("sEditTimeUnit             : "+sEditTimeUnit);
        Debug.println("sEditTimeUnitCount        : "+sEditTimeUnitCount);
        Debug.println("sEditUnitsPerTimeUnit     : "+sEditUnitsPerTimeUnit);
        Debug.println("sEditSupplyingServiceUid  : "+sEditSupplyingServiceUid);
        Debug.println("sEditServiceStockUid      : "+sEditServiceStockUid);
        Debug.println("sEditPatientFullName      : "+sEditPatientFullName);
        Debug.println("sEditPrescriberFullName   : "+sEditPrescriberFullName);
        Debug.println("sEditProductName          : "+sEditProductName);
        Debug.println("sEditSupplyingServiceName : "+sEditSupplyingServiceName);
        Debug.println("sEditAuthorization        : "+sEditAuthorization);
        Debug.println("sEditDiagnosis            : "+sEditDiagnosis);
        Debug.println("sEditRequiredPackages     : "+sEditRequiredPackages+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String msg = "", sSelectedPrescriberUid = "", sSelectedProductUid = "",
           sSelectedDateBegin = "", sSelectedDateEnd = "", sSelectedTimeUnit = "", sSelectedTimeUnitCount = "",
           sSelectedUnitsPerTimeUnit = "", sSelectedSupplyingServiceUid = "", sSelectedProductUnit = "",
           sSelectedPrescriberFullName = "", sSelectedProductName = "", sSelectedSupplyingServiceName = "",
           sSelectedServiceStockUid = "", sSelectedServiceStockName = "", sSelectedRequiredPackages = "",
           sSelectedAuthorization="",sSelectedDiagnosis="";

    // variables
    int foundPrescrCount;
    StringBuffer prescriptionsHtml;
    //boolean patientIsHospitalized = (activePatient!=null && activePatient.isHospitalized());
    boolean displayEditFields = false;

    //*********************************************************************************************
    //*** process actions *************************************************************************
    //*********************************************************************************************

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditPrescrUid.length() > 0){
        out.println("<script>isModified=true;</script>");
        
        // create prescription
        Prescription prescr = new Prescription();
        prescr.setUid(sEditPrescrUid);
        prescr.setPatientUid(activePatient.personid);
        prescr.setPrescriberUid(sEditPrescriberUid);
        prescr.setProductUid(sEditProductUid);
        prescr.setTimeUnit(sEditTimeUnit);
        prescr.setAuthorization(sEditAuthorization);
        prescr.setDiagnosisUid(sEditDiagnosis);
        
        if(sEditDateBegin.length() > 0) prescr.setBegin(ScreenHelper.parseDate(sEditDateBegin));
        if(sEditDateEnd.length() > 0) prescr.setEnd(ScreenHelper.parseDate(sEditDateEnd));
        if(sEditTimeUnitCount.length() > 0) prescr.setTimeUnitCount(Integer.parseInt(sEditTimeUnitCount));
        if(sEditUnitsPerTimeUnit.length() > 0) prescr.setUnitsPerTimeUnit(Double.parseDouble(sEditUnitsPerTimeUnit));
        if(sEditRequiredPackages.length() > 0) prescr.setRequiredPackages(Integer.parseInt(sEditRequiredPackages));
        prescr.setUpdateUser(activeUser.userid);

        // if no service stock (and so no supplying service) specified :
        Debug.println("*** activeUser.activeService.code                   = '"+activeUser.activeService.code+"'");/////////// todo
        Debug.println("*** activeUser.activeService.defaultServiceStockUid = '"+activeUser.activeService.defaultServiceStockUid+"'");/////////// todo

        if(sEditServiceStockUid.length()==0){
            if(activePatient.isHospitalized()){
                // * for hospitalized patient : active users' active services' default service stock
                sEditServiceStockUid = activeUser.activeService.defaultServiceStockUid;
                if(sEditServiceStockUid.length()==0){
                    sEditServiceStockUid = MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode");
                    Debug.println("*********** hospitalized, no def serv stock for serv --> centralPharmacyServiceStockCode");/////////////    todo
                } 
                else {
                    Debug.println("*********** hospitalized --> activeUser.activeService.defaultServiceStockUid");///////////// todo
                }
            } 
            else {
                // * for NON-hospitalized patient : service stock specified for centralPharmacy
                sEditServiceStockUid = MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode");
                Debug.println("*********** NOT hospitalized --> centralPharmacyServiceStockCode");/////////////    todo
            }
        }
        prescr.setServiceStockUid(sEditServiceStockUid);

        // supplying service uid
        if(sEditSupplyingServiceUid.length()==0){
            ServiceStock serviceStock = ServiceStock.get(sEditServiceStockUid);
            if(serviceStock!=null){
                sEditSupplyingServiceUid = serviceStock.getService().code;
            }
        }
        prescr.setSupplyingServiceUid(sEditSupplyingServiceUid);

        Debug.println("*********** SAVE PRESCRIPTION from popup : ");
        Debug.println("              sEditServiceStockUid     = "+sEditServiceStockUid);///////////// todo
        Debug.println("              sEditSupplyingServiceUid = "+sEditSupplyingServiceUid);///////////// todo

        String existingPrescrUid = prescr.exists();
        boolean prescrExists = existingPrescrUid.length() > 0;
        prescr.store(false);
        prescriptionSchema.setPrescriptionUid(prescr.getUid());
        prescriptionSchema.store();

        msg = "<font color='green'>"+getTran(request,"web","dataissaved",sWebLanguage)+"</font>";

        sEditPrescrUid = prescr.getUid();
    }
    //--- DELETE ----------------------------------------------------------------------------------
    else if(sAction.equals("delete") && sEditPrescrUid.length() > 0){
        Prescription.delete(sEditPrescrUid);
        PrescriptionSchema prescriptionSchemaToDelete = PrescriptionSchema.getPrescriptionSchema(sEditPrescrUid);
        prescriptionSchemaToDelete.delete();
        msg = getTran(request,"web","dataisdeleted",sWebLanguage);
        out.println("<script>isModified=true;</script>");
    }

    //--- SHOW DETAILS ----------------------------------------------------------------------------
    if(sAction.startsWith("showDetails")){
        displayEditFields = true;

        // get specified record
        if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
            Prescription prescr = Prescription.get(sEditPrescrUid);

            if(prescr!=null){
                if(prescr.getProduct()!=null){
                    sSelectedProductUid = prescr.getProductUid();
                }

                // format begin date
                java.util.Date tmpDate = prescr.getBegin();
                if(tmpDate!=null) sSelectedDateBegin = ScreenHelper.formatDate(tmpDate);

                // format end date
                tmpDate = prescr.getEnd();
                if(tmpDate!=null) sSelectedDateEnd = ScreenHelper.formatDate(tmpDate);

                sSelectedTimeUnit = checkString(prescr.getTimeUnit());
                sSelectedTimeUnitCount = prescr.getTimeUnitCount()+"";
                sSelectedUnitsPerTimeUnit = prescr.getUnitsPerTimeUnit()+"";
                sSelectedSupplyingServiceUid = checkString(prescr.getSupplyingServiceUid());
                sSelectedServiceStockUid = checkString(prescr.getServiceStockUid());
                sSelectedRequiredPackages = prescr.getRequiredPackages()+"";
                originalQuantity = prescr.getRequiredPackages();
                sSelectedPrescriberUid = prescr.getPrescriberUid();
                sSelectedAuthorization = checkString(prescr.getAuthorization());
                sSelectedDiagnosis = checkString(prescr.getDiagnosisUid());

                // afgeleide data
	          	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                sSelectedPrescriberFullName = ScreenHelper.getFullUserName(sSelectedPrescriberUid,ad_conn);
                ad_conn.close();
                
                // supplying service name
                if(sSelectedSupplyingServiceUid.length() > 0){
                    sSelectedSupplyingServiceName = getTranNoLink("Service",sSelectedSupplyingServiceUid,sWebLanguage);
                }

                // service stock name
                if(sSelectedServiceStockUid.length() > 0){
                    ServiceStock serviceStock = prescr.getServiceStock();
                    if(serviceStock!=null){
                        sSelectedServiceStockName = serviceStock.getName();
                    }
                }

                // product
                Product product = Product.get(sSelectedProductUid);
                if(product!=null){
                    sSelectedProductUnit = product.getUnit();
                    sSelectedProductName = product.getName();

                    if(sSelectedProductName.length()==0){
                        sSelectedProductName = "<font color='red'>"+getTran(request,"web","nonexistingproduct",sWebLanguage)+"</font>";
                    }
                }
            }

            prescriptionSchema = PrescriptionSchema.getPrescriptionSchema(prescr.getUid());
        } 
        else if(sAction.equals("showDetailsAfterAddReject")){
            // do not get data from DB, but show data that were allready on form
            sSelectedPrescriberUid = sEditPrescriberUid;
            sSelectedProductUid = sEditProductUid;
            sSelectedDateBegin = sEditDateBegin;
            sSelectedDateEnd = sEditDateEnd;
            sSelectedTimeUnit = sEditTimeUnit;
            sSelectedTimeUnitCount = sEditTimeUnitCount;
            sSelectedUnitsPerTimeUnit = sEditUnitsPerTimeUnit;
            sSelectedSupplyingServiceUid = sEditSupplyingServiceUid;
            sSelectedServiceStockUid = sEditServiceStockUid;
            sSelectedRequiredPackages = sEditRequiredPackages;
            try{
            	originalQuantity = Double.parseDouble(sEditRequiredPackages);
            }catch(Exception e){}
            sSelectedAuthorization = sEditAuthorization;
            sSelectedDiagnosis = sEditDiagnosis;

            // afgeleide data
            sSelectedPrescriberFullName = sEditPrescriberFullName;
            sSelectedProductName = sEditProductName;
            sSelectedProductUnit = "";
            sSelectedSupplyingServiceName = sEditSupplyingServiceName;
        } 
        else {
        	sEditPrescrUid="";
            // showDetailsNew : set default values
            sSelectedPrescriberUid = activeUser.userid;
            sSelectedPrescriberFullName = activeUser.person.lastname+" "+activeUser.person.firstname;
            sSelectedDateBegin = ScreenHelper.formatDate(new java.util.Date());
            sSelectedTimeUnit = "type2day";
            sSelectedTimeUnitCount = "1";
        }
    }

    // onclick : when editing, save, else search when pressing 'enter'
    String sOnKeyDown = "";
    if(sAction.startsWith("showDetails")){
        sOnKeyDown = "onKeyDown=\"if(enterEvent(event,13)){doSave();}\"";
    }
    
    // only editable by prescriber
    boolean editableByPrescriber = false;
    if(activeUser.isAdmin()){
    	editableByPrescriber = true; // always editable by administrator
    }
    else if(sEditPrescrUid.length() > 0){
    	if(sSelectedPrescriberUid.equals(activeUser.userid)){
    		editableByPrescriber = true;
    	}
    }
    Debug.println("--> editableByPrescriber : "+editableByPrescriber);  
    
    String sTitle = ("true".equalsIgnoreCase(request.getParameter("ServicePrescriptions"))?getTran(request,"Web.manage","ManageServicePrescriptions",sWebLanguage)+"&nbsp;"+activeUser.activeService.getLabel(sWebLanguage):getTran(request,"Web.manage","ManagePatientPrescriptions",sWebLanguage)+"&nbsp;"+activePatient.lastname+" "+activePatient.firstname);
    
    String sCloseAction = "closeWindow();";
    if(sAction.startsWith("showDetails")){
        sCloseAction = "doBack();";
    }
%>

<form name="transactionForm" id="transactionForm" method="post" action="<c:url value='/'/>/popup.jsp?Page=medical/managePrescriptionsPopup.jsp&PopupHeight=400&PopupWidth=900" <%=sOnKeyDown%> onClick='setSaveButton(event);clearMessage();' onKeyUp='setSaveButton(event);'>
    <%=writeTableHeaderDirectText(sTitle,sWebLanguage,sCloseAction)%>  
          
<%
    String onClick = "onclick=\"searchProduct('EditProductUid','EditProductName','ProductUnit','EditUnitsPerTimeUnit','UnitsPerPackage',null,'EditServiceStockUid','EditRequiredPackages');\"";
    if(!"true".equalsIgnoreCase(request.getParameter("ServicePrescriptions")) && activePatient==null){
        %><%=getTran(request,"web","firstselectaperson",sWebLanguage)%><%
    } 
    else{
    //*************************************************************************************
    //*** process display options *********************************************************
    //*************************************************************************************

    //--- EDIT FIELDS ---------------------------------------------------------------------
    if(displayEditFields){
        DecimalFormat doubleFormat = new DecimalFormat("#.#");
%>
<table class="list" width="100%" cellspacing="1">
<%-- product --%>
<tr>
    <td class="admin"><%=getTran(request,"Web","product",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <input type="hidden" name="EditProductUid" id="EditProductUid" value="<%=sSelectedProductUid%>">
        <input type="hidden" name="ProductUnit" value="<%=sSelectedProductUnit%>">
        <input class="text" type="text" name="EditProductName"  id="EditProductName"  size="<%=sTextWidth%>" value="<%=sSelectedProductName%>">
        <img id="findProduct" src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" <%=onClick%>>
        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditProductName.value='';transactionForm.EditProductUid.value='';">
        
		<div id="autocomplete_prescription" class="autocomple"></div>
    </td>
</tr>
<%-- ***** prescription-rule (dosage) ***** --%>
<tr>
    <td class="admin"><%=getTran(request,"Web","prescriptionrule",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <%-- Units Per Time Unit --%>
        <input type="text" class="text" style="vertical-align:-3px;" name="EditUnitsPerTimeUnit" id="EditUnitsPerTimeUnit" value="<%=(sSelectedUnitsPerTimeUnit.length()>0?(doubleFormat.format(Double.parseDouble(sSelectedUnitsPerTimeUnit))).replaceAll(",","."):"")%>" size="5" maxLength="5" onKeyUp="isNumber(this);calculatePackagesNeeded();">
        <span id="EditUnitsPerTimeUnitLabel"></span>

        <%-- Time Unit Count --%>
        &nbsp;<%=getTran(request,"web","per",sWebLanguage)%>
        <input type="text" class="text" style="vertical-align:-3px;" name="EditTimeUnitCount" id="EditTimeUnitCount" value="<%=sSelectedTimeUnitCount%>" size="5" maxLength="5" onKeyUp="calculatePackagesNeeded();">

        <%-- Time Unit (dropdown : Hour|Day|Week|Month) --%>
        <select class="text" name="EditTimeUnit" id="EditTimeUnit" onChange="setEditUnitsPerTimeUnitLabel();setEditTimeUnitCount();calculatePackagesNeeded();" style="vertical-align:-3px;">
            <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
            <%=ScreenHelper.writeSelectUnsorted(request,"prescription.timeunit",sSelectedTimeUnit,sWebLanguage)%>
        </select>

        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" style="vertical-align:-4px;" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="clearDescriptionRule();">
    </td>
</tr>

<%-- date begin --%>
<tr>
    <td class="admin"><%=getTran(request,"Web","begindate",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <input type="text" maxlength="10" class="text" id="EditDateBegin" name="EditDateBegin" value="<%=sSelectedDateBegin%>" size="12" onblur="if(!checkDate(this)){alertDialog('Web.Occup','date.error');this.value='';}else{calculatePackagesNeeded(false);}if(isEndDateBeforeBeginDate()){displayEndBeforeBeginAlert();}" onKeyUp="if(this.value.length==10){calculatePackagesNeeded(false);}else{transactionForm.EditRequiredPackages.value='';}">
        <img name="popcal" class="link" src="<%=sCONTEXTPATH%>/_img/icons/icon_agenda.png" alt="<%=getTranNoLink("Web","Select",sWebLanguage)%>" onclick="gfPop1.fPopCalendar(document.getElementById('EditDateBegin'));return false;">
        <img class="link" src="<%=sCONTEXTPATH%>/_img/icons/icon_compose.png" alt="<%=getTranNoLink("Web","PutToday",sWebLanguage)%>" onclick="getToday(document.getElementById('EditDateBegin'));calculatePackagesNeeded(false);">
        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditDateBegin.value='';">
    </td>
</tr>

<%-- date end --%>
<tr>
    <td class="admin"><%=getTran(request,"Web","enddate",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <input type="text" maxlength="10" class="text" id="EditDateEnd" name="EditDateEnd" value="<%=sSelectedDateEnd%>" size="12" onblur="if(!checkDate(this)){alertDialog('Web.Occup','date.error');this.value='';}else{calculatePackagesNeeded(false);}if(isEndDateBeforeBeginDate()){displayEndBeforeBeginAlert();}" onKeyUp="if(this.value.length==10){calculateNumberOfDays();calculatePackagesNeeded(false);}else{transactionForm.numberofdays.value='';transactionForm.EditRequiredPackages.value='';}">
        <img name="popcal" class="link" src="<%=sCONTEXTPATH%>/_img/icons/icon_agenda.png" alt="<%=getTranNoLink("Web","Select",sWebLanguage)%>" onclick="gfPop1.fPopCalendar(document.getElementById('EditDateEnd'));return false;">
        <img class="link" src="<%=sCONTEXTPATH%>/_img/icons/icon_compose.png" alt="<%=getTranNoLink("Web","PutToday",sWebLanguage)%>" onclick="getToday(document.getElementById('EditDateEnd'));calculatePackagesNeeded(false);">
        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditDateEnd.value='';">
		&nbsp;=&nbsp;
		<input style="text-align: center" type="text" maxlength="3" size="2" class="text" id="numberofdays" name="numberofdays" onkeyup="calculateEndDate()"/> <%=getTran(request,"web","days",sWebLanguage) %>
    </td>
</tr>

<%-- number of packages needed for this prescription --%>
<%
    // units per package
    String sUnitsPerPackage = "";
    Prescription prescr = null;
    if(sEditPrescrUid.length() > 0 && !sEditPrescrUid.equals("-1")){
        prescr = Prescription.get(sEditPrescrUid);
        if(prescr!=null && prescr.getProduct()!=null){
            sUnitsPerPackage = prescr.getProduct().getPackageUnits()+"";
            if(prescriptionSchema.getTimequantities().size()==0){
                prescriptionSchema.setTimequantities(ProductSchema.getSingleProductSchema(prescr.getProduct().getUid()).getTimequantities());
            }
        }
    }

%>
<tr>
    <td class="admin"><%=getTran(request,"Web","packages",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <input class="text" type="text" name="EditRequiredPackages" id="EditRequiredPackages" size="5" maxLength="5" value="<%=sSelectedRequiredPackages%>" onKeyUp="if(isInteger(this)){calculatePrescriptionPeriod();}">
        &nbsp;(<input type="text" class="text" name="UnitsPerPackage" id="UnitsPerPackage" value="<%=sUnitsPerPackage%>" size="3" readonly style="border:none;background:transparent;text-align:right;">&nbsp;<%=getTran(request,"web","packageunits",sWebLanguage).toLowerCase()%>)
    </td>
</tr>

<%-- prescriber --%>
<tr>
    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","prescriber",sWebLanguage)%>&nbsp;*&nbsp;</td>
    <td class="admin2">
        <input type="hidden" name="EditPrescriberUid" id="EditPrescriberUid" value="<%=sSelectedPrescriberUid%>">
        <input class="text" type="text" name="EditPrescriberFullName" id="EditPrescriberFullName" readonly size="<%=sTextWidth%>" value="<%=sSelectedPrescriberFullName%>">
        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchPrescriber('EditPrescriberUid','EditPrescriberFullName');">
        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditPrescriberUid.value='';transactionForm.EditPrescriberFullName.value='';">
    </td>
</tr>

<%-- Service Stock --%>
<tr>
    <td class="admin"><%=getTran(request,"Web","servicestock",sWebLanguage)%>&nbsp;</td>
    <td class="admin2">
        <input type="hidden" name="EditServiceStockUid" value="<%=sSelectedServiceStockUid%>">
        <input class="text" type="text" name="EditServiceStockName" readonly size="<%=sTextWidth%>" value="<%=sSelectedServiceStockName%>">

        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchServiceStock('EditServiceStockUid','EditServiceStockName');">
        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditServiceStockUid.value='';transactionForm.EditServiceStockName.value='';transactionForm.EditSupplyingServiceUid.value='';transactionForm.EditSupplyingServiceName.value='';">
    </td>
</tr>

<%-- Supplying Service --%>
<tr>
    <td class="admin" nowrap><%=getTran(request,"Web","supplyingservice",sWebLanguage)%>&nbsp;</td>
    <td class="admin2">
        <input type="hidden" name="EditSupplyingServiceUid" value="<%=sSelectedSupplyingServiceUid%>">
        <input class="text" type="text" name="EditSupplyingServiceName" readonly size="<%=sTextWidth%>" value="<%=sSelectedSupplyingServiceName%>">
    </td>
</tr>

<%-- Authorized receiver --%>
<tr>
    <td class="admin" nowrap><%=getTran(request,"Web","authorizedreceiver",sWebLanguage)%>&nbsp;</td>
    <td class="admin2">
        <input class="text" type="text" name="EditAuthorization" size="<%=sTextWidth%>" value="<%=sSelectedAuthorization%>">
    </td>
</tr>

<%-- Diagnosis --%>
<tr>
    <td class="admin" nowrap><%=getTran(request,"Web","indication",sWebLanguage)%>&nbsp;</td>
    <td class="admin2">
    	<select class='text' name='EditDiagnosis' id='EditDiagnosis'>
    		<option/>
    		<%
    			Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
    			if(encounter!=null && encounter.hasValidUid()){
    				Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "OC_DIAGNOSIS_GRAVITY DESC");
    				for(int n=0;n<diagnoses.size();n++){
    					Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
    					out.println("<option "+(diagnosis.getUid().equalsIgnoreCase(sSelectedDiagnosis)?"selected":"")+" value='"+diagnosis.getUid()+"'>"+diagnosis.getCode()+" - "+diagnosis.getLabel(sWebLanguage)+"</option>");
    				}
    			}
    		%>
    	</select>
    </td>
</tr>

<%-- schema --%>
<tr>
    <td class="admin" nowrap><%=getTran(request,"Web","schema",sWebLanguage)%>&nbsp;</td>
    <td class="admin2">
        <table>
            <tr>
                <td><input class="text" type="text" name="time1" value="<%=prescriptionSchema.getTimeQuantity(0).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td><input class="text" type="text" name="time2" value="<%=prescriptionSchema.getTimeQuantity(1).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td><input class="text" type="text" name="time3" value="<%=prescriptionSchema.getTimeQuantity(2).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td><input class="text" type="text" name="time4" value="<%=prescriptionSchema.getTimeQuantity(3).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td><input class="text" type="text" name="time5" value="<%=prescriptionSchema.getTimeQuantity(4).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td><input class="text" type="text" name="time6" value="<%=prescriptionSchema.getTimeQuantity(5).getKey()%>" size="2"><%=getTran(request,"web","abbreviation.hour",sWebLanguage)%></td>
                <td>&nbsp;&nbsp;<img class="link" src="<c:url value="/_img/icons/icon_search.png"/>" alt="<%=getTranNoLink("web","loadSchedule",sWebLanguage)%>" onClick="javascript:loadSchema();"/></a></td>
            </tr>
            <tr>
                <td><input class="text" type="text" name="quantity1" value="<%=(prescriptionSchema.getTimeQuantity(0).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(0).getValue())%>" size="2">#</td>
                <td><input class="text" type="text" name="quantity2" value="<%=(prescriptionSchema.getTimeQuantity(1).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(1).getValue())%>" size="2">#</td>
                <td><input class="text" type="text" name="quantity3" value="<%=(prescriptionSchema.getTimeQuantity(2).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(2).getValue())%>" size="2">#</td>
                <td><input class="text" type="text" name="quantity4" value="<%=(prescriptionSchema.getTimeQuantity(3).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(3).getValue())%>" size="2">#</td>
                <td><input class="text" type="text" name="quantity5" value="<%=(prescriptionSchema.getTimeQuantity(4).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(4).getValue())%>" size="2">#</td>
                <td><input class="text" type="text" name="quantity6" value="<%=(prescriptionSchema.getTimeQuantity(5).getValue().equals("-1")?"":prescriptionSchema.getTimeQuantity(5).getValue())%>" size="2">#</td>
                <td/>
            </tr>
        </table>
    </td>
</tr>
</table>

<%-- indication of obligated fields --%>
<%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>

<%-- display message --%>
<br><span id="msgArea">&nbsp;<%=msg%></span><span id='productmsg'></span>


<%-- EDIT BUTTONS --%>
<%=ScreenHelper.alignButtonsStart()%>
<%
    if(sAction.equals("showDetails") || sAction.equals("showDetailsAfterUpdateReject")){
	    if(editableByPrescriber){
	        // existing prescription : display saveButton with save-label
	        if(prescr==null || (activeUser.getAccessRight("prescriptions.drugs.add") || activeUser.getAccessRight("prescriptions.drugs.edit"))){
	            %><input class="button" type="button" name="saveButton" id="saveButton" value='<%=getTranNoLink("Web","save",sWebLanguage)%>' onclick="doSave();">&nbsp;<%
	        }
	        if((prescr==null || (prescr!=null && prescr.getDeliveredQuantity()==0)) && activeUser.getAccessRight("prescriptions.drugs.delete")){
				%><input class="button" type="button" name="deleteButton" value='<%=getTranNoLink("Web","delete",sWebLanguage)%>' onclick="doDelete('<%=sEditPrescrUid%>');">&nbsp;<%
	    	}
        }
        else{
        	%><font color="red"><%=getTran(request,"web.occup","onlyEditableByPrescriber",sWebLanguage)%><br></font><%
        }
	    
		%><input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","backtooverview",sWebLanguage)%>' onclick="doBack();"><%
	}
    else if(sAction.equals("showDetailsNew") || sAction.equals("showDetailsAfterAddReject")){
	    // new prescription : display saveButton with add-label+do not display delete button
	    if(activeUser.getAccessRight("prescriptions.drugs.add") || activeUser.getAccessRight("prescriptions.drugs.edit")){
			%><input class="button" type="button" name="saveButton" value='<%=getTranNoLink("Web","add",sWebLanguage)%>' onclick="doAdd();">&nbsp;<%
    	}
	    
		%><input class="button" type="button" name="returnButton" value='<%=getTranNoLink("Web","back",sWebLanguage)%>' onclick="doBack();"><%
    }

%>
<%=ScreenHelper.alignButtonsStop()%>

<script>
<%-- RELOAD OPENER --%>
function reloadOpener(){
  if(isModified && window.opener.document.getElementById('patientmedicationsummary')!=undefined){
    window.opener.location.reload();
  }
}

setEditUnitsPerTimeUnitLabel();

<%-- CALCULATE PRESCRIPTION PERIOD --%>
function calculatePrescriptionPeriod(){
  var packages = transactionForm.EditRequiredPackages.value;
  var beginDateStr = transactionForm.EditDateBegin.value,
      endDateStr   = transactionForm.EditDateEnd.value;

  if(packages.length > 0){
    var unitsPerPackage = transactionForm.UnitsPerPackage.value;
    var unitsPerTimeUnit = transactionForm.EditUnitsPerTimeUnit.value;
    var timeUnitCount = transactionForm.EditTimeUnitCount.value;
    var timeUnit = transactionForm.EditTimeUnit.value;

    if(unitsPerPackage.length > 0 && unitsPerTimeUnit.length > 0 && timeUnitCount.length > 0 && timeUnit.length > 0){
      var totalUnits = packages * unitsPerPackage;

      var millisInTimeUnit;
      if(timeUnit=="type1hour"){
        millisInTimeUnit = 3600 * 1000;
      }
      else if(timeUnit=="type2day"){
        millisInTimeUnit = 24 * 3600 * 1000;
      }
      else if(timeUnit=="type3week"){
        millisInTimeUnit = 7 * 24 * 3600 * 1000;
      }
      else if(timeUnit=="type4month"){
        millisInTimeUnit = 31 * 24 * 3600 * 1000;
      }

      var unitsPerMilli = unitsPerTimeUnit / millisInTimeUnit / timeUnitCount;
      var periodInMillis = totalUnits / unitsPerMilli;
      var millisPerDay = 24 * 60 * 60 * 1000;
      var periodInDays = Math.floor(periodInMillis / millisPerDay - 1);

      <%-- calculate beginDate : subtract days from endDate --%>
      if(beginDateStr.length==0){
        var beginDateInMillis = makeDate(endDateStr).getTime() - (periodInDays * (24 * 3600 * 1000));
        var beginDate = new Date();
        beginDate.setTime(beginDateInMillis);

        var day = beginDate.getDate();
        if(day < 10) day = "0"+day;

        var month = beginDate.getMonth()+1;
        if(month < 10) month = "0"+month;

        if(dateFormat=="dd/MM/yyyy"){
          transactionForm.EditDateBegin.value = day+"/"+month+"/"+beginDate.getFullYear();
        }
        else{
          transactionForm.EditDateBegin.value = month+"/"+day+"/"+beginDate.getFullYear();
        }
      }
      <%-- calculate endDate : add days to beginDate --%>
      else{
        var beginDate = makeDate(beginDateStr);
        var endDateInMillis = makeDate(beginDateStr).getTime()+(periodInDays * (24 * 3600 * 1000));
        var endDate = new Date();
        endDate.setTime(endDateInMillis);
        if(endDate.getTime() < beginDate.getTime()){
          endDate = beginDate;
        }
        var day = endDate.getDate();
        if(day < 10) day = "0"+day;
        
        var month = endDate.getMonth()+1;
        if(month < 10) month = "0"+month;

        if(dateFormat=="dd/MM/yyyy"){
          transactionForm.EditDateEnd.value = day+"/"+month+"/"+endDate.getFullYear();
        }
        else{
          transactionForm.EditDateEnd.value = month+"/"+day+"/"+endDate.getFullYear();
        }
      }
    }
  }
  calculateNumberOfDays();
}

function calculateNumberOfDays(){
	transactionForm.numberofdays.value='';
    var millisPerDay = 24 * 3600 * 1000;
    var beginDate = makeDate(transactionForm.EditDateBegin.value);
    var endDate = makeDate(transactionForm.EditDateEnd.value);
    transactionForm.numberofdays.value=Math.ceil(1+((endDate.getTime()-beginDate.getTime())/millisPerDay));
}

function calculateEndDate(){
	if(transactionForm.numberofdays.value*1>0){
	    var millisPerDay = 24 * 3600 * 1000;
	    var beginDate = makeDate(transactionForm.EditDateBegin.value);
	    var beginDateMillis=beginDate.getTime();
	    var endDate = new Date();
	    endDate.setTime(beginDateMillis+((transactionForm.numberofdays.value-1)*millisPerDay));
	    if(endDate.getTime() < beginDate.getTime()){
	        endDate = beginDate;
	    }
	    var day = endDate.getDate();
	    if(day < 10) day = "0"+day;
	    
	    var month = endDate.getMonth()+1;
	    if(month < 10) month = "0"+month;
	
	    if("<%=MedwanQuery.getInstance().getConfigString("euDateFormat","dd/MM/yyyy")%>"=="dd/MM/yyyy"){
	      transactionForm.EditDateEnd.value = day+"/"+month+"/"+endDate.getFullYear();
	    }
	    else{
	      transactionForm.EditDateEnd.value = month+"/"+day+"/"+endDate.getFullYear();
	    }
	    calculatePackagesNeeded();
	}
}
</script>
<script>

<%-- CALCULATE PACKAGES NEEDED --%>
function calculatePackagesNeeded(displayAlert){
	if(transactionForm.UnitsPerPackage.value.length > 0 && transactionForm.UnitsPerPackage.value!="0"){
    var dateBegin = transactionForm.EditDateBegin.value,
        dateEnd   = transactionForm.EditDateEnd.value;
    if(dateBegin.length > 0 && dateEnd.length > 0){
      if(!isEndDateBeforeBeginDate()){
        var unitsPerPackage = transactionForm.UnitsPerPackage.value;
        var unitsPerTimeUnit = transactionForm.EditUnitsPerTimeUnit.value;
        var timeUnitCount = transactionForm.EditTimeUnitCount.value;
        var timeUnit = transactionForm.EditTimeUnit.value;

        if(unitsPerPackage.length > 0 && unitsPerTimeUnit.length > 0 && timeUnitCount.length > 0 && timeUnit.length > 0){
          var beginDate = transactionForm.EditDateBegin.value;
          var endDate = transactionForm.EditDateEnd.value;
          var periodInMillis = makeDate(endDate).getTime()+24 * 3600 * 1000 - makeDate(beginDate).getTime();

          var millisInTimeUnit;
          if(timeUnit=="type1hour"){
            millisInTimeUnit = 3600 * 1000;
          }
          else if(timeUnit=="type2day"){
            millisInTimeUnit = 24 * 3600 * 1000;
          }
          else if(timeUnit=="type3week"){
            millisInTimeUnit = 7 * 24 * 3600 * 1000;
          }
          else if(timeUnit=="type4month"){
            millisInTimeUnit = 31 * 24 * 3600 * 1000;
          }

          var unitsPerMilli = unitsPerTimeUnit / millisInTimeUnit / timeUnitCount;
          var daysInPeriod = periodInMillis / (24 * 3600 * 1000);
          var unitsNeeded = periodInMillis * unitsPerMilli;
          var packagesNeeded = Math.ceil(unitsNeeded / unitsPerPackage);

          transactionForm.EditRequiredPackages.value = packagesNeeded;
        }
        else{
          transactionForm.EditRequiredPackages.value = "";
        }
      }
      else {
        if(displayAlert==undefined){
          displayAlert = true;
        }

        if(displayAlert==true){
          alertDialog("web.Occup","endMustComeAfterBegin");
          transactionForm.EditDateEnd.focus();
        }

        transactionForm.EditRequiredPackages.value = "";
      }
    }
  }
  calculateNumberOfDays();
}
</script>
<script>
<%-- DISPLAY "END BEFORE BEGIN" ALERT --%>
function displayEndBeforeBeginAlert(){
  if(transactionForm.EditDateEnd.value.length > 0){
	alertDialog("web.Occup","endMustComeAfterBegin");
  }
}

<%-- set editUnitsPerTimeUnitLabel --%>
function setEditUnitsPerTimeUnitLabel(productUid){
  var unitTran = "";

  if(transactionForm.EditProductUid.value.length==0){
    unitTran = '<%=getTranNoLink("web","units",sWebLanguage)%>';
  }
  else{
    <%
        Vector unitTypes = ScreenHelper.getProductUnitTypes(sWebLanguage);

        for(int i=0; i<unitTypes.size(); i++){
		    %>
		        var unitTran<%=(i+1)%> = "<%=getTranNoLink("product.unit",(String)unitTypes.get(i),sWebLanguage).toLowerCase()%>";
		        if(transactionForm.ProductUnit.value=="<%=unitTypes.get(i)%>") unitTran = unitTran<%=(i+1)%>;
		    <%
        }
    %>
  }

  if(unitTran.length==0){
    openEditProductUnitPopup(productUid);
  }
  else{
    document.getElementById("EditUnitsPerTimeUnitLabel").innerHTML = unitTran;
  }
}

<%-- open edit product unit popup --%>
function openEditProductUnitPopup(productUid){
  var url = "pharmacy/popups/editProductUnit.jsp"+
            "&EditProductUid="+productUid+
            "&ts="+new Date().getTime();
  openPopup(url);
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
}

<%-- IS VALID DATE --%>
function isValidDate(dateObj){
  if(dateObj.value.length==10){
    return checkDate(dateObj);
  }
  return false;
}

<%-- IS ENDDATE BEFORE BEGINDATE --%>
function isEndDateBeforeBeginDate(){
  if(transactionForm.EditDateBegin.value.length > 0 && transactionForm.EditDateEnd.value.length > 0){
    if(isValidDate(transactionForm.EditDateBegin) && isValidDate(transactionForm.EditDateEnd)){
      var dateBegin = transactionForm.EditDateBegin.value,
          dateEnd   = transactionForm.EditDateEnd.value;
      return before(dateEnd,dateBegin);
    }
    return false;
  }
  return true;
}
</script>
<%
    }
    //--- DISPLAY ACTIVE PRESCRIPTIONS (for activePatient) --------------------------------
    if(!sAction.startsWith("showDetails")){
        if("true".equalsIgnoreCase(request.getParameter("ServicePrescriptions"))){
%>
<table width="100%" cellspacing="0" cellpadding="0" class="list">
    <tbody class="hand">
        <%
            foundPrescrCount = 0;
            Vector services = Service.getChildIds(activeUser.activeService.code);
            services.add(activeUser.activeService.code);
            Vector activePatients;
           
            for(int s=0; s<services.size(); s++){
                activePatients = AdminPerson.getPatientsAdmittedInService((String)services.elementAt(s));
                
                for(int n=0; n<activePatients.size(); n++){
                    String patient = (String) activePatients.elementAt(n);                    
                    Vector activePrescrs = Prescription.findActive(patient,"","","","","","OC_PRESCR_BEGIN","DESC");
                    foundPrescrCount += activePrescrs.size();
                    
                    if(activePrescrs.size() > 0){
                      	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                        AdminPerson p = AdminPerson.getAdminPerson(ad_conn,patient);
                        ad_conn.close();
                        
                        // header per patient
                        out.print("<tr class='gray'><td colspan='25'>"+getTran(request,"Web.manage","ManagePatientPrescriptions",sWebLanguage)+"&nbsp;"+p.lastname+" "+p.firstname+"</td>");

                        %>
                            <%-- header --%>
	                        <tr class="label">
	                            <td width="20" nowrap>&nbsp;</td>
	                            <td width="250"><%=getTran(request,"Web","product",sWebLanguage)%></td>
	                            <td width="80"><SORTTYPE:DATE><%=getTran(request,"Web","begindate",sWebLanguage)%></SORTTYPE:DATE></td>
	                            <td width="80"><SORTTYPE:DATE><%=getTran(request,"Web","enddate",sWebLanguage)%></SORTTYPE:DATE></td>
	                            <td width="70"><%=getTran(request,"Web","prescriptionrule",sWebLanguage)%></td>
	                            <td width="70"><%=getTran(request,"Web","delivered.quantity",sWebLanguage)%></td>
	                            <td width="*"><%=getTran(request,"Web","tobedelivered.quantity",sWebLanguage)%></td>
	                        </tr>
                        <%
                        
                        out.print(objectsToHtml(activePrescrs,sWebLanguage,activeUser,request));
                    }
                }
            }
        %>
    </tbody>
</table>

<%-- number of records found --%>
<span style="width:49%;text-align:left;">
    &nbsp;<%=foundPrescrCount%> <%=getTran(request,"web","activeprescriptionsfound",sWebLanguage)%>
</span>

<%
    if(foundPrescrCount > 20){
        // link to top of page
		%>
		<span style="width:51%;text-align:right;">
		    <a href="#topp" class="topbutton">&nbsp;</a>
		</span>
		<%
    }
}
else{
    Vector activePrescrs = Prescription.findActive(activePatient.personid,"","","","","","OC_PRESCR_BEGIN","DESC");
    prescriptionsHtml = objectsToHtml(activePrescrs,sWebLanguage,activeUser,request);
    foundPrescrCount = activePrescrs.size();

    if(foundPrescrCount > 0 || !"1".equals(request.getParameter("skipEmpty"))){
%>
<table width="100%" cellspacing="0" cellpadding="0" class="sortable" id="searchresults">
    <%-- header --%>
    <tr>
        <td class="admin" width="22" nowrap>&nbsp;</td>
        <td class="admin"><%=getTran(request,"Web","product",sWebLanguage)%></td>
        <td class="admin"><SORTTYPE:DATE><%=getTran(request,"Web","begindate",sWebLanguage)%></SORTTYPE:DATE></td>
        <td class="admin"><SORTTYPE:DATE><%=getTran(request,"Web","enddate",sWebLanguage)%></SORTTYPE:DATE></td>
        <td class="admin"><%=getTran(request,"Web",checkString(request.getParameter("showDiagnosis")).equalsIgnoreCase("1")?"diagnosis":"authorizedreceiver",sWebLanguage)%></td>
        <td class="admin"><%=getTran(request,"Web","prescriber",sWebLanguage)%></td>
        <td class="admin"><%=getTran(request,"Web","prescriptionrule",sWebLanguage)%></td>
        <td class="admin" nowrap><%=getTran(request,"Web","delivered.quantity",sWebLanguage)%></td>
        <td class="admin" nowrap><%=getTran(request,"Web","tobedelivered.quantity",sWebLanguage)%></td>
    </tr>

    <tbody class="hand"><%=prescriptionsHtml%></tbody>
</table>

<%-- number of records found --%>
<span style="width:49%;text-align:left;">
    &nbsp;<%=foundPrescrCount%> <%=getTran(request,"web","activeprescriptionsfound",sWebLanguage)%>
</span>
<%
		    if(foundPrescrCount > 20){
		        // link to top of page
				%>
					<span style="width:51%;text-align:right;">
					    <a href="#topp" class="topbutton">&nbsp;</a>
					</span>
					<br>
				<%
			}
	    } 
	    else {
	        // no records found
	        %><script>window.location.href = "<c:url value='/popup.jsp'/>?Page=medical/managePrescriptionsPopup.jsp&Action=showDetailsNew&Close=true&findProduct=true&ts=<%=getTs()%>&PopupHeight=400&PopupWidth=900";</script><%
	    }
	}

    if(msg.length() > 0){
        %>
			<%-- display message --%>
			<br><span id="msgArea">&nbsp;<%=msg%></span>
	    <%
	}
%>
<table width='100%'>
	<tr>
		<td id='interactionswarning' style='display: none'>
		<a href='javascript:findInteractions();'>
		<img src="<c:url value='/_img/icons/icon_warning.gif'/>" title='<%=getTranNoLink("web","prescription_has_interactions",sWebLanguage)%>'/>
		<%=getTran(request,"web","prescription_has_interactions",sWebLanguage)%>!</a>
		</td>
	</tr>
</table>	

<%-- NEW BUTTON --%>
<%=ScreenHelper.alignButtonsStart()%>
	<%
	    if(!"true".equalsIgnoreCase(request.getParameter("ServicePrescriptions")) && activeUser.getAccessRight("prescriptions.drugs.add")){
	        %>
	        <input type="button" class="button" name="newButton" value="<%=getTranNoLink("Web","new",sWebLanguage)%>" onclick="doNew();">
	        <input type="button" class="button" name="paperPrescriptionButton" value="<%=getTranNoLink("Web","prescription",sWebLanguage)%>" onclick="printPaperPrescription();">
	        <%
	    }
	%>
	<input type="button" class="button" name="closeButton" value="<%=getTranNoLink("Web","close",sWebLanguage)%>" onclick="window.close();">
<%=ScreenHelper.alignButtonsStop()%>

<%
        }
    }
%>

<%-- hidden fields --%>
<input type="hidden" name="Action" id="ActionElement">
<input type="hidden" name="findProduct" id="findProduct">
<input type="hidden" name="EditPrescrUid" id="EditPrescrUid" value="<%=sEditPrescrUid%>">
<input type="hidden" name="DispensingStockUID" id="DispensingStockUID"/>
</form>
<form name="printPrescriptionForm" id="printPrescriptionForm" method="post" action="<c:url value='/'/>medical/createPrescriptionPdf.jsp">
    <input type="hidden" name="prescriptiondate" id="prescriptiondate" value="<%=ScreenHelper.stdDateFormat.format(new java.util.Date())%>"/>
    <input type="hidden" name="prescription" id="prescription" value=""/>
</form>

<%-- SCRIPTS ------------------------------------------------------------------------------------%>
<script>
window.resizeTo(900,380);
<%
    // default focus field
    if(displayEditFields){
        %>transactionForm.EditPrescriberFullName.focus();<%
    }
%>

function loadSchema(){
  openPopup("/_common/search/updatePrescriptionSchema.jsp&productuid="+document.getElementsByName("EditProductUid")[0].value);
}

<%-- DO ADD --%>
function doAdd(){
  transactionForm.EditPrescrUid.value = "-1";
  doSave();
}

function checkForInteractions(){
    var url = "<c:url value=''/>pharmacy/popups/findRxNormDrugDrugInteractionsBoolean.jsp";
    var params = "";
    new Ajax.Request(url,{
      method: "POST",
      parameters: params,
      onSuccess: function(resp){
        var interactions =  eval('('+resp.responseText+')');
        if(interactions.interactionsexist=='1'){
        	document.getElementById("interactionswarning").style.display='';
        }
        else {
        	document.getElementById("interactionswarning").style.display='none';
        }
      }
    });
  }


<%-- DO SAVE --%>
function doSave(){
  calculatePrescriptionPeriod();
  calculatePackagesNeeded();
  <%
  	if(MedwanQuery.getInstance().getConfigInt("enablePrescriptionSelectionOfDispensingStock",0)==1){%>
	  	if( '<%=sEditPrescrUid%>'.length==0 || '<%=sEditPrescrUid%>'=='-1' || <%=originalQuantity%> != (document.getElementById('EditRequiredPackages').value*1)){
	  		selectDispensingStock();
	  	}
	  	else{
	  		doSavePart2();
	  	}
  <%}else{%>
  		doSavePart2();
  <%}

  %>
}
function selectDispensingStock(){
	if(document.getElementById('EditProductUid').value.length>0){
		openPopup("/medical/selectDispensingStock.jsp&EditProductUid="+document.getElementById('EditProductUid').value+"&EditPrescrUid="+document.getElementById("EditPrescrUid").value+"&EditRequiredPackages="+document.getElementById('EditRequiredPackages').value);
	}
	else{
		doSavePart2();
	}
}
function addDispensingOperation(){
	<%
		String encounter ="";
		Encounter enc = Encounter.getActiveEncounter(activePatient.personid);
		if(enc!=null){
			encounter=enc.getUid();
		}
	%>
	var url = "<c:url value='/pharmacy/addDrugsOutBarcode.jsp'/>?loadonly="+
    "&ServiceStock="+document.getElementById("DispensingStockUID").value+
    "&DrugUid="+document.getElementById("EditProductUid").value+
    "&DrugBarcode="+
    "&EncounterUid=<%=encounter%>"+
    "&Quantity="+document.getElementById("EditRequiredPackages").value+
    "&Comment=<%=activeUser.person.getFullName()%>"+
    "&EditPrescrUid="+document.getElementById("EditPrescrUid").value+
    "&ts="+new Date().getTime();
	new Ajax.Request(url,{
		method: "POST",
		parameters: "",
		onSuccess: function(resp){
	        var label = eval('('+resp.responseText+')');
	        if(label.message && label.message.length>0){
	        	alert(label.message);
	        }
	        else {
	        	if(label.newprescriptionuid && label.newprescriptionuid.length>0){
		        	document.getElementById("EditPrescrUid").value=label.newprescriptionuid;
		        }
				doSavePart2();
	        }
		},
        onError: function(resp){
            alert(resp.responseText);
        }
	});
}
function doSavePart2(){
  if(checkPrescriptionFields()){
    if(transactionForm.returnButton!=undefined) transactionForm.returnButton.disabled = true;
    if(transactionForm.saveButton!=undefined) transactionForm.saveButton.disabled = true;
    if(transactionForm.deleteButton!=undefined) transactionForm.deleteButton.disabled = true;

    transactionForm.ActionElement.value = "save";
    transactionForm.submit();
  }
  else{
    if(transactionForm.EditProductUid.value.length==0){
      transactionForm.EditProductName.focus();
    }
    else if(transactionForm.EditUnitsPerTimeUnit.value.length==0){
      transactionForm.EditUnitsPerTimeUnit.focus();
    }
    else if(transactionForm.EditTimeUnitCount.value.length==0){
      transactionForm.EditTimeUnitCount.focus();
    }
    else if(transactionForm.EditTimeUnit.value.length==0){
      transactionForm.EditTimeUnit.focus();
    }
    else if(transactionForm.EditDateBegin.value.length==0){
      transactionForm.EditDateBegin.focus();
    }
    else if(transactionForm.EditDateEnd.value.length==0){
      transactionForm.EditDateEnd.focus();
    }
    else if(transactionForm.UnitsPerPackage.value.length==0){
      transactionForm.UnitsPerPackage.focus();
    }
    else if(transactionForm.EditPrescriberUid.value.length==0){
      transactionForm.EditPrescriberFullName.focus();
    }
    else if(transactionForm.EditRequiredPackages.value.length==0){
      transactionForm.EditRequiredPackages.focus();
    }
  }
}

<%-- CHECK PRESCRIPTION FIELDS --%>
function checkPrescriptionFields(){
  var maySubmit = false;

  <%-- required fields --%>
  if(!transactionForm.EditPrescriberUid.value.length==0 &&
     !transactionForm.EditProductUid.value.length==0 &&
     !transactionForm.EditTimeUnit.value.length==0 &&
     !transactionForm.EditDateBegin.value.length==0 &&
     !transactionForm.EditDateEnd.value.length==0 &&
     !transactionForm.UnitsPerPackage.value.length==0 &&
     !transactionForm.EditTimeUnitCount.value.length==0 &&
     !transactionForm.EditUnitsPerTimeUnit.value.length==0 &&
     !transactionForm.EditRequiredPackages.value.length==0){

    <%-- check dates --%>
    if(isValidDate(transactionForm.EditDateBegin) && isValidDate(transactionForm.EditDateEnd)){
      if(!isEndDateBeforeBeginDate()){
        maySubmit = true;
      }
      else{
        window.showModalDialog?alertDialog("web.Occup","endMustComeAfterBegin"):alertDialogDirectText('<%=getTran(null,"web.Occup","endMustComeAfterBegin",sWebLanguage)%>');
        transactionForm.EditDateEnd.focus();
      }
    }
  }
  else{
    maySubmit = false;
    window.showModalDialog?alertDialog("web.manage","dataMissing"):alertDialogDirectText('<%=getTran(null,"web.manage","dataMissing",sWebLanguage)%>');
  }

  return maySubmit;
}

<%-- DO DELETE --%>
function doDelete(prescriptionUid){
    if(yesnoDeleteDialog()){
    transactionForm.EditPrescrUid.value = prescriptionUid;
    transactionForm.Action.value = "delete";
    transactionForm.submit();
  }
}

function printPaperPrescription(){
	  document.getElementById('prescription').value="";
	  var elements = document.all;
	  for(n=0;n<elements.length;n++){
		  if(elements[n].id && elements[n].id.startsWith('cb_') && elements[n].checked){
			  document.getElementById('prescription').value+='R/ '+elements[n].name+"\n\n";
		  }
	  }
	  if(document.getElementById('prescription').value.length>0){
		  document.getElementById('printPrescriptionForm').submit();
	  }
}

<%-- DO NEW --%>
function doNew(){
  <%
  	if(Encounter.getActiveEncounter(activePatient.personid)==null){
  		%>
  		alert('<%=getTranNoLink("web","noactiveencounter",sWebLanguage)%>');
  		<%
  	}
  	else{
      if(displayEditFields){
          %>clearEditFields();<%
      }
	  %>
	
	  transactionForm.Action.value = "showDetailsNew";
	  transactionForm.findProduct.value = "true";
	  transactionForm.submit();
  <%}%>
}
</script>
<script>

<%-- DO SHOW DETAILS --%>
function doShowDetails(prescriptionUid){
  transactionForm.EditPrescrUid.value = prescriptionUid;
  transactionForm.Action.value = "showDetails";
  transactionForm.submit();
}
</script>
<script>
<%-- CLEAR EDIT FIELDS --%>
function clearEditFields(){
  transactionForm.EditPrescriberUid.value = "";
  transactionForm.EditPrescriberFullName.value = "";

  transactionForm.EditProductUid.value = "";
  transactionForm.EditProductName.value = "";

  transactionForm.EditSupplyingServiceUid.value = "";
  transactionForm.EditSupplyingServiceName.value = "";

  transactionForm.EditDateBegin.value = "";
  transactionForm.EditDateEnd.value = "";
  transactionForm.EditTimeUnit.value = "";
  transactionForm.EditTimeUnitCount.value = "";
  transactionForm.EditUnitsPerTimeUnit.value = "";
}

<%-- popup : search product --%>
function searchProduct(productUidField,productNameField,productUnitField,unitsPerTimeUnitField,
		               unitsPerPackageField,productStockUidField,serviceStockUidField,productTotalUnitsField){
  var url = "/_common/search/searchProduct.jsp&ts=<%=getTs()%>"+
            "&loadschema=true"+
            "&ReturnProductUidField="+productUidField+
            "&ReturnProductNameField="+productNameField+
            "&ReturnSupplierUidField=EditSupplyingServiceUid"+
            "&ReturnSupplierNameField=EditSupplyingServiceName";

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

  if(productTotalUnitsField!=undefined){
	    url+= "&ReturnTotalUnitsField="+productTotalUnitsField;
	  }

  openPopup(url);
}

<%-- popup : deliver medication --%>
function doDeliverMedication(prescrUID){
  var url = "/pharmacy/medication/popups/deliverMedicationPopup.jsp&ts=<%=getTs()%>"+
            "&EditPrescriptionUid="+prescrUID+"&EditSrcDestType=patient"+
            "&EditSrcDestName=<%=activePatient.firstname+" "+activePatient.lastname%>";
  openPopup(url);
}

<%-- popup : search userProduct --%>
function searchUserProduct(productUidField,productNameField,productUnitField,unitsPerTimeUnitField,
		                   unitsPerPackageField,productStockUidField,serviceStockUidField){
  var url = "/_common/search/searchUserProduct.jsp&ts=<%=getTs()%>&loadschema=true"+
		    "&ReturnProductUidField="+productUidField+"&ReturnProductNameField="+productNameField;

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
  var url = "/_common/search/searchProductInStock.jsp&ts=<%=getTs()%>&loadschema=true&DisplayProductsOfPatientService=true"+
            "&ReturnProductUidField="+productUidField+"&ReturnProductNameField="+productNameField;

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

<%-- popup : search supplying service --%>
function searchSupplyingService(serviceUidField,serviceNameField){
  openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
}

function findInteractions(){
    openPopup("/pharmacy/popups/findRxNormDrugDrugInteractions.jsp&ts=<%=getTs()%>",800,600);
}

<%-- popup : search service stock --%>
function searchServiceStock(serviceStockUidField,serviceStockNameField){
  openPopup("/_common/search/searchServiceStock.jsp&ts=<%=getTs()%>&ReturnServiceStockUidField="+serviceStockUidField+"&ReturnServiceStockNameField="+serviceStockNameField);
}

<%-- popup : search prescriber --%>
function searchPrescriber(prescriberUidField,prescriberNameField){
  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+prescriberUidField+"&ReturnName="+prescriberNameField+"&displayImmatNew=no");
}

<%-- CLEAR MESSAGE --%>
function clearMessage(){
  <%
      if(msg.length() > 0){
        %>document.getElementById('msgArea').innerHTML = "";<%
      }
  %>
}

<%-- CLOSE WINDOW --%>
function closeWindow(){
  if(checkSaveButton()){
    window.close()
  }
}

<%-- DO BACK --%>
function doBack(){
  if(checkSaveButton()){
    window.location.href = "<%=sCONTEXTPATH%>/popup.jsp?Page=medical/managePrescriptionsPopup.jsp&ts="+new Date().getTime();
  }
}

<%
	if(MedwanQuery.getInstance().getConfigInt("enableRxNorm",0)==1){
%>
		checkForInteractions();
<%
	}
%>
</script>

<script for="window" event="onunload">
  reloadOpener();
</script>
<script>
	new Ajax.Autocompleter('EditProductName','autocomplete_prescription','medical/ajax/getDrugs.jsp?serviceStockUid=NONE',{
	  minChars:1,
	  method:'post',
	  afterUpdateElement:afterAutoComplete,
	  callback:composeCallbackURL
	});
	
	function afterAutoComplete(field,item){
	  var regex = new RegExp('[-0123456789.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  clearEditFields();
	  document.getElementById("EditProductUid").value = id;
	  getProduct();
	}
	
	function composeCallbackURL(field,item){
	  var url = "";
	  if(field.id=="EditProductName"){
		url = "field=findDrugName&findDrugName="+field.value;
	  }
	  return url;
	}

	function getProduct(){
	    var url = "<c:url value=''/>medical/ajax/getProduct.jsp";
	    var params = "productUid="+document.getElementById("EditProductUid").value;

	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        var product =  eval('('+resp.responseText+')');
	        document.getElementById("EditProductName").value=product.name;
	        document.getElementById("EditUnitsPerTimeUnit").value=product.unitspertimeunit;
	        document.getElementById("EditTimeUnitCount").value=product.timeunitcount;
	        document.getElementById("EditTimeUnit").value=product.timeunit;
	        document.getElementById("EditDateBegin").value=product.startdate;
	        document.getElementById("UnitsPerPackage").value=product.packageunits;
	        document.getElementById("EditRequiredPackages").value=product.totalunits;
	        document.getElementById("EditPrescriberUid").value=product.prescriberuid;
	        document.getElementById("EditPrescriberFullName").value=product.prescribername;
	        document.getElementById("EditDiagnosis").value=product.diagnosis;
	        document.getElementById("productmsg").innerHTML='';
	        if(product.levels.indexOf("0/")==0){
	        	document.getElementById("productmsg").innerHTML=document.getElementById("productmsg").innerHTML+"<br/><img src='<c:url value="/"/>_img/icons/icon_warning.gif'/><%=getTran(request,"web","nodistributionstock",sWebLanguage)%>";
	        }
	        if(product.levels.indexOf("/0")>-1){
	        	document.getElementById("productmsg").innerHTML=document.getElementById("productmsg").innerHTML+"<br/><img src='<c:url value="/"/>_img/icons/icon_warning.gif'/><%=getTran(request,"web","nocentralstock",sWebLanguage)%>";
	        }
	        calculatePrescriptionPeriod();
			loadSchema();
	      }
	    });
	}
	
	calculateNumberOfDays();
	window.setTimeout('document.getElementById("EditProductName").focus();',200);
</script>

<%=writeJSButtons("transactionForm","saveButton")%>

<%
    if(MedwanQuery.getInstance().getConfigInt("enableAutomaticProductSearchInPrescriptions",0)==1 && "true".equalsIgnoreCase(request.getParameter("findProduct"))){
        if(sEditPrescrUid.length()==0){
        	out.print("<script>searchProduct('EditProductUid','EditProductName','ProductUnit','EditUnitsPerTimeUnit','UnitsPerPackage',null,'EditServiceStockUid','EditRequiredPackages');</script>");
        }
    }
%>
</body>