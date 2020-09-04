<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sMandatoryNames="missingPatientID;missingSampleID;missingTestLISCode;missingTestSite;missingTestSiteSampleReceivedDateTime;missingTestResultReleasedDateTime";
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='2'><%=getTran(request,"web","results",sWebLanguage) %></td>
	</tr>
<%
	String[] sResult=SH.c((String)session.getAttribute("dataExtractResult")).split(";");
	if(sResult.length>0){
		String[] lines = sResult;
		for(int n =0;n<lines.length;n++){
			if(sMandatoryNames.indexOf(lines[n].split("=")[0])>-1){
				out.println("<tr><td class='admin'><font style='color: red'>"+lines[n].split("=")[0]+"</font></td><td class='admin2'><font style='color: red;font-weight: bolder'>"+lines[n].split("=")[1]+"</font></td></tr>");
			}
			else{
				out.println("<tr><td class='admin'>"+lines[n].split("=")[0]+"</td><td class='admin2'>"+lines[n].split("=")[1]+"</td></tr>");
			}
		}
	}
	session.removeAttribute("dataExtractResult");
%>
</table>
