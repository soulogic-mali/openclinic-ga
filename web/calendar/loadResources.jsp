<%@page import="be.openclinic.adt.Reservation"%>
<%@ include file="/includes/validateUser.jsp" %>
<table width='100%'>
	<tr class='admin'>
		<td><%=getTran(request,"web","reservedresources",sWebLanguage) %></td>
	</tr>
<%
	String sId = checkString(request.getParameter("id"));
	Vector<Reservation> reservations = Reservation.getReservationsForPlanningUid(sId);
	for(int n=0;n<reservations.size();n++){
		Reservation reservation = reservations.elementAt(n);
		out.println("<tr>");
		out.println("<td class='admin2'><img style='vertical-align: middle' height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='removeResource(\""+reservation.getResourceUid()+"\",\""+sId+"\");'/> "+getTran(request,"calendarresource",reservation.getResourceUid(),sWebLanguage)+"</td>");
		out.println("</tr>");
	}
%>
</table>