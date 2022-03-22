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
	String accessright="clefs.children";
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
    
    private String writeDiag(int n,int rows,HttpServletRequest request,Object transaction,String sWebLanguage){
    	return "<td class='admin2' id='cb.diag."+n+"' style='border: 1px solid;text-align: center' rowspan='"+rows+"'><b>"+getTran(request,"web","clefs.child.diag"+n,sWebLanguage)+"</b><br/>"+SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_DIAG"+n, "onchange='checkSymptoms()'")+"<i>"+getTran(request,"web","accepteddiagnosis",sWebLanguage)+"</i></td>";
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
    
    <table width="100%" cellspacing="1" cellpadding='0'>
        <%-- DATE --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="4">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr>
        	<td width='25%' valign='top'>
        		<table width='100%' cellspacing='0' cellpadding='2'>
        			<tr class='admin'>
        				<td colspan='2'><%=getTran(request,"web","generalsymptoms",sWebLanguage) %></td>
        			</tr>
        			<% for(int n=1;n<13;n++){ %>
	        			<tr>	
							<td class='admin2' width='1px' id='cb.symgen.<%=n%>'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMGEN"+n, "onchange='checkSymptoms()'") %></td>
							<td class='admin2'><%=getTran(request,"web","clefs.children.symgen"+n,sWebLanguage) %></td>
	        			</tr>
        			<% } %>
        			<tr><td colspan='2'><img width='100%' src='<%=sCONTEXTPATH%>/_img/clefs_children.png'></td></tr>
        		</table>
        	</td>
        	<td width='75%' valign='top'>
        		<table width='100%' cellspacing='0' cellpadding='2'>
        			<tr class='admin'>
        				<td width='66%' colspan='2'><%=getTran(request,"web","specificsymptoms",sWebLanguage) %></td>
        				<td ><center><%=getTran(request,"web","diagnosis",sWebLanguage) %></center></td>
        			</tr>
        			<tr>
						<td class='admin2' style='border-bottom: 1px solid' id='cb.symspec.1' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC1", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec1",sWebLanguage) %></td>
						<%=writeDiag(1,1, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' style='border-bottom: 1px solid;border-top: 1px solid' id='cb.symspec.2' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC2", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid;border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec2",sWebLanguage) %></td>
						<%=writeDiag(2,1, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.3' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC3", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec3",sWebLanguage) %></td>
						<%=writeDiag(3,2, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.4' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC4", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec4",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.5' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC5", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec5",sWebLanguage) %></td>
						<%=writeDiag(4,3, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2'  id='cb.symspec.6' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC6", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec6",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2'  id='cb.symspec.7'width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC7", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec7",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.8' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC8", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec8",sWebLanguage) %></td>
						<%=writeDiag(5,3, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.9' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC9", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec9",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.10' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC10", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec10",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.11' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC11", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec11",sWebLanguage) %></td>
						<%=writeDiag(6,3, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.12' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec12",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.12a' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12A", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec12a",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.13' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC13", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec13",sWebLanguage) %></td>
						<%=writeDiag(7,2, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.14' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC14", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec14",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.15' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC15", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec15",sWebLanguage) %></td>
						<%=writeDiag(8,8, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.16' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC16", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec16",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.17' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC17", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec17",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.18' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC18", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec18",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.19' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC19", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec19",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.20' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC20", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec20",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.21' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC21", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec21",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.22' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC22", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec22",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.23' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC23", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec23",sWebLanguage) %></td>
						<%=writeDiag(9,5, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.24' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC24", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec24",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.25' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC25", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec25",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.26' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC26", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec26",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.27' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC27", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec27",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.28' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC28", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec28",sWebLanguage) %></td>
						<%=writeDiag(10,2, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.29' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC29", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec29",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.30' width='1px' style='border-top: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC30", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-top: 1px solid'><%=getTran(request,"web","clefs.child.symspec30",sWebLanguage) %></td>
						<%=writeDiag(11,7, request, transaction, sWebLanguage) %>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.31' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC31", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec31",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.32' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC32", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec32",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.33' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC33", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec33",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.34' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC34", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec34",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.35' width='1px'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC35", "onchange='checkSymptoms()'") %></td>
						<td class='admin2'><%=getTran(request,"web","clefs.child.symspec35",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' id='cb.symspec.36' width='1px' style='border-bottom: 1px solid'><%=SH.writeDefaultCheckBox((TransactionVO)transaction, request, "medwan.common.true", "ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC36", "onchange='checkSymptoms()'") %></td>
						<td class='admin2' style='border-bottom: 1px solid'><%=getTran(request,"web","clefs.child.symspec36",sWebLanguage) %></td>
        			</tr>
        			<tr>
						<td class='admin2' colspan='2' style='border-top: 1px solid'>&nbsp;</td>
						<%=writeDiag(12,1, request, transaction, sWebLanguage) %>
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
</form>

<script>  
	function checkSymptoms(){
		for(n=1;n<13;n++){
			document.getElementById('cb.symgen.'+n).style.backgroundColor='';
		}
		for(n=1;n<37;n++){
			document.getElementById('cb.symspec.'+n).style.backgroundColor='';
		}
		document.getElementById('cb.symspec.12a').style.backgroundColor='';
		for(n=1;n<13;n++){
			document.getElementById('cb.diag.'+n).className='admin2';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN1').checked){
			document.getElementById('cb.symspec.3').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.4').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.5').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.6').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.7').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.8').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.9').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.10').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN2').checked){
			document.getElementById('cb.symspec.11').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.12').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.12a').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN1').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN2').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN3').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN4').checked){
			document.getElementById('cb.symspec.13').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.14').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN1').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN2').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN3').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN4').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN5').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN6').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN7').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN8').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN9').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN10').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN11').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN12').checked){
			document.getElementById('cb.symspec.15').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.16').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.17').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.18').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.19').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.20').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.21').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.22').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.23').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.24').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.25').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.26').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.27').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN12').checked){
			document.getElementById('cb.symspec.30').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.31').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.32').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.33').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.34').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.35').style.backgroundColor='#4975A7';
			document.getElementById('cb.symspec.36').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC3').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC4').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC5').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC6').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC7').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC8').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC9').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC10').checked){
			document.getElementById('cb.symgen.1').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC11').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12A').checked){
			document.getElementById('cb.symgen.2').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC13').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC14').checked){
			document.getElementById('cb.symgen.1').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.2').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.3').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.4').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC15').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC16').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC17').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC18').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC19').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC20').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC21').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC22').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC23').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC24').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC25').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC26').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC27').checked){
			document.getElementById('cb.symgen.1').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.2').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.3').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.4').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.5').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.6').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.7').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.8').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.9').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.10').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.11').style.backgroundColor='#4975A7';
			document.getElementById('cb.symgen.12').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC30').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC31').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC32').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC33').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC34').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC35').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC36').checked){
			document.getElementById('cb.symgen.12').style.backgroundColor='#4975A7';
		}
		if(document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC1').checked || document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG1").checked){
			document.getElementById('cb.diag.1').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG2").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC2').checked){
			document.getElementById('cb.diag.2').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG3").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC3').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC4').checked){
			document.getElementById('cb.diag.3').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG4").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC5').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC6').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC7').checked){
			document.getElementById('cb.diag.4').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG5").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC8').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC9').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC10').checked){
			document.getElementById('cb.diag.5').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG6").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC11').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC12A').checked){
			document.getElementById('cb.diag.6').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG7").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC13').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC14').checked){
			document.getElementById('cb.diag.7').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG8").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC15').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC16').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC17').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC18').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC19').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC20').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC21').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC22').checked){
			document.getElementById('cb.diag.8').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG9").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC23').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC24').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC25').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC26').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC27').checked){
			document.getElementById('cb.diag.9').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG10").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC28').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC29').checked){
			document.getElementById('cb.diag.10').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG11").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC30').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC31').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC32').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC33').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC34').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC35').checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMSPEC36').checked){
			document.getElementById('cb.diag.11').className='adminselected';
		}
		if(document.getElementById("ITEM_TYPE_CLEFS_CHILDREN_DIAG12").checked || document.getElementById('ITEM_TYPE_CLEFS_CHILDREN_SYMGEN12').checked){
			document.getElementById('cb.diag.12').className='adminselected';
		}
	}

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
  checkSymptoms();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        