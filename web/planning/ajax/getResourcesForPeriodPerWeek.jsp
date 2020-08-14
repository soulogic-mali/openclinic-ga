<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
		String begin=ScreenHelper.checkString(request.getParameter("begin"));
		Date dbegin = ScreenHelper.getSQLDate(begin);
		int mintime=7*12;
		int maxtime=18*12;
		long minute=60000;
		long hour=60*minute;
		long day=24*hour;
		Hashtable occupiedSegments = new Hashtable();
		Vector reservations = Reservation.getReservationsForResourceUid(resourceuid, dbegin, new java.util.Date(dbegin.getTime()+7*day-1));
		for(int n=0;n<reservations.size();n++){
			Reservation reservation = (Reservation)reservations.elementAt(n);
			if(!reservation.getPlanningUid().startsWith("0.")){
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getBegin()))*12<mintime){
					mintime=Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getBegin()))*12;
				}
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getEnd()))*12>maxtime){
					maxtime=Integer.parseInt(new SimpleDateFormat("HH").format(reservation.getEnd()))*12;
				}
				try{
					String username=ScreenHelper.getTran(request,"web","user",request.getParameter("language"))+": "+reservation.getPlanning().getUser().getFullName()+" | "+ScreenHelper.getTran(request,"web","hour",request.getParameter("language"))+": "+ new SimpleDateFormat("HH:mm").format(reservation.getBegin())+"-"+new SimpleDateFormat("HH:mm").format(reservation.getEnd());
					if(reservation.getPlanning().getPatientUID()!=null && reservation.getPlanning().getPatientUID().length()>0){
						username=ScreenHelper.getTran(request,"web","patient",request.getParameter("language"))+": "+reservation.getPlanning().getPatient().getFullName()+" | "+username;
					}
					if( reservation.getPlanning().getDescription()!=null && reservation.getPlanning().getDescription().length()>0){
						username=username+" | "+ScreenHelper.getTran(request,"web","comment",request.getParameter("language"))+": "+reservation.getPlanning().getDescription();
					}
					username+=";"+reservation.getPlanningUid();
					for(long i=reservation.getBegin().getTime();i<reservation.getEnd().getTime();i+=5*minute){
						occupiedSegments.put(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(i)),username);
					}
				}
				catch(Exception e){}
			}			
		}
		Vector locks=Reservation.getReservationLocksForResourceUid(resourceuid, dbegin, new java.util.Date(dbegin.getTime()+7*day-1));
		for(int n=0;n<locks.size();n++){
			String lock = (String)locks.elementAt(n);
			if(lock.split(";").length==4){
				java.util.Date reservationbegin = new java.util.Date(Long.parseLong(lock.split(";")[1]));
				java.util.Date reservationend = new java.util.Date(Long.parseLong(lock.split(";")[2]));
				String reservationservice = lock.split(";")[3];
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservationbegin))*12<mintime){
					mintime=Integer.parseInt(new SimpleDateFormat("HH").format(reservationbegin))*12;
				}
				if(Integer.parseInt(new SimpleDateFormat("HH").format(reservationend))*12>maxtime){
					maxtime=Integer.parseInt(new SimpleDateFormat("HH").format(reservationend))*12;
				}
				try{
					String servicename=ScreenHelper.getTran(request,"web","lock",request.getParameter("language"))+": "+ScreenHelper.getTran(request,"service",reservationservice,request.getParameter("language"))+" | "+ScreenHelper.getTran(request,"web","hour",request.getParameter("language"))+": "+ new SimpleDateFormat("HH:mm").format(reservationbegin)+"-"+new SimpleDateFormat("HH:mm").format(reservationend);
					servicename+=";0";
					for(long i=reservationbegin.getTime();i<reservationend.getTime();i+=5*minute){
						if(occupiedSegments.get(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(i)))==null){
							occupiedSegments.put(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(i)),servicename);
						}
					}
				}
				catch(Exception e){}
			}
		}		
		
%>
		<table width='100%' style="border-spacing: 1px 0;">
			<tr class='admin'>
				<td colspan='8'><%=ScreenHelper.getTran(request,"web","resourceavailability.for",request.getParameter("language")) %>: <%=ScreenHelper.getTran(request,"planningresource", resourceuid, request.getParameter("language"))%></td>
			</tr>
			<tr>
				<td class='admin' width='1%'><%=ScreenHelper.getTran(request,"web","hour",request.getParameter("language")) %></td>
				<% for(int n=0;n<7;n++){ %>
				<td class='admin'><%=ScreenHelper.formatDate(new java.util.Date(dbegin.getTime()+n*day)) %></td>
				<% } %>
			</tr>
			<% for(int n=mintime;n<maxtime;n++){ %>
				<tr>
					<% if(n%12==0){ %>
						<td valign='top' bgcolor='lightgray' rowspan='12'><%=n/12+":00" %></td>
					<% } %>
					<% for(int i=0;i<7;i++){ 
						String sUser=ScreenHelper.checkString((String)occupiedSegments.get(new SimpleDateFormat("yyyyMMddHHmm").format(new java.util.Date(dbegin.getTime()+i*day+n*5*minute))));	
					%>
						<td height='5' <%=sUser.split(";")[0].length()>0?"title='"+sUser.split(";")[0]+"' "+(sUser.split(";")[1].equalsIgnoreCase("0")?"":" onmouseover='this.style.cursor=\"hand\"' onmouseout='this.style.cursor=\"default\"' onclick='openResourceAppointment(\""+sUser.split(";")[1]+"\")'")+" bgcolor='"+(sUser.split(";")[1].equalsIgnoreCase("0")?"#FF9999":"lightgray")+"' style='{padding: 0px 0px 0px 0px}'":"" %>> </td>
					<% } %>
				</tr>
			<% } %>
		</table>
<%
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
