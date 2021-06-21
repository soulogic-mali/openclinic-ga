<%@page import="be.openclinic.util.Nomenclature"%>
<%@page import="be.openclinic.assets.Asset,
               java.text.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%=checkPermission(out,"assets","select",activeUser)%>
<%=sJSPROTOTYPE%>
<%=sJSNUMBER%> 
<%=sJSSTRINGFUNCTIONS%>
<%=sJSSORTTABLE%>
<%    
    String sAction = checkString(request.getParameter("action"));
    String nomenclaturecode="",nomenclaturetext="";

    if(sAction.equalsIgnoreCase("save")){
    	String sUid = SH.c(request.getParameter("EditAssetUID"));
    	String sNomenclature = SH.c(request.getParameter("FindNomenclatureCode"));
    	String sCode = SH.c(request.getParameter("code"));
    	String sQuantity = SH.c(request.getParameter("quantity"));
    	String sDescription = SH.c(request.getParameter("description"));
    	String sCharacteristics = SH.c(request.getParameter("characteristics"));
    	String sSupplierUID = SH.c(request.getParameter("supplierUID"));
    	String sAssetType = SH.c(request.getParameter("assettype"));
    	String sComment1 = SH.c(request.getParameter("comment1"));
    	String sComment2 = SH.c(request.getParameter("comment2"));
    	String sComment3 = SH.c(request.getParameter("comment3"));
    	String sComment4 = SH.c(request.getParameter("comment4"));
    	String sComment5 = SH.c(request.getParameter("comment5"));
    	String sComment7 = SH.c(request.getParameter("comment7"));
    	String sComment8 = SH.c(request.getParameter("comment8"));
    	String sComment9 = SH.c(request.getParameter("comment9"));
    	String sComment10 = SH.c(request.getParameter("comment10"));
    	String sComment15 = SH.c(request.getParameter("comment15"));
    	String sComment16 = SH.c(request.getParameter("comment16"));
    	String sComment17 = SH.c(request.getParameter("comment17"));
    	Asset asset = new Asset();
    	asset.setUid(sUid);
    	asset.setNomenclature(sNomenclature);
    	asset.setDescription(sDescription);
    	asset.setCode(sCode);
		try{
			asset.setQuantity(Double.parseDouble(sQuantity));
		}
		catch(Exception e){}
		asset.setCharacteristics(sCharacteristics);
		asset.setSupplierUid(sSupplierUID);
		asset.setAssetType(sAssetType);
		asset.setComment1(sComment1);
		asset.setComment2(sComment2);
		asset.setComment3(sComment3);
		asset.setComment4(sComment4);
		asset.setComment5(sComment5);
		asset.setComment7(sComment7);
		asset.setComment8(sComment8);
		asset.setComment9(sComment9);
		asset.setComment10(sComment10);
		asset.setComment15(sComment15);
		asset.setComment16(sComment16);
		asset.setComment17(sComment17);
		asset.saveDefault();
    }
    else if(sAction.equalsIgnoreCase("delete")){
    	Asset.deleteDefault(SH.c(request.getParameter("EditAssetUID")));
    }
    
    if(!sAction.equalsIgnoreCase("edit")){
%> 
	
	<form name="SearchForm" id="SearchForm" method="POST">
		<input type='hidden' name='action' id='action' value=''/>
	    <input type="hidden" id="EditAssetUID" name="EditAssetUID" value="-1">
	    <%=writeTableHeader("web","assets"+SH.c(request.getParameter("assetType")),sWebLanguage,"")%>
	                
	    <table class="list" border="0" width="100%" cellspacing="1">
	        <%-- search CODE --%>
	        <tr>
	            <td class="admin" nowrap width='1%'><%=getTran(request,"web","nomenclature",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap width='1%'>
	                <input type="text" class="text" readonly id="nomenclature" name="nomenclature" size="50" maxLength="80" value="<%=nomenclaturetext%>">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('FindNomenclatureCode','nomenclature');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.FindNomenclatureCode.value='';SearchForm.nomenclature.value='';">
	                <input type="hidden" name="FindNomenclatureCode" id="FindNomenclatureCode" value="<%=nomenclaturecode%>">&nbsp;
	            </td>
	            <td class='admin2' colspan='2'>	                
	            	<input class="button" type="button" name="buttonSearch" id="buttonSearch" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="searchAssets();">&nbsp;
	            	<input class="button" type="button" name="buttonNew" id="buttonNew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="newAsset();">&nbsp;
	            </td>
	        </tr>   
	    </table>
	</form>
	<div id="divAssets" class="searchResults" style="width:100%;height:360px;"></div>
<%
    }
    else if(sAction.equalsIgnoreCase("edit")){
    	Asset asset = Asset.getDefaultAsset(SH.c(request.getParameter("EditAssetUID")));
    	if(asset==null){
    		asset=new Asset();
    	}
%>
	<form name="EditForm" id="EditForm" method="POST">
		<input type='hidden' name='action' id='action' value=''/>
	    <input type="hidden" id="EditAssetUID" name="EditAssetUID" value="<%=asset.getUid()%>">
	    <%=writeTableHeader("web","defaultasset",sWebLanguage,"")%>
	    
	    <input type='hidden' id='comment17'/>
	                
	    <table class="list" border="0" width="100%" cellspacing="1">    
	        <%-- CODE (*) --%>
	        <tr>
	            <td class="admin" ><%=getTran(request,"web.assets","code",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="code" name="code" size="20" maxLength="20" value="<%=checkString(asset.getCode())%>">
	            </td>
	            <td class="admin" ><%=getTran(request,"web.assets","UID",sWebLanguage)%></td>
	            <td class="admin2">
	                <b><%=checkString(asset.getUid())%></b>
	            </td>
	        </tr>
	        <tr>
		        <%-- GMDNCODE --%>
	            <td class="admin" ><%=getTran(request,"web","nomenclature",sWebLanguage)%> *</td>
	            <td class="admin2">
	                <input class="greytext" type="text" readonly size="15" name="FindNomenclatureCode" id="FindNomenclatureCode" value="<%=checkString(asset.getNomenclature())%>">&nbsp;
	                <input type="text" class="text" readonly id="nomenclature" name="nomenclature" size="40" maxLength="110" value="<%=getTranNoLink("admin.nomenclature.asset",checkString(asset.getNomenclature()),sWebLanguage)%>">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('FindNomenclatureCode','nomenclature');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditForm.FindNomenclatureCode.value='';EditForm.nomenclature.value='';">
	            </td>
	            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2">
	                <textarea class="text" name="description" id="description" cols="40" rows="1" onKeyup="resizeTextarea(this,8);limitChars(this,245);"><%=checkString(asset.getDescription())%></textarea>
	            </td>
			</tr>
	        <tr>
		        <%-- ASSET STATUS (*) --%>
	            <td class="admin">	        
	            	<%=getTran(request,"web.assets","status",sWebLanguage)%>
	            </td>
	            <td class="admin2">
	                <select class="text" id="comment9" name="comment9">
	                    <option/>
	                    <%=ScreenHelper.writeSelect(request,"assets.status",checkString(asset.getComment9()),sWebLanguage)%>
	                </select>
	            </td>
	            <td class="admin">
	            	<%=getTran(request,"web.assets","functionality",sWebLanguage)%>&nbsp;*&nbsp;
	            </td>
	            <td class="admin2">
	                <select class="text" id="comment7" name="comment7">
	                    <option/>
	                    <%=ScreenHelper.writeSelect(request,"assets.functionality",checkString(asset.getComment7()),sWebLanguage)%>
	                </select>
	            </td>
	        </tr>    
	        <tr>
	            <td class="admin"><%=getTran(request,"web","details",sWebLanguage)%></td>
	            <td class="admin2" colspan="3">
	                <textarea class="text" name="comment8" id="comment8" cols="60" rows="2" onKeyup="resizeTextarea(this,8);limitChars(this,245);"><%=checkString(asset.getComment8())%></textarea>
	            </td>
	        </tr>
	        <tr>
		        <%-- QUANTITY (*) --%>
	            <td class="admin" id="quantity_label"><%=getTran(request,"web.assets","quantity",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="quantity" name="quantity" size="8" maxLength="8" value="<%=asset.getQuantity()>0?asset.getQuantity():1%>" onKeyUp="isNumber(this);" onBlur="if(isNumber(this))setDecimalLength(this,2,true);">
	            </td>
		        <%-- CENORM --%>
	            <td class="admin">
	            	<table>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","cenorm",sWebLanguage)%></td></tr>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","othernorm",sWebLanguage)%></td></tr>
	            	</table>
	            </td>
	            <td class="admin2">
	            	<table>
	            		<tr>
	            			<td>
				                <select class="text" id="comment1" name="comment1">
				                    <option/>
				                    <%=ScreenHelper.writeSelect(request,"asset.comment1",checkString(asset.getComment1()),sWebLanguage)%>
				                </select>
	            			</td>
	            		</tr>
	            		<tr>
	            			<td>
	                			<input type="text" class="text" id="comment3" name="comment3" size="30" maxLength="30" value="<%=checkString(asset.getComment3())%>">
	            			</td>
	            		</tr>
	            	</table>
	            </td>
	        </tr>       
	        
	        <%-- BRAND --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","brand",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="comment2" name="comment2" size="30" maxLength="30" value="<%=checkString(asset.getComment2())%>">
	            </td>
		        <%-- MODEL --%>
	            <td class="admin"><%=getTran(request,"web.assets","model",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" id="comment10" name="comment10" size="20" maxLength="30" value="<%=checkString(asset.getComment10())%>">
	            </td>
	        </tr>       
	        <%-- CHARACTERISTICS --%>                
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","characteristics",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <textarea class="text" name="characteristics" id="characteristics" cols="60" rows="2" onKeyup="resizeTextarea(this,8);"><%=checkString(asset.getCharacteristics().replaceAll("<br>", "\n"))%></textarea>
	            </td>
	            <td class="admin">
	            	<table>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","voltage",sWebLanguage)%></td></tr>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","intensity",sWebLanguage)%></td></tr>
	            	</table>
	            </td>
	            <td class="admin2">
	            	<table>
	            		<tr>
	            			<td>
				                <input type="text" class="text" id="comment4" name="comment4" size="8" maxLength="8" value="<%=checkString(asset.getComment4())%>" onKeyUp="isNumber(this);" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> V
	            			</td>
	            		</tr>
	            		<tr>
	            			<td>
	                			<input type="text" class="text" id="comment5" name="comment5" size="8" maxLength="8" value="<%=checkString(asset.getComment5())%>" onKeyUp="isNumber(this);" onBlur="if(isNumber(this))setDecimalLength(this,2,true);">
				                <select class="text" id="comment16" name="comment16">
				                    <%=ScreenHelper.writeSelect(request,"asset.comment16",checkString(asset.getComment16()),sWebLanguage)%>
				                </select>
	            			</td>
	            		</tr>
	            	</table>
	            </td>
	        </tr>     
	        <%-- SUPPLIER --%>
	        <tr>
	            <td class="admin" id="supplier_label"><%=getTran(request,"web.assets","supplier",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap>
	                <input type="text" class="text" id="supplierUID" name="supplierUID" size="30" maxLength="50" value="<%=checkString(asset.getSupplierUid())%>">
	            </td>
		        <%-- TYPE --%>
	            <td class="admin"><%=getTran(request,"web.assets","type",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" id="assetType" name="assettype" size="30" maxLength="30" value="<%=checkString(asset.getAssetType())%>">
	            </td>
	        </tr>        
	                            
	        <%-- BUTTONS --%>
	        <tr>     
	            <td class="admin"/>
	            <td class="admin2" colspan="3">
					<%if(activeUser.getAccessRight("assets.edit")){ %>
	                <input class="button" type="button" name="buttonSave" id="buttonSave" value="<%=getTranNoLink("web","save",sWebLanguage)%>" onclick="saveAsset();">&nbsp;
					<%} %>
					<%if(activeUser.getAccessRight("assets.delete")){ %>
	                <input class="button" type="button" name="buttonDelete" id="buttonDelete" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onclick="deleteAsset();" >&nbsp;
					<%} %>
	            </td>
	        </tr>
	    </table>
	    <i><%=getTran(request,"web","colored_fields_are_obligate",sWebLanguage)%></i>
	    
	    <div id="divMessage" style="padding-top:10px;"></div>
	</form>
<%    	
    }
%>

<script>

  <%-- SEARCH ASSETS --%>
  function searchAssets(){
      document.getElementById("divAssets").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Searching..";
  
      var url = "<c:url value='/assets/ajax/asset/getDefaultAssets.jsp'/>?ts="+new Date().getTime();
      var params = "&nomenclature="+encodeURIComponent(SearchForm.FindNomenclatureCode.value);
      new Ajax.Request(url,{
        method: "GET",
        parameters: params,
        onSuccess: function(resp){
          $("divAssets").innerHTML = resp.responseText;
        },
        onFailure: function(resp){
          $("divMessage").innerHTML = "Error in 'assets/ajax/asset/getDefaultAssets.jsp' : "+resp.responseText.trim();
        }
      }); 
  }
  
  function requiredFieldsProvided(){
	  if(document.getElementById("code").value.length == 0 ){
		  document.getElementById("code").focus();
		  return false;
	  }
	  else if(document.getElementById("description").value.length == 0 ){
		  document.getElementById("description").focus();
		  return false;
	  }
	  else if(document.getElementById("nomenclature").value.length == 0 ){
		  document.getElementById("nomenclature").focus();
		  return false;
	  }
	  return true;           
  }

  function searchNomenclature(CategoryUidField,CategoryNameField){
	  openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=asset&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
  }
  
  function displayAsset(uid){
	  document.getElementById('action').value='edit';
	  document.getElementById('EditAssetUID').value=uid;
	  document.getElementById('SearchForm').submit();
  }
  
  function newAsset(){
	  document.getElementById('action').value='edit';
	  document.getElementById('EditAssetUID').value='';
	  document.getElementById('SearchForm').submit();
  }

  function saveAsset(){
	  if(requiredFieldsProvided()){
		  document.getElementById('action').value='save';
		  document.getElementById('EditForm').submit();
  	  }
      else{
          alertDialog("web.manage","dataMissing");
      }
  }

  function deleteAsset(){
	  if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		  document.getElementById('action').value='delete';
		  document.getElementById('EditForm').submit();
	  }
  }

</script>
