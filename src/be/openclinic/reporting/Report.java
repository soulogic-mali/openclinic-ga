package be.openclinic.reporting;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.OC_Object;

public class Report extends OC_Object{
	private String name;
	private String reportxml;
	private String inputxml;
	private String group;
	private String profiles;
	
	public String getProfiles() {
		return profiles;
	}
	public void setProfiles(String profiles) {
		this.profiles = profiles;
	}
	public String getGroup() {
		return group;
	}
	public void setGroup(String group) {
		this.group = group;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getReportxml() {
		return reportxml;
	}
	public void setReportxml(String reportxml) {
		this.reportxml = reportxml;
	}
	public String getInputxml() {
		return inputxml;
	}
	public void setInputxml(String inputxml) {
		this.inputxml = inputxml;
	}
	
	public void delete(){
		delete(getUid());
	}
	
	public static void delete(String uid){
        PreparedStatement ps = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery = "DELETE FROM OC_REPORTS where OC_REPORT_SERVERID=? and OC_REPORT_OBJECTID=?";
            ps = oc_conn.prepareStatement(sQuery);
            String [] ids = uid.split("\\.");
            ps.setInt(1,Integer.parseInt(ids[0]));
            ps.setInt(2,Integer.parseInt(ids[1]));
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
            catch(SQLException e){
                e.printStackTrace();
            }
        }
	}
	
	public static Vector getAll(){
		Vector reports=new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery = "SELECT * FROM OC_REPORTS order by OC_REPORT_NAME ASC";
            ps = oc_conn.prepareStatement(sQuery);
            rs = ps.executeQuery();

            while(rs.next()){
            	Report report = new Report();
            	report=new Report();
                report.setUid(rs.getString("OC_REPORT_SERVERID")+"."+rs.getString("OC_REPORT_OBJECTID"));
                report.setName(rs.getString("OC_REPORT_NAME"));
                report.setReportxml(rs.getString("OC_REPORT_REPORTXML"));
                report.setInputxml(rs.getString("OC_REPORT_INPUTXML"));
                report.setGroup(rs.getString("OC_REPORT_GROUP"));
                report.setProfiles(rs.getString("OC_REPORT_PROFILES"));
                reports.add(report);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                if(rs!=null) rs.close();
                oc_conn.close();
            }
            catch(SQLException e){
                e.printStackTrace();
            }
        }
		return reports;
	}
	
    public static Report get(String uid){
        if ((uid!=null)&&(uid.length()>0)){
            String [] ids = uid.split("\\.");
            if (ids.length==2){
                return get(Integer.parseInt(ids[0]),Integer.parseInt(ids[1]));
            }
        }
        return null;
    }

    public static Report get(int serverid, int objectid){
		Report report=null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sQuery = "SELECT * FROM OC_REPORTS"+
                            " WHERE OC_REPORT_SERVERID=? AND OC_REPORT_OBJECTID=?";
            ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,serverid);
            ps.setInt(2,objectid);
            rs = ps.executeQuery();

            if(rs.next()){
            	report=new Report();
                report.setUid(serverid+"."+objectid);
                report.setName(rs.getString("OC_REPORT_NAME"));
                report.setReportxml(rs.getString("OC_REPORT_REPORTXML"));
                report.setInputxml(rs.getString("OC_REPORT_INPUTXML"));
                report.setGroup(rs.getString("OC_REPORT_GROUP"));
                report.setProfiles(rs.getString("OC_REPORT_PROFILES"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                if(rs!=null) rs.close();
                oc_conn.close();
            }
            catch(SQLException e){
                e.printStackTrace();
            }
        }

		return report;
	}
    
    public boolean store(){
    	boolean bSuccess=false;
        PreparedStatement ps = null;
        ResultSet rs = null;
        if(this.getUid()==null || this.getUid().length()==0 || this.getUid().split("\\.").length<2){
        	this.setUid(MedwanQuery.getInstance().getConfigString("serverId")+"."+MedwanQuery.getInstance().getOpenclinicCounter("OC_REPORT_OBJECTID"));
        }
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
        	ps=oc_conn.prepareStatement("delete from OC_REPORTS where OC_REPORT_SERVERID=? and OC_REPORT_OBJECTID=?");
        	ps.setInt(1, Integer.parseInt(this.getUid().split("\\.")[0]));
        	ps.setInt(2, Integer.parseInt(this.getUid().split("\\.")[1]));
        	ps.execute();
        	ps.close();
        	ps=oc_conn.prepareStatement("insert into OC_REPORTS(OC_REPORT_SERVERID,"
        			+ " OC_REPORT_OBJECTID,"
        			+ " OC_REPORT_NAME,"
        			+ " OC_REPORT_REPORTXML,"
        			+ " OC_REPORT_GROUP,"
        			+ " OC_REPORT_PROFILES,"
        			+ " OC_REPORT_INPUTXML)"
        			+ "values(?,?,?,?,?,?,?)");
        	ps.setInt(1, Integer.parseInt(this.getUid().split("\\.")[0]));
        	ps.setInt(2, Integer.parseInt(this.getUid().split("\\.")[1]));
        	ps.setString(3, this.getName());
        	ps.setString(4, this.getReportxml());
        	ps.setString(5, this.getGroup());
        	ps.setString(6, this.getProfiles());
        	ps.setString(7, this.getInputxml());
        	ps.execute();
        	bSuccess=true;
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(ps!=null) ps.close();
                if(rs!=null) rs.close();
                oc_conn.close();
            }
            catch(SQLException e){
                e.printStackTrace();
            }
        }
        return bSuccess;
    }
	
}
