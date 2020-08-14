<%@page import="be.openclinic.archiving.ScanDirectoryMonitor"%>
<%@ page import="be.mxs.common.util.db.MedwanQuery" %>
<%
	ScanDirectoryMonitor monitor = new ScanDirectoryMonitor();
	monitor.activate();
%>