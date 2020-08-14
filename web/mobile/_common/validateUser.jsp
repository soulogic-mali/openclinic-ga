<%@include file="/mobile/_common/helper.jsp"%>

<%
    User activeUser = null;
    AdminPerson activePatient = null;

	String sUriPage = request.getRequestURI();
	if(!sUriPage.endsWith("loggedOut.jsp") && !sUriPage.endsWith("sessionExpired.jsp") && !sUriPage.endsWith("login.jsp")){
		if(session==null || session.isNew()){
            response.sendRedirect(sCONTEXTPATH+"/mobileRelogin.do");
		}
		
		activeUser = (User)session.getAttribute("activeUser");	
		activePatient = (AdminPerson)session.getAttribute("activePatient");
	}
%>