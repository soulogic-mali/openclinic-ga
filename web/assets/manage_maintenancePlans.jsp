<%@page import="be.openclinic.assets.MaintenancePlan,
               java.text.*,be.openclinic.util.*,be.openclinic.assets.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%@include file="../assets/includes/commonFunctions.jsp"%>
<%=checkPermission(out,"maintenanceplans","select",activeUser)%>

<%=sJSNUMBER%> 
<%=sJSSTRINGFUNCTIONS%>
<%=sJSSORTTABLE%>
<%=sJSEMAIL%>

<%
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n****************** assets/manage_maintenancePlans.jsp *****************");
        Debug.println("no parameters\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    String sAction = checkString(request.getParameter("action"));
    String sEditPlanUID = checkString(request.getParameter("EditPlanUID"));
    String sAssetUID = checkString(request.getParameter("assetUID"));
    String sAssetCode = checkString(request.getParameter("assetCode"));
    String serviceuid = checkString(request.getParameter("serviceuid"));
    String servicename = checkString(request.getParameter("servicename"));
    if(sAssetUID.length()>0 && serviceuid.length()==0){
    	Asset asset = Asset.get(sAssetUID);
    	if(asset!=null){
   			serviceuid=asset.getServiceuid();
   			servicename=getTranNoLink("service",serviceuid,sWebLanguage);
    	}
    }
    
    MaintenancePlan plan = null;
    boolean bLocked=false;

    if(sAction.length()==0){
%>            
		
		<form name="SearchForm" id="SearchForm" method="POST">
			<input type="hidden" name="action" id="action" value=""/>
			<input type="hidden" name="EditPlanUID" id="EditPlanUID" value=""/>
		    <%=writeTableHeader("web.assets","maintenancePlans",sWebLanguage,"")%>
		                
		    <table class="list" border="0" width="100%" cellspacing="1">        
		        <%-- search ASSET --%>    
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","asset",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="hidden" name="searchAssetUID" id="searchAssetUID" value="<%=sAssetUID%>">
		                <input type="text" class="text" id="searchAssetCode" name="searchAssetCode" size="20" readonly value="<%=sAssetCode%>">
		                                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectAsset('searchAssetUID','searchAssetCode');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearAssetSearchFields();">
		                <img src="<c:url value="/_img/icons/icon_view.png"/>" class="link" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewAsset();">
		            </td>
		            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","name",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2" nowrap>
		                <input type="text" class="text" id="searchName" name="searchName" size="40" maxLength="50" value="">
	                	<input type="checkbox" class="text" name="showinactive" id="showinactive"/><%=getTran(request,"web.maintenance","showinactive",sWebLanguage) %>
		            </td>
		        </tr>  
		        
		        <%-- search OPERATOR (person) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web","type",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		            	<select class='text' name='searchType' id='searchType'>
		            		<option/>
		            		<%=ScreenHelper.writeSelect(request, "maintenanceplan.type", "", sWebLanguage) %>
		            	</select>
		            </td>
		            <td class="admin"><%=getTran(request,"web","operator",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="text" class="text" id="searchOperator" name="searchOperator" size="40" maxLength="50" value="">
		            </td>
		        </tr>     
		                    
		        <%-- search BUTTONS --%>
	            <%
	        	serviceuid = checkString(activeUser.getParameter("serviceuid"));
	        	if(serviceuid.length()==0){
	        		serviceuid=checkString((String)session.getAttribute("activeservice"));
	        	}
	            %>
		        <tr>     
		            <td class="admin"><%=getTran(request,"web","service",sWebLanguage)%>&nbsp;</td>
		           	<td class="admin2" nowrap>
		                <input type="hidden" name="serviceuid" id="serviceuid" value="<%=serviceuid%>">
		                <input onblur="if(document.getElementById('serviceuid').value.length==0){this.value='';}" class="text" type="text" name="servicename" id="servicename" size="50" value="<%=getTranNoLink("service",serviceuid,sWebLanguage) %>" >
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"Web","select",sWebLanguage)%>" onclick="searchService('serviceuid','servicename');">
			            <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"Web","delete",sWebLanguage)%>" onclick="document.getElementById('serviceuid').value='';document.getElementById('servicename').value='';document.getElementById('servicename').focus();">
						<div id="autocomplete_service" class="autocomple"></div>
					</td>
		            <td class="admin"/>
		            <td class="admin2">
		                <input class="button" type="button" name="buttonSearch" id="buttonSearch" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="searchMaintenancePlans();">&nbsp;
		                <input class="button" type="button" name="buttonClear" id="buttonClear" value="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
						<%if(activeUser.getAccessRight("maintenanceplans.add")){ %>
		                <input class="button" type="button" name="buttonNew" id="buttonNew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="newPlan();">&nbsp;
						<%} %>
		            </td>
		        </tr>
		    </table>
		</form>
<script>
	new Ajax.Autocompleter('servicename','autocomplete_service','assets/findService.jsp',{
	  minChars:1,
	  method:'post',
	  afterUpdateElement: afterAutoCompleteService,
	  callback: composeCallbackURLService
	});

	function afterAutoCompleteService(field,item){
	  var regex = new RegExp('[-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.]*-idcache','i');
	  var nomimage = regex.exec(item.innerHTML);
	  var id = nomimage[0].replace('-idcache','');
	  document.getElementById("serviceuid").value = id;
	  document.getElementById("servicename").value=item.innerHTML.split("$")[1];
	}
	
	function composeCallbackURLService(field,item){
	  document.getElementById('serviceuid').value
	  var url = "";
	  if(field.id=="servicename"){
		url = "text="+field.value;
	  }
	  return url;
	}

<%
		if(sAssetUID.length()>0){
			out.println("window.setTimeout('searchMaintenancePlans()',500);");
		}
	%>
  SearchForm.searchName.focus();
  function searchService(serviceUidField,serviceNameField){
  	openPopup("/_common/search/searchService.jsp&ts=<%=getTs()%>&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  	document.getElementById(serviceNameField).focus();
    }
	function newPlan(){
		document.getElementById("action").value="new";
		SearchForm.submit();
	}
  <%-- SEARCH MAINTENANCE PLANS --%>
  function searchMaintenancePlans(){
	  if(document.getElementById("serviceuid").value.length==0){
		  alert('<%=getTranNoLink("web","serviceismandatory",sWebLanguage)%>');
		  return;
	  }
	    document.getElementById("divMaintenancePlans").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Searching";            
	    var url = "<c:url value='/assets/ajax/maintenancePlan/getMaintenancePlans.jsp'/>?ts="+new Date().getTime();
	    new Ajax.Request(url,{       
	      method: "GET",
	      parameters: "name="+encodeURIComponent(SearchForm.searchName.value)+
	                  "&assetUID="+encodeURIComponent(SearchForm.searchAssetUID.value)+
	                  "&showinactive="+SearchForm.showinactive.checked+
	                  "&type="+encodeURIComponent(SearchForm.searchType.value)+
	                  "&serviceuid="+encodeURIComponent(SearchForm.serviceuid.value)+
	                  "&operator="+encodeURIComponent(SearchForm.searchOperator.value),
	      onSuccess: function(resp){
	        $("divMaintenancePlans").innerHTML = resp.responseText;
	        sortables_init();
	      },
	      onFailure: function(resp){
	        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/getMaintenancePlans.jsp' : "+resp.responseText.trim();
	      }
	    });
  }

  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    document.getElementById("searchName").value = "";
    clearAssetSearchFields();
    document.getElementById("searchOperator").value = "";
    
    document.getElementById("searchName").focus();
    resizeAllTextareas(8);
  }
  
</script>

<div id="divMaintenancePlans" class="searchResults" style="width:100%;height:360px;"></div>
<%
	}
    if(sAction.equalsIgnoreCase("edit")){
    	plan = MaintenancePlan.get(sEditPlanUID);
    	if(checkString(plan.comment10).length()==0){
    		try{
	    		if(plan.getStartDate().before(plan.getUpdateDateTime())){
	    			plan.setComment10(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(plan.getStartDate()));
	    		}
	    		else{
	    			plan.setComment10(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(plan.getUpdateDateTime()));
	    		}
	    		plan.store(plan.getUpdateUser());
    		}
    		catch(Exception e){
    			e.printStackTrace();
    		}
    	}
    }
    else if(sAction.equalsIgnoreCase("new")){
    	plan = new MaintenancePlan();
    	plan.setUid("-1");
		if(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)>0){
			plan.setLockedBy(MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1));
		}
		else{
			plan.setLockedBy(-1);
		}
    	plan.store(activeUser.userid);
    	sEditPlanUID=plan.getUid();
    	plan.setAssetUID(checkString(request.getParameter("assetUID")));
    	plan.setType(checkString(request.getParameter("type")));
    	plan.setName(checkString(request.getParameter("name")));
    	plan.setStartDate(ScreenHelper.parseDate(request.getParameter("startDate")));
    	plan.setFrequency(ScreenHelper.checkString(request.getParameter("frequency")));
    	plan.setOperator(checkString(request.getParameter("operator")));
    	plan.setPlanManager(checkString(request.getParameter("planManager")));
    	plan.setComment10(new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new java.util.Date()));
    }
    else if(sAction.equalsIgnoreCase("history")){
    	plan = MaintenancePlan.getHistory(sEditPlanUID,SH.parseDate(SH.p(request,"timestamp"), "yyyyMMddHHmmssSSS"));
    }
    if(plan!=null){
		bLocked = plan.getObjectId()>-1 && ((plan.getLockedBy()>-1 && plan.getLockedBy()!=MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)) || (plan.getLockedBy()==-1 && MedwanQuery.getInstance().getConfigInt("GMAOLocalServerId",-1)!=0));
