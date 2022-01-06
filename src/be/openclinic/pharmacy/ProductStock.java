package be.openclinic.pharmacy;
import be.openclinic.common.OC_Object;
import be.openclinic.common.ObjectReference;
import be.openclinic.system.SH;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.tools.sendHtmlMail;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Miscelaneous;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Vector;

import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import java.util.GregorianCalendar;
import java.util.Calendar;
import java.sql.*;

import net.admin.AdminPerson;
import net.admin.Service;
import webcab.lib.statistics.statistics.BasicStatistics;
import webcab.lib.statistics.statistics.StatisticsException;
/**
 * User: Frank Verbeke, Stijn Smets
 * Date: 10-sep-2006
 */
public class ProductStock extends OC_Object implements Comparable {
    private ServiceStock serviceStock;
    private Product product;
    private int level = -1;
    private int minimumLevel = -1;
    private int maximumLevel = -1;
    private int orderLevel = -1;
    private Date begin;
    private Date end;
    private String defaultImportance; // (native|high|low)
    private Service supplier;
    private String location;
    
    public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	
    public Element getInitElement() {
    	int batchedQuantity=0;
    	Element p = DocumentHelper.createElement("productstock");
        p.addAttribute("level",SH.c(getLevel()+""));
        p.addAttribute("minimumlevel",SH.c(getMinimumLevel()+""));
        p.addAttribute("maximumlevel",SH.c(getMaximumLevel()+""));
        p.addAttribute("orderlevel",SH.c(getOrderLevel()+""));
        Element product=p.addElement("product");
        product.addAttribute("code",SH.c(getProduct().getCode()));
        product.addAttribute("atccode",SH.c(getProduct().getAtccode()));
        product.addAttribute("rxnormcode",SH.c(getProduct().getRxnormcode()));
        product.addElement("name").setText(getProduct().getName());
        product.addElement("dose").setText(getProduct().getDose());
        product.addElement("unit").setText(getProduct().getUnit());
        product.addElement("unitprice").setText(getProduct().getUnitPrice()+"");
        product.addElement("packageunits").setText(getProduct().getPackageUnits()+"");
    	Vector<Batch> batches = getActiveBatches();
    	for(int n=0;n<batches.size();n++) {
    		Batch batch = batches.elementAt(n);
    		batchedQuantity+=batch.getLevel();
    		Element b = p.addElement("batch");
    		b.addAttribute("level", batch.getLevel()+"");
    		b.addAttribute("number", batch.getBatchNumber());
    		b.addAttribute("expiry", SH.formatDate(batch.getEnd()));
    	}
    	if(getLevel()>batchedQuantity) {
    		Element b = p.addElement("batch");
    		b.addAttribute("level", (getLevel()-batchedQuantity)+"");
    		b.addAttribute("number", "?");
    		b.addAttribute("expiry", "");
    	}
    	return p;
    }

	public int getMaxNumberOfKits() {
		int nKits=-1;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs=null;
    	PreparedStatement ps=null;
		try {
			ps = conn.prepareStatement("select sum(OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY) OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY,OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID from oc_productkits where OC_PRODUCTKIT_TARGETPRODUCTSTOCKUID=? group by OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID order by oc_productkit_sourceproductstockuid");
			ps.setString(1, getUid());
			rs = ps.executeQuery();
			while(rs.next()) {
				ProductStock stock = ProductStock.get(rs.getString("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID"));
				int quantity = rs.getInt("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY");
				int maxkits = stock.getLevel()/quantity;
				if(nKits==-1 || nKits>maxkits) {
					nKits=maxkits;
				}
			}
    	}
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
		return Math.max(0, nKits);
	}
	
	public int createKits(int numberOfKits, String userid) {
		int nCreated=0;
		if(numberOfKits<=getMaxNumberOfKits()) {
			for(int n=0;n<numberOfKits;n++) {
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		    	ResultSet rs=null;
		    	PreparedStatement ps=null;
				try {
					ps = conn.prepareStatement("select sum(OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY) OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY,OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID from oc_productkits where OC_PRODUCTKIT_TARGETPRODUCTSTOCKUID=? group by OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID order by oc_productkit_sourceproductstockuid");
					ps.setString(1, getUid());
					rs = ps.executeQuery();
					while(rs.next()) {
						ProductStock stock = ProductStock.get(rs.getString("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKUID"));
						int quantity = rs.getInt("OC_PRODUCTKIT_SOURCEPRODUCTSTOCKQUANTITY");
						int deliveredquantity=0;
						while(deliveredquantity<quantity) {
							//Get the right batch from the productStock() if batches have been defined;
							int operationQuantity=0;
							String sBatchUid="";
							Vector vBatches = stock.getActiveBatches();
							if(vBatches.size()>0) {
								Batch batch = (Batch)vBatches.elementAt(0);
								if(batch.getLevel()>0) {
									sBatchUid=batch.getUid();
									if(quantity-deliveredquantity<=batch.getLevel()) {
										operationQuantity=quantity-deliveredquantity;
									}
									else {
										operationQuantity=batch.getLevel();
									}
								}
							}
							else {
								operationQuantity=quantity-deliveredquantity;
							}
								
							ProductStockOperation operation = new ProductStockOperation();
							operation.setUid("-1");
							operation.setBatchUid(sBatchUid);
							operation.setDate(new java.util.Date()); // now
							operation.setDescription(MedwanQuery.getInstance().getConfigString("medicationDeliveryToKit","medicationdelivery.kit"));
							operation.setProductStockUid(stock.getUid());
							operation.setSourceDestination(new ObjectReference("kit",getUid()));
							operation.setUnitsChanged(operationQuantity);
							operation.setComment("Kit creation");
							operation.setUpdateDateTime(new java.util.Date());
							operation.setUpdateUser(userid);
							operation.setVersion(1);
							operation.setPrescriptionUid("");
							operation.setEncounterUID("");
							operation.store();
							deliveredquantity+=operationQuantity;
						}
					}
		    	}
		        catch(Exception e){
		            e.printStackTrace();
		        }
		        finally{
		            try{
		                if(rs!=null) rs.close();
		                if(ps!=null) ps.close();
		                conn.close();
		            }
		            catch(SQLException se){
		                se.printStackTrace();
		            }
		        }
				nCreated++;
			}
		}
		//All source products were removed from stock. Now create incoming operation
		ProductStockOperation operation = new ProductStockOperation();
		operation.setUid("-1");
		operation.setDate(new java.util.Date()); // now
		operation.setDescription(MedwanQuery.getInstance().getConfigString("medicationReceiptForKit","medicationreceipt.kit"));
		operation.setProductStockUid(this.getUid());
		operation.setSourceDestination(new ObjectReference("kit",""));
		operation.setUnitsChanged(nCreated);
		operation.setComment("Kit creation");
		operation.setUpdateDateTime(new java.util.Date());
		operation.setUpdateUser(userid);
		operation.setVersion(1);
		operation.setPrescriptionUid("");
		operation.setEncounterUID("");
		operation.store();

		return nCreated;
	}

    public boolean isKit() {
    	boolean bKit=false;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs=null;
    	PreparedStatement ps=null;
    	try {
    		ps=conn.prepareStatement("select * from oc_productkits where oc_productkit_targetproductstockuid=?");
    		ps.setString(1, getUid());
    		rs=ps.executeQuery();
    		bKit=rs.next();
    	}
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
    	return bKit;
    }
    
	// non-db data
    private String serviceStockUid;
    private String productUid;
    private String supplierUid;
    //--- SERVICE STOCK ---------------------------------------------------------------------------
    public ServiceStock getServiceStock() {
        if (serviceStockUid != null && serviceStockUid.length() > 0) {
            if (serviceStock == null) {
                this.setServiceStock(ServiceStock.get(serviceStockUid));
            }
        }
        return serviceStock;
    }
    public void setServiceStock(ServiceStock serviceStock) {
        this.serviceStock = serviceStock;
    }
    //--- PRODUCT ---------------------------------------------------------------------------------
    public Product getProduct() {
        if (productUid != null && productUid.length() > 0) {
            if (product == null) {
                this.setProduct(Product.get(productUid));
            }
        }
        return product;
    }
    public Vector getBatches(){
    	return Batch.getBatches(this.getUid());
    }
    public Vector getAllBatches(){
    	return Batch.getAllBatches(this.getUid());
    }
    public Vector getActiveBatches(){
    	return Batch.getActiveBatches(this.getUid());
    }
    public Vector getAllProductStockOperations(){
    	return ProductStockOperation.getAll(this.getUid());
    }
    public void setProduct(Product product) {
        this.product = product;
    }
    public boolean hasOpenDeliveries(){
    	return ProductStockOperation.getOpenProductStockDeliveries(getServiceStockUid(), getProductUid()).size()>0;
    }
    public Vector getOpenDeliveries(){
    	return ProductStockOperation.getOpenProductStockDeliveries(getServiceStockUid(), getProductUid());
    }
    public int getAverageConsumption(Date date, boolean bIncludePatients, boolean bIncludeStocks, boolean bOther){
    	int consumption = 0;
    	String destinationtypes="'$$$'";
    	if(bOther){
    		destinationtypes+=",''";
    	}
    	if(bIncludePatients){
    		destinationtypes+=",'patient'";
    	}
    	if(bIncludeStocks){
    		destinationtypes+=",'servicestock'";
    	}
    	String sQuery="select sum(total) total,min(year) minyear,min(month) minmonth from (select sum(oc_operation_unitschanged) total,year(oc_operation_date) year,month(oc_operation_date) month from oc_productstockoperations where oc_operation_description like '%delivery%' and oc_operation_srcdesttype in ("+destinationtypes+") and oc_operation_productstockuid=? and oc_operation_date<=? group by year(oc_operation_date),month(oc_operation_date)) a";
    	Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	PreparedStatement ps = oc_conn.prepareStatement(sQuery);
        	ps.setString(1, getUid());
        	ps.setTimestamp(2, new java.sql.Timestamp(date.getTime()));
        	ResultSet rs = ps.executeQuery();
        	if (rs.next()){
        		try {
        			consumption = rs.getInt("total");
        			int months = 1+Integer.parseInt(new SimpleDateFormat("yyyy").format(date))*12+Integer.parseInt(new SimpleDateFormat("MM").format(date))- rs.getInt("minyear")*12-rs.getInt("minmonth");
        			consumption = consumption/months;
        		}
        		catch(Exception q){}
        	}
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
    	return consumption;
    }

