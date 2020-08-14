package be.mxs.common.util.pdf.general;

import be.mxs.common.util.pdf.official.PDFOfficialBasic;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.adt.Encounter;
import be.openclinic.adt.Encounter.EncounterService;
import be.openclinic.finance.Prestation;
import be.openclinic.pharmacy.Batch;
import be.openclinic.pharmacy.BatchOperation;
import be.openclinic.pharmacy.DrugCategory;
import be.openclinic.pharmacy.OperationDocument;
import be.openclinic.pharmacy.OrderForm;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductOrder;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.pharmacy.ProductStockOperation;
import be.openclinic.pharmacy.ServiceStock;
import be.openclinic.util.Nomenclature;
import be.chuk.Article;

import com.itextpdf.text.pdf.*;
import com.itextpdf.text.*;

import net.admin.User;
import net.admin.AdminPerson;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import oracle.net.ano.Service;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.io.SAXReader;

import java.io.ByteArrayOutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashSet;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;
import java.util.Hashtable;
import java.util.Collections;
import java.util.Enumeration;

/**
 * User: stijn smets
 * Date: 21-nov-2006
 */
public class PDFXMLReportGenerator extends PDFOfficialBasic {

    // declarations
    private final int pageWidth = 100;
    private String type;
    private final long day = 24*3600*1000;
    private int horizontalalign;
    PdfWriter docWriter=null;
    org.dom4j.Element report = null;
    Encounter encounter = null;
    TransactionVO transaction = null;
    
    public void addHeader(){
    }
    public void addContent(){
    }



    //--- CONSTRUCTOR -----------------------------------------------------------------------------
    public PDFXMLReportGenerator(User user, String sProject, String sPrintLanguage){
        this.user = user;
        this.sProject = sProject;
        this.sPrintLanguage = sPrintLanguage;
        doc = new com.itextpdf.text.Document();
    }

    public static String cs(String s){
    	return ScreenHelper.checkString(s);
    }
    
    public static String cs(String s,String defaultValue){
    	if(s==null){
    		return defaultValue;
    	}
    	else{
    		return s;
    	}
    }
    
