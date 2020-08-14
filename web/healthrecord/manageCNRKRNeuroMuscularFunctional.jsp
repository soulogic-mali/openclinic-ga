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
       <tr>
           <td class="admin" rowspan='2'><%=getTran(request,"web","walkingpattern",sWebLanguage)%></td>
           <td class="admin2"><%=getTran(request,"web","assistance",sWebLanguage)%></td>
           <td class="admin2">
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FUNC_ASSISTANCE" property="itemId"/>]>.value' id ='assistance'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.assistance",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FUNC_ASSISTANCE"),sWebLanguage) %>
	           	</select>
        	</td>
           	<td class="admin2"><%=getTran(request,"web","orthesis",sWebLanguage)%></td>
        	<td class="admin2">
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FUNC_ORTHESIS" property="itemId"/>]>.value' id ='orthesis'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.orthesis",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_FUNC_ORTHESIS"),sWebLanguage) %>
	           	</select>
			</td>
	   </tr>
       <tr>
           <td class="admin2"><%=getTran(request,"web","qualityofwalk",sWebLanguage)%></td>
           <td class="admin2" colspan='4'>
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_WALK_QUALITY")%> class="text" cols="64" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WALK_QUALITY" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_WALK_QUALITY" property="value"/></textarea>
           </td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","10minwalktest",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web","spontaneousspeed",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_10MWT_SPONTANEOUS")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_10MWT_SPONTANEOUS" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_10MWT_SPONTANEOUS" property="value"/>'/> s
	    	</td>
	       	<td class="admin2"><%=getTran(request,"web","highspeed",sWebLanguage)%></td>
	    	<td class="admin2" colspan='2'>
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_10MWT_FAST")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_10MWT_FAST" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_10MWT_FAST" property="value"/>'/> s
	    	</td>
       </tr>
       <tr>
           <td class="admin" rowspan='3'><%=getTran(request,"web","stairs",sWebLanguage)%></td>
           	<td class="admin2"><%=getTran(request,"web","numberofsteps",sWebLanguage)%></td>
        	<td class="admin2" colspan='4'>
           		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_STAIRS_NUMBEROFSTEPS")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_NUMBEROFSTEPS" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_NUMBEROFSTEPS" property="value"/>'/>
        	</td>
        </tr>
        <tr>
			<td class='admin'><%=getTran(request,"web","descent",sWebLanguage)%></td>
			<td class='admin2'>
				<%=getTran(request,"web.occup","duration",sWebLanguage)%>
				<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_STAIRS_DESC_TIME")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_TIME" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_TIME" property="value"/>'/> s
			</td>
			<td class='admin2'>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_ALTERNATE" property="itemId"/>]>.value' id ='desc_alternatie'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.alternate",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_ALTERNATE"),sWebLanguage) %>
	           	</select>
			</td>
			<td class='admin2'>
				<%=getTran(request,"web","ramp",sWebLanguage)%>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_RAMP" property="itemId"/>]>.value' id ='desc_ramp'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.ramp",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_DESC_RAMP"),sWebLanguage) %>
	           	</select>
			</td>
       </tr>
        <tr>
			<td class='admin'><%=getTran(request,"web","climbing",sWebLanguage)%></td>
			<td class='admin2'>
				<%=getTran(request,"web.occup","duration",sWebLanguage)%>
				<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_STAIRS_ASC_TIME")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_TIME" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_TIME" property="value"/>'/> s
			</td>
			<td class='admin2'>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_ALTERNATE" property="itemId"/>]>.value' id ='asc_alternatie'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.alternate",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_ALTERNATE"),sWebLanguage) %>
	           	</select>
			</td>
			<td class='admin2'>
				<%=getTran(request,"web","ramp",sWebLanguage)%>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_RAMP" property="itemId"/>]>.value' id ='asc_ramp'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.ramp",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_STAIRS_ASC_RAMP"),sWebLanguage) %>
	           	</select>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","tug",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web.occup","duration",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_TUG_DURATION")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TUG_DURATION" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TUG_DURATION" property="value"/>'/> s
	    	</td>
			<td class='admin2' colspan='3'>
				<%=getTran(request,"web","armrest",sWebLanguage)%>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TUG_ARMREST" property="itemId"/>]>.value' id ='armrest_tug'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.armrest",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TUG_ARMREST"),sWebLanguage) %>
	           	</select>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","sit2stand",sWebLanguage)%></td>
			<td class='admin2' colspan='5'>
				<%=getTran(request,"web","armrest",sWebLanguage)%>
	           	<select class='text' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SIT2UP_ARMREST" property="itemId"/>]>.value' id ='armrest_sit2up'>
	           		<option/>
	           		<%=ScreenHelper.writeSelect(request,"cnrkr.armrest",((TransactionVO)transaction).getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_SIT2UP_ARMREST"),sWebLanguage) %>
	           	</select>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","barefootwalking",sWebLanguage)%></td>
			<td class='admin2' colspan='5'>
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_BAREFOOTWALKING")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BAREFOOTWALKING" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BAREFOOTWALKING" property="value"/></textarea>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","tipoftoeswalking",sWebLanguage)%></td>
			<td class='admin2' colspan='5'>
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_TIPOFTOESWALKING")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TIPOFTOESWALKING" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_TIPOFTOESWALKING" property="value"/></textarea>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","heelwalking",sWebLanguage)%></td>
			<td class='admin2' colspan='5'>
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_HEELWALKING")%> class="text" cols="80" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HEELWALKING" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_HEELWALKING" property="value"/></textarea>
			</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","onelegbalance",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web","right",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_BALANCERIGHT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BALANCERIGHT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BALANCERIGHT" property="value"/>'/> s
	    	</td>
	       	<td class="admin2"><%=getTran(request,"web","left",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_BALANCELEFT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BALANCELEFT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_BALANCELEFT" property="value"/>'/> s
	    	</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","kneebending",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web","numberofbends",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_KNEEBENDING_NUMBER")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KNEEBENDING_NUMBER" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KNEEBENDING_NUMBER" property="value"/>'/>
	    	</td>
	       	<td class="admin2">
	       		<%=getTran(request,"web","assistance",sWebLanguage)%>
	       	</td>
	       	<td class="admin2">
               <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KNEEBENDING_ASSISTANCE")%> class="text" cols="40" rows="1" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KNEEBENDING_ASSISTANCE" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KNEEBENDING_ASSISTANCE" property="value"/></textarea>
	    	</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","jamar",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web","right",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_JAMARRIGHT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_JAMARRIGHT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_JAMARRIGHT" property="value"/>'/> kg
	    	</td>
	       	<td class="admin2"><%=getTran(request,"web","left",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_JAMARLEFT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_JAMARLEFT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_JAMARLEFT" property="value"/>'/> kg
	    	</td>
       </tr>
       <tr>
           <td class="admin"><%=getTran(request,"web","pinch",sWebLanguage)%></td>
	       	<td class="admin2"><%=getTran(request,"web","right",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_PINCHRIGHT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PINCHRIGHT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PINCHRIGHT" property="value"/>'/> kg
	    	</td>
	       	<td class="admin2"><%=getTran(request,"web","left",sWebLanguage)%></td>
	    	<td class="admin2">
	       		<input <%=setRightClick(session,"ITEM_TYPE_CNRKR_PINCHLEFT")%> type='text' class='text' size='5' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PINCHLEFT" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_PINCHLEFT" property="value"/>'/> kg
	    	</td>
       </tr>
       
       
       
		</table>
	</td>
 </tr>
</table>
</logic:present>
