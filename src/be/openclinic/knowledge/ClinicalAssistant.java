package be.openclinic.knowledge;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.Debet;
import be.openclinic.finance.Prestation;
import be.openclinic.medical.ChronicMedication;
import be.openclinic.medical.Diagnosis;
import be.openclinic.medical.Prescription;
import be.openclinic.medical.Problem;
import be.openclinic.medical.ReasonForEncounter;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductStockOperation;

public class ClinicalAssistant {
	
	public static Vector getDrugDrugInteractionsForEncounter(String encounterUid){
		return getDrugDrugInteractionsForEncounter(encounterUid,-1);
	}
	
	public static Vector getDrugDrugInteractionsForEncounter(String encounterUid, int minimumSeverity){
		return DrugDrugInteraction.getInteractionsBetweenATCCodes(getATCClassesForEncounter(encounterUid),minimumSeverity);
	}
	
	public static HashSet getAllergyATCForPatient(String personid){
		HashSet allergyatc = new HashSet();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select * from healthrecord a,transactions b,items c where a.personid=? and a.healthrecordid=b.healthrecordid and b.transactiontype='be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_ALERT' and b.transactionid=c.transactionid and c.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_ALERTS_ALLERGY'");
			ps.setInt(1, Integer.parseInt(personid));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String allergy = rs.getString("value");
				PreparedStatement ps2 = conn.prepareStatement("select * from OC_ALLERGIES where OC_ALLERGY_ID=?");
				ps2.setString(1, allergy);
				ResultSet rs2 = ps2.executeQuery();
				while(rs2.next()){
					allergyatc.add(allergy+";"+rs2.getString("OC_ALLERGY_ATC"));
				}
				rs2.close();
				ps2.close();
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return allergyatc;
	}
	
	public static Vector getContraIndicationsForEncounter(String encounterUid){
		SortedSet hContraIndications = new TreeSet();
		Vector atcClasses = getATCClassesForEncounter(encounterUid);
		HashSet atcCodes = new HashSet();
		for(int n=0;n<atcClasses.size();n++){
			ATCClass atc = (ATCClass)atcClasses.elementAt(n);
			atcCodes.add(atc.getCode());
			//TODO: also include all parents?
		}
		Vector icd10codes = getIcd10CodesForEncounter(encounterUid);
		for(int n=0;n<icd10codes.size();n++){
			String icd10code = (String)icd10codes.elementAt(n);
			Vector ci = ContraIndication.getContraIndicatedATCCodesForICD10Code(icd10code);
			for(int i=0;i<ci.size();i++){
				ATCClass atc = (ATCClass)ci.elementAt(i);
				if(atcCodes.contains(atc.getCode())){
					//This one is contraindicated!
					hContraIndications.add(atc.getCode()+";"+icd10code);
				}
			}
		}
		Vector contraIndications = new Vector();
		Iterator iContraIndications = hContraIndications.iterator();
		while(iContraIndications.hasNext()){
			contraIndications.addElement(iContraIndications.next());
		}
		return contraIndications;
	}
	
