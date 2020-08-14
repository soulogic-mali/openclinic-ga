<%@page import="java.util.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sFindPost = checkString(request.getParameter("FindPost"));

    Vector vVillages = HealthStructure.getVillages(sFindPost);
    Collections.sort(vVillages);
 
    String sTmpVillage, sVillages = "";
    for(int i=0; i<vVillages.size(); i++){
    	sTmpVillage = (String)vVillages.elementAt(i);
    	sVillages+= "$"+checkString(sTmpVillage);
    }
    
    out.print(sVillages);
%>
