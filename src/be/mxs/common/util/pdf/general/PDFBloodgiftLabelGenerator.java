package be.mxs.common.util.pdf.general;

import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.LabRequest;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.system.SH;
import net.admin.User;
import net.admin.AdminPerson;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.util.Vector;
import java.text.SimpleDateFormat;

/**
 * User: stijn smets
 * Date: 21-nov-2006
 */
public class PDFBloodgiftLabelGenerator extends PDFOfficialBasic {

    // declarations
    private final int pageWidth = 100;
    PdfWriter docWriter=null;
    
    public void addHeader(){
    }
    public void addContent(){
    }


    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFBloodgiftLabelGenerator(User user, String sProject){
        this.user = user;
        this.sProject = sProject;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String transactiondata) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;
        String sURL = req.getRequestURL().toString();
        if(sURL.indexOf("openclinic",10) > 0){
            sURL = sURL.substring(0,sURL.indexOf("openclinic", 10));
        }
        sPrintLanguage=user.person.language;
        String sContextPath = req.getContextPath()+"/";
        HttpSession session = req.getSession();
        String sProjectDir = (String)session.getAttribute("activeProjectDir");

        this.url = sURL;
        this.contextPath = sContextPath;
        this.projectDir = sProjectDir;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
            Rectangle rectangle=null;
            rectangle= new Rectangle(0,0,new Float(MedwanQuery.getInstance().getConfigInt("bloodgiftLabelWidth",760)*72/254).floatValue(),new Float(MedwanQuery.getInstance().getConfigInt("bloodgiftLabelHeight",890)*102/254).floatValue());
            doc.setPageSize(rectangle.rotate());
            doc.setMargins(20,20,10,10);
            doc.setJavaScript_onLoad("print();\r");
            doc.open();
            printBloodgiftLabel(transactiondata);
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

    //---- ADD PAGE HEADER ------------------------------------------------------------------------
    private void addPageHeader() throws Exception {
    }

