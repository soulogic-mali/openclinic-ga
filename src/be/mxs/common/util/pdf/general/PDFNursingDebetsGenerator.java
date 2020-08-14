package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.aspose.barcode.internal.dv.e;
import com.itextpdf.text.*;
import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.finance.*;
import be.openclinic.medical.Prescription;
import be.openclinic.pharmacy.Product;
import net.admin.*;

import javax.servlet.http.HttpServletRequest;

public class PDFNursingDebetsGenerator extends PDFInvoiceGenerator {

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFNursingDebetsGenerator(User user, AdminPerson patient, String sProject, String sPrintLanguage){
        this.user = user;
        this.patient = patient;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;

        doc = new Document();
    }

    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, Encounter encounter) throws Exception {
    	return null;
    }

    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String sEncounterUid) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
			doc.setPageSize(PageSize.A4);
            addFooter();

            doc.open();

            // get specified encounter
            Encounter encounter = Encounter.get(sEncounterUid);

            addHeading(encounter);
            addPatientData();
            addEncounterData(encounter);
            printNursingDebets(encounter);
    		if(MedwanQuery.getInstance().getConfigInt("autoPrintReceipt",0)==1){
    			PdfAction action = new PdfAction(PdfAction.PRINTDIALOG);
    			docWriter.setOpenAction(action);
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

    //---- ADD HEADING (logo & barcode) -----------------------------------------------------------
    private void addHeading(Encounter encounter) throws Exception {
        table = new PdfPTable(5);
        table.setWidthPercentage(pageWidth);

        try {
            //*** logo ***
            try{
                Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
                img.scaleToFit(75, 75);
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

	        if(MedwanQuery.getInstance().getConfigInt("showBarcodeOnReceipts",0)==1){
	
	            //*** title ***
	            table.addCell(createTitleCell(getTran("web","nursingdebetssummary").toUpperCase()+" #"+encounter.getUid().split("\\.")[1]+" - "+ScreenHelper.stdDateFormat.format(new java.util.Date()),"",3));
		        
	            //*** barcode ***
		        Image image = PdfBarcode.getBarcode("N"+encounter.getUid().split("\\.")[1],encounter.getUid().split("\\.")[1], docWriter);            
		        cell = new PdfPCell(image);
		        cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
		        cell.setBorder(PdfPCell.NO_BORDER);
		        cell.setColspan(1);
		        table.addCell(cell);
	        }
	        else{
	            //*** title ***
	            table.addCell(createTitleCell(getTran("web","nursingdebetssummary").toUpperCase()+" #"+encounter.getUid().split("\\.")[1]+" - "+ScreenHelper.stdDateFormat.format(new java.util.Date()),"",4));
	        }

            doc.add(table);
            addBlankRow();
            addBlankRow();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }


    private void addEncounterData(Encounter encounter) {
    	try {
	    	table = new PdfPTable(100);
	        table.setWidthPercentage(pageWidth);
	        table.addCell(createGrayCell(getTran("web","encounter"), 100));
	        
	        PdfPTable encounterTable = new PdfPTable(100);
	        encounterTable.setWidthPercentage(pageWidth);
	        encounterTable.addCell(createValueCell(getTran("web","ID"), 10));
	        encounterTable.addCell(createValueCell(encounter.getUid(), 40));
	        encounterTable.addCell(createValueCell(getTran("web","service"), 10));
	        encounterTable.addCell(createValueCell(encounter.getAllServices(sPrintLanguage), 40));
	        encounterTable.addCell(createValueCell(getTran("web","begin"), 10));
	        encounterTable.addCell(createValueCell(ScreenHelper.formatDate(encounter.getBegin(),ScreenHelper.fullDateFormat), 40));
	        encounterTable.addCell(createValueCell(getTran("web","end"), 10));
	        encounterTable.addCell(createValueCell(ScreenHelper.formatDate(encounter.getEnd(),ScreenHelper.fullDateFormat), 40));
            cell = createCell(new PdfPCell(encounterTable),100,PdfPCell.ALIGN_CENTER,PdfPCell.BOX);
	        table.addCell(cell);
	        doc.add(table);
	        addBlankRow();
    	}
    	catch(Exception e) {
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

    //--- PRINT INVOICE ---------------------------------------------------------------------------
    private void printNursingDebets(Encounter encounter){
        try {
            table = new PdfPTable(100);
            table.setWidthPercentage(pageWidth);

            table.addCell(createGrayCell(getTran("web","invoiceditems").toUpperCase(),100));
            table.addCell(createTitleCell(getTran("web","code"),10));
            table.addCell(createTitleCell(getTran("web","description"),40));
            table.addCell(createTitleCell(getTran("web","insurer"),20));
            table.addCell(createTitleCell(getTran("web","complementarycoverage"),20));
            table.addCell(createTitleCell(getTran("web","quantity"),10));
            
            SortedMap nursingprestations = new TreeMap();
            Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
            PreparedStatement ps = conn.prepareStatement("select * from oc_nursingdebets n, oc_debets d where n.oc_nursingdebet_debetuid='"+MedwanQuery.getInstance().getServerId()+".'"+MedwanQuery.getInstance().concatSign()+MedwanQuery.getInstance().convert("varchar","d.oc_debet_objectid")+" and d.oc_debet_encounteruid=? order by oc_debet_date");
            ps.setString(1, encounter.getUid());
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
            	String sPrestationUid = rs.getString("oc_nursingdebet_prestationuid");
            	Prestation prestation = Prestation.get(sPrestationUid);
            	if(prestation!=null) {
            		String sInsuranceUid=rs.getString("oc_debet_insuranceuid");
            		if(!nursingprestations.containsKey(sPrestationUid+"."+sInsuranceUid)) {
            			Hashtable ht = new Hashtable();
            			ht.put("prestationcode", prestation.getCode());
            			ht.put("prestation", prestation.getDescription());
            			ht.put("quantity", rs.getInt("oc_nursingdebet_quantity"));
            			ht.put("insurance", Insurance.get(sInsuranceUid));
            			nursingprestations.put(sPrestationUid+"."+sInsuranceUid, ht);
            		}
            		else {
            			Hashtable ht = (Hashtable)nursingprestations.get(sPrestationUid+"."+sInsuranceUid);
            			ht.put("quantity", (Integer)ht.get("quantity")+rs.getInt("oc_nursingdebet_quantity"));
            		}
            		
            	}
            }
            rs.close();
            ps.close();
            // print summarized prestations
            Iterator iPrestations = nursingprestations.keySet().iterator();
            while(iPrestations.hasNext()) {
            	String key = (String)iPrestations.next();
            	Hashtable ht = (Hashtable)nursingprestations.get(key);
                table.addCell(createValueCell((String)ht.get("prestationcode"),10));
                table.addCell(createValueCell((String)ht.get("prestation"),40));
                table.addCell(createValueCell(((Insurance)ht.get("insurance")).getInsurar()==null?"":((Insurance)ht.get("insurance")).getInsurar().getName(),20));
                table.addCell(createValueCell(((Insurance)ht.get("insurance")).getExtraInsurar()==null?"":((Insurance)ht.get("insurance")).getExtraInsurar().getName(),20));
                table.addCell(createValueCell((Integer)ht.get("quantity")+"",10));
            }

            doc.add(table);
            addBlankRow();
            
            
            //Now add a section for drugs dispensed during the encounter
            table = new PdfPTable(100);
            table.setWidthPercentage(pageWidth);
            table.addCell(createGrayCell(getTran("web","dispenseddrugs").toUpperCase(),100));
            
            ps=conn.prepareStatement("select * from oc_prescription_administration where oc_schema_date>? and oc_schema_date<?");
            long minute = 60000;
            long hour = 60*minute;
            long day = 24*hour;
            Hashtable summarizedDrugs = new Hashtable();
            boolean bInit=false;
            ps.setTimestamp(1, new java.sql.Timestamp(encounter.getBegin().getTime()-day));
            java.util.Date end = new java.util.Date();
            if(encounter.getEnd()!=null) {
            	end=encounter.getEnd();
            }
            ps.setTimestamp(2, new java.sql.Timestamp(end.getTime()));
            rs=ps.executeQuery();
            while(rs.next()) {
            	java.util.Date admintime = new java.util.Date(rs.getDate("oc_schema_date").getTime()+new Double(rs.getDouble("oc_schema_time")).intValue()*hour);
            	if(admintime.before(encounter.getBegin()) || admintime.after(end)) {
            		continue;
            	}
            	bInit=true;
            	String prescriptionUid = rs.getInt("oc_prescr_serverid")+"."+rs.getInt("oc_prescr_objectid");
            	Prescription prescription = Prescription.get(prescriptionUid);
            	if(prescription!=null && prescription.getProduct()!=null) {
	            	if(summarizedDrugs.get(prescription.getProductUid())==null) {
	            		summarizedDrugs.put(prescription.getProductUid(), new Double(0));
	            	}
	            	summarizedDrugs.put(prescription.getProductUid(), (Double)summarizedDrugs.get(prescription.getProductUid())+rs.getDouble("oc_schema_quantity"));
            	}
            }
            rs.close();
            ps.close();
            
            if(bInit) {
                table.addCell(createTitleCell(getTran("web", "code"),10));
                table.addCell(createTitleCell(getTran("web", "drugname"),40));
                table.addCell(createTitleCell(getTran("web", "unit"),20));
                table.addCell(createTitleCell(getTran("web", "dose"),20));
                table.addCell(createTitleCell(getTran("web", "quantity"),10));

	            Enumeration eDrugs = summarizedDrugs.keys();
	            while(eDrugs.hasMoreElements()) {
	            	String productUid = (String)eDrugs.nextElement();
	            	Product product = Product.get(productUid);
	            	if(product!=null) {
	                    table.addCell(createValueCell(product.getCode(),10));
	                    table.addCell(createValueCell(product.getName(),40));
	                    table.addCell(createValueCell(getTran("product.unit",product.getUnit()),20));
	                    table.addCell(createValueCell(product.getDose(),20));
	                    table.addCell(createValueCell(summarizedDrugs.get(productUid)+"",10));
	            	}
	            }
            }
            else {
                table.addCell(createValueCell(getTran("web", "none"),100));
            }
            table.addCell(createValueCell("\n\n\n",100));
            // "printed by" info
            table.addCell(createCell(new PdfPCell(getPrintedByInfo()),100,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));

            doc.add(table);
            
            conn.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }


}