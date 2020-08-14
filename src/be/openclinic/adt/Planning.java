package be.openclinic.adt;

import be.openclinic.common.OC_Object;
import be.openclinic.common.ObjectReference;
import be.openclinic.reporting.MessageNotifier;
import be.openclinic.system.SH;
import be.openclinic.util.Nomenclature;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import net.admin.AdminPerson;
import net.admin.User;

import java.text.SimpleDateFormat;
import java.util.*;

import javax.print.CancelablePrintJob;

import com.aspose.barcode.internal.dr.sc;
import com.sun.jna.platform.win32.COM.DispatchVTable.GetIDsOfNamesCallback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class Planning extends OC_Object {
    private String description;
    private AdminPerson patient;
    private String patientUID;
    private AdminPerson user;
    private String userUID;
    private Date plannedDate;
    private Date plannedEndDate;
    private String estimatedtime;
    private Date effectiveDate;
    private Date cancelationDate;
    private Date confirmationDate;
    private ObjectReference contact; // product, examination
    private TransactionVO transaction;
    private String transactionUID;
    private String contextID;
    private int margin;
    private String tempPlanningUid;
    private String serviceUid;
    private Date remindSent;
    private String comment;
    private Date cancellationWarningSent;
    private String modifiers;
    
	public String getModifiers() {
		return modifiers;
	}

	public void setModifiers(String modifiers) {
		this.modifiers = modifiers;
	}

	public void setModifier(int index,String value){
		if(getModifiers()==null){
			setModifiers("");
		}
		String[] m = getModifiers().split(";");
		if(m.length<=index){
			setModifiers(getModifiers()+"; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;".substring(0,(index+1-m.length)*2));
			m = getModifiers().split(";");
		}
		m[index]=value;
		modifiers="";
		for(int n=0;n<m.length;n++){
			modifiers+=m[n]+";";
		}
	}
	
	public void setPreparationDate(String n){
		setModifier(0,n+"");
	}
	
	public String getPreparationDate(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[0];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}
	
	public void setNoshow(String n){
		setModifier(1,n+"");
	}
	
	public String getNoshow(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[1];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}
	
	public String getCreateUser(){
		String user=getUpdateUser();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT * FROM OC_PLANNING_HISTORY WHERE OC_PLANNING_OBJECTID = ? and OC_PLANNING_VERSION=1";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(getUid().split("\\.")[1]));
            rs = ps.executeQuery();
            if (rs.next()){
            	user=rs.getString("OC_PLANNING_UPDATEUID");
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
        return user;
 	}

	public String getAdmissionDate(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[5];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setAdmissionDate(String n){
		setModifier(5,n+"");
	}
	
	public String getOperationDate(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[2];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setOperationDate(String n){
		setModifier(2,n+"");
	}
	
	public String getReportingPlace(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[3];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setReportingPlace(String n){
		setModifier(3,n+"");
	}
	
	public String getSurgeon(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[4];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setSurgeon(String n){
		setModifier(4,n+"");
	}
	
	public String getFullDay(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[5];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setFullDay(String n){
		setModifier(5,n+"");
	}
	
	public boolean isFullDay() {
		return ScreenHelper.checkString(getFullDay()).equalsIgnoreCase("1");
	}
	
	public String getType(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[6];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setType(String n){
		setModifier(6,n+"");
	}
	
	public String getLocation(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[7];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setLocation(String n){
		setModifier(7,n+"");
	}
	
	public String getColor(){
		String n="";
		if(getModifiers()!=null){
			try{
				n=getModifiers().split(";")[8];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return n;
	}

	public void setColor(String n){
		setModifier(8,n+"");
	}
	
    public Date getCancellationWarningSent() {
		return cancellationWarningSent;
	}
	public void setCancellationWarningSent(Date cancellationWarningSent) {
		this.cancellationWarningSent = cancellationWarningSent;
	}
	public Date getConfirmationDate() {
		return confirmationDate;
	}
	public void setConfirmationDate(Date confirmationDate) {
		this.confirmationDate = confirmationDate;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public Date getRemindSent() {
		return remindSent;
	}
	public void setRemindSent(Date remindSent) {
		this.remindSent = remindSent;
	}
	public String getServiceUid() {
		return serviceUid;
	}
	public void setServiceUid(String serviceUid) {
		this.serviceUid = serviceUid;
	}
	public void setPlannedEndDate(Date plannedEndDate) {
		this.plannedEndDate = plannedEndDate;
	}
	public String getTempPlanningUid() {
		return tempPlanningUid;
	}
	public void setTempPlanningUid(String tempPlanningUid) {
		this.tempPlanningUid = tempPlanningUid;
	}
	
	//--- DESCRIPTION -----------------------------------------------------------------------------
    public String getDescription(){
        return description;
    }
    public void setDescription(String description){
        this.description = description;
    }
    
    //--- GET PATIENT -----------------------------------------------------------------------------
    public AdminPerson getPatient(){
        if(this.patient==null){
            if(ScreenHelper.checkDbString(this.patientUID).length() > 0){
            	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                this.setPatient(AdminPerson.getAdminPerson(ad_conn,this.patientUID));
                
                try{
					ad_conn.close();
				}
                catch(SQLException e){
					e.printStackTrace();
				}
            }
            else {
                this.patient = null;
            }
        }
        
        return patient;
    }
    
    public void setPatient(AdminPerson patient){
        this.patient = patient;
    }
    public String getPatientUID(){
        return patientUID;
    }
    public void setPatientUID(String patientUID){
        this.patientUID = patientUID;
    }
    public String getUserUID(){
        return userUID;
    }
    public void setUserUID(String userUID){
        this.userUID = userUID;
    }
    public int getMargin(){
        return margin;
    }
    public void setMargin(int margin){
        this.margin = margin;
    }
    
    //--- GET USER --------------------------------------------------------------------------------
    public AdminPerson getUser(){
        if(this.user==null){
            if(ScreenHelper.checkDbString(this.userUID).length() > 0){
            	User u = User.get(Integer.parseInt(this.userUID));
            	if(u!=null){
            		this.setUser(u.person);
            	}
            }
            else{
                this.user = null;
            }
        }
        
        return user;
    }
    
    public void setUser(AdminPerson user){
        this.user = user;
    }
    
    //--- SET PLANNED END DATE --------------------------------------------------------------------
    public void setPlannedEndDate(){
        Calendar cal = GregorianCalendar.getInstance();
        cal.setTime(this.plannedDate);
        
        if(this.getEstimatedtime()!=null && this.getEstimatedtime().length()>0){
        	try{
	        	cal.add(Calendar.HOUR,Integer.parseInt(this.getEstimatedtime().split(":")[0]));
		        cal.add(Calendar.MINUTE,Integer.parseInt(this.getEstimatedtime().split(":")[1]));
        	}
        	catch(Exception e){}
        }
        
        this.plannedEndDate = cal.getTime();
    }
    
    public Date getPlannedEndDate(){
        return this.plannedEndDate;
    }
    
    public void setPlannedDate(Date plannedDate){
        this.plannedDate = plannedDate;
    }
    public Date getPlannedDate(){
        return plannedDate;
    }
    
    public String getEstimatedtime(){
        return ScreenHelper.checkString(estimatedtime);
    }
    public void setEstimatedtime(String estimatedtime){
        this.estimatedtime = estimatedtime;
    }
    
    public Date getEffectiveDate(){
        return effectiveDate;
    }
    public void setEffectiveDate(Date effectiveDate){
        this.effectiveDate = effectiveDate;
    }
    
    public Date getCancelationDate(){
        return cancelationDate;
    }
    public void setCancelationDate(Date canceledDate){
        this.cancelationDate = canceledDate;
    }
    
    //--- GET CONTACT -----------------------------------------------------------------------------
    public ObjectReference getContact(){
        return contact;
    }
    public void setContact(ObjectReference contact){
        this.contact = contact;
    }
    
    //--- GET TRANSACTION -------------------------------------------------------------------------
    public TransactionVO getTransaction(){
        if(this.transaction==null){
            if(ScreenHelper.checkDbString(this.transactionUID).length() > 0){
                String[] aID = this.transactionUID.split("\\.");
                this.setTransaction(MedwanQuery.getInstance().loadTransaction(Integer.parseInt(aID[0]),Integer.parseInt(aID[1])));
            } 
            else{
                this.transaction = null;
            }
        }
        
        return transaction;
    }
    
    public void setTransaction(TransactionVO transaction){
        this.transaction = transaction;
    }
    
    public String getTransactionUID(){
        return transactionUID;
    }
    
    public void setTransactionUID(String transactionUID){
        this.transactionUID = transactionUID;
    }
    
    //--- CONTEXT ---------------------------------------------------------------------------------
    public String getContextID(){
        return contextID;
    }
    
    public void setContextID(String contextID){
        this.contextID = contextID;
    }
    
    //--- GET -------------------------------------------------------------------------------------
    public static Planning get(String uid){
        Planning planning = new Planning();
        
        if((uid!=null) && (uid.length() > 0)){
            String[] ids = uid.split("\\.");
            if(ids.length==2){
                PreparedStatement ps = null;
                ResultSet rs = null;
                String sSelect = "SELECT * FROM OC_PLANNING WHERE OC_PLANNING_SERVERID = ?"+
                                 " AND OC_PLANNING_OBJECTID = ?";
                Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                try{
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();
                    if(rs.next()){
                        planning.setUid(uid);
                        planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                        planning.userUID = rs.getString("OC_PLANNING_USERUID");
                        planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                        planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                        planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                        planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                        planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                        ObjectReference orContact = new ObjectReference();
                        orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                        orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                        planning.setContact(orContact);
                        planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                        planning.comment = rs.getString("OC_PLANNING_COMMENT");
                        planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                        planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                        planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                        planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                        planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                        planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                        planning.contextID = rs.getString("OC_PLANNING_CONTEXTID");
                        planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                        planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                        planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                        planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                        planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
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
        
        return planning;
    }
    
    public static boolean isResourceAvailable(String resourceId,java.util.Date begin,java.util.Date end) {
    	boolean bAvailable=true;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from oc_reservations r,oc_planning p where"+
    					" oc_planning_objectid=replace(oc_reservation_planninguid,'"+SH.sid()+".','') and"+
    					" oc_reservation_resourceuid=? and"+
    					" oc_planning_planneddate<? and"+
    					" oc_planning_plannedend>?");
    		ps.setString(1, resourceId);
    		ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
    		ps.setTimestamp(3, new java.sql.Timestamp(begin.getTime()));
    		ResultSet rs = ps.executeQuery();
    		bAvailable=!rs.next();
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return bAvailable;
    }
    
    public boolean isResourceAvailable(String resourceId,String sWebLanguage) {
    	boolean bAvailable=true;
    	if(ScreenHelper.getTranNoLink("calendarresource", resourceId, sWebLanguage).contains(";noselect")){
    		bAvailable=false;
    	}
    	else {
	    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    	try {
	    		PreparedStatement ps = conn.prepareStatement("select * from oc_reservations r,oc_planning p where"+
	    					" oc_planning_objectid=replace(oc_reservation_planninguid,'"+SH.sid()+".','') and"+
	    					" oc_reservation_resourceuid =? and"+
	    					" oc_planning_planneddate<? and"+
	    					" oc_planning_plannedend>?");
	    		ps.setString(1, resourceId);
	    		ps.setTimestamp(2, new java.sql.Timestamp(this.getPlannedEndDate().getTime()));
	    		ps.setTimestamp(3, new java.sql.Timestamp(this.getPlannedDate().getTime()));
	    		ResultSet rs = ps.executeQuery();
	    		bAvailable=!rs.next();
	    		rs.close();
	    		ps.close();
	    		conn.close();
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    	}
    	}
		if(!bAvailable) {
	    	//Find out if any of the children is available
	    	Vector children = Nomenclature.getAllChildren("calendarresource", resourceId);
	    	for(int n=0;n<children.size();n++) {
	    		Nomenclature nomenclature = (Nomenclature)children.elementAt(n);
	    		if(isResourceAvailable(nomenclature.getId(),sWebLanguage)) {
	    			bAvailable=true;
	    			break;
	    		}
	    	}
		}

    	return bAvailable;
    }
    
    public boolean isFree() {
    	//Check if this appointment is still marked as free slot
    	if(!getType().contains("medwan.common.free")) {
    		return false;
    	}
    	//Check if this appointment is not in the past
    	if(getPlannedDate().before(new java.util.Date())) {
    		return false;
    	}
    	//Check if this appointment has already been saved to the database
    	if(getUid().split("\\.").length<2) {
    		return false;
    	}
    	//Check if the appointment is not covered
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from oc_planning where"+
    					" oc_planning_objectid<>? and"+
    					" substring_index(oc_planning_modifiers,';',6) not like '%;1' and"+ //Don't consider the full day events
    					" oc_planning_planneddate<? and"+
    					" oc_planning_useruid=? and"+
    					" oc_planning_modifiers not like '%;medwan.common.free;%' and"+ //Don't consider other free slots as overlap
    					" oc_planning_plannedend>?");
    		ps.setString(1, getUid().split("\\.")[1]);
    		ps.setTimestamp(2, new java.sql.Timestamp(getPlannedEndDate().getTime()));
    		ps.setString(3,getUserUID());
    		ps.setTimestamp(4, new java.sql.Timestamp(getPlannedDate().getTime()));
    		ResultSet rs = ps.executeQuery();
    		boolean bOverlap = rs.next();
    		rs.close();
    		ps.close();
    		conn.close();
    		if(bOverlap) {
    			return false;
    		}
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return true;
    }
    
    //--- UPDATE DATE -----------------------------------------------------------------------------
    public boolean updateDate(String sPlanningUID){
        PreparedStatement ps;
        boolean bOk = false;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String[] ids = sPlanningUID.split("\\.");
            String sQuery = "UPDATE OC_PLANNING"+
                            "  SET OC_PLANNING_PLANNEDDATE=?, OC_PLANNING_ESTIMATIONTIME=?, OC_PLANNING_PLANNEDEND=?"+
                            " WHERE OC_PLANNING_SERVERID = ? AND OC_PLANNING_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sQuery);

            // appointment date
            if(this.plannedDate==null){
                ps.setNull(1,java.sql.Types.TIMESTAMP);
            }
            else {
                ps.setTimestamp(1,new java.sql.Timestamp(this.plannedDate.getTime()));
            }
            
            // appointment end date
            ps.setString(2,this.estimatedtime);
            long minute=60*1000;
            long hour=60*minute;
            this.setPlannedEndDate(new java.util.Date(plannedDate.getTime()+Integer.parseInt(estimatedtime.split(":")[0])*hour+Integer.parseInt(this.estimatedtime.split(":")[1])*minute));
            ScreenHelper.getSQLTimestamp(ps,3,this.getPlannedEndDate());
            ps.setInt(4,Integer.parseInt(ids[0]));
            ps.setInt(5,Integer.parseInt(ids[1]));
            if(ps.executeUpdate() > 0){
                bOk = true;
            }
            
            ps.close();
        } 
        catch(Exception e){
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        
        try{
			oc_conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return bOk;
    }
    
    public static void copyToHistory(String uid){
    	String[] ids = ScreenHelper.checkString(uid).split("\\.");
        if(ids.length==2){
	    	Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
	        PreparedStatement ps = null;
	        try{
	        	String sSql="insert into OC_PLANNING_HISTORY(OC_PLANNING_PATIENTUID,OC_PLANNING_USERUID,OC_PLANNING_PLANNEDDATE,"
	        			+ " OC_PLANNING_EFFECTIVEDATE,OC_PLANNING_CANCELATIONDATE,OC_PLANNING_CONTACTTYPE,OC_PLANNING_CONTACTUID,"
	        			+ " OC_PLANNING_DESCRIPTION,OC_PLANNING_SERVERID,OC_PLANNING_TRANSACTIONUID,OC_PLANNING_CREATETIME,"
	        			+ " OC_PLANNING_UPDATETIME,OC_PLANNING_UPDATEUID,OC_PLANNING_VERSION,OC_PLANNING_OBJECTID,OC_PLANNING_ESTIMATIONTIME,"
	        			+ " OC_PLANNING_CONTEXTID,OC_PLANNING_SERVICEUID,OC_PLANNING_PLANNEDEND,OC_PLANNING_REMINDSENT,"
	        			+ " OC_PLANNING_CANCELLATIONWARNINGSENT,OC_PLANNING_COMMENT,OC_PLANNING_CONFIRMATIONDATE,OC_PLANNING_MODIFIERS)"
	        			+ " select OC_PLANNING_PATIENTUID,OC_PLANNING_USERUID,OC_PLANNING_PLANNEDDATE,"
	        			+ " OC_PLANNING_EFFECTIVEDATE,OC_PLANNING_CANCELATIONDATE,OC_PLANNING_CONTACTTYPE,OC_PLANNING_CONTACTUID,"
	        			+ " OC_PLANNING_DESCRIPTION,OC_PLANNING_SERVERID,OC_PLANNING_TRANSACTIONUID,OC_PLANNING_CREATETIME,"
	        			+ " OC_PLANNING_UPDATETIME,OC_PLANNING_UPDATEUID,OC_PLANNING_VERSION,OC_PLANNING_OBJECTID,OC_PLANNING_ESTIMATIONTIME,"
	        			+ " OC_PLANNING_CONTEXTID,OC_PLANNING_SERVICEUID,OC_PLANNING_PLANNEDEND,OC_PLANNING_REMINDSENT,"
	        			+ " OC_PLANNING_CANCELLATIONWARNINGSENT,OC_PLANNING_COMMENT,OC_PLANNING_CONFIRMATIONDATE,OC_PLANNING_MODIFIERS"
	        			+ " from OC_PLANNING where OC_PLANNING_SERVERID=? and OC_PLANNING_OBJECTID=?";
	        	ps=oc_conn.prepareStatement(sSql);
	            ps.setInt(1,Integer.parseInt(ids[0]));
	            ps.setInt(2,Integer.parseInt(ids[1]));
	            ps.execute();
	            ps.close();
	        }
	        catch(Exception e){
	        	e.printStackTrace();
	        }
	        finally{
	            try{
	                if(ps!=null) ps.close();
	                oc_conn.close();
	            }
	            catch(Exception ee){
	                Debug.printProjectErr(ee,Thread.currentThread().getStackTrace());
	            }
	        }
        }
    }
    
    public static void copyToHistoryCanceled(String uid,Date cancelationDate){
    	String[] ids = ScreenHelper.checkString(uid).split("\\.");
        if(ids.length==2){
	    	Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
	        PreparedStatement ps = null;
	        try{
	        	String sSql="insert into OC_PLANNING_HISTORY(OC_PLANNING_PATIENTUID,OC_PLANNING_USERUID,OC_PLANNING_PLANNEDDATE,"
	        			+ " OC_PLANNING_EFFECTIVEDATE,OC_PLANNING_CANCELATIONDATE,OC_PLANNING_CONTACTTYPE,OC_PLANNING_CONTACTUID,"
	        			+ " OC_PLANNING_DESCRIPTION,OC_PLANNING_SERVERID,OC_PLANNING_TRANSACTIONUID,OC_PLANNING_CREATETIME,"
	        			+ " OC_PLANNING_UPDATETIME,OC_PLANNING_UPDATEUID,OC_PLANNING_VERSION,OC_PLANNING_OBJECTID,OC_PLANNING_ESTIMATIONTIME,"
	        			+ " OC_PLANNING_CONTEXTID,OC_PLANNING_SERVICEUID,OC_PLANNING_PLANNEDEND,OC_PLANNING_REMINDSENT,"
	        			+ " OC_PLANNING_CANCELLATIONWARNINGSENT,OC_PLANNING_COMMENT,OC_PLANNING_CONFIRMATIONDATE,OC_PLANNING_MODIFIERS)"
	        			+ " select OC_PLANNING_PATIENTUID,OC_PLANNING_USERUID,OC_PLANNING_PLANNEDDATE,"
	        			+ " OC_PLANNING_EFFECTIVEDATE,?,OC_PLANNING_CONTACTTYPE,OC_PLANNING_CONTACTUID,"
	        			+ " OC_PLANNING_DESCRIPTION,OC_PLANNING_SERVERID,OC_PLANNING_TRANSACTIONUID,OC_PLANNING_CREATETIME,"
	        			+ " OC_PLANNING_UPDATETIME,OC_PLANNING_UPDATEUID,OC_PLANNING_VERSION,OC_PLANNING_OBJECTID,OC_PLANNING_ESTIMATIONTIME,"
	        			+ " OC_PLANNING_CONTEXTID,OC_PLANNING_SERVICEUID,OC_PLANNING_PLANNEDEND,OC_PLANNING_REMINDSENT,"
	        			+ " OC_PLANNING_CANCELLATIONWARNINGSENT,OC_PLANNING_COMMENT,OC_PLANNING_CONFIRMATIONDATE,OC_PLANNING_MODIFIERS"
	        			+ " from OC_PLANNING where OC_PLANNING_SERVERID=? and OC_PLANNING_OBJECTID=?";
	        	ps=oc_conn.prepareStatement(sSql);
	            ps.setTimestamp(1, new java.sql.Timestamp(cancelationDate.getTime()));
	            ps.setInt(2,Integer.parseInt(ids[0]));
	            ps.setInt(3,Integer.parseInt(ids[1]));
	            ps.execute();
	            ps.close();
	        }
	        catch(Exception e){
	        	e.printStackTrace();
	        }
	        finally{
	            try{
	                if(ps!=null) ps.close();
	                oc_conn.close();
	            }
	            catch(Exception ee){
	                Debug.printProjectErr(ee,Thread.currentThread().getStackTrace());
	            }
	        }
        }
    }
    
    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(){
        String ids[];
        int iVersion = 1;
        boolean bInserOk = false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if((this.getUid()!=null) && (this.getUid().length() > 0)){
                ids = this.getUid().split("\\.");
                
                if(ids.length==2){
                	
                	//First copy the record to history
                	if(getCancelationDate()==null){
                		copyToHistory(this.getUid());
                	}
                	else{
                		copyToHistoryCanceled(this.getUid(),getCancelationDate());
                	}
                	
                    sSelect = "SELECT OC_PLANNING_VERSION FROM OC_PLANNING WHERE OC_PLANNING_SERVERID = ? AND OC_PLANNING_OBJECTID = ?";
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();
                    if(rs.next()){
                        iVersion = rs.getInt("OC_PLANNING_VERSION")+1;
                    }
                    rs.close();
                    ps.close();
                    
                    sSelect = " DELETE FROM OC_PLANNING WHERE OC_PLANNING_SERVERID = ? AND OC_PLANNING_OBJECTID = ?";
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();
                }
            } 
            else{
                ids = new String[]{MedwanQuery.getInstance().getConfigString("serverId"),MedwanQuery.getInstance().getOpenclinicCounter("OC_PLANNING")+""};
                this.setCreateDateTime(new Date());
                this.setUid(ids[0]+"."+ids[1]);
            }
            
            if(ids.length==2 && getCancelationDate()==null){
                sSelect = " INSERT INTO OC_PLANNING ("+
                          " OC_PLANNING_SERVERID,"+
                          " OC_PLANNING_OBJECTID,"+
                          " OC_PLANNING_PATIENTUID,"+
                          " OC_PLANNING_USERUID,"+
                          " OC_PLANNING_PLANNEDDATE,"+
                          " OC_PLANNING_EFFECTIVEDATE,"+
                          " OC_PLANNING_CANCELATIONDATE,"+
                          " OC_PLANNING_CONTACTTYPE,"+
                          " OC_PLANNING_CONTACTUID,"+
                          " OC_PLANNING_TRANSACTIONUID,"+
                          " OC_PLANNING_DESCRIPTION,"+
                          " OC_PLANNING_CREATETIME,"+
                          " OC_PLANNING_UPDATETIME,"+
                          " OC_PLANNING_UPDATEUID,"+
                          " OC_PLANNING_VERSION,"+
                          " OC_PLANNING_ESTIMATIONTIME,"+
                          " OC_PLANNING_CONTEXTID,"+
                          " OC_PLANNING_SERVICEUID,"+
                          " OC_PLANNING_PLANNEDEND,"+
                          " OC_PLANNING_COMMENT,"+
                          " OC_PLANNING_CONFIRMATIONDATE,"+
                          " OC_PLANNING_MODIFIERS"+
                          ") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(ids[0]));
                ps.setInt(2,Integer.parseInt(ids[1]));
                ps.setString(3,this.getPatientUID());
                ps.setString(4,this.getUserUID());
                ScreenHelper.getSQLTimestamp(ps,5,this.getPlannedDate());
                ScreenHelper.getSQLTimestamp(ps,6,this.getEffectiveDate());
                ScreenHelper.getSQLTimestamp(ps,7,this.getCancelationDate());
                ps.setString(8,this.getContact()==null?"":this.getContact().getObjectType());
                ps.setString(9,this.getContact()==null?"":this.getContact().getObjectUid());
                ps.setString(10,this.getTransactionUID());
                ps.setString(11,this.getDescription());
                if(this.getCreateDateTime()==null){
                	this.setCreateDateTime(new java.util.Date());
                }
                ScreenHelper.getSQLTimestamp(ps,12,this.getCreateDateTime());
                this.setUpdateDateTime(new java.util.Date());
                ps.setTimestamp(13,new Timestamp(this.getUpdateDateTime().getTime()));
                ps.setString(14,this.getUpdateUser());
                ps.setInt(15,iVersion);
                ps.setString(16,this.getEstimatedtime());
                ps.setString(17,this.getContextID());
                ps.setString(18,this.getServiceUid());
                long minute=60*1000;
                long hour=60*minute;
                if(this.getPlannedEndDate()==null) {
                	this.setPlannedEndDate(this.getPlannedDate()==null||ScreenHelper.checkString(this.getEstimatedtime()).split(":").length<2?null:new java.util.Date(this.getPlannedDate().getTime()+Integer.parseInt(this.getEstimatedtime().split(":")[0])*hour+Integer.parseInt(this.getEstimatedtime().split(":")[1])*minute));
                }
                ScreenHelper.getSQLTimestamp(ps,19,this.getPlannedEndDate());
                ps.setString(20,this.getComment());
                ps.setTimestamp(21, this.getConfirmationDate()==null?null:new Timestamp(this.getConfirmationDate().getTime()));
                ps.setString(22,this.getModifiers());
                
                if(ps.executeUpdate() > 0){
                    bInserOk = true;
                    if(tempPlanningUid!=null && tempPlanningUid.split("\\.").length==2 && tempPlanningUid.split("\\.")[0].equalsIgnoreCase("0")){
                    	//Update reservations linked to temporaryplanninguid
                    	sSelect = "update OC_RESERVATIONS set OC_RESERVATION_PLANNINGUID=? where OC_RESERVATION_PLANNINGUID=?";
                    	ps.close();
                    	ps= oc_conn.prepareStatement(sSelect);
                    	ps.setString(1, this.getUid());
                    	ps.setString(2, tempPlanningUid);
                    	ps.execute();
                    	ps.close();
                    }
                }
            }
            else if(getCancelationDate()!=null){
            	bInserOk=true;
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
            catch(Exception ee){
                Debug.printProjectErr(ee,Thread.currentThread().getStackTrace());
            }
        }
        
        return bInserOk;
    }
    
    //--- GET PATIENT PLANNINGS -------------------------------------------------------------------
    public static Vector getPatientPlannings(String sPatientUID, String sUserUID){
        return getPatientPlannings(sPatientUID,sUserUID,null,null);	// all plannings
    }

    public static Vector getUserAppointmentsRemoveFreeOverlap(int userId, java.util.Date beginDate, java.util.Date endDate){
        Vector remainingappointments=new Vector();
        Vector appoinments = getUserPlannings(userId+"",beginDate,endDate);
        for(int n=0;n<appoinments.size();n++) {
            Planning appointment = (Planning)appoinments.elementAt(n);
            if(appointment.getType().equalsIgnoreCase("medwan.common.free")) {
                continue;
            }
            remainingappointments.add(appointment);
        }
        for(int n=0;n<appoinments.size();n++) {
            Planning appointment = (Planning)appoinments.elementAt(n);
            if(!appointment.getType().equalsIgnoreCase("medwan.common.free")) {
                continue;
            }
            boolean bSlotExists=false;
            for(int i=0;i<remainingappointments.size();i++){
                Planning app = (Planning)remainingappointments.elementAt(i);
                if(!app.getFullDay().equalsIgnoreCase("1") && appointment.getPlannedDate().before(app.getPlannedEndDate()) && appointment.getPlannedEndDate().after(app.getPlannedDate())){
                    bSlotExists=true;
                    break;
                }
            }
            if(!bSlotExists) {
                remainingappointments.add(appointment);
            }
        }
        return remainingappointments;
    }

    
    public static Vector getPatientPlannings(String sPatientUID, String sUserUID, Date begin, Date end){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT * FROM OC_PLANNING"+
                      " WHERE OC_PLANNING_PATIENTUID = ?";
            
            if(begin!=null){
                sSelect+= " AND OC_PLANNING_PLANNEDDATE >= ?";
            }
            if(end!=null){
                sSelect+= " AND OC_PLANNING_PLANNEDDATE < ?";
            }
             
            sSelect+= " AND OC_PLANNING_CANCELATIONDATE IS NULL";
            if(sUserUID.length() > 0){
                sSelect+= " AND OC_PLANNING_USERUID = '"+sUserUID+"'";
            }
            ps = oc_conn.prepareStatement(sSelect);
            
            int psIdx = 1;
            ps.setString(psIdx++,sPatientUID);
            if(begin!=null) ps.setTimestamp(psIdx++,new java.sql.Timestamp(begin.getTime()));
            if(end!=null) ps.setTimestamp(psIdx++,new java.sql.Timestamp(end.getTime()));
            rs = ps.executeQuery();
            
            Planning planning;
            while(rs.next()){
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                
                planning.setContact(orContact);
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                
                vPlannings.add(planning);
            }
        }
        catch(Exception e){
        	e.printStackTrace();
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
        
        return vPlannings;
    }
    
    public static Vector searchFreeAppointments(String sUserUID,String sLocation,String sBegin,String sEnd,String sBeginHour,String sEndHour){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        java.util.Date begin = ScreenHelper.parseDate(sBegin);
        if(begin==null) {
        	return vPlannings;
        }
        java.util.Date end = ScreenHelper.parseDate(sEnd);
        int beginhour=0,endhour=23;
        try {
        	beginhour=Integer.parseInt(sBeginHour);
        } catch(Exception ei) {}
        try {
        	endhour=Integer.parseInt(sEndHour);
        } catch(Exception ei) {}
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT * FROM OC_PLANNING"+
                      " WHERE OC_PLANNING_PLANNEDDATE >= ?";
            if(end!=null){
                sSelect+= " AND OC_PLANNING_PLANNEDDATE < ?";
            }
            if(sUserUID.length() > 0){
                sSelect+= " AND OC_PLANNING_USERUID = ?";
            }
            if(sLocation.length() > 0){
                sSelect+= " AND OC_PLANNING_MODIFIERS like '%;%;%;%;%;%;%;"+sLocation+";%'";
            }
            sSelect+= " AND OC_PLANNING_CANCELATIONDATE IS NULL";
            sSelect+= " AND OC_PLANNING_MODIFIERS like '%;%;%;%;%;%;medwan.common.free;%' order by OC_PLANNING_PLANNEDDATE";

            ps = oc_conn.prepareStatement(sSelect);
            
            int psIdx = 1;
            ps.setTimestamp(psIdx++,new java.sql.Timestamp(begin.getTime()));
            if(end!=null) ps.setTimestamp(psIdx++,new java.sql.Timestamp(end.getTime()));
            if(sUserUID.length()>0) ps.setString(psIdx++, sUserUID);
            rs = ps.executeQuery();
            
            Planning planning;
            while(rs.next()){
            	//Now check the timeframe
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                
                planning.setContact(orContact);
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                if(beginhour<=planning.getPlannedDate().getHours() && endhour>planning.getPlannedDate().getHours()) {
                    vPlannings.add(planning);
                }
            }
        }
        catch(Exception e){
        	e.printStackTrace();
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
        
        return vPlannings;
    }
    
    //--- GET PATIENT FUTURE PLANNINGS ------------------------------------------------------------
    public static Vector getPatientFuturePlannings(String sPatientUID, String sDate){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT * FROM OC_PLANNING"+
                      " WHERE OC_PLANNING_PATIENTUID = ?"+
                      "  AND OC_PLANNING_PLANNEDDATE >= ?"+
                      "  AND OC_PLANNING_CANCELATIONDATE IS NULL"+
                      " ORDER BY OC_PLANNING_PLANNEDDATE ASC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sPatientUID);
            ps.setDate(2,ScreenHelper.getSQLDate(sDate));
            rs = ps.executeQuery();
            Planning planning;
            while(rs.next()){
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                planning.setContact(orContact);
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                vPlannings.add(planning);
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
        
        return vPlannings;
    }
    
    //--- GET PATIENT MISSED PLANNINGS ------------------------------------------------------------
    public static Vector getPatientMissedPlannings(String sPatientUID){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // today
            Calendar today = Calendar.getInstance();
            today.set(Calendar.HOUR,0);
            today.set(Calendar.MINUTE,0);
            today.set(Calendar.SECOND,0);
            today.set(Calendar.MILLISECOND,0);
            
            sSelect = "SELECT * FROM OC_PLANNING WHERE OC_PLANNING_PATIENTUID = ?"+
                      " AND OC_PLANNING_CANCELATIONDATE IS NULL"+
                      " AND OC_PLANNING_EFFECTIVEDATE IS NULL"+
                      " AND OC_PLANNING_PLANNEDDATE < ?"+
                      " ORDER BY OC_PLANNING_PLANNEDDATE DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sPatientUID);
            ps.setDate(2,new java.sql.Date(today.getTime().getTime())); // today
            rs = ps.executeQuery();
            Planning planning;
            while (rs.next()){
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                planning.setContact(orContact);
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                vPlannings.add(planning);
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
        return vPlannings;
    }
    
    //--- GET PATIENT MISSED PLANNINGS ------------------------------------------------------------
    public static Vector getPatientCanceledPlannings(String sPatientUID){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // today
            Calendar today = Calendar.getInstance();
            today.set(Calendar.HOUR,0);
            today.set(Calendar.MINUTE,0);
            today.set(Calendar.SECOND,0);
            today.set(Calendar.MILLISECOND,0);
            
            sSelect = "SELECT * FROM OC_PLANNING_HISTORY WHERE OC_PLANNING_PATIENTUID = ?"+
                      " AND OC_PLANNING_CANCELATIONDATE IS NOT NULL"+
                      " ORDER BY OC_PLANNING_PLANNEDDATE DESC";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sPatientUID);
            rs = ps.executeQuery();
            Planning planning;
            while (rs.next()){
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                planning.setContact(orContact);
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                vPlannings.add(planning);
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
        return vPlannings;
    }
    
    public static void storeRemindSent(String planningUid,java.util.Date remindSent){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("update oc_planning set OC_PLANNING_REMINDSENT=? where oc_planning_serverid=? and oc_planning_objectid=?");
        	ps.setTimestamp(1, new java.sql.Timestamp(remindSent.getTime()));
        	ps.setInt(2, Integer.parseInt(planningUid.split("\\.")[0]));
        	ps.setInt(3, Integer.parseInt(planningUid.split("\\.")[1]));
        	ps.execute();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    }
    
    public static void storeCancellationWarningSent(String planningUid,java.util.Date remindSent){
        PreparedStatement ps = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("update oc_planning set OC_PLANNING_CANCELLATIONWARNINGSENT=? where oc_planning_serverid=? and oc_planning_objectid=?");
        	ps.setTimestamp(1, new java.sql.Timestamp(remindSent.getTime()));
        	ps.setInt(2, Integer.parseInt(planningUid.split("\\.")[0]));
        	ps.setInt(3, Integer.parseInt(planningUid.split("\\.")[1]));
        	ps.execute();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    }
    
    public static boolean isAvailablePlannedDate(String sUserUid,java.util.Date start, java.util.Date end, String exclude){
        boolean bAvailable = true;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps = oc_conn.prepareStatement("select * from oc_planning where oc_planning_useruid=? and oc_planning_planneddate<? and oc_planning_plannedend>? and oc_planning_objectid<>?");
        	ps.setString(1, sUserUid);
        	ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
        	ps.setTimestamp(3, new java.sql.Timestamp(start.getTime()));
        	ps.setString(4,exclude.replaceAll("1\\.", ""));
        	rs=ps.executeQuery();
        	bAvailable=!rs.next();
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
    	return bAvailable;
    }
    public static boolean isAvailablePlannedDate(String sUserUID,String sPlannedDate,String sPlannedDateTime,
    		                                     String sPlanningUID,String sEstimatedtime){
        boolean bAvailable = true;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PLANNING WHERE OC_PLANNING_USERUID = ?"+
                             " AND OC_PLANNING_CANCELATIONDATE IS NULL";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sUserUID);
            rs = ps.executeQuery();
            Date dBegin = ScreenHelper.getSQLTime(sPlannedDate+" "+sPlannedDateTime),
                 dEnd   = ScreenHelper.getSQLTime(sPlannedDate+" "+sPlannedDateTime);
            Calendar calendar;
            String[] aTime;
            int iHour, iMinute;
            if(sEstimatedtime.length() > 0){
                aTime = sEstimatedtime.split(":");
                iHour = Integer.parseInt(aTime[0]);
                iMinute = Integer.parseInt(aTime[1]);
                calendar = Calendar.getInstance();
                calendar.setTime(dEnd);
                calendar.add(Calendar.HOUR,iHour);
                calendar.add(Calendar.MINUTE,iMinute);
                calendar.set(Calendar.SECOND,00);
                calendar.set(Calendar.MILLISECOND,00);
                dEnd = calendar.getTime();
            }
            
            String sTmpUID, sTmpDate, sTmpEstimatedTime;
            Date dTmpBegin,dTmpEnd;
            while(rs.next()){
                dTmpBegin = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                sTmpDate = ScreenHelper.getSQLDate(dTmpBegin);
                if(sTmpDate.equalsIgnoreCase(sPlannedDate)){
                    sTmpUID = rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID");
                    if(!sTmpUID.equalsIgnoreCase(sPlanningUID)){
                        sTmpEstimatedTime = ScreenHelper.checkString(rs.getString("OC_PLANNING_ESTIMATIONTIME"));
                        dTmpEnd = dTmpBegin;
                        if(sTmpEstimatedTime.length() > 0){
                            aTime = sTmpEstimatedTime.split(":");
                            iHour = Integer.parseInt(aTime[0]);
                            iMinute = Integer.parseInt(aTime[1]);
                            calendar = Calendar.getInstance();
                            calendar.setTime(dTmpEnd);
                            calendar.add(Calendar.HOUR,iHour);
                            calendar.add(Calendar.MINUTE,iMinute);
                            calendar.set(Calendar.SECOND,00);
                            calendar.set(Calendar.MILLISECOND,00);
                            dTmpEnd = calendar.getTime();
                        }
                        if((dTmpBegin.getTime() < dEnd.getTime()) && (dTmpEnd.getTime() > dBegin.getTime())){
                            bAvailable = false;
                        }
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
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return bAvailable;
    }
    
    //--- GET USER PLANNINGS ----------------------------------------------------------------------
    public static Vector getUserPlannings(String sUserUID){
        return getUserPlannings(sUserUID,null,null);    	
    }
    
    public static Vector getResourcePlannings(String sResourceUid,Date begin, Date end){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_RESERVATIONS"+
                             " WHERE OC_RESERVATION_RESOURCEUID = ?"+
                             "  AND OC_RESERVATION_BEGIN >= ?"+
            		         "  AND OC_RESERVATION_BEGIN < ?"+
                             "  AND OC_RESERVATION_PLANNINGUID not like '0.%'"+
                             " ORDER BY OC_RESERVATION_BEGIN";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sResourceUid);
            ps.setTimestamp(2,new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(3,new java.sql.Timestamp(end.getTime()));
            rs = ps.executeQuery();
            
            Planning planning;
            while(rs.next()){
            	String puid = rs.getString("OC_RESERVATION_PLANNINGUID");
                planning = Planning.get(puid);
                planning.plannedDate = rs.getTimestamp("OC_RESERVATION_BEGIN");
                java.util.Date enddate = rs.getTimestamp("OC_RESERVATION_END");
                long duration = enddate.getTime()-planning.plannedDate.getTime();
                planning.estimatedtime = new SimpleDateFormat("HH:mm").format(new java.util.Date(duration));
                planning.description = sResourceUid;
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                vPlannings.add(planning);
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
                e.printStackTrace();
            }
        }
        
        return vPlannings;
    }
    
    public static Vector getUserPlannings(String sUserUID,Date begin,Date end){
        Vector vPlannings = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PLANNING"+
                             " WHERE OC_PLANNING_USERUID = ?"+
                             "  AND OC_PLANNING_PLANNEDDATE >= ?"+
            		         "  AND OC_PLANNING_PLANNEDDATE < ?"+
                             "  AND OC_PLANNING_CANCELATIONDATE IS NULL"+
                             " ORDER BY OC_PLANNING_PLANNEDDATE";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sUserUID);
            ps.setTimestamp(2,new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(3,new java.sql.Timestamp(end.getTime()));
            rs = ps.executeQuery();
            
            Planning planning;
            while(rs.next()){
                planning = new Planning();
                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
                planning.userUID = rs.getString("OC_PLANNING_USERUID");
                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
                
                ObjectReference orContact = new ObjectReference();
                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
                
                planning.setContact(orContact);
                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
                planning.comment = rs.getString("OC_PLANNING_COMMENT");
                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
                vPlannings.add(planning);
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
        
        return vPlannings;
    }
    
    public static Vector getServicePlannings(String sServiceUid,Date begin,Date end){
        Vector vPlannings = new Vector();
        if(sServiceUid!=null && sServiceUid.length()>0){
	        PreparedStatement ps = null;
	        ResultSet rs = null;
	        
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        try{
	            String sSelect = "SELECT * FROM OC_PLANNING"+
	                             " WHERE OC_PLANNING_SERVICEUID = ?"+
	                             "  AND OC_PLANNING_PLANNEDDATE >= ?"+
	            		         "  AND OC_PLANNING_PLANNEDDATE < ?"+
	                             "  AND OC_PLANNING_CANCELATIONDATE IS NULL"+
	                             " ORDER BY OC_PLANNING_PLANNEDDATE";
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setString(1,sServiceUid);
	            ps.setTimestamp(2,new java.sql.Timestamp(begin.getTime()));
	            ps.setTimestamp(3,new java.sql.Timestamp(end.getTime()));
	            rs = ps.executeQuery();
	            
	            Planning planning;
	            while(rs.next()){
	                planning = new Planning();
	                planning.setUid(rs.getInt("OC_PLANNING_SERVERID")+"."+rs.getInt("OC_PLANNING_OBJECTID"));
	                planning.patientUID = rs.getString("OC_PLANNING_PATIENTUID");
	                planning.userUID = rs.getString("OC_PLANNING_USERUID");
	                planning.plannedDate = rs.getTimestamp("OC_PLANNING_PLANNEDDATE");
	                planning.effectiveDate = rs.getTimestamp("OC_PLANNING_EFFECTIVEDATE");
	                planning.cancelationDate = rs.getTimestamp("OC_PLANNING_CANCELATIONDATE");
	                planning.estimatedtime = rs.getString("OC_PLANNING_ESTIMATIONTIME");
	                planning.confirmationDate = rs.getTimestamp("OC_PLANNING_CONFIRMATIONDATE");
	                
	                ObjectReference orContact = new ObjectReference();
	                orContact.setObjectType(rs.getString("OC_PLANNING_CONTACTTYPE"));
	                orContact.setObjectUid(rs.getString("OC_PLANNING_CONTACTUID"));
	                
	                planning.setContact(orContact);
	                planning.description = rs.getString("OC_PLANNING_DESCRIPTION");
	                planning.comment = rs.getString("OC_PLANNING_COMMENT");
	                planning.transactionUID = rs.getString("OC_PLANNING_TRANSACTIONUID");
	                planning.setCreateDateTime(rs.getTimestamp("OC_PLANNING_CREATETIME"));
	                planning.setUpdateDateTime(rs.getTimestamp("OC_PLANNING_UPDATETIME"));
	                planning.setUpdateUser(rs.getString("OC_PLANNING_UPDATEUID"));
	                planning.setVersion(rs.getInt("OC_PLANNING_VERSION"));
	                planning.setContextID(rs.getString("OC_PLANNING_CONTEXTID"));
	                planning.setServiceUid(rs.getString("OC_PLANNING_SERVICEUID"));
	                planning.setModifiers(rs.getString("OC_PLANNING_MODIFIERS"));
	                planning.setPlannedEndDate(rs.getTimestamp("OC_PLANNING_PLANNEDEND"));
                    planning.setRemindSent(rs.getTimestamp("OC_PLANNING_REMINDSENT"));
                    planning.setCancellationWarningSent(rs.getTimestamp("OC_PLANNING_CANCELLATIONWARNINGSENT"));
	                vPlannings.add(planning);
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
        return vPlannings;
    }
    
    //--- GET PLANNINGS PERMISSION USERS ----------------------------------------------------------
    public static Hashtable getPlanningPermissionUsers(String sUserID){
        String sSelect = "SELECT * FROM UserParameters"+
                         " WHERE parameter = 'PlanningFindUserIDs'"+
                         "  AND value LIKE '%"+sUserID+"%'";
        PreparedStatement ps = null;
        ResultSet rs = null;
        Hashtable hUsers = new Hashtable();
        
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            rs = ps.executeQuery();
            String sTmpUserID;
            hUsers.put(ScreenHelper.getFullUserName(sUserID,ad_conn),sUserID);
            while(rs.next()){
                sTmpUserID = rs.getString("userid");
                hUsers.put(ScreenHelper.getFullUserName(sTmpUserID,ad_conn),sTmpUserID);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        
        return hUsers;
    }
    
    public static void doMaintenance(){
        Debug.println("Running planning maintenance query");
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        PreparedStatement ps = null;
        try{
        	long day=24*3600*1000;
            String sSelect = 	" select * from OC_PLANNING where"+
					" OC_PLANNING_CANCELLATIONWARNINGSENT is null and"+
					" OC_PLANNING_CONFIRMATIONDATE<? and ("+
					" select sum(oc_debet_amount) total from oc_patientinvoices,oc_debets where"+
					" oc_debet_patientinvoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)"+
					" - "+
					" (select sum(oc_patientcredit_amount) total from oc_patientinvoices,oc_patientcredits where"+
					" oc_patientcredit_type='patient.payment' and"+
					" oc_patientcredit_invoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)>"+MedwanQuery.getInstance().getConfigInt("acceptableOpenBalanceForPlanningConfirmation",0);
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()+2*day));
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
            	//Warn patient that his appointment will be canceled if he does not manage to pay before the confirmationdate
				String patientid=rs.getString("oc_planning_patientuid");
				String planninguid = rs.getInt("oc_PLANNING_SERVERID")+"."+rs.getInt("oc_PLANNING_OBJECTID");
				AdminPerson patient = AdminPerson.getAdminPerson(patientid);
            	Debug.println("Warn patient "+patient.getFullName()+" of possible appointment cancellation");
				if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeCancelingAppointmentEmail",0)==1){
					String sendto=patient.getActivePrivate().email;
					Debug.println("Send appointment cancellation warning by e-mail to "+sendto);
					if(MessageNotifier.validateEmailValue(sendto)!=null){
						Debug.println("E-mail address "+sendto+" is valid");
						String sResult = ScreenHelper.getTranNoLink("web", "patientappointmentcancellationemailcontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
						sResult=sResult.replaceAll("#patientname#", patient.getFullName());
						sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
						sResult=sResult.replaceAll("#paymentdeadline#", new SimpleDateFormat("dd/MM/yyyy").format(rs.getTimestamp("oc_planning_confirmationdate")));
						MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "simplemail", sResult, sendto, "appointmentreminder", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
						Planning.storeCancellationWarningSent(planninguid, new java.util.Date());
					}
					else{
						Debug.println("E-mail address "+sendto+" is NOT valid");
					}
				}
				if(MedwanQuery.getInstance().getConfigInt("warnPatientBeforeCancelingAppointmentSMS",0)==1){
					String sendto =patient.getActivePrivate().mobile;
					Debug.println("Send appointment cancellation warning by sms to "+sendto);
					if(MessageNotifier.validateSMSValue(sendto)!=null){
						Debug.println("SMS number "+sendto+" is valid");
						String sResult = MedwanQuery.getInstance().getLabel("web", "patientappointmentcancellationsmscontent", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
						sResult=sResult.replaceAll("#patientname#", patient.getFullName());
						sResult=sResult.replaceAll("#appointmentdate#", new SimpleDateFormat("dd/MM/yyyy HH:mm").format(rs.getTimestamp("oc_planning_planneddate")));
						sResult=sResult.replaceAll("#paymentdeadline#", new SimpleDateFormat("dd/MM/yyyy").format(rs.getTimestamp("oc_planning_confirmationdate")));
						MessageNotifier.SpoolMessage(MedwanQuery.getInstance().getOpenclinicCounter("OC_MESSAGES"), "sms", sResult, sendto, "appointmentreminder", MedwanQuery.getInstance().getConfigString("warnPatientBeforeScheduledAppointmentLanguage","en"));
						Planning.storeCancellationWarningSent(planninguid, new java.util.Date());
					}
				}
            }
            rs.close();
            ps.close();
            sSelect = 	" update OC_PLANNING set OC_PLANNING_CANCELATIONDATE=OC_PLANNING_CONFIRMATIONDATE,OC_PLANNING_CONFIRMATIONDATE=null where"+
					" OC_PLANNING_CONFIRMATIONDATE<? and ("+
					" select sum(oc_debet_amount) total from oc_patientinvoices,oc_debets where"+
					" oc_debet_patientinvoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)"+
					" - "+
					" (select sum(oc_patientcredit_amount) total from oc_patientinvoices,oc_patientcredits where"+
					" oc_patientcredit_type='patient.payment' and"+
					" oc_patientcredit_invoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)>"+MedwanQuery.getInstance().getConfigInt("acceptableOpenBalanceForPlanningConfirmation",0);
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.executeUpdate();
            ps.close();
            sSelect = 	" update OC_PLANNING set OC_PLANNING_CONFIRMATIONDATE=null where"+
					" OC_PLANNING_CONFIRMATIONDATE<? and ("+
					" select sum(oc_debet_amount) total from oc_patientinvoices,oc_debets where"+
					" oc_debet_patientinvoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)"+
					" - "+
					" (select sum(oc_patientcredit_amount) total from oc_patientinvoices,oc_patientcredits where"+
					" oc_patientcredit_type='patient.payment' and"+
					" oc_patientcredit_invoiceuid="+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_serverid")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","oc_patientinvoice_objectid")+" and"+
					" oc_patientinvoice_patientuid=OC_PLANNING_PATIENTUID)<="+MedwanQuery.getInstance().getConfigInt("acceptableOpenBalanceForPlanningConfirmation",0);
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()+day));
            ps.executeUpdate();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
    			oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    	
    }
    
    //--- DELETE ----------------------------------------------------------------------------------
    public static void delete(String sPlanningUID){
        if((sPlanningUID!=null) && (sPlanningUID.length() > 0)){
            Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
            
            String[] ids = sPlanningUID.split("\\.");
            if(ids.length==2){
            	copyToHistory(sPlanningUID);
                PreparedStatement ps = null;
                String sSelect = "DELETE FROM OC_PLANNING WHERE OC_PLANNING_SERVERID = ?"+
                                 " AND OC_PLANNING_OBJECTID = ?";
                try{
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }
                finally{
                    try{
                        if(ps!=null) ps.close();
            			oc_conn.close();
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                }
            }
        }
    }
    
}