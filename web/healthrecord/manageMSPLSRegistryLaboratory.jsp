<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.Problem,
                be.openclinic.medical.Diagnosis,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                be.openclinic.medical.Prescription,
                java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="be.openclinic.medical.PaperPrescription" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String accessright="mspls.registry.laboratory";
%>
<%=checkPermission(accessright,"select",activeUser)%>
<%!
    //--- GET PRODUCT -----------------------------------------------------------------------------
    private Product getProduct(String sProductUid) {
        // search for product in products-table
        Product product = Product.get(sProductUid);

        if (product != null && product.getName() == null) {
            // search for product in product-history-table
            product = product.getProductFromHistory(sProductUid);
        }

        return product;
    }

    //--- GET ACTIVE PRESCRIPTIONS FROM RS --------------------------------------------------------
    private Vector getActivePrescriptionsFromRs(StringBuffer prescriptions, Vector vActivePrescriptions, String sWebLanguage) throws SQLException {
        Vector idsVector = new Vector();
        java.util.Date tmpDate;
        Product product = null;
        String sClass = "1", sPrescriptionUid = "", sDateBeginFormatted = "", sDateEndFormatted = "",
                sProductName = "", sProductUid = "", sPreviousProductUid = "", sTimeUnit = "", sTimeUnitCount = "",
                sUnitsPerTimeUnit = "", sPrescrRule = "", sProductUnit = "", timeUnitTran = "";
        DecimalFormat unitCountDeci = new DecimalFormat("#.#");
        SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;

        // frequently used translations
        String detailsTran = getTranNoLink("web", "showdetails", sWebLanguage),
                deleteTran = getTranNoLink("Web", "delete", sWebLanguage);
        Iterator iter = vActivePrescriptions.iterator();

        // run thru found prescriptions
        Prescription prescription;

        while (iter.hasNext()) {
            prescription = (Prescription)iter.next();
            sPrescriptionUid = prescription.getUid();
            // alternate row-style
            if (sClass.equals("")) sClass = "1";
            else sClass = "";

            idsVector.add(sPrescriptionUid);

            // format begin date
            tmpDate = prescription.getBegin();
            if (tmpDate != null) sDateBeginFormatted = stdDateFormat.format(tmpDate);
            else sDateBeginFormatted = "";

            // format end date
            tmpDate = prescription.getEnd();
            if (tmpDate != null) sDateEndFormatted = stdDateFormat.format(tmpDate);
            else sDateEndFormatted = "";

            // only search product-name when different product-UID
            sProductUid = prescription.getProductUid();
            if (!sProductUid.equals(sPreviousProductUid)) {
                sPreviousProductUid = sProductUid;
                product = getProduct(sProductUid);
                if (product != null) {
                    sProductName = product.getName();
                } else {
                    sProductName = "";
                }
                if (sProductName.length() == 0) {
                    sProductName = "<font color='red'>" + getTran(null,"web", "nonexistingproduct", sWebLanguage) + "</font>";
                }
            }

            //*** compose prescriptionrule (gebruiksaanwijzing) ***
            // unit-stuff
            sTimeUnit = prescription.getTimeUnit();
            sTimeUnitCount = Integer.toString(prescription.getTimeUnitCount());
            sUnitsPerTimeUnit = Double.toString(prescription.getUnitsPerTimeUnit());

            // only compose prescriptio-rule if all data is available
            if (!sTimeUnit.equals("0") && !sTimeUnitCount.equals("0") && !sUnitsPerTimeUnit.equals("0")) {
                sPrescrRule = getTran(null,"web.prescriptions", "prescriptionrule", sWebLanguage);
                sPrescrRule = sPrescrRule.replaceAll("#unitspertimeunit#", unitCountDeci.format(Double.parseDouble(sUnitsPerTimeUnit)));
                if (product != null) {
                    sProductUnit = product.getUnit();
                } else {
                    sProductUnit = "";
                }
                // productunits
                if (Double.parseDouble(sUnitsPerTimeUnit) == 1) {
                    sProductUnit = getTran(null,"product.unit", sProductUnit, sWebLanguage);
                } else {
                    sProductUnit = getTran(null,"product.units", sProductUnit, sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#productunit#", sProductUnit.toLowerCase());

                // timeunits
                if (Integer.parseInt(sTimeUnitCount) == 1) {
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#", "");
                    timeUnitTran = getTran(null,"prescription.timeunit", sTimeUnit, sWebLanguage);
                } else {
                    sPrescrRule = sPrescrRule.replaceAll("#timeunitcount#", sTimeUnitCount);
                    timeUnitTran = getTran(null,"prescription.timeunits", sTimeUnit, sWebLanguage);
                }
                sPrescrRule = sPrescrRule.replaceAll("#timeunit#", timeUnitTran.toLowerCase());
            }

            //*** display prescription in one row ***
            prescriptions.append("<tr class='list" + sClass + "'  title='" + detailsTran + "'>")
                    .append("<td align='center'><img src='" + sCONTEXTPATH + "/_img/icons/icon_delete.png' border='0' title='" + deleteTran + "' onclick=\"doDelete('" + sPrescriptionUid + "');\">")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sProductName + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sDateBeginFormatted + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sDateEndFormatted + "</td>")
                    .append("<td onclick=\"doShowDetails('" + sPrescriptionUid + "');\" >" + sPrescrRule.toLowerCase() + "</td>")
                    .append("</tr>");
        }
        return idsVector;
    }

    private class TransactionID {
        public int transactionid = 0;
        public int serverid = 0;
    }

    //--- GET MY TRANSACTION ID -------------------------------------------------------------------
    private TransactionID getMyTransactionID(String sPersonId, String sItemTypes, JspWriter out) {
        TransactionID transactionID = new TransactionID();
        Transaction transaction = Transaction.getSummaryTransaction(sItemTypes, sPersonId);
        try {
            if (transaction != null) {
                String sUpdateTime = ScreenHelper.getSQLDate(transaction.getUpdatetime());
                transactionID.transactionid = transaction.getTransactionId();
                transactionID.serverid = transaction.getServerid();
                out.print(sUpdateTime);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (Debug.enabled) Debug.println(e.getMessage());
        }
        return transactionID;
    }

    //--- GET MY ITEM VALUE -----------------------------------------------------------------------
    private String getMyItemValue(TransactionID transactionID, String sItemType, String sWebLanguage) {
        String sItemValue = "";
        Vector vItems = Item.getItems(Integer.toString(transactionID.transactionid), Integer.toString(transactionID.serverid), sItemType);
        Iterator iter = vItems.iterator();

        Item item;

        while (iter.hasNext()) {
            item = (Item) iter.next();
            sItemValue = item.getValue();//checkString(rs.getString(1));
            sItemValue = getTranNoLink("Web.Occup", sItemValue, sWebLanguage);
        }
        return sItemValue;
    }
%>
<form name="transactionForm" id="transactionForm" method="POST" action='<c:url value="/healthrecord/updateTransaction.do"/>?ts=<%=getTs()%>'>
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
	<%=checkPrestationToday(activePatient.personid,false,activeUser,(TransactionVO)transaction)%>
   
    <input type="hidden" id="transactionId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionId" value="<bean:write name="transaction" scope="page" property="transactionId"/>"/>
    <input type="hidden" id="serverId" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.serverId" value="<bean:write name="transaction" scope="page" property="serverId"/>"/>
    <input type="hidden" id="transactionType" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.transactionType" value="<bean:write name="transaction" scope="page" property="transactionType"/>"/>
    <input type="hidden" readonly name="be.mxs.healthrecord.updateTransaction.actionForwardKey" value="/main.do?Page=curative/index.jsp&ts=<%=getTs()%>"/>
    <%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_DEPARTMENT") %>
    <%=ScreenHelper.writeDefaultHiddenInput((TransactionVO)transaction, "ITEM_TYPE_CONTEXT_CONTEXT") %>
    
    <%=writeHistoryFunctions(((TransactionVO)transaction).getTransactionType(),sWebLanguage)%>
    <%=contextHeader(request,sWebLanguage)%>
    
    <table class="list" width="100%" cellspacing="1">
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>

        <tr>
            <td class="admin"><%=getTran(request,"web", "sampletype", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "mspls.sampletype", "ITEM_TYPE_SAMPLETYPE", sWebLanguage, true) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"mspls", "condition", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "goodbad",  "ITEM_TYPE_SAMPLECONDITION", sWebLanguage, true, "", " ") %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "examtype", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "mspls.labexamtype", "ITEM_TYPE_EXAMTYPE", sWebLanguage, true) %>
            </td>
        </tr>
        <tr>
            <td class="admin" rowspan="2"><%=getTran(request,"web", "stool", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_LAB_STOOL","posnegna", sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_STOOLTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "mspls.parasites", "ITEM_TYPE_PARASITES", sWebLanguage, true) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "urine", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_LAB_URINE","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_URINETEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "thicksmear", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_THIKSMEAR","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_THIKSMEARTEXT", 40,1) %><br/>
            	<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "mspls.malariaparasites", "ITEM_TYPE_MALARIAPARASITES", sWebLanguage, true) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "rapidtest", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_RAPIDTEST","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_RAPIDTESTTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "bk2", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_LAB_BK2","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_BK2TEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "pregnancy", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_PREGNANCY","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_PREGNANCYTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "hiv", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_HIV","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_HIVTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "syphilis", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_LAB_SYPHILIS","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_SYPHILISTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "otherstd", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction,  "ITEM_TYPE_LAB_OTHERSTD","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_OTHERSTDTEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "glucosuria", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_GLUCOSURIA","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_GLUCOSURIATEXT", 40,1) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "capillarglycemia", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_GLYCEMIA","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_GLYCEMIATEXT", 5) %>g/dl
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "hemoglobine", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_HB","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_HBTEXT", 5) %>g/dl
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "pcr", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_PCR","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_PCRTEXT", 40) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "cv", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_CV","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_CVTEXT", 40) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "hepatitisb", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_HEPATITISB","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_HEPATITISBTEXT", 40) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "hepatitisc", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_HEPATITISC","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_HEPATITISCTEXT", 40) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "otherexams", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_LAB_OTHEREXAMS","posnegna",  sWebLanguage, "") %>
            	<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO) transaction, "ITEM_TYPE_LAB_OTHEREXAMSTEXT", 40) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "transmissiondate", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_LAB_TRANSMISSIONDATE", sWebLanguage, sCONTEXTPATH)%>
            </td>
        </tr>
    </table>            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,accessright,sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</form>

<script>
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  if( document.getElementById('encounteruid').value=="" <%=request.getParameter("nobuttons")==null?"":" && 1==0"%>){
  	alertDialogDirectText('<%=getTranNoLink("web","no.encounter.linked",sWebLanguage)%>');
  	searchEncounter();
  }	

  function searchUser(managerUidField,managerNameField){
	  openPopup("/_common/search/searchUser.jsp&ts=<%=getTs()%>&ReturnUserID="+managerUidField+"&ReturnName="+managerNameField+"&displayImmatNew=no&FindServiceID=<%=MedwanQuery.getInstance().getConfigString("CCBRTEyeRegistryService")%>",650,600);
    document.getElementById(diagnosisUserName).focus();
  }

  function submitForm(){
    transactionForm.saveButton.disabled = true;
    <%
        SessionContainerWO sessionContainerWO = (SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO(request,SessionContainerWO.class.getName());
        out.print(takeOverTransaction(sessionContainerWO,activeUser,"document.transactionForm.submit();"));
    %>
  }
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>