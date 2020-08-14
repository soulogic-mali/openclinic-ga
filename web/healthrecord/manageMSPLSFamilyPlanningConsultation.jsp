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
	String accessright="mspls.familyplanning.consultation";
%>
<%=checkPermission(accessright,"select",activeUser)%>
<%!
	private String writerow(HttpServletRequest request,TransactionVO transaction,String language, int n, String label){
		String 	s="<tr>";
				s+="	<td class='admin' colspan='2'>";
				s+="		<table width='100%' cellspacing='0' cellpadding='0'>";
				s+="			<tr>";
				s+="				<td class='admin' width='80%'>"+n+". "+getTran(request,"web",label,language)+"</td>";
				s+="				<td class='admin' width='*'>";
				s+="					"+ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "yesonly", "cb"+n, language, false, "onchange='loadrows()'");	
				s+="				</td>";
				s+="			</tr>";
				s+=" 		</table>";
				s+=" 	</td>";
				s+=" 	<td style='background-color:#DEEAFF;padding: 0px' id='td"+n+"' colspan='2'/>";
				s+="</tr>";
		return s;
	}
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
        <tr>
            <td class="admin" width='20%'><%=getTran(request,"web", "gravidity", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_GRAVIDITY", 3, 0,20,sWebLanguage,"if(this.value==0){document.getElementById(\"cb2.1\").checked=true;}else if(this.value>0){document.getElementById(\"cb2.1\").checked=false;}document.getElementById(\"cb2.1\").onclick();loadrows();") %>
            </td>
            <td class="admin" width='20%'><%=getTran(request,"web", "parity", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_PARITY", 3, 0,20,sWebLanguage) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "childrenalive", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_CHILDRENALIVE", 3, 0,20,sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"web", "childrendead", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_CHILDRENDEAD", 3, 0,20,sWebLanguage) %>
            </td>
        </tr>
        <tr>
            <td class="admin"><%=getTran(request,"web", "childrendesired", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_CHILDRENDESIRED", 3, 0,20,sWebLanguage) %>
            </td>
            <td class="admin"><%=getTran(request,"web", "datelastpregnancy", sWebLanguage)%></td>
            <td class="admin2">
            	<%=ScreenHelper.writeDefaultDateInput(session, (TransactionVO)transaction, "ITEM_TYPE_FP_LASTPREGNANCY",sWebLanguage, sCONTEXTPATH) %>
            </td>
        </tr>
        <tr class='admin'>
        	<td colspan='2'></td>
        	<td colspan='2'><center><%=getTran(request,"web","recommendedmethod",sWebLanguage) %></center></td>
        </tr>
        <tr class='admin'>
        	<td colspan='2'><%=getTran(request,"web","anamnesis",sWebLanguage) %></td>
        	<td style='padding: 0px' colspan='2'>
        		<table width='100%' cellspacing="1">
        			<tr class='admin'>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MAO",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","BAR",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","DIU",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","PIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MINIPIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","INJ",sWebLanguage) %></center></td>
        				<td width='*'><center><%=getTran(request,"familyplanning","NOR",sWebLanguage) %></center></td>
        			</tr>
        		</table>
        	</td>
        </tr>
        <%
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,1,"adolescent"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,2,"nullipara"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,3,"brestfeedinglessthan6weeks"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,4,"illiteratewomen"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,5,"twosignsin"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,6,"irregularcycle"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,7,"unknownbloodloss"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,8,"fpdrugtreatment"));
        %>
        <tr class='admin'>
        	<td colspan='2'><%=getTran(request,"web","history",sWebLanguage) %></td>
        	<td style='padding: 0px' colspan='2'>
        		<table width='100%' cellspacing="1">
        			<tr class='admin'>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MAO",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","BAR",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","DIU",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","PIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MINIPIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","INJ",sWebLanguage) %></center></td>
        				<td width='*'><center><%=getTran(request,"familyplanning","NOR",sWebLanguage) %></center></td>
        			</tr>
        		</table>
        	</td>
		</tr>
		<%
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,9,"phlebitisorthrombosis"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,10,"cesarianlessthan6moths"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,11,"extrautirinepregnancy"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,12,"hypermenorrhea"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,13,"pelvicinfection"));
		%>
        <tr class='admin'>
        	<td colspan='2'><%=getTran(request,"web","generalexamination",sWebLanguage) %></td>
        	<td style='padding: 0px' colspan='2'>
        		<table width='100%' cellspacing="1">
        			<tr class='admin'>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MAO",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","BAR",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","DIU",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","PIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MINIPIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","INJ",sWebLanguage) %></center></td>
        				<td width='*'><center><%=getTran(request,"familyplanning","NOR",sWebLanguage) %></center></td>
        			</tr>
        		</table>
        	</td>
		</tr>
		<%
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,14,"paleconjunctiva"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,15,"yellowconjunctiva"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,16,"breasttumor"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,17,"recentliverdisease"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,18,"heartdisease"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,19,"fphypertension"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,20,"varices"));
	    	out.println(writerow(request,(TransactionVO)transaction,sWebLanguage,21,"genitalcancer"));
		%>
        <tr class='admin'>
        	<td colspan='2'><%=getTran(request,"web","fpconclusion",sWebLanguage) %></td>
        	<td style='padding: 0px' colspan='2'>
        		<table width='100%' cellspacing="1">
        			<tr class='admin'>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MAO",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","BAR",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","DIU",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","PIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","MINIPIL",sWebLanguage) %></center></td>
        				<td width='14.3%'><center><%=getTran(request,"familyplanning","INJ",sWebLanguage) %></center></td>
        				<td width='*'><center><%=getTran(request,"familyplanning","NOR",sWebLanguage) %></center></td>
        			</tr>
        		</table>
        	</td>
		</tr>
		<tr>
        	<td class='admin' colspan='2'><%=getTran(request,"web","contraindicatedmethod",sWebLanguage) %></td>
        	<td style='padding: 0px' colspan='2'>
        		<table width='100%' cellspacing="1">
        			<tr>
        				<td id='tdc1' height='24px' width='14.3%'/>
        				<td id='tdc2' width='14.3%'/>
        				<td id='tdc3' width='14.3%'/>
        				<td id='tdc4' width='14.3%'/>
        				<td id='tdc5' width='14.3%'/>
        				<td id='tdc6' width='14.3%'/>
        				<td id='tdc7' width='*'/>
        			</tr>
        		</table>
        	</td>
		</tr>
		<tr>
        	<td class='admin' colspan='1'><%=getTran(request,"web","selectedmethod",sWebLanguage) %></td>
        	<td class='admin2' style='padding: 0px' colspan='1'>
        		<%=ScreenHelper.writeDefaultSelect(request, (TransactionVO)transaction, "selectedmethod", "fp.selectedmethod", sWebLanguage, "") %>
        	</td>
        	<td class='admin' colspan='1'><%=getTran(request,"web","comment",sWebLanguage) %></td>
        	<td class='admin2' style='padding: 0px' colspan='1'>
        		<%=ScreenHelper.writeDefaultTextArea(session, (TransactionVO)transaction, "methodcomment", 40, 2) %>
        	</td>
		</tr>
		<tr>
        	<td class='admin' colspan='1'><%=getTran(request,"web","distributedquantity",sWebLanguage) %></td>
        	<td class='admin2' style='padding: 0px' colspan='3'>
        		<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO)transaction, "ITEM_TYPE_PF_DISTRIBUTEDQUANTITY", 5, 0, 1000, sWebLanguage) %>
        	</td>
		</tr>
		<tr>
        	<td class='admin' colspan='1'><%=getTran(request,"web","otherinformation",sWebLanguage) %></td>
        	<td class='admin2' style='padding: 0px' colspan='3'>
        		<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "fp.otherinformation", "otherinformation", sWebLanguage, true, "onchange='if(this.id==\"otherinformation.1\" && this.checked){document.getElementById(\"otherinformation.2\").checked=false;};if(this.id==\"otherinformation.2\" && this.checked){document.getElementById(\"otherinformation.1\").checked=false;}'") %>
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
  
  var td = new Array();
  td[1]="+;+;-;+;+;-;-";
  td[2]="+;+;-;+;+;-;-";
  td[3]="+;+;+;-;+;+;+";
  td[4]="0;+;+;0;0;+;+";
  td[5]="+;+;+;0;+;+;+";
  td[6]="+;+;0;+;0;0;0";
  td[7]="+;+;-;-;-;-;-";
  td[8]="+;+;+;-;-;-;-";
  td[9]="+;+;+;-;+;0;0";
  td[10]="+;+;-;+;+;+;+";
  td[11]="+;+;-;+;+;+;+";
  td[12]="+;+;-;+;+;+;+";
  td[13]="+;+;-;+;+;+;+";
  td[14]="+;+;-;+;+;+;+";
  td[15]="+;+;+;-;-;-;-";
  td[16]="+;+;+;-;-;-;-";
  td[17]="+;+;+;-;-;-;-";
  td[18]="+;+;-;+;+;+;+";
  td[19]="+;+;+;-;+;0;0";
  td[20]="+;+;+;0;+;0;0";
  td[21]="+;+;-;-;0;0;0";
  
  function selectmethod(tdnr){
	  tdElement = document.getElementById("td"+tdnr);
	  var s="<table cellspacing='0' cellpadding='0' width='100%'><tr>";
	  for(n=0;n<td[tdnr].split(";").length;n++){
		  var value=td[tdnr].split(";")[n];
		  if(value=='0'){
			  value='(-)';
		  }
		  if(document.getElementById("cb"+tdnr+".1").checked){
			  var color='yellow';
			  if(value=='+'){
				  color='lightgreen';
			  }
			  else if(value=='-'){
				  color='red';
			  }
			  s+="<td style='background-color: "+color+"' height='24px' width='"+(100/td[tdnr].split(";").length)+"%'><center><b>"+value+"</b></center></td>";
		  }
		  else{
			  s+="<td style='background-color:#DEEAFF;padding: 0px' height='24px' width='"+(100/td[tdnr].split(";").length)+"%'><center>"+value+"</center></td>";
		  }
	  }
	  s+="</tr></table>";
	  tdElement.innerHTML=s;
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
  
  function loadrows(){
	  var conclusions = new Array(1,1,1,1,1,1,1,1);
	  for(i=1;i<22;i++){
		  if(document.getElementById("cb"+i)){
			  selectmethod(i);
			  if(document.getElementById("cb"+i+".1").checked){
				  for(k=1;k<8;k++){
					  if(td[i].split(";")[k-1]=='0' && conclusions[k]==1){
						  conclusions[k]=0;
					  }
					  else if(td[i].split(";")[k-1]=='-'){
						  conclusions[k]=-1;
					  }
				  }
			  }
		  }
	  }
	  for(k=1;k<8;k++){
		  if(conclusions[k]==-1){
			  document.getElementById("tdc"+k).style.backgroundColor='red';
			  document.getElementById("tdc"+k).innerHTML='<center><b>-</b></center>';
		  }
		  else if(conclusions[k]==0){
			  document.getElementById("tdc"+k).style.backgroundColor='yellow';
			  document.getElementById("tdc"+k).innerHTML='<center><b>(-)</b></center>';
		  }
		  else{
			  document.getElementById("tdc"+k).style.backgroundColor='lightgreen';
			  document.getElementById("tdc"+k).innerHTML='<center><b>+</b></center>';
		  }
	  }
  }
  
  if(<%=activePatient.getAge()<20%>){
	  document.getElementById('cb1.1').checked=true;
	  document.getElementById('cb1.1').onclick();
  }
  if(document.getElementById("ITEM_TYPE_FP_GRAVIDITY").value=='0'){
	  document.getElementById('cb2.1').checked=true;
	  document.getElementById('cb2.1').onclick();
  }
  else if(document.getElementById("ITEM_TYPE_FP_GRAVIDITY").value>0){
	  document.getElementById('cb2.1').checked=false;
	  document.getElementById('cb2.1').onclick();
  }
  
  loadrows();
  
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>
