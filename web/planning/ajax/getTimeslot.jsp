<%@page import="be.openclinic.finance.*"%>
<%
	String uid = request.getParameter("uid");
	String start = request.getParameter("start");
	Prestation prestation = Prestation.get(uid);
	if(prestation!=null && prestation.getTimeslot()!=null && prestation.getTimeslot().length()>0){
		long minute = 60*1000;
		java.util.Date date = new java.text.SimpleDateFormat("HH:mm").parse(start);
		date = new java.util.Date(date.getTime()+Integer.parseInt(prestation.getTimeslot())*minute);
		out.print(prestation.getTimeslot()+":"+new java.text.SimpleDateFormat("HH:mm").format(date));
	}
	else{
		out.print("");
	}
%>