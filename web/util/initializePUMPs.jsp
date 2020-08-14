<%@page import="be.openclinic.pharmacy.Product,
                java.text.DecimalFormat,
                be.openclinic.pharmacy.ProductSchema,
                be.openclinic.common.KeyValue,
                be.openclinic.finance.*,
                be.mxs.common.util.system.Pointer,
                java.util.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select oc_stock_productuid,sum(oc_stock_level) quantity,oc_product_unitprice"+
		" from oc_productstocks,oc_products where"+
		" oc_product_objectid=replace(oc_stock_productuid,'1.','') and oc_product_unitprice>0"+
		" group by oc_stock_productuid,oc_product_unitprice having sum(oc_stock_level)>0");
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String productuid=rs.getString("oc_stock_productuid");
		int quantity=rs.getInt("quantity");
		double price = rs.getDouble("oc_product_unitprice");
		Pointer.deleteLoosePointers("drugprice."+productuid+".");
		Pointer.storePointer("drugprice."+productuid+".0.0",quantity+";"+price);
	}
	rs.close();
	ps.close();
	conn.close();
%>