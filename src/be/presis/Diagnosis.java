package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class Diagnosis {
	private String classification;
	private String code;
	private String type;
	private boolean presentOnAdmission;
	private boolean newCase;
	private String certainty;
	
	public String toXml() {
		return "<diagnosis classification='"+SH.c(classification)+"' type='"+SH.c(type)+"' poa='"+(presentOnAdmission?"1":"0")+"' newcase='"+(newCase?"1":"0")+"' certainty='"+SH.c(certainty)+"'>"+SH.c(code)+"</diagnosis>";
	}
	public void toXml(Element e) {
		Element eDiagnosis = e.addElement("diagnosis");
		eDiagnosis.addAttribute("classification", SH.c(classification));
		eDiagnosis.addAttribute("type", SH.c(type));
		eDiagnosis.addAttribute("poa", presentOnAdmission?"1":"0");
		eDiagnosis.addAttribute("newcase", newCase?"1":"0");
		eDiagnosis.addAttribute("certainty", SH.c(certainty));
		eDiagnosis.setText(code);
	}
	public static Diagnosis fromXml(Element e) {
		Diagnosis diagnosis = new Diagnosis();
		if(e!=null) {
			diagnosis.setClassification(SH.c(e.attributeValue("classification")));
			diagnosis.setType(SH.c(e.attributeValue("type")));
			diagnosis.setPresentOnAdmission(SH.c(e.attributeValue("poa")).equalsIgnoreCase("1"));
			diagnosis.setNewCase(SH.c(e.attributeValue("newcase")).equalsIgnoreCase("1"));
			diagnosis.setCertainty(SH.c(e.attributeValue("certainty")));
			diagnosis.setCode(SH.c(e.getText()));
		}
		return diagnosis;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getClassification() {
		return classification;
	}
	public void setClassification(String classification) {
		this.classification = classification;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public boolean isPresentOnAdmission() {
		return presentOnAdmission;
	}
	public void setPresentOnAdmission(boolean presentOnAdmission) {
		this.presentOnAdmission = presentOnAdmission;
	}
	public boolean isNewCase() {
		return newCase;
	}
	public void setNewCase(boolean newCase) {
		this.newCase = newCase;
	}
	public String getCertainty() {
		return certainty;
	}
	public void setCertainty(String certainty) {
		this.certainty = certainty;
	}
	
	public Diagnosis(String classification, String code, String type, boolean presentOnAdmission, boolean newCase, String certainty) {
		super();
		this.classification = classification;
		this.code = code;
		this.type = type;
		this.presentOnAdmission = presentOnAdmission;
		this.newCase = newCase;
		this.certainty = certainty;
	}
	
	public Diagnosis(String classification, String code) {
		super();
		this.classification = classification;
		this.code = code;
	}
	
	public Diagnosis() {
		super();
	}
}
