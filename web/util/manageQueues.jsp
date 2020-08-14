<%@ page import="be.openclinic.adt.Queue" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<form name='transactionForm' method='post'>
	<%
	if(checkString(request.getParameter("numberOfFrames")).equalsIgnoreCase("4")){
	%>
	<frameset name="queues" rows="5%,95%">
		<frame name='menu' src='<c:url value="/util/waitingQueueMenu.jsp?verticalFrames=2"/>'/>
		<frameset cols ="50%,50%" rows="50%,50%">
			<frame name='topleft' src='<c:url value="/util/manageQueue.jsp?verticalFrames=2"/>'/>
			<frame name='topright' src='<c:url value="/util/manageQueue.jsp?verticalFrames=2"/>'/>
			<frame name='bottomleft' src='<c:url value="/util/manageQueue.jsp?verticalFrames=2"/>'/>
			<frame name='bottomright' src='<c:url value="/util/manageQueue.jsp?verticalFrames=2"/>'/>
		</frameset>
	</frameset>
	<%
		}
		else if(checkString(request.getParameter("numberOfFrames")).equalsIgnoreCase("2")){
	%>
	<frameset rows="5%,95%">
		<frame name='menu' src='<c:url value="/util/waitingQueueMenu.jsp"/>'/>
		<frameset cols ="50%,50%">
			<frame name='topleft' src='<c:url value="/util/manageQueue.jsp"/>'/>
			<frame name='topright' src='<c:url value="/util/manageQueue.jsp"/>'/>
		</frameset>
	</frameset>
	<%
		}
		else{
	%>
	<frameset name="queues" rows="5%,95%">
		<frame name='menu' src='<c:url value="/util/waitingQueueMenu.jsp"/>'/>
		<frameset cols ="100%">
			<frame name='topleft' src='<c:url value="/util/manageQueue.jsp"/>'/>
		</frameset>
	</frameset>
	<%
		}
	%>
</form>
