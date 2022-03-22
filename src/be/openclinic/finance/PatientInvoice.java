package be.openclinic.finance;

import net.admin.AdminPerson;
import net.admin.User;

import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;
import java.util.Date;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.Diagnosis;
import be.openclinic.medical.ReasonForEncounter;
import be.openclinic.pharmacy.ProductionOrder;
import be.openclinic.system.SH;

public class PatientInvoice extends Invoice {
    private String patientUid;
    private AdminPerson patient;
    private String number;
    private String acceptationUid;
    protected String insurarreference;
    protected String insurarreferenceDate;
    protected String comment;
    protected String modifiers; //0=mfpdoctor,1=mfppost,2=mfpagent,3=drugreceiver,4=drugreceiverid,5=receiveridcarddate,6=receiveridcardplace,7=acceptationdate,8=derivedfrom
    
	public String getModifiers() {
		return modifiers;
	}
	public String toXml() {
		return toXml(false);
	}

	public String toXml(boolean bExtended) {
		String s="<patientinvoice id='"+SH.c(getUid())+"' number='"+getInvoiceNumber()+"'>";
		if(bExtended) {
			s+="<patient personid='"+SH.c(getPatientUid())+"'>";
			s+=AdminPerson.get(SH.c(getPatientUid())).toXml();
			s+="</patient>";
		}
		else {
			s+="<patient personid='"+SH.c(getPatientUid())+"'/>";
		}
		s+="<date>"+SH.formatDate(getDate(),SH.timestampFormat)+"</date>";
		s+="<totalamount>"+getTotalAmount()+"</totalamount>";
		s+="<patientamount>"+getPatientAmount()+"</patientamount>";
		s+="<insureramount>"+getInsurarAmount()+"</insureramount>";
		s+="<extrainsureramount>"+getExtraInsurarAmount()+"</extrainsureramount>";
		s+="<patientamountpaid>"+getAmountPaid()+"</patientamountpaid>";
		s+="<patientbalance>"+getBalance()+"</patientbalance>";
		s+="<insurancereference>"+SH.cx(getInsurarreference())+"</insurancereference>";
		s+="<updatetime>"+SH.formatDate(getUpdateDateTime(),SH.timestampFormat)+"</updatetime>";
		s+="<updateuser id='"+SH.cx(getUpdateUser())+"'>";
		if(bExtended) {
			try {
				User user = User.get(Integer.parseInt(getUpdateUser()));
				if(user.person!=null && user.person.isNotEmpty()) {
					s+=user.person.toXml();
				}
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		s+="</updateuser>";
		for(int n=0;n<debets.size();n++) {
			Debet debet = (Debet)debets.elementAt(n);
			s+=debet.toXml(bExtended);
		}
		s+="</patientinvoice>";
		return s;
	}
	
	public boolean createProductionOrders(){
		boolean bCreated = false;
		Vector debets = getDebets();
		for(int n=0;n<debets.size();n++){
			Debet debet = (Debet)debets.elementAt(n);
			Prestation prestation = debet.getPrestation();
			if(prestation!=null && prestation.getProductionOrder()!=null && prestation.getProductionOrder().trim().length()>0){
				//Check if the value of the paid sum >= minimum payment
				if(getAmountPaid()>=getPatientAmount()*prestation.getProductionOrderPaymentLevel()/100){
					if(ProductionOrder.getProductionOrders(null,null,debet.getUid(),null,null).size()==0){
						//Add the target productstockuid to the candidate production orders
						ProductionOrder productionOrder = new ProductionOrder();
						productionOrder.setCreateDateTime(debet.getDate());
						productionOrder.setPatientUid(Integer.parseInt(getPatientUid()));
						productionOrder.setTargetProductStockUid(prestation.getProductionOrder());
						productionOrder.setDebetUid(debet.getUid());
						productionOrder.setUpdateDateTime(new java.sql.Timestamp(new java.util.Date().getTime()));
						productionOrder.setUpdateUid(Integer.parseInt(getUpdateUser()));
						productionOrder.store();
						bCreated=true;
					}
				}
			}
		}
		return bCreated;
	}
	
	public static String getPatientSummaryInvoiceNumber(String uid){
		String s="";
		if(uid!=null && uid.length()>0){
	        String sSelect = "SELECT OC_ITEM_SUMMARYINVOICEUID FROM OC_SUMMARYINVOICEITEMS WHERE OC_ITEM_PATIENTINVOICEUID=?";
	        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
	        ResultSet rs=null;
	        PreparedStatement ps=null;
	        try{
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setString(1,uid);
	            rs = ps.executeQuery();
	            
	            if(rs.next()){
	            	String sNumber = ScreenHelper.checkString(rs.getString("OC_ITEM_SUMMARYINVOICEUID"));
	            	if(sNumber.length()>0){
	            		s=sNumber.split("\\.")[1];
	            	}
	            	else{
	                	if(uid.split("\\.").length>1){
	                		s= uid.split("\\.")[1];
	                	}
	            	}
	            }
	
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                if(rs!=null)rs.close();
	                if(ps!=null)ps.close();
	                oc_conn.close();
	            }
	            catch(Exception e){
	                e.printStackTrace();
	            }
	        }
		}
		return s;
	}
	
	public static String getPatientInvoiceNumber(String uid){
		String s=uid;
		if(uid!=null && uid.length()>0){
	        String sSelect = "SELECT OC_PATIENTINVOICE_NUMBER FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_SERVERID=? and OC_PATIENTINVOICE_OBJECTID = ? ";
	        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
	        ResultSet rs=null;
	        PreparedStatement ps=null;
	        try{
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setInt(1,Integer.parseInt(uid.split("\\.")[0]));
	            ps.setInt(2,Integer.parseInt(uid.split("\\.")[1]));
	            rs = ps.executeQuery();
	            
	            if(rs.next()){
	            	String sNumber = ScreenHelper.checkString(rs.getString("OC_PATIENTINVOICE_NUMBER"));
	            	if(sNumber.length()>0){
	            		s=sNumber;
	            	}
	            	else{
	                	if(uid.split("\\.").length>1){
	                		s= uid.split("\\.")[1];
	                	}
	            	}
	            }
	
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                if(rs!=null)rs.close();
	                if(ps!=null)ps.close();
	                oc_conn.close();
	            }
	            catch(Exception e){
	                e.printStackTrace();
	            }
	        }
		}
		return s;
	}

	public void setModifiers(String modifiers) {
		this.modifiers = modifiers;
	}

	public void setModifier(int index,String value){
		if(getModifiers()==null){
			setModifiers("");
		}
		String[] m = getModifiers().split(";");
		if(m.length<=index){
			setModifiers(getModifiers()+"; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ; ;".substring(0,(index+1-m.length)*2));
			m = getModifiers().split(";");
		}
		m[index]=value;
		modifiers="";
		for(int n=0;n<m.length;n++){
			modifiers+=m[n]+";";
		}
	}

