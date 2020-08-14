<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*,java.text.*" %>
<%
	String resourceuid = ScreenHelper.checkString(request.getParameter("resourceuid"));
	String[] users = MedwanQuery.getInstance().getConfigString("resourceUsers."+resourceuid,"").split(";");
	String stbl="";
	for(int n=0;n<users.length;n++){
		if(users[n].length()>0){
			stbl+="<tr><td class='admin2' width='1%'><img src='_img/icons/icon_delete.png' onclick='deleteAuthorizedUser("+users[n]+")'/></td><td class='admin2'>"+User.getFullUserName(users[n])+"</td></tr>";
		}
	}
	if(stbl.length()>0){
		out.println("<table width='100%'>"+stbl+"</table>");
	}
%>