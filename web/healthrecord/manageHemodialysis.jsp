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
	String accessright="hemodialysis";
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
    
    <table class="list" width="100%" cellspacing="1" cellpadding='0'>
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr valign='top'>
        	<td style='background-color:#DEEAFF;padding: 0px' width='50%'>
        		<table class='list' width='100%' cellspacing="1" cellpadding='0'>
        			<tr class='admin'>
        				<td colspan='2'><%=getTran(request,"web","patientinformation",sWebLanguage)%></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","hemodialysis",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hemodialysis.urgency", "ITEM_TYPE_HEMODIALYSIS_URGENCY", sWebLanguage, true) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","numberofsessionsperweek",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SESSIONSPERWEEK", 2, 0, 7, sWebLanguage) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","accessway",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hemodialysis.access", "ITEM_TYPE_HEMODIALYSIS_ACCESS", sWebLanguage, true) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","artery",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_ARTERY", 40, 1) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","vein",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_VEIN", 40, 1) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","observations",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_OBSERVATIONS", 40, 3) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","nextsessioninfo",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_NEXTSESSIONINFO", 40, 3) %></td>
        			</tr>
        		</table>
        	</td>
        	<td style='background-color:#DEEAFF;padding: 0px' width='50%'>
        		<table class='list' width='100%' cellspacing="1" cellpadding='0'>
        			<tr class='admin'>
        				<td colspan='4'><%=getTran(request,"web","dialysisprescription",sWebLanguage)%></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","baseweight",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BASEWEIGHT", 5, 0, 300, sWebLanguage) %>kg</td>
        				<td class='admin'><%=getTran(request,"web","ufmax",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_UFMAX", 5, 0, 10000, sWebLanguage) %>ml/h</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","bloodpumpflow",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BLOODPUMPFLOW", 5, 0, 10000, sWebLanguage) %>ml/min</td>
        				<td class='admin'><%=getTran(request,"web","dialysisflow",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISFLOW", 5, 0, 10000, sWebLanguage) %>ml/min</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","bathtemperature",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BATHTEMPERATURE", 5, 20, 45, sWebLanguage) %>°C</td>
        				<td class='admin'><%=getTran(request,"web","dialysistime",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISTIMEHOUR", 5, 0, 24, sWebLanguage,"calculatedialysistimes()") %>h
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISTIMEMINUTE", 5, 0, 59, sWebLanguage,"calculatedialysistimes()") %>min (<b><span id='dialysisminutes'></span></b> min)
        				</td>
        			</tr>
        			<tr>
        				<td class='admin' colspan='4'>
   					        <%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hemodialysis.calciparin", "ITEM_TYPE_HEMODIALYSIS_CALCIPARIN", sWebLanguage, true) %></td>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin2' rowspan><%=getTran(request,"web","bolus",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_CALCIPARINBOLUSUI", 5, 0, 10000, sWebLanguage) %>UI&nbsp;&nbsp;
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_CALCIPARINBOLUSML", 5, 0, 10000, sWebLanguage) %>ml
        				</td>
        				<td class='admin2' rowspan><%=getTran(request,"web","pumpmaintenance",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_CALCIPARINPUMPUI", 5, 0, 10000, sWebLanguage) %>UI&nbsp;&nbsp;
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_CALCIPARINPUMPML", 5, 0, 10000, sWebLanguage) %>ml
        				</td>
        			</tr>
        			<tr>
        				<td class='admin' colspan='4'>
   					        <%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hemodialysis.fraxiparin", "ITEM_TYPE_HEMODIALYSIS_FRAXIPARIN", sWebLanguage, true) %></td>
        				</td>
        			</tr>
        			<tr>
        				<td class='admin2'><%=getTran(request,"web","dose",sWebLanguage)%></td>
        				<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_FRAXIPARINDOSE", 40, 1) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","generator",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_GENERATOR", "hemodialysis.generator", sWebLanguage,"") %></td>
        				<td class='admin'><%=getTran(request,"web","dialyser",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSER", "hemodialysis.dialyser", sWebLanguage,"") %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","dialysisbath",sWebLanguage)%></td>
        				<td class='admin2' colspan='3'>
        					Na+ <%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BATH_NA", 5, 0, 1000, sWebLanguage) %>&nbsp;&nbsp;
        					K+ <%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BATH_K", 5, 0, 1000, sWebLanguage) %>&nbsp;&nbsp;
        					Ca2+ <%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BATH_CA", 5, 0, 1000, sWebLanguage) %>&nbsp;&nbsp;
        					<%=getTran(request,"web","bicarbonates",sWebLanguage)%> <%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_BATH_BICARBONATES", 5, 0, 1000, sWebLanguage) %>
        				</td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr class='admin'>
        	<td colspan='2'><center><%=getTran(request,"web","sessionsurveillance",sWebLanguage)%></center></td>
        </tr>
        <tr valign='top'>
        	<td style='background-color:#DEEAFF;padding: 0px' width='50%'>
        		<table class='list' width='100%' cellspacing="1" cellpadding='0'>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","inf",sWebLanguage)%></td>
        				<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_INF1", 40, 1) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","begin",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISBEGINHOUR", 5, 0, 24, sWebLanguage,"") %>h
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISBEGINMINUTE", 5, 0, 59, sWebLanguage,"") %>min
        				</td>
        				<td class='admin'><%=getTran(request,"web","dialysisduration",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISDURATIONHOUR", 5, 0, 24, sWebLanguage,"calculatedialysistimes()") %>h
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISDURATIONMINUTE", 5, 0, 59, sWebLanguage,"calculatedialysistimes()") %>min (<b><span id='dialysisdurationminutes'></span></b> min)
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","actualweight",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_ACTUALWEIGHT", 5, 0, 300, sWebLanguage) %>kg</td>
        				<td class='admin'><%=getTran(request,"web","dryweight",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DRYWEIGHT", 5, 0, 300, sWebLanguage) %>kg</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","PPID",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PPID", 5, 0, 10000, sWebLanguage) %>kg + <%=getTran(request,"web","forfait",sWebLanguage)%> <%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PPIDFORFAIT", 5, 0, 10000, sWebLanguage) %>ml
        				</td>
        				<td class='admin'><%=getTran(request,"web","programmeduf",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PROGRAMMEDUF", 5, 0, 10000, sWebLanguage) %>ml</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","other",sWebLanguage)%></td>
        				<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_OTHER", 40, 1) %></td>
        			</tr>
        		</table>
        	</td>
        	<td style='background-color:#DEEAFF;padding: 0px' width='50%'>
        		<table class='list' width='100%' cellspacing="1" cellpadding='0'>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","inf",sWebLanguage)%></td>
        				<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_INF2", 40, 1) %></td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","end",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISENDHOUR", 5, 0, 24, sWebLanguage,"") %>h
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIALYSISENDMINUTE", 5, 0, 59, sWebLanguage,"") %>min
        				</td>
        				<td class='admin'><%=getTran(request,"web","realtime",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_REALDURATIONHOUR", 5, 0, 24, sWebLanguage,"calculatedialysistimes()") %>h
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_REALDURATIONMINUTE", 5, 0, 59, sWebLanguage,"calculatedialysistimes()") %>min (<b><span id='realdurationminutes'></span></b> min)
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","bloodpressurebegin",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SYSTOLICPRESSUREBEGIN", 5, 0, 400, sWebLanguage,"") %>/<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIASTOLICPRESSUREBEGIN", 5, 0, 300, sWebLanguage,"") %>mmHg
        				</td>
        				<td class='admin'><%=getTran(request,"web","pulse",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PULSEBEGIN", 5, 0, 300, sWebLanguage,"") %>bpm
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","bloodpressureend",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SYSTOLICPRESSUREEND", 5, 0, 400, sWebLanguage,"") %>/<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_DIASTOLICPRESSUREEND", 5, 0, 300, sWebLanguage,"") %>mmHg
        				</td>
        				<td class='admin'><%=getTran(request,"web","pulse",sWebLanguage)%></td>
        				<td class='admin2'>
        					<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PULSEEND", 5, 0, 300, sWebLanguage,"") %>bpm
        				</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","totaluf",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_TOTALUF", 5, 0, 10000, sWebLanguage) %>ml</td>
        				<td class='admin'><%=getTran(request,"web","purifiedvolume",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_PURIFIEDVOLUME", 5, 0, 10000, sWebLanguage) %>L</td>
        			</tr>
        			<tr>
        				<td class='admin'><%=getTran(request,"web","weightendsession",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_WEIGHTENDSESSION", 5, 0, 10000, sWebLanguage) %>kg</td>
        				<td class='admin'><%=getTran(request,"web","generatordesinfection",sWebLanguage)%></td>
        				<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hemodialysis.generatordesinfection", "ITEM_TYPE_HEMODIALYSIS_GENERATORDESINFECTION", sWebLanguage, true) %></td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr>
        	<td colspan='2'>
        		<table width='100%'>
        			<tr class='admin'>
        				<td><center><%=getTran(request,"hemodialysis","hour",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","bp",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","atc",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","dsg",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","pv",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","pa",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","ptm",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","ufh",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","uft",sWebLanguage)%></center></td>
        				<td><center><%=getTran(request,"hemodialysis","remarks",sWebLanguage)%></center></td>
        			</tr>
        			<%
        				for(int l=1;l<9;l++){
        			%>
        			<tr>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_HOUR"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_TA"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_ATC"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_DSG"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_PV"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_PA"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_PTM"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_UFH"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_UFT"+l, 5) %></center></td>
        				<td class='admin2'><center><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HEMODIALYSIS_SURV_REMARK"+l, 20, 1) %></center></td>
        			</tr>
        			<%
        				}
        			%>
        		</table>
        	</td>
        </tr>
    </table>
    <table width="100%" class="list" cellspacing="1">
        <tr class="admin">
            <td align="center" width='50%'><a href="javascript:openPopup('medical/managePrescriptionsPopup.jsp&amp;skipEmpty=1',900,400,'medication');void(0);"><%=getTran(request,"Web.Occup","medwan.healthrecord.medication",sWebLanguage)%></a></td>
            <td align="center"><%=getTran(request,"curative","medication.paperprescriptions",sWebLanguage)%> (<%=ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime())%>)</td>
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
        <%
            Vector paperprescriptions = PaperPrescription.find(activePatient.personid,"",ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),ScreenHelper.stdDateFormat.format(((TransactionVO)transaction).getUpdateTime()),"","DESC");
	        out.print("<td><table width='100%'>");
            if(paperprescriptions.size()>0){
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
            }
            %>
            <tr>
                <td><a href="javascript:openPopup('medical/managePrescriptionForm.jsp&amp;skipEmpty=1',650,430,'medication');void(0);"><%=getTran(request,"web","medicationpaperprescription",sWebLanguage)%></a></td>
            </tr>
            <%
            out.print("</table></td>");
        %>
	    <%-- DIAGNOSES --%>
	    <%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncodingWide.jsp"),pageContext);%>            
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
  
	function calculatedialysistimes(){
		document.getElementById("dialysisminutes").innerHTML=(document.getElementById("ITEM_TYPE_HEMODIALYSIS_DIALYSISTIMEHOUR").value*60)+(document.getElementById("ITEM_TYPE_HEMODIALYSIS_DIALYSISTIMEMINUTE").value*1);
		document.getElementById("dialysisdurationminutes").innerHTML=(document.getElementById("ITEM_TYPE_HEMODIALYSIS_DIALYSISDURATIONHOUR").value*60)+(document.getElementById("ITEM_TYPE_HEMODIALYSIS_DIALYSISDURATIONMINUTE").value*1);
		document.getElementById("realdurationminutes").innerHTML=(document.getElementById("ITEM_TYPE_HEMODIALYSIS_REALDURATIONHOUR").value*60)+(document.getElementById("ITEM_TYPE_HEMODIALYSIS_REALDURATIONMINUTE").value*1);
	}

	calculatedialysistimes();
</script>
  
<%=writeJSButtons("transactionForm","saveButton")%>
  
        