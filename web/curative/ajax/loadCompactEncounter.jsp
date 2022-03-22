<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String encounteruid="",encounterservice="",encounterservicename="",encountertype="",encountermanager="",encountermanagername="",encounterorigin=SH.cs("defaultOrigin","1");
	Encounter encounter = Encounter.getActiveEncounter(activePatient.personid);
	if(encounter!=null && encounter.getEnd()==null){
		encounterservice=encounter.getServiceUID();
		encounterservicename=encounter.getService().getLabel(sWebLanguage);
		encountertype=encounter.getType();
		encounterorigin=encounter.getOrigin();
		encounteruid=encounter.getUid();
		encountermanager=encounter.getManagerUID();
		if(encounter.getManager()!=null&& encounter.getManager().person!=null){
			encountermanagername=encounter.getManager().person.getFullName();
		}
	}
	else{
%>
<tr>
	<td colspan='2'><font style='font-weight: bold;color: red'><%=getTran(request,"web","encountermustbecreated",sWebLanguage) %></font></td>
</tr>
<%
	}
%>
<tr id='trMsg'><td colspan='2'></td></tr>
<tr>
    <td class="admin" width='20%'><%=getTran(request,"web","service",sWebLanguage)%> *</td>
    <td class='admin2' nowrap>
    	<input type='hidden' name='encounteruid' id='encounteruid' value='<%=encounteruid %>'/>
        <input type="hidden" name="EditEncounterService" id="EditEncounterService" value="<%=encounterservice%>"/>
        <input class="text" type="text" name="EditEncounterServiceName" id="EditEncounterServiceName" value="<%=encounterservicename%>" readonly size="50"/>
        <%
          boolean bClosedEncounter = (SH.c(encounteruid).length()==0 || encounteruid.contains("-"));
        %>
        <img style='display: <%=!bClosedEncounter?"none":"" %>' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" title="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchService('EditEncounterService','EditEncounterServiceName');">
        <img style='display: <%=!bClosedEncounter?"none":"" %>' src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" title="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="EditEncounterService.value='';EditEncounterServiceName.value='';">
       	<img style='display: <%=bClosedEncounter?"none":"" %>' id='imgCloseEncounter' src="<c:url value="/_img/icons/icon_locked.png"/>" class="link" title="<%=getTran(null,"web","close",sWebLanguage)%>" onclick="closeEncounter();">
    </td>
</tr>
<tr>
    <td class="admin"><%=getTran(request,"web","manager",sWebLanguage)%></td>
    <td class="admin2" nowrap>
        <input type="hidden" name="EditEncounterManager" id="EditEncounterManager" value="<%=encountermanager%>">
        <input class="text" type="text" name="EditEncounterManagerName" id="EditEncounterManagerName" readonly size="50" value="<%=encountermanagername%>">
        <img style='display: <%=!bClosedEncounter?"none":"" %>' src="<c:url value="/_img/icons/icon_search.png"/>" class="link" alt="<%=getTran(null,"web","select",sWebLanguage)%>" onclick="searchManager('EditEncounterManager','EditEncounterManagerName');">
        <img style='display: <%=!bClosedEncounter?"none":"" %>'src="<c:url value="/_img/icons/icon_delete.png"/>" class="link" alt="<%=getTran(null,"web","clear",sWebLanguage)%>" onclick="document.getElementById('EditEncounterManager').value='';document.getElementById('EditEncounterManagerName').value='';">
    </td>
</tr>
<tr>
    <td class="admin" width="<%=sTDAdminWidth%>"><%=getTran(request,"web","type",sWebLanguage)%> *</td>
    <td class='admin2'>
        <%if(bClosedEncounter){ %>
         <select class='text' id='EditEncounterType' name='EditEncounterType' onchange="setMyAutoCompleter();checkEncounterType();">
         	<option value=''></option>
             <%
                 String encountertypes = MedwanQuery.getInstance().getConfigString("encountertypes","visit,admission");
                 String sOptions[] = encountertypes.split(",");

                 for(int i=0;i<sOptions.length;i++){
                     out.print("<option value='"+sOptions[i]+"' ");
                     if(sOptions[i].equalsIgnoreCase(encountertype)){
                     	out.print("selected");
                     }
                     out.print(">"+getTran(request,"web",sOptions[i],sWebLanguage)+"</option>");
                 }
             %>
         </select>
     <%}else{ %>
         <select class='text' id='EditEncounterType' name='EditEncounterType'>
         	<option value='<%=encountertype %>'><%=getTran(request,"web",encountertype,sWebLanguage) %></option>
         </select>
     <%} %>
    </td>
</tr>
<tr>
    <td class="admin"><%=getTran(request,"openclinic.chuk","urgency.origin",sWebLanguage)%> *</td>
    <td class="admin2">
        <%if(bClosedEncounter){ %>
         <select class="text" name="EditEncounterOrigin" id="EditEncounterOrigin">
             <option/>
             <%=ScreenHelper.writeSelect(request,"urgency.origin",encounterorigin,sWebLanguage)%>
         </select>
     <%}else{ %>
         <select class='text' id="EditEncounterOrigin" id="EditEncounterOrigin">
         	<option value='<%=encounterorigin %>'><%=getTran(request,"urgency.origin",encounterorigin,sWebLanguage) %></option>
         </select>
     <%} %>
    </td>
</tr>
