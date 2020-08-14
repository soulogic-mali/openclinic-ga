<%@ page import="be.openclinic.finance.*,be.openclinic.adt.Encounter,java.text.*,be.mxs.common.util.system.*" %>
<%@page errorPage="/includes/error.jsp"%>
<%@include file="/includes/validateUser.jsp"%>
<table width='100%'>
	<tr class='admin'><td  colspan='3'><%=getTran(request,"web","invoicehistory",sWebLanguage) %></td></tr>
<%
	String invoiceuid=checkString(request.getParameter("invoiceuid"));
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_patientinvoices_history where oc_patientinvoice_objectid=? order by oc_patientinvoice_version");
	ps.setInt(1,Integer.parseInt(invoiceuid));
	ResultSet rs = ps.executeQuery();
	while(rs.next()){
		out.println("<tr><td class='admin'>"+rs.getInt("oc_patientinvoice_version")+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("oc_patientinvoice_updatetime"))+"</td><td class='admin2'>"+User.getFullUserName(rs.getString("oc_patientinvoice_updateuid"))+"</td></tr>");
	}
	rs.close();
	ps.close();
	conn.close();
	PatientInvoice invoice = PatientInvoice.get(MedwanQuery.getInstance().getConfigString("serverId")+"."+invoiceuid);
	out.println("<tr><td class='admin'>"+invoice.getVersion()+"</td><td class='admin2'>"+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(invoice.getUpdateDateTime())+"</td><td class='admin2'>"+User.getFullUserName(invoice.getUpdateUser())+"</td></tr>");
%>

</table>