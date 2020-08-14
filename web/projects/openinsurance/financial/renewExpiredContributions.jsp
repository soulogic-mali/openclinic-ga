<%@ page import="be.openclinic.finance.*,java.util.Date" %>
<%@ page errorPage="/includes/error.jsp" %>
<%@ include file="/includes/validateUser.jsp" %>
<%
	String sDate=checkString(request.getParameter("expirydate"));
	if(sDate.length()==0){
		sDate=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date());
	}
	java.util.Date date = new SimpleDateFormat("dd/MM/yyyy").parse(sDate);
%>
<form name=renewExpiredForm" method="post">
<table>
	<tr><td class='admin'><label class='text'><%=getTran(request,"web","renewcontributionsthatexpireon",sWebLanguage)%></label></td><td class='admin2'><%=writeDateField("expirydate","renewExpiredForm",sDate,sWebLanguage) %>
<%
	if(request.getParameter("find")==null){
%>
	<input name='find' type='submit' value='<%=getTran(null,"web","find",sWebLanguage) %>'/></td></tr>
<%
	}
	else {
%>
	<input name='update' type='submit' value='<%=getTran(null,"web","update",sWebLanguage) %>'/></td></tr>
<%
	}
%>
</table>
</form>
<br/>
<%
if(request.getParameter("find")!=null){
	out.println("<h2>"+getTran(request,"web","totalnumberofcontributionstorenew",sWebLanguage)+": "+PrestationDebet.renewExpiredContributions(date,activeUser.userid,false)+"</h2>");
}
else if(request.getParameter("update")!=null){
	out.println("<h2>"+getTran(request,"web","totalnumberofcontributionsrenewed",sWebLanguage)+": "+PrestationDebet.renewExpiredContributions(date,activeUser.userid,true)+"</h2>");
}
%>