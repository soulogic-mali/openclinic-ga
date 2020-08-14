<%@ page import="be.openclinic.adt.*,java.util.*,be.mxs.common.util.system.*,net.admin.*,be.mxs.common.util.db.*,java.text.*" %>
<%
	String resourceuid=ScreenHelper.checkString(request.getParameter("resourceuid"));
	String userid=ScreenHelper.checkString(request.getParameter("userid"));
	MedwanQuery.getInstance().setConfigString("resourceUsers."+resourceuid, MedwanQuery.getInstance().getConfigString("resourceUsers."+resourceuid,"").replaceAll(";"+userid,""));
%>