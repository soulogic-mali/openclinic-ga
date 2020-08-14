<%@page import="be.mxs.common.util.db.*,net.admin.*,ca.uhn.fhir.rest.client.interceptor.*,ca.uhn.fhir.rest.gclient.*,ca.uhn.fhir.rest.param.*,java.util.*,be.hapi.*"%>
<%@page import="ca.uhn.fhir.context.*,org.hl7.fhir.r4.model.*,org.hl7.fhir.r4.model.Identifier.*,org.hl7.fhir.r4.model.Bundle.*,org.hl7.fhir.instance.model.api.*,ca.uhn.fhir.rest.client.api.*,ca.uhn.fhir.rest.api.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>

<%
	SortedMap<String,AdminPerson> sortedPatients = activePatient.searchMPI();
%>
<table width='100%'>
	<%
	if(sortedPatients.size()>0){
		%>
		<tr>
			<td colspan='4'><input type='button' class='button' name='newmpibutton' onclick='creatempi()' value='<%=getTranNoLink("web","createnewmpiid",sWebLanguage)%>'/></td>
		</tr>
		<%
		Iterator<String> iSortedPatients = sortedPatients.keySet().iterator();
		while(iSortedPatients.hasNext()){
			String score="";
			String key = iSortedPatients.next();
			AdminPerson p = sortedPatients.get(key);
			if(p.adminextends.get("mpimatch")!=null){
				score="<br/><table width='80%' cellpadding='0' cellspacing='2px'><tr class='border_box'><td style='background-color: green' height='10px' width='"+(Double.parseDouble((String)p.adminextends.get("mpimatch"))*100/1340)+"%'></td><td style='background-color: white' width='*'></td><tr></table>";
			}
			%>
			<tr style='vertical-align: top'>
				<td class='admin' style='vertical-align: top'><a href='javascript:mpiget("<%=checkString((String)p.adminextends.get("mpiid"))%>")'><b style='color:red;font-size: 12px'><%=checkString((String)p.adminextends.get("mpiid")) %></b></a><%=score %></td>
				<td class='admin2' style='vertical-align: top'><b><%=p.getFullName() %></b><br>°<%=p.dateOfBirth %> <%=getTranNoLink("gender",p.gender,sWebLanguage) %></td>
				<td class='admin2' style='vertical-align: top'><%=checkString(p.getID("natreg")) %></td>
				<td class='admin2' style='vertical-align: top'><%=checkString(p.getActivePrivate().telephone) %><br><%=checkString(p.getActivePrivate().email) %></td>
			</tr>
			<%
		}
	}
	else{
		%>
		<tr>
			<td style='font-size: 12px;color:red'><%=getTran(request,"web","nomatches",sWebLanguage) %></td>
		</tr>
		<tr>
			<td><input type='button' class='button' name='newmpibutton' onclick='creatempi()' value='<%=getTranNoLink("web","createnewmpiid",sWebLanguage)%>'/></td>
		</tr>
		<%
	}
	%>
</table>