	public String getMfpDoctor(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[0];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpDoctor(String s){
		setModifier(0,s);
	}

	public String getMfpPost(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[1];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpPost(String s){
		setModifier(1,s);
	}

	public String getMfpAgent(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[2];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpAgent(String s){
		setModifier(2,s);
	}

	public String getMfpDrugReceiver(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[3];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpDrugReceiver(String s){
		setModifier(3,s);
	}

	public String getMfpDrugReceiverId(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[4];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpDrugReceiverId(String s){
		setModifier(4,s);
	}

	public String getMfpDrugIdCardDate(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[5];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpDrugIdCardDate(String s){
		setModifier(5,s);
	}

	public String getMfpDrugIdCardPlace(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[6];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setMfpDrugIdCardPlace(String s){
		setModifier(6,s);
	}
	
	public String getAcceptationDate(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[7];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setAcceptationDate(String s){
		setModifier(7,s);
	}

	public void setDerivedFrom(String s){
		setModifier(8,s);
	}

	public String getDerivedFrom(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[8];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setSAPExport(String s){
		setModifier(9,s);
	}

	public String getSAPExport(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[9];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setEstimatedDeliveryDate(String s){
		setModifier(10,s);
	}

	public String getEstimatedDeliveryDate(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[10];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	public void setClosureDate(String s){
		setModifier(11,s);
	}

	public String getClosureDate(){
		String s="";
		if(getModifiers()!=null){
			try{
				s=getModifiers().split(";")[11];
			}
			catch(Exception e){
				//e.printStackTrace();
			}
		}
		return s;
	}

	//MFP reporting section
	
	public String getSignatures(){
		String signatures="";
		Vector pointers=Pointer.getFullPointers("INVSIGN."+this.getUid());
		for(int n=0;n<pointers.size();n++){
			if(n>0){
				signatures+=", ";
			}
			String ptr=(String)pointers.elementAt(n);
			signatures+=ptr.split(";")[0];
		}
		return signatures;
	}
	
    public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public String getInsurarreferenceDate() {
		return insurarreferenceDate;
	}

	public void setInsurarreferenceDate(String insurarreferenceDate) {
		this.insurarreferenceDate = insurarreferenceDate;
	}

	public String getInsurarreference() {
		return ScreenHelper.checkString(insurarreference);
	}

	public void setInsurarreference(String insurarreference) {
		this.insurarreference = insurarreference;
	}

    public String getAcceptationUid() {
		return acceptationUid;
	}

	public void setAcceptationUid(String acceptationUid) {
		this.acceptationUid = acceptationUid;
	}
	
	public boolean canBePrinted(){
		boolean bCan = false;
		long nMaximumAge=MedwanQuery.getInstance().getConfigInt("maximumInvoiceAgeForPrintingInHours",0)*3600*1000;
		if(nMaximumAge==0){
			bCan=true;
		}
		else{
			if(getStatus()==null || !getStatus().equalsIgnoreCase("closed")){
				bCan=true;
			}
			else if(getClosureDate()!=null && getClosureDate().length()>0){
				try{
					if(new java.util.Date().getTime()-ScreenHelper.parseDate(getClosureDate()).getTime()<nMaximumAge){
						bCan=true;
					}
				}
				catch(Exception e){
					if(new java.util.Date().getTime()-getUpdateDateTime().getTime()<nMaximumAge){
						bCan=true;
					}
				}
			}
			else{
				if(new java.util.Date().getTime()-getUpdateDateTime().getTime()<nMaximumAge){
					bCan=true;
				}
			}
		}
		return bCan;
	}

	public String getInvoiceNumber() {
        if(number==null || number.equalsIgnoreCase("")){
        	if(invoiceUid==null){
        		return "";
        	}
        	if(invoiceUid.split("\\.").length>1){
        		return invoiceUid.split("\\.")[1];
        	}
        	else{
        		return invoiceUid;
        	}
        }
        else {
        	return number+"";
        }
    }

    public String getNumber() {
		return number;
	}

	public void setNumber(String number) {
		this.number = number;
	}

	//--- S/GET PATIENT UID -----------------------------------------------------------------------
    public void setPatientUid(String patientUid) {
        this.patientUid = patientUid;
    }

    public String getPatientUid() {
        return patientUid;
    }

    //--- S/GET PATIENT ---------------------------------------------------------------------------
    public void setPatient(AdminPerson patient) {
        this.patient = patient;
    }

    public AdminPerson getPatient() {
        if(patient==null){
            if(ScreenHelper.checkString(patientUid).length()>0){
            	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
                patient=AdminPerson.getAdminPerson(ad_conn,patientUid);
                try {
					ad_conn.close();
				}
                catch (SQLException e) {
					e.printStackTrace();
				}
            }
        }
        return patient;
    }

    public String getDiagnoses(String language){
    	String diagnoses="";
    	//First make a list for all linked encouters
    	HashSet encounters = new HashSet();
    	Vector debets=getDebets();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(!encounters.contains(debet.getEncounterUid())){
	    			encounters.add(debet.getEncounterUid());
	    		}
	    	}
    	}
    	//Now make a list for all linked diagnoses
    	HashSet hDiagnoses = new HashSet();
    	Iterator iEncounters = encounters.iterator();
    	while(iEncounters.hasNext()){
    		String encounterUid=(String)iEncounters.next();
    		//Coded diagnosis
    		Vector vDiagnoses = Diagnosis.selectDiagnoses("", "", encounterUid, "", "", "", "", "", "", "", "", "icd10", "");
    		for(int n=0; n<vDiagnoses.size();n++){
    			Diagnosis d = (Diagnosis)vDiagnoses.elementAt(n);
    			hDiagnoses.add(d.getCode()+" "+MedwanQuery.getInstance().getDiagnosisLabel(d.getCodeType(), d.getCode(), language));
    		}
    		//RFEs
    		Vector vRFE = ReasonForEncounter.getReasonsForEncounterByEncounterUid(encounterUid);
    		for(int n=0; n<vRFE.size();n++){
    			ReasonForEncounter d = (ReasonForEncounter)vRFE.elementAt(n);
    			if(d.getCodeType().equalsIgnoreCase("icd10")){
    				hDiagnoses.add(d.getCode()+" "+MedwanQuery.getInstance().getDiagnosisLabel(d.getCodeType(), d.getCode(), language));
    			}
    		}
    		if(MedwanQuery.getInstance().getConfigInt("enablePBFFreeTextDiagnosisReporting",0)==1){
	    		//Free text diagnoses
	    		HashSet hFreetext = Encounter.getFreeTextDiagnoses(encounterUid);
	    		Iterator iFreeText = hFreetext.iterator();
	    		while(iFreeText.hasNext()){
	    			hDiagnoses.add(((String)iFreeText.next()).replaceAll("\n", " ").replaceAll("\r", "").replaceAll(";", ":"));
	    		}
    		}
    	}
    	Iterator iDiagnoses = hDiagnoses.iterator();
    	while(iDiagnoses.hasNext()){
    		if(diagnoses.length()>0){
    			diagnoses+=", ";
    		}
    		diagnoses+=iDiagnoses.next();
    	}
    	return diagnoses;
    }
    
    public Hashtable getInsurarAmounts(){
    	Hashtable amounts= new Hashtable();
    	for(int n=0;n<debets.size();n++){
    		Debet debet = (Debet)debets.elementAt(n);
			String insurar = "?";
			if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
				insurar=debet.getInsurance().getInsurar().getName();
			}
			if(insurar==null){
				insurar="?";
			}
			if(amounts.get(insurar)!=null){
				amounts.put(insurar, new Double(((Double)amounts.get(insurar)).doubleValue()+debet.getInsurarAmount()));
			}
			else {
				amounts.put(insurar, new Double(debet.getInsurarAmount()));
			}
    		if(debet.getExtraInsurarAmount()>0){
    			insurar = "?";
    			String extraInsurarUid=debet.getExtraInsurarUid();
    			Insurar extraInsurar = Insurar.get(extraInsurarUid);
    			if(extraInsurar!=null){
    				insurar=extraInsurar.getName();
    				if(insurar==null){
    					insurar="?";
    				}
    			}
    			if(amounts.get(insurar)!=null){
    				amounts.put(insurar, ((Double)amounts.get(insurar)).doubleValue()+debet.getExtraInsurarAmount());
    			}
    			else {
    				amounts.put(insurar, debet.getExtraInsurarAmount());
    			}
    		}
    	}
    	return amounts;
    }

    public double getPatientAmount(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		amount+=debet.getAmount();
	    	}
    	}
    	return amount;
    }
    
    public double getTotalAmount(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		amount+=debet.getTotalAmount();
	    	}
    	}
    	return amount;
    }
    
    public double getAmountPaid(){
    	double amount=0;
    	if(credits!=null){
	    	for(int n=0;n<credits.size();n++){
	    		PatientCredit credit = PatientCredit.get((String)credits.elementAt(n));
	    		if(credit!=null && credit.getUid().split("\\.").length==2){
	    			amount+=credit.getAmount();
	    		}
	    	}
    	}
    	return amount;
    }
    
    public double getPatientOwnAmount(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getExtraInsurarUid2()==null || debet.getExtraInsurarUid2().length()==0){
	    			amount+=debet.getAmount();
	    		}
	    	}
    	}
    	return amount;
    }
    
    public double getExtraInsurarAmount2(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getExtraInsurarUid2()!=null && debet.getExtraInsurarUid2().length()>0){
	    			amount+=debet.getAmount();
	    		}
	    	}
    	}
    	return amount;
    }
    
    public double getInsurarAmount(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		amount+=debet.getInsurarAmount();
	    	}
    	}
    	return amount;
    }
    
    public double getExtraInsurarAmount(){
    	double amount=0;
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		amount+=debet.getExtraInsurarAmount();
	    	}
    	}
    	return amount;
    }
    
    public String getInsurers(){
    	String insurers="";
    	Hashtable ins = new Hashtable();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
	    			ins.put(debet.getInsurance().getInsurarUid(), debet.getInsurance().getInsurar().getName());
	    		}
	    	}
    	}
    	Iterator i = ins.keySet().iterator();
    	while(i.hasNext()){
    		if(insurers.length()>0){
    			insurers+=", ";
    		}
    		insurers+=ins.get(i.next());
    	}
    	return insurers;
    }
    
    public Vector getInsurerObjects(){
    	Vector insurers=new Vector();
    	Hashtable ins = new Hashtable();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
	    			ins.put(debet.getInsurance().getInsurarUid(), debet.getInsurance().getInsurar());
	    		}
	    	}
    	}
    	Iterator i = ins.keySet().iterator();
    	while(i.hasNext()){
    		insurers.add(ins.get(i.next()));
    	}
    	return insurers;
    }
    
    public String getInsurerIds(){
    	String insurers="";
    	HashSet ins = new HashSet();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
	    			ins.add(debet.getInsurance().getInsurarUid());
	    		}
	    	}
    	}
    	Iterator i = ins.iterator();
    	while(i.hasNext()){
    		if(insurers.length()>0){
    			insurers+=", ";
    		}
    		insurers+=i.next();
    	}
    	return insurers;
    }
    
    public String getExtraInsurers(){
    	String insurers="";
    	Hashtable ins = new Hashtable();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getExtraInsurar()!=null && debet.getExtraInsurar().getName()!=null){
	    			ins.put(debet.getExtraInsurarUid(), debet.getExtraInsurar().getName());
	    		}
	    	}
    	}
    	Iterator i = ins.keySet().iterator();
    	while(i.hasNext()){
    		if(insurers.length()>0){
    			insurers+=", ";
    		}
    		insurers+=ins.get(i.next());
    	}
    	return insurers;
    }
    
    public String getExtraInsurers2(){
    	String insurers="";
    	Hashtable ins = new Hashtable();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getExtraInsurar2()!=null && debet.getExtraInsurar2().getName()!=null){
	    			ins.put(debet.getExtraInsurarUid2(), debet.getExtraInsurar2().getName());
	    		}
	    	}
    	}
    	Iterator i = ins.keySet().iterator();
    	while(i.hasNext()){
    		if(insurers.length()>0){
    			insurers+=", ";
    		}
    		insurers+=ins.get(i.next());
    	}
    	return insurers;
    }
    
    public String getDiseases(String language){
    	String encounters="";
    	Hashtable ins = new Hashtable();
    	if(debets!=null){
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getEncounterUid()!=null){
	    			ins.put(ScreenHelper.getTranNoLink("encounter.categories",debet.getEncounter().getCategories(),language),"1");
	    		}
	    	}
    	}
    	Iterator i = ins.keySet().iterator();
    	while(i.hasNext()){
    		if(encounters.length()>0){
    			encounters+=",";
    		}
    		encounters+=i.next();
    	}
    	return encounters;
    }
    
    public PatientCredit getReduction(){
    	for(int n=0;n<getCredits().size();n++){
    		PatientCredit credit = PatientCredit.get((String)getCredits().elementAt(n));
    		if(credit!=null && credit.getType().equals("reduction")){
    			return credit;
    		}
    	}
    	return null;
    }

    public double getBalance(){
        double b=0;
        if(getDebets()==null){
            debets = Debet.getPatientDebetsViaInvoiceUid(getPatientUid(),getUid());
        }
        for(int n=0;n<getDebets().size();n++){
            Debet debet = (Debet)getDebets().elementAt(n);
            if(!debet.hasValidExtrainsurer2()){
            	b+=debet.getAmount();
            }
        }
        if(getCredits()==null){
            credits = PatientCredit.getPatientCreditsViaInvoiceUID(getUid());
        }
        for(int n=0;n<getCredits().size();n++){
            PatientCredit credit = PatientCredit.get((String)getCredits().elementAt(n));
            b-=credit.getAmount();
        }
        if(MedwanQuery.getInstance().getConfigInt("currencyDecimals",2)>0 && b>0 && b<1/Math.pow(10,MedwanQuery.getInstance().getConfigInt("currencyDecimals",2))){
        	b=0;
        }
        else {
        	try{
        		b=Double.parseDouble(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#.00")).format(b));
        	}
        	catch(Exception e){
        	}
        }
        if(b>0 && b<Double.parseDouble(MedwanQuery.getInstance().getConfigString("minimumInvoiceBalance","1"))){
        	b=0;
        }
        return b;
    }

    //--- GET -------------------------------------------------------------------------------------
    public static PatientInvoice get(String uid){
        PatientInvoice patientInvoice = new PatientInvoice();

        if(uid!=null && uid.length()>0){
            String [] ids = uid.split("\\.");
            if(ids.length==1){
            	uid=MedwanQuery.getInstance().getConfigString("serverId")+"."+uid;
                ids = uid.split("\\.");
            }
            if (ids.length==2){
                PreparedStatement ps = null;
                ResultSet rs = null;
                String sSelect = "SELECT * FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_SERVERID = ? AND OC_PATIENTINVOICE_OBJECTID = ?";
                Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
                try{
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();

                    if(rs.next()){
                        patientInvoice.setUid(uid);
                        patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
                        patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                        patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                        patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                        patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                        patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                        patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                        patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                        patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                        patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                        patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                        patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                        patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                        patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                        patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));
                        patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));
                    }

                    patientInvoice.debets = Debet.getPatientDebetsViaInvoiceUid(patientInvoice.getPatientUid(),patientInvoice.getUid());
                    patientInvoice.credits = PatientCredit.getPatientCreditsViaInvoiceUID(patientInvoice.getUid());
                }
                catch(Exception e){
                    Debug.println("OpenClinic => PatientInvoice.java => get => "+e.getMessage());
                    e.printStackTrace();
                }
                finally{
                    try{
                        if(rs!=null)rs.close();
                        if(ps!=null)ps.close();
                        oc_conn.close();
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                }
            }
        }
        
        return patientInvoice;
    }

    public boolean hasPatientSignature(){
        boolean bHasSignature = false;
    	PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT * FROM OC_DRAWINGS where OC_DRAWING_SERVERID=? and OC_DRAWING_TRANSACTIONID=? and OC_DRAWING_ITEMTYPE='INVOICE_SIGN'";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(this.getUid().split("\\.")[0]));
            ps.setInt(2,Integer.parseInt(this.getUid().split("\\.")[1]));
            rs = ps.executeQuery();
            
            if(rs.next()){
            	bHasSignature=true;
            }
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => getViaInvoiceUID => "+e.getMessage());
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    	return bHasSignature;
    }
    
    public java.util.Date getPatientSignatureDate(){
        java.util.Date date = null;
    	PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT * FROM OC_DRAWINGS where OC_DRAWING_SERVERID=? and OC_DRAWING_TRANSACTIONID=? and OC_DRAWING_ITEMTYPE='INVOICE_SIGN'";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(this.getUid().split("\\.")[0]));
            ps.setInt(2,Integer.parseInt(this.getUid().split("\\.")[1]));
            rs = ps.executeQuery();
            
            if(rs.next()){
            	date=rs.getTimestamp("OC_DRAWING_DATE");
            }
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => getViaInvoiceUID => "+e.getMessage());
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    	return date;
    }
    
    //--- GET VIA INVOICE UID ---------------------------------------------------------------------
    public static PatientInvoice getViaInvoiceUID(String sInvoiceID){
        PatientInvoice patientInvoice = new PatientInvoice();

        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT * FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_OBJECTID = ? ";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(sInvoiceID));
            rs = ps.executeQuery();
            
            if(rs.next()){
                patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
                patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
                patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));
                patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));
            }

            patientInvoice.debets = Debet.getPatientDebetsViaInvoiceUid(patientInvoice.getPatientUid(),patientInvoice.getUid());
            patientInvoice.credits = PatientCredit.getPatientCreditsViaInvoiceUID(patientInvoice.getUid());
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => getViaInvoiceUID => "+e.getMessage());
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        
        return patientInvoice;
    }

    //--- GET VIA INVOICE UID ---------------------------------------------------------------------
    public static PatientInvoice getViaPatientNumber(String sInvoiceID){
        PatientInvoice patientInvoice = new PatientInvoice();

        PreparedStatement ps = null;
        ResultSet rs = null;

        String sSelect = "SELECT * FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_NUMBER = ? ";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            ps = oc_conn.prepareStatement(sSelect);
            ps.setInt(1,Integer.parseInt(sInvoiceID));
            rs = ps.executeQuery();
            
            if(rs.next()){
                patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
                patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
                patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));
                patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));
            }

            patientInvoice.debets = Debet.getPatientDebetsViaInvoiceUid(patientInvoice.getPatientUid(),patientInvoice.getUid());
            patientInvoice.credits = PatientCredit.getPatientCreditsViaInvoiceUID(patientInvoice.getUid());
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => getViaInvoiceUID => "+e.getMessage());
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        
        return patientInvoice;
    }

    //--- GET DEBET STRINGS -----------------------------------------------------------------------
    public Vector getDebetStrings(){
        Vector d = new Vector();
        
        if(debets!=null){
            for(int n=0;n<debets.size();n++){
                d.add(((Debet)debets.elementAt(n)).getUid());
            }
        }
        
        return d;
    }

    //--- STORE -----------------------------------------------------------------------------------
    public boolean store(){
        boolean bStored = true;
        AdminPerson patient = getPatient();
    	//Remove any drug reimbursement deliveries from invoice
        if(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionPrestationUid","").length()>0){
	    	Vector debets = Debet.getPatientDebetsToInvoice(getPatientUid());
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getPrestationUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionPrestationUid",""))){
	    			Debet.delete(debet.getUid());
	    		}
	    	}
        	debets = getDebets();
	    	for(int n=0;n<debets.size();n++){
	    		Debet debet = (Debet)debets.elementAt(n);
	    		if(debet.getPrestationUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionPrestationUid",""))){
	    			Debet.delete(debet.getUid());
	    			debets.remove(n);
	    			break;
	    		}
	    	}
            String bloodDonorInsuranceUid=Insurance.getActiveInsurance(getPatientUid(), MedwanQuery.getInstance().getConfigString("bloodDonorInsurance"));
	        if(bloodDonorInsuranceUid!=null){
	        	String encounteruid="";
	        	double eligibledebets =0;
	        	String eligiblefamilies=MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionEligibleDebetFamilies","PHA");
	        	debets = getDebetsForInsurance(bloodDonorInsuranceUid);
	        	for(int n=0;n<debets.size();n++){
	        		Debet debet = (Debet)debets.elementAt(n);
	        		if(eligiblefamilies.contains(debet.getPrestation().getReferenceObject().getObjectType())){
	        			eligibledebets+=debet.getAmount();
	        			encounteruid=debet.getEncounterUid();
	        		}
	        	}
	        	if(eligibledebets>0){
	        		//We must add the cost reduction debet
	        		if(eligibledebets>Double.parseDouble(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionMaximum","2"))){
	        			eligibledebets=Double.parseDouble(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionMaximum","2"));
	        		}
	        		Debet debet = new Debet();
	        		debet.setAmount(-eligibledebets);
	        		debet.setCreateDateTime(new java.util.Date());
	        		debet.setDate(new java.util.Date());
	        		debet.setEncounterUid(encounteruid);
	        		debet.setExtraInsurarAmount(0);
	        		debet.setInsuranceUid(bloodDonorInsuranceUid);
	        		debet.setInsurarAmount(0);
	        		debet.setPrestationUid(MedwanQuery.getInstance().getConfigString("bloodDonorCostReductionPrestationUid",""));
	        		debet.setQuantity(1);
	        		debet.setUpdateUser(getUpdateUser());
	        		debet.setUpdateDateTime(getUpdateDateTime());
	        		debet.setVersion(1);
	        		debet.setPatientInvoiceUid(getUid());
	        		debet.store();
	        		getDebets().add(debet);
	        	}
	        }
        }
        String ids[];
        int iVersion = 1;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            if(this.getUid()!=null && this.getUid().length() > 0){
                ids = this.getUid().split("\\.");

                if(ids.length == 2){
                    sSelect = "SELECT OC_PATIENTINVOICE_VERSION FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_SERVERID = ? AND OC_PATIENTINVOICE_OBJECTID = ?";
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    rs = ps.executeQuery();

                    if(rs.next()) {
                        iVersion = rs.getInt("OC_PATIENTINVOICE_VERSION") + 1;
                    }

                    rs.close();
                    ps.close();

                    sSelect = "INSERT INTO OC_PATIENTINVOICES_HISTORY SELECT * FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_SERVERID = ? AND OC_PATIENTINVOICE_OBJECTID = ?";
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();

                    sSelect = " DELETE FROM OC_PATIENTINVOICES WHERE OC_PATIENTINVOICE_SERVERID = ? AND OC_PATIENTINVOICE_OBJECTID = ?";
                    ps = oc_conn.prepareStatement(sSelect);
                    ps.setInt(1,Integer.parseInt(ids[0]));
                    ps.setInt(2,Integer.parseInt(ids[1]));
                    ps.executeUpdate();
                    ps.close();
                }
                else{
                    ids = new String[] {MedwanQuery.getInstance().getConfigString("serverId"),MedwanQuery.getInstance().getOpenclinicCounter("OC_INVOICES")+""};
                    this.setUid(ids[0]+"."+ids[1]);
                    this.setInvoiceUid(ids[1]);
                    if(ScreenHelper.checkString(this.getNumber()).length()==0 && (MedwanQuery.getInstance().getConfigInt("alternateInvoiceNumberingForClosedInvoicesOnly",0)==0 || this.getStatus().equalsIgnoreCase("closed"))){
                    	this.setNumber(getInvoiceNumberCounter("PatientInvoice"));
                    }
                }
            }
            else{
                ids = new String[] {MedwanQuery.getInstance().getConfigString("serverId"),MedwanQuery.getInstance().getOpenclinicCounter("OC_INVOICES")+""};
                this.setUid(ids[0]+"."+ids[1]);
                this.setInvoiceUid(ids[1]);
                if(ScreenHelper.checkString(this.getNumber()).length()==0 && (MedwanQuery.getInstance().getConfigInt("alternateInvoiceNumberingForClosedInvoicesOnly",0)==0 || this.getStatus().equalsIgnoreCase("closed"))){
                	this.setNumber(getInvoiceNumberCounter("PatientInvoice"));
                }
            }

            if(ids.length == 2){
            	if(getStatus().equalsIgnoreCase("closed") && getClosureDate().length()==0){
            		if(getUpdateDateTime()==null){
            			setUpdateDateTime(new java.util.Date());
            		}
            		setClosureDate(ScreenHelper.formatDate(getUpdateDateTime()));
            	}
            	sSelect = " INSERT INTO OC_PATIENTINVOICES (" +
                          " OC_PATIENTINVOICE_SERVERID," +
                          " OC_PATIENTINVOICE_OBJECTID," +
                          " OC_PATIENTINVOICE_DATE," +
                          " OC_PATIENTINVOICE_ID," +
                          " OC_PATIENTINVOICE_PATIENTUID," +
                          " OC_PATIENTINVOICE_CREATETIME," +
                          " OC_PATIENTINVOICE_UPDATETIME," +
                          " OC_PATIENTINVOICE_UPDATEUID," +
                          " OC_PATIENTINVOICE_VERSION," +
                          " OC_PATIENTINVOICE_BALANCE," +
                          " OC_PATIENTINVOICE_STATUS," +
                          " OC_PATIENTINVOICE_NUMBER," +
                          " OC_PATIENTINVOICE_INSURARREFERENCE," +
                          " OC_PATIENTINVOICE_INSURARREFERENCEDATE," +
                          " OC_PATIENTINVOICE_ACCEPTATIONUID," +
                          " OC_PATIENTINVOICE_VERIFIER," +
                          " OC_PATIENTINVOICE_COMMENT," +
                          " OC_PATIENTINVOICE_MODIFIERS" +
                        ") " +
                         " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
                ps = oc_conn.prepareStatement(sSelect);
                while(!MedwanQuery.getInstance().validateNewOpenclinicCounter("OC_PATIENTINVOICES","OC_PATIENTINVOICE_OBJECTID",ids[1])){
                    ids[1] = MedwanQuery.getInstance().getOpenclinicCounter("OC_INVOICES") + "";
                }
                ps.setInt(1,Integer.parseInt(ids[0]));
                ps.setInt(2,Integer.parseInt(ids[1]));
                ps.setDate(3,new java.sql.Date(this.getDate().getTime()));
                ps.setInt(4,Integer.parseInt(ids[1]));
                ps.setString(5,this.getPatientUid());
                ps.setTimestamp(6,new Timestamp(this.getCreateDateTime().getTime()));
                ps.setTimestamp(7,new Timestamp(new java.util.Date().getTime()));
                ps.setString(8,this.getUpdateUser());
                ps.setInt(9,iVersion);
                ps.setDouble(10,this.getBalance());
                ps.setString(11,this.getStatus());
                if(ScreenHelper.checkString(this.getNumber()).length()==0 && MedwanQuery.getInstance().getConfigInt("alternateInvoiceNumberingForClosedInvoicesOnly",0)==1 && this.getStatus().equalsIgnoreCase("closed")){
                	this.setNumber(getInvoiceNumberCounter("PatientInvoice"));
                }
                ps.setString(12,this.getNumber());
                ps.setString(13,this.getInsurarreference());
                ps.setString(14,this.getInsurarreferenceDate());
                ps.setString(15,this.getAcceptationUid());
                ps.setString(16,this.getVerifier());
                ps.setString(17, this.getComment());
                ps.setString(18, this.getModifiers());
                ps.executeUpdate();
                ps.close();

                sSelect = "UPDATE OC_DEBETS SET OC_DEBET_PATIENTINVOICEUID = NULL WHERE OC_DEBET_PATIENTINVOICEUID = ?";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1,this.getUid());
                ps.executeUpdate();
                ps.close();

                if (this.debets!=null){
                    String sDebetUID;
                    String[] aDebetUID;

                    for (int i=0;i<this.debets.size();i++){
                        sDebetUID = ScreenHelper.checkString(((Debet)this.debets.elementAt(i)).getUid());

                        if (sDebetUID.length()>0){
                            aDebetUID = sDebetUID.split("\\.");

                            if (aDebetUID.length==2){
                                sSelect = "UPDATE OC_DEBETS SET OC_DEBET_PATIENTINVOICEUID = ? WHERE OC_DEBET_SERVERID = ? AND OC_DEBET_OBJECTID = ? ";
                                ps = oc_conn.prepareStatement(sSelect);
                                ps.setString(1,this.getUid());
                                ps.setInt(2,Integer.parseInt(aDebetUID[0]));
                                ps.setInt(3,Integer.parseInt(aDebetUID[1]));
                                ps.executeUpdate();
                                ps.close();
                            }
                        }
                    }
                }

                sSelect = "UPDATE OC_PATIENTCREDITS SET OC_PATIENTCREDIT_INVOICEUID = NULL WHERE OC_PATIENTCREDIT_INVOICEUID = ? ";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1,this.getUid());
                ps.executeUpdate();
                ps.close();

                if (this.credits!=null){
                    String sCreditUID;
                    String[] aCreditUID;

                    for (int i=0;i<this.credits.size();i++){
                        sCreditUID = ScreenHelper.checkString((String)this.credits.elementAt(i));

                        if (sCreditUID.length()>0){
                            aCreditUID = sCreditUID.split("\\.");

                            if (aCreditUID.length==2){
                                sSelect = "UPDATE OC_PATIENTCREDITS SET OC_PATIENTCREDIT_INVOICEUID = ? WHERE OC_PATIENTCREDIT_SERVERID = ? AND OC_PATIENTCREDIT_OBJECTID = ? ";
                                ps = oc_conn.prepareStatement(sSelect);
                                ps.setString(1,this.getUid());
                                ps.setInt(2,Integer.parseInt(aCreditUID[0]));
                                ps.setInt(3,Integer.parseInt(aCreditUID[1]));
                                ps.executeUpdate();
                                ps.close();
                            }
                        }
                    }
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
            bStored = false;
            Debug.println("OpenClinic => PatientInvoice.java => store => "+e.getMessage()+" = "+sSelect);
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        return bStored;
    }

    //--- SEARCH INVOICES -------------------------------------------------------------------------
    public static Vector searchInvoices(String sInvoiceDate, String sInvoiceNr, String sInvoicePatientUid, String sInvoiceStatus){
        return searchInvoices(sInvoiceDate,sInvoiceNr,sInvoicePatientUid,sInvoiceStatus,"","");
    }

    public static Vector searchInvoices(String sInvoiceDate, String sInvoiceNr, String sInvoicePatientUid,
                                        String sInvoiceStatus, String sInvoiceBalanceMin, String sInvoiceBalanceMax){
        Vector invoices = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // compose query
            String sSql = "SELECT * FROM OC_PATIENTINVOICES";
            if(sInvoiceDate.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_DATE = ? AND";
            }
            if(sInvoiceNr.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_OBJECTID = ? AND";
            }
            if(sInvoicePatientUid.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_PATIENTUID = ? AND";
            }
            if(sInvoiceStatus.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_STATUS = ? AND";
            }

            // balance range
            if(sInvoiceBalanceMin.length() > 0 && sInvoiceBalanceMax.length() > 0){
                sSql+= " (OC_PATIENTINVOICE_BALANCE >= ? AND OC_PATIENTINVOICE_BALANCE < ?)";
            }
            else if(sInvoiceBalanceMin.length() > 0){
                sSql+= " OC_PATIENTINVOICE_BALANCE >= ?";
            }
            else if(sInvoiceBalanceMax.length() > 0){
                sSql+= " OC_PATIENTINVOICE_BALANCE < ?";
            }
            else{
                // remove last AND
                if(sSql.endsWith("AND")){
                    sSql = sSql.substring(0,sSql.length()-3);
                }
            }

            sSql+= " ORDER BY OC_PATIENTINVOICE_DATE DESC,OC_PATIENTINVOICE_OBJECTID DESC";

            ps = oc_conn.prepareStatement(sSql);

            // set question marks
            int qmIdx = 1;
            SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
            if(sInvoiceNr.length() > 0) ps.setInt(qmIdx++,Integer.parseInt(sInvoiceNr));
            if(sInvoiceDate.length() > 0) ps.setDate(qmIdx++,new java.sql.Date(ScreenHelper.parseDate(sInvoiceDate).getTime()));
            if(sInvoicePatientUid.length() > 0) ps.setString(qmIdx++,sInvoicePatientUid);
            if(sInvoiceStatus.length() > 0) ps.setString(qmIdx++,sInvoiceStatus);
            if(sInvoiceBalanceMin.length() > 0) ps.setDouble(qmIdx++,Double.parseDouble(sInvoiceBalanceMin));
            if(sInvoiceBalanceMax.length() > 0) ps.setDouble(qmIdx,Double.parseDouble(sInvoiceBalanceMax));

            rs = ps.executeQuery();

            PatientInvoice patientInvoice;
            while(rs.next()){
                patientInvoice = new PatientInvoice();

                patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
                patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
                patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));   
                patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));

                invoices.add(patientInvoice);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return invoices;
    }

    //--- SEARCH INVOICES -------------------------------------------------------------------------
    public static Vector searchInvoices(String sInvoiceDateBegin, String sInvoiceDateEnd, String sInvoiceNr,
    		                            String sInvoiceBalanceMin, String sInvoiceBalanceMax){
        Vector invoices = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // compose query
            String sSql = "SELECT * FROM OC_PATIENTINVOICES WHERE";

            if(sInvoiceDateBegin.length() > 0){
                sSql+= " OC_PATIENTINVOICE_DATE >= ? AND";
            }

            if(sInvoiceDateEnd.length() > 0){
                sSql+= " OC_PATIENTINVOICE_DATE <= ? AND";
            }

            if(sInvoiceNr.length() > 0){
            	if(sInvoiceNr.contains(".")){
            		sSql+= " OC_PATIENTINVOICE_NUMBER = ? AND";
            		
            	}
            	else {
            		sSql+= " (OC_PATIENTINVOICE_NUMBER = '"+sInvoiceNr+"' OR OC_PATIENTINVOICE_OBJECTID = ?) AND";
            	}
            }

            // balance range
            if(sInvoiceBalanceMin.length() > 0 && sInvoiceBalanceMax.length() > 0){
                sSql+= " (OC_PATIENTINVOICE_BALANCE >= ? AND OC_PATIENTINVOICE_BALANCE < ?) AND";
            }
            else if(sInvoiceBalanceMin.length() > 0){
                sSql+= " OC_PATIENTINVOICE_BALANCE >= ? AND";
            }
            else if(sInvoiceBalanceMax.length() > 0){
                sSql+= " OC_PATIENTINVOICE_BALANCE =< ? AND";
            }
            // remove last AND
            if(sSql.endsWith("AND")){
                sSql = sSql.substring(0,sSql.length()-3);
            }

            sSql+= " ORDER BY OC_PATIENTINVOICE_DATE DESC";

            ps = oc_conn.prepareStatement(sSql);

            // set question marks
            int qmIdx = 1;
            if(sInvoiceDateBegin.length() > 0) ps.setDate(qmIdx++,ScreenHelper.getSQLDate(sInvoiceDateBegin));
            if(sInvoiceDateEnd.length() > 0) ps.setDate(qmIdx++,ScreenHelper.getSQLDate(sInvoiceDateEnd));
            if(sInvoiceNr.length() > 0){
            	if(sInvoiceNr.contains(".")){
            		ps.setString(qmIdx++,sInvoiceNr);
            	}
            	else {
            		ps.setInt(qmIdx++,Integer.parseInt(sInvoiceNr));
            	}
            }
            if(sInvoiceBalanceMin.length() > 0) ps.setDouble(qmIdx++,Double.parseDouble(sInvoiceBalanceMin));
            if(sInvoiceBalanceMax.length() > 0) ps.setDouble(qmIdx,Double.parseDouble(sInvoiceBalanceMax));

            rs = ps.executeQuery();

            PatientInvoice patientInvoice;
            while(rs.next()){
                patientInvoice = new PatientInvoice();

                patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
                patientInvoice.setDate(rs.getTimestamp("OC_PATIENTINVOICE_DATE"));
                patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));
                patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));

                invoices.add(patientInvoice);
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return invoices;
    }

    public static Vector searchInvoicesByStatusAndBalance(String sInvoiceDateBegin, String sInvoiceDateEnd, String sInvoiceStatus, String sInvoiceBalanceMin){
        Vector invoices = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            // compose query
            String sSql = "SELECT * FROM OC_PATIENTINVOICES WHERE";

            if(sInvoiceDateBegin.length() > 0){
                sSql+= " OC_PATIENTINVOICE_DATE >= ? AND";
            }

            if(sInvoiceDateEnd.length() > 0){
                sSql+= " OC_PATIENTINVOICE_DATE <= ? AND";
            }

            if(sInvoiceStatus.length() > 0){
                sSql+= " OC_PATIENTINVOICE_STATUS = ? AND";
            }

            // balance range
            if(sInvoiceBalanceMin.length() > 0){
                sSql+= " OC_PATIENTINVOICE_BALANCE >= ? AND";
            }
            // remove last AND
            if(sSql.endsWith("AND")){
                sSql = sSql.substring(0,sSql.length()-3);
            }

            sSql+= " ORDER BY OC_PATIENTINVOICE_UPDATEUID,OC_PATIENTINVOICE_DATE";

            ps = oc_conn.prepareStatement(sSql);

            // set question marks
            int qmIdx = 1;
            if(sInvoiceDateBegin.length() > 0) ps.setDate(qmIdx++,ScreenHelper.getSQLDate(sInvoiceDateBegin));
            if(sInvoiceDateEnd.length() > 0) ps.setDate(qmIdx++,ScreenHelper.getSQLDate(sInvoiceDateEnd));
            if(sInvoiceStatus.length() > 0) ps.setString(qmIdx++,sInvoiceStatus);
            if(sInvoiceBalanceMin.length() > 0) ps.setDouble(qmIdx++,Double.parseDouble(sInvoiceBalanceMin));

            rs = ps.executeQuery();

            while(rs.next()){
                invoices.add(PatientInvoice.get(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID")));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return invoices;
    }

    //--- GET TOTAL BALANCE FOR PATIENT -----------------------------------------------------------
    public static double getTotalBalanceForPatient(String sInvoicePatientUid){
        return getTotalBalanceForPatient(sInvoicePatientUid,"","","");
    }

    public static double getTotalBalanceForPatient(String sInvoicePatientUid, String sInvoiceDateFrom, String sInvoiceDateTo){
        return getTotalBalanceForPatient(sInvoicePatientUid,sInvoiceDateFrom,sInvoiceDateTo,"");
    }

    public static double getTotalBalanceForPatient(String sInvoicePatientUid, String sInvoiceDateFrom, String sInvoiceDateTo, String sInvoiceStatus){
        PreparedStatement ps = null;
        ResultSet rs = null;
        double totalBalance = 0;

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{                      
            // compose query
            String sSql = "SELECT OC_PATIENTINVOICE_BALANCE FROM OC_PATIENTINVOICES";

            if(sInvoicePatientUid.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_PATIENTUID = ? AND";
            }
            if(sInvoiceDateFrom.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_DATE = ? AND";
            }
            if(sInvoiceDateTo.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_DATE = ? AND";
            }
            if(sInvoiceStatus.length() > 0){
                if(sSql.indexOf("WHERE")<0) sSql+= " WHERE";
                sSql+= " OC_PATIENTINVOICE_STATUS = ? AND";
            }

            // remove last AND
            if(sSql.endsWith("AND")){
                sSql = sSql.substring(0,sSql.length()-3);
            }

            ps = oc_conn.prepareStatement(sSql);

            // set question marks
            int qmIdx = 1;
            SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
            if(sInvoicePatientUid.length() > 0) ps.setString(qmIdx++,sInvoicePatientUid);
            if(sInvoiceDateFrom.length() > 0) ps.setDate(qmIdx++,new java.sql.Date(ScreenHelper.parseDate(sInvoiceDateFrom).getTime()));
            if(sInvoiceDateTo.length() > 0) ps.setDate(qmIdx++,new java.sql.Date(ScreenHelper.parseDate(sInvoiceDateTo).getTime()));
            if(sInvoiceStatus.length() > 0) ps.setString(qmIdx,sInvoiceStatus);

            rs = ps.executeQuery();

            while(rs.next()){
                totalBalance+= rs.getDouble("OC_PATIENTINVOICE_BALANCE");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return totalBalance;
    }
    
    public boolean hasPrestationClass(String s) {
    	boolean bResult = false;
    	if(debets!=null) {
    		for(int n=0;n<debets.size();n++) {
    			Debet debet = (Debet)debets.elementAt(n);
    			if(debet.getPrestation()!=null && debet.getPrestation().getPrestationClass().equalsIgnoreCase(s)) {
    				return true;
    			}
    		}
    	}
    	return bResult;
    }

    public boolean hasPrestationType(String s) {
    	boolean bResult = false;
    	if(debets!=null) {
    		for(int n=0;n<debets.size();n++) {
    			Debet debet = (Debet)debets.elementAt(n);
    			if(debet.getPrestation()!=null && debet.getPrestation().getType().equalsIgnoreCase(s)) {
    				return true;
    			}
    		}
    	}
    	return bResult;
    }

    public boolean hasPrestationCostCenter(String s) {
    	boolean bResult = false;
    	if(debets!=null) {
    		for(int n=0;n<debets.size();n++) {
    			Debet debet = (Debet)debets.elementAt(n);
    			if(debet.getPrestation()!=null && debet.getPrestation().getCostCenter().equalsIgnoreCase(s)) {
    				return true;
    			}
    		}
    	}
    	return bResult;
    }

    public boolean hasPrestationInvoiceGroup(String s) {
    	boolean bResult = false;
    	if(debets!=null) {
    		for(int n=0;n<debets.size();n++) {
    			Debet debet = (Debet)debets.elementAt(n);
    			if(debet.getPrestation()!=null && debet.getPrestation().getInvoiceGroup().equalsIgnoreCase(s)) {
    				return true;
    			}
    		}
    	}
    	return bResult;
    }

    public boolean hasPrestationFamily(String s) {
    	boolean bResult = false;
    	if(debets!=null) {
    		for(int n=0;n<debets.size();n++) {
    			Debet debet = (Debet)debets.elementAt(n);
    			if(debet.getPrestation()!=null && debet.getPrestation().getReferenceObject()!=null && debet.getPrestation().getReferenceObject().getObjectType().equalsIgnoreCase(s)) {
    				return true;
    			}
    		}
    	}
    	return bResult;
    }

    //--- GET PATIENT INVOICES ------------------------------------------------------------------- 
    public static Vector getPatientInvoices(String sPatientUid){
        return getPatientInvoicesWhereDifferentStatus(sPatientUid,"");    	
    }

    //--- GET PATIENT INVOICES WHERE DIFFERENT STATUS --------------------------------------------- 
    public static Vector getPatientInvoicesWhereDifferentStatus(String sPatientUid, String sStatus){
        Vector vPatientInvoices = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect = "";

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT * FROM OC_PATIENTINVOICES"+
                      " WHERE OC_PATIENTINVOICE_PATIENTUID = ?";
            if(sStatus.length() > 0){
                sSelect+= " AND OC_PATIENTINVOICE_STATUS NOT IN ("+sStatus+")";
            }
            sSelect+= " ORDER BY OC_PATIENTINVOICE_DATE ASC"; // reversed
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sPatientUid);

            rs = ps.executeQuery();
            PatientInvoice patientInvoice;
            while(rs.next()){
                patientInvoice = new PatientInvoice();

                patientInvoice.setUid(rs.getInt("OC_PATIENTINVOICE_SERVERID")+"."+rs.getInt("OC_PATIENTINVOICE_OBJECTID"));
                patientInvoice.setDate(rs.getDate("OC_PATIENTINVOICE_DATE"));
                patientInvoice.setInvoiceUid(rs.getInt("OC_PATIENTINVOICE_ID")+"");
                patientInvoice.setPatientUid(rs.getString("OC_PATIENTINVOICE_PATIENTUID"));
                patientInvoice.setCreateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_CREATETIME"));
                patientInvoice.setUpdateDateTime(rs.getTimestamp("OC_PATIENTINVOICE_UPDATETIME"));
                patientInvoice.setUpdateUser(rs.getString("OC_PATIENTINVOICE_UPDATEUID"));
                patientInvoice.setVersion(rs.getInt("OC_PATIENTINVOICE_VERSION"));
                patientInvoice.setBalance(rs.getDouble("OC_PATIENTINVOICE_BALANCE"));
                patientInvoice.setStatus(rs.getString("OC_PATIENTINVOICE_STATUS"));
                patientInvoice.setNumber(rs.getString("OC_PATIENTINVOICE_NUMBER"));
                patientInvoice.setInsurarreference(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCE"));
                patientInvoice.setInsurarreferenceDate(rs.getString("OC_PATIENTINVOICE_INSURARREFERENCEDATE"));
                patientInvoice.setAcceptationUid(rs.getString("OC_PATIENTINVOICE_ACCEPTATIONUID"));
                patientInvoice.setVerifier(rs.getString("OC_PATIENTINVOICE_VERIFIER"));
                patientInvoice.setComment(rs.getString("OC_PATIENTINVOICE_COMMENT"));
                patientInvoice.setModifiers(rs.getString("OC_PATIENTINVOICE_MODIFIERS"));

                vPatientInvoices.add(patientInvoice);
            }
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => getPatientInvoicesWhereDifferentStatus => "+e.getMessage()+" = "+sSelect);
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }

        return vPatientInvoices;
    }
    
    public String getInsuranceUid(){
    	String insuranceuid="";
    	for(int n=0;n<getDebets().size();n++){
    		Debet debet = (Debet)getDebets().elementAt(n);
    		if(debet!=null && debet.getInsuranceUid()!=null && debet.getInsuranceUid().length()>0){
    			return debet.getInsuranceUid();
    		}
    	}
    	return insuranceuid;
    }
    
    //--- SET STATUS OPEN -------------------------------------------------------------------------
    public static boolean setStatusOpen(String sInvoiceID, String UserId){
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean okQuery = false;
        
        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "update OC_PATIENTINVOICES SET OC_PATIENTINVOICE_STATUS ='open',"+
                             "  OC_PATIENTINVOICE_UPDATETIME=?, OC_PATIENTINVOICE_UPDATEUID=?"+
            		         " WHERE OC_PATIENTINVOICE_OBJECTID = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setTimestamp(1,new Timestamp(new java.util.Date().getTime())); // now
            ps.setString(2,UserId);
            ps.setInt(3,Integer.parseInt(sInvoiceID));

            okQuery = (ps.executeUpdate()>0);
        }
        catch(Exception e){
            Debug.println("OpenClinic => PatientInvoice.java => setStatusOpen => "+e.getMessage());
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null)rs.close();
                if(ps!=null)ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
        
        return okQuery;
    }
      
}
