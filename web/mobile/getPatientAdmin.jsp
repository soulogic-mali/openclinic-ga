<%@include file="/mobile/_common/head.jsp"%>

<%-- DEMOGRAPHICS -----------------------------%>
<table class="list" padding="0" cellspacing="1" width="<%=sTABLE_WIDTH%>">
	<tr class="admin"><td colspan="2"><%=getTran(request,"mobile","demographics",activeUser)%></td></tr>
	
	<tr><td width="100" class="admin" nowrap><%=getTran(request,"web.admin","nationality",activeUser)%></td><td><%=getTran(request,"country",activePatient.nativeCountry,activeUser)%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"mobile","idcard",activeUser)%></td><td><%=activePatient.getID("natreg")%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","language",activeUser)%></td><td><%=getTran(request,"web.language",activePatient.language,activeUser)%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","gender",activeUser)%></td><td><%=getTran(request,"gender",activePatient.gender,activeUser)%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","civilstatus",activeUser)%></td><td><%=getTran(request,"civil.status",activePatient.comment2,activeUser)%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","province",activeUser)%></td><td><%=activePatient.getActivePrivate().province%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","district",activeUser)%></td><td><%=activePatient.getActivePrivate().district%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","city",activeUser)%></td><td><%=activePatient.getActivePrivate().city%></td></tr>
	<tr><td class="admin" nowrap><%=getTran(request,"web","telephone",activeUser)%></td><td><%=activePatient.getActivePrivate().telephone%></td></tr>
</table>
<div style="padding-top:5px;"></div>

<%-- ADT --------------------------------------%>
<table class="list" padding="0" cellspacing="1" width="<%=sTABLE_WIDTH%>">
	<tr class="admin"><td colspan="3"><%=getTran(request,"web","adt",activeUser)%></td></tr>
	
	<tr class="gray"><td colspan="3"><%=getTran(request,"web","active_encounter",activeUser)%></td></tr>
	<%
		Encounter activeContact = Encounter.getActiveEncounter(activePatient.personid);	
		if(activeContact!=null){
			// 1 - general 
			out.print("<tr><td class='admin' width='100' nowrap>"+getTran(request,"web.occup","medwan.common.contacttype",activeUser)+"</td><td>"+getTran(request,"encountertype",activeContact.getType(),activeUser)+"</td></tr>");
			out.print("<tr><td class='admin' nowrap>"+getTran(request,"web","begin",activeUser)+"</td><td>"+stdDateFormat.format(activeContact.getBegin())+"</td></tr>");
			out.print("<tr><td class='admin' nowrap>"+getTran(request,"openclinic.chuk","urgency.origin",activeUser)+"</td><td>"+getTran(request,"urgency.origin",activeContact.getOrigin(),activeUser)+"</td></tr>");
			if(activeContact.getManager()!=null && activeContact.getManager().person!=null){
				out.print("<tr><td class='admin' nowrap>"+getTran(request,"web","manager",activeUser)+"</td><td>"+activeContact.getManager().person.getFullName()+"</td></tr>");
			}
			out.print("<tr><td class='admin' nowrap>"+getTran(request,"web","service",activeUser)+"</td><td>"+activeContact.getService().getLabel(activeUser.person.language)+"</td></tr>");

			out.print("</table>");
			out.print("<div style='padding-top:3px;'>");
			
			// 2 - reasons for encounter
            out.print("<table padding='0' cellspacing='0' width='"+sTABLE_WIDTH+"'>"); 
			out.print("<tr class='gray'><td colspan='3'>"+getTran(request,"openclinic.chuk","rfe",activeUser)+"</td></tr>");
			out.print("<tr><td colspan='2' style='padding-left:3px'>"+getReasonsForEncounterAsHtml(activeContact.getUid(),activeUser.person.language)+"</td></tr>");
		}
	%>
</table>
<div style="padding-top:3px;">

   <table class="list" padding="0" cellspacing="1" width="<%=sTABLE_WIDTH%>">
	<tr class="gray"><td colspan="3"><%=getTran(request,"mobile","lastContacts",activeUser)%></td></tr>
	<%
	    // 3 - last contacts
		Encounter lastvisit = Encounter.getInactiveEncounterBefore(activePatient.personid,"visit",new java.util.Date());
		if(lastvisit!=null){
			out.print("<tr>"+
		               "<td class='admin' width='100' nowrap>"+getTran(request,"encountertype","visit",activeUser)+"</td>"+
		               "<td>"+stdDateFormat.format(lastvisit.getBegin())+": "+lastvisit.getService().getLabel(activeUser.person.language)+"</td>"+
					  "</tr>");
		}
		
		Encounter lastadmission = Encounter.getInactiveEncounterBefore(activePatient.personid,"admission",new java.util.Date());
		if(lastadmission!=null){
			out.print("<tr><td class='admin' width='100' nowrap>"+getTran(request,"encountertype","admission",activeUser)+"</td><td width='90%'>"+stdDateFormat.format(lastadmission.getBegin())+": "+lastadmission.getService().getLabel(activeUser.person.language)+"</td></tr>");
		}

		if(lastvisit==null && lastadmission==null){
			out.print("<tr><td colspan='2' style='padding-left:3px;'><i>"+getTran(request,"web","noData",activeUser)+"</i></td></tr>");
		}
	%>
</table>
			
<%-- BUTTONS --%>
<%=alignButtonsStart()%>
    <input type="button" class="button" name="backButton" onclick="showPatientMenu();" value="<%=getTranNoLink("web","back",activeUser)%>">
<%=alignButtonsStop()%>
			
<%@include file="/mobile/_common/footer.jsp"%>