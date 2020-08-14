<%@page import="java.util.*,
                be.mxs.common.util.system.HTMLEntities"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
    String sFindDistrict = checkString(request.getParameter("FindDistrict"));

    Vector vPosts = HealthStructure.getPosts(sFindDistrict);
    Collections.sort(vPosts);
 
    String sTmpPost, sPosts = "";
    for(int i=0; i<vPosts.size(); i++){
    	sTmpPost = (String)vPosts.elementAt(i);
    	sPosts+= "$"+checkString(sTmpPost);
    }
    
    out.print(sPosts);
%>
