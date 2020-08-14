<%
	if(request.getParameter("submitButton")!=null){
		out.println("The patient name is: "+request.getParameter("patientname"));
	}
%>