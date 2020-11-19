<%@page import="be.openclinic.surveillance.Covid"%>
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
	String accessright="surveillance.covid19.assessment.pulseoximetry";
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
<div id='divheader'>    

    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <%-- DATE --%>
        <tr>
        	<td class='admin' colspan='8'>
        		<table width='100%' cellspacing='0' cellpadding='0'>
        			<tr>
			    		<td width='1%' nowrap rowspan='2'>
			            	<img style='vertical-align: middle' height='50px' src='<%=sCONTEXTPATH %>/_img/aniciis.png'/>&nbsp;&nbsp; 
			    		</td>
			            <td class="admin" width="<%=sTDAdminWidth%>">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
			                <input onkeyup="triage()" type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			            <td class='admin' width='80%'>
			            	<div id='covidtest' style='color: red;font-size: 14px'></div>
			            </td>
			    	</tr>
			        <tr class='admin'>
						<td colspan='2'><%=getTran(request,"examination","1209",sWebLanguage) %></td>
			        </tr>
        		</table>
        	</td>
        </tr>
    </table>
</div>
<div id='divcontent' style="overflow-y: scroll;">    
    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <tr id='trpom3'>
            <td class="admin" colspan='1' width='1%' nowrap>
            	<%=getTran(request,"Web.Occup","pulseoximetry",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2" colspan="1" width='1%' nowrap>
            	<%=SH.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_POM3", 5, sWebLanguage,"triage();")%>%
            <td class="admin2" colspan="6">
            	<div id='divpom3'></div>
            </td>
        </tr>
        <tr>
            <td class="admin" colspan='1' width='1%' nowrap>
            	<%=getTran(request,"covid","signs",sWebLanguage)%>&nbsp;
            </td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SIGNSONADMISSION", "yesno", sWebLanguage, "onclick='triage();'") %>
        	</td>
        	<td class='admin2top' colspan="6">
        		<%=getTran(request,"covid","entry.signs",sWebLanguage) %>
        	</td>
        </tr>
    </table>
    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <tr id='trassessment' style='display: none'>
        	<td colspan='8'>
        		<table width='100%'>
			        <%-- VITAL SIGNS --%>
			        <tr>
			            <td class="admin" colspan='1'><%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;</td>
			            <td class="admin2" colspan="7">
			            	<table width="100%">
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="triage();if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="ITEM_TYPE_BIOMETRY_HEIGHT" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="calculateBMI();triage();"/> cm</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="ITEM_TYPE_BIOMETRY_WEIGHT" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();triage();"/> kg</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
			            		</tr>
				                <tr>
						            <td nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm</td>
						            <td nowrap><b><%=getTran(request,"web","fhr",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_FOETAL_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="value"/>"/></td>
						            <td colspan='4'/>
				                </tr>
			            		<tr>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td>
			            			<td nowrap><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
			            			<td nowrap><b><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%>:</b></td>
			            			<td nowrap><input id="respfreq" type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" onBlur="isNumber(this);triage();" size="5"/> /min</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td>
			            			<td nowrap><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></b></td>
			            			<td nowrap><input tabindex="-1" class="text" type="text" size="4" readonly name="WFL" id="WFL"><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
			            		</tr>
			            	</table>
			            </td>
			        </tr>
			        <%-- CLINICAL SIGNS AND SYMPTOMS --%>
			        <tr class="admin">
			            <td colspan="8"><%=getTran(request,"web","clinicalsignsandsymptoms",sWebLanguage)%>&nbsp;</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","abdominalpain",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ABDOMINALPAIN", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","abnormalxray",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ABNORMALXRAY", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","ards",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ARDS", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chestpain",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHESTPAIN", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chills",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHILLS", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","conjunctivalinjection",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CONJUNCTIVALINJECTION", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","cough",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_COUGH", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","diarrhea",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DIARRHEA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","dyspnea",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DYSPNEA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","fatigue",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_FATIGUE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","fever",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_FEVER", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","lungfluid",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LUNGFLUID", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","xrayfluid",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_xrayfluid", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","headache",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEADACHE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","arthritis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ARTHRITIS", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","malaise",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_MALAISE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","musclepain",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_MUSCLEPAIN", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","nausea",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NAUSEA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","irritability",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_IRRITABILITY", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","pharyngealexudate",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_PHARYNGEALEXUDATE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","pneumonia",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_PNEUMONIA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","rapidbreathing",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RAPIDBREATHING", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","runningnose",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RUNNINGNOSE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","pharyngitis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_PHARYNGITIS", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","vomiting",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_VOMITING", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","coma",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_COMA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","othersymptoms",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan="3">
			        		<%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_OTHERSYMPTOMS", 40, 2) %>
			        	</td>
			        </tr>
			        <%-- EPIDEMIOLOGICAL DATA --%>
			        <tr class="admin">
			            <td colspan="8"><%=getTran(request,"web","epidemiologicdata",sWebLanguage)%>&nbsp;</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","contactwithcase",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","labcontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LABCONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","respcontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RESPCONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","samplecontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SAMPLECONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","closecontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' width='1%'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CLOSECONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","neighborhoodcontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' width='1%'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NEIGHBORHOOD", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","deadcontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' width='1%'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DEADCONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright''>
			        		<%=getTran(request,"covid","needlecontact",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' width='1%'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NEEDLECONTACT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","healthfacilityvisit",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEALTHFACILITYVISIT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","animalmarketvisit",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan="5">
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ANIMALMARKETVISIT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","socialeventvisited",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SOCIALEVENTVISITED", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2top' colspan="6">
			        		<%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_SOCIALEVENTDETAILS", 80, 2) %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","travel",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_TRAVEL", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2top' colspan="6">
			        		<%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_TRAVELDETAILS", 80, 2) %>
			        	</td>
			        </tr>
			        <%-- ANIMAL CONTACTS --%>
			        <tr class="admin">
			            <td colspan="8"><%=getTran(request,"web","animalcontacts",sWebLanguage)%>&nbsp;</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","bats",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_BATS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","snakes",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SNAKES", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","camels",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CAMELS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","otheranimals",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_OTHERANIMALS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","butchering",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_BUTCHERING", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","sickanimals",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SICKANIMALS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","rawmeat",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RAWMEAT", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","rawmeatinfected",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RAWMEATINFECTED", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <%-- PRE-EXISTING CONDITIONS --%>
			        <tr class="admin">
			            <td colspan="8"><%=getTran(request,"web","preexistingconditions",sWebLanguage)%>&nbsp;</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","tuberculosis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_TUBERCULOSIS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","asplenia",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ASPLENIA", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hepatitis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEPATITIS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","diabetes",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DIABETES", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","immunodeficiciencynonhiv",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_IMMUNODEFICIENCYNONHIV", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hiv",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HIV", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","congenitalsyphilis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SYPHILIS", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","down",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DOWN", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","liverdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIVERDISEASE", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","malignancy",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_MALIGNANCY", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chronicheartfailure",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICHEARTFAILURE", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chroniclungdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICLUNGDISEASE", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","renaldisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RENALDISEASE", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","neurologicdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NEUROLOGICDISEASE", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hypertension",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan='3'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HYPERTENSION", "yesnounknown", sWebLanguage, "") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","otherdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan="7">
			        		<%=SH.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_OTHERDISEASE", 80, 2) %>
			        	</td>
			        </tr>
			        <%-- LIPS Evaluation --%>
			        <tr class="admin">
			            <td colspan="8"><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_LIPSEVAL", sWebLanguage, "onchange='showtests();'")%><%=getTran(request,"web","lipsevaluation",sWebLanguage)%>&nbsp;</td>
			        </tr>
			       	<tr id='test_lips' style='display: none'>
			       		<td colspan='8'>
			       			<table class="list" width="100%" cellspacing="1" cellpadding='0'>
						        <tr>
						            <td class="admin" colspan="10"><%=getTran(request,"web","predisposingcondition",sWebLanguage)%>&nbsp;</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright' width='15%'>
						        		<%=getTran(request,"covid","shock",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_SHOCK", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright' width='15%'>
						        		<%=getTran(request,"covid","aspiration",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_ASPIRATION", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright' width='15%'>
						        		<%=getTran(request,"covid","sepsis",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_SEPSIS", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright' width='15%'>
						        		<%=getTran(request,"covid","pneumonia",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_PNEUMONIA", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright' width='15%'>
						        		<%=getTran(request,"covid","pancreatitis",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_PANCREATITIS", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","braininjury",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_BRAININJURY", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","smokeinhalation",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_SMOKEINHALATION", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","neardrowning",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_NEARDROWNING", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","lungcontusion",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_LUNGCONTUSION", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","multiplefractures",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_MULTIPLEFRACTURES", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						            <td class="admin" colspan="10"><%=getTran(request,"web","highrisksurgery",sWebLanguage)%>&nbsp;</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","orthopedicspine",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_ORTHOSPINE", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","acuteabdomen",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_ACUTEABDOMEN", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","cardiac",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_CARDIAC", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","aorticvascular",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top' colspan='3'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_AORTICVASCULAR", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						            <td class="admin" colspan="10"><%=getTran(request,"web","riskmodifiers",sWebLanguage)%>&nbsp;</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","emergencysurgery",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_EMERGENCYSURGERY", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","alcoholabuse",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_ALCOHOLABUSE", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","obesity",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_OBESITY", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","chemotherapy",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_CHEMOTHERAPY", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","diabetes",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_DIABETES", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","highrespiratoryrate",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_HIGHRESPIRATORYRATE", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","lowoxygensatuartion",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_LOWOXYGENSATURATION", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","highoxygenneed",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_HIGHOXYGENNEED", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","hypoalbuminemia",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_HYPOALBUMINEMIA", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","acidosis",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIPS_ACIDOSIS", "yesno", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						            <td class="admin" colspan="6"><%=getTran(request,"web","scores",sWebLanguage)%>&nbsp;</td>
						            <td class="admin" colspan="4"><%=getTran(request,"web","literature",sWebLanguage)%>&nbsp;</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<img height='14px' src='<%=sCONTEXTPATH%>/_img/icons/icon_info.gif' onclick='javascript:window.open("<%=sCONTEXTPATH%>/util/showImage.jsp?height=400&width=800&file=<%=sCONTEXTPATH%>/_img/lips.png","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'/>
						        		<%=getTran(request,"covid","lipsscore",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<span id='lipsscore' style='font-size: 14px; color: red; font-weight: bold'></span>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","ardsprobability",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<span id='ardsscore' style='font-size: 14px; color: red; font-weight: bold'></span>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","compositeprobability",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<span id='compositescore' style='font-size: 14px; color: red; font-weight: bold'></span>
						        	</td>
						        	<td class='admin2top' colspan='4'>
						        		<li><a href='javascript:window.open("<%=sCONTEXTPATH%>/util/showImage.jsp?height=400&width=800&file=<%=sCONTEXTPATH%>/_img/berlin_<%=sWebLanguage.toLowerCase()%>.png","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'><%=getTran(request,"covid","berlincriteria",sWebLanguage) %></a>
						        		<li><a href='javascript:window.open("https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5431079","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'>Lung Injury Prediction Score in Hospitalized Patients at risk of Acute Respiratory Distress Syndrome</a>, Graciela J Soto et al, Crit Care Med. 2016 Dec; 44(12): 2182-2191
						        		<li><a href='javascript:window.open("https://www.ncbi.nlm.nih.gov/pubmed/20802164","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'>Early identification of patients at risk of acute lung injury: evaluation of lung injury prediction score in a multicenter cohort study</a>, Gajic O et al, Am J Respir Crit Care Med. 2011 Feb 15;183(4):462-70
						        	</td>
						        </tr>
			        		</table>
			        	</td>
			        </tr>
			        <%-- HLH Evaluation --%>
			        <tr class="admin">
			            <td colspan="8"><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_HLHEVAL", sWebLanguage, "onchange='showtests();'")%><%=getTran(request,"web","hlhevaluation",sWebLanguage)%>&nbsp;</td>
			        </tr>
			       	<tr id='test_hlh' style='display: none'>
			       		<td colspan='8'>
			       			<table class="list" width="100%" cellspacing="1" cellpadding='0'>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","hepatomegalia",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEPATOMEGALIA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","splenomegalia",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SPLENOMEGALIA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","hemoglobin",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEMOGLOBIN", "hlh.hemoglobin", sWebLanguage, "onchange='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","leucocytes",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_LEUCOCYTES", "hlh.leucocytes", sWebLanguage, "onchange='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","platelets",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_PLATELETS", "hlh.platelets", sWebLanguage, "onchange='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","ferritin",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_FERRITIN", "hlh.ferritin", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","triglycerides",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_TRIGLYCERIDES", "hlh.triglycerides", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","fibrinogen",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_FIBRINOGEN", "hlh.fibrinogen", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","sgot",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_COVID_SGOT", "hlh.sgot", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","hemophagocytosis",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEMOGAGOCYTOSIS", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","immunosuppression",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top' colspan='3'>
						        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_IMMUNOSUPPRESSION", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
						        	</td>
						        </tr>
						        <tr>
						        	<td class='admin2topright'>
						        		<img height='14px' src='<%=sCONTEXTPATH%>/_img/icons/icon_info.gif' onclick='javascript:window.open("<%=sCONTEXTPATH%>/util/showImage.jsp?height=400&width=800&file=<%=sCONTEXTPATH%>/_img/hlh.png","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'/>
						        		<%=getTran(request,"covid","hscore",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<span id='hscore' style='font-size: 14px; color: red; font-weight: bold'></span>
						        	</td>
						        	<td class='admin2topright'>
						        		<%=getTran(request,"covid","hsrisk",sWebLanguage) %>
						        	</td>
						        	<td class='admin2top'>
						        		<span id='hsrisk' style='font-size: 14px; color: red; font-weight: bold'></span>
						        	</td>
						        	<td class='admin2top' colspan='4'>
										<a href='javascript:window.open("https://www.ncbi.nlm.nih.gov/pubmed/?term=24782338","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'>Development and validation of the HScore, a score for the diagnosis of reactive hemophagocytic syndrome.</a> Fardet L, Galicier L, Lambotte O, Marzac C, Aumont C, Chahwan D, Coppo P, Hejblum G.<br>
										<a href='javascript:window.open("https://www.ncbi.nlm.nih.gov/pubmed/?term=10.1093%2FAJCP%2FAQW076","OpenClinic-Covid","height=600,width=900,toolbar=yes,status=no,scrollbars=yes,resizable=yes,menubar=yes");'>Performances of the H-Score for Diagnosis of Hemophagocytic Lymphohistiocytosis in Adult and Pediatric Patients.</a> Debaugnies F, Mahadeb B, Ferster A, Meuleman N, Rozen L, Demulder A, Corazza F.<br>
						        	</td>
						        </tr>
			    			</table>
			    		</td>
			    	</tr>
			    </table>
			</td>
		</tr>
    </table>
    <table width="100%" class="list" cellspacing="1">
        <tr class="admin">
            <td align="center"><a href="javascript:openPopup('medical/managePrescriptionsPopup.jsp&amp;skipEmpty=1',900,400,'medication');void(0);"><%=getTran(request,"Web.Occup","medwan.healthrecord.medication",sWebLanguage)%></a></td>
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
            <td align="center"><%=getTran(request,"curative","medication.paperprescriptions",sWebLanguage)%> (<%=ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime())%>)</td>
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
                    out.println("<tr class='list"+l+"' id='pp"+paperPrescription.getUid()+"'><td valign='top' width='90px'><img src='_img/icons/icon_delete.png' onclick='deletepaperprescription(\""+paperPrescription.getUid()+"\");'/> <b>"+ScreenHelper.stdDateFormat.format(paperPrescription.getBegin())+"</b></td><td><i>");
                    Vector products =paperPrescription.getProducts();
                    for(int i=0;i<products.size();i++){
                        out.print(products.elementAt(i)+"<br/>");
                    }
                    out.println("</i></td></tr>");
                }
                out.print("</table></td></tr>");
            }
        %>
        <tr>
            <td><a href="javascript:openPopup('medical/managePrescriptionForm.jsp&amp;skipEmpty=1',650,430,'medication');void(0);"><%=getTran(request,"web","medicationpaperprescription",sWebLanguage)%></a></td>
        </tr>
    </table>            
	<%-- BUTTONS --%>
	<%=ScreenHelper.alignButtonsStart()%>
	    <%=getButtonsHtml(request,activeUser,activePatient,accessright,sWebLanguage)%>
	<%=ScreenHelper.alignButtonsStop()%>
	
    <%=ScreenHelper.contextFooter(request)%>
</div>
</form>

<script>  
  function searchEncounter(){
    openPopup("/_common/search/searchEncounter.jsp&ts=<%=getTs()%>&VarCode=encounteruid&VarText=&FindEncounterPatient=<%=activePatient.personid%>");
  }
  
  function showtests(){
	  if(document.getElementById('ITEM_TYPE_COVID_HLHEVAL').checked){
		  document.getElementById('test_hlh').style.display='';
	  }
	  else{
		  document.getElementById('test_hlh').style.display='none';
	  }
	  if(document.getElementById('ITEM_TYPE_COVID_LIPSEVAL').checked){
		  document.getElementById('test_lips').style.display='';
	  }
	  else{
		  document.getElementById('test_lips').style.display='none';
	  }
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

  function calculateBMI(){
	  var _BMI = 0;
	  var heightInputValue = document.getElementById('ITEM_TYPE_BIOMETRY_HEIGHT').value.replace(",",".")*1;
	  var weightInputValue = document.getElementById('ITEM_TYPE_BIOMETRY_WEIGHT').value.replace(",",".")*1;
	
	  if(heightInputValue > 0 && weightInputValue>0){
	      _BMI = (weightInputValue * 10000) / (heightInputValue * heightInputValue);
	      if(_BMI > 100 || _BMI < 5){
	          document.getElementsByName('BMI')[0].value = "";
	      }
	      else{
	          document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      }
	  }
  }
  
  function triage(){
	  if(document.getElementById("ITEM_TYPE_COVID_SIGNSONADMISSION-0").checked && document.getElementById("ITEM_TYPE_COVID_POM3").value*1>=1 && document.getElementById("ITEM_TYPE_COVID_POM3").value>=90){
		  document.getElementById("trassessment").style.display='';
	  }
	  else{
		  document.getElementById("trassessment").style.display='none';
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_SIGNSONADMISSION-1").checked || (document.getElementById("ITEM_TYPE_COVID_POM3").value*1>=10 && document.getElementById("ITEM_TYPE_COVID_POM3").value<94)){
		  document.getElementById("divpom3").innerHTML='<font style="font-size: 12px;color: red;font-weight: bolder"><%=getTranNoLink("web","divpom3",sWebLanguage)%></font>';
		  if(document.getElementById("ITEM_TYPE_COVID_SIGNSONADMISSION-1").checked){
			  document.getElementById("divpom3").innerHTML+='<font style="font-size: 12px;color: red;font-weight: bolder"><%=getTranNoLink("web","divpom3.1",sWebLanguage)%></font>';
		  }
		  else{
			  document.getElementById("divpom3").innerHTML+='<font style="font-size: 12px;color: red;font-weight: bolder"><%=getTranNoLink("web","divpom3.2",sWebLanguage)%></font>';
		  }
	  }
	  else{
		  if((document.getElementById("ITEM_TYPE_COVID_SIGNSONADMISSION-0").checked || document.getElementById("ITEM_TYPE_COVID_SIGNSONADMISSION-1").checked) && document.getElementById("ITEM_TYPE_COVID_POM3").value.length>0){
			  document.getElementById("divpom3").innerHTML='<font style="font-size: 12px;color: red;font-weight: bolder"><%=getTranNoLink("web","divpom3.3",sWebLanguage)%></font>';
		  }
		  else{
			  document.getElementById("divpom3").innerHTML='';
		  }
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_POM3").value*1>=10){
		  document.getElementById("tremergency").style.display='';
	  }
	  if(document.getElementById("temperature").value*1>=38){
		  document.getElementById("ITEM_TYPE_COVID_FEVER-1").checked=true;
	  }
	  else if(document.getElementById("temperature").value*1>=30){
		  document.getElementById("ITEM_TYPE_COVID_FEVER-2").checked=true;
	  }
	  if(<%=activePatient.getAgeInMonths()%><2){
		  if(document.getElementById("respfreq").value*1>60){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-1").checked=true;
		  }
		  else if (document.getElementById("respfreq").value*1>0){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-2").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><12){
		  if(document.getElementById("respfreq").value*1>50){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-1").checked=true;
		  }
		  else if (document.getElementById("respfreq").value*1>0){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-2").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><36){
		  if(document.getElementById("respfreq").value*1>40){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-1").checked=true;
		  }
		  else if (document.getElementById("respfreq").value*1>0){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-2").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><60){
		  if(document.getElementById("respfreq").value*1>30){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-1").checked=true;
		  }
		  else if (document.getElementById("respfreq").value*1>0){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-2").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%>>=60){
		  if(document.getElementById("respfreq").value*1>20){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-1").checked=true;
		  }
		  else if (document.getElementById("respfreq").value*1>0){
			  document.getElementById("ITEM_TYPE_COVID_RAPIDBREATHING-2").checked=true;
		  }
	  }
	  document.getElementById("covidtest").innerHTML="";
	  var milliseconds = Math.abs(new Date('<%=new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date())%>') - new Date(document.getElementById("trandate").value.split("/")[2]+"-"+document.getElementById("trandate").value.split("/")[1]+"-"+document.getElementById("trandate").value.split("/")[0]));
	  var hours = milliseconds/36e5;
	  if(<%=Covid.symptomFreeHours(Integer.parseInt(activePatient.personid), ((TransactionVO)transaction).getUpdateTime())%>-hours>24 && isSymptomFree()){
		  document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","cured",sWebLanguage)%><br/>";
	  }
	  //HLH score
	  var hscore=0;
	  var hsrisk=0;
	  if (document.getElementById("ITEM_TYPE_COVID_HEPATOMEGALIA-1").checked && document.getElementById("ITEM_TYPE_COVID_SPLENOMEGALIA-1").checked){
		  hscore+=38;
	  }
	  else if (document.getElementById("ITEM_TYPE_COVID_HEPATOMEGALIA-1").checked || document.getElementById("ITEM_TYPE_COVID_SPLENOMEGALIA-1").checked){
		  hscore+=23;
	  }
	  var cytopenia=0;
	  if(document.getElementById("ITEM_TYPE_COVID_HEMOGLOBIN").value=="1"){
		  cytopenia++;
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_LEUCOCYTES").value=="1"){
		  cytopenia++;
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_PLATELETS").value=="1"){
		  cytopenia++;
	  }
	  if(cytopenia==3){
		  hscore+=34;
	  }
	  else if(cytopenia==2){
		  hscore+=24;
	  }
	  if (document.getElementById("ITEM_TYPE_COVID_IMMUNOSUPPRESSION-1").checked){
		  hscore+=18;
	  }
	  if (document.getElementById("ITEM_TYPE_COVID_HEMOGAGOCYTOSIS-1").checked){
		  hscore+=35;
	  }
	  if(document.getElementById("temperature").value*1>=39.4){
		  hscore+=49;
	  }
	  else if(document.getElementById("temperature").value*1>=38.4){
		  hscore+=33;
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_FERRITIN").value=="2"){
		  hscore+=35;
	  }	  
	  else if(document.getElementById("ITEM_TYPE_COVID_FERRITIN").value=="3"){
		  hscore+=50;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_TRIGLYCERIDES").value=="2"){
		  hscore+=44;
	  }	  
	  else if(document.getElementById("ITEM_TYPE_COVID_TRIGLYCERIDES").value=="3"){
		  hscore+=64;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_FIBRINOGEN").value=="2"){
		  hscore+=30;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_SGOT").value=="2"){
		  hscore+=19;
	  }	  
	  document.getElementById("hscore").innerHTML=hscore;
	  calculateHScore(hscore);
	  //LIPS score
	  if(document.getElementById("oxygensaturation").value*1>0 && document.getElementById("oxygensaturation").value*1<95){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_LOWOXYGENSATURATION-1").checked=true;
	  }
	  else if(document.getElementById("oxygensaturation").value*1>=95){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_LOWOXYGENSATURATION-0").checked=true;
	  }
	  if(document.getElementById("respfreq").value*1>0 && document.getElementById("respfreq").value*1<=30){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_HIGHRESPIRATORYRATE-1").checked=true;
	  }
	  else if(document.getElementById("respfreq").value*1>30){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_HIGHRESPIRATORYRATE-0").checked=true;
	  }
	  if(document.getElementsByName('BMI')[0].value*1>30){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_OBESITY-1").checked=true;
	  }
	  else if(document.getElementsByName('BMI')[0].value*1>0){
		  document.getElementById("ITEM_TYPE_COVID_LIPS_OBESITY-0").checked=true;
	  }
	  var lipsscore=0;
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_SHOCK-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_ASPIRATION-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_SEPSIS-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_PNEUMONIA-1").checked){
		  lipsscore+=1.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_BRAININJURY-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_SMOKEINHALATION-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_NEARDROWNING-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_LUNGCONTUSION-1").checked){
		  lipsscore+=1.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_MULTIPLEFRACTURES-1").checked){
		  lipsscore+=1.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_ORTHOSPINE-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_ACUTEABDOMEN-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_CARDIAC-1").checked){
		  lipsscore+=2.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_AORTICVASCULAR-1").checked){
		  lipsscore+=3.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_EMERGENCYSURGERY-1").checked){
		  lipsscore+=1.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_ALCOHOLABUSE-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_OBESITY-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_CHEMOTHERAPY-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_DIABETES-1").checked && document.getElementById("ITEM_TYPE_COVID_LIPS_SEPSIS-1").checked){
		  lipsscore-=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_HIGHRESPIRATORYRATE-1").checked){
		  lipsscore+=1.5;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_LOWOXYGENSATURATION-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_HIGHOXYGENNEED-1").checked){
		  lipsscore+=2;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_HYPOALBUMINEMIA-1").checked){
		  lipsscore+=1;
	  }	  
	  if(document.getElementById("ITEM_TYPE_COVID_LIPS_ACIDOSIS-1").checked){
		  lipsscore+=1.5;
	  }	  
	  document.getElementById("lipsscore").innerHTML=lipsscore;
	  ardsscore='';
	  compositescore='';
	  if(lipsscore*1>=1){
		  if(lipsscore*1>12){
			  lipsscore=12;
			  ardsscore='>';
			  compositescore='>';
		  }
		  ardsscore+=calculateARDSScore(lipsscore*1)+'%';
		  compositescore+=calculateCompositeScore(lipsscore*1)+'%';
	  }
	  document.getElementById("ardsscore").innerHTML=ardsscore;
	  document.getElementById("compositescore").innerHTML=compositescore;
  }
  
  function calculateARDSScore(score){
	  return (0.8687*Math.pow(score,1.6208)).toFixed(0);
  }
  function calculateCompositeScore(score){
	  return (7.6013*Math.pow(score,0.8388)).toFixed(0);	  
  }
  function calculateHScore(score){
	    var params = "score="+score;
		var url = "<%=sCONTEXTPATH%>/util/calculateHScore.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			var label = eval('('+resp.responseText+')');
			document.getElementById("hsrisk").innerHTML=label.probability+"%";
		}
		});
  }
  
  function isSymptomFree(){
	  var signs = [
				"ITEM_TYPE_COVID_ABDOMINALPAIN","ITEM_TYPE_COVID_ABNORMALXRAY","ITEM_TYPE_COVID_ARDS",
				"ITEM_TYPE_COVID_CHESTPAIN","ITEM_TYPE_COVID_CHILLS","ITEM_TYPE_COVID_CONJUNCTIVALINJECTION",
				"ITEM_TYPE_COVID_COUGH","ITEM_TYPE_COVID_DIARRHEA","ITEM_TYPE_COVID_DYSPNEA",
				"ITEM_TYPE_COVID_FATIGUE","ITEM_TYPE_COVID_FEVER","ITEM_TYPE_COVID_LUNGFLUID",
				"ITEM_TYPE_COVID_xrayfluid","ITEM_TYPE_COVID_HEADACHE","ITEM_TYPE_COVID_ARTHRITIS",
				"ITEM_TYPE_COVID_MALAISE","ITEM_TYPE_COVID_MUSCLEPAIN","ITEM_TYPE_COVID_NAUSEA",
				"ITEM_TYPE_COVID_IRRITABILITY","ITEM_TYPE_COVID_PHARYNGEALEXUDATE","ITEM_TYPE_COVID_PNEUMONIA",
				"ITEM_TYPE_COVID_RAPIDBREATHING","ITEM_TYPE_COVID_RUNNINGNOSE","ITEM_TYPE_COVID_PHARYNGITIS",
				"ITEM_TYPE_COVID_VOMITING","ITEM_TYPE_COVID_COMA"
				];
	  for(n=0;n<signs.length;n++){
		  if(!document.getElementById(signs[n]+"-2").checked){
			  return false;
		  }
	  }
	  return true;
  }
	document.getElementById('html').style.overflowY='hidden';
	document.getElementById('Juist').style.overflowY='hidden';
    document.getElementById('divcontent').style.height=(document.body.clientHeight-20-document.getElementById('contextHeader').scrollHeight-document.getElementById('header').scrollHeight-document.getElementById('menu').scrollHeight-document.getElementById('divheader').offsetHeight)+'px';

  triage();
  calculateBMI();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        