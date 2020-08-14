package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import java.util.*;
import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.text.SimpleDateFormat;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.finance.*;
import be.openclinic.adt.Encounter;
import net.admin.*;

import javax.servlet.http.HttpServletRequest;

public class PDFIOTAFile2Generator extends PDFInvoiceGenerator {

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFIOTAFile2Generator(User user, AdminPerson patient, String sProject, String sPrintLanguage){
        this.user = user;
        this.patient = patient;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;

        doc = new Document();
    }

    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, Invoice inv) throws Exception {
    	return null;
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req,String personid) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
			doc.setPageSize(PageSize.A4.rotate());
            doc.open();

            // get specified invoice
            printFile();
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
    
    private void printFile(){
    	try{
    		PdfPTable mastertable = new PdfPTable(2);
    		mastertable.setWidthPercentage(100);
    		cell = createEmptyCell(1);
    		cell.setBorder(PdfPCell.NO_BORDER);
    		mastertable.addCell(cell);
    		
    		table = new PdfPTable(50);
	        table.setWidthPercentage(98);
            //*** logo ***
            try{
                Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
                img.scaleToFit(75, 75);
                cell = new PdfPCell(img);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setColspan(10);
                table.addCell(cell);
            }
            catch(NullPointerException e){
                Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
                e.printStackTrace();
            }

            PdfPTable table2 = new PdfPTable(1);
            cell=createBoldBorderlessCell(getTran("web", "hospitalname"), 1, MedwanQuery.getInstance().getConfigInt("IOTATitleFontSize",10));
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(getTran("web", "hospitaladdress"), 1, MedwanQuery.getInstance().getConfigInt("IOTATitle2FontSize",10));
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(getTran("web", "javaposcenterphone"), 1, MedwanQuery.getInstance().getConfigInt("IOTATitle3FontSize",10));
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table2.addCell(cell);
            
            cell=new PdfPCell(table2);
            cell.setPaddingLeft(10);
            cell.setPaddingRight(10);
            cell.setPaddingTop(0);
            cell.setColspan(30);
            cell.setBorder(PdfPCell.NO_BORDER);
            table.addCell(cell);

            //*** barcode ***
            Image image = PdfBarcode.getBarcode("0"+patient.personid, docWriter);            
            cell = new PdfPCell(image);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(10);
            table.addCell(cell);

            cell=createBoldBorderlessCell(getTran("web", "consultationcard")+"\n\n", 50, MedwanQuery.getInstance().getConfigInt("IOTATitle4FontSize",10));
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);
            
            
            table2 = new PdfPTable(60);
            cell=createBorderlessCell2(getTran("web", "name"), 7, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.lastname.toUpperCase(), 53, MedwanQuery.getInstance().getConfigInt("IOTANameFontSize",10));
            table2.addCell(cell);
            
            cell=createBorderlessCell2(getTran("web", "firstname"), 7, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.firstname, 33, MedwanQuery.getInstance().getConfigInt("IOTANameFontSize",10));
            table2.addCell(cell);
            cell=createBorderlessCell2(getTran("web", "gender"), 6, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.gender, 14, MedwanQuery.getInstance().getConfigInt("IOTANameFontSize",10));
            table2.addCell(cell);
            
            cell=createBorderlessCell2(getTran("web", "dateofbirth"), 7, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.dateOfBirth, 13, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",7));
            table2.addCell(cell);
            cell=createBorderlessCell2(getTran("web", "nativetown"), 6, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.nativeTown, 14, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",7));
            table2.addCell(cell);
            cell=createBorderlessCell2(getTran("web", "function"), 6, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.getActivePrivate().businessfunction, 14, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",7));
            table2.addCell(cell);

            cell=createBorderlessCell2(getTran("web", "contact"), 7, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.getActivePrivate().address, 53, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",10));
            table2.addCell(cell);

            cell=createBorderlessCell2(getTran("web", "city"), 7, 6);
            table2.addCell(cell);
            cell=createBoldBorderlessCell(patient.getActivePrivate().city, 13, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",7));
            table2.addCell(cell);
            cell=createBorderlessCell2("", 12, 6);
            table2.addCell(cell);
            cell=createBorderlessCell2(getTran("web", "firstconsultationdate"), 14, 6);
            table2.addCell(cell);
            Encounter firstEncounter = Encounter.getFirstEncounter(patient.personid);
            cell=createBoldBorderlessCell(firstEncounter==null?"":ScreenHelper.formatDate(firstEncounter.getBegin()), 14, MedwanQuery.getInstance().getConfigInt("IOTAAdminFontSize",7));
            table2.addCell(cell);
            
            cell=new PdfPCell(table2);
            cell.setColspan(50);
            cell.setBorder(PdfPCell.BOX);
            table.addCell(cell);
            
            PdfPCell cell = new PdfPCell(table);
            cell.setColspan(1);
            cell.setBorder(PdfPCell.NO_BORDER);
            mastertable.addCell(cell);

	        doc.add(mastertable);
    	}
    	catch(Exception ee){
    		ee.printStackTrace();
    	}
    }
  
}