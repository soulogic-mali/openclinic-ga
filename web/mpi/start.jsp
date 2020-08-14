<%@include file="/includes/validateUser.jsp"%>
<center>
<%
	if(activeUser.getParameter("onetime").length()==0){
		out.println(getTran(request,"web","welcome",sWebLanguage)+" "+ScreenHelper.capitalizeAllWords(activeUser.person.firstname));
	}
	else{
		out.println(getTran(request,"web","welcomeonetimeuser",sWebLanguage).replaceAll("\\$patient\\$",activePatient.getFullName()));
	}
%>
<br/>
</center>