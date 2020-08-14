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
	String accessright="mspls.childhiv.followup";
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
            <td class="admin" width="<%=sTDAdminWidth%>" colspan="4">
                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
                <script>writeTranDate();</script>
            </td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>I. <%=getTran(request,"web","hivconsultation",sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","hivreasonforencounter",sWebLanguage) %></td>
        	<td class='admin' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_COMPLAINTS", 80, 1)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","anamnesis",sWebLanguage) %></td>
        	<td class='admin' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_ANAMNESIS", 80, 1)%></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","patientonantituberculosis",sWebLanguage) %></td>
        	<td class='admin'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_ONANTITB", sWebLanguage, false, "onchange='evaluatetbdate()' onblur='evaluatetbdate()'", "")%></td>
        	<td class='admin' colspan='2'>
				<table width='100%' id='tbsince'>
					<tr>
			        	<td class='admin'><%=getTran(request,"web","treatmentsince",sWebLanguage) %></td>
			        	<td class='admin'><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_ONANTITBSINCE", sWebLanguage, sCONTEXTPATH)%></td>
					</tr>
				</table>
			</td>
        </tr>
        <tr id='tbscreening' style='display: none'>
			<td class='admin'><%=getTran(request,"web","tbscreeningquestionnaire",sWebLanguage) %></td>
        	<td colspan='3'>
        		<table width='100%'>
        			<tr>
						<td class='admin2' colspan='2'><%=getTran(request,"hiv","alertsigns",sWebLanguage) %></td>
        			</tr>
        			<%	for(int n=1;n<9;n++){ 
	        				if(n==3){
	        					out.println("<tr><td class='admin2' colspan='2'>"+getTran(request,"hiv","minorsigns",sWebLanguage)+"</td></tr>");
	        				}
	        				else if(n==6){
	        					out.println("<tr><td class='admin2' colspan='2'>"+getTran(request,"hiv","majorsigns",sWebLanguage)+"</td></tr>");
	        				}
        			%>
		        			<tr>
					        	<td class='admin'><%=getTran(request,"web","tbchildquestion"+n,sWebLanguage) %></td>
					        	<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE"+n, sWebLanguage, false, "onblur='evaluatetbquestionnaire()' onchange='evaluatetbquestionnaire()'", "")%></td>
		        			</tr>
					<%	} %>
        			<tr id='tbmessagetr' style='display: none'>
						<td class='admin2' colspan='2' id='tbmessage'></td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <tr class='admin'>
			<td colspan='4'>I. <%=getTran(request,"web","eventsafterlastconsultation",sWebLanguage) %></td>
        </tr>
        <tr>
        	<td class='admin'><%=getTran(request,"web","events",sWebLanguage) %></td>
        	<td class='admin' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_ENVENTS", 80, 1)%></td>
        </tr>
        <tr class='admin'>
        	<td colspan='4'>III. <%=getTran(request,"web","clinicalexamination",sWebLanguage) %></td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","vitalsigns",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
            	<table width="100%">
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"openclinic.chuk","temperature",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_TEMPERATURE", 5) %>°C</td>
            			<td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.length",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_HEIGHT",5,"onblur='calculateBMI()'") %>cm</td>
            			<td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.biometry.weight",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_BIOMETRY_WEIGHT", 5,"onblur='calculateBMI()'") %>kg</td>
			            <td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforlength",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInputNoClass(session, (TransactionVO)transaction, "WFL", 5, "onclick='calculateBMI()' onblur='calculateBMI()' onfocus='calculateBMI()' readonly") %><img id="wflinfo" style='display: none' src="<c:url value='/_img/icons/icon_info.gif'/>"/></td>
            		</tr>
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"web","armcircumference",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_ARMCIRCUMFERENCE", 5) %>°C</td>
            			<td class='admin' nowrap><%=getTran(request,"hiv","headcircumference",sWebLanguage)%></td>
            			<td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HEADCIRCUMFERENCE",5) %>cm</td>
			            <td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.weightforage",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInputNoClass(session, (TransactionVO)transaction, "WFA", 5, "onclick='calculateBMI()' onblur='calculateBMI()' onfocus='calculateBMI()' readonly") %></td>
			            <td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.lengthforage",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInputNoClass(session, (TransactionVO)transaction, "LFA", 5, "onclick='calculateBMI()' onblur='calculateBMI()' onfocus='calculateBMI()' readonly") %></td>
            		</tr>
	                <tr>
			            <td class='admin' nowrap><%=getTran(request,"Web.Occup","medwan.healthrecord.cardial.pression-arterielle",sWebLanguage)%></td>
			            <td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT", 5,"") %>/<%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_LEFT", 5,"") %>mmHg</td>
			            <td class='admin' nowrap><%=getTran(request,"openclinic.chuk","heart.frequency",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_HEART_FRENQUENCY", 5,"") %>/min</td>
			            <td class='admin' nowrap><%=getTran(request,"openclinic.chuk","respiratory.frequency",sWebLanguage)%></td>
			            <td class='admin2'><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "[GENERAL.ANAMNESE]ITEM_TYPE_RESPIRATORY_FRENQUENCY", 5,"") %>/min</td>
	                </tr>
            	</table>
            </td>
        </tr>
		<tr>
			<td class='admin'><%=getTran(request,"hiv","extremities",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hiv.child.extremities", "ITEM_TYPE_HIVCHILD_EXTREMITIES", sWebLanguage, false,"onchange='evaluateedema()'","") %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_EXTREMITIES.OTHER", 20, 1)%></td>
		</tr>
		<tr class='admin'>
			<td colspan='4'>IV. <%=getTran(request,"web","nutrionvaluation",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","weightforlength",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><b><span id='wfleval'></span></b></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","weightforage",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><b><span id='wfaeval'></span></b></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","oedema",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><b><span id='edemaeval'></span></b></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","heightforage",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><b><span id='lfaeval'></span></b></td>
		</tr>
		<tr>
			<td class='admin' colspan='2'><%=getTran(request,"web","nutritionmanagementnecessary",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_NUTRITIONMANAGEMENT", sWebLanguage, false, "", "") %></td>
		</tr>
		<tr>
			<td class='admin' colspan='2'><%=getTran(request,"web","nutritionreferraltohospital",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_NUTRITIONREFERRALTOHOSPITAL", sWebLanguage, false, "", "") %></td>
		</tr>
		<tr>
			<td class='admin' colspan='2'><%=getTran(request,"web","nutritionreferraltocommunity",sWebLanguage) %></td>
			<td class='admin2' colspan='2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_NUTRITIONREFERRALTOCOMMUNITY", sWebLanguage, false, "", "") %></td>
		</tr>
		<tr class='admin'>
			<td colspan='4'>V. <%=getTran(request,"web","conclusion",sWebLanguage) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","whostage",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><span id='whostageconclusion'/></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","otherassociateddiseases",sWebLanguage) %></td>
			<td class='admin2' colspan='3'><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_OTHERDISEASES", 80, 1) %></td>
		</tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","eligiblefortreament",sWebLanguage) %></td>
			<td class='admin2'><%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno", "ITEM_TYPE_HIVCHILD_ELIGIBLE", sWebLanguage, false, "", "") %></td>
			<td class='admin'><%=getTran(request,"web","eligibilitycriteria",sWebLanguage) %></td>
        	<td class='admin2'><%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "hivchild.eligibilitycriteria", "ITEM_TYPE_HIVCHILD_ELIGIBILITYCRITERIA", sWebLanguage, false) %></td>
		</tr>
        <tr class='admin'>
        	<td colspan='4'>VI. <%=getTran(request,"web","treatmentattitude",sWebLanguage) %></td>
		</tr>        
		<tr>
			<td class='admin'><%=ScreenHelper.writeDefaultCheckBox((TransactionVO)transaction, request, "yes", "ITEM_TYPE_HIVCHILD_CONTINUETREATMENT", sWebLanguage, "")%><%=getTran(request,"web","continueactualtreatment",sWebLanguage) %></td>
			<td class='admin2' colspan='3'></td>
		</tr>
		<tr>
			<td class='admin'><%=ScreenHelper.writeDefaultCheckBox((TransactionVO)transaction, request, "yes", "ITEM_TYPE_HIVCHILD_ADAPTTREATMENT", sWebLanguage, " onchange='evaluatetreatment()'")%><%=getTran(request,"web","adaptactualtreatment",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<table width="100%" id='adapttreatment' style='display: none'>
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"web","arvcombination",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","olddose",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","actualweight",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","newdose",sWebLanguage)%></td>
            		</tr>
            		<%	for(int n=1;n<4;n++){ %>
            		<tr>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_MOLECULE"+n, "hivadult.molecule", sWebLanguage, "") %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_OLDDOSE"+n, 20) %></td>
            			<td class='admin2' nowrap><span id='actualweight'></span></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_NEWDOSE"+n, 20) %></td>
            		</tr>
            		<%	} %>
            	</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=ScreenHelper.writeDefaultCheckBox((TransactionVO)transaction, request, "yes", "ITEM_TYPE_HIVCHILD_MODIFYTREATMENT", sWebLanguage, " onchange='evaluatetreatment()'")%><%=getTran(request,"web","modifyactualtreatment",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<table width="100%" id='modifytreatment' style='display: none'>
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"web","begin",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","arvcombination",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","reason",sWebLanguage)%></td>
            		</tr>
            		<%	for(int n=1;n<4;n++){ %>
            		<tr>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_MODIFYBEGIN"+n, sWebLanguage, sCONTEXTPATH) %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_MODIFYMOLECULE"+n, "hivadult.molecule", sWebLanguage, "") %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_MODIFYREASON"+n, 20,1) %></td>
            		</tr>
            		<%	} %>
            	</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=ScreenHelper.writeDefaultCheckBox((TransactionVO)transaction, request, "yes", "ITEM_TYPE_HIVCHILD_OTHERTREATMENT", sWebLanguage, " onchange='evaluatetreatment()'")%><%=getTran(request,"web","othertreatment",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<table width="100%" id='othertreatment' style='display: none'>
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"web","treatment",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","reason",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","duration",sWebLanguage)%></td>
            		</tr>
            		<%	for(int n=1;n<4;n++){ %>
            		<tr>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_OTHERTREATMENT"+n, 30) %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_OTHERREASON"+n, 20,1) %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_OTHERDURATION"+n, 20) %></td>
            		</tr>
            		<%	} %>
            	</table>
			</td>
		</tr>
		<tr>
			<td class='admin'><%=ScreenHelper.writeDefaultCheckBox((TransactionVO)transaction, request, "yes", "ITEM_TYPE_HIVCHILD_REFERENCE", sWebLanguage, " onchange='evaluatetreatment()'")%><%=getTran(request,"web","referral",sWebLanguage) %></td>
			<td class='admin2' colspan='3'>
				<table width="100%" id='referral' style='display: none'>
            		<tr>
            			<td class='admin' nowrap><%=getTran(request,"web","referralto",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"web","reason",sWebLanguage)%></td>
            			<td class='admin' nowrap><%=getTran(request,"hiv","observations",sWebLanguage)%></td>
            		</tr>
            		<tr>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextInput(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_REFERRALTO", 30) %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_REFERRALREASON", 20,1) %></td>
            			<td class='admin2' nowrap><%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "ITEM_TYPE_HIVCHILD_REFERRALOBSERVATIONS", 20,1) %></td>
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

  function evaluatetbdate(){
	  if(document.getElementById('ITEM_TYPE_HIVCHILD_ONANTITB.1').checked){
		  document.getElementById('tbsince').style.display='';
		  document.getElementById('tbscreening').style.display='none';
	  }
	  else{
		  document.getElementById('tbsince').style.display='none';
		  if(document.getElementById('ITEM_TYPE_HIVCHILD_ONANTITB.0').checked){
			  document.getElementById('tbscreening').style.display='';
		  }
		  else{
			  document.getElementById('tbscreening').style.display='none';
		  }
	  }
  }

  function evaluatetbquestionnaire(){
	  document.getElementById('tbmessagetr').style.display='none';
	  var alert=0;
	  var minor=0;
	  var major=0;
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE1.1").checked){ alert++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE2.1").checked){ alert++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE3.1").checked){ minor++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE4.1").checked){ minor++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE5.1").checked){ minor++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE6.1").checked){ major++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE7.1").checked){ major++;};
	  if(document.getElementById("ITEM_TYPE_HIVCHILD_TBQUESTIONNAIRE8.1").checked){ major++;};
	  if((alert>0 && minor>1) || (alert>0 && major>0)){
		  document.getElementById('tbmessagetr').style.display='';
		  document.getElementById('tbmessage').innerHTML='<img src="<%=sCONTEXTPATH%>/_img/icons/icon_warning.gif"/> <%=getTranNoLink("hiv","tchildbmessage",sWebLanguage)%>';
	  }
  }

  function calculateBMI(){
      document.getElementById('actualweight').innerHTML='<b>'+document.getElementById('ITEM_TYPE_BIOMETRY_WEIGHT').value+' kg</b>';
	  document.getElementById('WFL').value = '';
	  document.getElementById('WFA').value = '';
	  document.getElementById('LFA').value = '';
	  var _BMI = 0;
	  var heightInputValue = document.getElementById('ITEM_TYPE_BIOMETRY_HEIGHT').value.replace(",",".")*1;
	  var weightInputValue = document.getElementById('ITEM_TYPE_BIOMETRY_WEIGHT').value.replace(",",".")*1;
	
	  if(heightInputValue > 0 && weightInputValue>0){
	      _BMI = (weightInputValue * 10000) / (heightInputValue * heightInputValue);
	      if(_BMI > 100 || _BMI < 5){
	          //document.getElementsByName('BMI')[0].value = "";
	      }
	      else{
	          //document.getElementsByName('BMI')[0].value = Math.round(_BMI*10)/10;
	      }
    	  checkWeightForHeight(heightInputValue,weightInputValue);
	  }
  }

	function checkWeightForHeight(height,weight){
		var today = new Date();
	    var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&age=<%=activePatient.getAgeInDays() %>&gender=<%=activePatient.gender%>&ts='+today;
	    new Ajax.Request(url,{
	        method: "POST",
	        postBody: "",
	        onSuccess: function(resp){
	            var label = eval('('+resp.responseText+')');
	    		if(label.zindex>-999){
    		    	document.getElementById('WFL').value = (label.zindex*1).toFixed(2);
	    			if(label.zindex<-4){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wfleval").innerHTML="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").title="Z-index < -4: <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-3){
	    				document.getElementById("WFL").className="darkredtext";
	    				document.getElementById("wfleval").innerHTML="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-2){
	    				document.getElementById("WFL").className="orangetext";
	    				document.getElementById("wfleval").innerHTML="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex<-1){
	    				  document.getElementById("WFL").className="yellowtext";
		    				document.getElementById("wfleval").innerHTML="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    				  document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex>2){
	    				document.getElementById("WFL").className="orangetext";
	    				document.getElementById("wfleval").innerHTML="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    			  	document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","obesity",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else if(label.zindex>1){
	    				document.getElementById("WFL").className="yellowtext";
	    				document.getElementById("wfleval").innerHTML="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").title="Z-index = "+(label.zindex*1).toFixed(2)+": <%=getTranNoLink("web","light.obesity",sWebLanguage).toUpperCase()%>";
	    				document.getElementById("wflinfo").style.display='';
	    			}
	    			else{
	    				document.getElementById("WFL").className="text";
	    				document.getElementById("wfleval").innerHTML="-";
	    				document.getElementById("wflinfo").style.display='none';
	    			}
	    		}
  			  	else{
  					document.getElementById("WFL").className="text";
  				  	document.getElementById("wflinfo").style.display='none';
    				document.getElementById("wfleval").innerHTML="-";
  			  	}
	    		if(label.zindexLFA>-999){
    		    	document.getElementById('LFA').value = (label.zindexLFA*1).toFixed(2);
					if(label.zindexLFA<-3){
	    				document.getElementById("LFA").className="darkredtext";
	    				document.getElementById("lfaeval").innerHTML="Z-index = "+(label.zindexLFA*1).toFixed(2)+": <%=getTranNoLink("web","severe.chronic.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexLFA<-2){
	    				document.getElementById("LFA").className="orangetext";
	    				document.getElementById("lfaeval").innerHTML="Z-index = "+(label.zindexLFA*1).toFixed(2)+": <%=getTranNoLink("web","moderate.chronic.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexLFA<-1){
	    				document.getElementById("LFA").className="yellowtext";
	    				document.getElementById("lfaeval").innerHTML="Z-index = "+(label.zindexLFA*1).toFixed(2)+": <%=getTranNoLink("web","light.chronic.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexLFA>2){
	    				document.getElementById("LFA").className="orangetext";
	    				document.getElementById("lfaeval").innerHTML="-";
    			    }
	    			else if(label.zindexLFA>1){
	    				document.getElementById("LFA").className="yellowtext";
	    				document.getElementById("lfaeval").innerHTML="-";
	    			}
	    			else{
	    				document.getElementById("LFA").className="text";
	    				document.getElementById("lfaeval").innerHTML="-";
	    			}
	    		}
  			  	else{
  				  	document.getElementById("LFA").className="text";
  				  	document.getElementById("lfaeval").innerHTML="-";
  			  	}
	            if(label.zindexWFA>-999){
    		    	document.getElementById('WFA').value = (label.zindexWFA*1).toFixed(2);
					if(label.zindexWFA<-3){
	    				document.getElementById("WFA").className="darkredtext";
	    				document.getElementById("wfaeval").innerHTML="Z-index = "+(label.zindexWFA*1).toFixed(2)+": <%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexWFA<-2){
	    				document.getElementById("WFA").className="orangetext";
	    				document.getElementById("wfaeval").innerHTML="Z-index = "+(label.zindexWFA*1).toFixed(2)+": <%=getTranNoLink("web","moderate.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexWFA<-1){
	    				document.getElementById("WFA").className="yellowtext";
	    				document.getElementById("wfaeval").innerHTML="Z-index = "+(label.zindexWFA*1).toFixed(2)+": <%=getTranNoLink("web","light.malnutrition",sWebLanguage).toUpperCase()%>";
	    			}
	    			else if(label.zindexWFA>2){
	    				document.getElementById("WFA").className="orangetext";
	    				document.getElementById("wfaeval").innerHTML="-";
    			    }
	    			else if(label.zindexWFA>1){
	    				document.getElementById("WFA").className="yellowtext";
	    				document.getElementById("wfaeval").innerHTML="-";
	    			}
	    			else{
	    				document.getElementById("WFA").className="text";
	    				document.getElementById("wfaeval").innerHTML="-";
	    			}
	    		}
  			  	else{
  				  	document.getElementById("WFA").className="text";
  					document.getElementById("wfaeval").innerHTML="-";
  			  	}
	        },
	        onFailure: function(){
	        }
	    });
	}
	
	function evaluateedema(){
		if(document.getElementById("ITEM_TYPE_HIVCHILD_EXTREMITIES.2") && document.getElementById("ITEM_TYPE_HIVCHILD_EXTREMITIES.2").checked){
			document.getElementById("edemaeval").innerHTML='<%=getTranNoLink("web","severe.malnutrition",sWebLanguage).toUpperCase()%>'
		}
		else{
			document.getElementById("edemaeval").innerHTML='-'
		}
	}
	
	function evaluatetreatment(){
		if(document.getElementById("ITEM_TYPE_HIVCHILD_ADAPTTREATMENT").checked){
			document.getElementById("adapttreatment").style.display='';
		}
		else{
			document.getElementById("adapttreatment").style.display='none';
		}
		if(document.getElementById("ITEM_TYPE_HIVCHILD_MODIFYTREATMENT").checked){
			document.getElementById("modifytreatment").style.display='';
		}
		else{
			document.getElementById("modifytreatment").style.display='none';
		}
		if(document.getElementById("ITEM_TYPE_HIVCHILD_OTHERTREATMENT").checked){
			document.getElementById("othertreatment").style.display='';
		}
		else{
			document.getElementById("othertreatment").style.display='none';
		}
		if(document.getElementById("ITEM_TYPE_HIVCHILD_REFERENCE").checked){
			document.getElementById("referral").style.display='';
		}
		else{
			document.getElementById("referral").style.display='none';
		}
	}

	evaluatetbdate();
  	evaluatetbquestionnaire();
  	calculateBMI();
  	evaluateedema();
  	evaluatetreatment();
  
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>        