package be.openclinic.pharmacy;

import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.util.EntityUtils;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;


import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.openclinic.common.ObjectReference;
import be.openclinic.system.OCHttpClient;
import be.openclinic.system.SH;
import net.admin.Service;

public class RemotePharmacy {
	public static final int ERROR_FAILED_INITIALIZATION_EXISTING_OPERATIONS = 1;
	public static final int INFO_INITIALIZATION_PERFORMED = 2;
	public static final int INFO_NEW_PRODUCT_CREATED = 3;
	public static final int INFO_NEW_PRODUCTSTOCK_CREATED = 4;
	public static final int INFO_NEW_BATCH_CREATED = 5;
	public static final int INFO_NEW_OPERATION_CREATED = 6;
	public static final int INFO_INITIALIZATION_CORRECTION_PERFORMED = 7;
	public static final int INFO_NEW_BATCHOPERATION_CREATED = 8;
	
	public static void log(int error, String serviceStockUid) {
		log(error,serviceStockUid,"");
	}
	
	public static void log(int error, String serviceStockUid, String comment) {
		Connection conn = SH.getOpenClinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("insert into oc_pharmasynclogs(oc_error_code,oc_error_servicestockuid,oc_error_updatetime,oc_error_comment,oc_error_id) values(?,?,?,?,?)");
			ps.setInt(1, error);
			ps.setString(2, serviceStockUid);
			ps.setTimestamp(3, SH.getSQLTime());
			ps.setString(4, comment);
			ps.setInt(5, MedwanQuery.getInstance().getOpenclinicCounter("PHARMASYNCLOGS"));
			ps.execute();
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
	
	public static Element getPharmacyOperations(String serviceStockUid) {
		ServiceStock stock = ServiceStock.get(serviceStockUid);
		if(stock!=null) {
			return getPharmacyOperations(SH.cs("remoteSyncId."+stock.getUid(),""),SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+stock.getUid(),""), -1)+"");
		}
		return null;
	}
	
	public static void getPharmacyOperations(ServiceStock stock, String userid) {
		Debug.println("Getting remote operations from "+SH.cs("remoteSyncId."+stock.getUid(),"")+ " for service stock "+stock.getUid());
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
			OCHttpClient oc_client = new OCHttpClient();
			oc_client.addStringParam("uid", SH.cs("serviceStockUID."+stock.getUid(),""));
			oc_client.addStringParam("xml",message.asXML());
			oc_client.addStringParam("operation","store");
			CloseableHttpResponse resp = oc_client.postAuthenticated(SH.cs("pharmaSyncServerURL",""),SH.cs("pharmaSyncServerURLUsername", "nil"), SH.cs("pharmaSyncServerURLPassword", "nil"));
			HttpEntity entity = resp.getEntity();
		    if(entity!=null){
		    	bSuccess= true;
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
		Debug.println("Requesting messages from "+SH.cs("pharmaSyncServerURL","")+" sent by "+uid+" after "+lastupdateid);
		OCHttpClient oc_client = new OCHttpClient();
		oc_client.addStringParam("uid",uid);
		oc_client.addStringParam("lastupdateid",lastupdateid);
		oc_client.addStringParam("operation","retrieve");
		try {
			CloseableHttpResponse resp = oc_client.postAuthenticated(SH.cs("pharmaSyncServerURL",""),SH.cs("pharmaSyncServerURLUsername", "nil"), SH.cs("pharmaSyncServerURLPassword", "nil"));
			HttpEntity entity = resp.getEntity();
		    if(entity!=null){
		    	try {
			    	Document doc = org.dom4j.DocumentHelper.parseText(EntityUtils.toString(entity));
			    	return doc.getRootElement();
				}
				catch(Exception e) {
					e.printStackTrace();
				}
		    }
		}
		catch(Exception x) {
			x.printStackTrace();
		}

		return null;
	}
	
	public static int getLastPharmacyOperation() {
		if(SH.cs("pharmaSyncServerURL","").length()==0) {
			return -1;
		}
		OCHttpClient oc_client = new OCHttpClient();
		oc_client.addStringParam("operation","getlastid");
		try {
			CloseableHttpResponse resp = oc_client.postAuthenticated(SH.cs("pharmaSyncServerURL",""),SH.cs("pharmaSyncServerURLUsername", "nil"), SH.cs("pharmaSyncServerURLPassword", "nil"));
			HttpEntity entity = resp.getEntity();
		    if(entity!=null){
		    	try {
			    	Document doc = org.dom4j.DocumentHelper.parseText(EntityUtils.toString(entity));
			    	if(doc!=null && doc.getRootElement()!=null && SH.c(doc.getRootElement().attributeValue("lastid")).length()>0) {
			    		return Integer.parseInt(doc.getRootElement().attributeValue("lastid"));
			    	}
			    	else {
			    		Debug.println("Erroneous response from "+SH.cs("pharmaSyncServerURL",""));
			    	}
				}
				catch(Exception e) {
					e.printStackTrace();
				}
		    }
		}
		catch(Exception x) {
			x.printStackTrace();
		}
		return -1;
	}
	
	public static Element getLastPharmacyOperationsUids(String lastupdateid) {
		if(SH.cs("pharmaSyncServerURL","").length()==0) {
			return null;
		}
		OCHttpClient oc_client = new OCHttpClient();
		oc_client.addStringParam("operation","getnewuids");
		oc_client.addStringParam("lastupdateid",lastupdateid);
		try {
			CloseableHttpResponse resp = oc_client.postAuthenticated(SH.cs("pharmaSyncServerURL",""),SH.cs("pharmaSyncServerURLUsername", "nil"), SH.cs("pharmaSyncServerURLPassword", "nil"));
			HttpEntity entity = resp.getEntity();
		    if(entity!=null){
		    	try {
			    	Document doc = org.dom4j.DocumentHelper.parseText(EntityUtils.toString(entity));
			    	return doc.getRootElement();
				}
				catch(Exception e) {
					e.printStackTrace();
				}
		    }
		}
		catch(Exception x) {
			x.printStackTrace();
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
						log(INFO_NEW_PRODUCT_CREATED,serviceStockUid,prod.getUid()+": "+name);
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
							log(INFO_NEW_PRODUCTSTOCK_CREATED,serviceStockUid,productStock.getUid()+": "+name);
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
								log(INFO_NEW_BATCH_CREATED,serviceStockUid,batch.getUid()+": "+number+" ["+name+"]");
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
				        String sPatient="";
				        if(patient==null) {
					        sourceDestination.setObjectType("servicestock");
					        sourceDestination.setObjectUid(serviceStockUid);
				        }
				        else {
				        	sPatient=SH.c(patient.elementText("lastname")).toUpperCase()+", "+SH.capitalize(SH.c(patient.elementText("firstname")))+" - "+SH.c(patient.elementText("gender")).toUpperCase()+" - "+SH.c(patient.elementText("dateofbirth"));
					        sourceDestination.setObjectType("remotepatient");
					        sourceDestination.setObjectUid(SH.c(patient.attributeValue("localid")));
					        operation.setComment(sPatient);
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
						if(operationtype.contains("delivery")) {
							log(INFO_NEW_OPERATION_CREATED,serviceStockUid,operation.getUid()+": "+SH.getTranNoLink("productstockoperation.medicationdelivery",operationtype,"en")+" ["+name+"] "+sPatient);
						}
						else {
							log(INFO_NEW_OPERATION_CREATED,serviceStockUid,operation.getUid()+": "+SH.getTranNoLink("productstockoperation.medicationreceipt",operationtype,"en")+" ["+name+"] "+sPatient);
						}
					}
				}
				
				int updateid = Integer.parseInt(message.attributeValue("id"));
				if(updateid>SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), -1)) {
					MedwanQuery.getInstance().setConfigString("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), updateid+"");
				}
				Debug.println("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,"")+" set to "+updateid);
			}
			else if(SH.cs("remoteSyncId."+serviceStockUid,"").length()>0 && message.attributeValue("objecttype").equalsIgnoreCase("initialize")) {
				//If there are existing product stock operations, then we cannot perform the initialize command
				int newproducts=0,newproductstocks=0,newbatches=0,newoperations=0;
				Connection conn = SH.getOpenClinicConnection();
				PreparedStatement pst = conn.prepareStatement("select oc_operation_objectid from oc_productstockoperations,oc_productstocks where oc_stock_objectid=replace(oc_operation_productstockuid,'"+SH.getServerId()+".','') and ((oc_operation_srcdesttype='servicestock' and oc_operation_srcdestuid=?) or oc_stock_servicestockuid=?)");
				pst.setString(1, serviceStockUid);
				pst.setString(2, serviceStockUid);
				ResultSet rst = pst.executeQuery();
				if(rst.next()) {
					//Operations already exist. Cannot perform initialization command
					rst.close();
					pst.close();
					conn.close();
					HashSet hBatches=new HashSet(),hProductStocks=new HashSet();
					//Log failed initialization
					log(ERROR_FAILED_INITIALIZATION_EXISTING_OPERATIONS,serviceStockUid);
					//Now we register corrective operations to synchronize stocklevels with remote stock
					//**** First synchronize remote product stocks with this side
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
							Debug.println("Importing product "+code+" - "+name);
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
								hProductStocks.add(code);
								Debug.println("Searching for existing product");
								Vector<Product> p = Product.findWithCode(code, "", "", "", "", "", "", "", "", "OC_PRODUCT_OBJECTID", "");
								if(p.size()==0) {
									Debug.println("Product does not exist");
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
									log(INFO_NEW_PRODUCT_CREATED,serviceStockUid,prod.getUid()+" ["+name+"]");
									newproducts++;
								}
								else {
									prod=p.elementAt(0);
									Debug.println("Product exists with UID: "+prod.getUid());
								}
								
								ProductStock pStock=ProductStock.get(prod.getUid(), serviceStockUid);
								if(pStock==null) {
									//Add the product stock
									pStock = new ProductStock();
									pStock.setUid("-1");
									pStock.setBegin(new java.util.Date());
									pStock.setCreateDateTime(new java.util.Date());
									pStock.setLevel(0);
									try {
										pStock.setMinimumLevel(Integer.parseInt(minimumlevel));
									}catch(Exception r) {}
									try {
										pStock.setMaximumLevel(Integer.parseInt(maximumlevel));
									}catch(Exception r) {}
									try {
										pStock.setOrderLevel(Integer.parseInt(orderlevel));
									}catch(Exception r) {}
									pStock.setProductUid(prod.getUid());
									pStock.setServiceStockUid(serviceStockUid);
									pStock.setUpdateDateTime(new java.util.Date());
									pStock.setUpdateUser(updateuser);
									pStock.setVersion(1);
									pStock.store();
									log(INFO_NEW_PRODUCTSTOCK_CREATED,serviceStockUid,pStock.getUid()+" ["+name+"]");
									newproductstocks++;
									Debug.println("Product stock added to service stock");
								}
								else {
									Debug.println("Product stock exists with UID: "+pStock.getUid());
								}
								int nBatchedQuantity=0;
								Iterator<Element> iBatches = productStock.elementIterator("batch");
								while(iBatches.hasNext()) {
									Element batch = iBatches.next();
									String number = batch.attributeValue("number");
									String expiry = batch.attributeValue("expiry");
									String batchlevel = batch.attributeValue("level");
									if(number.length()>0) {
										hBatches.add(code+";"+number);
										Batch b = Batch.getByBatchNumber(pStock.getUid(), number);
										if(b==null) {
											b = new Batch();
											b.setUid("-1");
											b.setBatchNumber(number);
											b.setCreateDateTime(new java.util.Date());
											b.setEnd(SH.parseDate(expiry));
											b.setLevel(0);
											b.setProductStockUid(pStock.getUid());
											b.setUpdateDateTime(new java.util.Date());
											b.setUpdateUser(updateuser);
											b.setVersion(1);
											b.setComment("");
											b.store();
											log(INFO_NEW_BATCH_CREATED,serviceStockUid,pStock.getUid()+" ["+number+"]");
											newbatches++;
										}
										else {
											Batch.calculateBatchLevel(b.getUid());
											b = Batch.get(b.getUid());
										}
										//If the remote batch level is different from this batch level, create a corrective operation
										if(b.getLevel()!=Integer.parseInt(batchlevel)) {
											ProductStockOperation po =new ProductStockOperation();
											po.setComment("REMOTE INIT CORRECTION");
											po.setCreateDateTime(new java.util.Date());
											po.setDate(new java.util.Date());
											po.setBatchUid(b.getUid());
											if(b.getLevel()>Integer.parseInt(batchlevel)) {
												po.setDescription("medicationdelivery.99");
											}
											else {
												po.setDescription("medicationreceipt.99");
											}
											po.setProductStockUid(pStock.getUid());
											po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT CORRECTION"));
											po.setUid("-1");
											po.setUnitsChanged(Math.abs(Integer.parseInt(batchlevel)-b.getLevel()));
											po.setUnitsReceived(0);
											po.setUpdateDateTime(new java.util.Date());
											po.setUpdateUser(updateuser);
											po.setVersion(1);
											po.store(false,false);
											log(INFO_NEW_BATCHOPERATION_CREATED,serviceStockUid,po.getUid()+" ["+(Integer.parseInt(batchlevel)-b.getLevel())+"] ["+number+" - REMOTE INIT BATCH CORRECTION]");
											newoperations++;
										}
									}
								}
								pStock.setLevel(pStock.getLevel(new java.util.Date()));
								pStock.store();
								//If the remote product stock level is different from this product stock level, create a corrective operation
								if(pStock.getLevel()!=Integer.parseInt(level)) {
									ProductStockOperation po =new ProductStockOperation();
									po.setComment("REMOTE INIT CORRECTION");
									po.setCreateDateTime(new java.util.Date());
									po.setDate(new java.util.Date());
									if(pStock.getLevel()>Integer.parseInt(level)) {
										po.setDescription("medicationdelivery.99");
									}
									else {
										po.setDescription("medicationreceipt.99");
									}
									po.setProductStockUid(pStock.getUid());
									po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT CORRECTION"));
									po.setUid("-1");
									po.setUnitsChanged(Math.abs(Integer.parseInt(level)-pStock.getLevel()));
									po.setUnitsReceived(0);
									po.setUpdateDateTime(new java.util.Date());
									po.setUpdateUser(updateuser);
									po.setVersion(1);
									po.store(false,false);
									log(INFO_NEW_OPERATION_CREATED,serviceStockUid,po.getUid()+" ["+(Integer.parseInt(level)-pStock.getLevel())+"] ["+name+" - REMOTE INIT CORRECTION]");
									newoperations++;
									pStock.setLevel(pStock.getLevel(new java.util.Date()));
									pStock.store();
								}
							}
						}
					}
					//Now clear all productstocks and batches from this servicestock which do not exist on the remote side 
					Vector<ProductStock> pStocks = ServiceStock.getProductStocks(serviceStockUid);
					for(int n=0;n<pStocks.size();n++) {
						ProductStock pStock = pStocks.elementAt(n);
						//First clear the batches
						Vector<Batch> batches = pStock.getAllBatches();
						for(int i=0;i<batches.size();i++) {
							Batch b = batches.elementAt(i);
							Batch.calculateBatchLevel(b.getUid());
							if(b.getLevel()!=0 && !hBatches.contains(pStock.getProduct().getCode()+";"+b.getBatchNumber())) {
								//This batch does not exist remotely, reset it to zero
								ProductStockOperation po =new ProductStockOperation();
								po.setComment("REMOTE INIT CORRECTION");
								po.setCreateDateTime(new java.util.Date());
								po.setDate(new java.util.Date());
								po.setBatchUid(b.getUid());
								if(b.getLevel()>0) {
									po.setDescription("medicationdelivery.99");
								}
								else {
									po.setDescription("medicationreceipt.99");
								}
								po.setProductStockUid(pStock.getUid());
								po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT CORRECTION"));
								po.setUid("-1");
								po.setUnitsChanged(Math.abs(b.getLevel()));
								po.setUnitsReceived(0);
								po.setUpdateDateTime(new java.util.Date());
								po.setUpdateUser(updateuser);
								po.setVersion(1);
								po.store(false,false);
								log(INFO_NEW_BATCHOPERATION_CREATED,serviceStockUid,b.getUid()+" ["+(-b.getLevel())+"] ["+b.getBatchNumber()+" - REMOTE UNKNOWN BATCH CORRECTION]");
								newoperations++;
							}
						}
						pStock.setLevel(pStock.getLevel(new java.util.Date()));
						pStock.store();
						if(pStock.getLevel()!=0 && !hProductStocks.contains(pStock.getProduct().getCode())) {
							//This product stock does not exist remotely, reset it to zero
							ProductStockOperation po =new ProductStockOperation();
							po.setComment("REMOTE UNKNOWN PRODUCT STOCK CORRECTION");
							po.setCreateDateTime(new java.util.Date());
							po.setDate(new java.util.Date());
							if(pStock.getLevel()>0) {
								po.setDescription("medicationdelivery.99");
							}
							else {
								po.setDescription("medicationreceipt.99");
							}
							po.setProductStockUid(pStock.getUid());
							po.setSourceDestination(new ObjectReference("supplier", "REMOTE INIT CORRECTION"));
							po.setUid("-1");
							po.setUnitsChanged(Math.abs(pStock.getLevel()));
							po.setUnitsReceived(0);
							po.setUpdateDateTime(new java.util.Date());
							po.setUpdateUser(updateuser);
							po.setVersion(1);
							po.store(false,false);
							newoperations++;
							log(INFO_NEW_OPERATION_CREATED,serviceStockUid,po.getUid()+" ["+(-pStock.getLevel())+"] ["+pStock.getProduct().getName()+" - REMOTE UNKNOWN PRODUCT STOCK CORRECTION]");
						}
					}
					if(newproducts+newbatches+newproductstocks+newoperations>0) {
						log(INFO_INITIALIZATION_CORRECTION_PERFORMED,serviceStockUid,"Added "+newproducts+" products, "+newbatches+" batches, "+newproductstocks+" product stocks and "+newoperations+" inventory operations");
					}
					else {
						log(INFO_INITIALIZATION_CORRECTION_PERFORMED,serviceStockUid,"Synchronisation was already up to date, no action needed");
					}

					int updateid = Integer.parseInt(message.attributeValue("id"));
					if(updateid>SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), -1)) {
						MedwanQuery.getInstance().setConfigString("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), updateid+"");
					}
					return true;
				}
				rst.close();
				pst.close();
				conn.close();
				//Remove existing product stocks from the service stock
				conn = SH.getOpenClinicConnection();
				pst = conn.prepareStatement("delete from oc_productstocks where oc_stock_servicestockuid=?");
				pst.setString(1, serviceStockUid);
				pst.execute();
				pst.close();
				conn.close();
				Debug.println("Product stocks from service stock "+serviceStockUid+" deleted");
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
						Debug.println("Importing product "+code+" - "+name);
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
							Debug.println("Searching for existing product");
							Vector<Product> p = Product.findWithCode(code, "", "", "", "", "", "", "", "", "OC_PRODUCT_OBJECTID", "");
							if(p.size()==0) {
								Debug.println("Product does not exist");
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
								newproducts++;
							}
							else {
								prod=p.elementAt(0);
								Debug.println("Product exists with UID: "+prod.getUid());
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
							newproductstocks++;
							Debug.println("Product stock added to service stock");
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
									b.setLevel(0);
									b.setProductStockUid(ps.getUid());
									b.setUpdateDateTime(new java.util.Date());
									b.setUpdateUser(updateuser);
									b.setVersion(1);
									b.setComment("");
									b.store();
									newbatches++;
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
									newoperations++;
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
								newoperations++;
							}
						}
					}
				}
				log(INFO_INITIALIZATION_PERFORMED,serviceStockUid,"Added "+newproducts+" products, "+newbatches+" batches, "+newproductstocks+" product stocks and "+newoperations+" inventory operations");
				int updateid = Integer.parseInt(message.attributeValue("id"));
				if(updateid>SH.ci("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), -1)) {
					MedwanQuery.getInstance().setConfigString("remotePharmacySyncLastUpdateId."+SH.cs("remoteSyncId."+serviceStockUid,""), updateid+"");
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
