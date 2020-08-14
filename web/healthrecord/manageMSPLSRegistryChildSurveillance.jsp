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
	String accessright="mspls.registry.childsurv";
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
    
    <table class="list" width="100%" cellspacing="1">
    	<tr>
    		<td>
    			<table width=100%'>
			        <%-- DATE --%>
			        <tr>
			            <td class="admin" width="<%=sTDAdminWidth%>" colspan="2">
			                <a href="javascript:openHistoryPopup();" title="<%=getTranNoLink("Web.Occup","History",sWebLanguage)%>">...</a>&nbsp;
			                <%=getTran(request,"Web.Occup","medwan.common.date",sWebLanguage)%>
			                <input type="text" class="text" size="12" maxLength="10" name="currentTransactionVO.<TransactionVO[hashCode=<bean:write name="transaction" scope="page" property="transactionId"/>]>.updateTime" value="<mxs:propertyAccessorI18N name="transaction" scope="page" property="updateTime" formatType="date"/>" id="trandate" OnBlur='checkDate(this)'>
			                <script>writeTranDate();</script>
			            </td>
			        </tr>
			
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "newcase", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno",  "ITEM_TYPE_NEWCASE", sWebLanguage, true, "", " ") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "brachialcircimference", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO) transaction, "ITEM_TYPE_BRACHIALCIRCUMFERENCE", 5, 10, 1000, sWebLanguage,"checkAdmissionCriteria();") %> mm
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "weight", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO) transaction, "ITEM_TYPE_WEIGHT", 5, 2, 150, sWebLanguage,"a=1","onkeyup='calculateWeightOverHeight();'") %> kg
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "height", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultNumericInput(session, (TransactionVO) transaction, "ITEM_TYPE_HEIGHT", 5, 20, 250, sWebLanguage,"a=1","onkeyup='calculateWeightOverHeight();'") %> cm
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "weightoverlength", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultTextInputReadonly(session, (TransactionVO)transaction, "ITEM_TYPE_WEIGHTOVERHEIGHT", 5, "class='readonly2'") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "weightoverlengthz", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultTextInputReadonly(session, (TransactionVO)transaction, "ITEM_TYPE_WEIGHTOVERHEIGHTZ", 5, "class='readonly2'") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "weightforagez", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultTextInputReadonly(session, (TransactionVO)transaction, "ITEM_TYPE_WEIGHTFORAGEZ", 5, "class='readonly2'") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "lengthforagez", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultTextInputReadonly(session, (TransactionVO)transaction, "ITEM_TYPE_LENGTHFORAGEZ", 5, "class='readonly2'") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "nutritionstatus", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultCheckBoxes((TransactionVO)transaction, request, "mspls.nutritionstatus", "ITEM_TYPE_NUTRITIONSTATUS", sWebLanguage, false,"") %>
			            </td>
			        </tr>
			        <tr>
			            <td class="admin"><%=getTran(request,"web", "referral", sWebLanguage)%></td>
			            <td class="admin2">
			            	<%=ScreenHelper.writeDefaultRadioButtons((TransactionVO)transaction, request, "yesno",  "ITEM_TYPE_REFERRAL", sWebLanguage, true, "", " ") %>
			            </td>
			        </tr>
				</table>
			</td>
			<td valign="top" class='admin2'>
				<%ScreenHelper.setIncludePage("/healthrecord/who/getGrowthCurves.jsp",pageContext);%>
			</td>
		</tr>        
        <tr>
        	<td colspan='2'><%ScreenHelper.setIncludePage(customerInclude("healthrecord/diagnosesEncoding.jsp"),pageContext);%></td>
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
var oldWeight=document.getElementById("ITEM_TYPE_WEIGHT").value.trim();
var oldHeight=document.getElementById("ITEM_TYPE_HEIGHT").value.trim();

