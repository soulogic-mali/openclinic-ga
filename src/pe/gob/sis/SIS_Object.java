package pe.gob.sis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;
import be.openclinic.finance.Debet;

public class SIS_Object extends OC_Object{
	int fields;
	String tableName;
	String[] values;
	int errorField;
	
	boolean isValid(int fieldid){
		return true;
	}
	
	public boolean isValid(){
		for(int n=1;n<=fields;n++){
			if(!isValid(n)){
				errorField=n;
				return false;
			}
		}
		return true;
	}
	
	public int getFields() {
		return fields;
	}
	public String[] getValues() {
		return values;
	}
	public void setValues(String[] values) {
		this.values = values;
	}
	public void setFields(int fields) {
		this.fields = fields;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public SIS_Object(int fields, String tableName) {
		super();
		this.fields = fields;
		this.tableName = tableName;
		this.values = new String[fields+1];
	}
	public String getValueString(int n){
		return ScreenHelper.checkString(getValues()[n]);
	}
	public int getValueInt(int n){
		try{
			return Integer.parseInt(getValueString(n));
		}
		catch(Exception e){
			return -1;
		}
	}
	public double getValueDouble(int n){
		try{
			return Double.parseDouble(getValueString(n));
		}
		catch(Exception e){
			return -1;
		}
	}
	public java.util.Date getValueDate(int n){
		try{
			return ScreenHelper.parseDate(getValueString(n));
		}
		catch(Exception e){
			return null;
		}
	}

	public java.util.Date getValueDateTime(int n){
		try{
			return ScreenHelper.parseDate(getValueString(n),ScreenHelper.fullDateFormat);
		}
		catch(Exception e){
			return null;
		}
	}
	
	public java.util.Date getValueShortDate(int n){
		try{
			return ScreenHelper.parseDate(getValueString(n),new SimpleDateFormat("yyyyMMdd"));
		}
		catch(Exception e){
			return null;
		}
	}
	
	public java.util.Date getValueTimestamp(int n){
		try{
			return ScreenHelper.parseDate(getValueString(n),new SimpleDateFormat("yyyyMMddHHmmssSSS"));
		}
		catch(Exception e){
			return null;
		}
	}
	
	public void setValue(int index,String s){
		values[index]=s;
	}

	public static Vector getForFUA(String tableName, int fields, String uid){
		Vector objects = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from "+tableName+" where "+tableName+"_1=?");
			ps.setString(1, uid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				objects.add(get(tableName,fields,rs.getString(tableName+"_SERVERID")+"."+rs.getString(tableName+"_OBJECTID")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
		return objects;
	}

	public static SIS_Object get(String tableName, int fields, String uid){
		SIS_Object sis = null;
		if(isValidUid(uid)){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from "+tableName+" where "+tableName+"_SERVERID=? and "+tableName+"_OBJECTID=?");
				ps.setInt(1, getServerId(uid));
				ps.setInt(2, getObjectId(uid));
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					if(tableName.equalsIgnoreCase("SIS_ATENCION")){
						sis = new Atencion();
					}
					else if(tableName.equalsIgnoreCase("SIS_DIAGNOSTICOS")){
						sis = new Diagnosticos();
					}
					else if(tableName.equalsIgnoreCase("SIS_MEDICAMENTOS")){
						sis = new Medicamentos();
					}
					else if(tableName.equalsIgnoreCase("SIS_INSUMOS")){
						sis = new Insumos();
					}
					else if(tableName.equalsIgnoreCase("SIS_PROCEDIMIENTOS")){
						sis = new Procedimientos();
					}
					else if(tableName.equalsIgnoreCase("SIS_SMI")){
						sis = new SMI();
					}
					else if(tableName.equalsIgnoreCase("SIS_RECIENNACIDO")){
						sis = new RecienNacido();
					}
					else{
						sis = new SIS_Object(fields, tableName);
					}
					sis.setUid(uid);
					sis.setVersion(rs.getInt(tableName+"_VERSION"));
					for(int n=1;n<=fields;n++){
						sis.setValue(n,rs.getString(tableName+"_"+n));
					}
				}
				rs.close();
				ps.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			finally {
				try{
					conn.close();
				}
				catch(Exception d){
					d.printStackTrace();
				}
			}
		}
		return sis;
	}
	
	public static void moveToHistory(String tableName,int fields,String uid){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			String sql = "insert into "+tableName+"_HISTORY ("
					+ " "+tableName+"_SERVERID,"
					+ " "+tableName+"_OBJECTID,"
					+ " "+tableName+"_VERSION,"
					;
			for(int n=1;n<=fields;n++){
				sql+=" "+tableName+"_"+n;
				if(n<fields){
					sql+=",";
				}
			}
			sql+=")"
					+ " SELECT"
					+ " "+tableName+"_SERVERID,"
					+ " "+tableName+"_OBJECTID,"
					+ " "+tableName+"_VERSION,"
					;
			for(int n=1;n<=fields;n++){
				sql+=" "+tableName+"_"+n;
				if(n<fields){
					sql+=",";
				}
			}
			sql+=" FROM "+tableName+" WHERE "+tableName+"_1=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, uid);
			ps.execute();
			ps.close();
			sql = "DELETE FROM "+tableName+" WHERE "+tableName+"_1=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, uid);
			ps.execute();
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
	}
	
	public void store(){
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			if(hasValidUid()){
				//Move to history
				String sql = "insert into "+getTableName()+"_HISTORY ("
						+ " "+getTableName()+"_SERVERID,"
						+ " "+getTableName()+"_OBJECTID,"
						+ " "+getTableName()+"_VERSION,"
						;
				for(int n=1;n<=fields;n++){
					sql+=" "+getTableName()+"_"+n;
					if(n<fields){
						sql+=",";
					}
				}
				sql+=")"
						+ " SELECT"
						+ " "+getTableName()+"_SERVERID,"
						+ " "+getTableName()+"_OBJECTID,"
						+ " "+getTableName()+"_VERSION,"
						;
				for(int n=1;n<=fields;n++){
					sql+=" "+getTableName()+"_"+n;
					if(n<fields){
						sql+=",";
					}
				}
				sql+=" FROM "+getTableName()+" WHERE "+getTableName()+"_SERVERID=? AND "+getTableName()+"_OBJECTID=?";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, getServerId());
				ps.setInt(2, getObjectId());
				ps.execute();
				ps.close();
				sql = "DELETE FROM "+getTableName()+" WHERE "+getTableName()+"_SERVERID=? AND "+getTableName()+"_OBJECTID=?";
				ps = conn.prepareStatement(sql);
				ps.setInt(1, getServerId());
				ps.setInt(2, getObjectId());
				ps.execute();
				ps.close();
				setVersion(getVersion()+1);
			}
			else{
				setVersion(1);
				setUid(MedwanQuery.getInstance().getServerId()+"."+MedwanQuery.getInstance().getOpenclinicCounter(getTableName()));
			}
			setUpdateDateTime(new java.util.Date());
			String sql = "INSERT INTO "+getTableName()+"("
				+ " "+getTableName()+"_SERVERID,"
				+ " "+getTableName()+"_OBJECTID,"
				+ " "+getTableName()+"_VERSION,"
				;
			for(int n=1;n<=fields;n++){
				sql+=" "+getTableName()+"_"+n;
				if(n<fields){
					sql+=",";
				}
			}
			sql+=") VALUES(?,?,?,";
			for(int n=1;n<=fields;n++){
				sql+="?";
				if(n<fields){
					sql+=",";
				}
			}
			sql+=")";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, getServerId());
			ps.setInt(2, getObjectId());
			ps.setInt(3, getVersion());
			for(int n=1;n<=fields;n++){
				ps.setString(n+3, getValueString(n));
			}
			ps.execute();
			ps.close();
			
			//Update OC_Debets table for some table
			if(tableName.equalsIgnoreCase("SIS_MEDICAMENTOS") || tableName.equalsIgnoreCase("SIS_INSUMOS")){
				Debet debet = Debet.get(getValueString(8));
				if(debet!=null && !ScreenHelper.checkString(debet.getInsurarInvoiceUid()).equalsIgnoreCase(MedwanQuery.getInstance().getServerId()+"."+getValueString(1))){
					debet.setInsurarInvoiceUid(MedwanQuery.getInstance().getServerId()+"."+getValueString(1));
					debet.store();
				}
			}
			else if(tableName.equalsIgnoreCase("SIS_PROCEDIMIENTOS")){
				Debet debet = Debet.get(getValueString(11));
				if(debet!=null && !ScreenHelper.checkString(debet.getInsurarInvoiceUid()).equalsIgnoreCase(MedwanQuery.getInstance().getServerId()+"."+getValueString(1))){
					debet.setInsurarInvoiceUid(MedwanQuery.getInstance().getServerId()+"."+getValueString(1));
					debet.store();
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception d){
				d.printStackTrace();
			}
		}
	}
}
