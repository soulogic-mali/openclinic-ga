package be.presis;

import org.dom4j.Element;

import be.openclinic.system.SH;

public class Address {
	private String street;
	private String number;
	private String zipcode;
	private String city;
	private String province;
	private String region;
	private String country;
	private NameList other = new NameList();
	
	public String toXml() {
		StringBuffer sb = new StringBuffer();
		sb.append("<address>");
		sb.append("<street>"+(street==null?"":street)+"</street>");
		sb.append("<number>"+(number==null?"":number)+"</number>");
		sb.append("<zipcode>"+(zipcode==null?"":zipcode)+"</zipcode>");
		sb.append("<city>"+(city==null?"":city)+"</city>");
		sb.append("<province>"+(province==null?"":province)+"</province>");
		sb.append("<region>"+(region==null?"":region)+"</region>");
		sb.append("<country>"+(country==null?"":country)+"</country>");
		sb.append(other.toXml("other"));
		sb.append("</address>");
		return sb.toString();
	}
	public void toXml(Element e) {
		Element eAddress = e.addElement("address");
		eAddress.addElement("street").addCDATA(street==null?"":street);
		eAddress.addElement("number").addCDATA(number==null?"":number);
		eAddress.addElement("zipcode").addCDATA(zipcode==null?"":zipcode);
		eAddress.addElement("city").addCDATA(city==null?"":city);
		eAddress.addElement("province").addCDATA(province==null?"":province);
		eAddress.addElement("region").addCDATA(region==null?"":region);
		eAddress.addElement("country").addCDATA(country==null?"":country);
		other.toXml(eAddress);
	}
	public static Address fromXml(Element e) {
		Address address = new Address();
		if(e!=null) {
			address.setStreet(SH.c(e.elementText("street")));
			address.setNumber(SH.c(e.elementText("number")));
			address.setZipcode(SH.c(e.elementText("zipcode")));
			address.setCity(SH.c(e.elementText("city")));
			address.setProvince(SH.c(e.elementText("province")));
			address.setRegion(SH.c(e.elementText("region")));
			address.setCountry(SH.c(e.elementText("country")));
			address.setOther(NameList.fromXml(e,"other"));
		}
		return address;
	}
	public String getStreet() {
		return street;
	}
	public void setStreet(String street) {
		this.street = street;
	}
	public String getNumber() {
		return number;
	}
	public void setNumber(String number) {
		this.number = number;
	}
	public String getZipcode() {
		return zipcode;
	}
	public void setZipcode(String zipcode) {
		this.zipcode = zipcode;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getProvince() {
		return province;
	}
	public void setProvince(String province) {
		this.province = province;
	}
	public String getRegion() {
		return region;
	}
	public void setRegion(String region) {
		this.region = region;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public NameList getOther() {
		return other;
	}
	public void setOther(NameList other) {
		this.other = other;
	}
}
