<%@page import="java.text.SimpleDateFormat"%>
<%@page import="be.openclinic.system.SH"%>
<%@page import="org.apache.commons.io.FileUtils"%>
<%
	try{
		java.util.Date datetime = new SimpleDateFormat("yyyy-dd-MM HH:mm").parse(request.getParameter("date")+" "+request.getParameter("hour")+":"+request.getParameter("minutes"));
		FileUtils.writeStringToFile(new java.io.File(SH.cs("setdate.command","/tmp/setdate.sh")), "timedatectl set-ntp 0 ; date -s '"+new SimpleDateFormat("yyyy-dd-MM HH:mm:ss").format(datetime)+"'");
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>