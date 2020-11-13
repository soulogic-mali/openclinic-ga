package be.hapi;

import java.util.Collections;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;
import java.util.UUID;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hl7.fhir.r4.model.Enumerations;
import org.hl7.fhir.r4.model.Enumerations.AdministrativeGender;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Identifier;
import org.hl7.fhir.r4.model.Identifier.IdentifierUse;
import org.hl7.fhir.r4.model.Patient;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Picture;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.mpi.SearchPatient;
import ca.uhn.fhir.rest.annotation.Create;
import ca.uhn.fhir.rest.annotation.Destroy;
import ca.uhn.fhir.rest.annotation.IdParam;
import ca.uhn.fhir.rest.annotation.OptionalParam;
import ca.uhn.fhir.rest.annotation.Read;
import ca.uhn.fhir.rest.annotation.RequiredParam;
import ca.uhn.fhir.rest.annotation.ResourceParam;
import ca.uhn.fhir.rest.annotation.Search;
import ca.uhn.fhir.rest.annotation.Update;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.gclient.TokenClientParam;
import ca.uhn.fhir.rest.param.DateParam;
import ca.uhn.fhir.rest.param.NumberParam;
import ca.uhn.fhir.rest.param.StringParam;
import ca.uhn.fhir.rest.param.TokenParam;
import ca.uhn.fhir.rest.server.IResourceProvider;
import ca.uhn.fhir.rest.server.exceptions.UnprocessableEntityException;
import net.admin.AdminPerson;

public class RestfulPatientResourceProvider implements IResourceProvider {

	@Override
	public Class<Patient> getResourceType() {
		return Patient.class;
	}

	@Read
	public Patient getResourceById(@IdParam IdType theId) {
		//Todo: find the patient in the OpenClinic database
		int personid = ScreenHelper.convertFromUUID(theId.getIdPart());
		if(personid>-1) {
			AdminPerson person = AdminPerson.getAdminPerson(personid+"");
			if(person.isNotEmpty()) {
			    return person.getFHIRPatient();
			}
		}
		else {
			AdminPerson person = AdminPerson.getAdminPerson(theId.getIdPart());
			if(person.isNotEmpty()) {
			    return person.getFHIRPatient();
			}
		}
		return null;
	}

