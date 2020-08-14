<%@include file="/mobile/_common/head.jsp"%>
<%
	if(activePatient==null){
		out.print("<script>window.location.href='searchPatient.jsp';</script>");
	}
	else{
%>
<table class="list" padding="0" cellspacing="1" width="<%=sTABLE_WIDTH%>">
	<tr class="admin"><td><%=activePatient.lastname+", "+activePatient.firstname%> - <%=activePatient.dateOfBirth%></td></tr>

	<tr class="list1"><td><a href="getPatientAdmin.jsp"><%=getTran(request,"mobile","administrativedata",activeUser)%></a></td></tr>
	<tr class="list"><td><a href="getPatientBiometrics.jsp"><%=getTran(request,"mobile","biometricdata",activeUser)%></a></td></tr>
	<tr class="list1"><td><a href="getPatientLab.jsp"><%=getTran(request,"mobile","labdata",activeUser)%></a></td></tr>
	<tr class="list"><td><a href="getPatientImaging.jsp"><%=getTran(request,"mobile","imagingdata",activeUser)%></a></td></tr>
	<tr class="list1"><td><a href="getPatientEncounters.jsp"><%=getTran(request,"mobile","encounterdata",activeUser)%></a></td></tr>
	<tr class="list"><td><a href="getPatientClinical.jsp"><%=getTran(request,"mobile","clinicaldata",activeUser)%></a></td></tr>
	<tr class="list1"><td><a href="getPatientMedication.jsp"><%=getTran(request,"mobile","activeMedication",activeUser)%></a></td></tr>
	<tr class="list"><td><a href="getReasonsForEncounter.jsp"><%=getTran(request,"mobile","reasonsforencounter",activeUser)%></a></td></tr>
</table>

<%@include file="/mobile/_common/footer.jsp"%>
<%
	}
%>