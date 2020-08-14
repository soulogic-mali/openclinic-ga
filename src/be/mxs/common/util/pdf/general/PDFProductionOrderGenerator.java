package be.mxs.common.util.pdf.general;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import java.util.*;
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;

import be.mxs.common.util.system.Miscelaneous;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.PdfBarcode;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.finance.*;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ProductionOrder;
import be.openclinic.pharmacy.ProductionOrderMaterial;
import be.openclinic.adt.Encounter;
import net.admin.*;

import javax.print.attribute.standard.PrinterLocation;
import javax.servlet.http.HttpServletRequest;

public class PDFProductionOrderGenerator extends PDFInvoiceGenerator {
    String sProforma = "no";

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFProductionOrderGenerator(User user, String sProject, String sPrintLanguage){
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
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String sProductionOrderUid) throws Exception {
        ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

        // reset totals
		try{
            doc.addProducer();
            doc.addAuthor(user.person.firstname+" "+user.person.lastname);
			doc.addCreationDate();
			doc.addCreator("OpenClinic Software");
			doc.setPageSize(PageSize.A4);

			// get specified invoice
			ProductionOrder productionOrder = ProductionOrder.get(Integer.parseInt(sProductionOrderUid));
            doc.open();
            printOrder(productionOrder);
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
    
    private void printOrder(ProductionOrder order){
        try {
        	AdminPerson person = AdminPerson.getAdminPerson(order.getPatientUid()+"");
        	
    		table = new PdfPTable(100);
            table.setWidthPercentage(pageWidth);
            cell=createValueCell(getTran("web","hospitalname"), 100, 14, Font.BOLD);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell=createEmptyCell(100);
            table.addCell(cell);
            cell=createValueCell(getTran("web","productionorder"), 100, 16, Font.BOLD);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
            table.addCell(cell);

            cell=createEmptyCell(100);
            table.addCell(cell);
            cell = createValueCell(getTran("web","productionordernumber"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getId()+"",30,12,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","date"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(order.getCreateDateTime()),30,10,Font.BOLD);
            table.addCell(cell);

            cell=createEmptyCell(100);
            table.addCell(cell);
            cell = createValueCell(getTran("web","patient"),50,10,Font.UNDERLINE+Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","productionorder"),50,10,Font.UNDERLINE+Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","personid"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getPatientUid()+"",30,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","orderstatus"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getCloseDateTime()==null?getTran("web","open"):getTran("web","closed"),30,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","name"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(person.getFullName(),30,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","estimateddeliverydate"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getEstimatedDelivery(),30,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","invoicenumber"),20,10,Font.NORMAL);
            table.addCell(cell);
        	PatientInvoice invoice=null;
        	Debet debet=null;
        	if(order.getDebetUid()!=null){
        		debet = Debet.get(order.getDebetUid());
        		if(debet!=null){
        			invoice = debet.getPatientInvoice();
        		}
        	}
        	if(invoice==null){
        		invoice=new PatientInvoice();
        	}
            cell = createValueCell(invoice.getInvoiceNumber(),80,10,Font.BOLD);
            table.addCell(cell);
            
            cell=createEmptyCell(100);
            table.addCell(cell);
            cell = createValueCell(getTran("web","finishedgoods"),100,10,Font.UNDERLINE+Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","code"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getProductStock().getProduct().getCode(),80,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","description"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getProductStock().getProduct().getName(),80,10,Font.BOLD);
            table.addCell(cell);
            cell = createValueCell(getTran("web","comment"),20,10,Font.NORMAL);
            table.addCell(cell);
            cell = createValueCell(order.getComment(),80,10,Font.BOLD);
            table.addCell(cell);

            cell=createEmptyCell(100);
            table.addCell(cell);
            cell = createValueCell(getTran("web","rawmaterials"),100,10,Font.UNDERLINE+Font.BOLD);
            table.addCell(cell);
            cell=createEmptyCell(100);
            table.addCell(cell);
            cell = createHeaderCell(getTran("web","code"), 20,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createHeaderCell(getTran("web","description"), 70,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);
            cell = createHeaderCell(getTran("web","quantity"), 10,10);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
            table.addCell(cell);

            Hashtable productstocks = new Hashtable();
        	//First we summarize the information for this production order
    		Vector materials = order.getMaterials();
    		for(int n=0;n<materials.size();n++){
    			ProductionOrderMaterial material = (ProductionOrderMaterial)materials.elementAt(n);
    			ProductStock productStock = ProductStock.get(material.getProductStockUid());
    			if(productStock!=null && productStock.hasValidUid()){
    				if(productstocks.get(productStock.getUid())==null){
    					productstocks.put(productStock.getUid(),material.getQuantity());
    				}
    				else{
    					productstocks.put(productStock.getUid(),material.getQuantity()+(Double)productstocks.get(productStock.getUid()));
    				}
    			}
    		}
    		Enumeration eProducts = productstocks.keys();
    		while(eProducts.hasMoreElements()){
    			String key = (String)eProducts.nextElement();
    			ProductStock productStock = ProductStock.get(key);
    			double nQuantity=(Double)productstocks.get(key);
    			if(nQuantity==0){
    				continue;
    			}
                cell = createValueCell(10,productStock.getProduct().getCode(), 20);
                table.addCell(cell);
                cell = createValueCell(10,productStock.getProduct().getName(), 70);
                table.addCell(cell);
                cell = createValueCell(10,nQuantity+"", 10);
                table.addCell(cell);
    		}

            cell=createEmptyCell(100);
            table.addCell(cell);
    		table.addCell(createCell(new PdfPCell(getPrintedByInfo()),100,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));

            doc.add(table);
		} catch (DocumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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
            receiptTable.addCell(createValueCell(debet.getQuantity()+" x  ["+debet.getPrestation().getCode()+"] "+debet.getPrestation().getDescription()+extraInsurar,20,7,Font.NORMAL));
        }
        receiptTable.addCell(createEmptyCell(50-((debets.size() % 2)*20)));
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
            cell = new PdfPCell(getSaldo(debets, invoice));
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
        table.addCell(createEmptyCell(3));

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
        cell = createLabelCell(getTran("web","invoiceDebets"),5);
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
        cell = createBoldLabelCell(getTran("web","totalprice").toUpperCase(),5);
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
        table.addCell(createTotalPriceCell(complementaryinsurar,3));
        table.addCell(createEmptyCell(3));


        return table;
    }

}