    public long getMedianConsumption(int months, boolean bIncludePatients, boolean bIncludeStocks, boolean bOther){
    	Date date = ScreenHelper.parseDate(new SimpleDateFormat("01/MM/yyyy").format(new Date()));
    	date.setTime(date.getTime()-1);
    	long consumption = 0;
    	String destinationtypes="'$$$'";
    	if(bOther){
    		destinationtypes+=",''";
    	}
    	if(bIncludePatients){
    		destinationtypes+=",'patient'";
    	}
    	if(bIncludeStocks){
    		destinationtypes+=",'servicestock'";
    	}
    	String sQuery="select sum(oc_operation_unitschanged) total,year(oc_operation_date) year,month(oc_operation_date) month from oc_productstockoperations where oc_operation_description like '%delivery%' and oc_operation_srcdesttype in ("+destinationtypes+") and oc_operation_productstockuid=? and oc_operation_date>? and oc_operation_date<=? group by year(oc_operation_date),month(oc_operation_date)";
    	Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        double[] values = new double[months];
        try{
        	PreparedStatement ps = oc_conn.prepareStatement(sQuery);
        	ps.setString(1, getUid());
        	ps.setTimestamp(2, new java.sql.Timestamp(Miscelaneous.addMonthsToDate(date, -months).getTime()));
        	ps.setTimestamp(3, new java.sql.Timestamp(date.getTime()));
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		values[(date.getYear()+1900-rs.getInt("year"))*12+date.getMonth()+1-rs.getInt("month")]=rs.getInt("total");
        	}
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        BasicStatistics basicStatistics = new BasicStatistics(values);
        try {
			consumption=Math.round(basicStatistics.median());
		} catch (StatisticsException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return consumption;
    }
    
    public int getUnbatchedLevel(){
    	int level = getLevel();
    	Vector batches = getBatches();
    	for(int n=0;n<batches.size();n++){
    		Batch batch = (Batch)batches.elementAt(n);
    		level-=batch.getLevel();
    	}
    	return level;
    }

    public long getAverageConsumption(int months, boolean bIncludePatients, boolean bIncludeStocks, boolean bOther){
    	Date date = ScreenHelper.parseDate(new SimpleDateFormat("01/MM/yyyy").format(new Date()));
    	date.setTime(date.getTime()-1);
    	long consumption = 0;
    	String destinationtypes="'$$$'";
    	if(bOther){
    		destinationtypes+=",''";
    	}
    	if(bIncludePatients){
    		destinationtypes+=",'patient'";
    	}
    	if(bIncludeStocks){
    		destinationtypes+=",'servicestock'";
    	}
    	String sQuery="select sum(oc_operation_unitschanged) total,year(oc_operation_date) year,month(oc_operation_date) month from oc_productstockoperations where oc_operation_description like '%delivery%' and oc_operation_srcdesttype in ("+destinationtypes+") and oc_operation_productstockuid=? and oc_operation_date>? and oc_operation_date<=? group by year(oc_operation_date),month(oc_operation_date)";
    	Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        double[] values = new double[months];
        try{
        	PreparedStatement ps = oc_conn.prepareStatement(sQuery);
        	ps.setString(1, getUid());
        	ps.setTimestamp(2, new java.sql.Timestamp(Miscelaneous.addMonthsToDate(date, -months).getTime()));
        	ps.setTimestamp(3, new java.sql.Timestamp(date.getTime()));
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		values[(date.getYear()+1900-rs.getInt("year"))*12+date.getMonth()+1-rs.getInt("month")]=rs.getInt("total");
        	}
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        BasicStatistics basicStatistics = new BasicStatistics(values);
        try {
			consumption=Math.round(basicStatistics.arithmeticMean());
		} catch (StatisticsException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return consumption;
    }

    //--- LEVEL -----------------------------------------------------------------------------------
    public int getLevel() {
        return level;
    }
    
    public int getAvailableLevel() {
        return level-getExpiredProducts();
    }
    
	public static void updateId(String sql,String keepid,String deleteid){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps=conn.prepareStatement(sql);
			ps.setString(1, keepid);
			ps.setString(2, deleteid);
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static void mergeProducts(){
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sQuery = "select count(*),oc_stock_productuid,oc_stock_servicestockuid from oc_productstocks" +
                    " group by oc_stock_productuid,oc_stock_servicestockuid having count(*)>1";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String productuid = rs.getString("oc_stock_productuid");
                String servivicestockuid = rs.getString("oc_stock_servicestockuid");
                Vector products = ProductStock.find(servivicestockuid, productuid, "", "", "", "", "", "", "", "", "", "oc_stock_productuid", "asc");
                ProductStock remainingProductStock=null;
                for(int n=0;n<products.size();n++){
                	if(n==0){
                		remainingProductStock=(ProductStock)products.elementAt(n);
                	}
                	else{
                		ProductStock p = (ProductStock)products.elementAt(n);
                		//First move the remaining products to the remaining stock
                		remainingProductStock.setLevel(remainingProductStock.getLevel()+p.getLevel());
                		remainingProductStock.store();
                		//Now update any existing references to this productstock
        				updateId("update oc_batches set OC_BATCH_PRODUCTSTOCKUID=? where OC_BATCH_PRODUCTSTOCKUID=?",remainingProductStock.getUid(),p.getUid());
        				updateId("update OC_PRODUCTSTOCKOPERATIONS set OC_OPERATION_PRODUCTSTOCKUID=? where OC_OPERATION_PRODUCTSTOCKUID=?",remainingProductStock.getUid(),p.getUid());
        				updateId("update OC_PRODUCTIONORDERMATERIALS set OC_MATERIAL_PRODUCTSTOCKUID=? where OC_MATERIAL_PRODUCTSTOCKUID=?",remainingProductStock.getUid(),p.getUid());
        				updateId("update OC_PRODUCTORDERS set OC_ORDER_PRODUCTSTOCKUID=? where OC_ORDER_PRODUCTSTOCKUID=?",remainingProductStock.getUid(),p.getUid());
        				updateId("update OC_USERPRODUCTS set OC_PRODUCT_PRODUCTSTOCKUID=? where OC_PRODUCT_PRODUCTSTOCKUID=?",remainingProductStock.getUid(),p.getUid());
        				updateId("update oc_drugsoutlist set oc_list_productstockuid=? where oc_list_productstockuid=?",remainingProductStock.getUid(),p.getUid());
        				ProductStock.delete(p.getUid());
                	}
                }
            }
            rs.close();
            ps.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    
    public int getReceivedForProductionOrder(String productionOrderId){
    	int netReceived=0;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sQuery = "select SUM(OC_operation_unitschanged) as total from OC_PRODUCTstockoperations" +
                    " where" +
                    " OC_operation_productionorderuid=? and" +
                    " OC_operation_receiveproductstockuid=? and"
                    + " oc_operation_description like 'medicationdelivery%'";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setString(1, productionOrderId);
            ps.setString(2, getUid());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                netReceived = rs.getInt("total");
            }
            rs.close();
            ps.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return netReceived;
    }
    
    public int getLevelIncludingOpenCommands() {
        int level = getLevel();
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sQuery = "select SUM(OC_ORDER_PACKAGESORDERED) as total from OC_PRODUCTORDERS" +
                    " where" +
                    " OC_ORDER_PRODUCTSTOCKUID=? and" +
                    " OC_ORDER_DATEDELIVERED is null";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setString(1, getUid());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                level += rs.getInt("total");
            }
            rs.close();
            ps.close();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return level;
    }
    public void setLevel(int level) {
        this.level = level;
    }
    //--- MINIMUM LEVEL ---------------------------------------------------------------------------
    public int getMinimumLevel() {
        return minimumLevel;
    }
    public void setMinimumLevel(int minimumLevel) {
        this.minimumLevel = minimumLevel;
    }
    //--- MAXIMUM LEVEL ---------------------------------------------------------------------------
    public int getMaximumLevel() {
        return maximumLevel;
    }
    public void setMaximumLevel(int maximumLevel) {
        this.maximumLevel = maximumLevel;
    }
    //--- ORDER LEVEL -----------------------------------------------------------------------------
    public int getOrderLevel() {
        return orderLevel;
    }
    public void setOrderLevel(int orderLevel) {
        this.orderLevel = orderLevel;
    }
    //--- DATE BEGIN ------------------------------------------------------------------------------
    public Date getBegin() {
        return begin;
    }
    public void setBegin(Date begin) {
        this.begin = begin;
    }
    //--- DATE END --------------------------------------------------------------------------------
    public Date getEnd() {
        return end;
    }
    public void setEnd(Date end) {
        this.end = end;
    }
    //--- DEFAULT IMPORTANCE ----------------------------------------------------------------------
    public String getDefaultImportance() {
        return defaultImportance;
    }
    public void setDefaultImportance(String defaultImportance) {
        this.defaultImportance = defaultImportance;
    }
    //--- SUPPLIER --------------------------------------------------------------------------------
    public Service getSupplier() {
        if (supplierUid != null && supplierUid.length() > 0) {
            if (supplier == null) {
                this.setSupplier(Service.getService(supplierUid));
            }
        }
        return this.supplier;
    }
    public void setSupplier(Service supplier) {
        this.supplier = supplier;
    }
    //--- NON-DB DATA : SERVICE STOCK UID ---------------------------------------------------------
    public void setServiceStockUid(String uid) {
        this.serviceStockUid = uid;
    }
    public String getServiceStockUid() {
        return this.serviceStockUid;
    }
    //--- NON-DB DATA : PRODUCT UID ---------------------------------------------------------------
    public void setProductUid(String uid) {
        this.productUid = uid;
    }
    public String getProductUid() {
        return this.productUid;
    }
    //--- NON-DB DATA : SUPPLIER UID --------------------------------------------------------------
    public void setSupplierUid(String uid) {
        this.supplierUid = uid;
    }
    public String getSupplierUid() {
        return this.supplierUid;
    }
    //--- GET -------------------------------------------------------------------------------------
    public static ProductStock get(String stockUid) {
        ProductStock stock = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	if(stockUid.split("\\.").length<2){
        		return null;
        	}
            String sSelect = "SELECT * FROM OC_PRODUCTSTOCKS" +
                    " WHERE OC_STOCK_SERVERID = ? AND OC_STOCK_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1, Integer.parseInt(stockUid.substring(0, stockUid.indexOf("."))));
            ps.setInt(2, Integer.parseInt(stockUid.substring(stockUid.indexOf(".") + 1)));
            rs = ps.executeQuery();

            // get data from DB
            if (rs.next()) {
                stock = new ProductStock();
                stock.setUid(stockUid);
                stock.setServiceStockUid(rs.getString("OC_STOCK_SERVICESTOCKUID"));
                stock.setProductUid(rs.getString("OC_STOCK_PRODUCTUID"));
                stock.setDefaultImportance(rs.getString("OC_STOCK_DEFAULTIMPORTANCE")); // (native|high|low)
                stock.setSupplierUid(rs.getString("OC_STOCK_SUPPLIERUID"));

                // levels
                stock.setLevel(rs.getInt("OC_STOCK_LEVEL"));
                stock.setMinimumLevel(rs.getInt("OC_STOCK_MINIMUMLEVEL"));

                // maximumLevel
                String tmpValue = rs.getString("OC_STOCK_MAXIMUMLEVEL");
                if (tmpValue != null) {
                    stock.setMaximumLevel(Integer.parseInt(tmpValue));
                }

                // orderLevel
                tmpValue = rs.getString("OC_STOCK_ORDERLEVEL");
                if (tmpValue != null) {
                    stock.setOrderLevel(Integer.parseInt(tmpValue));
                }

                // dates
                stock.setBegin(rs.getDate("OC_STOCK_BEGIN"));
                stock.setEnd(rs.getDate("OC_STOCK_END"));

                // OBJECT variables
                stock.setCreateDateTime(rs.getTimestamp("OC_STOCK_CREATETIME"));
                stock.setUpdateDateTime(rs.getTimestamp("OC_STOCK_UPDATETIME"));
                stock.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_STOCK_UPDATEUID")));
                stock.setVersion(rs.getInt("OC_STOCK_VERSION"));
                stock.setLocation(rs.getString("OC_STOCK_LOCATION"));
            } else {
                throw new Exception("ERROR : PRODUCTSTOCK " + stockUid + " NOT FOUND");
            }
        }
        catch (Exception e) {
            if (e.getMessage().endsWith("NOT FOUND")) {
                Debug.println(e.getMessage());
            } else {
                e.printStackTrace();
            }
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return stock;
    }
    //--- GET (2 parameters) ----------------------------------------------------------------------
    public static ProductStock get(String productUid, String supplyingServiceUid) {
        ProductStock productStock = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            // compose query
            String sSelect = "SELECT * FROM OC_PRODUCTSTOCKS" +
                    " WHERE OC_STOCK_PRODUCTUID = ?" +
                    "  AND OC_STOCK_SERVICESTOCKUID = ?";

            // set questionmark values
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, productUid);
            ps.setString(2, supplyingServiceUid);

            // execute
            rs = ps.executeQuery();
            if (rs.next()) {
                productStock = ProductStock.get(rs.getString("OC_STOCK_SERVERID") + "." + rs.getString("OC_STOCK_OBJECTID"));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return productStock;
    }
    //--- STORE -----------------------------------------------------------------------------------
    public void store() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            if (this.getUid().equals("-1")) {
                // insert new version of stock into current stocks
                if (Debug.enabled) Debug.println("@@@ PRODUCTSTOCK INSERT @@@");
                sSelect = "INSERT INTO OC_PRODUCTSTOCKS (OC_STOCK_SERVERID, OC_STOCK_OBJECTID," +
                        "  OC_STOCK_SERVICESTOCKUID, OC_STOCK_PRODUCTUID, OC_STOCK_LEVEL," +
                        "  OC_STOCK_MINIMUMLEVEL, OC_STOCK_MAXIMUMLEVEL, OC_STOCK_ORDERLEVEL," +
                        "  OC_STOCK_BEGIN, OC_STOCK_END, OC_STOCK_DEFAULTIMPORTANCE, OC_STOCK_SUPPLIERUID," +
                        "  OC_STOCK_CREATETIME, OC_STOCK_UPDATETIME, OC_STOCK_UPDATEUID, OC_STOCK_VERSION,OC_STOCK_LOCATION)" +
                        " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,1,?)";
                ps = oc_conn.prepareStatement(sSelect);
                int questionMarkIdx = 1;

                // set new servicestockuid
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId");
                int productStockCounter = MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTSTOCKS");
                ps.setInt(questionMarkIdx++, serverId);
                ps.setInt(questionMarkIdx++, productStockCounter);
                this.setUid(serverId + "." + productStockCounter);
                ps.setString(questionMarkIdx++, this.getServiceStockUid());
                ps.setString(questionMarkIdx++, this.getProductUid());
                ps.setInt(questionMarkIdx++, this.getLevel());
                ps.setInt(questionMarkIdx++, this.getMinimumLevel());

                // if maximumLevel not specified, do not save it
                if (this.getMaximumLevel() > -1) ps.setInt(questionMarkIdx++, this.getMaximumLevel());
                else ps.setNull(questionMarkIdx++, Types.INTEGER);

                // if orderLevel not specified, do not save it
                if (this.getOrderLevel() > -1) ps.setInt(questionMarkIdx++, this.getOrderLevel());
                else ps.setNull(questionMarkIdx++, Types.INTEGER);

                // date begin
                if (this.begin != null)
                    ps.setTimestamp(questionMarkIdx++, new java.sql.Timestamp(this.begin.getTime()));
                else ps.setNull(questionMarkIdx++, Types.TIMESTAMP);

                // date end
                if (this.end != null) ps.setTimestamp(questionMarkIdx++, new java.sql.Timestamp(end.getTime()));
                else ps.setNull(questionMarkIdx++, Types.TIMESTAMP);

                // default importance
                if (this.getDefaultImportance()!=null && this.getDefaultImportance().length() > 0)
                    ps.setString(questionMarkIdx++, this.getDefaultImportance());
                else ps.setNull(questionMarkIdx++, Types.VARCHAR);

                // supplier
                if (this.getSupplierUid()!=null && this.getSupplierUid().length() > 0) ps.setString(questionMarkIdx++, this.getSupplierUid());
                else ps.setNull(questionMarkIdx++, Types.VARCHAR);

                // OBJECT variables
                ps.setTimestamp(questionMarkIdx++, new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setTimestamp(questionMarkIdx++, new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(questionMarkIdx++, this.getUpdateUser());
                ps.setString(questionMarkIdx++, this.getLocation());
                ps.executeUpdate();
                if(this.getLevel()!=0){
                    //An initial productstockoperation must be created for generating the first stock level
                	ProductStockOperation operation = new ProductStockOperation();
                	operation.setUid("-1");
                	operation.setCreateDateTime(new java.util.Date());
                	operation.setDate(this.begin);
                	operation.setDescription("medicationreceipt.99");
                	operation.setProductStockUid(this.getUid());
                	operation.setReceiveComment("initial stock");
                	operation.setUnitsChanged(this.getLevel());
                	operation.setUpdateDateTime(new java.util.Date());
                	operation.setUpdateUser(this.getUpdateUser());
                	operation.setVersion(1);
                	ObjectReference sourceDestination=new ObjectReference("supplier","?");
                	operation.setSourceDestination(sourceDestination);
                	operation.storeNoProductStockUpdate();
                }
                
            } else {
            	ProductStock oldVersion = ProductStock.get(getUid());
                //***** UPDATE *****
            	//First copy record to history
                sSelect = "INSERT INTO OC_PRODUCTSTOCKS_HISTORY(OC_STOCK_SERVERID, OC_STOCK_OBJECTID," +
                        "  OC_STOCK_SERVICESTOCKUID, OC_STOCK_PRODUCTUID, OC_STOCK_LEVEL," +
                        "  OC_STOCK_MINIMUMLEVEL, OC_STOCK_MAXIMUMLEVEL, OC_STOCK_ORDERLEVEL," +
                        "  OC_STOCK_BEGIN, OC_STOCK_END, OC_STOCK_DEFAULTIMPORTANCE, OC_STOCK_SUPPLIERUID," +
                        "  OC_STOCK_CREATETIME, OC_STOCK_UPDATETIME, OC_STOCK_UPDATEUID, OC_STOCK_VERSION,OC_STOCK_LOCATION) "
                        + "SELECT OC_STOCK_SERVERID, OC_STOCK_OBJECTID," +
                        "  OC_STOCK_SERVICESTOCKUID, OC_STOCK_PRODUCTUID, OC_STOCK_LEVEL," +
                        "  OC_STOCK_MINIMUMLEVEL, OC_STOCK_MAXIMUMLEVEL, OC_STOCK_ORDERLEVEL," +
                        "  OC_STOCK_BEGIN, OC_STOCK_END, OC_STOCK_DEFAULTIMPORTANCE, OC_STOCK_SUPPLIERUID," +
                        "  OC_STOCK_CREATETIME, OC_STOCK_UPDATETIME, OC_STOCK_UPDATEUID, OC_STOCK_VERSION,OC_STOCK_LOCATION FROM OC_PRODUCTSTOCKS WHERE OC_STOCK_SERVERID = ? AND OC_STOCK_OBJECTID = ?";
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setInt(1,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
	            ps.setInt(2,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));
	            ps.executeUpdate();
	            if(ps!=null) ps.close();

                if (Debug.enabled) Debug.println("@@@ PRODUCTSTOCK UPDATE @@@");
                sSelect = "UPDATE OC_PRODUCTSTOCKS SET" +
                        "  OC_STOCK_SERVICESTOCKUID=?, OC_STOCK_PRODUCTUID=?, OC_STOCK_LEVEL=?," +
                        "  OC_STOCK_MINIMUMLEVEL=?, OC_STOCK_MAXIMUMLEVEL=?, OC_STOCK_ORDERLEVEL=?," +
                        "  OC_STOCK_BEGIN=?, OC_STOCK_END=?, OC_STOCK_DEFAULTIMPORTANCE=?, OC_STOCK_SUPPLIERUID=?," +
                        "  OC_STOCK_UPDATETIME=?, OC_STOCK_UPDATEUID=?, OC_STOCK_VERSION=(OC_STOCK_VERSION+1),OC_STOCK_LOCATION=?" +
                        " WHERE OC_STOCK_SERVERID=? AND OC_STOCK_OBJECTID=?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1, this.getServiceStockUid());
                ps.setString(2, this.getProductUid());
                ps.setInt(3, this.getLevel());
                ps.setInt(4, this.getMinimumLevel());

                // if maximumLevel not specified, do not save it
                if (this.getMaximumLevel() > -1) ps.setInt(5, this.getMaximumLevel());
                else ps.setNull(5, Types.INTEGER);

                // if orderLevel not specified, do not save it
                if (this.getOrderLevel() > -1) ps.setInt(6, this.getOrderLevel());
                else ps.setNull(6, Types.INTEGER);

                // date begin
                if (this.begin != null) ps.setTimestamp(7, new java.sql.Timestamp(this.begin.getTime()));
                else ps.setNull(7, Types.TIMESTAMP);

                // date end
                if (this.end != null) ps.setTimestamp(8, new java.sql.Timestamp(end.getTime()));
                else ps.setNull(8, Types.TIMESTAMP);

                // default importance
                if (this.getDefaultImportance()!=null && this.getDefaultImportance().length() > 0) ps.setString(9, this.getDefaultImportance());
                else ps.setString(9, "");

                // supplier
                if (this.getSupplierUid()!=null && this.getSupplierUid().length() > 0) ps.setString(10, this.getSupplierUid());
                else ps.setNull(10, Types.VARCHAR);

                // OBJECT variables
                ps.setTimestamp(11, new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(12, this.getUpdateUser());
                ps.setString(13, this.getLocation());

                // where
                ps.setInt(14, Integer.parseInt(this.getUid().substring(0, this.getUid().indexOf("."))));
                ps.setInt(15, Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".") + 1)));
                ps.executeUpdate();
                
                //If stock level went below minimumlevel, send email to stock manager
                if(MedwanQuery.getInstance().getConfigInt("enablePharmacyEmailWarnings",0)==1 && oldVersion.getMinimumLevel()<=oldVersion.getLevel() && getLevel()<getMinimumLevel()){
                	AdminPerson stockManager = getServiceStock().getStockManager();
                	if(stockManager.getActivePrivate()!=null && ScreenHelper.checkString(stockManager.getActivePrivate().email).length()>0){
                		sendHtmlMail.sendSimpleMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), MedwanQuery.getInstance().getConfigString("SA.MailAddress","frank.verbeke@post-factum.be"), stockManager.getActivePrivate().email,ScreenHelper.getTranNoLink("pharmacy", "productbelowminimumlevel", stockManager.language) , ScreenHelper.getTranNoLink("pharmacy", "productbelowminimumlevel", stockManager.language) + ":\n" + ScreenHelper.getTranNoLink("web", "servicestock", stockManager.language)+": "+getServiceStock().getName()+"\n"+ScreenHelper.getTranNoLink("web", "product", stockManager.language)+": "+getProduct().getName()+"\n"+ScreenHelper.getTranNoLink("web", "minimum", stockManager.language)+": "+getMinimumLevel()+"\n"+ScreenHelper.getTranNoLink("web", "level", stockManager.language)+": "+getLevel());
                	}
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
    //--- EXISTS ----------------------------------------------------------------------------------
    // checks the database for a record with the same UNIQUE KEYS as 'this'.
    public String exists() {
        PreparedStatement ps = null;
        ResultSet rs = null;
        String uid = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //***** check existence *****
            String sSql = "SELECT OC_STOCK_SERVERID,OC_STOCK_OBJECTID FROM OC_PRODUCTSTOCKS"+
                          " WHERE OC_STOCK_SERVICESTOCKUID = ?"+
                          "  AND OC_STOCK_PRODUCTUID = ?";
            if(this.end!=null) sSql+= " AND OC_STOCK_END = ?";
            ps = oc_conn.prepareStatement(sSql);
            
            int qmIdx = 1;
            ps.setString(qmIdx++,this.getServiceStockUid());
            ps.setString(qmIdx++,this.getProductUid());
            
            if(this.end!=null) ps.setTimestamp(qmIdx++,new java.sql.Timestamp(end.getTime()));
            
            rs = ps.executeQuery();
            if(rs.next()){
                uid = rs.getInt("OC_STOCK_SERVERID") + "." + rs.getInt("OC_STOCK_OBJECTID");
                Debug.println("@@@ PRODUCTSTOCK exists ("+this.getServiceStockUid()+","+this.getProductUid()+") @@@");
            }
            else{
                Debug.println("@@@ PRODUCTSTOCK does not exist ("+this.getServiceStockUid()+","+this.getProductUid()+") @@@");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
        
        return uid;
    }
    
    public int getExpiredProducts(){
    	int level=0;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("select sum(OC_BATCH_LEVEL) as level from OC_BATCHES where OC_BATCH_LEVEL>0 and OC_BATCH_PRODUCTSTOCKUID=? and OC_BATCH_END<=?");
        	ps.setString(1, this.getUid());
        	ps.setDate(2, new java.sql.Date(new java.util.Date().getTime()));
        	rs=ps.executeQuery();
        	if(rs.next()){
        		level=rs.getInt("level");
        	}
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
    	return level;
    }
    public boolean hasExpiringProducts(int days){
    	boolean bHas=false;
    	long time = days*24*3600;
    	time=time*1000;
    	java.util.Date date = new java.util.Date(new java.util.Date().getTime()+time);
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("select * from OC_BATCHES where OC_BATCH_LEVEL>0 and OC_BATCH_PRODUCTSTOCKUID=? and OC_BATCH_END>=? and OC_BATCH_END<=?");
        	ps.setString(1, this.getUid());
        	ps.setDate(2, new java.sql.Date(new java.util.Date().getTime()));
        	ps.setDate(3, new java.sql.Date(date.getTime()));
        	rs=ps.executeQuery();
        	bHas=rs.next();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
    	return bHas;
    }
    //--- CHANGED ---------------------------------------------------------------------------------
    // checks the database for a record with the same DATA as 'this'.
    public boolean changed() {
        if (Debug.enabled) Debug.println("@@@ PRODUCTSTOCK changed ? @@@");
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean changed = true;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            //***** check existence *****
            String sSelect = "SELECT OC_STOCK_SERVERID,OC_STOCK_OBJECTID FROM OC_PRODUCTSTOCKS" +
                    " WHERE OC_STOCK_SERVICESTOCKUID=?" +
                    "  AND OC_STOCK_PRODUCTUID=?" +
                    "  AND OC_STOCK_LEVEL=?" +
                    "  AND OC_STOCK_MINIMUMLEVEL=?" +
                    "  AND OC_STOCK_MAXIMUMLEVEL=?" +
                    "  AND OC_STOCK_ORDERLEVEL=?" +
                    "  AND OC_STOCK_BEGIN=?" +
                    "  AND OC_STOCK_END=?" +
                    "  AND OC_STOCK_DEFAULTIMPORTANCE=?" +
                    "  AND OC_STOCK_SUPPLIERUID=?";
            ps = oc_conn.prepareStatement(sSelect);
            int questionmarkIdx = 1;
            ps.setString(questionmarkIdx++, this.getServiceStockUid()); // required
            ps.setString(questionmarkIdx++, this.getProductUid()); // required
            ps.setInt(questionmarkIdx++, this.getLevel()); // required
            ps.setInt(questionmarkIdx++, this.getMinimumLevel()); // required

            // if maximumLevel not specified, do not set it
            if (this.getMaximumLevel() > -1) ps.setInt(questionmarkIdx++, this.getMaximumLevel());
            else ps.setNull(questionmarkIdx++, Types.INTEGER);

            // if orderLevel not specified, do not set it
            if (this.getOrderLevel() > -1) ps.setInt(questionmarkIdx++, this.getOrderLevel());
            else ps.setNull(questionmarkIdx++, Types.INTEGER);

            // date begin
            if (this.begin != null) ps.setTimestamp(questionmarkIdx++, new java.sql.Timestamp(this.begin.getTime()));
            else ps.setNull(questionmarkIdx++, Types.TIMESTAMP);

            // date end
            if (this.end != null) ps.setTimestamp(questionmarkIdx++, new java.sql.Timestamp(end.getTime()));
            else ps.setNull(questionmarkIdx++, Types.TIMESTAMP);

            // default importance
            if (this.getDefaultImportance().length() > 0) ps.setString(questionmarkIdx++, this.getDefaultImportance());
            else ps.setNull(questionmarkIdx++, Types.VARCHAR);

            // supplier
            if (this.getSupplierUid().length() > 0) ps.setString(questionmarkIdx++, this.getSupplierUid());
            else ps.setNull(questionmarkIdx++, Types.VARCHAR);
            rs = ps.executeQuery();
            if (rs.next()) changed = false;
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return changed;
    }
    //--- GET DELIVERIES TO PATIENT ---------------------------------------------------------------
    // Return vector containing all deliveries (type of ProductStockOperation) to the specified patient.
    public Vector getDeliveriesToPatient(String patientId) {
        Vector deliveries = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            // compose query
            String sSelect = "SELECT * FROM OC_PRODUCTSTOCKOPERATIONS " +
                    "  WHERE OC_OPERATION_SRCDESTUID = ?" +
                    "   AND OC_OPERATION_PRODUCTSTOCKUID = ?" +
                    "   AND OC_OPERATION_SRCDESTTYPE = 'type2patient'" +
                    "   AND OC_OPERATION_DESCRIPTION LIKE 'medicationdelivery.%'" +
                    " ORDER BY OC_OPERATION_DATE ASC";

            // set questionmark values
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, patientId);
            ps.setString(2, this.getUid());

            // execute
            rs = ps.executeQuery();
            ProductStockOperation delivery = null;
            while (rs.next()) {
                delivery = ProductStockOperation.get(rs.getString("OC_OPERATION_SERVERID") + "." + rs.getString("OC_OPERATION_OBJECTID"));
                deliveries.add(delivery);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return deliveries;
    }
    //--- DELETE ----------------------------------------------------------------------------------
    public static void delete(String productStockUid) {
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "DELETE FROM OC_PRODUCTSTOCKS" +
                    " WHERE OC_STOCK_SERVERID = ? AND OC_STOCK_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1, Integer.parseInt(productStockUid.substring(0, productStockUid.indexOf("."))));
            ps.setInt(2, Integer.parseInt(productStockUid.substring(productStockUid.indexOf(".") + 1)));
            ps.executeUpdate();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
    }
    
    public static Vector findMaterials(){
    	return findMaterials(null);
    }
    
    public static Vector findMaterials(String name){
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	String sQuery="select * from OC_PRODUCTSTOCKS a, OC_PRODUCTS b"
        			+ " where"
        			+ " b.OC_PRODUCT_OBJECTID=replace(OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
        			+ (ScreenHelper.checkString(name).length()==0?"":" (b.OC_PRODUCT_NAME like '%"+name+"%' or b.OC_PRODUCT_CODE like '%"+name+"%') and")
        			+ " b.OC_PRODUCT_PRODUCTSUBGROUP in "+"('"+MedwanQuery.getInstance().getConfigString("ProductProductionMaterialSubGroup","MAT").replaceAll(",","','")+"')"
        			+ " order by OC_PRODUCT_NAME";
        	ps=conn.prepareStatement(sQuery);
        	rs=ps.executeQuery();
        	while(rs.next()){
                ProductStock stock = new ProductStock();
                stock.setUid(rs.getString("OC_STOCK_SERVERID")+"."+rs.getString("OC_STOCK_OBJECTID"));
                stock.setServiceStockUid(rs.getString("OC_STOCK_SERVICESTOCKUID"));
                stock.setProductUid(rs.getString("OC_STOCK_PRODUCTUID"));
                stock.setDefaultImportance(rs.getString("OC_STOCK_DEFAULTIMPORTANCE")); 
                stock.setSupplierUid(rs.getString("OC_STOCK_SUPPLIERUID"));
                stock.setLevel(rs.getInt("OC_STOCK_LEVEL"));
                stock.setMinimumLevel(rs.getInt("OC_STOCK_MINIMUMLEVEL"));
                String tmpValue = rs.getString("OC_STOCK_MAXIMUMLEVEL");
                if (tmpValue != null) {
                    stock.setMaximumLevel(Integer.parseInt(tmpValue));
                }
                tmpValue = rs.getString("OC_STOCK_ORDERLEVEL");
                if (tmpValue != null) {
                    stock.setOrderLevel(Integer.parseInt(tmpValue));
                }
                stock.setBegin(rs.getDate("OC_STOCK_BEGIN"));
                stock.setEnd(rs.getDate("OC_STOCK_END"));
                stock.setCreateDateTime(rs.getTimestamp("OC_STOCK_CREATETIME"));
                stock.setUpdateDateTime(rs.getTimestamp("OC_STOCK_UPDATETIME"));
                stock.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_STOCK_UPDATEUID")));
                stock.setVersion(rs.getInt("OC_STOCK_VERSION"));
                stock.setLocation(rs.getString("OC_STOCK_LOCATION"));
                foundObjects.add(stock);
        	}
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return foundObjects;
    }
    
    //--- FIND ------------------------------------------------------------------------------------
    public static Vector find(String sFindServiceStockUid, String sFindProductUid, String sFindLevel,
                              String sFindMinimumLevel, String sFindMaximumLevel, String sFindOrderLevel,
                              String sFindBegin, String sFindEnd, String sFindDefaultImportance,
                              String sFindSupplierUid, String sFindServiceUid, String sSortCol, String sSortDir) {
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "SELECT ps.OC_STOCK_SERVERID, ps.OC_STOCK_OBJECTID" +
                    " FROM OC_PRODUCTSTOCKS ps, OC_PRODUCTS p ";
            if (sFindServiceUid.length() > 0) {
                sSelect += ", OC_SERVICESTOCKS ss ";
            }
            sSelect += "WHERE ";

            // bind the serviceStock table
            String convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_SERVERID");
            String convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_OBJECTID");
            sSelect += " p.OC_PRODUCT_OBJECTID=replace(ps.OC_STOCK_PRODUCTUID,'" +  MedwanQuery.getInstance().getConfigInt("serverId") + ".','') ";

            // match search criteria
            if (sFindServiceStockUid.length() > 0 || sFindProductUid.length() > 0 || sFindLevel.length() > 0 ||
                    sFindMinimumLevel.length() > 0 || sFindMaximumLevel.length() > 0 || sFindOrderLevel.length() > 0 ||
                    sFindBegin.length() > 0 || sFindEnd.length() > 0 || sFindDefaultImportance.length() > 0 ||
                    sFindSupplierUid.length() > 0 || sFindServiceUid.length() > 0) {
                sSelect += "AND ";
                if (sFindServiceUid.length() > 0) {
                    // bind the serviceStock table
                    convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_SERVERID");
                    convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_OBJECTID");
                    sSelect += " ps.OC_STOCK_SERVICESTOCKUID = (" + convertServerId + MedwanQuery.getInstance().concatSign() + "'.'" + MedwanQuery.getInstance().concatSign() + convertObjectId + ") AND ";
                }
                if (sFindServiceUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindServiceUid);
                    childIds.add(sFindServiceUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN ('') AND ";
                    }
                }
                if (sFindServiceStockUid.length() > 0) sSelect += "ps.OC_STOCK_SERVICESTOCKUID = ? AND ";
                if (sFindProductUid.length() > 0) sSelect += "ps.OC_STOCK_PRODUCTUID = ? AND ";
                if (sFindLevel.length() > 0) sSelect += "ps.OC_STOCK_LEVEL >= ? AND ";
                if (sFindMinimumLevel.length() > 0) sSelect += "ps.OC_STOCK_MINIMUMLEVEL = ? AND ";
                if (sFindMaximumLevel.length() > 0) sSelect += "ps.OC_STOCK_MAXIMUMLEVEL = ? AND ";
                if (sFindOrderLevel.length() > 0) sSelect += "ps.OC_STOCK_ORDERLEVEL = ? AND ";
                if (sFindBegin.length() > 0) sSelect += "ps.OC_STOCK_BEGIN = ? AND ";
                if (sFindEnd.length() > 0) sSelect += "ps.OC_STOCK_END = ? AND ";
                if (sFindDefaultImportance.length() > 0) sSelect += "ps.OC_STOCK_DEFAULTIMPORTANCE = ? AND ";
                if (sFindSupplierUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindSupplierUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN ('') AND ";
                    }
                }

                // remove last AND if any
                if (sSelect.indexOf("AND ") > -1) {
                    sSelect = sSelect.substring(0, sSelect.lastIndexOf("AND "));
                }
            }
            if(ScreenHelper.checkString(sSortCol).length()>0) {
            	// order by selected col or default col
                sSelect += "ORDER BY " + sSortCol + " " + sSortDir;
            }
            
            Debug.println("SELECT: "+sSelect);
            ps = oc_conn.prepareStatement(sSelect);

            // set questionmark values
            int questionMarkIdx = 1;
            if (sFindServiceStockUid.length() > 0) ps.setString(questionMarkIdx++, sFindServiceStockUid);
            if (sFindProductUid.length() > 0) ps.setString(questionMarkIdx++, sFindProductUid);
            if (sFindLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindLevel));
            if (sFindMinimumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMinimumLevel));
            if (sFindMaximumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMaximumLevel));
            if (sFindOrderLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindOrderLevel));
            if (sFindBegin.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindBegin));
            if (sFindEnd.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindEnd));
            if (sFindDefaultImportance.length() > 0) ps.setString(questionMarkIdx++, sFindDefaultImportance);

            // execute
            rs = ps.executeQuery();
            while (rs.next()) {
                foundObjects.add(get(rs.getString("OC_STOCK_SERVERID") + "." + rs.getString("OC_STOCK_OBJECTID")));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return foundObjects;
    }
    //--- FIND ------------------------------------------------------------------------------------
    public static Vector find(String sFindServiceStockUid, String sFindProductUid, String sFindProductName, String sFindLevel,
                              String sFindMinimumLevel, String sFindMaximumLevel, String sFindOrderLevel,
                              String sFindBegin, String sFindEnd, String sFindDefaultImportance,
                              String sFindSupplierUid, String sFindServiceUid, String sSortCol, String sSortDir) {
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "SELECT ps.OC_STOCK_SERVERID, ps.OC_STOCK_OBJECTID" +
                    " FROM OC_PRODUCTSTOCKS ps, OC_PRODUCTS p ";
            if (sFindServiceUid.length() > 0) {
                sSelect += ", OC_SERVICESTOCKS ss ";
            }
            sSelect += "WHERE ";

            // bind the serviceStock table
            String convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_SERVERID");
            String convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_OBJECTID");
            sSelect += " p.OC_PRODUCT_OBJECTID=replace(ps.OC_STOCK_PRODUCTUID,'" +  MedwanQuery.getInstance().getConfigInt("serverId") + ".','') ";

            // match search criteria
            if (sFindServiceStockUid.length() > 0 || sFindProductUid.length() > 0 || sFindProductName.length() > 0 || sFindLevel.length() > 0 ||
                    sFindMinimumLevel.length() > 0 || sFindMaximumLevel.length() > 0 || sFindOrderLevel.length() > 0 ||
                    sFindBegin.length() > 0 || sFindEnd.length() > 0 || sFindDefaultImportance.length() > 0 ||
                    sFindSupplierUid.length() > 0 || sFindServiceUid.length() > 0) {
                sSelect += "AND ";
                if (sFindServiceUid.length() > 0) {
                    // bind the serviceStock table
                    convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_SERVERID");
                    convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_OBJECTID");
                    sSelect += " ps.OC_STOCK_SERVICESTOCKUID = (" + convertServerId + MedwanQuery.getInstance().concatSign() + "'.'" + MedwanQuery.getInstance().concatSign() + convertObjectId + ") AND ";
                }
                if (sFindServiceUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindServiceUid);
                    childIds.add(sFindServiceUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN ('') AND ";
                    }
                }
                if (sFindServiceStockUid.length() > 0) sSelect += "ps.OC_STOCK_SERVICESTOCKUID = ? AND ";
                if (sFindProductUid.length() > 0) sSelect += "ps.OC_STOCK_PRODUCTUID = ? AND ";
                if (sFindProductName.length() > 0) sSelect += "p.OC_PRODUCT_NAME like ? AND ";
                if (sFindLevel.length() > 0) sSelect += "ps.OC_STOCK_LEVEL = ? AND ";
                if (sFindMinimumLevel.length() > 0) sSelect += "ps.OC_STOCK_MINIMUMLEVEL = ? AND ";
                if (sFindMaximumLevel.length() > 0) sSelect += "ps.OC_STOCK_MAXIMUMLEVEL = ? AND ";
                if (sFindOrderLevel.length() > 0) sSelect += "ps.OC_STOCK_ORDERLEVEL = ? AND ";
                if (sFindBegin.length() > 0) sSelect += "ps.OC_STOCK_BEGIN = ? AND ";
                if (sFindEnd.length() > 0) sSelect += "ps.OC_STOCK_END = ? AND ";
                if (sFindDefaultImportance.length() > 0) sSelect += "ps.OC_STOCK_DEFAULTIMPORTANCE = ? AND ";
                if (sFindSupplierUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindSupplierUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN ('') AND ";
                    }
                }

                // remove last AND if any
                if (sSelect.indexOf("AND ") > -1) {
                    sSelect = sSelect.substring(0, sSelect.lastIndexOf("AND "));
                }
            }

            // order by selected col or default col
            sSelect += "ORDER BY " + sSortCol + " " + sSortDir;
            
            ps = oc_conn.prepareStatement(sSelect);

            // set questionmark values
            int questionMarkIdx = 1;
            if (sFindServiceStockUid.length() > 0) ps.setString(questionMarkIdx++, sFindServiceStockUid);
            if (sFindProductUid.length() > 0) ps.setString(questionMarkIdx++, sFindProductUid);
            if (sFindProductName.length() > 0) ps.setString(questionMarkIdx++, "%"+sFindProductName+"%");
            if (sFindLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindLevel));
            if (sFindMinimumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMinimumLevel));
            if (sFindMaximumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMaximumLevel));
            if (sFindOrderLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindOrderLevel));
            if (sFindBegin.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindBegin));
            if (sFindEnd.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindEnd));
            if (sFindDefaultImportance.length() > 0) ps.setString(questionMarkIdx++, sFindDefaultImportance);

            // execute
            rs = ps.executeQuery();
            while (rs.next()) {
                foundObjects.add(get(rs.getString("OC_STOCK_SERVERID") + "." + rs.getString("OC_STOCK_OBJECTID")));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return foundObjects;
    }
    //--- FIND ------------------------------------------------------------------------------------
    public static Vector findNameAndCode(String sFindServiceStockUid, String sFindProductUid, String sFindProductName, String sFindLevel,
                              String sFindMinimumLevel, String sFindMaximumLevel, String sFindOrderLevel,
                              String sFindBegin, String sFindEnd, String sFindDefaultImportance,
                              String sFindSupplierUid, String sFindServiceUid, String sSortCol, String sSortDir) {
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "SELECT ps.OC_STOCK_SERVERID, ps.OC_STOCK_OBJECTID" +
                    " FROM OC_PRODUCTSTOCKS ps, OC_PRODUCTS p ";
            if (sFindServiceUid.length() > 0) {
                sSelect += ", OC_SERVICESTOCKS ss ";
            }
            sSelect += "WHERE ";

            // bind the serviceStock table
            String convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_SERVERID");
            String convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_OBJECTID");
            sSelect += " p.OC_PRODUCT_OBJECTID=replace(ps.OC_STOCK_PRODUCTUID,'" +  MedwanQuery.getInstance().getConfigInt("serverId") + ".','') ";

            // match search criteria
            if (sFindServiceStockUid.length() > 0 || sFindProductUid.length() > 0 || sFindProductName.length() > 0 || sFindLevel.length() > 0 ||
                    sFindMinimumLevel.length() > 0 || sFindMaximumLevel.length() > 0 || sFindOrderLevel.length() > 0 ||
                    sFindBegin.length() > 0 || sFindEnd.length() > 0 || sFindDefaultImportance.length() > 0 ||
                    sFindSupplierUid.length() > 0 || sFindServiceUid.length() > 0) {
                sSelect += "AND ";
                if (sFindServiceUid.length() > 0) {
                    // bind the serviceStock table
                    convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_SERVERID");
                    convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "ss.OC_STOCK_OBJECTID");
                    sSelect += " ps.OC_STOCK_SERVICESTOCKUID = (" + convertServerId + MedwanQuery.getInstance().concatSign() + "'.'" + MedwanQuery.getInstance().concatSign() + convertObjectId + ") AND ";
                }
                if (sFindServiceUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindServiceUid);
                    childIds.add(sFindServiceUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += " ss.OC_STOCK_SERVICEUID IN ('') AND ";
                    }
                }
                if (sFindServiceStockUid.length() > 0) sSelect += "ps.OC_STOCK_SERVICESTOCKUID = ? AND ";
                if (sFindProductUid.length() > 0) sSelect += "ps.OC_STOCK_PRODUCTUID = ? AND ";
                if (sFindProductName.length() > 0) sSelect += "(p.OC_PRODUCT_NAME like ? OR p.OC_PRODUCT_CODE like ?) AND ";
                if (sFindLevel.length() > 0) sSelect += "ps.OC_STOCK_LEVEL = ? AND ";
                if (sFindMinimumLevel.length() > 0) sSelect += "ps.OC_STOCK_MINIMUMLEVEL = ? AND ";
                if (sFindMaximumLevel.length() > 0) sSelect += "ps.OC_STOCK_MAXIMUMLEVEL = ? AND ";
                if (sFindOrderLevel.length() > 0) sSelect += "ps.OC_STOCK_ORDERLEVEL = ? AND ";
                if (sFindBegin.length() > 0) sSelect += "ps.OC_STOCK_BEGIN = ? AND ";
                if (sFindEnd.length() > 0) sSelect += "ps.OC_STOCK_END = ? AND ";
                if (sFindDefaultImportance.length() > 0) sSelect += "ps.OC_STOCK_DEFAULTIMPORTANCE = ? AND ";
                if (sFindSupplierUid.length() > 0) {
                    // search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindSupplierUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds, ",", "'");
                    if (sChildIds.length() > 0) {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN (" + sChildIds + ") AND ";
                    } else {
                        sSelect += "ps.OC_STOCK_SUPPLIERUID IN ('') AND ";
                    }
                }

                // remove last AND if any
                if (sSelect.indexOf("AND ") > -1) {
                    sSelect = sSelect.substring(0, sSelect.lastIndexOf("AND "));
                }
            }

            // order by selected col or default col
            sSelect += "ORDER BY " + sSortCol + " " + sSortDir;
            
            ps = oc_conn.prepareStatement(sSelect);

            // set questionmark values
            int questionMarkIdx = 1;
            if (sFindServiceStockUid.length() > 0) ps.setString(questionMarkIdx++, sFindServiceStockUid);
            if (sFindProductUid.length() > 0) ps.setString(questionMarkIdx++, sFindProductUid);
            if (sFindProductName.length() > 0){
            	ps.setString(questionMarkIdx++, "%"+sFindProductName+"%");
            	ps.setString(questionMarkIdx++, "%"+sFindProductName+"%");
            }
            if (sFindLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindLevel));
            if (sFindMinimumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMinimumLevel));
            if (sFindMaximumLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindMaximumLevel));
            if (sFindOrderLevel.length() > 0) ps.setInt(questionMarkIdx++, Integer.parseInt(sFindOrderLevel));
            if (sFindBegin.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindBegin));
            if (sFindEnd.length() > 0) ps.setDate(questionMarkIdx++, ScreenHelper.getSQLDate(sFindEnd));
            if (sFindDefaultImportance.length() > 0) ps.setString(questionMarkIdx++, sFindDefaultImportance);

            // execute
            rs = ps.executeQuery();
            while (rs.next()) {
                foundObjects.add(get(rs.getString("OC_STOCK_SERVERID") + "." + rs.getString("OC_STOCK_OBJECTID")));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return foundObjects;
    }
    //--- IS ACTIVE -------------------------------------------------------------------------------
    public boolean isActive() {
        boolean isActive = false;
        if (this.getEnd() == null || this.getEnd().after(new java.util.Date())) {
            isActive = true;
        }
        return isActive;
    }
    //--- GET TOTAL UNITS IN FOR DATE -------------------------------------------------------------
    public int getTotalUnitsInForDate(java.util.Date date) {
        int units = 0;
        long day = 24 * 3600 * 1000;
        java.util.Date dateUntill = new java.util.Date(date.getTime() + day - 1); // add one day
        Vector receipts = ProductStockOperation.getReceipts(getUid(), "", date, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < receipts.size(); i++) {
            receipt = (ProductStockOperation) receipts.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    //--- GET TOTAL UNITS OUT FOR DATE ------------------------------------------------------------
    public int getTotalUnitsOutForDate(java.util.Date date) {
        int units = 0;
        long day = 24 * 3600 * 1000;
        java.util.Date dateUntill = new java.util.Date(date.getTime() + day - 1); // add one day
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", date, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            units += delivery.getUnitsChanged();
        }
        return units;
    }
    //--- GET TOTAL UNITS IN FOR MONTH ------------------------------------------------------------
    public int getTotalUnitsInForMonth(java.util.Date dateFrom) {
        int units = 0;
        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.MONTH, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector receipts = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < receipts.size(); i++) {
            receipt = (ProductStockOperation) receipts.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    //--- GET TOTAL UNITS OUT FOR MONTH -----------------------------------------------------------
    public int getTotalUnitsOutForMonth(java.util.Date dateFrom) {
        int units = 0;

        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.MONTH, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    //--- GET TOTAL UNITS OUT FOR MONTH -----------------------------------------------------------
    public int getTotalVisitUnitsOutForMonth(java.util.Date dateFrom) {
        int units = 0;

        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.MONTH, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector deliveries = ProductStockOperation.getPatientDeliveries(getUid(), "","visit", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    public int getTotalAdmissionUnitsOutForMonth(java.util.Date dateFrom) {
        int units = 0;

        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.MONTH, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector deliveries = ProductStockOperation.getPatientDeliveries(getUid(), "","admission", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    //--- GET TOTAL UNITS IN FOR YEAR -------------------------------------------------------------
    public int getTotalUnitsInForYear(java.util.Date dateFrom) {
        int units = 0;

        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), 0, 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.YEAR, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector deliveries = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    
    public int getTotalUnitsInForPeriod(java.util.Date dateFrom,java.util.Date dateTo) {
        int units = 0;

        Vector deliveries = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            units += receipt.getUnitsChanged();
        }
        return units;
    }
    
    public int getTotalUnitsInForPeriod(Vector receipts,java.util.Date dateFrom,java.util.Date dateTo) {
        int units = 0;
        ProductStockOperation receipt;
        for (int i = 0; i < receipts.size(); i++) {
        	receipt = (ProductStockOperation) receipts.get(i);
            if(receipt.getDescription().startsWith("medicationreceipt") && !receipt.getDate().before(dateFrom) && receipt.getDate().before(dateTo)){
            	units += receipt.getUnitsChanged();
            }
        }
        return units;
    }

    public int getTotalUnitsInForPeriod(java.util.Date dateFrom,java.util.Date dateTo,String userid) {
        int units = 0;

        Vector deliveries = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            if(userid.length()==0 || receipt.getUpdateUser().equalsIgnoreCase(userid)){
            	units += receipt.getUnitsChanged();
            }
        }
        return units;
    }
    
    public int getTotalUnitsInForPeriod(Vector receipts,java.util.Date dateFrom,java.util.Date dateTo, String userid) {
        int units = 0;
        ProductStockOperation receipt;
        for (int i = 0; i < receipts.size(); i++) {
        	receipt = (ProductStockOperation) receipts.get(i);
            if(receipt.getDescription().startsWith("medicationreceipt") && !receipt.getDate().before(dateFrom) && receipt.getDate().before(dateTo) && receipt.getUpdateUser().equalsIgnoreCase(userid)){
            	units += receipt.getUnitsChanged();
            }
        }
        return units;
    }

    public int getTotalUnitsInForPeriod(java.util.Date dateFrom,java.util.Date dateTo,String userid,String sBatchNumber) {
        int units = 0;

        Vector deliveries = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            if((userid.length()==0 || receipt.getUpdateUser().equalsIgnoreCase(userid)) && ((receipt.getBatchNumber()==null && sBatchNumber.equalsIgnoreCase("?"))||(receipt.getBatchNumber()!=null && receipt.getBatchNumber().equalsIgnoreCase(sBatchNumber)))){
            	units += receipt.getUnitsChanged();
            }
        }
        return units;
    }
    
    public SortedSet getBatchesInForPeriod(java.util.Date dateFrom,java.util.Date dateTo,String userid) {
        SortedSet batches = new TreeSet();

        Vector deliveries = ProductStockOperation.getReceipts(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < deliveries.size(); i++) {
            receipt = (ProductStockOperation) deliveries.get(i);
            if(receipt.getBatchNumber()!=null){
            	batches.add(receipt.getBatchNumber());
            }
            else{
            	batches.add("?");
            }
        }
        return batches;
    }
    
    //--- GET TOTAL UNITS OUT FOR YEAR ------------------------------------------------------------
    public int getTotalUnitsOutForPeriod(java.util.Date dateFrom,java.util.Date dateTo) {
        int units = 0;
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            units += delivery.getUnitsChanged();
        }
        return units;
    }
    
    //--- GET TOTAL UNITS OUT FOR YEAR ------------------------------------------------------------
    public int getTotalUnitsOutForPeriod(Vector deliveries,java.util.Date dateFrom,java.util.Date dateTo) {
        int units = 0;
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            if(delivery.getDescription().startsWith("medicationdelivery") && !delivery.getDate().before(dateFrom) && delivery.getDate().before(dateTo)){
            	units += delivery.getUnitsChanged();
            }
        }
        return units;
    }
    
    public int getTotalUnitsOutForPeriod(java.util.Date dateFrom,java.util.Date dateTo, String userid) {
        int units = 0;
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", dateFrom, dateTo, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            if(userid.length()==0 || delivery.getUpdateUser().equalsIgnoreCase(userid)){
            	units += delivery.getUnitsChanged();
            }
        }
        return units;
    }

    public int getTotalUnitsOutForPeriod(Vector deliveries,java.util.Date dateFrom,java.util.Date dateTo, String userid) {
        int units = 0;
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            if(delivery.getDescription().startsWith("medicationdelivery") && !delivery.getDate().before(dateFrom) && delivery.getDate().before(dateTo) && delivery.getUpdateUser().equalsIgnoreCase(userid)){
            	units += delivery.getUnitsChanged();
            }
        }
        return units;
    }
    
    
    public int getTotalUnitsOutForYear(java.util.Date dateFrom) {
        int units = 0;

        // date from : begin of specified month
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dateFrom);
        calendar.set(calendar.get(Calendar.YEAR), 0, 1, 0, 0, 0);
        dateFrom = calendar.getTime();

        // date untill : end of specified month
        calendar.add(Calendar.YEAR, 1);
        java.util.Date dateUntill = calendar.getTime();
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", dateFrom, dateUntill, "OC_OPERATION_DATE", "ASC");
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            units += delivery.getUnitsChanged();
        }
        return units;
    }
    //--- GET LEVEL -------------------------------------------------------------------------------
    // Count level at a given time starting from the initial level (0), based on the operations
    // done on this productStock,
    //---------------------------------------------------------------------------------------------
    public int getLevelOld(java.util.Date dateUntill) {
        java.util.Date dateFrom = new java.util.Date(0); // begin of time
        // IN
        int unitsIn = 0;
        Vector receipts = ProductStockOperation.getReceipts(getUid(), "", dateFrom, new java.util.Date(dateUntill.getTime() + (24 * 3600 * 1000) - 1), "OC_OPERATION_DATE", "ASC");
        ProductStockOperation receipt;
        for (int i = 0; i < receipts.size(); i++) {
            receipt = (ProductStockOperation) receipts.get(i);
            unitsIn += receipt.getUnitsChanged();
        }

        // OUT
        int unitsOut = 0;
        Vector deliveries = ProductStockOperation.getDeliveries(getUid(), "", dateFrom, new java.util.Date(dateUntill.getTime() + (24 * 3600 * 1000) - 1), "OC_OPERATION_DATE", "ASC");
        ProductStockOperation delivery;
        for (int i = 0; i < deliveries.size(); i++) {
            delivery = (ProductStockOperation) deliveries.get(i);
            unitsOut += delivery.getUnitsChanged();
        }
        return unitsIn - unitsOut;
    }
    
    public int getLevel(Vector operations, java.util.Date dateUntill) {
    	return getTotalUnitsInForPeriod(operations, new java.util.Date(0), dateUntill)-getTotalUnitsOutForPeriod(operations, new java.util.Date(0), dateUntill);
    }
    
    public int getLevel(java.util.Date dateUntill) {
    	int level=0;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT SUM(level) level from ("+
            				 " SELECT sum(OC_OPERATION_UNITSCHANGED) level"+
                             "  FROM OC_PRODUCTSTOCKOPERATIONS"+
                             " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationreceipt.%'" +
                             " and OC_OPERATION_PRODUCTSTOCKUID='"+getUid()+"'"+
                             " AND OC_OPERATION_DATE <= ?"+
                             " UNION"+
                             " SELECT -sum(OC_OPERATION_UNITSCHANGED) level"+
                             "  FROM OC_PRODUCTSTOCKOPERATIONS"+
                             " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationdelivery.%'" +
                             " and OC_OPERATION_PRODUCTSTOCKUID='"+getUid()+"'"+
                             " AND OC_OPERATION_DATE <= ?) z";

            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1,new java.sql.Timestamp(dateUntill.getTime()));
            ps.setTimestamp(2,new java.sql.Timestamp(dateUntill.getTime()));
            rs = ps.executeQuery();
            if(rs.next()){
            	level=rs.getInt("level");
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
    	finally{
    		try {
				oc_conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
        return level;
    }
    
    public int getCorrectedLevel(java.util.Date dateUntill) {
    	int level=0;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT SUM(level) level from ("+
            				 " SELECT sum(OC_OPERATION_UNITSCHANGED) level"+
                             "  FROM OC_PRODUCTSTOCKOPERATIONS"+
                             " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationreceipt.%'" +
                             " and OC_OPERATION_PRODUCTSTOCKUID='"+getUid()+"'"+
                             " AND OC_OPERATION_DATE >= ?"+
                             " UNION"+
                             " SELECT -sum(OC_OPERATION_UNITSCHANGED) level"+
                             "  FROM OC_PRODUCTSTOCKOPERATIONS"+
                             " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationdelivery.%'" +
                             " and OC_OPERATION_PRODUCTSTOCKUID='"+getUid()+"'"+
                             " AND OC_OPERATION_DATE >= ?) z";

            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1,new java.sql.Timestamp(dateUntill.getTime()));
            ps.setTimestamp(2,new java.sql.Timestamp(dateUntill.getTime()));
            rs = ps.executeQuery();
            if(rs.next()){
            	level=rs.getInt("level");
            }
            rs.close();
            ps.close();
            level=getLevel()-level;
        }
        catch(Exception e){
        	e.printStackTrace();
        }
    	finally{
    		try {
				oc_conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
        return level;
    }
    
    public static Hashtable getProductStockOperations(java.util.Date begin, java.util.Date end) {
    	Hashtable operations = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select * from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? order by oc_operation_date";
    	try {
			ps = conn.prepareStatement(sQuery);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			rs = ps.executeQuery();
			while(rs.next()) {
				String productuid = rs.getString("oc_operation_productstockuid");
				if(operations.get(productuid)==null) {
					operations.put(productuid, new Vector());
				}
				Vector ops = (Vector)operations.get(productuid);
				double unitschanged = rs.getDouble("OC_OPERATION_UNITSCHANGED");
				String type = rs.getString("OC_OPERATION_DESCRIPTION");
				if(type.startsWith("medicationdelivery")) {
					unitschanged=-unitschanged;
				}
				else if(!type.startsWith("medicationreceipt")) {
					unitschanged=0;
				}
				ops.add(new SimpleDateFormat("yyyyMMddHHmmss").format(rs.getTimestamp("OC_OPERATION_DATE"))+";"+unitschanged+";"+rs.getString("OC_STOCK_SERVICESTOCKUID"));
			}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
		
    	return operations;
    }
    
    public double getCorrectedLevel(java.util.Date dateUntill, Hashtable productstockoperations) {
    	double level=0;
    	Vector operations = (Vector)productstockoperations.get(getUid());
    	if(operations!=null) {
    		for(int n=0;n<operations.size();n++) {
    			String[] key=((String)operations.elementAt(n)).split(";");
    			level=level+Double.parseDouble(key[1]);
    		}
    	}
        level=getLevel()-level;
        return level;
    }
    
    //--- COMPARE TO ------------------------------------------------------------------------------
    public int compareTo(Object obj) {
        ProductStock otherProductStock = (ProductStock) obj;
        if (getProduct() == null || otherProductStock.getProduct() == null) return 1;
        return this.getProduct().compareTo(otherProductStock.getProduct());
    }
    
    public static ProductStock getByBarcode(String barcodeid,String servicestockuid){
    	if(SH.c(barcodeid).length()==0) {
    		return null;
    	}
        ProductStock productstock = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PRODUCTSTOCKS a,OC_PRODUCTS b WHERE b.OC_PRODUCT_BARCODE = ? and b.OC_PRODUCT_OBJECTID=replace(a.OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and a.OC_STOCK_SERVICESTOCKUID=?";
            ps=oc_conn.prepareStatement(sSelect);
            ps.setString(1, barcodeid);
            ps.setString(2, servicestockuid);
            rs=ps.executeQuery();
            if(rs.next()){
            	productstock = ProductStock.get(rs.getString("OC_STOCK_SERVERID")+"."+rs.getString("OC_STOCK_OBJECTID"));
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally {
        	try {
                oc_conn.close();
        	}
        	catch(Exception e) {
        		e.printStackTrace();
        	}
        }
        return productstock;
    }

    public static Vector getProducts(String stockId, String sFindProductName) {
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "SELECT ps.OC_STOCK_SERVERID, ps.OC_STOCK_OBJECTID" +
                    " FROM OC_PRODUCTSTOCKS ps, OC_PRODUCTS p WHERE 1=1";
            // bind the serviceStock table
            String convertServerId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_SERVERID");
            String convertObjectId = MedwanQuery.getInstance().convert("varchar(16)", "p.OC_PRODUCT_OBJECTID");
            sSelect += " AND ps.OC_STOCK_PRODUCTUID = (" + convertServerId + MedwanQuery.getInstance().concatSign() + "'.'" + MedwanQuery.getInstance().concatSign() + convertObjectId + ") ";
            sSelect += "AND ps.OC_STOCK_SERVICESTOCKUID = (" + stockId + ")";
            if (sFindProductName.trim().length() > 0) {
                sSelect += "AND p.OC_PRODUCT_NAME LIKE '%" + sFindProductName + "%'";

            }
            sSelect+=" ORDER BY OC_PRODUCT_NAME";
            ps = oc_conn.prepareStatement(sSelect);
            // execute
            rs = ps.executeQuery();
            while (rs.next()) {
                foundObjects.add(get(rs.getString("OC_STOCK_SERVERID") + "." + rs.getString("OC_STOCK_OBJECTID")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                oc_conn.close();
            }
            catch (SQLException se) {
                se.printStackTrace();
            }
        }
        return foundObjects;
    }
}
