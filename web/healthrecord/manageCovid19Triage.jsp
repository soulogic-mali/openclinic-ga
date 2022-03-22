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
	String accessright="surveillance.covid19.triage";
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
    <%
    	Iterator<ItemVO> items = ((TransactionVO)transaction).getItems().iterator();
    	while(items.hasNext()){
    		ItemVO item = items.next();
    	}
    %>
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
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			            <td class='admin' width='40%'>
			            	<div id='covidtest' style='color: red;font-size: 14px'></div>
			            </td>
			            <td class='admin' width='40%'>
			            	<div id='covidcare' style='color: red;font-size: 14px'></div>
			            </td>
			    	</tr>
			        <tr class='admin'>
						<td colspan='3'><%=getTran(request,"examination","1211",sWebLanguage) %></td>
			        </tr>
        		</table>
        	</td>
        </tr>
    </table>
</div>
<div id='divcontent' style="overflow-y: scroll;">    
    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <%-- VITAL SIGNS --%>
        <tr>
            <td class="admin" colspan='1'>
            	<%=getTran(request,"Web.Occup","rmh.vital.signs",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2" colspan="7">
            	<table width="100%">
            		<tr>
            			<td nowrap><b><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%>:</b></td><td nowrap><input id='temperature' type="text" class="text" <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE")%> name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE" property="value"/>" onBlur="triage();if(isNumber(this)){if(!checkMinMaxOpen(25,45,this)){alertDialog('Web.Occup','medwan.common.unrealistic-value');}}" size="5"/> °C</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_HEIGHT")%> id="ITEM_TYPE_BIOMETRY_HEIGHT" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT" property="value"/>" onBlur="calculateBMI();"/> cm</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClickMini("ITEM_TYPE_BIOMETRY_WEIGHT")%> id="ITEM_TYPE_BIOMETRY_WEIGHT" class="text" type="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT" property="value"/>" onBlur="calculateBMI();"/> kg</td>
            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.bmi",sWebLanguage)%>:</b></td><td nowrap><input id="BMI" class="text" type="text" size="5" name="BMI" readonly /></td>
            		</tr>
	                <tr>
			            <td nowrap><b><%=getTran(request,"openclinic.chuk","sao2",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION")%> type="text" id="sao2" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_SATURATION" property="value"/>" onblur="triage();"/> %</td>
			            <td nowrap><b><%=getTran(request,"web","abdomencircumference",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_ABDOMENCIRCUMFERENCE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ABDOMENCIRCUMFERENCE" property="value"/>"/> cm</td>
			            <td nowrap><b><%=getTran(request,"web","fhr",sWebLanguage)%>:</b></td><td nowrap><input <%=setRightClick(session,"ITEM_TYPE_FOETAL_HEARTRATE")%> type="text" class="text" size="5" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_FOETAL_HEARTRATE" property="value"/>"/></td>
			            <td colspan='2'/>
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
        	<td class='admin2top' colspan="2" width='25%'>
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_FEVER", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","fever",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan="2" width='25%'>
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_COUGH", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","cough",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan="2" width='25%'>
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_DYSPNEA", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","dyspnea",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan="2" width='25%'>
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_RUNNINGNOSE", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","runningnose",sWebLanguage) %>
        	</td>
        </tr>
        <tr>
        	<td class='admin2top' colspan="2">
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_OLDAGE", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","oldage",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan="2">
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","severepulmonarycomplaints",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan="4">
        		<%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_COVID_TESTPOSITIVE", sWebLanguage, "onchange='triage();'") %>
        		<%=getTran(request,"covid","positivetest",sWebLanguage) %>
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
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_TUBERCULOSIS", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","asplenia",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ASPLENIA", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","hepatitis",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEPATITIS", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","diabetes",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DIABETES", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        </tr>
        <tr>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","immunodeficiciencynonhiv",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_IMMUNODEFICIENCYNONHIV", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","hiv",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HIV", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","congenitalsyphilis",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SYPHILIS", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","down",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DOWN", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        </tr>
        <tr>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","liverdisease",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIVERDISEASE", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","malignancy",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_MALIGNANCY", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","chronicheartfailure",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICHEARTFAILURE", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","chroniclungdisease",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICLUNGDISEASE", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        </tr>
        <tr>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","renaldisease",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RENALDISEASE", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","neurologicdisease",sWebLanguage) %>
        	</td>
        	<td class='admin2top'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NEUROLOGICDISEASE", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
        	</td>
        	<td class='admin2topright'>
        		<%=getTran(request,"covid","hypertension",sWebLanguage) %>
        	</td>
        	<td class='admin2top' colspan='3'>
        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HYPERTENSION", "yesnounknown", sWebLanguage, "onchange='triage();'") %>
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
    <%-- DIAGNOSES --%>
    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncodingNoRFE.jsp"),pageContext);%>            
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
    	  checkWeightForHeight(heightInputValue,weightInputValue);
	  }
  }
  
  function triage(){
	  if(<%=activePatient.getAge()%>>=70){
		  document.getElementById("ITEM_TYPE_COVID_OLDAGE").checked=true;
	  }
	  else{
		  document.getElementById("ITEM_TYPE_COVID_OLDAGE").checked=false;
	  }
	  if(document.getElementById("temperature").value*1>=38){
		  document.getElementById("ITEM_TYPE_COVID_FEVER").checked=true;
	  }
	  else if(document.getElementById("temperature").value*1>=30){
		  document.getElementById("ITEM_TYPE_COVID_FEVER").checked=false;
	  }
	  if(<%=activePatient.getAgeInMonths()%><1){
		  if(document.getElementById("respfreq").value*1>60){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><6){
		  if(document.getElementById("respfreq").value*1>50){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><12){
		  if(document.getElementById("respfreq").value*1>46){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><48){
		  if(document.getElementById("respfreq").value*1>30){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><60){
		  if(document.getElementById("respfreq").value*1>25){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%><144){
		  if(document.getElementById("respfreq").value*1>20){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  else if(<%=activePatient.getAgeInMonths()%>>=144){
		  if(document.getElementById("respfreq").value*1>16){
			  document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked=true;
			  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
		  }
	  }
	  if(document.getElementById("sao2").value*1>1 && document.getElementById("sao2").value*1<90){
		  document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked=true;
	  }

	  document.getElementById("covidtest").innerHTML="";
	  document.getElementById("covidcare").innerHTML="";
	  //First check if test needed
	  if(document.getElementById("ITEM_TYPE_COVID_TESTPOSITIVE").checked){
		  document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patienttestedpositive",sWebLanguage)%><br/>";
	  }
	  else{
		  var suspected =	document.getElementById("ITEM_TYPE_COVID_FEVER").checked &&
		  					(document.getElementById("ITEM_TYPE_COVID_COUGH").checked ||
		  							document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked);
		  if(suspected){
			  document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patientsuspected",sWebLanguage)%><br/>";
		  }
		  var musttest = 	document.getElementById("ITEM_TYPE_COVID_OLDAGE").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_TUBERCULOSIS-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_ASPLENIA-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_HEPATITIS-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_DIABETES-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_IMMUNODEFICIENCYNONHIV-1").checked||
		  					document.getElementById("ITEM_TYPE_COVID_HIV-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_SYPHILIS-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_DOWN-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_LIVERDISEASE-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_MALIGNANCY-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_CHRONICHEARTFAILURE-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_CHRONICLUNGDISEASE-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_RENALDISEASE-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_NEUROLOGICDISEASE-1").checked ||
		  					document.getElementById("ITEM_TYPE_COVID_HYPERTENSION-1").checked;
		  if(suspected && musttest){
			  document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","performtest",sWebLanguage)%><br/>";
		  }
		  else{
			  document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","donotperformtest",sWebLanguage)%><br/>";
		  }
	  }
	  if(document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS").checked){
		  document.getElementById("covidcare").innerHTML+="<%=getTranNoLink("covid","admitpatient",sWebLanguage)%><br/>";
	  }
	  else{
		  if(	document.getElementById("ITEM_TYPE_COVID_FEVER").checked ||
				document.getElementById("ITEM_TYPE_COVID_DYSPNEA").checked ||
				document.getElementById("ITEM_TYPE_COVID_COUGH").checked ||
				document.getElementById("ITEM_TYPE_COVID_RUNNINGNOSE").checked
		  ){
			  document.getElementById("covidcare").innerHTML+="<%=getTranNoLink("covid","stayhome",sWebLanguage)%><br/>";
		  }
		  else{
			  document.getElementById("covidcare").innerHTML+="<%=getTranNoLink("covid","nomeasures",sWebLanguage)%><br/>";
		  }
	  }
  }
	document.getElementById('html').style.overflowY='hidden';
	document.getElementById('Juist').style.overflowY='hidden';
    document.getElementById('divcontent').style.height=(document.body.clientHeight-20-document.getElementById('contextHeader').scrollHeight-document.getElementById('header').scrollHeight-document.getElementById('menu').scrollHeight-document.getElementById('divheader').offsetHeight)+'px';

  triage();
  calculateBMI();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        