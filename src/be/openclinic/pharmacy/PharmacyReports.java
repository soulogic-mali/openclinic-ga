package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.webapp.wl.session.SessionContainerFactory;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.Debet;
import be.openclinic.finance.PatientInvoice;
import be.openclinic.finance.Prestation;
import net.admin.AdminPerson;
import net.admin.AdminPrivateContact;
import net.admin.Service;
import net.admin.User;

public class PharmacyReports {

	public static Vector getInventoryReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		long day = 24*3600*1000;
		String reportline="";
		if(MedwanQuery.getInstance().getConfigInt("enableCCBRT",0)==0){
			//Header
			reportline+="CODE;";
			reportline+="PRODUCT;";
			reportline+="UNIT;";
			reportline+="INITIAL;";
			reportline+="IN;";
			reportline+="OUT;";
			reportline+="THEORETICAL;";
			reportline+="PUMP;";
			reportline+="THEORETICAL_VALUE;";
			reportline+="PHYSICAL;";
			reportline+="PHYSICAL_VALUE;";
			reportline+="SALES;";
			reportline+="SALES_VALUE;";
			reportline+="MISSING;";
			reportline+="OVERSTOCK;\r\n";
			report.add(reportline);
			String[] uids = serviceStockUid.split(";");
			for(int s=0;s<uids.length;s++){
				ServiceStock serviceStock = ServiceStock.get(uids[s]);
				if(serviceStock!=null && serviceStock.hasValidUid()){
			 		//Now we have to find all productstocks sorted by productname
			 		SortedMap stocks = new TreeMap();
			 		Vector productStocks = ServiceStock.getProductStocks(uids[s]);
			 		for(int n=0;n<productStocks.size();n++){
			 			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			 			//First find the product subcategory
			 			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getName().toUpperCase())+"|"+stock.getUid();
			 			stocks.put(uid, stock);
			 		}
			 		
			 		Hashtable printedSubTitels = new Hashtable();
			 		Iterator iStocks = stocks.keySet().iterator();
			 		boolean bInitialized = false;
			 		double sectionTotal=0,generalTotal=0;
			 		String lasttitle="";
			 		while(iStocks.hasNext()){
			 			String key = (String)iStocks.next();
			 			ProductStock stock = (ProductStock)stocks.get(key);
			 			int initiallevel=stock.getLevel(begin);
			 			int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day));
			 			int out = stock.getTotalUnitsOutForPeriod(begin, new java.util.Date(end.getTime()+day));
			 			if(initiallevel!=0 || in!=0 || out!=0){
			 				reportline="";
				 			//Nu printen we de gegevens van de productstock
				 			reportline+=(stock.getProduct()==null?stock.getProductUid():stock.getProduct().getCode())+";";
				 			reportline+=(stock.getProduct()==null?"?":stock.getProduct().getName().replace(";",","))+";";
				 			reportline+=(stock.getProduct()==null?"?":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),language))+";";
				 			reportline+=initiallevel+";";
				 			reportline+=in+";";
				 			reportline+=out+";";
				 			reportline+=(initiallevel+in-out)+";";
				 			double pump=0;
				 			if(stock.getProduct()!=null){
				 				pump=stock.getProduct().getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
				 			}
				 			reportline+=pump+";";
				 			reportline+=((initiallevel+in-out)*pump)+";";
				 			reportline+=";";
				 			reportline+=";";
				 			if(stock.getProduct()!=null && stock.getProduct().getPrestationcode()!=null){
				 				Prestation prestation = Prestation.get(stock.getProduct().getPrestationcode());
				 				if(prestation!=null && prestation.getPrice()>0){
				 					reportline+=ScreenHelper.getPriceFormat(prestation.getPrice())+";";
				 					reportline+=ScreenHelper.getPriceFormat(prestation.getPrice()*(initiallevel+in-out))+";";
				 				}
					 			else{
						 			reportline+=";";
						 			reportline+=";";
					 			}
				 			}
				 			else{
					 			reportline+=";";
					 			reportline+=";";
				 			}
				 			reportline+=";";
				 			reportline+=";\n";
				 			report.add(reportline);
			 			}
			 		}
				}
			}
		}
		else{
			//Header
			reportline+="ITEM CODE;";
			reportline+="ITEM DESCRIPTION;";
			reportline+="OB QTY;";
			reportline+="Unit Price;";
			reportline+="OB Value;";
			reportline+="QTY from Supplier;";
			reportline+="Value from Supplier;";
			reportline+="Transfer QTY;";
			reportline+="Transfer value;";
			reportline+="Quantity issued;";
			reportline+="Value issued;";
			reportline+="Closing Qty;";
			reportline+="Closing value;";
			reportline+="Location;";
			reportline+="Group description;";
			reportline+="Items category;\r\n";
			report.add(reportline);
			String[] uids = serviceStockUid.split(";");
			for(int s=0;s<uids.length;s++){
				ServiceStock serviceStock = ServiceStock.get(uids[s]);
				if(serviceStock!=null && serviceStock.hasValidUid()){
			 		//Now we have to find all productstocks sorted by productname
			 		SortedMap stocks = new TreeMap();
			 		Vector productStocks = ServiceStock.getProductStocks(uids[s]);
			 		for(int n=0;n<productStocks.size();n++){
			 			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			 			//First find the product subcategory
			 			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getName().toUpperCase())+"|"+stock.getUid();
			 			stocks.put(uid, stock);
			 		}
			 		
			 		Iterator iStocks = stocks.keySet().iterator();
			 		while(iStocks.hasNext()){
			 			String key = (String)iStocks.next();
			 			ProductStock stock = (ProductStock)stocks.get(key);
			 			int initiallevel=stock.getLevel(begin);
			 			int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day));
			 			int inFromMainWarehouse=0;
			 			//Find the quantity received from the main warehouse stock
			 			Vector receivedProductsFromMainWarehouse = ProductStockOperation.getReceipts(stock.getUid(), MedwanQuery.getInstance().getConfigString("MainWarehouseUid","1.1"), begin, end, "OC_OPERATION_DATE", "");
			 			for(int n=0;n<receivedProductsFromMainWarehouse.size();n++){
			 				ProductStockOperation operation = (ProductStockOperation)receivedProductsFromMainWarehouse.elementAt(n);
			 				inFromMainWarehouse+=operation.getUnitsChanged();
			 			}
			 			int out = stock.getTotalUnitsOutForPeriod(begin, new java.util.Date(end.getTime()+day));
			 			if(initiallevel!=0 || in!=0 || out!=0){
				 			double pump=0;
				 			if(stock.getProduct()!=null){
				 				pump=stock.getProduct().getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
				 			}
			 				reportline="";
				 			reportline+=(stock.getProduct()==null?stock.getProductUid():stock.getProduct().getCode())+";";
				 			reportline+=(stock.getProduct()==null?"?":stock.getProduct().getName())+";";
				 			reportline+=initiallevel+";";
				 			reportline+=pump+";";
				 			reportline+=initiallevel*pump+";";
				 			reportline+=inFromMainWarehouse+";";
				 			reportline+=inFromMainWarehouse*pump+";";
				 			reportline+=in-inFromMainWarehouse+";";
				 			reportline+=(in-inFromMainWarehouse)*pump+";";
				 			reportline+=out+";";
				 			reportline+=out*pump+";";
				 			reportline+=(initiallevel+in-out)+";";
				 			reportline+=((initiallevel+in-out)*pump)+";";
				 			reportline+=serviceStock.getName()+";";
				 			reportline+=stock.getProduct()==null?"?":ScreenHelper.getTranNoLink("product.productgroup",stock.getProduct().getProductGroup(),language)+";";
				 			reportline+=stock.getProduct()==null?"?":ScreenHelper.getTranNoLink("drug.category",stock.getProduct().getProductSubGroup(),language)+";";
				 			reportline+=";\r\n";
				 			report.add(reportline);
			 			}
			 		}
				}
			}
		}
		return report;
	}
	
	public static Vector getInventorySummaryReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		long day = 24*3600*1000;
		String reportline="";
		//Header
		reportline+="CODE;";
		reportline+="PRODUCT;";
		reportline+="BATCH;";
		reportline+="EXPIRES;";
		reportline+="THEORETICAL;";
		reportline+="PUMP;";
		reportline+="THEORETICAL_VALUE;\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			SortedMap groups = new TreeMap();
			String[] serviceStockUids = serviceStockUid.split(";");
			for(int q=0;q<serviceStockUids.length;q++){
				Vector productStocks = ServiceStock.getProductStocks(serviceStockUids[q]);
				for(int n=0;n<productStocks.size();n++){
					ProductStock stock = (ProductStock)productStocks.elementAt(n);
					if((MedwanQuery.getInstance().getConfigInt("pharmacyShowZeroLevelStocks",0)==0 && stock.getLevel()==0) || stock.getProduct()==null){
						continue;
					}
					String uid=stock.getProduct().getName().toUpperCase();
					if(uid.length()>0){
						if(groups.get(uid)==null){
							groups.put(uid, new TreeMap());
						}
						SortedMap stocks = (TreeMap)groups.get(uid);
						int datelevel=stock.getLevel(end);
						//Now we add an entry for each combination productUid+BatchNumber
						//Look up all batches for this product
						int nBatchedQuantity=0;
						Vector batches = Batch.getAllBatches(stock.getUid());
						for(int b=0;b<batches.size() && (nBatchedQuantity<datelevel);b++){
							Batch batch = (Batch)batches.elementAt(b);
							int level=batch.getLevel(end);
							if(level>0){
								if(datelevel<nBatchedQuantity+level){
									level=level-(nBatchedQuantity+level-datelevel);
								}
								nBatchedQuantity+=level;
								uid=stock.getProduct().getName()+";"+ScreenHelper.checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+";"+batch.getBatchNumber()+";"+ScreenHelper.formatDate(batch.getEnd())+" ;";
								if(stocks.get(uid)==null){
									stocks.put(uid, 0);
								}
								stocks.put(uid,	(Integer)stocks.get(uid)+level);
							}
						}
						if(nBatchedQuantity<datelevel){
							//Part of the stock has no batch associated 
							uid=stock.getProduct().getName()+";"+ScreenHelper.checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+"; ; ;";
							if(stocks.get(uid)==null){
								stocks.put(uid, 0);
							}
							stocks.put(uid,	(Integer)stocks.get(uid)+datelevel-nBatchedQuantity);
						}
					}
				}
			}
			Hashtable printedSubTitels = new Hashtable();
			Iterator iGroups = groups.keySet().iterator();
			boolean bInitialized = false;
			double sectionTotal=0,generalTotal=0;
			String title="";
			while(iGroups.hasNext()){
				String key = (String)iGroups.next();
				SortedMap stocks = (SortedMap)groups.get(key);
				//Now we print a line for each element in the stocks for this group
				Iterator iStocks = stocks.keySet().iterator();
				while(iStocks.hasNext()){
					String key2 = (String)iStocks.next();
					//Nu printen we de gegevens van de productstock
					reportline="";
					reportline+=key2.split(";")[1]+";";
					reportline+=key2.split(";")[0]+";";
					reportline+=key2.split(";")[3]+";";
					reportline+=key2.split(";")[4]+";";
					int level=(Integer)stocks.get(key2);
					reportline+=level+";";
					double pump=0;
					Product product = Product.get(key2.split(";")[2]);
					if(product!=null){
						pump=product.getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
					}
					reportline+=pump+";";
					reportline+=level*pump+";\n";
					report.add(reportline);
				}
			}
		}
		return report;
	}
	
	public static Vector getConsumptionReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		String reportline="";
		end = ScreenHelper.endOfDay(end);
		//Header
		reportline+="POSTING DATE;";
		reportline+="ITEM NO;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="QUANTITY;";
		reportline+="STOCK PRICE;";
		reportline+="TOTAL;";
		reportline+="COST CENTER;";
		reportline+="ISSUED TO;";
		reportline+="PATIENT ID;";
		reportline+="LOCATION;";
		reportline+="GROUP DESCRIPTION;";
		reportline+="GROUP CATGEORY;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Hashtable pumps = new Hashtable();
				Hashtable encounters = new Hashtable();
				Vector operations = ProductStockOperation.getServiceStockDeliveries(serviceStockUid, begin, end, "OC_OPERATION_DATE", "ASC");
				for (int n=0;n<operations.size();n++){
					long time = new java.util.Date().getTime();
					ProductStockOperation operation = (ProductStockOperation)operations.elementAt(n);
					Product product=null;
					if(operation.getProductStock()!=null){
						product=operation.getProductStock().getProduct();
					}
					if((operation.getUnitsChanged()-operation.getUnitsReceived()!=0) && product!=null){
						if(pumps.get(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()))==null){
							pumps.put(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()),product.getLastYearsAveragePrice(ScreenHelper.endOfDay(operation.getCreateDateTime())));
						}
						double pump = (Double)pumps.get(product.getUid()+"."+ScreenHelper.formatDate(operation.getDate()));
						reportline=ScreenHelper.formatDate(operation.getDate())+";";
						reportline+=product.getCode()+";";
						reportline+=product.getName()+";";
						reportline+=(operation.getUnitsChanged()-operation.getUnitsReceived())+";";
						reportline+=ScreenHelper.getPriceFormat(pump)+";";
						reportline+=ScreenHelper.getPriceFormat((operation.getUnitsChanged()-operation.getUnitsReceived())*pump)+";";
						if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
							if(encounters.get(operation.getEncounterUID())==null){
								encounters.put(operation.getEncounterUID(), Encounter.get(operation.getEncounterUID()));
							}
							Encounter encounter = (Encounter)encounters.get(operation.getEncounterUID());
							if(encounter!=null){
								Service service = Service.getService(encounter.getServiceUID(operation.getDate()));
								if(service!=null){
									reportline+=service.getLabel(language);
								}
							}
							reportline+=";";
						}
						else{
							reportline+=";";
						}
						reportline+=ScreenHelper.getTranNoLink("productstockoperation.medicationdelivery", operation.getDescription(), language)+";";
						reportline+=operation.getSourceDestination().getObjectUid()+";";
						reportline+=operation.getProductStock().getServiceStock().getName()+";";
						reportline+=ScreenHelper.getTranNoLink("product.productgroup",product.getProductGroup(),language)+";";
						reportline+=ScreenHelper.getTranNoLink("drug.category",product.getProductSubGroup(),language)+";\n";
						report.add(reportline);

					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getInventoryAnalysisReport(String serviceStockUid, java.util.Date date){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="STOCK BALANCE;";
		reportline+="UNIT COST;";
		reportline+="STOCK VALUE;";
		reportline+="MINIMUM LEVEL;";
		reportline+="1 MONTH;";
		reportline+="3 MONTHS;";
		reportline+="6 MONTHS;";
		reportline+="LAST PURCHASE;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productStocks = serviceStock.getProductStocks();
				for(int n=0;n<productStocks.size();n++){
					ProductStock productStock = (ProductStock)productStocks.elementAt(n);
					if(productStock!=null && productStock.getProduct()!=null){
						reportline="";
						Vector operations = ProductStockOperation.getAll(productStock.getUid());
						double level = productStock.getLevel(operations,date);
						double cost = productStock.getProduct().getLastYearsAveragePrice(date);
						reportline+=productStock.getProduct().getCode()+";";
						reportline+=productStock.getProduct().getName()+";";
						reportline+=level+";";
						reportline+=cost+";";
						reportline+=(level<0?0:level)*cost+";";
						reportline+=productStock.getMinimumLevel()+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(operations,Miscelaneous.addMonthsToDate(date,-1),date)+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(operations,Miscelaneous.addMonthsToDate(date,-3),date)+";";
						reportline+=productStock.getTotalUnitsOutForPeriod(operations,Miscelaneous.addMonthsToDate(date,-6),date)+";";
						reportline+=Pointer.getLastPointer("PHARMA.PRODUCT.PURCHASE."+productStock.getProductUid())+";";
						reportline+="\r\n";
						report.add(reportline);
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSpecialOrderReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="P/O DATE&TIME;";
		reportline+="PRODUCTION DOC NR;";
		reportline+="FG ITEM CODE;";
		reportline+="RM ITEM CODE;";
		reportline+="RM ITEM DESCRIPTION;";
		reportline+="RM ITEM COMMENT;";
		reportline+="SALES ORDER NR;";
		reportline+="ESTIMATED DELIVERY;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Vector materials = productionOrder.getMaterialsSummary();
						for(int q=0;q<materials.size();q++){
							ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
							Product product = material.getProductStock().getProduct();
							if(product!=null && product.getCode().startsWith(MedwanQuery.getInstance().getConfigString("specialOrderPrefix","SO"))){
								reportline="";
								reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
								reportline+=productionOrder.getId()+";";
								reportline+=product.getCode()+";";
								//Add material data
								reportline+=material.getProductStock().getProduct().getCode()+";";
								reportline+=material.getProductStock().getProduct().getName()+";";
								reportline+=material.getComment()+";";
								if(productionOrder.getDebetUid()!=null){
									Debet debet = Debet.get(productionOrder.getDebetUid());
									if(debet!=null){
										reportline+=debet.getPatientInvoiceUid()+";";
										PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
										if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
											reportline+=invoice.getEstimatedDeliveryDate()+";";
										}
										else{
											reportline+=";";
										}
									}
									else{
										reportline+=";;";
									}
								}
								else{
									reportline+=";;";
								}
								report.add(reportline+"\r\n");
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getProductionReport(String serviceStockUid, java.util.Date begin, java.util.Date end, String language){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="P/O DATE&TIME;";
		reportline+="PRODUCTION DOC NR;";
		reportline+="FG ITEM CODE;";
		reportline+="RM ITEM CODE;";
		reportline+="RM ITEM DESCRIPTION;";
		reportline+="RM ITEM QUANTITY;";
		reportline+="RM ITEM COMMENT;";
		reportline+="SALES ORDER NR;";
		reportline+="ESTIMATED DELIVERY;";
		reportline+="TECHNICIAN NAME;";
		reportline+="SHOP NAME;";
		reportline+="P/O CLOSED;";
		reportline+="IP NUMBER;";
		reportline+="PATIENT NAME;";
		reportline+="PHONE NUMBER;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							//Now we search for all raw materials
							Vector materials = productionOrder.getMaterialsSummary();
							if(materials.size()==0){
								reportline="";
								reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
								reportline+=productionOrder.getId()+";";
								reportline+=product.getCode()+";;;;;";
								if(productionOrder.getDebetUid()!=null){
									Debet debet = Debet.get(productionOrder.getDebetUid());
									if(debet!=null){
										reportline+=debet.getPatientInvoiceUid()+";";
										PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
										if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
											reportline+=invoice.getEstimatedDeliveryDate()+";";
										}
										else{
											reportline+=";";
										}
									}
									else{
										reportline+=";;";
									}
								}
								else{
									reportline+=";;";
								}
								reportline+=ScreenHelper.getTranNoLink("productiontechnician",productionOrder.getTechnician(),language)+";";
								reportline+=ScreenHelper.getTranNoLink("productiondestination",productionOrder.getDestination(),language)+";";
								reportline+=ScreenHelper.formatDate(productionOrder.getCloseDateTime());
								report.add(reportline+"\r\n");
							}
							else{
								for(int q=0;q<materials.size();q++){
									reportline="";
									ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
									reportline="";
									reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
									reportline+=productionOrder.getId()+";";
									reportline+=product.getCode()+";";
									//Add material data
									if(material.getProductStock()!=null && material.getProductStock().getProduct()!=null){
										reportline+=material.getProductStock().getProduct().getCode()+";";
										reportline+=material.getProductStock().getProduct().getName()+";";
										reportline+=material.getQuantity()+";";
										reportline+=material.getComment()+";";
									}
									else{
										reportline+="?;?;?;?;";
									}
									if(productionOrder.getDebetUid()!=null){
										Debet debet = Debet.get(productionOrder.getDebetUid());
										if(debet!=null){
											reportline+=debet.getPatientInvoiceUid()+";";
											PatientInvoice invoice = PatientInvoice.get(debet.getPatientInvoiceUid());
											if(invoice!=null && invoice.getEstimatedDeliveryDate()!=null){
												reportline+=invoice.getEstimatedDeliveryDate()+";";
											}
											else{
												reportline+=";";
											}
										}
										else{
											reportline+=";;";
										}
									}
									else{
										reportline+=";;";
									}
									reportline+=ScreenHelper.getTranNoLink("productiontechnician",productionOrder.getTechnician(),language)+";";
									reportline+=ScreenHelper.getTranNoLink("productiondestination",productionOrder.getDestination(),language)+";";
									reportline+=ScreenHelper.formatDate(productionOrder.getCloseDateTime())+";";
									reportline+=productionOrder.getPatientUid()+";";
									AdminPerson person = AdminPerson.getAdminPerson(productionOrder.getPatientUid()+"");
									if(person!=null){
										reportline+=person.getFullName()+";";
										if(person.getActivePrivate()!=null){
											reportline+=person.getActivePrivate().telephone+";";
										}
									}
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSalesOrderReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="DATE;";
		reportline+="SALES ORDER DOC NR;";
		reportline+="IP NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="CUSTOMER PHONE;";
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="UNIT AMOUNT;";
		reportline+="TOTAL AMOUNT;";
		reportline+="PATIENT AMOUNT;";
		reportline+="AMOUNT PAID;";
		reportline+="BALANCE AMOUNT;";
		reportline+="INSURANCE AMOUNT;";
		reportline+="INVOICE STATUS;\r\n";
		report.add(reportline);
		serviceStockUid=Service.getChildIdsAsString(serviceStockUid);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select oc_patientinvoice_date,oc_patientinvoice_serverid,oc_patientinvoice_objectid,a.personid,lastname,firstname,telephone,oc_prestation_code,oc_prestation_description,oc_debet_prestationuid,oc_debet_quantity,oc_patientinvoice_status,oc_debet_amount,oc_debet_insuraramount, oc_debet_extrainsuraramount"
							+ " from oc_patientinvoices, oc_debets, adminview a, privateview b, oc_prestations where"
							+ " oc_patientinvoice_date >= ? and"
							+ " oc_patientinvoice_date <? and"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " a.personid=b.personid and"
							+ " a.personid=oc_patientinvoice_patientuid and"
							+ " oc_debet_patientinvoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"
							+ " oc_debet_serviceuid in ("+serviceStockUid+") ORDER BY oc_patientinvoice_date,oc_patientinvoice_objectid,oc_prestation_code");
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				PatientInvoice invoice = PatientInvoice.get(rs.getString("oc_patientinvoice_serverid")+"."+rs.getString("oc_patientinvoice_objectid"));
				double patientamount = rs.getDouble("oc_debet_amount");
				double insuraramount = rs.getDouble("oc_debet_insuraramount")+rs.getDouble("oc_debet_extrainsuraramount");
				double quantity = rs.getDouble("oc_debet_quantity");
				double paidamount=0;
				if(invoice.getPatientAmount()>0){
					paidamount=patientamount*invoice.getAmountPaid()/invoice.getPatientAmount();
				}
				reportline=ScreenHelper.formatDate(rs.getDate("oc_patientinvoice_date"))+";";
				reportline+=rs.getString("oc_patientinvoice_objectid")+";";
				reportline+=rs.getString("personid")+";";
				reportline+=rs.getString("lastname").toUpperCase()+", "+rs.getString("firstname")+";";
				reportline+=rs.getString("telephone")+";";
				reportline+=rs.getString("oc_prestation_code")+";";
				reportline+=rs.getString("oc_prestation_description").toUpperCase().replaceAll(";", " ")+";";
				reportline+=(patientamount+insuraramount)/quantity+";";
				reportline+=(patientamount+insuraramount)+";";
				reportline+=patientamount+";";
				reportline+=paidamount+";";
				reportline+=(patientamount+-paidamount)+";";
				reportline+=insuraramount+";";
				reportline+=rs.getString("oc_patientinvoice_status")+"\n";
				report.add(reportline);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return report;
	}

	public static Vector getProductionSalesOrderReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="DATE;";
		reportline+="SALES ORDER DOC NR;";
		reportline+="IP NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="CUSTOMER PHONE;";
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="UNIT AMOUNT;";
		reportline+="TOTAL AMOUNT;";
		reportline+="PATIENT AMOUNT;";
		reportline+="AMOUNT PAID;";
		reportline+="BALANCE AMOUNT;";
		reportline+="INSURANCE AMOUNT;";
		reportline+="INVOICE STATUS;\r\n";
		report.add(reportline);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct oc_patientinvoice_objectid as invoiceuid,oc_patientinvoice_date from oc_debets,oc_prestations,oc_patientinvoices,oc_productionorders,oc_productstocks"
							+ " where"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_prestation_code like ? and"
							+ " oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_OBJECTID")+" and"
							+ " oc_productionorder_debetuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_DEBET_OBJECTID")+" and"
							+ " oc_patientinvoice_date >= ? and"
							+ " oc_patientinvoice_date <? and"
							+ " oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_stock_servicestockuid=?"
							+ " ORDER BY oc_patientinvoice_date,oc_patientinvoice_objectid");
			ps.setString(1, MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG")+"%");
			ps.setDate(2, new java.sql.Date(begin.getTime()));
			ps.setDate(3, new java.sql.Date(end.getTime()));
			ps.setString(4, serviceStockUid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String invoiceuid = rs.getString("invoiceuid");
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				if(invoice!=null){
					reportline=ScreenHelper.formatDate(invoice.getDate())+";";
					reportline+=invoice.getInvoiceNumber()+";";
					reportline+=invoice.getPatientUid()+";";
					if(invoice.getPatient()!=null){
						reportline+=invoice.getPatient().getFullName().replaceAll(";"," ")+";";
						if(invoice.getPatient().getActivePrivate()!=null){
							reportline+=((AdminPrivateContact)invoice.getPatient().getActivePrivate()).telephone.replaceAll(";"," ")+";";
						}
						else{
							reportline+=";";
						}
					}
					else{
						reportline+=";;";
					}
					boolean bHasFinishedGoods=false;
					Vector debets = invoice.getDebets();
					for(int n=0;n<debets.size();n++){
						Debet debet = (Debet)debets.elementAt(n);
						if(debet.getPrestation()!=null && debet.getQuantity()>0 && debet.getPrestation().getCode().startsWith(MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG"))){
							reportline+=debet.getPrestation().getCode().replaceAll(";"," ")+";";
							reportline+=debet.getPrestation().getDescription().replaceAll(";"," ")+";";
							reportline+=invoice.getTotalAmount()/debet.getQuantity()+";";
							bHasFinishedGoods=true;
							break;
						}
					}
					if(!bHasFinishedGoods){
						reportline+=";;;";
					}
					reportline+=invoice.getTotalAmount()+";";
					reportline+=invoice.getPatientAmount()+";";
					reportline+=invoice.getAmountPaid()+";";
					reportline+=invoice.getBalance()+";";
					reportline+=(invoice.getTotalAmount()-invoice.getPatientAmount())+";";
					reportline+=invoice.getStatus()+";\r\n";
					report.add(reportline);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return report;
	}

	public static Vector getDeliveryReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="ISSUED DATE;";
		reportline+="IP NR;";
		reportline+="SALES ORDER NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="CUSTOMER PHONE;";
		reportline+="TOTAL AMOUNT;";
		reportline+="AMOUNT PAID;";
		reportline+="BALANCE AMOUNT;";
		reportline+="ESTIMATED DELIVERY;\r\n";
		report.add(reportline);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select distinct oc_patientinvoice_objectid as invoiceuid,oc_patientinvoice_date,oc_operation_date from oc_debets,oc_prestations,oc_patientinvoices,oc_productionorders,oc_productstockoperations,oc_productstocks"
							+ " where"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_prestation_code like ? and"
							+ " oc_debet_patientinvoiceuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_OBJECTID")+" and"
							+ " oc_productionorder_debetuid='"+MedwanQuery.getInstance().getConfigString("serverId")+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_DEBET_OBJECTID")+" and"
							+ " oc_operation_date >= ? and"
							+ " oc_operation_date <? and"
							+ " oc_operation_productstockuid=oc_productionorder_targetproductstockuid and"
							+ " oc_stock_objectid=replace(oc_productionorder_targetproductstockuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_stock_servicestockuid=? and"
							+ " oc_operation_description like 'medicationdelivery%' and"
							+ " oc_operation_srcdesttype='patient' and"
							+ " oc_operation_srcdestuid=oc_patientinvoice_patientuid and"
							+ " oc_operation_date>=oc_productionorder_createdatetime"
							+ " ORDER BY oc_operation_date,oc_patientinvoice_date,oc_patientinvoice_objectid");
			ps.setString(1, MedwanQuery.getInstance().getConfigString("finishedGoodsPrefix","FG")+"%");
			ps.setDate(2, new java.sql.Date(begin.getTime()));
			ps.setDate(3, new java.sql.Date(end.getTime()));
			ps.setString(4, serviceStockUid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String invoiceuid = rs.getString("invoiceuid");
				PatientInvoice invoice = PatientInvoice.get(invoiceuid);
				if(invoice!=null){
					reportline=ScreenHelper.formatDate(invoice.getDate())+";";
					reportline+=ScreenHelper.formatDate(rs.getDate("oc_operation_date"))+";";
					reportline+=invoice.getPatientUid()+";";
					reportline+=invoice.getInvoiceNumber()+";";
					if(invoice.getPatient()!=null){
						reportline+=invoice.getPatient().getFullName()+";";
						if(invoice.getPatient().getActivePrivate()!=null){
							reportline+=((AdminPrivateContact)invoice.getPatient().getActivePrivate()).telephone+";";
						}
						else{
							reportline+=";";
						}
					}
					else{
						reportline+=";;";
					}
					reportline+=invoice.getPatientAmount()+";";
					reportline+=invoice.getAmountPaid()+";";
					reportline+=invoice.getBalance()+";";
					reportline+=invoice.getEstimatedDeliveryDate()+";\r\n";
					report.add(reportline);
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return report;
	}

	public static Vector getInsuranceReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="SALES ORDER NR;";
		reportline+="INSURANCE NR;";
		reportline+="INSURANCE NAME;";
		reportline+="CUSTOMER NAME;";
		reportline+="IP NR;";
		reportline+="ITEM CODE;";
		reportline+="TOTAL AMOUNT;";
		reportline+="INVOICE STATUS;";
		reportline+="SALES EMPLOYEE;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							reportline="";
							reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
							if(productionOrder.getDebetUid()!=null){
								Debet debet = Debet.get(productionOrder.getDebetUid());
								if(debet!=null && debet.getPatientInvoice()!=null && debet.getPrestation()!=null && debet.getPatientInvoice().getInsurarAmount()>0 && debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
									reportline+=debet.getPatientInvoiceUid()+";";
									reportline+=debet.getInsurance().getInsurarUid()+";";
									reportline+=debet.getInsurance().getInsurar().getName()+";";
									reportline+=debet.getPatientInvoice().getPatient().getFullName()+";";
									reportline+=debet.getPatientInvoice().getPatientUid()+";";
									reportline+=debet.getPrestation().getCode()+";";
									reportline+=debet.getPatientInvoice().getInsurarAmount()+";";
									reportline+=debet.getPatientInvoice().getStatus()+";";
									reportline+=User.getFullUserName(debet.getUpdateUser())+";";
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
	
	public static Vector getSalesAnalysisReport(String serviceStockUid, java.util.Date begin, java.util.Date end){
		Vector report=new Vector();
		String reportline="";
		//Header
		reportline+="ORDER DATE;";
		reportline+="CREATED BY;";
		reportline+="SALES ORDER NR;";
		reportline+="IP NR;";
		reportline+="CUSTOMER NAME;";
		reportline+="ITEM CODE;";
		reportline+="ITEM DESCRIPTION;";
		reportline+="UNIT AMOUNT;";
		reportline+="TOTAL AMOUNT;";
		reportline+="PATIENT AMOUNT;";
		reportline+="PATIENT AMOUNT PAID;";
		reportline+="PATIENT BALANCE AMOUNT;";
		reportline+="INVOICE STATUS;";
		reportline+="COST OF SALE;";
		reportline+="GROSS PROFIT;\r\n";
		report.add(reportline);
		ServiceStock serviceStock = ServiceStock.get(serviceStockUid);
		if(serviceStock!=null && serviceStock.hasValidUid()){
			try {
				Vector productionOrders = ProductionOrder.getProductionOrders(begin,end,serviceStockUid);
				for(int n=0;n<productionOrders.size();n++){
					ProductionOrder productionOrder = (ProductionOrder)productionOrders.elementAt(n);
					if(productionOrder!=null && productionOrder.getProductStock()!=null){
						Product product = productionOrder.getProductStock().getProduct();
						if(product!=null){
							reportline="";
							reportline+=ScreenHelper.formatDate(productionOrder.getCreateDateTime())+";";
							reportline+=MedwanQuery.getInstance().getUserName(Integer.parseInt(productionOrder.getUpdateUser(1)))+";";
							if(productionOrder.getDebetUid()!=null){
								Debet debet = Debet.get(productionOrder.getDebetUid());
								if(debet!=null && debet.getPatientInvoice()!=null && debet.getPrestation()!=null){
									reportline+=debet.getPatientInvoiceUid()+";";
									reportline+=debet.getPatientInvoice().getPatientUid()+";";
									reportline+=debet.getPatientInvoice().getPatient().getFullName()+";";
									reportline+=debet.getPrestation().getCode()+";";
									reportline+=debet.getPrestation().getDescription()+";";
									double totalamount=debet.getPatientInvoice().getPatientAmount()+debet.getPatientInvoice().getInsurarAmount()+debet.getPatientInvoice().getExtraInsurarAmount()+debet.getPatientInvoice().getExtraInsurarAmount2();
									reportline+=(totalamount)/debet.getQuantity()+";";
									reportline+=totalamount+";";
									reportline+=debet.getPatientInvoice().getPatientAmount()+";";
									double paid = debet.getPatientInvoice().getAmountPaid();
									if(paid>totalamount){
										paid=totalamount;
									}
									reportline+=paid+";";
									reportline+=(debet.getPatientInvoice().getPatientAmount()-paid)+";";
									reportline+=debet.getPatientInvoice().getStatus()+";";
									//Now we must calculate the cost of the raw materials
									double cost = 0;
									Vector materials = productionOrder.getMaterials();
									for(int q=0;q<materials.size();q++){
										ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(q);
										if(material!=null && material.getProductStock()!=null && material.getProductStock().getProduct()!=null){
											cost+=material.getQuantity()*material.getProductStock().getProduct().getLastYearsAveragePrice();
										}
									}									
									reportline+=cost+";";
									reportline+=(totalamount-cost)+";";
									report.add(reportline+"\r\n");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return report;
	}
}
