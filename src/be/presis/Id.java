package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class Id {
	private String nameSpace;
	private String type;
	private String value;
	
	public String toXml() {
		return "<id namespace='"+getNameSpace()+"' type='"+getType()+"'>"+getValue()+"</id>";
	}
	public static Id fromXml(Element e) {
		if(e==null) {
			return new Id();
		}
		return new Id(SH.c(e.attributeValue("namespace")),SH.c(e.attributeValue("type")),SH.c(e.getText()));
	}
	public void toXml(Element e) {
		Element eId=e.addElement("id");
		eId.addAttribute("namespace", SH.c(getNameSpace()));
		eId.addAttribute("type", SH.c(getType()));
		eId.setText(SH.c(getValue()));
	}
	public String getNameSpace() {
		return nameSpace;
	}
	public void setNameSpace(String nameSpace) {
		this.nameSpace = nameSpace;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
	public String getFullId() {
		return nameSpace+"."+type+"."+value;
	}
	
	public Id(String nameSpace, String type, String value) {
		super();
		this.nameSpace = nameSpace;
		this.type = type;
		this.value = value;
	}
	
	public Id() {
		super();
	}
	
	public boolean equals(Id id) {
		return this.nameSpace.equalsIgnoreCase(id.getNameSpace()) && this.type.equalsIgnoreCase(id.type) && this.value.equalsIgnoreCase(id.value);
	}
	
	public boolean equivalent(Id id) {
		return this.nameSpace.equalsIgnoreCase(id.getNameSpace()) && this.type.equalsIgnoreCase(id.type);
	}
}