%>

		<form name="EditForm" id="EditForm" method="POST">
		    <input type="hidden" id="action" name="action" value="">
			<input type='hidden' name='lockedby' id='lockedby' value='<%=plan.getLockedBy()%>'/>
		    <input type="hidden" id="EditPlanUID" name="EditPlanUID" value="<%=plan.getUid()%>">
		    <%=writeTableHeaderButton(getTran(request,"web.assets","maintenancePlans",sWebLanguage),!plan.hasHistory()?"":"<img title='"+getTranNoLink("web","history",sWebLanguage)+"' src='"+sCONTEXTPATH+"/_img/icons/icon_history2.gif' onclick='showHistory();'/>&nbsp;")%>
		                
		    <table class="list" border="0" width="100%" cellspacing="1">
		        <%-- name (*) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","asset",sWebLanguage)%>&nbsp;*&nbsp;</td>
		            <td class="admin2">
		                <input type="hidden" name="assetUID" id="assetUID" value="<%=checkString(plan.getAssetUID())%>">
		                <input type="text" class="text" id="assetCode" name="assetCode" size="20" value="<%=checkString(plan.getAssetCode())%>" readonly>
		                
		                <%-- BUTTONS --%>
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" title="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectAsset('assetUID','assetCode');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" title="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="clearAssetFields();">
		                <img src="<c:url value="/_img/icons/icon_view.png"/>" class="link" title="<%=getTranNoLink("web","view",sWebLanguage)%>" onclick="viewAsset();">
		            </td>
		            <td class="admin"><%=getTran(request,"web.assets","type",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		            	<select class='text' name='type' id='type'>
		            		<option/>
		            		<%=ScreenHelper.writeSelect(request, "maintenanceplan.type", checkString(plan.getType()), sWebLanguage) %>
		            	</select>
		            </td>
		        </tr>
		             
		        <%-- startDate --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","nomenclature",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		            	<input type="hidden" name="nomenclaturecode" id="nomenclaturecode" value="<%=checkString(plan.getAssetNomenclature())%>"/>
		            	<input type="text" readonly name="nomenclature" id="nomenclature" size="50" value="<%=checkString(plan.getAssetNomenclature())+" - "+getTranNoLink("admin.nomenclature.asset",plan.getAssetNomenclature(),sWebLanguage) %>"/>
		            </td>
		            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web.assets","planname",sWebLanguage)%>&nbsp;*&nbsp;<img style='vertical-align: middle' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" title="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="viewDefault();"> <img style='vertical-align: middle' height='14px' src="<c:url value="/_img/icons/icon_upload.gif"/>" class="link" title="<%=getTranNoLink("web","adddefaultplan",sWebLanguage)%>" onclick="addDefault();"></td>
		            <td class="admin2">
		                <input type="text" class="text" id="name" name="name" size="50" maxLength="50" value="<%=checkString(plan.getName())%>">
		            </td>
		        </tr>  
		             
		        <%-- startDate --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","startDate",sWebLanguage)%>*&nbsp;</td>
		            <td class="admin2">
		                <%=writeDateField("startDate","EditForm",ScreenHelper.formatDate(plan.getStartDate()),sWebLanguage)%>
		            </td>
		            <td class="admin"><%=getTran(request,"web.assets","frequency",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		            	<select class='text' name='frequency' id='frequency' onchange='checkFrequency()'>
		            		<option/>
		            		<%=ScreenHelper.writeSelect(request, "maintenanceplan.frequency", checkString(plan.getFrequency()), sWebLanguage) %>
		            	</select>
		            </td>
		        </tr>  
		             
		        <%-- endDate --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","endDate",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <%=SH.writeDateField("endDate","EditForm",ScreenHelper.formatDate(plan.getEndDate()),true,true,sWebLanguage,sCONTEXTPATH,"")%>
		            </td>
		            <td class="admin">ID&nbsp;</td>
		            <td class="admin2">
		                <%=plan.getUid()%>
		            </td>
		        </tr>  
		             
		        <%-- operator (person) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","operator",sWebLanguage)%> *&nbsp;</td>
		            <td class="admin2">
		                <input type="text" class="text" id="operator" name="operator" size="50" maxLength="250" value="<%=checkString(plan.getOperator())%>">
		            </td>
		            <td class="admin"><%=getTran(request,"web.assets","planManagerEmail",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2">
		                <input type="text" name="planManager" id="planManager" size="50" maxLength="60" value="<%=checkString(plan.getPlanManager())%>">
		            </td>
		        </tr>  
		       
		        <%-- operator (person) --%>
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","externalsupplier",sWebLanguage)%>&nbsp;</td>
		            <td class="admin2" colspan="3">
		                <input type="text" class="text" id="comment4" name="comment4" size="50" maxLength="50" value="<%=checkString(plan.getComment4())%>">
		            	<!-- Structured field
		                <input type="hidden" name="comment4" id="comment4" value="<%=checkString(plan.getComment4())%>">
		                <%
		                	String supplier="";
		                	if(checkString(plan.getComment4()).length()>0){
			                	Supplier supplier2 = Supplier.get(plan.getComment4());
			                	if(supplier2!=null){
			                		supplier=supplier2.getName();
			                	}
		                	}
		                %>
		                <input type="text" class="text" name="searchSupplierName" id="searchSupplierName" readonly size="60" value="<%=supplier%>">
		                   
		                <%-- buttons --%>
		                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="selectSupplier('comment4','searchSupplierName');">
		                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="EditForm.comment4.value='';EditForm.searchSupplierName.value='';">
	                 -->
		            </td>
		        </tr>  
		       
		        <%-- instructions --%>                
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","instructions",sWebLanguage)%></td>
		            <td class="admin2" colspan="3">
		            	<%
		            		String instructions=checkString(plan.getInstructions());
		            	%>
		                <textarea class="text" name="instructions" id="instructions" cols="120" rows="4" onKeyup="resizeTextarea(this,10);"><%=instructions %></textarea>
		            </td>
		        </tr>                
		        <tr class="admin"><td colspan="4"><%=getTran(request,"web","costs",sWebLanguage) %></td></tr>       
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","transportcost",sWebLanguage)%></td>
		            <td class="admin2">
		                <input type="text" name="comment1" id="comment1" size="10" maxLength="10" value="<%=checkString(plan.getComment1())%>"  onKeyUp="isNumber(this);calculateCosts();" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>
		            </td>
		            <td class="admin"><%=getTran(request,"web.assets","consumables",sWebLanguage)%></td>
		            <td class="admin2">
		                <input type="text" name="comment2" id="comment2" size="10" maxLength="10" value="<%=checkString(plan.getComment2())%>"  onKeyUp="isNumber(this);calculateCosts();" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>
		            </td>
		        </tr>                
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","externalfee",sWebLanguage)%></td>
		            <td class="admin2">
		                <input type="text" name="comment5" id="comment5" size="10" maxLength="10" value="<%=checkString(plan.getComment5())%>"  onKeyUp="isNumber(this);calculateCosts();" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>
		            </td>
		            <td class="admin"><%=getTran(request,"web.assets","other",sWebLanguage)%></td>
		            <td class="admin2">
		                <input type="text" name="comment3" id="comment3" size="10" maxLength="10" value="<%=checkString(plan.getComment3())%>"  onKeyUp="isNumber(this);calculateCosts();" onBlur="if(isNumber(this))setDecimalLength(this,2,true);"> <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>
		            </td>
		        </tr>     
		        <tr>
		            <td class="admin"><%=getTran(request,"web.assets","total",sWebLanguage)%></td>
		            <td class="admin2" colspan="3">
		                <b><span id='totalcost'></span></b>
		            </td>
		        </tr>
		        <script>
		        	function calculateCosts(){
		        		document.getElementById("totalcost").innerHTML=(document.getElementById("comment1").value*1+document.getElementById("comment2").value*1+document.getElementById("comment3").value*1+document.getElementById("comment5").value*1)+' <%=MedwanQuery.getInstance().getConfigString("currency","EUR")%>';
		        	}
		        	calculateCosts();
		        </script>
		        <tr>
			        <%-- DOCUMENTS (multi-add) --%>   
		            <td class="admin" nowrap>
		            	<%=getTran(request,"web.assets","documents",sWebLanguage)%>&nbsp;
						<%if(!bLocked && activeUser.getAccessRight("assets.edit")){ %>
			            	<img src='<%=sCONTEXTPATH %>/_img/icons/icon_add.gif' onclick="addDocument('<%=plan.getUid()%>')"/>
			            <%} %>
		            </td>
		            <td class="admin2" colspan="2">
		            	<div id='documentsDiv'></div>
		            </td>
		            <td class="admin2">
		            	<div id='documentsLoaderDiv'></div>
		            </td>
		        </tr>        
		            
		        <tr>
		            <td class="admin" nowrap>
		            	<%=getTran(request,"web","lastmodificationby",sWebLanguage)%>&nbsp;
		            </td>
		            <td class="admin2" colspan="3">
		            	<b><%=User.getFullUserName(plan.getUpdateUser()) %> (<%=ScreenHelper.formatDate(plan.getUpdateDateTime(), ScreenHelper.fullDateFormat) %>)</b>
		            </td>
		        </tr>        
		        <tr>
		            <td class="admin" nowrap>
		            	<%=getTran(request,"web","created",sWebLanguage)%>&nbsp;
		            </td>
		            <td class="admin2" colspan="3">
		            	<b><%= plan.getComment10() %></b>
		            	<input type='hidden' name='comment10' id='comment10' value='<%= plan.getComment10() %>'/>
		            </td>
		        </tr>        
		        <%-- BUTTONS --%>
		        <tr>     
		            <td class="admin"/>
		            <td class="admin2" colspan="3">
		            	<%if(!sAction.equalsIgnoreCase("history") && !SH.p(request,"readonly").equalsIgnoreCase("true")){ %>
						<%if(!bLocked && activeUser.getAccessRight("maintenanceplans.edit")){ %>
		                <input class="button" type="button" name="buttonSave" id="buttonSave" value="<%=getTranNoLink("web","save",sWebLanguage)%>" onclick="saveMaintenancePlan();">&nbsp;
						<%} %>
						<%if(!bLocked && activeUser.getAccessRight("maintenanceplans.delete")){ %>
		                <input class="button" type="button" name="buttonDelete" id="buttonDelete" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onclick="deleteMaintenancePlan();">&nbsp;
						<%} %>
		                <input class="button" type="button" name="buttonOperations" id="buttonOperations" value="<%=getTranNoLink("web","operations",sWebLanguage)%>" onclick="showOperations();">&nbsp;
		                <input class="button" type="button" name="buttonList" id="buttonList" value="<%=getTranNoLink("web","list",sWebLanguage)%>" onclick="showList();">&nbsp;
		                <input class="button" type="button" name="buttonDocuments" id="buttonDocuments" value="<%=getTranNoLink("web","documents",sWebLanguage)%>" onclick="printWordDocuments();">&nbsp;
						<%
							if(activeUser.getAccessRight("assets.defaultmaintenanceplans.add")){
						%>
		                <input class="button" type="button" name="buttonAddDefault" id="buttonAddDefault" value="<%=getTranNoLink("web","adddefaultplan",sWebLanguage)%>" onclick="addDefault();">&nbsp;
						<%
							}
							if(activeUser.getAccessRight("assets.defaultmaintenanceplans.select")){
						%>
		                <input class="button" type="button" name="buttonViewDefault" id="buttonViewDefault" value="<%=getTranNoLink("web","loaddefaultplan",sWebLanguage)%>" onclick="viewDefault();">&nbsp;
						<%
							}
            			}
						%>
		            </td>
		        </tr>
		    </table>
		    <i><%=getTran(request,"web","colored_fields_are_obligate",sWebLanguage)%></i>
		    
		    <%if(sAction.equalsIgnoreCase("history")|| SH.p(request,"readonly").equalsIgnoreCase("true")){%>
		    	<center><input class="button" type="button" name="buttonClose" id="buttonClose" value="<%=getTranNoLink("web","close",sWebLanguage)%>" onclick="window.close();"></center>
			<%}%>
		
		    <div id="divMessage" style="padding-top:10px;"></div>
		</form>

<%
		session.setAttribute("activeAsset", plan.getAsset());
		session.setAttribute("activeMaintenancePlan", plan);
    }
%>
<script>
	function checkFrequency(){
		if(document.getElementById("frequency").value.length>0){
			document.getElementById("endDate").setAttribute("readonly", true);
			document.getElementById("endDate").style.backgroundColor='lightgrey';
		}
		else{
			document.getElementById("endDate").removeAttribute("readonly");
			document.getElementById("endDate").style.backgroundColor='white';
		}
	}
	function addDocument(uid){
  		openPopup("/assets/addDocument.jsp&ts=<%=getTs()%>&PopupHeight=200&PopupWidth=500&maintenanceplanuid="+uid);
  	}
	
	<%-- LOAD (all) ASSETS --%>
	function loadDocuments(){
	    document.getElementById("documentsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";
	  
	    var url = "<c:url value='/assets/ajax/asset/getDocuments.jsp'/>?ts="+new Date().getTime();
	    new Ajax.Request(url,{
	    	method: "GET",
	    	parameters: "maintenanceplanuid="+document.getElementById("EditPlanUID").value,
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
	
	function viewDefault(){
  		openPopup("/assets/viewDefaultManagementPlans.jsp&ts=<%=getTs()%>&PopupHeight=200&PopupWidth=500&assetUID="+encodeURI(EditForm.assetUID.value));
	}
	
	function addDefault(){
		if(document.getElementById('assetUID').value==''){
			alert('<%=getTranNoLink("web","assetnotspecified",sWebLanguage)%>');
		}
		else if(window.confirm('<%=getTranNoLink("web","areyousure",sWebLanguage)%>')){
			var name = window.prompt("<%=getTranNoLink("web","name",sWebLanguage)%>",document.getElementById('name').value);
			if(name.length>0){
		        var sParams = "EditPlanUID="+document.getElementById('EditPlanUID').value+
	            "&name="+name+
	            "&assetUID="+document.getElementById('assetUID').value+
	            "&startDate="+document.getElementById('startDate').value+
	            "&endDate="+document.getElementById('endDate').value+
	            "&frequency="+document.getElementById('frequency').value+
	            "&operator="+document.getElementById('operator').value+
	            "&planManager="+document.getElementById('planManager').value+
	            "&type="+document.getElementById('type').value+
	            "&nomenclaturecode="+document.getElementById('nomenclaturecode').value+
	            "&comment1="+document.getElementById('comment1').value+
	            "&comment2="+document.getElementById('comment2').value+
	            "&comment3="+document.getElementById('comment3').value+
	            "&comment4="+document.getElementById('comment4').value+
	            "&comment5="+document.getElementById('comment5').value+
	            /*
	            "&comment6="+EditForm.comment6.value+
	            "&comment7="+EditForm.comment7.value+
	            "&comment8="+EditForm.comment8.value+
	            "&comment9="+EditForm.comment9.value+
	            */
	            "&comment10="+EditForm.comment10.value+
	            "&instructions="+document.getElementById('instructions').value.replace(new RegExp("'", 'g'), '´').replace(new RegExp('"', 'g'), '´');
			    var url = "<c:url value='/assets/ajax/maintenancePlan/addDefault.jsp'/>?ts="+new Date().getTime();
			    new Ajax.Request(url,{
			      method: "POST",
			      parameters: sParams,
			      onSuccess: function(resp){
			    	  if(resp.responseText.indexOf("OK-200")>0){
			        	  viewDefault();
			    	  }
			    	  else if(resp.responseText.indexOf("NOK-300")>0){
			    		  alert('NOK-300 <%=getTranNoLink("web","nomenclaturenotspecified",sWebLanguage)%>');
			    	  }
			    	  else if(resp.responseText.indexOf("NOK-400")>0){
			    		  alert('NOK-400 <%=getTranNoLink("web","maintenanceplanalreadyexists",sWebLanguage)%>');
			        	  viewDefault();
			    	  }
			      },
			    });
			}
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
	
	function showDocument(url){
		openPopup(url);
	}  

	function selectSupplier(uidField,nameField){
    var url = "/_common/search/searchSupplier.jsp&ts=<%=getTs()%>&PopupWidth=500&PopupHeight=400"+
              "&ReturnFieldUid="+uidField+
              "&ReturnFieldName="+nameField;
    openPopup(url);
    document.getElementById(nameField).focus();
  }
	function viewAsset(){
		if(document.getElementById("assetUID") && document.getElementById("assetUID").value.length>0){
			window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&action=edit&EditAssetUID="/>'+document.getElementById("assetUID").value;
		}
		else if(document.getElementById("searchAssetUID") && document.getElementById("searchAssetUID").value.length>0){
			window.location.href='<c:url value="/main.do?Page=assets/manage_assets.jsp&action=edit&EditAssetUID="/>'+document.getElementById("searchAssetUID").value;
		}
	}
  function showOperations(){
	  this.location.href='<c:url value="main.do?Page=assets/manage_maintenanceOperations.jsp"/>&ts=<%=getTs()%>&PlanUID='+document.getElementById('EditPlanUID').value;
  }
  function showList(){
	  this.location.href='<c:url value="main.do?Page=assets/manage_maintenancePlans.jsp"/>&ts=<%=getTs()%>&assetUID='+document.getElementById('assetUID').value+'&assetCode='+document.getElementById('assetCode').value;
  }
  <%-- SAVE MAINTENANCE PLAN --%>
  function saveMaintenancePlan(){
    var okToSubmit = true;
    
    <%-- check required fields --%>
    if(requiredFieldsProvided()){
      <%-- check email (planManager) --%>
      if(okToSubmit==true){
        if(EditForm.planManager.value.length > 0){
          if(!validEmailAddress(EditForm.planManager.value)){
            okToSubmit = false;            
            alertDialog("Web","invalidemailaddress");
            EditForm.planManager.focus();
          }
        }
      }
    
      if(okToSubmit==true){
        document.getElementById("divMessage").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Saving";  
        disableButtons();
        
        var sParams = "EditPlanUID="+EditForm.EditPlanUID.value+
                      "&name="+EditForm.name.value+
                      "&assetUID="+EditForm.assetUID.value+
                      "&startDate="+EditForm.startDate.value+
                      "&endDate="+EditForm.endDate.value+
                      "&frequency="+EditForm.frequency.value+
                      "&operator="+EditForm.operator.value+
                      "&planManager="+EditForm.planManager.value+
                      "&type="+EditForm.type.value+
                      "&comment1="+EditForm.comment1.value+
                      "&comment2="+EditForm.comment2.value+
                      "&comment3="+EditForm.comment3.value+
                      "&comment4="+EditForm.comment4.value+
                      "&comment5="+EditForm.comment5.value+
                      /*
                      "&comment6="+EditForm.comment6.value+
                      "&comment7="+EditForm.comment7.value+
                      "&comment8="+EditForm.comment8.value+
                      "&comment9="+EditForm.comment9.value+
                      */
                      "&comment10="+EditForm.comment10.value+
                      "&lockedby="+document.getElementById("lockedby").value+
                      "&instructions="+EditForm.instructions.value;

        var url = "<c:url value='/assets/ajax/maintenancePlan/saveMaintenancePlan.jsp'/>?ts="+new Date().getTime();
        new Ajax.Request(url,{
          method: "POST",
          postBody: sParams,                   
          onSuccess: function(resp){
            var data = eval("("+resp.responseText+")");
            $("divMessage").innerHTML = data.message;
            var assetuid = document.getElementById("assetUID").value;
            var assetcode = document.getElementById("assetCode").value;
            newMaintenancePlan();
            document.getElementById("assetUID").value=assetuid;
            document.getElementById("assetCode").value=assetcode;
            EditForm.submit();
          },
          onFailure: function(resp){
            $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/saveMaintenancePlan.jsp' : "+resp.responseText.trim();
          }
        });
      }
    }
    else{
      alertDialog("web.manage","dataMissing");
      
      <%-- focus empty field --%>
           if(document.getElementById("name").value.length==0)      document.getElementById("name").focus();    
           else if(document.getElementById("operator").value.length==0) document.getElementById("operator").focus();          
           else if(document.getElementById("assetCode").value.length==0) document.getElementById("assetCode").focus();          
    }
  }
  
  function showHistory(){
	  openPopup("assets/showHistory.jsp&type=maintenanceplan&uid=<%=plan==null?"":plan.getUid()%>",800,500);
  }

  <%-- REQUIRED FIELDS PROVIDED --%>
  function requiredFieldsProvided(){
	  if(document.getElementById("startDate").value.length == 0 ){
		  document.getElementById("startDate").focus();
		  return false;
	  }
	  else if(document.getElementById("name").value.length == 0 ){
		  document.getElementById("name").focus();
		  return false;
	  }
	  else if(document.getElementById("operator").value.length == 0 ){
		  document.getElementById("operator").focus();
		  return false;
	  }
	  else if(document.getElementById("assetCode").value.length == 0 ){
		  document.getElementById("assetCode").focus();
		  return false;
	  }
    return true;
  }
  
  <%-- LOAD MAINTENANCEPLANS --%>
  function loadMaintenancePlans(){
    document.getElementById("divMaintenancePlans").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/><br>Loading..";            
    var url = "<c:url value='/assets/ajax/maintenancePlan/getMaintenancePlans.jsp'/>?ts="+new Date().getTime();
    new Ajax.Request(url,{
      method: "GET",
      parameters: "",
      onSuccess: function(resp){
        $("divMaintenancePlans").innerHTML = resp.responseText;
        sortables_init();
      },
      onFailure: function(resp){
        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/getMaintenancePlans.jsp' : "+resp.responseText.trim();
      }
    });
  }

  <%-- LOAD MAINTENANCEPLANS --%>
  function loadDefaultMaintenancePlan(uid){
	    var url = "<c:url value='/assets/ajax/maintenancePlan/loadDefaultMaintenancePlan.jsp'/>?ts="+new Date().getTime();
	    new Ajax.Request(url,{
	      method: "GET",
	      parameters: "uid="+uid,
	      onSuccess: function(resp){
	          var data = eval("("+resp.responseText+")");
	          EditForm.name.value=data.name;
              EditForm.frequency.value=data.frequency;
              EditForm.operator.value=data.operator;
              EditForm.planManager.value=data.planmanager;
              EditForm.type.value=data.type;
              EditForm.comment1.value=data.comment1;
              EditForm.comment2.value=data.comment2;
              EditForm.comment3.value=data.comment3;
              EditForm.comment4.value=data.comment4;
              EditForm.comment5.value=data.comment5;
              /*
              "&comment6="+EditForm.comment6.value+
              "&comment7="+EditForm.comment7.value+
              "&comment8="+EditForm.comment8.value+
              "&comment9="+EditForm.comment9.value+
              "&comment10="+EditForm.comment10.value+
              */
              EditForm.instructions.value=data.instructions.replace(new RegExp('<br>', 'g'), '\n');
              resizeTextarea(EditForm.instructions,10);
	      },
	      onFailure: function(resp){
	        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/loadDefaultMaintenancePlan.jsp' : "+resp.responseText.trim();
	      }
	    });
  	}
  <%-- LOAD MAINTENANCEPLANS --%>
  function loadNomenclature(){
		if(document.getElementById("nomenclaturecode") && document.getElementById("assetUID").value.length>0){
		    var url = "<c:url value='/assets/ajax/maintenancePlan/loadNomenclature.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		      method: "GET",
		      parameters: "assetuid="+document.getElementById("assetUID").value,
		      onSuccess: function(resp){
		          var data = eval("("+resp.responseText+")");
		          $("nomenclaturecode").value = data.nomenclaturecode;
		          $("nomenclature").value = unhtmlEntities(data.nomenclaturecode+" - "+data.nomenclature);
		      },
		      onFailure: function(resp){
		        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/loadNomenclature.jsp' : "+resp.responseText.trim();
		      }
		    });
		}
		else if(document.getElementById("searchAssetUID") && document.getElementById("searchAssetUID").value.length>0){
		    var url = "<c:url value='/assets/ajax/maintenancePlan/loadService.jsp'/>?ts="+new Date().getTime();
		    new Ajax.Request(url,{
		      method: "GET",
		      parameters: "assetuid="+document.getElementById("searchAssetUID").value,
		      onSuccess: function(resp){
		          var data = eval("("+resp.responseText+")");
		          $("serviceuid").value = data.serviceuid;
		          $("servicename").value = data.servicename;
		      },
		      onFailure: function(resp){
		        $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/loadNomenclature.jsp' : "+resp.responseText.trim();
		      }
		    });
		}
		
  	}
  <%-- DISPLAY MAINTENANCEPLAN --%>
  function displayMaintenancePlan(planUID){
	  document.getElementById("EditPlanUID").value=planUID;
	  document.getElementById("action").value="edit";
	  SearchForm.submit();
  }
  
  <%-- DELETE MAINTENACEPLAN --%>
  function deleteMaintenancePlan(){
      if(yesnoDeleteDialog()){
      disableButtons();
      
      var url = "<c:url value='/assets/ajax/maintenancePlan/deleteMaintenancePlan.jsp'/>?ts="+new Date().getTime();
      new Ajax.Request(url,{
        method: "GET",
        parameters: "PlanUID="+document.getElementById("EditPlanUID").value,
        onSuccess: function(resp){
          var data = eval("("+resp.responseText+")");
          $("divMessage").innerHTML = data.message;

          newMaintenancePlan();
          //loadMaintenancePlan();
          searchMaintenancePlans();
          enableButtons();
        },
        onFailure: function(resp){
          $("divMessage").innerHTML = "Error in 'assets/ajax/maintenancePlan/deleteMaintenancePlan.jsp' : "+resp.responseText.trim();
        }  
      });
    }
  }

  <%-- NEW MAINTENANCEPLAN --%>
  function newMaintenancePlan(){                   
    <%-- hide irrelevant buttons --%>
    if(document.getElementById("buttonDelete")) document.getElementById("buttonDelete").style.visibility = "hidden";
    if(document.getElementById("buttonOperations")) document.getElementById("buttonOperations").style.visibility = "hidden";
    if(document.getElementById("buttonNew")) document.getElementById("buttonNew").style.visibility = "hidden";
    
    $("EditPlanUID").value = "-1";  
    $("name").value = "";
    $("assetUID").value = "";
    $("assetCode").value = "";
    $("startDate").value = "";
    $("frequency").value = "";
    $("operator").value = "";
    $("planManager").value = "";
    $("instructions").value = "";  
    
    $("name").focus();
    resizeAllTextareas(8);
  }
  
  <%-- DISABLE BUTTONS --%>
  function disableButtons(){
    if (document.getElementById("buttonSave")) document.getElementById("buttonSave").disabled = true;
    if (document.getElementById("buttonDelete")) document.getElementById("buttonDelete").disabled = true;
    if (document.getElementById("buttonOperations")) document.getElementById("buttonOperations").disabled = true;
    if (document.getElementById("buttonNew")) document.getElementById("buttonNew").disabled = true;
  }
  
  <%-- ENABLE BUTTONS --%>
  function enableButtons(){
	  if (document.getElementById("buttonSave")) document.getElementById("buttonSave").disabled = false;
	  if (document.getElementById("buttonDelete")) document.getElementById("buttonDelete").disabled = false;
	  if (document.getElementById("buttonOperations")) document.getElementById("buttonOperations").disabled = false;
	  if (document.getElementById("buttonNew")) document.getElementById("buttonNew").disabled = false;
  }

  <%-- CLEAR ASSET SEARCHFIELDS --%>
  function clearAssetSearchFields(){
    $("searchAssetUID").value = "";
    $("searchAssetCode").value = "";
    
    $("searchAssetCode").focus();
  }
  <%-- SELECT ASSET --%>
  function selectAsset(uidField,codeField){
    var url = "/_common/search/searchAsset.jsp&ts=<%=getTs()%>&PopupWidth=600&PopupHeight=500"+
			  "&doFunction=loadNomenclature()"+
			  "&ReturnFieldUid="+uidField+
              "&ReturnFieldCode="+codeField;
    openPopup(url);
    document.getElementById(codeField).focus();
  }  
  
  <%-- CLEAR ASSET FIELDS --%>
  function clearAssetFields(){
    $("assetUID").value = "";
    $("assetCode").value = "";
    
    $("assetCode").focus();
  }
	window.setTimeout("loadDocuments();",500);
          
  //EditForm.code.focus();
  //loadMaintenancePlan();
  resizeAllTextareas(8);
  checkFrequency();
</script>
<%=sJSBUTTONS%>
