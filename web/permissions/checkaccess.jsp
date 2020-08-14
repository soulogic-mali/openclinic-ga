<%@include file="/includes/helper.jsp"%><%@page errorPage="/includes/error.jsp"%><%
	String screen = SH.c(request.getParameter("screen"));
	String permission = SH.c(request.getParameter("permission"));
	String userid = SH.c(request.getParameter("userid"));
	if(checkPermission(screen,permission,User.get(Integer.parseInt(userid))).length()>0){
		request.getRequestDispatcher(sCONTEXTPATH+"/util/noaccess.jsp").forward(request, response);
		return;
	}
%>