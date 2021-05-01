<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<table width='100%'>
	<tr class='admin'><td colspan='4'><%=getTran(request,"web","hemovigilance",sWebLanguage) %></td></tr>
	<tr class='admin'>
		<td><%=getTran(request,"web","date",sWebLanguage) %></td>
		<td><%=getTran(request,"web","personid",sWebLanguage) %></td>
		<td><%=getTran(request,"web","receiver",sWebLanguage) %></td>
		<td><%=getTran(request,"web","site",sWebLanguage) %></td>
	</tr>
<%
	String pocketid = SH.c(request.getParameter("pocketid"));
	String begin = SH.c(request.getParameter("begin"));
	Connection conn = SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_hemovigilance where oc_hemovigilance_pocketnumber like ?");
	if(begin.length()>0){
		ps = conn.prepareStatement("select * from oc_hemovigilance where oc_hemovigilance_timestamp >= ?");
		ps.setTimestamp(1, SH.getSQLTimestamp(begin));
	}
	else{
		ps.setString(1,pocketid+"%");
	}
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		String uid= rs.getString("oc_hemovigilance_transactionuid");
		MedwanQuery.getInstance().getObjectCache().removeObject("transaction",uid);
		TransactionVO transactionVO = TransactionVO.get(uid);
		if(transactionVO!=null){
			out.println("<tr>");
			out.println("<td class='admin'><a href='javascript:showTransaction(\""+transactionVO.getServerId()+"\",\""+transactionVO.getTransactionId()+"\",\""+transactionVO.getPatient().personid+" - "+transactionVO.getPatient().getFullName()+" ("+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE")+")\")'><b>"+SH.formatDate(transactionVO.getUpdateTime())+"</b></a></td>");
			out.println("<td class='admin2'>"+transactionVO.getPatient().personid+" ("+transactionVO.getHealthrecordId()+")</td>");
			out.println("<td class='admin2'>"+transactionVO.getPatient().getFullName()+"</td>");
			out.println("<td class='admin2'>"+transactionVO.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_REFERRAL_SOURCESITE")+"</td>");
			out.println("</tr>");
		}
	}
	rs.close();
	ps.close();
	conn.close();
%>
</table>

<script>
	function showTransaction(serverid,transactionid,title){
		openPopup('healthrecord/showPopupTransaction.jsp&title='+title+'&be.mxs.healthrecord.transaction_id='+transactionid+'&be.mxs.healthrecord.server_id='+serverid);
	}
</script>
