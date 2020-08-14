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
import be.openclinic.adt.Encounter;
import net.admin.*;

import javax.print.attribute.standard.PrinterLocation;
import javax.servlet.http.HttpServletRequest;

public class PDFSummaryInvoiceGenerator extends PDFInvoiceGenerator {
    String sProforma = "no";

    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFSummaryInvoiceGenerator(User user, AdminPerson patient, String sProject, String sPrintLanguage){
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
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String sInvoiceUid) throws Exception {
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

			// get specified invoice
            SummaryInvoice invoice = SummaryInvoice.get(sInvoiceUid);

			if(MedwanQuery.getInstance().getConfigInt("patientinvoicefooteraddpatientdata",0)==0){
				addFooter();
			}
			else {
				String lastname=ScreenHelper.checkString(invoice.getPatient().lastname).toUpperCase();
				String firstname=ScreenHelper.checkString(invoice.getPatient().firstname);
				String gender=ScreenHelper.checkString(invoice.getPatient().gender).toUpperCase();
				String birth=ScreenHelper.checkString(invoice.getPatient().dateOfBirth);
				addFooterWithText(lastname+", "+firstname+" "+gender+" "+birth);
			}

            doc.open();

            addHeading(invoice);
            addPatientData();
            addEncounterData(invoice,null);
            Vector debets=invoice.getDebets();
            //get list of patientinsurances
            SortedMap sIns = new TreeMap();
            for(int n=0;n<debets.size();n++){
            	ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(n);
            	if(debet.getInsuranceUid()!=null && sIns.get(debet.getInsuranceUid())==null){
            		if(debet.getInsurance()!=null && debet.getInsurance().getUid()!=null){
            			sIns.put(debet.getInsuranceUid(), debet.getInsurance());
            		}
            	}
            }
            Vector insurances = new Vector(sIns.values());
            for(int n=0;n<insurances.size();n++){
                Insurance insurance = (Insurance)insurances.elementAt(n);
                if(insurance!=null){
                    Vector insdebets= new Vector();
                    for(int i=0;i<debets.size();i++){
                    	ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(i);
                    	if(debet.getInsuranceUid()!=null && debet.getInsuranceUid().equalsIgnoreCase(insurance.getUid())){
                    		insdebets.add(debet);
                    	}
                    }
                    if(insdebets.size()>0){
                        addInsuranceData(insurance,invoice);
                        printDebets(invoice,insdebets);
                    }
                }
            }
            printInvoice(invoice,invoice.getDebets());
    		if(MedwanQuery.getInstance().getConfigInt("autoPrintPatientInvoice",0)==1){
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
    
    private void addEncounterData(SummaryInvoice invoice,String serviceuid){
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
	    		ConsolidatedDebet debet = (ConsolidatedDebet)invoice.getDebets().elementAt(n);
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
	    				if(encounter.getService()!=null){
		    				cell= createValueCell(getTran("web","service")+":",15);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
			    			cell= createValueCell(encounter.getService().getLabel(sPrintLanguage),85);
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
	    				if(encounter.getService()!=null){
			    			cell= createValueCell(getTran("web","service")+":",20);
			    			cell.setBorder(PdfPCell.NO_BORDER);
			    			table.addCell(cell);
			    			cell= createValueCell(encounter.getService().getLabel(sPrintLanguage),30);
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

    //---- ADD HEADING (logo & barcode) -----------------------------------------------------------
    private void addHeading(SummaryInvoice invoice) throws Exception {
        table = new PdfPTable(5);
        table.setWidthPercentage(pageWidth);

        try {
            //*** logo ***
            try{
                Image img = Miscelaneous.getImage("logo_"+sProject+".gif",sProject);
                int imgwidth=75,imgheight=75;
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
            table.addCell(createTitleCell((sProforma.equalsIgnoreCase("yes") || ScreenHelper.checkString(invoice.getValidated()).length()==0?ScreenHelper.getTranNoLink("invoice","SUMMARYPROFORMA",sPrintLanguage)+" #"+invoice.getInvoiceUid():sProforma.equalsIgnoreCase("debetnote")?ScreenHelper.getTranNoLink("invoice","SUMMARYDEBETNOTE",sPrintLanguage)+" #"+invoice.getInvoiceUid():getTran("web","summaryinvoice").toUpperCase()+" #"+invoice.getInvoiceUid())+" - "+ScreenHelper.stdDateFormat.format(invoice.getDate()),"",3));


            Image image = PdfBarcode.getBarcode("7"+invoice.getInvoiceUid(),invoice.getInvoiceUid(), docWriter);            
            cell = new PdfPCell(image);
            cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
            cell.setBorder(PdfPCell.NO_BORDER);
            cell.setColspan(1);
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
    private void addInsuranceData(Insurance insurance,SummaryInvoice invoice){
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
    private void printDebets(SummaryInvoice invoice,Vector debets){
        try{
            PdfPTable table = new PdfPTable(1);
            table.setWidthPercentage(pageWidth);
            // provide a list of all invoices that have been summarized
            table.addCell(createGrayCell(getTran("web","summarizedinvoices").toUpperCase(),1));
            String sInvoices="";
            String insuranceUid=((ConsolidatedDebet)debets.elementAt(0)).getInsuranceUid();
            Vector invoices = invoice.getPatientInvoices(insuranceUid);
            for(int n=0;n<invoices.size();n++){
            	PatientInvoice patientInvoice = (PatientInvoice)invoices.elementAt(n);
            	if(patientInvoice!=null){
            		if(sInvoices.length()>0){
            			sInvoices+=", ";
            		}
            		sInvoices+=patientInvoice.getInvoiceNumber()+" ("+ScreenHelper.formatDate(patientInvoice.getDate())+")";
            	}
            }
            table.addCell(createValueCell(sInvoices,1));
            table.addCell(createEmptyCell(1));
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
    private void printInvoice(SummaryInvoice invoice,Vector debets){
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
	            table.addCell(createValueCell(getTran("web","proformainvoicecomment"),2));
	            cell=createValueCell("\n",2);
    		}
            table.addCell(createCell(new PdfPCell(getPrintedByInfo()),2,PdfPCell.ALIGN_LEFT,PdfPCell.NO_BORDER));
            
            cell=createValueCell("\n",2);
            table.addCell(cell);


    		String signatures="";
    		Vector pointers=Pointer.getPointers("SUMINVSIGN."+invoice.getUid());
    		for(int n=0;n<pointers.size();n++){
    			if(n>0){
    				signatures+=", ";
    			}
    			signatures+=(String)pointers.elementAt(n);
    		}
    		if(signatures.length()>0){
    			signatures="\n"+ScreenHelper.getTran(null,"web.finance","signed.by",sPrintLanguage)+": "+signatures;
    		}
        	if(MedwanQuery.getInstance().getConfigInt("printPatientSignatureOnInvoice",1)==1){
        		table.addCell(createValueCell(getTran("patientsignature"),1));
        	}
        	else {
        		table.addCell(createValueCell("",1));
        	}
            table.addCell(createValueCell(getTran("careproviderSignature")+signatures,1));
            doc.add(table);
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //### PRIVATE METHODS #########################################################################

    //--- GET INSURANCE DATA ----------------------------------------------------------------------
    private PdfPTable getInsuranceData(Insurance insurance,SummaryInvoice invoice){
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
        table.addCell(createValueCell(":   "+invoice.getInsuranceReferences(),5));
        table.addCell(createLabelCell(getTran("insurance","member"),2));
        table.addCell(createValueCell(":   "+ScreenHelper.checkString(insurance.getMember()),5));
        
        if(invoice.getComment().length()>0){
	        table.addCell(createLabelCell(getTran("web.finance","otherreference"),2));
	        table.addCell(createValueCell(":   "+invoice.getComment(),12));
        }

        //*** ROW 4 ***
        // complementary insurar
        Vector debets = invoice.getDebets();
        HashSet insurances = new HashSet();
        String extraInsurars="";
        for (int n=0;n<debets.size();n++){
        	ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(n);
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
    private void getDebets(SummaryInvoice invoice,PdfPTable tableParent,Vector debets){

        Vector newdebets = new Vector();
        if(MedwanQuery.getInstance().getConfigInt("defaultInvoiceSummarizeDebets",0)==1){
            SortedMap prestations = new TreeMap();
            for(int n=0;n<debets.size();n++){
            	ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(n);
            	if(debet.getPrestation()!=null && debet.getQuantity()!=0){
        			//printDebet(debet,table);
            		if(prestations.get(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid())==null){
            			prestations.put(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid(), debet);
            		}
            		else {
            			ConsolidatedDebet olddebet = (ConsolidatedDebet)prestations.get(debet.getPrestation().getDescription()+"."+debet.getInsuranceUid()+"."+debet.getPrestationUid());
            			olddebet.setQuantity(olddebet.getQuantity()+debet.getQuantity());
            			olddebet.setPatientamount(olddebet.getPatientamount()+debet.getPatientamount());
            			olddebet.setInsureramount(olddebet.getInsureramount()+debet.getInsureramount());
            			olddebet.setExtrainsureramount(olddebet.getExtrainsureramount()+debet.getExtrainsureramount());
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
            ConsolidatedDebet debet;
            String activePrestationClass="";

            for(int i=0; i<newdebets.size(); i++){
                table = new PdfPTable(200);
                table.setWidthPercentage(pageWidth);
                debet = (ConsolidatedDebet)newdebets.get(i);
                String prestationClass= debet.getPrestation().getReferenceObject().getObjectType()==null?"?":debet.getPrestation().getReferenceObject().getObjectType();
                if(!prestationClass.equalsIgnoreCase(activePrestationClass)){
                    //This is a new prestation class, go calculate the header
                    activePrestationClass=prestationClass;
                    printPrestationClass(table,activePrestationClass,newdebets);
                }
                totalPatient+= debet.getPatientamount();
                totalInsurar+= debet.getInsureramount();
                totalExtraInsurar+= debet.getExtrainsureramount();
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
    private PdfPTable getCredits(SummaryInvoice invoice){
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
            ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(n);
            String sClass= debet.getPrestation().getReferenceObject().getObjectType()==null?"?":debet.getPrestation().getReferenceObject().getObjectType();
            if(sClass.equalsIgnoreCase(prestationClass)){
                classPatientAmount+=debet.getPatientamount();
                classInsurarAmount+=debet.getInsureramount();
                classExtraInsurarAmount+=debet.getExtrainsureramount();
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
    private void printDebet(PdfPTable invoiceTable, ConsolidatedDebet debet){
        double debetAmountPatient = debet.getPatientamount();
        double debetAmountInsurar = debet.getInsureramount();
        double debetAmountExtraInsurar = debet.getExtrainsureramount();

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
        invoiceTable.addCell(createValueCell(sPrestationCode+sPrestationDescr+extraInsurar,90));
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
        invoiceTable.addCell(createValueCell((ScreenHelper.checkString(credit.getInvoiceUid()).split("\\.").length<2?"":getTran("web","invoicenumber")+": "+credit.getInvoiceUid().split("\\.")[1]+" - ")+sCreditComment,9));
        invoiceTable.addCell(createPriceCell(creditAmount,3));
        invoiceTable.addCell(createEmptyCell(3));
    }

    //--- GET SALDO -------------------------------------------------------------------------------
    private PdfPTable getSaldo(Vector debets, SummaryInvoice invoice){
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
        	ConsolidatedDebet debet = (ConsolidatedDebet)debets.elementAt(n);
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
        		complementaryinsurar+=debet.getPatientamount();
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