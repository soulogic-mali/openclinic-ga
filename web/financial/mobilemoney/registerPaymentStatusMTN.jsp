<%@page import="be.openclinic.finance.PatientCredit"%>
<%@include file="/includes/validateUser.jsp"%>
<%
	String sPatientCreditUid=null;
	String status = SH.p(request,"status");
	if(status.length()==0){
		status="FAILED";
	}
	if(status.equalsIgnoreCase("SUCCESSFUL")){
		Connection conn= SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_momo where oc_momo_transactionid=?");
		ps.setString(1,SH.p(request,"transactionId"));
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			PatientCredit credit = new PatientCredit();
			credit.setCreateDateTime(new java.util.Date());
		    // set and store credit
		    credit.setDate(new java.util.Date());
		    try {
		    	credit.setInvoiceUid(SH.getServerId()+"."+Integer.parseInt(request.getParameter("invoiceUid")));
			    credit.setCategory("1");
		    }
		    catch(Exception e){
			    credit.setCategory("2");
		    }
		    credit.setAmount(rs.getDouble("oc_momo_amount"));
		    credit.setType("patient.payment");
		    try {
			    credit.setEncounterUid(Encounter.getActiveEncounter(activePatient.personid).getUid());
		    }
		    catch(Exception e){}
		    credit.setComment("MoMo transaction "+SH.p(request,"financialTransactionId")+" from "+SH.p(request,"telephone"));
		    credit.setUpdateDateTime(new java.util.Date());
		    credit.setUpdateUser(activeUser.userid);
		    credit.setCurrency(rs.getString("oc_momo_currency"));
		    credit.setPatientUid(rs.getString("oc_momo_patientuid"));
		    credit.store();
		    sPatientCreditUid=credit.getUid();
		}
		rs.close();
		ps.close();
		conn.close();
	}
	Connection conn= SH.getOpenClinicConnection();
	PreparedStatement ps = conn.prepareStatement("update oc_momo set oc_momo_status=?,oc_momo_financialtransactionid=?,oc_momo_patientcredituid=? where oc_momo_transactionid=?");
	ps.setString(1,status);
	ps.setString(2,SH.p(request,"financialTransactionId"));
	ps.setString(3,sPatientCreditUid);
	ps.setString(4,SH.p(request,"transactionId"));
	ps.execute();
	ps.close();
	conn.close();
%>