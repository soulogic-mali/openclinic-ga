<%@page import="org.apache.commons.httpclient.*,org.apache.commons.httpclient.methods.*,java.io.*"%>
<%@include file="/includes/helper.jsp"%>
<%!
	void checkCounter(String name, int minvalue){
		Connection conn = SH.getOpenClinicConnection();
		try{
			if(MedwanQuery.getInstance().getOpenclinicCounterNoIncrement(name)<minvalue){
				MedwanQuery.getInstance().getOpenclinicCounter(name, minvalue-1);
			}
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
%>
<%
	String sResult="<response type='error' message='[0.0] Undefined error'/>";
	try{
		String objecttype=request.getParameter("objecttype");
		String xml=request.getParameter("xml");
		String updateuser=request.getParameter("updateuser");
		if(objecttype.equalsIgnoreCase("admin")){
			AdminPerson person = AdminPerson.fromXml(xml, true);
			person.updateuserid=updateuser;
			String oldid=person.personid;
			person.personid="";
			checkCounter("PersonID",Integer.parseInt(oldid));
			if(person.store()){
				sResult="<response type='admin' oldid='"+oldid+"' newid='"+person.personid+"'/>";
			}
		}
		else if(objecttype.equalsIgnoreCase("encounter")){
			Encounter encounter = Encounter.fromXml(xml);
			encounter.setUpdateUser(updateuser);
			String oldid=encounter.getObjectId()+"";
			encounter.setUid("");
			checkCounter("OC_ENCOUNTERS",Integer.parseInt(oldid));
			encounter.store();
			sResult="<response type='encounter' oldid='"+oldid+"' newid='"+encounter.getObjectId()+"'/>";		}
		else if(objecttype.equalsIgnoreCase("transaction")){
			TransactionVO transaction = TransactionVO.fromXml(xml);
			transaction.setUpdateUser(updateuser);
			String oldid=transaction.getTransactionId()+"";
			transaction.setTransactionId(-1);
			checkCounter("TransactionID",Integer.parseInt(oldid));
			MedwanQuery.getInstance().updateTransaction(MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()), transaction);
			sResult="<response type='transaction' oldid='"+oldid+"' newid='"+transaction.getTransactionId()+"'/>";		}
		else{
			sResult="<response type='error' message='[1.0] Undefined objecttype: "+objecttype+"'/>";
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
%>
<%=sResult %>
