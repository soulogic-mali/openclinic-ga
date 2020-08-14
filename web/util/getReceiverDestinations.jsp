<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String destinations="<table>";
	try{
		String[] dests = checkString(request.getParameter("destinationids")).split(";");
		for(int n= 0;n<dests.length;n++){
			destinations+="<tr><td><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick=\\\"deleteDestination('"+dests[n]+"')\\\"/></td><td>"+ScreenHelper.getTranNoLink("sendRecordDestinations", dests[n].split(":")[0], sWebLanguage)+"</td><td><b>"+dests[n].split(":")[1]+"</b></td></tr>";
		}
		destinations+="</table>";
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
{
"destinations":"<%=destinations%>",
}