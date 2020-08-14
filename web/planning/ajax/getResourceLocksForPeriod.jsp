<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%@include file="/includes/helper.jsp" %>

<%
boolean bHasConflicts=false;
	try{
		String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
		String begin=ScreenHelper.checkString(request.getParameter("begin"));
		String end=ScreenHelper.checkString(request.getParameter("end"));
		String begintime=ScreenHelper.checkString(request.getParameter("begintime"));
		String endtime=ScreenHelper.checkString(request.getParameter("endtime"));
		java.util.Date dbegin = ScreenHelper.getSQLTime(begin+" "+begintime, "dd/MM/yyyy HH:mm");
		java.util.Date dend = ScreenHelper.getSQLTime(end+" "+endtime, "dd/MM/yyyy HH:mm");
		String sWebLanguage=request.getParameter("language");
%>
<table width='100%'>
	<tr class='admin'>
		<td colspan='6'><%=ScreenHelper.getTran(request,"web","reservationlocks.for",sWebLanguage) %>: <%=ScreenHelper.getTran(request,"planningresource", resourceuid, sWebLanguage)%></td>
	</tr>
	<tr>
		<td class='admin'/>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","begin",sWebLanguage) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","end",sWebLanguage) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","duration",sWebLanguage) %></td>
		<td class='admin'><%=ScreenHelper.getTran(request,"web","service",sWebLanguage) %></td>
	</tr>
<%
		Vector reservations = Reservation.getReservationLocksForResourceUid(resourceuid,ScreenHelper.getSQLTime(begin+" 00:00", "dd/MM/yyyy HH:mm"),ScreenHelper.getSQLTime(end+" 23:59", "dd/MM/yyyy HH:mm"));
		if(reservations.size()>0){
			for(int n=0;n<reservations.size();n++){
				String reservation = (String)reservations.elementAt(n);
				if(reservation.split(";").length==4){
					int reservationlockuid=Integer.parseInt(reservation.split(";")[0]);
					java.util.Date reservationbegin = new java.util.Date(Long.parseLong(reservation.split(";")[1]));
					java.util.Date reservationend = new java.util.Date(Long.parseLong(reservation.split(";")[2]));
					String reservationservice = reservation.split(";")[3];
					try{
						if((reservationbegin.before(dbegin) && !reservationend.after(dbegin))||(!reservationbegin.before(dend) && reservationend.after(dend))){
							out.println("<tr><td class='admin2'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteResourceLock("+reservationlockuid+");'/></td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationbegin)+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationend)+"</td><td class='admin2'>"+ScreenHelper.getDuration(reservationbegin,reservationend)+"</td><td class='admin2'>"+ScreenHelper.getTran(request,"service",reservationservice,sWebLanguage)+"</td></tr>");
						}
						else {
							out.println("<tr><td class='red'><img src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png' onclick='deleteResourceLock("+reservationlockuid+");'/></td><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationbegin)+"</td><td class='red'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(reservationend)+"</td><td class='red'>"+ScreenHelper.getDuration(reservationbegin,reservationend)+"</td><td class='red'>"+ScreenHelper.getTran(request,"service",reservationservice,sWebLanguage)+"</td></tr>");
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