	@Search
	public List<Patient> findPatients(
				@OptionalParam(name = Patient.SP_IDENTIFIER) TokenParam identifier,
				@OptionalParam(name = Patient.SP_GENDER) TokenParam gender,
				@OptionalParam(name = Patient.SP_BIRTHDATE) DateParam birthdate,
				@OptionalParam(name = Patient.SP_FAMILY) StringParam lastname,
				@OptionalParam(name = Patient.SP_GIVEN) StringParam firstname,
				@OptionalParam(name = Patient.SP_TELECOM) StringParam telephone,
				@OptionalParam(name = Patient.SP_EMAIL) StringParam email,
				@OptionalParam(name = "mpiid") StringParam mpiid,
				@OptionalParam(name = "natreg") StringParam natreg,
				@OptionalParam(name = "probabilistic") NumberParam probabilistic,
				HttpServletRequest theRequest, 
				HttpServletResponse theResponse) {
		List<Patient> patients = new Vector<Patient>();
		if(probabilistic!=null && probabilistic.getValue().intValue()>0) {
			String s_mpiid = cs(mpiid).replaceAll("\\*", "%");
			String s_natreg = cs(natreg).replaceAll("\\*", "%");
			String s_healthfacility = "",s_healthfacilityid="";
			if(identifier!=null) {
				s_healthfacility = ScreenHelper.checkString(identifier.getSystem());
				s_healthfacilityid = ScreenHelper.checkString(identifier.getValue());
			}
			String s_dateofbirth = "";
			if(birthdate!=null) s_dateofbirth=ScreenHelper.formatDate(birthdate.getValue());
			String s_lastname = cs(lastname).replaceAll("\\*", "%");
			String s_firstname = cs(firstname).replaceAll("\\*", "%");
			String s_telephone = cs(telephone).replaceAll("\\*", "%");
			String s_email = cs(email).replaceAll("\\*", "%");
			
			SearchPatient searchPatient = new SearchPatient(s_mpiid, s_healthfacility, s_healthfacilityid, s_lastname, s_firstname, s_dateofbirth, s_telephone, s_email, s_natreg);
			Hashtable h = new Hashtable();
			SortedMap<String,AdminPerson> pm = searchPatient.searchProbabilistic(h);
			Iterator<String> iPatients = pm.keySet().iterator();
			while(iPatients.hasNext()) {
				String key = iPatients.next();
				patients.add(pm.get(key).getFHIRPatient());
			}
		}
		else {
			if(mpiid != null) {
				String s_mpiid = cs(mpiid);
				int personid = ScreenHelper.convertFromUUID(s_mpiid);
				if(personid>-1){
					AdminPerson person = AdminPerson.getAdminPerson(personid+"");
					if(person.isNotEmpty()) {
						//The AdminPerson object exists and was loaded
						//Now check against the other parameters
						boolean bOk=true;
						if(gender!=null && gender.getValue().equals(Enumerations.AdministrativeGender.MALE.toCode()) && !person.gender.equalsIgnoreCase("m")) {
							bOk=false;
						}
						else if(gender!=null && gender.getValue().equals(Enumerations.AdministrativeGender.FEMALE.toCode()) && !person.gender.equalsIgnoreCase("f")) {
							bOk=false;
						}
						if(bOk && birthdate!=null && (ScreenHelper.checkString(person.dateOfBirth).length()==0 || !birthdate.getValue().equals(ScreenHelper.parseDate(person.dateOfBirth)))){
							bOk=false;
						}
						if(bOk && lastname!=null && !person.lastname.toLowerCase().contains(lastname.getValue().toLowerCase())) {
							bOk=false;
						}
						if(bOk && firstname!=null && !person.firstname.toLowerCase().contains(firstname.getValue().toLowerCase())) {
							bOk=false;
						}
						if(bOk) {
							patients.add(person.getFHIRPatient());
						}
					}
				}
			}
			else if(identifier!=null) {
				//Search patient based on unique (non-KHIN) identifier
				String personid = Pointer.getPointer("facilityid$"+identifier.getValue()+"$"+identifier.getSystem()); 
				if(personid.length()>0) {
					//The pointer exists. Try to load the AdminPerson object
					AdminPerson person = AdminPerson.getAdminPerson(personid);
					if(person.isNotEmpty()) {
						//The AdminPerson object exists and was loaded
						//Now check against the other parameters
						boolean bOk=true;
						if(gender!=null && gender.getValue().equals(Enumerations.AdministrativeGender.MALE.toCode()) && !person.gender.equalsIgnoreCase("m")) {
							bOk=false;
						}
						else if(gender!=null && gender.getValue().equals(Enumerations.AdministrativeGender.FEMALE.toCode()) && !person.gender.equalsIgnoreCase("f")) {
							bOk=false;
						}
						if(bOk && birthdate!=null && (ScreenHelper.checkString(person.dateOfBirth).length()==0 || !birthdate.getValue().equals(ScreenHelper.parseDate(person.dateOfBirth)))){
							bOk=false;
						}
						if(bOk && lastname!=null && !person.lastname.toLowerCase().contains(lastname.getValue().toLowerCase())) {
							bOk=false;
						}
						if(bOk && firstname!=null && !person.firstname.toLowerCase().contains(firstname.getValue().toLowerCase())) {
							bOk=false;
						}
						if(bOk) {
							patients.add(person.getFHIRPatient());
						}
					}
				}
			}
			else {
				String f_lastname = lastname==null?"":lastname.getValue().replaceAll("\\*", "%");
				String f_firstname = firstname==null?"":firstname.getValue().replaceAll("\\*", "%");
				String f_gender = "";
				if(gender!=null && gender.getValue().equals(Enumerations.AdministrativeGender.MALE.toCode())){
					f_gender="m";
				}
				else if(gender !=null && gender.getValue().equals(Enumerations.AdministrativeGender.MALE.toCode())){
					f_gender="f";
				}
				String f_dob = "";
				if(birthdate!=null) {
					f_dob=ScreenHelper.formatDate(birthdate.getValue());
				}
				//We don't have an identifier, so we are going to fetch the patients based on the provided criteria
				Vector<Hashtable> persons = AdminPerson.searchPatients(f_lastname, f_firstname, f_gender, f_dob, false);
				for(int n=0;n<persons.size();n++) {
					if(n>MedwanQuery.getInstance().getConfigInt("maxFHIRResourcesReturned",100)) {
						break;
					}
					AdminPerson person = AdminPerson.get(""+persons.elementAt(n).get("personid"));
					Patient patient = person.getFHIRPatient();
					if(patient!=null) {
						patients.add(patient);
					}
				}
			}
		}
	    return patients;
	}
	
