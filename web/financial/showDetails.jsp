<%@page import="net.admin.*,
                java.text.*,
                java.util.*,
                be.mxs.common.util.system.*,
                be.mxs.common.util.db.*,be.openclinic.reporting.*,pe.gob.sis.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	SIS_Object acreditacion = Acreditacion.getByAccreditationNumber(request.getParameter("accnr"));
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","insurancedetails",sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","authorizationnumber",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(2) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","contractr",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(16) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","insurancetype",sWebLanguage) %></td>
		<td class='admin2'><%=getTranNoLink("sis.insurancetype",acreditacion.getValueString(14),sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","insurancestatus",sWebLanguage) %></td>
		<td class='admin2'><b><%=acreditacion.getValueString(18) %></b></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","begin",sWebLanguage) %></td>
		<%
			String s = acreditacion.getValueString(8);
			if(s.length()>=8){
				s=s.substring(6,8)+"/"+s.substring(4,6)+"/"+s.substring(0,4);
			}
		%>
		<td class='admin2'><%=s %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","end",sWebLanguage) %></td>
		<%
			s = acreditacion.getValueString(17);
			if(s.length()>=8){
				s=s.substring(6,8)+"/"+s.substring(4,6)+"/"+s.substring(0,4);
			}
		%>
		<td class='admin2'><%=s %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","registrationnumber",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(21) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","coverageplan",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(29) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","coveragetable",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(20) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.ees",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(9) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.descees",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(10) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.eesubigeo",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(11) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.desceesubigeo",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(12) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.regimen",sWebLanguage) %></td>
		<td class='admin2'><%=getTranNoLink("sis.regimen",acreditacion.getValueString(13),sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","populationgroup",sWebLanguage) %></td>
		<td class='admin2'><%=getTranNoLink("sis.populationgroup",acreditacion.getValueString(30),sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","sis.disa",sWebLanguage) %></td>
		<td class='admin2'><%=acreditacion.getValueString(25) %></td>
	</tr>
</table>