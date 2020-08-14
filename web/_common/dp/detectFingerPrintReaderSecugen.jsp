<%@include file="/includes/helper.jsp"%>
<%
Debug.println("FingerPrintId for session "+session.getId()+" = "+(String)session.getAttribute("fingerprintid"));
%>
{
	"serial":"<%=checkString((String)session.getAttribute("fingerprintid"))%>"
}