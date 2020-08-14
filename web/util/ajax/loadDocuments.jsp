<%@page import="java.io.File"%>
<%@page import="be.openclinic.archiving.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%' cellspacing='1' cellpadding='1' >
<%
	String folder = checkString(request.getParameter("folder"));
	//We get all childfolders for this folder
	Vector<ArchiveDocument> documents = ArchiveDocument.getAllByReference("library."+folder);
	for(int n=0;n<documents.size();n++){
		ArchiveDocument document = documents.elementAt(n);
		if(document.deleteDate==null){
			out.println("<tr>");
			//If the document exists, make it a link
			String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
		    String sDocumentStore = SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
		    File file = new File(sDocumentStore+"/"+document.storageName);
		    if(SH.c(document.storageName).length()>0 && file.exists()){
		    	out.println("<td class='admin2'><a href='javascript:getFile(\"/"+document.storageName+"\")'>"+document.title+"</a></td>");
		    }
		    else {
		    	out.println("<td class='admin2'>"+document.title+"</td>");
		    }
			out.println("</tr>");
		}
	}
%>
</table>