<%@page import="be.mxs.common.util.system.*,be.openclinic.adt.*"%>
<%
	out.print(ScreenHelper.getTranNoLink("service", Encounter.get(request.getParameter("encounteruid")).getServiceUID(), (String)session.getAttribute((String)session.getAttribute("activeProjectTitle")+"WebLanguage")));
%>