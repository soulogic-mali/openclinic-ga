package be.openclinic.finance;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Locale;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import net.admin.Service;
import net.admin.User;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

import com.itextpdf.text.pdf.PdfPTable;

public class CsvInvoiceMFPAdmissions {
    static DecimalFormat priceFormatInsurar = new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatInsurarCsv","#,##0.00"),new DecimalFormatSymbols(Locale.getDefault()));

	public static String getOutput(javax.servlet.http.HttpServletRequest request){
		double pageTotalAmount=0,pageTotalAmount85=0,pageTotalAmount100=0;
		String invoiceuid=request.getParameter("invoiceuid");
        int coverage=85;
		InsurarInvoice invoice = InsurarInvoice.get(invoiceuid);
		if(invoice!=null){
			Insurar insurar=invoice.getInsurar();
	        if(insurar!=null && insurar.getInsuraceCategories()!=null && insurar.getInsuraceCategories().size()>0){
	        	try{
	        		coverage=100-Integer.parseInt(((InsuranceCategory)insurar.getInsuraceCategories().elementAt(0)).getPatientShare());
	        	}
	        	catch(Exception e){
	        		e.printStackTrace();
	        	}
	        }
		}
		String sOutput="";
		if(invoiceuid!=null){
            sOutput+="\r\n\r\n"+ScreenHelper.getTran(null,"hospital.statistics", "visits", "fr");
            sOutput+="\r\n#;FACTURE;NOM ET PRENOM ADHERENT;MATRICULE;PROVENANCE;BENEFICIAIRE;MONTANT TOTAL;MONTANT RECLAME;DATE;No ADMISSION;SERVICE;VALIDE_PAR\r\n";
	        int linecounter=1;
	        double total100pct=0, totalInsurer=0, amount100pct=0, amountInsurer=0;
	        String activePatientInvoiceUid="",sInvoiceUid="",sImmat="",sOrigin="",sPatientName="",sBeneficiary="",sInvoiceDate="", sAdmission="", sService="", sValidatedBy="", sComment="";
	        HashSet patientInvoices = new HashSet();
            Vector debets = InsurarInvoice.getDebetsForInvoiceSortByPatientInvoiceUid(invoiceuid);
	        for(int n=0;n<debets.size();n++) {
	        	Debet debet = (Debet)debets.elementAt(n);
	        	if(patientInvoices.contains(debet.getPatientInvoiceUid())) {
	        		amount100pct+=debet.getAmount()+debet.getExtraInsurarAmount();
	        		total100pct+=debet.getAmount()+debet.getExtraInsurarAmount();
	        		amountInsurer+=debet.getInsurarAmount();
	        		totalInsurer+=debet.getInsurarAmount();
	        	}
	        	else {
	        		if(n>0) {
	        			//Print the invoice
	        			sOutput+=(linecounter++)+";";
	        			sOutput+=sInvoiceUid+";";
	        			sOutput+=sPatientName+";";
	        			sOutput+=sImmat+";";
	        			sOutput+=sOrigin+";";
	        			sOutput+=sBeneficiary+";";
	        			sOutput+=amount100pct+";";
	        			sOutput+=amountInsurer+";";
	        			sOutput+=sInvoiceDate+";";
	        			sOutput+=sAdmission+";";
	        			sOutput+=sService+";";
	        			sOutput+=sValidatedBy+";";
	        			sOutput+=sComment+";";
	        			sOutput+="\r\n";
	        		}
	        		//Set new invoice base data
	        		PatientInvoice patientInvoice = PatientInvoice.get(debet.getPatientInvoiceUid());
	        		patientInvoices.add(debet.getPatientInvoiceUid());
	        		sInvoiceUid=debet.getPatientInvoiceUid().split("\\.")[1];
	        		sPatientName=debet.getPatientName();
	        		Insurance insurance =debet.getInsurance();
	        		sInvoiceDate=ScreenHelper.formatDate(patientInvoice.getDate());
	        		if(insurance!=null) {
		        		sImmat=insurance.getMemberImmat();
		        		sOrigin=insurance.getMemberEmployer();
		        		sBeneficiary=insurance.getInsuranceNr();
	        		}
	        		sAdmission=debet.getEncounter().getPatientUID();
	        		sService=patientInvoice.getServicesAsString("fr");
	        		sValidatedBy=User.getFullUserName(patientInvoice.getAcceptationUid());
	        		sComment=patientInvoice.getComment();
	        		//Reset amounts
	        		amount100pct=debet.getAmount()+debet.getExtraInsurarAmount();
	        		total100pct+=debet.getAmount()+debet.getExtraInsurarAmount();
	        		amountInsurer=debet.getInsurarAmount();
	        		totalInsurer+=debet.getInsurarAmount();
	        	}
	        }	
    		if(debets.size()>0) {
    			//Print last debet of the invoice
    			sOutput+=(linecounter++)+";";
    			sOutput+=sInvoiceUid+";";
    			sOutput+=sPatientName+";";
    			sOutput+=sImmat+";";
    			sOutput+=sOrigin+";";
    			sOutput+=sBeneficiary+";";
    			sOutput+=amount100pct+";";
    			sOutput+=amountInsurer+";";
    			sOutput+=sInvoiceDate+";";
    			sOutput+=sAdmission+";";
    			sOutput+=sService+";";
    			sOutput+=sValidatedBy+";";
    			sOutput+=sComment+";";
    			sOutput+="\r\n";
    			//Print totals of the invoice
    			sOutput+=";";
    			sOutput+=ScreenHelper.getTran(null,"web", "total", "fr")+";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=total100pct+";";
    			sOutput+=totalInsurer+";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+=";";
    			sOutput+="\r\n";
    		}
		}
		return sOutput;
	}
	
