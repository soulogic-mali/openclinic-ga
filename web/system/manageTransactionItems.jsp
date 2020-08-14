<%@page import="be.mxs.common.util.db.MedwanQuery,
                be.openclinic.system.TransactionItem,java.util.Vector" %>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%=checkPermission(out,"system.management","all",activeUser)%>
<%
    String sAction = checkString(request.getParameter("ActionField"));
    String sFindKey1 = checkString(request.getParameter("FindKey1")); // transactionTypeId
    String sFindKey2 = checkString(request.getParameter("FindKey2")); // itemTypeId
    String msg = null;

    // form values
    String transactionTypeId = checkString(request.getParameter("transactionTypeId"));
    String itemTypeId = checkString(request.getParameter("itemTypeId"));
    String defaultValue = checkString(request.getParameter("defaultValue"));
    String modifier = checkString(request.getParameter("modifier"));
    String priority = checkString(request.getParameter("priority"));
    String oldTransactionTypeId = checkString(request.getParameter("oldTransactionTypeId"));
    String oldItemTypeId = checkString(request.getParameter("oldItemTypeId"));

    try{
    	int p = Integer.parseInt(priority);
    }
    catch(Exception e){
    	priority="0";
    }

    boolean showAlert = false;

    String selectedTransactionTypeId = "";
    String selectedItemTypeId = "";
    String selectedDefaultValue = "";
    String selectedModifier = "";
    String selectedPrintChapter = "";
    String selectedResultLabelType = "";
    String selectedPriority = "";

    // "Save" on a non-existant record means "Add"
    if (sAction.equals("Save") && (oldTransactionTypeId.equals("") || oldItemTypeId.equals(""))) {
        sAction = "Add";
    }

    //*** SAVE ***************************************************************************************
    if (sAction.equals("Save") && !transactionTypeId.equals("") && !itemTypeId.equals("")) {
        // UPDATE
        if ((transactionTypeId.equals(oldTransactionTypeId) && itemTypeId.equals(oldItemTypeId))) {
            // update the displayed record
            TransactionItem objTI = new TransactionItem();
            objTI.setTransactionTypeId(transactionTypeId);
            objTI.setItemTypeId(itemTypeId);
            objTI.setDefaultValue(defaultValue);
            objTI.setModifier(modifier);
            objTI.setPriority(Integer.parseInt(priority));

            TransactionItem.saveTransactionItem(objTI, transactionTypeId, itemTypeId);

            msg = "'" + itemTypeId + "' " + getTran(request,"Web", "saved", sWebLanguage);
        } else {
            // check if record with new ids allready exists
            boolean bExists = false;
            bExists = TransactionItem.exists(transactionTypeId, itemTypeId);

            if (!bExists) {
                TransactionItem objTI = new TransactionItem();
                objTI.setTransactionTypeId(transactionTypeId);
                objTI.setItemTypeId(itemTypeId);
                objTI.setDefaultValue(defaultValue);
                objTI.setModifier(modifier);
                objTI.setPriority(Integer.parseInt(priority));

                TransactionItem.saveTransactionItem(objTI, oldTransactionTypeId, oldItemTypeId);

                msg = "'" + itemTypeId + "' " + getTran(request,"Web", "saved", sWebLanguage);
            } else {
                // a record with the given ids allready exists
                showAlert = true;
            }
        }
    }
    //*** ADD ****************************************************************************************
    else if (sAction.equals("Add") && !transactionTypeId.equals("") && !itemTypeId.equals("")) {
        // EXISTS ?
        boolean bExists = false;
        bExists = TransactionItem.exists(transactionTypeId, itemTypeId);

        if (!bExists) {
            TransactionItem objTI = new TransactionItem();
            objTI.setTransactionTypeId(transactionTypeId);
            objTI.setItemTypeId(itemTypeId);
            objTI.setDefaultValue(defaultValue);
            objTI.setModifier(modifier);
            objTI.setPriority(Integer.parseInt(priority));

            TransactionItem.addTransactionItem(objTI);

            sFindKey1 = transactionTypeId;
            sFindKey2 = itemTypeId;

            msg = "'" + itemTypeId + "' " + getTran(request,"Web", "added", sWebLanguage);
        } else {
            // a record with the given ids allready exists
            showAlert = true;
        }
    }
    //*** DELETE *************************************************************************************
    else if (sAction.equals("Delete") && !transactionTypeId.equals("") && !itemTypeId.equals("")) {
        TransactionItem.deleteTransactionItem(sFindKey1, sFindKey2);
        msg = "'" + sFindKey2 + "' " + getTran(request,"Web", "deleted", sWebLanguage);
        sFindKey2 = "-1";
    }

    //*** reload ***
    if (!sAction.equals("")) {
        MedwanQuery.reload();
    }

    StringBuffer sOut1 = new StringBuffer();
    StringBuffer sOut2 = new StringBuffer();

    //*** compose TransactionType select *************************************************************
    Vector vTI = TransactionItem.selectDistinctTransactionTypeId();
    Iterator iter = vTI.iterator();

    while (iter.hasNext()) {
        transactionTypeId = (String) iter.next();

        sOut1.append("<option value='" + transactionTypeId + "'");
        if (transactionTypeId.equals(sFindKey1)) {
            selectedTransactionTypeId = transactionTypeId;
            sOut1.append("selected");
        }
        sOut1.append(">" + transactionTypeId + "</option>");
    }

    //*** compose itemType select ********************************************************************
    Vector vTI2 = TransactionItem.selectByTransactionTypeId(sFindKey1);
    Iterator iter2 = vTI2.iterator();

    TransactionItem objTI;
    while (iter2.hasNext()) {
        objTI = (TransactionItem) iter2.next();
        itemTypeId = checkString(objTI.getItemTypeId());

        sOut2.append("<option value='" + itemTypeId + "'");
        if (itemTypeId.equals(sFindKey2)) {
            selectedItemTypeId = itemTypeId;
            selectedDefaultValue = checkString(objTI.getDefaultValue());
            selectedModifier = checkString(objTI.getModifier());
            selectedResultLabelType = checkString(objTI.getResultLabelType());
            selectedPrintChapter = checkString(objTI.getPrintChapter());
            selectedPriority = checkString(objTI.getPriority()+"");
            sOut2.append("selected");
        }
        sOut2.append(">" + itemTypeId + "</option>");
    }

