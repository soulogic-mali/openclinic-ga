package be.mxs.common.util.pdf.general;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ServiceStock;
import be.openclinic.pharmacy.Batch;
import be.openclinic.pharmacy.Product;
import net.admin.User;
import com.itextpdf.text.*;
import com.itextpdf.text.Font;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;

import javax.servlet.http.HttpServletRequest;
import java.io.ByteArrayOutputStream;
import java.util.*;
import java.awt.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;

/**
 * User: stijn smets
 * Date: 24-jan-2007
 */
public class PDFInventoryUpdateGenerator extends PDFBasic {

    // declarations
    private final int pageWidth = 90;
    private boolean bPrintAll = false;


    //--- CONSTRUCTOR --------------------------------------------------------------------------------------------------
    public PDFInventoryUpdateGenerator(User user, String sProject){
        this.user = user;
        this.sProject = sProject;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES ----------------------------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, ServiceStock serviceStock, String printLanguage) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		PdfWriter docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;
        this.sPrintLanguage = printLanguage;
        this.bPrintAll = ("1".equalsIgnoreCase(ScreenHelper.checkString(req.getParameter("printall"))));

        try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
			doc.setPageSize(PageSize.A4);

            doc.open();

            // add content to document
            addPageHeader(serviceStock);
            printInventoryUpdate(serviceStock);
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


    //############################################# PRIVATE METHODS ####################################################
    
    //--- ADD PAGE HEADER ----------------------------------------------------------------------------------------------
    private void addPageHeader(ServiceStock serviceStock) throws Exception {
        table = new PdfPTable(4);
        table.setWidthPercentage(pageWidth);

        // page title
        table.addCell(createTitle(ScreenHelper.getTranNoLink("web","inventoryupdatelist",sPrintLanguage),4));

        // service stock
        cell = createValueCell(ScreenHelper.getTranNoLink("web","serviceStock",sPrintLanguage),1); 
        cell.setBackgroundColor(new BaseColor(245,245,245)); // light grey
        table.addCell(cell);
        table.addCell(createValueCell(serviceStock.getName(),3));

        // print date
        cell = createValueCell(ScreenHelper.getTranNoLink("web","printdate",sPrintLanguage),1);
        cell.setBackgroundColor(new BaseColor(245,245,245)); // light grey
        table.addCell(cell);
        table.addCell(createValueCell(ScreenHelper.fullDateFormat.format(new java.util.Date()),3));

        doc.add(table);
        addBlankRow();
    }

    //--- PRINT PRODUCT STOCK FICHE ------------------------------------------------------------------------------------
    private void printInventoryUpdate(ServiceStock serviceStock){
        try{
            PdfPTable ficheTable = new PdfPTable(67);
            ficheTable.setWidthPercentage(pageWidth);

            //*** HEADER ***
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","code",sPrintLanguage),10));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","product",sPrintLanguage),22));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","batch",sPrintLanguage),7));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","theoretical",sPrintLanguage),7));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","physical",sPrintLanguage),7));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","difference",sPrintLanguage),7));
            ficheTable.addCell(createTitleCell(ScreenHelper.getTranNoLink("web","value",sPrintLanguage),7));

            String sClass = "1", sStockUid = "", sProductUid = "", sProductName = "", sStockBegin = "";
            Product product;
            long day=24*3600*1000;
            double totalDiffVal=0;

            Hashtable productnames = Product.getProductNames();
            Vector productstocks=serviceStock.getProductStocks();
            for(int i=0; i<productstocks.size(); i++){
            	ProductStock productStock = (ProductStock)productstocks.elementAt(i);
                sStockUid = productStock.getUid();

                if(productnames.get(productStock.getProductUid()) != null) {
                    sProductName = (String)productnames.get(productStock.getProductUid());
                    sProductUid = productStock.getProductUid();
                } 
                else{
                    sProductName = getTran("web","nonexistingproduct");
                }
    			
                int stocklevel = productStock.getLevel();
                boolean bHasNegative=false;
               	//We must write a row for each batch with a level<>0
               	Vector batches = Batch.getAllBatches(productStock.getUid());
               	for(int n=0;n<batches.size();n++){
               		Batch batch = (Batch)batches.elementAt(n);
               		String sPhysical=Pointer.getPointer("physical."+productStock.getUid()+"."+batch.getUid());
               		if(sPhysical.length()==0){
               			sPhysical=batch.getLevel()+"";
               		}
               		if((!sPhysical.equalsIgnoreCase(batch.getLevel()+"") || bPrintAll) && batch.getLevel()!=0){
	               		stocklevel-=batch.getLevel();
	                    cell = createValueCell(productStock.getProduct().getCode()+"",10);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(sProductName,22);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(batch.getBatchNumber(),7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(batch.getLevel()+"",7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(sPhysical,7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell((Double.parseDouble(sPhysical)-batch.getLevel())+"",7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    double value=productStock.getProduct().getLastYearsAveragePrice();
	                    double difval=(Double.parseDouble(sPhysical)-batch.getLevel())*value;
	                    totalDiffVal+=difval;
	                    cell = createValueCell(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(difval),7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
               		}
               	}
               	if(stocklevel!=0){
               		String sPhysical=Pointer.getPointer("physical."+productStock.getUid());
               		if(sPhysical.length()==0){
               			sPhysical=stocklevel+"";
               		}
               		if((!sPhysical.equalsIgnoreCase(stocklevel+"") || bPrintAll)){
	                    cell = createValueCell(productStock.getProduct().getCode()+"",10);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(sProductName,22);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell("?",7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(stocklevel+"",7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell(sPhysical,7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    cell = createValueCell((Double.parseDouble(sPhysical)-stocklevel)+"",7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
	                    double value=productStock.getProduct().getLastYearsAveragePrice();
	                    double difval=(Double.parseDouble(sPhysical)-stocklevel)*value;
	                    totalDiffVal+=difval;
	                    cell = createValueCell(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(difval),7);
	                    cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
	                    ficheTable.addCell(cell);
               		}
               	}	
            }
           	cell = emptyCell(60);
           	cell.setBorder(PdfPCell.NO_BORDER);
           	ficheTable.addCell(cell);
            cell = createValueCell(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat","#")).format(totalDiffVal),7);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            ficheTable.addCell(cell);

            doc.add(ficheTable);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
    
    //################################### UTILITY FUNCTIONS ############################################################

    //--- CREATE TITLE -------------------------------------------------------------------------------------------------
    protected PdfPCell createTitle(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,10,Font.UNDERLINE)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        cell.setPaddingBottom(20);

        return cell;
    }

    //--- CREATE BORDERLESS CELL ---------------------------------------------------------------------------------------
    protected PdfPCell createBorderlessCell(String value, int height, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setPaddingTop(height); //
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    protected PdfPCell createBorderlessCell(String value, int colspan){
        return createBorderlessCell(value,3,colspan);
    }

    protected PdfPCell createBorderlessCell(int colspan){
        cell = new PdfPCell();
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);

        return cell;
    }

}
