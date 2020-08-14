package be.presis;

import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Element;

public class IdList {
	private Vector<Id> ids = new Vector<Id>();

	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<ids>");
		for(int n=0;n<ids.size();n++) {
			Id thisId = ids.elementAt(n);
			sb.append(thisId.toXml());
		}
		sb.append("</ids>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eIds = e.addElement("ids");
		for(int n=0;n<ids.size();n++) {
			Id thisId = ids.elementAt(n);
			thisId.toXml(eIds);
		}
	}
	public static IdList fromXml(Element e) {
		IdList idList = new IdList();
		if(e!=null) {
			Iterator<Element> i = e.elementIterator("id");
			while(i.hasNext()) {
				idList.ids.add(Id.fromXml(i.next()));
			}
		}
		return idList;
	}
	public Vector<Id> getIds() {
		return ids;
	}

	public void setIds(Vector<Id> ids) {
		this.ids = ids;
	}
	
	public void setId(Id id) {
		for(int n=0;n<ids.size();n++) {
			Id thisId = ids.elementAt(n);
			if(thisId.equivalent(id)) {
				thisId.setValue(id.getValue());
				return;
			}
		}
		ids.add(id);
	}
	
	public void setId(String nameSpace, String type, String value) {
		setId(new Id(nameSpace,type,value));
	}
	
	public String getValue(String nameSpace, String type) {
		for(int n=0;n<ids.size();n++) {
			Id thisId = ids.elementAt(n);
			if(thisId.getNameSpace().equalsIgnoreCase(nameSpace) && thisId.getType().equalsIgnoreCase(type)) {
				return thisId.getValue();
			}
		}
		return "";
	}
	
	public Id getId(String nameSpace, String type) {
		for(int n=0;n<ids.size();n++) {
			Id thisId = ids.elementAt(n);
			if(thisId.getNameSpace().equalsIgnoreCase(nameSpace) && thisId.getType().equalsIgnoreCase(type)) {
				return thisId;
			}
		}
		return null;
	}
}
