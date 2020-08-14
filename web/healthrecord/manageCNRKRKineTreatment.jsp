<%@page import="be.mxs.common.model.vo.healthrecord.TransactionVO,
                be.mxs.common.model.vo.healthrecord.ItemVO,
                be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.medical.*,
                be.openclinic.system.Transaction,
                be.openclinic.system.Item,
                java.util.*" %>
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
<input type='hidden' id='treatments' name='currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_TREATMENTS" property="itemId"/>]>.value' value='<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_TREATMENTS" property="value"/>'/>
<table class="list" cellspacing="1" cellpadding="0" width="100%">
    <tr class="admin" style="padding:0px;">
        <td colspan="6"><%=getTran(request,"web","comments",sWebLanguage)%></td>
    </tr>
    <tr class="admin" style="padding:0px;">
        <td class="admin" colspan='2'><%=getTran(request,"web","comments",sWebLanguage)%></td>
        <td class="admin2" colspan='4'>
            <textarea onKeyup="resizeTextarea(this,10);limitChars(this,5000);" <%=setRightClick(session,"ITEM_TYPE_CNRKR_KINE_TREATMENTCOMMENTS")%> class="text" cols="80" rows="2" name="currentTransactionVO.items.<ItemVO[hashCode=<mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_TREATMENTCOMMENTS" property="itemId"/>]>.value"><mxs:propertyAccessorI18N name="transaction.items" scope="page" compare="type=be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNRKR_KINE_TREATMENTCOMMENTS" property="value"/></textarea>
        </td>
    </tr>
	<tr>
		<td colspan='6'>
			<div id='divTreatments'/>
		</td>
	</tr>
</table>

<script>
	function addTreatment(date,act1,act2,act3,act4,act5,act6,act7,act8,act9,act10,comment){
		if(document.getElementById('treatments').value.length>0){
			document.getElementById('treatments').value+="£";
		}
		document.getElementById('treatments').value += date+";"+act1+";"+act2+";"+act3+";"+act4+";"+act5+";"+act6+";"+act7+";"+act8+";"+act9+";"+act10+";"+comment;
		writeTreatments();
	}
	function deleteTreatment(row){
	    if(confirm("<%=getTran(null,"Web","AreYouSure",sWebLanguage)%>")){
			var treatments = document.getElementById('treatments').value.split("£");
			for(n=0;n<treatments.length;n++){
				if(n==row){
					if(n>0){
						document.getElementById('treatments').value= document.getElementById('treatments').value.replace('£'+treatments[n],'');
					}
					else if (treatments.length>1){
						document.getElementById('treatments').value= document.getElementById('treatments').value.replace(treatments[n]+'£','');
					}
					else{
						document.getElementById('treatments').value= document.getElementById('treatments').value.replace(treatments[n],'');
					}
				}
			}
			writeTreatments();
	    }
	}
	function editTreatment(row,date,act1,act2,act3,act4,act5,act6,act7,act8,act9,act10,comment){
		var newTreatments="";
		var treatments = document.getElementById('treatments').value.split("£");
		for(n=0;n<treatments.length;n++){
			if(n>0){
				newTreatments+="£";
			}
			if(n==row){
				newTreatments+= date+";"+act1+";"+act2+";"+act3+";"+act4+";"+act5+";"+act6+";"+act7+";"+act8+";"+act9+";"+act10+";"+comment;
			}
			else{
				newTreatments+= treatments[n];
			}
		}
		document.getElementById('treatments').value = newTreatments;
		writeTreatments();
	}
	function writeTreatments(){
		while(document.getElementById('treatments').value.indexOf("\n")>-1){
			document.getElementById('treatments').value=document.getElementById('treatments').value.replace("\n","<BR/>");
		}
		//Show all the treatments in tabular format on the form
		//Ajax to be able to translate
		document.getElementById("divTreatments").innerHTML="";
	    var today = new Date();
	    var url= '<c:url value="/healthrecord/getKineTreatments.jsp"/>?language=<%=sWebLanguage%>&treatments='+document.getElementById('treatments').value+'&ts='+today;
	    new Ajax.Request(url,{
		  method: "POST",
	      parameters: "",
	      onSuccess: function(resp){
	    	  document.getElementById("divTreatments").innerHTML=resp.responseText;
	      }
		});
	}
	function addTreatmentLine(){
	  openPopup("/healthrecord/editKineTreatment.jsp&PopupWidth=500&new=true&language=<%=sWebLanguage%>");
	}
	function editTreatmentLine(row){
		var treatments = document.getElementById('treatments').value.split("£");
		for(n=0;n<treatments.length;n++){
			if(n==row){
				var date = treatments[n].split(";")[0];
				var act1 = treatments[n].split(";").length<=1?"":treatments[n].split(";")[1];
				var act2 = treatments[n].split(";").length<=2?"":treatments[n].split(";")[2];
				var act3 = treatments[n].split(";").length<=3?"":treatments[n].split(";")[3];
				var act4 = treatments[n].split(";").length<=4?"":treatments[n].split(";")[4];
				var act5 = treatments[n].split(";").length<=5?"":treatments[n].split(";")[5];
				var act6 = treatments[n].split(";").length<=6?"":treatments[n].split(";")[6];
				var act7 = treatments[n].split(";").length<=7?"":treatments[n].split(";")[7];
				var act8 = treatments[n].split(";").length<=8?"":treatments[n].split(";")[8];
				var act9 = treatments[n].split(";").length<=9?"":treatments[n].split(";")[9];
				var act10 = treatments[n].split(";").length<=10?"":treatments[n].split(";")[10];
				var comment = treatments[n].split(";").length<=11?"":treatments[n].split(";")[11];
				openPopup("/healthrecord/editKineTreatment.jsp&PopupWidth=500&new=false&language=<%=sWebLanguage%>&row="+row+"&date="+date+"&act1="+act1+"&act2="+act2+"&act3="+act3+"&act4="+act4+"&act5="+act5+"&act6="+act6+"&act7="+act7+"&act8="+act8+"&act9="+act9+"&act10="+act10+"&comment="+comment);
				break;
			}
		}
	}
	writeTreatments();
</script>

</logic:present>
