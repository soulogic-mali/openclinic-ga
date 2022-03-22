<%@page import="be.openclinic.pharmacy.*,be.openclinic.medical.*,be.openclinic.finance.*"%>
<%@include file="/includes/validateUser.jsp"%>
<%@page errorPage="/includes/error.jsp"%>

<%
	String loadonly    = checkString(request.getParameter("loadonly")),
           drugbarcode = checkString(request.getParameter("DrugBarcode")),
           druguid = checkString(request.getParameter("DrugUid")),
           comment = checkString(request.getParameter("Comment")),
           prescriber = checkString(request.getParameter("prescriber")),
           encounteruid = checkString(request.getParameter("EncounterUid")),
           prescriptionUid = checkString(request.getParameter("EditPrescrUid")),
	       sQuantity   = checkString(request.getParameter("Quantity"));
	int quantity = 1;
	try{
		quantity = Integer.parseInt(sQuantity);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
	String servicestock = checkString(request.getParameter("ServiceStock"));
	String newPrescriptionUid="";
	Insurance insurance = Insurance.getDefaultInsuranceForPatient(activePatient.personid);
	
	

    /// DEBUG /////////////////////////////////////////////////////////////////////////////////////
    if(Debug.enabled){
    	Debug.println("\n******************** pharmacy/addDrugsOutBarcode.jsp ******************");
    	Debug.println("loadonly    : "+loadonly);
    	Debug.println("druguid : "+druguid);
    	Debug.println("drugbarcode : "+drugbarcode);
    	Debug.println("comment     : "+comment);
    	Debug.println("encounteruid: "+encounteruid);
    	Debug.println("servicestock: "+servicestock);
    	Debug.println("sQuantity   : "+sQuantity+"\n");
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////
	// search product
	ProductStock productstock = null;
    if(druguid.length()==0){
    	productstock= ProductStock.getByBarcode(drugbarcode,servicestock);
    }
    else{
    	Vector stocks =ProductStock.find(servicestock, druguid, "", "", "", "", "", "", "", "", "", "OC_STOCK_OBJECTID", "ASC");
    	if(stocks.size()>0){
    		productstock=(ProductStock)stocks.elementAt(0);
    	}
    }

    int reservedQuantity=0;
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	PreparedStatement ps = null;
	ResultSet rs = null;
	if(productstock!=null){
		ps = conn.prepareStatement("SELECT sum(OC_LIST_QUANTITY) reserved FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
	            " AND OC_LIST_PRODUCTSTOCKUID=?");
		ps.setString(1,activePatient.personid);
		ps.setString(2,productstock.getUid());
		rs = ps.executeQuery();
		if(rs.next()){
			reservedQuantity=rs.getInt("reserved");
		}
		rs.close();
		ps.close();
	}

	if(!servicestock.equalsIgnoreCase("-1") && loadonly.length()==0 && (servicestock.length()==0 || productstock==null)){
		out.print("{\"message\":\""+getTranNoLink("web","productstock.does.not.exist",sWebLanguage)+"\"}");
	}
	else if(!servicestock.equalsIgnoreCase("-1") && loadonly.length()==0 && productstock.getLevel()<(quantity+reservedQuantity)){
		out.print("{\"message\":\""+getTranNoLink("web","insufficient.stock",sWebLanguage)+"\"}");
	}
	else {
		// load-only

		if(loadonly.length()==0){
			if(prescriptionUid.equalsIgnoreCase("-1")){
				//In geval van een nieuw voorschrift gaan we een UID creëren en deze terugsturen
				Prescription prescription = new Prescription();
				prescription.setUid("-1");
				prescription.setPatientUid(activePatient.personid);
				prescription.setPrescriberUid(activeUser.userid);
				prescription.setProductUid(druguid);
				prescription.setTimeUnit("day");
				prescription.setTimeUnitCount(1);
				prescription.setUnitsPerTimeUnit(1);
				prescription.setRequiredPackages(0);
				prescription.setUpdateUser(activeUser.userid);
				prescription.store(false);
				newPrescriptionUid=prescription.getUid();
				prescriptionUid=prescription.getUid();
			}
			if(!servicestock.equalsIgnoreCase("-1")){
				// aflevering toevoegen aan oc_drugsoutlist
				String batchuid = "";
				Prescription prescription = Prescription.get(prescriptionUid);
				if(prescriptionUid!=null && prescriptionUid.length()>0 && prescription!=null){
					prescription.setRequiredPackages(quantity);
					quantity=new Double(prescription.getOpenQuantity()).intValue();
				}
				if(MedwanQuery.getInstance().getConfigInt("allowNegativeDrugOrderListQuantities",0)!=1){
					if(quantity<0){
						quantity=0;
					}
				}
	
				if(quantity!=0){
					int tofind = quantity;
					Vector batches = Batch.getActiveBatches(productstock.getUid());
					//Info: the active batches are ordered by expiry date, nearest expiry date first
					for(int n=0; n<batches.size(); n++){
						Batch batch = (Batch)batches.elementAt(n);
						int nBatchReserved = 0;
						ps = conn.prepareStatement("SELECT sum(OC_LIST_QUANTITY) reserved FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
		                        " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_PRESCRIPTIONUID=?");
						ps.setString(1,activePatient.personid);
						ps.setString(2,productstock.getUid());
						ps.setString(3,batch.getUid());
						ps.setString(4, prescriptionUid);
						rs = ps.executeQuery();
						
						if(rs.next()){
							nBatchReserved=rs.getInt("reserved");
						}
						rs.close();
						ps.close();
	
						if(batch.getLevel()>nBatchReserved){
							//The remaining quantity is more than the already reserved quantity
							//Update the batchrequest
							//Calculate the quantity that can be delivered from this batch
							int nToDeliver=0;
							if(batch.getLevel()-nBatchReserved>=tofind){
								nToDeliver=tofind;
							}
							else{
								nToDeliver=batch.getLevel()-nBatchReserved;
							}
	
							ps = conn.prepareStatement("SELECT * FROM OC_DRUGSOUTLIST WHERE OC_LIST_PATIENTUID=?"+
						                               " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=? and OC_LIST_PRESCRIPTIONUID=? and (OC_LIST_INVOICED is NULL OR OC_LIST_INVOICED=0)");
							ps.setString(1,activePatient.personid);
							ps.setString(2,productstock.getUid());
							ps.setString(3,batch.getUid());
							ps.setString(4,encounteruid);
							ps.setString(5, prescriptionUid);
							rs = ps.executeQuery();
							
							if(rs.next()){
								int serverid = rs.getInt("OC_LIST_SERVERID");
								int objectid = rs.getInt("OC_LIST_OBJECTID");
								rs.close();
								ps.close();
								//There already is a batch request, update the requested level
								//First copy to history
								ps=conn.prepareStatement("insert into OC_DRUGSOUTLISTHISTORY(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME)"+
														 " select OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME"+
														 " from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
								ps.setInt(1,serverid);
								ps.setInt(2,objectid);
								ps.execute();
								ps.close();
								ps = conn.prepareStatement("update OC_DRUGSOUTLIST set OC_LIST_QUANTITY=OC_LIST_QUANTITY+?,OC_LIST_VERSION=OC_LIST_VERSION+1,OC_LIST_UPDATETIME=?"+
								                           " where  OC_LIST_PATIENTUID=? AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=? and OC_LIST_PRESCRIPTIONUID=? and (OC_LIST_INVOICED is NULL OR OC_LIST_INVOICED=0)");
								ps.setInt(1,nToDeliver);
								ps.setString(2,activePatient.personid);
								ps.setString(3,productstock.getUid());
								ps.setString(4,batch.getUid());
								ps.setString(5,encounteruid);
								ps.setString(6, prescriptionUid);
								ps.setTimestamp(7,SH.getSQLTime());
								ps.execute();
								ps.close();
							}
							else{
								rs.close();
								ps.close();
								
								ps = conn.prepareStatement("insert into OC_DRUGSOUTLIST(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,"+
								                           "OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME) values(?,?,?,?,?,?,?,?,?,?,1,?)");
								ps.setInt(1,MedwanQuery.getInstance().getConfigInt("serverId"));
								ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("DRUGSOUT"));
								ps.setString(3,activePatient.personid);
								ps.setString(4,productstock.getUid());
								ps.setInt(5,nToDeliver);
								ps.setString(6,batch.getUid());
								ps.setString(7,comment);
								ps.setString(8,encounteruid);
								ps.setString(9, prescriptionUid);
								ps.setInt(10, prescriber.trim().length()==0?-1:Integer.parseInt(prescriber));
								ps.setTimestamp(11,SH.getSQLTime());
								ps.execute();
								ps.close();
							}
							tofind = tofind-nToDeliver;
						}
						if(tofind==0){
							break;
						}
					}
					
					if(tofind > 0){
						//There still is a quantity to deliver, but no more batches are available
						//Deliver the quantity from unbatched stock
						ps = conn.prepareStatement("select * from OC_DRUGSOUTLIST where OC_LIST_PATIENTUID=?"+
					                               " AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=? and OC_LIST_PRESCRIPTIONUID=? and (OC_LIST_INVOICED is NULL OR OC_LIST_INVOICED=0)");
						ps.setString(1,activePatient.personid);
						ps.setString(2,productstock.getUid());
						ps.setString(3,"");
						ps.setString(4,encounteruid);
						ps.setString(5, prescriptionUid);
						rs = ps.executeQuery();
						
						if(rs.next()){
							int serverid = rs.getInt("OC_LIST_SERVERID");
							int objectid = rs.getInt("OC_LIST_OBJECTID");
							rs.close();
							ps.close();
							//There already is a batch request, update the requested level
							//First copy to history
							ps=conn.prepareStatement("insert into OC_DRUGSOUTLISTHISTORY(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME)"+
													 " select OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME"+
													 " from OC_DRUGSOUTLIST where OC_LIST_SERVERID=? and OC_LIST_OBJECTID=?");
							ps.setInt(1,serverid);
							ps.setInt(2,objectid);
							ps.execute();
							ps.close();
							
							ps = conn.prepareStatement("update OC_DRUGSOUTLIST set OC_LIST_QUANTITY=OC_LIST_QUANTITY+?,OC_LIST_VERSION=OC_LIST_VERSION+1,OC_LIST_UPDATETIME=?"+
							                           " where OC_LIST_PATIENTUID=? AND OC_LIST_PRODUCTSTOCKUID=? and OC_LIST_BATCHUID=? and OC_LIST_ENCOUNTERUID=? and OC_LIST_PRESCRIPTIONUID=? and (OC_LIST_INVOICED is NULL OR OC_LIST_INVOICED=0)");
							ps.setInt(1,tofind);
							ps.setString(2,activePatient.personid);
							ps.setString(3,productstock.getUid());
							ps.setString(4,"");
							ps.setString(5,encounteruid);
							ps.setString(6, prescriptionUid);
							ps.setTimestamp(7,SH.getSQLTime());
							ps.execute();
							ps.close();
						}
						else{
							rs.close();
							ps.close();
							
							ps = conn.prepareStatement("insert into OC_DRUGSOUTLIST(OC_LIST_SERVERID,OC_LIST_OBJECTID,OC_LIST_PATIENTUID,"+
							                           " OC_LIST_PRODUCTSTOCKUID,OC_LIST_QUANTITY,OC_LIST_BATCHUID,OC_LIST_COMMENT,OC_LIST_ENCOUNTERUID,OC_LIST_PRESCRIPTIONUID,OC_LIST_PRESCRIBER,OC_LIST_VERSION,OC_LIST_UPDATETIME) values(?,?,?,?,?,?,?,?,?,?,1,?)");
							ps.setInt(1,MedwanQuery.getInstance().getConfigInt("serverId"));
							ps.setInt(2,MedwanQuery.getInstance().getOpenclinicCounter("DRUGSOUT"));
							ps.setString(3,activePatient.personid);
							ps.setString(4,productstock.getUid());
							ps.setInt(5,tofind);
							ps.setString(6,"");
							ps.setString(7,comment);
							ps.setString(8,encounteruid);
							ps.setString(9, prescriptionUid);
							ps.setInt(10, prescriber.trim().length()==0?-1:Integer.parseInt(prescriber));
							ps.setTimestamp(11,SH.getSQLTime());
							ps.execute();
							ps.close();
						}
					}
				}
			}
		}

		// lijst maken van oc_drugsoutlist producten in wacht voor patiënt
	    String drugs = "<table width='100%' class='list' cellpadding='0' cellspacing='1'>";
		
		ps = conn.prepareStatement("select * from oc_drugsoutlist where OC_LIST_PATIENTUID=? order by OC_LIST_PRODUCTSTOCKUID");
		ps.setString(1,activePatient.personid);
		rs = ps.executeQuery();
		int count = 0;
		double dPatient=0,dInsurer=0,dExtraInsurer=0;
		
		ProductStock stock;
		while(rs.next()){
			stock = ProductStock.get(rs.getString("OC_LIST_PRODUCTSTOCKUID"));

			if(stock!=null && stock.getProduct()!=null){
				int level = stock.getUnbatchedLevel();

				Batch batch = Batch.get(rs.getString("OC_LIST_BATCHUID"));
				String sBatch = "";
				String sExpires = "";
				if(batch!=null){
					sBatch = batch.getBatchNumber();
					level = batch.getLevel();
					sExpires = ScreenHelper.formatDate(batch.getEnd());
				}
				
				boolean bInvoiced=rs.getInt("OC_LIST_INVOICED")==1;

				// header
				if(count==0){
					drugs+= "<tr class='admin'>"+
				             "<td/>"+
							 "<td>ID</td>"+
				             "<td>"+getTran(request,"web","code",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","product",sWebLanguage)+"</td>"+
							 "<td>"+getTran(request,"web","quantity",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","batch",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","level",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","expires",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","comment",sWebLanguage)+"</td>"+
				             "<td>"+getTran(request,"web","encounter",sWebLanguage)+"</td>"+
							"</tr>";
				}
				count++;

				// one row
				String stocklabel="";
				if(!stock.getServiceStockUid().equalsIgnoreCase(servicestock)){
					stocklabel=" <font style='font-size: 8' color='darkgrey'>&nbsp;<img height='10' src='"+sCONTEXTPATH+"/_img/icons/icon_warning.gif'/>("+stock.getServiceStock().getName()+")</font>";
				}
				int nBatch=rs.getInt("OC_LIST_QUANTITY");
				 //Calculate costs for this drug. Only works with automatic invoicing activated.
				 double dPat=0;
				 Encounter encounter = Encounter.get(checkString(rs.getString("OC_LIST_ENCOUNTERUID")));
				 if(SH.c(stock.getProduct().getPrestationcode()).length()>0){
					 Prestation prestation = Prestation.get(stock.getProduct().getPrestationcode());
					 if(prestation!=null){
						 if(SH.c(insurance.getExtraInsurarUid()).length()==0){
							 dPat=nBatch*stock.getProduct().getPrestationquantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter(),encounter==null?"":encounter.getType());
							 dPatient+=dPat;
						 }
						 else{
							 dExtraInsurer+=nBatch*stock.getProduct().getPrestationquantity()*prestation.getPatientPrice(insurance, insurance.getInsuranceCategoryLetter(),encounter==null?"":encounter.getType());
						 }
						 dInsurer+=nBatch*stock.getProduct().getPrestationquantity()*prestation.getInsurarPrice(insurance, insurance.getInsuranceCategoryLetter(),encounter==null?"":encounter.getType());
					 }
				 }
				 String fontstyle=stock.getProduct().getPrestationcode().length()==0 || !stock.getProduct().isAutomaticInvoicing()?"color: white;background-color: red;font-size: 8;font-weight: bolder;text-decoration: line-through":"color: #606060;font-size: 8";
				 drugs+= "<tr>"+
				         "<td class='admin2'>"+
				         (activeUser.getAccessRight("fastdrugsprescription.delete")?
				          "<a href='javascript:doDelete(\\\""+rs.getInt("OC_LIST_SERVERID")+"."+rs.getInt("OC_LIST_OBJECTID")+"\\\");'>"+
				           "<img src='_img/icons/icon_delete.png' class='link' title='"+getTranNoLink("web","delete",sWebLanguage)+"'/></a>"
				          :"")+
				         "</td>"+
				         "<td class='admin2'>"+stock.getUid()+"</td>"+
				         "<td class='admin2'><b>"+stock.getProduct().getCode()+"</b></td>"+
				         "<td class='admin2'><b><span id='drugname."+stock.getUid()+"'>"+stock.getProduct().getName()+"<br><font style='"+fontstyle+"'>"+(SH.c(stock.getProduct().getRoute()).length()==0?"":"["+getTranNoLink("product.route",stock.getProduct().getRoute(),sWebLanguage)+"] ")+"["+SH.getPriceFormat(dPat)+" "+SH.cs("currency","EUR")+"]</font></span></b>"+stocklabel+"</td>"+
				         "<td class='admin2'><b>"+nBatch+(bInvoiced?" <img height='14px' src='"+sCONTEXTPATH+"/_img/icons/icon_money2.png'/>":"")+"</b></td>"+
				         "<td class='admin2'>"+sBatch+"</td>"+
				         "<td class='admin2'>"+level+(level<nBatch?" <NODELIVERY><img src='"+sCONTEXTPATH+"/_img/icons/icon_forbidden.png'/>":"")+"</td>"+
				         "<td class='admin2'>"+sExpires+"</td>"+
				         "<td class='admin2'><b>"+checkString(rs.getString("OC_LIST_COMMENT"))+"</b></td>"+
				         "<td class='admin2'>"+checkString(rs.getString("OC_LIST_ENCOUNTERUID"))+"</td>"+
				        "</tr>";
			}
		}
		rs.close();
		ps.close();
		conn.close();

		drugs+= "</table>";
		String drugsCost = "<table width='100%' cellpadding='5px'><tr style='vertical-align: middle'>";
		drugsCost+="<td>"+getTranNoLink("web","patient",sWebLanguage)+": <font style='color: red;font-size: 12px'>"+SH.getPriceFormat(dPatient)+" "+SH.cs("currency","EUR")+"</font></td>";
		drugsCost+="<td>"+getTranNoLink("web","insurar",sWebLanguage)+": <font style='font-size: 12px'>"+SH.getPriceFormat(dInsurer)+" "+SH.cs("currency","EUR")+"</font></td>";
		drugsCost+="<td>"+getTranNoLink("web","extrainsurar",sWebLanguage)+": <font style='font-size: 12px'>"+SH.getPriceFormat(dExtraInsurer)+" "+SH.cs("currency","EUR")+"</font></td>";
		drugsCost+="</tr></table>";
		
		out.print("{\"drugs\":\""+drugsCost+drugs+"\",\"newprescriptionuid\":\""+newPrescriptionUid+"\"}");
	}
%>