	public static Vector getIcd10CodesForEncounter(String encounterUid){
		//Finds all the diagnoses that have been active during a specific encounter
		Vector icd10Codes = new Vector();
		Encounter encounter = Encounter.get(encounterUid);
		if(encounter==null){
			return icd10Codes;
		}
		HashSet hIcd10Codes = new HashSet();
		//Step 1: find  all icd10 diagnoses that were related to this encounter
		long day = 24*3600*1000;
		long margin = MedwanQuery.getInstance().getConfigInt("knowledgeDiagnosticTimeMarginInDays",7)*day;
		Vector diagnoses = Diagnosis.selectDiagnoses("", "", encounterUid, "", "", "", "", "", "", "", "", "icd10", "");
		for(int n=0;n<diagnoses.size();n++){
			Diagnosis diagnosis = (Diagnosis)diagnoses.elementAt(n);
			hIcd10Codes.add(diagnosis.getCode());
		}
		
		//Step 2: add all problems that were active at the time of the encounter
		Vector problems = Problem.selectProblems("", "", "icd10", "", "", encounter.getPatientUID(), ScreenHelper.formatDate(new java.util.Date((encounter.getEnd()==null?new java.util.Date().getTime():encounter.getEnd().getTime())+margin)), ScreenHelper.formatDate(new java.util.Date(encounter.getBegin().getTime()-margin)), "", "", "");
		for(int n=0;n<problems.size();n++){
			Problem problem = (Problem)problems.elementAt(n);
			hIcd10Codes.add(problem.getCode());
		}
		
		//Step 3: add all reasons for encounter that were active at the time of the encounter
		Vector rfes = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounterUid);
		for(int n=0;n<rfes.size();n++){
			ReasonForEncounter rfe = (ReasonForEncounter)rfes.elementAt(n);
			if(rfe.getCodeType().equalsIgnoreCase("icd10")){
				hIcd10Codes.add(rfe.getCode());
			}
		}

