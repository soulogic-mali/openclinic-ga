package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;
import be.openclinic.common.ObjectReference;
import be.openclinic.system.SH;

public class Batch extends OC_Object{
	private String productStockUid;
	private String batchNumber;
	int level;
	Date end;
	String comment;
	String type;
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getBatchNumber() {
		return batchNumber;
	}
	public void setBatchNumber(String batchNumber) {
		this.batchNumber = batchNumber;
	}
	public String getProductStockUid() {
		return productStockUid;
	}
	public void setProductStockUid(String productStockUid) {
		this.productStockUid = productStockUid;
	}
	public int getLevel() {
		return level;
	}
	public void setLevel(int level) {
		this.level = level;
	}
	public Date getEnd() {
		return end;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
    //--- GET -------------------------------------------------------------------------------------
    public static Batch get(String batchUid){
        Batch batch = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	if(batchUid!=null && batchUid.split("\\.").length>1){
	        	String sSelect = "SELECT * FROM OC_BATCHES"+
	                             " WHERE OC_BATCH_SERVERID = ? AND OC_BATCH_OBJECTID = ?";
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setInt(1,Integer.parseInt(batchUid.split("\\.")[0]));
	            ps.setInt(2,Integer.parseInt(batchUid.split("\\.")[1]));
	            rs = ps.executeQuery();
	
	            // get data from DB
	            if(rs.next()){
	            	batch = new Batch();
	                batch.setUid(batchUid);
	
	                batch.setProductStockUid(rs.getString("OC_BATCH_PRODUCTSTOCKUID"));
	                batch.setBatchNumber(rs.getString("OC_BATCH_NUMBER"));
	                batch.setLevel(rs.getInt("OC_BATCH_LEVEL"));
	                batch.setComment(rs.getString("OC_BATCH_COMMENT"));
	                batch.setEnd(rs.getDate("OC_BATCH_END"));
	                batch.setType(rs.getString("OC_BATCH_TYPE"));
	
	                // OBJECT variables
	                batch.setCreateDateTime(rs.getTimestamp("OC_BATCH_CREATETIME"));
	                batch.setUpdateDateTime(rs.getTimestamp("OC_BATCH_UPDATETIME"));
	                batch.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_BATCH_UPDATEUID")));
	            }
	            else{
	                throw new Exception("ERROR : GET BATCH "+batchUid+" NOT FOUND");
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
        return batch;
    }

    //--- GET -------------------------------------------------------------------------------------
    public static Batch getByBatchNumber(String productStockUid,String batchNumber){
        Batch batch = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_BATCHES"+
                             " WHERE OC_BATCH_PRODUCTSTOCKUID=? AND OC_BATCH_NUMBER = ? ";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,productStockUid);
            ps.setString(2,batchNumber);
            rs = ps.executeQuery();

            // get data from DB
            if(rs.next()){
            	batch = new Batch();
                batch.setUid(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID"));

                batch.setProductStockUid(rs.getString("OC_BATCH_PRODUCTSTOCKUID"));
                batch.setBatchNumber(rs.getString("OC_BATCH_NUMBER"));
                batch.setLevel(rs.getInt("OC_BATCH_LEVEL"));
                batch.setComment(rs.getString("OC_BATCH_COMMENT"));
                batch.setEnd(rs.getDate("OC_BATCH_END"));
                batch.setType(rs.getString("OC_BATCH_TYPE"));

                // OBJECT variables
                batch.setCreateDateTime(rs.getTimestamp("OC_BATCH_CREATETIME"));
                batch.setUpdateDateTime(rs.getTimestamp("OC_BATCH_UPDATETIME"));
                batch.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_BATCH_UPDATEUID")));
            }
            else{
                throw new Exception("ERROR : GET BATCH BY NUMBER "+batchNumber+" NOT FOUND");
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
        return batch;
    }

    public static Vector getByBatchNumber(String batchNumber){
    	Vector batches = new Vector();
        Batch batch = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_BATCHES"+
                             " WHERE OC_BATCH_NUMBER = ? ";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,batchNumber);
            rs = ps.executeQuery();

            // get data from DB
            while(rs.next()){
            	batch = new Batch();
                batch.setUid(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID"));

                batch.setProductStockUid(rs.getString("OC_BATCH_PRODUCTSTOCKUID"));
                batch.setBatchNumber(rs.getString("OC_BATCH_NUMBER"));
                batch.setLevel(rs.getInt("OC_BATCH_LEVEL"));
                batch.setComment(rs.getString("OC_BATCH_COMMENT"));
                batch.setEnd(rs.getDate("OC_BATCH_END"));
                batch.setType(rs.getString("OC_BATCH_TYPE"));

                // OBJECT variables
                batch.setCreateDateTime(rs.getTimestamp("OC_BATCH_CREATETIME"));
                batch.setUpdateDateTime(rs.getTimestamp("OC_BATCH_UPDATETIME"));
                batch.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_BATCH_UPDATEUID")));
                batches.add(batch);
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
        return batches;
    }

    //--- STORE -----------------------------------------------------------------------------------
    public void store(){
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(this.getUid().equals("-1")){
                //***** INSERT *****

                sSelect = "INSERT INTO OC_BATCHES (OC_BATCH_SERVERID, OC_BATCH_OBJECTID,"+
                          "  OC_BATCH_PRODUCTSTOCKUID, OC_BATCH_NUMBER, OC_BATCH_LEVEL,"+
                          "  OC_BATCH_END, OC_BATCH_COMMENT, OC_BATCH_CREATETIME,"+
                          "  OC_BATCH_UPDATETIME, OC_BATCH_UPDATEUID,OC_BATCH_TYPE)"+
                          " VALUES(?,?,?,?,?,?,?,?,?,?,?)";

                ps = oc_conn.prepareStatement(sSelect);

                // set new uid
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId");
                int orderCounter = MedwanQuery.getInstance().getOpenclinicCounter("OC_BATCHES");
                ps.setInt(1,serverId);
                ps.setInt(2,orderCounter);
                this.setUid(serverId+"."+orderCounter);

                ps.setString(3,this.getProductStockUid());
                ps.setString(4,this.getBatchNumber());
                ps.setInt(5,this.getLevel());
                ps.setDate(6,this.getEnd()==null?null:new java.sql.Date(this.getEnd().getTime())); 
                ps.setString(7,this.getComment());

                // OBJECT variables
                ps.setTimestamp(8,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setTimestamp(9,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(10,this.getUpdateUser());
                ps.setString(11,this.getType());

                ps.executeUpdate();
            }
            else{
                //***** UPDATE *****

                sSelect = "UPDATE OC_BATCHES SET "+
                          "  OC_BATCH_PRODUCTSTOCKUID=?, OC_BATCH_NUMBER=?, OC_BATCH_LEVEL=?,"+
                          "  OC_BATCH_END=?, OC_BATCH_COMMENT=?,"+
                          "  OC_BATCH_UPDATETIME=?, OC_BATCH_UPDATEUID=?, OC_BATCH_TYPE=?"+
                          " WHERE OC_BATCH_SERVERID=? AND OC_BATCH_OBJECTID=?";

                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1,this.getProductStockUid());
                ps.setString(2,this.getBatchNumber());
                ps.setInt(3,this.getLevel());
                ps.setDate(4,this.getEnd()==null?null:new java.sql.Date(this.getEnd().getTime())); 
                ps.setString(5,this.getComment());

                // OBJECT variables
                ps.setTimestamp(6,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(7,this.getUpdateUser());
                ps.setString(8,this.getType());

                ps.setInt(9,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
                ps.setInt(10,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));

                ps.executeUpdate();
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
    }
    
    public static void updateBatchLevel(String batchUid, int n){
    	Batch batch = get(batchUid);
    	if(batch!=null){
    		batch.setLevel(batch.getLevel()+n);
    		batch.store();
    	}
    }
    
    public static void calculateBatchLevel(String batchuid){
        int in=0,out=0;
    	PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	sSelect="select sum(oc_batchoperation_quantity) total from oc_batchoperations where oc_batchoperation_destinationuid=?";
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, batchuid);
        	rs=ps.executeQuery();
        	if(rs.next()){
        		in=rs.getInt("total");
        	}
        	rs.close();
        	ps.close();
        	sSelect="select sum(oc_batchoperation_quantity) total from oc_batchoperations where oc_batchoperation_sourceuid=?";
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, batchuid);
        	rs=ps.executeQuery();
        	if(rs.next()){
        		out=rs.getInt("total");
        	}
        	rs.close();
        	ps.close();
        	Batch batch = get(batchuid);
        	if(batch!=null){
        		batch.setLevel(in-out);
        		batch.store();
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
    }
    
    public int getLevel(java.util.Date date){
        int in=0,out=0;
    	PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	sSelect="select sum(oc_batchoperation_quantity) total from oc_batchoperations where oc_batchoperation_destinationuid=? and oc_batchoperation_updatetime<=?";
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, getUid());
        	ps.setTimestamp(2, SH.getSQLTimestamp(date));
        	rs=ps.executeQuery();
        	if(rs.next()){
        		in=rs.getInt("total");
        	}
        	rs.close();
        	ps.close();
        	sSelect="select sum(oc_batchoperation_quantity) total from oc_batchoperations where oc_batchoperation_sourceuid=? and oc_batchoperation_updatetime<=?";
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, getUid());
        	ps.setTimestamp(2, SH.getSQLTimestamp(date));
        	rs=ps.executeQuery();
        	if(rs.next()){
        		out=rs.getInt("total");
        	}
        	rs.close();
        	ps.close();
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
        Debug.println(in-out);
        return in-out;
    }
    
    public static boolean exists(String productStockUid, String batchNumber){
    	return getByBatchNumber(productStockUid, batchNumber)!=null;
    }
    
    public static String copyBatch(String batchUid, String destinationProductStockUid){
    	Batch sourceBatch = Batch.get(batchUid);
    	if(sourceBatch!=null){
	    	Batch destinationBatch = Batch.getByBatchNumber(destinationProductStockUid, sourceBatch.getBatchNumber());
	    	if(destinationBatch==null){
	    		destinationBatch=sourceBatch;
	    		destinationBatch.setUid("-1");
	    		destinationBatch.setProductStockUid(destinationProductStockUid);
	    		destinationBatch.setLevel(0);
	    		destinationBatch.store();
	    	}
	    	return destinationBatch.getUid();
    	}
    	else {
    		return null;
    	}
    }
    
    public static Vector getBatches(String productStockUid){
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES WHERE OC_BATCH_PRODUCTSTOCKUID=? and OC_BATCH_LEVEL>0 order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,productStockUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(Batch.get(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID")));
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
        return batches;
    }
    
    public static Vector getActiveBatches(String productStockUid){
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES WHERE OC_BATCH_PRODUCTSTOCKUID=? and (OC_BATCH_END is null or OC_BATCH_END>=?) and OC_BATCH_LEVEL>0 order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,productStockUid);
            ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(Batch.get(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID")));
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
        return batches;
    }
    
    public static Vector getActiveExpiringBatches(java.util.Date begin, java.util.Date end, String servicestockuids){
    	String uids="' '";
    	String[] s = servicestockuids.split(";");
    	for(int n=0;n<s.length;n++) {
    		uids+=",'"+s[n]+"'";
    	}
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES,oc_productstocks WHERE OC_STOCK_OBJECTID=replace(OC_BATCH_PRODUCTSTOCKUID,'1.','') and oc_stock_servicestockuid in ("+uids+") and OC_BATCH_END>=? and OC_BATCH_END<? and OC_BATCH_LEVEL>0 order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1, new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(rs.getString("oc_batch_serverid")+"."+rs.getString("oc_batch_objectid")+";"+rs.getString("oc_stock_productuid")+";"+ScreenHelper.formatDate(rs.getDate("OC_BATCH_END"))+";"+rs.getString("OC_BATCH_NUMBER")+";"+rs.getString("OC_BATCH_LEVEL"));
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
        return batches;
    }
    
    public static Vector getActiveExpiringBatches(java.util.Date begin, java.util.Date end){
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES,oc_productstocks WHERE OC_STOCK_OBJECTID=replace(OC_BATCH_PRODUCTSTOCKUID,'1.','') and OC_BATCH_END>=? and OC_BATCH_END<? and OC_BATCH_LEVEL>0 order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1, new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(rs.getString("oc_batch_serverid")+"."+rs.getString("oc_batch_objectid")+";"+rs.getString("oc_stock_productuid")+";"+ScreenHelper.formatDate(rs.getDate("OC_BATCH_END"))+";"+rs.getString("OC_BATCH_NUMBER")+";"+rs.getString("OC_BATCH_LEVEL"));
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
        return batches;
    }
    
    public static Vector getActiveExpiringBatches(String productUid, java.util.Date begin, java.util.Date end){
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES,oc_productstocks WHERE OC_STOCK_OBJECTID=replace(OC_BATCH_PRODUCTSTOCKUID,'1.','') and oc_stock_productuid=? and OC_BATCH_END>=? and OC_BATCH_END<? and OC_BATCH_LEVEL>0 order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, productUid);
            ps.setTimestamp(2, new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(3, new java.sql.Timestamp(end.getTime()));
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(rs.getString("oc_batch_serverid")+"."+rs.getString("oc_batch_objectid")+";"+rs.getString("oc_stock_productuid")+";"+ScreenHelper.formatDate(rs.getDate("OC_BATCH_END"))+";"+rs.getString("OC_BATCH_NUMBER")+";"+rs.getString("OC_BATCH_LEVEL"));
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
        return batches;
    }
    
    public static Vector getAllBatches(String productStockUid){
    	Vector batches = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
        	sSelect="SELECT * FROM OC_BATCHES WHERE OC_BATCH_PRODUCTSTOCKUID=? order by OC_BATCH_END";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,productStockUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	batches.add(Batch.get(rs.getString("OC_BATCH_SERVERID")+"."+rs.getString("OC_BATCH_OBJECTID")));
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
        return batches;
    }

    public static Vector getProductStockOperations(String batchUid){
    	Vector operations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
        	sSelect="SELECT * FROM OC_PRODUCTSTOCKOPERATIONS WHERE OC_OPERATION_BATCHUID=? order by OC_OPERATION_UPDATETIME DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,batchUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	operations.add(ProductStockOperation.get(rs.getString("OC_OPERATION_SERVERID")+"."+rs.getString("OC_OPERATION_OBJECTID")));
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
    	return operations;
    }

    public static Vector getProductStockOperations(String batchUid, String productStockUid){
    	Vector operations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
        	sSelect="SELECT * FROM OC_PRODUCTSTOCKOPERATIONS WHERE OC_OPERATION_BATCHUID=? AND (OC_OPERATION_PRODUCTSTOCKUID=? OR (OC_OPERATION_SRCDESTTYPE='servicestock' and OC_OPERATION_SRCDESTUID=?)) order by OC_OPERATION_UPDATETIME DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,batchUid);
            ps.setString(2,productStockUid);
            ps.setString(3,productStockUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	operations.add(ProductStockOperation.get(rs.getString("OC_OPERATION_SERVERID")+"."+rs.getString("OC_OPERATION_OBJECTID")));
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
    	return operations;
    }
    
    public static Vector getBatchOperations(String batchUid, String sLanguage){
    	Vector operations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
        	sSelect="SELECT * FROM OC_BATCHOPERATIONS WHERE OC_BATCHOPERATION_SOURCEUID=? OR OC_BATCHOPERATION_DESTINATIONUID=? ORDER BY OC_BATCHOPERATION_UPDATETIME DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,batchUid);
            ps.setString(2,batchUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	BatchOperation batchOperation = null;
            	java.util.Date date = rs.getTimestamp("OC_BATCHOPERATION_UPDATETIME");
            	String thirdParty="?";
        		String souid=rs.getString("OC_BATCHOPERATION_PRODUCTSTOCKOPERATIONUID");
            	if(rs.getString("OC_BATCHOPERATION_SOURCEUID").equalsIgnoreCase(batchUid)){
            		ProductStockOperation operation = ProductStockOperation.get(souid);
            		if(operation!=null){
            			if(operation.getDescription().indexOf("receipt")>-1){
            				thirdParty=operation.getProductStock().getServiceStock().getService().getLabel(sLanguage);
            			}
            			else {
            				if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
            					ServiceStock serviceStock = ServiceStock.get(operation.getSourceDestination().getObjectUid());
            					if(serviceStock!=null){
            						thirdParty=serviceStock.getService().getLabel(sLanguage);
            					}
            				}
            				else {
            					thirdParty=operation.getSourceDestination().getObjectUid();
            				}
            			}
            		}
            		batchOperation = new BatchOperation("delivery", thirdParty, rs.getInt("OC_BATCHOPERATION_QUANTITY"),date,souid);
            	}
            	else {
            		ProductStockOperation operation = ProductStockOperation.get(rs.getString("OC_BATCHOPERATION_PRODUCTSTOCKOPERATIONUID"));
            		if(operation!=null){
            			if(operation.getDescription().indexOf("receipt")>-1){
            				if(operation.getProductStock()!=null && operation.getProductStock().getServiceStock()!=null && operation.getProductStock().getServiceStock().getService()!=null){
            					thirdParty=operation.getProductStock().getServiceStock().getService().getLabel(sLanguage);
            				}
            			}
            			else {
            				if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
            					ServiceStock serviceStock = ServiceStock.get(operation.getSourceDestination().getObjectUid());
            					if(serviceStock!=null){
            						thirdParty=serviceStock.getService().getLabel(sLanguage);
            					}
            				}
            				else {
            					thirdParty=operation.getSourceDestination().getObjectUid();
            				}
            			}
            		}
            		batchOperation = new BatchOperation("receipt", thirdParty, rs.getInt("OC_BATCHOPERATION_QUANTITY"),date,souid);
            	}
            	operations.add(batchOperation);
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
    	return operations;
    }
    
    public static Vector getBatchOperations(String batchUid, String productStockUid, String sLanguage){
    	Vector operations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
        	sSelect="SELECT * FROM OC_BATCHOPERATIONS,OC_PRODUCTSTOCKOPERATIONS WHERE OC_OPERATION_OBJECTID=replace(OC_BATCHOPERATION_PRODUCTSTOCKOPERATIONUID,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and OC_OPERATION_PRODUCTSTOCKUID=? and (OC_BATCHOPERATION_SOURCEUID=? OR OC_BATCHOPERATION_DESTINATIONUID=?) ORDER BY OC_BATCHOPERATION_UPDATETIME DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,productStockUid);
            ps.setString(2,batchUid);
            ps.setString(3,batchUid);
            rs=ps.executeQuery();
            while(rs.next()){
            	BatchOperation batchOperation = null;
            	java.util.Date date = rs.getTimestamp("OC_BATCHOPERATION_UPDATETIME");
            	String thirdParty="?";
        		String souid=rs.getString("OC_BATCHOPERATION_PRODUCTSTOCKOPERATIONUID");
            	if(rs.getString("OC_BATCHOPERATION_SOURCEUID").equalsIgnoreCase(batchUid)){
            		ProductStockOperation operation = ProductStockOperation.get(souid);
            		if(operation!=null){
            			if(operation.getDescription().indexOf("receipt")>-1){
            				thirdParty=operation.getProductStock().getServiceStock().getService().getLabel(sLanguage);
            			}
            			else {
            				if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
            					ServiceStock serviceStock = ServiceStock.get(operation.getSourceDestination().getObjectUid());
            					if(serviceStock!=null){
            						thirdParty=serviceStock.getService().getLabel(sLanguage);
            					}
            				}
            				else {
            					thirdParty=operation.getSourceDestination().getObjectUid();
            				}
            			}
            		}
            		batchOperation = new BatchOperation("delivery", thirdParty, rs.getInt("OC_BATCHOPERATION_QUANTITY"),date,souid);
            	}
            	else {
            		ProductStockOperation operation = ProductStockOperation.get(rs.getString("OC_BATCHOPERATION_PRODUCTSTOCKOPERATIONUID"));
            		if(operation!=null){
            			if(operation.getDescription().indexOf("receipt")>-1){
            				if(operation.getProductStock()!=null && operation.getProductStock().getServiceStock()!=null && operation.getProductStock().getServiceStock().getService()!=null){
            					thirdParty=operation.getProductStock().getServiceStock().getService().getLabel(sLanguage);
            				}
            			}
            			else {
            				if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
            					ServiceStock serviceStock = ServiceStock.get(operation.getSourceDestination().getObjectUid());
            					if(serviceStock!=null){
            						thirdParty=serviceStock.getService().getLabel(sLanguage);
            					}
            				}
            				else {
            					thirdParty=operation.getSourceDestination().getObjectUid();
            				}
            			}
            		}
            		batchOperation = new BatchOperation("receipt", thirdParty, rs.getInt("OC_BATCHOPERATION_QUANTITY"),date,souid);
            	}
            	operations.add(batchOperation);
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
    	return operations;
    }

}

