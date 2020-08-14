<%@ page import="be.openclinic.adt.Queue,java.util.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<table>
<%
	SortedMap stats = Queue.calculateStats();
	boolean bInit=false;
	if(stats.size()>0){
		Iterator iStats = stats.keySet().iterator();
		while(iStats.hasNext()){
			String queueid=(String)iStats.next();
			if(!bInit){
				out.println("<tr class='admin'><td colspan='2'>"+getTran(request,"web.manage","calculatequeuestats",sWebLanguage)+"</td></tr>");
				out.println("<tr class='admin'><td>"+getTran(request,"web","waitingqueue",sWebLanguage)+"</td><td>"+getTran(request,"web","median",sWebLanguage)+"</td></tr>");
				bInit=true;
			}
			long millis=(Long)stats.get(queueid);
			long second = (millis / 1000) % 60;
			long minute = (millis / (1000 * 60)) % 60;
			long hour = (millis / (1000 * 60 * 60)) % 24;
			String time = String.format("%02d:%02d:%02d", hour, minute, second);
			out.println("<tr><td  class='admin'>"+getTran(request,"queue",queueid,sWebLanguage)+"</td><td class='admin2'>"+time+"</td></tr>");
		}
	}
%>
</table>