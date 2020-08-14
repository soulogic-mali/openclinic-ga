package be.presis;

import org.dom4j.Element;

public class HealthFacility {
	private IdList ids = new IdList();
	private IdList categories = new IdList();
	private IdList agreements = new IdList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<healthfacility>");
		sb.append(ids.toXml());
		sb.append("<categories>"+categories.toXml()+"</categories>");
		sb.append("<agreements>"+agreements.toXml()+"</agreements>");
		sb.append("</healthfacility>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eHealthfacility = e.addElement("healthfacility");
		ids.toXml(eHealthfacility);
		Element eCategories = eHealthfacility.addElement("categories");
		categories.toXml(eCategories);
		Element eAgreements = eHealthfacility.addElement("agreements");
		agreements.toXml(eAgreements);
	}
	public static HealthFacility fromXml(Element e) {
		HealthFacility healthFacility = new HealthFacility();
		if(e!=null) {
			healthFacility.setIds(IdList.fromXml(e.element("ids")));
			if(e.element("categories")!=null) {
				healthFacility.setCategories(IdList.fromXml(e.element("categories").element("ids")));
			}
			if(e.element("agreements")!=null) {
				healthFacility.setAgreements(IdList.fromXml(e.element("agreements").element("ids")));
			}
		}
		return healthFacility;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getCategories() {
		return categories;
	}
	public void setCategories(IdList categories) {
		this.categories = categories;
	}
	public IdList getAgreements() {
		return agreements;
	}
	public void setAgreements(IdList agreements) {
		this.agreements = agreements;
	}
}