%>

<%-- SEARCHTABLE ---------------------------------------------------------------------------------%>
<form name="transactionForm" method="post">
	<input type='hidden' name='modifier' value='<%=selectedModifier%>'/>
	<%=writeTableHeader("Web.manage","manageTransactionItems",sWebLanguage,"main.do?Page=system/menu.jsp")%>
	<table border="0" width="100%" align="center" cellspacing="1" class="list">
	  <tr>
	    <td class="admin2" width="<%=sTDAdminWidth%>">&nbsp;TransactionTypeId</td>
	    <td class="admin2">
	      <select name="FindKey1" class="text" onchange="transactionForm.submit();">
	        <option value="-1"><%=getTran(request,"Web","select",sWebLanguage)%></option>
	        <%=sOut1%>
	      </select>
	    </td>
	  </tr>
	  <tr>
	    <td class="admin2">&nbsp;ItemTypeId</td>
	    <td class="admin2">
	      <select name="FindKey2" class="text" onchange="transactionForm.submit();">
	        <option value="-1"><%=getTran(request,"Web","select",sWebLanguage)%></option>
	        <%=sOut2%>
	      </select>
	
	      <%-- NEW BUTTON --%>
	      <input class="button" type="button" name="NewButton" value="<%=getTranNoLink("Web","New",sWebLanguage)%>" onclick="doNew();">
	    </td>
	  </tr>
	</table>
	<br><br>
	<%-- DETAILS OF SELECTED TRANSACTION -------------------------------------------------------------%>
	<table class="list" width="100%" cellspacing="1">
	  <tr>
	    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","transactiontypeid",sWebLanguage) %></td>
	    <td class="admin2">
	      <input class="text" type="text" name="transactionTypeId" id="transactionTypeId" value="<%=selectedTransactionTypeId%>" size="130" maxLength="255">
	    </td>
	  </tr>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","itemtypeid",sWebLanguage) %></td>
	    <td class="admin2">
	      <input class="text" type="text" name="itemTypeId" value="<%=selectedItemTypeId%>" size="130" maxLength="255">
	    </td>
	  </tr>
	  <%
	  	if(selectedItemTypeId.length()>0){
	  %>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","label",sWebLanguage) %></td>
	    <td class="admin2">
	      <%=getTran(request,"web.occup",selectedItemTypeId,sWebLanguage) %>
	    </td>
	  </tr>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","printchapter",sWebLanguage) %></td>
	    <td class="admin2">
	    	<select class='text' name='printchapter'>
	    		<option/>
	    		<%=ScreenHelper.writeSelect(request, selectedTransactionTypeId, selectedPrintChapter, sWebLanguage) %>
	    	</select>
	    	<img src='<%=sCONTEXTPATH %>/_img/icons/icon_edit.png' onclick='manageChapters()'/>
	    </td>
	  </tr>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","resultlabeltype",sWebLanguage) %></td>
	    <td class="admin2">
	    	<select class='text' name='resultlabeltype'>
	    		<option/>
	            <%
	                String sTmpLabeltype;
	                java.util.Vector vLabelTypes = Label.getLabelTypes();
	                iter = vLabelTypes.iterator();
	
	                while(iter.hasNext()){
	                    sTmpLabeltype = (String)iter.next();
	                    %><option value="<%=sTmpLabeltype%>" <%=(sTmpLabeltype.equalsIgnoreCase(selectedResultLabelType)?"selected":"")%>><%=sTmpLabeltype%></option><%
	                }
	            %>
	    	</select>
	    </td>
	  </tr>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","printorder",sWebLanguage) %></td>
	    <td class="admin2">
	    	<input type='text' name='priority' class='text' size='10' value='<%=selectedPriority %>'/>
	    </td>
	  </tr>
	  <tr>
	    <td class="admin"><%=getTran(request,"web","defaultvalue",sWebLanguage) %></td>
	    <td class="admin2">
	      <textarea onKeyup="resizeTextarea(this,10);" class="text" name="defaultValue" rows="4" cols="80" onKeyUp="checkMaxChars(this,255);"><%=selectedDefaultValue%></textarea>
	    </td>
	  </tr>
	  <%
	  	}	
	  %>
	  <tr>
	      <td class="admin"/>
	      <td class="admin2">
	          <input class="button" type="button" name="AddButton"    value="<%=getTranNoLink("Web","Add",sWebLanguage)%>"    onclick="checkAdd();">&nbsp;
	          <input class="button" type="button" name="SaveButton"   value="<%=getTranNoLink("Web","Save",sWebLanguage)%>"   onclick="checkSave();">&nbsp;
	          <input class="button" type="button" name="DeleteButton" value="<%=getTranNoLink("Web","Delete",sWebLanguage)%>" onclick="askDelete();">&nbsp;
	          <input class="button" type="button" name="backbutton"   value="<%=getTranNoLink("Web","Back",sWebLanguage)%>"   onclick="doBack();">
	
	          <%-- link to synchronise transactionItems with ini --%>
	          <img src='<c:url value="/_img/themes/default/pijl.gif"/>'>
	          <a  href="<c:url value='/main.do?Page=system/syncTransactionItemsWithIni.jsp?ts='/><%=getTs()%>" onMouseOver="window.status='';return true;"><%=getTran(request,"Web.manage","synchronizetransactionitemswithini",sWebLanguage)%></a>&nbsp;
	      </td>
	  </tr>
	  <%-- MESSAGE -----------------------------------------------------------------------------------%>
	  <tr>
	    <td class="admin2" colspan="2">
	    <%
	        if(msg == null){
	            msg = getTran(request,"Web.Manage","noDataChanged",sWebLanguage);
	        }
	        out.print(msg);
	    %>
	    </td>
	  </tr>
	</table>
	<input type="hidden" name="oldTransactionTypeId" value="<%=selectedTransactionTypeId%>">
	<input type="hidden" name="oldItemTypeId" value="<%=selectedItemTypeId%>">
	<input type="hidden" name="ActionField">
	<%-- ALERT ---------------------------------------------------------------------------------------%>
	<%
	  if(showAlert){
	    %><script>alertDialog("web.manage","transactionItemExists");</script><%
	  }
	%>
	<%-- SCRIPTS TILL EOF ----------------------------------------------------------------------------%>
	<script>
	<%
	  if(sFindKey1.equals("") || sFindKey1.equals("-1")){
	    out.print("transactionForm.FindKey1.focus();");
	  }
	  else{
	    out.print("transactionForm.FindKey2.focus();");
	  }
	%>
	function checkMaxChars(inputObj,maxChars){
	  if(inputObj.value.length > maxChars){
	    inputObj.value = inputObj.value.substring(0,maxChars);
	  }
	}
	function manageChapters(){
		window.open('/openclinic/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType='+document.getElementById('transactionTypeId').value+'&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');
	}
	function keysNotEmpty(){
	  if(transactionForm.transactionTypeId.value==""){
	    alertDialog("web","TransactionItemKeyFieldsAreEmpty");
	    transactionForm.transactionTypeId.focus();
	    return false;
	  }
	  else if(transactionForm.itemTypeId.value==""){
	    alertDialog("web","TransactionItemKeyFieldsAreEmpty");
	    transactionForm.itemTypeId.focus();
	    return false;
	  }
	  return true;
	}
	
	function checkSave(){
	  if(keysNotEmpty()){
		transactionForm.modifier.value=transactionForm.printchapter.value+';'+transactionForm.resultlabeltype.value;
	    transactionForm.ActionField.value = 'Save';
	    transactionForm.submit();
	  }
	}
	
	function checkAdd(){
	  if(keysNotEmpty()){
	    transactionForm.ActionField.value = "Add";
	    transactionForm.submit();
	  }
	}
	
	function doBack(){
	  window.location.href = "<c:url value='/main.do'/>?Page=system/menu.jsp";
	}
	
	function askDelete() {
	  if(transactionForm.FindKey1.value=="-1"){
	    alertDialog("web","FirstSelectTransactionItem");
	    transactionForm.FindKey1.focus();
	  }
	  else if(transactionForm.FindKey2.value=="-1"){
	    alertDialog("web","FirstSelectTransactionItem");
	    transactionForm.FindKey2.focus();
	  }
	  else if(transactionForm.transactionTypeId.value==""){
	    alertDialog("web","TransactionItemKeyFieldsAreEmpty");
	    transactionForm.transactionTypeId.focus();
	  }
	  else if(transactionForm.itemTypeId.value==""){
	    alertDialog("web","TransactionItemKeyFieldsAreEmpty");
	    transactionForm.itemTypeId.focus();
	  }
	  else{
	    if(yesnoDeleteDialog()){
	      transactionForm.ActionField.value = "Delete";
	      transactionForm.submit();
	    }
	  }
	}
	
	function doNew(){
	  if(!(transactionForm.FindKey1.value == "-1" && transactionForm.FindKey2.value == "-1")){
	    if(transactionForm.FindKey1.value != "-1"){
	      transactionForm.transactionTypeId.value = transactionForm.FindKey1.value;
	    }
	
	    if(transactionForm.FindKey2.value != "-1"){
	      transactionForm.itemTypeId.value = transactionForm.FindKey2.value;
	    }
	
	    transactionForm.defaultValue.value = "";
	    transactionForm.printchapter.value = "";
	    transactionForm.resultlabeltype.value = "";
	
	    transactionForm.transactionTypeId.focus();
	    transactionForm.NewButton.disabled = true;
	    transactionForm.SaveButton.disabled = true;
	  }
	}
	</script>
</form>