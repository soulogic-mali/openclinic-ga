package be.openclinic.medical;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Date;
import java.util.Vector;

import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.Debet;
import be.openclinic.system.SH;
import net.admin.AdminPerson;
import net.admin.Service;

public class BloodGift {
	private static final String sPrefix="be.mxs.common.model.vo.healthrecord.IConstants.";
	private int personid;
	private int age;
	private String gender=null;
	private Date date;
	private String environment=null;
	private String collectionLocation=null;
	private String collectionUnit=null;
	private int collected;
	private int tested;
	private int distributed;
	private String DonorType=null;
	private BloodGiftCost missioncost=new BloodGiftCost("mission");
	private BloodGiftCost collationcost=new BloodGiftCost("collation");
	private BloodGiftCost fuelcost=new BloodGiftCost("fuel");
	private boolean newDonor;
	private int refused; //0=no, 1=temorarily, 2=permanently
	private Vector reasonsForRefusal = new Vector();
	private int hiv;
	private int syphilis;
	private int hepatitisB;
	private int hepatitisC;
	private String bloodgroup=null;
	private Vector reasonsForDestruction=new Vector();
	private TransactionVO transaction;
	
	public static String getCsvReport(Date begin, Date end) {
		StringBuffer report = new StringBuffer();
		report.append("PERSONID;AGE;SEXE;DATE;MILIEU;LIEU_PRELEVEMENT;UNITE_COLLECTE;COLLECTE;TESTE;DISTRIBUE;TYPE_DONNEUR;COUT_MISSION;COUT_COLLATION;"+
		"COUT_CARBURANT;NOUVEAU_DONNEUR;REJET;VIH;BW;HEPB;HEPC;ABO;\n");
		Vector<BloodGift> bloodgifts = find(begin,end);
		for(int n=0;n<bloodgifts.size();n++) {
			BloodGift gift = bloodgifts.elementAt(n);
			report.append(gift.getPersonid()+";");
			report.append(gift.getAge()+";");
			report.append(gift.getGender().toUpperCase()+";");
			report.append(SH.formatDate(gift.getDate())+";");
			report.append(SH.getTranNoLink("cnts.environment",SH.c(gift.getEnvironment()),"fr").toUpperCase()+";");
			report.append(SH.c(gift.getCollectionLocation()).toUpperCase()+";");
			report.append(SH.getTranNoLink("cnts.collectionunit",gift.getCollectionUnit(),"fr").toUpperCase()+";");
			report.append(gift.getCollected()+";");
			report.append(gift.getTested()+";");
			report.append(gift.getDistributed()+";");
			report.append(SH.getTranNoLink("cnts.donortype",gift.getDonorType(),"fr").toUpperCase()+";");
			report.append(gift.getMissioncost().getTotal()+";");
			report.append(gift.getCollationcost().getTotal()+";");
			report.append(gift.getFuelcost().getTotal()+";");
			report.append((gift.isNewDonor()?"Nouveau":"Ancien").toUpperCase()+";");
			report.append(gift.getRefused()+";");
			report.append(gift.getHiv()+";");
			report.append(gift.getSyphilis()+";");
			report.append(gift.getHepatitisB()+";");
			report.append(gift.getHepatitisC()+";");
			report.append(gift.getBloodgroup().toUpperCase()+";");
			report.append("\n");
		}
		return report.toString();
	}
	
	public BloodGiftCost getMissioncost() {
		return missioncost;
	}

	public void setMissioncost(BloodGiftCost missioncost) {
		this.missioncost = missioncost;
	}

	public BloodGiftCost getCollationcost() {
		return collationcost;
	}

	public void setCollationcost(BloodGiftCost collationcost) {
		this.collationcost = collationcost;
	}

	public BloodGiftCost getFuelcost() {
		return fuelcost;
	}

	public void setFuelcost(BloodGiftCost fuelcost) {
		this.fuelcost = fuelcost;
	}

