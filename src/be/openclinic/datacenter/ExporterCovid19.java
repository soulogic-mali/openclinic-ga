package be.openclinic.datacenter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.Diagnosis;
import be.openclinic.system.SH;

public class ExporterCovid19 extends Exporter {

	public void export(){
		if(!mustExport(getParam())){
			return;
		}
		if(getParam().equalsIgnoreCase("covid19.1")){
			//Export a summary of bed occupancy
			StringBuffer sb = new StringBuffer("<covid19>");
			String serviceuid;
			SortedMap admissionServices = new TreeMap();
			Hashtable occupiedServices = new Hashtable();
			Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection(), oc_conn2;
			Date date = new Date();
			try {
				PreparedStatement ps = oc_conn.prepareStatement("select * from OC_EXPORTS where OC_EXPORT_ID='covid19.1' and OC_EXPORT_CREATEDATETIME>=?");
				ps.setTimestamp(1, new java.sql.Timestamp(getDeadline().getTime()));
				ResultSet rs = ps.executeQuery();
				if(!rs.next()){
					rs.close();
					ps.close();
					oc_conn.close();

					long day = 24*3600*1000;
					//# patients seen in covid triage for the past 7 days
					Hashtable 	hTriage = new Hashtable(), 		//1
								hAdmitted = new Hashtable(), 	//2a
								hDischarged = new Hashtable(), 	//2b
								hDead = new Hashtable(), 		//3
								hSuspect = new Hashtable(),		//4
								hConfirmed = new Hashtable(),	//5
								hSymptoms = new Hashtable();	//6
					HashSet		sConfirmed = new HashSet(),
								sTriage = new HashSet(),
								sSuspect = new HashSet();
					oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
					ps = oc_conn.prepareStatement("select * from transactions where updatetime>=? and transactiontype like 'be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_COVID19%'");
					ps.setDate(1, new java.sql.Date(new java.util.Date().getTime()-7*day));
					rs = ps.executeQuery();
					while(rs.next()){
						//get encounter linked to transaction
						TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(rs.getInt("serverid"),rs.getInt("transactionId"));
						Encounter encounter = transaction.getEncounter();
						if(encounter!=null && encounter.hasValidUid()) {
							String sDate = new SimpleDateFormat("yyyyMMdd").format(transaction.getUpdateTime());
							//Triage
							if(!sTriage.contains(encounter.getUid()) && transaction.getTransactionType().equalsIgnoreCase("be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_COVID19_TRIAGE")) {
								SH.addHashCounter(hTriage, sDate, 1);
								sTriage.add(encounter.getUid());
							}
							//Confirmed
							if(!sConfirmed.contains(encounter.getPatientUID()) && isEncounterCovid19Related(encounter.getUid(),true)) {
								SH.addHashCounter(hConfirmed, sDate, 1);
								sConfirmed.add(encounter.getPatientUID());
							}
							else if(!sConfirmed.contains(encounter.getPatientUID()) && !isEncounterCovid19Related(encounter.getUid(),true)) {
								//Check if the patient is suspected
								if(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_COVID_FEVER").equalsIgnoreCase("1") &&
										(
										transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_COVID_COUGH").equalsIgnoreCase("1") || 
										transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_COVID_DYSPNEA").equalsIgnoreCase("1")
										)
								  ) {
									SH.addHashCounter(hSuspect, sDate, 1);
									sSuspect.add(encounter.getPatientUID());
								}
							}
						}
					}
					rs.close();
					ps.close();
					//Loop through the admissions of the past 7 days and register the covid related ones
					Vector admissions = Encounter.selectEncounters("", "", SH.formatDate(new java.util.Date(new java.util.Date().getTime()-7*day)), "", "admission", "", "", "", "", "");
					for(int n=0;n<admissions.size();n++) {
						Encounter encounter = (Encounter)admissions.elementAt(n);
						if(isEncounterCovid19Related(encounter.getUid(),false)) {
							SH.addHashCounter(hAdmitted, new SimpleDateFormat("yyyyMMdd").format(encounter.getBegin()), 1);
						}
					}
					ps = oc_conn.prepareStatement("select * from oc_encounters where oc_encounter_enddate>? and oc_encounter_type='admission'");
					ps.setDate(1, new java.sql.Date((new java.util.Date().getTime()-7*day)));
					rs=ps.executeQuery();
					while(rs.next()) {
						if(isEncounterCovid19Related(rs.getString("oc_encounter_serverid")+"."+rs.getString("oc_encounter_objectid"),false)) {
							SH.addHashCounter(hDischarged, new SimpleDateFormat("yyyyMMdd").format(rs.getDate("oc_encounter_enddate")), 1);
							if(rs.getString("oc_encounter_outcome").equalsIgnoreCase("dead")) {
								SH.addHashCounter(hDead, new SimpleDateFormat("yyyyMMdd").format(rs.getDate("oc_encounter_enddate")), 1);
							}
						}
					}
					rs.close();
					ps.close();
					oc_conn.close();
					
					//Always send todays values

					if(hTriage.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.1' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eTriage = hTriage.keys();
					while(eTriage.hasMoreElements()) {
						String key = (String)eTriage.nextElement();
						sb.append("<par id='covid19.1' date='"+key+"' value='"+hTriage.get(key)+"'/>");
					}

					if(hConfirmed.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.5' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eConfirmed = hConfirmed.keys();
					while(eConfirmed.hasMoreElements()) {
						String key = (String)eConfirmed.nextElement();
						sb.append("<par id='covid19.5' date='"+key+"' value='"+hConfirmed.get(key)+"'/>");
					}
					
					if(hSuspect.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.4' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eSuspect = hSuspect.keys();
					while(eSuspect.hasMoreElements()) {
						String key = (String)eSuspect.nextElement();
						sb.append("<par id='covid19.4' date='"+key+"' value='"+hSuspect.get(key)+"'/>");
					}
					
					if(hDead.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.3' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eDead = hDead.keys();
					while(eDead.hasMoreElements()) {
						String key = (String)eDead.nextElement();
						sb.append("<par id='covid19.3' date='"+key+"' value='"+hDead.get(key)+"'/>");
					}
					
					if(hAdmitted.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.2a' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eAdmitted = hAdmitted.keys();
					while(eAdmitted.hasMoreElements()) {
						String key = (String)eAdmitted.nextElement();
						sb.append("<par id='covid19.2a' date='"+key+"' value='"+hAdmitted.get(key)+"'/>");
					}
					
					if(hDischarged.get(new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()))==null) {
						sb.append("<par id='covid19.2b' date='"+new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())+"' value='0'/>");
					}
					Enumeration eDischarged = hDischarged.keys();
					while(eDischarged.hasMoreElements()) {
						String key = (String)eDischarged.nextElement();
						sb.append("<par id='covid19.2b' date='"+key+"' value='"+hDischarged.get(key)+"'/>");
					}

					sb.append("</covid19>");
					exportSingleValue(sb.toString(), "covid19.1");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			finally {
				try {
					oc_conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	public static boolean isEncounterCovid19Related(String uid, boolean confirmed) {
		boolean bReturn=false;
		//First check if we do have a coronavirus related diagnosis
		Vector diagnoses = Diagnosis.selectDiagnoses("", "", uid, "", "", "", "", "", "", "", "", "icd10", "");
		for(int i=0;i<diagnoses.size();i++) {
			Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(i);
			if(confirmed && MedwanQuery.getInstance().getConfigString("covid19.confirmed.icd10codes","U07.1").indexOf(diagnosis.getCode())>-1) {
				bReturn=true;
				break;
			}
			else if(!confirmed && MedwanQuery.getInstance().getConfigString("covid19.icd10codes","U07.1,U07.2,B34.2,B97.2").indexOf(diagnosis.getCode())>-1) {
				bReturn=true;
				break;
			}
		}
		if(!bReturn) {
			//Check if we do have a positive coronavirus test linked to the encounter
			bReturn=MedwanQuery.getInstance().hasItem(uid, "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_COVID_TESTPOSITIVE", "1");
		}

		return bReturn;
	}
}
