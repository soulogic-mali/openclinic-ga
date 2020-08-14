package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class ATCClass {
	private String code;
	private String parentcode;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getParentcode() {
		return parentcode;
	}
	public void setParentcode(String parentcode) {
		this.parentcode = parentcode;
	}
	
	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("atc", getCode().trim(), sLanguage);
	}
	
	public String getFullLabel(String sLanguage){
		String label = getLabel(sLanguage);
		ATCClass parent = getParent();
		if(parent !=null){
			label=parent.getFullLabel(sLanguage)+">"+label;
		}
		return label;
	}
	
	public static ATCClass get(String code){
		ATCClass atcClass = null;
		if(code!=null){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from OC_ATC where OC_ATC_CODE=?");
				ps.setString(1, code);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					atcClass=new ATCClass();
					atcClass.setCode(code);
					atcClass.setParentcode(rs.getString("OC_ATC_PARENTCODE"));
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
		return atcClass;
	}
	
	public ATCClass getParent(){
		return get(getParentcode());
	}
	
	public Vector getChildren(){
		Vector children = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_ATC where OC_ATC_PARENTCODE=?");
			ps.setString(1, getCode());
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				ATCClass atcClass=new ATCClass();
				atcClass.setCode(rs.getString("OC_ATC_CODE"));
				atcClass.setParentcode(getCode());
				children.add(atcClass);
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
		return children;
	}
}
