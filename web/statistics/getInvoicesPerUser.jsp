<%@page import="be.openclinic.finance.PatientInvoice"%>
<%@page import="java.util.*,
               java.sql.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%=checkPermission(out,"statistics","select",activeUser)%>


<%
	try{
	String sBegin = request.getParameter("begin");
	java.util.Date dBegin=new java.util.Date();
	try{
		dBegin=ScreenHelper.euDateFormat.parse(sBegin);
	}
	catch(Exception e){
		sBegin=ScreenHelper.euDateFormat.format(dBegin);
		e.printStackTrace();
	}
	String sEnd = request.getParameter("end");
	java.util.Date dEnd=new java.util.Date();
	try{
		dEnd=ScreenHelper.euDateFormat.parse(sEnd);
	}
	catch(Exception e){
		sEnd=ScreenHelper.euDateFormat.format(dEnd);
		e.printStackTrace();
	}
	
	String sUserid = checkString(request.getParameter("userid"));

%>
<form name='transactionForm' method='post'>
	<%=getTran(request,"web","from",sWebLanguage)+"&nbsp;"+writeDateField("begin","transactionForm",sBegin,sWebLanguage) %>&nbsp;
	<%=getTran(request,"web","to",sWebLanguage)+"&nbsp;"+writeDateField("end","transactionForm",sEnd,sWebLanguage) %> &nbsp;
	<select name='userid'>
		<option/>
		<%
			Vector users = User.searchUsers("", "");
			for (int n=0;n<users.size();n++){
				Hashtable user =(Hashtable)users.elementAt(n);
				out.println("<option value='"+user.get("userid")+"' "+(sUserid.equals(user.get("userid"))?"selected":"")+">"+user.get("lastname")+", "+user.get("firstname")+"</option>");
			}
		%>
	</select>&nbsp;
	<input type='submit' name='submit' value='<%=getTran(null,"web","find",sWebLanguage) %>'/>
</form>
<table width='800px'>
<%	
	if(request.getParameter("submit")!=null){
		String sSql = "select oc_debet_patientinvoiceuid,oc_patientinvoice_date,convert(replace(oc_debet_patientinvoiceuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".',''),decimal) invoiceuid,oc_debet_updateuid,sum(oc_debet_amount) patient,sum(oc_debet_insuraramount) insurar,sum(oc_debet_extrainsuraramount) extrainsurar"+
						" from oc_debets,oc_patientinvoices"+
						" where "+
						" oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigInt("serverId")+".'"+MedwanQuery.getInstance().concatSign()+"oc_patientinvoice_objectid"+
						" and oc_patientinvoice_date>=? and oc_patientinvoice_date<=?"+
						" and oc_debet_updateuid like '"+sUserid+"%'"+
						" group by oc_debet_patientinvoiceuid,oc_patientinvoice_date,oc_debet_updateuid,convert(replace(oc_debet_patientinvoiceuid,'1.',''),decimal)"+
						" order by oc_patientinvoice_date,convert(replace(oc_debet_patientinvoiceuid,'1.',''),decimal)";
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement(sSql);
		ps.setDate(1,new java.sql.Date(dBegin.getTime()));
		ps.setDate(2,new java.sql.Date(dEnd.getTime()));
		ResultSet rs = ps.executeQuery();
		String activeinvoice="";
		while(rs.next()){
			//First we lookup the invoice
			String invoiceuid=rs.getString("oc_debet_patientinvoiceuid");
			if(invoiceuid!=null && !invoiceuid.equalsIgnoreCase(activeinvoice)){
				if(activeinvoice.length()>0){
					out.println("</table></td></tr>");
				}
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				//We write the invoice data
				out.println("<tr class='admin' width='10%'><td>"+invoice.getUid()+"</td><td width='30%'>"+(invoice.getPatient()!=null?invoice.getPatient().getFullName()+" ("+invoice.getPatientUid()+")":"")+"</td><td width='20%'>"+(invoice.getDate()!=null?ScreenHelper.euDateFormat.format(invoice.getDate()):"")+"</td><td width='20%'>"+getTran(request,"finance.patientinvoice.status",invoice.getStatus(),sWebLanguage)+"</td><td width='20%'>"+getTran(request,"balance","balance",sWebLanguage)+": "+invoice.getBalance()+"</td></tr>");
				out.println("<tr><td colspan='5'><table width='100%'>");
				out.println("<tr><td width='20%'></td><td class='admin' width='20%'>"+getTran(request,"web","user",sWebLanguage)+"</td><td class='admin' width='20%'>"+getTran(request,"web","patient",sWebLanguage)+"</td><td class='admin' width='20%'>"+getTran(request,"web","insurar",sWebLanguage)+"</td><td class='admin' width='20%'>"+getTran(request,"web","extrainsurar",sWebLanguage)+"</td></tr>");
				activeinvoice=invoice.getUid();
			}
			if(invoiceuid!=null){
				//we write the user record
				out.println("<tr><td></td><td class='admin2'>"+MedwanQuery.getInstance().getUserName(rs.getInt("oc_debet_updateuid"))+"</td><td class='admin2'>"+rs.getDouble("patient")+"</td><td class='admin2'>"+rs.getDouble("insurar")+"</td><td class='admin2'>"+rs.getDouble("extrainsurar")+"</td></tr>");
			}
		}
		if(activeinvoice.length()>0){
			out.println("</table></td></tr>");
		}
		rs.close();
		ps.close();
		conn.close();
	}
}
catch(Exception ee){
	ee.printStackTrace();
}
%>
</table>