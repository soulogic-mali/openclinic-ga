package be.mxs.common.util.pdf.general;

import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.adt.Encounter;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import net.admin.User;
import net.admin.AdminPerson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.util.Vector;

public class PDFArchiveDocumentBarcodeGenerator extends PDFOfficialBasic {

    // declarations
    private final int pageWidth = 100;
    private String type;
    PdfWriter docWriter=null;
    
    public void addHeader(){
    }
    
    public void addContent(){
    }


    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFArchiveDocumentBarcodeGenerator(User user, String sProject){
        this.user = user;
        this.sProject = sProject;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, AdminPerson person) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

        String sURL = req.getRequestURL().toString();
        if(sURL.indexOf("openclinic",10) > 0){
            sURL = sURL.substring(0,sURL.indexOf("openclinic",10));
        }

        String sContextPath = req.getContextPath()+"/";
        HttpSession session = req.getSession();
        String sProjectDir = (String)session.getAttribute("activeProjectDir");

        this.url = sURL;
        this.contextPath = sContextPath;
        this.projectDir = sProjectDir;

        ///////////////////////////////////////////////////////////////////////////////////////////
    	String sBarcode = checkString(req.getParameter("barcodeValue"));
      	int numberOfPrints = Integer.parseInt(checkString(req.getParameter("numberOfPrints")));

    	Debug.println("\n****************** PDFArchiveDocumentBarcodeGenerator ******************");
    	Debug.println("sBarcode       : "+sBarcode);
    	Debug.println("numberOfPrints : "+numberOfPrints);
        ///////////////////////////////////////////////////////////////////////////////////////////
    	
		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");  
			
			Rectangle rectangle = new Rectangle(0,0,new Float(MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeWidth",360)*72/254).floatValue(),
					                                new Float(MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeHeight",890)*72/254).floatValue());
            doc.setPageSize(rectangle.rotate());
            doc.setMargins(0,0,0,0);
         
            doc.setJavaScript_onLoad(MedwanQuery.getInstance().getConfigString("cardJavaScriptOnLoad","document.print();"));
            doc.open();

            // add content to document            
            for(int n=0; n<numberOfPrints; n++){
                if(n>0){
                	doc.newPage();
                }
            	printBarcode(sBarcode);
                
            }
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

    //--- PRINT BARCODE ---------------------------------------------------------------------------
    protected void printBarcode(String sCode){
        try {
            table = new PdfPTable(MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeColumns",2));
            table.setWidthPercentage(100);

            Image image = PdfBarcode.getQRCode(sCode, docWriter, MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeSize",200));
            if(MedwanQuery.getInstance().getConfigInt("archiveBarcodeScaleToFit",1)==1){
            	image.scaleToFit(doc.right()/MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeColumns",2), doc.top());
            }

            cell = new PdfPCell(image);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setPaddingTop(0);
            cell.setPaddingBottom(0);

            table.addCell(cell);
            
            for (int n=0;n<sCode.length();n++){
            	if(!sCode.substring(n,n+1).equalsIgnoreCase("0")){
            		sCode=sCode.substring(n);
            		break;
            	}
            }
            if(sCode.length()>2){
            	sCode=sCode.substring(0,sCode.length()-2)+"."+sCode.substring(sCode.length()-2);
            }
            cell = createBoldBorderlessCell(sCode,1,1,MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeFontSize",20));
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
            cell.setPaddingTop(0);
            cell.setPaddingBottom(0);
            table.addCell(cell);
            for(int n=2;n<MedwanQuery.getInstance().getConfigInt("archiveDocumentBarcodeColumns",2);n++){
            	cell=createBorderlessCell(1);
                table.addCell(cell);
            }

            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }
    
}
