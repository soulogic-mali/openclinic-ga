<%@page import="be.openclinic.reporting.*,pe.gob.sis.*"%>
<%
	out.println(SUSALUD.getAffiliationInformation(9966,"20029").getNuControlST());
%>