<%@page import="be.mayele.MayeleAPI,org.json.*"%>

<%
	response.setHeader("Access-Control-Allow-Origin", "*");
%>
<%=MayeleAPI.process(request).toString()%>