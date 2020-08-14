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

<script src="<%=sCONTEXTPATH%>/assets/includes/commonFunctions.js"></script> 

<%
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n************************** hr/manage_assets.jsp ***********************");
        Debug.println("No parameters\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    String sAction = checkString(request.getParameter("action"));
    String sEditAssetUID = checkString(request.getParameter("EditAssetUID"));
    String sEditServiceUid = checkString(request.getParameter("serviceuid"));
    
    if(sAction.length()==0){
%> 
	
	<form name="SearchForm" id="SearchForm" method="POST">
		<input type='hidden' name='action' id='action' value=''/>
	    <input type="hidden" id="EditAssetUID" name="EditAssetUID" value="-1">
	    <%=writeTableHeader("web","assets",sWebLanguage,"")%>
	                
	    <table class="list" border="0" width="100%" cellspacing="1">
	        <%-- search CODE --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web","nomenclature",sWebLanguage)%></td>
	            <td class="admin2" nowrap>
	                <input type="text" class="text" readonly id="nomenclature" name="nomenclature" size="50" maxLength="80" value="">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('FindNomenclatureCode','nomenclature');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.FindNomenclatureCode.value='';SearchForm.nomenclature.value='';">
	                <input type="hidden" name="FindNomenclatureCode" id="FindNomenclatureCode" value="">&nbsp;
	            </td>
	            <td class="admin" ><%=getTran(request,"web","code",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" id="searchCode" name="searchCode" size="20" maxLength="20" value="<%=checkString(request.getParameter("searchCode"))%>">
	                <input type="checkbox" class="text" name="showinactive" id="showinactive"/><%=getTran(request,"web.asset","showinactive",sWebLanguage) %>
	            </td>
	        </tr>   
	        
	        <%-- search DESCRIPTION --%>                
	        <tr>
	            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%></td>
	            <td class="admin2" >
	                <input type="text" class="text" id="searchDescription" name="searchDescription" size="50" maxLength="50" value="">
	            </td>
	            <td class="admin"><%=getTran(request,"web.assets","serialnumber",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" id="searchSerialnumber" name="searchSerialnumber" size="20" maxLength="30" value="">
	            </td>
	        </tr>     
	        
	        <%-- search ASSET TYPE --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","status",sWebLanguage)%></td>
	            <td class="admin2">
	                <select class="text" id="searchAssetStatus" name="searchAssetStatus">
	                    <option/>
	                    <%=ScreenHelper.writeSelect(request,"assets.status","",sWebLanguage)%>
	                </select>
	            </td>
	            <td class="admin"><%=getTran(request,"web.assets","supplier",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" name="searchSupplierUID" id="searchSupplierUID" size="30" value="">
	            </td>
	        </tr>
	        <%-- search COMPONENTS --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","components",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" readonly id="compnomenclature" name="compnomenclature" size="50" maxLength="80" value="">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchComponent('FindCompNomenclatureCode','compnomenclature');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="SearchForm.FindCompNomenclatureCode.value='';SearchForm.compnomenclature.value='';">
	                <input type="hidden" name="FindCompNomenclatureCode" id="FindCompNomenclatureCode" value="">&nbsp;
	            </td>                        
	            <td class="admin"><%=getTran(request,"web.assets","components",sWebLanguage)%> - <%=getTran(request,"web.assets","status",sWebLanguage)%></td>
	            <td class="admin2">
	                <select class="text" id="searchComponentStatus" name="searchComponentStatus">
	                    <option/>
	                    <%=ScreenHelper.writeSelect(request,"component.status","",sWebLanguage)%>
	                </select>
	            </td>                        
	        </tr>
	        <%-- search PURCHASE PERIOD --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","purchasePeriod",sWebLanguage)%>&nbsp;(<%=getTran(request,"web.assets","begin",sWebLanguage)%> - <%=getTran(request,"web.assets","end",sWebLanguage)%>)</td>
	            <td class="admin2">
	                <%=writeDateField("searchPurchaseBegin","SearchForm","",sWebLanguage)%>&nbsp;&nbsp;<%=getTran(request,"web","until",sWebLanguage)%>&nbsp;&nbsp; 
	                <%=writeDateField("searchPurchaseEnd","SearchForm","",sWebLanguage)%>            
	            </td>                        
	            <%
	            	if(checkString(request.getParameter("serviceuid")).length()>0){
	            		session.setAttribute("activeservice", request.getParameter("serviceuid"));
	            	}
	            	String sServiceUid = checkString((String)session.getAttribute("activeservice"));
	            	if(sServiceUid.length()==0){   	
	            		sServiceUid=activeUser.getParameter("defaultserviceid");
	            	}
	            %>
	            <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sServiceUid%>">
	                <input class="text" type="text" name="servicename" id="servicename" readonly size="60" value="<%=getTranNoLink("service",sServiceUid,sWebLanguage) %>" >
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
	            </td>                        
	        </tr>
	        <tr>
	            <td class="admin2" colspan="4">
	            	<center>
	                <input class="button" type="button" name="buttonSearch" id="buttonSearch" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="searchAssets();">&nbsp;
	                <input class="button" type="button" name="buttonClear" id="buttonClear" value="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
					<%if(activeUser.getAccessRight("assets.add")){ %>
	                <input class="button" type="button" name="buttonNew" id="buttonNew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="createNewAsset();">&nbsp;
	                <%} %>
	                </center>
	            </td>
	        </tr>
	    </table>
	</form>
	<div id="divAssets" class="searchResults" style="width:100%;height:360px;"></div>
	<script>
		function createNewAsset(){
			document.getElementById("action").value="new";
			SearchForm.submit();
		}
		
	<%
		if(checkString(request.getParameter("searchCode")).length()>0 || checkString(request.getParameter("forcedsearch")).length()>0){
	%>
			window.setTimeout("searchAssets()",500);
	<%
		}
	%>
	</script>
<%
    }
%>

<script>
  SearchForm.searchCode.focus();
  
  <%-- SEARCH ASSETS --%>
  function searchAssets(skip){
	if(!skip){
		skip=0;
	}
    var okToSubmit = true;
    <%-- begin can not be after end --%>
    if(document.getElementById("searchPurchaseBegin").value.length > 0 &&
       document.getElementById("searchPurchaseEnd").value.length > 0){
      var begin = makeDate(document.getElementById("searchPurchaseBegin").value),
          end   = makeDate(document.getElementById("searchPurchaseEnd").value);
      
      if(begin > end){
          okToSubmit = false;
          alertDialog("web","beginMustComeBeforeEnd");
          document.getElementById("searchPurchaseBegin").focus();
        }  
    }
    if(document.getElementById("serviceuid").value.length==0){
        okToSubmit = false;
        alertDialog("web","serviceismandatory");
      }  
    
    if(okToSubmit){
      document.getElementById("divAssets").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Searching..";
  
      var url = "<c:url value='/assets/ajax/asset/getAssets.jsp'/>?ts="+new Date().getTime();
      var params = "code="+encodeURIComponent(SearchForm.searchCode.value)+
			       "&nomenclature="+encodeURIComponent(SearchForm.FindNomenclatureCode.value)+
			       "&compnomenclature="+encodeURIComponent(SearchForm.FindCompNomenclatureCode.value)+
			       "&description="+encodeURIComponent(SearchForm.searchDescription.value)+
			       "&showinactive="+SearchForm.showinactive.checked+
			       "&serviceuid="+encodeURIComponent(SearchForm.serviceuid.value)+
                   "&serialnumber="+encodeURIComponent(SearchForm.searchSerialnumber.value)+
                   "&assetStatus="+encodeURIComponent(SearchForm.searchAssetStatus.value)+
                   "&componentStatus="+encodeURIComponent(SearchForm.searchComponentStatus.value)+
                   "&supplierUID="+encodeURIComponent(SearchForm.searchSupplierUID.value)+
                   "&purchasePeriodBegin="+encodeURIComponent(SearchForm.searchPurchaseBegin.value)+
                   "&skip="+skip+
                   "&purchasePeriodEnd="+encodeURIComponent(SearchForm.searchPurchaseEnd.value);
      new Ajax.Request(url,{
        method: "GET",
        parameters: params,
        onSuccess: function(resp){
          $("divAssets").innerHTML = resp.responseText;
          sortables_init();
          newAsset();
        },
        onFailure: function(resp){
          $("divMessage").innerHTML = "Error in 'assets/ajax/asset/getAssets.jsp' : "+resp.responseText.trim();
        }
      }); 
    }
  }
  
  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    document.getElementById("searchCode").value = "";
    document.getElementById("searchDescription").value = "";
    //document.getElementById("serviceuid").value = "";
    //document.getElementById("servicename").value = "";
    document.getElementById("nomenclature").value = "";
    document.getElementById("compnomenclature").value = "";
    document.getElementById("FindNomenclatureCode").value = "";
    document.getElementById("FindCompNomenclatureCode").value = "";
    document.getElementById("searchSerialnumber").value = "";
    document.getElementById("searchAssetStatus").selectedIndex = 0;
    document.getElementById("searchComponentStatus").selectedIndex = 0;
    clearSupplierSearchFields();
    document.getElementById("searchPurchaseBegin").value = "";   
    document.getElementById("searchPurchaseEnd").value = "";  
  }

  <%-- CLEAR SUPPLIER SEARCH FIELDS --%>
  function clearSupplierSearchFields(){
    document.getElementById("searchSupplierUID").value = "";  
  }
</script>

<%
	boolean bNewAsset = false;
	boolean bLocked=false;
	Asset asset = null;
	if(sAction.equalsIgnoreCase("new")){
		asset = new Asset();
		asset.setUid("-1");
		if(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)>0){
			asset.setLockedBy(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1));
			asset.setLockeddate(new java.util.Date());
		}
		else{
			asset.setLockedBy(-1);
		}
		asset.store(activeUser.userid);
		bNewAsset=true;
	}
	else if(sAction.equalsIgnoreCase("edit")){
		asset=Asset.get(sEditAssetUID);
		sEditServiceUid=asset.getServiceuid();
	}
	if(asset!=null){
		bLocked = asset.getObjectId()>-1 && ((asset.getLockedBy()>-1 && asset.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (asset.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
%>
	<form name="EditForm" id="EditForm" method="POST">
		<input type='hidden' name='searchCode' id='searchCode' value=''/>
		<input type='hidden' name='action' id='action' value=''/>
		<input type='hidden' name='lockedby' id='lockedby' value='<%=asset.getLockedBy()%>'/>
	    <input type="hidden" id="EditAssetUID" name="EditAssetUID" value="<%=asset.getUid()%>">
	    <%=writeTableHeader("web","assets",sWebLanguage,"")%>
	                
	    <table class="list" border="0" width="100%" cellspacing="1">    
	        <%-- CODE (*) --%>
	        <tr>
	            <td class="admin" width='15%')><%=getTran(request,"Web","service",sWebLanguage)%> *</td>
	            <td class='admin2' colspan="3">
	            	<table cellspacing="0">
	            		<tr>
	            			<td><b>
		                <%
		                	if(sEditServiceUid.length()>0){
		                		Service service = Service.getService(sEditServiceUid);
		                		if(service!=null){
			                		String[] names=service.getFullyQualifiedName(sWebLanguage,";").split(";");
			                		for(int n=0;n<names.length-1;n++){
			                			if(n>0){
			                				out.println(" - ");
			                			}
			                			out.println(names[n]);
			                		}
		                		}
		                	}
		                %>
		                	</b></td>
		                </tr>
		                <tr>
		                	<td>
				                <input type="hidden" name="serviceuid" id="serviceuid" value="<%=sEditServiceUid%>">
				                <input class="text" type="text" name="servicename" id="servicename" readonly size="60" value="<%=getTranNoLink("service",sEditServiceUid,sWebLanguage)%>" >
				                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
							</td>
						</tr>			              
					</table>
	            </td>
	            <td class="admin" ><%=getTran(request,"web.assets","code",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="code" name="code" size="20" maxLength="20" value="<%=checkString(asset.getCode())%>">
	            </td>
	        </tr>
	        <tr>
		        <%-- GMDNCODE --%>
	            <td class="admin" ><%=getTran(request,"web","nomenclature",sWebLanguage)%> *</td>
	            <td class="admin2" colspan="3">
	                <input class="greytext" type="text" readonly size="15" name="FindNomenclatureCode" id="FindNomenclatureCode" value="<%=checkString(asset.getNomenclature())%>" onchange="checkDefaultMaintenancePlans();validateLabels()">&nbsp;
	                <input type="text" class="text" readonly id="nomenclature" name="nomenclature" size="60" maxLength="110" value="<%=getTranNoLink("admin.nomenclature.asset",checkString(asset.getNomenclature()),sWebLanguage)%>">
	                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchNomenclature('FindNomenclatureCode','nomenclature');">
	                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditForm.FindNomenclatureCode.value='';EditForm.nomenclature.value='';">
	            </td>
	            <td class="admin" ><%=getTran(request,"web.assets","UID",sWebLanguage)%></td>
	            <td class="admin2">
	                <b><%=checkString(asset.getUid())%></b>
	            </td>
			</tr>
			
	        <%-- DESCRIPTION (*) --%>                    
	        <tr>
	            <td class="admin"><%=getTran(request,"web","description",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2" colspan="3">
	                <textarea class="text" name="description" id="description" cols="60" rows="2" onKeyup="resizeTextarea(this,8);limitChars(this,245);"><%=checkString(asset.getDescription())%></textarea>
	            </td>
	            <td class="admin" ><%=getTran(request,"web.assets","surface",sWebLanguage)%></td>
	            <td class="admin2">
	                <input type="text" class="text" id="comment17" name="comment17" size="10" maxLength="30" value="<%=checkString(asset.getComment17())%>">
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
	            	<%=getTran(request,"web.assets","functionality",sWebLanguage)%>
	            </td>
	            <td class="admin2">
	                <select class="text" id="comment7" name="comment7">
	                    <option/>
	                    <%=ScreenHelper.writeSelect(request,"assets.functionality",checkString(asset.getComment7()),sWebLanguage)%>
	                </select>
	            </td>
	            <td class="admin"><%=getTran(request,"web","details",sWebLanguage)%></td>
	            <td class="admin2">
	                <textarea class="text" name="comment8" id="comment8" cols="30" rows="2" onKeyup="resizeTextarea(this,8);limitChars(this,245);"><%=checkString(asset.getComment8())%></textarea>
	            </td>
	        </tr>    
	        
	        <%-- SERIAL NUMBER --%>
	        <tr>
	            <td class="admin" id="serialnumber_label"><%=getTran(request,"web.assets","serialnumber",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="serialnumber" name="serialnumber" size="20" maxLength="30" value="<%=checkString(asset.getSerialnumber())%>">
	            </td>
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
	            <td class="admin2" colspan="2">
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
		        <%-- TYPE --%>
	            <td class="admin"><%=getTran(request,"web.assets","type",sWebLanguage)%></td>
	            <td class="admin2" colspan="2">
	                <input type="text" class="text" id="assetType" name="assettype" size="30" maxLength="30" value="<%=checkString(asset.getAssetType())%>">
	            </td>
	        </tr>       
	        <%-- CHARACTERISTICS --%>                
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","characteristics",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" colspan="3">
	                <textarea class="text" name="characteristics" id="characteristics" cols="60" rows="2" onKeyup="resizeTextarea(this,8);"><%=checkString(asset.getCharacteristics().replaceAll("<br>", "\n"))%></textarea>
	            </td>
	            <td class="admin">
	            	<table>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","voltage",sWebLanguage)%></td></tr>
	            		<tr><td class='admin'><%=getTran(request,"web.assets","intensity",sWebLanguage)%></td></tr>
	            	</table>
	            </td>
	            <td class="admin2" colspan="2">
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
	        <%-- COMPONENTS --%>
	        <tr>
	        	<td class='admin'>
	        		<%=getTran(request,"web.assets","components",sWebLanguage) %>
					<%if(!bLocked && activeUser.getAccessRight("assets.edit")){ %>
		            	<img src='<%=sCONTEXTPATH %>/_img/icons/icon_add.gif' onclick="searchComponents('componentField')"/>
					<%} %>
	        	</td> 
	        	<td class='admin' colspan='5'>
	        		<a href='javascript:showComponents(1)'><%=getTran(request,"web","show",sWebLanguage) %></a>&nbsp;
	        		<a href='javascript:showComponents(0)'><%=getTran(request,"web","hide",sWebLanguage) %></a>
	        	</td>
	        </tr>
	        <script>
	        	function showComponents(value){
	        		if(value==1){
	        			document.getElementById("componentSection").style.display="";
	        		}
	        		else if(value==0){
	        			document.getElementById("componentSection").style.display="none";
	        		}
	        	}
	        	
	        </script>
	        <tr id='componentSection' style='display: none'>
	        	<td colspan='6'>
	        		<table width='100%'  style='border:1px solid black;'>
				        <tr>
				            <td class="admin">
				            </td>
				            <td class="admin2" nowrap colspan="5">
				            	<input type='hidden' name='componentField' id='componentField' value='' onchange='addComponent(this.value)'/>
				            	<script>
				            		function addComponent(value){
				            		    document.getElementById("componentsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
				            		    
				            		    var url = "<c:url value='/assets/addComponent.jsp'/>?ts="+new Date().getTime();
				            		    new Ajax.Request(url,{
				            		      	method: "POST",
				            		      	parameters: "componentuid=<%=asset.getUid()%>."+value,
				            		      	onSuccess: function(resp){
					            		  	loadComponents();
				            		    },
				            		    onFailure: function(resp){
				            		        $("divMessage").innerHTML = "Error in 'assets/addComponent.jsp' : "+resp.responseText.trim();
				            		    }
				            		    });
				            		}
				            	</script>
				            	<input type='hidden' name='comment15' id='comment15' value='<%=asset.getComment15() %>'/>
				            	<div id='componentsDiv'></div>
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
	            	<!-- Structured field
		                <input type="hidden" name="supplierUID" id="supplierUID" value="<%=asset.getSupplierUid()%>">
		                <input type="text" class="text" name="supplierName" id="supplierName" readonly size="30" value="<%=checkString(asset.getSupplierName())%>">
		                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectSupplier('supplierUID','supplierName');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSupplierFields();">
	                 -->
	            </td>
		        <%-- PURCHASE DATE --%>
	            <td class="admin"><%=getTran(request,"web.assets","purchaseDate",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap>
	                <%=writeDateField("purchaseDate","EditForm",ScreenHelper.formatDate(asset.getPurchaseDate()),sWebLanguage)%>        
	            </td>                        
		        <%-- PURCHASE PRICE (+currency) --%>
	            <td class="admin"><%=getTran(request,"web.assets","receiptBy",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="receiptBy" name="receiptBy" size="30" maxLength="50" value="<%=checkString(asset.getReceiptBy())%>">
	            </td>
	        </tr>        
	        
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","productiodate",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap>
	                <%=writeDateField("comment11","EditForm",checkString(asset.getComment11()),sWebLanguage)%>        
	            </td>                        
	            <td class="admin"><%=getTran(request,"web.assets","deliverydate",sWebLanguage)%>*&nbsp;</td>
	            <td class="admin2" nowrap>
	                <%=writeDateField("comment12","EditForm",checkString(asset.getComment12()),sWebLanguage)%>        
	            </td>                        
	            <td class="admin"><%=getTran(request,"web.assets","firstusagedate",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap>
	                <%=writeDateField("comment13","EditForm",checkString(asset.getComment13()),sWebLanguage)%>        
	            </td>                        
	        </tr>        
	        
	        <%-- RECEIPT BY --%>
	        <tr>
	            <td class="admin"><%=getTran(request,"web.assets","purchasePrice",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="purchasePrice" name="purchasePrice" size="15" maxLength="15" value="<%=asset.getPurchasePrice() %>" onKeyUp="isNumber(this);" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
	            </td>
	            <td class="admin"><%=getTran(request,"web.assets","fundingsource",sWebLanguage)%>&nbsp;*&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="comment6" name="comment6" size="20" maxLength="255" value="<%=asset.getComment6() %>" />
	            </td>
	            <td class="admin"><%=getTran(request,"web.assets","endofwarantydate",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2" nowrap>
	                <%=writeDateField("comment14","EditForm",checkString(asset.getComment14()),sWebLanguage)%>        
	            </td>                        
	        </tr>
	        <%-- SALE DATE --%>
	        <tr>
	            <td class="admin" nowrap><%=getTran(request,"web.assets","saleDate",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <%=writeDateField("saleDate","EditForm",ScreenHelper.formatDate(asset.getSaleDate()),sWebLanguage)%>&nbsp;            
	            </td>                        
		        <%-- SALE VALUE --%>
	            <td class="admin" nowrap><%=getTran(request,"web.assets","saleValue",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <input type="text" class="text" id="saleValue" name="saleValue" size="8" maxLength="8" value="<%=asset.getSaleValue() %>" onKeyUp="isNumber(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
	            </td>
		        <%-- SALE CLIENT --%>        
	            <td class="admin" nowrap><%=getTran(request,"web.assets","saleClient",sWebLanguage)%>&nbsp;</td>
	            <td class="admin2">
	                <textarea class="text" name="saleClient" id="saleClient" cols="30" rows="2" onKeyup="resizeTextarea(this,8);limitChars(this,245);"><%=checkString(asset.getSaleClient()) %></textarea>
	            </td>
	        </tr>        
	                    
	       
	        <tr>
		        <%-- DOCUMENTS (multi-add) --%>   
	            <td class="admin" nowrap>
	            	<%=getTran(request,"web.assets","documents",sWebLanguage)%>&nbsp;
					<%if(!bLocked && activeUser.getAccessRight("assets.edit")){ %>
		            	<img src='<%=sCONTEXTPATH %>/_img/icons/icon_add.gif' onclick="addDocument('<%=asset.getUid()%>')"/>
		            <%} %>
	            </td>
	        	<td class='admin' colspan='5'>
	        		<a href='javascript:showDocuments(1)'><%=getTran(request,"web","show",sWebLanguage) %></a>&nbsp;
	        		<a href='javascript:showDocuments(0)'><%=getTran(request,"web","hide",sWebLanguage) %></a>
	        	</td>
	        </tr>        
	        <script>
	        	function showDocuments(value){
	        		if(value==1){
	        			document.getElementById("documentSection").style.display="";
	        		}
	        		else if(value==0){
	        			document.getElementById("documentSection").style.display="none";
	        		}
	        	}
	        </script>
	        <tr id='documentSection' style='display: none'>
	        	<td colspan='6'>
	        		<table width='100%'  style='border:1px solid black;'>
				        <tr>
				            <td class="admin">
				            	<div id='documentsLoaderDiv'></div><div id='documentsDiv'></div>
				            </td>
				        </tr>   
				    </table>
				</td>
			</tr>     	        
	        
	        <tr>
	        	<td class='admin'>
	        		<%=getTran(request,"web","accounting",sWebLanguage) %>
	        	</td> 
	        	<td class='admin' colspan='5'>
	        		<a href='javascript:showFinance(1)'><%=getTran(request,"web","show",sWebLanguage) %></a>&nbsp;
	        		<a href='javascript:showFinance(0)'><%=getTran(request,"web","hide",sWebLanguage) %></a>
	        	</td>
	        </tr>
	        <script>
	        	function showFinance(value){
	        		if(value==1){
	        			document.getElementById("financialSection").style.display="";
	        		}
	        		else if(value==0){
	        			document.getElementById("financialSection").style.display="none";
	        		}
	        	}
	        	
	        </script>
	        <tr id='financialSection' style='display: none'>
	        	<td colspan='6'>
	        		<table width='100%'  style='border:2px solid black;'>
				        <%-- WRITE OFF METHOD --%>
				        <tr>
				            <td class="admin"  width='15%'><%=getTran(request,"web.assets","writeOffMethod",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2">
				                <select class="text" id="writeOffMethod" name="writeOffMethod">
				                    <option/>
				                    <%=ScreenHelper.writeSelect(request,"assets.writeOffMethod",checkString(asset.getWriteOffMethod()),sWebLanguage)%>
				                </select>
				            </td>
					        <%-- WRITE OFF PERIOD --%>
				            <td class="admin"><%=getTran(request,"web.assets","writeOffPeriod",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2">
				                <input type="text" class="text" id="writeOffPeriod" name="writeOffPeriod" size="2" maxLength="2" value="<%=asset.getWriteOffPeriod() %>" onKeyUp="isNumber(this);">&nbsp;<%=getTran(request,"web","years",sWebLanguage).toLowerCase()%>&nbsp;
				            </td>
					        <%-- ANNUITIY --%>
				            <td class="admin"><%=getTran(request,"web.assets","annuity",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2">
				                <select class="text" id="annuity" name="annuity">
				                    <option/>
				                    <%=ScreenHelper.writeSelect(request,"assets.annuity",checkString(asset.getAnnuity()),sWebLanguage)%>
				                </select>
				            </td>
				        </tr>        
				        
				        <%-- GAINS (multi-add: date, value (+currency)) --%>
				        <tr>
				            <td class="admin" nowrap><%=getTran(request,"web.assets","gains",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2" style="padding:5px;" colspan="5">
				                <input type="hidden" id="gains" name="gains" value="">
				                                     
				                <table width="100%" class="sortable" id="tblGA" cellspacing="1" headerRowCount="2"> 
				                    <%-- header --%>                        
				                    <tr class="admin">
				                        <%-- 0 - empty --%>
				                        <td  nowrap/>
				                        <%-- 1 - date --%>
				                        <td  nowrap style="padding-left:0px;">
				                            <%=getTran(request,"web.assets","date",sWebLanguage)%>&nbsp;*&nbsp;
				                        </td>    
				                        <%-- 2 - value --%>
				                        <td  nowrap style="padding-left:0px;">
				                            <%=getTran(request,"web.assets","value",sWebLanguage)%>&nbsp;*&nbsp;
				                        </td>    
				                        <%-- 3 - empty --%>
				                        <td nowrap>&nbsp;</td>      
				                    </tr>
				        
				                    <%-- content by ajax and javascript --%>
				                    
				                    <%-- add-row --%>                          
				                    <tr>
				                        <%-- 0 - empty --%>
				                        <td class="admin"/>
				                        <%-- 1 - gaDate --%>
				                        <td class="admin" nowrap> 
				                            <%=writeDateField("gaDate","EditForm","",sWebLanguage)%>&nbsp; 
				                        </td>
				                        <%-- 2 - gaValue --%>
				                        <td class="admin"> 
				                            <input type="text" class="text" id="gaValue" name="gaValue" size="8" maxLength="8" onKeyUp="isNumber(this);" onBlur="if(isNumber(this))setDecimalLength(this,2,true);" value="">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
				                        </td>
				                        <%-- 3 - buttons --%>
				                        <td class="admin" nowrap>
				                            <input type="button" class="button" name="ButtonAddGA" id="ButtonAddGA" value="<%=getTranNoLink("web","add",sWebLanguage)%>" onclick="addGA();">
				                            <input type="button" class="button" name="ButtonUpdateGA" id="ButtonUpdateGA" value="<%=getTranNoLink("web","edit",sWebLanguage)%>" onclick="updateGA();" disabled>&nbsp;
				                        </td>    
				                    </tr>
				                </table>                    
				            </td>
				        </tr>
				        <tr>
					        <%-- LOSSES (multi-add: date, value (+currency)) --%>  
				            <td class="admin" nowrap><%=getTran(request,"web.assets","losses",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2" style="padding:5px;" colspan="5">
				                <input type="hidden" id="losses" name="losses" value="">
				                                     
				                <table width="100%" class="sortable" id="tblLO" cellspacing="1" headerRowCount="2"> 
				                    <%-- header --%>                        
				                    <tr class="admin">
				                        <%-- 0 - empty --%>
				                        <td nowrap/>
				                        <%-- 1 - date --%>
				                        <td nowrap style="padding-left:0px;">
				                            <%=getTran(request,"web.assets","date",sWebLanguage)%>&nbsp;*&nbsp;
				                        </td>    
				                        <%-- 2 - value --%>
				                        <td nowrap style="padding-left:0px;">
				                            <%=getTran(request,"web.assets","value",sWebLanguage)%>&nbsp;*&nbsp;
				                        </td>    
				                        <%-- 3 - empty --%>
				                        <td  nowrap>&nbsp;</td>      
				                    </tr>
				        
				                    <%-- content by ajax and javascript --%>
				                    
				                    <%-- add-row --%>                          
				                    <tr>
				                        <%-- 0 - empty --%>
				                        <td class="admin"/>
				                        <%-- 1 - loDate --%>
				                        <td class="admin" nowrap> 
				                            <%=writeDateField("loDate","EditForm","",sWebLanguage)%>&nbsp; 
				                        </td>   
				                        <%-- 2 - loValue --%>
				                        <td class="admin"> 
				                            <input type="text" class="text" id="loValue" name="loValue" size="8" maxLength="8" onKeyUp="isNumber(this)" onBlur="if(isNumber(this))setDecimalLength(this,2,true);" value="">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
				                        </td>
				                        <%-- 3 - buttons --%>
				                        <td class="admin" nowrap>
				                            <input type="button" class="button" name="ButtonAddLO" id="ButtonAddLO" value="<%=getTranNoLink("web","add",sWebLanguage)%>" onclick="addLO();">
				                            <input type="button" class="button" name="ButtonUpdateLO" id="ButtonUpdateLO" value="<%=getTranNoLink("web","edit",sWebLanguage)%>" onclick="updateLO();" disabled>&nbsp;
				                        </td>    
				                    </tr>
				                </table>                    
				            </td>
				        </tr>        
				
				        <%-- RESIDUAL VALUE HISTORY (calculated) --%>
				        <tr id="residualValueHistoryDiv" style="visibility:visible;">
				            <td class="admin" nowrap><%=getTran(request,"web.assets","residualValueHistory",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2" colspan="5">
				                <div id="residualValueHistory" class="admin">
				                    <%-- javascript --%>
				                </div>
				            </td>
				        </tr>     
				                    
				        <%-- LOAN (own table) -------------------------------------------------------------------%>
				        
				        <tr>
				            <td class="admin" nowrap><%=getTran(request,"web.assets","loan",sWebLanguage)%>&nbsp;</td>
				            <td class="admin2" style="padding:5px;" colspan="5">
				                <table class="list" cellspacing="1" cellpadding="0" width="100%">
				                
				            <%-- subtitle : loan --%>
				            <tr class="admin">
				                <td colspan="2"><%=getTran(request,"web.assets","loan",sWebLanguage)%></td>        
				            </tr>
				        
				            <%-- LOAN DATE --%>
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","loanDate",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2">
				                    <%=writeDateField("loanDate","EditForm",ScreenHelper.formatDate(asset.getLoanDate()),sWebLanguage)%>            
				                </td>                        
				            </tr>
				            
				            <%-- LOAN AMOUNT --%>
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","loanAmount",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2">
				                    <input type="text" class="text" id="loanAmount" name="loanAmount" size="8" maxLength="8" value="<%=asset.getLoanAmount() %>" onKeyUp="isNumber(this);">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
				                </td>
				            </tr>
				                
				            <%-- LOAN INTEREST RATE (text!) --%>
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","loadInterestRate",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2">
				                    <input type="text" class="text" id="loanInterestRate" name="loanInterestRate" size="30" maxLength="30" value="<%=checkString(asset.getLoanInterestRate())%>">
				                </td>
				            </tr>     
				            
				            <%-- LOAN REIMBURSEMENT PLAN (multi-add: date, capital, interest, total (calculated)) --%>  
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","loadReimbursementPlan",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2" style="padding:5px;">
				                    <input type="hidden" id="loanReimbursementPlan" name="loanReimbursementPlan" value="">
				                                         
				                    <table width="100%" class="sortable" id="tblRP" cellspacing="1" headerRowCount="2" bottomRowCount="1"> 
				                        <%-- header --%>                        
				                        <tr class="admin">
				                            <%-- 0 - empty --%>
				                            <td nowrap/>
				                            <%-- 1 - date --%>
				                            <td nowrap style="padding-left:0px;">
				                                <%=getTran(request,"web.assets","date",sWebLanguage)%>&nbsp;*&nbsp;
				                            </td>
				                            <%-- 2 - capital (+currency) --%>
				                            <td nowrap style="padding-left:0px;">
				                                <%=getTran(request,"web.assets","capital",sWebLanguage)%>&nbsp;*&nbsp;
				                            </td>
				                            <%-- 3 - interest (+currency) --%>
				                            <td nowrap style="padding-left:0px;">
				                                <%=getTran(request,"web.assets","interest",sWebLanguage)%>&nbsp;*&nbsp;
				                            </td>    
				                            <%-- 4 - total --%>
				                            <td nowrap style="padding-left:0px;">
				                                <%=getTran(request,"web.assets","total",sWebLanguage)%>&nbsp;
				                            </td>   
				                            <%-- 5 - empty --%>
				                            <td nowrap>&nbsp;</td>      
				                        </tr>
				            
				                        <%-- content by ajax and javascript --%>
				                        
				                        <%-- add-row --%>                          
				                        <tr>
				                            <%-- 0 - empty --%>
				                            <td class="admin"/>
				                            <%-- 1 - rpDate --%>
				                            <td class="admin" nowrap> 
				                                <%=writeDateField("rpDate","EditForm","",sWebLanguage)%>&nbsp; 
				                            </td>
				                            <%-- 2 - rpCapital --%>
				                            <td class="admin">
				                                <input type="text" class="text" id="rpCapital" name="rpCapital" size="8" maxLength="8" onKeyUp="calculateRPTotal(this,false);" onBlur="calculateRPTotal(this,true);" value="">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
				                            </td>    
				                            <%-- 3 - rpInterest --%>
				                            <td class="admin">  
				                                <input type="text" class="text" id="rpInterest" name="rpInterest" size="8" maxLength="8" onKeyUp="calculateRPTotal(this,false);" onBlur="calculateRPTotal(this,true);" value="">&nbsp;<%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;
				                            </td>  
				                            <%-- 4 - rpTotal (calculated) --%>
				                            <td style="background-color:#ccc;font-weight:bold;color:#505050;">
				                                <span id="rpTotal" style="searchResults" style="color:#505050;padding:3px;width:50px;height:18px;border:1px solid #ccc;background:#f0f0f0;"><%-- javascript --%></span>&nbsp;<span style="vertical-align:3px"><%=MedwanQuery.getInstance().getConfigParam("currency","€")%></span>&nbsp;
				                            </td>   
				                            <%-- 5 - buttons --%>
				                            <td class="admin" nowrap>
				                                <input type="button" class="button" name="ButtonAddRP" id="ButtonAddRP" value="<%=getTranNoLink("web","add",sWebLanguage)%>" onclick="addRP();">
				                                <input type="button" class="button" name="ButtonUpdateRP" id="ButtonUpdateRP" value="<%=getTranNoLink("web","edit",sWebLanguage)%>" onclick="updateRP();" disabled>&nbsp;
				                            </td>    
				                        </tr>
				                    </table>                    
				                </td>
				            </tr>        
				                        
				            <%-- LOAN COMMENT --%>                
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","comment",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2">
				                    <textarea class="text" name="loanComment" id="loanComment" cols="40" rows="2" onKeyup="resizeTextarea(this,8);"><%=checkString(asset.getLoanComment()) %></textarea>
				                </td>
				            </tr>
				            
				            <%-- LOAN DOCUMENTS (multi-add) --%>
				            <tr>
				                <td class="admin" nowrap><%=getTran(request,"web.assets","loanDocuments",sWebLanguage)%>&nbsp;</td>
				                <td class="admin2" style="padding:5px;padding-bottom:0;">
				                    <input type="hidden" id="loanDocuments" name="loanDocuments" value="">
				                              
				                    <span id="ldScroller" style="overflow:none;width:270px;height:50px;border:none;">           
				                        <table width="100%" class="sortable" id="tblLD" cellspacing="1" headerRowCount="2"> 
				                            <%-- header --%>                        
				                            <tr class="admin">
				                                <%-- 0 - empty --%>
				                                <td nowrap/>
				                                <%-- 1 - documentId --%>
				                                <td  nowrap style="padding-left:0px;">
				                                    <%=getTran(request,"web.assets","documentId",sWebLanguage)%>&nbsp;*&nbsp;
				                                </td>    
				                                <%-- 2 - empty --%>
				                                <td nowrap>&nbsp;</td>      
				                            </tr>
				                            
				                            <%-- add-row --%>                          
				                            <tr>
				                                <%-- 0 - empty --%>
				                                <td class="admin"/>
				                                <%-- 1 - documentId --%>
				                                <td class="admin"> 
				                                    <input type="text" class="text" id="ldID" name="ldID" size="15" maxLength="12" value="" onKeyDown="if(enterEvent(event,13)){if(isValidDocumentId(document.getElementById('ldID')))addLD();}">&nbsp;
				                                </td>
				                                <%-- 2 - buttons --%>
				                                <td class="admin" nowrap>
				                                    <input type="button" class="button" name="ButtonAddLD" id="ButtonAddLD" value="<%=getTranNoLink("web","add",sWebLanguage)%>" onclick="if(isValidDocumentId(document.getElementById('ldID')))addLD();">
				                                    <input type="button" class="button" name="ButtonUpdateLD" id="ButtonUpdateLD" value="<%=getTranNoLink("web","edit",sWebLanguage)%>" onclick="updateLD();" disabled>&nbsp;
				                                </td>    
				                            </tr>
				                
				                            <%-- content by ajax and javascript --%>
				                        </table>
				                    
				                        <div id="loanDocumentMsgDiv" style="padding-top:10px;"></div>      
				                    </span>              
				                </td>
				            </tr>        
				        
				                </table>
				            </td>
				        </tr>
				    </table>
				</td>
			</tr>
	        <tr>
	            <td class="admin" nowrap>
	            	<%=getTran(request,"web","lastmodificationby",sWebLanguage)%>&nbsp;
	            </td>
	            <td class="admin2" colspan="5">
	            	<b><%=User.getFullUserName(asset.getUpdateUser()) %> (<%=ScreenHelper.formatDate(asset.getUpdateDateTime(), ScreenHelper.fullDateFormat) %>)</b>
	            </td>
	        </tr>        
	                            
	        <%-- BUTTONS --%>
	        <tr>     
	            <td class="admin"/>
	            <td class="admin2" colspan="7">
					<%if(!bLocked && activeUser.getAccessRight("assets.edit")){ %>
	                <input class="button" type="button" name="buttonSave" id="buttonSave" value="<%=getTranNoLink("web","save",sWebLanguage)%>" onclick="saveAsset();">&nbsp;
					<%} %>
					<%if(!bLocked && activeUser.getAccessRight("assets.delete")){ %>
	                <input class="button" type="button" name="buttonDelete" id="buttonDelete" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onclick="deleteAsset();" >&nbsp;
					<%} %>
	                <input class="button" type="button" name="buttonList" id="buttonList" value="<%=getTranNoLink("web","list",sWebLanguage)%>" onclick="listAssets();">&nbsp;
	                <input class="button" type="button" name="buttonMaintenance" id="buttonMaintenance" value="<%=getTranNoLink("web","maintenanceplans",sWebLanguage)%>" onclick="listMaintenancePlans();">&nbsp;
	                <input class="button" type="button" name="buttonOperations" id="buttonOperations" value="<%=getTranNoLink("web","operations",sWebLanguage)%>" onclick="listMaintenanceOperations();">&nbsp;
	                <input class="button" type="button" name="buttonDocuments" id="buttonDocuments" value="<%=getTranNoLink("web","documents",sWebLanguage)%>" onclick="printWordDocuments();">&nbsp;
	            </td>
	        </tr>
	    </table>
	    <i><%=getTran(request,"web","colored_fields_are_obligate",sWebLanguage)%></i>
	    
	    <div id="divMessage" style="padding-top:10px;"></div>
	</form>
	<script>
		window.setTimeout("loadComponents();loadDocuments();",500);
	</script>
<% 
	session.setAttribute("activeAsset", asset);
	} 
%>   
<script>
  <%
      String sAgent = request.getHeader("User-Agent").toLowerCase();
      if(sAgent.contains("msie")){
          out.print("document.getElementById('residualValueHistoryDiv').style.display = 'none';");
      }
  %>
	function resetMaintenancePlans(){
		if(document.getElementById("nomenclature").value==''){
			alert('<%=getTranNoLink("web","assetnotspecified",sWebLanguage)%>');
		}
		else if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
		    var url = "<c:url value='/assets/ajax/asset/setDefaultMaintenancePlans.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		    	method: "POST",
		    	parameters: "assetUID="+document.getElementById("EditAssetUID").value,
		    	onSuccess: function(resp){
					window.location.reload();
		    	},
		    	onFailure: function(resp){
		    	}
		  	});
		}
	}
  function listMaintenancePlans(){
	  window.location.href='<c:url value="/main.do?Page=assets/manage_maintenancePlans.jsp&assetUID="/>'+document.getElementById("EditAssetUID").value+"&assetCode="+document.getElementById("code").value;
  }
  function listMaintenanceOperations(){
	  window.location.href='<c:url value="/main.do?Page=assets/manage_maintenanceOperations.jsp&AssetUID="/>'+document.getElementById("EditAssetUID").value+"&AssetCode="+document.getElementById("code").value;
  }
  function listAssets(){
	  window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&forcedsearch=1"/>';
  }
  
  <%-- CALCULATE RP TOTAL --%>
  function calculateRPTotal(inputField,format){
    if(isNumber(inputField)){
      if(format==true){
        setDecimalLength(inputField,2,true);
      }
       
      var capital  = document.getElementById("rpCapital").value,
          interest = document.getElementById("rpInterest").value;
    
      if(capital.length > 0 && interest.length > 0){          
        document.getElementById("rpTotal").innerHTML = formatNumber((capital*1)+(interest*1),2);      
      }
      else{
        document.getElementById("rpTotal").innerHTML = "";
      }
    }
    else{
      document.getElementById("rpTotal").innerHTML = "";
    }
  }
  
  <%-- IS VALID DOCUMENT ID --%>
  function isValidDocumentId(docIdField){
    var docId = docIdField.value;
    
    if(docId.length > 0){
          return true;
    }
    alertDialog("web","invalidDocumentId");
    docIdField.focus();
    return false;
  }
  
  <%-- CLEAR ASSET FIELDS --%>
  function clearAssetFields(){
    document.getElementById("searchAsset").value = "";
    document.getElementById("searchAssetUID").value = "";  
  }

  <%-- CLEAR SUPPLIER FIELDS --%>
  function clearSupplierFields(){
    document.getElementById("supplierUID").value = ""; 
    document.getElementById("supplierName").value = ""; 
  }

  <%-- CLEAR PARENT FIELDS --%>
  function clearParentFields(){
    document.getElementById("parentUID").value = "";
    document.getElementById("parentCode").value = "";  
  }
    
  <%-- SAVE ASSET --%>
  function saveAsset(){
    var okToSubmit = true;    

    <%-- check required fields --%>
    if(requiredFieldsProvided()){    
      if(okToSubmit==true){
        document.getElementById("divMessage").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Saving..";  
        var url = "<c:url value='/assets/ajax/asset/saveAsset.jsp'/>?ts="+new Date().getTime();
        disableButtons();
        var sTmpBegin, sTmpEnd;

        <%-- compose string containing gains --%>
        while(sGA.indexOf("rowGA") > -1){
          sTmpBegin = sGA.substring(sGA.indexOf("rowGA"));
          sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
          sGA = sGA.substring(0,sGA.indexOf("rowGA"))+sTmpEnd;
        }
        document.getElementById("gains").value = sGA;

        <%-- compose string containing losses --%>
        while(sLO.indexOf("rowLO") > -1){
          sTmpBegin = sLO.substring(sLO.indexOf("rowLO"));
          sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
          sLO = sLO.substring(0,sLO.indexOf("rowLO"))+sTmpEnd;
        }
        document.getElementById("losses").value = sLO;

        <%-- compose string containing reimbursement plan --%>
        while(sRP.indexOf("rowRP") > -1){
          sTmpBegin = sRP.substring(sRP.indexOf("rowRP"));
          sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
          sRP = sRP.substring(0,sRP.indexOf("rowRP"))+sTmpEnd;
        }
        document.getElementById("loanReimbursementPlan").value = sRP;

        <%-- compose string containing loan documents --%>
        while(sLD.indexOf("rowLD") > -1){
          sTmpBegin = sLD.substring(sLD.indexOf("rowLD"));
          sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
          sLD = sLD.substring(0,sLD.indexOf("rowLD"))+sTmpEnd;
        }
        document.getElementById("loanDocuments").value = sLD;

        var sParams = "EditAssetUID="+EditForm.EditAssetUID.value+
        			  <%=bNewAsset?"\"&newasset=1\"+":""%>
			          "&code="+document.getElementById("code").value+
			          "&serviceuid="+document.getElementById("serviceuid").value+
			          "&nomenclature="+document.getElementById("FindNomenclatureCode").value+
                      "&description="+document.getElementById("description").value+
                      "&serialnumber="+document.getElementById("serialnumber").value+
                      "&quantity="+document.getElementById("quantity").value+
                      "&assetType="+document.getElementById("assetType").value+
                      "&supplierUID="+document.getElementById("supplierUID").value+
                      "&purchaseDate="+document.getElementById("purchaseDate").value+
                      "&purchasePrice="+document.getElementById("purchasePrice").value+
                      "&receiptBy="+document.getElementById("receiptBy").value+
                      "&writeOffMethod="+document.getElementById("writeOffMethod").value+
                      "&writeOffPeriod="+document.getElementById("writeOffPeriod").value+
                      "&annuity="+document.getElementById("annuity").value+
                      "&characteristics="+document.getElementById("characteristics").value+
                      "&gains="+document.getElementById("gains").value+
                      "&losses="+document.getElementById("losses").value+
                      "&lockedby="+document.getElementById("lockedby").value+
                    
                      //*** loan ***
                      "&loanDate="+document.getElementById("loanDate").value+
                      "&loanAmount="+document.getElementById("loanAmount").value+
                      "&loanInterestRate="+replaceAll(document.getElementById("loanInterestRate").value,"%","[percent]")+
                      "&loanReimbursementPlan="+document.getElementById("loanReimbursementPlan").value+
                      "&loanComment="+document.getElementById("loanComment").value+
                      "&loanDocuments="+document.getElementById("loanDocuments").value+

                      "&comment1="+document.getElementById("comment1").value+
                      "&comment2="+document.getElementById("comment2").value+
                      "&comment3="+document.getElementById("comment3").value+
                      "&comment4="+document.getElementById("comment4").value+
                      "&comment5="+document.getElementById("comment5").value+
                      "&comment6="+document.getElementById("comment6").value+
                      "&comment7="+document.getElementById("comment7").value+
                      "&comment8="+document.getElementById("comment8").value+
                      "&comment9="+document.getElementById("comment9").value+
                      "&comment10="+document.getElementById("comment10").value+
                      "&comment11="+document.getElementById("comment11").value+
                      "&comment12="+document.getElementById("comment12").value+
                      "&comment13="+document.getElementById("comment13").value+
                      "&comment14="+document.getElementById("comment14").value+
                      "&comment15="+document.getElementById("comment15").value+
                      "&comment16="+document.getElementById("comment16").value+
                      "&comment17="+document.getElementById("comment17").value+
                      /*
                      "&comment18="+document.getElementById("comment18").value+
                      "&comment19="+document.getElementById("comment19").value+
                      "&comment20="+document.getElementById("comment20").value+
					  */
                      "&saleDate="+document.getElementById("saleDate").value+
                      "&saleValue="+document.getElementById("saleValue").value+
                      "&saleClient="+document.getElementById("saleClient").value;
        new Ajax.Request(url,{   
          method:"POST",
          postBody:sParams,
          onSuccess:function(resp){
            var data = eval("("+resp.responseText+")");
            $("divMessage").innerHTML = data.message;
            listAssets();
          },
          onFailure:function(resp){
            $("divMessage").innerHTML = "Error in 'assets/ajax/asset/saveAsset.jsp' : "+resp.responseText.trim();
          }
        });
      }
    }
    else{
      alertDialog("web.manage","dataMissing");
      
      <%-- focus empty field --%>
           if(document.getElementById("code").value.length==0) document.getElementById("code").focus();
           else if(document.getElementById("description").value.length==0) document.getElementById("description").focus();
           else if(document.getElementById("nomenclature").value.length==0) document.getElementById("nomenclature").focus();
	      else if(document.getElementById("quantity").value.length==0) document.getElementById("quantity").focus();
	      else if(document.getElementById("serviceuid").value.length==0) document.getElementById("servicename").focus();          
    }
  }
  
  <%-- REQUIRED FIELDS PROVIDED --%>
  function requiredFieldsProvided(){
	  if(document.getElementById("comment12").value.length == 0 ){
		  document.getElementById("comment12").focus();
		  return false;
	  }
	  else if(document.getElementById("code").value.length == 0 ){
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
	  /*
	  else if(document.getElementById("quantity").value.length == 0 ){
		  document.getElementById("quantity").focus();
		  return false;
	  }
	  */
	  else if(document.getElementById("serviceuid").value.length == 0 ){
		  document.getElementById("serviceuid").focus();
		  return false;
	  }
    return true;           
  }
    
  <%-- LOAD (all) ASSETS --%>
  function loadAssets(){
    document.getElementById("divAssets").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
    
    var url = "<c:url value='/assets/ajax/asset/getAssets.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
        $("divAssets").innerHTML = resp.responseText;
        sortables_init();
      },
      onFailure: function(resp){
        $("divMessage").innerHTML = "Error in 'assets/ajax/asset/getAssets.jsp' : "+resp.responseText.trim();
      }
    });
  }

  function checkDefaultMaintenancePlans(){
    var url = "<c:url value='/assets/ajax/asset/checkDefaultMaintenancePlans.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "POST",
      parameters: "nomenclature="+document.getElementById("FindNomenclatureCode").value,
      onSuccess: function(resp){
    	  if(resp.responseText.indexOf("OK-200")>-1){
    		  document.getElementById("buttonInitializeMaintenanceplans").style.display="";
    	  }
    	  else{
    		  document.getElementById("buttonInitializeMaintenanceplans").style.display="none";
    	  }
      },
      onFailure: function(resp){
      }
    });
  }
  
  function deleteComponent(id){
      if(yesnoDeleteDialog()){
    	    document.getElementById("componentsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
    	    
    	    var url = "<c:url value='/assets/deleteComponent.jsp'/>?ts="+new Date().getTime();
    	    new Ajax.Request(url,{
    	      method: "GET",
    	      parameters: "componentuid="+id,
    	      onSuccess: function(resp){
    	    	  loadComponents();
    	      },
    	      onFailure: function(resp){
    	        $("divMessage").innerHTML = "Error in 'assets/deleteComponent.jsp' : "+resp.responseText.trim();
    	      }
    	    });
      }
  }
  
  function editComponent(id){
		var url = "/assets/editComponent.jsp&ts=<%=getTs()%>&PopupWidth=700&PopupHeight=300&componentuid="+id;
		openPopup(url);
}

  function showDocument(url){
		openPopup(url);
}

  <%-- LOAD (all) ASSETS --%>
  function loadComponents(){
    document.getElementById("componentsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
    
    var url = "<c:url value='/assets/ajax/asset/getComponents.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "assetuid=<%=asset==null?"":asset.getUid()%>",
      onSuccess: function(resp){
        $("componentsDiv").innerHTML = resp.responseText;
        if(resp.responseText.indexOf("<tr>")>-1){
        	showComponents(1);
        }
        else{
        	showComponents(0);
        }
      },
      onFailure: function(resp){
        $("divMessage").innerHTML = "Error in 'assets/ajax/asset/getComponents.jsp' : "+resp.responseText.trim();
      }
    });
  }

  <%-- LOAD (all) ASSETS --%>
  function loadDocuments(){
    document.getElementById("documentsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
    
    var url = "<c:url value='/assets/ajax/asset/getDocuments.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "assetuid="+document.getElementById("EditAssetUID").value,
      onSuccess: function(resp){
        $("documentsDiv").innerHTML = resp.responseText;
      },
      onFailure: function(resp){
        $("documentsDiv").innerHTML = "Error in 'assets/ajax/asset/getDocuments.jsp' : "+resp.responseText.trim();
      }
    });
  }
  function deleteDocument(objectid){
		if(window.confirm('<%=getTranNoLink("web","areyousuretodelete",sWebLanguage)%>')){
		    var url = "<c:url value='/assets/ajax/asset/deleteDocument.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		      method: "GET",
		      parameters: "objectid="+objectid,
		      onSuccess: function(resp){
	        	  loadDocuments();
		      },
		    });
		}
  }
  function monitordocuments(udi){
	    document.getElementById("documentsLoaderDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/>";  
	    var url = "<c:url value='/assets/ajax/asset/findDocument.jsp'/>?ts="+new Date().getTime();
	    new Ajax.Request(url,{
	      method: "GET",
	      parameters: "udi="+udi,
	      onSuccess: function(resp){
	          var data = eval("("+resp.responseText+")");
	          if(data.found=="1"){
	        	  loadDocuments();
	        	  document.getElementById("documentsLoaderDiv").innerHTML='';
	          }
	          else{
	        	  window.setTimeout("monitordocuments('"+udi+"');",1000);
	          }
	      },
	    });
  }
  
  <%-- DISPLAY ASSET --%>
  function displayAsset(assetUID){
	  document.getElementById("action").value="edit";
	  document.getElementById("EditAssetUID").value=assetUID;
	  SearchForm.submit();
  }

  <%-- SORT PURCHASE DOCUMENTS --%>
  function sortPurchaseDocuments(){
    var sortLink = document.getElementById("tblPD_lnk1");
    if(sortLink!=null){
      ts_resortTable(sortLink,1,false);
    }

    updateRowStylesSpecificTable("tblPD",2);
  }

  <%-- SORT LOAN DOCUMENTS --%>
  function sortLoanDocuments(){
    var sortLink = document.getElementById("tblLD_lnk1");
    if(sortLink!=null){
      ts_resortTable(sortLink,1,false);
    }

    updateRowStylesSpecificTable("tblLD",2);
  }
  
  <%-- DELETE ASSET --%>
  function deleteAsset(){ 
      if(yesnoDeleteDialog()){
      var url = "<c:url value='/assets/ajax/asset/deleteAsset.jsp'/>?ts="+new Date().getTime();
      disableButtons();
    
      new Ajax.Request(url,{
        method: "GET",
        parameters: "AssetUID="+document.getElementById("EditAssetUID").value,
        onSuccess: function(resp){
          var data = eval("("+resp.responseText+")");
          $("divMessage").innerHTML = data.message;

          enableButtons();
          listAssets();
        },
        onFailure: function(resp){
          $("divMessage").innerHTML = "Error in 'assets/ajax/asset/deleteAsset.jsp' : "+resp.responseText.trim();
        }  
      });
    }
  }
  
  <%-- NEW ASSET --%>
  function newAsset(){ 
    displayReimbursementTotals(0,0,0);
    clearAllTables();   
    
    <%-- hide irrelevant buttons --%>
    if (document.getElementById("buttonDelete")) document.getElementById("buttonDelete").style.visibility = "hidden";
    if (document.getElementById("buttonNew")) document.getElementById("buttonNew").style.visibility = "hidden";

    $("EditAssetUID").value = "-1";
    $("code").value = "";
    $("description").value = "";
    $("serialnumber").value = "";
    $("quantity").value = "1"; // default
    $("assetType").value = "";
    clearSupplierFields();
    $("purchaseDate").value = "";
    $("purchasePrice").value = "";
    $("receiptBy").value = "";
    clearPDTable();
    $("writeOffMethod").value = "";
    $("writeOffPeriod").value = "";
    $("annuity").value = "";
    $("characteristics").value = "";
    $("accountingCode").value = "";
    clearGATable();
    clearLOTable();

    $("residualValueHistory").innerHTML = "";
    <%
        if(sAgent.contains("msie")){
            %>$("residualValueHistoryDiv").style.display = "none";<%
        }
    %>
            
    //*** loan ***
    $("loanDate").value = "";
    $("loanAmount").value = "";
    $("loanInterestRate").value = "";
    clearRPTable();
    $("loanReimbursementCapitalTotal").innerHTML = "";
    $("loanReimbursementInterestTotal").innerHTML = "";
    $("loanReimbursementAmount").innerHTML = "";
    $("loanComment").value = "";
    clearLDTable();
    
    $("saleDate").value = "";
    $("saleValue").value = "";
    $("saleClient").value = "";
    
    $("code").focus();
    resizeAllTextareas(8);
  }
  
  <%-- CLEAR ALL TABLES --%>
  function clearAllTables(){     
    clearPDTable();
    clearGATable();
    clearLOTable();
    clearRPTable();
    clearLDTable();
  }
      
  <%-- SELECT SUPPLIER --%>
  function selectSupplier(uidField,nameField){
    var url = "/_common/search/searchSupplier.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=400"+
              "&ReturnFieldUid="+uidField+
              "&ReturnFieldName="+nameField;
    openPopup(url);
    document.getElementById(nameField).focus();
  }

  <%-- SELECT PARENT --%>
  function selectParent(uidField,codeField){
    var url = "/_common/search/searchAsset.jsp&ts=<%=getTs()%>"+
              "&ReturnFieldUid="+uidField+
              "&ReturnFieldCode="+codeField;
    openPopup(url);
    document.getElementById(codeField).focus();
  }
  
  <%-- DISABLE BUTTONS --%>
  function disableButtons(){
    if(document.getElementById("buttonSave")) document.getElementById("buttonSave").disabled = true;
    if(document.getElementById("buttonDelete")) document.getElementById("buttonDelete").disabled = true;
    if(document.getElementById("buttonNew")) document.getElementById("buttonNew").disabled = true;
  }

  <%-- ENABLE BUTTONS --%>
  function enableButtons(){
	  if(document.getElementById("buttonSave"))document.getElementById("buttonSave").disabled = false;
	  if(document.getElementById("buttonDelete"))document.getElementById("buttonDelete").disabled = false;
	  if(document.getElementById("buttonNew"))document.getElementById("buttonNew").disabled = false;
  }
  
  <%-- CALCULATE REIMBURSEMENT TOTALS --%>
  function calculateReimbursementTotals(){
    var sPlans = sRP;

    <%-- compose string containing reimbursement plan --%>
    while(sPlans.indexOf("rowRP") > -1){
      sTmpBegin = sPlans.substring(sPlans.indexOf("rowRP"));
      sTmpEnd = sTmpBegin.substring(sTmpBegin.indexOf("=")+1);
      sPlans = sPlans.substring(0,sPlans.indexOf("rowRP"))+sTmpEnd;
    }
    
    var totalCapital = 0, totalInterest = 0, totalAmount = 0;
    
    if(sPlans.indexOf("$") > -1){
      var sTmpRP = sPlans;
      
      var sTmpDate, sTmpCapital, sTmpInterest;
      
      while(sTmpRP.indexOf("|") > -1){
        sTmpDate = "";
        sTmpCapital = "";
        sTmpInterest = "";

        if(sTmpRP.indexOf("|") > -1){
          sTmpDate = sTmpRP.substring(0,sTmpRP.indexOf("|"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("|")+1);
        }
        
        if(sTmpRP.indexOf("|") > -1){
          sTmpCapital = sTmpRP.substring(0,sTmpRP.indexOf("|"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("|")+1);
        }
        
        if(sTmpRP.indexOf("$") > -1){
          sTmpInterest = sTmpRP.substring(0,sTmpRP.indexOf("$"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("$")+1);
        }

        totalCapital+= parseInt(sTmpCapital);
        totalInterest+= parseInt(sTmpInterest);
        totalAmount+= parseInt(sTmpCapital)+parseInt(sTmpInterest);
      }

      $("loanReimbursementCapitalTotal").innerHTML = formatNumber(totalCapital,2);
      $("loanReimbursementInterestTotal").innerHTML = formatNumber(totalInterest,2);
      $("loanReimbursementAmount").innerHTML = formatNumber(totalAmount,2);
    }
    else{
      document.getElementById("loanReimbursementCapitalTotal").innerHTML = "";
      document.getElementById("loanReimbursementInterestTotal").innerHTML = "";
      document.getElementById("loanReimbursementAmount").innerHTML = "";
    }
  }
  
  
  <%---------------------------------------------------------------------------------------------%>
  <%-- JS 1 : GAINS FUNCTIONS (GA) --------------------------------------------------------------%>
  <%---------------------------------------------------------------------------------------------%>
  var editGARowid = "", iGAIndex = 1, sGA = "";

  <%-- DISPLAY GAINS --%>
  function displayGains(){
    sGA = document.getElementById("gains").value;
        
    if(sGA.indexOf("$") > -1){
      var sTmpGA = sGA;
      sGA = "";
      
      var sTmpDate, sTmpValue;
 
      while(sTmpGA.indexOf("$") > -1){
        sTmpDate = "";
        sTmpValue = "";

        if(sTmpGA.indexOf("|") > -1){
          sTmpDate = sTmpGA.substring(0,sTmpGA.indexOf("|"));
          sTmpGA = sTmpGA.substring(sTmpGA.indexOf("|")+1);
        }
        
        if(sTmpGA.indexOf("$") > -1){
          sTmpValue = sTmpGA.substring(0,sTmpGA.indexOf("$"));
          sTmpGA = sTmpGA.substring(sTmpGA.indexOf("$")+1);
        }            

        sGA+= "rowGA"+iGAIndex+"="+sTmpDate+"|"+
                                   sTmpValue+"$";
        displayGain(iGAIndex++,sTmpDate,sTmpValue);
      }
    }
  }
  
  <%-- DISPLAY GAIN --%>
  function displayGain(iGAIndex,sDate,sValue){
    var tr = tblGA.insertRow(tblGA.rows.length);
    tr.id = "rowGA"+iGAIndex;

    var td = tr.insertCell(0);
    td.innerHTML = "<a href='javascript:deleteGA(rowGA"+iGAIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                   "</a> "+
                   "<a href='javascript:editGA(rowGA"+iGAIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>' style='vertical-align:-3px;'>"+
                   "</a>";
    tr.appendChild(td);

    td = tr.insertCell(1);
    td.innerHTML = "&nbsp;"+sDate;
    tr.appendChild(td);

    td = tr.insertCell(2);
    td.align = "right";
    td.innerHTML = "&nbsp;"+sValue+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(3);
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);
    
    setRowStyle(tr,iGAIndex-1);
  }
  
  <%-- ADD GAIN --%>
  function addGA(){
	var maxGains = <%=ScreenHelper.getConfigString("maxGains","20")%>;
    if(countSelectedGains() <= maxGains){
      if(areRequiredGAFieldsFilled()){
        var okToAdd = true;
          
        if(okToAdd==true){
          iGAIndex++;

          sGA+="rowGA"+iGAIndex+"="+EditForm.gaDate.value+"|"+
                                    EditForm.gaValue.value+"$";
        
          var tr = tblGA.insertRow(tblGA.rows.length);
          tr.id = "rowGA"+iGAIndex;

          var td = tr.insertCell(0);
          td.innerHTML = "<a href='javascript:deleteGA(rowGA"+iGAIndex+")'>"+
                          "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                         "</a> "+
                         "<a href='javascript:editGA(rowGA"+iGAIndex+")'>"+
                          "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                         "</a>";
          tr.appendChild(td);

          td = tr.insertCell(1);
          td.innerHTML = "&nbsp;"+EditForm.gaDate.value;
          tr.appendChild(td);

          td = tr.insertCell(2);
          td.align = "right";
          td.innerHTML = "&nbsp;"+EditForm.gaValue.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
          tr.appendChild(td);
                  
          <%-- empty cell --%>
          td = tr.insertCell(3);
          td.innerHTML = "&nbsp;";
          tr.appendChild(td);

          setRowStyle(tr,iGAIndex);
      
          <%-- reset --%>
          clearGAFields()
          EditForm.ButtonUpdateGA.disabled = true;
        }
      }
      else{
        alertDialog("web.manage","dataMissing");
    
        <%-- focus empty field --%>
             if(EditForm.gaDate.value.length==0) EditForm.gaDate.focus();
        else if(EditForm.gaValue.value==0) EditForm.gaValue.focus();
      }
    
      return true;
    }
    else{
      alertDialogDirectText(replaceAll("<%=getTranNoLink("web.assets","reachedMaximumGains",sWebLanguage)%>","#maxGains#",maxGains));
      return false;
    }
  }
  
  <%-- COUNT SELECTED GAINS --%>
  function countSelectedGains(){
    var table = document.getElementById("tblGA");
    return table.rows.length-1; // exclude add-row
  }

  <%-- UPDATE GAIN --%>
  function updateGA(){
    if(areRequiredGAFieldsFilled()){
      var okToAdd = true;
    
      if(okToAdd==true){        
        var newRow = editGARowid.id+"="+EditForm.gaDate.value+"|"+
                                        EditForm.gaValue.value;

        sGA = replaceRowInArrayString(sGA,newRow,editGARowid.id);

        <%-- update table object --%>
        var row = tblGA.rows[editGARowid.rowIndex];
        row.cells[0].innerHTML = "<a href='javascript:deleteGA("+editGARowid.id+")'>"+
                                  "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                                 "</a> "+
                                 "<a href='javascript:editGA("+editGARowid.id+")'>"+
                                  "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                                 "</a>";

        row.cells[1].innerHTML = "&nbsp;"+EditForm.gaDate.value;
        row.cells[2].innerHTML = "&nbsp;"+EditForm.gaValue.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
                        
        <%-- empty cell --%>
        row.cells[3].innerHTML = "&nbsp;";

        <%-- reset --%>
        clearGAFields();
        EditForm.ButtonUpdateGA.disabled = true;
      }
    }
    else{
      alertDialog("web.manage","dataMissing");
    
      <%-- focus empty field --%>
           if(EditForm.gaDate.value.length==0) EditForm.gaDate.focus();
      else if(EditForm.gaValue.value==0) EditForm.gaValue.focus();
    }
  }
  
  <%-- ARE REQUIRED GA FIELDS FILLED --%>
  function areRequiredGAFieldsFilled(){
    return (EditForm.gaDate.value.length > 0 &&
            EditForm.gaValue.value.length > 0);
  }

  <%-- CLEAR GAIN FIELDS --%>
  function clearGAFields(){
    EditForm.gaDate.value = "";
    EditForm.gaValue.value = "";   
  }

  <%-- CLEAR GAIN TABLE --%>
  function clearGATable(){
    $("gains").value = "";
    var table = document.getElementById("tblGA");
    
    for(var i=table.rows.length; i>2; i--){
      table.deleteRow(i-1);
    }
  }
  
  <%-- DELETE GAIN --%>
  function deleteGA(rowid){
      if(yesnoDeleteDialog()){
      sGA = deleteRowFromArrayString(sGA,rowid.id);
      tblGA.deleteRow(rowid.rowIndex);
      
      updateRowStylesSpecificTable("tblGA",2);
      clearGAFields();
    }
  }

  <%-- EDIT GAIN --%>
  function editGA(rowid){
    var row = getRowFromArrayString(sGA,rowid.id);

    EditForm.gaDate.value  = getCelFromRowString(row,0);
    EditForm.gaValue.value = getCelFromRowString(row,1);

    editGARowid = rowid;
    EditForm.ButtonUpdateGA.disabled = false;
  }

  
  <%---------------------------------------------------------------------------------------------%>
  <%-- JS 2 : LOSSES FUNCTIONS (LO) -------------------------------------------------------------%>
  <%---------------------------------------------------------------------------------------------%>
  var editLORowid = "", iLOIndex = 1, sLO = "";

  <%-- DISPLAY LOSSES --%>
  function displayLosses(){
    sLO = document.getElementById("losses").value;
        
    if(sLO.indexOf("$") > -1){
      var sTmpLO = sLO;
      sLO = "";
      
      var sTmpDate, sTmpValue;
 
      while(sTmpLO.indexOf("$") > -1){
        sTmpDate = "";
        sTmpValue = "";

        if(sTmpLO.indexOf("|") > -1){
          sTmpDate = sTmpLO.substring(0,sTmpLO.indexOf("|"));
          sTmpLO = sTmpLO.substring(sTmpLO.indexOf("|")+1);
        }
        
        if(sTmpLO.indexOf("$") > -1){
          sTmpValue = sTmpLO.substring(0,sTmpLO.indexOf("$"));
          sTmpLO = sTmpLO.substring(sTmpLO.indexOf("$")+1);
        }

        sLO+= "rowLO"+iLOIndex+"="+sTmpDate+"|"+
                                   sTmpValue+"$";
        displayLoss(iLOIndex++,sTmpDate,sTmpValue);
      }
    }
  }
  
  <%-- DISPLAY LOSS --%>
  function displayLoss(iLOIndex,sDate,sValue){
    var tr = tblLO.insertRow(tblLO.rows.length);
    tr.id = "rowLO"+iLOIndex;

    var td = tr.insertCell(0);
    td.innerHTML = "<a href='javascript:deleteLO(rowLO"+iLOIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                   "</a> "+
                   "<a href='javascript:editLO(rowLO"+iLOIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>' style='vertical-align:-3px;'>"+
                   "</a>";
    tr.appendChild(td);

    td = tr.insertCell(1);
    td.innerHTML = "&nbsp;"+sDate;
    tr.appendChild(td);

    td = tr.insertCell(2);
    td.align = "right";
    td.innerHTML = "&nbsp;"+sValue+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(3);
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);
    
    setRowStyle(tr,iLOIndex-1);
  }
  
  <%-- ADD LOSS --%>
  function addLO(){
	var maxLosses = <%=ScreenHelper.getConfigString("maxLosses","20")%>;
    if(countSelectedLosses() <= maxLosses){
      if(areRequiredLOFieldsFilled()){
        var okToAdd = true;
          
        if(okToAdd==true){
          iLOIndex++;

          sLO+="rowLO"+iLOIndex+"="+EditForm.loDate.value+"|"+
                                    EditForm.loValue.value+"$";
        
          var tr = tblLO.insertRow(tblLO.rows.length);
          tr.id = "rowLO"+iLOIndex;

          var td = tr.insertCell(0);
          td.innerHTML = "<a href='javascript:deleteLO(rowLO"+iLOIndex+")'>"+
                          "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                         "</a> "+
                         "<a href='javascript:editLO(rowLO"+iLOIndex+")'>"+
                          "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                         "</a>";
          tr.appendChild(td);

          td = tr.insertCell(1);
          td.innerHTML = "&nbsp;"+EditForm.loDate.value;
          tr.appendChild(td);

          td = tr.insertCell(2);
          td.align = "right";
          td.innerHTML = "&nbsp;"+EditForm.loValue.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
          tr.appendChild(td);
                  
          <%-- empty cell --%>
          td = tr.insertCell(3);
          td.innerHTML = "&nbsp;";
          tr.appendChild(td);

          setRowStyle(tr,iLOIndex);
      
          <%-- reset --%>
          clearLOFields()
          EditForm.ButtonUpdateLO.disabled = true;
        }
      }
      else{
        alertDialog("web.manage","dataMissing");
    
        <%-- focus empty field --%>
             if(EditForm.loDate.value.length==0) EditForm.loDate.focus();
        else if(EditForm.loValue.value==0) EditForm.loValue.focus();
      }
     
      return true;
    }
    else{
      alertDialogDirectText(replaceAll("<%=getTranNoLink("web.assets","reachedMaximumLosses",sWebLanguage)%>","#maxLosses#",maxLosses));
      return false;
    }
  }
  
  <%-- COUNT SELECTED LOSSES --%>
  function countSelectedLosses(){
    var table = document.getElementById("tblLO");
    return table.rows.length-1; // exclude add-row
  }

  <%-- UPDATE LOSS --%>
  function updateLO(){
    if(areRequiredLOFieldsFilled()){
      var okToAdd = true;
    
      if(okToAdd==true){        
        var newRow = editLORowid.id+"="+EditForm.loDate.value+"|"+
                                        EditForm.loValue.value;

        sLO = replaceRowInArrayString(sLO,newRow,editLORowid.id);

        <%-- update table object --%>
        var row = tblLO.rows[editLORowid.rowIndex];
        row.cells[0].innerHTML = "<a href='javascript:deleteLO("+editLORowid.id+")'>"+
                                  "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                                 "</a> "+
                                 "<a href='javascript:editLO("+editLORowid.id+")'>"+
                                  "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                                 "</a>";

        row.cells[1].innerHTML = "&nbsp;"+EditForm.loDate.value;
        row.cells[2].innerHTML = "&nbsp;"+EditForm.loValue.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
                        
        <%-- empty cell --%>
        row.cells[3].innerHTML = "&nbsp;";

        <%-- reset --%>
        clearLOFields();
        EditForm.ButtonUpdateLO.disabled = true;
      }
    }
    else{
      alertDialog("web.manage","dataMissing");
    
      <%-- focus empty field --%>
           if(EditForm.loDate.value.length==0) EditForm.loDate.focus();
      else if(EditForm.loValue.value==0) EditForm.loValue.focus();
    }
  }
  
  <%-- ARE REQUIRED LO FIELDS FILLED --%>
  function areRequiredLOFieldsFilled(){
    return (EditForm.loDate.value.length > 0 &&
            EditForm.loValue.value.length > 0);
  }

  <%-- CLEAR LOSS FIELDS --%>
  function clearLOFields(){
    EditForm.loDate.value = "";
    EditForm.loValue.value = "";   
  }

  <%-- CLEAR LOSS TABLE --%>
  function clearLOTable(){
    $("losses").value = "";
    var table = document.getElementById("tblLO");
    
    for(var i=table.rows.length; i>2; i--){
      table.deleteRow(i-1);
    }
  }
  
  <%-- DELETE LOSS --%>
  function deleteLO(rowid){
      if(yesnoDeleteDialog()){
      sLO = deleteRowFromArrayString(sLO,rowid.id);
      tblLO.deleteRow(rowid.rowIndex);

      updateRowStylesSpecificTable("tblLO",2);
      clearLOFields();
    }
  }

  <%-- EDIT LOSS --%>
  function editLO(rowid){
    var row = getRowFromArrayString(sLO,rowid.id);

    EditForm.loDate.value  = getCelFromRowString(row,0);
    EditForm.loValue.value = getCelFromRowString(row,1);

    editLORowid = rowid;
    EditForm.ButtonUpdateLO.disabled = false;
  }
  
  <%-- MAKE DOCUMENT LINK --%>
  function makeDocumentLink(documentId,msgDivId){
     return "<a href='javascript:void(0);' onClick=\"displayDocument('"+documentId+"','"+msgDivId+"');\">"+documentId+"</a>";
  }
  
  <%-- DISPLAY DOCUMENT --%>
  function displayDocument(documentId,msgDivId){
	var url = "<%=sCONTEXTPATH%>/assets/ajax/asset/openDocument.jsp?DocumentId="+documentId+"&ts="+new Date().getTime();
    window.open(url,"Document<%=getTs()%>","height=600,width=845,toolbar=no,status=no,scrollbars=yes,resizable=yes,menubar=yes,left=50,top=30");
  }
  

  <%---------------------------------------------------------------------------------------------%>
  <%-- JS 3 : PURCHASE DOCUMENTS FUNCTIONS (PD) -------------------------------------------------%>
  <%---------------------------------------------------------------------------------------------%>
  var editPDRowid = "", iPDIndex = 1, sPD = "";
  
  <%-- DISPLAY PURCHASE DOCUMENTS --%>
  function displayPurchaseDocuments(){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    sPD = document.getElementById("purchaseDocuments").value;
        
    if(sPD.indexOf("$") > -1){
      var sTmpPD = sPD;
      sPD = "";
      
      var sTmpID;
 
      while(sTmpPD.indexOf("$") > -1){
        sTmpID = "";

        if(sTmpPD.indexOf("$") > -1){
          sTmpID = sTmpPD.substring(0,sTmpPD.indexOf("$"));
          sTmpPD = sTmpPD.substring(sTmpPD.indexOf("$")+1);
        }
        
        sPD+= "rowPD"+iPDIndex+"="+sTmpID+"$";
        displayPurchaseDocument(iPDIndex++,sTmpID);
      }
    }
  }
  
  <%-- DISPLAY PURCHASE DOCUMENT --%>
  function displayPurchaseDocument(iPDIndex,sID){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    var tr = tblPD.insertRow(tblPD.rows.length);
    tr.id = "rowPD"+iPDIndex;

    var td = tr.insertCell(0);
    td.innerHTML = "<a href='javascript:deletePD(rowPD"+iPDIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                   "</a> "+
                   "<a href='javascript:editPD(rowPD"+iPDIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>' style='vertical-align:-3px;'>"+
                   "</a>";
    tr.appendChild(td);

    td = tr.insertCell(1);
    td.innerHTML = "&nbsp;"+sID;
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(2);
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);
    
    setRowStyle(tr,iPDIndex-1);
  }
  
  <%-- ADD PURCHASE DOCUMENT --%>
  function addPD(){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    
    if(EditForm.pdID.value.length==0){
      EditForm.pdID.focus(); 
      return;
    }
    
    EditForm.pdID.value = formatDocumentID(EditForm.pdID.value); 
      
   
    if(countSelectedPDs() <= 20){
      if(areRequiredPDFieldsFilled()){
        iPDIndex++;

        sPD+="rowPD"+iPDIndex+"="+EditForm.pdID.value+"$";
        
        var tr = tblPD.insertRow(tblPD.rows.length);
        tr.id = "rowPD"+iPDIndex;

        var td = tr.insertCell(0);
        td.innerHTML = "<a href='javascript:deletePD(rowPD"+iPDIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                       "</a> "+
                       "<a href='javascript:editPD(rowPD"+iPDIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                       "</a>";
        tr.appendChild(td);

        td = tr.insertCell(1);
        td.innerHTML = "&nbsp;"+EditForm.pdID.value;
        tr.appendChild(td);
                  
        <%-- empty cell --%>
        td = tr.insertCell(2);
        td.innerHTML = "&nbsp;";
        tr.appendChild(td);

        setRowStyle(tr,iPDIndex-1);
      
        <%-- reset --%>
        clearPDFields()
        EditForm.ButtonUpdatePD.disabled = true;
      }
      else{
        alertDialog("web.manage","dataMissing");
      
        <%-- focus empty field --%>
        if(EditForm.pdID.value.length==0) EditForm.pdID.focus();
      }
      
      return true; 
    }
    else{
      alertDialogDirectText("<%=getTranNoLink("web.assets","reachedMaximumDocuments",sWebLanguage).replaceAll("#maxDocuments#","20")%>");
      return false;
    }
  }
  
  <%-- COUNT SELECTED PDS --%>
  function countSelectedPDs(){
    var table = document.getElementById("tblPD");
    return table.rows.length-1; // exclude add-row
  }

  <%-- UPDATE PURCHASE DOCUMENT --%>
  function updatePD(){
    $("purchaseDocumentMsgDiv").innerHTML = "";
        
    if(areRequiredPDFieldsFilled()){
      var newRow = editPDRowid.id+"="+EditForm.pdID.value;

      sPD = replaceRowInArrayString(sPD,newRow,editPDRowid.id);

      <%-- update table object --%>
      var row = tblPD.rows[editPDRowid.rowIndex];
      row.cells[0].innerHTML = "<a href='javascript:deletePD("+editPDRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                               "</a> "+
                               "<a href='javascript:editPD("+editPDRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                               "</a>";

      row.cells[1].innerHTML = "&nbsp;"+EditForm.pdID.value;
                                            
      <%-- empty cell --%>
      row.cells[2].innerHTML = "&nbsp;";

      <%-- reset --%>
      clearPDFields();
      EditForm.ButtonUpdatePD.disabled = true;
    }
    else{
      alertDialog("web.manage","dataMissing");
    
      <%-- focus empty field --%>
      if(EditForm.pdID.value.length==0) EditForm.pdID.focus();
    }
  }
  
  <%-- ARE REQUIRED PD FIELDS FILLED --%>
  function areRequiredPDFieldsFilled(){
    return (EditForm.pdID.value.length > 0);
  }

  <%-- CLEAR PURCHASE DOCUMENT FIELDS --%>
  function clearPDFields(){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    EditForm.pdID.value = "";
  }

  <%-- CLEAR PURCHASE DOCUMENT TABLE --%>
  function clearPDTable(){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    $("purchaseDocuments").value = "";
    var table = document.getElementById("tblPD");
    
    for(var i=table.rows.length; i>2; i--){
      table.deleteRow(i-1);
    }
  }
  
  <%-- DELETE PURCHASE DOCUMENT --%>
  function deletePD(rowid){
    $("purchaseDocumentMsgDiv").innerHTML = "";

    if(yesnoDeleteDialog()){
      sPD = deleteRowFromArrayString(sPD,rowid.id);
      tblPD.deleteRow(rowid.rowIndex);

      updateRowStylesSpecificTable("tblPD",2);
      clearPDFields();
    }
  }

  <%-- EDIT PURCHASE DOCUMENT --%>
  function editPD(rowid){
    $("purchaseDocumentMsgDiv").innerHTML = "";
    var row = getRowFromArrayString(sPD,rowid.id);

    EditForm.pdID.value = getCelFromRowString(row,0);

    editPDRowid = rowid;
    EditForm.ButtonUpdatePD.disabled = false;
  }

  
  <%---------------------------------------------------------------------------------------------%>
  <%-- JS 4 : LOAN REIMBURSEMENT PLAN FUNCTIONS (RP) --------------------------------------------%>
  <%---------------------------------------------------------------------------------------------%>
  var editRPRowid = "", iRPIndex = 1, sRP = "";

  <%-- DISPLAY REIMBURSEMENT PLANS --%>
  function displayReimbursementPlans(){
    sRP = document.getElementById("loanReimbursementPlan").value;
        
    if(sRP.indexOf("|") > -1){
      var sTmpRP = sRP;
      sRP = "";
      
      var sTmpDate, sTmpCapital, sTmpInterest;
 
      while(sTmpRP.indexOf("|") > -1){
        sTmpDate = "";
        sTmpCapital = "";
        sTmpInterest = "";
        
        if(sTmpRP.indexOf("|") > -1){
          sTmpDate = sTmpRP.substring(0,sTmpRP.indexOf("|"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("|")+1);
        }
        
        if(sTmpRP.indexOf("|") > -1){
          sTmpCapital = sTmpRP.substring(0,sTmpRP.indexOf("|"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("|")+1);
        }
        
        if(sTmpRP.indexOf("$") > -1){
          sTmpInterest = sTmpRP.substring(0,sTmpRP.indexOf("$"));
          sTmpRP = sTmpRP.substring(sTmpRP.indexOf("$")+1);
        }
        
        var sTotal = formatNumber(sTmpCapital+sTmpInterest,2);
        
        sRP+= "rowRP"+iRPIndex+"="+sTmpDate+"|"+sTmpCapital+"|"+sTmpInterest+"$";
        displayReimbursementPlan(iRPIndex++,sTmpDate,sTmpCapital,sTmpInterest,sTotal);
      }
    }
  }
  
  <%-- DISPLAY REIMBURSEMENT PLAN --%>
  function displayReimbursementPlan(iRPIndex,sDate,sCapital,sInterest,sTotal){
    var tr = tblRP.insertRow(tblRP.rows.length-1);
    tr.id = "rowRP"+iRPIndex;

    var td = tr.insertCell(0);
    td.innerHTML = "<a href='javascript:deleteRP(rowRP"+iRPIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                   "</a> "+
                   "<a href='javascript:editRP(rowRP"+iRPIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>' style='vertical-align:-3px;'>"+
                   "</a>";
    tr.appendChild(td);

    td = tr.insertCell(1);
    td.innerHTML = "&nbsp;"+sDate;
    tr.appendChild(td);
    
    td = tr.insertCell(2);
    td.align = "right";
    td.innerHTML = "&nbsp;"+sCapital+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);

    td = tr.insertCell(3);
    td.align = "right";
    td.innerHTML = "&nbsp;"+sInterest+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);
    
    td = tr.insertCell(4);
    td.align = "right";
    td.innerHTML = "&nbsp;"+sTotal+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(5);
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);
    
    setRowStyle(tr,iRPIndex-1);
  }
  
  <%-- DISPLAY REIMBURSEMENT TOTALS --%>
  function displayReimbursementTotals(capitalTotal,interestTotal,amountTotal){
    var tr = tblRP.insertRow(tblRP.rows.length);  
    tr.id = "totalRP"+iRPIndex;

    <%-- empty cell --%>
    var td = tr.insertCell(0);
    td.style.backgroundColor = "#ccc";
    td.innerHTML = "&nbsp;";  
    tr.appendChild(td);

    <%-- empty cell --%>
    td = tr.insertCell(1);
    td.style.backgroundColor = "#ccc";
    td.innerHTML = "<%=getTranNoLink("web","totals",sWebLanguage)%>&nbsp;";
    td.align = "right";        
    tr.appendChild(td);

    <%-- capital total --%>
    td = tr.insertCell(2);
    td.style.backgroundColor = "#ccc";
    td.align = "right";            
    td.innerHTML = "&nbsp;<span id='loanReimbursementCapitalTotal' style='searchResults' style='vertical-align:-3px;color:#505050;padding:3px;width:50px;height:18px;border:1px solid #ccc;background:#f0f0f0;'>"+capitalTotal+"</span> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);

    <%-- interest total --%>
    td = tr.insertCell(3);
    td.style.backgroundColor = "#ccc";
    td.align = "right";
    td.innerHTML = "&nbsp;<span id='loanReimbursementInterestTotal' style='searchResults' style='vertical-align:-3px;color:#505050;padding:3px;width:50px;height:18px;border:1px solid #ccc;background:#f0f0f0;'>"+interestTotal+"</span> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);

    <%-- amount total --%>
    td = tr.insertCell(4);
    td.style.backgroundColor = "#ccc";
    td.align = "right";
    td.innerHTML = "&nbsp;<span id='loanReimbursementAmount' style='searchResults' style='vertical-align:-3px;color:#505050;padding:3px;width:50px;height:18px;border:1px solid #ccc;background:#f0f0f0;'>"+amountTotal+"</span> <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(5);
    td.style.backgroundColor = "#ccc";
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);    
  }
  
  <%-- ADD REIMBURSEMENT PLAN --%>
  function addRP(){
	var maxReimbursements = <%=ScreenHelper.getConfigString("maxReimbursementPlans","20")%>;
    if(countSelectedRPs() <= maxReimbursements){
      if(areRequiredRPFieldsFilled()){
        iRPIndex++;

        sRP+="rowRP"+iRPIndex+"="+EditForm.rpDate.value+"|"+EditForm.rpCapital.value+"|"+EditForm.rpInterest.value+"$";
        
        var tr = tblRP.insertRow(tblRP.rows.length-1);
        tr.id = "rowRP"+iRPIndex;

        var td = tr.insertCell(0);
        td.innerHTML = "<a href='javascript:deleteRP(rowRP"+iRPIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                       "</a> "+
                       "<a href='javascript:editRP(rowRP"+iRPIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                       "</a>";
        tr.appendChild(td);

        td = tr.insertCell(1);
        td.innerHTML = "&nbsp;"+EditForm.rpDate.value;
        tr.appendChild(td);
      
        td = tr.insertCell(2);
        td.align = "right";
        td.innerHTML = "&nbsp;"+EditForm.rpCapital.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
        tr.appendChild(td);

        td = tr.insertCell(3);
        td.align = "right";
        td.innerHTML = "&nbsp;"+EditForm.rpInterest.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
        tr.appendChild(td);
      
        td = tr.insertCell(4);
        td.align = "right";
        td.innerHTML = "&nbsp;"+document.getElementById("rpTotal").innerHTML+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
        tr.appendChild(td);
                  
        <%-- empty cell --%>
        td = tr.insertCell(5);
        td.innerHTML = "&nbsp;";
        tr.appendChild(td);

        setRowStyle(tr,iRPIndex);
      
        <%-- reset --%>
        clearRPFields()
        EditForm.ButtonUpdateRP.disabled = true;
      
        calculateReimbursementTotals();
      }
      else{
        alertDialog("web.manage","dataMissing");
    
        <%-- focus empty field --%>
             if(EditForm.rpDate.value.length==0) EditForm.rpDate.focus();
        else if(EditForm.rpCapital.value.length==0) EditForm.rpCapital.focus();
        else if(EditForm.rpInterest.value.length==0) EditForm.rpInterest.focus();
      }
    
      return true;
    }
    else{
      alertDialogDirectText(replaceAll("<%=getTranNoLink("web.assets","reachedMaximumReimbursementPlans",sWebLanguage)%>","#maxReimbursements#",maxReimbursements));      
      return false;
    }
  }
  
  <%-- COUNT SELECTED RPS --%>
  function countSelectedRPs(){
    var table = document.getElementById("tblRP");
    return table.rows.length-1; // exclude add-row
  }

  <%-- UPDATE REIMBURSEMENT PLAN --%>
  function updateRP(){
    if(areRequiredRPFieldsFilled()){   
      var newRow = editRPRowid.id+"="+EditForm.rpDate.value+"|"+EditForm.rpCapital.value+"|"+EditForm.rpInterest.value;
 
      sRP = replaceRowInArrayString(sRP,newRow,editRPRowid.id);

      <%-- update table object --%>
      var row = tblRP.rows[editRPRowid.rowIndex];
      row.cells[0].innerHTML = "<a href='javascript:deleteRP("+editRPRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                               "</a> "+
                               "<a href='javascript:editRP("+editRPRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                               "</a>";

      row.cells[1].innerHTML = "&nbsp;"+EditForm.rpDate.value;
      row.cells[2].innerHTML = "&nbsp;"+EditForm.rpCapital.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
      row.cells[3].innerHTML = "&nbsp;"+EditForm.rpInterest.value+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
      row.cells[4].innerHTML = "&nbsp;"+document.getElementById("rpTotal").innerHTML+" <%=MedwanQuery.getInstance().getConfigParam("currency","€")%>&nbsp;";
                        
      <%-- empty cell --%>
      row.cells[5].innerHTML = "&nbsp;";

      <%-- reset --%>
      clearRPFields();
      EditForm.ButtonUpdateRP.disabled = true;
      
      calculateReimbursementTotals();
    }
    else{
      alertDialog("web.manage","dataMissing");
    
      <%-- focus empty field --%>
           if(EditForm.rpDate.value.length==0) EditForm.rpDate.focus();
      else if(EditForm.rpCapital.value.length==0) EditForm.rpCapital.focus();
      else if(EditForm.rpInterest.value.length==0) EditForm.rpInterest.focus();
    }
  }
  
  <%-- ARE REQUIRED RP FIELDS FILLED --%>
  function areRequiredRPFieldsFilled(){
    return (EditForm.rpDate.value.length > 0 &&
            EditForm.rpCapital.value.length > 0 &&
            EditForm.rpInterest.value.length > 0);
  }

  <%-- CLEAR REIMBURSEMENT PLAN FIELDS --%>
  function clearRPFields(){
    EditForm.rpDate.value = "";
    EditForm.rpCapital.value = "";
    EditForm.rpInterest.value = "";  
    
    document.getElementById("rpTotal").innerHTML = "";
  }

  <%-- CLEAR REIMBURSEMENT PLAN TABLE --%>
  function clearRPTable(){
    $("loanReimbursementPlan").value = "";
    
    var table = document.getElementById("tblRP");    
    for(var i=table.rows.length-1; i>2; i--){
      table.deleteRow(i-1);
    }

    document.getElementById("loanReimbursementCapitalTotal").innerHTML = "";
    document.getElementById("loanReimbursementInterestTotal").innerHTML = "";
    document.getElementById("loanReimbursementAmount").innerHTML = "";
  }
  
  <%-- DELETE REIMBURSEMENT PLAN --%>
  function deleteRP(rowid){
      if(yesnoDeleteDialog()){
      sRP = deleteRowFromArrayString(sRP,rowid.id);
      tblRP.deleteRow(rowid.rowIndex);

      updateRowStylesSpecificTable("tblRP",2);
      clearRPFields();
      calculateReimbursementTotals();
    }
  }

  <%-- EDIT REIMBURSEMENT PLAN --%>
  function editRP(rowid){
    var row = getRowFromArrayString(sRP,rowid.id);

    EditForm.rpDate.value = getCelFromRowString(row,0);
    EditForm.rpCapital.value = getCelFromRowString(row,1);
    EditForm.rpInterest.value = getCelFromRowString(row,2);

    <%-- calculate total --%>
    document.getElementById("rpTotal").innerHTML = formatNumber(EditForm.rpCapital.value+EditForm.rpInterest.value,2); 
        
    editRPRowid = rowid;
    EditForm.ButtonUpdateRP.disabled = false;
  }
  

  <%---------------------------------------------------------------------------------------------%>
  <%-- JS 5 : LOAN DOCUMENTS FUNCTIONS (LD) -----------------------------------------------------%>
  <%---------------------------------------------------------------------------------------------%>
  var editLDRowid = "", iLDIndex = 1, sLD = "";

  <%-- DISPLAY LOAN DOCUMENTS --%>
  function displayLoanDocuments(){
    sLD = document.getElementById("loanDocuments").value;
        
    if(sLD.indexOf("$") > -1){
      var sTmpLD = sLD;
      sLD = "";
      
      var sTmpID;
 
      while(sTmpLD.indexOf("$") > -1){
        sTmpID = "";

        if(sTmpLD.indexOf("$") > -1){
          sTmpID = sTmpLD.substring(0,sTmpLD.indexOf("$"));
          sTmpLD = sTmpLD.substring(sTmpLD.indexOf("$")+1);
        }
        
        sLD+= "rowLD"+iLDIndex+"="+sTmpID+"$";
        displayLoanDocument(iLDIndex++,sTmpID);
      }
    }
  }
  
  <%-- DISPLAY LOAN DOCUMENT --%>
  function displayLoanDocument(iLDIndex,sID){
    $("loanDocumentMsgDiv").innerHTML = "";
	
    var tr = tblLD.insertRow(tblLD.rows.length);
    tr.id = "rowLD"+iLDIndex;

    var td = tr.insertCell(0);
    td.innerHTML = "<a href='javascript:deleteLD(rowLD"+iLDIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                   "</a> "+
                   "<a href='javascript:editLD(rowLD"+iLDIndex+")'>"+
                    "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>' style='vertical-align:-3px;'>"+
                   "</a>";
    tr.appendChild(td);

    td = tr.insertCell(1);
    td.innerHTML = "&nbsp;"+sID;
    tr.appendChild(td);
               
    <%-- empty cell --%>
    td = tr.insertCell(2);
    td.innerHTML = "&nbsp;";
    tr.appendChild(td);
    
    setRowStyle(tr,iLDIndex-1);
  }
  
  <%-- ADD LOAN DOCUMENT --%>
  function addLD(){
    $("loanDocumentMsgDiv").innerHTML = "";
	    
    if(EditForm.ldID.value.length==0){
      EditForm.ldID.focus(); 
      return;
    }
    
    EditForm.ldID.value = formatDocumentID(EditForm.ldID.value);
      
    if(sLD.indexOf(EditForm.ldID.value) > -1){
      alertDialog("web.assets","documentAlreadySelected");
      //EditForm.ldID.focus();
      return false;        
    }
    
    if(countSelectedLDs() <= 20){
      if(areRequiredLDFieldsFilled()){
        iLDIndex++;

        sLD+="rowLD"+iLDIndex+"="+EditForm.ldID.value+"$";
        
        var tr = tblLD.insertRow(tblLD.rows.length);
        tr.id = "rowLD"+iLDIndex;

        var td = tr.insertCell(0);
        td.innerHTML = "<a href='javascript:deleteLD(rowLD"+iLDIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                       "</a> "+
                       "<a href='javascript:editLD(rowLD"+iLDIndex+")'>"+
                        "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                       "</a>";
        tr.appendChild(td);

        td = tr.insertCell(1);
        td.innerHTML = "&nbsp;"+EditForm.ldID.value;
        tr.appendChild(td);
                  
        <%-- empty cell --%>
        td = tr.insertCell(2);
        td.innerHTML = "&nbsp;";
        tr.appendChild(td);

        setRowStyle(tr,iLDIndex-1);
      
        <%-- reset --%>
        clearLDFields()
        EditForm.ButtonUpdateLD.disabled = true;
      }
      else{
        alertDialog("web.manage","dataMissing");
    
        <%-- focus empty field --%>
        if(EditForm.ldID.value.length==0) EditForm.ldID.focus();
      }
    
      return true;
    }
    else{
      alertDialogDirectText("<%=getTranNoLink("web.assets","reachedMaximumDocuments",sWebLanguage).replaceAll("#maxDocuments#","20")%>");
      return false;
    }
  }  
  
  <%-- FORMAT DOCUMENT ID --%>
  function formatDocumentID(docID){
	return docID;
	
	/*  
    docID = replaceAll(docID,"-","");
    docID = replaceAll(docID,".","");

    if(docID.length==11){
      var part1 = docID.substr(0,9),
          part2 = docID.substr(9,2);
    
      return part1+"-"+part2;
    }
    else{
      return docID;
    }
    */
  }
  
  <%-- COUNT SELECTED LDS --%>
  function countSelectedLDs(){
    var table = document.getElementById("tblLD");
    return table.rows.length-1; // exclude add-row
  }
  
  <%-- UPDATE LOAN DOCUMENT --%>
  function updateLD(){
    $("loanDocumentMsgDiv").innerHTML = "";
    
    if(areRequiredLDFieldsFilled()){   
      var newRow = editLDRowid.id+"="+EditForm.ldID.value;
 
      sLD = replaceRowInArrayString(sLD,newRow,editLDRowid.id);

      <%-- update table object --%>
      var row = tblLD.rows[editLDRowid.rowIndex];
      row.cells[0].innerHTML = "<a href='javascript:deleteLD("+editLDRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_delete.png' class='link' alt='<%=getTranNoLink("web","delete",sWebLanguage)%>'>"+
                               "</a> "+
                               "<a href='javascript:editLD("+editLDRowid.id+")'>"+
                                "<img src='<%=sCONTEXTPATH%>/_img/icons/icon_edit.png' class='link' alt='<%=getTranNoLink("web","edit",sWebLanguage)%>'>"+
                               "</a>";

      row.cells[1].innerHTML = "&nbsp;"+EditForm.ldID.value;
                        
      <%-- empty cell --%>
      row.cells[2].innerHTML = "&nbsp;";

      <%-- reset --%>
      clearLDFields();
      EditForm.ButtonUpdateLD.disabled = true;
    }
    else{
      alertDialog("web.manage","dataMissing");
    
      <%-- focus empty field --%>
      if(EditForm.ldID.value.length==0) EditForm.ldID.focus();
    }
  }
  
  <%-- ARE REQUIRED LD FIELDS FILLED --%>
  function areRequiredLDFieldsFilled(){
    return (EditForm.ldID.value.length > 0);
  }

  <%-- CLEAR LOAN DOCUMENT FIELDS --%>
  function clearLDFields(){
    $("loanDocumentMsgDiv").innerHTML = "";
    EditForm.ldID.value = "";  
  }

  <%-- CLEAR LOAN DOCUMENT TABLE --%>
  function clearLDTable(){
    $("loanDocumentMsgDiv").innerHTML = "";
    $("loanDocuments").value = "";
    
    var table = document.getElementById("tblLD");    
    for(var i=table.rows.length; i>2; i--){
      table.deleteRow(i-1);
    }
  }
  
  <%-- DELETE LOAN DOCUMENT --%>
  function deleteLD(rowid){
    $("loanDocumentMsgDiv").innerHTML = "";

    if(yesnoDeleteDialog()){
      sLD = deleteRowFromArrayString(sLD,rowid.id);
      tblLD.deleteRow(rowid.rowIndex);

      updateRowStylesSpecificTable("tblLD",2);
      clearLDFields();
    }
  }

  function searchNomenclature(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=asset&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}
  function searchComponents(CategoryUidField){
	  showComponents(1);  
	  openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=assetcomponent&noclose=1&VarCode="+CategoryUidField);
	}
  function searchComponent(CategoryUidField,CategoryNameField){
	    openPopup("/_common/search/searchNomenclature.jsp&ts=<%=getTs()%>&FindType=assetcomponent&noclose=0&VarCode="+CategoryUidField+"&VarText="+CategoryNameField);
	}
  function searchService(serviceUidField,serviceNameField){
  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  	document.getElementById(serviceNameField).focus();
    }

  function addDocument(uid){
  	openPopup("/assets/addDocument.jsp&ts=<%=getTs()%>&PopupHeight=200&PopupWidth=500&assetuid="+uid);
  }

  <%-- EDIT LOAN DOCUMENT --%>
  function editLD(rowid){
    $("loanDocumentMsgDiv").innerHTML = "";
    var row = getRowFromArrayString(sLD,rowid.id);

    EditForm.ldID.value = getCelFromRowString(row,0);

    editLDRowid = rowid;
    EditForm.ButtonUpdateLD.disabled = false;
  }
  
  function validateLabels(){
	  if(document.getElementById("FindNomenclatureCode").value.startsWith("E")){
		  document.getElementById("serialnumber_label").innerHTML='<%=getTranNoLink("gmao","serialnumber",sWebLanguage)%>';
		  document.getElementById("quantity_label").innerHTML='<%=getTranNoLink("gmao","quantity",sWebLanguage)%>';
		  document.getElementById("supplier_label").innerHTML='<%=getTranNoLink("gmao","supplier",sWebLanguage)%>';
	  }
	  else if(document.getElementById("FindNomenclatureCode").value.startsWith("I")){
		  document.getElementById("serialnumber_label").innerHTML='<%=getTranNoLink("gmao","cadasternumber",sWebLanguage)%>';
		  document.getElementById("quantity_label").innerHTML='<%=getTranNoLink("gmao","surface",sWebLanguage)%>';
		  document.getElementById("supplier_label").innerHTML='<%=getTranNoLink("gmao","enterprise",sWebLanguage)%>';
	  }
  }
  
  validateLabels();
  
  resizeAllTextareas(8);
  //checkDefaultMaintenancePlans();
</script>
<%=sJSBUTTONS%>
