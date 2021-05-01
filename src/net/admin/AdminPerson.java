package net.admin;

import be.dpms.medwan.common.model.vo.occupationalmedicine.ExportActivityVO;
import be.hapi.BundleProcessor;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.Mail;
import be.mxs.common.util.system.Picture;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.UpdateSystem;
import be.mxs.common.util.tools.sendHtmlMail;
import be.openclinic.adt.Encounter;
import be.openclinic.common.OC_Object;
import be.openclinic.finance.Insurance;
import be.openclinic.medical.Prescription;
import be.openclinic.reporting.TimeFilterReportGenerator;
import be.openclinic.system.SH;
import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.model.primitive.BooleanDt;
import ca.uhn.fhir.model.primitive.DateTimeDt;
import ca.uhn.fhir.rest.api.MethodOutcome;
import ca.uhn.fhir.rest.client.api.IGenericClient;
import ca.uhn.fhir.rest.client.interceptor.BasicAuthInterceptor;
import ca.uhn.fhir.rest.gclient.IQuery;
import ca.uhn.fhir.rest.gclient.NumberClientParam;
import ca.uhn.fhir.rest.gclient.StringClientParam;
import ca.uhn.fhir.rest.gclient.TokenClientParam;
import ca.uhn.fhir.rest.server.exceptions.UnprocessableEntityException;

import java.io.ByteArrayInputStream;
import java.lang.reflect.Field;
import java.sql.*;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import org.apache.commons.text.RandomStringGenerator;
import org.dcm4che2.data.Implementation;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.hl7.fhir.instance.model.api.IBaseBundle;
import org.hl7.fhir.instance.model.api.IIdType;
import org.hl7.fhir.r4.model.Address;
import org.hl7.fhir.r4.model.Attachment;
import org.hl7.fhir.r4.model.BooleanType;
import org.hl7.fhir.r4.model.Bundle;
import org.hl7.fhir.r4.model.CodeableConcept;
import org.hl7.fhir.r4.model.Coding;
import org.hl7.fhir.r4.model.ContactPoint;
import org.hl7.fhir.r4.model.DateTimeType;
import org.hl7.fhir.r4.model.Enumerations;
import org.hl7.fhir.r4.model.Extension;
import org.hl7.fhir.r4.model.HumanName;
import org.hl7.fhir.r4.model.IdType;
import org.hl7.fhir.r4.model.Identifier;
import org.hl7.fhir.r4.model.Patient;
import org.hl7.fhir.r4.model.StringType;
import org.hl7.fhir.r4.model.Type;
import org.hl7.fhir.r4.model.Identifier.IdentifierUse;

import net.admin.system.AccessLog;


public class AdminPerson extends OC_Object{
    // declarations
    public String personid;
    public String sourceid;
    public Vector ids;
    public String lastname;
    public String middlename;
    public String firstname;
    public String language;
    public String gender;
    public String dateOfBirth;
    public String comment;
    public Vector privateContacts;
    public Vector familyRelations;
    public Vector workContacts;
    public String pension;
    public String engagement;
    public String statute;
    public String claimant;
    public String claimantExpiration;
    public String nativeCountry;
    public String nativeTown;
    public String personType;
    public String situationEndOfService;
    public String motiveEndOfService;
    public String startdateInactivity;
    public String enddateInactivity;
    public String codeInactivity;
    public String updateStatus;
    public String updateuserid;
    public String comment1;
    public String comment2;
    public String comment3;
    public String comment4;
    public String comment5;
    public String begin;
    public String end;
    public Hashtable<String,String> adminextends;
    public boolean export = true;
    public boolean checkNatreg = MedwanQuery.getInstance().getConfigInt("checkNatreg",1)==1;
    public boolean checkImmatnew = MedwanQuery.getInstance().getConfigInt("checkImmatnew",1)==1;
    public boolean checkImmatold = MedwanQuery.getInstance().getConfigInt("checkImmatold",0)==1;
    public boolean checkArchiveFileCode = false;
    String activeMedicalCenter="";
    String activeMD="";
    String activePara="";
    public AdminSocSec socsec;
    public java.util.Date modifyTime;
    public byte[] picture = null;

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public AdminPerson() {
        personid = "";
        sourceid = "";
        ids = new Vector();
        lastname = "";
        middlename = "";
        firstname = "";
        language = "";
        gender = "";
        dateOfBirth = "";
        comment = "";
        privateContacts = new Vector();
        familyRelations = new Vector();
        workContacts = new Vector();
        pension = "";
        engagement = "";
        statute = "";
        claimant = "";
        claimantExpiration = "";
        nativeCountry = "";
        nativeTown = "";
        personType = "";
        situationEndOfService = "";
        motiveEndOfService = "";
        startdateInactivity = "";
        enddateInactivity = "";
        codeInactivity = "";
        updateStatus = "";
        updateuserid = "";
        comment1 = "";
        comment2 = "";
        comment3 = "";
        comment4 = "";
        comment5 = "";
        begin = "";
        end = "";
        adminextends = new Hashtable();
        socsec = new AdminSocSec();

        export = true;
        checkNatreg = MedwanQuery.getInstance().getConfigInt("checkNatreg",1)==1;
        checkImmatnew = MedwanQuery.getInstance().getConfigInt("checkImmatnew",1)==1;
        checkImmatold = MedwanQuery.getInstance().getConfigInt("checkImmatold",0)==1;
        checkArchiveFileCode = false;
    }
    
    public int getPersonId() {
    	try {
    		return Integer.parseInt(personid);
    	}
    	catch(Exception e) {
    		return -1;
    	}
    }
    
