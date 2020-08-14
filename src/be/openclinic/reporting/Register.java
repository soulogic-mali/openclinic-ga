package be.openclinic.reporting;

import java.util.Collection;
import java.util.Iterator;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.Insurance;
import be.openclinic.medical.Diagnosis;
import be.openclinic.medical.Prescription;
import net.admin.AdminPerson;
import net.admin.AdminPrivateContact;

public class Register {
	private AdminPerson patient =null;
	private Encounter encounter = null;
	private TransactionVO transaction = null;
	private String sWebLanguage=null;
	private int counter=0;
	
	
	public int getCounter() {
		return counter;
	}

	public void setCounter(int counter) {
		this.counter = counter;
	}

	public Register(int serverid,int transactionid, int personid, String language){
		transaction = MedwanQuery.getInstance().loadTransaction(serverid, transactionid);
		patient = AdminPerson.getAdminPerson(personid+"");
		if(transaction!=null && transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID")!=null){
			encounter = Encounter.get(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID"));
			if(encounter==null){
				encounter = Encounter.getActiveEncounterOnDate(new java.sql.Timestamp(transaction.getUpdateTime().getTime()), personid+"");
			}
		}
		sWebLanguage=language;
	}
	
	public String getValue(String source, String name, String translateresult){
		String s ="";
		if(source.equalsIgnoreCase("system")){
			if(name.equalsIgnoreCase("id")){
				counter++;
				s=""+counter;
			}
		}
		else if(source.equalsIgnoreCase("diagnosis")){
			if(name.equalsIgnoreCase("icd10")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICD10Code")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
			else if(name.equalsIgnoreCase("icd10withlocalcodes")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICD10Code")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICD10Code", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
					else if(item.getType().startsWith("ICPCCode") && item.getType().replaceAll("ICPCCode", "").startsWith("J")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICPCCode", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
			else if(name.equalsIgnoreCase("encountericd10")){
				Collection diagnoses = Diagnosis.selectDiagnoses("", "", encounter.getUid(), "", "", "", "", "", "", "", "", "icd10", "");
				Iterator iDiagnoses = diagnoses.iterator();
				while(iDiagnoses.hasNext()){
					Diagnosis diagnosis =(Diagnosis)iDiagnoses.next();
					if(s.length()>0){
						s+=", ";
					}
					s+=diagnosis.getCode()+" "+MedwanQuery.getInstance().getCodeTran("icd10code"+diagnosis.getCode(), sWebLanguage);
				}
			}
			else if(name.equalsIgnoreCase("icpc2")){
				Collection items = transaction.getItems();
				Iterator iItems = items.iterator();
				while(iItems.hasNext()){
					ItemVO item =(ItemVO)iItems.next();
					if(item.getType().startsWith("ICPCCode")){
						if(s.length()>0){
							s+=", ";
						}
						s+=item.getType().replaceAll("ICPCCode", "")+" "+MedwanQuery.getInstance().getCodeTran(item.getType(), sWebLanguage);
					}
				}
			}
		}
		else if(patient!=null && source.equalsIgnoreCase("patient")){
			if(name.startsWith("fullname")){
				s=patient.getFullName();
			}
			else if(name.startsWith("civilstatus")) {
				s=ScreenHelper.getTranNoLink("civil.status",patient.comment2,sWebLanguage);
			}
			else if(name.startsWith("profession")) {
				s=patient.getActivePrivate().businessfunction;
			}
			else if(name.startsWith("ageinyears")){
				if(name.split("=").length<2) {
					if(transaction!=null) {
						s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
					}
					else {
						s=patient.getAge()+"";
					}
				}
				else {
					if(name.split("=")[1].split(":")[0].equalsIgnoreCase("lessthan") && patient.getAge()<Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
					else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("lessthanorequals") && patient.getAge()<=Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
					else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("morethan") && patient.getAge()>Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
					else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("morethanorequals") && patient.getAge()>=Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
					else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("equals") && patient.getAge()==Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
					else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("notequals") && patient.getAge()!=Double.parseDouble(name.split("=")[1].split(":")[1])) {
						if(transaction!=null) {
							s=patient.getAgeOnDate(transaction.getUpdateTime())+"";
						}
						else {
							s=patient.getAge()+"";
						}
					}
				}
			}
			else if(name.startsWith("childage")){
				if(transaction!=null) {
					if(patient.getAgeInMonthsOnDate(transaction.getUpdateTime())>=1) {
						s=patient.getAgeInMonthsOnDate(transaction.getUpdateTime())+"m";
					}
					else {
						s=patient.getAgeInDaysOnDate(transaction.getUpdateTime())+ScreenHelper.getTranNoLink("register","d",sWebLanguage);
					}
				}
				else {
					if(patient.getAgeInMonths()>=1) {
						s=patient.getAgeInMonths()+"m";
					}
					else {
						s=patient.getAgeInDays()+ScreenHelper.getTranNoLink("register","d",sWebLanguage);
					}
				}
			}
			else if(name.equalsIgnoreCase("msplsagegroup")){
				int age = patient.getAgeInMonths();
				if(transaction!=null) {
					age=patient.getAgeInMonthsOnDate(transaction.getUpdateTime());
				}
				if(age<1) {
					s="A";
				}
				else if(age<60) {
					s="B";
				}
				else if(age<120) {
					s="C";
				}
				else if(age<180) {
					s="D";
				}
				else if(age<240) {
					s="E";
				}
				else if(age<300) {
					s="F";
				}
				else if(age<360) {
					s="G";
				}
				else if(age<420) {
					s="H";
				}
				else if(age<480) {
					s="I";
				}
				else if(age<540) {
					s="J";
				}
				else if(age<600) {
					s="K";
				}
				else {
					s="L";
				}
			}
			else if(name.equalsIgnoreCase("msplsagegroup2")){
				int age = patient.getAgeInMonths();
				if(transaction!=null) {
					age=patient.getAgeInMonthsOnDate(transaction.getUpdateTime());
				}
				if(age<180) {
					s="<15";
				}
				else {
					s=">=15";
				}
			}
			else if(name.startsWith("dateofbirth")){
				s=patient.dateOfBirth;
			}
			else if(name.startsWith("personid")){
				s=patient.personid+"";
			}
			else if(name.startsWith("gender")){
				s=patient.gender;
			}
			else if(name.startsWith("sector")){
				s=patient.getActivePrivate().sector;
			}
			else if(name.startsWith("city")){
				s=patient.getActivePrivate().city;
			}
			else if(name.equalsIgnoreCase("comment")){
				s=patient.comment;
			}
			else if(name.equalsIgnoreCase("comment1")){
				s=patient.comment1;
			}
			else if(name.equalsIgnoreCase("comment2")){
				s=patient.comment2;
			}
			else if(name.equalsIgnoreCase("comment3")){
				s=patient.comment3;
			}
			else if(name.equalsIgnoreCase("comment4")){
				s=patient.comment4;
			}
			else if(name.equalsIgnoreCase("comment5")){
				s=patient.comment5;
			}
			else if(name.startsWith("address")){
				if(patient.getActivePrivate()!=null){
					s=patient.getActivePrivate().address;
				}
			}
			else if(name.startsWith("profession")){
				if(patient.getActivePrivate()!=null){
					s=patient.getActivePrivate().businessfunction;
				}
			}
		}
		else if(transaction!=null && source.startsWith("transaction")){
			if(name.equalsIgnoreCase("updatetime")){
				s=ScreenHelper.formatDate(transaction.getUpdateTime());
			}
			else {
				if(name.split("=").length<2) {
					s = ScreenHelper.checkString(transaction.getItemValue(name)).replaceAll(";", ",").replaceAll("\r", "").replaceAll("\n", " ");
				}
				else {
					try {
						if(name.split("=")[1].split(":")[0].equalsIgnoreCase("contains") && ScreenHelper.checkString(transaction.getItemValue(name.split("=")[0])).replaceAll(";", ",").replaceAll("\r", "").replaceAll("\n", " ").contains(name.split("=")[1].split(":")[1])) {
							s=ScreenHelper.checkString(transaction.getItemValue(name.split("=")[0])).replaceAll(";", ",").replaceAll("\r", "").replaceAll("\n", " ");
						}
						else {
							double val = Double.parseDouble(ScreenHelper.checkString(transaction.getItemValue(name.split("=")[0])).replaceAll(";", ",").replaceAll("\r", "").replaceAll("\n", " "));
							if(name.split("=")[1].split(":")[0].equalsIgnoreCase("lessthan") && val<Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
							if(name.split("=")[1].split(":")[0].equalsIgnoreCase("lessthanorequals") && val<=Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
							else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("morethan") && val>Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
							else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("morethanorequals") && val>=Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
							else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("equals") && val==Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
							else if(name.split("=")[1].split(":")[0].equalsIgnoreCase("notequals") && val!=Double.parseDouble(name.split("=")[1].split(":")[1])) {
								s=val+"";
							}
						}
					}
					catch(Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		else if(source.startsWith("encounter") && encounter!=null){
			if(name.equalsIgnoreCase("begin") && encounter.getBegin()!=null){
				s=ScreenHelper.formatDate(encounter.getBegin());
			}
			else if(name.equalsIgnoreCase("end") && encounter.getEnd()!=null){
				s=ScreenHelper.formatDate(encounter.getEnd());
			}
			else if(name.equalsIgnoreCase("duration") && encounter.getBegin()!=null && encounter.getEnd()!=null){
				long day = 24*3600*1000;
				java.util.Date start = ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getBegin()));
				java.util.Date stop = ScreenHelper.parseDate(ScreenHelper.formatDate(encounter.getEnd()));
				s=((stop.getTime()-start.getTime())/day+1)+"";
			}
			else if(name.equalsIgnoreCase("origin")){
				s=ScreenHelper.checkString(encounter.getOrigin());
			}
			else if(name.equalsIgnoreCase("situation")){
				s=ScreenHelper.checkString(encounter.getSituation());
			}
			else if(name.equalsIgnoreCase("outcome")){
				s=ScreenHelper.checkString(encounter.getOutcome());
			}
		}
		else if(source.startsWith("treatment") && encounter!=null){
			Vector prescriptions = Prescription.find(encounter);
			for(int n=0;n<prescriptions.size();n++) {
				if(s.length()>0) {
					s+="{sep}";
				}s+="["+(n+1)+"] ";
				Prescription prescription= (Prescription)prescriptions.elementAt(n);
				if(name.equalsIgnoreCase("drugs")) {
					s+=prescription.getProduct().getName();
				}
				else if(name.equalsIgnoreCase("unit")) {
					s+=ScreenHelper.getTranNoLink("product.unit",prescription.getProduct().getUnit(),sWebLanguage);
				}
				else if(name.equalsIgnoreCase("prescription")) {
					s+=prescription.getUnitsPerTimeUnit()+"/"+prescription.getTimeUnitCount()+" "+ScreenHelper.getTranNoLink("prescription.timeunit",prescription.getTimeUnit(),sWebLanguage);
				}
				else if(name.equalsIgnoreCase("duration")) {
					s+=(1+Math.ceil((prescription.getEnd().getTime()-prescription.getBegin().getTime())/ScreenHelper.getTimeDay()))+ScreenHelper.getTranNoLink("register","d",sWebLanguage);
				}
				else if(name.equalsIgnoreCase("delivered")) {
					s+=prescription.getDeliveredQuantity();
				}
			}
		}
		else if(source.startsWith("financial") && encounter!=null){
			Insurance insurance = Insurance.getDefaultInsuranceForPatient(encounter.getPatientUID());
			if(insurance!=null) {
				s=insurance.getInsurar().getName();
			}
		}
		if(s.length()>0 && translateresult!=null && translateresult.length()>0){
			String s2="",s3="";
			for(int n=0;n<s.split(",").length;n++) {
				s2=ScreenHelper.getTranNoLink(translateresult.split("=")[0], s.split(",")[n], sWebLanguage);
				if(translateresult.split("=").length>1) {
					s2=ScreenHelper.getTranNoLink(translateresult.split("=")[1].split("\\$")[0], translateresult.split("=")[1].split("\\$")[1], sWebLanguage)+": "+s2;
				}
				if(s2.length()>0) {
					if(s3.length()>0) {
						s3+="{sep}";
					}
					s3+=s2;
				}
			}
			s=s3;
		}
		
		return s;
	}
}
