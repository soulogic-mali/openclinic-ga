package be.openclinic.pharmacy;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.common.OC_Object;

public class ProductionOrderMaterial extends OC_Object{
	private int id=-1;
	private int productionOrderId;
	private String productStockUid;
	private double quantity;
	private int updateUid;
	private String comment;
	private java.util.Date dateUsed;
	
	public java.util.Date getDateUsed() {
		return dateUsed;
	}

	public void setDateUsed(java.util.Date dateUsed) {
		this.dateUsed = dateUsed;
	}

	public static ProductionOrderMaterial get(int id){
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			rs=ps.executeQuery();
			if(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(id);
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTIONORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				productionOrderMaterial.setDateUsed(rs.getTimestamp("OC_MATERIAL_DATEUSED"));
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
		return productionOrderMaterial;
	}
	
	public ProductionOrder getProductionOrder(){
		return ProductionOrder.get(getProductionOrderId());
	}
	
	public static Vector getProductionOrderMaterials(int productionOrderId){
		Vector materials = new Vector();
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_PRODUCTIONORDERID=?");
			ps.setInt(1, productionOrderId);
			rs=ps.executeQuery();
			while(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(rs.getInt("OC_MATERIAL_ID"));
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTIONORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				productionOrderMaterial.setDateUsed(rs.getTimestamp("OC_MATERIAL_DATEUSED"));
				materials.add(productionOrderMaterial);
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
		return materials;
	}
	
	public static Vector getProductionOrderUnusedMaterials(int productionOrderId){
		Vector materials = new Vector();
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select * from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_PRODUCTIONORDERID=? and OC_MATERIAL_DATEUSED IS NULL");
			ps.setInt(1, productionOrderId);
			rs=ps.executeQuery();
			while(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(rs.getInt("OC_MATERIAL_ID"));
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTIONORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				productionOrderMaterial.setDateUsed(rs.getTimestamp("OC_MATERIAL_DATEUSED"));
				materials.add(productionOrderMaterial);
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
		return materials;
	}
	
	public static Vector getProductionOrderMaterialsSummary(int productionOrderId){
		Vector materials = new Vector();
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select max(OC_MATERIAL_ID) as OC_MATERIAL_ID,"
					+ "OC_MATERIAL_PRODUCTIONORDERID,"
					+ "OC_MATERIAL_PRODUCTSTOCKUID,"
					+ "max(OC_MATERIAL_CREATEDATETIME) as OC_MATERIAL_CREATEDATETIME,"
					+ "max(OC_MATERIAL_UPDATETIME) as OC_MATERIAL_UPDATETIME,"
					+ "max(OC_MATERIAL_UPDATEUID) as OC_MATERIAL_UPDATEUID,"
					+ "sum(OC_MATERIAL_QUANTITY) as OC_MATERIAL_QUANTITY,"
					+ "max(OC_MATERIAL_VERSION) as OC_MATERIAL_VERSION,"
					+ "max(OC_MATERIAL_COMMENT) as OC_MATERIAL_COMMENT"
					+ " from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_PRODUCTIONORDERID=?"
					+ " group by OC_MATERIAL_PRODUCTIONORDERID,OC_MATERIAL_PRODUCTSTOCKUID");
			ps.setInt(1, productionOrderId);
			rs=ps.executeQuery();
			while(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(rs.getInt("OC_MATERIAL_ID"));
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTIONORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				if(productionOrderMaterial.getQuantity()!=0){
					materials.add(productionOrderMaterial);
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
		return materials;
	}
	
	public static Vector getProductionOrderUnusedMaterialsSummary(int productionOrderId){
		Vector materials = new Vector();
		ProductionOrderMaterial productionOrderMaterial = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		ResultSet rs =null;
		try{
			ps=conn.prepareStatement("select max(OC_MATERIAL_ID) as OC_MATERIAL_ID,"
					+ "OC_MATERIAL_PRODUCTIONORDERID,"
					+ "OC_MATERIAL_PRODUCTSTOCKUID,"
					+ "max(OC_MATERIAL_CREATEDATETIME) as OC_MATERIAL_CREATEDATETIME,"
					+ "max(OC_MATERIAL_UPDATETIME) as OC_MATERIAL_UPDATETIME,"
					+ "max(OC_MATERIAL_UPDATEUID) as OC_MATERIAL_UPDATEUID,"
					+ "sum(OC_MATERIAL_QUANTITY) as OC_MATERIAL_QUANTITY,"
					+ "max(OC_MATERIAL_VERSION) as OC_MATERIAL_VERSION,"
					+ "max(OC_MATERIAL_COMMENT) as OC_MATERIAL_COMMENT"
					+ " from OC_PRODUCTIONORDERMATERIALS where OC_MATERIAL_PRODUCTIONORDERID=? and OC_MATERIAL_DATEUSED is NULL"
					+ " group by OC_MATERIAL_PRODUCTIONORDERID,OC_MATERIAL_PRODUCTSTOCKUID");
			ps.setInt(1, productionOrderId);
			rs=ps.executeQuery();
			while(rs.next()){
				productionOrderMaterial = new ProductionOrderMaterial();
				productionOrderMaterial.setId(rs.getInt("OC_MATERIAL_ID"));
				productionOrderMaterial.setProductionOrderId(rs.getInt("OC_MATERIAL_PRODUCTIONORDERID"));
				productionOrderMaterial.setProductStockUid(rs.getString("OC_MATERIAL_PRODUCTSTOCKUID"));
				productionOrderMaterial.setCreateDateTime(rs.getTimestamp("OC_MATERIAL_CREATEDATETIME"));
				productionOrderMaterial.setUpdateDateTime(rs.getTimestamp("OC_MATERIAL_UPDATETIME"));
				productionOrderMaterial.setUpdateUid(rs.getInt("OC_MATERIAL_UPDATEUID"));
				productionOrderMaterial.setQuantity(rs.getInt("OC_MATERIAL_QUANTITY"));
				productionOrderMaterial.setVersion(rs.getInt("OC_MATERIAL_VERSION"));
				productionOrderMaterial.setComment(rs.getString("OC_MATERIAL_COMMENT"));
				if(productionOrderMaterial.getQuantity()!=0){
					materials.add(productionOrderMaterial);
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
		return materials;
	}
	
	public void setUsed(java.util.Date date){
		setDateUsed(date);
		store();
	}
	
	public static void setUsed(int nProductionOrderId,String sProductStockUid,java.util.Date date){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			String sQuery = "update oc_productionordermaterials set oc_material_dateused=? "
					+ "where oc_material_productionorderid=? and oc_material_productstockuid=? and oc_material_dateused is null";
			ps=conn.prepareStatement(sQuery);
			ps.setTimestamp(1, new java.sql.Timestamp(date.getTime()));
			ps.setInt(2, nProductionOrderId);
			ps.setString(3, sProductStockUid);
			ps.execute();
			ps.close();
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
	
	public boolean store(){
		boolean bStored=false;
		if(id==-1){
			id=MedwanQuery.getInstance().getOpenclinicCounter("OC_PRODUCTIONORDERMATERIAL_ID");
			setVersion(0);
		}
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps = null;
		try{
			//COPY TO HISTORY
		ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERMATERIALS_HISTORY(OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_DATEUSED,"
					+ " OC_MATERIAL_COMMENT)"
					+ " SELECT OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_DATEUSED,"
					+ " OC_MATERIAL_COMMENT"
					+ " FROM OC_PRODUCTIONORDERMATERIALS WHERE OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();
			//DELETE
			ps=conn.prepareStatement("DELETE FROM OC_PRODUCTIONORDERMATERIALS WHERE OC_MATERIAL_ID=?");
			ps.setInt(1, id);
			ps.execute();
			//STORE new version
			setVersion(getVersion()+1);
			ps=conn.prepareStatement("INSERT INTO OC_PRODUCTIONORDERMATERIALS(OC_MATERIAL_ID,"
					+ " OC_MATERIAL_PRODUCTIONORDERID,"
					+ " OC_MATERIAL_PRODUCTSTOCKUID,"
					+ " OC_MATERIAL_QUANTITY,"
					+ " OC_MATERIAL_CREATEDATETIME,"
					+ " OC_MATERIAL_UPDATETIME,"
					+ " OC_MATERIAL_UPDATEUID,"
					+ " OC_MATERIAL_VERSION,"
					+ " OC_MATERIAL_COMMENT,"
					+ " OC_MATERIAL_DATEUSED)"
					+ " VALUES(?,?,?,?,?,?,?,?,?,?)");
			ps.setInt(1, id);
			ps.setInt(2, getProductionOrderId());
			ps.setString(3, getProductStockUid());
			ps.setDouble(4, getQuantity());
			ps.setTimestamp(5, new java.sql.Timestamp(getCreateDateTime().getTime()));
			ps.setTimestamp(6, new java.sql.Timestamp(getUpdateDateTime().getTime()));
			ps.setInt(7, getUpdateUid());
			ps.setInt(8, getVersion());
			ps.setString(9, getComment());
			ps.setTimestamp(10, getDateUsed()==null?null:new java.sql.Timestamp(getDateUsed().getTime()));
			bStored=ps.execute();
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
		return bStored;		
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getProductionOrderId() {
		return productionOrderId;
	}
	public void setProductionOrderId(int productionOrderId) {
		this.productionOrderId = productionOrderId;
	}
	public String getProductStockUid() {
		return productStockUid;
	}
	public ProductStock getProductStock(){
		if(getProductStockUid()!=null){
			return ProductStock.get(getProductStockUid());
		}
		return null;
	}
	public void setProductStockUid(String productStockUid) {
		this.productStockUid = productStockUid;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public int getUpdateUid() {
		return updateUid;
	}
	public void setUpdateUid(int updateuid) {
		this.updateUid = updateuid;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}

}