	@Update
	public MethodOutcome update(@IdParam IdType theId, @ResourceParam Patient thePatient) {
		AdminPerson person = AdminPerson.fromFIHRPatient(thePatient);
		//First make sure the patient already exists. Otherwise, switch to create
		boolean bExists = false;
		if (thePatient.getId()!=null && !thePatient.getId().isEmpty()) {
			//First try with the MPI ID
			AdminPerson ap = AdminPerson.get(ScreenHelper.convertFromUUID(thePatient.getId().replaceAll("Patient/", ""))+"");
			bExists=ap.isNotEmpty();
		}
		if(!bExists) {
			//Now try with an alternate identifier
			List<Identifier> identifiers = thePatient.getIdentifier();
		    Iterator<Identifier> iIdentifiers = identifiers.iterator();
		    while(iIdentifiers.hasNext()) {
		    	Identifier identifier = iIdentifiers.next();
				String personid = Pointer.getPointer("facilityid$"+identifier.getValue()+"$"+identifier.getSystem()); 
				if(personid.length()>0) {
					AdminPerson ap = AdminPerson.get(ScreenHelper.convertFromUUID(thePatient.getId().replaceAll("Patient/", ""))+"");
					bExists=ap.isNotEmpty();
					if(bExists) {
						person.personid=personid;
					}
				}
		    }
		}
		if(bExists) {
			//The patient exists, we can update the record
			person.store();
	    	if(thePatient.getPhoto()!=null && !thePatient.getPhoto().isEmpty()) {
	    		if(!Picture.exists(Integer.parseInt(person.personid))){
	    			Picture picture = new Picture();
	    			picture.setPersonid(Integer.parseInt(person.personid));
	    			picture.setPicture(thePatient.getPhotoFirstRep().getData());
	    			picture.store();
	    		}
	    	}

		    MethodOutcome retVal = new MethodOutcome();
		    retVal.setId(new IdType("Patient", ScreenHelper.convertToUUID(person.personid), person.getVersion()+""));
		    return retVal;
		}
		else {
			//The patient doesn't exist, create the record
			return createPatient(thePatient);
		}
	}
	
	@Create 
	public MethodOutcome createPatient(@ResourceParam Patient thePatient) {
	    if (thePatient.getIdentifierFirstRep().isEmpty()) {
	    	throw new UnprocessableEntityException("At least one identifier must be provided");
	    }
	    else if (thePatient.getId()!=null && !thePatient.getId().isEmpty()) {
	    	throw new UnprocessableEntityException("The patient already exists with id "+thePatient.getId());
	    }
	    else if (thePatient.getName()==null || thePatient.getName().isEmpty()) {
	    	throw new UnprocessableEntityException("At least a family name or given name must be provided");
	    }
	    else if(!thePatient.getIdentifierFirstRep().isEmpty()){
	    	boolean bHasSecondary=false;
	    	List<Identifier> identifiers = thePatient.getIdentifier();
	    	Iterator<Identifier> iIdentifiers = identifiers.iterator();
	    	while(iIdentifiers.hasNext()) {
	    		if(iIdentifiers.next().getUse().equals(IdentifierUse.SECONDARY)) {
	    			bHasSecondary=true;
	    			break;
	    		}
	    	}
	    	if(!bHasSecondary) {
		    	throw new UnprocessableEntityException("At least one health facility identifier must be provided");
	    	}
	    }
	    List<Identifier> identifiers = thePatient.getIdentifier();
	    Iterator<Identifier> iIdentifiers = identifiers.iterator();
	    while(iIdentifiers.hasNext()) {
	    	Identifier identifier = iIdentifiers.next();
			String personid = Pointer.getPointer("facilityid$"+identifier.getValue()+"$"+identifier.getSystem()); 
			if(personid.length()>0) {
				//The pointer exists. Try to load the AdminPerson object
				AdminPerson person = AdminPerson.getAdminPerson(personid);
				if(person.isNotEmpty()) {
			    	throw new UnprocessableEntityException("The patient already exists with id "+ScreenHelper.convertToUUID(person.personid));
				}
			}
	    }
	    AdminPerson person = AdminPerson.fromFIHRPatient(thePatient);
	    person.updateuserid="4";
	    person.sourceid="1";
	    person.store();
    	if(thePatient.getPhoto()!=null && !thePatient.getPhoto().isEmpty()) {
			Picture picture = new Picture();
			picture.setPersonid(Integer.parseInt(person.personid));
			picture.setPicture(thePatient.getPhotoFirstRep().getData());
			picture.store();
    	}
	    MethodOutcome retVal = new MethodOutcome();
	    retVal.setId(new IdType("Patient", ScreenHelper.convertToUUID(person.personid), "1"));
	    return retVal;
	}
			
	
	@Destroy
	public void destroy() {
	}
	
	private String cs(StringParam sp) {
		if(sp==null) {
			return "";
		}
		else {
			return ScreenHelper.checkString(sp.getValue());
		}
	}
}
