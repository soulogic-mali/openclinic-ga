<%@page import="be.openclinic.adt.Bed,
                java.util.Vector"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"adt.managebeds","all",activeUser)%>
<%=sJSSORTTABLE%>

<%!
    //--- BED EXISTS IN SERVICE -------------------------------------------------------------------
    // bed with same name exists in specified service
    public boolean bedExistsInService(String sBedName, String sBedService){
	    boolean bedExistsInService = false;
	    Vector vBeds = null;

        try{
            vBeds = Bed.selectBeds("","",sBedName,sBedService,"","","");

            Iterator bedIter = vBeds.iterator();
            Bed tmpBed;

            while(bedIter.hasNext()){
                tmpBed = (Bed)bedIter.next();
                
                if(tmpBed.getName().equalsIgnoreCase(sBedName)){
                	bedExistsInService = true;
                    break;
                }
            }
        } 
        catch(Exception e){
            e.printStackTrace();
        }	    
	    
	    return bedExistsInService; 
    }
%>

<%
    String sAction = checkString(request.getParameter("Action"));

    // Find Params
    String sFindBedName        = checkString(request.getParameter("FindBedName")),
           sFindBedService     = checkString(request.getParameter("FindBedService")),
           sFindBedServiceName = checkString(request.getParameter("FindBedServiceName"));

    // Edit Params
    String sEditUID        = checkString(request.getParameter("EditUID")),
	       sEditName       = checkString(request.getParameter("EditName")),
	       sEditBedService = checkString(request.getParameter("EditBedService")),
	       sEditPriority   = checkString(request.getParameter("EditPriority")),
	       sEditLocation   = checkString(request.getParameter("EditLocation")),
	       sEditComment    = checkString(request.getParameter("EditComment"));

    String sEditBedServiceName = checkString(request.getParameter("EditBedServiceName"));
    
    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
        Debug.println("\n************************* system/manageBeds.jsp ***********************");
        Debug.println("sAction             : "+sAction);
        Debug.println("sFindBedName        : "+sFindBedName);
        Debug.println("sFindBedService     : "+sFindBedService);
        Debug.println("sFindBedServiceName : "+sFindBedServiceName+"\n");
       
        Debug.println("sEditUID            : "+sEditUID);
        Debug.println("sEditName           : "+sEditName);
        Debug.println("sEditBedService     : "+sEditBedService);
        Debug.println("sEditBedServiceName : "+sEditBedServiceName);
        Debug.println("sEditPriority       : "+sEditPriority);
        Debug.println("sEditLocation       : "+sEditLocation);
        Debug.println("sEditComment        : "+sEditComment+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////

    
    String sMsg = "";

    //*** SAVE ************************************************************************************
    if(sAction.equals("SAVE")){
    	boolean bedExists = false;
    	
           Bed tmpBed = new Bed();
        if(sEditUID.length() > 0 ){
            tmpBed = Bed.get(sEditUID);
        }
        else{   	
        	if(bedExistsInService(sEditName,sEditBedService)){
                sMsg = "<font color='red'>"+getTran(request,"web","bedAllreadyExistsInService",sWebLanguage)+"</font>";
                bedExists = true;
        	}
        	else{
                tmpBed.setCreateDateTime(ScreenHelper.getSQLDate(getDate()));
        	}
        }
        
        if(!bedExists){
	        tmpBed.setName(sEditName);
	        
	        Service tmpService = Service.getService(sEditBedService);
	        if(tmpService==null){
	        	tmpService = new Service();
	        }
	        tmpBed.setService(tmpService);
	        
	        int priority = 1;
	        try{
	            priority = Integer.parseInt(sEditPriority);
	        }
	        catch(Exception e){
	        	// empty
	        }
	        
	        tmpBed.setPriority(priority);
	        tmpBed.setLocation(sEditLocation);
	        tmpBed.setComment(sEditComment);
	        tmpBed.setUpdateDateTime(ScreenHelper.getSQLDate(getDate()));
	        tmpBed.setUpdateUser(activeUser.userid);
	        tmpBed.store();
	        
	        sEditUID = tmpBed.getUid();
	        sMsg = "<font color='green'>"+getTran(request,"web","dataIsSaved",sWebLanguage)+"</font>";
    	}
    }
    //*** DELETE **********************************************************************************
    if(sAction.equals("DELETE")){
        if(sEditUID.length() > 0 ){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        	PreparedStatement ps = conn.prepareStatement("delete from OC_BEDS where OC_BED_SERVERID=? and OC_BED_OBJECTID=?");
        	
        	ps.setInt(1,Integer.parseInt(sEditUID.split("\\.")[0]));
        	ps.setInt(2,Integer.parseInt(sEditUID.split("\\.")[1]));
        	ps.execute();
        	
        	ps.close();
        	conn.close();
        }
        
        sEditUID = "";
        sMsg = "<font color='green'>"+getTran(request,"web","dataIsDeleted",sWebLanguage)+"</font>";
    }
    
    if(sEditUID.length() > 0){
        Bed tmpBed = Bed.get(sEditUID);
        
        sEditUID            = tmpBed.getUid();
        sEditName           = tmpBed.getName();
        sEditPriority       = Integer.toString(tmpBed.getPriority());
        sEditLocation       = tmpBed.getLocation();
        sEditComment        = tmpBed.getComment();
        sEditBedService     = tmpBed.getService().code;
        sEditBedServiceName = getTran(request,"Service",sEditBedService,sWebLanguage);
    }

    //--- SEARCH ----------------------------------------------------------------------------------
    if(sAction.equals("SEARCH") || sAction.equals("") || sAction.equals("DELETE")){
%>

<%-- 1 : SEARCH FORM --%>
<form name="FindBedForm" method="POST" action='<c:url value="/main.do"/>?Page=system/manageBeds.jsp&ts=<%=getTs()%>'>
    <input type="hidden" name="Action" value="">
    
    <%=writeTableHeader("web","manageBeds",sWebLanguage," doBack();")%>    
    <table class="list" width="100%" cellspacing="1" onKeyDown="if(enterEvent(event,13)){doFind();return false;}else{return true;}">
        <%-- service --%>
        <tr>
            <td class="admin2" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","service",sWebLanguage)%></td>
            <td class="admin2">
                <input type="hidden" name="FindBedService" value="<%=sFindBedService%>">
                <input class="text" type="text" name="FindBedServiceName" readonly size="<%=sTextWidth%>" value="<%=sFindBedServiceName%>">
                
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("web","select",sWebLanguage)%>" onclick="searchService('FindBedService','FindBedServiceName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("web","clear",sWebLanguage)%>" onclick="FindBedForm.FindBedService.value='';FindBedForm.FindBedServiceName.value='';">
            </td>
        </tr>
        
        <%-- name --%>
        <tr>
            <td class="admin2"><%=getTran(request,"web","name",sWebLanguage)%></td>
            <td class="admin2"><input class="text" name="FindBedName" value="<%=sFindBedName%>" size="<%=sTextWidth%>"></td>
        </tr>
        
        <%-- buttons --%>
        <tr>
            <td class="admin2">&nbsp;</td>
            <td class="admin2">
                <input class="button" type="button" name="buttonfind" value="<%=getTranNoLink("web","search",sWebLanguage)%>" onclick="doFind();">&nbsp;
                <input class="button" type="button" name="buttonclear" value="<%=getTranNoLink("web","Clear",sWebLanguage)%>" onclick="clearSearchFields();">&nbsp;
                <input class="button" type="button" name="buttonnew" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="doNew();">&nbsp;
                <input class="button" type="button" name="Backbutton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBack();">
            </td>
        </tr>
    </table>

	<%
	    if(sMsg.length() > 0){
	        %><%=sMsg%><%
	    }
	%>
</form>

<%
}
    
    //--- EDIT ------------------------------------------------------------------------------------
    if(sAction.equals("NEW") || sAction.equals("SELECT") || sAction.equals("SAVE")){
        if(sEditBedService.length()==0) sEditBedService = sFindBedService;
        if(sEditBedServiceName.length()==0) sEditBedServiceName = sFindBedServiceName;
        if(sEditName.length()==0) sEditName = sFindBedName;    	

        Debug.println("--> sEditBedService     : "+sEditBedService);
        Debug.println("--> sEditBedServiceName : "+sEditBedServiceName);
        Debug.println("--> sEditName           : "+sEditName);
    
%>
<%-- 2 : EDIT FORM --%>
<form name="EditBedForm" method="POST" action='<c:url value="/main.do"/>?Page=system/manageBeds.jsp&ts=<%=getTs()%>'>
    <%=writeTableHeader("web","manageBeds",sWebLanguage," doBack();")%>
    
    <table class="list" width="100%" cellspacing="1">
        <%-- service --%>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","service",sWebLanguage)%> *</td>
            <td class="admin2">
                <input type="hidden" name="EditBedService" value="<%=sEditBedService%>">
                <input class="text" type="text" name="EditBedServiceName" readonly size="<%=sTextWidth%>" value="<%=sEditBedServiceName%>">
               
                <img src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTranNoLink("Web","select",sWebLanguage)%>" onclick="searchService('EditBedService','EditBedServiceName');">
                <img src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTranNoLink("Web","clear",sWebLanguage)%>" onclick="EditBedForm.EditBedService.value='';EditBedForm.EditBedServiceName.value='';">
            </td>
        </tr>
        
        <%-- name --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","name",sWebLanguage)%> *</td>
            <td class="admin2"><input class="text" type="text" name="EditName" value="<%=sEditName%>" size="<%=sTextWidth%>"></td>
        </tr>

        <%-- priority --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","priority",sWebLanguage)%></td>
            <td class="admin2"><input class="text" type="text" name="EditPriority" value="<%=sEditPriority%>" size="2"></td>
        </tr>
        
        <%-- location --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","location",sWebLanguage)%></td>
            <td class="admin2">
                <input class="text" type="text" name="EditLocation" value="<%=sEditLocation%>" size="<%=sTextWidth%>">
               
                <%
                    String sExtension = ""; 
	                if(sEditLocation.length() > 0){
	                	if(sEditLocation.indexOf(".") > -1){
	                        sExtension = sEditLocation.substring(sEditLocation.indexOf(".")+1).toLowerCase();
		                    
		                    // icon to open location-document
		                    if(MedwanQuery.getInstance().getConfigString("image_extensions","gif,jpg,bmp").toLowerCase().indexOf(sExtension)>-1){
		                        %>
		                            <div style="padding-top:5px"></div>
		                            <img src="<%=MedwanQuery.getInstance().getConfigString("documentsdir","adt/documents/")+"/"+sEditLocation%>" class="link" onclick="openLocationFile();" alt="<%=getTranNoLink("web","view",sWebLanguage)%>" width="<%=MedwanQuery.getInstance().getConfigString("adt.bed.imagewidth","250")%>">
		                        <%
		                    }
	                	}
	                }
                %>
            </td>
        </tr>
        
        <%-- comment --%>
        <tr>
            <td class="admin"><%=getTran(request,"web","comment",sWebLanguage)%></td>
            <td class="admin2"><%=writeTextarea("EditComment","","","",sEditComment)%></td>
        </tr>
        
        <input type="hidden" name="Action" value="">
        <input type="hidden" name="EditUID" value="<%=sEditUID%>">
        
        <%-- buttons --%>
        <%=ScreenHelper.setFormButtonsStart()%>
            <input class="button" type="button" name="saveButton" value="<%=getTranNoLink("web","save",sWebLanguage)%>" onclick="doSave();">&nbsp;
            <input class="button" type="button" name="Backbutton" value="<%=getTranNoLink("web","back",sWebLanguage)%>" onclick="doBackToSearch();">
            
            <%
                if(!sAction.equals("NEW")){
                    %>
                        <input class="button" type="button" name="newButton" value="<%=getTranNoLink("web","new",sWebLanguage)%>" onclick="doNewBed();">
                        <input class="button" type="button" name="deleteButton" value="<%=getTranNoLink("web","delete",sWebLanguage)%>" onclick="doDeleteBed('<%=sEditUID%>');">
                    <%
                }
            %>
        <%=ScreenHelper.setFormButtonsStop()%>
    </table>

	<%
	    if(sMsg.length() > 0){
	        %><%=sMsg%><%
	    }
	%>
</form>

<%-- 3 : UPLOAD FORM --%>
<form name="uploadForm" target="_newForm" action="<c:url value='/adt/storeDocument.jsp'/>" method="post" enctype="multipart/form-data">
    <%=writeTableHeader("web","location",sWebLanguage," doBack();")%>
    
    <table class="list" width="100%" cellspacing="1">
        <input name="ReturnField" value="EditLocation" type="hidden"/>
        <tr>
            <td class="admin" width="<%=sTDAdminWidth%>">
                <%=getTran(request,"web","doc_upload",sWebLanguage)%>
                <br>
            </td>
            <td class="admin2">
                <input class='text' name="filename" type="file" title="" size='<%=sTextWidth%>'/>
                &nbsp;&nbsp;<input class='button' name="sendimage" type="submit" value="<%=getTranNoLink("web","upload_file",sWebLanguage)%>">
            </td>
        </tr>
    </table>
    
    <%=getTran(request,"Web","colored_fields_are_obligate",sWebLanguage)%>
</form>

<%-- 4 : BACK TO SEARCH FORM --%>
<form name="BackToSearchForm" method="POST" action='<c:url value="/main.do"/>?Page=system/manageBeds.jsp&ts=<%=getTs()%>'>
    <input type="hidden" name="Action" value="SEARCH"/>
    
    <input type="hidden" name="FindBedService" value="<%=sEditBedService%>"/>
    <input type="hidden" name="FindBedServiceName" value="<%=sEditBedServiceName%>"/>
    <input type="hidden" name="FindBedName" value="<%=sEditName%>"/>
</form>
<%
    }
%>

<div id="bedsDiv"><%-- Ajax --%></div>

<%-- 5 : DELETE BED FORM --%>
<form name="DeleteBedForm" method="POST" action='<c:url value="/main.do"/>?Page=system/manageBeds.jsp&ts=<%=getTs()%>'>
    <input type="hidden" name="Action" value="DELETE"/>    
    <input type="hidden" name="EditUID" value=""/>
    
    <input type="hidden" name="FindBedService" value="<%=sFindBedService%>"/>
    <input type="hidden" name="FindBedServiceName" value="<%=sFindBedServiceName%>"/>
    <input type="hidden" name="FindBedName" value="<%=sFindBedName%>"/>
</form>

<script>
  <%-- SEARCH BEDS --%>
  function searchBeds(bedName,serviceId){
	enableButtons(false);
    $("bedsDiv").innerHTML = "<img src='<%=sCONTEXTPATH%>/_img/themes/<%=sUserTheme%>/ajax-loader.gif'/>&nbsp;Loading..";
	  
    var url = "<c:url value='/system/ajax/searchBeds.jsp'/>?ts="+new Date().getTime();
    var params = "FindBedName="+replaceAll(bedName,"%","[pct]")+
                 "&FindBedService="+serviceId+
                 "&EditUID=<%=sEditUID%>";
    
    new Ajax.Updater("bedsDiv",url,{
      evalScripts:true,
      method:"post",
      parameters: params,
      onSuccess: function(resp){
        $("bedsDiv").innerHTML = resp.responseText.trim();
    	enableButtons(true);
      },
      onFailure: function(resp){
        $("bedsDiv").innerHTML = "Error in 'system/ajax/searchBeds.jsp' : "+resp.responseText.trim();
      	enableButtons(true);
      }
    });
  }
  
  <%-- ENABLE BUTTONS --%>
  function enableButtons(key){
	if(document.FindBedForm!=null){
      if(FindBedForm.buttonfind) FindBedForm.buttonfind.disabled = !key;
      if(FindBedForm.buttonclear) FindBedForm.buttonclear.disabled = !key;
      if(FindBedForm.buttonnew) FindBedForm.buttonnew.disabled = !key;
      if(FindBedForm.Backbutton) FindBedForm.Backbutton.disabled = !key;
	}
  }
  
  <%-- CLEAR SEARCH FIELDS --%>
  function clearSearchFields(){
    FindBedForm.FindBedService.value = "";
    FindBedForm.FindBedServiceName.value = "";
    FindBedForm.FindBedName.value = "";
    
    $("bedsDiv").innerHTML = "";
  }

  <%-- DO FIND --%>
  function doFind(){
    if(FindBedForm.FindBedService.value!="" || FindBedForm.FindBedName.value!=""){
      FindBedForm.Action.value = "SEARCH";
      FindBedForm.buttonfind.disabled = true;
      FindBedForm.submit();
    }
    else{
      alertDialog("web.manage","dataMissing");
    }
  }

  <%-- DO NEW--%>
  function doNew(){
    FindBedForm.Action.value = "NEW";
    FindBedForm.submit();
  }

  <%-- DO SELECT --%>
  function doSelect(id){
    window.location.href = "<c:url value='/main.do'/>?Page=system/manageBeds.jsp"+
    		               "&Action=SELECT"+
    		               "&EditUID="+id+
    		               "&ts="+new Date().getTime();
  }

  <%-- SEARCH INFO SERVICE --%>
  function searchInfoService(sObject){
    if(sObject.value.length > 0){
      openPopup("/_common/search/serviceInformation.jsp&ServiceID="+sObject.value+"&ViewCode=on");
    }
  }

  <%-- DO NEW BED --%>
  function doNewBed(){
    EditBedForm.newButton.disabled = true;    
    EditBedForm.Action.value = "NEW";
    
    EditBedForm.EditName.value = "";
    EditBedForm.EditPriority.value = "";
    EditBedForm.EditLocation.value = "";
    EditBedForm.EditComment.value = "";
    EditBedForm.EditUID.value = "";
    
    if (EditBedForm.EditBedService.value.length==0) EditBedForm.EditBedService.value = "<%=sFindBedService%>";
    if (EditBedForm.EditBedServiceName.value.length==0) EditBedForm.EditBedServiceName.value = "<%=sFindBedServiceName%>";
    
    EditBedForm.submit();
  }

  <%-- DO DELETE BED --%>
  function doDeleteBed(deleteBedUid){    
    if(yesnoDeleteDialog()){
	  DeleteBedForm.EditUID.value = deleteBedUid;
	  DeleteBedForm.submit();
	}
  }

  <%-- DO SAVE --%>
  function doSave(){	  
    if(EditBedForm.EditBedService.value.length==0){
      alertDialog("web","no_bed_service");
    }
    else if(EditBedForm.EditName.value.length==0){
      alertDialog("web","no_bed_name");
    }
    else if(EditBedForm.EditPriority.value.length > 0 && !isNumber(EditBedForm.EditPriority)){
      alertDialog("web","bed_invalid_priority");
    }
    else{
      EditBedForm.saveButton.disabled = true;
      EditBedForm.Action.value = "SAVE";
      EditBedForm.submit();
    }
  }

  <%-- OPEN LOCATION FILE --%>
  function openLocationFile(){
    if(EditBedForm.EditLocation.value.length > 0){
      var url = "<%=MedwanQuery.getInstance().getConfigString("documentsdir","adt/documents/")+"/"+sEditLocation%>";
      window.open(url,"Location","toolbar=no,status=no,scrollbars=no,resizable=yes,menubar=no");
    }
  }

  <%-- SEARCH SERVICE --%>
  function searchService(serviceUidField,serviceNameField){
    openPopup("/_common/search/searchService.jsp&ts="+new Date().getTime()+"&VarCode="+serviceUidField+"&VarText="+serviceNameField);
  }
  
  <%-- DO BACK --%>
  function doBack(){
    window.location.href = "<c:url value='/main.do'/>?Page=system/menu.jsp&ts="+new Date().getTime();
  }

  <%-- DO BACK TO SEARCH --%>
  function doBackToSearch(){
	BackToSearchForm.submit();
  }
  
  <%
	  if(sAction.equals("SAVE") || sAction.equals("NEW") || sAction.equals("SELECT")){
		  if(sEditBedService.length() > 0){
	          %>searchBeds('','<%=sEditBedService%>');<%
		  }
	  }
	  else if(sAction.equals("SEARCH") || sAction.equals("DELETE")){
		  if(sFindBedName.length() > 0 || sFindBedService.length() > 0){
		      %>searchBeds('<%=sFindBedName%>','<%=sFindBedService%>');<%
		  }
	  }

      if(sAction.equals("NEW") || sAction.equals("SELECT") || sAction.equals("SAVE")){
          %>setTimeout('EditBedForm.EditName.focus();',500);<%
      }
  %>   
</script>