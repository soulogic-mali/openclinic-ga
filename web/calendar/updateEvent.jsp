<%@page import="be.openclinic.adt.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%!
	private java.util.Date roundMinutes(java.util.Date date,int n){
		long minute = 60*1000;
		date = new java.util.Date(Math.round(date.getTime()/(n*minute))*n*minute);
		return date;
	}
%>
<%
	String sId = checkString(request.getParameter("id"));
	Planning appointment = Planning.get(sId);
	//First check if the user has the necessary accessrights
	boolean bHasRight = false;
	if(appointment.getUserUID().equalsIgnoreCase(activeUser.userid)){
		//The user can modify his own appointments
		bHasRight=true;
	}
	else{
		//Get allowed users
		User user = new User();
		user.initialize(Integer.parseInt(appointment.getUserUID()));
		if(user.userid.equalsIgnoreCase(activeUser.userid)){
			bHasRight=true;
		}
		else{
			String[] users = user.getParameter("agenda_users").split(";");
			for(int n=0;n<users.length;n++){
				if(users[n].split("=").length>1){
					if(activeUser.userid.equalsIgnoreCase(users[n].split("=")[0]) && users[n].split("=")[1].length()>0 && users[n].split("=")[1].contains("u")){
						bHasRight=true;
					}
				}
			}
		}
	}
	
	if(!bHasRight){
		%>
		{
			"error" : "noaccess"
		}
		<%
	}
	else {
		String[] sStart=request.getParameter("start").split("T");
		String[] sEnd=request.getParameter("end").split("T");
		SimpleDateFormat ISO8601DATEFORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
		java.util.Date dStart = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(sStart[0]+" "+sStart[1].substring(0,8));
		java.util.Date dEnd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(sEnd[0]+" "+sEnd[1].substring(0,8));
		if(appointment!=null){
			appointment.setPlannedDate(roundMinutes(dStart,5));
			appointment.setPlannedEndDate(roundMinutes(dEnd,5));
			appointment.store();
		}
	}
%>