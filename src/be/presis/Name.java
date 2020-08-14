package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class Name {
	private String type;
	private String name;
	
	public String toXml() {
		return "<name type='"+type+"'>"+name+"</name>";
	}
	public void toXml(Element e) {
		Element eName = e.addElement("name");
		eName.addAttribute("type", SH.c(type));
		eName.addCDATA(SH.c(name));
	}
	public String toXml(String tagName) {
		return "<"+tagName+" type='"+type+"'>"+name+"</"+tagName+">";
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean equivalent(Name name) {
		return this.type.equalsIgnoreCase(name.getType());
	}
	public boolean equivalent(String type) {
		return this.type.equalsIgnoreCase(type);
	}
	public boolean equals(Name name) {
		return this.type.equalsIgnoreCase(name.getType()) && this.name.equalsIgnoreCase(name.getName());
	}
	public Name(String type, String name) {
		super();
		this.type = type;
		this.name = name;
	}
}
