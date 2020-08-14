package be.presis;

import org.dom4j.Element;

public class CoverageAuthorization {
	private IdList ids = new IdList();
	private double authorizezdAmount;
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<authorization>");
		sb.append(ids.toXml());
		sb.append("<authorizedamount>"+authorizezdAmount+"</authorizedamount>");
		sb.append("</authorization>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eAuthorization = e.addElement("authorization");
		ids.toXml(eAuthorization);
		eAuthorization.addElement("authorizedamount").setText(authorizezdAmount+"");
	}
	public static CoverageAuthorization fromXml(Element e) {
		CoverageAuthorization authorization = new CoverageAuthorization();
		if(e!=null) {
			authorization.setIds(IdList.fromXml(e.element("ids")));
			try {
				authorization.setAuthorizezdAmount(Double.parseDouble(e.elementText("authorizedamount")));
			} catch(Exception e2) {}
		}
		return authorization;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public double getAuthorizezdAmount() {
		return authorizezdAmount;
	}
	public void setAuthorizezdAmount(double authorizezdAmount) {
		this.authorizezdAmount = authorizezdAmount;
	}
}
