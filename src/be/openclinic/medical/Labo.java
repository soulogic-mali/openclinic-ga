package be.openclinic.medical;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Hashtable;
import java.util.Vector;

/**
 * Created by IntelliJ IDEA.
 * User: mxs-rudy
 * Date: 20-mrt-2007
 * Time: 16:45:12
 * To change this template use File | Settings | File Templates.
 */
public class Labo {
    public static Hashtable getLabRequestDefaultData(String sCode,String language){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sLowerLabelType = MedwanQuery.getInstance().getConfigParam("lowerCompare", "l.OC_LABEL_TYPE");

        StringBuffer sSelect = new StringBuffer();
        sSelect.append("SELECT la.labtype,la.monster,l.OC_LABEL_VALUE")
                    .append(" FROM LabAnalysis la, OC_LABELS l")
                    .append(" WHERE "+ MedwanQuery.getInstance().convert("varchar(255)","la.labID")+" = l.OC_LABEL_ID")
                    .append("  AND l.oc_label_type = 'labanalysis'")
                    .append("  AND la.labcode = ? and l.OC_LABEL_LANGUAGE=? and la.deletetime is null");

        Hashtable hDefaultData = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect.toString());
            ps.setString(1, sCode);
            ps.setString(2, language);
            rs = ps.executeQuery();

            if(rs.next()){
                hDefaultData = new Hashtable();

                hDefaultData.put("labtype", ScreenHelper.checkString(rs.getString("labtype")));
                hDefaultData.put("OC_LABEL_VALUE",ScreenHelper.checkString(rs.getString("OC_LABEL_VALUE")));
                hDefaultData.put("monster",ScreenHelper.checkString(rs.getString("monster")));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return hDefaultData;
    }
    
