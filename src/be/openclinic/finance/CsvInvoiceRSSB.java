package be.openclinic.finance;

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Locale;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import javax.servlet.ServletOutputStream;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.system.SH;
import net.admin.AdminPerson;

import com.itextpdf.text.pdf.PdfPTable;

public class CsvInvoiceRSSB {
	public static String getOutput(javax.servlet.http.HttpServletRequest request, ServletOutputStream os){
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
		StringBuffer sOutput = new StringBuffer();
		sOutput.append("#;DATE;VOUCHER_ID;INVOICE_ID;BENEFICIARY_CATEGORY;BENEFICIARY_NR;BENEFICIARY_AGE;BENEFICIARY_SEX;BENEFICIARY_NAME;AFFILIATE_NAME;FAMILY_CODE;AFFILIATE_AFFECT;CONS;LAB;IMA;HOS;PRO;AMB;OTH;MED;TOT 100%;TOT PATIENT;TOT "+coverage+"%\r\n");
		if(invoiceuid!=null){
			Debug.println("Getting debets...");
	        Vector debets = InsurarInvoice.getDebetsForInvoiceSortByDate(invoiceuid);
			Debug.println("Found "+debets.size()+" debets");
	        if(debets.size() > 0){
	            // print debets
	            Debet debet;
	            String sPatientName="", sPrevPatientName = "",sPreviousInvoiceUID="",beneficiarynr="",beneficiaryage="",beneficiarysex="",affiliatecompany="", beneficiarycategory="",familycode="";
	            Date date=null,prevdate=null;
	            boolean displayPatientName=false,displayDate=false;
	            SortedMap categories = new TreeMap(), totalcategories = new TreeMap();
	            double total100pct=0,total85pct=0,generaltotal100pct=0,generaltotal85pct=0,daytotal100pct=0,daytotal85pct=0;
	            String invoiceid="",adherent="",recordnumber="",insurarreference="";
	            int linecounter=1,counter=1;
	            for(int i=0; i<debets.size(); i++){
	            	Debug.println(i);
	                debet = (Debet)debets.get(i);
	                date = ScreenHelper.parseDate(SH.formatDate(debet.getDate()));
	                displayDate = !date.equals(prevdate);
	                sPatientName = debet.getPatientName()+";"+debet.getEncounter().getPatientUID();
	                displayPatientName = displayDate || !sPatientName.equals(sPrevPatientName) || (debet.getPatientInvoiceUid()!=null && debet.getPatientInvoiceUid().indexOf(".")>=0 && invoiceid.indexOf(debet.getPatientInvoiceUid().split("\\.")[1])<0 && invoiceid.length()>0);
	                if(i>0 && (displayDate || displayPatientName)){
	                    sOutput.append(printDebet2(categories,displayDate,prevdate!=null?prevdate:date,invoiceid,adherent,sPrevPatientName.split(";")[0],total100pct,total85pct,recordnumber,linecounter++,insurarreference,beneficiarynr,beneficiaryage,beneficiarysex,affiliatecompany,beneficiarycategory,familycode));
	                	categories = new TreeMap();
	                	total100pct=0;
	                	total85pct=0;
	                	if(displayDate){
	                		daytotal100pct=0;
	                		daytotal85pct=0;
	                	}
	                	invoiceid="";
	                	adherent="";
	                	recordnumber="";
	                	insurarreference="";
	                	beneficiarynr="";
	                	beneficiaryage="";
	                	beneficiarysex="";
	                	beneficiarycategory="";
	                	familycode="";
	                	affiliatecompany="";
	                }
                	beneficiarysex=debet.getPatientgender();
               		beneficiaryage=debet.getPatientbirthdate();
	                if(debet.getPatientInvoiceUid()!=null && debet.getPatientInvoiceUid().indexOf(".")>=0 && invoiceid.indexOf(debet.getPatientInvoiceUid().split("\\.")[1])<0){
	                	if(invoiceid.length()>0){
	                		invoiceid+="\n";
	                	}
	                	invoiceid+=debet.getPatientInvoiceUid().split("\\.")[1];
	                	if(insurarreference.equalsIgnoreCase("")){
		                	PatientInvoice patientInvoice = PatientInvoice.get(debet.getPatientInvoiceUid());
		                	if(patientInvoice!=null){
		                		insurarreference=patientInvoice.getInsurarreference();
		                	}
	                	}
	                }
	                if(debet.getInsuranceUid()!=null){
	                	Insurance insurance = Insurance.get(debet.getInsuranceUid());
	                	debet.setInsurance(insurance);
	                	beneficiarynr=insurance.getInsuranceNr();
	                	affiliatecompany=insurance.getMemberEmployer();
	                	beneficiarycategory=insurance.getMembercategory();
	                	familycode=insurance.getFamilycode();
	                	
	                }
	                if(debet.getInsurance()!=null && debet.getInsurance().getMember()!=null && adherent.indexOf(debet.getInsurance().getMember().toUpperCase())<0){
	                	if(adherent.length()>0){
	                		adherent+="\n";
	                	}
	                	adherent+=debet.getInsurance().getMember().toUpperCase();
	                }
	                if(debet.getInsurance()!=null && debet.getInsurance().getInsuranceNr()!=null && recordnumber.indexOf(debet.getInsurance().getInsuranceNr())<0){
	                	if(recordnumber.length()>0){
	                		recordnumber+="\n";
	                	}
	                	recordnumber+=debet.getInsurance().getInsuranceNr();
	                }
	                Prestation prestation = debet.getPrestation();
	                double rAmount = debet.getAmount();
	                double rInsurarAmount = debet.getInsurarAmount();
	                double rExtraInsurarAmount = debet.getExtraInsurarAmount();
	                double rTotal=(double)(rAmount+rInsurarAmount+rExtraInsurarAmount);
	                if(prestation!=null && prestation.getReferenceObject()!=null && prestation.getReferenceObject().getObjectType()!=null && prestation.getReferenceObject().getObjectType().length()>0){
	                	String sCat=prestation.getReferenceObject().getObjectType();
	                    if(categories.get(sCat)==null){
	                        categories.put(sCat,"+"+rTotal);
	                    }
	                    else {
	                        categories.put(sCat,categories.get(sCat)+"+"+rTotal);
	                    }
	                    if(totalcategories.get(sCat)==null){
	                        totalcategories.put(sCat,"+"+rTotal);
	                    }
	                    else {
	                        totalcategories.put(sCat,totalcategories.get(sCat)+"+"+rTotal);
	                    }
	                }
	                else {
	                    if(categories.get("OTHER")==null){
	                        categories.put("OTHER","+"+rTotal);
	                    }
	                    else {
	                        categories.put("OTHER",categories.get("OTHER")+"+"+rTotal);
	                    }
	                    if(totalcategories.get("OTHER")==null){
	                        totalcategories.put("OTHER","+"+rTotal);
	                    }
	                    else {
	                        totalcategories.put("OTHER",totalcategories.get("OTHER")+"+"+rTotal);
	                    }
	                }                
	                total100pct+=rTotal;
	                total85pct+=rInsurarAmount;
	                prevdate = date;
	                sPrevPatientName = sPatientName;
	                if(i%1000==0) {
	                	try {
		                    byte[] b = sOutput.toString().getBytes("ISO-8859-1");
		                    for (int n=0;n<b.length;n++) {
		                        os.write(b[n]);
		                    }
		                    os.flush();
		                    sOutput=new StringBuffer("");
	                	}
	                	catch(Exception e) {
	                		e.printStackTrace();
	                	}
	                }
	            }
                sOutput.append(printDebet2(categories,displayDate,prevdate!=null?prevdate:date,invoiceid,adherent,sPrevPatientName.split(";")[0],total100pct,total85pct,recordnumber,linecounter++,insurarreference,beneficiarynr,beneficiaryage,beneficiarysex,affiliatecompany,beneficiarycategory,familycode));
	        }
		}
		return sOutput.toString();
	}
	