    //--- GENERATE PDF DOCUMENT BYTES -------------------------------------------------------------
    public ByteArrayOutputStream generatePDFDocumentBytes(final HttpServletRequest req, String reportFileName, String encounteruid) throws Exception {
    	ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
		docWriter = PdfWriter.getInstance(doc,baosPDF);
        this.req = req;

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
			SAXReader reader = new SAXReader(false);
			encounter = Encounter.get(encounteruid);
			patient = encounter.getPatient();
			String sDoc = MedwanQuery.getInstance().getConfigString("reportSource",MedwanQuery.getInstance().getConfigString("templateSource")) + reportFileName;
            Document document = reader.read(new URL(sDoc));
			report = document.getRootElement();
        	if(cs(report.attributeValue("orientation"),"portrait").equalsIgnoreCase("portrait")){
        		if(cs(report.attributeValue("size","A4")).equalsIgnoreCase("A4")){
        			doc.setPageSize(PageSize.A4);
        		}
        		else if(cs(report.attributeValue("size")).equalsIgnoreCase("A3")){
        			doc.setPageSize(PageSize.A3);
        		}
        		else if(cs(report.attributeValue("size")).equalsIgnoreCase("A5")){
        			doc.setPageSize(PageSize.A5);
        		}
        	}
        	else {
        		if(cs(report.attributeValue("size","A4")).equalsIgnoreCase("A4")){
        			doc.setPageSize(PageSize.A4.rotate());
        		}
        		else if(cs(report.attributeValue("size")).equalsIgnoreCase("A3")){
        			doc.setPageSize(PageSize.A3.rotate());
        		}
        		else if(cs(report.attributeValue("size")).equalsIgnoreCase("A5")){
        			doc.setPageSize(PageSize.A5.rotate());
        		}
        	}
        	doc.addTitle(cs(report.attributeValue("name")));
            doc.open();
            //Now write content to report
            writeReport();
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
    
    private void writeReport(){
    	//A report is a sequence of tables, therefore run through te different tables
    	Iterator reportTables = report.elementIterator("table");
    	while(reportTables.hasNext()){
    		org.dom4j.Element reportTable = (org.dom4j.Element)reportTables.next();
    		table = new PdfPTable(Integer.parseInt(cs(reportTable.attributeValue("columns"),"1")));
    		writeTable(reportTable);
    		try {
				doc.add(table);
			} catch (DocumentException e) {
				e.printStackTrace();
			}
    	}
    }
    
    private void writeTable(org.dom4j.Element reportTable){
    	//A table is a sequence of rows and loops, run through the elements of the table
    	Iterator tableElements = reportTable.elementIterator();
    	while(tableElements.hasNext()){
    		org.dom4j.Element tableElement = (org.dom4j.Element)tableElements.next();
    		if(tableElement.getName().equalsIgnoreCase("row")){
    			writeRow(tableElement);
    		}
    		else if(tableElement.getName().equalsIgnoreCase("loop")){
    			doLoop(tableElement);
    		}
    	}
    }
    
    private void doLoop(org.dom4j.Element loopElement){
    	//We must execute the content of the loop each time the condition applies
    	if(cs(loopElement.attributeValue("type")).equalsIgnoreCase("transactions")){
    		String transactionType = cs(loopElement.attributeValue("transactiontype"),"");
    		if(!transactionType.startsWith("be.mxs.common.model.vo.healthrecord.IConstants.")){
    			transactionType="be.mxs.common.model.vo.healthrecord.IConstants."+transactionType;
    		}
    		Vector transactions = null;
    		if(transactionType.length()>0){
    			transactions=MedwanQuery.getInstance().getTransactionsByType(Integer.parseInt(patient.personid), transactionType, encounter.getUid());
    		}
    		else{
    			transactions=MedwanQuery.getInstance().getTransactionsByEncounter(Integer.parseInt(patient.personid), encounter.getUid());
    		}
    		Collections.reverse(transactions);
    		for(int n=0;n<transactions.size();n++){
    			transaction = (TransactionVO)transactions.elementAt(n);
    			writeTable(loopElement);
    		}
    	}
    	else if(cs(loopElement.attributeValue("type")).equalsIgnoreCase("itemexists")){
    		String itemType = cs(loopElement.attributeValue("itemtype"),"");
    		if(!itemType.startsWith("be.mxs.common.model.vo.healthrecord.IConstants.")){
    			itemType="be.mxs.common.model.vo.healthrecord.IConstants."+itemType;
    		}
    		if(transaction.getItemValue(itemType).trim().length()>0){
    			writeTable(loopElement);
    		}
    	}
    	else if(cs(loopElement.attributeValue("type")).equalsIgnoreCase("itemcompare")){
    		String itemType = cs(loopElement.attributeValue("itemtype"),"");
    		if(!itemType.startsWith("be.mxs.common.model.vo.healthrecord.IConstants.")){
    			itemType="be.mxs.common.model.vo.healthrecord.IConstants."+itemType;
    		}
    		String s =transaction.getItemValue(itemType).trim();
    		if(s.length()>0){
    			double d = Double.parseDouble(s);
    			boolean bExecute = false;
    			String compare = cs(loopElement.attributeValue("compare"));
    			double ref = Double.parseDouble(compare.split(";")[1]);
    			try{
	    			if(compare.split(";")[0].equalsIgnoreCase("<") && d>=ref){
	    				return;
	    			}
	    			else if(compare.split(";")[0].equalsIgnoreCase("<=") && d>ref){
	    				return;
	    			}
	    			else if(compare.split(";")[0].equalsIgnoreCase(">=") && d<ref){
	    				return;
	    			}
	    			else if(compare.split(";")[0].equalsIgnoreCase(">") && d<=ref){
	    				return;
	    			}
	    			else if(compare.split(";")[0].equalsIgnoreCase("=") && !(d==ref)){
	    				return;
	    			}
	    			writeTable(loopElement);
    			}
    			catch(Exception e){
    				e.printStackTrace();
    			}
    		}
    	}
    }
    
    private void writeRow(org.dom4j.Element reportRow){
    	//A row is a collection of cells, run through the different cells
    	Iterator reportCells = reportRow.elementIterator("cell");
    	while(reportCells.hasNext()){
    		org.dom4j.Element reportCell = (org.dom4j.Element)reportCells.next();
    		writeCell(reportCell);
    	}
    }
    
    private void writeCell(org.dom4j.Element reportCell){
    	int colspan = Integer.parseInt(cs(reportCell.attributeValue("columns"),"1"));
    	String align = cs(reportCell.attributeValue("align"),"left");
    	if(align.equalsIgnoreCase("left")){
    		horizontalalign=PdfPCell.ALIGN_LEFT;
    	}
    	else if(align.equalsIgnoreCase("right")){
    		horizontalalign=PdfPCell.ALIGN_RIGHT;
    	}
    	else if(align.equalsIgnoreCase("center")){
    		horizontalalign=PdfPCell.ALIGN_CENTER;
    	}
    	String type = cs(reportCell.attributeValue("type"),"title");
    	if(type.equalsIgnoreCase("title")){
    		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"10"));
    		cell = createTitleCell(reportCell.getTextTrim(), colspan, fontsize);
    		cell.setHorizontalAlignment(horizontalalign);
        	table.addCell(cell);
    	}
    	else if(type.equalsIgnoreCase("label")){
    		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"7"));
    		cell = createLabel(reportCell.getTextTrim(), fontsize, colspan, Font.NORMAL);
    		cell.setVerticalAlignment(PdfPCell.TOP);
    		cell.setHorizontalAlignment(horizontalalign);
        	table.addCell(cell);
    	}
    	else if(type.equalsIgnoreCase("line")){
    		cell = new PdfPCell();
    		cell.setColspan(colspan);
    		cell.setBorder(PdfPCell.BOTTOM);
        	table.addCell(cell);
    	}
    	else if(type.equalsIgnoreCase("patientadmin")){
    		writePatientAdmin(reportCell,colspan);
    	}
    	else if(type.equalsIgnoreCase("encounter")){
    		writeEncounter(reportCell, colspan);
    	}
    	else if(type.equalsIgnoreCase("transaction")){
    		writeTransaction(reportCell, colspan);
    	}
    	else if(type.equalsIgnoreCase("item")){
    		writeItem(reportCell, colspan);
    	}
    }
    
    private void writeItem(org.dom4j.Element reportCell, int colspan){
		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"8"));
		String itemType = reportCell.getText();
		if(!itemType.startsWith("be.mxs.common.model.vo.healthrecord.IConstants.")){
			itemType = "be.mxs.common.model.vo.healthrecord.IConstants."+itemType;
		}
		String s="";
		if(cs(reportCell.attributeValue("translate")).length()==0){
			s=cs(transaction.getItemValue(itemType));
		}
		else if(cs(reportCell.attributeValue("translate")).startsWith("translate")){
			String[] ss = transaction.getItemValue(itemType).split(";");
			for(int n=0;n<ss.length;n++){
				if(s.length()>0){
					s+=", ";
				}
				s+=ScreenHelper.uppercaseFirstLetter(ScreenHelper.getTranNoLink(reportCell.attributeValue("translate").split(";")[1],ss[n],sPrintLanguage));
			}
		}
		else if(cs(reportCell.attributeValue("translate")).equalsIgnoreCase("keywords")){
			String[] ss = transaction.getItemValue(itemType).split(";");
			for(int n=0;n<ss.length;n++){
				if(ss[n].contains("$")){
					if(s.length()>0){
						s+=", ";
					}
					s+=ScreenHelper.uppercaseFirstLetter(ScreenHelper.getTranNoLink(ss[n].split("\\$")[0],ss[n].split("\\$")[1],sPrintLanguage));
				}
			}
		}
		cell = createBoldValueCell(fontsize, s, colspan);
		cell.setHorizontalAlignment(horizontalalign);
    	table.addCell(cell);
    }
    
    private void writeTransaction(org.dom4j.Element reportCell, int colspan){
		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"8"));
		String s="";
		if(cs(reportCell.getText()).equalsIgnoreCase("updatetime")){
			s=ScreenHelper.formatDate(transaction.getUpdateTime());
		}
		else if(cs(reportCell.getText()).equalsIgnoreCase("username")){
			s=transaction.getUser().getPersonVO().getFullName();
		}
		else if(cs(reportCell.getText()).equalsIgnoreCase("transactiontype")){
			s=ScreenHelper.getTranNoLink("web.occup",transaction.getTransactionType(),sPrintLanguage);
		}
		cell = createBoldValueCell(fontsize, s, colspan);
		cell.setHorizontalAlignment(horizontalalign);
    	table.addCell(cell);
    }
    
    private void writeEncounter(org.dom4j.Element reportCell, int colspan){
		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"8"));
		String[] cellText = cs(reportCell.getText()).split(";");
		String s = "";
		for(int n=0;n<cellText.length;n++){
			if(cellText[n].startsWith("\"") || cellText[n].startsWith("\"")){
				s+=cellText[n].substring(1, cellText[n].length()-1);
			}
			if(cellText[n].equalsIgnoreCase("uid")){
				s+=encounter.getUid();
			}
			else if(cellText[n].equalsIgnoreCase("begindate")){
				s+=ScreenHelper.formatDate(encounter.getBegin());
			}
			else if(cellText[n].equalsIgnoreCase("enddate")){
				s+=ScreenHelper.formatDate(encounter.getEnd()==null?new java.util.Date():encounter.getEnd());
			}
			else if(cellText[n].equalsIgnoreCase("services")){
				Vector transfers = encounter.getFullTransferHistory();
				SortedSet services = new TreeSet();
				for(int i=0;i<transfers.size();i++){
					EncounterService service = (EncounterService)transfers.elementAt(i);
					services.add(ScreenHelper.getTranNoLink("service", service.serviceUID, sPrintLanguage));
				}
				Iterator iServices = services.iterator();
				while(iServices.hasNext()){
					String serv=(String)iServices.next();
					if(s.length()>0){
						s+=", ";
					}
					s+=serv;
				}
			}
		}
		cell = createBoldValueCell(fontsize, s, colspan);
		cell.setHorizontalAlignment(horizontalalign);
    	table.addCell(cell);
    }

    private void writePatientAdmin(org.dom4j.Element reportCell, int colspan){
		int fontsize = Integer.parseInt(cs(reportCell.attributeValue("fontsize"),"8"));
		String[] cellText = cs(reportCell.getText()).split(";");
		String s = "";
		for(int n=0;n<cellText.length;n++){
			if(cellText[n].startsWith("\"") || cellText[n].startsWith("\"")){
				s+=cellText[n].substring(1, cellText[n].length()-1);
			}
			if(cellText[n].equalsIgnoreCase("personid")){
				s+=patient.personid;
			}
			else if(cellText[n].equalsIgnoreCase("lastname")){
				s+=patient.lastname.toUpperCase();
			}
			else if(cellText[n].equalsIgnoreCase("firstname")){
				s+=ScreenHelper.uppercaseFirstLetter(patient.firstname);
			}
			else if(cellText[n].equalsIgnoreCase("gender")){
				s+=ScreenHelper.getTran("gender", patient.gender, sPrintLanguage);
			}
			else if(cellText[n].equalsIgnoreCase("dateofbirth")){
				s+=patient.dateOfBirth;
			}
		}
		cell = createBoldValueCell(fontsize, s, colspan);
		cell.setHorizontalAlignment(horizontalalign);
    	table.addCell(cell);
    }

    //---- ADD PAGE HEADER ------------------------------------------------------------------------
    private void addPageHeader() throws Exception {
    }

	private void addCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}
	private void addCol(org.dom4j.Element row, int size, String value, int fontsize){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("fontsize", fontsize+"");
		col.setText(value);
	}
	private void addBoldCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("weight", "bold");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}
	
	private void addRightCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("align", "right");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}
	
	private void addCenterCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("align", "center");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}
	
	private void addRightBoldCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("align", "right");
		col.addAttribute("weight", "bold");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}

	private void addCenterBoldCol(org.dom4j.Element row, int size, String value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("align", "center");
		col.addAttribute("weight", "bold");
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
		col.setText(value);
	}

	private void addPriceCol(org.dom4j.Element row, int size, double value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.setText(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#")).format(value));
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
	}

	private void addPriceCol(org.dom4j.Element row, int size, double value,String format){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.setText(new DecimalFormat(format).format(value));
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
	}

	private void addPriceBoldCol(org.dom4j.Element row, int size, double value,String format){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("weight", "bold");
		col.setText(new DecimalFormat(format).format(value));
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
	}

	private void addPriceBoldCol(org.dom4j.Element row, int size, double value){
		org.dom4j.Element col = row.addElement("col");
		col.addAttribute("size", size+"");
		col.addAttribute("weight", "bold");
		col.setText(new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#")).format(value));
		col.addAttribute("fontsize", MedwanQuery.getInstance().getConfigString("defaultPharmacyReportFontSize","8"));
	}

    
    protected void printDocument(org.dom4j.Document d) throws DocumentException{
    	org.dom4j.Element root = d.getRootElement();
    	table = new PdfPTable(Integer.parseInt(root.attributeValue("size")));
    	table.setWidthPercentage(100);
    	Iterator rows = root.elementIterator("row");
    	while(rows.hasNext()){
    		org.dom4j.Element row = (org.dom4j.Element)rows.next();
			Iterator cols = row.elementIterator("col");
			while(cols.hasNext()){
				org.dom4j.Element col = (org.dom4j.Element)cols.next();
				int fontsize=10;
				if(ScreenHelper.checkString(col.attributeValue("fontsize")).length()>0){
					fontsize=Integer.parseInt(ScreenHelper.checkString(col.attributeValue("fontsize")));
				}
	    		if(ScreenHelper.checkString(row.attributeValue("type")).equalsIgnoreCase("title")){
	    			cell = createGreyCell(fontsize,col.getText(), Integer.parseInt(col.attributeValue("size")));
	    		}
	    		else {
		    		if(ScreenHelper.checkString(col.attributeValue("weight")).equalsIgnoreCase("bold")){
		    			cell = createBoldValueCell(fontsize,col.getText(), Integer.parseInt(col.attributeValue("size")));
		    		}
		    		else {
		    			cell = createValueCell(fontsize,col.getText(), Integer.parseInt(col.attributeValue("size")));
		    		}
	    		}
	    		if(ScreenHelper.checkString(col.attributeValue("align")).equalsIgnoreCase("right")){
	    			cell.setHorizontalAlignment(PdfPCell.ALIGN_RIGHT);
	    		}
	    		else if(ScreenHelper.checkString(col.attributeValue("align")).equalsIgnoreCase("center")){
	    			cell.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
	    		}
	    		table.addCell(cell);
			}
    	}
    	doc.add(table);
    }

    protected void printExpiration(org.dom4j.Document d, org.dom4j.Element t, String sBegin, String sEnd, String sServiceStockUID) throws ParseException{
		d.add(t);
        t.addAttribute("size", "200");
        java.util.Date begin = ScreenHelper.parseDate(sBegin);
        java.util.Date end = ScreenHelper.parseDate(sEnd);
    	
		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","expiration",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","stock",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));
		
		//Now we have to find all productstocks sorted by productsubgroup
		SortedMap stocks = new TreeMap();
		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
		for(int n=0;n<productStocks.size();n++){
			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			//Check if product is about to expire
			Vector batches = Batch.getAllBatches(stock.getUid());
			for (int i=0; i<batches.size();i++){
				Batch batch = (Batch)batches.elementAt(i);
				if(batch.getLevel()>0 && batch.getEnd()!=null && !batch.getEnd().after(end) && batch.getEnd().after(begin)){
					//First find the product subcategory
					String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+stock.getUid()+"|"+new SimpleDateFormat("dd/MM/yyyy").format(batch.getEnd())+"|"+batch.getLevel()+"|"+batch.getBatchNumber();
					stocks.put(uid, stock);
				}
			}
		}
		
		Hashtable printedSubTitels = new Hashtable();
		Iterator iStocks = stocks.keySet().iterator();
		boolean bInitialized = false;
		double generalTotal=0;
		while(iStocks.hasNext()){
			String key = (String)iStocks.next();
			ProductStock stock = (ProductStock)stocks.get(key);
			//Nu kijken we welke tussentitels er moeten geprint worden
			String[] subtitles = key.split("\\|")[0].split(";");
			String title="";
			for(int n=0;n<subtitles.length;n++){
				title+=subtitles[n]+";";
				if(printedSubTitels.get(title)==null){
					//This one must be printed
			        row =t.addElement("row");
			        if(n>0){
			        	addCol(row,n*5,"");
			        }
					addBoldCol(row,200-n*5,subtitles[n]);
					printedSubTitels.put(title, "1");
				}
			}
			bInitialized=true;
			//Nu printen we de gegevens van de productstock
	        row =t.addElement("row");
			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
			addCol(row,80,stock.getProduct()==null?"":stock.getProduct().getName()+" ("+getTran("web","batchnumber.short")+": "+(key.split("\\|").length>4?key.split("\\|")[4]:"")+")");
			addCol(row,20,key.split("\\|").length>2?key.split("\\|")[2]:"");
			int level=0;
			try{
				level=Integer.parseInt(key.split("\\|")[3]);
			}
			catch(Exception r){};
			addCol(row,20,level+"");
			addCol(row,20,stock.getProduct()==null?"":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),sPrintLanguage));
			double pump=0;
			if(stock.getProduct()!=null){
				pump=stock.getProduct().getLooseLastYearsAveragePrice(new java.util.Date(new java.util.Date().getTime()+day));
			}
			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
			addPriceCol(row,20,level*pump);
			generalTotal+=level*pump;
		}
		if(bInitialized){
	        row =t.addElement("row");
			addRightBoldCol(row,180,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
			addPriceBoldCol(row,20,generalTotal);
		}
    }


    protected void printStockOut(org.dom4j.Document d, org.dom4j.Element t, String sDate, String sServiceStockUID) throws ParseException{
		d.add(t);
        t.addAttribute("size", "200");
        java.util.Date date = ScreenHelper.parseDate(sDate);
    	
		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
		addCol(row,100,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
		addCol(row,40,ScreenHelper.getTranNoLink("web","stock",sPrintLanguage));
		addCol(row,40,ScreenHelper.getTranNoLink("web","minstock",sPrintLanguage));
		
		//Now we have to find all productstocks sorted by productsubgroup
		SortedMap stocks = new TreeMap();
		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
		for(int n=0;n<productStocks.size();n++){
			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			if(stock.getLevel()<stock.getMinimumLevel()){
				//First find the product subcategory
				String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+stock.getUid();
				stocks.put(uid, stock);
			}
		}
		
		Hashtable printedSubTitels = new Hashtable();
		Iterator iStocks = stocks.keySet().iterator();
		while(iStocks.hasNext()){
			String key = (String)iStocks.next();
			ProductStock stock = (ProductStock)stocks.get(key);
			//Nu kijken we welke tussentitels er moeten geprint worden
			String[] subtitles = key.split("\\|")[0].split(";");
			String title="";
			for(int n=0;n<subtitles.length;n++){
				title+=subtitles[n]+";";
				if(printedSubTitels.get(title)==null){
					//This one must be printed
			        row =t.addElement("row");
			        if(n>0){
			        	addCol(row,n*5,"");
			        }
					addBoldCol(row,200-n*5,subtitles[n]);
					printedSubTitels.put(title, "1");
				}
			}
			//Nu printen we de gegevens van de productstock
	        row =t.addElement("row");
			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
			addCol(row,100,stock.getProduct()==null?"":stock.getProduct().getName());
			addCol(row,40,stock.getLevel()+"");
			addCol(row,40,stock.getMinimumLevel()+"");
		}
    }


    protected void printServiceStockInventory(org.dom4j.Document d, org.dom4j.Element t, String sDate, String sServiceStockUID, String sProductGroup, String sProductSubGroup) throws ParseException{
		d.add(t);
        t.addAttribute("size", "230");
    	
		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
		addCol(row,90,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
		addCol(row,30,ScreenHelper.getTranNoLink("web","batch",sPrintLanguage));
		addCol(row,30,ScreenHelper.getTranNoLink("web","expires",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","theor.stock",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","pump",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","theor.value",sPrintLanguage));
		
 		if(MedwanQuery.getInstance().getConfigInt("printServiceStockInventoryShowClasses",1)==1){
			//Now we have to find all productstocks sorted by productsubgroup
			SortedMap groups = new TreeMap();
			String[] serviceStockUids = sServiceStockUID.split(";");
			for(int q=0;q<serviceStockUids.length;q++){
				Vector productStocks = ServiceStock.getProductStocks(serviceStockUids[q]);
				for(int n=0;n<productStocks.size();n++){
					ProductStock stock = (ProductStock)productStocks.elementAt(n);
					if((MedwanQuery.getInstance().getConfigInt("pharmacyShowZeroLevelStocks",0)==0 && stock.getLevel()==0) || stock.getProduct()==null){
						continue;
					}
					String uid="";
					//We first figure out in which group this stock should go
					if(stock!=null && stock.getProduct()!=null && ScreenHelper.checkString(stock.getProduct().getProductGroup()).startsWith(sProductGroup) && ScreenHelper.checkString(stock.getProduct().getProductSubGroup()).startsWith(sProductSubGroup)){
						//First find the product subcategory
						uid=stock.getProduct().getProductGroup()==null?"?":HTMLEntities.unhtmlentities(ScreenHelper.getTranNoLink("product.productgroup",stock.getProduct().getProductGroup(),sPrintLanguage))+" > "+stock.getProduct().getFullProductSubGroupName(sPrintLanguage);
						if(groups.get(uid)==null){
							groups.put(uid, new TreeMap());
						}
					}
					else if(sProductGroup.length()==0 && sProductSubGroup.length()==0){
						uid="?";
						if(groups.get(uid)==null){
							groups.put(uid, new TreeMap());
						}
					}
					if(uid.length()>0){
						SortedMap stocks = (TreeMap)groups.get(uid);
						//Now we add an entry for each combination productUid+BatchNumber
						//Look up all batches for this product
						int nBatchedQuantity=0;
						java.util.Date date = ScreenHelper.parseDate(sDate);
						int datelevel=stock.getLevel(date);
						Vector batches = Batch.getAllBatches(stock.getUid());
						for(int b=0;b<batches.size() && (nBatchedQuantity<datelevel);b++){
							Batch batch = (Batch)batches.elementAt(b);
							int level=batch.getLevel(date);
							if(level>0){
								if(datelevel<nBatchedQuantity+level){
									level=level-(nBatchedQuantity+level-datelevel);
								}
								nBatchedQuantity+=level;
								uid=stock.getProduct().getName()+";"+checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+";"+batch.getBatchNumber()+";"+ScreenHelper.formatDate(batch.getEnd())+" ;";
								if(stocks.get(uid)==null){
									stocks.put(uid, 0);
								}
								stocks.put(uid,	(Integer)stocks.get(uid)+level);
							}
						}
						if(nBatchedQuantity<datelevel){
							//Part of the stock has no batch associated 
							uid=stock.getProduct().getName()+";"+checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+"; ; ;";
							if(stocks.get(uid)==null){
								stocks.put(uid, 0);
							}
							stocks.put(uid,	(Integer)stocks.get(uid)+datelevel-nBatchedQuantity);
						}
					}
				}
			}
			Hashtable printedSubTitels = new Hashtable();
			Iterator iGroups = groups.keySet().iterator();
			boolean bInitialized = false;
			double sectionTotal=0,generalTotal=0;
			String title="";
			while(iGroups.hasNext()){
				String key = (String)iGroups.next();
				//For each new group, we are going to print a title
				if(bInitialized){
					//First print the totals from the previous title
			        row =t.addElement("row");
					addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","total.for",sPrintLanguage)+": "+(title.length()==0?"?":title));
					addPriceBoldCol(row,20,sectionTotal);
					sectionTotal=0;
				}
				bInitialized=true;
				title=key;
		        row =t.addElement("row");
				addBoldCol(row, 230, title);
				SortedMap stocks = (SortedMap)groups.get(key);
				//Now we print a line for each element in the stocks for this group
				Iterator iStocks = stocks.keySet().iterator();
				while(iStocks.hasNext()){
					String key2 = (String)iStocks.next();
					//Nu printen we de gegevens van de productstock
			        row =t.addElement("row");
					addCol(row,20,key2.split(";")[1]);
					addCol(row,90,key2.split(";")[0]);
					addCol(row,30,key2.split(";")[3]);
					addCol(row,30,key2.split(";")[4]);
					int level=(Integer)stocks.get(key2);
					addCol(row,20,level+"");
					double pump=0;
					Product product = Product.get(key2.split(";")[2]);
					if(product!=null){
						pump=product.getLastYearsAveragePrice(new java.util.Date(ScreenHelper.parseDate(sDate).getTime()+day));
					}
					addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
					addPriceCol(row,20,level*pump);
					sectionTotal+=level*pump;
					generalTotal+=level*pump;
				}
			}
			if(bInitialized){
		        row =t.addElement("row");
				addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","total.for",sPrintLanguage)+": "+(title.length()==0?"?":title));
				addPriceBoldCol(row,20,sectionTotal);
				addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
				addPriceBoldCol(row,20,generalTotal);
			}
 		}
 		else{
			SortedMap groups = new TreeMap();
			String[] serviceStockUids = sServiceStockUID.split(";");
			for(int q=0;q<serviceStockUids.length;q++){
				Vector productStocks = ServiceStock.getProductStocks(serviceStockUids[q]);
				for(int n=0;n<productStocks.size();n++){
					ProductStock stock = (ProductStock)productStocks.elementAt(n);
					if((MedwanQuery.getInstance().getConfigInt("pharmacyShowZeroLevelStocks",0)==0 && stock.getLevel()==0) || stock.getProduct()==null){
						continue;
					}
					String uid=stock.getProduct().getName().toUpperCase();
					if(uid.length()>0){
						if(groups.get(uid)==null){
							groups.put(uid, new TreeMap());
						}
						SortedMap stocks = (TreeMap)groups.get(uid);
						//Now we add an entry for each combination productUid+BatchNumber
						//Look up all batches for this product
						int nBatchedQuantity=0;
						java.util.Date date = ScreenHelper.parseDate(sDate);
						Vector batches = Batch.getAllBatches(stock.getUid());
						for(int b=0;b<batches.size();b++){
							Batch batch = (Batch)batches.elementAt(b);
							int level=batch.getLevel(date);
							if(level>0){
								nBatchedQuantity+=level;
								uid=stock.getProduct().getName()+";"+checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+";"+batch.getBatchNumber()+";"+ScreenHelper.formatDate(batch.getEnd())+" ;";
								if(stocks.get(uid)==null){
									stocks.put(uid, 0);
								}
								stocks.put(uid,	(Integer)stocks.get(uid)+level);
							}
						}
						if(stock.getLevel(date)>nBatchedQuantity){
							//Part of the stock has no batch associated 
							uid=stock.getProduct().getName()+";"+checkString(stock.getProduct().getCode())+";"+stock.getProduct().getUid()+"; ; ;";
							if(stocks.get(uid)==null){
								stocks.put(uid, 0);
							}
							stocks.put(uid,	(Integer)stocks.get(uid)+stock.getLevel(date)-nBatchedQuantity);
						}
					}
				}
			}
			Hashtable printedSubTitels = new Hashtable();
			Iterator iGroups = groups.keySet().iterator();
			boolean bInitialized = false;
			double sectionTotal=0,generalTotal=0;
			String title="";
			while(iGroups.hasNext()){
				String key = (String)iGroups.next();
				SortedMap stocks = (SortedMap)groups.get(key);
				//Now we print a line for each element in the stocks for this group
				Iterator iStocks = stocks.keySet().iterator();
				while(iStocks.hasNext()){
					String key2 = (String)iStocks.next();
					//Nu printen we de gegevens van de productstock
			        row =t.addElement("row");
					addCol(row,20,key2.split(";")[1]);
					addCol(row,90,key2.split(";")[0]);
					addCol(row,30,key2.split(";")[3]);
					addCol(row,30,key2.split(";")[4]);
					int level=(Integer)stocks.get(key2);
					addCol(row,20,level+"");
					double pump=0;
					Product product = Product.get(key2.split(";")[2]);
					if(product!=null){
						pump=product.getLastYearsAveragePrice(new java.util.Date(ScreenHelper.parseDate(sDate).getTime()+day));
					}
					addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
					addPriceCol(row,20,level*pump);
					sectionTotal+=level*pump;
					generalTotal+=level*pump;
				}
			}
	        row =t.addElement("row");
			addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
			addPriceBoldCol(row,20,generalTotal);
 		}
    }

    protected void printMonthlyConsumption(org.dom4j.Document d, org.dom4j.Element t, String sDate, String sServiceStockUID,boolean bIncludePatients,boolean bIncludeStocks,boolean bOther) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "180");

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","cmm",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","min.stock",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","max.stock",sPrintLanguage),8);
		
		//Now we have to find all productstocks sorted by productsubgroup
		SortedMap stocks = new TreeMap();
		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
		for(int n=0;n<productStocks.size();n++){
			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			//First find the product subcategory
			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+stock.getUid();
			stocks.put(uid, stock);
		}
		
 		Hashtable printedSubTitels = new Hashtable();
 		Iterator iStocks = stocks.keySet().iterator();
 		boolean bInitialized = false;
 		double sectionTotal=0,generalTotal=0;
 		String lasttitle="";
 		while(iStocks.hasNext()){
 			String key = (String)iStocks.next();
 			ProductStock stock = (ProductStock)stocks.get(key);
 			//Nu kijken we welke tussentitels er moeten geprint worden
 			String[] subtitles = key.split("\\|")[0].split(";");
 			String title="";
 			for(int n=0;n<subtitles.length;n++){
 				title+=subtitles[n]+";";
 				if(printedSubTitels.get(title)==null){
 					//This one must be printed
 			        row =t.addElement("row");
 			        if(n>0){
 			        	addCol(row,n*5,"");
 			        }
 					addBoldCol(row,180-n*5,subtitles[n]);
 					printedSubTitels.put(title, "1");
 				}
 				lasttitle=subtitles[n];
 			}
 			java.util.Date date = ScreenHelper.parseDate(sDate);
 			//Nu printen we de gegevens van de productstock
 	        row =t.addElement("row");
 			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
 			addCol(row,80,stock.getProduct()==null || stock.getProduct().getName()==null?"":stock.getProduct().getName());
 			addCol(row,20,stock.getProduct()==null || stock.getProduct().getUnit()==null?"":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),sPrintLanguage),7);
 			int averageConsumption=0;
 			if(stock.getProduct()!=null){
 				averageConsumption=stock.getAverageConsumption(new java.util.Date(date.getTime()+day),bIncludePatients,bIncludeStocks,bOther);
 			}
 			addCol(row,20,averageConsumption+"");
 			addCol(row,20,(averageConsumption*2)+"");
 			addCol(row,20,(averageConsumption*3)+"");
 		}
    	
    }
    
    protected void printProductOrderForm(org.dom4j.Document d, org.dom4j.Element t, String orderFormUid) throws ParseException{
 		OrderForm orderForm = OrderForm.get(orderFormUid);
    	d.add(t);
        t.addAttribute("size", "180");

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		addCol(row,30,ScreenHelper.getTranNoLink("web","imputation",sPrintLanguage),12);
		addCol(row,150,"",8);

		addCol(row,30,ScreenHelper.getTranNoLink("web","supplier",sPrintLanguage),12);
		addCol(row,150,orderForm.getSupplier(),12);
		
		addCol(row,180,"\n",8);
        
		row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,100,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unitprice",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","comment",sPrintLanguage),8);
		
		Vector productOrders = orderForm.getProductOrders();
		Hashtable hOrders = new Hashtable();
		SortedMap hProducts = new TreeMap();
		for(int n=0;n<productOrders.size();n++){
			ProductOrder order = (ProductOrder)productOrders.elementAt(n);
			if(hOrders.get(order.getProductStock().getProductUid())==null){
				hOrders.put(order.getProductStock().getProductUid(), new Double(order.getPackagesOrdered()));
			}
			else{
				hOrders.put(order.getProductStock().getProductUid(), order.getPackagesOrdered()+(Double)hOrders.get(order.getProductStock().getProductUid()));
			}
			hProducts.put(order.getProductStock().getProductUid(),order.getProductStock().getProduct());
		}
		Iterator eOrders = hProducts.keySet().iterator();
		while(eOrders.hasNext()){
			String key = (String)eOrders.next();
			Product product = (Product)hProducts.get(key);
	        row =t.addElement("row");
			addCol(row,20,hOrders.get(key)+"",8);
			addCol(row,100,product.getName(),8);
			addCol(row,20,"",8);
			addCol(row,20,"",8);
			addCol(row,20,"",8);
		}
		
		addCol(row,180,"\n",8);

		addCol(row,30,ScreenHelper.getTranNoLink("web","date",sPrintLanguage)+": "+ScreenHelper.formatDate(orderForm.getDate()),8);
		addCol(row,110,"",8);
		addCol(row,40,ScreenHelper.getTranNoLink("web","signature",sPrintLanguage),8);
		
    }
    
    protected void printProductDeliveryForm(org.dom4j.Document d, org.dom4j.Element t, String orderFormUid) throws ParseException{
 		OrderForm orderForm = OrderForm.get(orderFormUid);
    	d.add(t);
        t.addAttribute("size", "180");

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		addCol(row,180,ScreenHelper.getTranNoLink("web","commissionmembers",sPrintLanguage)+"\n........................................................................\n........................................................................\n........................................................................\n",12);
		addCol(row,180,"\n",8);

		addCol(row,30,ScreenHelper.getTranNoLink("web","supplier",sPrintLanguage),12);
		addCol(row,150,orderForm.getSupplier(),12);
		addCol(row,180,"\n",8);
		
        
		row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,100,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unitprice",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","comment",sPrintLanguage),8);
		
		Vector productOrders = orderForm.getProductOrders();
		Hashtable hOrders = new Hashtable();
		SortedMap hProducts = new TreeMap();
		for(int n=0;n<productOrders.size();n++){
			ProductOrder order = (ProductOrder)productOrders.elementAt(n);
			if(hOrders.get(order.getProductStock().getProductUid())==null){
				hOrders.put(order.getProductStock().getProductUid(), new Double(order.getPackagesDelivered()));
			}
			else{
				hOrders.put(order.getProductStock().getProductUid(), order.getPackagesDelivered()+(Double)hOrders.get(order.getProductStock().getProductUid()));
			}
			hProducts.put(order.getProductStock().getProductUid(),order.getProductStock().getProduct());
		}
		Iterator eOrders = hProducts.keySet().iterator();
		while(eOrders.hasNext()){
			String key = (String)eOrders.next();
			Product product = (Product)hProducts.get(key);
	        row =t.addElement("row");
			addCol(row,100,product.getName(),8);
			addCol(row,20,((Double)hOrders.get(key)).intValue()+"",8);
			double price=0;
			String sPrice=Pointer.getPointerAfterLike("drugprice."+product.getUid(),orderForm.getDate());
			if(sPrice.length()>0 && sPrice.split(";").length>1){
				price=Double.parseDouble(sPrice.split(";")[1]);
			}
			if(price==0){
				addCol(row,20,"",8);
				addCol(row,20,"",8);
				addCol(row,20,"",8);
			}
			else{
				addCol(row,20,ScreenHelper.getPriceFormat(price),8);
				addCol(row,20,ScreenHelper.getPriceFormat(price*(Double)hOrders.get(key)),8);
				addCol(row,20,"",8);
			}
		}
		
		addCol(row,180,"\n",8);

		addCol(row,180,ScreenHelper.getTranNoLink("web","decision",sPrintLanguage)+"\n\n\n\n",12);
		addCol(row,120,"\n",8);
		addCol(row,60,ScreenHelper.getTranNoLink("web","signedon",sPrintLanguage),8);
		
    }
    
    protected void printServiceStockInventory(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
         t.addAttribute("size", "310");

 		//Add title rows
         org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
 		addCol(row,70,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","init.stock",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","entries",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","exits",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","theor.stock",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pump",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","theor.value",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","stock.phys",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","val.reelle",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","manq",sPrintLanguage),8);
 		addCol(row,20,ScreenHelper.getTranNoLink("web","exced",sPrintLanguage),8);
 		
 		if(MedwanQuery.getInstance().getConfigInt("printServiceStockInventoryShowClasses",1)==1){
	 		//Now we have to find all productstocks sorted by productsubgroup
	 		SortedMap stocks = new TreeMap();
	 		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
	 		for(int n=0;n<productStocks.size();n++){
	 			ProductStock stock = (ProductStock)productStocks.elementAt(n);
	 			//First find the product subcategory
	 			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+stock.getUid();
	 			stocks.put(uid, stock);
	 		}
	 		
	 		Hashtable printedSubTitels = new Hashtable();
	 		Iterator iStocks = stocks.keySet().iterator();
	 		boolean bInitialized = false;
	 		double sectionTotal=0,generalTotal=0;
	 		String lasttitle="";
	 		while(iStocks.hasNext()){
	 			String key = (String)iStocks.next();
	 			ProductStock stock = (ProductStock)stocks.get(key);
	 			java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
	 			java.util.Date end = ScreenHelper.parseDate(sDateEnd);
	 			int initiallevel=stock.getLevel(begin);
	 			int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day));
	 			int out = stock.getTotalUnitsOutForPeriod(begin, new java.util.Date(end.getTime()+day));
	 			if(initiallevel!=0 || in!=0 || out!=0){
		 			//Nu kijken we welke tussentitels er moeten geprint worden
		 			String[] subtitles = key.split("\\|")[0].split(";");
		 			String title="";
		 			for(int n=0;n<subtitles.length;n++){
		 				title+=subtitles[n]+";";
		 				if(printedSubTitels.get(title)==null){
		 					//First look if we don't have to print a section total
		 					if(bInitialized){
		 				        row =t.addElement("row");
		 						addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","total.for",sPrintLanguage)+": "+lasttitle);
		 						addPriceBoldCol(row,20,sectionTotal);
		 						addCol(row,20,"");
		 						addCol(row,20,"");
		 						addCol(row,20,"");
		 						addCol(row,20,"");
		 						sectionTotal=0;
		 						bInitialized=false;
		 					}
		 					//This one must be printed
		 			        row =t.addElement("row");
		 			        if(n>0){
		 			        	addCol(row,n*5,"");
		 			        }
		 					addBoldCol(row,230-n*5,subtitles[n]);
		 					addCol(row,20,"");
		 					addCol(row,20,"");
		 					addCol(row,20,"");
		 					addCol(row,20,"");
		 					printedSubTitels.put(title, "1");
		 				}
		 				lasttitle=subtitles[n];
		 			}
		 			bInitialized=true;
		 			//Nu printen we de gegevens van de productstock
		 	        row =t.addElement("row");
		 			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
		 			addCol(row,70,stock.getProduct()==null?"":stock.getProduct().getName());
		 			addCol(row,20,stock.getProduct()==null?"":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),sPrintLanguage),7);
		 			addCol(row,20,initiallevel+"");
		 			addCol(row,20,in+"");
		 			addCol(row,20,out+"");
		 			addCol(row,20,(initiallevel+in-out)+"");
		 			double pump=0;
		 			if(stock.getProduct()!=null){
		 				pump=stock.getProduct().getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
		 			}
		 			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
		 			addPriceCol(row,20,(initiallevel+in-out)*pump);
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			sectionTotal+=(initiallevel+in-out)*pump;
		 			generalTotal+=(initiallevel+in-out)*pump;
	 			}
	 		}
	 		if(bInitialized){
	 	        row =t.addElement("row");
	 			addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","total.for",sPrintLanguage)+": "+lasttitle);
	 			addPriceBoldCol(row,20,sectionTotal);
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 			addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
	 			addPriceBoldCol(row,20,generalTotal);
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 			addCol(row,20,"");
	 		}
 		}
 		else{
	 		//Now we have to find all productstocks sorted by productname
	 		SortedMap stocks = new TreeMap();
	 		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
	 		for(int n=0;n<productStocks.size();n++){
	 			ProductStock stock = (ProductStock)productStocks.elementAt(n);
	 			//First find the product subcategory
	 			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getName().toUpperCase())+"|"+stock.getUid();
	 			stocks.put(uid, stock);
	 		}
	 		
	 		Hashtable printedSubTitels = new Hashtable();
	 		Iterator iStocks = stocks.keySet().iterator();
	 		boolean bInitialized = false;
	 		double sectionTotal=0,generalTotal=0;
	 		String lasttitle="";
	 		while(iStocks.hasNext()){
	 			String key = (String)iStocks.next();
	 			ProductStock stock = (ProductStock)stocks.get(key);
	 			java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
	 			java.util.Date end = ScreenHelper.parseDate(sDateEnd);
	 			int initiallevel=stock.getLevel(begin);
	 			int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day));
	 			int out = stock.getTotalUnitsOutForPeriod(begin, new java.util.Date(end.getTime()+day));
	 			if(initiallevel!=0 || in!=0 || out!=0){
		 			//Nu printen we de gegevens van de productstock
		 	        row =t.addElement("row");
		 			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
		 			addCol(row,70,stock.getProduct()==null?"":stock.getProduct().getName());
		 			addCol(row,20,stock.getProduct()==null?"":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),sPrintLanguage),7);
		 			addCol(row,20,initiallevel+"");
		 			addCol(row,20,in+"");
		 			addCol(row,20,out+"");
		 			addCol(row,20,(initiallevel+in-out)+"");
		 			double pump=0;
		 			if(stock.getProduct()!=null){
		 				pump=stock.getProduct().getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
		 			}
		 			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
		 			addPriceCol(row,20,(initiallevel+in-out)*pump);
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			addCol(row,20,"");
		 			sectionTotal+=(initiallevel+in-out)*pump;
		 			generalTotal+=(initiallevel+in-out)*pump;
	 			}
	 		}
 			addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
 			addPriceBoldCol(row,20,generalTotal);
 			addCol(row,20,"");
 			addCol(row,20,"");
 			addCol(row,20,"");
 			addCol(row,20,"");
	 	}
	 		
     }
    
    protected void printServiceStockOperations(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "280");

 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,100,"");
 		addCol(row,40,ScreenHelper.getTranNoLink("web","initial.situation",sPrintLanguage));
 		addCol(row,40,ScreenHelper.getTranNoLink("web","entries",sPrintLanguage));
 		addCol(row,40,ScreenHelper.getTranNoLink("web","exits",sPrintLanguage));
 		addCol(row,60,ScreenHelper.getTranNoLink("web","stock",sPrintLanguage));
 		
		row =t.addElement("row");
		row.addAttribute("type", "title");
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pump",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));
 		
 		//Now we have to find all productstocks sorted by productsubgroup
 		SortedMap stocks = new TreeMap();
 		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
 		for(int n=0;n<productStocks.size();n++){
 			ProductStock stock = (ProductStock)productStocks.elementAt(n);
 			//First find the product subcategory
 			Product product=stock.getProduct();
 			String uid=stock.getProduct()==null?"|"+stock.getUid():HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+(product!=null?product.getName():"")+" |"+stock.getUid();
 			stocks.put(uid, stock);
 		}
 		
 		Hashtable printedSubTitels = new Hashtable();
 		Iterator iStocks = stocks.keySet().iterator();
 		double sectionTotal=0,generalTotal=0;
 		String lasttitle="";
 		while(iStocks.hasNext()){
 			String key = (String)iStocks.next();
 			ProductStock stock = (ProductStock)stocks.get(key);
 			//Nu kijken we welke tussentitels er moeten geprint worden
 			String[] subtitles = key.split("\\|")[0].split(";");
 			String title="";
 			for(int n=0;n<subtitles.length;n++){
 				title+=subtitles[n]+";";
 				if(printedSubTitels.get(title)==null){
 					//First look if we don't have to print a section total
 					//This one must be printed
 			        row =t.addElement("row");
 			        if(n>0){
 			        	addCol(row,n*5,"");
 			        }
 					addBoldCol(row,280-n*5,subtitles[n]);
 					printedSubTitels.put(title, "1");
 				}
 				lasttitle=subtitles[n];
 			}
 			java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
 			java.util.Date end = ScreenHelper.parseDate(sDateEnd);
 			//Nu printen we de gegevens van de productstock
 	        row =t.addElement("row");
 			addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
 			addCol(row,80,stock.getProduct()==null?"":stock.getProduct().getName());
 			int initiallevel=stock.getLevel(begin);
 			addCol(row,20,initiallevel+"");
 			double pump=0;
 			if(stock.getProduct()!=null){
 				pump=stock.getProduct().getLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
 			}
 			addPriceCol(row,20,initiallevel*pump);
 			int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day));
 			addCol(row,20,in+"");
 			addPriceCol(row,20,in*pump);
 			int out = stock.getTotalUnitsOutForPeriod(begin, new java.util.Date(end.getTime()+day));
 			addCol(row,20,out+"");
 			addPriceCol(row,20,out*pump);
 			addCol(row,20,(initiallevel+in-out)+"");
 			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
 			addPriceCol(row,20,(initiallevel+in-out)*pump);
 		}
     }
    protected void printPatientDeliveries(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String patientUid) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "110");
 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,10,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,70,ScreenHelper.getTranNoLink("web","productstock",sPrintLanguage));
 		addCol(row,10,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","packageunits",sPrintLanguage));

        try{
			java.util.Date dDate = ScreenHelper.parseDate(sDateBegin);
			String sQuery = " select oc_stock_productuid,sum(quantity) quantity from ("+
							" select oc_operation_objectid,c.oc_stock_name,oc_stock_productuid,oc_operation_unitschanged quantity from oc_productstockoperations a,oc_productstocks b,oc_servicestocks c"+
			                " where oc_operation_srcdesttype='patient'"+
			                "  and oc_operation_date>?"+
			                "  and oc_operation_description like '%delivery%'"+
			                "  and oc_operation_srcdestuid=?"+
			                "  and b.oc_stock_objectid=replace(a.oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
			                "  and c.oc_stock_objectid=replace(b.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
			                " union"+
			                " select oc_operation_objectid,c.oc_stock_name,oc_stock_productuid,-oc_operation_unitschanged quantity from oc_productstockoperations a,oc_productstocks b,oc_servicestocks c"+
			                " where oc_operation_srcdesttype='patient'"+
			                "  and oc_operation_date>?"+
			                "  and oc_operation_description like '%receipt%'"+
			                "  and oc_operation_srcdestuid=?"+
			                "  and b.oc_stock_objectid=replace(a.oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
			                "  and c.oc_stock_objectid=replace(b.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')) q"+
			                " group by oc_stock_productuid";
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement(sQuery);
			ps.setDate(1,new java.sql.Date(dDate.getTime()));
			ps.setString(2,patientUid);
			ps.setDate(3,new java.sql.Date(dDate.getTime()));
			ps.setString(4,patientUid);
			
			ResultSet rs = ps.executeQuery();
			
			Product product;
			
			while(rs.next()){
				product = Product.get(rs.getString("oc_stock_productuid"));
				if(product!=null){
		 	        row =t.addElement("row");
			 		addCol(row,10,product.getCode());
			 		addCol(row,70,product.getName());
			 		addCol(row,10,rs.getInt("quantity")+"");
			 		addCol(row,20,product.getPackageUnits()+" "+ScreenHelper.getTran(null,"product.unit",product.getUnit(),sPrintLanguage));
				}
			}

			rs.close();
			ps.close();
			conn.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
     }
    
    protected void printPatientDeliveries(org.dom4j.Document d, org.dom4j.Element t, String sOperationUid) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "110");
 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,10,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,70,ScreenHelper.getTranNoLink("web","productstock",sPrintLanguage));
 		addCol(row,10,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","packageunits",sPrintLanguage));

        try{
			String sQuery = " select oc_stock_productuid,sum(quantity) quantity from ("+
							" select oc_operation_objectid,c.oc_stock_name,oc_stock_productuid,oc_operation_unitschanged quantity from oc_productstockoperations a,oc_productstocks b,oc_servicestocks c"+
			                " where oc_operation_objectid=?"+
			                "  and b.oc_stock_objectid=replace(a.oc_operation_productstockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')"+
			                "  and c.oc_stock_objectid=replace(b.oc_stock_servicestockuid,'"+MedwanQuery.getInstance().getConfigInt("serverId")+".','')) tt group by oc_stock_productuid";
			Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			PreparedStatement ps = conn.prepareStatement(sQuery);
			ps.setInt(1,Integer.parseInt(sOperationUid.split("\\.")[1]));
			ResultSet rs = ps.executeQuery();
			
			Product product;
			
			while(rs.next()){
				product = Product.get(rs.getString("oc_stock_productuid"));
				if(product!=null){
		 	        row =t.addElement("row");
			 		addCol(row,10,product.getCode());
			 		addCol(row,70,product.getName());
			 		addCol(row,10,rs.getInt("quantity")+"");
			 		addCol(row,20,product.getPackageUnits()+" "+ScreenHelper.getTran(null,"product.unit",product.getUnit(),sPrintLanguage));
				}
			}

			rs.close();
			ps.close();
			conn.close();
        }
        catch(Exception e){
        	e.printStackTrace();
        }
     }
    
    protected void printServiceOutgoingStockOperations(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "215");

 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,30,ScreenHelper.getTranNoLink("web","document",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","year",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pu",sPrintLanguage));
 		addCol(row,25,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage));

 		//First we make a list of all productstockoperations ordered by date
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);
		double subtotal=0, generaltotal=0;
 		Vector deliveries = ProductStockOperation.getServiceStockDeliveries(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DATE,OC_OPERATION_SRCDESTUID,OC_OPERATION_DOCUMENTUID", "ASC");
 		String activedate="",activedestination="$$$";
 		for(int n=0;n<deliveries.size();n++){
 			ProductStockOperation operation = (ProductStockOperation)deliveries.elementAt(n);
 			if(operation.getProductStock()!=null){
 				Product product=operation.getProductStock().getProduct();
 				if(product!=null){
		 			String date=new SimpleDateFormat("dd/MM/yyyy").format(operation.getDate());
		 			String destination=operation.getDescription()+"."+(operation.getSourceDestination()==null?"":ScreenHelper.checkString(operation.getSourceDestination().getObjectType()))+"."+(operation.getSourceDestination()==null?"":ScreenHelper.checkString(operation.getSourceDestination().getObjectUid()))+"."+operation.getDocumentUID();
		
		 			if(activedate.length()>0 && (!date.equalsIgnoreCase(activedate) || !destination.equalsIgnoreCase(activedestination))){
		 				row =t.addElement("row");
		 		 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
		 		 		addPriceBoldCol(row,25,subtotal);
		 		 		subtotal=0;
		 		 		activedestination="$$$";
		 			}
		 			if(!date.equalsIgnoreCase(activedate)){
		 				row =t.addElement("row");
		 		 		addBoldCol(row,215,date);
		 		 		activedate=date;
		 			}
		 			if(!destination.equalsIgnoreCase(activedestination)){
		 				row =t.addElement("row");
		 		 		addCol(row,10,"");
		 	 			String document="";
		 	 			if(operation.getDocument()!=null && operation.getDocument().hasValidUid()){
		 	 				document=operation.getUid()+(operation.getDocument().getReference().length()==0?"":" ("+operation.getDocument().getReference()+")");
		 	 			}
		 	 			else if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
		 	 				document=operation.getSourceDestination().getObjectUid();
		 	 			}
		 		 		addBoldCol(row,80,getTran("web","document")+": "+document);
		 		 		addBoldCol(row,125,ScreenHelper.getTranNoLink("productstockoperation.medicationdelivery",operation.getDescription(),sPrintLanguage)+": "+operation.getSourceDestinationName(sPrintLanguage));
		 		 		activedestination=destination;
		 			}
		 	        row =t.addElement("row");
			 		addCol(row,10,"");
		 			addCol(row,20,ScreenHelper.checkString(product.getCode()));
		 			addCol(row,100,ScreenHelper.checkString(product.getName())+(operation.getBatchNumber()!=null&&operation.getBatchNumber().length()>0?" ("+operation.getBatchNumber().toUpperCase()+")":""));
		 			addCol(row,20,operation.getDate()==null?"":new SimpleDateFormat("yyyy").format(operation.getDate()));
		 			addCol(row,20,operation.getUnitsChanged()+"");
		 			double price=product.getLastYearsAveragePrice(ScreenHelper.endOfDay(operation.getDate()));
		 			addPriceCol(row,20,price,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
		 			addPriceCol(row,25,operation.getUnitsChanged()*price);
		 			subtotal+=operation.getUnitsChanged()*price;
		 			generaltotal+=operation.getUnitsChanged()*price;
 				}
 			}
 		}
		if(activedate.length()>0){
			row =t.addElement("row");
	 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
	 		addPriceBoldCol(row,25,subtotal);
		}

 		row =t.addElement("row");
 		addCol(row,215,"");
 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "total", sPrintLanguage));
 		addPriceBoldCol(row,25,generaltotal);
 		
     }
    
    protected void printServiceOutgoingStockOperationsPerService(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "215");

 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,30,ScreenHelper.getTranNoLink("web","service",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","year",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pu",sPrintLanguage));
 		addCol(row,25,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage));

 		//First we make a list of all productstockoperations ordered by date
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);
		double subtotal=0, generaltotal=0;
		Hashtable products = new Hashtable();
 		Vector deliveries = ProductStockOperation.getServiceStockDeliveries(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DATE,OC_OPERATION_SRCDESTUID,OC_OPERATION_DOCUMENTUID", "ASC");
 		SortedMap mDeliveries = new TreeMap();
 		for(int n=0;n<deliveries.size();n++){
 			ProductStockOperation operation = (ProductStockOperation)deliveries.elementAt(n);
 			if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
 	 			String date=new SimpleDateFormat("yyyyMMdd").format(operation.getDate());
 	 			String productstockuid=operation.getProductStockUid();
 	 			Product product = (Product)products.get(productstockuid);
 	 			if(product==null){
 	 		 		ProductStock productStock = ProductStock.get(productstockuid);
 	 		 		if(productStock!=null){
 	 		 			product=productStock.getProduct();
 	 		 			if(product!=null){
 	 		 				products.put(productstockuid, product);
 	 		 			}
 	 		 		}
 	 			}
 	 			String patientuid=operation.getSourceDestination().getObjectUid();
 	 			//Now determine the service on the moment the operation took place
 	 			Encounter encounter = Encounter.getActiveEncounterOnDate(new java.sql.Timestamp(operation.getDate().getTime()), patientuid);
 	 			String service = "?";
 	 			if(encounter!=null && encounter.getServiceUID(operation.getDate())!=null){
 	 				service = encounter.getServiceUID(operation.getDate());
 	 			}
 	 			String uid = date+";"+service+";"+(product==null?"?":product.getName().toUpperCase())+";"+productstockuid;
 	 			if(mDeliveries.get(uid)==null){
 	 				mDeliveries.put(uid, 0);
 	 			}
 	 			if(operation.getDescription().contains("delivery")){
 	 				mDeliveries.put(uid, (Integer)mDeliveries.get(uid)+operation.getUnitsChanged());
 	 			}
 	 			else {
 	 				mDeliveries.put(uid, (Integer)mDeliveries.get(uid)-operation.getUnitsChanged());
 	 			}
 			}
 		}
 		String activedate="",activedestination="$$$";
 		Iterator iDeliveries = mDeliveries.keySet().iterator();
 		while(iDeliveries.hasNext()){
 			String key = (String)iDeliveries.next();
 			String date=ScreenHelper.formatDate(new SimpleDateFormat("yyyyMMdd").parse(key.split(";")[0]));
 			String destination=ScreenHelper.getTranNoLink("service", key.split(";")[1], sPrintLanguage);

 			if(activedate.length()>0 && (!date.equalsIgnoreCase(activedate) || !destination.equalsIgnoreCase(activedestination))){
 				row =t.addElement("row");
 		 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
 		 		addPriceBoldCol(row,25,subtotal);
 		 		subtotal=0;
 		 		activedestination="$$$";
 			}
 			if(!date.equalsIgnoreCase(activedate)){
 				row =t.addElement("row");
 		 		addBoldCol(row,215,date);
 		 		activedate=date;
 			}
 			if(!destination.equalsIgnoreCase(activedestination)){
 				row =t.addElement("row");
 		 		addCol(row,10,"");
 		 		addBoldCol(row,80,getTran("web","service")+": ");
 		 		addBoldCol(row,125,destination);
 		 		activedestination=destination;
 			}
 	        row =t.addElement("row");
 	        Product product = (Product)products.get(key.split(";")[3]);
	 		addCol(row,10,"");
 			addCol(row,20,product!=null?ScreenHelper.checkString(product.getCode()):"");
 			addCol(row,100,product!=null?ScreenHelper.checkString(product.getName()):"");
 			addCol(row,20,new SimpleDateFormat("yyyy").format(ScreenHelper.getSQLDate(date)));
 			addCol(row,20,mDeliveries.get(key)+"");
 			double price=product==null?0:product.getLastYearsAveragePrice(ScreenHelper.getSQLDate(date)==null?new java.util.Date():ScreenHelper.endOfDay(date));
 			addPriceCol(row,20,price,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
 			addPriceCol(row,25,((Integer)mDeliveries.get(key))*price);
 			subtotal+=((Integer)mDeliveries.get(key))*price;
 			generaltotal+=((Integer)mDeliveries.get(key))*price;
 		}
		if(activedate.length()>0){
			row =t.addElement("row");
	 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
	 		addPriceBoldCol(row,25,subtotal);
		}

 		row =t.addElement("row");
 		addCol(row,215,"");
 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "total", sPrintLanguage));
 		addPriceBoldCol(row,25,generaltotal);
     }
    
    protected void printServiceIncomingStockOperations(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID, String userid) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "200");
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,30,ScreenHelper.getTranNoLink("web","category",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
		addCol(row,70,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage),8);
		
		//Now we have to find all productstocks sorted by productsubgroup
		SortedMap stocks = new TreeMap();
		//Todo: get productstocks per batch
		Vector productStocks = ServiceStock.getProductStocks(sServiceStockUID);
		for(int n=0;n<productStocks.size();n++){
			ProductStock stock = (ProductStock)productStocks.elementAt(n);
			//First we look up if there have been incoming transactions
			//Todo: check productstocks for specific batches
			//Todo: store incoming in uid
			if(stock.getProduct()!=null && stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day),ScreenHelper.checkString(userid))>0){
				//First find the product subcategory
				String uid=HTMLEntities.unhtmlentities(stock.getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+ScreenHelper.capitalize(stock.getProduct().getName())+"|"+stock.getUid();
				stocks.put(uid, stock);
			}
		}
		
		Hashtable printedSubTitels = new Hashtable();
		Iterator iStocks = stocks.keySet().iterator();
		boolean bInitialized = false;
		double generalTotal=0;
		while(iStocks.hasNext()){
			String key = (String)iStocks.next();
			ProductStock stock = (ProductStock)stocks.get(key);
			//Nu kijken we welke tussentitels er moeten geprint worden
			String[] subtitles = key.split("\\|")[0].split(";");
			String title="";
			for(int n=0;n<subtitles.length;n++){
				title+=subtitles[n]+";";
				if(printedSubTitels.get(title)==null){
					//This one must be printed
			        row =t.addElement("row");
			        if(n>0){
			        	addCol(row,n*5,"");
			        }
					addBoldCol(row,200-n*5,subtitles[n]);
					printedSubTitels.put(title, "1");
				}
			}
			bInitialized=true;
			//Nu printen we de gegevens van de productstock
			//We printen een lijn voor elke batch waarop operaties plaatsvonden
			SortedSet hBatches = stock.getBatchesInForPeriod(begin, new java.util.Date(end.getTime()+day),ScreenHelper.checkString(userid));
			Iterator iBatches = hBatches.iterator();
			while(iBatches.hasNext()){
				String sBatchNumber = (String)iBatches.next();
				row =t.addElement("row");
		        addCol(row,10,"");
		        //Todo: add batch number
				addCol(row,20,stock.getProduct()==null?"":stock.getProduct().getCode());
				addCol(row,90,stock.getProduct()==null?ScreenHelper.getTranNoLink("web","unknown_product",sPrintLanguage):ScreenHelper.capitalize(stock.getProduct().getName())+(sBatchNumber.equalsIgnoreCase("?")?"":" ("+ScreenHelper.getTran(null,"web", "batch", sPrintLanguage)+": "+sBatchNumber.toUpperCase()+")"));
				//Todo: get incoming from uid and batchuid
				int in = stock.getTotalUnitsInForPeriod(begin, new java.util.Date(end.getTime()+day),ScreenHelper.checkString(userid),sBatchNumber);
				addCol(row,20,in+"");
				addCol(row,20,stock.getProduct()==null?"":ScreenHelper.getTranNoLink("product.unit",stock.getProduct().getUnit(),sPrintLanguage),7);
				double pump=0;
				if(stock.getProduct()!=null){
					try {
						if(MedwanQuery.getInstance().getConfigInt("enableLastPurchasePriceForIncomingPharmacyReports",0)==0){
							pump=stock.getProduct().getLooseLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
						}
						else{
							pump=stock.getProduct().getLastPurchasePrice(end);
						}
					}
					catch(Exception e){};
				}
				addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
				addPriceCol(row,20,in*pump);
				generalTotal+=in*pump;
			}
		}
		if(bInitialized){
	        row =t.addElement("row");
			addRightBoldCol(row,180,ScreenHelper.getTranNoLink("web","general.total",sPrintLanguage));
			addPriceBoldCol(row,20,generalTotal);
		}

     }
    
    protected void printServiceIncomingStockOperationsPerOrder(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "210");
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
		addCol(row,90,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","expiry",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage),8);

		String activedocument = "$$$";
		double sectiontotal = 0;
		//Now we have to find all the orders for this period
		Vector receipts = ProductStockOperation.getReceiptsForServiceStock(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DOCUMENTUID", "ASC");
		for(int n=0;n<receipts.size();n++){
			ProductStockOperation operation = (ProductStockOperation)receipts.elementAt(n);
			if(!ScreenHelper.checkString(operation.getDocumentUID()).equals(activedocument)){
				//First check if we have to print the sectiontotal
				if(!activedocument.equalsIgnoreCase("$$$")){
					row =t.addElement("row");
					addRightBoldCol(row, 190, getTran("web","total"));
					addPriceBoldCol(row, 20, sectiontotal);
					sectiontotal=0;
				}
				//We have to print the order title
				if(ScreenHelper.checkString(operation.getDocumentUID()).length()==0){
					row =t.addElement("row");
					addBoldCol(row,45,getTran("web","date")+": ?");
					addBoldCol(row,45,getTran("web","ordernr")+": ?");
					addBoldCol(row,120,getTran("web","supplier")+": ?");
				}
				else {
					OperationDocument document = OperationDocument.get(operation.getDocumentUID());
					if(document==null){
						row =t.addElement("row");
						addBoldCol(row,45,getTran("web","date")+": ?");
						addBoldCol(row,45,getTran("web","ordernr")+": ?");
						addBoldCol(row,120,getTran("web","supplier")+": ?");
					}
					else {
						row =t.addElement("row");
						addBoldCol(row,45,getTran("web","date")+": "+new SimpleDateFormat("dd/MM/yyyy").format(document.getDate()));
						addBoldCol(row,45,getTran("web","ordernr")+": "+document.getReference());
						addBoldCol(row,120,getTran("web","supplier")+": "+document.getSourceName(sPrintLanguage));
					}
				}
				activedocument=ScreenHelper.checkString(operation.getDocumentUID());
			}
			//Now we print the operation data
			row =t.addElement("row");
			addCol(row,20,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":operation.getProductStock().getProduct().getCode());
			addCol(row,90,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":operation.getProductStock().getProduct().getName());
			addCol(row,20,operation.getBatchEnd()==null?"":new SimpleDateFormat("dd/MM/yyyy").format(operation.getBatchEnd()));
			int in=operation.getUnitsChanged();
			addCol(row,20,in+"");
			addCol(row,20,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":ScreenHelper.getTranNoLink("product.unit",operation.getProductStock().getProduct().getUnit(),sPrintLanguage),7);
			double pump=0;
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				try {
					if(MedwanQuery.getInstance().getConfigInt("enableLastPurchasePriceForIncomingPharmacyReports",0)==0){
						pump=operation.getProductStock().getProduct().getLooseLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
					}
					else{
						pump=operation.getProductStock().getProduct().getLastPurchasePrice(new java.util.Date(operation.getUpdateDateTime().getTime()+day));
					}
				}
				catch(Exception e){};
			}
			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
			addPriceCol(row,20,in*pump);
			sectiontotal+=in*pump;
		}
		if(!activedocument.equalsIgnoreCase("$$$")){
			row =t.addElement("row");
			addRightBoldCol(row, 190, getTran("web","total"));
			addPriceBoldCol(row, 20, sectiontotal);
		}
     }
    
    protected void printServiceIncomingStockOperationsPerItem(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "140");
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,16,ScreenHelper.getTranNoLink("web","date",sPrintLanguage),8);
		addCol(row,25,ScreenHelper.getTranNoLink("web","docnr",sPrintLanguage),8);
		addCol(row,21,ScreenHelper.getTranNoLink("web","batch",sPrintLanguage),8);
		addCol(row,10,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage),8);
		addCol(row,18,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage),8);
		addCol(row,30,ScreenHelper.getTranNoLink("web","provider",sPrintLanguage),8);

		String activeproduct = "$$$";
		double sectiontotal = 0;
		//Now we have to find all the orders for this period
		SortedMap operations = new TreeMap();
		Vector receipts = ProductStockOperation.getReceiptsForServiceStock(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DOCUMENTUID ASC,OC_OPERATION_DATE", "ASC");
		for(int n=0;n<receipts.size();n++){
			ProductStockOperation operation = (ProductStockOperation)receipts.elementAt(n);
			String prodname="";
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				operations.put(operation.getProductStock().getProduct().getName()+";"+operation.getDate().getTime()+";"+operation.getUid(), operation);
			}
		}
		Iterator iOperations = operations.keySet().iterator();
		while(iOperations.hasNext()){
			String key=(String)iOperations.next();
			ProductStockOperation operation = (ProductStockOperation)operations.get(key);
			String prodname="?";
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				prodname=operation.getProductStock().getProduct().getCode()+" "+operation.getProductStock().getProduct().getName();
			}
			if(!prodname.equals(activeproduct)){
				//First check if we have to print the sectiontotal
				if(!activeproduct.equalsIgnoreCase("$$$")){
					row =t.addElement("row");
					addRightBoldCol(row, 92, getTran("web","total"));
					addPriceBoldCol(row, 48, sectiontotal);
					sectiontotal=0;
				}
				//We have to print the productname
				row =t.addElement("row");
				row.addAttribute("type", "title");
				addCenterBoldCol(row, 140, prodname);
				activeproduct=prodname;
			}
			//Now we print the operation data
			row =t.addElement("row");
			addCol(row,16,operation.getDate()==null?"":new SimpleDateFormat("dd/MM/yyyy").format(operation.getDate()));
			addCol(row,25,operation.getDocument()==null?"":operation.getDocument().getReference());
			addCol(row,21,operation.getBatchNumber()==null?"":operation.getBatchNumber().toUpperCase(),8);
			int in=operation.getUnitsChanged();
			addCol(row,10,in+"");
			double pump=0;
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				if(MedwanQuery.getInstance().getConfigInt("enableLastPurchasePriceForIncomingPharmacyReports",0)==0){
					pump=operation.getProductStock().getProduct().getLooseLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
				}
				else{
					pump=operation.getLastPurchasePrice();
				}
			}
			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
			addPriceCol(row,18,in*pump);
			addCol(row,30,operation.getDocument()==null?"":operation.getDocument().getSourceName(sPrintLanguage));
			sectiontotal+=in*pump;
		}
		if(!activeproduct.equalsIgnoreCase("$$$")){
			row =t.addElement("row");
			addRightBoldCol(row, 92, getTran("web","total"));
			addPriceBoldCol(row, 48, sectiontotal);
		}
     }

    protected void printServiceIncomingStockOperationsPerCategoryItem(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID){
 		try{
	    	d.add(t);
	        t.addAttribute("size", "180");
			java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
			java.util.Date end = ScreenHelper.parseDate(sDateEnd);
	
			//Add title rows
	        org.dom4j.Element row =t.addElement("row");
			row.addAttribute("type", "title");
			addCol(row,20,ScreenHelper.getTranNoLink("web","month.and.batch",sPrintLanguage),8);
			addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
			addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
			addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
			addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage),8);
			addCol(row,20,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage),8);
	
			String activecategory = "$$$";
			String activeproduct = "$$$";
			String activemonth ="$$$";
			//Now we have to find all the orders for this period
			SortedMap operations = new TreeMap();
			Hashtable quantities = new Hashtable();
			Vector receipts = ProductStockOperation.getReceiptsForServiceStock(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DOCUMENTUID", "ASC");
			for(int n=0;n<receipts.size();n++){
				ProductStockOperation operation = (ProductStockOperation)receipts.elementAt(n);
				String prodname="";
				if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
					String key=new SimpleDateFormat("MM/yyyy").format(operation.getDate())+"|"+HTMLEntities.unhtmlentities(operation.getProductStock().getProduct().getFullProductSubGroupName(sPrintLanguage))+"|"+ScreenHelper.capitalize(operation.getProductStock().getProduct().getName())+"|"+ScreenHelper.checkString(operation.getBatchNumber()).toUpperCase()+" ";
					if(quantities.get(key)==null){
						quantities.put(key, 0);
						operations.put(key, operation.getProductStock().getProduct());
					}
					quantities.put(key, (Integer)quantities.get(key)+operation.getUnitsChanged());
				}
			}
			Iterator iOperations = operations.keySet().iterator();
			Hashtable printedSubTitels = new Hashtable();
			while(iOperations.hasNext()){
				String key=(String)iOperations.next();
				Product product = (Product)operations.get(key);
				String month=key.split("\\|")[0];
				if(!month.equals(activemonth)){
					//We have to print the month
					row =t.addElement("row");
					addBoldCol(row, 180, month);
					activemonth=month;
					printedSubTitels = new Hashtable();
					activecategory="$$$";
				}
				String category=key.split("\\|")[1];
				if(!category.equals(activecategory)){
					//We have to print the category
					String[] subtitles = category.split(";");
					String title="";
					for(int n=0;n<subtitles.length;n++){
						title+=subtitles[n]+";";
						if(printedSubTitels.get(title)==null){
							//This one must be printed
					        row =t.addElement("row");
					        if(n>0){
					        	addCol(row,n*5,"");
					        }
							addBoldCol(row,180-n*5,subtitles[n]);
							printedSubTitels.put(title, "1");
						}
					}
					activecategory=category;
					activeproduct="$$$";
				}
				String productname=key.split("\\|")[2];
				//Now we print the operation data
				row =t.addElement("row");
				addCol(row,20,key.split("\\|")[3]);
				addCol(row,20,product.getCode());
				addCol(row,80,productname);
				int in=(Integer)quantities.get(key);
				addCol(row,20,in+"");
				double pump=0;
				try {
					if(MedwanQuery.getInstance().getConfigInt("enableLastPurchasePriceForIncomingPharmacyReports",0)==0){
						pump=product.getLooseLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
					}
					else{
						pump=product.getLastPurchasePrice(end);
					}
				}
				catch(Exception e){};
				addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
				addPriceCol(row,20,in*pump);
			}
 		}
 		catch(Exception e2){
 			e2.printStackTrace();
 		}
     }

    protected void printServiceIncomingStockOperationsPerProvider(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID,String provider) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "220");
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);

		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage),8);
		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","expiry",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","quantity",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","missed",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","unit",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","PU",sPrintLanguage),8);
		addCol(row,20,ScreenHelper.getTranNoLink("web","totalprice",sPrintLanguage),8);

		String activeprovider = "$$$";
		String activedocument = "$$$";
		double sectiontotal = 0;
		//Now we have to find all the orders for this period
		SortedMap operations = new TreeMap();
		Vector receipts = ProductStockOperation.getReceiptsForServiceStock(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DOCUMENTUID", "ASC");
		for(int n=0;n<receipts.size();n++){
			ProductStockOperation operation = (ProductStockOperation)receipts.elementAt(n);
			if(operation.getUnitsChanged()!=0){
				String provname="?";
				if(operation.getDocument()!=null && ScreenHelper.checkString(operation.getDocument().getSourceName(sPrintLanguage)).length()>0){
					provname=ScreenHelper.checkString(operation.getDocument().getSourceName(sPrintLanguage));
				}
				else{
					provname=operation.getSourceDestinationName(sPrintLanguage);
				}
				if(provname.toLowerCase().startsWith(provider.toLowerCase())){
					String docid="?";
					if(operation.getDocument()!=null){
						docid=operation.getDocument().getUid();
					}
					operations.put(provname+";"+docid+";"+(operation.getDate()==null?"?":new SimpleDateFormat("yyyyMMdd").format(operation.getDate()))+";"+operation.getUid(), operation);
				}
			}
		}
		Iterator iOperations = operations.keySet().iterator();
		String operationdate="";
		while(iOperations.hasNext()){
			String key=(String)iOperations.next();
			ProductStockOperation operation = (ProductStockOperation)operations.get(key);
			String provname=key.split(";")[0];
			boolean bNewProvider=false;
			if(!provname.equals(activeprovider)){
				//First check if we have to print the sectiontotal
				if(!activeprovider.equalsIgnoreCase("$$$")){
					row =t.addElement("row");
					addRightBoldCol(row, 200, getTran("web","total"));
					addPriceBoldCol(row, 20, sectiontotal);
					sectiontotal=0;
					activedocument = "$$$";
					bNewProvider=true;
				}
				//We have to print the provider name
				row =t.addElement("row");
				addBoldCol(row, 220, getTran("web","provider")+": "+provname);
				activeprovider=provname;
			}
			String docid=key.split(";")[1];
			if(!docid.equals(activedocument)){
				//First check if we have to print the sectiontotal
				if(!bNewProvider && !activedocument.equalsIgnoreCase("$$$")){
					row =t.addElement("row");
					addRightBoldCol(row, 200, getTran("web","total"));
					addPriceBoldCol(row, 20, sectiontotal);
					sectiontotal=0;
					activedocument = "$$$";
				}
				//We have to print the document data 
				String docdate="?";
				String docref="?";
				if(!docid.equalsIgnoreCase("?")){
					OperationDocument document = OperationDocument.get(docid);
					if(document!=null){
						docdate=new SimpleDateFormat("dd/MM/yyyy").format(document.getDate());
						docref=document.getReference()+"";
					}
				}
				row =t.addElement("row");
				addBoldCol(row, 40, getTran("web","docdate")+": "+docdate);
				addBoldCol(row, 180, getTran("web","docnr")+": "+docref);
				activedocument=docid;
				operationdate="";
			}
			if(!operationdate.equalsIgnoreCase(ScreenHelper.getSQLDate(operation.getDate()))){
				operationdate=ScreenHelper.getSQLDate(operation.getDate());
				addBoldCol(row, 220, getTran("web","deliverydate")+": "+operationdate);
			}
			//Now we print the operation data
			row =t.addElement("row");
			addCol(row,20,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":operation.getProductStock().getProduct().getCode());
			addCol(row,80,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":operation.getProductStock().getProduct().getName()+(operation.getBatchNumber()==null?"":" ("+operation.getBatchNumber().toUpperCase()+")"));
			addCol(row,20,operation.getBatchEnd()==null?"":new SimpleDateFormat("dd/MM/yyyy").format(operation.getBatchEnd()));
			int in=operation.getUnitsChanged();
			addCol(row,20,in+"");
			//Calculate missed items if an order was linked to this receipt
			if(operation.getOrderUID()!=null && operation.getOrderUID().length()>0){
				ProductOrder order = ProductOrder.get(operation.getOrderUID());
				if(order!=null && order.hasValidUid()){
					addCol(row,20,(order.getPackagesOrdered()-order.getPackagesDelivered())+"");
				}
				else{
					addCol(row,20,"");
				}
			}
			else{
				addCol(row,20,"");
			}
			addCol(row,20,operation.getProductStock()==null || operation.getProductStock().getProduct()==null?"?":ScreenHelper.getTranNoLink("product.unit",operation.getProductStock().getProduct().getUnit(),sPrintLanguage),7);
			double pump=0;
			if(operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null){
				try {
					if(MedwanQuery.getInstance().getConfigInt("enableLastPurchasePriceForIncomingPharmacyReports",0)==0){
						pump=operation.getProductStock().getProduct().getLooseLastYearsAveragePrice(new java.util.Date(end.getTime()+day));
					}
					else{
						pump=operation.getProductStock().getProduct().getLastPurchasePrice(new java.util.Date(operation.getUpdateDateTime().getTime()+day));
					}
				}
				catch(Exception e){};
			}
			addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
			addPriceCol(row,20,in*pump);
			sectiontotal+=in*pump;
		}
		if(!activedocument.equalsIgnoreCase("$$$")){
			row =t.addElement("row");
			addRightBoldCol(row, 200, getTran("web","total"));
			addPriceBoldCol(row, 20, sectiontotal);
		}
		row =t.addElement("row");
		addCol(row, 220, "\n");
		row =t.addElement("row");
		addCol(row, 220, "\n");
		row =t.addElement("row");
		addRightBoldCol(row, 40, getTran("web","name"));
		addRightBoldCol(row, 40, getTran("web","function"));
		addRightBoldCol(row, 40, getTran("web","date"));
		addRightBoldCol(row, 100, getTran("mdnac","signature"));
		for(int n=0;n<4;n++){
			row =t.addElement("row");
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 100, "\n");
		}
     }
    
    protected void printServiceOutgoingStockOperationsListingPerService(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID, String destinationStockUID) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "230");

 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,30,ScreenHelper.getTranNoLink("web","warehouse",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","batch",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","expires",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pu",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));

 		//First we make a list of all productstockoperations ordered by date
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);
		double subtotal=0, generaltotal=0;
 		Vector deliveries = ProductStockOperation.getServiceDestinationStockDeliveries(sServiceStockUID,destinationStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DATE,OC_OPERATION_DOCUMENTUID", "ASC");
 		String activedate="",activedestination="$$$";
 		for(int n=0;n<deliveries.size();n++){
 			ProductStockOperation operation = (ProductStockOperation)deliveries.elementAt(n);
 			String date=new SimpleDateFormat("dd/MM/yyyy").format(operation.getDate());
 			String destination=operation.getDescription()+"."+date+"."+operation.getDocumentUID();

 			if(!destination.equalsIgnoreCase(activedestination)){
 				if(!activedestination.equalsIgnoreCase("$$$")){
 					row =t.addElement("row");
 			 		addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
 			 		addPriceBoldCol(row,20,subtotal);
 				}
 				row =t.addElement("row");
 	 			String document="";
 	 			if(operation.getDocument()!=null){
 	 				document=ScreenHelper.getTranNoLink("operationdocumenttypes",operation.getDocument().getType(),sPrintLanguage)+(ScreenHelper.checkString(operation.getDocument().getReference()).length()==0?"":" ["+operation.getDocument().getReference()+"]");
 	 			}
 		 		addBoldCol(row,230,date +"   -   "+getTran("web","document")+": "+document);
 		 		activedestination=destination;
 		 		subtotal=0;
 			}
 	        row =t.addElement("row");
	 		addCol(row,30,"");
 			addCol(row,20,operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null?ScreenHelper.checkString(operation.getProductStock().getProduct().getCode()):"");
 			addCol(row,80,operation.getProductStock()!=null && operation.getProductStock().getProduct()!=null?ScreenHelper.checkString(operation.getProductStock().getProduct().getName()):"");
 			addCol(row,20,operation.getUnitsChanged()+"");
 			//Batch data
 			addCol(row,20,ScreenHelper.checkString(operation.getBatchNumber()));
 			addCol(row,20,ScreenHelper.formatDate(operation.getBatchEnd()));
 			
 			double price=operation.getProductStock()==null || operation.getProductStock().getProduct()==null?0:operation.getProductStock().getProduct().getLastYearsAveragePrice(operation.getDate()==null?new java.util.Date():ScreenHelper.endOfDay(operation.getDate()));
 			addPriceCol(row,20,price,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
 			addPriceCol(row,20,operation.getUnitsChanged()*price);
 			subtotal+=operation.getUnitsChanged()*price;
 			generaltotal+=operation.getUnitsChanged()*price;
 		}

		if(!activedestination.equalsIgnoreCase("$$$")){
			row =t.addElement("row");
	 		addRightBoldCol(row,190,ScreenHelper.getTranNoLink("web", "subtotal", sPrintLanguage));
	 		addPriceBoldCol(row,20,subtotal);
		}
 		row =t.addElement("row");
 		addCol(row,230,"");
 		addRightBoldCol(row,210,ScreenHelper.getTranNoLink("web", "total", sPrintLanguage));
 		addPriceBoldCol(row,20,generaltotal);
		row =t.addElement("row");
		addCol(row, 230, "\n");
		row =t.addElement("row");
		addCol(row, 230, "\n");
		row =t.addElement("row");
		addRightBoldCol(row, 40, "");
		addRightBoldCol(row, 40, getTran("pharmacy","name"));
		addRightBoldCol(row, 40, getTran("pharmacy","title"));
		addRightBoldCol(row, 40, getTran("web","date"));
		addRightBoldCol(row, 70, getTran("mdnac","signature"));
		for(int n=0;n<4;n++){
			row =t.addElement("row");
			if(n==0){
				addRightBoldCol(row, 40, ScreenHelper.getTranNoLink("web", "requestedby", sPrintLanguage)+"\n\n");
			}
			else if(n==1){
				addRightBoldCol(row, 40, ScreenHelper.getTranNoLink("web", "transferredby", sPrintLanguage)+"\n\n");
			}
			else if(n==2){
				addRightBoldCol(row, 40, ScreenHelper.getTranNoLink("web", "approvedby", sPrintLanguage)+"\n\n");
			}
			else if(n==3){
				addRightBoldCol(row, 40, ScreenHelper.getTranNoLink("web", "receivedby", sPrintLanguage)+"\n\n");
			}
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 40, "\n");
			addRightBoldCol(row, 70, "\n");
		}
 		
     }
    
    protected void printServiceOutgoingStockOperationsListing(org.dom4j.Document d, org.dom4j.Element t, String sDateBegin, String sDateEnd, String sServiceStockUID, String userid) throws ParseException{
 		d.add(t);
        t.addAttribute("size", "200");

 		//Add title rows
        org.dom4j.Element row =t.addElement("row");
 		row.addAttribute("type", "title");
 		addCol(row,20,ScreenHelper.getTranNoLink("web","document",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","date",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","code",sPrintLanguage));
 		addCol(row,80,ScreenHelper.getTranNoLink("web","article",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","pu",sPrintLanguage));
 		addCol(row,20,ScreenHelper.getTranNoLink("web","amount",sPrintLanguage));

        row =t.addElement("row");
 		//First we make a list of all productstockoperations ordered by date
		java.util.Date begin = ScreenHelper.parseDate(sDateBegin);
		java.util.Date end = ScreenHelper.parseDate(sDateEnd);
		double subtotal=0, generaltotal=0;
 		Vector deliveries = ProductStockOperation.getServiceStockDeliveries(sServiceStockUID, begin, new java.util.Date(end.getTime()+day), "OC_OPERATION_DATE,OC_OPERATION_DOCUMENTUID", "ASC");
 		//we groeperen de records per datum/product
 		SortedMap products = new TreeMap();
 		for(int n=0;n<deliveries.size();n++){
 			ProductStockOperation operation = (ProductStockOperation)deliveries.elementAt(n);
 			if(ScreenHelper.checkString(userid).length()==0 || operation.getUpdateUser().equals(userid)){
	 			String date=ScreenHelper.stdDateFormat.format(operation.getDate());
	 			ProductStock stock = operation.getProductStock();
	 			int quantity=operation.getUnitsChanged();
	 			if(products.get(date+";"+stock.getUid())==null){
	 				products.put(date+";"+stock.getUid(),0);
	 			}
				products.put(date+";"+stock.getUid(),(Integer)products.get(date+";"+stock.getUid())+quantity);
 			}
 		}
 		Iterator i = products.keySet().iterator();
 		while(i.hasNext()){
 			String s = (String)i.next();
 			ProductStock stock = ProductStock.get(s.split(";")[1]);
 			String date=s.split(";")[0];
 			String document="";
 			int quantity=(Integer)products.get(s);
 			addCol(row,20,document);
 			addCol(row,20,date);
 			addCol(row,20,stock!=null && stock.getProduct()!=null?ScreenHelper.checkString(stock.getProduct().getCode()):"");
 			addCol(row,80,stock!=null && stock.getProduct()!=null?ScreenHelper.checkString(stock.getProduct().getName()):"");
 			addCol(row,20,""+quantity);
 			double price=stock==null || stock.getProduct()==null?0:stock.getProduct().getLastYearsAveragePrice(date==null?new java.util.Date():ScreenHelper.endOfDay(date));
 			addPriceCol(row,20,price,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
 			addPriceCol(row,20,quantity*price);
 			generaltotal+=quantity*price;
 		}

 		row =t.addElement("row");
 		addCol(row,200,"");
 		addBoldCol(row,180,ScreenHelper.getTranNoLink("web", "total", sPrintLanguage));
 		addPriceBoldCol(row,20,generaltotal);
 		
     }
    
    protected void printProductStockFile(org.dom4j.Document d, org.dom4j.Element t, String sYear, String sProductStockUID) throws ParseException{
		d.add(t);
        t.addAttribute("size", "235");
		
		//Add title rows
        org.dom4j.Element row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,95,"");
		addCol(row,40,ScreenHelper.getTranNoLink("web","entries",sPrintLanguage));
		addCol(row,40,ScreenHelper.getTranNoLink("web","exits",sPrintLanguage));
		addCol(row,40,ScreenHelper.getTranNoLink("web","available",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","pump",sPrintLanguage));
		
		row =t.addElement("row");
		row.addAttribute("type", "title");
		addCol(row,25,ScreenHelper.getTranNoLink("web","date",sPrintLanguage));
		addCol(row,30,ScreenHelper.getTranNoLink("web","reference",sPrintLanguage));
		addCol(row,40,ScreenHelper.getTranNoLink("web","pharmacy.sourcedestination",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","value",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","qte",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","value",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","qd",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","value",sPrintLanguage));
		addCol(row,20,ScreenHelper.getTranNoLink("web","pue",sPrintLanguage));
		
		ProductStock productStock = ProductStock.get(sProductStockUID);
		java.util.Date begin  = ScreenHelper.parseDate("01/01/"+sYear);
		java.util.Date	end = ScreenHelper.parseDate("31/12/"+sYear);
		int stock=0;
		int initialstock=-999;
		if(productStock!=null){
			Vector operations = ProductStockOperation.getAll(productStock.getUid());
			for(int n=0;n<operations.size();n++){
				ProductStockOperation operation = (ProductStockOperation)operations.elementAt(n);
				if(!operation.getDate().before(begin)){
					//if this operation falls after the end date, we can stop
					if(operation.getDate().after(end)){
						break;
					}
					//First let's see if we have to show the initial stock level
					if(initialstock==-999){
						initialstock=stock;
						//Add initial stock row
						row=t.addElement("row");
						addCol(row,25,ScreenHelper.stdDateFormat.format(begin));
						addCol(row,30,"");
						addCol(row,40,ScreenHelper.getTranNoLink("web","initial.stock",sPrintLanguage));
						addCol(row,20,initialstock+"");
						double pump=productStock.getProduct().getLastYearsAveragePrice(new java.util.Date(begin.getTime()+day));
						addPriceCol(row,20,initialstock*pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
						addCol(row,20,"0");
						addCol(row,20,"0");
						addCol(row,20,initialstock+"");
						addPriceCol(row,20,initialstock*pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
						addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
					}
					//We have to show this operation
					// Date
					row=t.addElement("row");
					addCol(row,25,ScreenHelper.stdDateFormat.format(operation.getDate()));
					// Reference document
	 	 			String document="";
	 	 			if(operation.getDocument()!=null && operation.getDocument().hasValidUid()){
	 	 				document=operation.getUid()+(operation.getDocument().getReference().length()==0?"":" ("+operation.getDocument().getReference()+")");
	 	 			}
	 	 			else if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient") || operation.getSourceDestination().getObjectType().equalsIgnoreCase("production")){
	 	 				document=operation.getSourceDestination().getObjectUid();
	 	 			}
		 			addCol(row,30,document);
					// Origin or Destination
					if(operation.getSourceDestination().getObjectType().equalsIgnoreCase("servicestock")){
						ServiceStock serviceStock = ServiceStock.get(operation.getSourceDestination().getObjectUid());
						if(serviceStock!=null){
							addCol(row,40,serviceStock.getName());
						}
						else {
							addCol(row,40,"?");
						}
					}
					else if (operation.getSourceDestination().getObjectType().equalsIgnoreCase("patient")){
						addCol(row,40,AdminPerson.getFullName(operation.getSourceDestination().getObjectUid()));
					}
					else if (operation.getSourceDestination().getObjectType().equalsIgnoreCase("supplier")){
						addCol(row,40,operation.getSourceDestination().getObjectUid());
					}
					else {
						if(operation.getDescription().indexOf("medicationreceipt.")>-1){
							addCol(row,40,ScreenHelper.getTranNoLink("productstockoperation.medicationreceipt",operation.getDescription(),sPrintLanguage));
						}
						else if (operation.getDescription().indexOf("medicationdelivery.")>-1){
							addCol(row,40,ScreenHelper.getTranNoLink("productstockoperation.medicationdelivery",operation.getDescription(),sPrintLanguage));
						}
					}
					// Quantity received and price
					if(operation.getDescription().indexOf("medicationreceipt.")>-1){
						addCol(row,20,operation.getUnitsChanged()+"");
						String pump=Pointer.getPointer("drugprice."+productStock.getProductUid()+"."+operation.getUid());
						if(pump.length()>0){
							addPriceCol(row,20,operation.getUnitsChanged()*Double.parseDouble(pump.split(";")[1]),MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
						}
						else {
							pump=""+productStock.getProduct().getLastYearsAveragePrice(new java.util.Date(operation.getUpdateDateTime().getTime()+day));
							addPriceCol(row,20,operation.getUnitsChanged()*Double.parseDouble(pump),MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
						}
					}
					else {
						addCol(row,20,"0");
						addCol(row,20,"0");
					}
					double pump=productStock.getProduct().getLastYearsAveragePrice(new java.util.Date(operation.getUpdateDateTime().getTime()+day));
					// Quantity delivered and price
					if (operation.getDescription().indexOf("medicationdelivery.")>-1){
						addCol(row,20,operation.getUnitsChanged()+"");
						addPriceCol(row,20,operation.getUnitsChanged()*pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
					}
					else {
						addCol(row,20,"0");
						addCol(row,20,"0");
					}
					// Remaining stock and value
					if(operation.getDescription().indexOf("medicationreceipt.")>-1){
						stock+=operation.getUnitsChanged();
					}
					else if (operation.getDescription().indexOf("medicationdelivery.")>-1){
						stock-=operation.getUnitsChanged();
					}
					addCol(row,20,stock+"");
					addPriceCol(row,20,stock*pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
					//PUMP
					addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
				}
				else {
					//update stock level
					if(operation.getDescription().indexOf("medicationreceipt.")>-1){
						stock+=operation.getUnitsChanged();
					}
					else if (operation.getDescription().indexOf("medicationdelivery.")>-1){
						stock-=operation.getUnitsChanged();
					}
				}
			}
			//First let's see if we have to show the initial stock level (if there were no operations)
			if(initialstock==-999){
				initialstock=stock;
				//Add initial stock row
				row=t.addElement("row");
				addCol(row,25,ScreenHelper.stdDateFormat.format(begin));
				addCol(row,30,"");
				addCol(row,40,ScreenHelper.getTranNoLink("web","initial.stock",sPrintLanguage));
				addCol(row,20,initialstock+"");
				double pump=productStock.getProduct().getLastYearsAveragePrice(new java.util.Date(begin.getTime()+day));
				addPriceCol(row,20,initialstock*pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
				addCol(row,20,"0");
				addCol(row,20,"0");
				addCol(row,20,initialstock+"");
				addPriceCol(row,20,initialstock*pump);
				addPriceCol(row,20,pump,MedwanQuery.getInstance().getConfigString("priceFormatDetailed","#,##0.00"));
			}
		}
    }
    
    protected void printHeaderModel1 (String type, Hashtable parameters, String title){
        table = new PdfPTable(3);
        table.setWidthPercentage(100);
        
        PdfPTable table2 = new PdfPTable(1);
        table2.setWidthPercentage(100);
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title1",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title2",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title3",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title4",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title5",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title6",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(" \n", 1, 1, 10));
        cell = new PdfPCell(table2);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setColspan(1);
        table.addCell(cell);

        cell = emptyCell();
        table.addCell(cell);

        cell = emptyCell();
        table.addCell(cell);

        cell = createTitle(title, 3);
        table.addCell(cell);
        cell = createTitle(ScreenHelper.getTranNoLink("pharmacy.report","period.from",sPrintLanguage)+" "+(String)parameters.get("begin")+" "+ScreenHelper.getTranNoLink("pharmacy.report","till",sPrintLanguage)+" "+(String)parameters.get("end"), 3);
        table.addCell(cell);
        
        table.addCell(emptyCell(3));
        table.addCell(emptyCell(3));
        table.addCell(emptyCell(3));
}
    protected void printHeaderModel2 (String type, Hashtable parameters, String title){
        table = new PdfPTable(3);
        table.setWidthPercentage(100);
        
        PdfPTable table2 = new PdfPTable(1);
        table2.setWidthPercentage(100);
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title1",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title2",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title3",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title4",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title5",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(ScreenHelper.getTranNoLink("pharmacy.report","title6",sPrintLanguage), 1, 1, 10));
        table2.addCell(createBorderlessCell(" \n", 1, 1, 10));
        cell = new PdfPCell(table2);
        cell.setBorder(PdfPCell.NO_BORDER);
        cell.setColspan(1);
        table.addCell(cell);

        cell = emptyCell();
        table.addCell(cell);

        cell = emptyCell();
        table.addCell(cell);

        cell = createTitle(title, 3);
        table.addCell(cell);
        
        table.addCell(emptyCell(3));
        table.addCell(emptyCell(3));
        table.addCell(emptyCell(3));
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
    protected PdfPCell createTitleNoUnderline(String msg, int colspan){
        cell = new PdfPCell(new Paragraph(msg,FontFactory.getFont(FontFactory.HELVETICA,10,Font.BOLD)));
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

    protected PdfPCell createBoldBorderlessCell(String value, int height, int colspan){
        cell = new PdfPCell(new Paragraph(value,FontFactory.getFont(FontFactory.HELVETICA,7,Font.BOLD)));
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

    protected PdfPCell createBoldBorderlessCell(String value, int colspan){
        return createBoldBorderlessCell(value,3,colspan);
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