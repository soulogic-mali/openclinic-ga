<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.Asset"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
    String objectid = checkString(request.getParameter("objectid"));
    Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
    PreparedStatement ps = conn.prepareStatement("delete from arch_documents where arch_document_objectid=?");
    ps.setString(1,objectid);
    ps.execute();
    ps.close();
	conn.close();
       
%>
