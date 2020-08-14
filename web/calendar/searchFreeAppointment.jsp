<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td><%=getTran(request,"web","hour",sWebLanguage) %></td>
		<td><%=getTran(request,"web","duration",sWebLanguage) %></td>
		<td><%=getTran(request,"web","location",sWebLanguage) %></td>
		<td><%=getTran(request,"web","user",sWebLanguage) %></td>
	</tr>
<%
	long minute = 60000;
	String sLocation = checkString(request.getParameter("location"));
	String sBegin = checkString(request.getParameter("begin"));
	String sBeginHour = checkString(request.getParameter("beginhour"));
	String sEnd = checkString(request.getParameter("end"));
	String sEndHour = checkString(request.getParameter("endhour"));
	String sUserId = checkString(request.getParameter("userid"));
	String sResourceId = checkString(request.getParameter("resourceid"));
	Vector<Planning> appointments = Planning.searchFreeAppointments(sUserId,sLocation,sBegin,sEnd,sBeginHour,sEndHour);
	int counter=0;
	for(int n=0;n<appointments.size();n++){
		Planning appointment = appointments.elementAt(n);
		//First check if there is no overlap with this appointment
		if(!appointment.isFree()){
			continue;
		}
		//If a resource was specified, also check if the resource is available for this appointment
		if(sResourceId.length()>0 && !appointment.isResourceAvailable(sResourceId,sWebLanguage)){
			continue;
		}
		out.println("<tr>");
		out.println("<td class='admin'>"+ScreenHelper.formatDate(appointment.getPlannedDate())+"</td>");
		out.println("<td class='admin'><a href='javascript:window.location.href=\""+sCONTEXTPATH+"/popup.jsp?Page=/calendar/editEvent.jsp&id="+appointment.getUid()+"&type=-&resourceid="+sResourceId+"\";'>"+new SimpleDateFormat("HH:mm").format(appointment.getPlannedDate())+"</a></td>");
		String sDuration="-";
		if(appointment.getPlannedEndDate()!=null){
			sDuration=((appointment.getPlannedEndDate().getTime()-appointment.getPlannedDate().getTime())/minute)+"m";
		}
		out.println("<td class='admin'>"+sDuration+"</td>");
		out.println("<td class='admin'>"+getTran(request,"appointment.location",appointment.getLocation(),sWebLanguage)+"</td>");
		out.println("<td class='admin'>"+(checkString(appointment.getUserUID()).length()==0?"":User.getFullUserName(appointment.getUserUID()))+"</td>");
		out.println("</tr>");
		counter++;
	}
%>
</table>