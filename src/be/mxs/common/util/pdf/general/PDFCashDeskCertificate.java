package be.mxs.common.util.pdf.general;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.pdf.PDFBasic;
import be.mxs.common.util.pdf.official.EndPage;
import be.mxs.common.util.pdf.official.EndPage2;
import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.Evaluate;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.LabRequest;
import be.openclinic.medical.RequestedLabAnalysis;
import be.openclinic.system.SH;
import be.openclinic.medical.LabAnalysis;
import net.admin.User;
import net.admin.Service;
import net.admin.AdminPerson;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;

/**
 * User: stijn smets
 * Date: 21-nov-2006
 */
public class PDFCashDeskCertificate extends PDFOfficialBasic {

    // declarations
    protected PdfWriter docWriter;
    private final int pageWidth = 100;
    private String type;


    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFCashDeskCertificate(User user, String sProject,String sPrintLanguage){
        this.user = user;
        this.sPrintLanguage=sPrintLanguage;
        this.sProject = sProject;

        doc = new Document();
    }

    public void addHeader(){
    }

    public void addContent(){
    }

    //--- ADD FOOTER ------------------------------------------------------------------------------
    protected void addFooter(){
        PDFFooter footer = new PDFFooter(ScreenHelper.getTran("web","cashdeskreporttitle",sPrintLanguage)+" - "+ScreenHelper.fullDateFormat.format(new java.util.Date()));
        docWriter.setPageEvent(footer);
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, Date begin,Date end,String serviceUid) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;
        long hour=3600*1000;
        long day = 24*hour;
        end=new java.util.Date(end.getTime()+day-1);

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
            doc.setMargins(10,10,10,30);
           	addFooter();
            doc.open();
            printHeader(begin, end, serviceUid);
            printCertificate(begin,end,serviceUid);
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
    	// empty
    }

    //--- PRINT LABRESULT -------------------------------------------------------------------------
    protected void printCertificate(Date begin,Date end, String serviceUid){
        try {
        	//Chapter 1: patient related revenue
            String sQuery = "select sum(number) number, sum(quantity) quantity, sum(total) total, sum(patientincome) patientincome, sum(insurarincome) insurarincome,"+
	                "       oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
	                " from ("+
                    "  select count(*) number, sum(oc_debet_quantity) quantity, sum(oc_debet_amount+oc_debet_insuraramount+oc_debet_extrainsuraramount) total,"+
	                "         sum(oc_debet_amount) patientincome, sum(oc_debet_insuraramount+oc_debet_extrainsuraramount) insurarincome,"+
                    "         oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
                    "   from oc_debets a, oc_prestations b, oc_encounters c, adminview d"+
                    "    where oc_prestation_objectid = replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+ 
                    "     and oc_encounter_objectid = replace(a.oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+ 
                    "     and d.personid = c.oc_encounter_patientuid"+
                    "     and (oc_debet_patientinvoiceuid is not null and oc_debet_patientinvoiceuid<>'')"+
                    "     and oc_debet_date between ? and ?"+
                    "     and oc_debet_serviceuid in ("+Service.getChildIdsAsString(serviceUid)+")"+
                    "  group by oc_debet_serviceuid,oc_prestation_description,oc_prestation_code"+
    				" union "+
                    "select count(*) number, sum(oc_debet_quantity) quantity, sum(oc_debet_amount+oc_debet_insuraramount+oc_debet_extrainsuraramount) total,"+
    				"       sum(oc_debet_amount) patientincome, sum(oc_debet_insuraramount+oc_debet_extrainsuraramount) insurarincome,"+
                    "       serviceuid as oc_debet_serviceuid, oc_prestation_description, oc_prestation_code"+
                    " from ("+
                    "  select oc_debet_amount,oc_debet_insuraramount,oc_debet_quantity,oc_debet_extrainsuraramount,oc_debet_prestationuid,"+
                    "   ("+
                    "    select max(oc_encounter_serviceuid)"+
                    "     from oc_encounters_view"+
                    "       where oc_encounter_objectid = replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
                    "   ) as serviceuid"+	
                    "   from oc_debets"+
                    "    where (oc_debet_patientinvoiceuid is not null"+
                    "     and oc_debet_patientinvoiceuid<>'')"+
                    "     and oc_debet_date between ? and ?"+
                    "     and oc_debet_serviceuid is null) a, oc_prestations b"+
                    "  where oc_prestation_objectid = replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')"+
                    "   and serviceuid in ("+Service.getChildIdsAsString(serviceUid)+")"+
                    "    group by serviceuid,oc_prestation_description,oc_prestation_code"+
                    "   ) as q"+
                    " group by oc_debet_serviceuid,oc_prestation_description,oc_prestation_code"+
                    " order by oc_debet_serviceuid,total desc";
            Connection conn = MedwanQuery.getInstance().getLongOpenclinicConnection();
            PreparedStatement ps = conn.prepareStatement(sQuery);
            ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
            ps.setTimestamp(3,new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(4,new java.sql.Timestamp(end.getTime()));
            ResultSet rs = ps.executeQuery();
            
            String activeservice = null;
            double totalpatientincome = 0;
            double totalinsurarincome = 0;
            double totalservicepatientincome = 0;
            double totalserviceinsurarincome = 0;
            int recordCount = 0;
            table = new PdfPTable(100);
            while(rs.next()){
                String serviceuid = checkString(rs.getString("oc_debet_serviceuid"));
                if(activeservice==null || !activeservice.equalsIgnoreCase(serviceuid)){
                    if(activeservice!=null){
                    	cell = createValueCell("",70);
                    	cell.setBorder(PdfPCell.NO_BORDER);
                    	table.addCell(cell);
                    	cell = createBoldValueCell(SH.getPriceFormat(totalserviceinsurarincome+totalservicepatientincome), 10);
                    	table.addCell(cell);
                    	cell = createBoldValueCell(SH.getPriceFormat(totalservicepatientincome), 10);
                    	table.addCell(cell);
                    	cell = createBoldValueCell(SH.getPriceFormat(totalserviceinsurarincome), 10);
                    	table.addCell(cell);
                    	cell = createValueCell("\n",100);
                    	cell.setBorder(PdfPCell.NO_BORDER);
                    	table.addCell(cell);
                    }
                    
                    activeservice = serviceuid;
                    cell=createGreyCell((activeservice.length()==0?"?":activeservice+": "+SH.getTran("service",activeservice,sPrintLanguage)), 50);
                    table.addCell(cell);
                	cell = createGreyCell("#", 20);
                	table.addCell(cell);
                	cell = createGreyCell(SH.getTran("web","total",sPrintLanguage), 10);
                	table.addCell(cell);
                	cell = createGreyCell(SH.getTran("web","patient",sPrintLanguage), 10);
                	table.addCell(cell);
                	cell = createGreyCell(SH.getTran("web","insurar",sPrintLanguage), 10);
                	table.addCell(cell);
                    totalpatientincome+= totalservicepatientincome;
                    totalinsurarincome+= totalserviceinsurarincome;
                    totalserviceinsurarincome = 0;
                    totalservicepatientincome = 0;
                    recordCount++;
                }
                double patientincome = rs.getDouble("patientincome");
                double insurarincome = rs.getDouble("insurarincome");
                totalserviceinsurarincome+= insurarincome;
                totalservicepatientincome+= patientincome;
               
                cell = createValueCell(rs.getString("oc_prestation_code")+": "+rs.getString("oc_prestation_description"),50);
                table.addCell(cell);
                cell = createValueCell(rs.getInt("quantity")+" ("+rs.getInt("number")+" "+SH.getTran("web","invoices",sPrintLanguage)+")",20);
                table.addCell(cell);
                cell = createValueCell(SH.getPriceFormat(patientincome+insurarincome),10);
                table.addCell(cell);
                cell = createValueCell(SH.getPriceFormat(patientincome),10);
                table.addCell(cell);
                cell = createValueCell(SH.getPriceFormat(insurarincome),10);
                table.addCell(cell);
            }
            
            if(activeservice!=null){
            	cell = createValueCell("",70);
            	cell.setBorder(PdfPCell.NO_BORDER);
            	table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalserviceinsurarincome+totalservicepatientincome), 10);
            	table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalservicepatientincome), 10);
            	table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalserviceinsurarincome), 10);
            	table.addCell(cell);
            	cell = createValueCell("\n",100);
            	cell.setBorder(PdfPCell.NO_BORDER);
            	table.addCell(cell);
                
                totalpatientincome+= totalservicepatientincome;
                totalinsurarincome+= totalserviceinsurarincome;
                
                cell = createGreyCell(SH.getTran("web","allservices",sPrintLanguage),70);
                table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalinsurarincome+totalpatientincome), 10);
            	table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalpatientincome), 10);
            	table.addCell(cell);
            	cell = createBoldValueCell(SH.getPriceFormat(totalinsurarincome), 10);
            	table.addCell(cell);
            	cell = createValueCell("\n",100);
            	cell.setBorder(PdfPCell.NO_BORDER);
            	table.addCell(cell);
            }
            rs.close();
            ps.close();
            doc.add(table);
        	
        	//Chapter 2: non patient related revenue
            table = new PdfPTable(100);
            cell=createGreyCell(SH.getTran("web","otherwicketoperations",sPrintLanguage), 50);
            table.addCell(cell);
        	cell = createGreyCell("#", 20);
        	table.addCell(cell);
        	cell = createGreyCell(SH.getTran("web","total",sPrintLanguage), 10);
        	table.addCell(cell);
        	cell = createGreyCell("", 10);
        	table.addCell(cell);
        	cell = createGreyCell("", 10);
        	table.addCell(cell);
    		ps = conn.prepareStatement("select count(*) total,sum(oc_wicket_credit_amount) amount,oc_wicket_credit_type from oc_wicket_credits where oc_wicket_credit_operationdate>=? and oc_wicket_credit_operationdate<? and oc_wicket_credit_type<>'patient.payment' group by oc_wicket_credit_type");
            ps.setTimestamp(1, new java.sql.Timestamp(begin.getTime()));
            ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
            rs=ps.executeQuery();
            totalpatientincome=0;
            while(rs.next()){
            	cell=createValueCell(SH.getTran("wicketcredit.type",rs.getString("oc_wicket_credit_type"),sPrintLanguage), 50);
            	table.addCell(cell);
            	cell=createValueCell(rs.getString("total"),20);
            	table.addCell(cell);
            	cell=createValueCell(SH.getPriceFormat(rs.getDouble("amount")),10);
            	table.addCell(cell);
            	cell=createValueCell("",10);
            	table.addCell(cell);
            	cell=createValueCell("",10);
            	table.addCell(cell);
            	totalpatientincome+=rs.getDouble("amount");
            	recordCount++;
            }
            cell=createValueCell("", 70);
            cell.setBorder(PdfPCell.NO_BORDER);
            table.addCell(cell);
        	cell=createBoldValueCell(SH.getPriceFormat(totalpatientincome),10);
        	table.addCell(cell);
            cell=createValueCell("", 20);
            cell.setBorder(PdfPCell.NO_BORDER);
            table.addCell(cell);
            rs.close();
            ps.close();
            doc.add(table);
            conn.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

   
    //--- PRINT HEADER ----------------------------------------------------------------------------
    private void printHeader(Date begin, Date end, String serviceUid) throws Exception{
        table = new PdfPTable(100);
        table.setWidthPercentage(100);
        
        //Hospital logo
        try{
	        Image image =Image.getInstance(new URL(url+contextPath+projectDir+"/_img/logo_patientcard.gif"));
	        image.scaleToFit(48*400/254,96);
	        cell = new PdfPCell(image);
        }
        catch(Exception e){
        	cell=emptyCell();
        }
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
        cell.setColspan(25);
        cell.setPadding(10);
        table.addCell(cell);
        
        PdfPTable table2 = new PdfPTable(1);
        table2.setWidthPercentage(100);
        
        //Title
        cell=createLabel(ScreenHelper.getTranNoLink("web","cashdeskreporttitle",user.person.language),14,1,Font.BOLD);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        table2.addCell(cell);
        
        cell=createLabel(ScreenHelper.getTranNoLink("web","period",user.person.language)+": "+SH.formatDate(begin)+" - "+SH.formatDate(end),12,1,Font.BOLD);
        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
        table2.addCell(cell);
        
        if(serviceUid.length()>0) {
	        cell=createLabel(ScreenHelper.getTranNoLink("web","service",user.person.language)+": "+SH.getTran("service",serviceUid,sPrintLanguage),12,1,Font.BOLD);
	        cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	        table2.addCell(cell);
        }
        
        cell=createBorderlessCell(70);
        cell.setVerticalAlignment(PdfPCell.ALIGN_MIDDLE);
        cell.addElement(table2);
        table.addCell(cell);
        
        table2 = new PdfPTable(1);
        table2.setWidthPercentage(100);
       
        cell=createBorderlessCell(5);
        table.addCell(cell);

        doc.add(table);
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

    //--- CREATE TITLE ----------------------------------------------------------------------------
    protected PdfPCell createLabelCourier(String msg, int fontsize, int colspan,int style){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.COURIER,fontsize,style)));
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
