package be.openclinic.assets;

import be.openclinic.common.OC_Object;
import be.openclinic.util.Nomenclature;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.StringReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;


public class MaintenanceOperation extends OC_Object {
    public int serverId;
    public int objectId;    

    public String maintenanceplanUID;
    public java.util.Date date;
    public String operator; // 255
    public String supplier; // 255
	public String result; // 50
    public String comment; // 255
    public String comment1; // 255
    public String comment2; // 255
    public String comment3; // 255
    public String comment4; // 255
    public String comment5; // 255
    public int lockedBy;
    
    public int getLockedBy() {
		return lockedBy;
	}

	public void setLockedBy(int lockedBy) {
		this.lockedBy = lockedBy;
	}

    public static void updateMaintenanceoperation(Element eOperation) throws Exception{
    	int serverid = Integer.parseInt(eOperation.attributeValue("serverid"));
    	int objectid = Integer.parseInt(eOperation.attributeValue("objectid"));
    	java.util.Date updatetime = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(eOperation.element("updatetime").getTextTrim());
    	//First we check if this maintenanceplan record has been changed
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_serverid=? and oc_maintenanceoperation_objectid=? and oc_maintenanceoperation_updatetime=?");
		ps.setInt(1, serverid);
		ps.setInt(2, objectid);
		ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
		ResultSet rs =ps.executeQuery();
		if(!rs.next()){
			//The record has changed. Let's update it
    		rs.close();
    		ps.close();
			ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_serverid=? and oc_maintenanceoperation_objectid=?");
    		ps.setInt(1, serverid);
    		ps.setInt(2, objectid);
    		rs =ps.executeQuery();
    		if(!rs.next()){
    			//The record does not exist yet, create it
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("insert into oc_maintenanceoperations(oc_maintenanceoperation_serverid,oc_maintenanceoperation_objectid) values(?,?)");
        		ps.setInt(1, serverid);
        		ps.setInt(2, objectid);
    			ps.execute();
    		}
			MaintenanceOperation operation = new MaintenanceOperation();
			operation.setUid(serverid+"."+objectid);
			operation.setServerId(serverid);
			operation.setObjectId(objectid);
			operation.setComment1(eOperation.element("comment1")==null?"":eOperation.element("comment1").getText());
			operation.setComment2(eOperation.element("comment2")==null?"":eOperation.element("comment2").getText());
			operation.setComment3(eOperation.element("comment3")==null?"":eOperation.element("comment3").getText());
			operation.setComment4(eOperation.element("comment4")==null?"":eOperation.element("comment4").getText());
			operation.setComment5(eOperation.element("comment5")==null?"":eOperation.element("comment5").getText());
			operation.setDate(eOperation.element("date")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eOperation.element("date").getText()));
			operation.setLockedBy(Integer.parseInt(eOperation.element("lockedby")==null?"0":eOperation.element("lockedby").getText()));
			operation.setMaintenanceplanUID(eOperation.element("maintenanceplanuid")==null?"":eOperation.element("maintenanceplanuid").getText());
			operation.setNextDate(eOperation.element("nextdate")==null?null:new SimpleDateFormat("yyyyMMddHHmmssSSSS").parse(eOperation.element("nextdate").getText()));
			operation.setOperator(eOperation.element("operator")==null?"":eOperation.element("operator").getText());
			operation.setResult(eOperation.element("result")==null?"":eOperation.element("result").getText());
			operation.setSupplier(eOperation.element("supplier")==null?"":eOperation.element("supplier").getText());
			operation.store(eOperation.element("updateid")==null?"":eOperation.element("updateid").getText());
		}
		rs.close();
		ps.close();
		conn.close();
    }

    public static void addTagString(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
		String s = rs.getString("oc_maintenanceoperation_"+tag);
		if(ScreenHelper.checkString(s).length()>0){
			xml.append("<"+tag+"><![CDATA["+s+"]]></"+tag+">");
		}
    }
    
    public static void addTagDate(StringBuffer xml,String tag,ResultSet rs) throws SQLException{
    	java.util.Date d = rs.getTimestamp("oc_maintenanceoperation_"+tag);
    	if(d!=null){
    		xml.append("<"+tag+">"+new SimpleDateFormat("yyyyMMddHHmmssSSS").format(d)+"</"+tag+">");
    	}
    }
    
    public static StringBuffer toXml(String uid){
    	StringBuffer xml = new StringBuffer();
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try{
    		PreparedStatement ps = conn.prepareStatement("select * from oc_maintenanceoperations where oc_maintenanceoperation_serverid=? and oc_maintenanceoperation_objectid=? and oc_maintenanceoperation_objectid>-1");
    		ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
    		ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()){
    			xml.append("<maintenanceoperation serverid='"+rs.getInt("oc_maintenanceoperation_serverid")+"' objectid='"+rs.getInt("oc_maintenanceoperation_objectid")+"'>");
    			addTagString(xml,"name",rs);
    			addTagString(xml,"maintenanceplanuid",rs);
    			addTagDate(xml,"date",rs);
    			addTagString(xml,"operator",rs);
    			addTagString(xml,"result",rs);
    			addTagString(xml,"comment",rs);
    			addTagDate(xml,"nextdate",rs);
    			addTagDate(xml,"updatetime",rs);
    			addTagString(xml,"updateid",rs);
    			addTagString(xml,"supplier",rs);
    			addTagString(xml,"comment1",rs);
    			addTagString(xml,"comment2",rs);
    			addTagString(xml,"comment3",rs);
    			addTagString(xml,"comment4",rs);
    			addTagString(xml,"comment5",rs);
    			addTagString(xml,"lockedby",rs);
    			xml.append("</maintenanceoperation>");
    		}
    		rs.close();
    		ps.close();
        	conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	return xml;
    }
    
    public String getComment1() {
		return comment1;
	}

	public void setComment1(String comment1) {
		this.comment1 = comment1;
	}

	public String getComment2() {
		return comment2;
	}

	public void setComment2(String comment2) {
		this.comment2 = comment2;
	}

	public String getComment3() {
		return comment3;
	}

	public void setComment3(String comment3) {
		this.comment3 = comment3;
	}

	public String getComment4() {
		return comment4;
	}

	public void setComment4(String comment4) {
		this.comment4 = comment4;
	}

	public String getComment5() {
		return comment5;
	}

	public void setComment5(String comment5) {
		this.comment5 = comment5;
	}

	public java.util.Date nextDate;
    
    // extra search-criteria
    public java.util.Date periodPerformedBegin;
    public java.util.Date periodPerformedEnd;
    
    
    public String getSupplier() {
		return supplier;
	}

	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}

	public int getServerId() {
		return serverId;
	}

	public void setServerId(int serverId) {
		this.serverId = serverId;
	}

	public int getObjectId() {
		return objectId;
	}

	public void setObjectId(int objectId) {
		this.objectId = objectId;
	}

	public String getMaintenanceplanUID() {
		return maintenanceplanUID;
	}

	public void setMaintenanceplanUID(String maintenanceplanUID) {
		this.maintenanceplanUID = maintenanceplanUID;
	}
	
	public MaintenancePlan getMaintenancePlan(){
		MaintenancePlan plan = MaintenancePlan.get(this.maintenanceplanUID);
		if(plan==null){
			plan = new MaintenancePlan();
		}
		return plan;
	}

	public java.util.Date getDate() {
		return date;
	}

	public void setDate(java.util.Date date) {
		this.date = date;
	}

	public String getOperator() {
		return operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public java.util.Date getNextDate() {
		return nextDate;
	}

	public void setNextDate(java.util.Date nextDate) {
		this.nextDate = nextDate;
	}

	public java.util.Date getPeriodPerformedBegin() {
		return periodPerformedBegin;
	}

	public void setPeriodPerformedBegin(java.util.Date periodPerformedBegin) {
		this.periodPerformedBegin = periodPerformedBegin;
	}

	public java.util.Date getPeriodPerformedEnd() {
		return periodPerformedEnd;
	}

	public void setPeriodPerformedEnd(java.util.Date periodPerformedEnd) {
		this.periodPerformedEnd = periodPerformedEnd;
	}

	//--- CONSTRUCTOR ---
    public MaintenanceOperation(){
        serverId = -1;
        objectId = -1;

        maintenanceplanUID = "";
        date = null;
        operator = ""; // 255
        supplier="";
        result = ""; // 50
        comment = ""; // 255
        nextDate = null;
        
        periodPerformedBegin = null;
        periodPerformedEnd = null;
        lockedBy=-1;
    }
        
    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(String userUid){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSql;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                
        try{            
            if(getUid().equals("-1")){            	  
                // insert new operation
                sSql = "INSERT INTO OC_MAINTENANCEOPERATIONS(OC_MAINTENANCEOPERATION_SERVERID,OC_MAINTENANCEOPERATION_OBJECTID,"+
                       "  OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID,OC_MAINTENANCEOPERATION_DATE,OC_MAINTENANCEOPERATION_OPERATOR,"+
                	   "  OC_MAINTENANCEOPERATION_RESULT,OC_MAINTENANCEOPERATION_COMMENT,OC_MAINTENANCEOPERATION_NEXTDATE,OC_MAINTENANCEOPERATION_SUPPLIER,"+
                       "  OC_MAINTENANCEOPERATION_UPDATETIME,OC_MAINTENANCEOPERATION_UPDATEID,OC_MAINTENANCEOPERATION_COMMENT1,OC_MAINTENANCEOPERATION_COMMENT2,"
                       + "OC_MAINTENANCEOPERATION_COMMENT3,OC_MAINTENANCEOPERATION_COMMENT4,OC_MAINTENANCEOPERATION_COMMENT5,OC_MAINTENANCEOPERATION_LOCKEDBY)"+
                       " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; // 10 
                ps = oc_conn.prepareStatement(sSql);
                
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId"),
                    objectId = MedwanQuery.getInstance().getOpenclinicCounter("OC_MAINTENANCEOPERATIONS",-100000);
                this.setUid(serverId+"."+objectId);
                                
                int psIdx = 1;
                ps.setInt(psIdx++,serverId);
                ps.setInt(psIdx++,objectId);
                
                ps.setString(psIdx++,maintenanceplanUID);
                ps.setDate(psIdx++,new java.sql.Date(date.getTime()));
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,result);
                ps.setString(psIdx++,comment);
                
                // nextDate might be unspecified
                if(nextDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(nextDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }
                ps.setString(psIdx++,supplier);
                
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setInt(psIdx++,lockedBy);
                
                ps.executeUpdate();
            } 
            else{
                // update existing record
                sSql = "UPDATE OC_MAINTENANCEOPERATIONS SET"+
                       "  OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID = ?, OC_MAINTENANCEOPERATION_DATE = ?,OC_MAINTENANCEOPERATION_OPERATOR = ?,"+
                	   "  OC_MAINTENANCEOPERATION_RESULT = ?, OC_MAINTENANCEOPERATION_COMMENT = ?, OC_MAINTENANCEOPERATION_NEXTDATE = ?, OC_MAINTENANCEOPERATION_SUPPLIER=?,"+
                       "  OC_MAINTENANCEOPERATION_UPDATETIME = ?, OC_MAINTENANCEOPERATION_UPDATEID = ?, OC_MAINTENANCEOPERATION_COMMENT1=?, OC_MAINTENANCEOPERATION_COMMENT2=?,"
                       + " OC_MAINTENANCEOPERATION_COMMENT3=?, OC_MAINTENANCEOPERATION_COMMENT4=?, OC_MAINTENANCEOPERATION_COMMENT5=?, OC_MAINTENANCEOPERATION_LOCKEDBY=?"+ // update-info
                       " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)"; // identification
                ps = oc_conn.prepareStatement(sSql);

                int psIdx = 1;
                ps.setString(psIdx++,maintenanceplanUID);
                ps.setDate(psIdx++,new java.sql.Date(date.getTime()));
                ps.setString(psIdx++,operator);
                ps.setString(psIdx++,result);
                ps.setString(psIdx++,comment);
                
                // nextDate might be unspecified
                if(nextDate!=null){
                    ps.setDate(psIdx++,new java.sql.Date(nextDate.getTime()));
                }
                else{
                    ps.setDate(psIdx++,null);
                }

                ps.setString(psIdx++,supplier);
                // update-info
                ps.setTimestamp(psIdx++,new Timestamp(new java.util.Date().getTime())); // now
                ps.setString(psIdx++,userUid);
                ps.setString(psIdx++,comment1);
                ps.setString(psIdx++,comment2);
                ps.setString(psIdx++,comment3);
                ps.setString(psIdx++,comment4);
                ps.setString(psIdx++,comment5);
                ps.setInt(psIdx++,lockedBy);
                
                // where
                ps.setInt(psIdx++,Integer.parseInt(getUid().substring(0,getUid().indexOf("."))));
                ps.setInt(psIdx,Integer.parseInt(getUid().substring(getUid().indexOf(".")+1)));
                
                ps.executeUpdate();
            }            
        }
        catch(Exception e){
        	errorOccurred = true;
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    public java.util.Date getNextOperationDate(){
    	java.util.Date date = getDate();
    	if(date==null) {
    		date=new java.util.Date();
    	}
		MaintenancePlan plan = getMaintenancePlan();
		if(plan!=null){
			if(ScreenHelper.checkString(plan.getFrequency()).length()>0){
				String frequency = plan.getFrequency();
				if(frequency.length()>0){
					GregorianCalendar calendar = new GregorianCalendar();
					calendar.setTime(date);
					if(frequency.equalsIgnoreCase("1")){
						//Daily
						calendar.add(GregorianCalendar.HOUR, 24);
					}
					else if(frequency.equalsIgnoreCase("2")){
						//Weekly
						calendar.add(GregorianCalendar.HOUR, 24*7);
					}
					else if(frequency.equalsIgnoreCase("3")){
						//Monthly
						calendar.add(GregorianCalendar.MONTH, 1);
					}
					else if(frequency.equalsIgnoreCase("4")){
						//Quarterly
						calendar.add(GregorianCalendar.MONTH, 3);
					}
					else if(frequency.equalsIgnoreCase("5")){
						//Half-yearly
						calendar.add(GregorianCalendar.MONTH, 6);
					}
					else if(frequency.equalsIgnoreCase("6")){
						//Yearly
						calendar.add(GregorianCalendar.MONTH, 12);
					}
					else{
						return null;
					}
					return calendar.getTime();
				}
			}
			else{
				Nomenclature nomenclature = Nomenclature.get("asset", plan.getAssetNomenclature());
				if(nomenclature!=null){
					String frequency="";
					if(plan.getType().equalsIgnoreCase("1")){
						frequency = nomenclature.getParameter("controlfrequency");
					}
					else if(plan.getType().equalsIgnoreCase("2")){
						frequency = nomenclature.getParameter("maintenancefrequency");
					}
					if(frequency.length()>0){
						GregorianCalendar calendar = new GregorianCalendar();
						calendar.setTime(date);
						if(frequency.equalsIgnoreCase("1")){
							//Daily
							calendar.add(GregorianCalendar.HOUR, 24);
						}
						else if(frequency.equalsIgnoreCase("2")){
							//Weekly
							calendar.add(GregorianCalendar.HOUR, 24*7);
						}
						else if(frequency.equalsIgnoreCase("3")){
							//Monthly
							calendar.add(GregorianCalendar.MONTH, 1);
						}
						else if(frequency.equalsIgnoreCase("4")){
							//Quarterly
							calendar.add(GregorianCalendar.MONTH, 3);
						}
						else if(frequency.equalsIgnoreCase("5")){
							//Half-yearly
							calendar.add(GregorianCalendar.MONTH, 6);
						}
						else if(frequency.equalsIgnoreCase("6")){
							//Yearly
							calendar.add(GregorianCalendar.MONTH, 12);
						}
						else{
							return null;
						}
						return calendar.getTime();
					}
				}
			}
		}
		return null;
	}
    
    public java.util.Date getNextOperationDate(java.util.Date date){
		MaintenancePlan plan = getMaintenancePlan();
		if(plan!=null){
			if(ScreenHelper.checkString(plan.getFrequency()).length()>0){
				String frequency = plan.getFrequency();
				if(frequency.length()>0){
					GregorianCalendar calendar = new GregorianCalendar();
					calendar.setTime(date);
					if(frequency.equalsIgnoreCase("1")){
						//Daily
						calendar.add(GregorianCalendar.HOUR, 24);
					}
					else if(frequency.equalsIgnoreCase("2")){
						//Weekly
						calendar.add(GregorianCalendar.HOUR, 24*7);
					}
					else if(frequency.equalsIgnoreCase("3")){
						//Monthly
						calendar.add(GregorianCalendar.MONTH, 1);
					}
					else if(frequency.equalsIgnoreCase("4")){
						//Quarterly
						calendar.add(GregorianCalendar.MONTH, 3);
					}
					else if(frequency.equalsIgnoreCase("5")){
						//Half-yearly
						calendar.add(GregorianCalendar.MONTH, 6);
					}
					else if(frequency.equalsIgnoreCase("6")){
						//Yearly
						calendar.add(GregorianCalendar.MONTH, 12);
					}
					else{
						return null;
					}
					return calendar.getTime();
				}
			}
			else{
				Nomenclature nomenclature = Nomenclature.get("asset", plan.getAssetNomenclature());
				if(nomenclature!=null){
					String frequency="";
					if(plan.getType().equalsIgnoreCase("1")){
						frequency = nomenclature.getParameter("controlfrequency");
					}
					else if(plan.getType().equalsIgnoreCase("2")){
						frequency = nomenclature.getParameter("maintenancefrequency");
					}
					if(frequency.length()>0){
						GregorianCalendar calendar = new GregorianCalendar();
						calendar.setTime(date);
						if(frequency.equalsIgnoreCase("1")){
							//Daily
							calendar.add(GregorianCalendar.HOUR, 24);
						}
						else if(frequency.equalsIgnoreCase("2")){
							//Weekly
							calendar.add(GregorianCalendar.HOUR, 24*7);
						}
						else if(frequency.equalsIgnoreCase("3")){
							//Monthly
							calendar.add(GregorianCalendar.MONTH, 1);
						}
						else if(frequency.equalsIgnoreCase("4")){
							//Quarterly
							calendar.add(GregorianCalendar.MONTH, 3);
						}
						else if(frequency.equalsIgnoreCase("5")){
							//Half-yearly
							calendar.add(GregorianCalendar.MONTH, 6);
						}
						else if(frequency.equalsIgnoreCase("6")){
							//Yearly
							calendar.add(GregorianCalendar.MONTH, 12);
						}
						else{
							return null;
						}
						return calendar.getTime();
					}
				}
			}
		}
		return null;
	}
    //--- DELETE ----------------------------------------------------------------------------------
    public static boolean delete(String sOperationUid){
    	boolean errorOccurred = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "DELETE FROM OC_MAINTENANCEOPERATIONS"+
                          " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sOperationUid.substring(0,sOperationUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sOperationUid.substring(sOperationUid.indexOf(".")+1)));
            
            ps.executeUpdate();
        }
        catch(Exception e){
        	errorOccurred = true;
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return errorOccurred;
    }
    
    //--- GET -------------------------------------------------------------------------------------
    public static MaintenanceOperation get(MaintenanceOperation operation){
    	return get(operation.getUid());
    }
       
    public static MaintenanceOperation get(String sOperationUid){
    	MaintenanceOperation operation = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
            String sSql = "SELECT * FROM OC_MAINTENANCEOPERATIONS"+
                          " WHERE (OC_MAINTENANCEOPERATION_SERVERID = ? AND OC_MAINTENANCEOPERATION_OBJECTID = ?)";
            ps = oc_conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(sOperationUid.substring(0,sOperationUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(sOperationUid.substring(sOperationUid.indexOf(".")+1)));

            // execute
            rs = ps.executeQuery();
            if(rs.next()){
                operation = new MaintenanceOperation();
                operation.setUid(rs.getString("OC_MAINTENANCEOPERATION_SERVERID")+"."+rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                operation.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_SERVERID"));
                operation.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                
                operation.maintenanceplanUID = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID"));
                operation.date               = rs.getDate("OC_MAINTENANCEOPERATION_DATE");
                operation.operator           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_OPERATOR"));
                operation.result             = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_RESULT"));
                operation.comment            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT"));
                operation.comment1            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT1"));
                operation.comment2            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT2"));
                operation.comment3            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT3"));
                operation.comment4            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT4"));
                operation.comment5            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT5"));
                operation.lockedBy            = rs.getInt("OC_MAINTENANCEOPERATION_LOCKEDBY");
                operation.supplier            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_SUPPLIER"));
                operation.nextDate           = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
                
                // update-info
                operation.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEOPERATION_UPDATETIME"));
                operation.setUpdateUser(rs.getString("OC_MAINTENANCEOPERATION_UPDATEID"));
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return operation;
    }
        
    //--- GET LIST --------------------------------------------------------------------------------
    public static List<MaintenanceOperation> getList(){
    	return getList(new MaintenanceOperation());     	
    }
    
    public static List<MaintenanceOperation> getList(MaintenanceOperation findItem){
        List<MaintenanceOperation> foundObjects = new LinkedList();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        
        try{
        	//*** compose query ***************************
            String sSql = "SELECT * FROM OC_MAINTENANCEOPERATIONS,OC_MAINTENANCEPLANS,OC_ASSETS WHERE OC_ASSET_OBJECTID=replace(OC_MAINTENANCEPLAN_ASSETUID,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') AND OC_MAINTENANCEPLAN_OBJECTID=replace(OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','')"; // 'where' facilitates further composition of query

            //*** search-criteria *** 
            if(findItem.maintenanceplanUID.length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID = '"+findItem.maintenanceplanUID+"'";
            }

            // performed-period
            if(findItem.periodPerformedBegin!=null && findItem.periodPerformedEnd!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE BETWEEN '"+findItem.periodPerformedBegin+"' AND '"+findItem.periodPerformedEnd+"'";
            }
            else if(findItem.periodPerformedBegin!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE > '"+findItem.periodPerformedBegin+"'";
            }
            else if(findItem.periodPerformedEnd!=null){
                sSql+= " AND OC_MAINTENANCEOPERATION_DATE <= '"+findItem.periodPerformedEnd+"'";
            }
            
            if(ScreenHelper.checkString(findItem.getTag()).split(";")[0].length()>0){
                sSql+= " AND OC_MAINTENANCEPLAN_ASSETUID = '"+findItem.getTag().split(";")[0]+"'";
            }
            if(ScreenHelper.checkString(findItem.getTag()).split(";").length>1 && ScreenHelper.checkString(findItem.getTag()).split(";")[1].length()>0){
                sSql+= " AND OC_ASSET_SERVICE like '"+findItem.getTag().split(";")[1]+"%'";
            }
            if(ScreenHelper.checkString(findItem.operator).length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_OPERATOR LIKE '%"+findItem.operator+"%'";
            }
            if(ScreenHelper.checkString(findItem.result).length() > 0){
                sSql+= " AND OC_MAINTENANCEOPERATION_RESULT = '"+findItem.result+"'";
            }
            
            sSql+= " ORDER BY OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID ASC,OC_MAINTENANCEOPERATION_DATE ASC";
            
            ps = oc_conn.prepareStatement(sSql);
            
                        
            //*** execute query ***************************
            rs = ps.executeQuery();
            MaintenanceOperation operation;
            
            while(rs.next()){
            	operation = new MaintenanceOperation();   
            	operation.setUid(rs.getString("OC_MAINTENANCEOPERATION_SERVERID")+"."+rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));
                operation.serverId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_SERVERID"));
                operation.objectId = Integer.parseInt(rs.getString("OC_MAINTENANCEOPERATION_OBJECTID"));

                operation.maintenanceplanUID = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_MAINTENANCEPLANUID"));
                operation.date               = rs.getDate("OC_MAINTENANCEOPERATION_DATE");
                operation.operator           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_OPERATOR"));
                operation.result             = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_RESULT"));
                operation.comment            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT"));
                operation.comment1            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT1"));
                operation.comment2            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT2"));
                operation.comment3            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT3"));
                operation.comment4            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT4"));
                operation.comment5            = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_COMMENT5"));
                operation.nextDate           = rs.getDate("OC_MAINTENANCEOPERATION_NEXTDATE");
                operation.supplier           = ScreenHelper.checkString(rs.getString("OC_MAINTENANCEOPERATION_SUPPLIER"));
                operation.lockedBy            = rs.getInt("OC_MAINTENANCEOPERATION_LOCKEDBY");
               
                // update-info
                operation.setUpdateDateTime(rs.getTimestamp("OC_MAINTENANCEOPERATION_UPDATETIME"));
                operation.setUpdateUser(rs.getString("OC_MAINTENANCEOPERATION_UPDATEID"));
                
                foundObjects.add(operation);
            }
        }
        catch(Exception e){
        	if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        
        return foundObjects;
    }

}