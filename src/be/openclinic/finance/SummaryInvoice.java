package be.openclinic.finance;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;
import net.admin.AdminPerson;

public class SummaryInvoice extends OC_Object{
	private java.util.Date date;
	private int patientUid;
	private String status;
	private String validated;
	private String comment;
	private Vector items=new Vector();
	private Vector patientinvoices=null;
	
	public void setPatientinvoices(Vector patientinvoices) {
		this.patientinvoices = patientinvoices;
	}

	public Vector getItems() {
		return items;
	}

	public void setItems(Vector items) {
		this.items = items;
	}
	
	public static Vector getSummarizedInvoices(String sPatientUid){
		Vector invoices = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			ps=conn.prepareStatement("select * from OC_SUMMARYINVOICES where OC_SUMMARYINVOICE_PATIENTUID=? order by OC_SUMMARYINVOICE_DATE DESC,OC_SUMMARYINVOICE_OBJECTID DESC");
			ps.setString(1, sPatientUid);
			rs=ps.executeQuery();
	        while(rs.next()){
	        	SummaryInvoice summaryInvoice=new SummaryInvoice();
				summaryInvoice.setUid(rs.getInt("oc_summaryinvoice_serverid")+"."+rs.getInt("oc_summaryinvoice_objectid"));
				summaryInvoice.setDate(rs.getTimestamp("oc_summaryinvoice_date"));
				summaryInvoice.setPatientUid(rs.getInt("oc_summaryinvoice_patientuid"));
				summaryInvoice.setStatus(rs.getString("oc_summaryinvoice_status"));
				summaryInvoice.setValidated(rs.getString("oc_summaryinvoice_validated"));
				summaryInvoice.setComment(rs.getString("oc_summaryinvoice_comment"));
				summaryInvoice.setUpdateDateTime(rs.getTimestamp("oc_summaryinvoice_updatedatetime"));
				summaryInvoice.setCreateDateTime(rs.getTimestamp("oc_summaryinvoice_createdatetime"));
				summaryInvoice.setUpdateUser(rs.getString("oc_summaryinvoice_updateuid"));
				summaryInvoice.setVersion(rs.getInt("oc_summaryinvoice_version"));
				//Now we also load the items
				PreparedStatement ps2=conn.prepareStatement("select distinct oc_item_patientinvoiceuid from oc_summaryinvoiceitems where oc_item_summaryinvoiceuid=?");
				ps2.setString(1, summaryInvoice.getUid());
				ResultSet rs2=ps2.executeQuery();
				while(rs2.next()){
					summaryInvoice.getItems().add(rs2.getString("oc_item_patientinvoiceuid"));
				}
				rs2.close();
				ps2.close();
				invoices.add(summaryInvoice);
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
		return invoices;
	}

	public static Vector getUnsummarizedPatientInvoices(String sPatientUid){
		Vector invoices = new Vector();
        PatientInvoice patientInvoice;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			String sQuery="select * from OC_PATIENTINVOICES where OC_PATIENTINVOICE_PATIENTUID=? and not exists (select * from OC_SUMMARYINVOICEITEMS where OC_ITEM_PATIENTINVOICEUID="+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_SERVERID")+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar", "OC_PATIENTINVOICE_OBJECTID")+") ORDER BY OC_PATIENTINVOICE_DATE";
			ps=conn.prepareStatement(sQuery);
			ps.setString(1, sPatientUid);
			rs=ps.executeQuery();
	        while(rs.next()){
	            patientInvoice = new PatientInvoice();
	            patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
	            patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
	            patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
	            patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
	            patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
	            patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
	            patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
	            patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
	            patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
	            patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
	            patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
	            patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
	            patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
	            patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
	            patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
	            patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));   
	            patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));
                patientInvoice.debets = Debet.getPatientDebetsViaInvoiceUid(patientInvoice.getPatientUid(),patientInvoice.getUid());
                patientInvoice.credits = PatientCredit.getPatientCreditsViaInvoiceUID(patientInvoice.getUid());
	            invoices.add(patientInvoice);
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
		return invoices;
	}
	
	public Vector getPatientInvoices(String insuranceUid){
		Vector subpatientinvoices=new Vector();
		for(int n=0;n<getItems().size();n++){
			PatientInvoice invoice = PatientInvoice.get((String)this.getItems().elementAt(n));
			if(invoice!=null && invoice.hasValidUid()){
				Vector debets = invoice.getDebets();
				for (int p=0;p<debets.size();p++){
					Debet debet = (Debet)debets.elementAt(p);
					if(debet!=null && debet.getPatientInvoiceUid()!=null && ScreenHelper.checkString(debet.getInsuranceUid()).equalsIgnoreCase(ScreenHelper.checkString(insuranceUid))){
						subpatientinvoices.add(invoice);
						break;
					}
				}
			}
		}
		return subpatientinvoices;
	}
	
	public Vector getPatientInvoices(){
		if(patientinvoices==null){
			patientinvoices=new Vector();
			for(int n=0;n<getItems().size();n++){
				PatientInvoice invoice = PatientInvoice.get((String)this.getItems().elementAt(n));
				if(invoice!=null && invoice.hasValidUid()){
					patientinvoices.add(invoice);
				}
			}
		}
		return patientinvoices;
	}
	
	public Hashtable getConsolidatedDebets(){
		Hashtable consolidatedDebets = new Hashtable();
		for(int n=0;n<getPatientInvoices().size();n++){
			PatientInvoice invoice = (PatientInvoice)getPatientInvoices().elementAt(n);
			for(int d=0;d<invoice.getDebets().size();d++){
				Debet debet = (Debet)invoice.getDebets().elementAt(d);
				if(debet !=null && debet.hasValidUid()){
					String consolidatedDebetUid=debet.getPrestationUid()+";"+debet.getEncounterUid()+";"+debet.getInsuranceUid()+";"+ScreenHelper.checkString(debet.getExtraInsurarUid())+";"+ScreenHelper.checkString(debet.getExtraInsurarUid2());
					if(consolidatedDebets.get(consolidatedDebetUid)==null){
						consolidatedDebets.put(consolidatedDebetUid, new ConsolidatedDebet());
					}
					ConsolidatedDebet cDebet = (ConsolidatedDebet)consolidatedDebets.get(consolidatedDebetUid);
					cDebet.addDebet(debet);
				}
			}
		}
		return consolidatedDebets;
	}
	
    public Vector getDebetsForInsurance(String sInsuranceUid) {
		Vector d = new Vector();
		for(int n=0;n<getPatientInvoices().size();n++){
			PatientInvoice invoice = (PatientInvoice)getPatientInvoices().elementAt(n);
			for(int e=0;e<invoice.getDebets().size();e++){
				Debet debet = (Debet)invoice.getDebets().elementAt(e);
				if(debet !=null && debet.hasValidUid() && sInsuranceUid.equalsIgnoreCase(debet.getInsuranceUid())){
					d.add(debet);
				}
			}
		}
        return d;
    }
    
    public String getPatientInvoiceNumbers(){
    	String s = "";
    	SortedSet ss = new TreeSet();
		for(int n=0;n<getPatientInvoices().size();n++){
			ss.add(((PatientInvoice)getPatientInvoices().elementAt(n)).getInvoiceNumber());
		}
		Iterator iSs=ss.iterator();
		while(iSs.hasNext()){
			if(s.length()>0){
				s+=", ";
			}
			s+=iSs.next();
		}
		return s;
    }
    
    public Vector getAllDebets(){
		Vector allDebets = new Vector();
		for(int n=0;n<getPatientInvoices().size();n++){
			PatientInvoice invoice = (PatientInvoice)getPatientInvoices().elementAt(n);
			for(int d=0;d<invoice.getDebets().size();d++){
				Debet debet = (Debet)invoice.getDebets().elementAt(d);
				allDebets.add(debet);
			}
		}
		return allDebets;
    }

    public String getServicesAsString(String language){
 	   String service="";
 	   try{
 		   HashSet services = new HashSet();
 		   Vector debets = getAllDebets();
 		   for(int n=0;n<debets.size();n++){
 			   Debet debet = (Debet)debets.elementAt(n);
 			   if(ScreenHelper.checkString(debet.getServiceUid()).length()>0){
 				   services.add(debet.getServiceUid());
 			   }
 			   else if(debet.getEncounter()!=null && ScreenHelper.checkString(debet.getEncounter().getServiceUID()).length()>0){
 				   services.add(debet.getEncounter().getServiceUID());
 			   }
 		   }
 		   Iterator hs = services.iterator();
 		   while(hs.hasNext()){
 			   if(service.length()>0){
 				   service+=", ";
 			   }
 			   service+=ScreenHelper.getTran(null,"service", (String)hs.next(), language);
 		   }
 	   }
 	   catch(Exception e){
 		   e.printStackTrace();
 	   }
 	   return service;
    }
    
    public String getServicesAsString(Vector debets, String language){
 	   String service="";
 	   HashSet services = new HashSet();
 	   for(int n=0;n<debets.size();n++){
 		   Debet debet = (Debet)debets.elementAt(n);
 		   if(ScreenHelper.checkString(debet.getServiceUid()).length()>0){
 			   services.add(debet.getServiceUid());
 		   }
 	   }
 	   Iterator hs = services.iterator();
 	   while(hs.hasNext()){
 		   if(service.length()>0){
 			   service+=", ";
 		   }
 		   service+=ScreenHelper.getTran(null,"service", (String)hs.next(), language);
 	   }
 	   return service;
    }
    
    public double getBalance(){
    	double balance=0;
    	Vector invoices = getPatientInvoices();
    	for(int n=0;n<invoices.size();n++){
    		PatientInvoice invoice = (PatientInvoice)invoices.elementAt(n);
    		balance+=invoice.getBalance();
    	}
    	return balance;
    }
    
	public Hashtable getConsolidatedCredits(){
		Hashtable consolidatedCredits = new Hashtable();
		for(int n=0;n<getPatientInvoices().size();n++){
			PatientInvoice invoice = (PatientInvoice)getPatientInvoices().elementAt(n);
			for(int d=0;d<invoice.getCredits().size();d++){
				PatientCredit credit = PatientCredit.get((String)invoice.getCredits().elementAt(d));
				if(credit !=null && credit.hasValidUid()){
					if(consolidatedCredits.get(credit.getUid())==null){
						consolidatedCredits.put(credit.getUid(), credit.getUid());
					}
				}
			}
		}
		return consolidatedCredits;
	}
	
	public String getInvoiceUid(){
		if(hasValidUid()){
			return getUid().split("\\.")[1];
		}
		else{
			return "";
		}
	}
	
	public String getInsuranceReferences(){
		String sReferences="";
		Vector v = getPatientInvoices();
		for(int n=0;n<v.size();n++){
			PatientInvoice patientInvoice = (PatientInvoice)v.elementAt(n);
			if(ScreenHelper.checkString(patientInvoice.getInsurarreference()).length()>0 && sReferences.indexOf(patientInvoice.getInsurarreference())<0){
				if(sReferences.length()>0){
					sReferences+=", ";
				}
				sReferences+=patientInvoice.getInsurarreference();
			}
		}
		return sReferences;
	}
	
	public Vector getDebets(){
		Hashtable consolidatedDebets=getConsolidatedDebets();
		Vector v = new Vector();
		Enumeration hDebets = consolidatedDebets.keys();
		while(hDebets.hasMoreElements()){
			v.add(consolidatedDebets.get(hDebets.nextElement()));
		}
		return v;
	}
	
	public Vector getCredits(){
		Hashtable consolidatedCredits=getConsolidatedCredits();
		Vector v = new Vector();
		Enumeration hCredits = consolidatedCredits.keys();
		while(hCredits.hasMoreElements()){
			v.add(consolidatedCredits.get(hCredits.nextElement()));
		}
		return v;
	}
	
	public static SummaryInvoice get(String uid){
        String [] ids = uid.split("\\.");
        if(ids.length==1){
        	uid=MedwanQuery.getInstance().getConfigString("serverId")+"."+uid;
            ids = uid.split("\\.");
        }
		SummaryInvoice summaryInvoice = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try{
			if(uid!=null && uid.split("\\.").length==2){
				ps=conn.prepareStatement("select * from oc_summaryinvoices where oc_summaryinvoice_serverid=? and oc_summaryinvoice_objectid=?");
				ps.setInt(1, Integer.parseInt(uid.split("\\.")[0]));
				ps.setInt(2, Integer.parseInt(uid.split("\\.")[1]));
				rs=ps.executeQuery();
				if(rs.next()){
					summaryInvoice=new SummaryInvoice();
					summaryInvoice.setUid(uid);
					summaryInvoice.setDate(rs.getTimestamp("oc_summaryinvoice_date"));
					summaryInvoice.setPatientUid(rs.getInt("oc_summaryinvoice_patientuid"));
					summaryInvoice.setStatus(rs.getString("oc_summaryinvoice_status"));
					summaryInvoice.setValidated(rs.getString("oc_summaryinvoice_validated"));
					summaryInvoice.setComment(rs.getString("oc_summaryinvoice_comment"));
					summaryInvoice.setUpdateDateTime(rs.getTimestamp("oc_summaryinvoice_updatedatetime"));
					summaryInvoice.setCreateDateTime(rs.getTimestamp("oc_summaryinvoice_createdatetime"));
					summaryInvoice.setUpdateUser(rs.getString("oc_summaryinvoice_updateuid"));
					summaryInvoice.setVersion(rs.getInt("oc_summaryinvoice_version"));
					//Now we also load the items
					PreparedStatement ps2=conn.prepareStatement("select distinct oc_item_patientinvoiceuid from oc_summaryinvoiceitems where oc_item_summaryinvoiceuid=?");
					ps2.setString(1, summaryInvoice.getUid());
					ResultSet rs2=ps2.executeQuery();
					while(rs2.next()){
						summaryInvoice.getItems().add(rs2.getString("oc_item_patientinvoiceuid"));
					}
					rs2.close();
					ps2.close();
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
		return summaryInvoice;
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			if(this.getUid()!=null && this.getUid().split("\\.").length==2){
				ps=conn.prepareStatement("delete from oc_summaryinvoices where oc_summaryinvoice_serverid=? and oc_summaryinvoice_objectid=?");
				ps.setInt(1, Integer.parseInt(this.getUid().split("\\.")[0]));
				ps.setInt(2, Integer.parseInt(this.getUid().split("\\.")[1]));
				ps.execute();
				ps.close();
				ps=conn.prepareStatement("delete from oc_summaryinvoiceitems where oc_item_summaryinvoiceuid=?");
				ps.setString(1, this.getUid());
				ps.execute();
				ps.close();
			}
			else{
				this.setUid(MedwanQuery.getInstance().getConfigString("serverId","1")+"."+MedwanQuery.getInstance().getOpenclinicCounter("OC_SUMMARYINVOICE_OBJECTID"));
			}
			ps=conn.prepareStatement("insert into oc_summaryinvoices (OC_SUMMARYINVOICE_SERVERID,"
					+ "OC_SUMMARYINVOICE_OBJECTID,"
					+ "OC_SUMMARYINVOICE_DATE,"
					+ "OC_SUMMARYINVOICE_PATIENTUID,"
					+ "OC_SUMMARYINVOICE_STATUS,"
					+ "OC_SUMMARYINVOICE_VALIDATED,"
					+ "OC_SUMMARYINVOICE_COMMENT,"
					+ "OC_SUMMARYINVOICE_UPDATEUID,"
					+ "OC_SUMMARYINVOICE_UPDATEDATETIME,"
					+ "OC_SUMMARYINVOICE_CREATEDATETIME,"
					+ "OC_SUMMARYINVOICE_VERSION)"
					+ " values(?,?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, MedwanQuery.getInstance().getConfigInt("serverId",1));
			ps.setInt(2, Integer.parseInt(this.getUid().split("\\.")[1]));
			ps.setTimestamp(3, new java.sql.Timestamp(this.getDate().getTime()));
			ps.setInt(4, this.getPatientUid());
			ps.setString(5, this.getStatus());
			ps.setString(6, this.getValidated());
			ps.setString(7, this.getComment());
			ps.setString(8, this.getUpdateUser());
			ps.setTimestamp(9, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setTimestamp(10, new java.sql.Timestamp(this.getCreateDateTime()==null?new java.util.Date().getTime():this.getCreateDateTime().getTime()));
			ps.setInt(11, this.getVersion()+1);
			ps.execute();
			ps.close();
			for(int n=0;n<getItems().size();n++){
				ps=conn.prepareStatement("insert into oc_summaryinvoiceitems(oc_item_summaryinvoiceuid,oc_item_patientinvoiceuid) values (?,?)");
				ps.setString(1, this.getUid());
				ps.setString(2, (String)this.getItems().elementAt(n));
				ps.execute();
				ps.close();
			}
			this.setPatientinvoices(null);
		}
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
	}
	
	public java.util.Date getDate() {
		return date;
	}
	public void setDate(java.util.Date date) {
		this.date = date;
	}
	public int getPatientUid() {
		return patientUid;
	}
	
	public AdminPerson getPatient(){
		if(getPatientUid()>0){
			AdminPerson person = AdminPerson.getAdminPerson(getPatientUid()+"");
			return person;
		}
		return null;
	}
	public void setPatientUid(int patientUid) {
		this.patientUid = patientUid;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getValidated() {
		return validated;
	}
	public void setValidated(String validated) {
		this.validated = validated;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
}
