package be.openclinic.medical;

public class BloodGiftCost {
	private String type=null;
	private double cnts;
	private double donor;
	
	public BloodGiftCost(String type) {
		this.type=type;
	}
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public double getCnts() {
		return cnts;
	}
	public void setCnts(double cnts) {
		this.cnts = cnts;
	}
	public double getDonor() {
		return donor;
	}
	public void setDonor(double donor) {
		this.donor = donor;
	}
	
	public double getTotal() {
		return cnts+donor;
	}
	
	public void addCnts(double d) {
		cnts+=d;
	}
	
	public void addDonor(double d) {
		donor+=d;
	}
	
}