    public SortedMap<String,AdminPerson> searchMPI(){
    	Vector<Patient> patients = new Vector();
    	try {
	    	FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
	    	IGenericClient client = ctx.newRestfulGenericClient(MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir"));
    		BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
	    	client.registerInterceptor(auth);
	    	// Perform a search
	    	IQuery<IBaseBundle> query = client
	    	      .search()
	    	      .forResource(Patient.class);
	    	if(adminextends.get("mpiid")!=null){
	    		query = query.where(new StringClientParam("mpiid").matches().value((String)adminextends.get("mpiid")));
	    	}
	    	query = query.where(Patient.IDENTIFIER.exactly().systemAndIdentifier(MedwanQuery.getInstance().getConfigString("hin.server.identifier","hin.facility.undefined"), personid));
	    	if(ScreenHelper.checkString(getID("natreg")).length()>0){
	    		query = query.where(new StringClientParam("natreg").matches().value(getID("natreg")));
	    	}
	    	query = query.where(Patient.FAMILY.matches().value(lastname));
	    	query = query.where(Patient.GIVEN.matches().value(firstname));
	    	if(ScreenHelper.parseDate(dateOfBirth)!=null){
	    		query = query.where(Patient.BIRTHDATE.exactly().day(ScreenHelper.parseDate(dateOfBirth)));
	    	}
	    	if(ScreenHelper.checkString(gender).length()>0){
	    		query = query.where(new TokenClientParam("gender").exactly().code(ScreenHelper.checkString(gender).equalsIgnoreCase("m")?Enumerations.AdministrativeGender.MALE.toCode():ScreenHelper.checkString(gender).equalsIgnoreCase("f")?Enumerations.AdministrativeGender.FEMALE.toCode():Enumerations.AdministrativeGender.UNKNOWN.toCode()));
	    	}
	    	if(ScreenHelper.checkString(getActivePrivate().telephone).length()>0){
	    		query = query.where(new StringClientParam("telecom").matches().value(getActivePrivate().telephone));
	    	}
	    	if(ScreenHelper.checkString(getActivePrivate().email).length()>0){
	    		query = query.where(new StringClientParam("email").matches().value(getActivePrivate().email));
	    	}
	    	query = query.where(new NumberClientParam("probabilistic").greaterThan().number(1));
	        Bundle results = query.returnBundle(Bundle.class).prettyPrint().execute();
	    	patients = BundleProcessor.extractResourcesFromBundle(results, "Patient");    
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	SortedMap<String,AdminPerson> sortedPatients = new TreeMap();
    	for(int n=0;n<patients.size();n++){
    		AdminPerson p = AdminPerson.fromFIHRPatient(patients.elementAt(n));
    		sortedPatients.put(ScreenHelper.padLeft((2000- Double.parseDouble((String)p.adminextends.get("mpimatch")))+"","0",5)+"$"+p.adminextends.get("mpiid"), p);
    	}
    	return sortedPatients;
    }
    
    public static AdminPerson getMPI(String mpiid) {
    	AdminPerson person = new AdminPerson();
    	if(mpiid.length()>0){
    		FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
    		IGenericClient client = ctx.newRestfulGenericClient(MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir"));
    		BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
    		client.registerInterceptor(auth);
    		try{
    			Patient patient = client
    				      .read()
    				      .resource(Patient.class)
    				      .withId(mpiid)
    				      .execute();
    			person = AdminPerson.fromFIHRPatient(patient);
    		}
    		catch(Exception e){
    			person.updateStatus=e.getMessage();
    			e.printStackTrace();
    			//Patient doesn't exist on MPI server side. Person object will remain empty.
    		}
    	}
    	return person;
    }
    
    public long updateMPI() {
    	long retVal = -1;
    	try {
			FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
			IGenericClient client = ctx.newRestfulGenericClient(MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir"));
			BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
			client.registerInterceptor(auth);
			MethodOutcome outcome = client.update()
					   .resource(getFHIRPatient())
					   .execute();
			retVal=outcome.getId().getVersionIdPartAsLong();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return retVal;
    }
    
    public long createMPI() {
    	long retVal = -1;
    	try {
	    	FhirContext ctx = MedwanQuery.getInstance().getFhirContext();
	    	IGenericClient client = ctx.newRestfulGenericClient(MedwanQuery.getInstance().getConfigString("MPIFhirServerURL","http://mpi.ocf.world/openclinic/fhir"));
	    	BasicAuthInterceptor auth = new BasicAuthInterceptor(MedwanQuery.getInstance().getConfigString("MPIServerLogin","changeme"),MedwanQuery.getInstance().getConfigString("MPIServerPassword","changeme"));
	    	client.registerInterceptor(auth);
	    	MethodOutcome outcome = client.create()
	    		.resource(getFHIRPatient())
	    		.prettyPrint()
	    		.encodedXml()
	    		.execute();
	    	IIdType id = outcome.getId();
	    	adminextends.put("mpiid",id.getIdPart());
	    	store();
	    	retVal = id.getVersionIdPartAsLong();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return retVal;
    }
    
    public String getLastnameFather(){
    	return lastname.replaceAll(ScreenHelper.checkString(middlename), "").trim();
    }
    
    public String getLastnameMother(){
    	return ScreenHelper.checkString(middlename).trim();
    }
    
    public void setLastnames(String lastnamefather, String lastnamemother){
    	lastname = lastnamefather+" "+lastnamemother;
    	middlename = lastnamemother;
    }
    
    private String xe(String s){
    	return HTMLEntities.xmlencode(ScreenHelper.checkString(s));
    }
    
    public String toXml(){
    	return toXmlElement().asXML();
    }
    
    public String getBioGender(){
    	if(ScreenHelper.checkString((String)adminextends.get("biologicgender")).equalsIgnoreCase("1")){
    		return gender.equalsIgnoreCase("m")?"f":"m";
    	}
    	else{
    		return gender;
    	}
    }
    
    public Element toXmlElement(){
    	return toXmlElement("");
    }
    
    public Element toXmlElement(String destinationPersonId){
        Element patient = DocumentHelper.createElement("person");
        patient.addAttribute("personid",ScreenHelper.checkString(personid));
        if(ScreenHelper.checkString(destinationPersonId).length()>0){
            patient.addAttribute("destpersonid",ScreenHelper.checkString(destinationPersonId));
        }
        patient.addElement("firstname").setText(xe(firstname));
        patient.addElement("lastname").setText(xe(lastname));
        patient.addElement("dateofbirth").setText(xe(dateOfBirth));
        patient.addElement("sourceid").setText(xe(sourceid));
        patient.addElement("gender").setText(xe(gender));
        patient.addElement("language").setText(xe(language));
        patient.addElement("immatnew").setText(xe(getID("immatnew")));
        patient.addElement("natreg").setText(xe(getID("natreg")));
        patient.addElement("immatold").setText(xe(getID("immatold")));
        patient.addElement("nativecountry").setText(xe(nativeCountry));
        patient.addElement("nativetown").setText(xe(nativeTown));
        patient.addElement("comment").setText(xe(comment));
        patient.addElement("comment1").setText(xe(comment1));
        patient.addElement("comment2").setText(xe(comment2));
        patient.addElement("comment3").setText(xe(comment3));
        patient.addElement("comment4").setText(xe(comment4));
        patient.addElement("comment5").setText(xe(comment5));
        patient.addElement("sourceid").setText(xe(sourceid));
        if(getActivePrivate()!=null){
        	AdminPrivateContact pc=getActivePrivate();
        	Element priv = patient.addElement("private");
        	priv.addElement("address").setText(xe(pc.address));
        	priv.addElement("begin").setText(xe(pc.begin));
        	priv.addElement("end").setText(xe(pc.end));
        	priv.addElement("business").setText(xe(pc.business));
        	priv.addElement("businessfunction").setText(xe(pc.businessfunction));
        	priv.addElement("cell").setText(xe(pc.cell));
        	priv.addElement("city").setText(xe(pc.city));
        	priv.addElement("comment").setText(xe(pc.comment));
        	priv.addElement("country").setText(xe(pc.country));
        	priv.addElement("district").setText(xe(pc.district));
        	priv.addElement("email").setText(xe(pc.email));
        	priv.addElement("fax").setText(xe(pc.fax));
        	priv.addElement("mobile").setText(xe(pc.mobile));
        	priv.addElement("province").setText(xe(pc.province));
        	priv.addElement("quarter").setText(xe(pc.quarter));
        	priv.addElement("sanitarydistrict").setText(xe(pc.sanitarydistrict));
        	priv.addElement("sector").setText(xe(pc.sector));
        	priv.addElement("telephone").setText(xe(pc.telephone));
        	priv.addElement("type").setText(xe(pc.type));
        	priv.addElement("zipcode").setText(xe(pc.zipcode));
        }
        return patient;
    }
    
    public static AdminPerson fromXml(String s,boolean bIncludePersonId){
    	AdminPerson person = new AdminPerson();
        SAXReader reader = new SAXReader(false);
    	try {
			Document document = reader.read(new ByteArrayInputStream(s.getBytes()));
			Element patient = document.getRootElement();
			person.fromXmlElement(patient, bIncludePersonId);
		} catch (DocumentException e) {
			e.printStackTrace();
			return null;
		}

    	return person;
    }
    
    public void fromXmlElement(Element patient,boolean bIncludePersonId){
		if(bIncludePersonId){
			personid=patient.attributeValue("personid");
		}
		comment=patient.elementText("comment");
		comment1=patient.elementText("comment1");
		comment2=patient.elementText("comment2");
		comment3=patient.elementText("comment3");
		comment4=patient.elementText("comment4");
		comment5=patient.elementText("comment5");
		dateOfBirth=patient.elementText("dateofbirth");
		firstname=patient.elementText("firstname");
		gender=patient.elementText("gender");
		language=patient.elementText("language");
		lastname=patient.elementText("lastname");
		nativeCountry=patient.elementText("nativecountry");
		nativeTown=patient.elementText("nativetown");
		sourceid=patient.elementText("sourceid");
		setID("immatold",patient.elementText("immatold"));
		setID("immatnew",patient.elementText("immatnew"));
		setID("natreg",patient.elementText("natreg"));
		if(patient.element("private")!=null){
			privateContacts=new Vector();
			Element pc=patient.element("private");
			AdminPrivateContact priv = new AdminPrivateContact();
			priv.address=pc.elementText("address");
			priv.begin=pc.elementText("begin");
			priv.business=pc.elementText("business");
			priv.businessfunction=pc.elementText("businessfunction");
			priv.cell=pc.elementText("cell");
			priv.city=pc.elementText("city");
			priv.comment=pc.elementText("comment");
			priv.country=pc.elementText("country");
			priv.district=pc.elementText("district");
			priv.email=pc.elementText("email");
			priv.end=pc.elementText("end");
			priv.fax=pc.elementText("fax");
			priv.province=pc.elementText("province");
			priv.quarter=pc.elementText("quarter");
			priv.sanitarydistrict=pc.elementText("sanitarydistrict");
			priv.sector=pc.elementText("sector");
			priv.telephone=pc.elementText("telephone");
			priv.type=pc.elementText("type");
			priv.zipcode=pc.elementText("zipcode");
			privateContacts.add(priv);
		}
    }
    
    public Vector getMissingMandatoryFieldsTranslated(String language){
    	Vector translatedFields = new Vector();
    	Vector missingFields = getMissingMandatoryFields();
    	for(int n=0;n<missingFields.size();n++){
    		translatedFields.add(ScreenHelper.getTranNoLink("web", (String)missingFields.elementAt(n),language));
    	}
    	return translatedFields;
    }
    
    public Vector getMissingMandatoryFields(){
    	Vector missingFields=new Vector();
    	String[] mandatoryFields = MedwanQuery.getInstance().getConfigString("ObligatoryFields_Admin","").split(",");
    	for(int n=0;n<mandatoryFields.length;n++){
    		if(mandatoryFields[n].equalsIgnoreCase("lastname") && ScreenHelper.checkString(lastname).length()==0){
    			missingFields.add("lastname");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("firstname") && ScreenHelper.checkString(firstname).length()==0){
    			missingFields.add("firstname");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("dateofbirth") && ScreenHelper.checkString(dateOfBirth).length()==0){
    			missingFields.add("dateofbirth");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("immatold") && ScreenHelper.checkString(getID("immatold")).length()==0){
    			missingFields.add("immatold");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("natreg") && ScreenHelper.checkString("natreg").length()==0){
    			missingFields.add("natreg");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("language") && ScreenHelper.checkString(language).length()==0){
    			missingFields.add("language");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("gender") && ScreenHelper.checkString(gender).length()==0){
    			missingFields.add("gender");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("candidate") && ScreenHelper.checkString(getID("candidate")).length()==0){
    			missingFields.add("candidate");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("engagement") && ScreenHelper.checkString(engagement).length()==0){
    			missingFields.add("engagement");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("pension") && ScreenHelper.checkString(pension).length()==0){
    			missingFields.add("pension");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("claimant") && ScreenHelper.checkString(claimant).length()==0){
    			missingFields.add("claimant");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("claimantexpiration") && ScreenHelper.checkString(claimantExpiration).length()==0){
    			missingFields.add("claimantexpiration");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("nativecountry") && ScreenHelper.checkString(nativeCountry).length()==0){
    			missingFields.add("nativecountry");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("nativetown") && ScreenHelper.checkString(nativeTown).length()==0){
    			missingFields.add("nativetown");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment") && ScreenHelper.checkString(comment).length()==0){
    			missingFields.add("comment");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment1") && ScreenHelper.checkString(comment1).length()==0){
    			missingFields.add("comment1");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment2") && ScreenHelper.checkString(comment2).length()==0){
    			missingFields.add("comment2");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment3") && ScreenHelper.checkString(comment3).length()==0){
    			missingFields.add("comment3");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment4") && ScreenHelper.checkString(comment4).length()==0){
    			missingFields.add("comment4");
    		}
    		else if(mandatoryFields[n].equalsIgnoreCase("comment5") && ScreenHelper.checkString(comment5).length()==0){
    			missingFields.add("comment5");
    		}
    	}
		//AdminPrivate
		AdminPrivateContact apc = getActivePrivate();
		if(apc!=null){
	    	mandatoryFields = MedwanQuery.getInstance().getConfigString("ObligatoryFields_AdminPrivate","").split(",");
	    	for(int n=0;n<mandatoryFields.length;n++){
	    		if(mandatoryFields[n].equalsIgnoreCase("pbegin") && ScreenHelper.checkString(apc.begin).length()==0){
	    			missingFields.add("begin");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("paddress") && ScreenHelper.checkString(apc.address).length()==0){
	    			missingFields.add("address");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pzipcode") && ScreenHelper.checkString(apc.zipcode).length()==0){
	    			missingFields.add("zipcode");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pcity") && ScreenHelper.checkString(apc.city).length()==0){
	    			missingFields.add("city");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pcountry") && ScreenHelper.checkString(apc.country).length()==0){
	    			missingFields.add("country");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pprovince") && ScreenHelper.checkString(apc.province).length()==0){
	    			missingFields.add("province");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pdistrict") && ScreenHelper.checkString(apc.district).length()==0){
	    			missingFields.add("district");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("psector") && ScreenHelper.checkString(apc.sector).length()==0){
	    			missingFields.add("sector");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pemail") && ScreenHelper.checkString(apc.email).length()==0){
	    			missingFields.add("email");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("ptelephone") && ScreenHelper.checkString(apc.telephone).length()==0){
	    			missingFields.add("telephone");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pfax") && ScreenHelper.checkString(apc.fax).length()==0){
	    			missingFields.add("fax");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pmobile") && ScreenHelper.checkString(apc.mobile).length()==0){
	    			missingFields.add("mobile");
	    		}
	    		else if(mandatoryFields[n].equalsIgnoreCase("pcomment") && ScreenHelper.checkString(apc.comment).length()==0){
	    			missingFields.add("comment");
	    		}
	    	}
		}
    	return missingFields;
    }

    //--- GET ADMIN PERSON ------------------------------------------------------------------------
    public static AdminPerson getAdminPerson (Connection connection, String sPersonID){
    	AdminPerson adminPerson = new AdminPerson();
        adminPerson.initialize(connection,sPersonID);
        return adminPerson;
    }

    //--- GET ADMIN PERSON ------------------------------------------------------------------------
    public static AdminPerson getAdminHistoryPerson (Connection connection, String sPersonID, java.util.Date updatetime){
        AdminPerson adminPerson = new AdminPerson();
        adminPerson.initializeHistory(connection,sPersonID,updatetime);
        return adminPerson;
    }

    //--- GET ADMIN PERSON ------------------------------------------------------------------------
    public static AdminPerson getAdminHistoryPerson (String sPersonID, java.util.Date updatetime){
        AdminPerson adminPerson = new AdminPerson();
        try{
	        Connection conn = MedwanQuery.getInstance().getAdminConnection();
	        adminPerson.initializeHistory(conn,sPersonID,updatetime);
	        conn.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
        return adminPerson;
    }

    //--- GET ADMIN PERSON ------------------------------------------------------------------------
    public static AdminPerson getAdminPerson(String sPersonID){
    	AdminPerson adminPerson=null;
    	
    	try {
	        Connection conn = MedwanQuery.getInstance().getAdminConnection();
	        adminPerson= AdminPerson.getAdminPerson(conn,sPersonID);
			conn.close();
		} 
    	catch (SQLException e) {
			e.printStackTrace();
		}
    	
        return adminPerson;
    }
    
    public static AdminPerson get(String sPersonID) {
    	return getAdminPerson(sPersonID);
    }
    
    //--- GET FULL NAME ---------------------------------------------------------------------------
    public String getFullName(){
    	return lastname.toUpperCase()+", "+firstname;
    }
    
    //--- GET UID ---------------------------------------------------------------------------------
    public String getUid(){
    	return personid;
    }
    
    //--- IS EMPLOYEE -----------------------------------------------------------------------------
    public boolean isEmployee(){
        boolean isEmployee = false;  
        
        /*
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        Connection conn = MedwanQuery.getInstance().getAdminConnection();
        
        try{
            // compose query
            String sSql = "SELECT DISTINCT(a.personId) FROM admin a, adminextends e"+
            		      " WHERE a.personId = e.personId"+
            	          "  AND (e.labelid = 'category' OR e.labelid = 'statut')"+
            		      "  AND "+MedwanQuery.getInstance().getConfigString("lengthFunction","len")+"(e.extendvalue) > 0"+
            	          "  AND a.personid = ?";
            ps = conn.prepareStatement(sSql);
            ps.setInt(1,Integer.parseInt(this.personid));
            rs = ps.executeQuery();
            isEmployee = rs.next();  
        }
        catch(Exception e){
            if(Debug.enabled) e.printStackTrace();
            Debug.printProjectErr(e,Thread.currentThread().getStackTrace());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
                Debug.printProjectErr(se,Thread.currentThread().getStackTrace());
            }
        }
        */

        String sLabelID, sExtendValue;
        Enumeration eExtends = this.adminextends.keys();
        while(eExtends.hasMoreElements()){
            sLabelID = (String)eExtends.nextElement();
            
            if(sLabelID.equalsIgnoreCase("category") || sLabelID.equalsIgnoreCase("statut")){
                sExtendValue = (String)this.adminextends.get(sLabelID);
                if(sExtendValue.length() > 0){
                	isEmployee = true;
                	break;
                }
            }
        }
        
        return isEmployee;
    }
    
    //--- HAS PENDING EXPORT REQUEST --------------------------------------------------------------
    public boolean hasPendingExportRequest(){
		boolean hasRequest=false;
    	try {
	        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        PreparedStatement ps = conn.prepareStatement("select * from OC_EXPORTREQUESTS where OC_EXPORTREQUEST_TYPE='patient' and OC_EXPORTREQUEST_ID=? and (OC_EXPORTREQUEST_PROCESSED is null or OC_EXPORTREQUEST_PROCESSED<2)");
	        ps.setString(1, personid);
	        ResultSet rs = ps.executeQuery();
	        hasRequest=rs.next();
	        rs.close();
	        ps.close();
			conn.close();
		}
    	catch (SQLException e) {
			e.printStackTrace();
		}
    	
    	return hasRequest;
    }
    
    public static Vector<AdminPerson> getAdminPersonsByExtendValue(String sLabelId, String sValue) {
    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
    	PreparedStatement ps = null;
    	ResultSet rs = null;
    	Vector<AdminPerson> persons = new Vector<AdminPerson>();
    	if(sLabelId.length()>0 && sValue.length()>0) {
	    	try {
	    		ps = conn.prepareStatement("select distinct e.personid from adminextends e,admin a where a.personid=e.personid and labelid=? and extendvalue=?");
	    		ps.setString(1, sLabelId);
	    		ps.setString(2, sValue);
	    		rs=ps.executeQuery();
	    		while(rs.next()) {
	    			persons.add(AdminPerson.get(rs.getString("personid")));
	    		}
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    	}
	    	finally {
	    		try {
	    			if(rs!=null) rs.close();
	    			if(ps!=null) ps.close();
	    			conn.close();
	    		}
	    		catch(Exception e) {
	    			e.printStackTrace();
	    		}
	    	}
    	}
    	return persons;
    }
    
	public static Vector<AdminPerson> getAdminPersonsByTelephone(String sPhone) {
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		Vector<AdminPerson> persons = new Vector<AdminPerson>();
		if(sPhone.length()>0) {
	    	try {
	    		ps = conn.prepareStatement("select distinct e.personid from adminprivate e,admin a where a.personid=e.personid and (replace(telephone,' ','') like ? OR replace(mobile,' ','') like ?)");
	    		ps.setString(1, "%"+sPhone.replaceAll(" ", "")+"%");
	    		ps.setString(2, "%"+sPhone.replaceAll(" ", "")+"%");
	    		rs=ps.executeQuery();
	    		while(rs.next()) {
	    			persons.add(AdminPerson.get(rs.getString("personid")));
	    		}
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    	}
	    	finally {
	    		try {
	    			if(rs!=null) rs.close();
	    			if(ps!=null) ps.close();
	    			conn.close();
	    		}
	    		catch(Exception e) {
	    			e.printStackTrace();
	    		}
	    	}
		}
		return persons;
	}
	
	public static Vector<AdminPerson> getAdminPersonsByEmail(String sEmail) {
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		Vector<AdminPerson> persons = new Vector<AdminPerson>();
		if(sEmail.length()>0) {
	    	try {
	    		ps = conn.prepareStatement("select distinct e.personid from adminprivate e,admin a where a.personid=e.personid and email=?");
	    		ps.setString(1, sEmail);
	    		rs=ps.executeQuery();
	    		while(rs.next()) {
	    			persons.add(AdminPerson.get(rs.getString("personid")));
	    		}
	    	}
	    	catch(Exception e) {
	    		e.printStackTrace();
	    	}
	    	finally {
	    		try {
	    			if(rs!=null) rs.close();
	    			if(ps!=null) ps.close();
	    			conn.close();
	    		}
	    		catch(Exception e) {
	    			e.printStackTrace();
	    		}
	    	}
		}
		return persons;
	}
	
    public String getLastSentExportRequest(){
		String lastDate="";
    	try {
	        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        PreparedStatement ps = conn.prepareStatement("select max(OC_EXPORTREQUEST_UPDATETIME) as lastdate from OC_EXPORTREQUESTS where OC_EXPORTREQUEST_TYPE='patient' and OC_EXPORTREQUEST_ID=? and OC_EXPORTREQUEST_PROCESSED=2");
	        ps.setString(1, personid);
	        ResultSet rs = ps.executeQuery();
	        if(rs.next()){
	        	java.sql.Timestamp ld = rs.getTimestamp("lastdate");
	        	if(ld!=null){
	        		lastDate=ScreenHelper.fullDateFormatSS.format(ld);
	        	}
	        }
	        rs.close();
	        ps.close();
			conn.close();
		}
    	catch (SQLException e) {
			e.printStackTrace();
		}
    	
    	return lastDate;
    }
    
    public void setExportRequest(boolean bSet){
    	try {
	        Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        PreparedStatement ps = conn.prepareStatement("DELETE from OC_EXPORTREQUESTS where OC_EXPORTREQUEST_TYPE='patient' and (OC_EXPORTREQUEST_PROCESSED is null or OC_EXPORTREQUEST_PROCESSED<2) and OC_EXPORTREQUEST_ID=?");
	        ps.setString(1, personid);
	        ps.execute();
	        ps.close();
	        if(bSet){
		        ps = conn.prepareStatement("INSERT INTO OC_EXPORTREQUESTS(OC_EXPORTREQUEST_TYPE,OC_EXPORTREQUEST_ID,OC_EXPORTREQUEST_PROCESSED,OC_EXPORTREQUEST_UPDATETIME) values('patient',?,0,?)");
		        ps.setString(1, personid);
				ps.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
		        ps.execute();
		        ps.close();
	        }
			conn.close();
		} 
    	catch (SQLException e) {
			e.printStackTrace();
		}
    }
    
    public boolean isNotEmpty() {
    	return ScreenHelper.checkString(this.personid).length()>0 && (ScreenHelper.checkString(this.lastname).trim().length()>0 || ScreenHelper.checkString(this.firstname).trim().length()>0);
    }
    
    //--- INITIALIZE ------------------------------------------------------------------------------
    public boolean initialize(String sPersonID){
    	boolean bReturn=false;
    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
    	bReturn = initialize(conn,sPersonID);
    	ScreenHelper.closeQuietly(conn, null, null);
    	return bReturn;
    }
    
    public boolean initialize (Connection connection, String sPersonID) {
        boolean bReturn = false;
        if ((sPersonID!=null)&&(sPersonID.trim().length()>0)) {
            String sSelect = "";
            try {
                PreparedStatement ps;
                String sID;
                this.personid = sPersonID;

                sSelect = " SELECT * FROM AdminView WHERE personid = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sPersonID));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    // IDs
                    sID = ScreenHelper.checkString(rs.getString("natreg"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("NatReg",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("immatold"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("ImmatOld",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("immatnew"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("ImmatNew",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("archiveFileCode"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("archiveFileCode",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("candidate"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("Candidate",sID));
                    }

                    // simple attributes
                    lastname = ScreenHelper.checkString(rs.getString("lastname"));
                    firstname = ScreenHelper.checkString(rs.getString("firstname"));
                    gender = ScreenHelper.checkString(rs.getString("gender"));
                    dateOfBirth = ScreenHelper.getSQLDate(rs.getDate("dateofbirth"));
                    comment = ScreenHelper.checkString(rs.getString("comment"));
                    sourceid = ScreenHelper.checkString(rs.getString("sourceid"));
                    language = ScreenHelper.checkString(rs.getString("language"));

                    // correct language // todo : may be removed when in production
                    if(language.equalsIgnoreCase("N")) language = "nl";
                    else if(language.equalsIgnoreCase("F")) language = "fr";

                    pension = ScreenHelper.getSQLDate(rs.getDate("pension"));
                    statute = ScreenHelper.checkString(rs.getString("statute"));
                    engagement = ScreenHelper.getSQLDate(rs.getDate("engagement"));
                    claimant = ScreenHelper.checkString(rs.getString("claimant"));
                    claimantExpiration =ScreenHelper.getSQLDate(rs.getDate("claimant_expiration"));
                    nativeCountry =ScreenHelper.checkString(rs.getString("native_country"));
                    nativeTown = ScreenHelper.checkString(rs.getString("native_town"));
                    personType = ScreenHelper.checkString(rs.getString("person_type"));
                    motiveEndOfService =ScreenHelper.checkString(rs.getString("motive_end_of_service"));
                    situationEndOfService =ScreenHelper.checkString(rs.getString("situation_end_of_service"));
                    startdateInactivity =ScreenHelper.getSQLDate(rs.getDate("startdate_inactivity"));
                    enddateInactivity =ScreenHelper.getSQLDate(rs.getDate("enddate_inactivity"));
                    codeInactivity =ScreenHelper.checkString(rs.getString("code_inactivity"));
                    updateStatus = ScreenHelper.checkString(rs.getString("update_status"));
                    updateuserid = ScreenHelper.checkString(rs.getString("updateuserid"));
                    comment1 = ScreenHelper.checkString(rs.getString("comment1"));
                    comment2 = ScreenHelper.checkString(rs.getString("comment2"));
                    comment3 = ScreenHelper.checkString(rs.getString("comment3"));
                    comment4 = ScreenHelper.checkString(rs.getString("comment4"));
                    comment5 = ScreenHelper.checkString(rs.getString("comment5"));
                    middlename = ScreenHelper.checkString(rs.getString("middlename"));
                    begin =ScreenHelper.getSQLDate(rs.getDate("begindate"));
                    end =ScreenHelper.getSQLDate(rs.getDate("enddate"));

            //private
                    AdminPrivateContact apc;
                    sSelect = "SELECT privateid FROM PrivateView WHERE personid = ? ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        apc = new AdminPrivateContact();
                        apc.privateid = ScreenHelper.checkString(rs.getString("privateid"));
                        apc.initialize(connection);
                        privateContacts.add(apc);
                    }

            //socsec
                    sSelect = "SELECT socsecid FROM AdminSocSec WHERE personid = ? ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        socsec.socsecid = ScreenHelper.checkString(rs.getString("socsecid"));
                        socsec.initialize(connection);
                    }

            //family relation
                    AdminFamilyRelation afr;
                    sSelect = "SELECT relationid FROM AdminFamilyRelation"+
                              " WHERE (sourceid = ? OR destinationid = ?)";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setInt(2,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while(rs.next()){
                        afr = new AdminFamilyRelation();
                        afr.relationId = ScreenHelper.checkString(rs.getString("relationid"));
                        afr.initialize(connection);
                        familyRelations.add(afr);
                    }

             //extends
                    String sLabelID, sExtendValue;
                    sSelect = " SELECT labelid, extendvalue FROM AdminExtends WHERE personid = ? AND extendtype = 'A' ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        sLabelID = ScreenHelper.checkString(rs.getString("labelid"));
                        sExtendValue = ScreenHelper.checkString(rs.getString("extendvalue"));
                        adminextends.put(sLabelID.toLowerCase(),sExtendValue);
                    }
                    bReturn = true;
                }
                if(rs!=null) rs.close();
                if (ps!=null)ps.close();
                
                if(Picture.exists(Integer.parseInt(personid))) {
                	picture=new Picture(Integer.parseInt(personid)).getPicture();
                }
            }
            catch(SQLException e) {
                e.printStackTrace();
                Debug.println("AdminPerson initialize error: "+e.getMessage()+" "+sSelect);
            }
        }
        return bReturn;
    }

    //--- INITIALIZE ------------------------------------------------------------------------------
    public boolean initializeHistory (Connection connection, String sPersonID, java.util.Date updatetime) {
        boolean bReturn = false;
        if ((sPersonID!=null)&&(sPersonID.trim().length()>0)) {
            String sSelect = "";
            try {
                PreparedStatement ps;
                String sID;
                this.personid = sPersonID;

                sSelect = " SELECT * FROM AdminHistory WHERE personid = ? and updatetime=?";
                ps = connection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sPersonID));
                ps.setTimestamp(2, new java.sql.Timestamp(updatetime.getTime()));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    // IDs
                    sID = ScreenHelper.checkString(rs.getString("natreg"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("NatReg",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("immatold"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("ImmatOld",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("immatnew"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("ImmatNew",sID));
                    }

                    sID = ScreenHelper.checkString(rs.getString("candidate"));
                    if((sID!=null)&&(sID.trim().length()>0)&&(!sID.trim().toLowerCase().equals("null"))) {
                        ids.add(new AdminID("Candidate",sID));
                    }

                    // simple attributes
                    lastname = ScreenHelper.checkString(rs.getString("lastname"));
                    firstname = ScreenHelper.checkString(rs.getString("firstname"));
                    gender = ScreenHelper.checkString(rs.getString("gender"));
                    dateOfBirth = ScreenHelper.getSQLDate(rs.getDate("dateofbirth"));
                    comment = ScreenHelper.checkString(rs.getString("comment"));
                    sourceid = ScreenHelper.checkString(rs.getString("sourceid"));
                    language = ScreenHelper.checkString(rs.getString("language"));

                    // correct language // todo : may be removed when in production
                    if(language.equalsIgnoreCase("N")) language = "nl";
                    else if(language.equalsIgnoreCase("F")) language = "fr";

                    pension = ScreenHelper.getSQLDate(rs.getDate("pension"));
                    statute = ScreenHelper.checkString(rs.getString("statute"));
                    engagement = ScreenHelper.getSQLDate(rs.getDate("engagement"));
                    claimant = ScreenHelper.checkString(rs.getString("claimant"));
                    claimantExpiration =ScreenHelper.getSQLDate(rs.getDate("claimant_expiration"));
                    nativeCountry =ScreenHelper.checkString(rs.getString("native_country"));
                    nativeTown = ScreenHelper.checkString(rs.getString("native_town"));
                    personType = ScreenHelper.checkString(rs.getString("person_type"));
                    motiveEndOfService =ScreenHelper.checkString(rs.getString("motive_end_of_service"));
                    situationEndOfService =ScreenHelper.checkString(rs.getString("situation_end_of_service"));
                    startdateInactivity =ScreenHelper.getSQLDate(rs.getDate("startdate_inactivity"));
                    enddateInactivity =ScreenHelper.getSQLDate(rs.getDate("enddate_inactivity"));
                    codeInactivity =ScreenHelper.checkString(rs.getString("code_inactivity"));
                    updateStatus = ScreenHelper.checkString(rs.getString("update_status"));
                    updateuserid = ScreenHelper.checkString(rs.getString("updateuserid"));
                    comment1 = ScreenHelper.checkString(rs.getString("comment1"));
                    comment2 = ScreenHelper.checkString(rs.getString("comment2"));
                    comment3 = ScreenHelper.checkString(rs.getString("comment3"));
                    comment4 = ScreenHelper.checkString(rs.getString("comment4"));
                    comment5 = ScreenHelper.checkString(rs.getString("comment5"));
                    middlename = ScreenHelper.checkString(rs.getString("middlename"));
                    begin =ScreenHelper.getSQLDate(rs.getDate("begindate"));
                    end =ScreenHelper.getSQLDate(rs.getDate("enddate"));

            //private
                    AdminPrivateContact apc;
                    sSelect = "SELECT privateid FROM PrivateView WHERE personid = ? ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        apc = new AdminPrivateContact();
                        apc.privateid = ScreenHelper.checkString(rs.getString("privateid"));
                        apc.initialize(connection);
                        privateContacts.add(apc);
                    }

            //socsec
                    sSelect = "SELECT socsecid FROM AdminSocSec WHERE personid = ? ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        socsec.socsecid = ScreenHelper.checkString(rs.getString("socsecid"));
                        socsec.initialize(connection);
                    }

            //family relation
                    AdminFamilyRelation afr;
                    sSelect = "SELECT relationid FROM AdminFamilyRelation"+
                              " WHERE (sourceid = ? OR destinationid = ?)";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setInt(2,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while(rs.next()){
                        afr = new AdminFamilyRelation();
                        afr.relationId = ScreenHelper.checkString(rs.getString("relationid"));
                        afr.initialize(connection);
                        familyRelations.add(afr);
                    }

             //extends
                    String sLabelID, sExtendValue;
                    sSelect = " SELECT labelid, extendvalue FROM AdminExtends WHERE personid = ? AND extendtype = 'A' ";
                    rs.close();
                    ps.close();
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    rs = ps.executeQuery();
                    while (rs.next()) {
                        sLabelID = ScreenHelper.checkString(rs.getString("labelid"));
                        sExtendValue = ScreenHelper.checkString(rs.getString("extendvalue"));
                        adminextends.put(sLabelID.toLowerCase(),sExtendValue);
                    }
                    bReturn = true;
                }
                if(rs!=null) rs.close();
                if (ps!=null)ps.close();
            }
            catch(SQLException e) {
                e.printStackTrace();
                Debug.println("AdminPerson initialize error: "+e.getMessage()+" "+sSelect);
            }
        }
        return bReturn;
    }

    //--- SAVE TO DB ------------------------------------------------------------------------------
    public boolean saveToDB(String activeMedicalCenter,String activeMD,String activePara){
        boolean bReturn=false;
    	this.activeMedicalCenter=activeMedicalCenter;
        this.activeMD=activeMD;
        this.activePara=activePara;
        Connection conn = MedwanQuery.getInstance().getAdminConnection();
        bReturn= saveToDB(conn);
        ScreenHelper.closeQuietly(conn, null, null);
        return bReturn;
    }

    //--- SAVE TO DB ------------------------------------------------------------------------------
    public boolean saveToDB(Connection connection,String activeMedicalCenter,String activeMD,String activePara){
        this.activeMedicalCenter=activeMedicalCenter;
        this.activeMD=activeMD;
        this.activePara=activePara;
        return saveToDB(connection);
    }

    public boolean hasLabRequests(){
        boolean ok=false;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sQuery="select * from RequestedLabAnalyses where patientid=?";
            PreparedStatement ps = oc_conn.prepareStatement(sQuery);
            ps.setInt(1,Integer.parseInt(personid));
            ResultSet rs = ps.executeQuery();
            if (rs.next()){
                ok=true;
            }
            rs.close();
            ps.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
        try {
			oc_conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
        return ok;
    }
    
    public boolean addReceiverPersonId(String sPersonId){
    	if(comment4==null){
    		comment4="";
    	}
    	String[] receiverpersonids = comment4.split(";");
    	boolean bFound=false;
    	for(int n=0;n<receiverpersonids.length;n++){
    		if(receiverpersonids[n].equalsIgnoreCase(sPersonId)){
    			bFound=true;
    			break;
    		}
    	}
    	if(!bFound){
    		if(comment4.length()>0){
    			comment4+=";";
    		}
    		comment4+=sPersonId;
    	}
    	return !bFound;
    }
    
    public boolean hasReceiverPersonId(String receiverid){
    	if(comment4==null){
    		comment4="";
    	}
    	String[] receiverpersonids = comment4.split(";");
    	boolean bFound=false;
    	for(int n=0;n<receiverpersonids.length;n++){
    		String receiverpersonid = receiverpersonids[n];
    		if(receiverpersonid.split(":").length==2 && receiverpersonid.split(":")[0].equalsIgnoreCase(receiverid)){
    			return true;
    		}
    	}
    	return false;
    }
    
    public String getReceiverPersonId(String receiverid){
    	if(comment4==null){
    		comment4="";
    	}
    	String[] receiverpersonids = comment4.split(";");
    	boolean bFound=false;
    	for(int n=0;n<receiverpersonids.length;n++){
    		String receiverpersonid = receiverpersonids[n];
    		if(receiverpersonid.split(":").length==2 && receiverpersonid.split(":")[0].equalsIgnoreCase(receiverid)){
    			return receiverpersonid.split(":")[1];
    		}
    	}
    	return "";
    }
    
    public String getReceiverPersonIdsToHtmlTable(String language){
    	if(comment4==null){
    		comment4="";
    	}
    	String ids="<table>";
    	String[] receiverpersonids = comment4.split(";");
    	boolean bFound=false;
    	for(int n=0;n<receiverpersonids.length;n++){
    		String receiverpersonid = receiverpersonids[n];
    		if(receiverpersonid.split(":").length==2){
    			ids+="<tr><td>"+ScreenHelper.getTran("sendRecordDestinations", receiverpersonid.split(":")[0], language)+"</td><td><b>"+receiverpersonid.split(":")[1]+"</b></td></tr>";
    		}
    	}
    	ids+="</table>";
    	return ids;
    }

    public String getReferenceInsuranceNumber(){
    	Vector insurances = Insurance.getCurrentInsurances(personid);
    	for(int n=0;n<insurances.size();n++){
    		Insurance insurance = (Insurance)insurances.elementAt(n);
    		if(insurance.getInsurar().getUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("referenceInsurarUid",""))){
    			return ScreenHelper.checkString(insurance.getInsuranceNr());
    		}
    	}
    	return "";
    }

    public boolean saveToDB(Connection connection) {
        boolean bReturn = true;
        boolean bNew=false;
        String sSelect = "";
        try {
            PreparedStatement ps;
            ResultSet rs;
            String sPersonID = "", sSourceID, sSearchname, sLastname, sFirstname, sMiddlename;

            sSourceID = this.sourceid;
            if ((this.personid!=null)&&(this.personid.trim().length()>0)) {
                sPersonID = this.personid;
            }

            // NATREG
            if(checkNatreg && (sPersonID.trim().length()==0)&&(getID("natreg").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE natreg = ? ";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("natreg"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // IMMATNEW
            if(checkImmatnew && (sPersonID.trim().length()==0)&&(getID("immatnew").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE immatnew = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("immatnew"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // IMMATOLD
            if(checkImmatold && (sPersonID.trim().length()==0)&&(getID("immatold").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE immatold = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("immatold"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // archiveFileCode
            if(checkArchiveFileCode && (sPersonID.trim().length()==0)&&(getID("archiveFileCode").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE archiveFileCode = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("archiveFileCode"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            sLastname = ScreenHelper.checkSpecialCharacters(lastname);
            sFirstname = ScreenHelper.checkSpecialCharacters(firstname);
            sMiddlename = ScreenHelper.checkSpecialCharacters(middlename);
            sSearchname = sLastname.toUpperCase().trim()+","+sFirstname.toUpperCase().trim();
            sSearchname = ScreenHelper.normalizeSpecialCharacters(sSearchname);
            
            firstname = firstname.replaceAll("'","´");
            lastname = lastname.replaceAll("'","´");
            
            
            //*** INSERT ***
            if ((bReturn)&&(sPersonID.trim().length()==0)) {
            	bNew=true;
                sPersonID = MedwanQuery.getInstance().getOpenclinicCounter("PersonID")+"";
                if ((sPersonID.trim().length()>0)&&(this.sourceid.trim().length()>0)) {
                    this.personid = sPersonID;
                    sSelect = " INSERT INTO Admin (personid, natreg, lastname, sourceid) VALUES (?,?,?,?) ";
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setString(2,ScreenHelper.checkString(getID("natreg")));
                    ps.setString(3,this.lastname);
                    ps.setString(4,sSourceID);
                    if(!ScreenHelper.executeQuery(ps)) {
                        sPersonID = MedwanQuery.getInstance().getOpenclinicCounter("PersonID")+"";
                        ps.setInt(1,Integer.parseInt(sPersonID));
                        if(!ScreenHelper.executeQuery(ps)) {
                        	bReturn=false;
                        }
                    }
                    if (ps!=null) ps.close();
                    if(bReturn) {
	                    if(this.getID("immatnew").length()==0 && SH.ci("autoInitializeImmatnew",1)==1){
	                        this.setID("immatnew",(SH.ci("enableOfflineSync",0)==1?SH.cs("offlineLocalPrefix", "")+"M-":"")+ sPersonID);
	                    }
	
	                    if ((this.updateuserid==null)||(this.updateuserid.trim().length()==0)) {
	                        this.updateuserid = "0";
	                    }
	
	                    // Er werd een nieuw dossier aangemaakt, genereer eventueel de bijgaande prestatiecode
	                    if (export && MedwanQuery.getInstance().getConfigInt("exportEnabled")==1){
	                        ExportActivityVO exportActivityVO=new ExportActivityVO(Integer.parseInt(personid),Integer.parseInt(this.updateuserid),ScreenHelper.stdDateFormat.format(new java.util.Date()),null,"RECORD-CREATION."+personid+"."+MedwanQuery.getInstance().getConfigString("serverId"));
	                        exportActivityVO.setMedicalCenter(activeMedicalCenter);
	                        exportActivityVO.setMD(activeMD);
	                        exportActivityVO.setPara(activePara);
	                        if (exportActivityVO.setCodeWhereExists("RECORD-CREATION") && !this.updateuserid.equals("0")){
	                            exportActivityVO.store(true,this.updateuserid);
	                        }
	                    }
                    }
                }
                else {
                    Debug.println(" SourceID error with "+getID("natreg")+""+getID("immatold")+" "+getID("immatnew")+" "+sSelect);
                    bReturn = false;
                }
            }

            if (bReturn) {
                //*** UPDATE ***
                if (sSourceID.toLowerCase().equals(this.sourceid.toLowerCase())) {
                    Hashtable hSelect = new Hashtable();
                    hSelect.put(" natreg = ? ",getID("natreg"));
                    hSelect.put(" immatold = ? ",getID("immatold"));
                    hSelect.put(" immatnew = ? ",getID("immatnew"));
                    hSelect.put(" archiveFileCode = ? ",getID("archiveFileCode"));
                    hSelect.put(" candidate = ? ",getID("candidate"));

                    hSelect.put(" gender = ? ",this.gender);
                    hSelect.put(" language = ? ",this.language);
                    hSelect.put(" dateofbirth = ? ",this.dateOfBirth);
                    hSelect.put(" sourceid = ? ",this.sourceid);
                    hSelect.put(" comment = ? ",this.comment);
                    hSelect.put(" pension = ? ",this.pension);
                    hSelect.put(" engagement = ? ",this.engagement);
                    hSelect.put(" statute = ? ",this.statute);
                    hSelect.put(" claimant = ? ",this.claimant);
                    hSelect.put(" claimant_expiration = ? ",this.claimantExpiration);
                    hSelect.put(" native_country = ? ",this.nativeCountry);
                    hSelect.put(" native_town = ? ",this.nativeTown);
                    hSelect.put(" person_type = ? ",this.personType);
                    hSelect.put(" situation_end_of_service = ? ",this.situationEndOfService);
                    hSelect.put(" motive_end_of_service = ? ",this.motiveEndOfService);
                    hSelect.put(" startdate_inactivity = ? ",this.startdateInactivity);
                    hSelect.put(" enddate_inactivity = ? ",this.enddateInactivity);
                    hSelect.put(" code_inactivity = ? ",this.codeInactivity);
                    hSelect.put(" update_status = ?",this.updateStatus);
                    hSelect.put(" comment1 = ? ",ScreenHelper.checkString(this.comment1));
                    hSelect.put(" comment2 = ? ",ScreenHelper.checkString(this.comment2));
                    hSelect.put(" comment3 = ? ",ScreenHelper.checkString(this.comment3));
                    hSelect.put(" comment4 = ? ",ScreenHelper.checkString(this.comment4));
                    hSelect.put(" comment5 = ? ",ScreenHelper.checkString(this.comment5));
                    hSelect.put(" middlename = ? ",ScreenHelper.checkString(this.middlename));
                    hSelect.put(" enddate = ? ",this.end);
                    hSelect.put(" begindate = ? ",this.begin);

                    if (hSelect.size()>0) {
                        if ((this.updateuserid==null)||(this.updateuserid.trim().length()==0)) {
                            this.updateuserid = "0";
                        }
                        sSelect = "UPDATE Admin SET searchname = ?, lastname = ?, firstname = ?, updatetime = ? , updateuserid = ? "+", updateserverid="+MedwanQuery.getInstance().getConfigInt("serverId")+" ";

                        Enumeration e = hSelect.keys();
                        String sKey;
                        while (e.hasMoreElements()){
                            sKey = (String) e.nextElement();
                            sSelect += ","+sKey;
                        }
                        sSelect += " WHERE personid = "+sPersonID;


                        ps = connection.prepareStatement(sSelect);
                        ps.setString(1,sSearchname);
                        ps.setString(2,this.lastname);
                        ps.setString(3,this.firstname);
                        ps.setTimestamp(4,new java.sql.Timestamp(new java.util.Date().getTime()));
                        ps.setInt(5,Integer.parseInt(this.updateuserid));

                        int iIndex = 6;
                        e = hSelect.keys();
                        String sValue;
                        while (e.hasMoreElements()){
                            sKey = (String) e.nextElement();
                            sValue = (String)hSelect.get(sKey);
                            if ( (sKey.equalsIgnoreCase(" dateofbirth = ? "))
                                ||(sKey.equalsIgnoreCase(" engagement = ? "))
                                ||(sKey.equalsIgnoreCase(" pension = ? "))
                                ||(sKey.equalsIgnoreCase(" claimant_expiration = ? "))
                                ||(sKey.equalsIgnoreCase(" startdate_inactivity = ? "))
                                ||(sKey.equalsIgnoreCase(" enddate_inactivity = ? "))
                                ||(sKey.equalsIgnoreCase(" begindate = ? "))
                                ||(sKey.equalsIgnoreCase(" enddate = ? ")) ){
                                ScreenHelper.setSQLDate(ps,iIndex,sValue);
                            }
                            else {
                                ps.setString(iIndex,sValue);
                            }
                            iIndex++;
                        }
                    	copyActiveToHistoryNoDelete(sPersonID);

                        ps.executeUpdate();
                        if (ps!=null)ps.close();
                        this.personid = sPersonID;
                    }
                }
                else {
                    // WRONG OWNER
                	Debug.println(" Wrong owner of "+getID("natreg")+" "+getID("immatold")+" "+getID("immatnew"));
                    bReturn = false;
                }
            }
            else {
            	Debug.println(" Error with "+getID("natreg")+" "+getID("immatold")+" "+getID("immatnew")+" "+sSelect);
            }
            
            // adminprivate
            if (bReturn) {
                for (int i=0;(i<this.privateContacts.size())&&(bReturn);i++) {
                	AdminPrivateContact apc = ((AdminPrivateContact)this.privateContacts.elementAt(i));
                    boolean bSendEmail =false;
                    if(SH.ci("isMPIServer",0)==1 && SH.ci("mpiServerSendWelcomeMessageToNewPatients", 1)==1) {
	                    if(bNew && SH.parseDate(apc.end)==null && SH.c(apc.email).length()>0 && SH.isValidEmailAddress(apc.email)) {
	                    	bSendEmail=true;
	                    }
	                    else if(!bNew) {
	                    	//Check if we are moving from a without-email to with-email situation
	                    	//First Load existing person record
	                    	AdminPerson oldperson = AdminPerson.get(personid);
	                    	if(SH.c(oldperson.getActivePrivate().email).length()==0 && SH.parseDate(apc.end)==null && SH.c(apc.email).length()>0 && SH.isValidEmailAddress(apc.email)){
	                    		bSendEmail=true;
	                    	}
	                    	
	                    }
                    }
                    bReturn = apc.saveToDB(sPersonID, connection);
                    if(bSendEmail) {
                    	try {
	                    	//This is a patient record that was newly created on the MPI server
	                    	//Create a patient password and send it to the email address registered in the patient record
                    		setID("candidate", SH.getRandomPassword());
                    		Connection conn = MedwanQuery.getInstance().getAdminConnection();
                    		PreparedStatement ps2 = conn.prepareStatement("update admin set candidate=? where personid=?");
                    		ps2.setString(1, getID("candidate"));
                    		ps2.setString(2, personid);
                    		ps2.execute();
                    		ps2.close();
                    		conn.close();
                    		sendMPIRegistrationMessage();
                    	}
                    	catch(Exception e) {
                    		e.printStackTrace();
                    	}
                    }
                }
            }

            // socsec
            if (bReturn) {
                bReturn = socsec.saveToDB(sPersonID, connection);
            }

            // admin family relations
            if(bReturn){
                AdminFamilyRelation.deleteAllRelationsForPerson(this.personid);
                AdminFamilyRelation relation;
                for(int i=0; i<this.familyRelations.size(); i++){
                    relation = ((AdminFamilyRelation)this.familyRelations.elementAt(i));

                    // update sourceId to saved personid if none specified
                    if(relation.sourceId.length()==0 || Integer.parseInt(relation.sourceId) < 0){
                        relation.sourceId = this.personid;
                    }

                    // update destinationId to saved personid if none specified
                    if(relation.destinationId.length()==0 || Integer.parseInt(relation.destinationId) < 0){
                        relation.destinationId = this.personid;
                    }

                    relation.saveToDB(connection);
                }
            }

            // adminextends
            if (bReturn) {
                sSelect = "DELETE FROM AdminExtends WHERE personid = ? AND extendtype = 'A'";
                ps = connection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sPersonID));
                ps.executeUpdate();
                if (ps!=null)ps.close();

                String sLabelID, sExtendValue;
                Enumeration eExtends = this.adminextends.keys();
                while (eExtends.hasMoreElements()){
                    sLabelID = (String)eExtends.nextElement();
                    sExtendValue = (String) this.adminextends.get(sLabelID);
                    sSelect = " INSERT INTO AdminExtends (personid, extendtype, extendvalue, labelid, updatetime, updateuserid,updateserverid) "
                        +" VALUES (?,'A', ?,?,?,?,"+MedwanQuery.getInstance().getConfigInt("serverId")+")";
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setString(2,sExtendValue);
                    ps.setString(3,sLabelID);
                    ps.setDate(4,ScreenHelper.getSQLDate(ScreenHelper.getDate()));
                    ps.setInt(5,Integer.parseInt(this.updateuserid));
                    ps.executeUpdate();
                    if (ps!=null)ps.close();
                    
                    //If this is an MPI Server, then facilityid values must also be stored to pointers
                    if(MedwanQuery.getInstance().getConfigInt("isMPIServer",0)==1){
	                    if(sLabelID.startsWith("facilityid$")) {
	                    	if(Pointer.getPointer(sLabelID.replaceAll("facilityid\\$","facilityid\\$"+sPersonID+"\\$")).length()==0){
	                    		Pointer.storePointer(sLabelID.replaceAll("facilityid\\$","facilityid\\$"+sPersonID+"\\$"), sExtendValue);
	                    	}
	                    }
                    }
                }
            }
            
            if(bReturn) {
            	if(picture!=null && picture.length>0) {
        			Picture photo = new Picture();
        			photo.setPersonid(Integer.parseInt(personid));
        			photo.setPicture(picture);
        			photo.store();
            	}
            }
            
            if(export) MedwanQuery.getInstance().exportPerson(Integer.parseInt(this.personid));
        }
        catch(Exception e) {
        	Debug.printStackTrace(e);
            bReturn = false;
        }

        java.util.Date cd = getCreationDate();
        
        if(this.modifyTime!=null){
        	AccessLog.insert(this.updateuserid==null?"0":this.updateuserid,"M."+this.personid, this.modifyTime);
        	if(bNew || cd==null){
            	AccessLog.insert(this.updateuserid==null?"0":this.updateuserid,"C."+this.personid, this.modifyTime);
        	}
        	else if(cd.after(this.modifyTime)){
        		setCreationDate(this.modifyTime);
        	}
        }
        else {
        	AccessLog.insert(this.updateuserid==null?"0":this.updateuserid,"M."+this.personid);
        	if(bNew){
            	AccessLog.insert(this.updateuserid==null?"0":this.updateuserid,"C."+this.personid);
        	}
        }
        return bReturn;
    }
    
    public boolean sendMPIRegistrationMessage() {
    	String smtpServer=SH.cs("DefaultMailServerAddress", "mail.foo.org");
    	String sFrom=SH.cs("DefaultFromMailAddress", "noreply@foo.org");
    	String sTo = getActivePrivate().email;
    	String sSubject = SH.getTranNoLink("mpi","registrationsubject",SH.c(language).length()>0 && SH.cs("supportedLanguages", "en").toLowerCase().contains(language.toLowerCase())?language.toLowerCase():"en").replaceAll("\\$mpiid\\$",SH.convertToUUID(personid));
    	String sMessage = SH.getTranNoLink("mpi","registrationmessage",SH.c(language).length()>0 && SH.cs("supportedLanguages", "en").toLowerCase().contains(language.toLowerCase())?language.toLowerCase():"en").replaceAll("\\$mpiid\\$", SH.convertToUUID(personid)).replaceAll("\\$password\\$",getID("candidate")).replaceAll("\\$firstname\\$",SH.capitalizeAllWords(firstname));
    	//Todo: maybe attach a user manual to the mail
    	try {
    		return be.openclinic.system.Gmail.sendMessage("frank@ict4d.be", "Bigo4ever", sFrom, "KHIN Network", sTo, sFrom, sSubject, sMessage, SH.cs("mpiLogo","/var/tomcat/webapps/openclinic/_img/icons/khinfavicon-32x32.png"));
			//return TimeFilterReportGenerator.sendEmailWithImages(smtpServer, sFrom, sTo, sSubject, sMessage,SH.cs("mpiLogo","/var/tomcat/webapps/openclinic/_img/icons/khinfavicon-32x32.png"));
    	} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return false;
    }

    
    //--- SAVE TO DB WITH SUPPLIED ID -------------------------------------------------------------
    public boolean 	WithSuppliedID(Connection connection, String sPersonID,String activeMedicalCenter,String activeMD,String activePara) {
        this.activeMedicalCenter=activeMedicalCenter;
        this.activeMD=activeMD;
        this.activePara=activePara;
        return saveToDBWithSuppliedID(connection,sPersonID);
    }

    public java.util.Date getCreationDate(){
    	return AccessLog.getFirstAccess("C."+personid);
    }
    
    public void setCreationDate(java.util.Date d){
    	AccessLog.setFirstAccess("C."+personid,d);
    }
    
    public boolean saveToDBWithSuppliedID(Connection connection, String sPersonID) {
        boolean bReturn = true;
        PreparedStatement ps;
        ResultSet rs;
        String sSelect = "", sSourceID, sSearchname, sLastname, sFirstname, sMiddlename;

        try {
            sSourceID = this.sourceid;

            // NATREG
            if(checkNatreg && (sPersonID.trim().length()==0)&&(getID("natreg").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE natreg = ? ";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("natreg"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // IMMATNEW
            if(checkImmatnew && (sPersonID.trim().length()==0)&&(getID("immatnew").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE immatnew = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("immatnew"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // IMMATOLD
            if(checkImmatold && (sPersonID.trim().length()==0)&&(getID("immatold").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE immatold = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("immatold"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            // archiveFileCode
            if(checkArchiveFileCode && (sPersonID.trim().length()==0)&&(getID("archiveFileCode").trim().length()>0)) {
                sSelect = " SELECT personid, sourceid FROM Admin WHERE archiveFileCode = ?";
                ps = connection.prepareStatement(sSelect);
                ps.setString(1,getID("archiveFileCode"));
                rs = ps.executeQuery();
                if (rs.next()) {
                    sPersonID = rs.getString("personid");
                    sSourceID = rs.getString("sourceid");
                }
                rs.close();
                ps.close();
            }

            sLastname = ScreenHelper.checkSpecialCharacters(lastname);
            sFirstname = ScreenHelper.checkSpecialCharacters(firstname);
            sMiddlename = ScreenHelper.checkSpecialCharacters(middlename);
            sSearchname = sLastname.toUpperCase().trim()+","+sFirstname.toUpperCase().trim();

            //*** INSERT ***
            if(bReturn){
                if ((sPersonID.trim().length()>0)&&(this.sourceid.trim().length()>0)) {
                    this.personid = sPersonID;

                    sSelect = "INSERT INTO Admin (personid, natreg, lastname, sourceid) VALUES (?,?,?,?)";
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setString(2,getID("natreg"));
                    ps.setString(3,this.lastname);
                    ps.setString(4,sSourceID);
                    ps.executeUpdate();
                    if (ps!=null)ps.close();

                    if ((this.updateuserid==null)||(this.updateuserid.trim().length()==0)) {
                        this.updateuserid = "0";
                    }

                    // Er werd een nieuw dossier aangemaakt, genereer eventueel de bijgaande prestatiecode
                    if (export && MedwanQuery.getInstance().getConfigInt("exportEnabled")==1){
                        ExportActivityVO exportActivityVO=new ExportActivityVO(Integer.parseInt(personid),Integer.parseInt(this.updateuserid),ScreenHelper.stdDateFormat.format(new java.util.Date()),null,"RECORD-CREATION."+personid+"."+MedwanQuery.getInstance().getConfigString("serverId"));
                        exportActivityVO.setMedicalCenter(activeMedicalCenter);
                        exportActivityVO.setMD(activeMD);
                        exportActivityVO.setPara(activePara);
                        if (exportActivityVO.setCodeWhereExists("RECORD-CREATION") && !this.updateuserid.equals("0")){
                            exportActivityVO.store(true,this.updateuserid);
                        }
                    }
                }
                else {
                	Debug.println(" SourceID error with "+getID("natreg")+""+getID("immatold")+" "+getID("immatnew")+" "+sSelect);
                    bReturn = false;
                }
            }

            if (bReturn) {
                //*** UPDATE ***
                if (sSourceID.toLowerCase().equals(this.sourceid.toLowerCase())) {
                    Hashtable hSelect = new Hashtable();
                    hSelect.put(" natreg = ? ",getID("natreg"));
                    hSelect.put(" immatold = ? ",getID("immatold"));
                    hSelect.put(" immatnew = ? ",getID("immatnew"));
                    hSelect.put(" archiveFileCode = ? ",getID("archiveFileCode"));
                    hSelect.put(" candidate = ? ",getID("candidate"));

                    hSelect.put(" gender = ? ",this.gender);
                    hSelect.put(" language = ? ",this.language);
                    hSelect.put(" dateofbirth = ? ",this.dateOfBirth);
                    hSelect.put(" sourceid = ? ",this.sourceid);
                    hSelect.put(" comment = ? ",this.comment);
                    hSelect.put(" pension = ? ",this.pension);
                    hSelect.put(" engagement = ? ",this.engagement);
                    hSelect.put(" statute = ? ",this.statute);
                    hSelect.put(" claimant = ? ",this.claimant);
                    hSelect.put(" claimant_expiration = ? ",this.claimantExpiration);
                    hSelect.put(" native_country = ? ",this.nativeCountry);
                    hSelect.put(" native_town = ? ",this.nativeTown);
                    hSelect.put(" person_type = ? ",this.personType);
                    hSelect.put(" situation_end_of_service = ? ",this.situationEndOfService);
                    hSelect.put(" motive_end_of_service = ? ",this.motiveEndOfService);
                    hSelect.put(" startdate_inactivity = ? ",this.startdateInactivity);
                    hSelect.put(" enddate_inactivity = ? ",this.enddateInactivity);
                    hSelect.put(" code_inactivity = ? ",this.codeInactivity);
                    hSelect.put(" update_status = ?",this.updateStatus);
                    hSelect.put(" comment1 = ? ",this.comment1);
                    hSelect.put(" comment2 = ? ",this.comment2);
                    hSelect.put(" comment3 = ? ",this.comment3);
                    hSelect.put(" comment4 = ? ",this.comment4);
                    hSelect.put(" comment5 = ? ",this.comment5);
                    hSelect.put(" middlename = ? ",sMiddlename);
                    hSelect.put(" enddate = ? ",this.end);
                    hSelect.put(" begindate = ? ",this.begin);

                    if (hSelect.size()>0) {
                        if ((this.updateuserid==null)||(this.updateuserid.trim().length()==0)) {
                            this.updateuserid = "0";
                        }
                        sSelect = "UPDATE Admin SET searchname = ?, lastname = ?, firstname = ?, updatetime = ? , updateuserid = ? "+", updateserverid="+MedwanQuery.getInstance().getConfigInt("serverId")+" ";
                        Enumeration e = hSelect.keys();
                        String sKey;
                        while (e.hasMoreElements()){
                            sKey = (String) e.nextElement();
                            sSelect += ","+sKey;
                        }
                        sSelect += " WHERE personid = "+sPersonID;

                        ps = connection.prepareStatement(sSelect);
                        ps.setString(1,sSearchname);
                        ps.setString(2,this.lastname);
                        ps.setString(3,this.firstname);
                        ps.setTimestamp(4,new java.sql.Timestamp(new java.util.Date().getTime()));
                        ps.setInt(5,Integer.parseInt(this.updateuserid));

                        int iIndex = 6;
                        e = hSelect.keys();
                        String sValue;
                        while (e.hasMoreElements()){
                            sKey = (String) e.nextElement();
                            sValue = (String)hSelect.get(sKey);
                            if ( (sKey.equalsIgnoreCase(" dateofbirth = ? "))
                                ||(sKey.equalsIgnoreCase(" engagement = ? "))
                                ||(sKey.equalsIgnoreCase(" pension = ? "))
                                ||(sKey.equalsIgnoreCase(" claimant_expiration = ? "))
                                ||(sKey.equalsIgnoreCase(" startdate_inactivity = ? "))
                                ||(sKey.equalsIgnoreCase(" enddate_inactivity = ? "))
                                ||(sKey.equalsIgnoreCase(" begindate = ? "))
                                ||(sKey.equalsIgnoreCase(" enddate = ? ")) ){

                                ScreenHelper.setSQLDate(ps,iIndex,sValue);
                            }
                            else {
                                ps.setString(iIndex,sValue);
                            }
                            iIndex++;
                        }
                    	copyActiveToHistoryNoDelete(this.personid);

                        ps.executeUpdate();
                        if (ps!=null)ps.close();
                        this.personid = sPersonID;
                    }
                }
                else {
                    // WRONG OWNER
                	Debug.println(" Wrong owner of "+getID("natreg")+" "+getID("immatold")+" "+getID("immatnew"));
                    bReturn = false;
                }
            }
            else {
            	Debug.println(" Error with "+getID("natreg")+" "+getID("immatold")+" "+getID("immatnew")+" "+sSelect);
            }

            // adminprivate
            if (bReturn) {
                for (int i=0;(i<this.privateContacts.size())&&(bReturn);i++) {
                    bReturn = ((AdminPrivateContact)this.privateContacts.elementAt(i)).saveToDB(sPersonID, connection);
                }
            }

            // socsec
            if (bReturn) {
                bReturn = socsec.saveToDB(sPersonID, connection);
            }

            // adminextends
            if (bReturn) {
                sSelect = "DELETE FROM AdminExtends WHERE personid = ? AND extendtype = 'A'";
                ps = connection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sPersonID));
                ps.executeUpdate();
                if (ps!=null)ps.close();

                String sLabelID, sExtendValue;
                Enumeration eExtends = this.adminextends.keys();
                while (eExtends.hasMoreElements()){
                    sLabelID = (String)eExtends.nextElement();
                    sExtendValue = (String) this.adminextends.get(sLabelID);
                    sSelect = " INSERT INTO AdminExtends (personid, extendtype, extendvalue, labelid, updatetime, updateuserid,updateserverid) "
                        +" VALUES (?,'A', ?,?,?,?,"+MedwanQuery.getInstance().getConfigInt("serverId")+")";
                    ps = connection.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(sPersonID));
                    ps.setString(2,sExtendValue);
                    ps.setString(3,sLabelID);
                    ps.setDate(4,ScreenHelper.getSQLDate(ScreenHelper.getDate()));
                    ps.setInt(5,Integer.parseInt(this.updateuserid));
                    ps.executeUpdate();
                    if (ps!=null)ps.close();
                }
            }

            if(export) MedwanQuery.getInstance().exportPerson(Integer.parseInt(this.personid));
        }
        catch(SQLException e) {
        	Debug.printStackTrace(e);
            bReturn = false;
        }
        AccessLog.insert(this.updateuserid==null?"0":this.updateuserid,"M."+this.personid);

        return bReturn;
    }

    //--- SET ID 1 --------------------------------------------------------------------------------
    public String getID(String sType) {
        AdminID id;
        for (int i=0;i<this.ids.size();i++) {
            id = (AdminID) this.ids.elementAt(i);
            if (id.type.toLowerCase().equals(sType.toLowerCase())) {
                return id.value;
            }
        }
        return "";
    }

    //--- SET ID 1 --------------------------------------------------------------------------------
    public AdminID getAdminID(String sType) {
        AdminID id;
        for (int i=0;i<this.ids.size();i++) {
            id = (AdminID) this.ids.elementAt(i);
            if (id.type.toLowerCase().equals(sType.toLowerCase())) {
                return id;
            }
        }
        return null;
    }

    //--- SET ID 2 --------------------------------------------------------------------------------
    public void setID(String sType,String sValue) {
        AdminID id;
        for (int i=0;i<this.ids.size();i++) {
            id = (AdminID) this.ids.elementAt(i);
            if (id.type.toLowerCase().equals(sType.toLowerCase())) {
                id.value=sValue;
                return;
            }
        }

        // id not found, so add it
        this.ids.add(new AdminID(sType,sValue));
    }

    //--- GET ACTIVE PRIVATE ----------------------------------------------------------------------
    public AdminPrivateContact getActivePrivate() {
        AdminPrivateContact apc;

        for (int i=0;i<privateContacts.size();i++) {
            apc = (AdminPrivateContact) privateContacts.elementAt(i);
            if (apc.end.equals("")) {
                return apc;
            }
        }
        return new AdminPrivateContact();
    }

    //--- COMPARE FIELD ---------------------------------------------------------------------------
    private boolean compareField(Object source,Object target,String sField){
        try {
            Field field=source.getClass().getField(sField);
            if (field.get(source)!=null && (field.getType().isPrimitive() || (field.getType().isInstance("") && ((String)field.get(source)).length()>0))){
                if (!field.get(source).equals(field.get(target))){
                    return false;
                }
            }
        } catch (NoSuchFieldException e) {
            e.printStackTrace();
        } catch (SecurityException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
        return true;
    }

    //--- EQUALS PARTIAL PERSON -------------------------------------------------------------------
    public boolean equalsPartialPerson(AdminPerson person){
        //Eerst vergelijken we de signaletiek
        if (person.ids!=null){
            AdminID id;
            for (int n=0;n<person.ids.size();n++){
                id = (AdminID)person.ids.elementAt(n);
                if (!id.value.trim().equals(this.getID(id.type).trim())) return false;
            }
        }
        if (!compareField(person,this,"firstname")) return false;
        if (!compareField(person,this,"middlename")) return false;
        if (!compareField(person,this,"lastname")) return false;
        if (!compareField(person,this,"language")) return false;
        if (!compareField(person,this,"gender")) return false;
        if (!compareField(person,this,"dateOfBirth")) return false;
        if (!compareField(person,this,"comment")) return false;
        if (!compareField(person,this,"pension")) return false;
        if (!compareField(person,this,"engagement")) return false;
        if (!compareField(person,this,"statute")) return false;
        if (!compareField(person,this,"claimant")) return false;
        if (!compareField(person,this,"claimantExpiration")) return false;
        if (!compareField(person,this,"nativeCountry")) return false;
        if (!compareField(person,this,"nativeTown")) return false;
        if (!compareField(person,this,"personType")) return false;
        if (!compareField(person,this,"situationEndOfService")) return false;
        if (!compareField(person,this,"motiveEndOfService")) return false;
        if (!compareField(person,this,"startdateInactivity")) return false;
        if (!compareField(person,this,"enddateInactivity")) return false;
        if (!compareField(person,this,"codeInactivity")) return false;
        if (!compareField(person,this,"comment1")) return false;
        if (!compareField(person,this,"comment2")) return false;
        if (!compareField(person,this,"comment3")) return false;
        if (!compareField(person,this,"comment4")) return false;
        if (!compareField(person,this,"comment5")) return false;

        //Daarna de privégegevens
        AdminPrivateContact personPrivate=person.getActivePrivate();
        AdminPrivateContact thisPrivate=this.getActivePrivate();
        if(!compareField(personPrivate,thisPrivate,"address")) return false;
        if(!compareField(personPrivate,thisPrivate,"city")) return false;
        if(!compareField(personPrivate,thisPrivate,"zipcode")) return false;
        if(!compareField(personPrivate,thisPrivate,"country")) return false;
        if(!compareField(personPrivate,thisPrivate,"telephone")) return false;
        if(!compareField(personPrivate,thisPrivate,"fax")) return false;
        if(!compareField(personPrivate,thisPrivate,"mobile")) return false;
        if(!compareField(personPrivate,thisPrivate,"email")) return false;
        if(!compareField(personPrivate,thisPrivate,"comment")) return false;
        if(!compareField(personPrivate,thisPrivate,"type")) return false;
        return true;
    }

    //--- GET ACTIVE PERSON -----------------------------------------------------------------------
    public AdminPerson getActivePerson(){
        AdminPrivateContact privateContact = getActivePrivate();
        privateContacts=new Vector();
        if (privateContact.privateid.length()!=0){
            privateContacts.add(privateContact);
        }
        return this;
    }

    //--- IS HOSPITALIZED -------------------------------------------------------------------------
    public boolean isHospitalized(){
        Service activeDivision = getActiveDivision();
        return (activeDivision!=null);
    }

    //--- GET ACTIVE DIVISION ---------------------------------------------------------------------
    public Service getActiveDivision(){
        return ScreenHelper.getActiveDivision(this.personid);
    }

    //--- GET ACTIVE PRESCRIPTIONS (internal supplying service) -----------------------------------
    public Vector getActivePrescriptions(){
        Vector prescriptions = new Vector();
        Prescription prescription;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // compose query
            String sSelect = "SELECT OC_PRESCR_SERVERID, OC_PRESCR_OBJECTID, OC_PRESCR_PRODUCTUID, OC_PRESCR_SUPPLYINGSERVICEUID"+
                             " FROM OC_PRESCRIPTIONS"+
                             "  WHERE OC_PRESCR_PATIENTUID = ?"+
                             "   AND (OC_PRESCR_END >= ? OR OC_PRESCR_END IS NULL) "+
                             //"   AND "+lowerServiceCode+" NOT LIKE 'extfour%'"+
                             " ORDER BY OC_PRESCR_BEGIN DESC";

            // set questionmark values
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,this.personid);
            ps.setDate(2,new Date(new java.util.Date().getTime())); // now

            // execute
            String supplyingServiceUid;
            rs = ps.executeQuery();
            while(rs.next()){
                // only get prescriptions supplied by internal services
                supplyingServiceUid = ScreenHelper.checkString(rs.getString("OC_PRESCR_SUPPLYINGSERVICEUID"));
                boolean supplyingServiceIsExternalService = false;
                if(supplyingServiceUid.length() > 0){
                    supplyingServiceIsExternalService = Service.isExternalService(supplyingServiceUid);
                }

                if(!supplyingServiceIsExternalService){
                    prescription = Prescription.get(rs.getString("OC_PRESCR_SERVERID")+"."+rs.getString("OC_PRESCR_OBJECTID"));
                    prescriptions.add(prescription);
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return prescriptions;
    }

    //--- IS USER ---------------------------------------------------------------------------------
    public boolean isUser(){
        boolean isUser = false;
        PreparedStatement ps = null;
        ResultSet rs = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            // compose query
            String sSelect = "SELECT userid FROM Users WHERE personid = ?";
            ps = ad_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(this.personid));

            // execute
            rs = ps.executeQuery();
            if(rs.next()) isUser = true;
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return isUser;
    }

    public static List getUserHospitalized(String sUserID){
        PreparedStatement ps = null;
        ResultSet rs = null;

        //Vector vResults = new Vector();
        List lResults = new ArrayList();

        String sSelect =" SELECT DISTINCT OC_ENCOUNTER_PATIENTUID," +
                                        " personid," +
                                        " immatnew," +
                                        " natreg," +
                                        " lastname," +
                                        " firstname," +
                                        " gender," +
                                        " dateofbirth," +
                                        " pension" +
                                        " FROM AdminView a,OC_ENCOUNTER_SERVICES o,OC_ENCOUNTERS o2" +
                                        " WHERE"
                                        + " o2.OC_ENCOUNTER_OBJECTID=o.OC_ENCOUNTER_OBJECTID and"
                                        + " o2.OC_ENCOUNTER_SERVERID=o.OC_ENCOUNTER_SERVERID and"
                                        + " (o.OC_ENCOUNTER_SERVICEENDDATE IS NULL OR o.OC_ENCOUNTER_SERVICEENDDATE > ?)" +
                                        " AND o2.OC_ENCOUNTER_TYPE = 'admission'" +
                                        " AND o.OC_ENCOUNTER_MANAGERUID = ?" +
                                        " AND o2.OC_ENCOUNTER_PATIENTUID = personid";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect.trim());
            ps.setTimestamp(1,new Timestamp(ScreenHelper.getSQLTime().getTime()));
            ps.setString(2,sUserID);

            rs = ps.executeQuery();

            AdminPerson tempPat;
            while(rs.next()){
                tempPat = new AdminPerson();
                //tempPat.setPatientUID(ScreenHelper.checkString(rs.getString("OC_ENCOUNTER_PATIENTUID")));
                tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                //tempPat.setPersonid(ScreenHelper.checkString(rs.getString("personid")));
                tempPat.ids.addElement(new AdminID("ImmatNew",ScreenHelper.checkString(rs.getString("immatnew"))));
                //tempPat.setImmatnew(ScreenHelper.checkString(rs.getString("immatnew")));
                tempPat.ids.addElement(new AdminID("NatReg",ScreenHelper.checkString(rs.getString("natreg"))));
                //tempPat.setNatreg(ScreenHelper.checkString(rs.getString("natreg")));
                tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                //tempPat.setLastname(ScreenHelper.checkString(rs.getString("lastname")));
                tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                //tempPat.setFirstname(ScreenHelper.checkString(rs.getString("firstname")));
                tempPat.gender = ScreenHelper.checkString(rs.getString("gender"));
                //tempPat.setGender(ScreenHelper.checkString(rs.getString("gender")));
                tempPat.pension = ScreenHelper.checkString(rs.getString("pension"));
                //tempPat.setPension(ScreenHelper.checkString(rs.getString("pension")));
                if(rs.getDate("dateofbirth") != null){
                    tempPat.dateOfBirth = ScreenHelper.stdDateFormat.format(rs.getDate("dateofbirth"));
                }else{
                    tempPat.dateOfBirth = "";
                }
                //tempPat.setDateofbirth(rs.getDate("dateofbirth"));

                lResults.add(tempPat);
            }

            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return lResults;
    }

    public static List getUserVisits(String sUserID){
        PreparedStatement ps = null;
        ResultSet rs = null;

        //Vector vResults = new Vector();
        List lResults = new ArrayList();

        String sSelect =" SELECT DISTINCT OC_ENCOUNTER_PATIENTUID," +
                                        " personid," +
                                        " immatnew," +
                                        " natreg," +
                                        " lastname," +
                                        " firstname," +
                                        " gender," +
                                        " dateofbirth," +
                                        " pension" +
                        " FROM AdminView a,OC_ENCOUNTER_SERVICES o,OC_ENCOUNTERS o2" +
                        " WHERE"
                        + " o2.OC_ENCOUNTER_OBJECTID=o.OC_ENCOUNTER_OBJECTID and"
                        + " o2.OC_ENCOUNTER_SERVERID=o.OC_ENCOUNTER_SERVERID and"
                        + " (o.OC_ENCOUNTER_SERVICEENDDATE IS NULL OR o.OC_ENCOUNTER_SERVICEENDDATE > ?)" +
                        " AND o2.OC_ENCOUNTER_TYPE = 'visit'" +
                        " AND o.OC_ENCOUNTER_MANAGERUID = ?" +
                        " AND o2.OC_ENCOUNTER_PATIENTUID = personid";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect.trim());
            ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
            ps.setString(2,sUserID);

            rs = ps.executeQuery();

            AdminPerson tempPat;
            while(rs.next()){
                tempPat = new AdminPerson();
                //tempPat.setPatientUID(ScreenHelper.checkString(rs.getString("OC_ENCOUNTER_PATIENTUID")));
                tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                //tempPat.setPersonid(ScreenHelper.checkString(rs.getString("personid")));
                tempPat.ids.addElement(new AdminID("ImmatNew",ScreenHelper.checkString(rs.getString("immatnew"))));
                //tempPat.setImmatnew(ScreenHelper.checkString(rs.getString("immatnew")));
                tempPat.ids.addElement(new AdminID("NatReg",ScreenHelper.checkString(rs.getString("natreg"))));
                //tempPat.setNatreg(ScreenHelper.checkString(rs.getString("natreg")));
                tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                //tempPat.setLastname(ScreenHelper.checkString(rs.getString("lastname")));
                tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                //tempPat.setFirstname(ScreenHelper.checkString(rs.getString("firstname")));
                tempPat.gender = ScreenHelper.checkString(rs.getString("gender"));
                //tempPat.setGender(ScreenHelper.checkString(rs.getString("gender")));
                tempPat.pension = ScreenHelper.checkString(rs.getString("pension"));
                //tempPat.setPension(ScreenHelper.checkString(rs.getString("pension")));
                if(rs.getDate("dateofbirth") != null){
                    tempPat.dateOfBirth = ScreenHelper.stdDateFormat.format(rs.getDate("dateofbirth"));
                }else{
                    tempPat.dateOfBirth = "";
                }
                //tempPat.setDateofbirth(rs.getDate("dateofbirth"));
                lResults.add(tempPat);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return lResults;
    }

    public static Vector getPatientsAdmittedInService(String serviceid){
        Vector patients=new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try {
            String sQuery="select OC_ENCOUNTER_PATIENTUID " +
                    " from OC_ENCOUNTERS o, OC_ENCOUNTER_SERVICES p where " +
					" o.OC_ENCOUNTER_SERVERID=p.OC_ENCOUNTER_SERVERID and " +
					" o.OC_ENCOUNTER_OBJECTID=p.OC_ENCOUNTER_OBJECTID and " +
                    " p.OC_ENCOUNTER_SERVICEUID=? and" +
                    " (OC_ENCOUNTER_SERVICEENDDATE IS NULL or OC_ENCOUNTER_SERVICEENDDATE>=?) and" +
                    " OC_ENCOUNTER_SERVICEBEGINDATE<=?";
            ps=oc_conn.prepareStatement(sQuery);
            ps.setString(1,serviceid);
            ps.setDate(2,new java.sql.Date(new java.util.Date().getTime()));
            ps.setDate(3,new java.sql.Date(new java.util.Date().getTime()));
            rs = ps.executeQuery();
            while(rs.next()){
                patients.add(rs.getString("OC_ENCOUNTER_PATIENTUID"));
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return patients;
    }

    public static List getPatientsInEncounterServiceUID(String simmatnew,String sArchiveFileCode,String snatreg,String sName,String sFirstname,String sDateOfBirth,String sEncounterServiceUID, String sPersonID, String sDistrict){
    	return getPatientsInEncounterServiceUID(simmatnew, sArchiveFileCode, snatreg, sName, sFirstname, sDateOfBirth, sEncounterServiceUID, sPersonID, sDistrict, "");
    }
    
    public static List getPatientsInEncounterServiceUID(String simmatnew,String sArchiveFileCode,String snatreg,String sName,String sFirstname,String sDateOfBirth,String sEncounterServiceUID, String sPersonID, String sDistrict, String sSector){
        PreparedStatement ps = null;
        ResultSet rs = null;

        //Check if we are using an MPI personID
        try {
        	if(sPersonID!=null && sPersonID.length()>0) {
        		int p = Integer.parseInt(sPersonID);
        	}
        }
        catch(Exception e) {
        	try {
	        	//This might be an MPI number, try to find it
	        	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	        	ps = conn.prepareStatement("select personid from adminextends where labelid='mpiid' and extendvalue=?");
	        	ps.setString(1, sPersonID);
	        	rs=ps.executeQuery();
	        	if(rs.next()) {
	        		sPersonID=rs.getString("personid");
	        	}
	        	rs.close();
	        	ps.close();
	        	conn.close();
        	}
        	catch(Exception i) {
        		i.printStackTrace();
        	}
        }
        //Vector vResults = new Vector();
        List lResults = new ArrayList();

        String sSQLSelect = " SELECT distinct searchname,OC_ENCOUNTER_PATIENTUID,a.personid, immatnew, natreg, lastname, firstname, gender, dateofbirth, pension";
        String sSQLFrom   = " FROM AdminView a, OC_ENCOUNTERS o, OC_ENCOUNTER_SERVICES p";
        String sSQLWhere  = " (OC_ENCOUNTER_SERVICEENDDATE IS NULL OR OC_ENCOUNTER_SERVICEENDDATE >= ?) AND "
							+ " o.OC_ENCOUNTER_SERVERID=p.OC_ENCOUNTER_SERVERID and " 
							+ " o.OC_ENCOUNTER_OBJECTID=p.OC_ENCOUNTER_OBJECTID and " +
                            " OC_ENCOUNTER_TYPE IN ('admission','visit') AND" +
                            " OC_ENCOUNTER_PATIENTUID = a.personid AND";

        if (simmatnew.trim().length()>0) {
            sSQLWhere += " immatnew = '"+simmatnew+"' AND";
        }
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();

        if (sArchiveFileCode.trim().length()>0) {
            String lowerArchiverFileCode = ScreenHelper.getConfigParam("lowerCompare","archiveFileCode",oc_conn);
            sSQLWhere += " "+lowerArchiverFileCode+" LIKE '"+sArchiveFileCode.toLowerCase()+"%' AND";
        }

        if (snatreg.trim().length()>0) {
            sSQLWhere += " natreg = '"+snatreg+"' AND";
        }

        if (sPersonID.trim().length()>0) {
            sSQLWhere += " a.personid = '"+sPersonID+"' AND";
        }

        sName = ScreenHelper.normalizeSpecialCharacters(sName);
        sFirstname = ScreenHelper.normalizeSpecialCharacters(sFirstname);

        if ((sName.trim().length()>0)&&(sFirstname.trim().length()>0)) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%,"+sFirstname.toUpperCase()+"%' AND";
        }
        else if (sName.trim().length()>0) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%' AND";
        }
        else if (sFirstname.trim().length()>0) {
            sSQLWhere += " searchname like '%,"+sFirstname.toUpperCase()+"%' AND";
        }

        if (sDateOfBirth.trim().length()==10) {
            if (sDateOfBirth.indexOf("/")>0) {
                sSQLWhere += " dateofbirth = ? AND";
            }
            else {
                sDateOfBirth = "";
            }
        }
        else {
            sDateOfBirth = "";
        }

        if (sEncounterServiceUID.trim().length()>0) {
            if (MedwanQuery.getInstance().getConfigString("showChildServices").toLowerCase().equals("true")) {
                sEncounterServiceUID = "'"+sEncounterServiceUID+"'"+AdminPerson.getChildServices(sEncounterServiceUID);
                sSQLWhere += " OC_ENCOUNTER_SERVICEUID IN ("+sEncounterServiceUID+") AND";
            }
            else {
                sSQLWhere += " OC_ENCOUNTER_SERVICEUID  = '"+sEncounterServiceUID+"' AND";
            }
        }
        if(sDistrict.trim().length()>0){
            sSQLFrom+=",PrivateView v ";
            sSQLWhere+=" a.personid=v.personid AND v.district = '"+sDistrict+"' AND";
        }
        if(sSector.trim().length()>0){
            if(sDistrict.trim().length()==0){
            	sSQLFrom+=",PrivateView v ";
            }
            sSQLWhere+=" a.personid=v.personid AND v.sector = '"+sSector+"' AND";
        }
        try{
            if (sSQLWhere.trim().length()>0) {
                String sSelect = sSQLSelect+" "+sSQLFrom+" WHERE "+sSQLWhere.substring(0,sSQLWhere.length()-3)+
                          " ORDER BY searchname ";
                ps = oc_conn.prepareStatement(sSelect.trim());
                ps.setDate(1,new java.sql.Date(new java.util.Date().getTime())); // now

                if (sDateOfBirth.trim().length()>0) {
                    java.sql.Date dDate=null;
                    try {
                        dDate=new java.sql.Date(ScreenHelper.parseDate(sDateOfBirth).getTime());
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                    ps.setDate(2,dDate);
                }
                rs = ps.executeQuery();

                AdminPerson tempPat;
                while(rs.next()){
                    tempPat = new AdminPerson();
                    //tempPat.setPatientUID(ScreenHelper.checkString(rs.getString("OC_ENCOUNTER_PATIENTUID")));
                    tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                    //tempPat.setPersonid(ScreenHelper.checkString(rs.getString("personid")));
                    tempPat.ids.addElement(new AdminID("ImmatNew",ScreenHelper.checkString(rs.getString("immatnew"))));
                    //tempPat.setImmatnew(ScreenHelper.checkString(rs.getString("immatnew")));
                    tempPat.ids.addElement(new AdminID("NatReg",ScreenHelper.checkString(rs.getString("natreg"))));
                    //tempPat.setNatreg(ScreenHelper.checkString(rs.getString("natreg")));
                    tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                    //tempPat.setLastname(ScreenHelper.checkString(rs.getString("lastname")));
                    tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                    //tempPat.setFirstname(ScreenHelper.checkString(rs.getString("firstname")));
                    tempPat.gender = ScreenHelper.checkString(rs.getString("gender"));
                    //tempPat.setGender(ScreenHelper.checkString(rs.getString("gender")));
                    tempPat.pension = ScreenHelper.checkString(rs.getString("pension"));
                    //tempPat.setPension(ScreenHelper.checkString(rs.getString("pension")));
                    if(rs.getDate("dateofbirth") != null){
                        tempPat.dateOfBirth = ScreenHelper.stdDateFormat.format(rs.getDate("dateofbirth"));
                    }else{
                        tempPat.dateOfBirth = "";
                    }
                    //tempPat.setDateofbirth(rs.getDate("dateofbirth"));

                    lResults.add(tempPat);
                }

                rs.close();
                ps.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return lResults;
    }

    public static List getAllPatients(String simmatnew,String sArchiveFileCode,String snatreg,String sName,String sFirstname,String sDateOfBirth, String sPersonID, String sDistrict){
        PreparedStatement ps = null;
        ResultSet rs = null;
        //Vector vResults = new Vector();
        List lResultList = new ArrayList();

        String sSQLSelect = " SELECT DISTINCT a.searchname, a.personid, a.immatnew, a.natreg, a.lastname, a.firstname, a.gender, a.dateofbirth, a.pension";
        String sSQLFrom   = " FROM AdminView a";
        String sSQLWhere  = " 1=1 AND";

        if (simmatnew.trim().length()>0) {
            //simmatnew = simmatnew.replaceAll("\\.","");
            //simmatnew = simmatnew.replaceAll("-","");
            //simmatnew = simmatnew.replaceAll("/","");
            sSQLWhere += " immatnew like '"+simmatnew+"%' AND";
        }

        /*if (simmatold.trim().length()>0) {
            sSQLWhere += " immatold = '"+simmatold+"' AND";
        }*/
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();

        if (sArchiveFileCode.trim().length()>0) {
            String lowerArchiverFileCode = ScreenHelper.getConfigParam("lowerCompare","archiveFileCode",oc_conn);
            sSQLWhere += " "+lowerArchiverFileCode+" LIKE '"+sArchiveFileCode.toLowerCase()+"' AND";
        }

        if (snatreg.trim().length()>0) {
            sSQLWhere += " natreg like '"+snatreg+"%' AND";
        }

        if (sPersonID.trim().length()>0) {
            sSQLWhere += " a.personid = "+sPersonID+" AND";
        }

        if (sDistrict.trim().length()>0){
            sSQLFrom += ", AdminPrivate p";
            sSQLWhere += " p.personid = a.personid AND district = '"+sDistrict+"' AND";
        }

        sName = ScreenHelper.normalizeSpecialCharacters(sName);
        sFirstname = ScreenHelper.normalizeSpecialCharacters(sFirstname);

        if ((sName.trim().length()>0)&&(sFirstname.trim().length()>0)) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%,"+sFirstname.toUpperCase()+"%' AND";
        }
        else if (sName.trim().length()>0) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%' AND";
        }
        else if (sFirstname.trim().length()>0) {
            sSQLWhere += " searchname like '%,"+sFirstname.toUpperCase()+"%' AND";
        }

        if (sDateOfBirth.trim().length()==10) {
            if (sDateOfBirth.replaceAll("-","/").indexOf("/")>0) {
                sSQLWhere += " dateofbirth = ? AND";
            }
            else {
                sDateOfBirth = "";
            }
        }
        else {
            sDateOfBirth = "";
        }

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            if (sSQLWhere.trim().length()>0) {
                String sSelect = sSQLSelect+" "+sSQLFrom+" WHERE "+sSQLWhere.substring(0,sSQLWhere.length()-3)+
                          " ORDER BY searchname ";
                ps = ad_conn.prepareStatement(sSelect.trim());

                if (sDateOfBirth.trim().length()>0) {
                    ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(sDateOfBirth.replaceAll("-","/")).getTime()));
                }
                rs = ps.executeQuery();

                AdminPerson tempPat;
                while(rs.next()){
                    tempPat = new AdminPerson();
                    //tempPat.setPatientUID(ScreenHelper.checkString(rs.getString("OC_ENCOUNTER_PATIENTUID")));
                    tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                    //tempPat.setPersonid(ScreenHelper.checkString(rs.getString("personid")));
                    tempPat.ids.addElement(new AdminID("ImmatNew",ScreenHelper.checkString(rs.getString("immatnew"))));
                    //tempPat.setImmatnew(ScreenHelper.checkString(rs.getString("immatnew")));
                    tempPat.ids.addElement(new AdminID("NatReg",ScreenHelper.checkString(rs.getString("natreg"))));
                    //tempPat.setNatreg(ScreenHelper.checkString(rs.getString("natreg")));
                    tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                    //tempPat.setLastname(ScreenHelper.checkString(rs.getString("lastname")));
                    tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                    //tempPat.setFirstname(ScreenHelper.checkString(rs.getString("firstname")));
                    tempPat.gender = ScreenHelper.checkString(rs.getString("gender"));
                    //tempPat.setGender(ScreenHelper.checkString(rs.getString("gender")));
                    tempPat.pension = ScreenHelper.checkString(rs.getString("pension"));
                    //tempPat.setPension(ScreenHelper.checkString(rs.getString("pension")));
                    if(rs.getDate("dateofbirth") != null){
                        tempPat.dateOfBirth = ScreenHelper.stdDateFormat.format(rs.getDate("dateofbirth"));
                    }else{
                        tempPat.dateOfBirth = "";
                    }
                    //tempPat.setDateofbirth(rs.getDate("dateofbirth"));
                    lResultList.add(tempPat);
                    //vResults.addElement(tempPat);
                }

                rs.close();
                ps.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return lResultList;
    }
    public static List getAllPatients(String simmatnew,String sArchiveFileCode,String snatreg,String sName,String sFirstname,String sDateOfBirth, String sPersonID, String sDistrict, int iMaxResults){
    	return getAllPatients(simmatnew, sArchiveFileCode, snatreg, sName, sFirstname, sDateOfBirth, sPersonID, sDistrict,iMaxResults,"");
    }
    
    public static List getAllPatients(String simmatnew,String sArchiveFileCode,String snatreg,String sName,String sFirstname,String sDateOfBirth, String sPersonID, String sDistrict, int iMaxResults,String sSector){
        PreparedStatement ps = null;
        ResultSet rs = null;
        //Vector vResults = new Vector();
        List lResultList = new ArrayList();
        
        //Check if we are using an MPI personID
        try {
        	if(sPersonID!=null && sPersonID.length()>0) {
        		int p = Integer.parseInt(sPersonID);
        	}
        }
        catch(Exception e) {
        	try {
        		if(MedwanQuery.getInstance().getConfigInt("isMPIServer",0)==1) {
        			sPersonID=ScreenHelper.convertFromUUID(sPersonID)+"";
        		}
        		else {
		        	//This might be an MPI number, try to find it
		        	Connection conn = MedwanQuery.getInstance().getAdminConnection();
		        	ps = conn.prepareStatement("select personid from adminextends where labelid='mpiid' and extendvalue=?");
		        	ps.setString(1, sPersonID);
		        	rs=ps.executeQuery();
		        	if(rs.next()) {
		        		sPersonID=rs.getString("personid");
		        	}
		        	rs.close();
		        	ps.close();
		        	conn.close();
        		}
        	}
        	catch(Exception i) {
        		i.printStackTrace();
        	}
        }

        String sSQLSelect = " SELECT DISTINCT a.searchname, a.personid, a.immatnew, a.natreg, a.lastname, a.firstname, a.gender, a.dateofbirth, a.pension";
        String sSQLFrom   = " FROM AdminView a";
        String sSQLWhere  = " 1=1 AND";

        if (simmatnew.trim().length()>0) {
            sSQLWhere += " immatnew like '"+simmatnew+"%' AND";
        }

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();

        if (sArchiveFileCode.trim().length()>0) {
            String lowerArchiverFileCode = ScreenHelper.getConfigParam("lowerCompare","archiveFileCode",oc_conn);
            sSQLWhere += " "+lowerArchiverFileCode+" LIKE '"+sArchiveFileCode.toLowerCase()+"' AND";
        }

        if (snatreg.trim().length()>0) {
            sSQLWhere += " natreg like '"+snatreg+"%' AND";
        }

        if (sPersonID.trim().length()>0) {
            sSQLWhere += " a.personid = "+sPersonID+" AND";
        }

        if (sDistrict.trim().length()>0){
            sSQLFrom += ", AdminPrivate p";
            sSQLWhere += " p.personid = a.personid AND district = '"+sDistrict+"' AND";
        }

        if (sSector.trim().length()>0){
        	if(sDistrict.trim().length()==0){
        		sSQLFrom += ", AdminPrivate p";
        	}
            sSQLWhere += " p.personid = a.personid AND sector = '"+sSector+"' AND";
        }

        sName = ScreenHelper.normalizeSpecialCharacters(sName);
        sFirstname = ScreenHelper.normalizeSpecialCharacters(sFirstname);

        if ((sName.trim().length()>0)&&(sFirstname.trim().length()>0)) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%,"+sFirstname.toUpperCase()+"%' AND";
        }
        else if (sName.trim().length()>0) {
            sSQLWhere += " searchname like '"+sName.toUpperCase()+"%' AND";
        }
        else if (sFirstname.trim().length()>0) {
            sSQLWhere += " searchname like '%,"+sFirstname.toUpperCase()+"%' AND";
        }

        if (sDateOfBirth.trim().length()==10) {
            if (sDateOfBirth.indexOf("/")>0) {
                sSQLWhere += " dateofbirth = ? AND";
            }
            else {
                sDateOfBirth = "";
            }
        }
        else {
            sDateOfBirth = "";
        }

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            if (sSQLWhere.trim().length()>0) {
                String sSelect = sSQLSelect+" "+sSQLFrom+" WHERE "+sSQLWhere.substring(0,sSQLWhere.length()-3)+
                          " ORDER BY searchname ";
                Debug.println(sSelect);
                ps = ad_conn.prepareStatement(sSelect.trim());

                if (sDateOfBirth.trim().length()>0) {
                    ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(sDateOfBirth.replaceAll("-","/")).getTime()));
                }
                
                rs = ps.executeQuery();

                AdminPerson tempPat;
                while(rs.next() && lResultList.size()<=iMaxResults){
                    tempPat = new AdminPerson();
                    //tempPat.setPatientUID(ScreenHelper.checkString(rs.getString("OC_ENCOUNTER_PATIENTUID")));
                    tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                    //tempPat.setPersonid(ScreenHelper.checkString(rs.getString("personid")));
                    tempPat.ids.addElement(new AdminID("ImmatNew",ScreenHelper.checkString(rs.getString("immatnew"))));
                    //tempPat.setImmatnew(ScreenHelper.checkString(rs.getString("immatnew")));
                    tempPat.ids.addElement(new AdminID("NatReg",ScreenHelper.checkString(rs.getString("natreg"))));
                    //tempPat.setNatreg(ScreenHelper.checkString(rs.getString("natreg")));
                    tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                    //tempPat.setLastname(ScreenHelper.checkString(rs.getString("lastname")));
                    tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                    //tempPat.setFirstname(ScreenHelper.checkString(rs.getString("firstname")));
                    tempPat.gender = ScreenHelper.checkString(rs.getString("gender"));
                    //tempPat.setGender(ScreenHelper.checkString(rs.getString("gender")));
                    tempPat.pension = ScreenHelper.checkString(rs.getString("pension"));
                    //tempPat.setPension(ScreenHelper.checkString(rs.getString("pension")));
                    if(rs.getDate("dateofbirth") != null){
                        tempPat.dateOfBirth = ScreenHelper.stdDateFormat.format(rs.getDate("dateofbirth"));
                    }else{
                        tempPat.dateOfBirth = "";
                    }
                    //tempPat.setDateofbirth(rs.getDate("dateofbirth"));
                    lResultList.add(tempPat);
                    //vResults.addElement(tempPat);
                }

                rs.close();
                ps.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return lResultList;
    }

    public static List getLimitedPatients(String sName,String sFirstname, int iMaxRows){
           PreparedStatement ps = null;
           ResultSet rs = null;
           //Vector vResults = new Vector();
           List lResultList = new ArrayList();


           String sSQLSelect = " SELECT "+MedwanQuery.getInstance().topFunction(""+iMaxRows)+" searchname,personid, lastname, firstname,dateofbirth";
           String sSQLFrom   = " FROM AdminView a";
           String sSQLWhere  = " 1=1 AND";


           sName = ScreenHelper.normalizeSpecialCharacters(sName);
           sFirstname = ScreenHelper.normalizeSpecialCharacters(sFirstname);

           if ((sName.trim().length()>0)&&(sFirstname.trim().length()>0)) {
               sSQLWhere += " searchname like '"+sName.toUpperCase()+"%,"+sFirstname.toUpperCase()+"%' AND";
           }
           else if (sName.trim().length()>0) {
               sSQLWhere += " searchname like '"+sName.toUpperCase()+"%' AND";
           }
           else if (sFirstname.trim().length()>0) {
               sSQLWhere += " searchname like '%,"+sFirstname.toUpperCase()+"%' AND";
           }

           Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
           try{
               if (sSQLWhere.trim().length()>0) {
                   String sSelect = sSQLSelect+" "+sSQLFrom+" WHERE "+sSQLWhere.substring(0,sSQLWhere.length()-3);

                   if (sFirstname.length()>0){
                        sSelect += " ORDER BY firstname, searchname ";
                   }
                   else {
                        sSelect += " ORDER BY searchname ";
                   }
                   sSelect +=MedwanQuery.getInstance().limitFunction(""+iMaxRows);
                   ps = oc_conn.prepareStatement(sSelect.trim());

                   rs = ps.executeQuery();

                   AdminPerson tempPat;
                   while(rs.next()){
                       tempPat = new AdminPerson();
                       tempPat.personid = ScreenHelper.checkString(rs.getString("personid"));
                       tempPat.lastname = ScreenHelper.checkString(rs.getString("lastname"));
                       tempPat.firstname = ScreenHelper.checkString(rs.getString("firstname"));
                       Date d = rs.getDate("dateofbirth");
                       tempPat.dateOfBirth = d!=null?ScreenHelper.formatDate(d):"";
                       lResultList.add(tempPat);
                   }

                   rs.close();
                   ps.close();
               }
           }catch(Exception e){
               e.printStackTrace();
           }finally{
               try{
                   if(rs!=null)rs.close();
                   if(ps!=null)ps.close();
                   oc_conn.close();
               }catch(Exception e){
                   e.printStackTrace();
               }
           }

           return lResultList;
       }

    private static String getChildServices(String sParentServiceID) {
        String sReturnServiceIDs = "";
        PreparedStatement ps = null;
        ResultSet rs = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try {
            String sTmpServiceID;
            String sTmpSelect = "SELECT serviceid FROM Services WHERE serviceparentid = ?";
            ps = ad_conn.prepareStatement(sTmpSelect);
            ps.setString(1,sParentServiceID);
            rs = ps.executeQuery();

            while (rs.next()) {
                sTmpServiceID = ScreenHelper.checkString(rs.getString("serviceid"));
                sReturnServiceIDs+= ",'"+sTmpServiceID+"'";
                sReturnServiceIDs+= getChildServices(sTmpServiceID);
            }
        }
        catch (Exception e) {
            Debug.println(e.getMessage());
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return sReturnServiceIDs;
    }

    public static boolean copyActiveToHistory(String personid){
        PreparedStatement ps = null,ps2 = null;
        ResultSet rs = null;

        boolean isFound = false;
        String sSelect = "SELECT personid, immatold, immatnew, candidate, lastname,firstname," +
                " gender, dateofbirth, comment, sourceid, language, engagement, pension,statute, claimant, searchname, updatetime," +
                " claimant_expiration, native_country,native_town, motive_end_of_service, startdate_inactivity, enddate_inactivity," +
                " code_inactivity, update_status, person_type, situation_end_of_service, updateuserid," +
                " comment1, comment2, comment3, comment4, comment5, natreg, middlename, begindate, enddate, updateserverid, archivefilecode" +
                " FROM Admin WHERE personid = ?";

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(personid));
            rs = ps.executeQuery();

            if(rs.next()){
                isFound = true;
                // insert Admin in AdminHistory (note that the columns have a different order in both tables !)
                StringBuffer sbQuery = new StringBuffer();
                sbQuery.append("INSERT INTO AdminHistory(personid, immatold, immatnew, candidate, lastname,")
                       .append("  firstname, gender, dateofbirth, comment, sourceid, language, engagement, pension,")
                       .append("  statute, claimant, searchname, updatetime, claimant_expiration, native_country,")
                       .append("  native_town, motive_end_of_service, startdate_inactivity, enddate_inactivity,")
                       .append("  code_inactivity, update_status, person_type, situation_end_of_service, updateuserid,")
                       .append("  comment1, comment2, comment3, comment4, comment5, natreg, middlename, begindate, enddate, updateserverid,archivefilecode) ")
                       .append(" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"); // 39
                ps2 = ad_conn.prepareStatement(sbQuery.toString());

                Object obj;
                String columnType;

                // get adminHistory metadata : put column types in a vector
                Vector adminHistoryMetaData = new Vector();
                DatabaseMetaData databaseMetaData = ad_conn.getMetaData();
                ResultSet rsMD = databaseMetaData.getColumns(null,null,"AdminHistory",null);
                String type;

                while(rsMD.next()){
                    type = rsMD.getString("TYPE_NAME");

                    if(type.equals("varchar") || type.equals("nvarchar") || type.equals("char")){
                        adminHistoryMetaData.add("String");
                    }
                    else if(type.equals("datetime") || type.equals("smalldatetime")){
                        adminHistoryMetaData.add("Date");
                    }
                    else{
                        adminHistoryMetaData.add(type);
                    }
                }

                rsMD.close();

                // set questionmarks in query
                for(int i=1; i<=39; i++){
                    obj = rs.getObject(i);

                    if(obj==null){
                        columnType = (String)adminHistoryMetaData.elementAt((i-1));

                             if(columnType.equals("int"))    ps2.setInt(i,0);
                        else if(columnType.equals("String")) ps2.setString(i,"");
                        else if(columnType.equals("Date"))   ps2.setTimestamp(i,new Timestamp(new java.util.Date().getTime())); // now
                    }
                    else{
                        ps2.setObject(i,obj);
                    }
                }

                // set updatetime = now (~deletetime)
                ps2.setTimestamp(17,new Timestamp(new java.util.Date().getTime()));
                ps2.executeUpdate();
                ps2.close();

                // delete Admin
                ps2 = ad_conn.prepareStatement("DELETE FROM Admin WHERE personid = ?");
                ps2.setInt(1,Integer.parseInt(personid));
                ps2.executeUpdate();
                ps2.close();
            }
            rs.close();
            ps.close();

        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                if(ps2!=null)ps2.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return isFound;
    }

    public static boolean copyActiveToHistoryNoDelete(String personid){
        PreparedStatement ps2 = null;

        boolean isFound = true;
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            // insert Admin in AdminHistory (note that the columns have a different order in both tables !)
            StringBuffer sbQuery = new StringBuffer();
            sbQuery.append("INSERT INTO AdminHistory(personid, immatold, immatnew, candidate, lastname,")
                   .append("  firstname, gender, dateofbirth, comment, sourceid, language, engagement, pension,")
                   .append("  statute, claimant, searchname, updatetime, claimant_expiration, native_country,")
                   .append("  native_town, motive_end_of_service, startdate_inactivity, enddate_inactivity,")
                   .append("  code_inactivity, update_status, person_type, situation_end_of_service, updateuserid,")
                   .append("  comment1, comment2, comment3, comment4, comment5, natreg, middlename, begindate, enddate, updateserverid, archivefilecode) ")
                   .append("SELECT personid, immatold, immatnew, candidate, lastname,firstname,")
			       .append(" gender, dateofbirth, comment, sourceid, language, engagement, pension,statute, claimant, searchname, updatetime,")
			       .append(" claimant_expiration, native_country,native_town, motive_end_of_service, startdate_inactivity, enddate_inactivity,")
			       .append(" code_inactivity, update_status, person_type, situation_end_of_service, updateuserid,")
			       .append(" comment1, comment2, comment3, comment4, comment5, natreg, middlename, begindate, enddate, updateserverid, archivefilecode")
			       .append(" FROM Admin WHERE personid = ?");
            ps2 = ad_conn.prepareStatement(sbQuery.toString());
            ps2.setInt(1,Integer.parseInt(personid));
            ps2.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(ps2!=null)ps2.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return isFound;
    }

    public static Vector searchDoubles(int iSelectedFields){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Hashtable hAdminInfo;
        Vector vDoubles = new Vector();

        StringBuffer sbQuery = new StringBuffer();

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            sbQuery.append("SELECT a1.personid, a2.personid, a1.lastname, a1.firstname, a1.dateofbirth, a1.immatnew, a2.immatnew")
               .append(" FROM Admin a1, Admin a2 ");

            // search on immatnew
            if(iSelectedFields==1){
                sbQuery.append("WHERE a1.immatnew = a2.immatnew");
            }
            // search on searchname AND dateOfBirth
            else if(iSelectedFields==2){
                sbQuery.append("WHERE a1.searchname = a2.searchname")
                       .append(" AND a1.dateofbirth = a2.dateofbirth");
            }

            sbQuery.append(" AND a1.personid != a2.personid")
                   .append(" ORDER BY a1.searchname");

            ps = ad_conn.prepareStatement(sbQuery.toString());
            rs = ps.executeQuery();

            while(rs.next()){
                hAdminInfo = new Hashtable();
                hAdminInfo.put("pid1",ScreenHelper.checkString(rs.getString(1)));
                hAdminInfo.put("pid2",ScreenHelper.checkString(rs.getString(2)));
                hAdminInfo.put("lastname",ScreenHelper.checkString(rs.getString(3)));
                hAdminInfo.put("firstname",ScreenHelper.checkString(rs.getString(4)));
                hAdminInfo.put("dateofbirth",ScreenHelper.checkString(ScreenHelper.getSQLDate(rs.getDate(5))));
                hAdminInfo.put("immatnew1",ScreenHelper.checkString(rs.getString(6)));
                hAdminInfo.put("immatnew2",ScreenHelper.checkString(rs.getString(7)));

                vDoubles.addElement(hAdminInfo);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vDoubles;
    }

    public static String[] getPersonDetails(String sPersonid,String[] personDetails){
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuffer sSelect = new StringBuffer();
        sSelect.append(" SELECT personid,natreg,immatold,immatnew,candidate,lastname,firstname,")
               .append(" gender,dateofbirth,comment,sourceid,language,engagement,pension,")
               .append(" statute,claimant,updatetime,claimant_expiration,native_country,native_town,")
               .append(" motive_end_of_service,startdate_inactivity,enddate_inactivity,")
               .append(" code_inactivity,update_status,person_type,situation_end_of_service,")
               .append(" updateuserid,comment1,comment2,comment3,comment4,comment5,native_country,")
               .append(" middlename,begindate,enddate")
               .append(" FROM Admin WHERE personid = ?");

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect.toString());
            ps.setInt(1,Integer.parseInt(sPersonid));
            rs = ps.executeQuery();

            if(rs.next()){
                for(int i=1; i<personDetails.length; i++){
                // dates should be formatted
                if(i==9 || i==17 || i==18 || i==22 || i==23 || i==36 || i==37){
                    personDetails[i] = ScreenHelper.checkString(ScreenHelper.getSQLDate(rs.getDate(i)));
                }
                else{
                    personDetails[i] = ScreenHelper.checkString(rs.getString(i));
                }
            }
            }

            rs.close();
            ps.close();

        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return personDetails;
    }

    public static Hashtable checkDoublesByOR(Hashtable hSelect,String sQueryAddon){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Hashtable hResults = new Hashtable();
        Enumeration e;
        String sSelect;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            if (hSelect.size()>0) {
                sSelect = "SELECT personid, lastname, firstname, dateofbirth FROM Admin WHERE ";

                if(sQueryAddon.trim().length() > 0){
                    sSelect += " ( ";
                }
                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sSelect+= (String)e.nextElement();
                }

                // remove OR
                sSelect = sSelect.substring(0,sSelect.length()-3);

                ps = ad_conn.prepareStatement(sSelect);
                int iIndex = 1;
                String sKey, sValue;

                // set values
                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sKey = (String)e.nextElement();
                    sValue = (String)hSelect.get(sKey);

                    if (sKey.equalsIgnoreCase(" dateofbirth = ? OR")){
                        ps.setDate(iIndex,new Date(ScreenHelper.parseDate(sValue).getTime()));
                    }
                    else {
                        ps.setString(iIndex,sValue);
                    }

                    iIndex++;
                }
                if(sQueryAddon.trim().length() > 0){
                    sSelect += " ) " + sQueryAddon;
                }
                rs = ps.executeQuery();

                if(rs.next()){
                    hResults.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hResults.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hResults.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hResults.put("dateofbirth",ScreenHelper.getSQLTimeStamp(rs.getTimestamp("dateofbirth")));
                }
                rs.close();
                ps.close();
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }
        return hResults;
    }

    public static Hashtable checkDoublesByAND(Hashtable hSelect){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Hashtable hResults = new Hashtable();

        Enumeration e;
        String sSelect;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            if (hSelect.size()>0) {
                sSelect = "SELECT personid,lastname,firstname,dateofbirth FROM Admin WHERE ";

                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sSelect+= (String)e.nextElement();
                }

                // remove AND
                sSelect = sSelect.substring(0,sSelect.length()-4);

                ps = ad_conn.prepareStatement(sSelect);
                int iIndex = 1;
                String sKey, sValue;

                // set values
                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sKey = (String)e.nextElement();
                    sValue = (String)hSelect.get(sKey);

                    if (sKey.equalsIgnoreCase(" dateofbirth = ? AND")){
                        ps.setDate(iIndex,new java.sql.Date(ScreenHelper.parseDate(sValue).getTime()));
                    }
                    else {
                        ps.setString(iIndex,sValue.toUpperCase());
                    }

                    iIndex++;
                }

                // execute query
                rs = ps.executeQuery();
                if (rs.next()) {
                    hResults.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hResults.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hResults.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hResults.put("dateofbirth",ScreenHelper.getSQLTimeStamp(rs.getTimestamp("dateofbirth")));
                }

                rs.close();
                ps.close();
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }
        return hResults;
    }

    public static Vector multipleCheckDoublesByAND(Hashtable hSelect){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Hashtable hResults = new Hashtable();
        Vector vResults = new Vector();
        Enumeration e;
        String sSelect;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            if (hSelect.size()>0) {
                sSelect = "SELECT personid,lastname,firstname,dateofbirth FROM Admin WHERE ";

                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sSelect+= (String)e.nextElement();
                }

                // remove AND
                sSelect = sSelect.substring(0,sSelect.length()-4);

                ps = ad_conn.prepareStatement(sSelect);
                int iIndex = 1;
                String sKey, sValue;

                // set values
                e = hSelect.keys();
                while (e.hasMoreElements()){
                    sKey = (String)e.nextElement();
                    sValue = (String)hSelect.get(sKey);

                    if (sKey.equalsIgnoreCase(" dateofbirth = ? AND")){
                        ps.setDate(iIndex,new Date(ScreenHelper.parseDate(sValue).getTime()));
                    }
                    else {
                        ps.setString(iIndex,sValue);
                    }

                    iIndex++;
                }

                // execute query
                rs = ps.executeQuery();
                while (rs.next()) {
                    hResults = new Hashtable();
                    hResults.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hResults.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hResults.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hResults.put("dateofbirth",ScreenHelper.getSQLTimeStamp(rs.getTimestamp("dateofbirth")));
                    vResults.addElement(hResults);
                }

                rs.close();
                ps.close();
            }
        }catch(Exception ex){
            ex.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception ex){
                ex.printStackTrace();
            }
        }
        return vResults;
    }

    public static Vector getPrivateId(String sPersonId){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vResults = new Vector();

        String sSelect = "SELECT privateid FROM PrivateView WHERE personid = ? ORDER BY start DESC";

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(sPersonId));
            rs = ps.executeQuery();

            while(rs.next()){
                vResults.addElement(ScreenHelper.checkString(rs.getString("privateid")));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vResults;
    }

    public static String getFullName(String sPersonId){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sResult="";
        String sSelect = "SELECT lastname,firstname FROM Admin WHERE personid = ?";

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(sPersonId));
            rs = ps.executeQuery();

            if(rs.next()){
                sResult = ScreenHelper.checkString(rs.getString("lastname")).toUpperCase()+", "+ScreenHelper.checkString(rs.getString("firstname"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sResult;
    }

    
    public static Vector<Hashtable> searchPatients(String sSelectLastname,String sSelectFirstname,String sFindGender,String sFindDOB,boolean bIsUser){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vResults = new Vector();

        Hashtable hInfo;

        String sSelect = "";

        try{
            if ((sSelectLastname.trim().length()>0) && (sSelectFirstname.trim().length()>0)) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }
            else if (sSelectLastname.trim().length()>0) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,%' AND";
            }
            else if (sSelectFirstname.trim().length()>0) {
                sSelect+= " searchname LIKE '%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }

            if(sFindGender.trim().length() > 0){
                sSelect+= " gender = '"+sFindGender+"' AND";
            }

            // check if sFindDOB has a valid date format
            if(sFindDOB.length() > 0){
                try{
                    sFindDOB = sFindDOB.replaceAll("-","/");
                    ScreenHelper.parseDate(sFindDOB);
                    sSelect+= " dateofbirth = ? AND";
                }
                catch(Exception e){
                    sFindDOB = "";
                }
            }

            // complete query
            String sQuery;
            if(sSelect.length()>0 || bIsUser) {
                if (sSelect.endsWith("AND")){
                    sSelect = sSelect.substring(0,sSelect.length()-3);
                }
                if(bIsUser){
                    sQuery = "SELECT b.userid, a.personid, a.dateofbirth, a.gender, a.lastname, a.firstname, a.immatnew"+
                              " FROM Admin a, Users b"+
                              "  WHERE a.personid=b.personid";
                              if(sSelect.length() > 0) sQuery+= " AND ";
                    sQuery+= " ORDER BY searchname";
                }
                else {
                    sQuery = "SELECT personid, dateofbirth, gender, lastname, firstname, immatnew"+
                              " FROM Admin"+
                              "  WHERE "+sSelect+
                              " ORDER BY searchname";
                }
                
            	Connection lad_conn = MedwanQuery.getInstance().getAdminConnection();
                ps = lad_conn.prepareStatement(sQuery);
                if(sFindDOB.trim().length()>0){
                    ps.setString(1,ScreenHelper.getSQLDate(sFindDOB).toString());
                }

                rs = ps.executeQuery();

                SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
                while(rs.next()){
                    hInfo = new Hashtable();
                    if(bIsUser){
                        hInfo.put("userid",ScreenHelper.checkString(rs.getString("userid")));
                    }
                    hInfo.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hInfo.put("dateofbirth",ScreenHelper.checkString(ScreenHelper.getSQLDate(rs.getDate("dateofbirth"))));
                    hInfo.put("gender",ScreenHelper.checkString(rs.getString("gender")));
                    hInfo.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hInfo.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hInfo.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));

                    vResults.addElement(hInfo);
                }
                rs.close();
                ps.close();
                lad_conn.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return vResults;
    }
    
    public boolean isVirtualInvoicingAccount() {
    	return SH.cs("edition","openclinic").equalsIgnoreCase("bloodbank") && SH.c(adminextends.get("tracnetid")).equals("1");
    }
    
    public static Vector<Hashtable> searchVirtualInvoicingAccounts(String sSelectLastname,String sSelectFirstname,String sFindGender,String sFindDOB,boolean bIsUser){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vResults = new Vector();

        Hashtable hInfo;

        String sSelect = " exists (select * from adminextends x where x.personid=a.personid and labelid='tracnetid' and extendvalue='1') AND";

        try{
            if ((sSelectLastname.trim().length()>0) && (sSelectFirstname.trim().length()>0)) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }
            else if (sSelectLastname.trim().length()>0) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,%' AND";
            }
            else if (sSelectFirstname.trim().length()>0) {
                sSelect+= " searchname LIKE '%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }

            if(sFindGender.trim().length() > 0){
                sSelect+= " gender = '"+sFindGender+"' AND";
            }

            // check if sFindDOB has a valid date format
            if(sFindDOB.length() > 0){
                try{
                    sFindDOB = sFindDOB.replaceAll("-","/");
                    ScreenHelper.parseDate(sFindDOB);
                    sSelect+= " dateofbirth = ? AND";
                }
                catch(Exception e){
                    sFindDOB = "";
                }
            }

            // complete query
            String sQuery;
            if(sSelect.length()>0 || bIsUser) {
                if (sSelect.endsWith("AND")){
                    sSelect = sSelect.substring(0,sSelect.length()-3);
                }
                if(bIsUser){
                    sQuery = "SELECT b.userid, a.personid, a.dateofbirth, a.gender, a.lastname, a.firstname, a.immatnew"+
                              " FROM Admin a, Users b"+
                              "  WHERE a.personid=b.personid";
                              if(sSelect.length() > 0) sQuery+= " AND ";
                    sQuery+= " ORDER BY searchname";
                }
                else {
                    sQuery = "SELECT personid, dateofbirth, gender, lastname, firstname, immatnew"+
                              " FROM Admin a"+
                              "  WHERE "+sSelect+
                              " ORDER BY searchname";
                }
                
            	Connection lad_conn = MedwanQuery.getInstance().getAdminConnection();
                ps = lad_conn.prepareStatement(sQuery);
                if(sFindDOB.trim().length()>0){
                    ps.setString(1,ScreenHelper.getSQLDate(sFindDOB).toString());
                }

                rs = ps.executeQuery();

                SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
                while(rs.next()){
                    hInfo = new Hashtable();
                    if(bIsUser){
                        hInfo.put("userid",ScreenHelper.checkString(rs.getString("userid")));
                    }
                    hInfo.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hInfo.put("dateofbirth",ScreenHelper.checkString(ScreenHelper.getSQLDate(rs.getDate("dateofbirth"))));
                    hInfo.put("gender",ScreenHelper.checkString(rs.getString("gender")));
                    hInfo.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hInfo.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hInfo.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));

                    vResults.addElement(hInfo);
                }
                rs.close();
                ps.close();
                lad_conn.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return vResults;
    }
    public static Vector searchAffiliates(String sSelectLastname,String sSelectFirstname,String sFindGender,String sFindDOB,String sFindInsurarUID,String sFindInsuranceNr){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vResults = new Vector();
        Hashtable hInfo;

        String sSelect = "";

        try{
            if ((sSelectLastname.trim().length()>0) && (sSelectFirstname.trim().length()>0)) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }
            else if (sSelectLastname.trim().length()>0) {
                sSelect+= " searchname LIKE '"+sSelectLastname.toUpperCase()+"%,%' AND";
            }
            else if (sSelectFirstname.trim().length()>0) {
                sSelect+= " searchname LIKE '%,"+sSelectFirstname.toUpperCase()+"%' AND";
            }
            if(sFindGender.trim().length() > 0){
                sSelect+= " gender = '"+sFindGender+"' AND";
            }

            // check if sFindDOB has a valid date format
            if(sFindDOB.length() > 0){
                try{
                    sFindDOB = sFindDOB.replaceAll("-","/");
                    ScreenHelper.parseDate(sFindDOB);
                    sSelect+= " dateofbirth = ? AND";
                }
                catch(Exception e){
                    sFindDOB = "";
                }
            }
            if(sFindInsurarUID.trim().length() > 0){
                if(sFindInsuranceNr.trim().length() > 0){
                    if(sFindInsuranceNr.indexOf("/")>-1){
                    	sFindInsuranceNr=sFindInsuranceNr.substring(0,sFindInsuranceNr.indexOf("/"));
                    }
                    if(sFindInsuranceNr.indexOf(".")>-1){
                    	sFindInsuranceNr=sFindInsuranceNr.substring(0,sFindInsuranceNr.indexOf("."));
                    }
                    if(sFindInsuranceNr.indexOf("-")>-1){
                    	sFindInsuranceNr=sFindInsuranceNr.substring(0,sFindInsuranceNr.indexOf("-"));
                    }
                    if(sFindInsuranceNr.indexOf(" ")>-1){
                    	sFindInsuranceNr=sFindInsuranceNr.substring(0,sFindInsuranceNr.indexOf(" "));
                    }
                    try{
                    	sFindInsuranceNr=Integer.parseInt(sFindInsuranceNr)+"";
                    }
                    catch (Exception e){
                    	sFindInsuranceNr="";
                    }
                }
                sSelect+= " OC_INSURANCE_NR like '"+sFindInsuranceNr+"%' AND OC_INSURANCE_INSURARUID='"+sFindInsurarUID+"' AND";
            }

            // complete query
            String sQuery;
            if(sSelect.length()>0) {
                if (sSelect.endsWith("AND")){
                    sSelect = sSelect.substring(0,sSelect.length()-3);
                }
                sQuery = "SELECT personid, dateofbirth, gender, lastname, firstname, immatnew,b.OC_INSURANCE_NR,b.OC_INSURANCE_MEMBER_EMPLOYER"+
                          " FROM AdminView a,OC_INSURANCES b"+
                          "  WHERE b.OC_INSURANCE_PATIENTUID=a.personid AND b.OC_INSURANCE_STOP IS NULL AND "+sSelect+
                          " ORDER BY searchname";

            	Connection lad_conn = MedwanQuery.getInstance().getOpenclinicConnection();
                ps = lad_conn.prepareStatement(sQuery);
                if(sFindDOB.trim().length()>0){
                    ps.setString(1,ScreenHelper.getSQLDate(sFindDOB).toString());
                }

                rs = ps.executeQuery();

                SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
                while(rs.next()){
                    hInfo = new Hashtable();
                    hInfo.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                    hInfo.put("dateofbirth",ScreenHelper.checkString(ScreenHelper.getSQLDate(rs.getDate("dateofbirth"))));
                    hInfo.put("gender",ScreenHelper.checkString(rs.getString("gender")));
                    hInfo.put("lastname",ScreenHelper.checkString(rs.getString("lastname")));
                    hInfo.put("firstname",ScreenHelper.checkString(rs.getString("firstname")));
                    hInfo.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));
                    hInfo.put("insurancenr",ScreenHelper.checkString(rs.getString("OC_INSURANCE_NR")));
                    hInfo.put("employer",ScreenHelper.checkString(rs.getString("OC_INSURANCE_MEMBER_EMPLOYER")));

                    vResults.addElement(hInfo);
                }
                rs.close();
                ps.close();
                lad_conn.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }

        return vResults;
    }

    //--- GET AGE IN MONTHS -----------------------------------------------------------------------
    public int getAgeInMonths(){
    	try{
	    	Calendar startCalendar = new GregorianCalendar();
	    	startCalendar.setTime(ScreenHelper.parseDate(dateOfBirth));
	    	Calendar endCalendar = new GregorianCalendar();
	    	endCalendar.setTime(new java.util.Date());
	    	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
	    	int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
	    	return diffMonth;
    	}
    	catch(Exception e){
    		return -1;
    	}
    }
    
    public int getAgeInDays(){
    	try{
    		java.util.Date birthdate=ScreenHelper.parseDate(dateOfBirth);
	    	return (int) ((new java.util.Date().getTime()-birthdate.getTime())/ScreenHelper.getTimeDay());
    	}
    	catch(Exception e){
    		return -1;
    	}
    }
    
    public static int getYearsBetween(java.util.Date begin,java.util.Date end){
        int age = -1;

        if(begin!=null && end!=null){

        	try{
        		GregorianCalendar start = new GregorianCalendar();
        		start.setTime(begin);
                GregorianCalendar stop = new GregorianCalendar();
                stop.setTime(end);

                //*** check wether the birthday in the current year is passed ***
                // check month
                if(stop.get(Calendar.MONTH) < start.get(Calendar.MONTH)){
                    // dob not passed
                    age = stop.get(Calendar.YEAR) - start.get(Calendar.YEAR) - 1;
                }
                else if(stop.get(Calendar.MONTH) > start.get(Calendar.MONTH)){
                    // dob passed
                    age = stop.get(Calendar.YEAR) - start.get(Calendar.YEAR);
                }
                else if(stop.get(Calendar.MONTH) == start.get(Calendar.MONTH)){
                    // check day
                    if(stop.get(Calendar.DAY_OF_MONTH) < start.get(Calendar.DAY_OF_MONTH)){
                        // dob not passed
                        age = stop.get(Calendar.YEAR) - start.get(Calendar.YEAR) - 1;
                    }
                    else if(stop.get(Calendar.DAY_OF_MONTH) >= start.get(Calendar.DAY_OF_MONTH)){
                        // dob passed
                        age = stop.get(Calendar.YEAR) - start.get(Calendar.YEAR);
                    }
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return age;
    }
    public int getAgeOnDate(java.util.Date date) {
    	int age=0;
    	try {
    		java.util.Date dob = ScreenHelper.parseDate(this.dateOfBirth);
    		age=new Double((date.getTime()-dob.getTime())/ScreenHelper.getTimeYear()).intValue();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return age;
    }
    public static int getAgeOnDate(java.util.Date dob, java.util.Date date) {
    	int age=0;
    	try {
    		age=new Double((date.getTime()-dob.getTime())/ScreenHelper.getTimeYear()).intValue();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return age;
    }
    public int getAgeInMonthsOnDate(java.util.Date date) {
    	int age=0;
    	try {
    		java.util.Date dob = ScreenHelper.parseDate(this.dateOfBirth);
    		age=new Double((date.getTime()-dob.getTime())/(ScreenHelper.getTimeDay()*30.42)).intValue();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return age;
    }
    public int getAgeInDaysOnDate(java.util.Date date) {
    	int age=0;
    	try {
    		java.util.Date dob = ScreenHelper.parseDate(this.dateOfBirth);
    		age=new Double((date.getTime()-dob.getTime())/ScreenHelper.getTimeDay()).intValue();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return age;
    }
    //--- GET AGE ------------------------------------------------------------------------------------
    public int getAge(){
        int age = -1;

        if(this.dateOfBirth.length() > 0){
            try{
                java.util.Date dob = ScreenHelper.parseDate(this.dateOfBirth);
                Calendar dateOfBirth = Calendar.getInstance();
                dateOfBirth.setTime(dob);

                Calendar now = Calendar.getInstance();

                //*** check wether the birthday in the current year is passed ***
                // check month
                if(now.get(Calendar.MONTH) < dateOfBirth.get(Calendar.MONTH)){
                    // dob not passed
                    age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR) - 1;
                }
                else if(now.get(Calendar.MONTH) > dateOfBirth.get(Calendar.MONTH)){
                    // dob passed
                    age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
                }
                else if(now.get(Calendar.MONTH) == dateOfBirth.get(Calendar.MONTH)){
                    // check day
                    if(now.get(Calendar.DAY_OF_MONTH) < dateOfBirth.get(Calendar.DAY_OF_MONTH)){
                        // dob not passed
                        age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR) - 1;
                    }
                    else if(now.get(Calendar.DAY_OF_MONTH) >= dateOfBirth.get(Calendar.DAY_OF_MONTH)){
                        // dob passed
                        age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
                    }
                }
            }
            catch(Exception e){
                Debug.printStackTrace(e);
            }
        }

        return age;
    }

    public static int getAge(java.util.Date db){
        int age = -1;
        try{
            Calendar dateOfBirth = Calendar.getInstance();
            dateOfBirth.setTime(db);

            Calendar now = Calendar.getInstance();

            //*** check wether the birthday in the current year is passed ***
            // check month
            if(now.get(Calendar.MONTH) < dateOfBirth.get(Calendar.MONTH)){
                // dob not passed
                age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR) - 1;
            }
            else if(now.get(Calendar.MONTH) > dateOfBirth.get(Calendar.MONTH)){
                // dob passed
                age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
            }
            else if(now.get(Calendar.MONTH) == dateOfBirth.get(Calendar.MONTH)){
                // check day
                if(now.get(Calendar.DAY_OF_MONTH) < dateOfBirth.get(Calendar.DAY_OF_MONTH)){
                    // dob not passed
                    age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR) - 1;
                }
                else if(now.get(Calendar.DAY_OF_MONTH) >= dateOfBirth.get(Calendar.DAY_OF_MONTH)){
                    // dob passed
                    age = now.get(Calendar.YEAR) - dateOfBirth.get(Calendar.YEAR);
                }
            }
        }
        catch(Exception e){
            Debug.printStackTrace(e);
        }
        return age;
    }

    public static Vector getUpdateTimes(java.sql.Date dBegin, java.sql.Date dEnd, int iUserid){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Vector vUpdateTimes = new Vector();

        String sSelect = "Select updatetime FROM Admin WHERE updatetime BETWEEN ? AND ? AND updateuserid = ? ";

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setDate(1, dBegin);
            ps.setDate(2, dEnd);
            ps.setInt(3, iUserid);

            rs = ps.executeQuery();
            while(rs.next()){
                vUpdateTimes.addElement(rs.getDate("updatetime"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vUpdateTimes;
    }

    public static String getEnclosedFileId(String id){
        PreparedStatement ps =null;
        ResultSet rs = null;

        String sSelect = " SELECT a.immatnew FROM Admin a, AdminExtends e"+
                         " WHERE a.personid = e.personid"+
                         "  AND e.labelid = 'includedin'"+
                         "  AND e.extendvalue = ?";

        String sReturn = "";

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,id);
            rs = ps.executeQuery();

            if(rs.next()){
                sReturn = ScreenHelper.checkString(rs.getString("immatnew"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sReturn;
    }

    public static String getPersonIdByImmatnew(String sImmatnew){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE immatnew = ?";

        String sPersonid = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,sImmatnew);
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonid = ScreenHelper.checkString(rs.getString("personid"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonid;
    }

    public static String getPersonIdByCandidate(String s){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE candidate = ?";

        String sPersonid = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,s);
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonid = ScreenHelper.checkString(rs.getString("personid"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonid;
    }

    public static String getPersonIdByNatReg(String sNatReg){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE natreg = ?";

        String sPersonid = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,sNatReg);
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonid = ScreenHelper.checkString(rs.getString("personid"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonid;
    }

    public static String getUniquePersonIdByNatReg(String sNatReg){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE natreg = ?";

        String sPersonid = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,sNatReg);
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonid = ScreenHelper.checkString(rs.getString("personid"));
                if(rs.next()) {
                	sPersonid=null;
                }
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonid;
    }

    /*
        Query customized for patientEditSavePopup.jsp
     */
    public static String getPersonIdBySearchNameDateofBirth(Hashtable hSelect){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE ";

        Enumeration enum2 = hSelect.keys();
        while (enum2.hasMoreElements()) {
            sSelect += (String) enum2.nextElement();
        }

        // remove AND
        sSelect = sSelect.substring(0, sSelect.length() - 4);

        String sPersonId = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            int iIndex = 1;
            String sKey, sValue;

            // set values
            enum2 = hSelect.keys();
            while (enum2.hasMoreElements()) {
                sKey = (String) enum2.nextElement();
                sValue = (String) hSelect.get(sKey);

                if (sKey.equalsIgnoreCase(" dateofbirth = ? AND")) {
                    ps.setDate(iIndex, new java.sql.Date(ScreenHelper.parseDate(sValue).getTime()));
                } else {
                    ps.setString(iIndex, sValue);
                }

                iIndex++;
            }

            // execute query
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonId = ScreenHelper.checkString(rs.getString("personid"));
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonId;
    }

    public static String getUniquePersonIdBySearchNameDateofBirth(Hashtable hSelect){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT personid FROM Admin WHERE ";

        Enumeration enum2 = hSelect.keys();
        while (enum2.hasMoreElements()) {
            sSelect += (String) enum2.nextElement();
        }

        // remove AND
        sSelect = sSelect.substring(0, sSelect.length() - 4);

        String sPersonId = null;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            int iIndex = 1;
            String sKey, sValue;

            // set values
            enum2 = hSelect.keys();
            while (enum2.hasMoreElements()) {
                sKey = (String) enum2.nextElement();
                sValue = (String) hSelect.get(sKey);

                if (sKey.equalsIgnoreCase(" dateofbirth = ? AND")) {
                    ps.setDate(iIndex, new java.sql.Date(ScreenHelper.parseDate(sValue).getTime()));
                } else {
                    ps.setString(iIndex, sValue);
                }

                iIndex++;
            }

            // execute query
            rs = ps.executeQuery();

            if(rs.next()){
                sPersonId = ScreenHelper.checkString(rs.getString("personid"));
                if(rs.next()) {
                	sPersonId=null;
                }
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return sPersonId;
    }

    public static Vector getImmatNewPersonIdByImmatNew(String sImmatNew){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT immatnew, personid FROM Admin WHERE immatnew = ?";

        Hashtable hData = new Hashtable();
        Vector vData = new Vector();
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,sImmatNew);
            rs = ps.executeQuery();

            while(rs.next()){
                hData = new Hashtable();
                hData.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));
                hData.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                vData.addElement(hData);
            }

            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vData;
    }

    public static Vector getImmatNewPersonIdByNatReg(String sNatReg){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT immatnew, personid FROM Admin WHERE natreg = ?";

        Hashtable hData = new Hashtable();
        Vector vData = new Vector();
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,sNatReg);
            rs = ps.executeQuery();

            while(rs.next()){
                hData = new Hashtable();
                hData.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));
                hData.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                vData.addElement(hData);
            }

            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vData;
    }

    public java.util.Date isDead(){
    	java.util.Date death=null;
    	PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT * from oc_encounters where oc_encounter_patientuid=? and oc_encounter_outcome like 'dead%' order by oc_encounter_enddate desc";

    	Connection ad_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setString(1,this.personid);
            rs = ps.executeQuery();

            if(rs.next()){
            	death=rs.getDate("oc_encounter_enddate");
            }

            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return death;
    }

    /*
        Query customized for patientEditSavePopup.jsp
     */
    public static Vector getImmatNewPersonIdBySearchNameDateofBirth(Hashtable hSelect){
        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT immatnew,personid FROM Admin WHERE ";

        Enumeration enum2 = hSelect.keys();
        while (enum2.hasMoreElements()) {
            sSelect += (String) enum2.nextElement();
        }

        // remove AND
        sSelect = sSelect.substring(0, sSelect.length() - 4);

        Vector vData = new Vector();

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            int iIndex = 1;
            String sKey, sValue;

            // set values
            enum2 = hSelect.keys();
            while (enum2.hasMoreElements()) {
                sKey = (String) enum2.nextElement();
                sValue = (String) hSelect.get(sKey);

                if (sKey.equalsIgnoreCase(" dateofbirth = ? AND")) {
                    ps.setDate(iIndex, new java.sql.Date(ScreenHelper.parseDate(sValue).getTime()));
                } else {
                    ps.setString(iIndex, sValue);
                }

                iIndex++;
            }

            // execute query
            rs = ps.executeQuery();
            Hashtable hData;
            if(rs.next()){
                hData = new Hashtable();
                hData.put("immatnew",ScreenHelper.checkString(rs.getString("immatnew")));
                hData.put("personid",ScreenHelper.checkString(rs.getString("personid")));
                vData.addElement(hData);
            }
            rs.close();
            ps.close();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                ad_conn.close();
            }catch(Exception e){
                e.printStackTrace();
            }
        }
        return vData;
    }

    public boolean saveMiniToDB(){
    	boolean bReturn=false;
    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
    	bReturn=saveMiniToDB(conn);
    	ScreenHelper.closeQuietly(conn, null, null);
    	return bReturn;
    }
    
    public boolean saveMiniToDB(Connection connection) {
        boolean bReturn = true;
        String sSelect = "";

        try {
            PreparedStatement ps;
            String sPersonID = "", sSearchname, sLastname, sFirstname;

            sLastname = ScreenHelper.checkSpecialCharacters(lastname);
            sFirstname = ScreenHelper.checkSpecialCharacters(firstname);
            sSearchname = sLastname.toUpperCase().trim()+","+sFirstname.toUpperCase().trim();
            sSearchname = ScreenHelper.normalizeSpecialCharacters(sSearchname);

            sPersonID = MedwanQuery.getInstance().getOpenclinicCounter("PersonID")+"";

            if (sPersonID.trim().length()>0) {
                this.personid = sPersonID;
                sSelect = " INSERT INTO Admin (personid, lastname, firstname, gender, dateofbirth, searchname, updatetime, updateuserid, updateserverid) VALUES (?,?,?,?,?,?,?,?,?) ";
                ps = connection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(sPersonID));
                ps.setString(2,this.lastname);
                ps.setString(3,this.firstname);
                ps.setString(4,this.gender);
                ps.setString(5,this.dateOfBirth);
                ps.setString(6,sSearchname);
                ps.setTimestamp(7,new java.sql.Timestamp(new java.util.Date().getTime()));
                ps.setInt(8,Integer.parseInt(this.updateuserid));
                ps.setInt(9,MedwanQuery.getInstance().getConfigInt("serverId"));
                ps.executeUpdate();
                if (ps!=null)ps.close();
            }
        }
        catch(Exception e) {
        	Debug.printStackTrace(e);
            bReturn = false;
        }

        return bReturn;
    }

    public boolean store(){
        boolean bResult=false;
    	try {
        	Connection connection=MedwanQuery.getInstance().getAdminConnection();
            bResult=saveToDB(connection);
    		connection.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return bResult;
    }
    
    public static AdminPerson fromFIHRPatient(Patient patient) {
    	AdminPerson person = new AdminPerson();
    	if(MedwanQuery.getInstance().getConfigInt("isMPIServer",0)==1) {
    		if(patient.getId()!=null && !patient.getId().isEmpty()) {
    			person.personid=ScreenHelper.convertFromUUID(patient.getId().toString().replaceAll("Patient/", ""))+"";
    		}
    	}
    	else {
	    	if(patient.getId()!=null && !patient.getId().isEmpty()) {
	    		person.adminextends.put("mpiid", patient.getIdElement().getIdPart());
	    	}
    	}
	    List<Identifier> identifiers = patient.getIdentifier();
	    boolean bLabelsUpdated=false;
	    if(patient.getIdentifier()!=null && !patient.getIdentifier().isEmpty()) {
		    Iterator<Identifier> iIdentifiers = identifiers.iterator();
		    while(iIdentifiers.hasNext()) {
		    	Identifier identifier = iIdentifiers.next();
		    	if(identifier.getUse().equals(IdentifierUse.SECONDARY)) {
		    		if(identifier.getSystem().equalsIgnoreCase("mpimatch")) {
			    		person.adminextends.put(identifier.getSystem(), identifier.getValue());
		    		}
		    		else {
			    		person.adminextends.put("facilityid$"+identifier.getSystem(), identifier.getValue());
			    		if(identifier.getExtension()!=null && !identifier.getExtension().isEmpty()) {
			    			String[] supportedLanguages = MedwanQuery.getInstance().getConfigString("supportedLanguages","en").split(",");
			    			for(int n=0;n<supportedLanguages.length;n++) {
			    				if(Label.get("mpi.facility", identifier.getSystem(), supportedLanguages[n])==null && identifier.getExtensionByUrl(supportedLanguages[n])!=null) {
			    					Label label = new Label("mpi.facility",identifier.getSystem(),supportedLanguages[n],identifier.getExtensionByUrl(supportedLanguages[n]).getValue().toString(),"1","4");
			    					label.saveToDB();
			    					bLabelsUpdated=true;
			    				}
			    			}
			    		}
		    		}
		    	}
		    	else if(identifier.getUse().equals(IdentifierUse.OFFICIAL)) {
		    		person.setID("natreg", identifier.getValue());
		    	}
		    }
	    }
	    if(bLabelsUpdated) {
	    	UpdateSystem.reloadSingletonNoSession();
	    }
	    if(patient.getGender()!=null && patient.getGender().equals(Enumerations.AdministrativeGender.MALE)) {
	    	person.gender="m";
	    }
	    else if(patient.getGender()!=null && patient.getGender().equals(Enumerations.AdministrativeGender.FEMALE)) {
	    	person.gender="f";
	    }
	    person.dateOfBirth=ScreenHelper.formatDate(patient.getBirthDate());
	    person.language=patient.getLanguage();
	    person.lastname=patient.getName()!=null && !patient.getName().isEmpty()?patient.getName().get(0).getFamily():"";
	    person.firstname="";
	    if(patient.getName()!=null && !patient.getName().isEmpty() && patient.getName().get(0).getGiven()!=null) {
		    List<StringType> firstnames = patient.getName().get(0).getGiven();
		    Iterator<StringType> iFirstnames = firstnames.iterator();
		    while(iFirstnames.hasNext()) {
		    	person.firstname+=iFirstnames.next().getValue()+" ";
		    }
		    person.firstname=person.firstname.trim();
	    }
	    AdminPrivateContact apc = new AdminPrivateContact();
	    if(patient.getAddressFirstRep()!=null && !patient.getAddressFirstRep().isEmpty()) {
	    	Address address = patient.getAddressFirstRep();
	    	apc.address=address.getLine()!=null && !address.getLine().isEmpty() && address.getLine().get(0)!=null?address.getLine().get(0).getValue():"";
	    	apc.country=address.getCountry();
	    	apc.city=address.getCity();
	    	apc.district=address.getDistrict();
	    	apc.zipcode=address.getPostalCode();
	    }
	    if(patient.getTelecom()!=null && !patient.getTelecom().isEmpty()) {
	    	List<ContactPoint> telecom = patient.getTelecom();
	    	Iterator<ContactPoint> iTelecoms = telecom.iterator();
	    	while(iTelecoms.hasNext()) {
	    		ContactPoint cp = iTelecoms.next();
	    		if(cp.getSystem().equals(ContactPoint.ContactPointSystem.PHONE)) {
	    			apc.telephone=cp.getValue();
	    		}
	    		else if(cp.getSystem().equals(ContactPoint.ContactPointSystem.SMS)) {
	    			apc.mobile=cp.getValue();
	    		}
	    		else if(cp.getSystem().equals(ContactPoint.ContactPointSystem.EMAIL)) {
	    			apc.email=cp.getValue();
	    		}
	    	}
	    }
    	person.privateContacts.add(apc);
    	if(patient.getPhoto()!=null && !patient.getPhoto().isEmpty()) {
    		person.picture=patient.getPhotoFirstRep().getData();
    	}
    	
    	return person;
    }
    
    public Patient getFHIRPatient() {
    	Patient patient = new Patient();
    	if(MedwanQuery.getInstance().getConfigInt("isMPIServer",0)==1) {
    		patient.setId(ScreenHelper.convertToUUID(personid));
    		//Add all secondary id's
    		Vector<String> pointers = Pointer.getPointersLike("facilityid$"+personid+"$");
    		for(int n=0;n<pointers.size();n++) {
    			String key = pointers.elementAt(n).split(";")[0].replaceAll("facilityid\\$"+personid+"\\$", "");
    			String value = pointers.elementAt(n).split(";")[1];
    			Identifier identifier = new Identifier().setUse(IdentifierUse.SECONDARY).setSystem(key).setValue(value);
    			Label l = Label.get("mpi.facility", key, "en");
    			if(l!=null) {
    				identifier.addExtension().setUrl("en").setValue(new StringType(l.value));
    			}
    			l = Label.get("mpi.facility", key, "fr");
    			if(l!=null) {
    				identifier.addExtension().setUrl("fr").setValue(new StringType(l.value));
    			}
    			l = Label.get("mpi.facility", key, "nl");
    			if(l!=null) {
    				identifier.addExtension().setUrl("nl").setValue(new StringType(l.value));
    			}
    			l = Label.get("mpi.facility", key, "pt");
    			if(l!=null) {
    				identifier.addExtension().setUrl("pt").setValue(new StringType(l.value));
    			}
    			l = Label.get("mpi.facility", key, "es");
    			if(l!=null) {
    				identifier.addExtension().setUrl("es").setValue(new StringType(l.value));
    			}
    			patient.addIdentifier(identifier);
    		}
    	} 
    	else {
    		String id = ScreenHelper.checkString((String)adminextends.get("mpiid"));
    		if(id.length()==0) {
    			id=personid;
    		}
    		patient.setId(id);
    	    patient.addIdentifier().setUse(IdentifierUse.SECONDARY).setSystem(MedwanQuery.getInstance().getConfigString("hin.server.identifier","hin.facility.undefined")).setValue(personid);
    	}
    	if(getID("natreg").length()>0) {
    		patient.addIdentifier().setUse(IdentifierUse.OFFICIAL).setSystem("mpi.national.id").setValue(getID("natreg"));
    	}
    	patient.setGender(ScreenHelper.checkString(gender).equalsIgnoreCase("m")?Enumerations.AdministrativeGender.MALE:ScreenHelper.checkString(gender).equalsIgnoreCase("f")?Enumerations.AdministrativeGender.FEMALE:Enumerations.AdministrativeGender.UNKNOWN);
    	patient.setBirthDate(ScreenHelper.parseDate(dateOfBirth));
    	patient.setDeceased(isDead()==null?new BooleanType(false):new DateTimeType(isDead()));
    	patient.setLanguage(ScreenHelper.checkString(language).toUpperCase());
    	HumanName theName = new HumanName();
    	theName.setFamily(lastname.toUpperCase());
    	theName.addGiven(firstname.toUpperCase());
    	patient.setName(Collections.singletonList(theName));
    	if(adminextends.get("mpimatch")!=null) {
    	    patient.addIdentifier().setUse(IdentifierUse.SECONDARY).setSystem("mpimatch").setValue((String)adminextends.get("mpimatch"));
    	}
    	AdminPrivateContact apc = getActivePrivate();
    	if(apc!=null) {
	    	Address address = new Address();
	    	address.setCountry(apc.country);
	    	address.setCity(apc.city);
	    	address.setDistrict(apc.district);
	    	address.setPostalCode(apc.zipcode);
	    	address.setType(Address.AddressType.BOTH);
	    	address.setUse(Address.AddressUse.HOME);
	    	address.addLine(apc.address);
	    	List<Address> theAddress = Collections.singletonList(address);
	    	patient.setAddress(theAddress);
	    	
	    	List<ContactPoint> theTelecom = new Vector<ContactPoint>();
	    	ContactPoint f_phone = new ContactPoint();
	    	f_phone.setSystem(ContactPoint.ContactPointSystem.PHONE);
	    	f_phone.setValue(apc.telephone);
	    	theTelecom.add(f_phone);
	    	ContactPoint f_mobile = new ContactPoint();
	    	f_mobile.setSystem(ContactPoint.ContactPointSystem.SMS);
	    	f_mobile.setValue(apc.mobile);
	    	theTelecom.add(f_mobile);
	    	ContactPoint f_email = new ContactPoint();
	    	f_email.setSystem(ContactPoint.ContactPointSystem.EMAIL);
	    	f_email.setValue(apc.email);
	    	theTelecom.add(f_email);
	    	patient.setTelecom(theTelecom);
    	}
    	//if a picture exists, we can also add it
    	if(Picture.exists(Integer.parseInt(personid))) {
	    	Attachment photo = new Attachment();
	    	photo.setContentType("image/jpeg");
	    	photo.setData(new Picture(Integer.parseInt(personid)).getPicture());
	    	patient.addPhoto(photo);
    	}
    	if(Debug.enabled) {
    		Debug.println(MedwanQuery.getInstance().getFhirContext().newXmlParser().encodeResourceToString(patient));
    	}
    	return patient;
    }

}

