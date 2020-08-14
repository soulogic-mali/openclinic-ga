package be.presis;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.dom4j.Element;

public class DateIdQuantity {
	private IdList ids = new IdList();
	private Date date;
	private double quantity;
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append(ids.toXml());
		sb.append("<date>"+(date==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(date))+"</date>");
		sb.append("<quantity>"+quantity+"</quantity>");
		return sb.toString();
	}
	public void toXml(Element e) {
		ids.toXml(e);
		e.addElement("date").setText(date==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(date));
		e.addElement("quantity").setText(quantity+"");
	}
	public static DateIdQuantity fromXml(Element e) {
		DateIdQuantity dateIdQuantity = new DateIdQuantity();
		dateIdQuantity.setIds(IdList.fromXml(e.element("ids")));
		try {
			dateIdQuantity.setDate(new SimpleDateFormat("yyyyMMddHHmmss").parse(e.elementText("date")));
		}
		catch(Exception e2) {}
		try {
			dateIdQuantity.setQuantity(Double.parseDouble(e.elementText("quantity")));
		}
		catch(Exception e2) {}
		return dateIdQuantity;
	}
	public IdList getIds() {
		return ids;
	}
	public void setIds(IdList ids) {
		this.ids = ids;
	}
	public Date getDate() {
		return date;
	}
	public void setDate(Date date) {
		this.date = date;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
}
