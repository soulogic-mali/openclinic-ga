<%@page import="be.openclinic.util.Nomenclature"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<table width='100%'>
<%
	String folder = checkString(request.getParameter("folder"));
	Nomenclature folderref = Nomenclature.get("library",folder);
	String foldername="&nbsp;/";
	if(folderref!=null){
		foldername = "<a href='javascript:setFolder(\"\")'>/</a>>"+folderref.getFullyQualifiedNameLibrary(sWebLanguage);
	}
	out.println("<tr><td>"+foldername+"</td></tr>");
	//We get all childfolders for this folder
	Vector<Nomenclature> subfolders = Nomenclature.getChildren("library", folder);
	for(int n=0;n<subfolders.size();n++){
		Nomenclature nomenclature = subfolders.elementAt(n);
		out.println("<tr><td><a href='javascript:setFolder(\""+nomenclature.getId()+"\")'><img style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/themes/default/menu_tee_plus.gif'/>"+getTranNoLink("library",nomenclature.getId(),sWebLanguage)+"</a></td></tr>");
	}
	
%>
</table>