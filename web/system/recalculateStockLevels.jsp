<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"system.management","select",activeUser)%>
<%
	Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_PRODUCTSTOCKS");
	ResultSet rs = ps.executeQuery();
	while (rs.next()){
		ProductStock productStock = ProductStock.get(rs.getInt("OC_STOCK_SERVERID")+"."+rs.getInt("OC_STOCK_OBJECTID"));
		if(productStock!=null){
			int newlevel = productStock.getLevel(new java.util.Date());
			if(newlevel!=productStock.getLevel()){
				productStock.setLevel(newlevel);
				productStock.store();
			}
		}
	}
	rs.close();
	ps.close();
	ps = conn.prepareStatement("select * from OC_BATCHES");
	rs = ps.executeQuery();
	while (rs.next()){
		Batch batch = Batch.get(rs.getInt("OC_BATCH_SERVERID")+"."+rs.getInt("OC_BATCH_OBJECTID"));
		if(batch!=null){
			int newlevel = batch.getLevel(new java.util.Date());
			if(newlevel!=batch.getLevel()){
				batch.setLevel(newlevel);
				batch.store();
			}
		}
	}
	rs.close();
	ps.close();
	conn.close();
	out.println(getTran(request,"web","stocklevels.successfully.updated",sWebLanguage));
%>