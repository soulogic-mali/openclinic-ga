package be.openclinic.api;

import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;

import javax.servlet.http.HttpServletRequest;

import be.openclinic.mpi.SearchPatient;
import net.admin.AdminPerson;

public class Patient extends API{
	
	public Patient(HttpServletRequest request) {
		super(request);
	}
	
	@Override
	public String get() {
		String s = "<patients>";
		if(exists("personid")) {
			s += AdminPerson.get(value("personid")).toXml();
		}
		else if((value("lastname")+value("firstname")+value("dateofbirth")+value("natreg")+value("telephone")+value("email")).length()>0){
			SearchPatient searchPatient = new SearchPatient(value("mpiid"), "", "", value("lastname"), value("firstname"), value("dateofbirth"), value("telephone"), value("email"), value("natreg"));
			Hashtable<String,AdminPerson> h = new Hashtable<String,AdminPerson>();
			SortedMap<String,AdminPerson> pm = searchPatient.searchProbabilistic(h);
			Iterator<String> i = pm.keySet().iterator();
			while(i.hasNext()) {
				String key = i.next();
				AdminPerson patient = pm.get(key);
				s+=patient.toXml();
			}
			
		}
		s+="</patients>";
		return format(s);
	}
	
	@Override
	public String set() {
		return null;
	}
	
}
