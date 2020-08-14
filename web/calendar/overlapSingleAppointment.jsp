<%@ page import="be.openclinic.adt.*" %>
<%@include file="/includes/validateUser.jsp"%>
<%=sCSSNORMAL %>
<%
	String id = checkString(request.getParameter("id"));
	String begindate = checkString(request.getParameter("begindate"));
	String enddate = checkString(request.getParameter("enddate"));
	Planning appointment = Planning.get(id);
%>
<h3><%=getTran(request,"web","selectedarearoverlapswithfollowingappointment",sWebLanguage)%>:</h3><br/>
<li><%=getTran(request,"web","date",sWebLanguage)+": <b>"+ScreenHelper.formatDate(appointment.getPlannedDate())%></b></li>
<li><%=getTran(request,"web","hour",sWebLanguage)+": <b>"+new SimpleDateFormat("HH:mm").format(appointment.getPlannedDate())%></b></li>
<li><%=getTran(request,"web","patient",sWebLanguage)+": <b>"+(appointment.getPatient()==null?"":appointment.getPatient().getFullName())%></b></li>
<li><%=getTran(request,"web","user",sWebLanguage)+": <b>"+(appointment.getUser()==null?"":appointment.getUser().getFullName())%></b></li>
<li><%=getTran(request,"web","location",sWebLanguage)+": <b>"+getTranNoLink("appointment.location",appointment.getLocation(),sWebLanguage)%></b></li>
<li><%=getTran(request,"web","type",sWebLanguage)+": <b>"+getTranNoLink("appointment.types",appointment.getType(),sWebLanguage)%></b></li>
<br/>
<b><%=getTran(request,"web","whatwouldyouliketodo",sWebLanguage)%>:</b><br/>
<li><a href='javascript:openappointment()'><%=getTran(request,"web","openappointment",sWebLanguage)%></a>
<li><a href='javascript:createappointment()'><%=getTran(request,"web","createappointment",sWebLanguage)%></a>

<script>
	function openappointment(){
		window.location.href='<%=sCONTEXTPATH%>/popup.jsp?Page=calendar/editEvent.jsp&id=<%=id%>&PopupWidth=500&PopupHeight=250';
	}
	function createappointment(){
		window.location.href='<%=sCONTEXTPATH%>/popup.jsp?Page=calendar/editEvent.jsp&begindate=<%=begindate%>&enddate=<%=enddate%>&PopupWidth=500&PopupHeight=250';
	}
</script>