    //--- PRINT DEBET (prestation) ----------------------------------------------------------------
    private static String printDebet2(SortedMap categories, boolean displayDate, Date date, String invoiceid,String adherent,String beneficiary,double total100pct,double total85pct,String recordnumber,int linecounter,String insurarreference,String beneficiarynr,String beneficiaryage,String beneficiarysex,String affiliatecompany,String beneficiarycategory, String familycode){
    	StringBuffer sOutput=new StringBuffer("");
        sOutput.append(linecounter+";");
        sOutput.append(SH.formatDate(date)+";");
        sOutput.append(insurarreference+";");
        sOutput.append(invoiceid+";");
        sOutput.append(beneficiarycategory+";");
        sOutput.append("Nr "+beneficiarynr+";");
        sOutput.append(beneficiaryage+";");
        sOutput.append(beneficiarysex+";");
        sOutput.append(beneficiary+";");
        sOutput.append(adherent+";");
        sOutput.append(familycode+";");
        sOutput.append(affiliatecompany+";");
        String amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAconsultationCategory","Co"));
        sOutput.append(amount==null?"0;":amount+";");
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAlabCategory","L"));
        sOutput.append(amount==null?"0;":amount+";");
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAimagingCategory","R"));
        sOutput.append(amount==null?"0;":amount+";");
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAadmissionCategory","S"));
        sOutput.append(amount==null?"0;":amount+";");
        //Acts and consumables go together
        String acts_cons ="+0";
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAactsCategory","A"));
       	if(amount!=null){
       		acts_cons+="+"+amount;
       	}
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAconsumablesCategory","C"));
       	if(amount!=null){
       		acts_cons+="+"+amount;
       	}
        sOutput.append(acts_cons+";");
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAambulanceCategory","Amb"));
        sOutput.append(amount==null?"0;":amount+";");
        String otherprice="+0";
        String allcats=	"*"+MedwanQuery.getInstance().getConfigString("RAMAconsultationCategory","Co")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAlabCategory","L")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAimagingCategory","R")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAadmissionCategory","S")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAactsCategory","A")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAambulanceCategory","Amb")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAconsumablesCategory","C")+
						"*"+MedwanQuery.getInstance().getConfigString("RAMAdrugsCategory","M")+"*";
        Iterator iterator = categories.keySet().iterator();
        while (iterator.hasNext()){
        	String cat = (String)iterator.next();
        	if(allcats.indexOf("*"+cat+"*")<0 && ((String)categories.get(cat)).length()>0){
        		otherprice+="+"+(String)categories.get(cat);
        	}
        }
        sOutput.append(otherprice+";");
        amount = (String)categories.get(MedwanQuery.getInstance().getConfigString("RAMAdrugsCategory","M"));
        sOutput.append(amount==null?"0;":amount+";");
        DecimalFormat priceFormatInsurar = new DecimalFormat(SH.cs("priceFormatInsurarCsv", "#0.00"),new DecimalFormatSymbols(Locale.getDefault()));
        sOutput.append(priceFormatInsurar.format(total100pct)+";");
        sOutput.append(priceFormatInsurar.format(total100pct-total85pct)+";");
        sOutput.append(priceFormatInsurar.format(total85pct)+"\r\n");
        return sOutput.toString();
    }

}
