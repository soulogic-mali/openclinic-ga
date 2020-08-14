<%@include file="/includes/helper.jsp" %>
<%@include file="/includes/SingletonContainer.jsp"%>

<%
	if(request.getParameter("autologin")!=null){
		session.setAttribute("activeUser",null);
		//autoLogin(request.getParameter("autologin").split(";")[0],request.getParameter("autologin").split(";")[1],request);
		User activeUser = new User();
		Connection ad_conn=MedwanQuery.getInstance().getAdminConnection();
		boolean bSuccess = activeUser.initialize(ad_conn, request.getParameter("autologin").split(";")[0],activeUser.encrypt(request.getParameter("autologin").split(";")[1]));
		ad_conn.close();
		if(bSuccess){
			session.setAttribute("activeUser",activeUser);
			reloadSingleton(session);
	        session.setAttribute(sAPPTITLE + "WebLanguage", activeUser.person.language);
		}
		else{
			out.println("<script>window.location.href='"+sCONTEXTPATH+"';</script>");
			out.flush();
		}
	}
	else{
		session.setAttribute("activeUser",null);
		out.println("<script>window.location.href='"+sCONTEXTPATH+"';</script>");
		out.flush();
	}
    Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
    if(langHashtable == null || langHashtable.size()==0){
        reloadSingleton(request.getSession());
    }
    MedwanQuery.getInstance().reloadConfigValues();
%>
<script>
	window.location.href='<%=sCONTEXTPATH+"/main.do?Page=assets/manage_assets.jsp"%>';
</script>