<%
	if(session.getAttribute("normsreport")==null || !((String)session.getAttribute("normsreport")).equalsIgnoreCase("done")){
		out.println("0");
	}
	else{
		session.removeAttribute("normsreport");
		out.println("<OK>");
	}
%>