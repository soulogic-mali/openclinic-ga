package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import java.util.*;
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;

import javax.servlet.http.HttpServletRequest;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.*;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.system.SH;
import be.openclinic.adt.Encounter;
import net.admin.*;

public class PDFCovidCertificateGenerator extends PDFOfficialBasic {
    String PrintType;
    PdfWriter docWriter=null;

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFCovidCertificateGenerator(User user, String sProject, String sPrintLanguage, String PrintType){
        this.user = user;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;
        this.PrintType=PrintType;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(int transactionId) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
			doc.setPageSize(PageSize.A4);
			doc.setMargins(5, 5, 5, 5);
            // get specified invoice

            doc.open();
            addFooterWithText("Powered by OpenClinic GA LIMS - OpenClinic Foundation (c)2021");
            printCertificate(transactionId);
        }
		catch(Exception e){
			baosPDF.reset();
			e.printStackTrace();
		}
		finally{
			if(doc!=null) doc.close();
            if(docWriter!=null) docWriter.close();
		}

		if(baosPDF.size() < 1){
			throw new DocumentException("document has no bytes");
		}

		return baosPDF;
	}
    
    private void printCertificate(int transactionId) throws Exception {
    	TransactionVO transaction = MedwanQuery.getInstance().loadTransaction(1, transactionId);
    	AdminPerson patient = AdminPerson.getAdminPerson(""+MedwanQuery.getInstance().getPersonIdFromHealthrecordId(transaction.getHealthrecordId()));
    	
    	table = new PdfPTable(100);
        try{
            Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
            img.scaleToFit(90, 90);
            cell = new PdfPCell(img);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(20);
            table.addCell(cell);
            PdfPTable table2 = new PdfPTable(100);
            cell = createBoldBorderlessCell("Biomedical Services (BIOS) - National Reference Laboratory", 100, 14);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table2.addCell(cell);
            cell = createBoldBorderlessCell("ACCREDITED ISO-15189:2012", 100, 12);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(100);
            table2.addCell(cell);
            cell = createBoldBorderlessCell("COVID-19 RESULT REPORT", 100, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setColspan(100);
            table2.addCell(cell);
            cell = new PdfPCell(table2);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(80);
            table.addCell(cell);
            Image image = PdfBarcode.getQRCode("http://covid.khin.rw/openclinic/check.jsp?id="+Base64.getEncoder().encodeToString((transaction.getTransactionId()+";"+patient.personid).getBytes()), docWriter, MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeSize",200));
            if(MedwanQuery.getInstance().getConfigInt("archiveBarcodeScaleToFit",1)==1){
            	image.scaleToFit(75,75);
            }
            cell = new PdfPCell(image);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setPaddingTop(0);
            cell.setPaddingBottom(0);
            cell.setColspan(100);
            table.addCell(cell);

            cell=createBorderlessCell2("\n\n", 100,10);
            table.addCell(cell);
            cell=createBoldGreyCell(10, "Lab contact information", 100);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Unique ID", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.personid, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Full name", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.getFullName(), 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Sex", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.gender.toUpperCase(), 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Date of birth", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.dateOfBirth, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Nationality", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(getTran("country",patient.nativeCountry.toLowerCase()), 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell=createBorderlessCell2("\n\n", 100,10);
            table.addCell(cell);
            cell=createBoldGreyCell(10, "Address and contact information", 100);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Telephone", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.getActivePrivate().mobile, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Email address", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.getActivePrivate().email, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Country", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(patient.getActivePrivate().country, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell=createBorderlessCell2("\n\n", 100,10);
            table.addCell(cell);
            cell=createBoldGreyCell(10, "Covid-19 investigation and tests", 100);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("Specimen collection", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(SH.formatDate(transaction.getUpdateTime()), 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            String sDate="";
            String sValue="";
            RequestedLabAnalysis an = RequestedLabAnalysis.get(1, transactionId, "cov");
            if(an!=null) {
            	try {
	            	sDate = SH.formatDate(an.getResultDate());
	            	sValue = an.getResultValue();
            	}
            	catch(Exception e) {
            		e.printStackTrace();
            	}
            }
            cell = createBorderlessCell2("Result date", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(sDate, 80, 10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell2("SARS-CoV-2 RT-PCR Result", 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBoldBorderlessCell(sValue, 80, 14);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell=createBorderlessCell2("\n\n", 100,10);
            table.addCell(cell);
            cell=createBoldGreyCell(10, "Official use only", 100);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell=createBorderlessCell2("\n", 100,10);
            table.addCell(cell);
            img = Miscelaneous.getImage("covid_stamp.gif",sProject);
            img.scaleToFit(90, 90);
            cell = new PdfPCell(img);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(20);
            table.addCell(cell);
            cell = createBorderlessCell(50);
            table.addCell(cell);
            img = Miscelaneous.getImage("covid_signature.gif",sProject);
            img.scaleToFit(90,90);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell = new PdfPCell(img);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(20);
            table.addCell(cell);
            cell=createBorderlessCell2("\n", 100,10);
            table.addCell(cell);
            cell=createBorderlessCell2("Date: "+SH.formatDate(new java.util.Date()), 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createBorderlessCell(50);
            table.addCell(cell);
            cell=createBorderlessCell2("Validated by Robert Rutayisire\nDivision Manager\nNational Reference Laboratory", 30,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
            
        }
        catch(Exception e){
            Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
            e.printStackTrace();
            cell = new PdfPCell();
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(100);
            table.addCell(cell);
        }
        doc.add(table);
    }
    
    protected void addFooterWithText(String s){
        PDFFooter footer = new PDFFooter(s);
        docWriter.setPageEvent(footer);
    }


	@Override
	protected void addHeader() {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void addContent() {
		// TODO Auto-generated method stub
		
	}

}