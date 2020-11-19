<%@include file="/includes/validateUser.jsp"%>
<%
	String sEditTargetProductStockUid = SH.c(request.getParameter("EditTargetProductStockUid"));
	String sEditSourceProductStockUid = SH.c(request.getParameter("EditSourceProductStockUid"));
	
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("delete from oc_productkits where OC_PRODUCTKIT_TARGETPRODUCTSTOCKUID=? and OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID=?");
	ps.setString(1, sEditTargetProductStockUid);
	ps.setString(2, sEditSourceProductStockUid);
	ps.execute();
	ps.close();
	conn.close();
%>