<%@page import="be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	if(SH.ci("patientInvoiceReferenceCanOnlyBeUsedOnce",1)==1){
		String reference = SH.p(request,"reference");
		Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_patientinvoices where oc_patientinvoice_comment=?");
		ps.setString(1,reference);
		ResultSet rs =ps.executeQuery();
		if(rs.next()){
			out.println("<EXISTS>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
%>