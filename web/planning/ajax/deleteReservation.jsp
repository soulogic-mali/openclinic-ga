<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,java.text.*" %>
<%
	try{
		String uid = ScreenHelper.checkString(request.getParameter("uid"));
		Reservation.delete(uid);
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
