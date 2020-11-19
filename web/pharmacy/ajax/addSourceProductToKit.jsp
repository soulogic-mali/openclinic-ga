<%@include file="/includes/validateUser.jsp"%>
<%
	String sEditTargetProductStockUid = SH.c(request.getParameter("EditTargetProductStockUid"));
	String sEditSourceProductStockUid = SH.c(request.getParameter("EditSourceProductStockUid"));
	String sEditSourceProductStockQuantity = SH.c(request.getParameter("EditSourceProductStockQuantity"));
	
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("insert into oc_productkits(OC_PRODUCTKIT_TARGETPRODUCTSTOCKUID,OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID,OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY) values(?,?,?)");
	ps.setString(1, sEditTargetProductStockUid);
	ps.setString(2, sEditSourceProductStockUid);
	ps.setInt(3,Integer.parseInt(sEditSourceProductStockQuantity));
	ps.execute();
	ps.close();
	conn.close();
%>