<%@page import="be.openclinic.finance.*"%>
<%@page import="be.openclinic.pharmacy.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action'/>
	<table width='100%'>
		<tr class='admin'><td colspan='2'><%=getTran(request,"web","addmaterials",sWebLanguage) %></td></tr>
		<tr>
			<td class='admin'><%=getTran(request,"web","product",sWebLanguage) %></td>
			<td class='admin2'>
	            <input type="hidden" name="EditMaterialProductStockUid" id="EditMaterialProductStockUid">
	            <input type="text" size="80" class="text" name="EditMaterialProductStockName" id="EditMaterialProductStockName"/>
	            <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchProductStock('EditMaterialProductStockUid','EditMaterialProductStockName');">
	            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="transactionForm.EditMaterialProductStockUid.value='';transactionForm.EditMaterialProductStockName.value='';">
				<div id="autocomplete_material" class="autocomple"></div>
	        </td>
	    </tr>
	    <tr>
			<td class='admin'><%=getTran(request,"web","quantity",sWebLanguage) %></td>
			<td class='admin2'>
	            <input type="text" size="10" class="text" name="EditMaterialQuantity" id="EditMaterialQuantity" value='1'/>
	        </td>
		</tr>
	</table>
	<center>
		<input type='button' class='button' name='saveButton' value='<%=getTran(null,"web","save",sWebLanguage) %>' onclick='saveData();'/>
		<input type='button' class='button' name='closeButton' value='<%=getTran(null,"web","close",sWebLanguage) %>' onclick='window.close();'/>
	</center>
</form>

<script>
	
	function searchProductStock(productStockUidField,productStockNameField){
    	openPopup("/_common/search/searchProductStock2.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=400&ReturnProductStockUidField="+productStockUidField+"&ReturnProductStockNameField="+productStockNameField+"&ReturnServiceStockFunction=getProductStock()");
  	}
	
	new Ajax.Autocompleter('EditMaterialProductStockName','autocomplete_material','pharmacy/getProductStocksForMaterialName.jsp?showzerolevel=1',{
		  minChars:1,
		  method:'post',
		  afterUpdateElement:afterAutoComplete,
		  callback:composeCallbackURL
	});
	
	function saveData(){
		//if(document.getElementById('EditMaterialQuantity').value*1==0){
		//	alert('<%=getTranNoLink("web","quantitymustbemorethanzero",sWebLanguage)%>');
		//	return;
		//}
		if(window.opener.addRawMaterialFunction){
			window.opener.addRawMaterialFunction(document.getElementById('EditMaterialProductStockUid').value,document.getElementById('EditMaterialQuantity').value);
			window.close();
		}
	}
	
	function afterAutoComplete(field,item){
		var regex = new RegExp('[-0123456789.]*-idcache','i');
		var nomimage = regex.exec(item.innerHTML);
		var id = nomimage[0].replace('-idcache','');
		document.getElementById("EditMaterialProductStockUid").value = id;
		getProductStock();
	}
		
	function composeCallbackURL(field,item){
		var url = "";
		if(field.id=="EditMaterialProductStockName"){
			url = "findMaterialName="+field.value;
		}
		return url;
	}
	
	function getProductStock(){
	    var url = "<c:url value=''/>medical/ajax/getProduct.jsp";
	    var params = "productStockUid="+document.getElementById("EditMaterialProductStockUid").value;
	    new Ajax.Request(url,{
	      method: "POST",
	      parameters: params,
	      onSuccess: function(resp){
	        var product =  eval('('+resp.responseText+')');
	        document.getElementById("EditMaterialProductStockName").value=product.name;
	    	maxQuantity=product.quantity;
			<%if(MedwanQuery.getInstance().getConfigInt("enableCCBRTProductionOrderMecanism",0)==0){ %>
		    	document.getElementById('maxquantityspan').innerHTML=maxQuantity;
		    <%}%>
	      }
	    });
	}

	document.getElementById("EditMaterialProductStockName").focus();
</script>