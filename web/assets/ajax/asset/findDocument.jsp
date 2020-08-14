<%@page import="be.mxs.common.util.system.HTMLEntities,
                be.openclinic.assets.Asset"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>

<%
	String sFound="0";
    String udi = checkString(request.getParameter("udi"));
    Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
    PreparedStatement ps = conn.prepareStatement("select * from arch_documents where arch_document_udi=? and arch_document_storagename is not null");
    ps.setString(1,udi);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
    	sFound="1";
    }
    rs.close();
    ps.close();
	conn.close();
       
%>

{
  "found":"<%=sFound%>"
}