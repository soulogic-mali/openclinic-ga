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
    		System.out.println(item.getType()+" = "+item.getValue());
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
			            <td class="admin" nowrap width="<%=sTDAdminWidth%>">
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
        <%-- TRIAGE SIGNS --%>
        <tr>
            <td class="admin" colspan='1'>
            	<%=getTran(request,"Web.Occup","entry.signs",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2" colspan="7">
            	<table width="100%">
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage) %>
			        	</td>
	            		<td class='admin2top'>
	            			<input id="respfreq" type="text" class="text" onkeyup='pretriage();' name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY" property="value"/>" size="5"/> /min
	            		</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","feverpast14days",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_FEVERPAST14DAYS", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","cough",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_COUGH", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","shortnessofbreath",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DYSPNEA", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"openclinic.chuk","obstructedbreathing",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_OBSTRUCTEDBREATHING", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","severepulmonarycomplaints",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","centralsyanosis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CENTRALCYANOSIS", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","shock",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SHOCK", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"openclinic.chuk","coma",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_COMA", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","convulsions",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan='5'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CONVULSIONS", "yesno", sWebLanguage, "onclick='pretriage()'") %>
			        	</td>
			        </tr>
            	</table>
            </td>
        </tr>
        <tr id='trpom1' style='display: none'>
            <td class="admin" colspan='1'>
            	<%=getTran(request,"Web.Occup","pulseoximetry",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2" colspan="2">
            	<%=SH.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_POM1", 5, sWebLanguage,"pretriage();")%>%
            <td class="admin2" colspan="5">
            	<div id='divpom1'></div>
            </td>
        </tr>
        <tr id='trtriage' style='display: none'>
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
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%>:</b></td>
			            			<td nowrap><input id="sbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> / <input id="dbpr" <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT" property="value"/>" onblur="setBP(this,'sbpr','dbpr');"> mmHg</td>
			            			<td nowrap><b><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.frequence-cardiaque",sWebLanguage)%>:</b></td>
			            			<td nowrap><input <%=setRightClick(session,"ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY")%> type="text" class="text" size="3" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="itemId"/>]>.value" value="<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_HEARTH_FREQUENCY" property="value"/>" onblur="setHF(this);"> /min</td>
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
			        		<%=getTran(request,"covid","fever",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_FEVER", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","runningnose",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RUNNINGNOSE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","oldage",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_OLDAGE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","positivetest",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_TESTPOSITIVE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
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
			        		<%=getTran(request,"covid","diarrhea",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DIARRHEA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","fatigue",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_FATIGUE", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
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
			        		<%=getTran(request,"covid","lungfluid",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LUNGFLUID", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","pneumonia",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_PNEUMONIA", "yesnounknown", sWebLanguage, "onclick='triage()'") %>
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
			        		<%=getTran(request,"covid","othersymptoms",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan="5">
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
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_TUBERCULOSIS", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","asplenia",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_ASPLENIA", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hepatitis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HEPATITIS", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","diabetes",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DIABETES", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","immunodeficiciencynonhiv",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_IMMUNODEFICIENCYNONHIV", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hiv",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HIV", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","congenitalsyphilis",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SYPHILIS", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","down",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_DOWN", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","liverdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_LIVERDISEASE", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","malignancy",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_MALIGNANCY", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chronicheartfailure",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICHEARTFAILURE", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","chroniclungdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_CHRONICLUNGDISEASE", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","renaldisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_RENALDISEASE", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","neurologicdisease",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_NEUROLOGICDISEASE", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        	<td class='admin2topright'>
			        		<%=getTran(request,"covid","hypertension",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top' colspan='3'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_HYPERTENSION", "yesnounknown", sWebLanguage, "onclick='triage();'") %>
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
			        <%-- SIGNS DEVELOPED DURING ASSESSMENT --%>
			        <tr class="admin">
			            <td colspan="8"><%=getTran(request,"web","signsdevelopedduringassessment",sWebLanguage)%>&nbsp;</td>
			        </tr>
			        <tr>
			        	<td class='admin2topright' colspan="7">
			        		<%=getTran(request,"covid","entry.signs",sWebLanguage) %>
			        	</td>
			        	<td class='admin2top'>
			        		<%=SH.writeDefaultToggle(null, (TransactionVO)transaction, "ITEM_TYPE_COVID_SIGNSDURINGASSESSMENT", "yesno", sWebLanguage, "onclick='triage();'") %>
			        	</td>
			        </tr>
        		</table>
        	</td>
        </tr>
        <tr id='trpom2' style='display: none'>
            <td class="admin" colspan='1'>
            	<%=getTran(request,"Web.Occup","pulseoximetry",sWebLanguage)%>&nbsp;
            </td>
            <td class="admin2" colspan="2">
            	<%=SH.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_COVID_POM2", 5, sWebLanguage, "triage();") %>%
        	</td>
            <td class="admin2" colspan="5">
            	<div id='divpom2'></div>
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
  
  	function pretriage(){
  		document.getElementById("covidcare").innerHTML='';
  		document.getElementById("covidtest").innerHTML='';
  		document.getElementById("divpom1").innerHTML='';
	  	bAdmit=false;
	  	bEmergencySigns=document.getElementById("ITEM_TYPE_COVID_OBSTRUCTEDBREATHING-1").checked || document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS-1").checked || document.getElementById("ITEM_TYPE_COVID_CENTRALCYANOSIS-1").checked || document.getElementById("ITEM_TYPE_COVID_SHOCK-1").checked || document.getElementById("ITEM_TYPE_COVID_COMA-1").checked || document.getElementById("ITEM_TYPE_COVID_CONVULSIONS-1").checked;
	  	bSigns=document.getElementById("ITEM_TYPE_COVID_FEVERPAST14DAYS-1").checked || document.getElementById("ITEM_TYPE_COVID_COUGH-1").checked || document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked;
	  	if(!bSigns){
	  	  	if(<%=activePatient.getAgeInMonths()%>>=180){
	  		  	bSigns=document.getElementById("respfreq").value*1>22;
		  	}
	  	  	else if(<%=activePatient.getAgeInMonths()%>>=60){
	  		  	bSigns=document.getElementById("respfreq").value*1>30;
		  	}
	  	  	else if(<%=activePatient.getAgeInMonths()%>>=12){
	  		  	bSigns=document.getElementById("respfreq").value*1>40;
		  	}
	  	  	else if(<%=activePatient.getAgeInMonths()%>>=2){
	  		  	bSigns=document.getElementById("respfreq").value*1>50;
		  	}
	  	  	else if(<%=activePatient.getAgeInMonths()%>>0){
	  		  	bSigns=document.getElementById("respfreq").value*1>60;
		  	}
	  	}
	  	if(document.getElementById("ITEM_TYPE_COVID_POM1").value.length==0){
		  	var bGiveOxygen=false;
	  	  	if(bSigns||bEmergencySigns){
				var msg='<%=getTran(request,"covid","checkoxygensaturation",sWebLanguage)%>';
	  			if(bEmergencySigns){
		  			msg+=' + <%=getTran(request,"covid","giveoxygen",sWebLanguage)%>';
	  			}
	  			document.getElementById("divpom1").innerHTML='<font style="font-size: 12px;color: red;font-weight: bolder">'+msg+'</font>';
	  			document.getElementById("trpom1").style.display='';
				hideTriage();			  
	  	  	}
	  	  	else{
	  			document.getElementById("trpom1").style.display='none';
	  			showTriage();
	  	  	}
	  	}
	  	else{
		  	document.getElementById("trpom1").style.display='';
  			var suspected =	document.getElementById("ITEM_TYPE_COVID_FEVERPAST14DAYS-1").checked &&
			(document.getElementById("ITEM_TYPE_COVID_COUGH-1").checked ||
			document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked);
		  	//Evaluate pom1 value
		  	if(document.getElementById("ITEM_TYPE_COVID_POM1").value*1<94 || bEmergencySigns){
			  	bAdmit=true;
				var msg='<img height="16px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_blinkwarning.gif"/> <%=getTran(request,"covid","admitpatient",sWebLanguage)%>';
	  			msg+=' + <%=getTran(request,"covid","giveoxygen",sWebLanguage)%>';
	  			document.getElementById("divpom1").innerHTML='<font style="font-size: 12px;color: red;font-weight: bolder">'+msg+'</font>';
	  			document.getElementById("trpom1").style.display='';
	  			if(suspected){
	  			  	document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patientsuspected",sWebLanguage)%><br/>";
	  			}
	  			if(document.getElementById("ITEM_TYPE_COVID_POM1").value*1<94){
	  				document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","performtest",sWebLanguage)%><br/>";
	  			}
				hideTriage();			  
		  	}
		  	else{
  				if(suspected){
  			  		document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patientsuspected",sWebLanguage)%><br/>";
  				}
				showTriage();			  
		  	}
	  	}
	  	if(bAdmit){
  		  	document.getElementById("covidcare").innerHTML+="<img height='14px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/icon_blinkwarning.gif'/> <%=getTranNoLink("covid","admitpatient",sWebLanguage)%><br/>";
	  	}
  	}
  
    function showTriage(){
  	  	document.getElementById('trtriage').style.display='';
  	  	triage();
    }
    
    function hideTriage(){
  	  	document.getElementById('trtriage').style.display='none';
  		document.getElementById("trpom2").style.display='none';
    }
    
    function triage(){
    	bAdmit=false;
  	  	if(<%=activePatient.getAge()%>>=70){
		  	document.getElementById("ITEM_TYPE_COVID_OLDAGE-1").checked=true;
	  	}
	  	else{
		  	document.getElementById("ITEM_TYPE_COVID_OLDAGE-2").checked=true;
	  	}
		if(document.getElementById("temperature").value*1>=38){
		 	document.getElementById("ITEM_TYPE_COVID_FEVERPAST14DAYS-1").checked=true;
		 	document.getElementById("ITEM_TYPE_COVID_FEVER-1").checked=true;
		}
		else if(document.getElementById("temperature").value*1>=1){
		 	document.getElementById("ITEM_TYPE_COVID_FEVER-2").checked=true;
		}
		if(<%=activePatient.getAgeInMonths()%><1){
		 	if(document.getElementById("respfreq").value*1>60){
		  		document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
		 	}
		}
		else if(<%=activePatient.getAgeInMonths()%><6){
		 	if(document.getElementById("respfreq").value*1>50){
		  		document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
		 	}
		}
  	  	else if(<%=activePatient.getAgeInMonths()%><12){
  		  	if(document.getElementById("respfreq").value*1>46){
  			  	document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
  		  	}
  	  	}
  	  	else if(<%=activePatient.getAgeInMonths()%><48){
  		  	if(document.getElementById("respfreq").value*1>30){
  			  	document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
  		  	}
  	  	}
  	  	else if(<%=activePatient.getAgeInMonths()%><60){
  		  	if(document.getElementById("respfreq").value*1>25){
  			  	document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
  		  	}
  	  	}
  	  	else if(<%=activePatient.getAgeInMonths()%><144){
  		  	if(document.getElementById("respfreq").value*1>20){
  			  	document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
  		  	}
  	  	}
  	  	else if(<%=activePatient.getAgeInMonths()%>>=144){
  		  	if(document.getElementById("respfreq").value*1>16){
  			  	document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked=true;
  		  	}
  	  	}

  	  	document.getElementById("covidtest").innerHTML="";
  	  	document.getElementById("covidcare").innerHTML="";
  	  	//First check if test needed
  	  	if(document.getElementById("ITEM_TYPE_COVID_TESTPOSITIVE-1").checked){
  		 	 document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patienttestedpositive",sWebLanguage)%><br/>";
  	  	}
  	  	else{
  			var suspected =	document.getElementById("ITEM_TYPE_COVID_FEVERPAST14DAYS-1").checked &&
  		  					(document.getElementById("ITEM_TYPE_COVID_COUGH-1").checked ||
  		  					document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked);
  		  	if(suspected){
  			  	document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","patientsuspected",sWebLanguage)%><br/>";
  		  	}
  		  	var musttest = 	document.getElementById("ITEM_TYPE_COVID_OLDAGE-1").checked ||
  		  					document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS-1").checked ||
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
  		  					document.getElementById("ITEM_TYPE_COVID_HYPERTENSION-1").checked||
  		  					document.getElementById("ITEM_TYPE_COVID_POM1").value*1<94;
  		  	if(suspected && musttest){
  			  	document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","performtest",sWebLanguage)%><br/>";
  		  	}
  		  	else{
  			  	document.getElementById("covidtest").innerHTML+="<%=getTranNoLink("covid","donotperformtest",sWebLanguage)%><br/>";
  		  	}
  	  	}
  	  	if(document.getElementById("ITEM_TYPE_COVID_SEVEREPULMONARYCOMPLAINTS-1").checked){
  		  	bAdmit=true;
  	  	}
  	  	else{
  		  	if(	document.getElementById("ITEM_TYPE_COVID_FEVER-1").checked ||
  				document.getElementById("ITEM_TYPE_COVID_DYSPNEA-1").checked ||
 				document.getElementById("ITEM_TYPE_COVID_COUGH-1").checked ||
  				document.getElementById("ITEM_TYPE_COVID_RUNNINGNOSE-1").checked
  		  	){
  			  	document.getElementById("covidcare").innerHTML+="<%=getTranNoLink("covid","stayhome",sWebLanguage)%><br/>";
  		  	}
  		  	else{
  			  	document.getElementById("covidcare").innerHTML+="<%=getTranNoLink("covid","nomeasures",sWebLanguage)%><br/>";
  		  	}
  	  	}
  	  	if(document.getElementById("trtriage").style.display=='' && document.getElementById("ITEM_TYPE_COVID_SIGNSDURINGASSESSMENT-1").checked){
  			document.getElementById("trpom2").style.display='';
  			if(document.getElementById("ITEM_TYPE_COVID_POM2").value*1>1 && document.getElementById("ITEM_TYPE_COVID_POM2").value*1<94){
  				document.getElementById("divpom2").innerHTML='<font style="font-size: 12px;color: red;font-weight: bolder"><img height="16px" style="vertical-align: middle" src="<%=sCONTEXTPATH%>/_img/icons/icon_blinkwarning.gif"/> <%=getTranNoLink("covid","admitpatient",sWebLanguage)%></font>';
				bAdmit=true;
  			}
  			else{
  				document.getElementById("divpom2").innerHTML="";
  			}
  	  	}
  	  	else{
  			document.getElementById("trpom2").style.display='none';
  	  	}
	  	if(bAdmit){
  		  	document.getElementById("covidcare").innerHTML="<img height='14px' style='vertical-align: middle' src='<%=sCONTEXTPATH%>/_img/icons/icon_blinkwarning.gif'/> <%=getTranNoLink("covid","admitpatient",sWebLanguage)%><br/>";
	  	}
    }
	document.getElementById('html').style.overflowY='hidden';
	document.getElementById('Juist').style.overflowY='hidden';
    document.getElementById('divcontent').style.height=(document.body.clientHeight-20-document.getElementById('contextHeader').scrollHeight-document.getElementById('header').scrollHeight-document.getElementById('menu').scrollHeight-document.getElementById('divheader').offsetHeight)+'px';

    pretriage();
	triage();
	calculateBMI();
	
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        