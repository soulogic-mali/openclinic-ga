package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class Cost {
	private String currency;
	private double amount;
	
	public static Cost fromXml(Element e) {
		Cost cost = new Cost();
		if(e!=null) {
			cost.setCurrency(SH.c(e.attributeValue("currency")));
			try {
				cost.setAmount(Double.parseDouble(e.elementText("amount")));
			}
			catch(Exception e2) {}
		}
		return cost;
	}
	public String getCurrency() {
		return currency;
	}
	public void setCurrency(String currency) {
		this.currency = currency;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
}
