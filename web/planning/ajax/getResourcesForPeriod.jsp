<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%@include file="/includes/helper.jsp" %>

<%
boolean bHasConflicts=false;
	try{
		String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
		String excludeplanninguid=ScreenHelper.checkString(request.getParameter("excludeplanninguid"));
		String begin=ScreenHelper.checkString(request.getParameter("begin"));
		String end=ScreenHelper.checkString(request.getParameter("end"));
		String begintime=ScreenHelper.checkString(request.getParameter("begintime"));
		String endtime=ScreenHelper.checkString(request.getParameter("endtime"));
		java.util.Date dbegin = ScreenHelper.getSQLTime(begin+" "+begintime, "dd/MM/yyyy HH:mm");
		java.util.Date dend = ScreenHelper.getSQLTime(end+" "+endtime, "dd/MM/yyyy HH:mm");
		String activeservice=ScreenHelper.checkString(request.getParameter("activeservice"));
		
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='6'><%=ScreenHelper.getTran(request,"web","resourceavailability.for",request.getParameter("language")) %>: <%=ScreenHelper.getTran(request,"planningresource", resourceuid, request.getParameter("language"))%></td>
	</tr>
	<tr>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","begin",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","end",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","duration",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","user",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","patient",request.getParameter("language")) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","comment",request.getParameter("language")) %></td>
	</tr>
<%
		Vector reservations = Reservation.getReservationsForResourceUid(resourceuid,ScreenHelper.getSQLTime(begin+" 00:00", "dd/MM/yyyy HH:mm"),ScreenHelper.getSQLTime(end+" 23:59", "dd/MM/yyyy HH:mm"));
		if(reservations.size()>0){
			for(int n=0;n<reservations.size();n++){
				Reservation reservation = (Reservation)reservations.elementAt(n);
				if(reservation.getPlanning().getUser()!=null && !reservation.getPlanningUid().startsWith("0.") && !reservation.getPlanningUid().equalsIgnoreCase(excludeplanninguid)){
					try{
						if((reservation.getBegin().before(dbegin) && reservation.getEnd().before(dbegin))||(reservation.getBegin().after(dend) && reservation.getEnd().after(dend))){
							out.println("<tr><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='admin2'>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td><td class='admin2'><img height='12px' src='"+sCONTEXTPATH+"/_img/icons/icon_ok.gif'> "+(reservation.getPlanning().getUser()==null?"?":reservation.getPlanning().getUser().getFullName())+"</td><td class='admin2'>"+(reservation.getPlanning().getPatient()==null?"?":reservation.getPlanning().getPatient().getFullName())+"</td><td class='admin2'>"+ScreenHelper.checkString(reservation.getPlanning().getDescription())+"</td></tr>");
						}
						else {
							out.println("<tr><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='admin2'>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td><td class='admin2'><img height='12px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'> "+(reservation.getPlanning().getUser()==null?"?":reservation.getPlanning().getUser().getFullName())+"</td><td class='admin2'>"+(reservation.getPlanning().getPatient()==null?"?":reservation.getPlanning().getPatient().getFullName())+"</td><td class='admin2'>"+ScreenHelper.checkString(reservation.getPlanning().getDescription())+"</td></tr>");
							//out.println("<tr><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getBegin())+"</td><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservation.getEnd())+"</td><td class='red'>"+ScreenHelper.getDuration(reservation.getBegin(),reservation.getEnd())+"</td><td class='red'>"+(reservation.getPlanning().getUser()==null?"?":reservation.getPlanning().getUser().getFullName())+"</td><td class='red'>"+(reservation.getPlanning().getPatient()==null?"?":reservation.getPlanning().getPatient().getFullName())+"</td><td class='red'>"+ScreenHelper.checkString(reservation.getPlanning().getDescription())+"</td></tr>");
							bHasConflicts=true;
						}
					}
					catch(Exception e1){
						e1.printStackTrace();
					}
				}
			}
		}
		Vector locks = Reservation.getReservationLocksForResourceUid(resourceuid,ScreenHelper.getSQLTime(begin+" 00:00", "dd/MM/yyyy HH:mm"),ScreenHelper.getSQLTime(end+" 23:59", "dd/MM/yyyy HH:mm"));
		if(locks.size()>0){
			for(int n=0;n<locks.size();n++){
				String lock = (String)locks.elementAt(n);
				if(lock.split(";").length==4){
					java.util.Date reservationbegin = new java.util.Date(Long.parseLong(lock.split(";")[1]));
					java.util.Date reservationend = new java.util.Date(Long.parseLong(lock.split(";")[2]));
					String reservationservice = lock.split(";")[3];
					try{
						if(activeservice.startsWith(reservationservice) || (reservationbegin.before(dbegin) && !reservationend.after(dbegin))||(!reservationbegin.before(dend) && reservationend.after(dend))){
							out.println("<tr class='gray'><td>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationbegin)+"</td><td>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationend)+"</td><td>"+ScreenHelper.getDuration(reservationbegin,reservationend)+"</td><td colspan='3'><img height='12px' src='"+sCONTEXTPATH+"/_img/icons/icon_ok.gif'> "+ScreenHelper.getTran(request,"web","lock",request.getParameter("language"))+": "+ScreenHelper.getTran(request,"service",reservationservice,request.getParameter("language"))+"</td></tr>");
						}
						else {
							out.println("<tr class='gray'><td>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationbegin)+"</td><td>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationend)+"</td><td>"+ScreenHelper.getDuration(reservationbegin,reservationend)+"</td><td colspan='3'><img height='12px' src='"+sCONTEXTPATH+"/_img/icons/icon_error.gif'> "+ScreenHelper.getTran(request,"web","lock",request.getParameter("language"))+": "+ScreenHelper.getTran(request,"service",reservationservice,request.getParameter("language"))+"</td></tr>");
							//out.println("<tr><td class='adminred'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationbegin)+"</td><td class='adminred'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationend)+"</td><td class='adminred'>"+ScreenHelper.getDuration(reservationbegin,reservationend)+"</td><td class='adminred' colspan='3'>"+ScreenHelper.getTran(request,"web","lock",request.getParameter("language"))+": "+ScreenHelper.getTran(request,"service",reservationservice,request.getParameter("language"))+"</td></tr>");
							bHasConflicts=true;
						}
					}
					catch(Exception e1){
						e1.printStackTrace();
					}
				}
			}
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
</table>
<%
	if(bHasConflicts){
%>
<input type='hidden' name='conflict' id='conflict' value='1'/>
<%
	}
%>