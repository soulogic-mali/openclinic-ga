<%@page import="be.openclinic.pharmacy.Batch"%>
<%@page import="be.openclinic.pharmacy.BatchOperation"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%' cellpadding='0' cellspacing='0'>
	<%
		String giftid = SH.c(request.getParameter("giftid"));
		boolean bFound=false;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("SELECT * FROM OC_BATCHES where OC_BATCH_NUMBER like ?");
		ps.setString(1,giftid+".%");
		boolean bInit=false;
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			Batch batch = Batch.get(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID"));
			if(batch!=null){
				Vector operations = Batch.getBatchOperations(batch.getUid(), sWebLanguage);
				for(int n=0;n<operations.size();n++){
					BatchOperation operation = (BatchOperation)operations.elementAt(n);
					if(operation.getType().equalsIgnoreCase("receipt") && SH.c(operation.getProductStockOperation().getReceiveComment()).equalsIgnoreCase("BloodBank Production")){
						if(operation.getProductStockOperation().getProductStock()!=null && operation.getProductStockOperation().getProductStock().getProduct()!=null){
							if(!bInit){
								bInit=true;
								out.println("<tr>");
								out.println("<td class='admin'>"+getTran(request,"web","date",sWebLanguage)+"</td>");
								out.println("<td class='admin'>"+getTran(request,"web","servicestock",sWebLanguage)+"</td>");
								out.println("<td class='admin'>"+getTran(request,"web","product",sWebLanguage)+"</td>");
								out.println("<td class='admin'>"+getTran(request,"web","transferred",sWebLanguage)+" ("+getTran(request,"web","stocklevel",sWebLanguage)+")</td>");
								out.println("<td class='admin'>"+getTran(request,"web","expires",sWebLanguage)+"</td>");
								out.println("</tr>");
							}
							String sClass="admin2";
							bFound=true;
							if(operation.getProductStockOperation().getBatchEnd().before(new java.util.Date())){
								sClass="adminred";
							}
							out.println("<tr>");
							out.println("<td class='admin2'>"+SH.formatDate(operation.getProductStockOperation().getDate())+"</td>");
							out.println("<td class='admin2' width='1%' nowrap><b>"+operation.getProductStockOperation().getProductStock().getServiceStock().getName()+"</b>&nbsp;</td>");
							out.println("<td class='admin2'>"+operation.getProductStockOperation().getProductStock().getProduct().getName()+"</td>");
							out.println("<td class='admin2'><b>"+operation.getQuantity()+"</b> (<i>"+batch.getLevel()+"</i>)</td>");
							out.println("<td class='"+sClass+"'>"+operation.getProductStockOperation().getBatchEnd()+"</td>");
							out.println("</tr>");
						}
					}
				}
			}
		}
		rs.close();
		ps.close();
		conn.close();
		if(!bFound){
			%>
			<tr><td class='admin2'><%=getTran(request,"web","noproductsstored",sWebLanguage)%></td></tr>
			<%
		}
	%>
</table>