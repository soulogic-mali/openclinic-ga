package be.presis;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import org.dom4j.Element;

public class Encounter {
	private IdList ids = new IdList();
	private IdList types = new IdList();
	private Pregnancy pregnancy = new Pregnancy();
	private Date begin;
	private Date end;
	private Referral referral=new Referral();
	private Care care = new Care();
	private Vector<Diagnosis> diagnoses = new Vector<Diagnosis>();
	
	public Care getCare() {
		return care;
	}
	public void setCare(Care care) {
		this.care = care;
	}
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<encounter>");
		sb.append(ids.toXml());
		sb.append("<type>"+types.toXml()+"</type>");
		sb.append("<begin>"+(begin==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(begin))+"</begin>");
		sb.append("<end>"+(end==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(end))+"</end>");
		sb.append(referral.toXml());
		sb.append(care.toXml());
		sb.append("<diagnoses>");
		for(int n=0;n<diagnoses.size();n++) {
			Diagnosis diagnosis = diagnoses.elementAt(n);
			sb.append(diagnosis.toXml());
		}
		sb.append("</diagnoses>");
		sb.append("</encounter>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eEncounter = e.addElement("encounter");
		ids.toXml(eEncounter);
		types.toXml(eEncounter.addElement("type"));
		eEncounter.addElement("begin").setText(begin==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(begin));
		eEncounter.addElement("end").setText(end==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(end));
		referral.toXml(eEncounter);
		care.toXml(eEncounter);
		Element eDiagnoses = eEncounter.addElement("diagnoses");
		for(int n=0;n<diagnoses.size();n++) {
			Diagnosis diagnosis = diagnoses.elementAt(n);
			diagnosis.toXml(eDiagnoses);
		}
	}
	public static Encounter fromXml(Element e) {
		Encounter encounter = new Encounter();
		if(e!=null) {
			encounter.setIds(IdList.fromXml(e.element("ids")));
			encounter.setTypes(IdList.fromXml(e.element("type")));
			try {
				encounter.setBegin(new SimpleDateFormat("yyyyMMddHHmmss").parse(e.elementText("begin")));
			}catch(Exception e2) {}
			try {
				encounter.setEnd(new SimpleDateFormat("yyyyMMddHHmmss").parse(e.elementText("end")));
			}catch(Exception e2) {}
			encounter.setReferral(Referral.fromXml(e.element("referral")));
			encounter.setCare(Care.fromXml(e.element("care")));
			if(e.element("diagnoses")!=null) {
				Iterator<Element> i = e.element("diagnoses").elementIterator("diagnosis");
				while(i.hasNext()) {
					encounter.diagnoses.add(Diagnosis.fromXml(i.next()));
				}
			}
		}
		return encounter;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getTypes() {
		return types;
	}
	public void setTypes(IdList types) {
		this.types = types;
	}
	public Pregnancy getPregnancy() {
		return pregnancy;
	}
	public void setPregnancy(Pregnancy pregnancy) {
		this.pregnancy = pregnancy;
	}
	public Date getBegin() {
		return begin;
	}
	public void setBegin(Date begin) {
		this.begin = begin;
	}
	public Date getEnd() {
		return end;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
	public Referral getReferral() {
		return referral;
	}
	public void setReferral(Referral referral) {
		this.referral = referral;
	}
	public Vector<Diagnosis> getDiagnoses() {
		return diagnoses;
	}
	public void setDiagnoses(Vector<Diagnosis> diagnoses) {
		this.diagnoses = diagnoses;
	}
}
