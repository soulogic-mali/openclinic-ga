<%@page import="be.openclinic.pharmacy.ProductStockOperation"%>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String pocketid = SH.c(request.getParameter("pocketid"));
%>
<table width='100%'>
<%
	boolean bInit=false;
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_batchoperations,oc_batches where "+
			" (oc_batch_objectid=replace(oc_batchoperation_sourceuid,'"+SH.getServerId()+".','') or"+
			" oc_batch_objectid=replace(oc_batchoperation_destinationuid,'"+SH.getServerId()+".','')) and"+
			" oc_batch_number=? order by oc_batchoperation_updatetime,oc_batchoperation_productstockoperationuid");
	ps.setString(1,pocketid);
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		ProductStockOperation operation = ProductStockOperation.get(rs.getString("oc_batchoperation_productstockoperationuid"));
		if(!bInit){
			%>
			<tr class='admin'><td colspan='8'><%=getTran(request,"web","bloodpockethistory",sWebLanguage) %>&nbsp;&nbsp;&nbsp;#<%= pocketid %>&nbsp;&nbsp;&nbsp;[<%=operation.getProductStock().getProduct().getName() %>]</td></tr>
			<tr class='admin'>
				<td><%=getTran(request,"web","date",sWebLanguage) %></td>
				<td><%=getTran(request,"web","servicestock",sWebLanguage) %></td>
				<td><%=getTran(request,"web","type",sWebLanguage) %></td><td/>
				<td><%=getTran(request,"web","details",sWebLanguage) %></td>
				<td><%=getTran(request,"web","quantity",sWebLanguage) %></td>
				<td><%=getTran(request,"cnts","sourcedestination",sWebLanguage) %></td>
				<td><%=getTran(request,"web","user",sWebLanguage) %></td>
			</tr>
			<%
			bInit=true;
		}
		String sClass="admin2";
		if(rs.isLast()){
			sClass="admingreen";
		}
		out.println("<tr>");
		out.println("<td class='admin'>"+SH.formatDate(operation.getDate())+"</td>");
		out.println("<td class='"+sClass+"'>"+operation.getProductStock().getServiceStock().getName()+"</td>");
		out.println("<td class='"+sClass+"'>"+(operation.getDescription().contains("delivery")?getTran(request,"web","outgoing",sWebLanguage):(operation.getDescription().contains("receipt")?getTran(request,"web","incoming",sWebLanguage):"?"))+"</td>");
		out.println("<td class='"+sClass+"'>"+(operation.getDescription().contains("delivery")?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-right.png'> ":(operation.getDescription().contains("receipt")?"<img height='16px' style='vertical-align: middle' src='"+sCONTEXTPATH+"/_img/icons/mobile/arrow-left.png'> ":"?"))+"</td>");
		out.println("<td class='"+sClass+"'>"+(operation.getDescription().contains("delivery")?getTran(request,"productstockoperation.medicationdelivery",operation.getDescription(),sWebLanguage):operation.getDescription().contains("receipt")?getTran(request,"productstockoperation.medicationreceipt",operation.getDescription(),sWebLanguage):"")+"</td>");
		out.println("<td class='"+sClass+"'>"+operation.getUnitsChanged()+"</td>");
		out.println("<td class='"+sClass+"'>"+operation.getSourceDestinationName(sWebLanguage)+(SH.c(operation.getComment()).length()==0?"":" - "+operation.getComment())+"</td>");
		out.println("<td class='"+sClass+"'>"+User.getFullUserName(operation.getUpdateUser())+"</td>");
		out.println("</tr>");
	}
	rs.close();
	ps.close();
	conn.close();
%>


</table>