<%@page import="be.openclinic.pharmacy.ProductStock"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	StringBuffer sResult=new StringBuffer();
	String sEditTargetProductStockUid = SH.c(request.getParameter("EditTargetProductStockUid"));
	ProductStock targetStock = ProductStock.get(sEditTargetProductStockUid);
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select sum(OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY) OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY,OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID from oc_productkits where OC_PRODUCTKIT_TARGETPRODUCTSTOCKUID=? group by OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID order by oc_productkit_sourceproductstockuid");
	ps.setString(1, sEditTargetProductStockUid);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		ProductStock stock = ProductStock.get(rs.getString("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID"));
		int quantity = rs.getInt("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY");
		if(activeUser.getAccessRightNoSA("pharmacy.kits.edit") || targetStock.getLevel()==0){
			sResult.append("<tr><td width='1%'><img onclick='deleteKitProduct(\""+stock.getUid()+"\")' src='"+sCONTEXTPATH+"/_img/icons/icon_delete.png'/></td><td width='1%' nowrap>"+quantity+"</td><td>x <b>"+stock.getProduct().getName()+"</b> ["+stock.getServiceStock().getName()+"]</td></tr>");
		}
		else{
			sResult.append("<tr><td width='1%'></td><td width='1%' nowrap>"+quantity+"</td><td>x <b>"+stock.getProduct().getName()+"</b> ["+stock.getServiceStock().getName()+"]</td></tr>");
		}
	}
	rs.close();
	ps.close();
	conn.close();
	if(sResult.length()>0){
		out.println("<table width='100%'>"+sResult.toString()+"</table>");
	}
%>