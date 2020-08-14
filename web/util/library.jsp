<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>

<%
	String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
	String sDocumentStore = SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
%>
<table width='100%'>
	<tr class='admin'><td colspan='2'><%=getTran(request,"web","library",sWebLanguage) %></td></tr>
	<tr valign='top'>
		<td valign='top' class='admin' width='30%'><%=getTran(request,"web","folders",sWebLanguage) %></td>
		<td valign='top' class='admin' width='*'><%=getTran(request,"web","documents",sWebLanguage) %></td>
	</tr>
	<tr valign='top'>
		<td style='vertical-align: top;background-color: #DEEAFF;' nowrap><div id='divFolders'/></td>
		<td valign='top'><div id='divDocuments'/></td>
	</tr>
</table>
<IFRAME style="display:none" id='hf2' name="hidden-libform"></IFRAME>

<script>
	var activeFolder='';
	
	function loadFolders(){
	    var params = "folder="+activeFolder;
		var url = "<%=sCONTEXTPATH%>/util/ajax/loadFolders.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divFolders').innerHTML=resp.responseText;
			loadDocuments();
		}
		});
	}
	
	function loadDocuments(){
	    var params = "folder="+activeFolder;
		var url = "<%=sCONTEXTPATH%>/util/ajax/loadDocuments.jsp";
		new Ajax.Request(url,{
		method: "POST",
		parameters: params,
		onSuccess: function(resp){
			document.getElementById('divDocuments').innerHTML=resp.responseText;
		}
		});
	}
	
	function setFolder(folder){
		activeFolder=folder;
		loadFolders();
	}
	
	function getFile(filename){
		var url = "<c:url value='util/getDocument.jsp?document='/><%=sDocumentStore%>/"+filename;
		window.open(url,"hidden-libform");
	}
	
	loadFolders();
</script>