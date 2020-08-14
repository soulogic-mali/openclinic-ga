<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*,java.text.*" %>
<%
	String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
	String userid=ScreenHelper.checkString(request.getParameter("userid"));
	String[] users = MedwanQuery.getInstance().getConfigString("resourceUsers."+resourceuid,"").split(";");
	boolean bUserExists=false;
	for(int n=0;n<users.length;n++){
		if(users[n].equalsIgnoreCase(userid)){
			bUserExists=true;
			break;
		}
	}
	if(!bUserExists){
		MedwanQuery.getInstance().setConfigString("resourceUsers."+resourceuid, MedwanQuery.getInstance().getConfigString("resourceUsers."+resourceuid,"")+";"+userid);
	}

%>