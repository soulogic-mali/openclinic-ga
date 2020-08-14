<%@page import="be.openclinic.assets.Asset,
                be.mxs.common.util.system.HTMLEntities,
                java.util.*"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
   	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
   	PreparedStatement ps=null;
   	ResultSet rs=null;
    if(checkString(request.getParameter("nomenclature")).length()>0){
    	ps=conn.prepareStatement("select * from oc_defaultmaintenanceplans where oc_maintenanceplan_nomenclature=?");
    	ps.setString(1, request.getParameter("nomenclature"));
    	rs=ps.executeQuery();
    	if(rs.next()){
    		out.println("OK-200");
    	}
    }
    rs.close();
    ps.close();
    conn.close();
%>