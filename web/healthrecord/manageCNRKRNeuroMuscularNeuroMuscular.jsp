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
		       <tr class="admin" style="padding:0px;">
		           <td colspan="3"><%=getTran(request,"web","upperlimbs",sWebLanguage)%></td>
		       </tr>
		       <tr>
		       		<td class='admin'/>
 		            <td class='admin'><%=getTran(request,"web","right",sWebLanguage)%></td>
 		            <td class='admin'><%=getTran(request,"web","left",sWebLanguage)%></td>
 		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","deltmid",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTMID_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTMID_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTMID_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTMID_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","deltant",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTANT_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTANT_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTANT_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTANT_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","deltpost",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTPOST_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTPOST_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTPOST_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_DELTPOST_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","pect",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_PECT_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_PECT_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_PECT_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_PECT_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","biceps",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_BICEPS_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_BICEPS_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_BICEPS_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_BICEPS_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","triceps",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRICEPS_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRICEPS_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRICEPS_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRICEPS_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","extwrist",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTWRIST_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTWRIST_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTWRIST_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTWRIST_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","extfinger",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTFINGER_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTFINGER_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTFINGER_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTFINGER_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","flexwrist",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXWRIST_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXWRIST_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXWRIST_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXWRIST_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","flexfinger",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXFINGER_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXFINGER_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXFINGER_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXFINGER_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","interbone",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_INTERBONE_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_INTERBONE_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_INTERBONE_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_INTERBONE_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","oppthumb",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_OPPTHUMB_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_OPPTHUMB_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_OPPTHUMB_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_OPPTHUMB_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","abdthumb",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDTHUMB_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDTHUMB_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDTHUMB_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDTHUMB_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
			</table>
		</td>
        <td style="vertical-align:top" width="50%">                
            <table class="list" cellspacing="1" cellpadding="0" width="100%">
		       <tr class="admin" style="padding:0px;">
		           <td colspan="3"><%=getTran(request,"web","lowerlimbs",sWebLanguage)%></td>
		       </tr>
		       <tr>
		       		<td class='admin'/>
 		            <td class='admin'><%=getTran(request,"web","right",sWebLanguage)%></td>
 		            <td class='admin'><%=getTran(request,"web","left",sWebLanguage)%></td>
 		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","flexhip",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXHIP_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXHIP_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXHIP_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXHIP_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","quadri",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_QUADRI_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_QUADRI_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_QUADRI_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_QUADRI_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","tibant",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBANT_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBANT_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBANT_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBANT_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","exttoes",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTTOES_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTTOES_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTTOES_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EXTTOES_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","epgo",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EPGO_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EPGO_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EPGO_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_EPGO_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","tibpost",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBPOST_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBPOST_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBPOST_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TIBPOST_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","fiblat",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FIBLAT_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FIBLAT_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FIBLAT_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FIBLAT_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","trisur",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRISUR_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRISUR_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRISUR_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_TRISUR_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","isch",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ISCH_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ISCH_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ISCH_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ISCH_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","glutmag",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMAG_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMAG_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMAG_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMAG_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","glutmed",sWebLanguage)%></td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMED_R" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMED_R"),sWebLanguage) %>
			           	</select>
          		   </td>
          		   <td class='admin2'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMED_L" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_GLUTMED_L"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr class="admin" style="padding:0px;">
		           <td colspan="3"><%=getTran(request,"web","trunkandneck",sWebLanguage)%></td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","flexneck",sWebLanguage)%></td>
          		   <td class='admin2' colspan='3'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXNECK" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_FLEXNECK"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
		       <tr>
		           <td class="admin"><%=getTran(request,"muscular","abdo",sWebLanguage)%></td>
          		   <td class='admin2' colspan='3'>
			           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDO" property="itemId"/>]>.value'>
			           		<option/>
			           		<%=ScreenHelper.writeSelect(request,"cnrkr.muscular",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_MUSC_ABDO"),sWebLanguage) %>
			           	</select>
          		   </td>
		       </tr>
			</table>
		</td>
	</tr>
</table>
</logic:present>
