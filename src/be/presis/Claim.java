package be.presis;

import java.io.File;
import java.io.FileOutputStream;
import java.io.StringWriter;
import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import be.openclinic.system.SH;

public class Claim {
	private String version = "0.1";
	private IdList ids = new IdList();
	private HealthFacility healthFacility=new HealthFacility();
	private IdList replacements = new IdList();
	private InsuredPerson insuredPerson = new InsuredPerson();
	private Encounter encounter=new Encounter();
	private String comment;
	private Vector<HealthService> healthServices = new Vector<HealthService>();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<claim version='"+SH.c(version)+"'>");
		sb.append(ids.toXml());
		sb.append(healthFacility.toXml());
		sb.append("<replacements>"+replacements.toXml()+"</replacements>");
		sb.append(insuredPerson.toXml());
		sb.append(encounter.toXml());
		sb.append("<comment>"+SH.c(comment)+"</comment>");
		sb.append("<healthservices>");
		for(int n=0;n<healthServices.size();n++) {
			HealthService healthService = healthServices.elementAt(n);
			sb.append(healthService.toXml());
		}
		sb.append("</healthservices>");
		sb.append("</claim>");
		return sb.toString();
	}
	public Document toXmlDocument() {
		Document document = DocumentHelper.createDocument();
		Element eClaim = document.addElement("claim");
		eClaim.addAttribute("version", SH.c(version));
		ids.toXml(eClaim);
		healthFacility.toXml(eClaim);
		replacements.toXml(eClaim.addElement("replacements"));
		insuredPerson.toXml(eClaim);
		encounter.toXml(eClaim);
		eClaim.addElement("comment").addCDATA(comment==null?"":SH.c(comment));
		Element eHealthServices = eClaim.addElement("healthservices");
		for(int n=0;n<healthServices.size();n++) {
			HealthService healthService = healthServices.elementAt(n);
			healthService.toXml(eHealthServices);
		}
		return document;
	}
	public static Claim fromXmlDocument(Document document) {
		Claim claim = new Claim();
		Element eClaim = document.getRootElement();
		claim.setVersion(SH.c(eClaim.attributeValue("version")));
		claim.setIds(IdList.fromXml(eClaim.element("ids")));
		claim.setHealthFacility(HealthFacility.fromXml(eClaim.element("healthfacility")));
		if(eClaim.element("replacements")!=null) {
			claim.setReplacements(IdList.fromXml(eClaim.element("replacements").element("ids")));
		}
		claim.setInsuredPerson(InsuredPerson.fromXml(eClaim.element("insuredperson")));
		claim.setEncounter(Encounter.fromXml(eClaim.element("encounter")));
		claim.setComment(SH.c(eClaim.elementText("comment")));
		if(eClaim.element("healthservices")!=null) {
			Iterator<Element> i = eClaim.element("healthservices").elementIterator("item");
			while(i.hasNext()) {
				claim.healthServices.add(HealthService.fromXml(i.next()));
			}
		}
		return claim;
	}
	
	public String toXmlPrettyPrint() {
		Document document = toXmlDocument();

	    OutputFormat format = OutputFormat.createPrettyPrint();
	    format.setEncoding("UTF-8");
	    StringWriter writer = new StringWriter();
	    XMLWriter xmlWriter = new XMLWriter(writer, format);
	    try {
	        xmlWriter.write(document);
	        xmlWriter.close();
	    } catch (Exception e) {
	        throw new RuntimeException("XML Error");
	    }
	    return writer.toString();
	}

	public void toXmlPrettyPrintFile(String sPath) {
		Document document = toXmlDocument();

	    OutputFormat format = OutputFormat.createPrettyPrint();
	    format.setEncoding("UTF-8");
	    try {
			XMLWriter xmlWriter = new XMLWriter(new FileOutputStream(new File(sPath)), format);
	        xmlWriter.write(document);
	        xmlWriter.close();
	    } catch (Exception e) {
	        throw new RuntimeException("XML Error");
	    }
	}

	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public HealthFacility getHealthFacility() {
		return healthFacility;
	}
	public void setHealthFacility(HealthFacility healthFacility) {
		this.healthFacility = healthFacility;
	}
	public IdList getReplacements() {
		return replacements;
	}
	public void setReplacements(IdList replacements) {
		this.replacements = replacements;
	}
	public InsuredPerson getInsuredPerson() {
		return insuredPerson;
	}
	public void setInsuredPerson(InsuredPerson insuredPerson) {
		this.insuredPerson = insuredPerson;
	}
	public Encounter getEncounter() {
		return encounter;
	}
	public void setEncounter(Encounter encounter) {
		this.encounter = encounter;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public Vector<HealthService> getHealthServices() {
		return healthServices;
	}
	public void setHealthServices(Vector<HealthService> healthServices) {
		this.healthServices = healthServices;
	}
}
