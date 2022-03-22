<%@page import="be.openclinic.pharmacy.*,be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>
<%
	String sMessage = "";
	//First make some checks and return an error message if they are not matched
	String sWicketUid = SH.p(request,"wicketuid");
	if(sWicketUid.length()==0){
		sMessage="error;"+getTranNoLink("web","nocashdeskselected",sWebLanguage);
	}
	else{
		session.setAttribute("defaultwicket",sWicketUid);
		Encounter activeEncounter = Encounter.getActiveEncounter(activePatient.personid);
		Insurance insurance = Insurance.getDefaultInsuranceForPatient(activePatient.personid);
		if(insurance==null){
			sMessage="error;"+getTranNoLink("web","noactiveinsuranceavailable",sWebLanguage);
		}
		else if(activeEncounter==null){
			sMessage="error;"+getTranNoLink("web","noactiveencounter",sWebLanguage);
		}
		else{
			PatientInvoice invoice = new PatientInvoice();
			invoice.setUid("-1");
			invoice.setCreateDateTime(new java.util.Date());
			invoice.setDate(new java.util.Date());
			invoice.setDebets(new Vector());
			invoice.setPatientUid(activePatient.personid);
			invoice.setStatus("closed");
			invoice.setUpdateDateTime(new java.util.Date());
			invoice.setUpdateUser(activeUser.userid);
			invoice.setVersion(1);
			//First register service deliveries for each drug in the waiting list
			Connection conn = SH.getOpenClinicConnection();
			PreparedStatement ps = conn.prepareStatement("select * from oc_drugsoutlist where OC_LIST_PATIENTUID=? order by OC_LIST_PRODUCTSTOCKUID");
			ps.setString(1,activePatient.personid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				int nQuantity=rs.getInt("OC_LIST_QUANTITY");
				ProductStock productStock = ProductStock.get(rs.getString("OC_LIST_PRODUCTSTOCKUID"));
				if(productStock==null || productStock.getProduct()==null || SH.c(productStock.getProduct().getPrestationcode()).length()==0 || !productStock.getProduct().isAutomaticInvoicing()){
					continue;
				}
				if(productStock.getLevel()<nQuantity){
					continue;
				}
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
				// Automatic invoicing should now have occurred. Add the debet to the invoice
				invoice.getDebets().add(operation.getDebet());
				// Delete product from waiting list
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
			//If at least one debet was stored, then store the invoice and create a payment
			if(invoice.getDebets().size()>0){
				invoice.setStatus("closed");
				invoice.store();
				PatientCredit credit = new PatientCredit();
				credit.setAmount(invoice.getPatientAmount());
				credit.setCategory("1");
				credit.setComment(getTranNoLink("web","automaticdrugdeliverypayment",sWebLanguage));
				credit.setCreateDateTime(new java.util.Date());
				credit.setCurrency(SH.cs("currency","EUR"));
				credit.setDate(new java.util.Date());
				credit.setEncounterUid(activeEncounter.getUid());
				credit.setInvoiceUid(invoice.getUid());
				credit.setPatientUid(activePatient.personid);
				credit.setType("patient.payment");
				credit.setUid("");
				credit.setUpdateDateTime(new java.util.Date());
				credit.setUpdateUser(activeUser.userid);
				credit.setVersion(1);
				credit.store();
				//Also store a cash desk operation
	            WicketCredit wicketCredit = new WicketCredit();
                wicketCredit.setWicketUID(sWicketUid);
                wicketCredit.setCreateDateTime(new java.util.Date());
                wicketCredit.setUserUID(Integer.parseInt(activeUser.userid));
                wicketCredit.setOperationDate(getSQLTime());
                wicketCredit.setOperationType("patient.payment");
                wicketCredit.setCategory("1");
                wicketCredit.setAmount(credit.getAmount());
                wicketCredit.setComment(activePatient.lastname+" "+activePatient.firstname+" - "+invoice.getInvoiceNumber());
                wicketCredit.setInvoiceUID(invoice.getUid());
                ObjectReference objRef = new ObjectReference();
                objRef.setObjectType("PatientCredit");
                objRef.setObjectUid(credit.getUid());
                wicketCredit.setReferenceObject(objRef);
                wicketCredit.setUpdateDateTime(getSQLTime());
                wicketCredit.setUpdateUser(activeUser.userid);
                wicketCredit.setCurrency(credit.getCurrency());
                wicketCredit.store();
				//Return the invoiceuid so it can be printed
				sMessage="invoice;"+invoice.getUid();
			}
			else{
				sMessage="error;"+getTranNoLink("web","nothinginvoiced",sWebLanguage);
			}
			conn.close();
		}
	}
%>
<%=sMessage%>