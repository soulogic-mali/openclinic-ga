<%
	if(!new java.util.Date().before(new java.text.SimpleDateFormat("dd/MM/yyyy").parse(be.openclinic.system.SH.cs("minimumSystemDate","01/01/2021")))){
		out.println("<OK>");
	}
%>