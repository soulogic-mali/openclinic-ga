<%@ page import="be.openclinic.adt.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<%
	String begindate = checkString(request.getParameter("begindate"));
	String enddate = checkString(request.getParameter("enddate"));
	Vector<Planning> appointments = Planning.getUserPlannings((String)session.getAttribute("calendarUser"), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(begindate), new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(enddate));
	int count=0;
	for(int n=0;n<appointments.size();n++){
		Planning appointment = appointments.elementAt(n);
		if(appointment.isFullDay() || new SimpleDateFormat("HH:mm:ss").format(appointment.getPlannedDate()).equalsIgnoreCase("00:00:00")){
			continue;
		}
		count++;
	}
%>
<h3><%=getTran(request,"web","selectedarearoverlapswithmultipleappointments",sWebLanguage)+" ("+count+")"%></h3><br/>
<br/>
<b><%=getTran(request,"web","whatwouldyouliketodo",sWebLanguage)%>:</b><br/>
<li><a href='javascript:editappointments()'><%=getTran(request,"web","editappointments",sWebLanguage)%></a>
<li><a href='javascript:createappointment()'><%=getTran(request,"web","createappointment",sWebLanguage)%></a>

<script>
	function editappointments(){
		window.location.href='<%=sCONTEXTPATH%>/popup.jsp?Page=calendar/editMultipleEvents.jsp&count=<%=count%>&begindate=<%=begindate%>&enddate=<%=enddate%>&PopupWidth=500&PopupHeight=250';
	}
	function createappointment(){
		window.location.href='<%=sCONTEXTPATH%>/popup.jsp?Page=calendar/editEvent.jsp&begindate=<%=begindate%>&enddate=<%=enddate%>&PopupWidth=500&PopupHeight=250';
	}
</script>