package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class HealthService {
	private String type;
	private IdList ids = new IdList();
	private IdList performedBy = new IdList();
	private Diagnosis diagnosis=new Diagnosis();
	private DateIdQuantity prescription = new DateIdQuantity();
	private DateIdQuantity delivery=new DateIdQuantity();
	private Cost patientCost=new Cost();
	private Cost insurerCost=new Cost();
	private Cost otherCost=new Cost();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<item type='"+SH.c(type)+"'>");
		sb.append(ids.toXml());
		sb.append("<performedby>"+performedBy.toXml()+"</performedby>");
		sb.append(diagnosis.toXml());
		sb.append("<prescription>"+prescription.toXml()+"</prescription>");
		sb.append("<delivery>"+delivery.toXml()+"</delivery>");
		sb.append("<cost>");
		sb.append("<patient>"+patientCost+"</patient>");
		sb.append("<insurer>"+insurerCost+"</insurer>");
		sb.append("<other>"+otherCost+"</other>");
		sb.append("</cost>");
		sb.append("</item>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eItem = e.addElement("item");
		ids.toXml(eItem);
		performedBy.toXml(eItem.addElement("performedby"));
		diagnosis.toXml(eItem);
		prescription.toXml(eItem.addElement("prescription"));
		delivery.toXml(eItem.addElement("delivery"));
		Element eCost = eItem.addElement("cost");
		eCost.addElement("patient").setText(patientCost+"");
		eCost.addElement("insurer").setText(insurerCost+"");
		eCost.addElement("other").setText(otherCost+"");
	}
	public static HealthService fromXml(Element e) {
		HealthService healthService = new HealthService();
		if(e!=null) {
			healthService.setIds(IdList.fromXml(e.element("ids")));
			if(e.element("performedby")!=null) {
				healthService.setPerformedBy(IdList.fromXml(e.element("performedby").element("ids")));
			}
			healthService.setDiagnosis(Diagnosis.fromXml(e.element("diagnosis")));
			healthService.setPrescription(DateIdQuantity.fromXml(e.element("prescription")));
			healthService.setDelivery(DateIdQuantity.fromXml(e.element("delivery")));
			if(e.element("cost")!=null) {
				healthService.setPatientCost(Cost.fromXml(e.element("cost").element("patient")));
				healthService.setInsurerCost(Cost.fromXml(e.element("cost").element("insurer")));
				healthService.setOtherCost(Cost.fromXml(e.element("cost").element("other")));
			}
		}
		return healthService;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getPerformedBy() {
		return performedBy;
	}
	public void setPerformedBy(IdList performedBy) {
		this.performedBy = performedBy;
	}
	public Diagnosis getDiagnosis() {
		return diagnosis;
	}
	public void setDiagnosis(Diagnosis diagnosis) {
		this.diagnosis = diagnosis;
	}
	public DateIdQuantity getPrescription() {
		return prescription;
	}
	public void setPrescription(DateIdQuantity prescription) {
		this.prescription = prescription;
	}
	public DateIdQuantity getDelivery() {
		return delivery;
	}
	public void setDelivery(DateIdQuantity delivery) {
		this.delivery = delivery;
	}
	public Cost getPatientCost() {
		return patientCost;
	}
	public void setPatientCost(Cost patientCost) {
		this.patientCost = patientCost;
	}
	public Cost getInsurerCost() {
		return insurerCost;
	}
	public void setInsurerCost(Cost insurerCost) {
		this.insurerCost = insurerCost;
	}
	public Cost getOtherCost() {
		return otherCost;
	}
	public void setOtherCost(Cost otherCost) {
		this.otherCost = otherCost;
	}
}
