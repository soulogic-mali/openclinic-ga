package be.openclinic.adt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;
import be.openclinic.common.ObjectReference;

public class Reservation  extends OC_Object {
	private String resourceUid;
	private String planningUid;
	private java.util.Date begin;
	private java.util.Date end;
	private Planning planning;
	
	public String getResourceUid() {
		return resourceUid;
	}
	public void setResourceUid(String resourceUid) {
		this.resourceUid = resourceUid;
	}
	public String getPlanningUid() {
		return planningUid;
	}
	public void setPlanningUid(String planningUid) {
		this.planningUid = planningUid;
	}
	public java.util.Date getBegin() {
		return begin;
	}
	public void setBegin(java.util.Date begin) {
		this.begin = begin;
	}
	public java.util.Date getEnd() {
		return end;
	}
	public void setEnd(java.util.Date end) {
		this.end = end;
	}
	public Planning getPlanning(){
		if(planning==null){
			planning = Planning.get(planningUid);
		}
		return planning;
	}
	
	public static void saveReservationLock(String resourceuid,java.util.Date begin,java.util.Date end,String service,String userid){
        PreparedStatement ps = null;
        String sSelect = "insert into OC_RESERVATIONLOCKS(OC_RESERVATIONLOCK_REFTYPE,"
        		+ "OC_RESERVATIONLOCK_REFUID,"
        		+ "OC_RESERVATIONLOCK_BEGIN,"
        		+ "OC_RESERVATIONLOCK_END,"
        		+ "OC_RESERVATIONLOCK_SERVICE,"
        		+ "OC_RESERVATIONLOCK_UPDATETIME,"
        		+ "OC_RESERVATIONLOCK_UPDATEUID,"
        		+ "OC_RESERVATIONLOCK_OBJECTID) "
        		+ "VALUES(?,?,?,?,?,?,?,?)";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, "resource");
        	ps.setString(2, resourceuid);
        	ps.setTimestamp(3, new java.sql.Timestamp(begin.getTime()));
        	ps.setTimestamp(4, new java.sql.Timestamp(end.getTime()));
        	ps.setString(5, service);
        	ps.setTimestamp(6, new java.sql.Timestamp(new java.util.Date().getTime()));
        	ps.setString(7,userid);
        	ps.setInt(8, MedwanQuery.getInstance().getOpenclinicCounter("OC_RESERVATIONLOCK_OBJECTID"));
        	ps.execute();
        }
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }
	}
	
	public static String getAccessibleResources(String userid){
		String resources="";
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "select * from OC_CONFIG where OC_KEY like 'resourceUsers.%'";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement(sSelect);
        	rs=ps.executeQuery();
        	while(rs.next()){
        		String resource=rs.getString("OC_KEY").replaceAll("resourceUsers.", "");
        		String rights=rs.getString("OC_VALUE")+";";
        		if(rights.indexOf(";"+userid+";")>-1){
        			resources+=";"+resource;
        		}
        	}
        }
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }
		return resources+";";
	}
	
	public static Vector getReservationLocksForResourceUid(String sResourceUid, java.util.Date begin, java.util.Date end){
		Vector reservations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "SELECT * FROM OC_RESERVATIONLOCKS WHERE "
        		+ "OC_RESERVATIONLOCK_REFUID = ?"
        		+ " AND OC_RESERVATIONLOCK_REFTYPE='resource'"+
                " AND OC_RESERVATIONLOCK_BEGIN <= ?"+
        		" AND OC_RESERVATIONLOCK_END >= ?"
        		+ " ORDER by OC_RESERVATIONLOCK_BEGIN ASC";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, sResourceUid);
        	ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
        	ps.setTimestamp(3, new java.sql.Timestamp(begin.getTime()));
        	rs=ps.executeQuery();
        	while(rs.next()){
                reservations.add(rs.getInt("OC_RESERVATIONLOCK_OBJECTID")+";"+rs.getTimestamp("OC_RESERVATIONLOCK_BEGIN").getTime()+";"+rs.getTimestamp("OC_RESERVATIONLOCK_END").getTime()+";"+rs.getString("OC_RESERVATIONLOCK_SERVICE"));
        	}
        }
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }

		return reservations;
	}
	
	public static Vector getReservationsForResourceUid(String sResourceUid, java.util.Date begin, java.util.Date end){
		Vector reservations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "SELECT * FROM OC_RESERVATIONS WHERE OC_RESERVATION_RESOURCEUID = ?"+
                " AND OC_RESERVATION_BEGIN <= ?"+
        		" AND OC_RESERVATION_END >= ?"
        		+ " ORDER by OC_RESERVATION_BEGIN ASC";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, sResourceUid);
        	ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
        	ps.setTimestamp(3, new java.sql.Timestamp(begin.getTime()));
        	rs=ps.executeQuery();
        	while(rs.next()){
                Reservation reservation = new Reservation();
                reservation.setUid(rs.getInt("OC_RESERVATION_SERVERID")+"."+rs.getInt("OC_RESERVATION_OBJECTID"));
                reservation.resourceUid = rs.getString("OC_RESERVATION_RESOURCEUID");
                reservation.planningUid = rs.getString("OC_RESERVATION_PLANNINGUID");
                reservation.begin = rs.getTimestamp("OC_RESERVATION_BEGIN");
                reservation.end = rs.getTimestamp("OC_RESERVATION_END");
                reservation.setCreateDateTime(rs.getTimestamp("OC_RESERVATION_CREATEDATETIME"));
                reservation.setUpdateDateTime(rs.getTimestamp("OC_RESERVATION_UPDATETIME"));
                reservation.setUpdateUser(rs.getString("OC_RESERVATION_UPDATEUID"));
                reservation.setVersion(rs.getInt("OC_RESERVATION_VERSION"));
                reservations.add(reservation);
        	}
        }
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }

		return reservations;
	}
	
	public static Vector<Reservation> getReservationsForPlanningUid(String sPlanningUid){
		Vector reservations = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "SELECT * FROM OC_RESERVATIONS WHERE OC_RESERVATION_PLANNINGUID = ?";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement(sSelect);
        	ps.setString(1, sPlanningUid);
        	rs=ps.executeQuery();
        	while(rs.next()){
                Reservation reservation = new Reservation();
                reservation.setUid(rs.getInt("OC_RESERVATION_SERVERID")+"."+rs.getInt("OC_RESERVATION_OBJECTID"));
                reservation.resourceUid = rs.getString("OC_RESERVATION_RESOURCEUID");
                reservation.planningUid = rs.getString("OC_RESERVATION_PLANNINGUID");
                reservation.begin = rs.getTimestamp("OC_RESERVATION_BEGIN");
                reservation.end = rs.getTimestamp("OC_RESERVATION_END");
                reservation.setCreateDateTime(rs.getTimestamp("OC_RESERVATION_CREATEDATETIME"));
                reservation.setUpdateDateTime(rs.getTimestamp("OC_RESERVATION_UPDATETIME"));
                reservation.setUpdateUser(rs.getString("OC_RESERVATION_UPDATEUID"));
                reservation.setVersion(rs.getInt("OC_RESERVATION_VERSION"));
                reservations.add(reservation);
        	}
        }
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
            }
        }

		return reservations;
	}
	
	public static void deleteResourceLock(String uid){
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
	        PreparedStatement ps = oc_conn.prepareStatement("delete from OC_RESERVATIONLOCKS where OC_RESERVATIONLOCK_OBJECTID=?");
	        ps.setInt(1, Integer.parseInt(uid));
	        ps.execute();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
	}
	
	public static void delete(String uid){
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
	        PreparedStatement ps = oc_conn.prepareStatement("delete from OC_RESERVATIONS where OC_RESERVATION_SERVERID=? and OC_RESERVATION_OBJECTID=?");
	        ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
	        ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
	        ps.execute();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
	}
	
    //--- GET -------------------------------------------------------------------------------------
    public static Reservation get(String uid){
        Reservation reservation = new Reservation();
        
        if((uid!=null) && (uid.length() > 0)){
            String[] ids = uid.split("\\.");
            if(ids.length==2){
                PreparedStatement ps = null;
                ResultSet rs = null;
                String sSelect = "SELECT * FROM OC_RESERVATIONS WHERE OC_RESERVATION_SERVERID = ?"+
                                 " AND OC_RESERVATION_OBJECTID = ?";
                Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                try{
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();
                    if(rs.next()){
                        reservation.setUid(uid);
                        reservation.resourceUid = rs.getString("OC_RESERVATION_RESOURCEUID");
                        reservation.planningUid = rs.getString("OC_RESERVATION_PLANNINGUID");
                        reservation.begin = rs.getTimestamp("OC_RESERVATION_BEGIN");
                        reservation.end = rs.getTimestamp("OC_RESERVATION_END");
                        reservation.setCreateDateTime(rs.getTimestamp("OC_RESERVATION_CREATEDATETIME"));
                        reservation.setUpdateDateTime(rs.getTimestamp("OC_RESERVATION_UPDATETIME"));
                        reservation.setUpdateUser(rs.getString("OC_RESERVATION_UPDATEUID"));
                        reservation.setVersion(rs.getInt("OC_RESERVATION_VERSION"));
                    }
                }
                catch(Exception e){
                    Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
                }
                finally{
                    try{
                        if(rs!=null) rs.close();
                        if(ps!=null) ps.close();
                        oc_conn.close();
                    }
                    catch(Exception e){
                        Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
                    }
                }
            }
        }
        return reservation;
    }
    
    // STORE
    public void store(){
        String ids[];
        int iVersion = 1;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(this.getUid()!=null && this.getUid().length() > 0){
                ids = this.getUid().split("\\.");
                if(ids.length==2){
                    sSelect = "SELECT * FROM OC_RESERVATIONS"+
                              " WHERE OC_RESERVATION_SERVERID = ?"+
                              "  AND OC_RESERVATION_OBJECTID = ?";
                    ps = conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));

                    rs = ps.executeQuery();
                    if(rs.next()){
                        iVersion = rs.getInt("OC_RESERVATION_VERSION")+1;
                    }

                    rs.close();
                    ps.close();

                    // move record to history
                    sSelect = "INSERT INTO OC_RESERVATIONS_HISTORY(OC_RESERVATION_SERVERID,"+
	                          "OC_RESERVATION_OBJECTID,"+
	                          "OC_RESERVATION_RESOURCEUID,"+
	                          "OC_RESERVATION_PLANNINGUID,"+
	                          "OC_RESERVATION_BEGIN,"+
	                          "OC_RESERVATION_END,"+
	                          "OC_RESERVATION_UPDATETIME,"+
	                          "OC_RESERVATION_UPDATEUID,"+
	                          "OC_RESERVATION_CREATEDATETIME,"+
	                          "OC_RESERVATION_VERSION) "+
	                          " SELECT OC_RESERVATION_SERVERID,"+
	                          "OC_RESERVATION_OBJECTID,"+
	                          "OC_RESERVATION_RESOURCEUID,"+
	                          "OC_RESERVATION_PLANNINGUID,"+
	                          "OC_RESERVATION_BEGIN,"+
	                          "OC_RESERVATION_END,"+
	                          "OC_RESERVATION_UPDATETIME,"+
	                          "OC_RESERVATION_UPDATEUID,"+
	                          "OC_RESERVATION_CREATEDATETIME,"+
	                          "OC_RESERVATION_VERSION "+
	                          " FROM OC_RESERVATIONS "+
	                          " WHERE OC_RESERVATION_SERVERID = ?"+
	                          " AND OC_RESERVATION_OBJECTID = ?";
                    ps = conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();

                    // delete from active records
                    sSelect = "DELETE FROM OC_RESERVATIONS"+
                              " WHERE OC_RESERVATION_SERVERID = ?"+
                              "  AND OC_RESERVATION_OBJECTID = ?";
                    ps = conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();
                }
            }
            else{
                ids = new String[]{MedwanQuery.getInstance().getConfigString("serverId"),MedwanQuery.getInstance().getOpenclinicCounter("OC_RESERVATIONS")+""};
            }
            
            if(ids.length==2){
                sSelect = " INSERT INTO OC_RESERVATIONS"+
                          "("+
                          "OC_RESERVATION_SERVERID,"+
                          "OC_RESERVATION_OBJECTID,"+
                          "OC_RESERVATION_RESOURCEUID,"+
                          "OC_RESERVATION_PLANNINGUID,"+
                          "OC_RESERVATION_BEGIN,"+
                          "OC_RESERVATION_END,"+
                          "OC_RESERVATION_UPDATETIME,"+
                          "OC_RESERVATION_UPDATEUID,"+
                          "OC_RESERVATION_CREATEDATETIME,"+
                          "OC_RESERVATION_VERSION "+
                          ") "+
                          " VALUES(?,?,?,?,?,?,?,?,?,?)";
                ps = conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(ids[0]));
                while(!MedwanQuery.getInstance().validateNewOpenclinicCounter("OC_RESERVATIONS","OC_RESERVATION_OBJECTID",ids[1])){
                    ids[1] =  MedwanQuery.getInstance().getOpenclinicCounter("OC_RESERVATIONS")+"";
                }
                ps.setInt(2,Integer.parseInt(ids[1]));
                ps.setString(3,this.getResourceUid());
                ps.setString(4,this.getPlanningUid());
                ps.setTimestamp(5,new Timestamp(this.getBegin().getTime()));
                if(this.getEnd()==null){
                    ps.setNull(6,java.sql.Types.TIMESTAMP);
                } 
                else{
                    ps.setTimestamp(6,new Timestamp(this.getEnd().getTime()));
                }
                ps.setTimestamp(7,new Timestamp(new Date().getTime()));
                ps.setString(8,this.getUpdateUser());
                ps.setTimestamp(9,new Timestamp(this.getCreateDateTime().getTime()));
                ps.setInt(10,iVersion);
                ps.executeUpdate();
                ps.close();
                
                this.setUid(ids[0]+"."+ ids[1]);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                if(conn!=null) conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    }

}
