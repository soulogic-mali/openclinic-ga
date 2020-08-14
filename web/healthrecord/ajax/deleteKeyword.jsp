<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String labeltype=request.getParameter("labeltype");
	String labelid=request.getParameter("labelid");
	Label.delete(labeltype, labelid);
	Hashtable labels = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
	labels = (Hashtable)labels.get(labeltype);
	labels.remove(labelid);
    //reloadSingleton(session);
%>