		Iterator iIcd10Codes = hIcd10Codes.iterator();
		while(iIcd10Codes.hasNext()){
			icd10Codes.add(iIcd10Codes.next());
		}
		return icd10Codes;
	}
	
	public static Vector getEncounterItemsForATCClass(String encounterUid, String atccode){
		Vector items = new Vector();
		if(atccode!=null){
			Encounter encounter = Encounter.get(encounterUid);
			Vector prescriptions = Prescription.find("", "", "", ScreenHelper.formatDate(encounter.getBegin()), encounter.getEnd()==null?ScreenHelper.formatDate(new java.util.Date()):ScreenHelper.formatDate(encounter.getEnd()), "", "", "");
			for(int n=0;n<prescriptions.size();n++){
				Prescription prescription = (Prescription)prescriptions.elementAt(n);
				Product product = prescription.getProduct();
				if(product!=null && ScreenHelper.checkString(product.getAtccode()).equalsIgnoreCase(atccode) ){
					items.add("product;"+product.getUid());
				}
			}
			//Step 2: find ATC classes linked to health services that have been delivered for this encounter 
			Vector debets = Debet.getEncounterDebets(encounterUid);
			for(int n=0;n<debets.size();n++){
				Debet debet = (Debet)debets.elementAt(n);
				Prestation prestation = debet.getPrestation();
				if(prestation!=null && prestation.getATCCode().equalsIgnoreCase(atccode)){
					items.add("prestation;"+prestation.getUid());
				}
			}
			//Step 3: find ATC classes linked to chronic medication
			Vector chronicMedications = ChronicMedication.find(encounter.getPatientUID(), "", "", "" , "OC_CHRONICMED_BEGIN", "ASC");
			for(int n=0;n<chronicMedications.size();n++){
				ChronicMedication chronicMedication = (ChronicMedication)chronicMedications.elementAt(n);
				Product product = chronicMedication.getProduct();
				if(product!=null && ScreenHelper.checkString(product.getAtccode()).equalsIgnoreCase(atccode)){
					items.add("chronic;"+product.getUid());
				}
			}
			//Step 4: find ATC classes linked to recently delivered medication
			long day = 24*3600*1000;
			Vector medicationHistory = ProductStockOperation.getPatientDeliveries(encounter.getPatientUID(),new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("patientMedicationDeliveryHistoryDuration",14)*day), new java.util.Date(),"OC_OPERATION_DATE","DESC");
			if(medicationHistory.size() > 0){
		        ProductStockOperation operation;
				for(int n=0; n<medicationHistory.size(); n++){
					operation = (ProductStockOperation)medicationHistory.elementAt(n);
					if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null && operation.getProductStock().getProduct().getAtccode()!=null && operation.getProductStock().getProduct().getAtccode().equalsIgnoreCase(atccode)){
						items.add("delivered;"+operation.getUid());
					}
				}
			}

		}
		return items;
	}
	
	public static Vector getATCClassesForEncounter(String encounterUid){
		//Finds all drugs that have been active during a specific encounter
		Vector atcClasses = new Vector();
		Encounter encounter = Encounter.get(encounterUid);
		if(encounter==null){
			return atcClasses;
		}
		Hashtable hAtcClasses = new Hashtable();
		// Step 1: find ATC classes linked to drug prescriptions that where active during the encounter
		
		//*****************************************************************
		// TODO: potentially only keep prescriptions with detected overlap
		//*****************************************************************
		
		Vector prescriptions = Prescription.find(encounter.getPatientUID(), "", "", ScreenHelper.formatDate(encounter.getBegin()), encounter.getEnd()==null?ScreenHelper.formatDate(new java.util.Date()):ScreenHelper.formatDate(encounter.getEnd()), "", "", "");
		for(int n=0;n<prescriptions.size();n++){
			Prescription prescription = (Prescription)prescriptions.elementAt(n);
			Product product = prescription.getProduct();
			if(product!=null && ScreenHelper.checkString(product.getAtccode()).length()>0 && ATCClass.get(product.getAtccode())!=null){
				//This is an active ATC code, add it to the list
				hAtcClasses.put(product.getAtccode(), ATCClass.get(product.getAtccode()));
			}
		}
		//Step 2: find ATC classes linked to health services that have been delivered for this encounter 
		Vector debets = Debet.getEncounterDebets(encounterUid);
		for(int n=0;n<debets.size();n++){
			Debet debet = (Debet)debets.elementAt(n);
			Prestation prestation = debet.getPrestation();
			if(prestation!=null && prestation.getATCCode().length()>0 && ATCClass.get(prestation.getATCCode())!=null){
				//This is an active ATC code, add it to the list
				hAtcClasses.put(prestation.getATCCode(), ATCClass.get(prestation.getATCCode()));
			}
		}
		//Step 3: find ATC classes linked to chronic medication
		Vector chronicMedications = ChronicMedication.find(encounter.getPatientUID(), "", "", "" , "OC_CHRONICMED_BEGIN", "ASC");
		for(int n=0;n<chronicMedications.size();n++){
			ChronicMedication chronicMedication = (ChronicMedication)chronicMedications.elementAt(n);
			Product product = chronicMedication.getProduct();
			if(product!=null && ScreenHelper.checkString(product.getAtccode()).length()>0 && ATCClass.get(product.getAtccode())!=null){
				//This is an active ATC code, add it to the list
				hAtcClasses.put(product.getAtccode(), ATCClass.get(product.getAtccode()));
			}
		}
		//Step 4: find ATC classes linked to recently delivered medication
		long day = 24*3600*1000;
		Vector medicationHistory = ProductStockOperation.getPatientDeliveries(encounter.getPatientUID(),new java.util.Date(new java.util.Date().getTime()-MedwanQuery.getInstance().getConfigInt("patientMedicationDeliveryHistoryDuration",14)*day), new java.util.Date(),"OC_OPERATION_DATE","DESC");
		if(medicationHistory.size() > 0){
	        ProductStockOperation operation;
			for(int n=0; n<medicationHistory.size(); n++){
				operation = (ProductStockOperation)medicationHistory.elementAt(n);
				if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null && operation.getProductStock().getProduct().getAtccode()!=null && operation.getProductStock().getProduct().getAtccode().length()>0){
					hAtcClasses.put(operation.getProductStock().getProduct().getAtccode(), ATCClass.get(operation.getProductStock().getProduct().getAtccode()));
				}
			}
		}
		
		Enumeration eAtcClasses = hAtcClasses.keys();
		while(eAtcClasses.hasMoreElements()){
			atcClasses.add(hAtcClasses.get(eAtcClasses.nextElement()));
		}
		return atcClasses;
	}

}
