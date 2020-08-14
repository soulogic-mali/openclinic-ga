<%@page import="be.openclinic.finance.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sResult="<NOK>";
	String prestationuid=checkString(request.getParameter("prestationuid"));
	String activity=checkString(request.getParameter("activityname")).split("-")[0].trim()+" - "+checkString(request.getParameter("activityname")).replaceAll(checkString(request.getParameter("activityname")).split("-")[0]+"-","").trim();
	Prestation p = Prestation.get(prestationuid);
	
	if(p!=null && p.hasValidUid() && (p.getCode().toUpperCase()+" - "+p.getDescription().replaceAll("\\&","")).equalsIgnoreCase(activity)){
		sResult="<OK>";
	}
%>
<%=sResult%>