package be.presis;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class InsuredPerson {
	private IdList ids = new IdList();
	private IdList insurers = new IdList();
	private PersonName name=new PersonName();
	private Date dateOfBirth;
	private Date dateOfDeath;
	private String gender;
	private Address address = new Address();
	private PersonEducation education = new PersonEducation();
	private IdList coveragePlans = new IdList();
	private IdList populationGroups = new IdList();
	private Vector<CoverageAuthorization> authorizations = new Vector<CoverageAuthorization>();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<insuredperson>");
		sb.append(ids.toXml());
		sb.append("<insurers>"+insurers.toXml()+"</insurers>");
		sb.append(name.toXml());
		sb.append("<dateofbirth>"+(dateOfBirth==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(dateOfBirth))+"</dateofbirth>");
		sb.append("<dateofdeath>"+(dateOfDeath==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(dateOfDeath))+"</dateofdeath>");
		sb.append("<gender>"+SH.c(gender)+"</gender>");
		sb.append(address.toXml());
		sb.append(education.toXml());
		sb.append("<coverageplans>"+coveragePlans.toXml()+"</coverageplans>");
		sb.append("<populationgroups>"+populationGroups.toXml()+"</populationgroups>");
		sb.append("<authorizations>");
		for(int n=0;n<authorizations.size();n++) {
			CoverageAuthorization authorization = authorizations.elementAt(n);
			sb.append(authorization.toXml());
		}
		sb.append("</authorizations>");
		sb.append("</insuredperson>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eInsuredPerson = e.addElement("insuredperson");
		ids.toXml(eInsuredPerson);
		Element eInsurers = eInsuredPerson.addElement("insurers");
		insurers.toXml(eInsurers);
		name.toXml(eInsuredPerson);
		eInsuredPerson.addElement("dateofbirth").setText(dateOfBirth==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(dateOfBirth));
		eInsuredPerson.addElement("dateofdeath").setText(dateOfDeath==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(dateOfDeath));
		eInsuredPerson.addElement("gender").setText(SH.c(gender));
		address.toXml(eInsuredPerson);
		education.toXml(eInsuredPerson);
		coveragePlans.toXml(eInsuredPerson);
		populationGroups.toXml(eInsuredPerson);
		Element eAuthorizations = eInsuredPerson.addElement("authorizations");
		for(int n=0;n<authorizations.size();n++) {
			CoverageAuthorization authorization = authorizations.elementAt(n);
			authorization.toXml(eAuthorizations);
		}
	}
	public static InsuredPerson fromXml(Element e) {
		InsuredPerson insuredPerson = new InsuredPerson();
		if(e!=null) {
			insuredPerson.setIds(IdList.fromXml(e.element("ids")));
			if(e.element("insurers")!=null) {
				insuredPerson.setInsurers(IdList.fromXml(e.element("insurers").element("ids")));
			}
			insuredPerson.setName(PersonName.fromXml(e.element("names")));
			try {
				insuredPerson.setDateOfBirth(new SimpleDateFormat("yyyyMMddHHmmss").parse(e.elementText("dateofbirth")));
			} catch(Exception e2) {}
			try {
				insuredPerson.setDateOfDeath(new SimpleDateFormat("yyyyMMddHHmmss").parse(e.elementText("dateofdeath")));
			} catch(Exception e2) {}
			insuredPerson.setGender(SH.c(e.elementText("gender")));
			insuredPerson.setAddress(Address.fromXml(e.element("address")));
			insuredPerson.setCoveragePlans(IdList.fromXml(e.element("coverageplans")));
			insuredPerson.setPopulationGroups(IdList.fromXml(e.element("populationgroups")));
			if(e.element("authorizations")!=null) {
				Iterator<Element> i = e.element("authorizations").elementIterator("authorization");
				while(i.hasNext()) {
					insuredPerson.authorizations.add(CoverageAuthorization.fromXml(i.next()));
				}
			}
		}
		return insuredPerson;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getInsurers() {
		return insurers;
	}
	public void setInsurers(IdList insurers) {
		this.insurers = insurers;
	}
	public PersonName getName() {
		return name;
	}
	public void setName(PersonName name) {
		this.name = name;
	}
	public Date getDateOfBirth() {
		return dateOfBirth;
	}
	public void setDateOfBirth(Date dateOfBirth) {
		this.dateOfBirth = dateOfBirth;
	}
	public Date getDateOfDeath() {
		return dateOfDeath;
	}
	public void setDateOfDeath(Date dateOfDeath) {
		this.dateOfDeath = dateOfDeath;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public Address getAddress() {
		return address;
	}
	public void setAddress(Address address) {
		this.address = address;
	}
	public PersonEducation getEducation() {
		return education;
	}
	public void setEducation(PersonEducation education) {
		this.education = education;
	}
	public IdList getCoveragePlans() {
		return coveragePlans;
	}
	public void setCoveragePlans(IdList coveragePlans) {
		this.coveragePlans = coveragePlans;
	}
	public IdList getPopulationGroups() {
		return populationGroups;
	}
	public void setPopulationGroups(IdList populationGroups) {
		this.populationGroups = populationGroups;
	}
}
