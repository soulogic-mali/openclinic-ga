package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class DrugInteractionClass {
	private String interactionClassId;

	public String getInteractionClassId() {
		return interactionClassId;
	}

	public void setInteractionClassId(String interactionClassId) {
		this.interactionClassId = interactionClassId;
	}

	public DrugInteractionClass(String interactionClassId) {
		super();
		this.interactionClassId = interactionClassId;
	}

	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("druginteractionclass", getInteractionClassId(), sLanguage);
	}

	public Vector getATCForInteraction(){
		Vector atcCodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONCLASSES where OC_DRUGINTERACTIONCLASS_CODE=?");
			ps.setString(1, getInteractionClassId());
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atcCodes.add(rs.getString("OC_DRUGINTERACTIONCLASS_ATCCODE"));
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
	
	public static Vector getATCForInteraction(String interactionClassId){
		Vector atcCodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONCLASSES where OC_DRUGINTERACTIONCLASS_CODE=?");
			ps.setString(1, interactionClassId);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atcCodes.add(rs.getString("OC_DRUGINTERACTIONCLASS_ATCCODE"));
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
	
	public static Vector getInteractionsForATC(String atcCode){
		Vector interactions = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONCLASSES where OC_DRUGINTERACTIONCLASS_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				interactions.add(new DrugInteractionClass(rs.getString("OC_DRUGINTERACTIONCLASS_CODE")));
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
		return interactions;
	}
	
	public static Vector getInteractionIdsForATC(String atcCode){
		Vector interactions = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINTERACTIONCLASSES where OC_DRUGINTERACTIONCLASS_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				interactions.add(rs.getString("OC_DRUGINTERACTIONCLASS_CODE"));
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
		return interactions;
	}
	
}
