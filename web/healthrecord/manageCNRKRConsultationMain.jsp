<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.*,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
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
                    .append("<td align='center'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' border='0' title='"+deleteTran+"' onclick=\"doDelete('"+sPrescriptionUid+"');\">")
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
<table class="list" cellspacing="1" cellpadding="0" width="100%">
    <tr>
        <td style="vertical-align:top" width="50%">                
            <table class="list" cellspacing="1" cellpadding="0" width="100%">
                <%-- MEDICAL SUMMARY --------------------------------------------------------------------%>
		       <tr class="admin" style="padding:0px;">
		           <td colspan="2"><%=getTran(request,"web","consultation",sWebLanguage)%></td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","history",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_HISTORY")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HISTORY" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","symptoms",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_SYMPTOMS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SYMPTOMS" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","performedexaminations",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_EXAMS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_EXAMS" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","clinicalexamination",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_CLINICALEXAM")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_CLINICALEXAM" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","workingdiagnosis",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WORKINGDIAGNOSIS" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","therapy",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_THERAPY")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_THERAPY" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr class="admin" style="padding:0px;">
		           <td colspan="2"><%=getTran(request,"web","prescription",sWebLanguage)%></td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","reeducation",sWebLanguage)%></td>
		           <td class="admin2">
			           	<select  <%=setRightClick(session,"ITEM_TYPE_CNRKR_REEDUCATION")%> class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REEDUCATION" property="itemId"/>]>.value' id ='reeducation'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.reeducation",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_REEDUCATION"),sWebLanguage) %>
			           	</select>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","numberofsessions",sWebLanguage)%></td>
		           <td class="admin2">
		           		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_SESSIONS")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONS" property="itemId"/>]>.value' value='<%=((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONS")%>'/>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","frequency",sWebLanguage)%></td>
		           <td class="admin2">
			           	<select <%=setRightClick(session,"ITEM_TYPE_CNRKR_FREQUENCY")%> class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FREQUENCY" property="itemId"/>]>.value' id ='frequency'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.frequency",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FREQUENCY"),sWebLanguage) %>
			           	</select>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","sessionduration",sWebLanguage)%></td>
		           <td class="admin2">
			           	<select <%=setRightClick(session,"ITEM_TYPE_CNRKR_SESSIONDURATION")%> class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONDURATION" property="itemId"/>]>.value' id ='sessionduration'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.sessionduration",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SESSIONDURATION"),sWebLanguage) %>
			           	</select>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","instructions",sWebLanguage)%></td>
		           <td class="admin2">
		               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_INSTRUCTIONS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_INSTRUCTIONS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_INSTRUCTIONS" property="value"/></textarea>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
		           <td class="admin2">
		           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
		           <td class="admin2">
		           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY2","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"cnrkr","pathology",sWebLanguage)%></td>
		           <td class="admin2">
		           		<%=ScreenHelper.writeDefaultNomenclatureField(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_PATHOLOGY3","cnrkr.pathology", 80, sWebLanguage,sCONTEXTPATH,"") %>
		           </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
		           <td class="admin2">
		           		<%=ScreenHelper.writeDefaultTextArea(session,(TransactionVO)transaction,"ITEM_TYPE_CNRKR_COMMENT", 80, 2) %>
		           </td>
		       </tr>
			</table>
		</td>

        <%-- DIAGNOSES --%>
        <td valign='top'>
    	<%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%>
        <table width="100%" class="list" cellspacing="1">
            <tr class="admin">
                <td align="center"><%=getTran(request,"Web.Occup","medwan.healthrecord.medication",sWebLanguage)%></td>
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
 	</td>
 </tr>
</table>
</logic:present>
