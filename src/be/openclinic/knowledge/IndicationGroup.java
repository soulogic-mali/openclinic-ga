package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class IndicationGroup {
	private String indicationGroupId;
	private String icd10CodeMin;
	private String icd10CodeMax;

	public String getIndicationGroupId() {
		return indicationGroupId;
	}

	public String getIcd10CodeMin() {
		return icd10CodeMin;
	}

	public void setIcd10CodeMin(String icd10CodeMin) {
		this.icd10CodeMin = icd10CodeMin;
	}

	public String getIcd10CodeMax() {
		return icd10CodeMax;
	}

	public void setIcd10CodeMax(String icd10CodeMax) {
		this.icd10CodeMax = icd10CodeMax;
	}

	public void setIndicationGroupId(String indicationGroupId) {
		this.indicationGroupId = indicationGroupId;
	}

	public IndicationGroup(String indicationGroupId) {
		super();
		this.indicationGroupId = indicationGroupId;
	}
	
	public String getLabel(String sLanguage){
		return ScreenHelper.getTranNoLink("indicationgroup", getIndicationGroupId(), sLanguage);
	}
	
	public static IndicationGroup get(String indicationGroupId){
		IndicationGroup indicationGroup = null;
		if(indicationGroupId!=null){
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try{
				PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONGROUPS where OC_DRUGINDICATIONGROUP_CODE=?");
				ps.setString(1, indicationGroupId);
				ResultSet rs = ps.executeQuery();
				if(rs.next()){
					indicationGroup=new IndicationGroup(indicationGroupId);
					indicationGroup.setIcd10CodeMin(rs.getString("OC_DRUGINDICATIONGROUP_ICD10CODEMIN"));
					indicationGroup.setIcd10CodeMax(rs.getString("OC_DRUGINDICATIONGROUP_ICD10CODEMAX"));
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
		return indicationGroup;
	}
	
	public static Vector getIndicationGroupsForICD10Code(String icd10code){
		Vector indicationGroups = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONGROUPS where OC_DRUGINDICATIONGROUP_ICD10CODEMIN<=? AND OC_DRUGINDICATIONGROUP_ICD10CODEMAX>=?");
			ps.setString(1, icd10code);
			ps.setString(2, icd10code);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				IndicationGroup indicationGroup=new IndicationGroup(rs.getString("OC_DRUGINDICATIONGROUP_CODE"));
				indicationGroup.setIcd10CodeMin(rs.getString("OC_DRUGINDICATIONGROUP_ICD10CODEMIN"));
				indicationGroup.setIcd10CodeMax(rs.getString("OC_DRUGINDICATIONGROUP_ICD10CODEMAX"));
				indicationGroups.add(indicationGroup);
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
		return indicationGroups;
	}
	
	public Vector getIndications(){
		return getIndications(getIndicationGroupId());
	}
	
	public static Vector getIndications(String indicationGroupId){
		Vector indications = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONLINKS where OC_DRUGINDICATIONLINK_GROUPCODE=?");
			ps.setString(1, indicationGroupId);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Indication indication=Indication.get(rs.getString("OC_DRUGINDICATIONLINK_CODE"));
				if(indication!=null){
					indications.add(indication);
				}
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
		return indications;
	}
	
	public static Vector getIndicationsForICD10Code(String icd10code){
		Vector indications = new Vector();
		HashSet hIndications = new HashSet();
		Vector indicationGroups = getIndicationGroupsForICD10Code(icd10code);
		for(int n=0;n<indicationGroups.size();n++){
			IndicationGroup indicationGroup = (IndicationGroup)indicationGroups.elementAt(n);
			Vector inds = indicationGroup.getIndications();
			for(int i=0;i<inds.size();i++){
				hIndications.add(inds.elementAt(i));
			}
		}
		Iterator iIndications = hIndications.iterator();
		while(iIndications.hasNext()){
			indications.add(iIndications.next());
		}
		return indications;
	}
	
	public static Vector getIndicationsForATCCode(String atcCode){
		Vector indications = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONS where OC_DRUGINDICATION_ATCCODE=?");
			ps.setString(1, atcCode);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				Indication indication = new Indication(rs.getString("OC_DRUGINDICATION_CODE"));
				indication.setAtcCode(atcCode);
				indications.add(indication);
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
		return indications;
	}

	public static Vector getIndicationGroupsForATCCode(String atcCode){
		Vector groups = new Vector();
		Hashtable hGroups = new Hashtable();
		Vector indications = getIndicationsForATCCode(atcCode);
		for(int n=0;n<indications.size();n++){
			Indication indication = (Indication)indications.elementAt(n);
			Vector iGroups = indication.getIndicationGroups();
			for(int i=0;i<iGroups.size();i++){
				IndicationGroup indicationGroup = (IndicationGroup)iGroups.elementAt(i);
				hGroups.put(indicationGroup.getIndicationGroupId(), indicationGroup);
			}
		}
		Enumeration eGroups = hGroups.keys();
		while(eGroups.hasMoreElements()){
			String id = (String)eGroups.nextElement();
			groups.add(hGroups.get(id));
		}
		return groups;
	}

	public static Vector getATCCodesForIndication(String indicationId){
		Vector atcCodes = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from OC_DRUGINDICATIONS where OC_DRUGINDICATION_CODE=?");
			ps.setString(1, indicationId);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				atcCodes.add(rs.getString("OC_DRUGINDICATION_ATCCODE"));
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
	
	public Vector getATCCodesForIndicationGroup(){
		return getATCCodesForIndicationGroup(getIndicationGroupId());
	}

	public static Vector getATCCodesForIndicationGroup(String indicationGroupId){
		Vector atccodes = new Vector();
		HashSet hAtcCodes = new HashSet();
		Vector indications = getIndications(indicationGroupId);
		for(int n=0;n<indications.size();n++){
			Indication indication = (Indication)indications.elementAt(n);
			Vector atcs = indication.getATCCodesForIndication();
			for(int i=0;i<atcs.size();i++){
				hAtcCodes.add(atcs.elementAt(i));
			}
		}
		Iterator iAtcs = hAtcCodes.iterator();
		while(iAtcs.hasNext()){
			atccodes.add(iAtcs.next());
		}
		return atccodes;
	}
}
