<%@page import="be.openclinic.archiving.ArchiveDocument,java.io.*,be.mxs.common.util.db.*"%>
<%
	String documentuid = request.getParameter("documentuid");
	String storageName=ArchiveDocument.getStorageName(documentuid);
	if(storageName.length()>0){
		File file = new File(MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+storageName);
		file.delete();
	}
	ArchiveDocument.setStorageName(documentuid, "");
%>