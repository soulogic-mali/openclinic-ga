package pe.gob.sis;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class Acreditacion extends SIS_Object{

	public Acreditacion() {
		super(33, "SIS_ACREDITACION");
	}
	
	public void setPersonid(int personid){
		setValue(31, personid+"");
	}

	public void setDateTime(java.util.Date date){
		setValue(32, ScreenHelper.formatDate(date,new SimpleDateFormat("yyyyMMddHHmmssSSS")));
	}
	
	public void setAccreditationMecanism(String s){
		setValue(33, s);
	}
	
	public int getPersonId(){
		return getValueInt(31);
	}

	public java.util.Date getDateTime(){
		return getValueTimestamp(32);
	}
	
	public static void delete(String sAccreditationId) {
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			ps=conn.prepareStatement("delete from SIS_ACREDITACION where SIS_ACREDITACION_2=?");
			ps.setString(1, sAccreditationId);
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
	
	public static void store(ResultQueryAsegurado insurance,int personid, java.util.Date date, String accmec){
		Acreditacion acreditacion = new Acreditacion();
		acreditacion.setPersonid(personid);
		acreditacion.setDateTime(date);
		acreditacion.setAccreditationMecanism(accmec);
		acreditacion.setValue(1, insurance.getIdError());
		acreditacion.setValue(2, insurance.getResultado());
		acreditacion.setValue(3, insurance.getTipoDocumento());
		acreditacion.setValue(4, insurance.getNroDocumento());
		acreditacion.setValue(5, insurance.getApePaterno());
		acreditacion.setValue(6, insurance.getApeMaterno());
		acreditacion.setValue(7, insurance.getNombres());
		acreditacion.setValue(8, insurance.getFecAfiliacion());
		acreditacion.setValue(9, insurance.getEESS());
		acreditacion.setValue(10, insurance.getDescEESS());
		acreditacion.setValue(11, insurance.getEESSUbigeo());
		acreditacion.setValue(12, insurance.getDescEESSUbigeo());
		acreditacion.setValue(13, insurance.getRegimen());
		acreditacion.setValue(14, insurance.getTipoSeguro());
		acreditacion.setValue(15, insurance.getDescTipoSeguro());
		acreditacion.setValue(16, insurance.getContrato());
		acreditacion.setValue(17, insurance.getFecCaducidad());
		acreditacion.setValue(18, insurance.getEstado());
		acreditacion.setValue(19, insurance.getMsgConfidencial());
		acreditacion.setValue(20, insurance.getTabla());
		acreditacion.setValue(21, insurance.getIdNumReg());
		acreditacion.setValue(22, insurance.getGenero());
		acreditacion.setValue(23, insurance.getFecNacimiento());
		acreditacion.setValue(24, insurance.getIdUbigeo());
		acreditacion.setValue(25, insurance.getDisa());
		acreditacion.setValue(26, insurance.getTipoFormato());
		acreditacion.setValue(27, insurance.getNroContrato());
		acreditacion.setValue(28, insurance.getCorrelativo());
		acreditacion.setValue(29, insurance.getIdPlan());
		acreditacion.setValue(30, insurance.getIdGrupoPoblacional());
		acreditacion.store();
	}
	
	public static SIS_Object getLast(int personid){
		SIS_Object acreditacion = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			ps=conn.prepareStatement("select * from SIS_ACREDITACION where SIS_ACREDITACION_31=? order by SIS_ACREDITACION_32 DESC");
			ps.setString(1, personid+"");
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				acreditacion=Acreditacion.get("SIS_ACREDITACION",33,rs.getInt("SIS_ACREDITACION_SERVERID")+"."+rs.getInt("SIS_ACREDITACION_OBJECTID"));
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
		return acreditacion;
	}

	public static SIS_Object getByAccreditationNumber(String accnr){
		SIS_Object acreditacion = null;
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		PreparedStatement ps;
		try{
			ps=conn.prepareStatement("select * from SIS_ACREDITACION where SIS_ACREDITACION_2=?");
			ps.setString(1, accnr);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				acreditacion=Acreditacion.get("SIS_ACREDITACION",32,rs.getInt("SIS_ACREDITACION_SERVERID")+"."+rs.getInt("SIS_ACREDITACION_OBJECTID"));
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
		return acreditacion;
	}

}