	public Vector getReasonsForDestruction() {
		return reasonsForDestruction;
	}

	public void setReasonsForDestruction(Vector reasonsForDestruction) {
		this.reasonsForDestruction = reasonsForDestruction;
	}

	public int getCollected() {
		return collected;
	}

	public void setCollected(int collected) {
		this.collected = collected;
	}

	public int getTested() {
		return tested;
	}

	public void setTested(int tested) {
		this.tested = tested;
	}

	public int getDistributed() {
		return distributed;
	}

	public void setDistributed(int distributed) {
		this.distributed = distributed;
	}

	public TransactionVO getTransaction() {
		return transaction;
	}

	public void setTransaction(TransactionVO transaction) {
		this.transaction = transaction;
	}

	public int getPersonid() {
		return personid;
	}

	public void setPersonid(int personid) {
		this.personid = personid;
	}

	public int getAge() {
		return age;
	}

	public void setAge(int age) {
		this.age = age;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getEnvironment() {
		return environment;
	}

	public void setEnvironment(String environment) {
		this.environment = environment;
	}

	public String getCollectionLocation() {
		return collectionLocation;
	}

	public void setCollectionLocation(String collectionLocation) {
		this.collectionLocation = collectionLocation;
	}

	public String getCollectionUnit() {
		return collectionUnit;
	}

	public void setCollectionUnit(String collectionUnit) {
		this.collectionUnit = collectionUnit;
	}

	public String getDonorType() {
		return DonorType;
	}

	public void setDonorType(String DonorType) {
		this.DonorType = DonorType;
	}

	public boolean isNewDonor() {
		return newDonor;
	}

	public void setNewDonor(boolean newDonor) {
		this.newDonor = newDonor;
	}

	public int getRefused() {
		return refused;
	}

	public void setRefused(int refused) {
		this.refused = refused;
	}

	public Vector getReasonsForRefusal() {
		return reasonsForRefusal;
	}

	public void setReasonsForRefusal(Vector reasonsForRefusal) {
		this.reasonsForRefusal = reasonsForRefusal;
	}

	public int getHiv() {
		return hiv;
	}

	public void setHiv(int hiv) {
		this.hiv = hiv;
	}

	public int getSyphilis() {
		return syphilis;
	}

	public void setSyphilis(int syphilis) {
		this.syphilis = syphilis;
	}

	public int getHepatitisB() {
		return hepatitisB;
	}

	public void setHepatitisB(int hepatitisB) {
		this.hepatitisB = hepatitisB;
	}

	public int getHepatitisC() {
		return hepatitisC;
	}

	public void setHepatitisC(int hepatitisC) {
		this.hepatitisC = hepatitisC;
	}

	public String getBloodgroup() {
		return bloodgroup;
	}

	public void setBloodgroup(String bloodgroup) {
		this.bloodgroup = bloodgroup;
	}

	public static Vector<BloodGift> find(String begin, String end){
		return find(SH.parseDate(begin),new java.util.Date(SH.parseDate(end).getTime()+SH.getTimeDay()),"");
	}
	
	public static Vector<BloodGift> find(String begin, String end, String site){
		return find(SH.parseDate(begin),new java.util.Date(SH.parseDate(end).getTime()+SH.getTimeDay()),site);
	}
	
	public static String getCsvReport(String begin, String end) {
		return getCsvReport(SH.parseDate(begin),SH.parseDate(end));
	}
	
	public static Vector<BloodGift> find(Date begin,Date end){
		return find(begin, end, "");
	}
	public static Vector<BloodGift> find(Date begin,Date end, String site){
		Vector bloodgifts = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			String sSql = "select a.personid,a.gender,a.dateofbirth,t.updatetime,t.serverid,t.transactionid from adminview a,healthrecord h, transactions t where"
						+ " a.personid=h.personid and h.healthrecordid=t.healthrecordid and "
						+ " t.transactiontype='"+sPrefix+"TRANSACTION_TYPE_CNTS_BLOODGIFT' and"
						+ " t.updatetime>=? and t.updatetime<? order by t.updatetime";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				BloodGift gift = new BloodGift();
				gift.setPersonid(rs.getInt("personid"));
				gift.setGender(rs.getString("gender"));
				gift.setDate(rs.getDate("updatetime"));
				gift.setAge(AdminPerson.getAgeOnDate(rs.getDate("dateofbirth"),gift.getDate()));
				gift.setTransaction(TransactionVO.get(rs.getString("serverid"), rs.getString("transactionid")));
				gift.setCollectionUnit();
				if(site.length()>0 && SH.c(gift.getCollectionUnit()).length()==0) { //unspecified collecxtion site
					continue;
				}
				else if(site.equalsIgnoreCase("1") && !"1,6,".contains(gift.getCollectionUnit()+",")) { //CNTS
					continue;
				}
				else if(site.equalsIgnoreCase("2") && !"2,9,".contains(gift.getCollectionUnit()+",")) { //Gitega
					continue;
				}
				else if(site.equalsIgnoreCase("3") && !"5,10,".contains(gift.getCollectionUnit()+",")) { //Ngozi
					continue;
				}
				else if(site.equalsIgnoreCase("4") && !"4,8,".contains(gift.getCollectionUnit()+",")) { //Cibitoke
					continue;
				}
				else if(site.equalsIgnoreCase("5") && !"3,7,".contains(gift.getCollectionUnit()+",")) { //Bururi
					continue;
				}
				gift.setProgress();
				gift.setEnvironment();
				gift.setCollectionLocation();
				gift.setDonorType();
				gift.setCosts();
				gift.setNewDonor(begin);
				gift.setRefused();
				if(gift.getRefused()>0) {
					gift.setRefusalReasons();
				}
				gift.setReasonsForDestruction();
				bloodgifts.add(gift);
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return bloodgifts;
	}
	
	private void setReasonsForDestruction() {
		this.setReasonsForDestruction(new Vector());
		//TODO: reasons for destruction
		//1. Search in pharmacy stock for destruction operations
		//2. Check blood gift form
		//3. Check lab form
	}
	
	private boolean fieldContains(String field, String value) {
		return (transaction.getItemValue(sPrefix+field).startsWith(value+";") || transaction.getItemValue(sPrefix+field).contains(";"+value+";"));
	}
	
	private void setRefusalReasons() {
		setReasonsForRefusal(new Vector());
		for(int n=1;n<30;n++) {
			if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_REJECTIONCRITERIA",n+"")) reasonsForRefusal.add("cnts.bloodgift.rejectioncriteria;"+n);
		}
		for(int n=1;n<30;n++) {
			if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_DISEASES",n+"")) reasonsForRefusal.add("cnts.bloodgift.diseases;"+n);
		}
		if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_PRESERVATIVES","0")) reasonsForRefusal.add("bloodgift;unprotectedsex");
		if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_PREGNANT","1")) reasonsForRefusal.add("bloodgift;pregnant");
		if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_MULTIPLEPARTNERS","1")) reasonsForRefusal.add("bloodgift;multiplesexualpartnerslast3months");
		if(fieldContains("ITEM_TYPE_CNTSBLOODGIFT_WEIGHTLOSS","1")) reasonsForRefusal.add("bloodgift;weightloss");
		if(getAge()<17) reasonsForRefusal.add("bloodgift;youngerthan17");
		if(transaction.getItemValue(sPrefix+"ITEM_TYPE_BIOMETRY_WEIGHT").length()>0 && Double.parseDouble(transaction.getItemValue(sPrefix+"ITEM_TYPE_BIOMETRY_WEIGHT"))<50) {
			reasonsForRefusal.add("bloodgift;weightbelow50");
		}
		if(transaction.getItemValue(sPrefix+"ITEM_TYPE_RMH_MEDICATION").length()>0) reasonsForRefusal.add("web.occup;rmh.clinical.medication");
	}
	
	private void setRefused() {
		if(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true")){
			this.setRefused(2);
		}
		else if(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION").equalsIgnoreCase("medwan.common.true")){
			this.setRefused(1);
		}
		else {
			this.setRefused(0);
		}
	}
	
	private void setNewDonor(Date begin) {
		setNewDonor(true);
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			String sSql="select * from transactions where healthrecordid=? and transactiontype='"+sPrefix+"TRANSACTION_TYPE_CNTS_BLOODGIFT' and updatetime<?";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setInt(1, transaction.getHealthrecordId());
			ps.setDate(2, new java.sql.Date(begin.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()) {
				TransactionVO oldTransaction = TransactionVO.get(rs.getInt("serverid"), rs.getInt("transactionid"));
				if(!(oldTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true") ||
						oldTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION").equalsIgnoreCase("medwan.common.true"))
						 && oldTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_FIT").equalsIgnoreCase("medwan.common.true")){
					setNewDonor(false);
					break;
				}
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void setCosts() {
		setMissioncost(new BloodGiftCost("mission"));
		setCollationcost(new BloodGiftCost("collation"));
		setFuelcost(new BloodGiftCost("fuel"));
		String encounterUid = transaction.getItemValue(sPrefix+"ITEM_TYPE_CONTEXT_ENCOUNTERUID");
		Vector debets = Debet.getEncounterDebets(encounterUid);
		double mission = 0, collation=0, fuel=0;
		for(int n=0;n<debets.size();n++) {
			Debet debet = (Debet)debets.elementAt(n);
			if(debet.getPrestation().getCostCenter().equalsIgnoreCase("mission")) {
				missioncost.addCnts(debet.getInsurarAmount());
				if(SH.c(debet.getExtraInsurarUid()).length()>0) {
					missioncost.addDonor(debet.getAmount());
				}
			}
			else if(debet.getPrestation().getCostCenter().equalsIgnoreCase("collation")) {
				collationcost.addCnts(debet.getInsurarAmount());
				if(SH.c(debet.getExtraInsurarUid()).length()>0) {
					collationcost.addDonor(debet.getAmount());
				}
			}
			if(debet.getPrestation().getCostCenter().equalsIgnoreCase("fuel")) {
				fuelcost.setCnts(debet.getInsurarAmount());
				if(SH.c(debet.getExtraInsurarUid()).length()>0) {
					fuelcost.setDonor(debet.getAmount());
				}
			}

		}
	}
	
	private void setDonorType() {
		this.setDonorType(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_DONORTYPE").replaceAll(";", ""));
	}
	
	private void setEnvironment() {
		String serviceId = transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_LOCATIONPRESET");
		if(serviceId.length()>0) {
			Service service = Service.getService(serviceId);
			if(service!=null) {
				this.setEnvironment(service.contract);
			}
		}
	}
	
	private void setCollectionLocation() {
		this.setCollectionLocation(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_LOCATIONPRESET"));
	}
	
	private void setCollectionUnit() {
		this.setCollectionUnit(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_COLLECTIONUNIT"));
	}
	
	private void setProgress() {
		this.setCollected(0);
		this.setTested(0);
		this.setDistributed(0);
		this.setBloodgroup("");
		//Check if blood gift was not rejected
		if(!(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_PERMANENTREJECTION").equalsIgnoreCase("medwan.common.true") ||
			 transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_TEMPORARYREJECTION").equalsIgnoreCase("medwan.common.true"))
			 && transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_FIT").equalsIgnoreCase("medwan.common.true")){
			this.setCollected(Integer.parseInt(transaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSBLOODGIFT_POCKETS")));
			//Check if lab tests where negative
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			try {
				String sSql = "select * from transactions t,items i where transactiontype='"+sPrefix+"TRANSACTION_TYPE_LAB_REQUEST' and healthrecordid=? and"
							+ " i.serverid=t.serverid and i.transactionid=t.transactionid and"
							+ " i.type='"+sPrefix+"ITEM_TYPE_LAB_OBJECTID' and i.value=?";
				PreparedStatement ps = conn.prepareStatement(sSql);
				ps.setInt(1, transaction.getHealthrecordId());
				ps.setString(2, transaction.getTransactionId()+"");
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					int labTransactionId = rs.getInt("transactionId");
					this.setHiv(checkLabResult(MedwanQuery.getInstance().getConfigString("cntsHIVCode","HIV"),labTransactionId));
					this.setHepatitisB(checkLabResult(MedwanQuery.getInstance().getConfigString("cntsHIVCode","HBS"),labTransactionId));
					this.setHepatitisC(checkLabResult(MedwanQuery.getInstance().getConfigString("cntsHIVCode","HCV"),labTransactionId));
					this.setSyphilis(checkLabResult(MedwanQuery.getInstance().getConfigString("cntsHIVCode","BW"),labTransactionId));
					if(RequestedLabAnalysis.get(transaction.getServerId(), labTransactionId,MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO"))!=null &&
							RequestedLabAnalysis.get(transaction.getServerId(), labTransactionId, MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","Rh"))!=null) {
						this.setBloodgroup(RequestedLabAnalysis.get(transaction.getServerId(), labTransactionId,MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO")).getResultValue().toUpperCase()+
								RequestedLabAnalysis.get(transaction.getServerId(), labTransactionId, MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","Rh")).getResultValue());
					}
					if(!"A+;A-;B+;B-;AB+;AB-;O+;O-".contains(this.getBloodgroup().toUpperCase())) {
						this.setBloodgroup("");
					}
					if(this.getHiv()==0 && this.getHepatitisB()==0 && this.getHepatitisC()==0 && this.getSyphilis()==0) {
						this.setTested(this.getCollected());
						rs.close();
						ps.close();
						//Check if pockets have been produced 
						sSql = "select * from transactions t,items i where transactiontype='"+sPrefix+"TRANSACTION_TYPE_CNTS_LAB_RECORD' and healthrecordid=? and"
								+ " i.serverid=t.serverid and i.transactionid=t.transactionid and"
								+ " i.type='"+sPrefix+"ITEM_TYPE_LAB_OBJECTID' and i.value=?";
						ps = conn.prepareStatement(sSql);
						ps.setInt(1, transaction.getHealthrecordId());
						ps.setString(2, transaction.getTransactionId()+"");
						rs = ps.executeQuery();
						if(rs.next()) {
							labTransactionId = rs.getInt("transactionId");
							TransactionVO labTransaction = TransactionVO.get(transaction.getServerId(), labTransactionId);
							if( Integer.parseInt(labTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSLAB_PFCPOCKETS"))>0 ||
							    Integer.parseInt(labTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSLAB_PRPPOCKETS"))>0 ||
								Integer.parseInt(labTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSLAB_CGRPOCKETS"))>0 ||
								Integer.parseInt(labTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSLAB_STPOCKETS"))>0 ||
								Integer.parseInt(labTransaction.getItemValue(sPrefix+"ITEM_TYPE_CNTSLAB_CPPOCKETS"))>0
								) {
								this.setDistributed(this.getCollected());
							}
						}
					}
				}
				rs.close();
				ps.close();
				conn.close();
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	private int checkLabResult(String labcode,int labTransactionId) {
		RequestedLabAnalysis analysis = RequestedLabAnalysis.get(transaction.getServerId(), labTransactionId, labcode);
		if(analysis!=null) {
			if(MedwanQuery.getInstance().getConfigString("hivnegativevalues","négatif,négative,negatif,negative,-,neg,nég").contains(analysis.getResultValue().toLowerCase())){
				return 0;
			}
			else {
				return 1;
			}
		}
		else {
			return -1;
		}
	}
}
