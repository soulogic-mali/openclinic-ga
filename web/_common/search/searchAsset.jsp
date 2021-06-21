<%@page import="be.openclinic.assets.Asset,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../../assets/includes/commonFunctions.jsp"%>
<%=sJSPROTOTYPE%>
<%=sJSSORTTABLE%>

<body style="padding:5px;">
<%
    String sAssetUid = checkString(request.getParameter("AssetUid"));
    
    String sFunction = checkString(request.getParameter("doFunction"));
        
    // return fields
    String sReturnFieldUid  = checkString(request.getParameter("ReturnFieldUid")),
           sReturnFieldCode = checkString(request.getParameter("ReturnFieldCode"));

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n******************** _common/search/searchAsset.jsp ********************");
        Debug.println("sAssetUid        : "+sAssetUid);
        Debug.println("sFunction        : "+sFunction);
        Debug.println("sReturnFieldUid  : "+sReturnFieldUid);
        Debug.println("sReturnFieldCode : "+sReturnFieldCode+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
        
    // inner search
    String sAction = checkString(request.getParameter("Action"));
    
    String sCode                = checkString(request.getParameter("searchCode")),
           sDescription         = checkString(request.getParameter("searchDescription")),
           sSerialnumber        = checkString(request.getParameter("searchSerialnumber")),
           sAssetType           = checkString(request.getParameter("searchAssetType")),
           sServiceUid          = checkString(request.getParameter("searchServiceUid")),
           sServiceName         = checkString(request.getParameter("searchServiceName")),
           sSupplierUid         = checkString(request.getParameter("searchSupplierUid")),
           sSupplierName        = checkString(request.getParameter("searchSupplierName")),
           sPurchasePeriodBegin = checkString(request.getParameter("searchPeriodBegin")),
           sPurchasePeriodEnd   = checkString(request.getParameter("searchPeriodEnd"));

    ///////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n********** innerSearch **********");
        Debug.println("sAction              : "+sAction);
        Debug.println("sCode                : "+sCode);
        Debug.println("sDescription         : "+sDescription);
        Debug.println("sSerialnumber        : "+sSerialnumber);
        Debug.println("sAssetType           : "+sAssetType);
        Debug.println("sSupplierUid         : "+sSupplierUid);
        Debug.println("sSupplierName        : "+sSupplierName);
        Debug.println("sPurchasePeriodBegin : "+sPurchasePeriodBegin);
        Debug.println("sPurchasePeriodEnd   : "+sPurchasePeriodEnd+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////
   
    boolean showAllAssetsOnEmptySearch = true;
    String msg = "";    
      
    // search fields 
    %>
        <form name="SearchForm" id="SearchForm" method="POST">          
            <%=writeTableHeader("web","searchAssets",sWebLanguage," window.close();")%>
            <input type="hidden" name="Action" value="search">
                            
            <table class="list" border="0" width="100%" cellspacing="1">
            	<tr>
		            <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%>&nbsp;</td>
		           	<td class="admin2">
		                <input type="hidden" name="searchServiceUid" id="searchServiceUid" value="<%=sServiceUid%>">
		                <input class="text" type="text" name="searchServiceName" id="searchServiceName" readonly size="50" value="<%=sServiceName%>" >
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('searchServiceUid','searchServiceName');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.searchServiceUid.value='';SearchForm.searchServiceName.value='';">
					</td>
            	</tr>
            	
                <%-- search CODE --%>
                <tr>
                    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","code",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" id="searchCode" name="searchCode" size="20" maxLength="50" value="<%=sCode%>">
                    </td>
                </tr>   
                           
                <%-- search DESCRIPTION --%>                
                <tr>
                    <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" id="searchDescription" name="searchDescription" size="40" maxLength="150" value="<%=sDescription%>">
                    </td>
                </tr>
                
                <%-- search SERIAL NUMBER --%>
                <tr>
                    <td class="admin"><%=getTran(request,"web.assets","serialnumber",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="text" class="text" id="searchSerialnumber" name="searchSerialnumber" size="20" maxLength="50" value="<%=sSerialnumber%>">
                    </td>
                </tr>         
                
                <%-- search SUPPLIER --%>
                <tr>
                    <td class="admin"><%=getTran(request,"web.assets","supplier",sWebLanguage)%></td>
                    <td class="admin2">
                        <input type="hidden" name="searchSupplierUid" id="searchSupplierUid" value="<%=sSupplierUid%>">
                        <input type="text" class="text" name="searchSupplierName" id="searchSupplierName" readonly size="30" value="<%=sSupplierName%>">
                           
                        <%-- buttons --%>
                        <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectSupplier('searchSupplierUid','searchSupplierName');">
                        <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSupplierSearchFields();">
                    </td>
                </tr>
                
                <%-- search PURCHASE PERIOD --%>
                <tr>
                    <td class="admin"><%=getTran(request,"web.assets","purchasePeriod",sWebLanguage)%>&nbsp;(<%=getTran(request,"web.assets","begin",sWebLanguage)%> - <%=getTran(request,"web.assets","end",sWebLanguage)%>)</td>
                    <td class="admin2">
                        <%=writeDateField("searchPeriodBegin","SearchForm",sPurchasePeriodBegin,sWebLanguage)%>&nbsp;&nbsp;<%=getTran(request,"web","until",sWebLanguage)%>&nbsp;&nbsp; 
                        <%=writeDateField("searchPeriodEnd","SearchForm",sPurchasePeriodEnd,sWebLanguage)%>            
                    </td>                        
                </tr>
                                    
                <%-- search BUTTONS --%>
                <tr>     
                    <td class="admin"/>
                    <td class="admin2" colspan="2">
                        <input class="button" type="button" name="buttonSearch" id="buttonSearch" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="searchAssets();">&nbsp;
                        <input class="button" type="button" name="buttonClear" id="buttonClear" value="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
                    </td>
                </tr>
            </table>
        </form>
    <%
    
    List<Asset> foundAssets = new LinkedList();
    
    if(sAction.equals("search")){
	    if(sCode.length() > 0 || sDescription.length() > 0 || sSerialnumber.length() > 0 || sAssetType.length() > 0 ||
	    		sSupplierUid.length() > 0 || sServiceUid.length() > 0 || sPurchasePeriodBegin.length() > 0 || sPurchasePeriodEnd.length() > 0 || showAllAssetsOnEmptySearch){
		    Asset findItem = new Asset();
		    findItem.code = sCode;
		    findItem.description = sDescription;		    
		    findItem.serialnumber = sSerialnumber;
		    findItem.assetType = sAssetType;
		    findItem.supplierUid = sSupplierUid;
		    findItem.serviceuid = sServiceUid;
		    
		    if(sPurchasePeriodBegin.length() > 0){
		        findItem.purchasePeriodBegin = ScreenHelper.parseDate(sPurchasePeriodBegin);
		    }
		    
		    if(sPurchasePeriodEnd.length() > 0){
		        findItem.purchasePeriodEnd = ScreenHelper.parseDate(sPurchasePeriodEnd);
		    }
		    
		    foundAssets = Asset.getList(findItem);
		    if(foundAssets.size() > 0){
		        %>		            
		            <table id="searchresults" cellpadding="0" cellspacing="0" width="100%" class="sortable">
		                <%-- header --%>
		                <tr class="admin">
		                    <td class="admin" style="padding-left:0;" width="15%" nowrap><%=getTran(request,"web","code",sWebLanguage)%></td>
		                    <td class="admin" style="padding-left:0;" width="50%" nowrap><%=getTran(request,"web","description",sWebLanguage)%></td>
		                    <td class="admin" style="padding-left:0;" width="20%" nowrap><%=getTran(request,"web","type",sWebLanguage)%></td>
		                    <td class="admin" style="padding-left:0;" width="15%" nowrap><%=getTran(request,"web.assets","purchaseDate",sWebLanguage)%></td>
		                </tr>
		                
		                <tbody>
		                    <%
		                        String sClass = "1";
		                        Asset asset;
		                        
		                        for(int i=0; i<foundAssets.size(); i++){
		                            asset = (Asset)foundAssets.get(i);
		                		    
		                		    if(asset.description.length() > 100){
		                		    	asset.description = asset.description.substring(0,100)+"...";
		                		    }
		                		    
		                            // alternate row-style
		                            if(sClass.length()==0) sClass = "1";
		                            else                   sClass = "";
		                            
		                            %>
		                                <tr class="list<%=sClass%>" onmouseover="this.style.cursor='hand';" onmouseout="this.style.cursor='default';" onClick="selectAsset('<%=asset.getUid()%>','<%=asset.code%>');">
		                                    <td><%=checkString(asset.code)%></td>
		                                    <td><%=checkString(asset.description).replaceAll("\r\n","<br>")%></td>
		                                    <td><%=checkString(asset.assetType)%></td>
		                                    <td><%=(asset.purchaseDate!=null?ScreenHelper.stdDateFormat.format(asset.purchaseDate):"")%></td>
		                                </tr>
		                            <%
		                        }
		                    %>
		                </tbody>
		            </table>
		        <%
		    }
	    }
	    
	    // number of found records
	    if(foundAssets.size() > 0){
	        %><%=foundAssets.size()%> <%=getTran(request,"web","recordsFound",sWebLanguage)%><%
	    }
	    else{
	        %><%=getTran(request,"web","noRecordsFound",sWebLanguage)%><%
	    }
    }
    
    // display message
    if(msg.length() > 0){
        %><br><%=msg%><br><%
    }
%>
    
<%-- CLOSE BUTTON --%>
<div style="text-align:center;padding-top:10px;">
    <input type="button" class="button" name="closeButton" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onclick="window.close();">
</div>

<script>
  window.resizeTo(700,500);
  resizeAllTextareas(4);

  function searchService(serviceUidField,serviceNameField){
	  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
	  	document.getElementById(serviceNameField).focus();
	    }
  <%-- SELECT SUPPLIER --%>
  function selectSupplier(uidField,nameField){
    var url = "/_common/search/searchSupplier.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=400"+
              "&ReturnFieldUid="+uidField+
              "&ReturnFieldName="+nameField;
    openPopup(url);
    document.getElementById(nameField).focus();
  }
  
  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    document.getElementById("searchCode").value = "";
    document.getElementById("searchDescription").value = "";
    document.getElementById("searchSerialnumber").value = "";
    document.getElementById("searchAssetType").selectedIndex = 0;
    clearSupplierSearchFields();
    document.getElementById("searchPeriodBegin").value = "";   
    document.getElementById("searchPeriodEnd").value = ""; 

    document.getElementById("searchCode").focus();
  }

  <%-- CLEAR SUPPLIER SEARCH FIELDS --%>
  function clearSupplierSearchFields(){
    document.getElementById("searchSupplierUid").value = "";
    document.getElementById("searchSupplierName").value = "";  
  }  
  
  <%-- SEARCH ASSETS --%>
  function searchAssets(){
    var okToSubmit = true;
    
    if(document.getElementById("searchCode").value.length > 0 ||
       document.getElementById("searchServiceUid").value.length > 0 ||
       document.getElementById("searchDescription").value.length > 0 ||
       document.getElementById("searchSerialnumber").value.length > 0 ||
       document.getElementById("searchAssetType").value.length > 0 ||
       document.getElementById("searchSupplierUid").value.length > 0 ||
       document.getElementById("searchPeriodBegin").value.length > 0 ||
       document.getElementById("searchPeriodEnd").value.length > 0){
      okToSubmit = true;
    }
    
    <%-- begin can not be after end --%>
    if(okToSubmit==true){
      if(document.getElementById("searchPeriodBegin").value.length > 0 &&
         document.getElementById("searchPeriodEnd").value.length > 0){
        var begin = makeDate(document.getElementById("searchPeriodBegin").value),
            end   = makeDate(document.getElementById("searchPeriodEnd").value);
      
        if(begin > end){
          okToSubmit = false;
          alertDialog("web","beginMustComeBeforeEnd");
          document.getElementById("searchPeriodBegin").focus();
        }  
      }
    }
    
    if(okToSubmit==true){
      document.getElementById("buttonSearch").disabled = true;
      document.getElementById("buttonClear").disabled = true;
      SearchForm.submit();
    }
  }
  
  <%-- SELECT ASSET --%>
  function selectAsset(uid,code){
    if("<%=sReturnFieldUid%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldUid%>")[0].value = uid;
    }
    if("<%=sReturnFieldCode%>".length > 0){
      window.opener.document.getElementsByName("<%=sReturnFieldCode%>")[0].value = code;
    }
    
    <%
        if(sFunction.length() > 0){
            out.print("window.opener."+sFunction+";");
        }
    %>

    window.close();
  }
  
  window.setTimeout("document.getElementById('searchCode').focus();",300);
</script>
</body>