    public static String getLabBarcode(String specimenid) {
    	String barcodeid=null;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID=?");
    		ps.setString(1, specimenid);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			barcodeid=rs.getString("OC_LABBARCODE_BARCODEID");
    		}
    		rs.close();
    		ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return barcodeid;
    }
    
    public static String getLabSpecimenId(String barcodeid) {
    	String specimenid=null;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_BARCODEID=?");
    		ps.setString(1, barcodeid);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			specimenid=rs.getString("OC_LABBARCODE_SAMPLEID");
    		}
    		rs.close();
    		ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return specimenid;
    }
    
    public static String getLabSpecimenId(String barcodeid, Connection conn) {
    	String specimenid=null;
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_BARCODEID=?");
    		ps.setString(1, barcodeid);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			specimenid=rs.getString("OC_LABBARCODE_SAMPLEID");
    		}
    		rs.close();
    		ps.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return specimenid;
    }
    
    public static String getLabBarcode(String specimenid, boolean bCreate) {
    	String barcodeid=null;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID=?");
    		ps.setString(1, specimenid);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			barcodeid=rs.getString("OC_LABBARCODE_BARCODEID");
    		}
    		else if(bCreate){
    			barcodeid=createLabBarcode(specimenid);
    		}
    		rs.close();
    		ps.close();
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return barcodeid;
    }
    
    public static String getLabBarcode(String specimenid, boolean bCreate, Connection conn) {
    	String barcodeid=null;
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID=?");
    		ps.setString(1, specimenid);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			barcodeid=rs.getString("OC_LABBARCODE_BARCODEID");
    		}
    		else if(bCreate){
    			barcodeid=createLabBarcode(specimenid,conn);
    		}
    		rs.close();
    		ps.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return barcodeid;
    }
    
    public static Vector getLabBarcodes(String transactionid, boolean bCreate, Connection conn) {
    	Vector barcodeids=new Vector();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID like ?");
    		ps.setString(1, transactionid+".%");
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()) {
    			barcodeids.add(rs.getString("OC_LABBARCODE_BARCODEID")+";"+rs.getString("OC_LABBARCODE_SAMPLEID"));
    		}
    		rs.close();
    		ps.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return barcodeids;
    }
    
    public static Vector getHL7Results(int transactionid, Connection conn) {
    	Vector hl7results=new Vector();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_HL7IN where OC_HL7IN_TRANSACTIONID = ?");
    		ps.setInt(1, transactionid);
    		ResultSet rs = ps.executeQuery();
    		while(rs.next()) {
    			hl7results.add(rs.getString("OC_HL7IN_ID")+";"+new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(rs.getTimestamp("OC_HL7IN_RECEIVED")));
    		}
    		rs.close();
    		ps.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return hl7results;
    }
    
    public static String getHL7ResultMessage(String messageId, Connection conn) {
    	String msg = "";
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from OC_HL7IN where OC_HL7IN_ID = ?");
    		ps.setString(1, messageId);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			msg=rs.getString("OC_HL7IN_MESSAGE");
    		}
    		rs.close();
    		ps.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return msg;
    }
    
    public static String setLabBarcode(String specimenid,String barcodeid) {
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		if(getLabSpecimenId(barcodeid, conn)==null) {
	    		PreparedStatement ps = conn.prepareStatement("delete from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID=?");
	    		ps.setString(1, specimenid);
	    		ps.execute();
	    		ps.close();
	    		ps=conn.prepareStatement("insert into OC_LABBARCODES(OC_LABBARCODE_SAMPLEID,OC_LABBARCODE_BARCODEID) values(?,?)");
	    		ps.setString(1, specimenid);
	    		ps.setString(2, barcodeid);
	    		ps.execute();
    		}
    		else {
    			barcodeid="USED";
    		}
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
    	return barcodeid;
    }
    
    public static String setLabBarcode(String specimenid,String barcodeid,Connection conn) {
    	try {
    		PreparedStatement ps = conn.prepareStatement("delete from OC_LABBARCODES where OC_LABBARCODE_SAMPLEID=?");
    		ps.setString(1, specimenid);
    		ps.execute();
    		ps.close();
    		ps=conn.prepareStatement("insert into OC_LABBARCODES(OC_LABBARCODE_SAMPLEID,OC_LABBARCODE_BARCODEID) values(?,?)");
    		ps.setString(1, specimenid);
    		ps.setString(2, barcodeid);
    		ps.execute();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
    	return barcodeid;
    }
    
    public static String createLabBarcode(String specimenid) {
    	String barcodeid=MedwanQuery.getInstance().getOpenclinicCounter("LabBarcodeId")+"";
    	return setLabBarcode(specimenid, "9"+"000000000".substring(barcodeid.length())+barcodeid);
    }
    
    public static int getOpenclinicCounter(String name,int mincounter,java.sql.Connection conn){
        int newCounter = 0;
        PreparedStatement ps=null;
        ResultSet rs=null;
        try{
        	ps = conn.prepareStatement("select OC_COUNTER_VALUE from OC_COUNTERS where OC_COUNTER_NAME=?");
            ps.setString(1, name);
            rs = ps.executeQuery();
            if(rs.next()){
                newCounter = rs.getInt("OC_COUNTER_VALUE");
                if(newCounter==0){
                	newCounter=1;
                }
                if(newCounter<mincounter){
                	newCounter=mincounter;
                }
                rs.close();
                ps.close();
            } 
            else{
                rs.close();
                ps.close();
                newCounter = 1;
                if(newCounter<mincounter){
                	newCounter=mincounter;
                }
                ps = conn.prepareStatement("insert into OC_COUNTERS(OC_COUNTER_NAME,OC_COUNTER_VALUE) values(?,1)");
                ps.setString(1, name);
                ps.execute();
                ps.close();
            }
            ps = conn.prepareStatement("update OC_COUNTERS set OC_COUNTER_VALUE=? where OC_COUNTER_NAME=?");
            ps.setInt(1, newCounter+1);
            ps.setString(2, name);
            ps.execute();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
        	try{
        		if(rs!=null) rs.close();
        		if(ps!=null) ps.close();
        	}
        	catch(Exception e2){
        		e2.printStackTrace();
        	}
        }
      
        return newCounter;
    }

    public static String createLabBarcode(String specimenid, java.sql.Connection conn) {
    	String barcodeid=getOpenclinicCounter("LabBarcodeId",0,conn)+"";
    	return setLabBarcode(specimenid, "9"+"000000000".substring(barcodeid.length())+barcodeid,conn);
    }
    
    public static Hashtable getLabRequestDefaultData(String language){
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuffer sSelect = new StringBuffer();
        sSelect.append("SELECT la.labtype,la.monster,l.OC_LABEL_VALUE,la.labcode")
                    .append(" FROM LabAnalysis la, OC_LABELS l")
                    .append(" WHERE "+ MedwanQuery.getInstance().convert("varchar(255)","la.labID")+" = l.OC_LABEL_ID")
                    .append("  AND l.oc_label_type = 'labanalysis'")
                    .append("  and l.OC_LABEL_LANGUAGE=? and la.deletetime is null");

        Hashtable hDefaultData = new Hashtable();

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect.toString());
            ps.setString(1, language);
            rs = ps.executeQuery();

            while(rs.next()){
                Hashtable hDefaultDataDetail = new Hashtable();
                hDefaultDataDetail.put("labtype", ScreenHelper.checkString(rs.getString("labtype")));
                hDefaultDataDetail.put("OC_LABEL_VALUE",ScreenHelper.checkString(rs.getString("OC_LABEL_VALUE")));
                hDefaultDataDetail.put("monster",ScreenHelper.checkString(rs.getString("monster")));
                hDefaultData.put(ScreenHelper.checkString(rs.getString("labcode")), hDefaultDataDetail);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return hDefaultData;
    }
}
