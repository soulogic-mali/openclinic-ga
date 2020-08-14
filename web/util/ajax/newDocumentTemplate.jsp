<%@page import="be.openclinic.archiving.ArchiveDocument"%>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>

<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","newdocument",sWebLanguage) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","title",sWebLanguage) %></td>
		<td class='admin2'><input type='text' class='text' name='docTitle' size='50'/></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","description",sWebLanguage) %></td>
		<td class='admin2'><textarea class='text' name='docDescription' cols='50' rows='4'></textarea></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","author",sWebLanguage) %></td>
		<td class='admin2'><input type='text' class='text' name='docAuthor' size='50'/></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","version",sWebLanguage) %></td>
		<td class='admin2'><input type='text' class='text' name='docVersion' size='10'/></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td class='admin2'><%=SH.writeDateField("docDate", "transactionForm", "", true, false, sWebLanguage, sCONTEXTPATH) %></td>
	</tr>
	<tr>
		<td class='admin'><%=getTran(request,"web","document",sWebLanguage) %></td>
		<td class='admin2'><input type='file' class='text' name='docFile' size='50'/></td>
	</tr>
	<tr>
		<td class='admin2'/>
		<td class='admin2'>
			<input type='submit' name='storeDocumentButton' class='button' value='<%=getTranNoLink("web","save",sWebLanguage) %>'/>
			<input type='button' name='cancel' class='button' value='<%=getTranNoLink("web","cancel",sWebLanguage) %>' onclick='loadDocuments();'/>
		</td>
	</tr>
</table>