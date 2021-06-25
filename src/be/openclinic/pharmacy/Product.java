package be.openclinic.pharmacy;

import net.admin.Service;
import be.openclinic.common.OC_Object;
import be.openclinic.finance.Prestation;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Debug;

import java.sql.*;
import java.util.Hashtable;
import java.util.Vector;
import java.text.ParseException;
import java.text.SimpleDateFormat;

/**
 * User: Frank Verbeke, Stijn Smets
 * Date: 10-sep-2006
 */
public class Product extends OC_Object implements Comparable {
    private String name;
    private String unit;
    private double unitPrice;
    private int packageUnits;
    private int minimumOrderPackages = -1;
    private Service supplier;
    private String timeUnit; // (Hour|Day|Week|Month)
    private int timeUnitCount = -1;
    private double unitsPerTimeUnit = -1;
    private double totalUnits = 0;
    private String productGroup;
    private String productSubGroup;
    private String prescriptionInfo;
    private String barcode;
    private String rxnormcode;
	private String atccode;
	private String prestationcode;
    private int prestationquantity;
    private double margin;
    private boolean applyLowerPrices;
    private boolean automaticInvoicing;
    private String code;
    private String dose;
    private String dhis2code;
	private double lastYearsAverage=-1;
    private Hashtable lastYearAverages=new Hashtable();
    private Hashtable looseLastYearAverages=new Hashtable();
    private String route;
    
    public String getRoute() {
		return route;
	}

	public void setRoute(String route) {
		this.route = route;
	}

	public String getDhis2code() {
		return dhis2code;
	}

	public void setDhis2code(String dhis2code) {
		this.dhis2code = dhis2code;
	}

	public String getDose() {
		return dose;
	}

	public void setDose(String dose) {
		this.dose = dose;
	}

    public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getRxnormcode() {
		return rxnormcode;
	}

	public void setRxnormcode(String rxnormcode) {
		this.rxnormcode = rxnormcode;
	}


    public String getAtccode() {
		return atccode;
	}

	public void setAtccode(String atccode) {
		this.atccode = atccode;
	}

	public double getTotalUnits() {
		return totalUnits;
	}

	public void setTotalUnits(double totalUnits) {
		this.totalUnits = totalUnits;
	}

    public boolean isAutomaticInvoicing(){
		return automaticInvoicing;
	}

	public String getProductSubGroup(){
		return productSubGroup;
	}

	public void setProductSubGroup(String productSubGroup){
		this.productSubGroup = productSubGroup;
	}
	
	public String getFullProductSubGroupName(String sLanguage){
		String name = "";
		
		if(ScreenHelper.checkString(this.productSubGroup).length()>0){
			Vector parents = DrugCategory.getParentIdsNoReverse(this.productSubGroup);
			for(int n=0; n<parents.size(); n++){
				name+= HTMLEntities.htmlentities(ScreenHelper.getTranNoLink("drug.category", (String)parents.elementAt(n), sLanguage))+";";
			}
			name+= HTMLEntities.htmlentities(ScreenHelper.getTranNoLink("drug.category", this.productSubGroup, sLanguage));
		}
		
		return name;
	}
	
	public void setAutomaticInvoicing(boolean automaticInvoicing){
		this.automaticInvoicing = automaticInvoicing;
	}

	public double getMargin(){
		return margin;
	}

	public void setMargin(double margin){
		this.margin = margin;
	}

	public boolean isApplyLowerPrices(){
		return applyLowerPrices;
	}

	public void setApplyLowerPrices(boolean applyLowerPrices){
		this.applyLowerPrices = applyLowerPrices;
	}

	public String getBarcode(){
		return barcode;
	}

	public void setBarcode(String barcode){
		this.barcode = barcode;
	}

	public String getPrestationcode(){
		return prestationcode;
	}

	public void setPrestationcode(String prestationcode){
		this.prestationcode = prestationcode;
	}

	public int getPrestationquantity(){
		return prestationquantity;
	}

	public void setPrestationquantity(int prestationquantity){
		this.prestationquantity = prestationquantity;
	}

	public String getPrescriptionInfo(){
		return prescriptionInfo;
	}

	public void setPrescriptionInfo(String prescriptionInfo){
		this.prescriptionInfo = prescriptionInfo;
	}

	// non-db data
    private String supplierUid;


    //--- NAME ------------------------------------------------------------------------------------
    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    //--- UNIT ------------------------------------------------------------------------------------
    public String getUnit(){
        return unit;
    }

    public void setUnit(String unit){
        this.unit = unit;
    }

    //--- UNIT PRICE ------------------------------------------------------------------------------
    public double getUnitPrice(){
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice){
        this.unitPrice = unitPrice;
    }

    //--- PACKAGE UNITS ---------------------------------------------------------------------------
    public int getPackageUnits(){
        return packageUnits;
    }

    public void setPackageUnits(int packageUnits){
        this.packageUnits = packageUnits;
    }

    //--- MINIMUM ORDER PACKAGES ------------------------------------------------------------------
    public int getMinimumOrderPackages(){
        return minimumOrderPackages;
    }

    public void setMinimumOrderPackages(int minimumOrderPackages){
        this.minimumOrderPackages = minimumOrderPackages;
    }
    
