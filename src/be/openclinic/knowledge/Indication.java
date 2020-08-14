package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class Indication {
	private String indicationId;
	private String atcCode;

	public String getAtcCode() {
		return atcCode;
	}

	public void setAtcCode(String atcCode) {
		this.atcCode = atcCode;
	}

	public String getIndicationId() {
		return indicationId;
	}

	public void setIndicationId(String indicationId) {
		this.indicationId = indicationId;
	}

	public Indication(String indicationId) {
		super();
		this.indicationId = indicationId;
	}
	
	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("indication", getIndicationId(), sLanguage);
	}
	
	public static Indication get(String indicationId){
		Indication indication = null;
		if(indicationId!=null){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONS where OC_DRUGINDICATION_CODE=?");
				ps.setString(1, indicationId);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					indication=new Indication(indicationId);
					indication.setAtcCode(rs.getString("OC_DRUGINDICATION_ATCCODE"));
				}
				rs.close();
				ps.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			finally{
				try{
					conn.close();
				}
				catch(Exception e){
					e.printStackTrace();
				}
			}
		}
		return indication;
	}
	
	public Vector getIndicationGroups(){
		Vector groups = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONLINKS where OC_DRUGINDICATIONLINK_CODE=?");
			ps.setString(1, getIndicationId());
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				groups.add(IndicationGroup.get(rs.getString("OC_DRUGINDICATIONLINK_GROUPCODE")));
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return groups;
	}
	
	public Vector getIndicationsForATCCode(){
		return getIndicationsForATCCode(getAtcCode());
	}

	public static Vector getIndicationsForATCCode(String atcCode){
		return IndicationGroup.getIndicationsForATCCode(atcCode);
	}
	
	public Vector getATCCodesForIndication(){
		return getATCCodesForIndication(getIndicationId());
	}

	public static Vector getATCCodesForIndication(String indicationId){
		return IndicationGroup.getATCCodesForIndication(indicationId);
	}
	
	public static Vector getIndicationsForICD10Code(String icd10code){
		return IndicationGroup.getIndicationsForICD10Code(icd10code);
	}
	
	public static boolean isATCCodeIndicatedForICD10Code(String atc,String icd10){
		boolean bIndicated=false;
		String sql="select * from oc_drugindications a,oc_drugindicationlinks b, oc_drugindicationgroups c"+
				" where"+
				" a.oc_drugindication_atccode=? and"+
				" a.oc_drugindication_code = b.oc_drugindicationlink_code and"+
				" b.oc_drugindicationlink_groupcode=c.oc_drugindicationgroup_code and"+
				" c.oc_drugindicationgroup_icd10codemin<=? and"+
				" c.oc_drugindicationgroup_icd10codemax>=?";
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, atc);
			ps.setString(2, icd10);
			ps.setString(3, icd10);
			ResultSet rs = ps.executeQuery();
			bIndicated = rs.next();
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bIndicated;
	}
}
