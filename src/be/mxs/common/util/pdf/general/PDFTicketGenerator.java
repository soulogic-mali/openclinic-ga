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

public class PDFTicketGenerator extends PDFInvoiceGenerator {

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFTicketGenerator(User user, AdminPerson patient, String sProject, String sPrintLanguage){
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
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String objectid) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

		try{

			doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
            Rectangle rectangle = new Rectangle(0,0,new Float(MedwanQuery.getInstance().getConfigInt("ticketWidth",720)*72/254).floatValue(),new Float(MedwanQuery.getInstance().getConfigInt("ticketHeight",800)*72/254).floatValue());
            doc.setPageSize(rectangle);
            doc.setMargins(MedwanQuery.getInstance().getConfigInt("patientReceiptLeftMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptRightMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptTopMargin",0), MedwanQuery.getInstance().getConfigInt("patientReceiptBottomMargin",0));
            doc.open();

            // get specified ticket
            be.openclinic.adt.Queue queue = be.openclinic.adt.Queue.get(Integer.parseInt(objectid));
            printTicket(queue);
    		if(MedwanQuery.getInstance().getConfigInt("autoPrintTicket",1)==1){
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
    
    private void printTicket(be.openclinic.adt.Queue queue){
    	try{
	    	table = new PdfPTable(50);
	        table.setWidthPercentage(98);
	        cell = createBorderlessCell("\n", 1,50,10);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
            Image image = PdfBarcode.getBarcode("T"+queue.getObjectid(),getTran("web","estimatedtimeofservice")+": "+queue.getEstimatedTime(), docWriter);            
	        cell = new PdfPCell(image);
	        cell.setBorder(PdfPCell.NO_BORDER);
	        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        cell.setColspan(50);
	        cell.setPadding(0);
	        table.addCell(cell);
	        cell = createBoldBorderlessCell(getTran("web","date")+": "+new SimpleDateFormat("dd/MM/yyyy HH:mm").format(queue.getBegin()), 1,50,12);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
	        cell = createBorderlessCell(getTran("queue",queue.getId()), 1,50,10);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);
	        if(queue.getSubjectuid()!=null && queue.getSubjectuid().length()>0){
	        	cell = createBorderlessCell(AdminPerson.getFullName(queue.getSubjectuid())+" ("+queue.getSubjectuid()+")", 1,50,10);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		        table.addCell(cell);
	        }
	        cell = createBoldBorderlessCell(queue.getTicketnumber()+"", 1,50,MedwanQuery.getInstance().getConfigInt("PDFTicketFontSize",50));
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table.addCell(cell);

	        doc.add(table);
    	}
    	catch(Exception ee){
    		ee.printStackTrace();
    	}
    }
  
}