package be.openclinic.finance;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.common.OC_Object;

import java.util.HashSet;
import java.util.Vector;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.Iterator;

import net.admin.Service;
import net.admin.User;

public class Invoice extends OC_Object {
    protected String invoiceUid;
    protected java.util.Date date;
    protected Vector debets;
    protected Vector credits;
    protected String status;
    protected double balance;
    protected String verifier;

    protected static SimpleDateFormat stdDateFormat = ScreenHelper.stdDateFormat;
    protected static SimpleDateFormat fullDateFormat = ScreenHelper.fullDateFormat;
    

	//--- SETTERS & GETTERS -----------------------------------------------------------------------
    public String getInvoiceUid() {
        return invoiceUid;
    }

    public String getVerifier() {
		return verifier;
	}

	public void setVerifier(String verifier) {
		this.verifier = verifier;
	}

	public void setInvoiceUid(String invoiceUid) {
        this.invoiceUid = invoiceUid;
    }

    public java.util.Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Vector getDebets() {
        return debets;
    }

    public Vector getDebetsForInsurance(String sInsuranceUid) {
        Vector d = new Vector();
        for(int n=0;n<getDebets().size();n++){
            Debet debet = (Debet)getDebets().elementAt(n);
            if(debet!=null && sInsuranceUid.equalsIgnoreCase(debet.getInsuranceUid())){
                d.add(debet);
            }
        }
        return d;
    }

    public void setDebets(Vector debets) {
        this.debets = debets;
    }

    public Vector getCredits() {
        return credits;
    }

    public void setCredits(Vector credits) {
        this.credits = credits;
    }

    public String getStatus() {
       return status;
   }

   public void setStatus(String status) {
       this.status = status;
   }

   public double getBalance() {
       if(balance==1){
           return 0;
       }
       return balance;
   }

   public void setBalance(double balance) {
       this.balance = balance;
   }

   public HashSet getServices(){
	   HashSet services = new HashSet();
	   for(int n=0;n<debets.size();n++){
		   Debet debet = (Debet)debets.elementAt(n);
		   if(ScreenHelper.checkString(debet.getServiceUid()).length()>0){
			   services.add(debet.getServiceUid());
		   }
	   }
	   return services;
   }
   
   public String getServicesAsString(String language){
	   String service=Pointer.getPointer("INV.SVC."+this.getUid());
	   if(service.length()==0) {
		   try{
			   HashSet services = new HashSet();
			   for(int n=0;n<debets.size();n++){
				   Debet debet = (Debet)debets.elementAt(n);
				   if(ScreenHelper.checkString(debet.getServiceUid()).length()>0){
					   services.add(debet.getServiceUid());
				   }
				   else if(debet.getEncounter()!=null && ScreenHelper.checkString(debet.getEncounter().getServiceUID()).length()>0){
					   services.add(debet.getEncounter().getServiceUID());
				   }
			   }
			   Iterator hs = services.iterator();
			   while(hs.hasNext()){
				   if(service.length()>0){
					   service+=", ";
				   }
				   service+=ScreenHelper.getTran(null,"service", (String)hs.next(), language);
			   }
		   }
		   catch(Exception e){
			   e.printStackTrace();
		   }
	   }
	   else {
		   service = ScreenHelper.getTran("service", service, language);
	   }
	   return service;
   }
   
   public String getCliniciansAsString(){
	   String clinician="";
	   try{
		   HashSet clinicians = new HashSet();
		   for(int n=0;n<debets.size();n++){
			   Debet debet = (Debet)debets.elementAt(n);
			   if(ScreenHelper.checkString(debet.getPerformeruid()).length()>0){
				   clinicians.add(debet.getPerformeruid());
			   }
		   }
		   Iterator hs = clinicians.iterator();
		   while(hs.hasNext()){
			   if(clinician.length()>0){
				   clinician+=", ";
			   }
			   clinician+=User.getFullUserName((String)hs.next());
		   }
	   }
	   catch(Exception e){
		   e.printStackTrace();
	   }
	   return clinician;
   }
   
