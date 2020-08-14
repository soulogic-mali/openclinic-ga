<%@page import="be.mxs.common.util.system.*,net.admin.*"%>
<%@page import="be.openclinic.assets.*"%>
<%
	String serverid = ScreenHelper.checkString(request.getParameter("serverid"));
	Asset.checkInAssetsForServerId(Integer.parseInt(serverid));
	out.println("<OK>");
%>