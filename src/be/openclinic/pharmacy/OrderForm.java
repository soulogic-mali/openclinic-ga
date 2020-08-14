package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;

public class OrderForm extends OC_Object {
	private String supplier;
	private Date date;
	private String supplierinvoice;
	private String comment;
	
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public String getSupplierinvoice() {
		return supplierinvoice;
	}
	public void setSupplierinvoice(String supplierinvoice) {
		this.supplierinvoice = supplierinvoice;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	
    public static OrderForm get(String orderFormUid){
    	if(orderFormUid.split("\\.").length<2){
    		return null;
    	}
        OrderForm form = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT * FROM OC_PRODUCTORDERFORMS"+
                             " WHERE OC_FORM_SERVERID = ? AND OC_FORM_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(orderFormUid.substring(0,orderFormUid.indexOf("."))));
            ps.setInt(2,Integer.parseInt(orderFormUid.substring(orderFormUid.indexOf(".")+1)));
            rs = ps.executeQuery();

            // get data from DB
            if(rs.next()){
                form = new OrderForm();
                form.setUid(orderFormUid);

                form.setSupplier(rs.getString("OC_FORM_SUPPLIER"));
                form.setSupplierinvoice(rs.getString("OC_FORM_SUPPLIERINVOICE")); // (native|high|low)
                form.setDate(rs.getDate("OC_FORM_DATE"));

                // OBJECT variables
                form.setCreateDateTime(rs.getTimestamp("OC_FORM_CREATETIME"));
                form.setUpdateDateTime(rs.getTimestamp("OC_FORM_UPDATETIME"));
                form.setUpdateUser(ScreenHelper.checkString(rs.getString("OC_FORM_UPDATEUID")));
                form.setVersion(rs.getInt("OC_FORM_VERSION"));
            }
            else{
                throw new Exception("ERROR : PRODUCTORDERFORM "+orderFormUid+" NOT FOUND");
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

        return form;
    }

    //--- STORE -----------------------------------------------------------------------------------
    public void store(){
        store(true);
    }

    public void store(boolean checkExistence){
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(this.getUid().equals("-1")){
                //***** INSERT *****
                Debug.println("@@@ PRODUCTORDERFORM insert @@@");

                sSelect = "INSERT INTO OC_PRODUCTORDERFORMS (OC_FORM_SERVERID, OC_FORM_OBJECTID,"+
                          "  OC_FORM_SUPPLIER, OC_FORM_SUPPLIERINVOICE,OC_FORM_DATE,"+
                          "  OC_FORM_CREATETIME, OC_FORM_UPDATETIME, OC_FORM_UPDATEUID, OC_FORM_VERSION)"+
                          " VALUES(?,?,?,?,?,?,?,?,1)";

                ps = oc_conn.prepareStatement(sSelect);

                // set new uid
                int serverId = MedwanQuery.getInstance().getConfigInt("serverId");
                int orderFormCounter = MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTORDERFORMS");
                ps.setInt(1,serverId);
                ps.setInt(2,orderFormCounter);
                this.setUid(serverId+"."+orderFormCounter);

                ps.setString(3,this.getSupplier());
                ps.setString(4,this.getSupplierinvoice());
                if(this.getDate()!=null) ps.setTimestamp(5,new java.sql.Timestamp(this.getDate().getTime()));
                else                       ps.setNull(5,Types.TIMESTAMP);

                // OBJECT variables
                ps.setTimestamp(6,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setTimestamp(7,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(8,this.getUpdateUser());

                ps.executeUpdate();
            }
            else{
                //***** UPDATE *****
                Debug.println("@@@ PRODUCTORDERFORM update @@@");

                sSelect = "UPDATE OC_PRODUCTORDERFORMS SET "+
                          "  OC_FORM_SUPPLIER=?, OC_FORM_SUPPLIERINVOICE=?, OC_FORM_DATE=?,"+
                          "  OC_FORM_UPDATETIME=?, OC_FORM_UPDATEUID=?, OC_FORM_VERSION=(OC_FORM_VERSION+1)"+
                          " WHERE OC_FORM_SERVERID=? AND OC_FORM_OBJECTID=?";

                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1,this.getSupplier());
                ps.setString(2,this.getSupplierinvoice());
                if(this.getDate()!=null) ps.setTimestamp(3,new java.sql.Timestamp(this.getDate().getTime()));
                else                       ps.setNull(3,Types.TIMESTAMP);

                // OBJECT variables
                ps.setTimestamp(4,new java.sql.Timestamp(new java.util.Date().getTime())); // now
                ps.setString(5,this.getUpdateUser());
                ps.setInt(6,Integer.parseInt(this.getUid().substring(0,this.getUid().indexOf("."))));
                ps.setInt(7,Integer.parseInt(this.getUid().substring(this.getUid().indexOf(".")+1)));

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
    
    //--- FIND ------------------------------------------------------------------------------------
    public Vector getProductOrders(){
        Vector foundObjects = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // compose query
            String sSelect = "SELECT OC_ORDER_SERVERID, OC_ORDER_OBJECTID"+
                             " FROM OC_PRODUCTORDERS po where OC_ORDER_FORMUID=?";

            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1, getUid());
            rs = ps.executeQuery();

            while(rs.next()){
                foundObjects.add(ProductOrder.get(rs.getString("OC_ORDER_SERVERID")+"."+rs.getString("OC_ORDER_OBJECTID")));
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
}