function calculateWeightOverHeight(){
	  if(document.getElementById("ITEM_TYPE_WEIGHT").value.trim()=="" || document.getElementById("ITEM_TYPE_HEIGHT").value.trim()==""){
		  document.getElementById("ITEM_TYPE_WEIGHTOVERHEIGHT").value="";
	  }
	  else{
		  document.getElementById("ITEM_TYPE_WEIGHTOVERHEIGHT").value=(document.getElementById("ITEM_TYPE_WEIGHT").value/document.getElementById("ITEM_TYPE_HEIGHT").value).toFixed(2);
		  checkWeightForHeight(document.getElementById("ITEM_TYPE_HEIGHT").value,document.getElementById("ITEM_TYPE_WEIGHT").value,"ITEM_TYPE_WEIGHTOVERHEIGHTZ","ITEM_TYPE_WEIGHTFORAGEZ","ITEM_TYPE_LENGTHFORAGEZ");
	  }
	  if(document.getElementById("ITEM_TYPE_WEIGHT").value*1>0 && document.getElementById("ITEM_TYPE_HEIGHT").value*1>0){
		  if(document.getElementById("ITEM_TYPE_WEIGHT").value!=oldWeight || document.getElementById("ITEM_TYPE_HEIGHT").value!=oldHeight){
			  drawGraphs();
			  oldWeight=document.getElementById("ITEM_TYPE_WEIGHT").value;
			  oldHeight=document.getElementById("ITEM_TYPE_HEIGHT").value;
		  }
	  }
}

	function checkWeightForHeight(height,weight,fieldid,fieldid2,fieldid3){
		var today = new Date();
 	    var url= '<c:url value="/ikirezi/getWeightForHeight.jsp"/>?height='+height+'&weight='+weight+'&age=<%=new Double((((TransactionVO)transaction).getUpdateTime().getTime()-SH.parseDate(activePatient.dateOfBirth).getTime())/SH.getTimeDay()).intValue() %>&gender=<%=activePatient.gender%>&ts='+today;
	      new Ajax.Request(url,{
	          method: "POST",
	          postBody: "",
	          onSuccess: function(resp){
	              var label = eval('('+resp.responseText+')');
	    		  if(label.zindex>-999){
    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.2").checked=false;
	    			  if(label.zindex<-3){
	    				  document.getElementById(fieldid).className="darkredtext";
	    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.2").checked=true;
	    			  }
	    			  else if(label.zindex<-2){
	    				  document.getElementById(fieldid).className="orangetext";
	    			  }
	    			  else if(label.zindex<-1){
	    				  document.getElementById(fieldid).className="yellowtext";
	    			  }
	    			  else if(label.zindex>2){
	    				  document.getElementById(fieldid).className="orangetext";
	    			  }
	    			  else if(label.zindex>1){
	    				  document.getElementById(fieldid).className="yellowtext";
	    			  }
	    			  else{
	    				  document.getElementById(fieldid).className="text";
	    			  }
	    			  document.getElementById(fieldid).value=(label.zindex*1).toFixed(2);
	    		  }
	    		  else{
	    			  document.getElementById(fieldid).value="";
				  	  document.getElementById(fieldid).className="text";
	    		  }
	    		  if(label.zindexWFA>-999){
    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.3").checked=false;
	    			  if(label.zindexWFA<-3){
	    				  document.getElementById(fieldid2).className="darkredtext";
	    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.3").checked=true;
	    			  }
	    			  else if(label.zindexWFA<-2){
	    				  document.getElementById(fieldid2).className="orangetext";
	    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.3").checked=true;
	    			  }
	    			  else if(label.zindexWFA<-1){
	    				  document.getElementById(fieldid2).className="yellowtext";
	    			  }
	    			  else if(label.zindexWFA>2){
	    				  document.getElementById(fieldid2).className="orangetext";
	    			  }
	    			  else if(label.zindexWFA>1){
	    				  document.getElementById(fieldid2).className="yellowtext";
	    			  }
	    			  else{
	    				  document.getElementById(fieldid2).className="text";
	    			  }
	    			  document.getElementById(fieldid2).value=(label.zindexWFA*1).toFixed(2);
	    		  }
	    		  else{
	    			  document.getElementById(fieldid2).value="";
				  	  document.getElementById(fieldid2).className="text";
	    		  }
	    		  if(label.zindexLFA>-999){
    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.4").checked=false;
	    			  if(label.zindexLFA<-3){
	    				  document.getElementById(fieldid3).className="darkredtext";
	    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.4").checked=true;
	    			  }
	    			  else if(label.zindexLFA<-2){
	    				  document.getElementById(fieldid3).className="orangetext";
	    				  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.4").checked=true;
	    			  }
	    			  else if(label.zindexLFA<-1){
	    				  document.getElementById(fieldid3).className="yellowtext";
	    			  }
	    			  else if(label.zindexLFA>2){
	    				  document.getElementById(fieldid3).className="orangetext";
	    			  }
	    			  else if(label.zindexLFA>1){
	    				  document.getElementById(fieldid3).className="yellowtext";
	    			  }
	    			  else{
	    				  document.getElementById(fieldid3).className="text";
	    			  }
	    			  document.getElementById(fieldid3).value=(label.zindexLFA*1).toFixed(2);
	    		  }
	    		  else{
	    			  document.getElementById(fieldid3).value="";
				  	  document.getElementById(fieldid3).className="text";
	    		  }
	    		  if(document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.2").checked==false && document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.3").checked==false && document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.4").checked==false){
	    			  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.1").checked=true;
	    		  }
	    		  else{
	    			  document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.1").checked=false;
	    		  }
				  updateMultiCheckbox(document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.1"),"ITEM_TYPE_NUTRITIONSTATUS","1")
				  updateMultiCheckbox(document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.2"),"ITEM_TYPE_NUTRITIONSTATUS","2")
				  updateMultiCheckbox(document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.3"),"ITEM_TYPE_NUTRITIONSTATUS","3")
				  updateMultiCheckbox(document.getElementById("ITEM_TYPE_NUTRITIONSTATUS.4"),"ITEM_TYPE_NUTRITIONSTATUS","4")

	          },
	          onFailure: function(){
	          }
	      }
		  );
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
  calculateWeightOverHeight();
</script>
    
<%=writeJSButtons("transactionForm","saveButton")%>