    protected void printBloodgiftLabel(String transactiondata){
    	String giftid = transactiondata.split(";")[0];
    	String personid=transactiondata.split(";")[1];
		TransactionVO bloodgift = MedwanQuery.getInstance().loadTransaction(MedwanQuery.getInstance().getConfigInt("serverId"), Integer.parseInt(giftid));
		String sampledate=bloodgift.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CNTS_RECEPTIONDATE");
		String abo="?",rhesus="?";
    	RequestedLabAnalysis analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(personid), MedwanQuery.getInstance().getConfigString("cntsBloodgroupCode","ABO"));
    	if(analysis!=null) abo=analysis.getResultValue()+" "+analysis.getResultUnit();
    	analysis = RequestedLabAnalysis.getByPersonid(Integer.parseInt(personid), MedwanQuery.getInstance().getConfigString("cntsRhesusCode","Rh"));
    	if(analysis!=null) rhesus=analysis.getResultValue()+" "+analysis.getResultUnit();
    	String pfcpockets = transactiondata.split(";")[3];
    	String pfcexpirydate = transactiondata.split(";")[4];
    	String prppockets = transactiondata.split(";")[5];
    	String prpexpirydate = transactiondata.split(";")[6];
    	String cgrpockets = transactiondata.split(";")[7];
    	String cgrexpirydate = transactiondata.split(";")[8];
    	String stpockets = transactiondata.split(";")[9];
    	String ctexpirydate = transactiondata.split(";")[10];
    	String cppockets = transactiondata.split(";")[11];
    	String cpexpirydate = transactiondata.split(";")[12];
    	String phenotype="";
    	Vector labrequests = MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(personid), "be.mxs.common.model.vo.healthrecord.IConstants.TRANSACTION_TYPE_LAB_REQUEST");
    	for(int n=0;n<labrequests.size();n++){
    		TransactionVO labrequest = (TransactionVO)labrequests.elementAt(n);
    		if(labrequest.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_LAB_OBJECTID").equals(giftid)){
    			//This labrequest is linked to the blood gift, check if it has a phenotype
    			LabRequest lr = new LabRequest(labrequest.getServerId(),labrequest.getTransactionId());
    			String r = lr.getResultValue(MedwanQuery.getInstance().getConfigString("cntsPhenotypeCode","pheno"));
    			if(r.length()>0){
    				phenotype=r;
    			}
    		}
    	}
    	
        try {
        	String[] products="pfc;prp;cgr;st;cp".split(";");
        	for(int i=3;i<11;i=i+2){
	        	for(int n=0;n<Integer.parseInt(transactiondata.split(";")[i]);n++){
		        	if(n>0){
		        		doc.newPage();
		        	}
		        	String id=giftid+"."+(i-1)/2+"."+(n+1);
		            table = new PdfPTable(2);
		            table.setWidthPercentage(pageWidth);
		            
		            //Left column
		            PdfPTable table2 = new PdfPTable(200);
		            cell = new PdfPCell(new Paragraph(abo,FontFactory.getFont(FontFactory.HELVETICA,80,Font.BOLD)));
		            cell.setColspan(170);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            cell = new PdfPCell(new Paragraph(rhesus,FontFactory.getFont(FontFactory.HELVETICA,48,Font.BOLD)));
		            cell.setColspan(30);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		            table2.addCell(cell);
		            Image image = PdfBarcode.getQRCode("B"+id,docWriter,80);            
		            cell = new PdfPCell(image);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setVerticalAlignment(PdfPCell.ALIGN_BOTTOM);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		            cell.setColspan(200);
		            cell.setPadding(0);
		            table2.addCell(cell);
		            cell = new PdfPCell(new Paragraph(getTran("web", "hospitalname"),FontFactory.getFont(FontFactory.HELVETICA,10,Font.BOLD)));
		            cell.setColspan(200);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
		            cell.setPadding(5);
		            table2.addCell(cell);
		            cell=new PdfPCell(table2);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setColspan(1);
		            cell.setPadding(0);
		            table.addCell(cell);
		            
		            
		            //Right column
		            table2 = new PdfPTable(1);
		            cell=createValueCell(ScreenHelper.getTranNoLink("bloodgift", "receptiondate", sPrintLanguage));
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            cell.setColspan(1);
		            table2.addCell(cell);
		            cell=createBoldValueCell(12, sampledate, 1);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            cell=createValueCell(ScreenHelper.getTranNoLink("bloodgift", "expirydate", sPrintLanguage));
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            cell.setColspan(1);
		            table2.addCell(cell);
		            cell=createBoldValueCell(12,transactiondata.split(";")[i+1],1);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            cell=createValueCell(ScreenHelper.getTranNoLink("bloodgift", "sampleid", sPrintLanguage));
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            cell.setColspan(1);
		            table2.addCell(cell);
		            cell=createBoldValueCell(12, giftid, 1);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            cell=createValueCell(ScreenHelper.getTranNoLink("bloodgift", "pocket", sPrintLanguage));
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            cell.setColspan(1);
		            table2.addCell(cell);
		            cell=createBoldValueCell(12, (i-1)/2+"."+(n+1), 1);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            cell=createValueCell(ScreenHelper.getTranNoLink("web", "product", sPrintLanguage));
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            cell.setColspan(1);
		            table2.addCell(cell);
		            cell=createBoldValueCell(12, getTran("bloodproducts",products[(i-3)/2]), 1);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		            table2.addCell(cell);
		            if(phenotype.length()>0){
			            cell=createValueCell(ScreenHelper.getTranNoLink("web", "phenotype", sPrintLanguage));
			            cell.setBorder(PdfPCell.NO_BORDER);
			            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
			            cell.setColspan(1);
			            table2.addCell(cell);
			            cell=createBoldValueCell(12, phenotype, 1);
			            cell.setBorder(PdfPCell.NO_BORDER);
			            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
			            cell.setColspan(1);
			            cell.setPadding(0);
			            table2.addCell(cell);
		            }
		            cell=new PdfPCell(table2);
		            cell.setBorder(PdfPCell.NO_BORDER);
		            cell.setColspan(1);
		            cell.setPadding(0);
		            table.addCell(cell);
		            doc.add(table);
	        	}
        	}
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //################################### UTILITY FUNCTIONS #######################################

    //--- CREATE UNDERLINED CELL ------------------------------------------------------------------
    protected PdfPCell createUnderlinedCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.UNDERLINE))); // underlined
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    //--- PRINT VECTOR ----------------------------------------------------------------------------
    protected String printVector(Vector vector){
        StringBuffer buf = new StringBuffer();
        for(int i=0; i<vector.size(); i++){
            buf.append(vector.get(i)).append(", ");
        }

        // remove last comma
        if(buf.length() > 0) buf.deleteCharAt(buf.length()-2);

        return buf.toString();
    }

    //--- CREATE TITLE ----------------------------------------------------------------------------
    protected PdfPCell createTitle(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,10,Font.UNDERLINE)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);

        return cell;
    }

    //--- CREATE TITLE ----------------------------------------------------------------------------
    protected PdfPCell createLabel(String msg, int fontsize, int colspan,int style){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,fontsize,style)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);

        return cell;
    }

    //--- CREATE BORDERLESS CELL ------------------------------------------------------------------
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

    //--- CREATE ITEMNAME CELL --------------------------------------------------------------------
    protected PdfPCell createItemNameCell(String itemName, int colspan){
        cell = new PdfPCell(new Paragraph(itemName,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL))); // no uppercase
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);

        return cell;
    }

    //--- CREATE PADDED VALUE CELL ----------------------------------------------------------------
    protected PdfPCell createPaddedValueCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
        cell.setPaddingRight(5); // difference

        return cell;
    }

    //--- CREATE NUMBER VALUE CELL ----------------------------------------------------------------
    protected PdfPCell createNumberCell(String value, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.NORMAL)));
        cell.setColspan(colspan);
        cell.setBorder(PdfPCell.BOX);
        cell.setBorderColor(innerBorderColor);
        cell.setVerticalAlignment(PdfPCell.ALIGN_TOP);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);

        return cell;
    }

}
