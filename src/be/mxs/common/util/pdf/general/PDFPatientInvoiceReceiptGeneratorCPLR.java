package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import java.util.*;
import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.ExportSAP_AR_INV;
import be.openclinic.finance.*;
import be.openclinic.system.SH;
import be.openclinic.adt.Encounter;
import net.admin.*;

import javax.servlet.http.HttpServletRequest;

public class PDFPatientInvoiceReceiptGeneratorCPLR extends PDFInvoiceGenerator {

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFPatientInvoiceReceiptGeneratorCPLR(User user, AdminPerson patient, String sProject, String sPrintLanguage){
        this.user = user;
        this.patient = patient;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String sInvoiceUid) throws Exception {
		// get specified invoice
        PatientInvoice invoice = PatientInvoice.get(sInvoiceUid);
        return generatePDFDocumentBytes(req, invoice);
	}
    
    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, Invoice inv) throws Exception {
    	PatientInvoice invoice = (PatientInvoice)inv;
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

        // reset totals
        this.patientDebetTotal = 0;
        this.insurarDebetTotal = 0;
        this.creditTotal = 0;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
            Rectangle rectangle = new Rectangle(0,0,new Float(MedwanQuery.getInstance().getConfigInt("patientReceiptWidth",720)*72/254).floatValue(),new Float(MedwanQuery.getInstance().getConfigInt("patientReceiptHeight",5000)*72/254).floatValue());
            doc.setPageSize(rectangle);
            doc.setMargins(MedwanQuery.getInstance().getConfigInt("patientReceiptLeftMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptRightMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptTopMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptBottomMargin",0));
            doc.open();

            // get specified invoice
            printInvoice(invoice,invoice.getDebets());
    		if(MedwanQuery.getInstance().getConfigInt("autoPrintPatientReceipt",0)==1){
    			PdfAction action = new PdfAction(PdfAction.PRINTDIALOG);
    			docWriter.setOpenAction(action);
    		}
        }
		catch(Exception e){
			baosPDF.reset();
			e.printStackTrace();
        }
		finally{
			if(doc!=null) {
				doc.close();
			}
            if(docWriter!=null) {
            	docWriter.close();
            }
		}
		if(baosPDF.size() < 1){
			throw new DocumentException("document has no bytes");
		}

		return baosPDF;
	}
    
    private void printInvoice(PatientInvoice invoice, Vector debets){
    	try{
	    	double titleScaleFactor = new Double(MedwanQuery.getInstance().getConfigInt("PDFReceiptTitleFontScaleFactor",100))/100;
	    	double scaleFactor = new Double(MedwanQuery.getInstance().getConfigInt("PDFReceiptFontScaleFactor",100))/100;
	    	table = new PdfPTable(50);
	        table.setWidthPercentage(98);

	        if(SH.ci("enablePatientInvoiceReceiptCPLRLogo",0)==1) {
		        // logo
		        try{
		            Image img = Miscelaneous.getImage("JavaPOSImage1.gif",sProject);
		            for(int n=0;n<debets.size();n++){
		            	Debet debet = (Debet)debets.elementAt(n);
		            	if(debet.getInsurance()!=null && debet.getInsurance().getInsurarUid()!=null && MedwanQuery.getInstance().getConfigString("insurancelogo."+debet.getInsurance().getInsurarUid(),"").length()>0){
		            		img = Miscelaneous.getImage(MedwanQuery.getInstance().getConfigString("insurancelogo."+debet.getInsurance().getInsurarUid(),""),sProject);
		            		break;
		            	}
		            }
		            if(img==null){
		                cell = createEmptyCell(10);
		                table.addCell(cell);
		            }
		            else {
		                img.scaleToFit(50,50);
		                cell = new PdfPCell(img);
		                cell.setBorder(PdfPCell.NO_BORDER);
		                cell.setPadding(0);
		                cell.setColspan(50);
		                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		                table.addCell(cell);
		            }
		        }
		        catch (Exception e){
		        	Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
		            e.printStackTrace();
		        }
	        }
	        cell = createBorderlessCell(ScreenHelper.getTranNoLink("web","javaposcentername",sPrintLanguage), 1,50,new Double(10*titleScaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
	        cell = createBorderlessCell(ScreenHelper.getTranNoLink("web","javaposcentersubtitle",sPrintLanguage), 1,50,new Double(10*titleScaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
	        cell = createBorderlessCell(ScreenHelper.getTranNoLink("web","javaposcenterphone",sPrintLanguage), 1,50,new Double(10*titleScaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
	        
	        double totalCredit=0;
	        String sPaymentCurrency="";
	        for(int n=0;n<invoice.getCredits().size();n++){
	            PatientCredit credit = PatientCredit.get((String)invoice.getCredits().elementAt(n));
	            totalCredit+=credit.getAmount();
	            sPaymentCurrency=credit.getCurrency();
	        }
	        double totalDebet=0,totalinsurardebet=0,totalextrainsurardebet=0;
	        Hashtable services = new Hashtable(), insurances = new Hashtable(), extrainsurances = new Hashtable(), careproviders=new Hashtable();
	        String service="",insurance="",extrainsurance="",careprovider="";
	        for(int n=0;n<debets.size();n++){
	            Debet debet = (Debet)debets.elementAt(n);
	            if(debet!=null){
	            	if(debet.getService()!=null){
	            		service=debet.getService().getLabel(sPrintLanguage);
	            	}
		            if(service!=null){
		            	if(SH.c(debet.getEncounter().getManagerUID()).length()>0) {
		            		service+=" ["+debet.getEncounter().getManager().person.getFullName()+"]";
		            	}
		            	services.put(service, "1");
		            }
	            	if(debet.getInsurance()!=null && debet.getInsurance().getInsurar()!=null){
	            		insurance=debet.getInsurance().getInsurar().getName()+(ScreenHelper.checkString(debet.getInsurance().getInsuranceNr()).length()==0?"":" ("+debet.getInsurance().getInsuranceNr()+")");
	            	}
		            if(checkString(insurance).length()>0){
		            	insurances.put(insurance, debet.getInsurance());
		            }
	            	if(debet.getExtraInsurarUid()!=null){
	            		Insurar extraInsurar = Insurar.get(debet.getExtraInsurarUid());
	            		if(extraInsurar!=null && extraInsurar.getName()!=null){
	            			extrainsurance=extraInsurar.getName();
	            		}
	            	}
		            if(checkString(extrainsurance).length()>0){
		            	extrainsurances.put(extrainsurance, "1");
		            }
	            	if(checkString(debet.getPerformeruid()).length()>0){
	            		User user = User.get(Integer.parseInt(debet.getPerformeruid()));
	            		if(user!=null && user.person!=null){
	            			careprovider=user.person.getFullName();
	            		}
	            	}
		            if(checkString(careprovider).length()>0){
		            	careproviders.put(careprovider, "1");
		            }
		            totalDebet+=debet.getAmount();
		            totalinsurardebet+=debet.getInsurarAmount();
		            totalextrainsurardebet+=debet.getExtraInsurarAmount();
	            }
	        }

			//Create the receipt content
			int receiptid=MedwanQuery.getInstance().getOpenclinicCounter("RECEIPT");
			if(receiptid>=MedwanQuery.getInstance().getConfigInt("maximumNumberOfReceipts",10000)){
				MedwanQuery.getInstance().setOpenclinicCounter("RECEIPT",0);
			}
	        cell = createBorderlessCell(receiptid+" - "+ScreenHelper.getTran(null,"web","receiptforinvoice",sPrintLanguage)+" "+invoice.getInvoiceNumber(),10, 50,new Double(8*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        cell.setPadding(2);
	        table.addCell(cell);
	        cell = createBorderlessCell(ScreenHelper.stdDateFormat.format(invoice.getDate()),10, 50,new Double(8*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        cell.setPaddingBottom(10);
	        table.addCell(cell);

	        //Patient
	        cell = createValueCell(ScreenHelper.getTran(null,"web","patient",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createBoldLabelCell(invoice.getPatient().lastname.toUpperCase()+", "+invoice.getPatient().firstname, 35,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createValueCell("", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createBoldLabelCell(invoice.getPatientUid(), 15,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createBoldLabelCell("°"+invoice.getPatient().dateOfBirth, 20,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        table.addCell(cell);

	        Enumeration ins=insurances.keys();
	        while(ins.hasMoreElements()){
	        	//Assurance
	        	cell = createValueCell(ScreenHelper.getTran(null,"web","insurance",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                table.addCell(cell);
	        	insurance = (String)ins.nextElement();
	            cell = createBoldLabelCell(insurance, 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);

	            //Adherent
		        cell = createValueCell(ScreenHelper.getTran(null,"insurance","member",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		        table.addCell(cell);
		        String immat=ScreenHelper.checkString(((Insurance)insurances.get(insurance)).getMemberImmat());
		        cell = createBoldLabelCell(ScreenHelper.checkString(((Insurance)insurances.get(insurance)).getMember())+(immat.length()==0?"":" ("+immat+")"), 35,new Double(7*scaleFactor).intValue());
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		        table.addCell(cell);
	        }
	        if(checkString(invoice.getInsurarreference()).length()>0){
	        	//B/C Assurance
	        	cell = createValueCell(ScreenHelper.getTran(null,"web","bc.insurar",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                table.addCell(cell);
	            cell = createBoldLabelCell(checkString(invoice.getInsurarreference()), 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
	        }
	        Enumeration extrains=extrainsurances.keys();
	        while(extrains.hasMoreElements()){
	        	//Assurance complémentaire
	        	cell = createValueCell(ScreenHelper.getTran(null,"web","extrainsurar",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                table.addCell(cell);
	        	extrainsurance = (String)extrains.nextElement();
	            cell = createBoldLabelCell(extrainsurance, 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
	        }
	        if(checkString(invoice.getComment()).length()>0){
	        	//B/C Assurance complémentaire
	        	cell = createValueCell(ScreenHelper.getTran(null,"web","bc.extrainsurar",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
                table.addCell(cell);
	            cell = createBoldLabelCell(checkString(invoice.getComment()), 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
	        }
	        //Services
	        Enumeration es = services.keys();
	        int nLines=0;
	        while (es.hasMoreElements()){
	        	if(nLines==0){
	                cell = createValueCell(ScreenHelper.getTran(null,"web","service",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                table.addCell(cell);
	        	}
	        	else {
	                cell = createValueCell("", 15);
	                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                table.addCell(cell);
	        	}
	        	nLines++;
	        	service=(String)es.nextElement();
	            cell = createBoldLabelCell(service, 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
	        }
	        //Médecin
	        Enumeration cps = careproviders.keys();
	        nLines=0;
	        while (cps.hasMoreElements()){
	        	if(nLines==0){
	                cell = createValueCell(ScreenHelper.getTran(null,"web","physician",sPrintLanguage)+":", 15,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                table.addCell(cell);
	        	}
	        	else {
	                cell = createValueCell("", 15);
	                cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                table.addCell(cell);
	        	}
	        	nLines++;
	        	careprovider=(String)cps.nextElement();
	            cell = createBoldLabelCell(careprovider, 35,new Double(7*scaleFactor).intValue());
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
	        }
	        cell=createValueCell("",50);
	        cell.setBorder(PdfPCell.NO_BORDER);
	        table.addCell(cell);
	        cell = createUnderlinedTextCell(ScreenHelper.getTran(null,"web","prestations",sPrintLanguage), 50*MedwanQuery.getInstance().getConfigInt("patientInvoiceReceiptCareDeliveryColumnWidthPercent",60)/100,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createUnderlinedTextCell(ScreenHelper.getTran(null,"web","amount",sPrintLanguage), 50-50*MedwanQuery.getInstance().getConfigInt("patientInvoiceReceiptCareDeliveryColumnWidthPercent",60)/100,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        table.addCell(cell);
	        for(int n=0;n<debets.size();n++){
	            Debet debet = (Debet)debets.elementAt(n);
	            if(debet.getPrestation()!=null){
		            cell = createValueCell(debet.getQuantity()+" x "+debet.getPrestation().getDescription(), 50*MedwanQuery.getInstance().getConfigInt("patientInvoiceReceiptCareDeliveryColumnWidthPercent",60)/100,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		            table.addCell(cell);
		            cell = createTotalPriceCell(debet.getAmount()+debet.getInsurarAmount()+debet.getExtraInsurarAmount(), 50-50*MedwanQuery.getInstance().getConfigInt("patientInvoiceReceiptCareDeliveryColumnWidthPercent",60)/100,debet.getDate(),sPaymentCurrency,new Double(7*scaleFactor).intValue());
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table.addCell(cell);
	            }
	        }

	        cell=createValueCell("",50);
	        cell.setBorder(PdfPCell.BOTTOM);
	        table.addCell(cell);

	        //Total général
	        cell = createValueCell(ScreenHelper.getTran(null,"web","total.general",sPrintLanguage), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        cell = createTotalPriceCell(totalDebet+totalextrainsurardebet+totalinsurardebet, 25,new java.util.Date(),sPaymentCurrency,new Double(7*scaleFactor).intValue());
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        table.addCell(cell);
	        //Total patient
	        String sAlternateCurrency = MedwanQuery.getInstance().getConfigString("AlternateCurrency","");
	        String sAlternateValue="";
	        if(sAlternateCurrency.length()>0){
	        	sAlternateValue=" ("+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(totalDebet/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency+")";
	        }
	        cell = createValueCell(ScreenHelper.getTran(null,"web","total.patient",sPrintLanguage)+": "+getTotalPriceString(totalDebet, false, new java.util.Date(), sPaymentCurrency), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        //Total assureur
	        cell = createValueCell(ScreenHelper.getTran(null,"web","total.insurar",sPrintLanguage)+": "+getTotalPriceString(totalinsurardebet, false, new java.util.Date(), sPaymentCurrency), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        table.addCell(cell);
	        //Payé patient
	        if(sAlternateCurrency.length()>0){
	        	sAlternateValue=" ("+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(totalCredit/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency+")";
	        }
	        cell = createValueCell(ScreenHelper.getTran(null,"web","payments",sPrintLanguage)+": "+getTotalPriceString(totalCredit, false, new java.util.Date(), sPaymentCurrency), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);
	        //Total assureur complémentaire
	        cell = createValueCell(ScreenHelper.getTran(null,"web","total.extrainsurar",sPrintLanguage)+": "+getTotalPriceString(totalextrainsurardebet, false, new java.util.Date(), sPaymentCurrency), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        table.addCell(cell);
	        //Solde patient
	        cell = createValueCell(ScreenHelper.getTran(null,"web","balance",sPrintLanguage)+": "+getTotalPriceString(totalDebet-totalCredit, false, new java.util.Date(), sPaymentCurrency), 50,new Double(7*scaleFactor).intValue(),Font.NORMAL);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	        table.addCell(cell);

	        cell=createValueCell("",50);
	        cell.setBorder(PdfPCell.NO_BORDER);
	        table.addCell(cell);

	        if(MedwanQuery.getInstance().getConfigInt("showBarcodeOnReceipts",0)==1){
		        //*** barcode ***
		        Image image = PdfBarcode.getBarcode("7"+invoice.getInvoiceUid(),"", docWriter);            
		        cell = new PdfPCell(image);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        cell.setColspan(50);
		        table.addCell(cell);
	        }

	        cell=createValueCell("",50);
	        cell.setBorder(PdfPCell.NO_BORDER);
	        table.addCell(cell);

	        if(MedwanQuery.getInstance().getConfigInt("enablePatientReceiptPrintBy",0)==1){
		        //Signature patient
		        cell = createValueCell(ScreenHelper.getTranNoLink("web","printedby",sPrintLanguage)+": "+user.person.getFullName(), 50,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		        table.addCell(cell);
	
		        cell=createValueCell("\r\n",50);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        table.addCell(cell);
	        }
	        else {
		        cell = createValueCell(user.person.getFullName().toUpperCase(), 40,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		        table.addCell(cell);
		
		        cell = createValueCell(ScreenHelper.getTran(null,"web","thankyou",sPrintLanguage), 10,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		        table.addCell(cell);
	        }


	        cell=createValueCell("",50);
	        cell.setBorder(PdfPCell.BOTTOM);
	        table.addCell(cell);

	        if(MedwanQuery.getInstance().getConfigInt("enablePatientReceiptSignatures",0)==1){
		        //Signature patient
		        cell = createValueCell(ScreenHelper.getTranNoLink("web","signature.patient",sPrintLanguage), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		        table.addCell(cell);
		        //Signature provider
		        cell = createValueCell(ScreenHelper.getTranNoLink("web","signature.provider",sPrintLanguage), 25,new Double(7*scaleFactor).intValue(),Font.NORMAL);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		        table.addCell(cell);
	
		        cell=createValueCell("\r\n",50);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        table.addCell(cell);
		        cell=createValueCell("\r\n",50);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        table.addCell(cell);
	        }

	        for(int n=0; n < MedwanQuery.getInstance().getConfigInt("receiptPrinterEmptyLines",0);n++){
		        cell=createValueCell("\r\n",50);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        table.addCell(cell);
	        }


	        doc.add(table);
    	}
    	catch(Exception ee){
    		ee.printStackTrace();
    	}
    }
  
}