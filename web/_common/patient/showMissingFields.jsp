<%@ page import="java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<body onunload="window.opener.location.href='<c:url value="/patientedit.do"/>';" onblur="window.opener.location.href='<c:url value="/patientedit.do"/>';">
<table width='100%'>
	<tr class='admin'><td><%=getTran(request,"web","mandatory.patientdata.ismissing",sWebLanguage) %></td></tr>
<%
	Vector missing = activePatient.getMissingMandatoryFieldsTranslated(sWebLanguage);
	for(int n=0;n<missing.size();n++){
		out.println("<tr><td class='admin2'>"+missing.elementAt(n)+"</td></tr>");
	}
%>
</table>
<center><input type='button' value='<%=getTran(null,"web","close",sWebLanguage) %>' onclick='closeMe();'/></center>

<script>
	function closeMe(){
		window.opener.location.href='<c:url value="/patientedit.do"/>';
		window.close();
	}
</script>