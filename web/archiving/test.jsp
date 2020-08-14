<%@page import="be.openclinic.archiving.ScanDirectoryMonitor"%>

<%
    ScanDirectoryMonitor scanDirMon = new ScanDirectoryMonitor();
    scanDirMon.activate();
%>