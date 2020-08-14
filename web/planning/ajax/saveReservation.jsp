<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String planninguid = ScreenHelper.checkString(request.getParameter("planninguid"));
		String resourceuid = ScreenHelper.checkString(request.getParameter("resourceuid"));
		String begin = ScreenHelper.checkString(request.getParameter("begin"));
		String begintime = ScreenHelper.checkString(request.getParameter("begintime"));
		String end = ScreenHelper.checkString(request.getParameter("end"));
		String endtime = ScreenHelper.checkString(request.getParameter("endtime"));
		String userid = ScreenHelper.checkString(request.getParameter("userid"));
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
		Reservation reservation = new Reservation();
		if(planninguid!=null && planninguid.split("\\.").length==2){
			reservation=Reservation.get(planninguid);
		}
		reservation.setPlanningUid(planninguid);
		reservation.setResourceUid(resourceuid);
		reservation.setBegin(dbegin);
		reservation.setEnd(dend);
		reservation.setUpdateUser(userid);
		reservation.setUpdateDateTime(new java.util.Date());
		reservation.setCreateDateTime(new java.util.Date());
		reservation.store();
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
