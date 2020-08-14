package be.presis;

import org.dom4j.Element;

public class PersonName {
	private NameList firstnames = new NameList();
	private NameList lastnames = new NameList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<names>");
		sb.append("<firstnames>"+firstnames.toXml()+"</firstnames>");
		sb.append("<lastnames>"+lastnames.toXml()+"</lastnames>");
		sb.append("</names>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eNames = e.addElement("names");
		Element eFirstnames = eNames.addElement("firstnames");
		firstnames.toXml(eFirstnames);
		Element eLastnames = eNames.addElement("lastnames");
		lastnames.toXml(eLastnames);
	}
	public static PersonName fromXml(Element e) {
		PersonName personName = new PersonName();
		personName.setFirstnames(NameList.fromXml(e.element("firstnames")));
		personName.setLastnames(NameList.fromXml(e.element("lastnames")));
		return personName;
	}
	public NameList getFirstnames() {
		return firstnames;
	}
	public void setFirstnames(NameList firstnames) {
		this.firstnames = firstnames;
	}
	public NameList getLastnames() {
		return lastnames;
	}
	public void setLastnames(NameList lastnames) {
		this.lastnames = lastnames;
	}
	public void setFirstName(String type,String value) {
		firstnames.setName(type,value);
	}
	
	public void setFirstName(Name firstname) {
		firstnames.setName(firstname);
	}
	
	public void setLastName(String type,String value) {
		lastnames.setName(type,value);
	}
	
	public void setLastName(Name lastname) {
		firstnames.setName(lastname);
	}
	
	public String getFirstname(String type) {
		return firstnames.getName(type);
	}
	
	public String getLastname(String type) {
		return lastnames.getName(type);
	}
	
	public String getFirstNames() {
		return firstnames.getFullName();
	}
	
	public String getLastNames() {
		return lastnames.getFullName();
	}
	
	public String getFullName() {
		return getLastNames().toUpperCase()+", "+getFirstNames();
	}
}
