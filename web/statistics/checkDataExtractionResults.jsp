<%
	if(session.getAttribute("dataExtractResult")!=null && ((String)session.getAttribute("dataExtractResult")).length()>0){
		out.println("<OK>");
	}
%>