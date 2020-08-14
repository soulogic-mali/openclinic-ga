<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String resourceuid = ScreenHelper.checkString(request.getParameter("resourceuid"));
		String begin = ScreenHelper.checkString(request.getParameter("begin"));
		String begintime = ScreenHelper.checkString(request.getParameter("begintime"));
		String end = ScreenHelper.checkString(request.getParameter("end"));
		String endtime = ScreenHelper.checkString(request.getParameter("endtime"));
		String userid = ScreenHelper.checkString(request.getParameter("userid"));
		String service = ScreenHelper.checkString(request.getParameter("service"));
		
		java.util.Date dbegin = null;
		try{
			dbegin = ScreenHelper.getSQLTime(begin+" "+begintime,"dd/MM/yyyy HH:mm");
		}
		catch(Exception e1){
			e1.printStackTrace();
		}
		java.util.Date dend = null;
		try{
			dend = ScreenHelper.getSQLTime(end+" "+endtime,"dd/MM/yyyy HH:mm");
		}
		catch(Exception e1){
			e1.printStackTrace();
		}
		if(service.length()>0 && dbegin!=null && dend!=null && resourceuid.length()>0){
			Reservation.saveReservationLock(resourceuid, dbegin, dend, service, userid);
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
