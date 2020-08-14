<%
	if(session.getAttribute("editmode")!=null && ((String)session.getAttribute("editmode")).equalsIgnoreCase("1")){
		session.setAttribute("editmode", "0");
		out.println(be.mxs.common.util.system.ScreenHelper.getTran(request,"web","off",request.getParameter("language")));
	}
	else{
		session.setAttribute("editmode", "1");
		out.println(be.mxs.common.util.system.ScreenHelper.getTran(request,"web","editon",request.getParameter("language")));
	}
%>