   public String getServicesAsString(Vector debets, String language){
	   String service="";
	   HashSet invoices = new HashSet();
	   HashSet services = new HashSet();
	   for(int n=0;n<debets.size();n++){
		   Debet debet = (Debet)debets.elementAt(n);
		   if(ScreenHelper.checkString(debet.getServiceUid()).length()>0){
			   services.add(debet.getServiceUid());
		   }
		   if(ScreenHelper.checkString(debet.getPatientInvoiceUid()).length()>0){
			   invoices.add(debet.getPatientInvoiceUid());
		   }
	   }
	   Iterator iInvoices = invoices.iterator();
	   while(iInvoices.hasNext()) {
		   String s =Pointer.getPointer("INV.SVC."+iInvoices.next());
		   if(s.length()>0) {
			   if(service.length()>0){
				   service+=", ";
			   }
			   service+=ScreenHelper.getTran(null,"service", s, language);
		   }
	   }
	   if(service.length()==0) {
		   Iterator hs = services.iterator();
		   while(hs.hasNext()){
			   if(service.length()>0){
				   service+=", ";
			   }
			   service+=ScreenHelper.getTran(null,"service", (String)hs.next(), language);
		   }
	   }
	   return service;
   }
   
   public Vector getDebetsForServiceUid(String serviceUid){
	   Vector serviceDebets = new Vector();
	   for(int n=0;n<debets.size();n++){
		   Debet debet = (Debet)debets.elementAt(n);
		   if(ScreenHelper.checkString(debet.getServiceUid()).equalsIgnoreCase(serviceUid)){
			   serviceDebets.add(debet);
		   }
	   }
	   return serviceDebets;
   }
   
   public String getInvoiceNumberCounter(String invoiceType){
	   String s=null;
	   String sPrefix="";
	   try{
		   invoiceType=MedwanQuery.getInstance().getConfigString(invoiceType+"Type",invoiceType);
		   //First find the resetDate
		   java.util.Date dResetDate=ScreenHelper.getSQLDate(MedwanQuery.getInstance().getConfigString(invoiceType+"ResetDate",""));
		   if(dResetDate!=null){
			   dResetDate=ScreenHelper.getSQLDate(new SimpleDateFormat("dd/MM/").format(dResetDate)+new SimpleDateFormat("yyyy").format(this.getDate()));
			   if(this.getDate().before(dResetDate)){
				   sPrefix=(Integer.parseInt(new SimpleDateFormat("yyyy").format(this.getDate()))-1)+"";
			   }
			   else {
				   sPrefix=new SimpleDateFormat("yyyy").format(this.getDate());
			   }
			   //Now find the appropriate counter for this invoice
			   s = MedwanQuery.getInstance().getOpenclinicCounter(sPrefix+"."+invoiceType)+"";
			   if(MedwanQuery.getInstance().getConfigInt(invoiceType+"AddPrefix",1)==1){
				   s=sPrefix+"."+s;
			   }
		   }
	   }
	   catch(Exception e){
		   e.printStackTrace();
	   }
	   return s;
   }
   
   public static String getInvoiceNumberCounterNoIncrement(String invoiceType){
	   String s="-1";
	   String sPrefix="";
	   try{
		   invoiceType=MedwanQuery.getInstance().getConfigString(invoiceType+"Type",invoiceType);
		   //First find the resetDate
		   java.util.Date dResetDate=ScreenHelper.getSQLDate(MedwanQuery.getInstance().getConfigString(invoiceType+"ResetDate",""));
		   if(dResetDate!=null){
			   dResetDate=ScreenHelper.getSQLDate(new SimpleDateFormat("dd/MM/").format(dResetDate)+new SimpleDateFormat("yyyy").format(new java.util.Date()));
			   if(new java.util.Date().before(dResetDate)){
				   sPrefix=(Integer.parseInt(new SimpleDateFormat("yyyy").format(new java.util.Date()))-1)+"";
			   }
			   else {
				   sPrefix=new SimpleDateFormat("yyyy").format(new java.util.Date());
			   }
			   //Now find the appropriate counter for this invoice
			   s = MedwanQuery.getInstance().getOpenclinicCounterNoIncrement(sPrefix+"."+invoiceType)+"";
			   if(MedwanQuery.getInstance().getConfigInt(invoiceType+"AddPrefix",1)==1){
				   s=sPrefix+"."+s;
			   }
		   }
		   else{
			   s = MedwanQuery.getInstance().getOpenclinicCounterNoIncrement(invoiceType)+"";
		   }
	   }
	   catch(Exception e){
		   e.printStackTrace();
	   }
	   if(s.indexOf("-1")>-1){
		   s="";
	   }
	   return s;
   }
   
}
