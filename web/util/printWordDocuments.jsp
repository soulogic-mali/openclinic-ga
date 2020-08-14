<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String transactionuid = checkString(request.getParameter("transactionuid"));
	if(request.getParameter("be.mxs.healthrecord.transaction_id")!=null && request.getParameter("be.mxs.healthrecord.server_id")!=null){
		transactionuid=request.getParameter("be.mxs.healthrecord.server_id")+"."+request.getParameter("be.mxs.healthrecord.transaction_id");
	}
%>
<form name='transactionForm' method='post'>
	<input type='hidden' name='action' id='action' value=''/>
	<table width='100%'>
		<tr class='admin'><td colspan='4'><%=getTran(request,"web","printworddocuments",sWebLanguage) %></td></tr>
		<%
			Connection conn = MedwanQuery.getInstance().getAdminConnection();
			PreparedStatement ps = conn.prepareStatement("select * from WordDocuments order by name");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				if((transactionuid.length()==0 && checkString(rs.getString("xml")).length()==0) || (transactionuid.length()>0 && checkString(rs.getString("xml")).length()>0)){
					String name=rs.getString("name");
					out.println("<tr><td class='admin'><a href='javascript:printWordDocument(\""+Base64.getEncoder().encodeToString(name.getBytes())+"\");'>"+name+"</a>");
				}
			}
			rs.close();
			ps.close();
		%>
	</table>
</form>
<script>
	function printWordDocument(name){
		window.open("<%=sCONTEXTPATH+ScreenHelper.customerInclude("util/printWordDocument.jsp",sAPPFULLDIR,sAPPDIR)%>?name="+name+"&transactionuid=<%=transactionuid%>&language=<%=sWebLanguage%>");
		window.close();
	}
	window.focus();
</script>
