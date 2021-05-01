package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Base64;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;


import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.ObjectReference;
import be.openclinic.system.SH;
import net.admin.Service;

public class RemotePharmacy {
	public static Element getPharmacyOperations(String serviceStockUid) {
		ServiceStock stock = ServiceStock.get(serviceStockUid);
		if(stock!=null) {
			return getPharmacyOperations(SH.cs("remoteSyncId."+stock.getUid(),""),SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+stock.getUid(),""), -1)+"");
		}
		return null;
	}
	
	public static void getPharmacyOperations(ServiceStock stock, String userid) {
		Element messages = getPharmacyOperations(SH.cs("remoteSyncId."+stock.getUid(),""),SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+stock.getUid(),""), -1)+"");
		Iterator<Element> iMessages = messages.elementIterator("message");
		while(iMessages.hasNext()){
			RemotePharmacy.processPharmacyOperation(stock.getUid(), iMessages.next(), userid);
		}
	}
	
	public static boolean postInitializeRemoteStock(String serviceStockUid) {
		return false;
	}
	
	public static boolean initializeRemoteStock(String serviceStockUid) {
		ServiceStock stock = ServiceStock.get(serviceStockUid);
		if(stock!=null) {
			return initializeRemoteStock(stock);
		}
		return false;
	}
	
	public static boolean initializeRemoteStock(ServiceStock stock) {
		boolean bSuccess = false;
		try {
			Element message = DocumentHelper.createElement("message");
			message.addAttribute("objecttype", "initialize");
			Vector<ProductStock> productStocks = stock.getProductStocks();
			for(int n=0;n<productStocks.size();n++) {
				ProductStock productStock = productStocks.elementAt(n);
				message.add(productStock.getInitElement());
			}
			HttpClient client = new HttpClient();
			PostMethod method = new PostMethod(SH.cs("pharmaSyncServerURL",""));
			NameValuePair[] nvp = new NameValuePair[3];
			nvp[0]= new NameValuePair("uid",SH.cs("serviceStockUID."+stock.getUid(),""));
			nvp[1]= new NameValuePair("xml",message.asXML());
			nvp[2]= new NameValuePair("operation","store");
			method.setQueryString(nvp);
			String authStr = SH.cs("pharmaSyncServerURLUsername", "nil") + ":" + SH.cs("pharmaSyncServerURLPassword", "nil");
			String authEncoded = Base64.getEncoder().encodeToString(authStr.getBytes());
		    method.setRequestHeader("Authorization", "Basic "+authEncoded);
			try{
				int statusCode = client.executeMethod(method);
				String sResponse=method.getResponseBodyAsString();
				Document doc = org.dom4j.DocumentHelper.parseText(sResponse);
				Element eResponse = doc.getRootElement();
				if(eResponse.attributeValue("type").equalsIgnoreCase("pharmasync")){
					//Operation was succesfull
					bSuccess=true;
				}
				else if(eResponse.attributeValue("type").equalsIgnoreCase("error")){
					//Operation was NOT succesfull
				}
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return bSuccess;
	}
	
	public static Element getPharmacyOperations(String uid, String lastupdateid) {
		if(SH.cs("pharmaSyncServerURL","").length()==0) {
			return null;
		}
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(SH.cs("pharmaSyncServerURL",""));
		NameValuePair[] nvp = new NameValuePair[3];
		nvp[0]= new NameValuePair("uid",uid);
		nvp[1]= new NameValuePair("lastupdateid",lastupdateid);
		nvp[2]= new NameValuePair("operation","retrieve");
		method.setQueryString(nvp);
		String authStr = SH.cs("pharmaSyncServerURLUsername", "nil") + ":" + SH.cs("pharmaSyncServerURLPassword", "nil");
		String authEncoded = Base64.getEncoder().encodeToString(authStr.getBytes());
	    method.setRequestHeader("Authorization", "Basic "+authEncoded);
		try{
			int statusCode = client.executeMethod(method);
			String sResponse=method.getResponseBodyAsString();
			Document doc = org.dom4j.DocumentHelper.parseText(sResponse);
			return doc.getRootElement();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static int getLastPharmacyOperation() {
		if(SH.cs("pharmaSyncServerURL","").length()==0) {
			return -1;
		}
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(SH.cs("pharmaSyncServerURL",""));
		NameValuePair[] nvp = new NameValuePair[1];
		nvp[0]= new NameValuePair("operation","getlastid");
		method.setQueryString(nvp);
		String authStr = SH.cs("pharmaSyncServerURLUsername", "nil") + ":" + SH.cs("pharmaSyncServerURLPassword", "nil");
		String authEncoded = Base64.getEncoder().encodeToString(authStr.getBytes());
	    method.setRequestHeader("Authorization", "Basic "+authEncoded);
		try{
			int statusCode = client.executeMethod(method);
			String sResponse=method.getResponseBodyAsString();
			Document doc = org.dom4j.DocumentHelper.parseText(sResponse);
			return Integer.parseInt(doc.getRootElement().attributeValue("lastid"));
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public static Element getLastPharmacyOperationsUids(String lastupdateid) {
		if(SH.cs("pharmaSyncServerURL","").length()==0) {
			return null;
		}
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(SH.cs("pharmaSyncServerURL",""));
		NameValuePair[] nvp = new NameValuePair[2];
		nvp[0]= new NameValuePair("operation","getnewuids");
		nvp[1]= new NameValuePair("lastupdateid",lastupdateid);
		method.setQueryString(nvp);
		String authStr = SH.cs("pharmaSyncServerURLUsername", "nil") + ":" + SH.cs("pharmaSyncServerURLPassword", "nil");
		String authEncoded = Base64.getEncoder().encodeToString(authStr.getBytes());
	    method.setRequestHeader("Authorization", "Basic "+authEncoded);
		try{
			int statusCode = client.executeMethod(method);
			String sResponse=method.getResponseBodyAsString();
			Document doc = org.dom4j.DocumentHelper.parseText(sResponse);
			return doc.getRootElement();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static boolean processPharmacyOperation(String serviceStockUid, Element message, String updateuser) {
		boolean bSuccess = false;
		try {
			if(SH.cs("remoteSyncId."+serviceStockUid,"").length()>0 && message.attributeValue("objecttype").equalsIgnoreCase("operation")) {
				double quantity = Double.parseDouble(message.attributeValue("quantity"));
				String operationtype="medicationreceipt.remote";
				if(message.attributeValue("type").equalsIgnoreCase("remove")) {
					operationtype="medicationdelivery.remote";
				}
				String reference = "";
				if(message.element("reference")!=null) {
					reference = SH.c(message.element("reference").attributeValue("localoperationid"));
				}
				Element product = message.element("product");
				String code = SH.c(product.attributeValue("code"));
				String atccode = SH.c(product.attributeValue("atccode"));
				String rxnormcode = SH.c(product.attributeValue("rxnormcode"));
				String dose = SH.c(product.elementText("dose"));
				String name = SH.c(product.elementText("name"));
				String unit = SH.c(product.elementText("unit"));
				Element patient = message.element("patient");
				int packageunits=1;
				try {
					packageunits=Integer.parseInt(SH.c(product.elementText("packageunits")));
				} catch(Exception o) {}
				double unitprice=0;
				try {
					unitprice=Double.parseDouble(SH.c(product.elementText("unitprice")));
				} catch(Exception o) {}
				Product prod = null;
				if(code.length()>0) {
					Vector<Product> p = Product.findWithCode(code, "", "", "", "", "", "", "", "", "OC_PRODUCT_OBJECTID", "");
					if(p.size()==0) {
						//The product does not exist, so we must create it
						prod=new Product();
						prod.setUid("-1");
						prod.setAtccode(atccode);
						prod.setCode(code);
						prod.setCreateDateTime(new java.util.Date());
						prod.setDose(dose);
						prod.setName(name);
						prod.setPackageUnits(packageunits);
						prod.setRxnormcode(rxnormcode);
						prod.setUnit(unit);
						prod.setUnitPrice(unitprice);
						prod.setUpdateDateTime(new java.util.Date());
						prod.setUpdateUser(updateuser);
						prod.setVersion(1);
						prod.store();
					}
					else {
						prod=p.elementAt(0);
					}
					ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
					if(serviceStock!=null) {
						ProductStock productStock = serviceStock.getProductStock(prod.getUid());
						if(productStock==null) {
							//Add the product stock
							productStock = new ProductStock();
							productStock.setUid("-1");
							productStock.setBegin(new java.util.Date());
							productStock.setCreateDateTime(new java.util.Date());
							productStock.setLevel(0);
							productStock.setProductUid(prod.getUid());
							productStock.setServiceStockUid(serviceStockUid);
							productStock.setUpdateDateTime(new java.util.Date());
							productStock.setUpdateUser(updateuser);
							productStock.setVersion(1);
							productStock.store();
						}
						Batch batch = null;
						String batchuid="";
						String number = SH.c(message.element("batch").attributeValue("number"));
						String expiry = SH.c(message.element("batch").attributeValue("expiry"));
						String date = SH.c(message.element("batch").attributeValue("date"));
						if(number.length()>0) {
							batch = Batch.getByBatchNumber(productStock.getUid(), number);
							if(batch==null) {
								//We must create the batch
								batch = new Batch();
								batch.setUid("-1");
								batch.setBatchNumber(number);
								batch.setCreateDateTime(SH.parseDate(date));
								batch.setEnd(SH.parseDate(expiry));
								batch.setLevel(0);
								batch.setProductStockUid(productStock.getUid());
								batch.setUpdateDateTime(new java.util.Date());
								batch.setUpdateUser(updateuser);
								batch.setVersion(1);
								batch.store();
							}
							batchuid=batch.getUid();
						}
						//Now we have all data for storing the operation
						ProductStockOperation operation = new ProductStockOperation();
				        operation.setUid("-1");
				        operation.setDescription(operationtype);
				        operation.setBatchUid(batchuid);
				        operation.setDocumentUID("");
				        operation.setEncounterUID("");
				        operation.setComment("");
				        ObjectReference sourceDestination = new ObjectReference();
				        if(patient==null) {
					        sourceDestination.setObjectType("servicestock");
					        sourceDestination.setObjectUid(serviceStockUid);
				        }
				        else {
					        sourceDestination.setObjectType("remotepatient");
					        sourceDestination.setObjectUid(SH.c(patient.attributeValue("localid")));
					        operation.setComment(SH.c(patient.elementText("lastname")).toUpperCase()+", "+SH.capitalize(SH.c(patient.elementText("firstname")))+" - "+SH.c(patient.elementText("gender")).toUpperCase()+" - "+SH.c(patient.elementText("dateofbirth")));
					        //store the remote patient reference for this operation here
					        Connection conn = SH.getOpenClinicConnection();
					        PreparedStatement ps = conn.prepareStatement("delete from OC_REMOTEPATIENTBATCHDELIVERIES where OC_DELIVERY_BATCHNUMBER=? and"
					        		+ " OC_DELIVERY_OPERATIONUID=?");
					        ps.setString(1, number);
					        ps.setString(2, reference);
					        ps.execute();
					        ps.close();
					        ps=conn.prepareStatement("insert into OC_REMOTEPATIENTBATCHDELIVERIES(OC_DELIVERY_SERVERID,OC_DELIVERY_OBJECTID,"
					        		+ "OC_DELIVERY_BATCHNUMBER,OC_DELIVERY_BATCHEXPIRY,OC_DELIVERY_SITENAME,OC_DELIVERY_PATIENTDATA,"
					        		+ "OC_DELIVERY_OPERATIONUID,OC_DELIVERY_DATE,OC_DELIVERY_QUANTITY,OC_DELIVERY_PRODUCTUID,OC_DELIVERY_PHONE) values(?,?,?,?,?,?,?,?,?,?,?)");
					        ps.setInt(1, SH.getServerId());
					        ps.setInt(2, MedwanQuery.getInstance().getOpenclinicCounter("OC_REMOTEPATIENTBATCHDELIVERIES"));
					        ps.setString(3,number);
					        ps.setDate(4, SH.getSQLDate(expiry));
					        ps.setString(5, ServiceStock.get(serviceStockUid).getName());
					        ps.setString(6, "["+SH.c(patient.attributeValue("localid"))+"] "+operation.getComment());
					        ps.setString(7, reference);
					        ps.setDate(8, SH.getSQLDate(date));
					        ps.setInt(9, new Double(quantity).intValue());
					        ps.setString(10, prod.getUid());
					        ps.setString(11, SH.c(patient.elementText("telephone")));
					        ps.execute();
					        ps.close();
					        conn.close();
				        }
				        operation.setSourceDestination(sourceDestination);
				        operation.setDate(SH.parseDate(date));
				        operation.setProductStockUid(productStock.getUid());
				        operation.setUnitsChanged(new Double(quantity).intValue());
				        operation.setUpdateUser(updateuser);
				        operation.setValidated(1);
						operation.store(false,false);
					}
				}
				
				int updateid = Integer.parseInt(message.attributeValue("id"));
				if(updateid>SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), -1)) {
					MedwanQuery.getInstance().setConfigString("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), updateid+"");
				}
			}
			else if(SH.cs("remoteSyncId."+serviceStockUid,"").length()>0 && message.attributeValue("objecttype").equalsIgnoreCase("initialize")) {
				//Remove existing product stocks from the service stock
				Connection conn = SH.getOpenClinicConnection();
				PreparedStatement pst = conn.prepareStatement("delete from oc_productstocks where oc_stock_servicestockuid=?");
				pst.setString(1, serviceStockUid);
				pst.execute();
				pst.close();
				conn.close();
				Iterator<Element> iProductStocks = message.elementIterator("productstock");
				while(iProductStocks.hasNext()) {
					Element productStock = iProductStocks.next();
					String level = SH.c(productStock.attributeValue("level"));
					String minimumlevel = SH.c(productStock.attributeValue("minimumlevel"));
					String maximumlevel = SH.c(productStock.attributeValue("maximumlevel"));
					String orderlevel = SH.c(productStock.attributeValue("orderlevel"));
					Element product = productStock.element("product");
					if(product!=null) {
						String code = product.attributeValue("code");
						String atccode = SH.c(product.attributeValue("atccode"));
						String rxnormcode = SH.c(product.attributeValue("rxnormcode"));
						String dose = SH.c(product.elementText("dose"));
						String name = SH.c(product.elementText("name"));
						String unit = SH.c(product.elementText("unit"));
						int packageunits=1;
						try {
							packageunits=Integer.parseInt(SH.c(product.elementText("packageunits")));
						} catch(Exception o) {}
						double unitprice=0;
						try {
							unitprice=Double.parseDouble(SH.c(product.elementText("unitprice")));
						} catch(Exception o) {}
						Product prod=null;
						if(code.length()>0) {
							Vector<Product> p = Product.findWithCode(code, "", "", "", "", "", "", "", "", "OC_PRODUCT_OBJECTID", "");
							if(p.size()==0) {
								//The product does not exist, so we must create it
								prod=new Product();
								prod.setUid("-1");
								prod.setAtccode(atccode);
								prod.setCode(code);
								prod.setCreateDateTime(new java.util.Date());
								prod.setDose(dose);
								prod.setName(name);
								prod.setPackageUnits(packageunits);
								prod.setRxnormcode(rxnormcode);
								prod.setUnit(unit);
								prod.setUnitPrice(unitprice);
								prod.setUpdateDateTime(new java.util.Date());
								prod.setUpdateUser(updateuser);
								prod.setVersion(1);
								prod.store();
							}
							else {
								prod=p.elementAt(0);
							}
							//Add the product stock
							ProductStock ps = new ProductStock();
							ps.setUid("-1");
							ps.setBegin(new java.util.Date());
							ps.setCreateDateTime(new java.util.Date());
							ps.setLevel(0);
							try {
								ps.setMinimumLevel(Integer.parseInt(minimumlevel));
							}catch(Exception r) {}
							try {
								ps.setMaximumLevel(Integer.parseInt(maximumlevel));
							}catch(Exception r) {}
							try {
								ps.setOrderLevel(Integer.parseInt(orderlevel));
							}catch(Exception r) {}
							ps.setProductUid(prod.getUid());
							ps.setServiceStockUid(serviceStockUid);
							ps.setUpdateDateTime(new java.util.Date());
							ps.setUpdateUser(updateuser);
							ps.setVersion(1);
							ps.store();
							int nBatchedQuantity=0;
							Iterator<Element> iBatches = productStock.elementIterator("batch");
							while(iBatches.hasNext()) {
								Element batch = iBatches.next();
								String number = batch.attributeValue("number");
								String expiry = batch.attributeValue("expiry");
								String batchlevel = batch.attributeValue("level");
								if(number.length()>0) {
									Batch b = new Batch();
									b.setUid("-1");
									b.setBatchNumber(number);
									b.setCreateDateTime(new java.util.Date());
									b.setEnd(SH.parseDate(expiry));
									b.setLevel(Integer.parseInt(batchlevel));
									b.setProductStockUid(ps.getUid());
									b.setUpdateDateTime(new java.util.Date());
									b.setUpdateUser(updateuser);
									b.setVersion(1);
									b.setComment("");
									b.store();
									//Add productstockoperation here
									ProductStockOperation po =new ProductStockOperation();
									po.setBatchComment(b.getComment());
									po.setBatchEnd(b.getEnd());
									po.setBatchNumber(b.getBatchNumber());
									po.setBatchType(b.getType());
									po.setBatchUid(b.getUid());
									po.setComment("REMOTE INIT");
									po.setCreateDateTime(new java.util.Date());
									po.setDate(new java.util.Date());
									po.setDescription("medicationreceipt.4");
									po.setProductStockUid(ps.getUid());
									po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT"));
									po.setUid("-1");
									po.setUnitsChanged(Integer.parseInt(batchlevel));
									po.setUnitsReceived(Integer.parseInt(batchlevel));
									po.setUpdateDateTime(new java.util.Date());
									po.setUpdateUser(updateuser);
									po.setVersion(1);
									po.store(false,false);
									nBatchedQuantity+=Integer.parseInt(batchlevel);
								}
							}
							if(nBatchedQuantity<Integer.parseInt(level)) {
								ProductStockOperation po =new ProductStockOperation();
								po.setComment("REMOTE INIT UNBATCHED");
								po.setCreateDateTime(new java.util.Date());
								po.setDate(new java.util.Date());
								po.setDescription("medicationreceipt.4");
								po.setProductStockUid(ps.getUid());
								po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT UNBATCHED"));
								po.setUid("-1");
								po.setUnitsChanged(Integer.parseInt(level)-nBatchedQuantity);
								po.setUnitsReceived(Integer.parseInt(level)-nBatchedQuantity);
								po.setUpdateDateTime(new java.util.Date());
								po.setUpdateUser(updateuser);
								po.setVersion(1);
								po.store(false,false);
							}
						}
					}
				}
			}
			return true;
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		return bSuccess;
	}

}
