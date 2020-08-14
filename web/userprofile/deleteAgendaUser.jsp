<%@include file="/includes/validateUser.jsp"%>
<%
	String userid = checkString(request.getParameter("userid"));
	String[] users = activeUser.getParameter("agenda_users").split(";");
	String newusers="";
	for(int n=0;n<users.length;n++){
		if(users[n].split("=").length>1){
			if(!userid.equalsIgnoreCase(users[n].split("=")[0])){
				newusers+=users[n]+";";
			}
		}
	}
	activeUser.setParameter("agenda_users",newusers);
	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	PreparedStatement ps = conn.prepareStatement("delete from userparameters where userid=? and parameter=?");
	ps.setInt(1,Integer.parseInt(activeUser.userid));
	ps.setString(2,"agenda_users");
	ps.execute();
	ps.close();
	ps = conn.prepareStatement("insert into userparameters(userid,parameter,value,updatetime,active) values(?,?,?,?,?)");
	ps.setInt(1,Integer.parseInt(activeUser.userid));
	ps.setString(2,"agenda_users");
	ps.setString(3,newusers);
	ps.setTimestamp(4,new Timestamp(new java.util.Date().getTime()));
	ps.setInt(5,1);
	ps.execute();
	ps.close();
%>