    public double getQuantityLost(java.util.Date begin, java.util.Date end, String productstockuid) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" ? like '%'||oc_operation_description||'%' and"+
    					" oc_stock_objectid=?";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setString(3, MedwanQuery.getInstance().getConfigString("productstockoperationsonexpireddrugs","medicationdelivery4,medicationdelivery5,"));
    		ps.setInt(4, Integer.parseInt(productstockuid.split("\\.")[1]));
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumed");
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
    	return consumption;
    }

    public double getQuantityLost(java.util.Date begin, java.util.Date end) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" ? like '%'||oc_operation_description||'%' and"+
    					" oc_stock_productuid=?";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setString(3, MedwanQuery.getInstance().getConfigString("productstockoperationsonexpireddrugs","medicationdelivery4,medicationdelivery5,"));
    		ps.setString(4, this.getUid());
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumed");
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
    	return consumption;
    }
    
    public static Hashtable getQuantitiesLost(java.util.Date begin, java.util.Date end) {
    	Hashtable consumptions =new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed,oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" ? like '%'||oc_operation_description||'%'"+
    					" group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setString(3, MedwanQuery.getInstance().getConfigString("productstockoperationsonexpireddrugs","medicationdelivery4,medicationdelivery5,"));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }
    
    public static Hashtable getQuantitiesLost(java.util.Date begin, java.util.Date end, String servicestockuids) {
    	Hashtable consumptions = new Hashtable();
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed,oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" ? like '%'||oc_operation_description||'%' and"+
    					" oc_stock_servicestockuid in ("+uids+")"+
    					" group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setString(3, MedwanQuery.getInstance().getConfigString("productstockoperationsonexpireddrugs","medicationdelivery4,medicationdelivery5,"));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }
    
    public static Hashtable getProductOperations(java.util.Date begin, java.util.Date end) {
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
				String productuid = rs.getString("oc_stock_productuid");
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
    
    public int getDaysOutOfStock(java.util.Date begin, java.util.Date end, String servicestockuids) {
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	int days=0;
    	long day=24*3600*1000;
    	long stockoutbegin=0;
    	double level = getTotalQuantityAvailable(begin);
    	if(level<=0) {
    		stockoutbegin=begin.getTime();
    	}
    	//Now run through all operations on this product after begin until end
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	String sQuery=	"select * from oc_productstockoperations,oc_productstocks where oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_stock_productuid=? and"+
    					" oc_stock_servicestockuid in ("+uids+") and"+
    					" oc_operation_date>=? and oc_operation_date<? order by oc_operation_date";
    	try {
    		PreparedStatement ps = conn.prepareStatement(sQuery);
    		ps.setString(1, getUid());
    		ps.setDate(2, new java.sql.Date(begin.getTime()));
    		ps.setDate(3, new java.sql.Date(end.getTime()));
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()) {
    			if(rs.getString("oc_operation_description").startsWith("medicationdelivery")) {
    				level = level-rs.getDouble("oc_operation_unitschanged");
    			}
    			else if(rs.getString("oc_operation_description").startsWith("medicationreceipt")) {
    				level = level+rs.getDouble("oc_operation_unitschanged");
    			}
				if(stockoutbegin>0 && level>0) {
					days += (rs.getTimestamp("oc_operation_date").getTime()-stockoutbegin)/day;
					stockoutbegin=0;
				}
				else if(stockoutbegin==0 && level<=0) {
					stockoutbegin=rs.getTimestamp("oc_operation_date").getTime();
				}
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    		if(stockoutbegin>0) {
    			days += (end.getTime()-stockoutbegin)/day;
    		}
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return days;
    }

    public int getDaysOutOfStock(java.util.Date begin, java.util.Date end, String servicestockuids,Hashtable productstockoperations) {
    	int days=0;
    	long day=ScreenHelper.getTimeDay();
    	long stockoutbegin=0;
    	double level = getTotalQuantityAvailable();
    	if(level<=0) {
    		stockoutbegin=begin.getTime();
    	}
		try {
			//Now run through all operations on this product after begin until end
	    	Vector operations = (Vector)productstockoperations.get(getUid());
	    	if(operations!=null) {
	    		for(int n=0;n<operations.size();n++) {
	    			String[] key=((String)operations.elementAt(n)).split(";");
	    			level=level-Double.parseDouble(key[1]);
	    		}
	    		for(int n=0;n<operations.size();n++) {
	    			String[] key=((String)operations.elementAt(n)).split(";");
	    			if(servicestockuids.contains(key[2]) && new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).before(end)) {
		    			level = level+Double.parseDouble(key[1]);
						if(stockoutbegin>0 && level>0) {
							days += (new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).getTime()-stockoutbegin)/day;
							stockoutbegin=0;
						}
						else if(stockoutbegin==0 && level<=0) {
							stockoutbegin=new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).getTime();
						}
	    			}
	    			else {
	    				break;
	    			}
	    		}
	    	}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(stockoutbegin>0) {
			days += (end.getTime()-stockoutbegin)/day;
		}
    	return days;
    }

    public int getDaysOutOfStock(java.util.Date begin, java.util.Date end, Hashtable productstockoperations) {
    	int days=0;
    	long day=ScreenHelper.getTimeDay();
    	long stockoutbegin=0;
    	double level = getTotalQuantityAvailable(begin);
    	if(level<=0) {
    		stockoutbegin=begin.getTime();
    	}
    	level=getTotalQuantityAvailable();
		try {
			//Now run through all operations on this product after begin until end
	    	Vector operations = (Vector)productstockoperations.get(getUid());
	    	if(operations!=null) {
	    		for(int n=0;n<operations.size();n++) {
	    			String[] key=((String)operations.elementAt(n)).split(";");
	    			level=level-Double.parseDouble(key[1]);
	    		}
	    		for(int n=0;n<operations.size();n++) {
	    			String[] key=((String)operations.elementAt(n)).split(";");
	    			level = level+Double.parseDouble(key[1]);
	    			if(new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).before(end)) {
						if(stockoutbegin>0 && level>0) {
							days += (new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).getTime()-stockoutbegin)/day;
							stockoutbegin=0;
						}
						else if(stockoutbegin==0 && level<=0) {
							stockoutbegin=new SimpleDateFormat("yyyyMMddHHmmss").parse(key[0]).getTime();
						}
	    			}
	    			else {
	    				break;
	    			}
	    		}
	    	}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if(stockoutbegin>0) {
			days += (end.getTime()-stockoutbegin)/day;
		}
    	return days;
    }

    public int getDaysOutOfStock(java.util.Date begin, java.util.Date end) {
    	int days=0;
    	long day=24*3600*1000;
    	long stockoutbegin=0;
    	double level = getTotalQuantityAvailable(begin);
    	if(level<=0) {
    		stockoutbegin=begin.getTime();
    	}
    	//Now run through all operations on this product after begin until end
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	String sQuery=	"select * from oc_productstockoperations,oc_productstocks where oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_stock_productuid=? and"+
    					" oc_operation_date>=? and oc_operation_date<? order by oc_operation_date";
    	try {
    		PreparedStatement ps = conn.prepareStatement(sQuery);
    		ps.setString(1, getUid());
    		ps.setDate(2, new java.sql.Date(begin.getTime()));
    		ps.setDate(3, new java.sql.Date(end.getTime()));
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()) {
    			if(rs.getString("oc_operation_description").startsWith("medicationdelivery")) {
    				level = level-rs.getDouble("oc_operation_unitschanged");
    			}
    			else if(rs.getString("oc_operation_description").startsWith("medicationreceipt")) {
    				level = level+rs.getDouble("oc_operation_unitschanged");
    			}
				if(stockoutbegin>0 && level>0) {
					days += (rs.getTimestamp("oc_operation_date").getTime()-stockoutbegin)/day;
					stockoutbegin=0;
				}
				else if(stockoutbegin==0 && level<=0) {
					stockoutbegin=rs.getTimestamp("oc_operation_date").getTime();
				}
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    		if(stockoutbegin>0) {
    			days += (end.getTime()-stockoutbegin)/day;
    		}
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return days;
    }

    public double getConsumption(java.util.Date begin, java.util.Date end, String productstockuid) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_objectid=?";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setInt(3, Integer.parseInt(productstockuid.split("\\.")[1]));
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumed");
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
    	return consumption;
    }

    public double getConsumption(java.util.Date begin, java.util.Date end) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_productuid=?";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		ps.setString(3, this.getUid());
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumed");
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
    	return consumption;
    }

    public static Hashtable getConsumptions(java.util.Date begin, java.util.Date end) {
    	Hashtable consumptions = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed, oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }

    public static Hashtable getConsumptions(java.util.Date begin, java.util.Date end, String servicestockuids) {
    	Hashtable consumptions = new Hashtable();
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed, oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_servicestockuid in ("+uids+")"+
    					" group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }

    public static Hashtable getExits(java.util.Date begin, java.util.Date end) {
    	Hashtable consumptions = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed, oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%'"+
    					" group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }

    public double getSalesPrice() {
    	double salesprice=0;
		if(ScreenHelper.checkString(getPrestationcode()).length()>0){
			Prestation prestation =Prestation.get(getPrestationcode());
			salesprice=prestation.getPrice()+prestation.getSupplement();
		}
		else if(getMargin()>0){
			salesprice=getLastYearsAveragePrice()*(100+getMargin())/100;
		}
		if(salesprice<=0) {
			salesprice=getUnitPrice();
		}
		return salesprice;
    }
    
    public static Hashtable getExits(java.util.Date begin, java.util.Date end, String servicestockuids) {
    	Hashtable consumptions = new Hashtable();
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	" select sum(oc_operation_unitschanged) consumed, oc_stock_productuid from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>=? and"+
    					" oc_operation_date<? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_stock_servicestockuid in ("+uids+")"+
    					" group by oc_stock_productuid";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		ps.setDate(1, new java.sql.Date(begin.getTime()));
    		ps.setDate(2, new java.sql.Date(end.getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("oc_stock_productuid"),rs.getDouble("consumed"));
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
    	return consumptions;
    }

    public double getLastYearsAverageMonthlyConsumption(java.util.Date date, String productstockuid) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	"select avg(consumed) consumption from ("+
    					" select sum(oc_operation_unitschanged) consumed,month(oc_operation_date) month from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_objectid=?"+
    					" group by month(oc_operation_date)) a";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		long year = ScreenHelper.getTimeYear();
    		ps.setDate(1, new java.sql.Date(new java.util.Date(date.getTime()-year).getTime()));
    		ps.setInt(2, Integer.parseInt(productstockuid.split("\\.")[1]));
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumption");
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
    	return consumption;
    }

    public double getLastYearsAverageMonthlyConsumption(java.util.Date date) {
    	double consumption =0;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	"select avg(consumed) consumption from ("+
    					" select sum(oc_operation_unitschanged) consumed,month(oc_operation_date) month from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_productuid=?"+
    					" group by month(oc_operation_date)) a";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		long year = ScreenHelper.getTimeYear();
    		ps.setDate(1, new java.sql.Date(new java.util.Date(date.getTime()-year).getTime()));
    		ps.setString(2, this.getUid());
    		rs=ps.executeQuery();
    		if(rs.next()) {
    			consumption=rs.getDouble("consumption");
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
    	return consumption;
    }

    public static Hashtable getLastYearsAverageMonthlyConsumptions(java.util.Date date) {
    	Hashtable consumptions = new Hashtable();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	"select avg(consumed) consumption, product from ("+
    					" select sum(oc_operation_unitschanged) consumed,month(oc_operation_date) month,oc_stock_productuid product from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient'"+
    					" group by month(oc_operation_date),oc_stock_productuid) a group by product";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		long year = ScreenHelper.getTimeYear();
    		ps.setDate(1, new java.sql.Date(new java.util.Date(date.getTime()-year).getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("product"),rs.getDouble("consumption"));
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
    	return consumptions;
    }

    public static Hashtable getLastYearsAverageMonthlyConsumptions(java.util.Date date, String servicestockuids) {
    	Hashtable consumptions = new Hashtable();
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	ResultSet rs = null;
    	PreparedStatement ps = null;
    	String sQuery=	"select avg(consumed) consumption, product from ("+
    					" select sum(oc_operation_unitschanged) consumed,month(oc_operation_date) month,oc_stock_productuid product from oc_productstockoperations o,oc_productstocks p"+
    					" where"+
    					" oc_stock_objectid=replace(oc_operation_productstockuid,'1.','') and"+
    					" oc_operation_date>? and"+
    					" oc_operation_description like 'medicationdelivery%' and"+
    					" oc_operation_srcdesttype='patient' and"+
    					" oc_stock_servicestockuid in ("+uids+")"+
    					" group by month(oc_operation_date),oc_stock_productuid) a group by product";
    	try {
    		ps = conn.prepareStatement(sQuery);
    		long year = ScreenHelper.getTimeYear();
    		ps.setDate(1, new java.sql.Date(new java.util.Date(date.getTime()-year).getTime()));
    		rs=ps.executeQuery();
    		while(rs.next()) {
    			consumptions.put(rs.getString("product"),rs.getDouble("consumption"));
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
    	return consumptions;
    }

    public double getLastYearsAveragePrice(){
    	if(lastYearsAverage>-1){
    		return lastYearsAverage;
    	}
    	if(MedwanQuery.getInstance().getConfigInt("usePUMPFormula",1)==2){
			String pump = Pointer.getLastExactPointer("pump."+getUid());
			if(pump.length()>0){
				try{
					lastYearsAverage=Double.parseDouble(pump);
					return lastYearsAverage;
				}
				catch(Exception t){
					t.printStackTrace();
				}
			}
    	}
    	double price=0;
    	long day = 24*3600*1000;
    	long year = 365*day;
    	double totalprice = 0;
    	double count = 0;
    	
    	Vector prices = Pointer.getLoosePointers("drugprice."+getUid()+".",new java.util.Date(new java.util.Date().getTime()-year),new java.util.Date());
    	for(int n=0; n<prices.size();n++){
    		String[] s = ((String)prices.elementAt(n)).split(";");
    		if(s.length > 1){
    			totalprice+= Double.parseDouble(s[0])*Double.parseDouble(s[1]);
    			count+= Double.parseDouble(s[0]);
    		}
    	}
    	
    	if(count > 0){
    		price = totalprice/count;
    	}
    	else{
    		String sLastPrice=Pointer.getLastPointer("drugprice."+getUid()+".", new java.util.Date(new java.util.Date().getTime()-year));
    		if(sLastPrice.length()>0){
    			price=Double.parseDouble(sLastPrice.split(";")[1]);
    		}
    	}
    	lastYearsAverage=price;
    	return price;
    }
    
    public double getLastYearsAveragePrice(java.util.Date date){
    	if(lastYearAverages.get(date)!=null){
    		return (Double)lastYearAverages.get(date);
    	}
    	if(MedwanQuery.getInstance().getConfigInt("usePUMPFormula",1)==2){
			String pump = Pointer.getLastExactPointer("pump."+getUid(),date);
			if(pump.length()>0){
				try{
					lastYearAverages.put(date, Double.parseDouble(pump));
					return Double.parseDouble(pump);
				}
				catch(Exception t){
					t.printStackTrace();
				}
			}
    	}
    	double price=0;
    	long day = 24*3600*1000;
    	long year = 365*day;
    	double totalprice=0;
    	double count=0;
    	Vector prices = Pointer.getLoosePointers("drugprice."+getUid()+".", new java.util.Date(date.getTime()-year), date);
    	for(int n=0; n<prices.size();n++){
    		String[] s = ((String)prices.elementAt(n)).split(";");
    		if(s.length>1){
    			totalprice+=Double.parseDouble(s[0])*Double.parseDouble(s[1]);
    			count+=Double.parseDouble(s[0]);
    		}
    	}
    	if(count>0){
    		price=totalprice/count;
    	}
    	else{
    		String sLastPrice=Pointer.getLastPointer("drugprice."+getUid()+".", new java.util.Date(date.getTime()-year));
    		if(sLastPrice.length()>0){
    			price=Double.parseDouble(sLastPrice.split(";")[1]);
    		}
    	}
    	if(price==0) {
    		price=getUnitPrice();
    	}
		lastYearAverages.put(date, price);
    	return price;
    }
    
    public double getLooseLastYearsAveragePrice(java.util.Date date){
    	if(looseLastYearAverages.get(date)!=null){
    		return (Double)looseLastYearAverages.get(date);
    	}
    	if(MedwanQuery.getInstance().getConfigInt("usePUMPFormula",1)==2){
			String pump = Pointer.getLastExactPointer("pump."+getUid(),date);
			if(pump.length()>0){
				try{
					looseLastYearAverages.put(date, Double.parseDouble(pump));
					return Double.parseDouble(pump);
				}
				catch(Exception t){
					t.printStackTrace();
				}
			}
    	}
    	double price=0;
    	long day = 24*3600*1000;
    	long year = 365*day;
    	double totalprice=0;
    	double count=0;
    	Vector prices = Pointer.getLoosePointers("drugprice."+getUid()+".", new java.util.Date(date.getTime()-year), date);
    	for(int n=0; n<prices.size();n++){
    		String[] s = ((String)prices.elementAt(n)).split(";");
    		if(s.length>1){
    			totalprice+=Double.parseDouble(s[0])*Double.parseDouble(s[1]);
    			count+=Double.parseDouble(s[0]);
    		}
    	}
    	if(count>0){
    		price=totalprice/count;
    	}
    	else {
    		String last = Pointer.getLastExactPointer("drugprice."+getUid());
    		String[] s = last.split(";");
    		if(s.length>1){
    			totalprice+=Double.parseDouble(s[0])*Double.parseDouble(s[1]);
    			count+=Double.parseDouble(s[0]);
    		}
        	if(count>0){
        		price=totalprice/count;
        	}
    	}
		looseLastYearAverages.put(date, price);
    	return price;
    }
    
    //--- SUPPLIER --------------------------------------------------------------------------------
    public Service getSupplier(){
        if(supplierUid!=null && supplierUid.length() > 0){
            if(supplier==null){
                this.setSupplier(Service.getService(supplierUid));
            }
        }

        return supplier;
    }

    public void setSupplier(Service supplier){
        this.supplier = supplier;
    }

    //--- TIMEUNIT --------------------------------------------------------------------------------
    public String getTimeUnit(){
        return timeUnit;
    }

    public void setTimeUnit(String timeUnit){
        this.timeUnit = timeUnit;
    }

    //--- TIMEUNIT COUNT --------------------------------------------------------------------------
    public int getTimeUnitCount(){
        return timeUnitCount;
    }

    public void setTimeUnitCount(int timeUnitCount){
        this.timeUnitCount = timeUnitCount;
    }

    //--- UNITS PER TIMEUNIT ----------------------------------------------------------------------
    public double getUnitsPerTimeUnit(){
        return unitsPerTimeUnit;
    }

    public void setUnitsPerTimeUnit(double unitsPerTimeUnit){
        this.unitsPerTimeUnit = unitsPerTimeUnit;
    }

    //--- PRODUCTGROUP ----------------------------------------------------------------------------
    public String getProductGroup(){
        return productGroup;
    }

    public void setProductGroup(String productGroup){
        this.productGroup = productGroup;
    }

    //--- NON_DB DATA : SUPPLIER UID --------------------------------------------------------------
    public void setSupplierUid(String uid){
        this.supplierUid = uid;
    }

    public String getSupplierUid(){
        return this.supplierUid;
    }

    public static Hashtable getProductNames(){
    	Hashtable names = new Hashtable();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        String sSelect = "SELECT * FROM OC_PRODUCTS";
        try{
	        ps = oc_conn.prepareStatement(sSelect);
	        rs = ps.executeQuery();
	        while(rs.next()){
	        	names.put(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID"), rs.getString("OC_PRODUCT_NAME"));
	        }
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
	        
    	return names;
    }
    //--- GET -------------------------------------------------------------------------------------
    public static Product get(String productUid){
    	Product product = (Product)MedwanQuery.getInstance().getObjectCache().getObject("product",productUid);
        if(product!=null){
            return product;
        }
        String sUids[] = productUid.split("\\.");

        if(sUids.length == 2){
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
            try{
                String sSelect = "SELECT * FROM OC_PRODUCTS"+
                                 " WHERE OC_PRODUCT_OBJECTID = ? AND OC_PRODUCT_SERVERID = ?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sUids[1]));
                ps.setInt(2,Integer.parseInt(sUids[0]));
                rs = ps.executeQuery();

                // get data from DB
                if(rs.next()){
                    product = new Product();
                    product.setUid(productUid);

                    product.setName(rs.getString("OC_PRODUCT_NAME"));
                    product.setDose(rs.getString("OC_PRODUCT_DOSE"));
                    product.setUnit(rs.getString("OC_PRODUCT_UNIT"));
                    product.setUnitPrice(rs.getDouble("OC_PRODUCT_UNITPRICE"));
                    product.setPackageUnits(rs.getInt("OC_PRODUCT_PACKAGEUNITS"));
                    product.setSupplierUid(rs.getString("OC_PRODUCT_SUPPLIERUID"));
                    product.setProductGroup(rs.getString("OC_PRODUCT_PRODUCTGROUP"));
                    product.setProductSubGroup(rs.getString("OC_PRODUCT_PRODUCTSUBGROUP"));
                    product.setPrescriptionInfo(rs.getString("OC_PRODUCT_PRESCRIPTIONINFO"));
                    product.setBarcode(rs.getString("OC_PRODUCT_BARCODE"));
                    product.setAtccode(rs.getString("OC_PRODUCT_ATCCODE"));
                    product.setRxnormcode(rs.getString("OC_PRODUCT_RXNORMCODE"));
                    product.setPrestationcode(rs.getString("OC_PRODUCT_PRESTATIONCODE"));
                    product.setPrestationquantity(rs.getInt("OC_PRODUCT_PRESTATIONQUANTITY"));
                    product.setMargin(rs.getDouble("OC_PRODUCT_MARGIN"));
                    product.setApplyLowerPrices(rs.getInt("OC_PRODUCT_APPLYLOWERPRICES")==1);
                    product.setAutomaticInvoicing(rs.getInt("OC_PRODUCT_AUTOMATICINVOICING")==1);
                    product.setCode(ScreenHelper.checkString(rs.getString("OC_PRODUCT_CODE")));
                    product.setDhis2code(ScreenHelper.checkString(rs.getString("OC_PRODUCT_DHIS2CODE")));
                    
                    // timeUnit
                    String tmpValue = rs.getString("OC_PRODUCT_TIMEUNIT");
                    if(tmpValue!=null){
                        product.setTimeUnit(tmpValue);
                    }

                    // timeUnitCount
                    tmpValue = rs.getString("OC_PRODUCT_TIMEUNITCOUNT");
                    if(tmpValue!=null){
                        product.setTimeUnitCount(Integer.parseInt(tmpValue));
                    }

                    // unitsPerTimeUnit
                    tmpValue = rs.getString("OC_PRODUCT_UNITSPERTIMEUNIT");
                    if(tmpValue!=null){
                        product.setUnitsPerTimeUnit(Double.parseDouble(tmpValue));
                    }

                    // minimumOrderPackages
                    tmpValue = rs.getString("OC_PRODUCT_MINORDERPACKAGES");
                    if(tmpValue!=null){
                        product.setMinimumOrderPackages(Integer.parseInt(tmpValue));
                    }

                    // OBJECT variables
                    product.setCreateDateTime(rs.getTimestamp("OC_PRODUCT_CREATETIME"));
                    product.setUpdateDateTime(rs.getTimestamp("OC_PRODUCT_UPDATETIME"));
                    product.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_PRODUCT_UPDATEUID")));
                    product.setVersion(rs.getInt("OC_PRODUCT_VERSION"));
                    product.setTotalUnits(rs.getInt("OC_PRODUCT_TOTALUNITS"));
                    product.setRoute(rs.getString("OC_PRODUCT_ROUTE"));
                }
                else{
                    throw new Exception("ERROR : PRODUCT "+productUid+" NOT FOUND");
                }
            }
            catch(Exception e){
                if(e.getMessage().endsWith("NOT FOUND")){
                    Debug.println(e.getMessage());
                }
                else{
                    e.printStackTrace();
                }
            }
            finally{
                try{
                    if(rs!=null) rs.close();
                    if(ps!=null) ps.close();
                    oc_conn.close();

                }
                catch(SQLException se){
                    se.printStackTrace();
                }
            }
        }
        MedwanQuery.getInstance().getObjectCache().putObject("product",product);

        return product;
    }

    //--- GET PRODUCT FROM HISTORY ----------------------------------------------------------------
    public Product getProductFromHistory(String productUid){
        Product product = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sSelect = "SELECT * FROM OC_PRODUCTS_HISTORY"+
                             " WHERE OC_PRODUCT_SERVERID=? AND OC_PRODUCT_OBJECTID=?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(productUid.substring(0,productUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(productUid.substring(productUid.indexOf(".")+1)));

            rs = ps.executeQuery();
            if(rs.next()){
                product = new Product();
                product.setUid(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID"));
                product.setName(rs.getString("OC_PRODUCT_NAME"));
                product.setDose(rs.getString("OC_PRODUCT_DOSE"));
                product.setUnit(rs.getString("OC_PRODUCT_UNIT"));
                product.setUnitPrice(rs.getDouble("OC_PRODUCT_UNITPRICE"));
                product.setPackageUnits(rs.getInt("OC_PRODUCT_PACKAGEUNITS"));
                product.setBarcode(rs.getString("OC_PRODUCT_BARCODE"));
                product.setAtccode(rs.getString("OC_PRODUCT_ATCCODE"));
                product.setRxnormcode(rs.getString("OC_PRODUCT_RXNORMCODE"));
                product.setPrestationcode(rs.getString("OC_PRODUCT_PRESTATIONCODE"));
                product.setPrestationquantity(rs.getInt("OC_PRODUCT_PRESTATIONQUANTITY"));
                product.setMargin(rs.getDouble("OC_PRODUCT_MARGIN"));
                product.setApplyLowerPrices(rs.getInt("OC_PRODUCT_APPLYLOWERPRICES")==1);
                product.setAutomaticInvoicing(rs.getInt("OC_PRODUCT_AUTOMATICINVOICING")==1);
                product.setCode(ScreenHelper.checkString(rs.getString("OC_PRODUCT_CODE")));
                product.setDhis2code(ScreenHelper.checkString(rs.getString("OC_PRODUCT_DHIS2CODE")));

                // supplier
                String supplierUid = rs.getString("OC_PRODUCT_SUPPLIERUID");
                if(supplierUid!=null){
                    Service supplier = Service.getService(supplierUid);
                    product.setSupplier(supplier);
                    product.setSupplierUid(supplierUid);
                }

                // timeUnit
                String tmpValue = rs.getString("OC_PRODUCT_TIMEUNIT");
                if(tmpValue!=null){
                    product.setTimeUnit(tmpValue);
                }

                // timeUnitCount
                tmpValue = rs.getString("OC_PRODUCT_TIMEUNITCOUNT");
                if(tmpValue!=null){
                    product.setTimeUnitCount(Integer.parseInt(tmpValue));
                }

                // unitsPerTimeUnit
                tmpValue = rs.getString("OC_PRODUCT_UNITSPERTIMEUNIT");
                if(tmpValue!=null){
                    product.setUnitsPerTimeUnit(Double.parseDouble(tmpValue));
                }

                // minimumOrderPackages
                tmpValue = rs.getString("OC_PRODUCT_MINORDERPACKAGES");
                if(tmpValue!=null){
                    product.setMinimumOrderPackages(Integer.parseInt(tmpValue));
                }

                // productGroup
                product.setProductGroup(rs.getString("OC_PRODUCT_PRODUCTGROUP"));
                product.setProductSubGroup(rs.getString("OC_PRODUCT_PRODUCTSUBGROUP"));

                // OBJECT variables
                product.setCreateDateTime(rs.getTimestamp("OC_PRODUCT_CREATETIME"));
                product.setUpdateDateTime(rs.getTimestamp("OC_PRODUCT_UPDATETIME"));
                product.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_PRODUCT_UPDATEUID")));
                product.setVersion(rs.getInt("OC_PRODUCT_VERSION"));
                product.setPrescriptionInfo(rs.getString("OC_PRODUCT_PRESCRIPTIONINFO"));
                product.setTotalUnits(rs.getInt("OC_PRODUCT_TOTALUNITS"));
                product.setRoute(rs.getString("OC_PRODUCT_ROUTE"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return product;
    }

    //--- STORE -----------------------------------------------------------------------------------
    public void store(){
        store(true);
    }

    public void store(boolean checkExistence){
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        int newVersion = 1;
        boolean productWithSameDataExists = false;

        // set new productuid if needed
        if(this.getUid().equals("-1")){
            int serverId = MedwanQuery.getInstance().getConfigInt("serverId");
            int productCounter = MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTS");
            this.setUid(serverId+"."+productCounter);
        }

        // check existence if needed
        if(checkExistence){
            productWithSameDataExists = (this.exists().length() > 0);
        }

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(!this.getUid().equals("-1") && !productWithSameDataExists){

                // get version of product that is copied to history and increase it
                sSelect = "SELECT * FROM OC_PRODUCTS WHERE OC_PRODUCT_SERVERID = ? AND OC_PRODUCT_OBJECTID = ?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
                ps.setInt(2,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));
                rs = ps.executeQuery();
                if(rs.next()){
                    newVersion = rs.getInt("OC_PRODUCT_VERSION")+1;
                }
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();

                // delete product from current products
                Debug.println("@@@ PRODUCT DELETE after TO-HISTORY-COPY @@@");

                sSelect = "INSERT INTO OC_PRODUCTS_HISTORY(OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID,"+
                      "  OC_PRODUCT_NAME,OC_PRODUCT_UNIT,OC_PRODUCT_UNITPRICE,OC_PRODUCT_PACKAGEUNITS,"+
                      "  OC_PRODUCT_MINORDERPACKAGES,OC_PRODUCT_SUPPLIERUID,OC_PRODUCT_TIMEUNIT,"+
                      "  OC_PRODUCT_TIMEUNITCOUNT,OC_PRODUCT_UNITSPERTIMEUNIT,OC_PRODUCT_PRODUCTGROUP,"+
                      "  OC_PRODUCT_CREATETIME,OC_PRODUCT_UPDATETIME,OC_PRODUCT_UPDATEUID,OC_PRODUCT_VERSION,OC_PRODUCT_PRESCRIPTIONINFO,"+
                      "  OC_PRODUCT_BARCODE,OC_PRODUCT_PRESTATIONCODE,OC_PRODUCT_PRESTATIONQUANTITY,OC_PRODUCT_MARGIN,OC_PRODUCT_APPLYLOWERPRICES,"+
                      "  OC_PRODUCT_AUTOMATICINVOICING,OC_PRODUCT_PRODUCTSUBGROUP,OC_PRODUCT_ATCCODE,OC_PRODUCT_TOTALUNITS,OC_PRODUCT_RXNORMCODE,"
                      + "OC_PRODUCT_CODE,OC_PRODUCT_DOSE,OC_PRODUCT_DHIS2CODE,OC_PRODUCT_ROUTE) "
                      + "SELECT OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID,"+
                      "  OC_PRODUCT_NAME,OC_PRODUCT_UNIT,OC_PRODUCT_UNITPRICE,OC_PRODUCT_PACKAGEUNITS,"+
                      "  OC_PRODUCT_MINORDERPACKAGES,OC_PRODUCT_SUPPLIERUID,OC_PRODUCT_TIMEUNIT,"+
                      "  OC_PRODUCT_TIMEUNITCOUNT,OC_PRODUCT_UNITSPERTIMEUNIT,OC_PRODUCT_PRODUCTGROUP,"+
                      "  OC_PRODUCT_CREATETIME,OC_PRODUCT_UPDATETIME,OC_PRODUCT_UPDATEUID,OC_PRODUCT_VERSION,OC_PRODUCT_PRESCRIPTIONINFO,"+
                      "  OC_PRODUCT_BARCODE,OC_PRODUCT_PRESTATIONCODE,OC_PRODUCT_PRESTATIONQUANTITY,OC_PRODUCT_MARGIN,OC_PRODUCT_APPLYLOWERPRICES,"+
                      "  OC_PRODUCT_AUTOMATICINVOICING,OC_PRODUCT_PRODUCTSUBGROUP,OC_PRODUCT_ATCCODE,OC_PRODUCT_TOTALUNITS,OC_PRODUCT_RXNORMCODE,"
                      + "OC_PRODUCT_CODE,OC_PRODUCT_DOSE,OC_PRODUCT_DHIS2CODE,OC_PRODUCT_ROUTE FROM OC_PRODUCTS "
                      + "WHERE OC_PRODUCT_SERVERID = ? AND OC_PRODUCT_OBJECTID = ?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
                ps.setInt(2,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));
                ps.executeUpdate();
                if(ps!=null) ps.close();
                
                sSelect = "DELETE FROM OC_PRODUCTS WHERE OC_PRODUCT_SERVERID = ? AND OC_PRODUCT_OBJECTID = ?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
                ps.setInt(2,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));
                ps.executeUpdate();
                if(ps!=null) ps.close();
            }

            // insert new version of product into current products
            Debug.println("@@@ PRODUCT insert @@@");

            sSelect = "INSERT INTO OC_PRODUCTS (OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID,"+
                      "  OC_PRODUCT_NAME,OC_PRODUCT_UNIT,OC_PRODUCT_UNITPRICE,OC_PRODUCT_PACKAGEUNITS,"+
                      "  OC_PRODUCT_MINORDERPACKAGES,OC_PRODUCT_SUPPLIERUID,OC_PRODUCT_TIMEUNIT,"+
                      "  OC_PRODUCT_TIMEUNITCOUNT,OC_PRODUCT_UNITSPERTIMEUNIT,OC_PRODUCT_PRODUCTGROUP,"+
                      "  OC_PRODUCT_CREATETIME,OC_PRODUCT_UPDATETIME,OC_PRODUCT_UPDATEUID,OC_PRODUCT_VERSION,OC_PRODUCT_PRESCRIPTIONINFO,"+
                      "  OC_PRODUCT_BARCODE,OC_PRODUCT_PRESTATIONCODE,OC_PRODUCT_PRESTATIONQUANTITY,OC_PRODUCT_MARGIN,OC_PRODUCT_APPLYLOWERPRICES,"+
                      "  OC_PRODUCT_AUTOMATICINVOICING,OC_PRODUCT_PRODUCTSUBGROUP,OC_PRODUCT_ATCCODE,OC_PRODUCT_TOTALUNITS,OC_PRODUCT_RXNORMCODE,"
                      + "OC_PRODUCT_CODE,OC_PRODUCT_DOSE,OC_PRODUCT_DHIS2CODE,OC_PRODUCT_ROUTE)"+
                      " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
            ps.setInt(2,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));

            ps.setString(3,this.getName());
            ps.setString(4,this.getUnit());
            ps.setDouble(5,this.getUnitPrice());
            ps.setInt(6,this.getPackageUnits());

            if(this.getMinimumOrderPackages() > -1) ps.setInt(7,this.getMinimumOrderPackages());
            else                                    ps.setNull(7,Types.INTEGER);

            if(this.getSupplierUid()!=null && this.getSupplierUid().length() > 0) ps.setString(8,this.getSupplierUid());
            else                                                                  ps.setNull(8,Types.VARCHAR);

            if(this.getTimeUnit()!=null && this.getTimeUnit().length() > 0) ps.setString(9,this.getTimeUnit());
            else                                                            ps.setNull(9,Types.VARCHAR);

            if(this.getTimeUnitCount() > -1) ps.setInt(10,this.getTimeUnitCount());
            else                             ps.setNull(10,Types.INTEGER);

            if(this.getUnitsPerTimeUnit() > -1) ps.setDouble(11,this.getUnitsPerTimeUnit());
            else                                ps.setNull(11,Types.DOUBLE);

            if(this.getProductGroup()!=null) ps.setString(12,this.getProductGroup());
            else                             ps.setString(12,"");                             

            // OBJECT variables
            ps.setTimestamp(13,new java.sql.Timestamp(new java.util.Date().getTime())); // now
            ps.setTimestamp(14,new java.sql.Timestamp(new java.util.Date().getTime())); // now
            ps.setString(15,this.getUpdateUser());
            ps.setInt(16,newVersion);
            ps.setString(17,this.getPrescriptionInfo());
            ps.setString(18,this.getBarcode());
            ps.setString(19,this.getPrestationcode());
            ps.setInt(20,this.getPrestationquantity());
            ps.setDouble(21,this.getMargin());
            ps.setInt(22,isApplyLowerPrices()?1:0);
            ps.setInt(23,isAutomaticInvoicing()?1:0);
            
            if(this.getProductSubGroup()!=null) ps.setString(24,this.getProductSubGroup());
            else                                ps.setString(24,"");                             
            
            ps.setString(25, this.getAtccode());
            ps.setDouble(26, this.getTotalUnits());
            ps.setString(27, this.getRxnormcode());
            ps.setString(28, this.getCode());
            ps.setString(29, this.getDose());
            ps.setString(30, this.getDhis2code());
            ps.setString(31,  this.getRoute());
            ps.executeUpdate();
            
            //If a health service and a margin were provided, automatically update the health service price
            if(this.getPrestationcode()!=null && this.getPrestationcode().length()>0 && this.getMargin()!=0 && this.getPrestationquantity()>0){
            	Prestation prestation = Prestation.get(this.getPrestationcode());
            	if(prestation!=null){
            		double newPrice = this.getUnitPrice()*(100+this.getMargin())/(100*(this.getPrestationquantity()));
            		if(isApplyLowerPrices()||newPrice>prestation.getPrice()){
	            		prestation.setPrice(newPrice);
	            		prestation.store();
            		}
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
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
        MedwanQuery.getInstance().getObjectCache().putObject("product",this);
    }

    //--- EXISTS ----------------------------------------------------------------------------------
    // checks the database for a record with the same UNIQUE KEYS as 'this'.
    public String exists(){
        Debug.println("@@@ PRODUCT exists ? @@@");

        PreparedStatement ps = null;
        ResultSet rs = null;
        String uid = "";

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //*** check existence ***
            String sSelect = "SELECT OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID FROM OC_PRODUCTS"+
                             " WHERE OC_PRODUCT_NAME=?"+
                             "  AND OC_PRODUCT_UNIT=?";
            ps = oc_conn.prepareStatement(sSelect);
            int questionmarkIdx = 1;
            ps.setString(questionmarkIdx++,this.getName());
            ps.setString(questionmarkIdx++,this.getUnit());


            rs = ps.executeQuery();
            if(rs.next()){
                uid = rs.getInt("OC_PRODUCT_SERVERID")+"."+rs.getInt("OC_PRODUCT_OBJECTID");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return uid;
    }

    //--- CHANGED ---------------------------------------------------------------------------------
    // checks the database for a record with the same DATA as 'this'.
    public boolean changed(){
        Debug.println("@@@ PRODUCT changed ? @@@");

        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean changed = true;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            //*** check existence ***
            String sSelect = "SELECT OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID FROM OC_PRODUCTS"+
                             " WHERE OC_PRODUCT_NAME=?"+
                             "  AND OC_PRODUCT_UNIT=?"+
                             "  AND OC_PRODUCT_UNITPRICE=?"+
                             "  AND OC_PRODUCT_PACKAGEUNITS=?"+
                             "  AND OC_PRODUCT_MINORDERPACKAGES=?"+
                             "  AND OC_PRODUCT_SUPPLIERUID=?"+
                             "  AND OC_PRODUCT_TIMEUNIT=?"+
                             "  AND OC_PRODUCT_TIMEUNITCOUNT=?"+
                             "  AND OC_PRODUCT_UNITSPERTIMEUNIT=?"+
                             "  AND OC_PRODUCT_PRODUCTGROUP=?";

            ps = oc_conn.prepareStatement(sSelect);
            int questionmarkIdx = 1;

            ps.setString(questionmarkIdx++,this.getName()); // required
            ps.setString(questionmarkIdx++,this.getUnit()); // required
            ps.setDouble(questionmarkIdx++,this.getUnitPrice()); // required
            ps.setInt(questionmarkIdx++,this.getPackageUnits()); // required

            // minimumOrderPackages
            if(this.minimumOrderPackages > -1) ps.setInt(questionmarkIdx++,this.minimumOrderPackages);
            else                               ps.setNull(questionmarkIdx++,Types.INTEGER);

            // supplierUid
            if(this.getSupplierUid().length() > 0) ps.setString(questionmarkIdx++,this.getSupplierUid());
            else                                   ps.setNull(questionmarkIdx++,Types.VARCHAR);

            // timeUnit
            if(this.getTimeUnit().length() > 0) ps.setString(questionmarkIdx++,this.getTimeUnit());
            else                                ps.setNull(questionmarkIdx++,Types.VARCHAR);

            // timeUnitCount
            if(this.timeUnitCount > -1) ps.setInt(questionmarkIdx++,this.timeUnitCount);
            else                        ps.setNull(questionmarkIdx++,Types.INTEGER);

            // unitsPerTimeUnit
            if(this.unitsPerTimeUnit > -1) ps.setDouble(questionmarkIdx++,this.unitsPerTimeUnit);
            else                           ps.setNull(questionmarkIdx++,Types.DOUBLE);

            // productGroup
            if(this.getProductGroup().length() > 0) ps.setString(questionmarkIdx++,this.getProductGroup());
            else                                    ps.setNull(questionmarkIdx++,Types.VARCHAR);

            rs = ps.executeQuery();
            if(rs.next()) changed = false;
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return changed;
    }

    public static Vector getLimitedDrugs(String name,int maxrows){
    	Vector products = new Vector();
    	PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PRODUCTS"+
                             " WHERE OC_PRODUCT_NAME like ? or OC_PRODUCT_CODE like ? order by OC_PRODUCT_NAME";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, "%"+name+"%");
            ps.setString(2, "%"+name+"%");
            rs = ps.executeQuery();

            int counter=0;
            Product product;
            // get data from DB
            while (rs.next() && counter<=maxrows){
            	counter++;
                product = new Product();
                product.setUid(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID"));
                product.setCode(rs.getString("OC_PRODUCT_CODE"));
                product.setName(rs.getString("OC_PRODUCT_NAME"));
                product.setDose(rs.getString("OC_PRODUCT_DOSE"));
                product.setUnit(rs.getString("OC_PRODUCT_UNIT"));
                product.setUnitPrice(rs.getDouble("OC_PRODUCT_UNITPRICE"));
                product.setPackageUnits(rs.getInt("OC_PRODUCT_PACKAGEUNITS"));
                product.setSupplierUid(rs.getString("OC_PRODUCT_SUPPLIERUID"));
                product.setProductGroup(rs.getString("OC_PRODUCT_PRODUCTGROUP"));
                product.setProductSubGroup(rs.getString("OC_PRODUCT_PRODUCTSUBGROUP"));
                product.setPrescriptionInfo(rs.getString("OC_PRODUCT_PRESCRIPTIONINFO"));
                product.setBarcode(rs.getString("OC_PRODUCT_BARCODE"));
                product.setAtccode(rs.getString("OC_PRODUCT_ATCCODE"));
                product.setRxnormcode(rs.getString("OC_PRODUCT_RXNORMCODE"));
                product.setPrestationcode(rs.getString("OC_PRODUCT_PRESTATIONCODE"));
                product.setPrestationquantity(rs.getInt("OC_PRODUCT_PRESTATIONQUANTITY"));
                product.setMargin(rs.getDouble("OC_PRODUCT_MARGIN"));
                product.setApplyLowerPrices(rs.getInt("OC_PRODUCT_APPLYLOWERPRICES")==1);
                product.setAutomaticInvoicing(rs.getInt("OC_PRODUCT_AUTOMATICINVOICING")==1);
                product.setCode(ScreenHelper.checkString(rs.getString("OC_PRODUCT_CODE")));
                product.setDhis2code(ScreenHelper.checkString(rs.getString("OC_PRODUCT_DHIS2CODE")));
                product.setRoute(rs.getString("OC_PRODUCT_ROUTE"));
                
                // timeUnit
                String tmpValue = rs.getString("OC_PRODUCT_TIMEUNIT");
                if(tmpValue!=null){
                    product.setTimeUnit(tmpValue);
                }

                // timeUnitCount
                tmpValue = rs.getString("OC_PRODUCT_TIMEUNITCOUNT");
                if(tmpValue!=null){
                    product.setTimeUnitCount(Integer.parseInt(tmpValue));
                }

                // unitsPerTimeUnit
                tmpValue = rs.getString("OC_PRODUCT_UNITSPERTIMEUNIT");
                if(tmpValue!=null){
                    product.setUnitsPerTimeUnit(Double.parseDouble(tmpValue));
                }

                // minimumOrderPackages
                tmpValue = rs.getString("OC_PRODUCT_MINORDERPACKAGES");
                if(tmpValue!=null){
                    product.setMinimumOrderPackages(Integer.parseInt(tmpValue));
                }

                // OBJECT variables
                product.setCreateDateTime(rs.getTimestamp("OC_PRODUCT_CREATETIME"));
                product.setUpdateDateTime(rs.getTimestamp("OC_PRODUCT_UPDATETIME"));
                product.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_PRODUCT_UPDATEUID")));
                product.setVersion(rs.getInt("OC_PRODUCT_VERSION"));
                product.setTotalUnits(rs.getInt("OC_PRODUCT_TOTALUNITS"));
                products.add(product);
            }
        }
        catch(Exception e){
            if(e.getMessage().endsWith("NOT FOUND")){
                Debug.println(e.getMessage());
            }
            else{
                e.printStackTrace();
            }
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }    	
        return products;
    }
    
    public static Vector getLimitedDrugs(String name,int maxrows,String serviceStockUid){
    	Vector products = new Vector();
    	PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PRODUCTS,OC_PRODUCTSTOCKS"+
                             " WHERE "
                             + " (OC_PRODUCT_NAME like ? OR OC_PRODUCT_CODE like ?) AND"
                             + " OC_PRODUCT_OBJECTID=replace(OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') AND"
                             + " OC_STOCK_SERVICESTOCKUID=? AND"
                             + " OC_STOCK_LEVEL>0"
                             + " order by OC_PRODUCT_NAME";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, "%"+name+"%");
            ps.setString(2, "%"+name+"%");
            ps.setString(3, serviceStockUid);
            rs = ps.executeQuery();

            int counter=0;
            Product product;
            // get data from DB
            while (rs.next() && counter<=maxrows){
            	counter++;
                product = new Product();
                product.setUid(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID"));
                product.setCode(rs.getString("OC_PRODUCT_CODE"));
                product.setName(rs.getString("OC_PRODUCT_NAME"));
                product.setDose(rs.getString("OC_PRODUCT_DOSE"));
                product.setUnit(rs.getString("OC_PRODUCT_UNIT"));
                product.setUnitPrice(rs.getDouble("OC_PRODUCT_UNITPRICE"));
                product.setPackageUnits(rs.getInt("OC_PRODUCT_PACKAGEUNITS"));
                product.setSupplierUid(rs.getString("OC_PRODUCT_SUPPLIERUID"));
                product.setProductGroup(rs.getString("OC_PRODUCT_PRODUCTGROUP"));
                product.setProductSubGroup(rs.getString("OC_PRODUCT_PRODUCTSUBGROUP"));
                product.setPrescriptionInfo(rs.getString("OC_PRODUCT_PRESCRIPTIONINFO"));
                product.setBarcode(rs.getString("OC_PRODUCT_BARCODE"));
                product.setAtccode(rs.getString("OC_PRODUCT_ATCCODE"));
                product.setRxnormcode(rs.getString("OC_PRODUCT_RXNORMCODE"));
                product.setPrestationcode(rs.getString("OC_PRODUCT_PRESTATIONCODE"));
                product.setPrestationquantity(rs.getInt("OC_PRODUCT_PRESTATIONQUANTITY"));
                product.setMargin(rs.getDouble("OC_PRODUCT_MARGIN"));
                product.setApplyLowerPrices(rs.getInt("OC_PRODUCT_APPLYLOWERPRICES")==1);
                product.setAutomaticInvoicing(rs.getInt("OC_PRODUCT_AUTOMATICINVOICING")==1);
                product.setCode(ScreenHelper.checkString(rs.getString("OC_PRODUCT_CODE")));
                product.setDhis2code(ScreenHelper.checkString(rs.getString("OC_PRODUCT_DHIS2CODE")));
                product.setRoute(rs.getString("OC_PRODUCT_ROUTE"));
                
                // timeUnit
                String tmpValue = rs.getString("OC_PRODUCT_TIMEUNIT");
                if(tmpValue!=null){
                    product.setTimeUnit(tmpValue);
                }

                // timeUnitCount
                tmpValue = rs.getString("OC_PRODUCT_TIMEUNITCOUNT");
                if(tmpValue!=null){
                    product.setTimeUnitCount(Integer.parseInt(tmpValue));
                }

                // unitsPerTimeUnit
                tmpValue = rs.getString("OC_PRODUCT_UNITSPERTIMEUNIT");
                if(tmpValue!=null){
                    product.setUnitsPerTimeUnit(Double.parseDouble(tmpValue));
                }

                // minimumOrderPackages
                tmpValue = rs.getString("OC_PRODUCT_MINORDERPACKAGES");
                if(tmpValue!=null){
                    product.setMinimumOrderPackages(Integer.parseInt(tmpValue));
                }

                // OBJECT variables
                product.setCreateDateTime(rs.getTimestamp("OC_PRODUCT_CREATETIME"));
                product.setUpdateDateTime(rs.getTimestamp("OC_PRODUCT_UPDATETIME"));
                product.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_PRODUCT_UPDATEUID")));
                product.setVersion(rs.getInt("OC_PRODUCT_VERSION"));
                product.setTotalUnits(rs.getInt("OC_PRODUCT_TOTALUNITS"));
                products.add(product);
            }
        }
        catch(Exception e){
            if(e.getMessage().endsWith("NOT FOUND")){
                Debug.println(e.getMessage());
            }
            else{
                e.printStackTrace();
            }
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }    	
        return products;
    }
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static void delete(String productUid){
        PreparedStatement ps = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "DELETE FROM OC_PRODUCTS"+
                             " WHERE OC_PRODUCT_SERVERID = ? AND OC_PRODUCT_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(productUid.substring(0,productUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(productUid.substring(productUid.indexOf(".")+1)));
            ps.executeUpdate();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
        MedwanQuery.getInstance().getObjectCache().removeObject("product",productUid);
    }

    //--- DELETE ----------------------------------------------------------------------------------
    public static void moveToHistory(String productUid){
        PreparedStatement ps = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "INSERT INTO OC_PRODUCTS_HISTORY(OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID,"+
                    "  OC_PRODUCT_NAME,OC_PRODUCT_UNIT,OC_PRODUCT_UNITPRICE,OC_PRODUCT_PACKAGEUNITS,"+
                    "  OC_PRODUCT_MINORDERPACKAGES,OC_PRODUCT_SUPPLIERUID,OC_PRODUCT_TIMEUNIT,"+
                    "  OC_PRODUCT_TIMEUNITCOUNT,OC_PRODUCT_UNITSPERTIMEUNIT,OC_PRODUCT_PRODUCTGROUP,"+
                    "  OC_PRODUCT_CREATETIME,OC_PRODUCT_UPDATETIME,OC_PRODUCT_UPDATEUID,OC_PRODUCT_VERSION,OC_PRODUCT_PRESCRIPTIONINFO,"+
                    "  OC_PRODUCT_BARCODE,OC_PRODUCT_PRESTATIONCODE,OC_PRODUCT_PRESTATIONQUANTITY,OC_PRODUCT_MARGIN,OC_PRODUCT_APPLYLOWERPRICES,"+
                    "  OC_PRODUCT_AUTOMATICINVOICING,OC_PRODUCT_PRODUCTSUBGROUP,OC_PRODUCT_ATCCODE,OC_PRODUCT_TOTALUNITS,OC_PRODUCT_RXNORMCODE,"
                    + "OC_PRODUCT_CODE,OC_PRODUCT_DOSE,OC_PRODUCT_DHIS2CODE,OC_PRODUCT_ROUTE) "
                    + "SELECT OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID,"+
                    "  OC_PRODUCT_NAME,OC_PRODUCT_UNIT,OC_PRODUCT_UNITPRICE,OC_PRODUCT_PACKAGEUNITS,"+
                    "  OC_PRODUCT_MINORDERPACKAGES,OC_PRODUCT_SUPPLIERUID,OC_PRODUCT_TIMEUNIT,"+
                    "  OC_PRODUCT_TIMEUNITCOUNT,OC_PRODUCT_UNITSPERTIMEUNIT,OC_PRODUCT_PRODUCTGROUP,"+
                    "  OC_PRODUCT_CREATETIME,OC_PRODUCT_UPDATETIME,OC_PRODUCT_UPDATEUID,OC_PRODUCT_VERSION,OC_PRODUCT_PRESCRIPTIONINFO,"+
                    "  OC_PRODUCT_BARCODE,OC_PRODUCT_PRESTATIONCODE,OC_PRODUCT_PRESTATIONQUANTITY,OC_PRODUCT_MARGIN,OC_PRODUCT_APPLYLOWERPRICES,"+
                    "  OC_PRODUCT_AUTOMATICINVOICING,OC_PRODUCT_PRODUCTSUBGROUP,OC_PRODUCT_ATCCODE,OC_PRODUCT_TOTALUNITS,OC_PRODUCT_RXNORMCODE,"
                    + "OC_PRODUCT_CODE,OC_PRODUCT_DOSE,OC_PRODUCT_DHIS2CODE,OC_PRODUCT_ROUTE FROM OC_PRODUCTS "
                    + "WHERE OC_PRODUCT_SERVERID = ? AND OC_PRODUCT_OBJECTID = ?";
              ps = oc_conn.prepareStatement(sSelect);
              ps.setInt(1,Integer.parseInt(productUid.split("\\.")[0]));
              ps.setInt(2,Integer.parseInt(productUid.split("\\.")[1]));
              ps.executeUpdate();
              delete(productUid);
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
        MedwanQuery.getInstance().getObjectCache().removeObject("product",productUid);
    }

    //--- GET PRODUCT GOUPS -----------------------------------------------------------------------
    public static Vector getProductGroups(){
        Vector groups = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "select distinct OC_PRODUCT_PRODUCTGROUP"+
                             " from OC_PRODUCTS"+
            		         "  order by OC_PRODUCT_PRODUCTGROUP";
            ps=oc_conn.prepareStatement(sSelect);
            rs = ps.executeQuery();
            while (rs.next()){
                groups.add(rs.getString("OC_PRODUCT_PRODUCTGROUP"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return groups;
    }

    //--- GET PRODUCT SUBGOUPS --------------------------------------------------------------------
    public static Vector getProductSubGroups(){
        Vector groups = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "select distinct OC_PRODUCT_PRODUCTSUBGROUP"+
                             " from OC_PRODUCTS"+
            		         "  order by OC_PRODUCT_PRODUCTSUBGROUP";
            ps = oc_conn.prepareStatement(sSelect);
            rs = ps.executeQuery();
            while (rs.next()){
                groups.add(rs.getString("OC_PRODUCT_PRODUCTSUBGROUP"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return groups;
    }
    
    //--- FIND ------------------------------------------------------------------------------------
    public static Vector find(String sFindProductName, String sFindUnit, String sFindUnitPriceMin,
                              String sFindUnitPriceMax, String sFindPackageUnits, String sFindMinOrderPackages,
                              String sFindSupplierUid, String sFindProductGroup, String sSortCol, String sSortDir){
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	String sTop = MedwanQuery.getInstance().topFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
            String sSelect = "SELECT "+sTop+" OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID"+
                             " FROM OC_PRODUCTS ";

            if(sFindProductName.length()>0 || sFindUnit.length()>0 || sFindUnitPriceMin.length()>0 ||
               sFindUnitPriceMax.length()>0 || sFindPackageUnits.length()>0 || sFindMinOrderPackages.length()>0 ||
               sFindSupplierUid.length()>0 || sFindProductGroup.length()>0){
                sSelect+= "WHERE ";

                if(sFindProductName.length() > 0){
                    String sLowerProductName = MedwanQuery.getInstance().getConfigParam("lowerCompare","OC_PRODUCT_NAME");
                    sSelect+= sLowerProductName+" LIKE ? AND ";
                }

                if(sFindUnit.length() > 0)             sSelect+= "OC_PRODUCT_UNIT = ? AND ";
                if(sFindUnitPriceMin.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE >= ? AND ";
                if(sFindUnitPriceMax.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE <= ? AND ";
                if(sFindPackageUnits.length() > 0)     sSelect+= "OC_PRODUCT_PACKAGEUNITS = ? AND ";
                if(sFindMinOrderPackages.length() > 0) sSelect+= "OC_PRODUCT_MINORDERPACKAGES = ? AND ";
                if(sFindProductGroup.length() > 0)     sSelect+= "OC_PRODUCT_PRODUCTGROUP = ? AND ";

                if(sFindSupplierUid.length() > 0){
                    // Hier moet de stock komen die het product in voorraad moet hebben
                	sSelect+= "OC_PRODUCT_OBJECTID in (select replace(OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') from OC_PRODUCTSTOCKS where OC_STOCK_SERVICESTOCKUID='"+sFindSupplierUid+"') AND ";
                	
                	/*
                	// search all service and its child-services
                    Vector childIds = Service.getChildIds(sFindSupplierUid);
                    String sChildIds = ScreenHelper.tokenizeVector(childIds,",","'");
                    if(sChildIds.length() > 0){
                        sSelect+= "OC_PRODUCT_SUPPLIERUID IN ("+sChildIds+") AND ";
                    }
                    else{
                        sSelect+= "OC_PRODUCT_SUPPLIERUID IN ('') AND ";
                    }
                    */
                }

                // remove last AND if any
                if(sSelect.indexOf("AND ") > 0){
                    sSelect = sSelect.substring(0,sSelect.lastIndexOf("AND "));
                }
            }

            // order
            String sLimit = MedwanQuery.getInstance().limitFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
            sSelect+= "ORDER BY "+sSortCol+" "+sSortDir+sLimit;

            ps = oc_conn.prepareStatement(sSelect);

            // set questionmark values
            int questionMarkIdx = 1;
            if(sFindProductName.length() > 0)      ps.setString(questionMarkIdx++,"%"+sFindProductName.toLowerCase()+"%");
            if(sFindUnit.length() > 0)             ps.setString(questionMarkIdx++,sFindUnit);
            if(sFindUnitPriceMin.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMin));
            if(sFindUnitPriceMax.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMax));
            if(sFindPackageUnits.length() > 0)     ps.setInt(questionMarkIdx++,Integer.parseInt(sFindPackageUnits));
            if(sFindMinOrderPackages.length() > 0) ps.setInt(questionMarkIdx++,Integer.parseInt(sFindMinOrderPackages));
            if(sFindProductGroup.length() > 0)     ps.setString(questionMarkIdx++,sFindProductGroup);

            // execute
            rs = ps.executeQuery();

            while(rs.next()){
                foundObjects.add(get(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID")));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return foundObjects;
    }

    public static Vector findWithCode(String sFindProductCode, String sFindProductName, String sFindUnit, String sFindUnitPriceMin,
            String sFindUnitPriceMax, String sFindPackageUnits, String sFindMinOrderPackages,
            String sFindSupplierUid, String sFindProductGroup, String sSortCol, String sSortDir){
		Vector foundObjects = new Vector();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sTop = MedwanQuery.getInstance().topFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
			String sSelect = "SELECT "+sTop+" OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID"+
			           " FROM OC_PRODUCTS ";
			
			if(sFindProductCode.length()>0 || sFindProductName.length()>0 || sFindUnit.length()>0 || sFindUnitPriceMin.length()>0 ||
				sFindUnitPriceMax.length()>0 || sFindPackageUnits.length()>0 || sFindMinOrderPackages.length()>0 ||
				sFindSupplierUid.length()>0 || sFindProductGroup.length()>0){
				sSelect+= "WHERE ";
				
				if(sFindProductCode.length() > 0){
					sSelect+= "OC_PRODUCT_CODE LIKE ? AND ";
				}
				
				if(sFindProductName.length() > 0){
					String sLowerProductName = MedwanQuery.getInstance().getConfigParam("lowerCompare","OC_PRODUCT_NAME");
					sSelect+= sLowerProductName+" LIKE ? AND ";
				}
				
				if(sFindUnit.length() > 0)             sSelect+= "OC_PRODUCT_UNIT = ? AND ";
				if(sFindUnitPriceMin.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE >= ? AND ";
				if(sFindUnitPriceMax.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE <= ? AND ";
				if(sFindPackageUnits.length() > 0)     sSelect+= "OC_PRODUCT_PACKAGEUNITS = ? AND ";
				if(sFindMinOrderPackages.length() > 0) sSelect+= "OC_PRODUCT_MINORDERPACKAGES = ? AND ";
				if(sFindProductGroup.length() > 0)     sSelect+= "OC_PRODUCT_PRODUCTGROUP = ? AND ";
				
				if(sFindSupplierUid.length() > 0){
					sSelect+= "OC_PRODUCT_OBJECTID in (select replace(OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') from OC_PRODUCTSTOCKS where OC_STOCK_SERVICESTOCKUID='"+sFindSupplierUid+"') AND ";
				}
				
				// remove last AND if any
				if(sSelect.indexOf("AND ") > 0){
				  sSelect = sSelect.substring(0,sSelect.lastIndexOf("AND "));
				}
			}
			
			// order
			String sLimit = MedwanQuery.getInstance().limitFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
			sSelect+= "ORDER BY "+sSortCol+" "+sSortDir+sLimit;
			
			ps = oc_conn.prepareStatement(sSelect);
			
			// set questionmark values
			int questionMarkIdx = 1;
			if(sFindProductCode.length() > 0)      ps.setString(questionMarkIdx++,sFindProductCode+"%");
			if(sFindProductName.length() > 0)      ps.setString(questionMarkIdx++,"%"+sFindProductName.toLowerCase()+"%");
			if(sFindUnit.length() > 0)             ps.setString(questionMarkIdx++,sFindUnit);
			if(sFindUnitPriceMin.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMin));
			if(sFindUnitPriceMax.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMax));
			if(sFindPackageUnits.length() > 0)     ps.setInt(questionMarkIdx++,Integer.parseInt(sFindPackageUnits));
			if(sFindMinOrderPackages.length() > 0) ps.setInt(questionMarkIdx++,Integer.parseInt(sFindMinOrderPackages));
			if(sFindProductGroup.length() > 0)     ps.setString(questionMarkIdx++,sFindProductGroup);
			
			// execute
			rs = ps.executeQuery();
			
			while(rs.next()){
				foundObjects.add(get(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID")));
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				if(rs!=null) rs.close();
				if(ps!=null) ps.close();
				oc_conn.close();
			}
			catch(SQLException se){
				se.printStackTrace();
			}
		}
		
		return foundObjects;
	}
	
    //--- FIND ------------------------------------------------------------------------------------
    public static Vector find(String sFindProductName, String sFindUnit, String sFindUnitPriceMin,
                              String sFindUnitPriceMax, String sFindPackageUnits, String sFindMinOrderPackages,
                              String sFindSupplierUid, String sFindProductGroup, String sFindProductSubGroup,
                              String sSortCol, String sSortDir){
		Vector foundObjects = new Vector();
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sTop = MedwanQuery.getInstance().topFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
     	    String sSelect = "SELECT "+sTop+" OC_PRODUCT_SERVERID,OC_PRODUCT_OBJECTID"+
		                     " FROM OC_PRODUCTS ";
			
			if(sFindProductName.length()>0 || sFindUnit.length()>0 || sFindUnitPriceMin.length()>0 ||
			   sFindUnitPriceMax.length()>0 || sFindPackageUnits.length()>0 || sFindMinOrderPackages.length()>0 ||
			   sFindSupplierUid.length()>0 || sFindProductGroup.length()>0 || sFindProductSubGroup.length()>0){
				sSelect+= "WHERE ";
				
				if(sFindProductName.length() > 0){
				    String sLowerProductName = MedwanQuery.getInstance().getConfigParam("lowerCompare","OC_PRODUCT_NAME");
				    sSelect+= sLowerProductName+" LIKE ? AND ";
				}
				
				if(sFindUnit.length() > 0)             sSelect+= "OC_PRODUCT_UNIT = ? AND ";
				if(sFindUnitPriceMin.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE >= ? AND ";
				if(sFindUnitPriceMax.length() > 0)     sSelect+= "OC_PRODUCT_UNITPRICE <= ? AND ";
				if(sFindPackageUnits.length() > 0)     sSelect+= "OC_PRODUCT_PACKAGEUNITS = ? AND ";
				if(sFindMinOrderPackages.length() > 0) sSelect+= "OC_PRODUCT_MINORDERPACKAGES = ? AND ";
				if(sFindProductGroup.length() > 0)     sSelect+= "OC_PRODUCT_PRODUCTGROUP = ? AND ";
				if(sFindProductSubGroup.length() > 0)  sSelect+= "OC_PRODUCT_PRODUCTSUBGROUP like ? AND ";
				
				if(sFindSupplierUid.length() > 0){
				    // Hier moet de stock komen die het product in voorraad moet hebben
					sSelect+= "OC_PRODUCT_OBJECTID in (select replace(OC_STOCK_PRODUCTUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') from OC_PRODUCTSTOCKS where OC_STOCK_SERVICESTOCKUID='"+sFindSupplierUid+"') AND ";
					
					/*
					// search all service and its child-services
				    Vector childIds = Service.getChildIds(sFindSupplierUid);
				    String sChildIds = ScreenHelper.tokenizeVector(childIds,",","'");
				    if(sChildIds.length() > 0){
				        sSelect+= "OC_PRODUCT_SUPPLIERUID IN ("+sChildIds+") AND ";
				    }
				    else{
				        sSelect+= "OC_PRODUCT_SUPPLIERUID IN ('') AND ";
				    }
				    */
				}
			
				// remove last AND if any
				if(sSelect.indexOf("AND ") > 0){
				    sSelect = sSelect.substring(0,sSelect.lastIndexOf("AND "));
				}
			}
			
			// order
			String sLimit = MedwanQuery.getInstance().limitFunction(MedwanQuery.getInstance().getConfigString("maxProductsToShow","100"));
			sSelect+= "ORDER BY "+sSortCol+" "+sSortDir+sLimit;
			
			ps = oc_conn.prepareStatement(sSelect);
			
			// set questionmark values
			int questionMarkIdx = 1;
			if(sFindProductName.length() > 0)      ps.setString(questionMarkIdx++,"%"+sFindProductName.toLowerCase()+"%");
			if(sFindUnit.length() > 0)             ps.setString(questionMarkIdx++,sFindUnit);
			if(sFindUnitPriceMin.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMin));
			if(sFindUnitPriceMax.length() > 0)     ps.setDouble(questionMarkIdx++,Double.parseDouble(sFindUnitPriceMax));
			if(sFindPackageUnits.length() > 0)     ps.setInt(questionMarkIdx++,Integer.parseInt(sFindPackageUnits));
			if(sFindMinOrderPackages.length() > 0) ps.setInt(questionMarkIdx++,Integer.parseInt(sFindMinOrderPackages));
			if(sFindProductGroup.length() > 0)     ps.setString(questionMarkIdx++,sFindProductGroup);
			if(sFindProductSubGroup.length() > 0)  ps.setString(questionMarkIdx++,sFindProductSubGroup+"%");
			
		    // execute
		    rs = ps.executeQuery();
		
		    while(rs.next()){
		        foundObjects.add(get(rs.getString("OC_PRODUCT_SERVERID")+"."+rs.getString("OC_PRODUCT_OBJECTID")));
		    }
		}
		catch(Exception e){
		    e.printStackTrace();
		}
		finally{
		    try{
		        if(rs!=null) rs.close();
		        if(ps!=null) ps.close();
		        oc_conn.close();
		    }
		    catch(SQLException se){
		        se.printStackTrace();
		    }
		}
		
		return foundObjects;
	}
    
    public String getAccessibleStockLevels(){
    	int centrallevel=0;
    	int distributionlevel=0;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	//First look for distributionlevel
        	String sql = "select a.oc_stock_serverid,a.oc_stock_objectid "+
                    " from oc_productstocks a,oc_servicestocks b"+
                    " where b.oc_stock_objectid=replace(a.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
                    " and not a.oc_stock_servicestockuid=? "+
                    " and (b.oc_stock_hidden is null or oc_stock_hidden<>1)"+
                    " and a.oc_stock_productuid = ?";
        	PreparedStatement ps = oc_conn.prepareStatement(sql);
        	ps.setString(1, MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode","0.0"));
        	ps.setString(2, this.getUid());
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		ProductStock stock=ProductStock.get(rs.getInt("oc_stock_serverid")+"."+rs.getInt("oc_stock_objectid"));
        		distributionlevel+=stock.getAvailableLevel();
        	}
        	rs.close();
        	ps.close();
        	//Look for centrallevel
        	sql = "select oc_stock_serverid,oc_stock_objectid "+
                    " from oc_productstocks"+
                    " where oc_stock_servicestockuid=? "+
                    " and oc_stock_productuid = ?";
        	ps = oc_conn.prepareStatement(sql);
        	ps.setString(1, MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode","0.0"));
        	ps.setString(2, this.getUid());
        	rs = ps.executeQuery();
        	while(rs.next()){
        		ProductStock stock=ProductStock.get(rs.getInt("oc_stock_serverid")+"."+rs.getInt("oc_stock_objectid"));
        		centrallevel+=stock.getAvailableLevel();
        	}
        	rs.close();
        	ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
    	return distributionlevel+"/"+centrallevel;
    }
    
    public int getAccessibleStockLevel(String serviceStockUid){
    	int distributionlevel=0;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	//First look for distributionlevel
        	String sql = "select oc_stock_serverid,oc_stock_objectid "+
                    " from oc_productstocks"+
                    " where oc_stock_servicestockuid=? "+
                    " and oc_stock_productuid = ?";
        	PreparedStatement ps = oc_conn.prepareStatement(sql);
        	ps.setString(1, serviceStockUid);
        	ps.setString(2, this.getUid());
        	ResultSet rs = ps.executeQuery();
        	while(rs.next()){
        		ProductStock stock=ProductStock.get(rs.getInt("oc_stock_serverid")+"."+rs.getInt("oc_stock_objectid"));
        		distributionlevel+=stock.getAvailableLevel();
        	}
        	rs.close();
        	ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
    	return distributionlevel;
    }
    
    //--- IS IN STOCK -----------------------------------------------------------------------------
    public static boolean isInStock(String sProductUID, String sServiceUID){
    	boolean isInStock = false;
    	
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(sServiceUID!=null && sServiceUID.length()>0){
            	// controleren we of het product in de dienststock bestaat
                String sQuery = "select oc_stock_level"+
                                " from oc_productstocks a,oc_servicestocks b"+
                                "  where b.oc_stock_objectid=replace(a.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
                                "   and a.oc_stock_productuid = ?"+
                                "   and b.oc_stock_serviceuid = ?";
                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                ps.setString(1,sProductUID);
                ps.setString(2,sServiceUID);
                ResultSet rs = ps.executeQuery();
                while(rs.next() && !isInStock){
                	isInStock=rs.getInt("oc_stock_level")>0;
                }
                rs.close();
                ps.close();
            }
            if(!isInStock){
                //Het product bestaat niet in de dienststock, dus testen we de centrale stock
                String sQuery = "select oc_stock_level"+
                                " from oc_productstocks a, oc_servicestocks b"+
                                "  where b.oc_stock_objectid = replace(a.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
                                "   and a.oc_stock_productuid = ?"+
                                "   and b.oc_stock_serviceuid = ?";
                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                ps.setString(1,sProductUID);
                ps.setString(2,MedwanQuery.getInstance().getConfigString("centralPharmacyCode","PHA.PHA"));
                ResultSet rs = ps.executeQuery();
                while(rs.next() && !isInStock){
                	isInStock = (rs.getInt("oc_stock_level") > 0);
                }
                rs.close();
                ps.close();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return isInStock;
    }

    //--- IS IN SERVICE STOCK ---------------------------------------------------------------------
    public static boolean isInServiceStock(String sProductUID, String sServiceUID){
    	boolean isInStock = false;
    	
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(sServiceUID!=null && sServiceUID.length() > 0){
            	// controleren we of het product in de dienststock bestaat
                String sQuery = "select oc_stock_level"+
                                " from oc_productstocks"+
                		        "  where oc_stock_productuid = ?"+
                                "   and oc_stock_servicestockuid = ?";
                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                ps.setString(1,sProductUID);
                ps.setString(2,sServiceUID);
                ResultSet rs = ps.executeQuery();
                while(rs.next() && !isInStock){
                	isInStock = (rs.getInt("oc_stock_level") > 0);
                }
                rs.close();
                ps.close();
            }
            
            if(!isInStock){
                // product bestaat niet in de dienststock, dus testen we de centrale stock
                String sQuery = "select oc_stock_level"+
                                " from oc_productstocks"+
                                "  where oc_stock_productuid = ?"+
                                "   and oc_stock_servicestockuid = ?";
                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                ps.setString(1,sProductUID);
                ps.setString(2,MedwanQuery.getInstance().getConfigString("centralStockCode","0.0"));
                ResultSet rs = ps.executeQuery();
                while(rs.next() && !isInStock){
                	isInStock = (rs.getInt("oc_stock_level") > 0);
                }
                rs.close();
                ps.close();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return isInStock;
    }

    //--- QUANTITY AVAILABLE ----------------------------------------------------------------------
    public static int quantityAvailable(String sProductUID, String sServiceStockUID){
        int quantity = 0;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(sServiceStockUID!=null && sServiceStockUID.length()>0){
                // controleren we of het product in de dienststock bestaat
                String sQuery = "select sum(oc_stock_level) total"+
                                " from oc_productstocks"+
                                " where oc_stock_servicestockuid=?"+
                                "  and oc_stock_productuid=?";
                PreparedStatement ps = oc_conn.prepareStatement(sQuery);
                ps.setString(1,sServiceStockUID);
                ps.setString(2,sProductUID);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    quantity = rs.getInt("total");
                }
                rs.close();
                ps.close();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return quantity;
    }

    public static Vector getProductsByDhis2code(String code) {
    	Vector products = new Vector();
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery = "select * from oc_products where oc_product_dhis2code=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setString(1,code);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                products.add(get(rs.getInt("OC_PRODUCT_SERVERID")+"."+rs.getInt("OC_PRODUCT_OBJECTID")));
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
    	return products;
    }
    //--- QUANTITY AVAILABLE ----------------------------------------------------------------------
    public int getTotalQuantityAvailable(){
        int quantity = 0;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery = "select sum(oc_stock_level) total"+
                            " from oc_productstocks"+
                            " where oc_stock_productuid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setString(1,getUid());
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                quantity = rs.getInt("total");
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return quantity;
    }
    
    public static Hashtable getTotalQuantitiesAvailable(java.util.Date date) {
    	Hashtable quantities = new Hashtable();
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "select sum(level) level, oc_stock_productuid from ("+
   				 	" SELECT -sum(OC_OPERATION_UNITSCHANGED) level,oc_stock_productuid"+
                    " FROM OC_PRODUCTSTOCKOPERATIONS,OC_PRODUCTSTOCKS"+
                    " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationreceipt.%'" +
                    " and OC_STOCK_OBJECTID=replace(OC_OPERATION_PRODUCTSTOCKUID,'1.','')"+
                    " AND OC_OPERATION_DATE >= ? group by oc_stock_productuid"+
                    " UNION"+
                    " SELECT sum(OC_OPERATION_UNITSCHANGED) level,oc_stock_productuid"+
                    " FROM OC_PRODUCTSTOCKOPERATIONS,OC_PRODUCTSTOCKS"+
                    " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationdelivery.%'" +
                    " and OC_STOCK_OBJECTID=replace(OC_OPERATION_PRODUCTSTOCKUID,'1.','')"+
                    " AND OC_OPERATION_DATE >= ? group by oc_stock_productuid"+
                    " UNION"+
                    " select sum(oc_stock_level) level,oc_stock_productuid from oc_productstocks group by oc_stock_productuid) z"+
                    " group by oc_stock_productuid";
            PreparedStatement ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1,new java.sql.Timestamp(date.getTime()));
            ps.setTimestamp(2,new java.sql.Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
		   		quantities.put(rs.getString("oc_stock_productuid"), rs.getDouble("level"));
            }
            rs.close();
            ps.close();
            oc_conn.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        return quantities;
    }
    
    //--- QUANTITY AVAILABLE ----------------------------------------------------------------------
    public int getTotalQuantityAvailable(java.util.Date date){
        int quantity = getTotalQuantityAvailable();
        //Now substract all operations up to date (in the past)
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT SUM(level) level from ("+
   				 " SELECT sum(OC_OPERATION_UNITSCHANGED) level"+
                    "  FROM OC_PRODUCTSTOCKOPERATIONS,OC_PRODUCTSTOCKS"+
                    " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationreceipt.%'" +
                    " and OC_STOCK_OBJECTID=replace(OC_OPERATION_PRODUCTSTOCKUID,'1.','')"+
                    " and OC_STOCK_PRODUCTUID='"+getUid()+"'"+
                    " AND OC_OPERATION_DATE >= ?"+
                    " UNION"+
                    " SELECT -sum(OC_OPERATION_UNITSCHANGED) level"+
                    "  FROM OC_PRODUCTSTOCKOPERATIONS,OC_PRODUCTSTOCKS"+
                    " WHERE OC_OPERATION_DESCRIPTION LIKE 'medicationdelivery.%'" +
                    " and OC_STOCK_OBJECTID=replace(OC_OPERATION_PRODUCTSTOCKUID,'1.','')"+
                    " and OC_STOCK_PRODUCTUID='"+getUid()+"'"+
                    " AND OC_OPERATION_DATE >= ?) z";

            PreparedStatement ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1,new java.sql.Timestamp(date.getTime()));
            ps.setTimestamp(2,new java.sql.Timestamp(date.getTime()));
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
		   		quantity=quantity-rs.getInt("level");
            }
            rs.close();
            ps.close();
            oc_conn.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        
        return quantity;
    }

    public boolean isInStock(String sServiceUID){
        return Product.isInStock(getUid(),sServiceUID);
    }

    public boolean isInServiceStock(String sServiceUID){
        return Product.isInServiceStock(getUid(),sServiceUID);
    }

    public int quantityAvailable(String sServiceUID){
        return Product.quantityAvailable(getUid(),sServiceUID);
    }

    public double getLastPurchasePrice(){
    	return getLastPurchasePrice(new java.util.Date());
    }

    public double getLastPurchasePrice(java.util.Date date){
    	double price = 0;
		//Try to find the latest purchase price for this product
		String purchaseData = Pointer.getLastPointer("drugprice."+this.getUid()+".",date);
		if(purchaseData.length()>0 && purchaseData.split(";").length>1){
			try{
				price = Double.parseDouble(purchaseData.split(";")[1]);
			}
			catch(Exception e){}
		}
    	return price;
    }

    //--- COMPARE TO ------------------------------------------------------------------------------
    public int compareTo(Object obj){
        Product otherProduct = (Product)obj;
        return this.name.compareTo(otherProduct.name);
    }

}
