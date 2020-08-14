package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class Allergy {
	private String allergyId;

	public String getAllergyId() {
		return allergyId;
	}

	public void setAllergyId(String allergyId) {
		this.allergyId = allergyId;
	}
	
	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("allergy", getAllergyId(), sLanguage);
	}
	
	public Vector getATCForAllergy(){
		Vector atcCodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGALLERGIES where OC_DRUGALLERGY_CODE=?");
			ps.setString(1, getAllergyId());
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atcCodes.add(rs.getString("OC_DRUGALLERGY_ATCCODE"));
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
		return atcCodes;
	}
	
	public static Vector getATCForAllergy(String allergyId){
		Vector atcCodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGALLERGIES where OC_DRUGALLERGY_CODE=?");
			ps.setString(1, allergyId);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atcCodes.add(rs.getString("OC_DRUGALLERGY_ATCCODE"));
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
		return atcCodes;
	}

	public static Vector getAllergiesForATC(String atcCode){
		Vector allergies = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGALLERGIES where OC_DRUGALLERGY_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				allergies.add(new Allergy(rs.getString("OC_DRUGALLERGY_CODE")));
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
		return allergies;
	}
	
	public Allergy(String allergyId) {
		super();
		this.allergyId = allergyId;
	}

}