    //--- PRINT DEBET (prestation) ----------------------------------------------------------------
    private static String printDebet2(SortedMap categories, boolean displayDate, Date date, String invoiceid,String adherent,String beneficiary,double total100pct,double total85pct,String recordnumber,int linecounter,String insurarreference,String beneficiarynr,String beneficiaryage,String beneficiarysex,String affiliatecompany){
    	String sOutput="";
        sOutput+=linecounter+";";
        sOutput+=ScreenHelper.stdDateFormat.format(date)+";";
        sOutput+=insurarreference+";";
        sOutput+=invoiceid+";";
        sOutput+=beneficiarynr+";";
        sOutput+=beneficiaryage+";";
        sOutput+=beneficiarysex+";";
        sOutput+=beneficiary+";";
        sOutput+=adherent+";";
        sOutput+=affiliatecompany+";";
        String amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAconsultationCategory","Co"));
        sOutput+=amount==null?"0;":amount+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAlabCategory","L"));
        sOutput+=amount==null?"0;":amount+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAimagingCategory","R"));
        sOutput+=amount==null?"0;":amount+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAadmissionCategory","S"));
        sOutput+=amount==null?"0;":amount+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAactsCategory","A"));
        sOutput+=amount==null?"0;":amount+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAconsumablesCategory","C"));
        sOutput+=amount==null?"0;":amount+";";
        String otherprice="+0";
        String allcats=	"*"+MedwanQuery.getInstance().getConfigString("RAMAconsultationCategory","Co")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAlabCategory","L")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAimagingCategory","R")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAadmissionCategory","S")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAactsCategory","A")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAconsumablesCategory","C")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAdrugsCategory","M")+"*";
        Iterator iterator = categories.keySet().iterator();
        while (iterator.hasNext()){
        	String cat = (String)iterator.next();
        	if(allcats.indexOf("*"+cat+"*")<0 && ((String)categories.get(cat)).length()>0){
        		otherprice+="+"+(String)categories.get(cat);
        	}
        }
        sOutput+=otherprice+";";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAdrugsCategory","M"));
        sOutput+=amount==null?"0;":amount+";";
        sOutput+=priceFormatInsurar.format(total100pct)+";";
        sOutput+=priceFormatInsurar.format(total85pct)+"\r\n";
        return sOutput;
    }

}
