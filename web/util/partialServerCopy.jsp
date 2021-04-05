<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	out.println("<b>Copying server data to disk file...</b><br/>");
	out.flush();
	Thread.sleep(1000);
	String executeCmd = "";
	executeCmd = "cmd /c \""+SH.cs("offlineMySQLBinDirectory","C:/Program Files/MySQL/MySQL Server 5.7/bin")+"/mysqldump.exe\" -h "+
			SH.cs("offlineReferenceMySQLServerIPAddress","")+" -P "+SH.cs("offlineReferenceMySQLServerPort","3306")+" -u "+SH.cs("offlineReferenceMySQLServerUser","")+" --password="+
			SH.cs("offlineReferenceMySQLServerPassword","")+" ocadmin_dbo admin adminprivate adminextends users > "+SH.cs("tempDirectory","/temp")+"/oca.sql";
	System.out.println(executeCmd);
	Process runtimeProcess = Runtime.getRuntime().exec(executeCmd);
	int processComplete = runtimeProcess.waitFor();
	executeCmd = "cmd /c \""+SH.cs("offlineMySQLBinDirectory","C:/Program Files/MySQL/MySQL Server 5.7/bin")+"/mysqldump.exe\" -h "+
			SH.cs("offlineReferenceMySQLServerIPAddress","")+" -P "+SH.cs("offlineReferenceMySQLServerPort","3306")+" -u "+SH.cs("offlineReferenceMySQLServerUser","")+" --password="+
			SH.cs("offlineReferenceMySQLServerPassword","")+" openclinic_dbo healthrecord oc_encounters transactions items requestedlabanalyses oc_credits oc_debets oc_diagnoses oc_rfe > "+SH.cs("tempDirectory","/temp")+"/oc.sql";
	runtimeProcess = Runtime.getRuntime().exec(executeCmd);
	processComplete = runtimeProcess.waitFor();
	if(processComplete == 0){
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'/> Backup taken successfully<br/><br/>");
	} 
	else {
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/> Could not take mysql backup<br/><br/>");
	}
	out.println("<b>Loading disk file into local database...</b><br/>");
	out.flush();
	Thread.sleep(1000);
	executeCmd = "cmd /c \""+SH.cs("offlineMySQLBinDirectory","C:/Program Files/MySQL/MySQL Server 5.7/bin")+"/mysql.exe\" -u "+
			SH.cs("offlineLocalMySQLServerUser","")+" -h "+ SH.cs("offlineLocalMySQLServerIPAddress","127.0.0.1")+" -P "+
			SH.cs("offlineLocalMySQLServerPort","3306")+" --password="+SH.cs("offlineLocalMySQLServerPassword","")+" ocadmin_dbo < "+SH.cs("tempDirectory","/temp")+"/oca.sql";
	runtimeProcess = Runtime.getRuntime().exec(executeCmd);
	processComplete = runtimeProcess.waitFor();
	executeCmd = "cmd /c \""+SH.cs("offlineMySQLBinDirectory","C:/Program Files/MySQL/MySQL Server 5.7/bin")+"/mysql.exe\" -u "+
			SH.cs("offlineLocalMySQLServerUser","")+" -h "+ SH.cs("offlineLocalMySQLServerIPAddress","127.0.0.1")+" -P "+
			SH.cs("offlineLocalMySQLServerPort","3306")+" --password="+SH.cs("offlineLocalMySQLServerPassword","")+" openclinic_dbo < "+SH.cs("tempDirectory","/temp")+"/oc.sql";
	runtimeProcess = Runtime.getRuntime().exec(executeCmd);
	processComplete = runtimeProcess.waitFor();
	if(processComplete == 0){
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_check.png'/> Backup restored successfully<br/><br/>");
	} 
	else {
		out.println("<img src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'/> Could not restore mysql backup<br/><br/>");
	}
%>
