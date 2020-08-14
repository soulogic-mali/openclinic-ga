<%@page import="pe.gob.sis.*"%>
<%@page import="org.jnp.interfaces.java.javaURLContextFactory"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
<%
	FUAGenerator generator = new FUAGenerator();
	if(checkString(request.getParameter("error")).equalsIgnoreCase("1")){
		generator.loadErrorFUAs(Integer.parseInt(request.getParameter("year")), Integer.parseInt(request.getParameter("month")));
	}
	else{
		generator.loadFUAs(Integer.parseInt(request.getParameter("year")), Integer.parseInt(request.getParameter("month")));
	}
	if(generator.getFuas().size()>0){
		out.println("<tr class='admin'>");
		out.println("<td>"+getTran(request,"web","id",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","fuadate",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","patient",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","service",sWebLanguage)+"</td>");
		out.println("<td>"+getTran(request,"web","user",sWebLanguage)+"</td>");
		out.println("</tr>");
	}
	for(int n=0;n<generator.getFuas().size();n++){
		FUA fua = (FUA)generator.getFuas().elementAt(n);
		out.println("<tr>");
		out.println("<td class='admin'><a href='"+sCONTEXTPATH+"/main.jsp?Page=financial/manageFUA.jsp&fuauid="+fua.getUid()+"&PersonID="+fua.getPersonId()+"'>"+fua.getUid()+"</a></td>");
		out.println("<td class='admin'>"+fua.getDate()+"</td>");
		Encounter encounter = Encounter.get(fua.getEncounteruid());
		out.println("<td class='admin2'>"+encounter.getPatient().getFullName()+"</td>");
		out.println("<td class='admin2'>"+encounter.getService().getLabel(sWebLanguage)+"</td>");
		out.println("<td class='admin2'>"+User.getFullUserName(encounter.getManagerUID())+"</td>");
		out.println("</tr>");
	}
%>
</table>