package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import java.util.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.ExportSAP_AR_INV;
import be.openclinic.finance.*;
import be.openclinic.adt.Encounter;
import net.admin.*;
import pe.gob.sis.Diagnosticos;
import pe.gob.sis.FUA;

import javax.imageio.ImageIO;
import javax.print.attribute.standard.PrinterLocation;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.input.SwappedDataInputStream;

public class PDFFUAGenerator extends PDFInvoiceGenerator {
    String sProforma = "no";

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFFUAGenerator(User user, String sProject, String sPrintLanguage){
        this.user = user;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String sFUAuid) throws Exception {
		// get specified invoice
        FUA fua = FUA.get(sFUAuid);
        return generatePDFDocumentBytes(req, fua);
	}
    
    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, FUA fua) throws Exception {
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
			if(MedwanQuery.getInstance().getConfigString("invoicePaperFormat","A4").equalsIgnoreCase("A5")){
				doc.setPageSize(PageSize.A5);
			}
			else{
				doc.setPageSize(PageSize.A4);
			}
			doc.setMargins(MedwanQuery.getInstance().getConfigInt("patientInvoiceMarginLeft",new Float(doc.leftMargin()).intValue()), MedwanQuery.getInstance().getConfigInt("patientInvoiceMarginRight",new Float(doc.rightMargin()).intValue()), MedwanQuery.getInstance().getConfigInt("patientInvoiceMarginTop",new Float(doc.topMargin()).intValue()), MedwanQuery.getInstance().getConfigInt("patientInvoiceMarginBottom",new Float(doc.bottomMargin()).intValue()));
            doc.open();
            printFUA(fua);
            
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
    
    private void printFUA(FUA fua) throws DocumentException{
    	BaseColor color_gray=BaseColor.LIGHT_GRAY;
    	BaseColor color_lightgray = new BaseColor(228,228,228);
    	
		table = new PdfPTable(190);
        table.setWidthPercentage(pageWidth);

        cell = createEmptyCell(190);
		try{
            Image img = Miscelaneous.getImage("sis.jpg",sProject);
            if(img!=null){
                img.scaleToFit(200,40);
                cell = new PdfPCell(img);
                cell.setColspan(190);
                cell.setPadding(5);
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		table.addCell(cell);

        cell= createValueCell("FORMATO UNICO DE ATENCION - FUA",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		table.addCell(cell);

		table.addCell(createEmptyCell(60));
		cell= createValueCell("NUMERO DE FORMATO",70,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		table.addCell(cell);
		table.addCell(createEmptyCell(60));
		
		table.addCell(createEmptyCell(60));
		cell= createValueCell(MedwanQuery.getInstance().getConfigString("fua.disa","350"),20,12,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getDate()==null?"":new SimpleDateFormat("yy").format(fua.getDate()),10,12,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getObjectId()+"",40,12,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		table.addCell(createEmptyCell(60));

        cell= createValueCell("DE LA INSTITUCION PRESTADORA DE SERVICIOS DE SALUD",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		table.addCell(cell);

		cell= createValueCell("CÓDIGO RENAES DE LA IPRESS",50,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOMBRE DE LA IPRESS QUE REALIZA LA ATENCION",140,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell(MedwanQuery.getInstance().getConfigString("fua.ipress.renaes","0147 (1570)"),50,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(MedwanQuery.getInstance().getConfigString("fua.ipress.name","HOSPITAL DE EMERGENCIAS PEDIÁTRICAS"),140,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("PERSONAL QUE ATIENDE",30,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("LUGAR DE ATENCION",30,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ATENCION",30,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("REFERENCIA REALIZADA POR",100,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("DE LA IPRESS",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(43)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("INTRAMURAL",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(44)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("AMBULATORIA",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(34)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("COD RENAES",20,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOMBRE DE LA IPRESS U OFERTA FLEXIBLE",60,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("HOJA REFERENCIA",20,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("ITINERANTE",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(43)==2?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("EXTRAMURAL",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(44)==2?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("REFERENCIA",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(34)==2?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(40),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.RIGHT);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(ScreenHelper.getTranNoLink("ipress.renaes", fua.getAtencion().getValueString(40), sPrintLanguage),60,8,Font.BOLD);
		cell.setBorder(PdfPCell.RIGHT);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(41),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.RIGHT);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell = createEmptyCell(60);
		cell.setBorder(PdfPCell.BOX);
		table.addCell(cell);
		cell= createValueCell("EMERGENCIA",25,6,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(34)==3?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell = createEmptyCell(20);
		cell.setBorder(PdfPCell.RIGHT);
		table.addCell(cell);
		cell = createEmptyCell(60);
		cell.setBorder(PdfPCell.RIGHT);
		table.addCell(cell);
		cell = createEmptyCell(20);
		cell.setBorder(PdfPCell.RIGHT);
		table.addCell(cell);
		
		cell= createValueCell("DEL ASEGURADO / USUARIO",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("IDENTIFICATION",45,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CÓDIGO DESL ASEGURADO SIS",45,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ASEGURADO DE OTRA IAFAS",100,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("TDI",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° DOCUMENTO DE IDENTIDAD",35,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DIRESA",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NÚMERO",35,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("INSTITUCIÓN",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(getTran("sis.iafas",fua.getAtencion().getValueString(62)),70,5,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell(getTran("fua.doctype",fua.getAtencion().getValueString(24)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(25),35,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(16),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(17),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(18),25,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CODIGO SEGURO",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(63),70,5,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("APELLIDO PATERNO",95,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("APELLIDO MATERNO",95,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell(fua.getAtencion().getValueString(26),95,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(27),95,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("PRIMER NOMBRE",95,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("OTROS NOMBRES",95,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell(fua.getAtencion().getValueString(28),95,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(29),95,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("SEXO",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("FECHA",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DIA",16,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("MES",16,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ANO",32,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° DE HISTORIA CLINICA",41,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ETNIA",35,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("MASCULINO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(31)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("FECHA PROBABLE DE PARTO / FECHA DE PARTO",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(31)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(31)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(31)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(31)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(31)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(31)),32,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(33),41,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(getTran("sis.etnia",fua.getAtencion().getValueString(61)),35,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		
		cell= createValueCell("FEMININO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(31)==0?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("SALUD MATERNA",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("FECHA DE NACIMIENTO",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(30)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(30)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(30)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(30)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(30)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(30)),32,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DNI / CNV / AFILIACIÓN DEL RN 1",41,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell = createEmptyCell(35);
		cell.setBorder(PdfPCell.BOX);
		table.addCell(cell);

		cell= createValueCell("GESTANTE",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(35)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("FECHA DE FALLECIMIENTO",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(59)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(59)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(59)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(59)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(59)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(59)),32,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("DNI / CNV / AFILIACIÓN DEL RN 2",41,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell = createEmptyCell(35);
		cell.setBorder(PdfPCell.BOX);
		table.addCell(cell);

		cell= createValueCell("PUERPERA",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(35)==2?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DNI / CNV / AFILIACIÓN DEL RN 3",41,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell = createEmptyCell(35);
		cell.setBorder(PdfPCell.BOX);
		table.addCell(cell);

		cell= createValueCell("DE LA ATENCIÓN",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("FECHA DE ATENCIÓN",64,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("HORA",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("UPS",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("CÓD. PRESTA.",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("HOSPITALIZACIÓN",5,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(5);
		cell.setRotation(90);
		table.addCell(cell);
		cell= createValueCell("FECHA",21,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DIA",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("MES",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ANO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("DIA",16,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("MES",16,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("ANO",32,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DE INGRESO",21,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(46)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(46)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(46)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(46)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(46)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(46)),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell(fua.getAtencion().getValueDateTime(39)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDateTime(39)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDateTime(39)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDateTime(39)),16,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDateTime(39)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDateTime(39)),32,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDateTime(39)==null?"":new SimpleDateFormat("HH:mm").format(fua.getAtencion().getValueDateTime(39)),20,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(64),20,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(42),20,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DE ALTA",21,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(47)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(47)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(47)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(47)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(47)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(47)),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell=createEmptyCell(20);
		cell.setBorder(PdfPCell.BOX);
		table.addCell(cell);
		cell= createValueCell("CÓD. AUTORIZACIÓN",50,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° FUA A VINCULAR",54,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DE CORTE ADMINISTRATIVO",21,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(65)==null?"":new SimpleDateFormat("dd").format(fua.getAtencion().getValueDate(65)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(65)==null?"":new SimpleDateFormat("MM").format(fua.getAtencion().getValueDate(65)),10,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueDate(65)==null?"":new SimpleDateFormat("yyyy").format(fua.getAtencion().getValueDate(65)),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		
		cell= createValueCell("REPORTE VINCULADO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(68).length()==0?"":fua.getAtencion().getValueString(66)+"."+fua.getAtencion().getValueString(67)+"."+fua.getAtencion().getValueString(68),50,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(71).length()==0?"":fua.getAtencion().getValueString(69)+"."+fua.getAtencion().getValueString(70)+"."+fua.getAtencion().getValueString(71),54,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("CONCEPTO PRESTACIONÁL",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("ATENCIÓN DIRECTA",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(3);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(3);
		table.addCell(cell);
		cell= createValueCell("COD EXTRAORDINARIA",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CARTA DE GARANTIA",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("TRASLADO",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(3);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==5?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(3);
		table.addCell(cell);
		cell= createValueCell("SEPELIO",75,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("N° AUTORIZACIÓN",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==3?fua.getAtencion().getValueString(37):"",15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° AUTORIZACIÓN",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==6?fua.getAtencion().getValueString(37):"",15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NATIMUERTO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createEmptyCell(5);
		cell.setBorder(PdfPCell.BOX);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("OBITO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createEmptyCell(5);
		cell.setBorder(PdfPCell.BOX);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("OTRO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createEmptyCell(5);
		cell.setBorder(PdfPCell.BOX);
		cell.setRowspan(2);
		table.addCell(cell);

		cell= createValueCell("MONTO S/.",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==3?fua.getAtencion().getValueString(38):"",15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("MONTO S/.",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(36)==6?fua.getAtencion().getValueString(38):"",15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("DEL DESTINO DESL ASEGURADO USUARIO",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("ALTA",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==1?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("CITA",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==2?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("HOSPITALIZACIÓN",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==8?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("REFERIDO",60,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CONTRAREFERIDO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==6?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("FALLECIDO",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==7?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("CORTE ADMIN",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==9?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		
		cell= createValueCell("EMERGENCIA",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==3?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CONSULTA EXTERNA",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==4?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("APOYO AL DIAGNOSTICO",15,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueInt(45)==5?"X":"",5,10,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("SE REFIERE / CONTRAREFIERE A",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("CODIGO RENAES DE LA IPRESS",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOMBRE DE LA IPRESS A LA QUE SE REFIERE / CONTRAREFIERE",130,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° HOJA DE REFERENCIA",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell(fua.getAtencion().getValueString(48),30,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(getTran("ipress.renaes",fua.getAtencion().getValueString(48))+"\n",130,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(49),30,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("OTRAS ACTIVIDADES",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("PESO (Kg)",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(MedwanQuery.getInstance().getLastItemValueAfter(fua.getPersonId(), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_WEIGHT",fua.getEncounter().getBegin()),15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("TAILLA (cm)",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(MedwanQuery.getInstance().getLastItemValueAfter(fua.getPersonId(), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_BIOMETRY_HEIGHT",fua.getEncounter().getBegin()),15,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("P.A. (mmHg)",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell(MedwanQuery.getInstance().getLastItemValueAfter(fua.getPersonId(), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_SYSTOLIC_PRESSURE_RIGHT",fua.getEncounter().getBegin())+"/"+MedwanQuery.getInstance().getLastItemValueAfter(fua.getPersonId(), "be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CARDIAL_CLINICAL_EXAMINATION_DIASTOLIC_PRESSURE_RIGHT",fua.getEncounter().getBegin()),20,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("TAMIZAJE DE SALUD MENTAL",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("PAT.",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOR.",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		cell= createValueCell("DIAGNOSTICOS",190,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_gray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("N°",5,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("DESCRIPTION",95,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(2);
		table.addCell(cell);
		cell= createValueCell("INGRESO",45,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("EGRESO",45,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("TIPO DE DX",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CIE-10",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("TIPO DE DX",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("CIE-10",25,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		for(int n=0;n<fua.getDiagnosticos().size();n++){
			Diagnosticos d = (Diagnosticos)fua.getDiagnosticos().elementAt(n);
			cell= createValueCell(d.getValueString(3),5,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setBackgroundColor(color_lightgray);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
			String diag = d.getValueString(2);
			if(diag.length()>3){
				diag=diag.substring(0,3)+"."+diag.substring(3);
			}
			cell= createValueCell(MedwanQuery.getInstance().getCodeTran("icd10code"+diag,sPrintLanguage),95,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
			cell= createValueCell(d.getValueString(4).equalsIgnoreCase("I")?d.getValueInt(5)==1?"D":d.getValueInt(5)==2?"P":d.getValueInt(5)==4?"R":"":"",20,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
			cell= createValueCell(d.getValueString(4).equalsIgnoreCase("I")?diag:"",25,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
			cell= createValueCell(d.getValueString(4).equalsIgnoreCase("E")?d.getValueInt(5)==1?"D":d.getValueInt(5)==4?"R":"":"",20,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
			cell= createValueCell(d.getValueString(4).equalsIgnoreCase("E")?diag:"",25,8,Font.BOLD);
			cell.setBorder(PdfPCell.BOX);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
			table.addCell(cell);
		}

		cell= createValueCell("N° DE DNI",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOMBRE DEL RESPONSABLE DE LA ATENCION",130,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° DE COLEGIATURA",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell(fua.getAtencion().getValueString(73),30,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getEncounter().getManager()==null?"":fua.getEncounter().getManager().person.getFullName(),130,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(77),30,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell("ESPECIALIDAD",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(getTran("hr.contractcode1",fua.getAtencion().getValueString(75)),80,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("N° RNE",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(fua.getAtencion().getValueString(78),25,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("EGRESADO",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setBackgroundColor(color_lightgray);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell(getTran("hr.contractcode2",fua.getAtencion().getValueString(76)),25,8,Font.BOLD);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
		cell= createValueCell(" \n \n \n",190,10,Font.NORMAL);
		table.addCell(cell);

		cell= createValueCell("FIRMA Y SELLO DEL RESPONSABLE DE LA ATENCIÓN",70,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_BOTTOM);
		cell.setRowspan(5);
		table.addCell(cell);
		cell= createValueCell("FIRMA\n\n",70,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		
        cell = createEmptyCell(50);
		try{
        	InputStream in = new ByteArrayInputStream(fua.getPatientFingerPrint());
        	BufferedImage bimg = ImageIO.read(in);        	
            Image img = Image.getInstance(bimg , null); 
            if(img!=null){
                img.scaleToFit(75,75);
                cell = new PdfPCell(img);
                cell.setColspan(50);
            }
        }
        catch (Exception e){
            e.printStackTrace();
        }
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		cell.setRowspan(5);
		table.addCell(cell);
		
		cell= createValueCell("ASEGURADO\n\n",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",40,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("APODERADO\n\n",20,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",10,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOX);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",40,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOTTOM);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("NOMBRES Y APELLIDOS\n\n",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",40,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOTTOM);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("DNI o CE DEL APODERADO\n\n",30,5,Font.NORMAL);
		cell.setBorder(PdfPCell.NO_BORDER);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);
		cell= createValueCell("",40,5,Font.NORMAL);
		cell.setBorder(PdfPCell.BOTTOM);
		cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
		table.addCell(cell);

		
		doc.add(table);
    }
    
    private void addEncounterData(PatientInvoice invoice,String serviceuid){
        try {
        	String servicename="?";
        	if(serviceuid!=null){
	        	Service service = Service.getService(serviceuid);
	        	if(service!=null && service.getLabel(sPrintLanguage)!=null && service.getLabel(sPrintLanguage).length()>0){
	        		servicename=service.getLabel(sPrintLanguage);
	        	}
        	}
	    	PdfPTable wrappertable = new PdfPTable(2);
	    	wrappertable.setWidthPercentage(pageWidth);
	    	SortedMap encounters = new TreeMap();
	    	for(int n=0;n<invoice.getDebets().size();n++){
	    		Debet debet = (Debet)invoice.getDebets().elementAt(n);
	    		encounters.put(debet.getEncounterUid(), "1");
	    	}
	    	Iterator iEncounters = encounters.keySet().iterator();
	    	while(iEncounters.hasNext()){
	    		String encounterUid = (String)iEncounters.next();
	    		Encounter encounter = Encounter.get(encounterUid);
	    		if(encounter!=null){
	    			table = new PdfPTable(100);
	    	        table.setWidthPercentage(pageWidth);
	    			if(encounter.getType()!=null && encounter.getType().equalsIgnoreCase("admission")){
	    				if(invoice.getServicesAsString(sPrintLanguage).length()>0){
		    				cell= createValueCell(getTran("web","service")+":",15);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
			    			cell= createValueCell(invoice.getServicesAsString(sPrintLanguage),85);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
		    			}
		    			cell= createValueCell(getTran("web","begindate")+":",15);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
	        			cell= createValueCell(encounter.getBegin()==null?"":ScreenHelper.stdDateFormat.format(encounter.getBegin()),23);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
		    			cell= createValueCell(getTran("web","enddate")+":",15);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
		    			cell= createValueCell(encounter.getEnd()==null?"":ScreenHelper.stdDateFormat.format(encounter.getEnd()),23);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
		    			cell= createValueCell(getTran("web","bed")+":",10);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
		    			cell= createValueCell(encounter.getBed()==null?"":encounter.getBed().getName(),14);
		    			cell.setBorder(PdfPCell.NO_BORDER);
		    			table.addCell(cell);
	    			}
	    			else {
	    				if(invoice.getServicesAsString(sPrintLanguage).length()>0){
			    			cell= createValueCell(getTran("web","service")+":",20);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
			    			cell= createValueCell(invoice.getServicesAsString(sPrintLanguage),30);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
			    			cell= createValueCell(getTran("web","begindate")+":",20);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
		        			cell= createValueCell(encounter.getBegin()==null?"":ScreenHelper.stdDateFormat.format(encounter.getBegin()),30);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
	    				}
	    				else {
			    			cell= createValueCell(getTran("web","begindate")+":",20);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
		        			cell= createValueCell(encounter.getBegin()==null?"":ScreenHelper.stdDateFormat.format(encounter.getBegin()),80);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
	    				}
	    			}
	    			cell = createGrayCell(getTran("encountertype",encounter.getType()).toUpperCase(), 1);
	    			wrappertable.addCell(cell);
	    			String svc ="";
	    			try{
	    				svc=Service.getService(encounter.getServiceUID(invoice.getCreateDateTime())).getLabel(sPrintLanguage).toUpperCase();
	    			}
	    			catch(Exception d){}
	    			cell = createGrayCell(svc, 1);
	    			wrappertable.addCell(cell);
	                cell = createCell(new PdfPCell(table),2,PdfPCell.ALIGN_CENTER,PdfPCell.BOX);
	                cell.setPadding(cellPadding);
	                wrappertable.addCell(cell);
	    		}
	    	}
	    	doc.add(wrappertable);
	    	addBlankRow();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
    }

    //---- ADD RECEIPT ----------------------------------------------------------------------------
    private void addReceipt(PatientInvoice invoice) throws DocumentException {
        PdfPTable receiptTable = new PdfPTable(50);
        receiptTable.setWidthPercentage(pageWidth);

        // logo
        try{
            Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
            if(img==null){
                cell = createEmptyCell(10);
                receiptTable.addCell(cell);
            }
            else {
                img.scaleToFit(75,75);
                cell = new PdfPCell(img);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setColspan(10);
                receiptTable.addCell(cell);
            }
        }
        catch (Exception e){
        	Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
            e.printStackTrace();
        }

        table = new PdfPTable(5);
        table.setWidthPercentage(100);

        if(MedwanQuery.getInstance().getConfigInt("showBarcodeOnReceipts",0)==1){
	        table.addCell(createGrayCell((sProforma.equalsIgnoreCase("yes")?ScreenHelper.getTranNoLink("invoice","PROFORMA",sPrintLanguage)+" #"+invoice.getInvoiceNumber():sProforma.equalsIgnoreCase("debetnote")?ScreenHelper.getTranNoLink("invoice","DEBETNOTE",sPrintLanguage)+" #"+invoice.getInvoiceNumber():getTran("web","receiptforinvoice").toUpperCase()+" #"+invoice.getInvoiceNumber())+" - "+ScreenHelper.stdDateFormat.format(invoice.getDate()),4,10,Font.BOLD));
	        
	        //*** barcode ***
	        Image image = PdfBarcode.getBarcode("7"+invoice.getInvoiceUid(),"", docWriter);            
	        cell = new PdfPCell(image);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	        cell.setBorder(PdfPCell.NO_BORDER);
	        cell.setColspan(1);
	        table.addCell(cell);
            table.addCell(createValueCell(getTran("web","receivedfrom")+": "+patient.lastname.toUpperCase()+" "+patient.firstname+" ("+patient.personid+") - "+patient.dateOfBirth+" - "+patient.gender,5,8,Font.NORMAL));
        }
        else{
	        table.addCell(createGrayCell((sProforma.equalsIgnoreCase("yes")?ScreenHelper.getTranNoLink("invoice","PROFORMA",sPrintLanguage)+" #"+invoice.getInvoiceNumber():sProforma.equalsIgnoreCase("debetnote")?ScreenHelper.getTranNoLink("invoice","DEBETNOTE",sPrintLanguage)+" #"+invoice.getInvoiceNumber():getTran("web","receiptforinvoice").toUpperCase()+" #"+invoice.getInvoiceNumber())+" - "+ScreenHelper.stdDateFormat.format(invoice.getDate()),5,10,Font.BOLD));
	        table.addCell(createValueCell(getTran("web","receivedfrom")+": "+patient.lastname.toUpperCase()+" "+patient.firstname+" ("+patient.personid+")",3,8,Font.NORMAL));
	        table.addCell(createValueCell(patient.dateOfBirth,1,8,Font.NORMAL));
	        table.addCell(createValueCell(patient.gender,1,8,Font.NORMAL));
        }
        if(invoice.getInvoiceNumber().equalsIgnoreCase(invoice.getInvoiceUid())){
        	table.addCell(createEmptyCell(3));
        }
        else {
            table.addCell(createValueCell(getTran("web.occup","medwan.common.reference")+": "+invoice.getInvoiceUid(),1,8,Font.NORMAL));
        	table.addCell(createEmptyCell(2));
        }
        table.addCell(createValueCell(getTran("web","prestations"),1,8,Font.NORMAL));
        double totalDebet=0;
        double totalinsurardebet=0;

    	//Find services
		Vector debets=invoice.getDebets();
    	for(int n=0;n<debets.size();n++){
    		Debet debet = (Debet)debets.elementAt(n);
   			if(debet!=null){
	            totalDebet+=debet.getAmount();
	            totalinsurardebet+=debet.getInsurarAmount();
   			}
    	}
    	
        table.addCell(createTotalPriceCell(totalDebet,1,invoice.getDate()));
        table.addCell(createValueCell(getTran("web","cashiersignature"),3,8,Font.NORMAL));
        table.addCell(createValueCell(getTran("web","payments"),1,8,Font.NORMAL));
        double totalCredit=0;
        for(int n=0;n<invoice.getCredits().size();n++){
            PatientCredit credit = PatientCredit.get((String)invoice.getCredits().elementAt(n));
            totalCredit+=credit.getAmount();
        }
        cell=createTotalPriceCell(totalCredit,1,invoice.getDate());
        cell.setBorder(PdfPCell.BOTTOM);
        table.addCell(cell);
        table.addCell(createValueCell(ScreenHelper.stdDateFormat.format(new Date())+" - "+user.person.getFullName(),3,8,Font.NORMAL));
        if(invoice.getBalance()>0 && Balance.getActiveBalance(patient.personid).getMinimumBalance()>Balance.getPatientBalance(patient.personid)){
        	table.addCell(createValueCell(getTran("web.finance","unauthorizedbalance"),1,MedwanQuery.getInstance().getConfigInt("unauthorizedBalanceFontSize",10),Font.BOLD));
        }
        else {
        	table.addCell(createValueCell(getTran("web.finance","balance"),1,8,Font.NORMAL));
        }
        table.addCell(createTotalPriceCell(invoice.getBalance(),1,invoice.getDate()));
        table.addCell(createEmptyCell(3));
        table.addCell(createValueCell(getTran("web","insurar"),1,8,Font.ITALIC));
        cell = new PdfPCell(new Paragraph(priceFormat.format(totalinsurardebet)+" "+sCurrency,FontFactory.getFont(FontFactory.HELVETICA,7,Font.ITALIC)));
        cell.setColspan(1);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        table.addCell(cell);
        cell = new PdfPCell(table);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setColspan(40);
        receiptTable.addCell(cell);
        receiptTable.addCell(createEmptyCell(50));
        receiptTable.addCell(createValueCell(getTran("web","service"),10,8,Font.BOLD));
        receiptTable.addCell(createValueCell(invoice.getServicesAsString(sPrintLanguage),40,7,Font.NORMAL));
        //If associated clinicians have been registered, then show them
        String clinicians=invoice.getCliniciansAsString();
        if(clinicians.length()>0){
            receiptTable.addCell(createValueCell(getTran("web","clinician"),10,8,Font.BOLD));
            receiptTable.addCell(createValueCell(clinicians,40,7,Font.NORMAL));
        }
        receiptTable.addCell(createValueCell(getTran("web","prestations"),10,8,Font.BOLD));
        int nLines=2;
        //Summarize debets contant
        SortedMap debetlines = new TreeMap();
        for(int n=0;n<debets.size();n++){
            Debet debet = (Debet)debets.elementAt(n);
            String extraInsurar="";
            if(debet.getExtraInsurarUid()!=null && debet.getExtraInsurarUid().length()>0){
                Insurar exIns = Insurar.get(debet.getExtraInsurarUid());
                if(exIns!=null){
                    extraInsurar=" >>> "+ScreenHelper.checkString(exIns.getName());
                    if(extraInsurar.indexOf("#")>-1){
                        extraInsurar=extraInsurar.substring(0,extraInsurar.indexOf("#"));
                    }
                }
            }
            String debetline = " x  ["+debet.getPrestation().getCode()+"] "+debet.getPrestation().getDescription()+extraInsurar;
            if(debetlines.get(debetline)==null){
            	debetlines.put(debetline, (double)0);
            }
            debetlines.put(debetline, (Double)debetlines.get(debetline)+debet.getQuantity());
        }
        Iterator iDebets = debetlines.keySet().iterator();
        while(iDebets.hasNext()){
        	String debetline = (String)iDebets.next();
        	if(nLines==0){
                receiptTable.addCell(createEmptyCell(10));
                nLines=1;
        	}
        	else if(nLines==1){
        		nLines=0;
        	}
        	else {
        		nLines=1;
        	}
            receiptTable.addCell(createValueCell(debetlines.get(debetline)+debetline,20,7,Font.NORMAL));
        }
        receiptTable.addCell(createEmptyCell(50-((debetlines.size() % 2)*20)));
        receiptTable.addCell(createEmptyCell(50));
        receiptTable.addCell(createCell(createValueCell(" "),50,PdfPCell.ALIGN_CENTER,PdfPCell.BOTTOM));
        receiptTable.addCell(createEmptyCell(50));
        doc.add(receiptTable);
    }


    //---- ADD HEADING (logo & barcode) -----------------------------------------------------------
    private void addHeading(PatientInvoice invoice) throws Exception {
        table = new PdfPTable(5);
        table.setWidthPercentage(pageWidth);

        try {
            //*** logo ***
            try{
                Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
                int imgwidth=75,imgheight=75;
                Vector debets = invoice.getDebets();
                for(int n=0;n<debets.size();n++){
                	Debet debet = (Debet)debets.elementAt(n);
                	if(debet.getInsurance()!=null && debet.getInsurance().getInsurarUid()!=null && MedwanQuery.getInstance().getConfigString("insurancelogo."+debet.getInsurance().getInsurarUid(),"").length()>0){
                		img = Miscelaneous.getImage(MedwanQuery.getInstance().getConfigString("insurancelogo."+debet.getInsurance().getInsurarUid(),""),sProject);
                		imgwidth=MedwanQuery.getInstance().getConfigInt("insurancelogo."+debet.getInsurance().getInsurarUid()+".width",imgwidth);
                		imgheight=MedwanQuery.getInstance().getConfigInt("insurancelogo."+debet.getInsurance().getInsurarUid()+".height",imgheight);
                		break;
                	}
                }
                img.scaleToFit(imgwidth,imgheight);
                cell = new PdfPCell(img);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setColspan(1);
                table.addCell(cell);
            }
            catch(Exception e){
                Debug.println("WARNING : PDFPatientInvoiceGenerator --> IMAGE NOT FOUND : logo_"+sProject+".gif");
                e.printStackTrace();
                cell = new PdfPCell();
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setColspan(1);
                table.addCell(cell);
            }

            //*** title ***
            if(invoice.getInvoiceNumber().equalsIgnoreCase(invoice.getInvoiceUid())){
                table.addCell(createTitleCell((sProforma.equalsIgnoreCase("yes")?ScreenHelper.getTranNoLink("invoice","PROFORMA",sPrintLanguage)+" #"+invoice.getInvoiceNumber():sProforma.equalsIgnoreCase("debetnote")?ScreenHelper.getTranNoLink("invoice","DEBETNOTE",sPrintLanguage)+" #"+invoice.getInvoiceNumber():getTran("web","invoice").toUpperCase()+" #"+invoice.getInvoiceNumber())+" - "+ScreenHelper.stdDateFormat.format(invoice.getDate()),"",3));
            }
            else {
            	PdfPTable table2 = new PdfPTable(1);
                table2.setWidthPercentage(100);
                table2.addCell(createTitleCell((sProforma.equalsIgnoreCase("yes")?ScreenHelper.getTranNoLink("invoice","PROFORMA",sPrintLanguage)+" #"+invoice.getInvoiceNumber():sProforma.equalsIgnoreCase("debetnote")?ScreenHelper.getTranNoLink("invoice","DEBETNOTE",sPrintLanguage)+" #"+invoice.getInvoiceNumber():getTran("web","invoice").toUpperCase()+" #"+invoice.getInvoiceNumber())+" - "+ScreenHelper.stdDateFormat.format(invoice.getDate()),"",1));
            	cell=createValueCell(getTran("web.occup","medwan.common.reference")+": "+invoice.getInvoiceUid(),1,8,Font.NORMAL);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            	table2.addCell(cell);
            	cell = new PdfPCell(table2);
                cell.setBorder(PdfPCell.NO_BORDER);
            	cell.setColspan(3);
            	table.addCell(cell);
            }


            if(!(sProforma.equalsIgnoreCase("yes") || sProforma.equalsIgnoreCase("debetnote")) || MedwanQuery.getInstance().getConfigInt("showBarcodeForProformaInvoices",0)==1){
                //*** barcode ***
                Image image = PdfBarcode.getBarcode("7"+invoice.getInvoiceUid(),invoice.getInvoiceUid(), docWriter);            
                cell = new PdfPCell(image);
                cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
                cell.setBorder(PdfPCell.NO_BORDER);
                cell.setColspan(1);
            }
            else {
                cell = createEmptyCell(1);
            }
            table.addCell(cell);
            doc.add(table);
            addBlankRow();
            addBlankRow();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //--- ADD PATIENT DATA ------------------------------------------------------------------------
    private void addPatientData(){
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(pageWidth);

        PdfPTable patientTable = new PdfPTable(3);
        patientTable.setWidthPercentage(pageWidth);

        try {
            //--- LEFT SUB TABLE ----------------------------------------------
            PdfPTable leftTable = new PdfPTable(3);

            //*** contact data ***
            String sContactData = "";
            AdminPrivateContact apc = patient.getActivePrivate();
            if(apc!=null){
                sContactData+= apc.address+
                               "\n"+apc.zipcode+" "+apc.city;

                // additional data
                if(apc.province.length() > 0) sContactData+= "\n"+getTran("province",apc.province);
                if(apc.district.length() > 0) sContactData+= "\n"+apc.district;
                if(apc.sector.length() > 0)   sContactData+= "\n"+apc.sector;

                sContactData+= "\n"+getTran("country",apc.country);
            }

            leftTable.addCell(createValueCell(sContactData,3));

            cell = createCell(new PdfPCell(leftTable),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
            patientTable.addCell(cell);

            //--- RIGHT SUB TABLE ---------------------------------------------
            PdfPTable rightTable = new PdfPTable(9);

            //*** date of birth ***
            String sData = patient.dateOfBirth;
            if(sData.length() > 0){
                rightTable.addCell(createValueCell(getTran("web","dateofbirth"),2));
                rightTable.addCell(createValueCell(":   "+sData,7));
            }

            //*** gender ***
            sData = patient.gender;
            if(sData.length() > 0){
                rightTable.addCell(createValueCell(getTran("web","gender"),2));
                rightTable.addCell(createValueCell(":   "+sData,7));
            }

            //*** person id ***
            sData = patient.personid;
            if(sData.length() > 0){
                rightTable.addCell(createValueCell(getTran("web","personid"),2));
                rightTable.addCell(createValueCell(":   "+sData,7));
            }

            //*** natreg ***
            sData = patient.getAdminID("natreg")==null?"":patient.getAdminID("natreg").value;
            if(sData.length() > 0){
                rightTable.addCell(createValueCell(getTran("web","natreg"),2));
                rightTable.addCell(createValueCell(":   "+sData,7));
            }

            cell = createCell(new PdfPCell(rightTable),2,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
            patientTable.addCell(cell);

            // title = patient name
            String sPatientName = patient.lastname+" "+patient.firstname;
            table.addCell(createGrayCell(getTran("web","patient")+": "+sPatientName.toUpperCase(),1,9,Font.BOLD));
            cell = createCell(new PdfPCell(patientTable),1,PdfPCell.ALIGN_CENTER,PdfPCell.BOX);
            cell.setPadding(cellPadding);
            table.addCell(cell);

            doc.add(table);
            addBlankRow();
            
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //--- ADD INSURANCE DATA ----------------------------------------------------------------------
    private void addInsuranceData(Insurance insurance,PatientInvoice invoice){
        try {
            if(insurance!=null){
                InsuranceCategory insuranceCat = insurance.getInsuranceCategory();
                if(insuranceCat!=null){
                    Insurar insurar = insuranceCat.getInsurar();
                    if(!insurar.getUid().equals(getConfigString("patientSelfInsurarUID"))){
                        PdfPTable table = new PdfPTable(1);
                        table.setWidthPercentage(pageWidth);

                        PdfPTable insuranceTable = new PdfPTable(1);
                        insuranceTable.addCell(createGrayCell(getTran("web","insurancyData").toUpperCase(),1));
                        cell = new PdfPCell(getInsuranceData(insurance,invoice));
                        cell.setPadding(cellPadding);
                        insuranceTable.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.BOX));
                        table.addCell(createCell(new PdfPCell(insuranceTable),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER));
                        table.addCell(createEmptyCell(1));

                        doc.add(table);
                    }
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //--- PRINT INVOICE ---------------------------------------------------------------------------
    private void printDebets(PatientInvoice invoice,Vector debets){
        try{
            PdfPTable table = new PdfPTable(1);
            table.setWidthPercentage(pageWidth);

            // debets
            table.addCell(createGrayCell(getTran("web","invoiceDebets").toUpperCase(),1));
            getDebets(invoice,table,debets);
            table.addCell(createEmptyCell(1));
            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    private void printInvoice(PatientInvoice invoice,Vector debets){
        try {
            PdfPTable table = new PdfPTable(1);
            table.setWidthPercentage(pageWidth);

            // credits
            PdfPTable creditTable = new PdfPTable(1);
            creditTable.addCell(createGrayCell(getTran("web","invoiceCredits").toUpperCase(),1));
            cell = new PdfPCell(getCredits(invoice));
            cell.setPadding(cellPadding);
            creditTable.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.BOX));
            table.addCell(createCell(new PdfPCell(creditTable),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER));
            table.addCell(createEmptyCell(1));

            // saldo
            PdfPTable saldoTable = new PdfPTable(1);
            saldoTable.addCell(createGrayCell(getTran("web","invoiceSaldo").toUpperCase(),1));
            if(MedwanQuery.getInstance().getConfigInt("enableESDFormat",0)==0){
            	cell = new PdfPCell(getSaldo(debets, invoice));
            }
            else {
            	cell = new PdfPCell(getSaldoESD(debets, invoice));
            }
            cell.setPadding(cellPadding);
            saldoTable.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.BOX));
            table.addCell(createCell(new PdfPCell(saldoTable),1,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER));
            table.addCell(createEmptyCell(1));

            doc.add(table);

            table = new PdfPTable(2);
            table.setWidthPercentage(pageWidth);
            // "printed by" info
    		if(sProforma.equalsIgnoreCase("yes") && MedwanQuery.getInstance().getConfigInt("ebableProformaInvoiceComment",0)==1){
    			String comment = getTran("web","proformainvoicecomment");
    			String clinictype="standardclinic";
    			HashSet services = invoice.getServices();
    			Iterator iServices = services.iterator();
    			while(iServices.hasNext()){
    				String uid = (String)iServices.next();
    				Service service = Service.getService(uid);
    				if(service!=null && service.code3!=null && service.code3.equalsIgnoreCase("privateclinic")){
    					clinictype="privateclinic";
    				}
    			}
    			if(!ScreenHelper.getTranNoLink("web","proformainvoicecomment."+clinictype,sPrintLanguage).equalsIgnoreCase("proformainvoicecomment."+clinictype)){
    				comment=ScreenHelper.getTranNoLink("web","proformainvoicecomment."+clinictype,sPrintLanguage);
    			}
	            table.addCell(createValueCell(comment,2));
	            cell=createValueCell("\n",2);
    		}
            table.addCell(createCell(new PdfPCell(getPrintedByInfo()),2,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));
            if(invoice.getAcceptationUid()!=null && invoice.getAcceptationUid().length()>0){
            	User validatinguser = User.get(Integer.parseInt(invoice.getAcceptationUid()));
	            cell=createValueCell(getTran("web","validatedby")+": "+validatinguser.person.lastname.toUpperCase()+", "+validatinguser.person.firstname+" ("+validatinguser.userid+")",2);
	            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	            table.addCell(cell);
            }
            
            cell=createValueCell("\n",2);
            table.addCell(cell);


    		if(invoice.getEstimatedDeliveryDate()!=null && invoice.getEstimatedDeliveryDate().length()>0){
        		table.addCell(createValueCell(ScreenHelper.getTran(null,"web","estimateddeliverydate",sPrintLanguage)+": "+invoice.getEstimatedDeliveryDate(),2));
    		}
    		String signatures="";
    		Vector pointers=Pointer.getPointers("INVSIGN."+invoice.getUid());
    		for(int n=0;n<pointers.size();n++){
    			if(n>0){
    				signatures+=", ";
    			}
    			signatures+=(String)pointers.elementAt(n);
    		}
    		if(signatures.length()>0){
    			signatures="\n"+ScreenHelper.getTran(null,"web.finance","signed.by",sPrintLanguage)+": "+signatures;
    		}
            if(MedwanQuery.getInstance().getConfigInt("enableInvoiceVerification",0)==1){
	            table.addCell(createValueCell(getTran("careproviderSignature")+signatures,1));
	            table.addCell(createValueCell(getTran("verifiersignature")+"\n\n"+checkString(invoice.getVerifier()),1));
            }
            else {
            	if(MedwanQuery.getInstance().getConfigInt("printPatientSignatureOnInvoice",1)==1){
            		String sSignature=getTran("patientsignature");
            		if(invoice.hasPatientSignature()){
            			sSignature+="\n"+getTran("electronicsignature")+" #"+ScreenHelper.base64Compress(invoice.getUid());
            		}
            		table.addCell(createValueCell(sSignature,1));
            	}
            	else {
            		table.addCell(createValueCell("",1));
            	}
	            table.addCell(createValueCell(getTran("careproviderSignature")+signatures,1));
            }
            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //### PRIVATE METHODS #########################################################################

    //--- GET INSURANCE DATA ----------------------------------------------------------------------
    private PdfPTable getInsuranceData(Insurance insurance,PatientInvoice invoice){
        PdfPTable table = new PdfPTable(14);
        table.setWidthPercentage(pageWidth);

        InsuranceCategory insuranceCat = insurance.getInsuranceCategory();
        Insurar insurar = insuranceCat.getInsurar();
        double patientShare = Double.parseDouble(insuranceCat.getPatientShare());

        //*** ROW 1 ***
        // insurar name
        table.addCell(createLabelCell(getTran("web","insurar"),2));
        table.addCell(createValueCell(":   "+insurar.getName(),5,8,Font.BOLD));

        // patient share
        table.addCell(createLabelCell(getTran("system.manage","categorypatientshare"),2));
        cell = createValueCell(":   "+(insurar.getUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP",""))?MedwanQuery.getInstance().getConfigString("MFPPatientShares",patientShare+""):patientShare+"")+" %",2);
        table.addCell(cell);
        table.addCell(createLabelCell(getTran("hrm","dossiernr"),1));
        table.addCell(createValueCell(":   "+insurance.getInsuranceNr(),2));

        //*** ROW 2 ***
        // insurance category
        table.addCell(createLabelCell(getTran("web","tariff"),2));
        table.addCell(createValueCell(":   "+ getTran("insurance.types",insurance.getType()),5));

        // insurar share
        table.addCell(createLabelCell(getTran("system.manage","categoryinsurarshare"),2));
        cell = createValueCell(":   "+(insurar.getUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("MFP",""))?MedwanQuery.getInstance().getConfigString("MFPInsurarShares",(100-patientShare)+""):(100-patientShare)+"")+" %",2);
        table.addCell(cell);
        table.addCell(createLabelCell(getTran("insurance","memberimmat"),1));
        table.addCell(createValueCell(":   "+insurance.getMemberImmat(),2));

        //*** ROW 3 ***
        // insurance category
        table.addCell(createLabelCell(getTran("web.finance","insurarreference"),2));
        table.addCell(createValueCell(":   "+invoice.getInsurarreference()+(invoice.getInsurarreferenceDate()!=null && invoice.getInsurarreferenceDate().length()>0?" ("+invoice.getInsurarreferenceDate()+")":""),5));
        table.addCell(createLabelCell(getTran("insurance","member"),2));
        table.addCell(createValueCell(":   "+ScreenHelper.checkString(insurance.getMember()),5));
        
        if(invoice.getComment().length()>0){
	        table.addCell(createLabelCell(getTran("web.finance","otherreference"),2));
	        table.addCell(createValueCell(":   "+invoice.getComment(),12));
        }

        if(invoice.getMfpDoctor().length()>0 || invoice.getMfpDrugReceiver().length()>0 || invoice.getMfpPost().length()>0){
        	if(MedwanQuery.getInstance().getConfigInt("hideCCBRTInvoiceFields",1)==0){
	            table.addCell(createLabelCell(getTran("web.finance","ccbrt.specialauthorizationnumber"),2));
	            table.addCell(createValueCell(":   "+invoice.getMfpDoctor()+(invoice.getMfpDrugReceiver().length()>0?" ("+getTran("nhif.authorizationtypes",invoice.getMfpDrugReceiver())+")":""),5));
	            table.addCell(createLabelCell(getTran("web","ccbrt.comment"),2));
	            table.addCell(createValueCell(":   "+invoice.getMfpPost(),5));
        	}
        }

        //*** ROW 4 ***
        // complementary insurar
        Vector debets = invoice.getDebets();
        HashSet insurances = new HashSet();
        String extraInsurars="";
        for (int n=0;n<debets.size();n++){
        	Debet debet = (Debet)debets.elementAt(n);
        	if(debet.getExtraInsurarUid()!=null){
        		Insurar ins = Insurar.get(debet.getExtraInsurarUid());
        		if(ins!=null && ins.getName()!=null && ins.getName().length()>0){
        			insurances.add(ins.getName());
        		}
        	}
        }
        Iterator iIns = insurances.iterator();
        while(iIns.hasNext()){
        	if(extraInsurars.length()>0){
        		extraInsurars+=", ";
        	}
        	extraInsurars+=(String)iIns.next();
        }
        if(extraInsurars.length()>0){
	        table.addCell(createLabelCell(getTran("web","complementarycoverage"),2));
	        table.addCell(createValueCell(":   "+extraInsurars,12));
        }
        return table;
    }

    //--- GET DEBETS (prestations) ----------------------------------------------------------------
    private void getDebets(PatientInvoice invoice,PdfPTable tableParent,Vector debets){

        Vector newdebets = new Vector();
        if(MedwanQuery.getInstance().getConfigInt("defaultInvoiceSummarizeDebets",0)==1){
            SortedMap prestations = new TreeMap();
            for(int n=0;n<debets.size();n++){
            	Debet debet = (Debet)debets.elementAt(n);
            	if(debet.getPrestation()!=null && debet.getQuantity()!=0){
        			//printDebet(debet,table);
            		if(prestations.get(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid())==null){
            			prestations.put(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid(), debet);
            		}
            		else {
            			Debet olddebet = (Debet)prestations.get(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid());
            			olddebet.setQuantity(olddebet.getQuantity()+debet.getQuantity());
            			olddebet.setAmount(olddebet.getAmount()+debet.getAmount());
            			olddebet.setInsurarAmount(olddebet.getInsurarAmount()+debet.getInsurarAmount());
            			olddebet.setExtraInsurarAmount(olddebet.getExtraInsurarAmount()+debet.getExtraInsurarAmount());
            			olddebet.setDate(debet.getDate());
            		}
            	}
            }
            Iterator iDebets = prestations.keySet().iterator();
            while(iDebets.hasNext()){
            	newdebets.add(prestations.get(iDebets.next()));
            }
        }
        else {
        	newdebets=debets;
        }
        if(newdebets.size() > 0){
            PdfPTable table = new PdfPTable(200);
            table.setWidthPercentage(pageWidth);
            // header
            cell = createUnderlinedCell(getTran("web","dateandencounter"),1);
            PdfPTable singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),30,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","prestation"),1);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),60,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell("#",1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),10,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","unitprice.abbreviation"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),20,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","amount"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),20,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","patient"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),20,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","insurar"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),20,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","extrainsurar"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),20,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = new PdfPCell(table);
            cell.setPadding(cellPadding);
            tableParent.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));

            // print debets
            double totalPatient = 0, totalInsurar = 0, totalExtraInsurar=0;
            Debet debet;
            String activePrestationClass="";

            for(int i=0; i<newdebets.size(); i++){
                table = new PdfPTable(200);
                table.setWidthPercentage(pageWidth);
                debet = (Debet)newdebets.get(i);
                String prestationClass= debet.getPrestation().getReferenceObject().getObjectType()==null?"?":debet.getPrestation().getReferenceObject().getObjectType();
                if(!prestationClass.equalsIgnoreCase(activePrestationClass)){
                    //This is a new prestation class, go calculate the header
                    activePrestationClass=prestationClass;
                    printPrestationClass(table,activePrestationClass,newdebets);
                }
                totalPatient+= debet.getAmount();
                totalInsurar+= debet.getInsurarAmount();
                totalExtraInsurar+= debet.getExtraInsurarAmount();
                printDebet(table,debet);
                cell = new PdfPCell(table);
                cell.setPadding(0);
                tableParent.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));
            }

            table = new PdfPTable(20);

            table.addCell(createEmptyCell(7));
            cell = createLabelCell(getTran("web","subtotalpriceprestations"),5);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(cellPadding);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(totalPatient+totalInsurar+totalExtraInsurar,2));
            table.addCell(createTotalPriceCell(totalPatient,2));

            table.addCell(createTotalPriceCell(totalInsurar,2));

            table.addCell(createTotalPriceCell(totalExtraInsurar,2));
            cell = new PdfPCell(table);
            cell.setPadding(cellPadding);
            tableParent.addCell(createCell(cell,1,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));

            this.patientDebetTotal += totalPatient;
            this.insurarDebetTotal += totalInsurar;
        }
        else{
            table.addCell(createValueCell(getTran("web","noDataAvailable"),20));
        }

    }

    //--- GET CREDITS (payments) ------------------------------------------------------------------
    private PdfPTable getCredits(PatientInvoice invoice){
        PdfPTable table = new PdfPTable(20);
        table.setWidthPercentage(pageWidth);

        Vector creditUids = invoice.getCredits();
        if(creditUids.size() > 0){
            // header
            cell = createUnderlinedCell(getTran("web","date"),1);
            PdfPTable singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),2,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","type"),1);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),3,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","comment"),1);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),9,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(getTran("web","patient"),1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),3,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            cell = createUnderlinedCell(" ",1);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            singleCellHeaderTable = new PdfPTable(1);
            singleCellHeaderTable.addCell(cell);
            cell = createCell(new PdfPCell(singleCellHeaderTable),3,PdfPCell.ALIGN_CENTER,PdfPCell.NO_BORDER);
            cell.setPaddingRight(2);
            table.addCell(cell);

            // get credits from uids
            double total = 0;
            Hashtable creditsHash = new Hashtable();
            PatientCredit credit;
            String sCreditUid;

            for(int i=0; i<creditUids.size(); i++){
                sCreditUid = (String)creditUids.get(i);
                credit = PatientCredit.get(sCreditUid);
                creditsHash.put(new SimpleDateFormat("yyyyMMddHHmmss").format(credit.getDate())+"."+credit.getUid(),credit);
            }

            // sort credits on date
            Vector creditDates = new Vector(creditsHash.keySet());
            Collections.sort(creditDates);
            Collections.reverse(creditDates);

            String creditDate;
            for(int i=0; i<creditDates.size(); i++){
                creditDate = (String)creditDates.get(i);
                credit = (PatientCredit)creditsHash.get(creditDate);
                if(credit.getAmount()>=0){
	                total+= credit.getAmount();
	                printCredit(table,credit);
                }
            }
            for(int i=0; i<creditDates.size(); i++){
                creditDate = (String)creditDates.get(i);
                credit = (PatientCredit)creditsHash.get(creditDate);
                if(credit.getAmount()<0){
	                total+= credit.getAmount();
	                printCredit(table,credit);
                }
            }

            // spacer
            //table.addCell(createEmptyCell(20));

            // display credit total
            table.addCell(createEmptyCell(9));
            cell = createLabelCell(getTran("web","subtotalpricepayments"),5);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(cellPadding);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(total,3));
            table.addCell(createEmptyCell(3));

            this.creditTotal = total;
        }
        else{
            table.addCell(createValueCell(getTran("web","noDataAvailable"),20));
        }

        return table;
    }

    //--- PRINT PRESTATIONCLASS -------------------------------------------------------------------
    private void printPrestationClass(PdfPTable invoiceTable,String prestationClass,Vector debets){
        double classPatientAmount = 0,classInsurarAmount=0,classExtraInsurarAmount=0;
        for(int n=0;n<debets.size();n++){
            Debet debet = (Debet)debets.elementAt(n);
            String sClass= debet.getPrestation().getReferenceObject().getObjectType()==null?"?":debet.getPrestation().getReferenceObject().getObjectType();
            if(sClass.equalsIgnoreCase(prestationClass)){
                classPatientAmount+=debet.getAmount();
                classInsurarAmount+=debet.getInsurarAmount();
                classExtraInsurarAmount+=debet.getExtraInsurarAmount();
            }
        }
        cell = new PdfPCell(new Paragraph(getTran("prestationclass",prestationClass),FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(120);
        cell.setBorder(PdfPCell.BOX);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
        invoiceTable.addCell(cell);
        cell = new PdfPCell(new Paragraph(priceFormat.format(classPatientAmount+classInsurarAmount+classExtraInsurarAmount)+" "+sCurrency,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(20);
        cell.setBorder(PdfPCell.BOX);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        invoiceTable.addCell(cell);
        cell = new PdfPCell(new Paragraph(priceFormat.format(classPatientAmount)+" "+sCurrency,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(20);
        cell.setBorder(PdfPCell.BOX);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        invoiceTable.addCell(cell);
        cell = new PdfPCell(new Paragraph(priceFormat.format(classInsurarAmount)+" "+sCurrency,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(20);
        cell.setBorder(PdfPCell.BOX);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        invoiceTable.addCell(cell);
        cell = new PdfPCell(new Paragraph(priceFormat.format(classExtraInsurarAmount)+" "+sCurrency,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLDITALIC)));
        cell.setColspan(20);
        cell.setBorder(PdfPCell.BOX);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        invoiceTable.addCell(cell);
    };

    //--- PRINT DEBET (prestation) ----------------------------------------------------------------
    private void printDebet(PdfPTable invoiceTable, Debet debet){
        String sDebetDate = new SimpleDateFormat("d/M/yy").format(debet.getDate());
        double debetAmountPatient = debet.getAmount();
        double debetAmountInsurar = debet.getInsurarAmount();
        double debetAmountExtraInsurar = debet.getExtraInsurarAmount();

        // encounter
        Encounter debetEncounter = debet.getEncounter();
        String sEncounterName = debetEncounter.getUid();

        // prestation
        Prestation prestation = debet.getPrestation();
        String sPrestationCode  = "", sPrestationDescr = "";
        if(prestation!=null){
            sPrestationCode  = checkString(prestation.getCode());
            sPrestationDescr = checkString(prestation.getDescription());
        }

        if(sPrestationCode.length() > 0){
            sPrestationCode = "["+sPrestationCode+"] ";
        }

        // row
        invoiceTable.addCell(createValueCell(sDebetDate+" "+sEncounterName,30));
        String extraInsurar="";
        if(MedwanQuery.getInstance().getConfigInt("enableExtraInsurarDataForDebetsDefaultInvoice",1)==1 && debet.getExtraInsurarUid()!=null && debet.getExtraInsurarUid().length()>0){
            Insurar exIns = Insurar.get(debet.getExtraInsurarUid());
            if(exIns!=null){
                extraInsurar=" >>> "+ScreenHelper.checkString(exIns.getName());
                if(extraInsurar.indexOf("#")>-1){
                    extraInsurar=extraInsurar.substring(0,extraInsurar.indexOf("#"));
                }
            }
        }
        invoiceTable.addCell(createValueCell(sPrestationCode+sPrestationDescr+extraInsurar,60));
        cell=createValueCell(debet.getQuantity()+"",10);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        invoiceTable.addCell(cell);
        invoiceTable.addCell(createPriceCell((debetAmountPatient+debetAmountInsurar+debetAmountExtraInsurar)/debet.getQuantity(),20));
        invoiceTable.addCell(createPriceCell((debetAmountPatient+debetAmountInsurar+debetAmountExtraInsurar),20));
        invoiceTable.addCell(createPriceCell(debetAmountPatient,20));
        invoiceTable.addCell(createPriceCell(debetAmountInsurar,20));
        invoiceTable.addCell(createPriceCell(debetAmountExtraInsurar,20));
    }

    //--- PRINT CREDIT (payment) ------------------------------------------------------------------
    private void printCredit(PdfPTable invoiceTable, PatientCredit credit){
        String sCreditDate = ScreenHelper.stdDateFormat.format(credit.getDate());
        double creditAmount = credit.getAmount();
        String sCreditComment = checkString(credit.getComment());
        String sCreditType = getTran("credit.type",credit.getType());

        // row
        invoiceTable.addCell(createValueCell(sCreditDate,2));
        invoiceTable.addCell(createValueCell(sCreditType,3));
        invoiceTable.addCell(createValueCell(sCreditComment,9));
        invoiceTable.addCell(createPriceCell(creditAmount,3));
        invoiceTable.addCell(createEmptyCell(3));
    }

    //--- GET SALDO -------------------------------------------------------------------------------
    private PdfPTable getSaldo(Vector debets, PatientInvoice invoice){
        PdfPTable table = new PdfPTable(20);
        table.setWidthPercentage(pageWidth);

        // debets
        table.addCell(createEmptyCell(9));
        cell = createLabelCell(getTran("web","totalprice"),5);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
        table.addCell(createTotalPriceCell(this.patientDebetTotal,3,invoice.getDate()));
        table.addCell(createEmptyCell(3));

        // credits
        table.addCell(createEmptyCell(9));
        cell = createLabelCell(getTran("web","invoiceCredits"),5);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
        table.addCell(createTotalPriceCell(this.creditTotal,(this.creditTotal>=0),3,invoice.getDate()));
        table.addCell(createEmptyCell(3));

        // saldo
        table.addCell(createEmptyCell(9));
        cell = createBoldLabelCell(getTran("web","balance").toUpperCase(),5);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
        double saldo = (this.patientDebetTotal - Math.abs(this.creditTotal));
        table.addCell(createTotalPriceCell(saldo,3,invoice.getDate()));
        table.addCell(createEmptyCell(3));

        
        double complementaryinsurar = 0;
        String sComplementaryInsurars="";
        for (int n=0;n<debets.size();n++){
        	Debet debet = (Debet)debets.elementAt(n);
        	if(debet.getExtraInsurarUid2()!=null && debet.getExtraInsurarUid2().length()>0){
        		Insurar e2 = Insurar.get(debet.getExtraInsurarUid2());
        		if(e2!=null){
        			String sName = e2.getName();
        			if(sComplementaryInsurars.indexOf(sName)<0){
        				if(sComplementaryInsurars.length()>0){
        					sComplementaryInsurars+=", ";
        				}
        				sComplementaryInsurars+=sName;
        			}
        		}
        		complementaryinsurar+=debet.getAmount();
        	}
        }
        // complementary insurar
        table.addCell(createEmptyCell(9));
        cell = createBoldLabelCell(getTran("web","complementarycoverage2").toUpperCase()+" ("+sComplementaryInsurars+")",5);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
        table.addCell(createTotalPriceCell(complementaryinsurar,3,invoice.getDate()));
        table.addCell(createEmptyCell(3));


        return table;
    }
    
    //--- GET SALDO -------------------------------------------------------------------------------
    private PdfPTable getSaldoESD(Vector debets, PatientInvoice invoice){
        String sAlternateCurrency = MedwanQuery.getInstance().getConfigString("AlternateCurrency","");

    	PdfPTable table = new PdfPTable(40);
        table.setWidthPercentage(pageWidth);

        // debets
        table.addCell(createEmptyCell(1));
        cell = createLabelCell(getTran("web","totalprice")+" "+getTran("web","esdcurrency1"),10);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
		String sValue=new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(this.patientDebetTotal/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency;
    	if(MedwanQuery.getInstance().getConfigInt("totalAlternatePriceCurrencyBeforeAmount",0)==1){
    		sValue=sAlternateCurrency+" "+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(this.patientDebetTotal/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()));
    	}
    	cell=createValueCell(sValue,6,7,Font.BOLD);
    	cell.setBorder(PdfPCell.TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        table.addCell(cell);
        table.addCell(createEmptyCell(3));
        if(sAlternateCurrency.length()>0){
            table.addCell(createEmptyCell(1));
            cell = createLabelCell(getTran("web","totalprice")+" "+getTran("web","esdcurrency2"),10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(5);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(this.patientDebetTotal,6));
            table.addCell(createEmptyCell(3));
        }
        else {
            table.addCell(createEmptyCell(20));
        }

        // credits
        table.addCell(createEmptyCell(1));
        cell = createLabelCell(getTran("web","invoiceCredits"),10);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
		sValue=new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(this.creditTotal/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency;
    	if(MedwanQuery.getInstance().getConfigInt("totalAlternatePriceCurrencyBeforeAmount",0)==1){
    		sValue=sAlternateCurrency+" -"+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(this.creditTotal/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()));
    	}
    	cell=createValueCell(sValue,6,7,Font.BOLD);
    	cell.setBorder(PdfPCell.TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        table.addCell(cell);
        table.addCell(createEmptyCell(3));
        if(sAlternateCurrency.length()>0){
            table.addCell(createEmptyCell(1));
            cell = createLabelCell(getTran("web","invoiceCredits"),10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(5);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(this.creditTotal,(this.creditTotal>=0),6));
            table.addCell(createEmptyCell(3));
        }
        else {
            table.addCell(createEmptyCell(20));
        }

        // saldo
        table.addCell(createEmptyCell(1));
        cell = createBoldLabelCell(getTran("web","balance").toUpperCase(),10);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
        double saldo = (this.patientDebetTotal - Math.abs(this.creditTotal));
		sValue=new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(saldo/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency;
    	if(MedwanQuery.getInstance().getConfigInt("totalAlternatePriceCurrencyBeforeAmount",0)==1){
    		sValue=sAlternateCurrency+" "+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(saldo/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()));
    	}
    	cell=createValueCell(sValue,6,7,Font.BOLD);
    	cell.setBorder(PdfPCell.TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        table.addCell(cell);
        table.addCell(createEmptyCell(3));
        if(sAlternateCurrency.length()>0){
            table.addCell(createEmptyCell(1));
            cell = createBoldLabelCell(getTran("web","balance").toUpperCase(),10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(5);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(saldo,6));
            table.addCell(createEmptyCell(3));
        }
        else {
            table.addCell(createEmptyCell(20));
        }

        
        double complementaryinsurar = 0;
        String sComplementaryInsurars="";
        for (int n=0;n<debets.size();n++){
        	Debet debet = (Debet)debets.elementAt(n);
        	if(debet.getExtraInsurarUid2()!=null && debet.getExtraInsurarUid2().length()>0){
        		Insurar e2 = Insurar.get(debet.getExtraInsurarUid2());
        		if(e2!=null){
        			String sName = e2.getName();
        			if(sComplementaryInsurars.indexOf(sName)<0){
        				if(sComplementaryInsurars.length()>0){
        					sComplementaryInsurars+=", ";
        				}
        				sComplementaryInsurars+=sName;
        			}
        		}
        		complementaryinsurar+=debet.getAmount();
        	}
        }
        // complementary insurar
        table.addCell(createEmptyCell(1));
        cell = createBoldLabelCell(getTran("web","complementarycoverage2").toUpperCase()+" ("+sComplementaryInsurars+")",10);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setPaddingRight(5);
        table.addCell(cell);
		sValue=new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(complementaryinsurar/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()))+" "+sAlternateCurrency;
    	if(MedwanQuery.getInstance().getConfigInt("totalAlternatePriceCurrencyBeforeAmount",0)==1){
    		sValue=sAlternateCurrency+" "+new DecimalFormat(MedwanQuery.getInstance().getConfigString("AlternateCurrencyPriceFormat","# ##0.00")).format(complementaryinsurar/ExportSAP_AR_INV.getExchangeRate(sAlternateCurrency, invoice.getDate()));
    	}
    	cell=createValueCell(sValue,6,7,Font.BOLD);
    	cell.setBorder(PdfPCell.TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        table.addCell(cell);
        table.addCell(createEmptyCell(3));
        if(sAlternateCurrency.length()>0){
            table.addCell(createEmptyCell(1));
            cell = createBoldLabelCell(getTran("web","complementarycoverage2").toUpperCase()+" ("+sComplementaryInsurars+")",10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setPaddingRight(5);
            table.addCell(cell);
            table.addCell(createTotalPriceCell(complementaryinsurar,6));
            table.addCell(createEmptyCell(3));
        }
        else {
            table.addCell(createEmptyCell(20));
        }


        return table;
    }

}