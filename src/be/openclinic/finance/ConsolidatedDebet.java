package be.openclinic.finance;

import be.mxs.common.util.system.ScreenHelper;

public class ConsolidatedDebet {
	private String prestationUid;
	private double quantity=0;
	private double patientamount=0;
	private double insureramount=0;
	private double extrainsureramount=0;
	private double extrainsureramount2=0;
	private String insuranceUid,extraInsurarUid,extraInsurarUid2,encounterUid;
	private Prestation prestation=null;
	
	public String getEncounterUid() {
		return encounterUid;
	}

	public void setEncounterUid(String encounterUid) {
		this.encounterUid = encounterUid;
	}

	public double getExtrainsureramount2() {
		return extrainsureramount2;
	}

	public void setExtrainsureramount2(double extrainsureramount2) {
		this.extrainsureramount2 = extrainsureramount2;
	}

	public String getInsuranceUid() {
		return insuranceUid;
	}

	public Insurance getInsurance(){
		Insurance insurance = null;
		if(ScreenHelper.checkString(getInsuranceUid()).length()>0){
			insurance = Insurance.get(getInsuranceUid());
			if(insurance!=null && !insurance.hasValidUid()){
				insurance=null;
			}
		}
		return insurance;
	}
	
	public void setInsuranceUid(String insuranceUid) {
		this.insuranceUid = insuranceUid;
	}

	public String getExtraInsurarUid() {
		return extraInsurarUid;
	}

	public void setExtraInsurarUid(String extraInsurarUid) {
		this.extraInsurarUid = extraInsurarUid;
	}

	public String getExtraInsurarUid2() {
		return extraInsurarUid2;
	}

	public void setExtraInsurarUid2(String extraInsurarUid2) {
		this.extraInsurarUid2 = extraInsurarUid2;
	}

	public void addDebet(Debet debet){
		if(debet.getCredited()==0){
			if(prestationUid==null){
				prestationUid=debet.getPrestationUid();
				insuranceUid=debet.getInsuranceUid();
				extraInsurarUid=debet.getExtraInsurarUid();
				extraInsurarUid2=debet.getExtraInsurarUid2();
				encounterUid=debet.getEncounterUid();
			}
			if(prestationUid.equalsIgnoreCase(debet.getPrestationUid())){
				quantity+=debet.getQuantity();
				if(ScreenHelper.checkString(debet.getExtraInsurarUid2()).length()>0){
					extrainsureramount2+=debet.getAmount();
				}
				else {
					patientamount+=debet.getAmount();
				}
				insureramount+=debet.getInsurarAmount();
				extrainsureramount+=debet.getExtraInsurarAmount();
			}
		}
	}
	
	public String getPrestationUid() {
		return prestationUid;
	}
	public void setPrestationUid(String prestationUid) {
		this.prestationUid = prestationUid;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public double getPatientamount() {
		return patientamount;
	}
	public void setPatientamount(double patientamount) {
		this.patientamount = patientamount;
	}
	public double getInsureramount() {
		return insureramount;
	}
	public void setInsureramount(double insureramount) {
		this.insureramount = insureramount;
	}
	public double getExtrainsureramount() {
		return extrainsureramount;
	}
	public void setExtrainsureramount(double extrainsureramount) {
		this.extrainsureramount = extrainsureramount;
	}
	public double getExtrainsuraramount2() {
		return extrainsureramount2;
	}
	public void setExtrainsuraramount2(double extrainsuraramount2) {
		this.extrainsureramount2 = extrainsuraramount2;
	}
	public Prestation getPrestation(){
		if(prestation==null){
			prestation=Prestation.get(prestationUid);
		}
		return prestation;
	}
	
}
