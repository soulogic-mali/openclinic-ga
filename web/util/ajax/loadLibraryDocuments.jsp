<%@page import="java.io.File"%>
<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>

<%
	String sFolderCode=checkString(request.getParameter("folderCode"));
%>

<table width='100%'>
	<tr class='admin'><td colspan='6'><%=getTran(request,"web","documentsinthisfolder",sWebLanguage) %></td></tr>
<%
	//We must find all the documents linked to this folder
	Vector<ArchiveDocument> documents = ArchiveDocument.getAllByReference("library."+sFolderCode);
	for(int n=0;n<documents.size();n++){
		ArchiveDocument document = documents.elementAt(n);
		if(document.deleteDate==null){
			out.println("<tr>");
			out.println("<td class='admin' width='1%' nowrap><img style='vertical-align: middle' height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteDocument("+document.getServerId()+","+document.getObjectId()+")'/>&nbsp;</td>");
			//If the document exists, make it a link
			String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
		    String sDocumentStore = SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
		    File file = new File(sDocumentStore+"/"+document.storageName);
		    if(SH.c(document.storageName).length()>0 && file.exists()){
		    	out.println("<td class='admin'><a href='javascript:getFile(\"/"+document.storageName+"\")'>"+document.title+"</a></td>");
		    }
		    else {
		    	out.println("<td class='admin'>"+document.title+"&nbsp;&nbsp;<img style='vertical-align: middle' height='10px' src='"+sCONTEXTPATH+"/_img/themes/default/ajax-loader.gif'/></td>");
		    }
			out.println("<td class='admin2'><i>"+document.description+"</i></td>");
			out.println("<td class='admin2'><i>"+document.author+"</i></td>");
			out.println("<td class='admin2'><i>"+ScreenHelper.formatDate(document.date)+"</i></td>");
			out.println("</tr>");
		}
	}
%>
</table>