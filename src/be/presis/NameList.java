package be.presis;

import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class NameList {
	private Vector<Name> names = new Vector<Name>();

	public String toXml() {
		StringBuffer sb = new StringBuffer();
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			sb.append(thisName.toXml());
		}
		return sb.toString();
	}
	public void toXml(Element e) {
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			thisName.toXml(e);
		}
	}
	public String toXml(String tagName) {
		StringBuffer sb = new StringBuffer();
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			sb.append(thisName.toXml(tagName));
		}
		return sb.toString();
	}
	public static NameList fromXml(Element e) {
		NameList nameList = new NameList();
		if(e!=null) {
			Iterator<Element> i = e.elementIterator("name");
			while(i.hasNext()) {
				Element eName = i.next();
				nameList.setName(SH.c(eName.attributeValue("type")), SH.c(eName.getText()));
			}
		}
		return nameList;
	}
	public static NameList fromXml(Element e,String tagName) {
		NameList nameList = new NameList();
		if(e!=null) {
			Iterator<Element> i = e.elementIterator(tagName);
			while(i.hasNext()) {
				Element eName = i.next();
				nameList.setName(SH.c(eName.attributeValue("type")), SH.c(eName.getText()));
			}
		}
		return nameList;
	}
	public Vector<Name> getNames() {
		return names;
	}

	public void setNames(Vector<Name> names) {
		this.names = names;
	}
	
	public void setName(Name name) {
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			if(thisName.equivalent(name)) {
				thisName.setName(name.getName());
				return;
			}
		}
		names.add(name);
	}
	
	public void setName(String type, String name) {
		setName(new Name(type,name));
	}
	
	public String getName(String type) {
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			if(thisName.equivalent(type)) {
				return thisName.getName();
			}
		}
		return "";
	}
	
	public String getFullName() {
		String fullname="";
		for(int n=0;n<names.size();n++) {
			Name thisName = names.elementAt(n);
			fullname+=thisName.getName()+" ";
		}
		return fullname.trim();
	}
}
