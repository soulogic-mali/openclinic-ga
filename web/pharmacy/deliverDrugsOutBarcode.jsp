<%@page import="be.openclinic.pharmacy.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String listuid = checkString(request.getParameter("listuid"));
	
	/// DEBUG /////////////////////////////////////////////////////////////////////////////////////
	if(Debug.enabled){
		Debug.println("\n****************** pharmacy/deliverDrugsOutBarcode.jsp *****************");
		Debug.println("listuid : "+listuid+"\n");
	}
	///////////////////////////////////////////////////////////////////////////////////////////////

    Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from oc_drugsoutlist where OC_LIST_PATIENTUID=?"+
                                                 " order by OC_LIST_PRODUCTSTOCKUID");
	ps.setString(1,activePatient.personid);
	ResultSet rs = ps.executeQuery();
	int count = 0;
	
	while(rs.next()){
		int nQuantity=rs.getInt("OC_LIST_QUANTITY");
		String sBatchUid=checkString(rs.getString("OC_LIST_BATCHUID"));
		if(sBatchUid.length()>0){
			Batch batch = Batch.get(sBatchUid);
			if(batch.getLevel()<nQuantity){
				continue;
			}
		}
		// Create stock operation
		ProductStockOperation operation = new ProductStockOperation();
		operation.setUid("-1");
		operation.setBatchUid(sBatchUid);
		operation.setDate(new java.util.Date()); // now
		operation.setDescription(MedwanQuery.getInstance().getConfigString("medicationDeliveryToPatientDescription","medicationdelivery.1"));
		operation.setProductStockUid(rs.getString("OC_LIST_PRODUCTSTOCKUID"));
		operation.setSourceDestination(new ObjectReference("patient",activePatient.personid));
		operation.setUnitsChanged(nQuantity);
		operation.setComment(checkString(rs.getString("OC_LIST_COMMENT")));
		operation.setUpdateDateTime(new java.util.Date());
		operation.setUpdateUser(activeUser.userid);
		operation.setVersion(1);
		operation.setPrescriptionUid(rs.getString("OC_LIST_PRESCRIPTIONUID"));
		operation.setEncounterUID(checkString(rs.getString("OC_LIST_ENCOUNTERUID")));
		
		operation.store();
		
		// Delete list
		//First copy to history
		PreparedStatement ps2=conn.prepareStatement("insert into OC_DRUGSOUTLISTHISTORY(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME)"+
								 " select OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME"+
								 " from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
		ps2.setInt(1,rs.getInt("OC_LIST_SERVERID"));
		ps2.setInt(2,rs.getInt("OC_LIST_OBJECTID"));
		ps2.execute();
		ps2.close();
		
		ps2 = conn.prepareStatement("delete from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
		ps2.setInt(1,rs.getInt("OC_LIST_SERVERID"));
		ps2.setInt(2,rs.getInt("OC_LIST_OBJECTID"));
		ps2.execute();
		ps2.close();
	}
	rs.close();
	ps.close();
	conn.close();
	
	out.print("{\"drugs\":\"\"}");
%>