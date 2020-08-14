package be.presis;

import java.text.SimpleDateFormat;

public class Pregnancy {
	private IdList status = new IdList();
	private TypedDate delivery;
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<pregnancy>");
		sb.append(status.toXml());
		sb.append("<deliverydate>"+(delivery==null?"":new SimpleDateFormat("yyyyMMddHHmmss").format(delivery.getDate()))+"</deliverydate>");
		sb.append("</pregnancy>");
		return sb.toString();
	}
	public IdList getStatus() {
		return status;
	}
	public void setStatus(IdList status) {
		this.status = status;
	}
	public TypedDate getDelivery() {
		return delivery;
	}
	public void setDelivery(TypedDate delivery) {
		this.delivery = delivery;
	}
}
