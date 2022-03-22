package be.openclinic.knowledge;

import java.awt.Color;
import java.awt.Image;
import java.awt.Polygon;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Vector;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.openclinic.adt.Encounter;
import ocspring2.OC;
import ocspring2.OCProb;

public class Ikirezi {
	
	public static Hashtable getEncounterSymptoms(String encounteruid){
		Hashtable symptoms = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps =conn.prepareStatement("select * from oc_ikirezisymptoms where oc_symptom_encounteruid=? order by oc_symptom_id");
			ps.setString(1,encounteruid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				symptoms.put(rs.getInt("oc_symptom_id"), rs.getInt("oc_symptom_value"));
			}
			rs.close();
			ps.close();
			conn.close();
			//TODO: try to detect symptoms with other methods
			//Check patient age
			checkPatientAge(symptoms,encounteruid);

		}
		catch(Exception e){
			e.printStackTrace();
		}
		return symptoms;
	}
	
	public static Hashtable getRemainingStartupSigns(Vector existingSigns,String language){
		Hashtable remainingSigns = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getIkireziConnection();
		try{
			String existingnrs="";
			for(int n=0;n<existingSigns.size();n++){
				if(existingSigns.elementAt(n)!=null && ((String)existingSigns.elementAt(n)).length()>0){
					if(existingnrs.length()>0){
						existingnrs+=",";
					}
					existingnrs+=(String)existingSigns.elementAt(n);
				}
			}
			String symp="sympe";
			if(language.toLowerCase().startsWith("f")){
				symp="sympf";
			}
			else if(language.toLowerCase().startsWith("n")){
				symp="sympn";
			}
			else if(language.toLowerCase().startsWith("es")){
				symp="symps";
			}
			else if(language.toLowerCase().startsWith("p")){
				symp="sympp";
			}
			String sSql="select a.nrs,b."+symp+" as symp from sym a,sym_lang b where a.startup=-1 and a.nrs=b.nrs and a.nrs not in ("+existingnrs+") and a.nrs not in (select nrsexclude from excludes where nrs in ("+existingnrs+"))";
			PreparedStatement ps =conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				remainingSigns.put(rs.getString("nrs"),rs.getString("symp"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return remainingSigns;
	}
	
	public static Hashtable getRemainingSigns(Vector existingSigns,String language){
		Hashtable remainingSigns = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getIkireziConnection();
		try{
			String existingnrs="";
			for(int n=0;n<existingSigns.size();n++){
				if(existingSigns.elementAt(n)!=null){
					if(existingnrs.length()>0){
						existingnrs+=",";
					}
					existingnrs+=(String)existingSigns.elementAt(n);
				}
			}
			String symp="sympe";
			if(language.toLowerCase().startsWith("f")){
				symp="sympf";
			}
			else if(language.toLowerCase().startsWith("n")){
				symp="sympn";
			}
			else if(language.toLowerCase().startsWith("es")){
				symp="symps";
			}
			else if(language.toLowerCase().startsWith("p")){
				symp="sympp";
			}
			String sSql="select a.nrs,b."+symp+" as symp from sym a,sym_lang b where a.nrs=b.nrs and a.nrs not in ("+existingnrs+") and a.nrs not in (select nrsexclude from excludes where nrs in ("+existingnrs+"))";
			PreparedStatement ps =conn.prepareStatement(sSql);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				remainingSigns.put(rs.getString("nrs"),rs.getString("symp"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return remainingSigns;
	}
	
	public static void checkPatientAge(Hashtable symptoms, String encounteruid){
		try{
			Encounter encounter = Encounter.get(encounteruid);
			int age = encounter.getPatient().getAgeInMonths();
			if(age<12){
				symptoms.put(110,1);
			}
			else if(age<180){
				symptoms.put(98,1);
			}
			else if(encounter.getPatient().gender.toLowerCase().equalsIgnoreCase("m")){
				symptoms.put(136,1);
			}
			else{
				symptoms.put(81,1);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static void checkPatientAgeBoolean(Hashtable symptoms, String encounteruid){
		try{
			Encounter encounter = Encounter.get(encounteruid);
			int age = encounter.getPatient().getAgeInMonths();
			if(age<12){
				symptoms.put(110,true);
			}
			else if(age<180){
				symptoms.put(98,true);
			}
			else if(encounter.getPatient().gender.toLowerCase().equalsIgnoreCase("m")){
				symptoms.put(136,true);
			}
			else{
				symptoms.put(81,true);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static String getDiseaseMapping(int nrz){
		String code=null;
		Connection conn = MedwanQuery.getInstance().getIkireziConnection();
		try{
			PreparedStatement ps =conn.prepareStatement("select * from diseasemappings where nrz=?");
			ps.setInt(1,nrz);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				code=rs.getString("icd10");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return code;
	}

	public static Hashtable getEncounterSymptomsBoolean(String encounteruid){
		Hashtable symptoms = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps =conn.prepareStatement("select * from oc_ikirezisymptoms where oc_symptom_encounteruid=? order by oc_symptom_id");
			ps.setString(1,encounteruid);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				symptoms.put(rs.getInt("oc_symptom_id"), rs.getInt("oc_symptom_value")==1);
			}
			rs.close();
			ps.close();
			conn.close();
			checkPatientAgeBoolean(symptoms,encounteruid);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return symptoms;
	}
	
	public static Vector getDiagnoses(Vector signs, String language){
		OC oc = new OC();
		Vector diagnoses = oc.getResponse(signs,language);
		return diagnoses;
	}
	
	public static Vector getDiagnoses(String[] signs, String language){
		OC oc = new OC();
		Vector diagnoses = oc.getResponse(signs,language);
		return diagnoses;
	}
	
	public static void purgeSessions(){
		long interval = MedwanQuery.getInstance().getConfigInt("ikireziCleanInterval",3600*1000); //default = once an hour
		long cutoff = new java.util.Date().getTime()-interval;
		java.sql.Timestamp cutOffDate=new java.sql.Timestamp(cutoff);
		Debug.println("Purging Ikirezi cutoff date = "+cutOffDate);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps =conn.prepareStatement("select * from oc_ikirezisessions where oc_session_updatetime<?");
			ps.setTimestamp(1,cutOffDate);
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String sessionid = rs.getString("oc_session_id");
				Debug.println("Purging Ikirezi sessionid = "+sessionid);
				Connection iconn = MedwanQuery.getInstance().getIkireziConnection();
				PreparedStatement ps2 = iconn.prepareStatement("delete from probabilita where sessionid=?");
				ps2.setString(1, sessionid);
				ps2.execute();
				ps2.close();
				ps2 = iconn.prepareStatement("delete from myrelated where sessionid=?");
				ps2.setString(1, sessionid);
				ps2.execute();
				ps2.close();
				ps2 = iconn.prepareStatement("delete from myselected2 where sessionid=?");
				ps2.setString(1, sessionid);
				ps2.execute();
				ps2.close();
				ps2 = iconn.prepareStatement("delete from poterireplex where sessionid=?");
				ps2.setString(1, sessionid);
				ps2.execute();
				ps2.close();
				ps2 = iconn.prepareStatement("delete from sintomis where sessionid=?");
				ps2.setString(1, sessionid);
				ps2.execute();
				ps2.close();
				iconn.close();
			}
			rs.close();
			ps.close();
			ps=conn.prepareStatement("delete from oc_ikirezisessions where oc_session_updatetime<?");
			ps.setTimestamp(1,new java.sql.Timestamp(cutoff));
			ps.execute();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static Vector getDiagnosisProbabilities(Hashtable signs, String language,String sessionId){
		Vector diagnoses = new Vector();
		OCProb ocProb = new OCProb(sessionId,signs,language);
		Vector diseases = ocProb.getListData();
		for(int n=0;n<diseases.size();n++){
			Vector disease = (Vector) diseases.elementAt(n);
			//NRZ;Probabiliteit;NRS;PC;PE
			String key= disease.elementAt(6)+";"+disease.elementAt(2)+";"+disease.elementAt(4)+";"+disease.elementAt(7)+";"+disease.elementAt(8);
			if(!diagnoses.contains(key)){
				diagnoses.add(key);
			}
		}
		return diagnoses;
	}
	
	public static String getSymptomLabel(int id,String language){
		String label=id+"";
		String l="e";
		if(language.toLowerCase().startsWith("n")){
			l="n";
		}
		else if(language.toLowerCase().startsWith("f")){
			l="f";
		}
		if(language.toLowerCase().startsWith("p")){
			l="p";
		}
		if(language.toLowerCase().startsWith("es")){
			l="s";
		}
		try{
			Connection conn = MedwanQuery.getInstance().getIkireziConnection();
			PreparedStatement ps = conn.prepareStatement("select sym_lang.symp"+l+" as label from sym_lang,sym where sym.nrs=sym_lang.nrs and sym_lang.nrs=?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				label=rs.getString("label");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return label;
	}
	
	public static Hashtable getSymptomLabels(String language){
		Hashtable findings = new Hashtable();
		String l="e";
		if(language.toLowerCase().startsWith("n")){
			l="n";
		}
		else if(language.toLowerCase().startsWith("f")){
			l="f";
		}
		if(language.toLowerCase().startsWith("p")){
			l="p";
		}
		if(language.toLowerCase().startsWith("es")){
			l="s";
		}
		try{
			Connection conn = MedwanQuery.getInstance().getIkireziConnection();
			PreparedStatement ps = conn.prepareStatement("select sym_lang.nrs,sym_lang.symp"+l+" as label from sym,sym_lang where sym.nrs=sym_lang.nrs order by symp"+l+"");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				findings.put(rs.getString("nrs"),rs.getString("label"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return findings;
	}
	
	public static Hashtable getStartupSymptomLabels(String language){
		Hashtable findings = new Hashtable();
		String l="e";
		if(language.toLowerCase().startsWith("n")){
			l="n";
		}
		else if(language.toLowerCase().startsWith("f")){
			l="f";
		}
		if(language.toLowerCase().startsWith("p")){
			l="p";
		}
		if(language.toLowerCase().startsWith("es")){
			l="s";
		}
		try{
			Connection conn = MedwanQuery.getInstance().getIkireziConnection();
			PreparedStatement ps = conn.prepareStatement("select sym_lang.nrs,sym_lang.symp"+l+" as label from sym,sym_lang where sym.nrs=sym_lang.nrs and sym.startup=-1 order by symp"+l+"");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				findings.put(rs.getString("nrs"),rs.getString("label"));
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return findings;
	}
	
	public static String getDiagnosisLabel(String id,String language){
		return getDiagnosisLabel(Integer.parseInt(id), language);
	}
	
	public static String getDiagnosisLabel(int id,String language){
		String label=id+"";
		String l="e";
		if(language.toLowerCase().startsWith("n")){
			l="n";
		}
		else if(language.toLowerCase().startsWith("f")){
			l="f";
		}
		if(language.toLowerCase().startsWith("p")){
			l="p";
		}
		if(language.toLowerCase().startsWith("es")){
			l="s";
		}
		try{
			Connection conn = MedwanQuery.getInstance().getIkireziConnection();
			PreparedStatement ps = conn.prepareStatement("select ziek"+l+" as label from diag_lang where nrz=?");
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				label=rs.getString("label");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		return label;
	}
	
	public static void storeSymptom(String encounteruid, String symptom, String value, int updateuid){
		try{
			if(encounteruid.length()>0){
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				PreparedStatement ps = conn.prepareStatement("delete from OC_IKIREZISYMPTOMS where OC_SYMPTOM_ENCOUNTERUID=? and OC_SYMPTOM_ID=?");
				ps.setString(1, encounteruid);
				ps.setString(2, symptom);
				ps.execute();
				ps.close();
				if(!value.equalsIgnoreCase("0")){
					Connection iconn = MedwanQuery.getInstance().getIkireziConnection();
					ps=iconn.prepareStatement("select * from excludes where nrs=?");
					ps.setInt(1, Integer.parseInt(symptom));
					ResultSet rs = ps.executeQuery();
					String excludesymptoms="-1";
					while(rs.next()){
						excludesymptoms+=","+rs.getString("nrsexclude");
					}
					rs.close();
					ps.close();
					iconn.close();
					if(!excludesymptoms.equals("-1")){
						ps=conn.prepareStatement("delete from OC_IKIREZISYMPTOMS where OC_SYMPTOM_ENCOUNTERUID=? and OC_SYMPTOM_ID in("+excludesymptoms+")");
						ps.setString(1, encounteruid);
						ps.execute();
						ps.close();
					}
					ps = conn.prepareStatement("insert into OC_IKIREZISYMPTOMS(OC_SYMPTOM_ENCOUNTERUID,OC_SYMPTOM_ID,OC_SYMPTOM_VALUE,OC_SYMPTOM_UID,OC_SYMPTOM_UPDATETIME) values(?,?,?,?,?)");
					ps.setString(1, encounteruid);
					ps.setString(2, symptom);
					ps.setString(3, value);
					ps.setInt(4, updateuid);
					ps.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
					ps.execute();
					ps.close();
				}
				conn.close();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static void removeSymptom(String encounteruid, String symptom, int updateuid){
		try{
			if(encounteruid.length()>0){
				Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
				PreparedStatement ps = conn.prepareStatement("delete from OC_IKIREZISYMPTOMS where OC_SYMPTOM_ENCOUNTERUID=? and OC_SYMPTOM_ID=?");
				ps.setString(1, encounteruid);
				ps.setString(2, symptom);
				ps.execute();
				ps.close();
				conn.close();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

	public static void logAction(String encounteruid, String data, int updateuid){
		try{
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement("insert into OC_IKIREZIACTIONS(OC_ACTION_ID,OC_ACTION_ENCOUNTERUID,OC_ACTION_DATA,OC_ACTION_UID,OC_ACTION_UPDATETIME) values(?,?,?,?,?)");
			ps.setInt(1, MedwanQuery.getInstance().getOpenclinicCounter("OC_IKIREZIACTIONS"));
			ps.setString(2, encounteruid);
			ps.setString(3, data);
			ps.setInt(4, updateuid);
			ps.setTimestamp(5, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.execute();
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}

}
