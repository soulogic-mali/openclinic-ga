<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"pharmacy.manageproductorders","edit",activeUser)%>

<%
    String sAction = checkString(request.getParameter("Action"));
    if(sAction.length()==0) sAction = "showDetailsNew"; // default

    // retreive form data
    String sEditOrderUid        = checkString(request.getParameter("EditOrderUid")),
           sEditDescription     = checkString(request.getParameter("EditDescription")),
           sEditProductStockUid = checkString(request.getParameter("EditProductStockUid")),
           sEditPackagesOrdered = checkString(request.getParameter("EditPackagesOrdered")),
           sEditDateOrdered     = checkString(request.getParameter("EditDateOrdered")),
           sEditDateDeliveryDue = checkString(request.getParameter("EditDateDeliveryDue")),
           sEditFrom			= checkString(request.getParameter("EditFrom")),
           sEditImportance      = checkString(request.getParameter("EditImportance")); // (native|high|low)

    // afgeleide data
    String sEditProductName = checkString(request.getParameter("EditProductName"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************* pharmacy/popups/orderProduct.jsp ******************");
        Debug.println("sAction              : "+sAction);
        Debug.println("sEditOrderUid        : "+sEditOrderUid);
        Debug.println("sEditDescription     : "+sEditDescription);
        Debug.println("sEditProductStockUid : "+sEditProductStockUid);
        Debug.println("sEditPackagesOrdered : "+sEditPackagesOrdered);
        Debug.println("sEditDateOrdered     : "+sEditDateOrdered);
        Debug.println("sEditDateDeliveryDue : "+sEditDateDeliveryDue);
        Debug.println("sEditImportance      : "+sEditImportance);
        Debug.println("sEditFrom      		: "+sEditFrom);
        Debug.println("sEditProductName     : "+sEditProductName+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    String msg = "",sSelectedProductStockUid = "", sSelectedDescription = "", sSelectedPackagesOrdered = "",
           sSelectedDateOrdered = "", sSelectedDateDeliveryDue = "", sSelectedImportance = "",
           sSelectedProductName = "", sSelectedFrom="";

    // defaults
    if(sEditDescription.length()==0) sEditDescription = sEditProductName;
    if(sEditImportance.length()==0) sEditImportance = "type1native";

    // calculate packages needed based on levels
    if(sEditPackagesOrdered.length()==0){
        //sEditPackagesOrdered = "1";
        ProductStock productStock = ProductStock.get(sEditProductStockUid);
        if(productStock!=null){
            int currLevel = productStock.getLevel();
            int reqLevel  = productStock.getMaximumLevel()-ProductOrder.getOpenOrderedQuantity(productStock.getUid());

            if(currLevel < reqLevel){
                int requiredQuantity = reqLevel-currLevel;
                int minOrderQuantity = productStock.getProduct().getMinimumOrderPackages();

                if(requiredQuantity >= minOrderQuantity) sEditPackagesOrdered = requiredQuantity+"";
                else                                     sEditPackagesOrdered = minOrderQuantity+"";
            }
            else{
            	sEditPackagesOrdered="0";
            }
        }
    }
    if(sEditFrom.length()==0 && sEditProductStockUid.length()>0){
        ProductStock productStock = ProductStock.get(sEditProductStockUid);
        if(productStock!=null){
			sEditFrom=checkString(productStock.getSupplierUid());
			if(sEditFrom.length()==0){
				sEditFrom=checkString(productStock.getServiceStock().getDefaultSupplierUid());
			}
        }
    }

    boolean displayEditFields = false;

    //*********************************************************************************************
    //*** process actions *************************************************************************
    //*********************************************************************************************

    //--- SAVE ------------------------------------------------------------------------------------
    if(sAction.equals("save") && sEditOrderUid.length()>0){
        // create order
        ProductOrder order = new ProductOrder();
        order.setUid(sEditOrderUid);
        order.setDescription(sEditDescription);
        order.setProductStockUid(sEditProductStockUid);
        if(sEditPackagesOrdered.length() > 0) order.setPackagesOrdered(Integer.parseInt(sEditPackagesOrdered));
        if(sEditDateOrdered.length() > 0)     order.setDateOrdered(ScreenHelper.parseDate(sEditDateOrdered));
        if(sEditDateDeliveryDue.length() > 0) order.setDateDeliveryDue(ScreenHelper.parseDate(sEditDateDeliveryDue));
        order.setImportance(sEditImportance); // (native|high|low)
        order.setUpdateUser(activeUser.userid);
        order.setFrom(sEditFrom);

        String orderWithSameDataUid = order.exists();
        boolean orderWithSameDataExists = orderWithSameDataUid.length()>0;

        if(sEditOrderUid.equals("-1")){
            //***** insert new order *****
            if(!orderWithSameDataExists){
                order.store(false);

                // show saved data
                sAction = "showDetailsNoOrderButton";
                msg = getTran(request,"web.manage","orderplaced",sWebLanguage);
            }
            //***** reject new addition *****
            else{
                // show rejected data
                sAction = "showDetailsAfterAddReject";
                msg = "<font color='red'>"+getTran(request,"web.manage","orderexists",sWebLanguage)+"</font>";
            }
        }
		out.println("<script>window.opener.location.reload();window.close();</script>");
		out.flush();
        sEditOrderUid = order.getUid();
    }

    //--- SHOW DETAILS ----------------------------------------------------------------------------
    if(sAction.startsWith("showDetails")){
        displayEditFields = true;

        // get specified record
        if(sAction.equals("showDetails") || sAction.equals("showDetailsNoOrderButton")){
            ProductOrder order = ProductOrder.get(sEditOrderUid);

            if(order!=null){
                sSelectedProductStockUid = order.getProductStockUid();
                sSelectedDescription     = order.getDescription();
                sSelectedPackagesOrdered = (order.getPackagesOrdered()<0?"":order.getPackagesOrdered()+"");
                sSelectedImportance      = order.getImportance();

                // format date ordered
                java.util.Date tmpDate = order.getDateOrdered();
                if(tmpDate!=null) sSelectedDateOrdered = ScreenHelper.formatDate(tmpDate);

                // format date delivery due
                tmpDate = order.getDateDeliveryDue();
                if(tmpDate!=null) sSelectedDateDeliveryDue = ScreenHelper.formatDate(tmpDate);

                sSelectedProductName = order.getProductStock().getProduct().getName();
                sSelectedFrom = checkString(order.getFrom());
            }
        }
        else if(sAction.equals("showDetailsAfterAddReject")){
            // do not get data from DB, but show data that were allready on form
            sSelectedProductStockUid = sEditProductStockUid;
            sSelectedDescription     = sEditDescription;
            sSelectedPackagesOrdered = sEditPackagesOrdered;
            sSelectedDateOrdered     = sEditDateOrdered;
            sSelectedDateDeliveryDue = sEditDateDeliveryDue;
            sSelectedImportance      = sEditImportance;
            sSelectedProductName     = sEditProductName;
            sSelectedFrom			 = sEditFrom;
        }
        else if(sAction.equals("showDetailsNew")){
            sSelectedProductStockUid = sEditProductStockUid;
            sSelectedDescription     = sEditDescription;
            sSelectedPackagesOrdered = sEditPackagesOrdered;
            sSelectedImportance      = sEditImportance;
            sSelectedProductName     = sEditProductName;
            sSelectedFrom			 = sEditFrom;
        }
    }
%>
<form name="transactionForm" id="transactionForm" method="post" onKeyDown="if(enterEvent(event,13)){doOrder();}" onClick="clearMessage();">
    <%=writeTableHeader("Web.manage","orderproduct",sWebLanguage,"window.close();")%> 
     
    <%
        //*****************************************************************************************
        //*** process display options *************************************************************
        //*****************************************************************************************

        //--- EDIT FIELDS -------------------------------------------------------------------------
        if(displayEditFields){
            %>
                <table class="list" width="100%" cellspacing="1">
                    <%-- Product --%>
                    <tr>
                        <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"Web","product",sWebLanguage)%>&nbsp;</td>
                        <td class="admin2"><%=sSelectedProductName%></td>
                    </tr>

                    <%-- description --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","description",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditDescription" value="<%=sSelectedDescription%>" size="60" maxLength="255">
                        </td>
                    </tr>

                    <%-- ProductStock --%>
                    <input type="hidden" name="EditProductStockUid" value="<%=sSelectedProductStockUid%>">
                    <input type="hidden" name="EditProductName" value="<%=sSelectedProductName%>">

                    <%-- PackagesOrdered --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","quantity",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <input type="text" class="text" name="EditPackagesOrdered" value="<%=sSelectedPackagesOrdered%>" size="5" maxLength="5" onBlur="if(this.value*1>0 && !isNumberLimited(this,1,<%=sSelectedPackagesOrdered%>)){alert(this.value+' > <%=sSelectedPackagesOrdered%>');this.value='<%=sSelectedPackagesOrdered%>';this.focus()}"> <= <%=sSelectedPackagesOrdered%>
                        </td>
                    </tr>

                    <%-- DateOrdered --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","Date",sWebLanguage)%> *</td>
                        <td class="admin2"><%=writeDateField("EditDateOrdered","transactionForm",sSelectedDateOrdered,sWebLanguage)%></td>
                        <%
                            // if new order : set today as default value for dateOrdered
                            if(sAction.equals("showDetailsNew")){
                                %><script>getToday(document.getElementsByName('EditDateOrdered')[0]);</script><%
                            }
                        %>
                    </tr>

                    <%-- supplier --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","orderfrom",sWebLanguage)%></td>
                        <td class="admin2">
                        	<select class='text' name='EditFrom' id='EditFrom'>
                        		<option value=''/>
                        		<%
                        			try{
                        				String thisServiceUid = "";
                        				ProductStock productStock = ProductStock.get(sEditProductStockUid);
                        				if(productStock!=null){
                        					thisServiceUid=productStock.getServiceStockUid();
                        				}
	                        			Vector servicestocks = ServiceStock.findAll();
	                        			for(int n=0;n<servicestocks.size();n++){
	                        				ServiceStock stock = (ServiceStock)servicestocks.elementAt(n);
	                        				if(stock!=null && !stock.getUid().equalsIgnoreCase(thisServiceUid)){
	                        					out.println("<option value='"+stock.getUid()+"' "+(sEditFrom.equalsIgnoreCase(stock.getUid())?"selected":"")+">"+stock.getName()+"</option>");
	                        				}
	                        			}
                        			}
                        			catch(Exception r){
                        				r.printStackTrace();
                        			}
                        		%>
                        	</select>
                        </td>
                    </tr>

                    <%-- DateDeliveryDue --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","DateDeliveryDue",sWebLanguage)%></td>
                        <td class="admin2"><%=writeDateField("EditDateDeliveryDue","transactionForm",sSelectedDateDeliveryDue,sWebLanguage)%></td>
                    </tr>

                    <%-- importance (dropdown : native|high|low) --%>
                    <tr>
                        <td class="admin"><%=getTran(request,"Web","Importance",sWebLanguage)%> *</td>
                        <td class="admin2">
                            <select class="text" name="EditImportance">
                                <option value=""><%=getTranNoLink("web","choose",sWebLanguage)%></option>
                                <%=ScreenHelper.writeSelectUnsorted(request,"productorder.importance",sSelectedImportance,sWebLanguage)%>
                            </select>
                        </td>
                    </tr>
                </table>
                <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>

                <%-- display message --%>
                <br><span id="msgArea"><%=msg%></span>

                <%-- EDIT BUTTONS --%>
                <%=ScreenHelper.alignButtonsStart()%>
                    <%
                        if(!sAction.equals("showDetailsNoOrderButton")){
                            %><input class="button" type="button" name="orderButton" value='<%=getTranNoLink("Web","order",sWebLanguage)%>' onclick="doOrder();"><%
                        }
                    %>

                    <input type="button" class="button" name="closeButton" value='<%=getTranNoLink("Web","close",sWebLanguage)%>' onclick='window.close();'>
                <%=ScreenHelper.alignButtonsStop()%>
            <%
        }
        else{
            %>
                <%=ScreenHelper.alignButtonsStart()%>
                    <input type="button" class="button" name="closeButton" value='<%=getTranNoLink("Web","close",sWebLanguage)%>' onclick='window.close();'>
                <%=ScreenHelper.alignButtonsStop()%>
            <%
        }
    %>

    <%-- hidden fields --%>
    <input type="hidden" name="Action">
    <input type="hidden" name="EditOrderUid" value="<%=sEditOrderUid%>">
</form>

<%-- SCRIPTS ------------------------------------------------------------------------------------%>
<script>
  window.resizeTo(550,290);

  <%
      // default focus field
      if(displayEditFields){
          %>transactionForm.EditDescription.focus();<%
      }
  %>

  <%-- DO ORDER --%>
  function doOrder(){
    transactionForm.EditOrderUid.value = "-1";
    doSave();
  }

  <%-- DO SAVE --%>
  function doSave(){
    if(checkOrderFields()){
      transactionForm.orderButton.disabled = true;
      transactionForm.Action.value = "save";
      transactionForm.submit();
    }
    else{
      if(transactionForm.EditDescription.value.length==0){
        transactionForm.EditDescription.focus();
      }
      else if(transactionForm.EditPackagesOrdered.value.length==0){
        transactionForm.EditPackagesOrdered.focus();
      }
      else if(transactionForm.EditDateOrdered.value.length==0){
        transactionForm.EditDateOrdered.focus();
      }
      else if(transactionForm.EditImportance.value.length==0){
        transactionForm.EditImportance.focus();
      }
    }
  }

  <%-- CHECK ORDER FIELDS --%>
  function checkOrderFields(){
    var maySubmit = false;

    <%-- required fields --%>
    if(!transactionForm.EditDescription.value.length==0 &&
       !transactionForm.EditProductStockUid.value.length==0 &&
       !transactionForm.EditPackagesOrdered.value.length==0 &&
       !transactionForm.EditDateOrdered.value.length==0 &&
       //!transactionForm.EditDateDeliveryDue.value.length==0 &&
       !transactionForm.EditImportance.value.length==0){
      maySubmit = true;

      <%-- check dates 1 and 2 --%>
      if(maySubmit){
        if(transactionForm.EditDateOrdered.value.length>0 && transactionForm.EditDateDeliveryDue.value.length>0){
          var dateOrdered     = transactionForm.EditDateOrdered.value;
          var dateDeliveryDue = transactionForm.EditDateDeliveryDue.value;

          if(!before(dateDeliveryDue,dateOrdered)){
            maySubmit = true;
          }
          else{
        	alertDialog("web","DateDeliveryDueMustComeAfterDateOrdered");
            maySubmit = false;
            transactionForm.EditDateDeliveryDue.focus();
          }
        }
        else{
          maySubmit = true;
        }
      }
    }
    else{
      maySubmit = false;
                alertDialog("web.manage","dataMissing");
    }

    return maySubmit;
  }

  <%-- CLEAR EDIT FIELDS --%>
  function clearEditFields(){
    transactionForm.EditProductStockUid.value = "";
    transactionForm.EditProductName.value = "";

    transactionForm.EditDescription.value = "";
    transactionForm.EditPackagesOrdered.value = "";
    transactionForm.EditDateOrdered.value = "";
    transactionForm.EditDateDeliveryDue.value = "";
    transactionForm.EditImportance.value = "";
  }

  <%-- search product stock --%>
  function searchProductStock(productStockUidField,productStockNameField){
    openPopup("/_common/search/searchProductStock.jsp&ts=<%=getTs()%>&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField);
  }

  <%-- CLEAR MESSAGE --%>
  function clearMessage(){
    <%
        if(msg.length() > 0){
            %>document.getElementById('msgArea').innerHTML = "";<%
        }
    %>
  }
</script>