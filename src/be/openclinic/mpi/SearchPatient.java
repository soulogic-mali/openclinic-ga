package be.openclinic.mpi;

import java.util.Enumeration;
import java.util.Hashtable;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;

public class SearchPatient {
	public String mpiid="";
	public String healthfacility="";
	public String healthfacilityid="";
	public String lastname="";
	public String firstname="";
	public String dateofbirth="";
	public String telephone="";
	public String email="";
	public String natreg="";
	
	
	public SearchPatient(String mpiid, String healthfacility, String healthfacilityid, String lastname,
			String firstname, String dateofbirth, String telephone, String email, String natreg) {
		super();
		this.mpiid = mpiid;
		this.healthfacility = healthfacility;
		this.healthfacilityid = healthfacilityid;
		this.lastname = lastname;
		this.firstname = firstname;
		this.dateofbirth = dateofbirth;
		this.telephone = telephone;
		this.email = email;
		this.natreg = natreg;
	}

	public boolean isEmpty() {
		return (mpiid+healthfacility+healthfacilityid+lastname+firstname+dateofbirth+telephone+email+natreg).length()==0;
	}

	public boolean match(AdminPerson p){
		if(mpiid.length()>0 && !mpiid.equalsIgnoreCase(ScreenHelper.convertToUUID(p.personid))) return false;
		if(natreg.length()>0 && !natreg.equalsIgnoreCase(p.getID("natreg"))) return false;
		if(healthfacility.length()>0 && healthfacilityid.length()>0){
			if(p.adminextends.get("facilityid$"+healthfacility)==null || !((String)p.adminextends.get("facilityid$"+healthfacility)).equalsIgnoreCase(healthfacilityid)){
				return false;
			}
		}
		if(lastname.length()>0 && !ScreenHelper.normalizeSpecialCharacters(p.lastname.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(lastname.toLowerCase()))) return false;
		if(firstname.length()>0 && !ScreenHelper.normalizeSpecialCharacters(p.firstname.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(firstname.toLowerCase()))) return false;
		if(dateofbirth.length()>0 && !dateofbirth.equalsIgnoreCase(p.dateOfBirth)) return false;
		if(telephone.length()>0 && !(ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().telephone.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(telephone.toLowerCase())) || ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().mobile.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(telephone.toLowerCase())))) return false;
		if(email.length()>0 && !ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().email.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(email.toLowerCase()))) return false;
		return true;
	}
	
	public int matchProbability(AdminPerson p){
		int score=0;
		if(mpiid.length()>0 && mpiid.equalsIgnoreCase(ScreenHelper.convertToUUID(p.personid))) {
			score+=500;
		}
		if(natreg.length()>0 && natreg.equalsIgnoreCase(p.getID("natreg"))) {
			score+=200;
		}
		if(healthfacility.length()>0 && healthfacilityid.length()>0){
			if(p.adminextends.get("facilityid$"+healthfacility)!=null && ((String)p.adminextends.get("facilityid$"+healthfacility)).equalsIgnoreCase(healthfacilityid)){
				score+=200;
			}
		}
		if(lastname.length()>0 && ScreenHelper.normalizeSpecialCharacters(p.lastname.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(lastname.toLowerCase()))) {
			score+=70;
		}
		if(firstname.length()>0 && ScreenHelper.normalizeSpecialCharacters(p.firstname.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(firstname.toLowerCase()))) {
			score+=40;
		}
		if(dateofbirth.length()>0 && dateofbirth.equalsIgnoreCase(p.dateOfBirth)) {
			score+=150;
		}
		if(telephone.length()>0 && (ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().telephone.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(telephone.toLowerCase())) || ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().mobile.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(telephone.toLowerCase())))) {
			score+=90;
		}
		if(email.length()>0 && ScreenHelper.normalizeSpecialCharacters(p.getActivePrivate().email.toLowerCase()).contains(ScreenHelper.normalizeSpecialCharacters(email.toLowerCase()))) {
			score+=90;
		}
		return score;
	}
	
	public SortedMap<String,AdminPerson> searchProbabilistic(Hashtable<String,AdminPerson> persons) {
		if(mpiid.length()>0){
			int personid = ScreenHelper.convertFromUUID(mpiid);
			if(personid>-1){
				AdminPerson p = AdminPerson.get(personid+"");
				if(p.isNotEmpty()){
					p.adminextends.put("mpimatch", matchProbability(p)+"");
					persons.put(p.personid,p);
				}
			}
		}
		if(natreg.length()>0){
			String s = AdminPerson.getPersonIdByNatReg(natreg);
			if(s!=null){
				AdminPerson p = AdminPerson.get(s);
				if(p.isNotEmpty()){
					p.adminextends.put("mpimatch", matchProbability(p)+"");
					persons.put(p.personid,p);
				}
			}
		}
		if(healthfacility.length()>0 && healthfacilityid.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByExtendValue("facilityid$"+healthfacility,healthfacilityid);
			for(int n=0;n<p.size();n++) {
				p.elementAt(n).adminextends.put("mpimatch", matchProbability(p.elementAt(n))+"");
			}
			copyPersons(p,persons);
		}
		if(telephone.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByTelephone(telephone);
			for(int n=0;n<p.size();n++) {
				p.elementAt(n).adminextends.put("mpimatch", matchProbability(p.elementAt(n))+"");
			}
			copyPersons(p,persons);
		}
		if(email.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByEmail(email);
			for(int n=0;n<p.size();n++) {
				p.elementAt(n).adminextends.put("mpimatch", matchProbability(p.elementAt(n))+"");
			}
			copyPersons(p,persons);
		}
		if(firstname.length()>0 || lastname.length()>0) {
			Vector<Hashtable> v = AdminPerson.searchPatients(ScreenHelper.normalizeSpecialCharacters(lastname), ScreenHelper.normalizeSpecialCharacters(firstname), "", "", false);
			for(int n=0;n<v.size() && n<100;n++){
				AdminPerson p = AdminPerson.get((String)v.elementAt(n).get("personid"));
				p.adminextends.put("mpimatch", matchProbability(p)+"");
				persons.put(p.personid,p);
			}
		}
		if(dateofbirth.length()>0) {
			Vector<Hashtable> v = AdminPerson.searchPatients("", "", "", dateofbirth, false);
			for(int n=0;n<v.size() && n<100;n++){
				AdminPerson p = AdminPerson.get((String)v.elementAt(n).get("personid"));
				p.adminextends.put("mpimatch", matchProbability(p)+"");
				persons.put(p.personid,p);
			}
		}
		SortedMap<String,AdminPerson> sortedPatients = new TreeMap();
		Enumeration<String> ePatients = persons.keys();
		while(ePatients.hasMoreElements()){
			String key = ePatients.nextElement();
			AdminPerson p = (AdminPerson)persons.get(key);
			sortedPatients.put(ScreenHelper.padLeft((2000-Double.parseDouble((String)p.adminextends.get("mpimatch")))+"","0",5)+"$"+p.lastname+"$"+p.firstname+"$"+p.personid,p);
		}
		return sortedPatients;
	}
	
	public SortedMap searchExact(Hashtable persons){
		if(mpiid.length()>0){
			int personid = ScreenHelper.convertFromUUID(mpiid);
			if(personid>-1){
				AdminPerson p = AdminPerson.get(personid+"");
				if(p.isNotEmpty() && match(p)){
					persons.put(p.personid,p);
				}
			}
		}
		else if(natreg.length()>0){
			String s = AdminPerson.getPersonIdByNatReg(natreg);
			if(s!=null){
				AdminPerson p = AdminPerson.get(s);
				if(p.isNotEmpty() && match(p)){
					persons.put(p.personid,p);
				}
			}
		}
		else if(healthfacility.length()>0 && healthfacilityid.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByExtendValue("facilityid$"+healthfacility,healthfacilityid);
			copyPersons(p,persons);
		}
		else if(telephone.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByTelephone(telephone);
			copyPersons(p,persons);
		}
		else if(email.length()>0){
			Vector<AdminPerson> p = AdminPerson.getAdminPersonsByEmail(email);
			copyPersons(p,persons);
		}
		else{
			Vector<Hashtable> v = AdminPerson.searchPatients(ScreenHelper.normalizeSpecialCharacters(lastname), ScreenHelper.normalizeSpecialCharacters(firstname), "", dateofbirth, false);
			for(int n=0;n<v.size() && n<100;n++){
				AdminPerson p = AdminPerson.get((String)v.elementAt(n).get("personid"));
				persons.put(p.personid,p);
			}
		}
		SortedMap sortedPatients = new TreeMap();
		Enumeration<String> ePatients = persons.keys();
		while(ePatients.hasMoreElements()){
			String key = ePatients.nextElement();
			AdminPerson p = (AdminPerson)persons.get(key);
			sortedPatients.put(p.lastname+"$"+p.firstname+"$"+p.personid,p);
		}
		return sortedPatients;
	}
	
	private void copyPersons(Vector<AdminPerson> v,Hashtable h){
		for(int n=0;n<v.size();n++){
			if(match(v.elementAt(n))){
				h.put(v.elementAt(n).personid, v.elementAt(n));
			}
		}
	}
}
