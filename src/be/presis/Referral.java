package be.presis;

import org.dom4j.Element;

public class Referral {
	private IdList ids = new IdList();
	private IdList referredBy = new IdList();
	private IdList referringTo = new IdList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<referral>");
		sb.append(ids.toXml());
		sb.append("<referredby>"+referredBy.toXml()+"</referredby>");
		sb.append("<referringto>"+referringTo.toXml()+"</referringto>");
		sb.append("</referral>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eReferral = e.addElement("referral");
		ids.toXml(eReferral);
		referredBy.toXml(eReferral.addElement("referredby"));
		referringTo.toXml(eReferral.addElement("referringto"));
	}
	public static Referral fromXml(Element e) {
		Referral referral = new Referral();
		if(e!=null) {
			referral.setIds(IdList.fromXml(e.element("ids")));
			if(e.element("referredby")!=null) {
				referral.setReferredBy(IdList.fromXml(e.element("referredby").element("ids")));
			}
			if(e.element("referringto")!=null) {
				referral.setReferringTo(IdList.fromXml(e.element("referringto").element("ids")));
			}
		}
		return referral;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getReferredBy() {
		return referredBy;
	}
	public void setReferredBy(IdList referredBy) {
		this.referredBy = referredBy;
	}
	public IdList getReferringTo() {
		return referringTo;
	}
	public void setReferringTo(IdList referringTo) {
		this.referringTo = referringTo;
	}
}
