package be.openclinic.finance;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;

public class CsvInvoiceCMCK {
    static DecimalFormat priceFormatInsurar = new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatInsurar","#,##0.00"));

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
		String sOutput="ADHERENT;FACTURES;NUMERO_BC;BENEFICIAIRE;DATE;CLASSE;ACTE;QUANTITE;PRIX_UNITAIRE;TOTAL;ASSUREUR;PATIENT;\r\n";
		if(invoiceuid!=null){
			try{
				Vector debets = new Vector();
	            for(int n=0;n<invoice.getDebets().size();n++){
	            	Debet debet = (Debet)invoice.getDebets().elementAt(n);
	            	if(debet!=null && debet.getEncounter()!=null && debet.getCredited()==0){
	           			debets.addElement(debet);
	            	}
	            }
	            Date begin = new Date();
	            Date end = ScreenHelper.stdDateFormat.parse("01/01/1900");
	            SortedMap invoices = new TreeMap();
	            Hashtable bcinvoices=new Hashtable();
	            String uid;
	            for(int n=0;n<debets.size();n++){
	            	Debet debet = (Debet)debets.elementAt(n);
	            	if(debet.getDate().after(end)){
	            		end=debet.getDate();
	            	}
	            	if(debet.getDate().before(begin)){
	            		begin=debet.getDate();
	            	}
	            	//Invoicekey
	            	String invoicekey="?",invoicenumber="?",insurarreference="?",invoicedate="?";
	            	if(debet.getPatientInvoiceUid()!=null){
	        			PatientInvoice inv = PatientInvoice.get(debet.getPatientInvoiceUid());
	        			if(inv!=null && inv.getUid()!=null && inv.getUid().equalsIgnoreCase(debet.getPatientInvoiceUid())){
	        				invoicedate=ScreenHelper.formatDate(debet.getDate());
	        				invoicenumber=ScreenHelper.checkString(inv.getInvoiceNumber());
	        				insurarreference=ScreenHelper.checkString(inv.getInsurarreference());
	        			}
	            	}
	            	
	            	//Adherent
	            	String adherentkey="?";
	            	if(debet.getInsurance()!=null && ScreenHelper.checkString(debet.getInsurance().getMember()).length()>0){
	            		adherentkey=debet.getInsurance().getMember();
	            	}
	
	            	if(bcinvoices.get(insurarreference+";"+adherentkey)==null){
	            		bcinvoices.put(insurarreference+";"+adherentkey,new HashSet());
	            	}
	
	            	((HashSet)bcinvoices.get(insurarreference+";"+adherentkey)).add(invoicenumber);
	            	//Beneficiaries
	            	String beneficiarykey="?";
	            	if(debet.getEncounter()!=null && debet.getEncounter().getPatient()!=null){
	            		beneficiarykey=debet.getEncounter().getPatient().firstname+" "+debet.getEncounter().getPatient().lastname;
	            	}
	
	            	//PrestationClass
	            	String prestationclasskey="?";
	            	if(debet.getPrestation()!=null && debet.getPrestation().getPrestationClass()!=null){
	            		prestationclasskey=debet.getPrestation().getPrestationClass();
	            	}
	            	if(prestationclasskey==null || prestationclasskey.length()==0){
	            		prestationclasskey="?";
	            	}
	            	
	            	invoicekey=insurarreference+";"+adherentkey+";"+beneficiarykey+";"+prestationclasskey.toLowerCase()+";"+invoicedate+";"+debet.getUid();
	            	
	            	invoices.put(invoicekey, debet);
	           	}
				Iterator iInvoices = invoices.keySet().iterator();
				while(iInvoices.hasNext()){
					String invoicekey = (String)iInvoices.next();
					Debet debet = (Debet)invoices.get(invoicekey);
					String bc=invoicekey.split(";")[0]+";"+(invoicekey.split(";").length<2?"?":invoicekey.split(";")[1]);
					sOutput+=invoicekey.split(";").length<2?"?":invoicekey.split(";")[1]+";";
					String invoicenumbers="";
					HashSet set = (HashSet)bcinvoices.get(bc);
					if(set!=null){
						Iterator iSet=set.iterator();
						while(iSet.hasNext()){
							if(invoicenumbers.length()>0){
								invoicenumbers+=", ";
							}
							invoicenumbers+=(String)iSet.next();
						}
					}
					sOutput+=invoicenumbers+";";
					sOutput+=invoicekey.split(";")[0]+";";
					String beneficiary=invoicekey.split(";").length<3?"?":invoicekey.split(";")[2];
					sOutput+=beneficiary+";";
					String invoicedate=invoicekey.split(";").length<5?"?":invoicekey.split(";")[4];
					sOutput+=invoicedate+";";
					String prestationclass=invoicekey.split(";").length<4?"?":invoicekey.split(";")[3];
					sOutput+=ScreenHelper.getTranNoLink("prestation.class",prestationclass,(String)request.getSession().getAttribute("WebLanguage"))+";";
					sOutput+=debet.getPrestation().getDescription()+";";
					sOutput+=new Double(debet.getQuantity()).intValue()+";";
					sOutput+=ScreenHelper.getPriceFormat((debet.getAmount()+debet.getInsurarAmount()+debet.getExtraInsurarAmount())/debet.getQuantity())+";";
					sOutput+=ScreenHelper.getPriceFormat(debet.getInsurarAmount()+debet.getAmount())+";";
					sOutput+=ScreenHelper.getPriceFormat(debet.getInsurarAmount())+";";
					sOutput+=ScreenHelper.getPriceFormat(debet.getAmount())+";\r\n";
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return sOutput;
	}
}
