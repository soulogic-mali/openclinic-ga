package be.mxs.common.util.pdf.general;

import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import net.admin.User;
import net.admin.AdminPerson;
import net.admin.Service;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.util.Arrays;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;
import java.text.SimpleDateFormat;

/**
 * User: stijn smets
 * Date: 21-nov-2006
 */
public class PDFAssetNormGenerator extends PDFOfficialBasic {

    // declarations
    private final int pageWidth = 100;
    private String type;
    PdfWriter docWriter=null;
    private String serviceid ="";
    private String norms="";
    private String structures="";
    
    public void addHeader(){
    }
    public void addContent(){
    }


    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFAssetNormGenerator(User user, String sProject){
        this.user = user;
        this.sProject = sProject;

        doc = new Document();
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String serviceid, String norms, String structures, String language) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;
        this.type=type;
        this.serviceid=serviceid;
        this.norms=norms;
        this.structures=structures;
        this.sPrintLanguage=language;

        String sURL = req.getRequestURL().toString();
        if(sURL.indexOf("openclinic",10) > 0){
            sURL = sURL.substring(0,sURL.indexOf("openclinic", 10));
        }

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
            doc.setPageSize(PageSize.A4);
            doc.setMargins(20,20,50,50);
            doc.open();

            // add content to document
            printNorms();
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
    
    private void printNorms() throws DocumentException{
		SortedMap normsdb = new TreeMap();
		//We calculate all norms for all services that descend form the root service
		getNorms(serviceid,normsdb,structures);
		//Now we've got all norms for all structures starting from serviceid and lower
		//Run through each of the structures
		Iterator services = normsdb.keySet().iterator();
		while(services.hasNext()){
			String activeserviceid = (String)services.next();
			Service service = Service.getService(activeserviceid);
			int numberofnorms=0,numberofcompliantnorms=0;
			//Write full service name to report
			table = new PdfPTable(100);
			cell = createGreyCell(12,service.getFullyQualifiedName(sPrintLanguage) , 100);
			table.addCell(cell);
			//Write norm headers to report
			cell = createHeaderCell(ScreenHelper.getTranNoLink("asset", "norm", sPrintLanguage), 60);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
			table.addCell(cell);
			cell = createHeaderCell(ScreenHelper.getTranNoLink("asset", "minimum", sPrintLanguage), 10);
			table.addCell(cell);
			cell = createHeaderCell(ScreenHelper.getTranNoLink("asset", "existing", sPrintLanguage), 10);
			table.addCell(cell);
			cell = createHeaderCell(ScreenHelper.getTranNoLink("asset", "nonfunctional", sPrintLanguage), 10);
			table.addCell(cell);
			cell = createHeaderCell(ScreenHelper.getTranNoLink("asset", "compliant", sPrintLanguage), 10);
			table.addCell(cell);
			//Now we must run through all the norms and show the results of the relevant ones
			SortedMap servicenorms = (SortedMap)normsdb.get(activeserviceid);
			Iterator iservicenorms = servicenorms.keySet().iterator();
			while(iservicenorms.hasNext()){
				String sn_nomenclature = (String)iservicenorms.next();
				if(norms.length()==0 || (norms+";").contains(sn_nomenclature)){
					String sn_result = ScreenHelper.checkString((String)servicenorms.get(sn_nomenclature));
					if(sn_result.split(";").length>1){
						numberofnorms++;
						double sn_minimumquantity = Double.parseDouble(sn_result.split(";")[0]);
						double sn_foundquantity = Double.parseDouble(sn_result.split(";")[1]);
						double sn_nonfunctional = Double.parseDouble(sn_result.split(";")[2]);
						cell = createValueCell(sn_nomenclature.toUpperCase(), 15);
						table.addCell(cell);
						cell = createValueCell(ScreenHelper.getTranNoLink("admin.nomenclature.asset", sn_nomenclature, sPrintLanguage), 45);
						table.addCell(cell);
						cell = createValueCell(new Double(sn_minimumquantity).intValue()+"", 10);
						cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						table.addCell(cell);
						cell = createValueCell(sn_foundquantity==0?"-":new Double(sn_foundquantity).intValue()+"", 10);
						cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						table.addCell(cell);
						cell = createValueCell(sn_nonfunctional==0?"-":new Double(sn_nonfunctional).intValue()+"", 10);
						cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						table.addCell(cell);
						cell = createBoldValueCell(sn_foundquantity>=sn_minimumquantity?ScreenHelper.getTranNoLink("web", "yes", sPrintLanguage):ScreenHelper.getTranNoLink("web", "no", sPrintLanguage), 10);
						cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						if(sn_foundquantity<sn_minimumquantity){
					        cell.setBackgroundColor(new BaseColor(230,50,50)); // light red
						}
						else{
							numberofcompliantnorms++;
						}
						table.addCell(cell);
					}
				}
			}
			cell = createBorderlessCell("" , 60);
			table.addCell(cell);
			cell = createValueCell(ScreenHelper.getTranNoLink("web", "conformityscore", sPrintLanguage)+": ", 30);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
			table.addCell(cell);
			cell = createValueCell((numberofcompliantnorms*100/numberofnorms)+"%", 10);
			cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
			table.addCell(cell);
			cell = createBorderlessCell("\n" , 100);
			table.addCell(cell);
			doc.add(table);
			
		}
    }

    //---- ADD PAGE HEADER ------------------------------------------------------------------------
    private void addPageHeader() throws Exception {
    }

	private void getNorms(String serviceid,SortedMap normsdb,String structures){
		Service service = Service.getService(serviceid);
		if(service!=null){
			//First find the norms for this service
			if(checkString(service.costcenter).length()>0 && structures.contains(service.costcenter)){
				Debug.println("Getting PDF norms for "+serviceid);
				normsdb.put(serviceid,be.openclinic.assets.Util.getNormsForService(serviceid));
			}
			//Then find the norms for all the children
			Vector children=Service.getChildIds(serviceid);
			for(int n=0;n<children.size();n++){
				service = Service.getService((String)children.elementAt(n));
				if(service!=null && checkString(service.costcenter).length()>0 && structures.contains(service.costcenter)){
					Debug.println("Getting PDF norms for "+(String)children.elementAt(n));
					normsdb.put((String)children.elementAt(n),be.openclinic.assets.Util.getNormsForService((String)children.elementAt(n)));
				}
			}
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
