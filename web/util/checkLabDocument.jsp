<%@ page import="be.openclinic.archiving.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String fileuploadid=request.getParameter("fileuploadid");
	Debug.println("searching for udi "+fileuploadid);
	ArchiveDocument doc = ArchiveDocument.get(fileuploadid);
	if(doc!=null && checkString(doc.storageName).length()>0){
		out.print("true");
	}
%>