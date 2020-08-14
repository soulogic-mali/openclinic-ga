<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Queue queue = Queue.getByActiveTicketNumber(Integer.parseInt(request.getParameter("TicketID")));
	if(queue!=null && queue.getSubjecttype().equalsIgnoreCase("patient")){
		if(MedwanQuery.getInstance().getConfigInt("autoCloseTicketWhenScanned",1)==1){
			Queue.closeTicket(queue.getObjectid(), MedwanQuery.getInstance().getConfigInt("queueSeenValue",1)+"", Integer.parseInt(activeUser.userid));
		}
		%>
		<script>window.location.href = "<c:url value='/main.do'/>?Page=curative/index.jsp&ts=<%=ScreenHelper.getTs()%>&PersonID=<%=queue.getSubjectuid() %>";</script>
		<%
	}
%>