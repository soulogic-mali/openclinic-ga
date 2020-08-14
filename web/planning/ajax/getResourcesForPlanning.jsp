<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String planninguid=ScreenHelper.checkString(request.getParameter("planninguid"));
		if(planninguid.length()==0){
			planninguid=ScreenHelper.checkString(request.getParameter("tempplanninguid"));
		}
		Vector reservations = Reservation.getReservationsForPlanningUid(planninguid);
		if(reservations.size()>0){
			%>
			<table width='100%'>
				<tr class='admin'>
					<%
						if(request.getParameter("delete")!=null && request.getParameter("delete").equalsIgnoreCase("yes")){
					%>
						<td id='imgtdh' width='1%' nowrap></td>
					<%
						}
					%>
					<td width='50%'><%=ScreenHelper.getTran(request,"web","resource",request.getParameter("language")) %></td>
					<td><%=ScreenHelper.getTran(request,"web","begin",request.getParameter("language")) %></td>
					<td><%=ScreenHelper.getTran(request,"web","end",request.getParameter("language")) %></td>
					<td><%=ScreenHelper.getTran(request,"web","duration",request.getParameter("language")) %></td>
				</tr>
			<%
			for(int n=0;n<reservations.size();n++){
				Reservation reservation = (Reservation)reservations.elementAt(n);
				try{
					out.println("<tr>"+(request.getParameter("delete")!=null && request.getParameter("delete").equalsIgnoreCase("yes")?"<td class='admin' id='imgtd"+n+"'><img src='_img/icons/icon_delete.png' onclick='deleteResource(\""+reservation.getUid()+"\")'/></td>":"")+"<td class='admin'>"+ScreenHelper.getTran(request,"planningresource", reservation.getResourceUid(), request.getParameter("language"))+"</td><td class='admin2' nowrap>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='admin2' nowrap>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='admin2' nowrap>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td></tr>");
				}
				catch(Exception e1){
					e1.printStackTrace();
				}
			}
			%>
			</table>
			<%
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
