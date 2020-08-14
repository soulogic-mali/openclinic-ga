package be.presis;

import org.dom4j.Element;

public class Care {
	private IdList ids = new IdList();
	private IdList careProvider = new IdList();
	private IdList outcome = new IdList();
	private IdList risks = new IdList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<care>");
		sb.append(ids.toXml());
		sb.append("<careprovider>"+careProvider.toXml()+"</careprovider>");
		sb.append("<outcome>"+outcome.toXml()+"</outcome>");
		sb.append("<risks>"+risks.toXml()+"</risks>");
		sb.append("</care>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eCare = e.addElement("care");
		ids.toXml(eCare);
		careProvider.toXml(eCare.addElement("careprovider"));
		outcome.toXml(eCare.addElement("outcome"));
		risks.toXml(eCare.addElement("risks"));
	}
	public static Care fromXml(Element e) {
		Care care = new Care();
		if(e!=null) {
			care.setIds(IdList.fromXml(e.element("ids")));
			if(e.element("careprovider")!=null) {
				care.setCareProvider(IdList.fromXml(e.element("careprovider").element("ids")));
			}
			if(e.element("outcome")!=null) {
				care.setOutcome(IdList.fromXml(e.element("outcome").element("ids")));
			}
			if(e.element("risks")!=null) {
				care.setRisks(IdList.fromXml(e.element("risks").element("ids")));
			}
		}
		return care;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public IdList getCareProvider() {
		return careProvider;
	}
	public void setCareProvider(IdList careProvider) {
		this.careProvider = careProvider;
	}
	public IdList getOutcome() {
		return outcome;
	}
	public void setOutcome(IdList outcome) {
		this.outcome = outcome;
	}
	public IdList getRisks() {
		return risks;
	}
	public void setRisks(IdList risks) {
		this.risks = risks;
	}
}
