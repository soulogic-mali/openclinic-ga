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
<%@ page import="be.openclinic.medical.PaperPrescription" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%!
    //--- GET PRODUCT -----------------------------------------------------------------------------
    private Product getProduct(String sProductUid) {
        // search for product in products-table
        Product product = new Product();
        product = product.get(sProductUid);

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
                    sProductName = "<font color='red'>"+getTran(null,"web", "nonexistingproduct", sWebLanguage)+"</font>";
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
                    sProductUnit = getTran(null,"product.unit", sProductUnit, sWebLanguage);
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
            prescriptions.append("<tr class='list"+sClass+"' onmouseover=\"this.style.cursor='pointer';\" onmouseout=\"this.style.cursor='default';\" title='"+detailsTran+"'>")
                    .append("<td />")
                    .append("<td onclick=\"doShowDetails('"+sPrescriptionUid+"');\" >"+sProductName+"</td>")
                    .append("<td onclick=\"doShowDetails('"+sPrescriptionUid+"');\" >"+sDateBeginFormatted+"</td>")
                    .append("<td onclick=\"doShowDetails('"+sPrescriptionUid+"');\" >"+sDateEndFormatted+"</td>")
                    .append("<td onclick=\"doShowDetails('"+sPrescriptionUid+"');\" >"+sPrescrRule.toLowerCase()+"</td>")
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

<script>
    <%-- VALIDATE WEIGHT --%>
    <%
        int minWeight = 1;
        int maxWeight = 300;

        String weightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight.validationerror",sWebLanguage);
        weightMsg = weightMsg.replaceAll("#min#",minWeight+"");
        weightMsg = weightMsg.replaceAll("#max#",maxWeight+"");
    %>
    function validateWeight(weightInput){
      weightInput.value = weightInput.value.replace(",",".");
      if(weightInput.value.length > 0){
        var min = <%=minWeight%>;
        var max = <%=maxWeight%>;

        if(isNaN(weightInput.value) || weightInput.value < min || weightInput.value > max){
          alertDialogDirectText("<%=weightMsg%>");
          //weightInput.value = "";
          weightInput.focus();
        }
      }
    }

    <%-- VALIDATE HEIGHT --%>
    <%
        int minHeight = 25;
        int maxHeight = 240;

        String heightMsg = getTran(request,"Web.Occup","medwan.healthrecord.biometry.height.validationerror",sWebLanguage);
        heightMsg = heightMsg.replaceAll("#min#",minHeight+"");
        heightMsg = heightMsg.replaceAll("#max#",maxHeight+"");
    %>
    function validateHeight(heightInput){
      heightInput.value = heightInput.value.replace(",",".");
      if(heightInput.value.length > 0){
        var min = <%=minHeight%>;
        var max = <%=maxHeight%>;

        if(isNaN(heightInput.value) || heightInput.value < min || heightInput.value > max){
          alertDialogDirectText("<%=heightMsg%>");
          heightInput.focus();
        }
      }
    }

    <%-- CALCULATE BMI --%>
    function calculateBMI(){
    	document.getElementsByName('BMI')[0].value = "";
      var _BMI = 0;
      var heightInput = document.getElementById('height');
      var weightInput = document.getElementById('weight');
      if(heightInput.value > 0){
        _BMI = (weightInput.value * 10000) / (heightInput.value * heightInput.value);
        if(_BMI > 100 || _BMI < 5){
          document.getElementsByName('BMI')[0].value = "";
        }
        else {
          document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
        }
      }
    }
</script>

<logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="healthRecordVO">
    <bean:define id="transaction" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="currentTransactionVO"/>
    <bean:define id="lastTransaction_biometry" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeBiometry"/>

<%
    if (session.getAttribute("sessionCounter")==null){
        session.setAttribute("sessionCounter",new Integer(0));
    }
    else {
        session.setAttribute("sessionCounter",new Integer(((Integer)session.getAttribute("sessionCounter")).intValue()+1));
    }
%>

<input type="hidden" name="sessionCounter" value="<%=session.getAttribute("sessionCounter")%>"/>

<table class="list" width="100%" border="0" cellspacing="1" cellpadding="0">
    <tr>
        <%-- LAST GENERAL CLINICAL EXAMINATION --%>
        <td style="vertical-align:top;" height="100%">
            <table class="list" width="100%" border="0" cellspacing="1" cellpadding="1" height="100%">
                <logic:present name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeGeneralClinicalExamination">
                    <bean:define id="lastTransaction_generalClinicalExamination" name="be.mxs.webapp.wl.session.SessionContainerFactory.WO_SESSION_CONTAINER" property="lastTransactionTypeGeneralClinicalExamination"/>
                </logic:present>
                <tr class="gray">
                    <td width="33%"><%=getTran(request,"Web.Occup","medwan.healthrecord.clinical-examination.systeme-cardiovasculaire.TA",sWebLanguage)%>
                            (<%
                            TransactionID transactionID = getMyTransactionID(activePatient.personid,"'be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT','be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT','be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT','be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT'", out);
                            String sSBPR = "", sDBPR = "", sSBPL = "", sDBPL = "";
                            if (transactionID.transactionid>0){
                                sSBPR = getMyItemValue(transactionID,sPREFIX+"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT",sWebLanguage);
                                sDBPR = getMyItemValue(transactionID,sPREFIX+"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT",sWebLanguage);
                                sSBPL = getMyItemValue(transactionID,sPREFIX+"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT",sWebLanguage);
                                sDBPL = getMyItemValue(transactionID,sPREFIX+"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT",sWebLanguage);
                            }
                        %>)
                    </td>
                    <td width="33%">
                        <b>
                            <span <%=setRightClickMini("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%>>
                                <%=sSBPR%>
                            </span>
                            /
                            <span <%=setRightClickMini("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%>>
                                <%=sDBPR%>
                            </span>
                        </b>
                    </td>
                    <td width="33%">
                        <b>
                            <span <%=setRightClickMini("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%>>
                                <%=sSBPL%>
                            </span>
                            /
                            <span <%=setRightClickMini("ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%>>
                                <%=sDBPL%>
                            </span>
                        </b>
                    </td>
                </tr>
            </table>
        </td>

        <%-- LAST BIOMETRY EXAMINATION --%>
        <td style="vertical-align:top;" colspan="2" height="100%">
            <table class="list" width="100%" border="0" cellspacing="1" cellpadding="0" height="100%">
                <tr class="gray">
                    <td width="25%">
                        <%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%> (°C)
                        <b>
                            <%
                                String temperature=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid),"be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE");
                                if(temperature.length()>0){
                            %>
                            <div <%=setRightClickMini("[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%>><%=temperature%></div>
                            <input id="lastTemperature" type="hidden" name="lastTemperature" value="<%=temperature%>"/>
                            <%
                                }
                                else {
                                	out.print("<div>&nbsp;</div>");
                                }
                            %>
                        </b>
                    </td>
                    <td width="25%">
                        <%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>
                        <b>
                            <%
                                String weight=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid),"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT");
                                if(weight.length()>0){
                            %>
                            <div <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%>><%=weight%></div>
                            <input id="lastWeight" type="hidden" name="lastWeight" value="<%=weight%>"/>
                            <%
                                }
                                else {
                                	out.print("<div>&nbsp;</div>");
                                }
                            %>
                        </b>
                    </td>
                    <td width="25%">
                        <%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>
                        <b>
                            <%
                                 String height=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid),"be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT");
                                if(height.length()>0){
                            %>
                                <div <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%>><%=height%></div>
                                <input id="lastHeight" type="hidden" name="lastHeight" value="<%=height%>"/>
                            <%
                                }
                                else {
                                	out.print("<div>&nbsp;</div>");
                                }
                            %>
                        </b>
                    </td>
                    <td width="25%">
                        <%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>
                        <b>
                            <%
                                if(height.length()*weight.length()>0){
                            %>
                                <div id="BMI"></div>
                                <script>
                                  if (document.getElementsByName('lastHeight')[0].value.length > 0 && document.getElementsByName('lastWeight')[0].value.length>0){
                                    var _BMI = (document.getElementsByName('lastWeight')[0].value * 10000) / (document.getElementsByName('lastHeight')[0].value * document.getElementsByName('lastHeight')[0].value);
                                    document.getElementsByName('BMI')[0].innerHTML = "<b>"+Math.round(_BMI*10)/10+"</b>";
                                  }
                                </script>
                            <%
                                }
                                else {
                                	out.print("<div>&nbsp;</div>");
                                }
                            %>
                        </b>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
    <%-- ANAMNESE ---------------------------------------------------------------------------------------------------%>
    <tr>
        <td width="50%" style="vertical-align:top;">
            <table class="list" width="100%" height="100%" cellspacing="1">
                <tr class="admin">
                    <td align="center" colspan="4"><%=getTran(request,"Web.Occup","medwan.healthrecord.general",sWebLanguage)%></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese.general.subjective",sWebLanguage)%></td>
                    <td colspan="3" class="admin2">
                        <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE")%> class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE1" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE3" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE4" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE5" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE6" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE7" property="value"/></textarea>
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE1" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE2" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE3" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE4" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE5" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE6" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SUBJECTIVE7" property="itemId"/>]>.value">
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese.general.objective",sWebLanguage)%></td>
                    <td colspan="3" class="admin2">
                        <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE")%> class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE1" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE3" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE4" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE5" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE6" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE7" property="value"/></textarea>
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE1" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE2" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE3" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE4" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE5" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE6" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_OBJECTIVE7" property="itemId"/>]>.value">
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese.general.evaluation",sWebLanguage)%></td>
                    <td colspan="3" class="admin2">
                        <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION")%> class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION1" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION3" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION4" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION5" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION6" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION7" property="value"/></textarea>
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION1" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION2" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION3" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION4" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION5" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION6" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_EVALUATION7" property="itemId"/>]>.value">
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.anamnese.general.planning",sWebLanguage)%></td>
                    <td colspan="3" class="admin2">
                        <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING")%> class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING1" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING2" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING3" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING4" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING5" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING6" property="value"/><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING7" property="value"/></textarea>
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING1" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING2" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING3" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING4" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING5" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING6" property="itemId"/>]>.value">
                        <input type="hidden" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_PLANNING7" property="itemId"/>]>.value">
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"web","remark",sWebLanguage)%></td>
                    <td colspan="3" class="admin2">
                        <textarea onKeyup="resizeTextarea(this,10);" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_REMARK")%> class="text" cols="50" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_REMARK" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_REMARK" property="value"/></textarea>
                    </td>
                </tr>
		        <!- DRAWING ITEM-->
		        <tr>
		            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","drawing",sWebLanguage) %> <img src='<%=sCONTEXTPATH%>/_img/icons/icon_minus.png' onclick='document.getElementById("drawing").style.display="none";'/> <img src='<%=sCONTEXTPATH%>/_img/icons/icon_plus.png' onclick='document.getElementById("drawing").style.display="";'/></td>
		        	<td class='admin2' colspan='4'>
		        		<div id='drawing' style='display: <%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING").length()>0?"":"none"%>'>
							<%=ScreenHelper.createDrawingDiv(request, "canvasDiv", "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_OCDRAWING", transaction,MedwanQuery.getInstance().getConfigString("defaultVVFDiagram","/_img/shoulder.png"),"surgery.image") %>
						</div>
		        	</td>
		        </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%></td>
                    <td class="admin2" colspan="3"><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min
                        <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1a" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.regulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.regulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.regulier",sWebLanguage,"sum_r1a")%>
                        <input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH")%> type="radio" onDblClick="uncheckRadio(this);" id="sum_r1b" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH" property="itemId"/>]>.value" value="medwan.healthrecord.cardial.irregulier" <mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_RYTMH;value=medwan.healthrecord.cardial.irregulier" property="value" outputString="checked"/>><%=getLabel(request,"Web.Occup","medwan.healthrecord.cardial.irregulier",sWebLanguage,"sum_r1b")%>
                    </td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
                    <td class="admin2" nowrap>
                        <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-droit",sWebLanguage)%>
                        <input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> /
                        <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg
                    </td>
                    <td class="admin2" colspan="2" nowrap>
                        <%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.bras-gauche",sWebLanguage)%>
                        <input id="sbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> /
                        <input id="dbpl" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_LEFT" property="value"/>" onblur="setBP(this,'sbpl','dbpl');"> mmHg
                    </td>
                </tr>
		        <tr>
		            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>&nbsp;</td>
		            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="weight" class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="validateWeight(this);" onkeyup="calculateBMI();"/></td>
		            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>&nbsp;</td>
		            <td class='admin2'><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id='height' class="text" type="text" size="10" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="validateHeight(this);" onkeyup="calculateBMI();"/></td>
		        </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="if(isNumber(this)){if(!checkMinMaxOpen(0,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> C°
                    </td>
		            <td class='admin'><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>&nbsp;</td>
		            <td class='admin2'><input tabindex="-1" class="text" type="text" size="10" readonly name="BMI"></td>
                </tr>
                <tr>
                    <td class="admin"><%=getTran(request,"Web.Occup","Smoking",sWebLanguage)%></td>
                    <td class="admin2">
                        <select <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TOBACCO_USAGE")%> id="EditSmoking" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TOBACCO_USAGE" property="itemId"/>]>.value" class="text">
                            <option/>
                            <option value="1">0</option>
                            <option value="2">0 - 5</option>
                            <option value="3">5 - 10</option>
                            <option value="4">10 - 15</option>
                            <option value="5">15 - 25</option>
                            <option value="6">&gt; 25</option>
                        </select>
                        &nbsp;&nbsp;<%=getTran(request,"Web.Occup","ADay",sWebLanguage)%>
                    </td>
                    <td class="admin"><%=getTran(request,"Web.Occup","medwan.healthrecord.psycho.alcohol",sWebLanguage)%></td>
                    <td class="admin2">
                        <select <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_ALCOHOL_USAGE")%> id="EditAlcohol" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_ALCOHOL_USAGE" property="itemId"/>]>.value" class="text">
                            <option></option>
                            <option value="ce.alcohol.usage.none"><%=getTran(request,"Web.Occup","ce.alcohol.usage.none",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.weekend"><%=getTran(request,"Web.Occup","ce.alcohol.usage.weekend",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.social"><%=getTran(request,"Web.Occup","ce.alcohol.usage.social",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.occasional"><%=getTran(request,"Web.Occup","ce.alcohol.usage.occasional",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.1_a_day"><%=getTran(request,"Web.Occup","ce.alcohol.usage.1_a_day",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.2_a_day"><%=getTran(request,"Web.Occup","ce.alcohol.usage.2_a_day",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.3_a_day"><%=getTran(request,"Web.Occup","ce.alcohol.usage.3_a_day",sWebLanguage)%></option>
                            <option value="ce.alcohol.usage.more_than_3_a_day"><%=getTran(request,"Web.Occup","ce.alcohol.usage.more_than_3_a_day",sWebLanguage)%></option>
                        </select>
                    </td>
                </tr>
            </table>
        </td>

        <%-- KLINISCH ONDERZOEK -------------------------------------------------------------------------------------%>
        <td style="vertical-align:top;" colspan="2">
        	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
            <br/>
            <table width="100%" class="list" cellspacing="1">
                <tr class="admin">
                    <td align="center"><a href="javascript:showProblemlist();"><%=getTran(request,"web.occup","medwan.common.problemlist",sWebLanguage)%></a></td>
                </tr>
                <tr>
                    <td id="problemList">
                        <%
                            Vector activeProblems = Problem.getActiveProblems(activePatient.personid);
                            if(activeProblems.size()>0){
                                out.print("<table width='100%' cellspacing='0' class='list'><tr class='admin'><td>"+getTran(request,"web.occup","medwan.common.description",sWebLanguage)+"</td><td nowrap>"+getTran(request,"web.occup","medwan.common.datebegin",sWebLanguage)+"</td></tr>");

                                String sClass = "1";

                                for(int n=0;n<activeProblems.size();n++){
                                	// alternate row-style
                                    if(sClass.equals("")) sClass = "1";
                                    else                  sClass = "";
                                	
                                    Problem activeProblem = (Problem)activeProblems.elementAt(n);
                                    String comment="";
                                    if(activeProblem.getComment().trim().length()>0){
                                        comment=":&nbsp;<i>"+activeProblem.getComment().trim()+"</i>";
                                    }
                                    out.print("<tr class='list"+sClass+"'><td><b>"+(activeProblem.getCode()+" "+MedwanQuery.getInstance().getCodeTran(activeProblem.getCodeType()+"code"+activeProblem.getCode(),sWebLanguage)+"</b>"+comment)+"</td><td>"+ScreenHelper.stdDateFormat.format(activeProblem.getBegin())+"</td></tr>");
                                }
                                out.print("</table>");
                            }
                        %>
                    </td>
                </tr>
            </table>
            <br/>
            
	            <table width="100%" class="list" cellspacing="1">
	                <tr class="admin">
	                    <td align="center"><%=getTran(request,"Web.Occup","medwan.healthrecord.medication",sWebLanguage)%> (<a href="javascript:openPopup('medical/managePrescriptionsPopup.jsp&amp;Action=showDetailsNew&amp;Close=true&amp;findProduct=true',650,430,'medication');void(0);"><%=getTran(request,"web","medications",sWebLanguage)%></a>)</td>
	                </tr>
	                <tr>
	                    <td>
	                <%
	                    //--- DISPLAY ACTIVE PRESCRIPTIONS (of activePatient) ---------------------------------
	                    // compose query
	                    Vector vActivePrescriptions = Prescription.findActive(activePatient.personid,activeUser.userid,"","","","","","");
	
	                    StringBuffer prescriptions = new StringBuffer();
	                    Vector idsVector = getActivePrescriptionsFromRs(prescriptions, vActivePrescriptions , sWebLanguage);
	                    int foundPrescrCount = idsVector.size();
	
	                    if(foundPrescrCount > 0){
	                        %>
	                            <table width="100%" cellspacing="0" cellpadding="0" class="list">
	                                <%-- header --%>
	                                <tr class="admin">
	                                    <td width="22" nowrap>&nbsp;</td>
	                                    <td width="30%"><%=getTran(request,"Web","product",sWebLanguage)%></td>
	                                    <td width="15%"><%=getTran(request,"Web","begindate",sWebLanguage)%></td>
	                                    <td width="15%"><%=getTran(request,"Web","enddate",sWebLanguage)%></td>
	                                    <td width="40%"><%=getTran(request,"Web","prescriptionrule",sWebLanguage)%></td>
	                                </tr>
	
	                                <tbody class="hand"><%=prescriptions%></tbody>
	                            </table>
	                        <%
	                    }
	                    else{
	                        // no records found
	                        %><%=getTran(request,"web","noactiveprescriptionsfound",sWebLanguage)%><br><%
	                    }
	                    %>
	                    </td>
	                </tr>
	                <tr class="admin">
	                    <td align="center"><%=getTran(request,"curative","medication.paperprescriptions",sWebLanguage)%> (<%=ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime())%>) (<a href="javascript:openPopup('medical/managePrescriptionForm.jsp&amp;skipEmpty=1',650,430,'medication');void(0);"><%=getTran(request,"web","medicationpaperprescription",sWebLanguage)%></a>)</td>
	                </tr>
	                <%
	                    Vector paperprescriptions = PaperPrescription.find(activePatient.personid,"",ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),"","DESC");
	                    if(paperprescriptions.size()>0){
	                        out.print("<tr><td><table width='100%'>");
	                        String l="";
	                        for(int n=0;n<paperprescriptions.size();n++){
	                            if(l.length()==0){
	                                l="1";
	                            }
	                            else{
	                                l="";
	                            }
	                            PaperPrescription paperPrescription = (PaperPrescription)paperprescriptions.elementAt(n);
	                            out.println("<tr class='list"+l+"' id='pp"+paperPrescription.getUid()+"'><td valign='top' width='90px'> <b>"+ScreenHelper.stdDateFormat.format(paperPrescription.getBegin())+"</b></td><td><i>");
	                            Vector products =paperPrescription.getProducts();
	                            for(int i=0;i<products.size();i++){
	                                out.print(products.elementAt(i)+"<br/>");
	                            }
	                            out.println("</i></td></tr>");
	                        }
	                        out.print("</table></td></tr>");
	                    }
	                    else{
	                        out.print("<tr><td><table width='100%'>");
	                        // no records found
	                        %><%=getTran(request,"web","noactiveprescriptionsfound",sWebLanguage)%><br><%
	                        out.print("</table></td></tr>");
	                    }
	                %>
	            </table>
            </table>
        </td>
    </tr>
</table>

<script>
  function setBP(oObject,sbp,dbp){
    if(oObject.value.length>0){
      if(!isNumberLimited(oObject,40,300)){
        alertDialog("Web.occup","out-of-bounds-value");
      }
      else if((sbp.length>0)&&(dbp.length>0)){
        isbp = document.getElementsByName(sbp)[0].value*1;
        idbp = document.getElementsByName(dbp)[0].value*1;
        if(idbp>isbp){
          alertDialog("Web.occup","error.dbp_greather_than_sbp");
        }
      }
    }
  }

  function setHF(oObject){
    if(oObject.value.length>0){
      if(!isNumberLimited(oObject,30,300)){
        alertDialog("Web.occup","out-of-bounds-value");
      }
    }
  }

  function deleteDiagnose(rowid){
    activeDiagnosis.deleteRow(rowid.rowIndex);
  }

  function showProblemlist(){
    openPopup("medical/manageProblems.jsp&ts=<%=getTs()%>");
  }

  function doShowDetails(uid){
    openPopup("medical/managePrescriptionsPopup.jsp&Action=showDetails&EditPrescrUid="+uid);
  }

  iAlcohol = "<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_ALCOHOL_USAGE" property="value"/>";
  for(var n=0;n<transactionForm.EditAlcohol.length;n++){
    if(transactionForm.EditAlcohol.options[n].text==iAlcohol){
      transactionForm.EditAlcohol.selectedIndex=n;
      break;
    }
  }

  iSmoking = "<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TOBACCO_USAGE" property="value"/>";
  for(var n=0;n<transactionForm.EditSmoking.length;n++){
    if(transactionForm.EditSmoking.options[n].value==iSmoking){
      transactionForm.EditSmoking.selectedIndex=n;
      break;
    }
  }
  calculateBMI();
</script>
</logic:present>