package ocdhis2;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.jsp.JspWriter;
import javax.xml.bind.JAXBException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.adt.Encounter;
import be.openclinic.medical.Diagnosis;
import be.openclinic.pharmacy.Batch;
import be.openclinic.pharmacy.Product;
import be.openclinic.pharmacy.ProductStock;
import be.openclinic.system.Center;
import net.admin.Service;

public class DHIS2Exporter {
	private Date begin=null;
	private Date end=null;
	private Document dhis2document=null;
	private Hashtable departmentmaps=loadDepartmentMaps();
	private String exportFormat;
	private StringBuffer html;
	String language="en";
	private String uids="";
	private HashSet patientrecords;
	private JspWriter jspWriter=null;
	private boolean bHasContent;
	
	public DHIS2Exporter() {
		super();
		DHIS2Helper.activeDataSet="";
	}
	
	public DHIS2Exporter(String uids) {
		super();
		DHIS2Helper.activeDataSet="";
		this.uids=uids;
	}
	
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getExportFormat() {
		return exportFormat;
	}
	public void setExportFormat(String exportFormat) {
		this.exportFormat = exportFormat;
	}
	public StringBuffer getHtml() {
		return html;
	}
	public void setHtml(StringBuffer html) {
		this.html = html;
	}
	public Date getBegin() {
		return begin;
	}
	public void setBegin(Date begin) {
		this.begin = begin;
	}
	public Date getEnd() {
		return end;
	}
	public void setEnd(Date end) {
		this.end = end;
	}
	public Document getDhis2document() {
		return dhis2document;
	}
	public void setDhis2document(Document dhis2document) {
		this.dhis2document = dhis2document;
	}
	
	public boolean setDhis2document(String documentname) {
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(documentname));
			setDhis2document(document);
		} catch (DocumentException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean inArray(String sValue,String sArray){
		return inArray(sValue,sArray,"\\|");
	}
	
	public boolean inArray(String sValue,String sArray,String separator){
		Debug.print("Searching for "+sValue+" in "+sArray);
		String[] items = sArray.split(separator);
		for(int n=0;n<items.length;n++){
			if(sValue.equals(items[n])){
				Debug.println(" - Found!");
				return true;
			}
		}
		Debug.println(" - Not found...");
		return false;
	}
	
	private Hashtable loadDepartmentMaps(){
		Hashtable h = new Hashtable();
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select serviceid,inscode from services");
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String serviceid = ScreenHelper.checkString(rs.getString("serviceid")).toLowerCase();
				String inscode = ScreenHelper.checkString(rs.getString("inscode")).toLowerCase();
				if(serviceid.length()>0 && inscode.length()>0){
					Debug.println("Adding "+serviceid+" -> "+inscode);
					h.put(serviceid, inscode);
				}
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return h;
	}
	
	public String showRecords(String dataelementuid,String optionuid,String attributeoptionuid){
		bHasContent=false;
		patientrecords = new HashSet();
		StringBuffer result = new StringBuffer("");

		Element root = dhis2document.getRootElement();
		//Step 1: make a list of all dataset types that are needed
		Vector datasetTypes = new Vector();
		Iterator iDatasets = root.elementIterator("dataset");
		while(iDatasets.hasNext()){
			Element dataset = (Element)iDatasets.next();
			if(uids.length()==0||uids.contains(dataset.attributeValue("uid"))){
				if(!datasetTypes.contains(dataset.attributeValue("type").toLowerCase())){
					datasetTypes.add(dataset.attributeValue("type").toLowerCase());
				}
			}
		}
		//Step 2: iterate through all dataset types and export all datasets for each type
		Vector diagnosisItems = new Vector();
		Vector encounterItems = new Vector();
		Vector lastEncounterItems = new Vector();
		Vector technicalActivityItems = new Vector();

		for(int n=0;n<datasetTypes.size();n++){
			String datasetType = (String)datasetTypes.elementAt(n);
			Debug.println("Exporting dataset type "+datasetType);
			if(datasetType.equalsIgnoreCase("diagnosis") && diagnosisItems.size()==0){
				diagnosisItems=loadDiagnoses();
			}
			else if(datasetType.equalsIgnoreCase("encounter") && encounterItems.size()==0){
				encounterItems=loadEncounters();
				lastEncounterItems=loadLastEncounters();
			}
			else if(datasetType.equalsIgnoreCase("technicalactivity") && technicalActivityItems.size()==0){
				technicalActivityItems=loadTechnicalActivities();
			}
		}
		iDatasets = root.elementIterator("dataset");
		while(iDatasets.hasNext()){
			Element dataset = (Element)iDatasets.next();
			if(uids.length()==0||uids.contains(dataset.attributeValue("uid"))){
				if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDatasetRecord(dataset,diagnosisItems,dataelementuid,optionuid,attributeoptionuid);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
					if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
						exportDatasetRecord(dataset,lastEncounterItems,dataelementuid,optionuid,attributeoptionuid);
					}
					else{
						Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
						exportDatasetRecord(dataset,encounterItems,dataelementuid,optionuid,attributeoptionuid);
					}
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDatasetRecord(dataset,technicalActivityItems,dataelementuid,optionuid,attributeoptionuid);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("item")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items = loadItems(dataset);
					exportDatasetRecord(dataset,items,dataelementuid,optionuid,attributeoptionuid);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items=loadLastTransactionItems(dataset);
					exportDatasetRecord(dataset,items,dataelementuid,optionuid,attributeoptionuid);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items = loadLab(dataset);
					exportDatasetRecord(dataset,items,dataelementuid,optionuid,attributeoptionuid);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("pharmacy")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDatasetRecord(dataset,new Vector(),dataelementuid,optionuid,attributeoptionuid);
				}
			}
		}
		Iterator records = patientrecords.iterator();
		while(records.hasNext()){
			String personid=(String)records.next();
			result.append(personid+";");
		}
		return result.toString();
	}
	
	public boolean export(String exportFormat){
		if(exportFormat.equalsIgnoreCase("dhis2serverdelete")){
			System.out.println("full delete of dhis2 server");
			MedwanQuery.getInstance().setConfigString("sendFullDHIS2DataSets", "1");
			exportFormat="dhis2server";
		}
		else{
			MedwanQuery.getInstance().setConfigString("sendFullDHIS2DataSets", "0");
		}
		DHIS2Helper.bSuccess=true;
		DHIS2Helper.sError="";
		DHIS2Helper.bColumnsDrawn=false;
		DHIS2Helper.activeAttribute="";
		DHIS2Helper.activeDataSet="";
		this.exportFormat=exportFormat;
		html=new StringBuffer();
		if(begin==null){
			System.out.println("DHIS2 export error: begin of period is missing");
			return false;
		}
		else if(end==null){
			System.out.println("DHIS2 export error: end of period is missing");
			return false;
		}
		else if(dhis2document==null){
			System.out.println("DHIS2 export error: DHIS2 configuration file is missing");
			return false;
		}
		Element root = dhis2document.getRootElement();
		//Step 1: make a list of all dataset types that are needed
		try {
			if(jspWriter!=null){
				jspWriter.print("Making list of dataset types... ");
				jspWriter.flush();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		
		Vector datasetTypes = new Vector();
		List iDatasets = root.elements("dataset");
		for(int n=0; n<iDatasets.size();n++){
			Element dataset = (Element)iDatasets.get(n);
			if(uids.length()==0||uids.contains(dataset.attributeValue("uid"))){
				if(!datasetTypes.contains(dataset.attributeValue("type").toLowerCase())){
					datasetTypes.add(dataset.attributeValue("type").toLowerCase());
				}
			}
		}
		try {
			if(jspWriter!=null){
				jspWriter.print("done<br/>Prepare exports... ");
				jspWriter.flush();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		//Step 2: iterate through all dataset types and export all datasets for each type
		Vector diagnosisItems = new Vector();
		Vector encounterItems = new Vector();
		Vector lastEncounterItems = new Vector();
		Vector technicalActivityItems = new Vector();
		Hashtable initialquantities = new Hashtable();
		Hashtable averageconsumptions = new Hashtable();
		Hashtable consumptions = new Hashtable();
		//Hashtable quantitieslost = new Hashtable();
		Hashtable productoperations = new Hashtable();
		for(int n=0;n<datasetTypes.size();n++){
			String datasetType = (String)datasetTypes.elementAt(n);
			Debug.println("Exporting dataset type "+datasetType);
			if(datasetType.equalsIgnoreCase("diagnosis")){
				diagnosisItems=loadDiagnoses();
			}
			else if(datasetType.equalsIgnoreCase("encounter")){
				encounterItems=loadEncounters();
				Debug.println("Exporting dataset type lastencounter");
				lastEncounterItems=loadLastEncounters();
			}
			else if(datasetType.equalsIgnoreCase("technicalactivity")){
				technicalActivityItems=loadTechnicalActivities();
			}
			else if(datasetType.equalsIgnoreCase("pharmacy") && initialquantities.size()==0){
				initialquantities = Product.getTotalQuantitiesAvailable(begin);
				averageconsumptions = Product.getLastYearsAverageMonthlyConsumptions(end);
				consumptions = Product.getConsumptions(begin, end);
				//quantitieslost = Product.getQuantitiesLost(begin, end, getServiceUids());
				productoperations = Product.getProductOperations(begin, end);
			}
		}
		try {
			if(jspWriter!=null){
				jspWriter.print("done<br/>");
				jspWriter.flush();
			}
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		iDatasets = root.elements("dataset");
		int nTotalSets=iDatasets.size();
		for(int n=0; n<iDatasets.size();n++){
			Element dataset = (Element)iDatasets.get(n);
			if(jspWriter!=null && (n*100/nTotalSets)>0){
				try {
					jspWriter.print("<script>document.getElementById('progressBar').style.width='"+(n*100/nTotalSets)+"%';</script>");
					jspWriter.flush();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if(uids.length()==0||uids.contains(dataset.attributeValue("uid"))){
				if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDataset(dataset,diagnosisItems);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
						exportDataset(dataset,lastEncounterItems);
					}
					else{
						exportDataset(dataset,encounterItems);
					}
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDataset(dataset,technicalActivityItems);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("item")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items = loadItems(dataset);
					exportDataset(dataset,items);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items = loadLastTransactionItems(dataset);
					exportDataset(dataset,items);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					Vector items = loadLab(dataset);
					exportDataset(dataset,items);
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("pharmacy")){
					Debug.println("Exporting dataset "+dataset.attributeValue("uid"));
					exportDataset(dataset,new Vector(),initialquantities,averageconsumptions,consumptions,productoperations);
				}
			}
		}
		if(jspWriter!=null){
			try {
				jspWriter.print("<script>document.getElementById('progressBar').style.width='100%';</script>");
				jspWriter.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(html.toString().indexOf("table")>-1){
			html.append("</table>");
		}
		if(!bHasContent) {
			html.append("<table width='100%'><tr><td class='admin'>"+ScreenHelper.getTranNoLink("web","nodhis2data",language)+"</td></tr></table><p/>");
		}
		return DHIS2Helper.bSuccess;
	}
	
	public JspWriter getJspWriter() {
		return jspWriter;
	}

	public void setJspWriter(JspWriter jspWriter) {
		this.jspWriter = jspWriter;
	}

	private void exportDataset(Element dataset,Vector items, Hashtable initialquantities,Hashtable averageconsumptions,Hashtable consumptions,Hashtable productoperations){
		Element attributeOptionCombo = dataset.element("attributeOptionCombo");
		String department=null;
		Vector selectedItems = new Vector();
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(ScreenHelper.checkString(dataset.attributeValue("ondate")).equalsIgnoreCase("begin")){
				try{
					java.util.Date begindate = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
					if(begindate.after(begin)){
						continue;
					}
				}
				catch(Exception e){
					continue;
				}
			}
			selectedItems.add(item);
		}
		if(dataset.attributeValue("type").equalsIgnoreCase("pharmacy")){
			exportPharmacyDataset(dataset,"",initialquantities,averageconsumptions,consumptions,productoperations);
		}
	}
		
	private void exportDataset(Element dataset,Vector items){
		Element attributeOptionCombo = dataset.element("attributeOptionCombo");
		String department=null;
		if(attributeOptionCombo!=null){
			Vector selectedItems = new Vector();
			String attributeOptionComboType=attributeOptionCombo.attributeValue("type");
			//Iterator through all attributeOptionCombo values
			Iterator iattributeOptionComboValues = attributeOptionCombo.elementIterator();
			while(iattributeOptionComboValues.hasNext()){
				selectedItems = new Vector();
				Element attributeOptionComboValue=(Element)iattributeOptionComboValues.next();
				//For the time being, only department exists as attributeOptionComboType
				if(attributeOptionComboType.equalsIgnoreCase("department")){
					department=attributeOptionComboValue.attributeValue("value");
					Debug.println("Exporting attributeOptionType "+attributeOptionCombo.attributeValue("type")+" - "+department);
				}
				for(int n=0;n<items.size();n++){
					boolean bAddItem=false;
					String item = (String)items.elementAt(n);
					if(ScreenHelper.checkString(dataset.attributeValue("ondate")).equalsIgnoreCase("begin")){
						try{
							java.util.Date begindate = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
							if(begindate.after(begin)){
								continue;
							}
						}
						catch(Exception e){
							continue;
						}
					}
					if(department==null || department.length()==0){
						bAddItem=true;
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[6])))){
						bAddItem=true;
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("encounter") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
						bAddItem=true;
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
						bAddItem=true;
					}
					else if((dataset.attributeValue("type").equalsIgnoreCase("item")|| dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")) && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
						bAddItem=true;
					}
					if(bAddItem){
						selectedItems.add(item);
					}
				}
				if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
					exportDiagnosisDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
					exportEncounterDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
					exportTechnicalActivityDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("item") || dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem") ){
					exportItemDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
				else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
					exportLabDataset(selectedItems,dataset,attributeOptionComboValue.attributeValue("uid"));
				}
			}
		}
		else{
			Vector selectedItems = new Vector();
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(ScreenHelper.checkString(dataset.attributeValue("ondate")).equalsIgnoreCase("begin")){
					try{
						java.util.Date begindate = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
						if(begindate.after(begin)){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				selectedItems.add(item);
			}
			if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
				exportDiagnosisDataset(selectedItems,dataset,"");
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
				exportEncounterDataset(selectedItems,dataset,"");
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
				exportTechnicalActivityDataset(selectedItems,dataset,"");
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("item")||dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")){
				exportItemDataset(selectedItems,dataset,"");
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
				exportLabDataset(selectedItems,dataset,"");
			}
		}
	}
		
	private void exportDatasetRecord(Element dataset,Vector items,String dataelementuid,String optionuid,String attributeoptionuid){
		Element attributeOptionCombo = dataset.element("attributeOptionCombo");
		String department=null;
		if(attributeOptionCombo!=null){
			Vector selectedItems = new Vector();
			String attributeOptionComboType=attributeOptionCombo.attributeValue("type");
			//Iterator through all attributeOptionCombo values
			Iterator iattributeOptionComboValues = attributeOptionCombo.elementIterator();
			while(iattributeOptionComboValues.hasNext()){
				selectedItems = new Vector();
				Element attributeOptionComboValue=(Element)iattributeOptionComboValues.next();
				if(attributeoptionuid.length()==0||attributeoptionuid.equals(attributeOptionComboValue.attributeValue("uid"))){
					//For the time being, only department exists as attributeOptionComboType
					if(attributeOptionComboType.equalsIgnoreCase("department")){
						department=attributeOptionComboValue.attributeValue("value");
						Debug.println("Exporting attributeOptionType "+attributeOptionCombo.attributeValue("type")+" - "+department);
					}
					for(int n=0;n<items.size();n++){
						boolean bAddItem=false;
						String item = (String)items.elementAt(n);
						if(ScreenHelper.checkString(dataset.attributeValue("ondate")).equalsIgnoreCase("begin")){
							try{
								java.util.Date begindate = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								if(begindate.after(begin)){
									continue;
								}
							}
							catch(Exception e){
								continue;
							}
						}
						if(department==null || department.length()==0){
							bAddItem=true;
						}
						else if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[6])))){
							bAddItem=true;
						}
						else if(dataset.attributeValue("type").equalsIgnoreCase("encounter") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
							bAddItem=true;
						}
						else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
							bAddItem=true;
						}
						else if(dataset.attributeValue("type").equalsIgnoreCase("item") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
							bAddItem=true;
						}
						else if(dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem") && department!=null && department.equalsIgnoreCase(ScreenHelper.checkString((String)departmentmaps.get(item.split(";")[4])))){
							bAddItem=true;
						}
						if(bAddItem){
							selectedItems.add(item);
						}
					}
					if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
						exportDiagnosisDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
						exportEncounterDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
						exportTechnicalActivityDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("item") || dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")){
						exportItemDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
					}
					else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
						exportLabDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
					}
				}
			}
		}
		else{
			Vector selectedItems = new Vector();
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(ScreenHelper.checkString(dataset.attributeValue("ondate")).equalsIgnoreCase("begin")){
					try{
						java.util.Date begindate = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
						if(begindate.after(begin)){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				selectedItems.add(item);
			}
			if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
				exportDiagnosisDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
				exportEncounterDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("technicalactivity")){
				exportTechnicalActivityDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("item") || dataset.attributeValue("type").equalsIgnoreCase("lasttransactionitem")){
				exportItemDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
			}
			else if(dataset.attributeValue("type").equalsIgnoreCase("lab")){
				exportLabDatasetRecords(selectedItems,dataset,dataelementuid,optionuid);
			}
		}
	}
	
	private void  exportDiagnosisDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		String origin=null;
		String outcome=null;
		double minAge=-1;
		double maxAge=-1;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
					origin=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
					outcome=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
				}
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					if(ScreenHelper.checkString(dataset.attributeValue("incoming")).equals("1")){
						try{
							java.util.Date begin = null;
							if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
								begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
							}
							else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
								begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
							}
							if(begin.before(this.begin) || begin.after(this.end)){
								continue;
							}
						}
						catch (Exception e){
							e.printStackTrace();
						}
					}
					if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
						try{
							java.util.Date end = null;
							if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
								end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
							}
							else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
								end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
							}
							if(end.before(this.begin) || end.after(this.end)){
								continue;
							}
						}
						catch (Exception e){
							e.printStackTrace();
						}
					}
					//Check if the serviceid associated to the diagnosis is mapped onto the dhis2 department code
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && inArray(item.split(";")[2].toLowerCase(),gender.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && inArray(item.split(";")[2].toLowerCase(),gender.toLowerCase()) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[11].toLowerCase(),origin.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[8].toLowerCase(),outcome.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
						selectedItems.add(item);
					}
				}
				exportDiagnosisDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportDiagnosisDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				bHasContent=true;
			}
		}
	}
	
	private void exportDiagnosisDatasetRecords(Vector items,Element dataset, String dataelementuid,String optionuid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(optionuid.length()==0||optionuid.equals(categoryOptionComboValue.attributeValue("uid"))){
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
						gender=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						gender=categoryOptionComboValue.attributeValue("gender");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
						origin=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
						outcome=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
					}
					for(int n=0;n<items.size();n++){
						String item = (String)items.elementAt(n);
						if(ScreenHelper.checkString(dataset.attributeValue("incoming")).equals("1")){
							try{
								java.util.Date begin = null;
								if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
									begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
								}
								else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
									begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								}
								if(begin.before(this.begin) || begin.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
							try{
								java.util.Date end = null;
								if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
									end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
								}
								else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
									end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								}
								if(end.before(this.begin) || end.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						//Check if the serviceid associated to the diagnosis is mapped onto the dhis2 department code
						if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[11].toLowerCase(),origin.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[8].toLowerCase(),outcome.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
							selectedItems.add(item);
						}
					}
					exportDiagnosisDatasetSeriesRecords(selectedItems,dataset,dataelementuid);
				}
			}
		}
		else{
			exportDiagnosisDatasetSeriesRecords(items,dataset,dataelementuid);
		}
	}
	
	private void exportEncounterDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		String zone=null;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
					origin=categoryOptionComboValue.attributeValue("value");
					Debug.println("- Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
					outcome=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone")){
					zone=categoryOptionComboValue.attributeValue("value");
					Debug.println("- Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+zone);
				}
				Debug.println("Checking "+items.size()+" items...");
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					if(ScreenHelper.checkString(dataset.attributeValue("incoming")).equals("1")){
						try{
							java.util.Date begin = null;
							if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
								begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
							}
							else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
								begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
							}
							if(begin.before(this.begin) || begin.after(this.end)){
								continue;
							}
						}
						catch (Exception e){
							e.printStackTrace();
						}
					}
					if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
						try{
							java.util.Date end = null;
							if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
								end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
							}
							else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
								end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
							}
							if(end.before(this.begin) || end.after(this.end)){
								continue;
							}
						}
						catch (Exception e){
							e.printStackTrace();
						}
					}
					if(dataset.attributeValue("type").equalsIgnoreCase("encounter") && ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true") && !item.split(";")[5].startsWith("dead")){
						continue;
					}
					if(dataset.attributeValue("type").equalsIgnoreCase("encounter") && ScreenHelper.checkString(dataset.attributeValue("missing")).equals("diagnosis")){
						Vector diagnoses = Diagnosis.selectDiagnoses("", "", MedwanQuery.getInstance().getServerId()+"."+item.split(";")[1], "", "", "", "", "", "", "", "", "icd10", "");
						if(diagnoses.size()>0) {
							continue;
						}
					}
					//Check if the serviceid associated to the encounter is mapped onto the dhis2 department code
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone") && zone!=null && inArray(item.split(";")[10].toLowerCase(),zone.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
						selectedItems.add(item);
					}
				}
				exportEncounterDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportEncounterDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				html.append("<p/>");
				bHasContent=true;
			}
		}
	}
	
	private void exportTechnicalActivityDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
					origin=categoryOptionComboValue.attributeValue("value");
					Debug.println("- Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
					outcome=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
				}
				Debug.println("Checking "+items.size()+" items...");
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					Debug.println("Checking item: "+item);
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
						selectedItems.add(item);
					}
				}
				exportTechnicalActivityDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportTechnicalActivityDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				html.append("<p/>");
				bHasContent=true;
			}
		}
	}
	
	private void exportItemDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		String zone=null;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
					origin=categoryOptionComboValue.attributeValue("value");
					Debug.println("- Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone")){
					zone=categoryOptionComboValue.attributeValue("value");
					Debug.println("- Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+zone);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
					outcome=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
				}
				Debug.println("Checking "+items.size()+" items...");
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					Debug.println("Checking item: "+item);
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone") && zone!=null && inArray(item.split(";")[12].toLowerCase(),zone.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("transactionitemvalue")){
						ItemVO tItem = null;
						tItem=MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), categoryOptionComboValue.attributeValue("itemtype"));
						if(tItem==null || tItem.getValue()==null || tItem.getValue().length()==0){
							continue;
						}
						else{
							String minval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMin"));
							String maxval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMax"));
							String matchval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValue"));
							String matchvalin=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueIn"));
							String minvalpct=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMinPct"));
							String maxvalpct=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMaxPct"));
							if(matchvalin.length()>0){
								try{
									if(!inArray(tItem.getValue(),matchvalin)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(minvalpct.length()>0){
								try{
									if(Double.parseDouble(tItem.getValue())*100/Double.parseDouble(item.split(";")[8])<Double.parseDouble(minvalpct)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(maxvalpct.length()>0){
								try{
									if(Double.parseDouble(tItem.getValue())*100/Double.parseDouble(item.split(";")[8])>=Double.parseDouble(maxvalpct)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(minval.length()>0){
								try{
									if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])<Double.parseDouble(minval)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(maxval.length()>0){
								try{
									if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])>Double.parseDouble(maxval)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(matchval.length()>0){
								try{
									if(!item.split(";")[8].equalsIgnoreCase(matchval)){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
						}
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
						selectedItems.add(item);
					}
				}
				exportItemDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportItemDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				html.append("<p/>");
				bHasContent=true;
			}
		}
	}
	
	private void exportPharmacyDataset(Element dataset, String attributeOptionComboUid,Hashtable initialquantities,Hashtable averageconsumptions,Hashtable consumptions,Hashtable productoperations){
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);
        
		exportPharmacyDatasetSeries(dataset,dataValueSet,initialquantities,averageconsumptions,consumptions,productoperations);

        if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				html.append("<p/>");
				bHasContent=true;
			}
		}
	}

	private void exportLabDataset(Vector items,Element dataset, String attributeOptionComboUid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		//This is where we create the DataValueSet
        DataValueSet dataValueSet = new DataValueSet();
        dataValueSet.setDataSet(dataset.attributeValue("uid"));
        dataValueSet.setOrgUnit(MedwanQuery.getInstance().getConfigString("dhis2_orgunit",""));
        dataValueSet.setPeriod(new SimpleDateFormat("yyyyMM").format(begin));
        dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(end));
        dataValueSet.setAttributeOptionCombo(attributeOptionComboUid);

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator(); //option elements
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next(); //categoryOptionComboValue = option element
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
					gender=categoryOptionComboValue.attributeValue("value");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
				}
				else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
					minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
					maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
					gender=categoryOptionComboValue.attributeValue("gender");
					Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
				}
				Debug.println("Checking "+items.size()+" items...");
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					Debug.println("Checking item: "+item);
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[1])){
						selectedItems.add(item);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[2]);
							if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[1]) && minAge>-1 && maxAge>-1){
						long day = 24*3600*1000;
						double year = 365*day;
						try{
							Date dateofbirth = ScreenHelper.parseDate(item.split(";")[2]);
							if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
								selectedItems.add(item);
							}
						}
						catch(Exception e){
							e.printStackTrace();
						}
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
						selectedItems.add(item);
					}
				}
				exportLabDatasetSeries(selectedItems,dataset,attributeOptionComboUid,categoryOptionComboValue.attributeValue("uid"),dataValueSet);
			}
		}
		else{
			exportLabDatasetSeries(items,dataset,attributeOptionComboUid,"",dataValueSet);
		}
		if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1 || dataValueSet.getDataValues().size()>0){
			try {
				Debug.println(dataValueSet.toXMLString());
			} catch (JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Send message to DHIS2 server
			if(exportFormat.equalsIgnoreCase("dhis2server")){
				DHIS2Helper.sendToServer(dataValueSet,dataset.attributeValue("label"),jspWriter);
			}
			else if(exportFormat.equalsIgnoreCase("html")){
				html.append(DHIS2Helper.toHtml(dataValueSet,"default",language,dataset.attributeValue("label")));
				html.append("<p/>");
				bHasContent=true;
			}
		}
	}
	
	private void exportEncounterDatasetRecords(Vector items,Element dataset, String dataelementuid,String optionuid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		String zone=null;

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(optionuid.length()==0||optionuid.equals(categoryOptionComboValue.attributeValue("uid"))){
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
						gender=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						gender=categoryOptionComboValue.attributeValue("gender");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
						origin=categoryOptionComboValue.attributeValue("value");
						Debug.println("* Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone")){
						zone=categoryOptionComboValue.attributeValue("value");
						Debug.println("* Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+zone);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
						outcome=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
					}
					Debug.println("Checking "+items.size()+" items...");
					for(int n=0;n<items.size();n++){
						String item = (String)items.elementAt(n);
						if(ScreenHelper.checkString(dataset.attributeValue("incoming")).equals("1")){
							try{
								java.util.Date begin = null;
								if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
									begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
								}
								else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
									begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								}
								if(begin.before(this.begin) || begin.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataset.attributeValue("outgoing")).equals("1")){
							try{
								java.util.Date end = null;
								if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
									end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
								}
								else if(dataset.attributeValue("type").equalsIgnoreCase("encounter")){
									end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								}
								if(end.before(this.begin) || end.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataset.attributeValue("missing")).equals("diagnosis")){
							if(Diagnosis.selectDiagnoses("", "", MedwanQuery.getInstance().getServerId()+"."+item.split(";")[1], "", "", "", "", "", "", "", "", "icd10", "").size()>0) {
								continue;
							}
						}
						if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone") && zone!=null && inArray(item.split(";")[10].toLowerCase(),zone.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
							selectedItems.add(item);
						}
					}
					exportEncounterDatasetSeriesRecords(selectedItems,dataset,dataelementuid);
				}
			}
		}
		else{
			exportEncounterDatasetSeriesRecords(items,dataset,dataelementuid);
		}
	}
	
	private void exportTechnicalActivityDatasetRecords(Vector items,Element dataset, String dataelementuid,String optionuid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(optionuid.length()==0||optionuid.equals(categoryOptionComboValue.attributeValue("uid"))){
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
						gender=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						gender=categoryOptionComboValue.attributeValue("gender");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
						origin=categoryOptionComboValue.attributeValue("value");
						Debug.println("* Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
						outcome=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
					}
					Debug.println("Checking "+items.size()+" items...");
					for(int n=0;n<items.size();n++){
						String item = (String)items.elementAt(n);
						Debug.println("Checking item: "+item);
						if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
							selectedItems.add(item);
						}
					}
					exportTechnicalActivityDatasetSeriesRecords(selectedItems,dataset,dataelementuid);
				}
			}
		}
		else{
			exportTechnicalActivityDatasetSeriesRecords(items,dataset,dataelementuid);
		}
	}
	
	private void exportPharmacyDatasetRecords(Element dataset, String dataelementuid,String optionuid,Hashtable initialquantities,Hashtable averageconsumptions,Hashtable consumptions,Hashtable productoperations){
		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
					//if conditions fulfilled for this categoryOptionCombo, calculate the dataElements 
				}
			}
		}
	}
	
	private void exportLabDatasetRecords(Vector items,Element dataset, String dataelementuid,String optionuid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(optionuid.length()==0||optionuid.equals(categoryOptionComboValue.attributeValue("uid"))){
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
						gender=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						gender=categoryOptionComboValue.attributeValue("gender");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
					}
					Debug.println("Checking "+items.size()+" items...");
					for(int n=0;n<items.size();n++){
						String item = (String)items.elementAt(n);
						Debug.println("Checking item: "+item);
						if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[1])){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[2]);
								if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[1]) && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[2]);
								if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
							selectedItems.add(item);
						}
					}
					exportLabDatasetSeriesRecords(selectedItems,dataset,dataelementuid);
				}
			}
		}
		else{
			exportLabDatasetSeriesRecords(items,dataset,dataelementuid);
		}
	}
	
	private void exportItemDatasetRecords(Vector items,Element dataset, String dataelementuid,String optionuid){
		String gender=null;
		double minAge=-1;
		double maxAge=-1;
		String origin=null;
		String outcome=null;
		String zone=null;

		//First we check if any categoryOptionCombo has been defined
		Element categoryOptionCombo = dataset.element("categoryOptionCombo");
		if(categoryOptionCombo!=null){
			Iterator icategoryOptionCombo = categoryOptionCombo.elementIterator();
			while(icategoryOptionCombo.hasNext()){
				Vector selectedItems = new Vector();
				Element categoryOptionComboValue = (Element)icategoryOptionCombo.next();
				if(optionuid.length()==0||optionuid.equals(categoryOptionComboValue.attributeValue("uid"))){
					if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender")){
						gender=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender")){
						minAge=Double.parseDouble(categoryOptionComboValue.attributeValue("min"));
						maxAge=Double.parseDouble(categoryOptionComboValue.attributeValue("max"));
						gender=categoryOptionComboValue.attributeValue("gender");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+minAge+"->"+maxAge+ " | "+gender);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin")){
						origin=categoryOptionComboValue.attributeValue("value");
						Debug.println("* Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+origin);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone")){
						zone=categoryOptionComboValue.attributeValue("value");
						Debug.println("* Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+zone);
					}
					else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome")){
						outcome=categoryOptionComboValue.attributeValue("value");
						Debug.println("Exporting categoryOptionType "+categoryOptionCombo.attributeValue("type")+" - "+outcome);
					}
					Debug.println("Checking "+items.size()+" items...");
					for(int n=0;n<items.size();n++){
						String item = (String)items.elementAt(n);
						Debug.println("Checking item: "+item);
						if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("gender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2])){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("age") && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("agegender") && gender!=null && gender.equalsIgnoreCase(item.split(";")[2]) && minAge>-1 && maxAge>-1){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								if((begin.getTime()-dateofbirth.getTime())/year>=minAge && (begin.getTime()-dateofbirth.getTime())/year<maxAge){
									selectedItems.add(item);
								}
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("origin") && origin!=null && inArray(item.split(";")[7].toLowerCase(),origin.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("zone") && zone!=null && inArray(item.split(";")[12].toLowerCase(),zone.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("outcome") && outcome!=null && inArray(item.split(";")[5].toLowerCase(),outcome.toLowerCase())){
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("transactionitemvalue")){
							ItemVO tItem = null;
							tItem=MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), categoryOptionComboValue.attributeValue("itemtype"));
							if(tItem==null || tItem.getValue()==null || tItem.getValue().length()==0){
								continue;
							}
							else{
								String minval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMin"));
								String maxval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMax"));
								String matchval=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValue"));
								String matchvalin=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueIn"));
								String minvalpct=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMinPct"));
								String maxvalpct=ScreenHelper.checkString(categoryOptionComboValue.attributeValue("outputItemValueMaxPct"));
								if(matchvalin.length()>0){
									try{
										if(!inArray(tItem.getValue(),matchvalin)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
								if(minvalpct.length()>0){
									try{
										if(Double.parseDouble(tItem.getValue())*100/Double.parseDouble(item.split(";")[8])<Double.parseDouble(minvalpct)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
								if(maxvalpct.length()>0){
									try{
										if(Double.parseDouble(tItem.getValue())*100/Double.parseDouble(item.split(";")[8])>=Double.parseDouble(maxvalpct)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
								if(minval.length()>0){
									try{
										if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])<Double.parseDouble(minval)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
								if(maxval.length()>0){
									try{
										if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])>Double.parseDouble(maxval)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
								if(matchval.length()>0){
									try{
										if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])!=Double.parseDouble(matchval)){
											continue;
										}
									}
									catch(Exception e){
										continue;
									}
								}
							}
							selectedItems.add(item);
						}
						else if(categoryOptionCombo.attributeValue("type").equalsIgnoreCase("default")){
							selectedItems.add(item);
						}
					}
					exportItemDatasetSeriesRecords(selectedItems,dataset,dataelementuid);
				}
			}
		}
		else{
			exportItemDatasetSeriesRecords(items,dataset,dataelementuid);
		}
	}
	
	private void exportEncounterDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		String sOutcome = ScreenHelper.checkString(dataset.attributeValue("outcome"));
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Hashtable uids = new Hashtable();
			Element dataelement = (Element)i.next();
			long uidcounter=0;
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(ScreenHelper.checkString(dataelement.attributeValue("minage")).length()>0){
					long day = 24*3600*1000;
					double year = 365*day;
					try{
						Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
						double minAge = Double.parseDouble(dataelement.attributeValue("minage"));
						if(dateofbirth==null || (begin.getTime()-dateofbirth.getTime())/year<minAge){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(ScreenHelper.checkString(dataelement.attributeValue("maxage")).length()>0){
					long day = 24*3600*1000;
					double year = 365*day;
					try{
						Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
						double maxAge = Double.parseDouble(dataelement.attributeValue("maxage"));
						if(dateofbirth==null || (begin.getTime()-dateofbirth.getTime())/year>=maxAge){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(ScreenHelper.checkString(dataelement.attributeValue("gender")).length()>0){
					if(!inArray(item.split(";")[2].toLowerCase(),dataelement.attributeValue("gender").toLowerCase())){
						continue;
					}
				}
				if(ScreenHelper.checkString(dataset.attributeValue("newcase")).equals("1") && !Encounter.isNewCase(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1])){
					continue;
				}
				else if(ScreenHelper.checkString(dataset.attributeValue("newcase")).equals("0") && !Encounter.isOldCase(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1])){
					continue;
				}
				if(sOutcome.length()>0 && !sOutcome.equalsIgnoreCase(item.split(";")[5])){
					continue;
				}
				if(!bMortality || item.split(";")[5].startsWith("dead")){
					if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
						if(ScreenHelper.checkString(dataelement.attributeValue("incoming")).equals("1")){
							try{
								java.util.Date begin = begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								if(begin.before(this.begin) || begin.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("outgoing")).equals("1")){
							try{
								java.util.Date end =  new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								if(end.before(this.begin) || end.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("potentialAdmissionDays")){
							uidcounter=getBedCountForDepartment(item.split(";")[4])*ScreenHelper.nightsBetween(begin,end);
							break;
						}
						else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("admissionDays")){
							try{
								java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								if(begin.before(this.begin)){
									begin=this.begin;
								}
								java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								if(end.after(this.end)){
									end=new java.util.Date(this.end.getTime()-1000);
								}
								uidcounter+= ScreenHelper.nightsBetween(begin,end);
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("totalAdmissionDays")){
							try{
								java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								if(end.after(this.end)){
									end=new java.util.Date(this.end.getTime()-1000);
								}
								uidcounter+= ScreenHelper.nightsBetween(begin,end);
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("totalAdmissionDaysPlus")){
							try{
								java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								if(end.after(this.end)){
									end=new java.util.Date(this.end.getTime()-1000);
								}
								uidcounter+= ScreenHelper.nightsBetween(begin,end)+1;
							}
							catch(Exception e){
								e.printStackTrace();
							}
						}
						else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("itemCount")){
							int nNeeded=0;
							if(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")).length()>0){
								nNeeded=Integer.parseInt(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")));
							}
							int nFound=0;
							Iterator iItems = dataelement.elementIterator("item");
							while(iItems.hasNext()){
								Element itemelement = (Element)iItems.next();
								String sItemType=itemelement.attributeValue("itemtype");
								String sItemValue=ScreenHelper.checkString(itemelement.attributeValue("itemvalue"));
								//Now we look for the existence of this item
								boolean bExists=MedwanQuery.getInstance().hasItem(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1], sItemType, sItemValue);
								if(nNeeded==0 && !bExists){
									nFound=-1;
									break;
								}
								else if(nNeeded==0){
									nFound++;
								}
								else if(nNeeded>0 && bExists){
									nFound++;
									if(nFound>=nNeeded && !ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
										break;
									}
								}
							}
							if(nFound>=nNeeded){
								if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
									uids.put(item.split(";")[0],nFound);
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
									uids.put(item.split(";")[1],nFound);
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
									uidcounter+=nFound;
								}
								else{
									uidcounter++;
								}
							}
						}
						else{
							if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
								uids.put(item.split(";")[0],1);
							}
							else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
								uids.put(item.split(";")[1],1);
							}
							else{
								uidcounter++;
							}
						}
					}
				}
			}
			if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients") || ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
				if(ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
					uidcounter=0;
					Enumeration eUids = uids.keys();
					while(eUids.hasMoreElements()){
						String key = (String)eUids.nextElement();
						uidcounter+=(Integer)uids.get(key);
					}
				}
				else{
					uidcounter=uids.size();
				}
			}
			if(MedwanQuery.getInstance().getConfigInt("cleanDHIS2DataSets",0)==0 && uidcounter>0){
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid,uidcounter+"",""));
			}
			else if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1){
				System.out.println("adding empty "+dataelement.attributeValue("uid")+" - "+dataelement.attributeValue("categoryoptionuid"));
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid," ",""));
			}
		}
	}
	
	private void exportTechnicalActivityDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Element dataelement = (Element)i.next();
			long uidcounter=0;
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(!bMortality || item.split(";")[5].startsWith("dead")){
					if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
						if(inArray(item.split(";")[8].toLowerCase(), dataelement.attributeValue("code").toLowerCase())){
							uidcounter++;
						}
					}
				}
			}
			if(MedwanQuery.getInstance().getConfigInt("cleanDHIS2DataSets",0)==0 && uidcounter>0){
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid,uidcounter+"",""));
			}
			else if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1){
				System.out.println("adding empty "+dataelement.attributeValue("uid")+" - "+dataelement.attributeValue("categoryoptionuid"));
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid," ",""));
			}
		}
	}
	
	private void exportPharmacyDatasetSeries(Element dataset, DataValueSet dataValueSet,Hashtable initialquantities,Hashtable averageconsumptions,Hashtable consumptions,Hashtable productoperations){
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			String dataElementUid="";
			String categoryOptionComboUid="";
			Element dataelement = (Element)i.next();
			Debug.println("Searching products for DHIS2 code = "+dataelement.attributeValue("productcode"));
			Vector<Product> products = Product.getProductsByDhis2code(ScreenHelper.checkString(dataelement.attributeValue("productcode")));
			if(ScreenHelper.checkString(dataset.attributeValue("missing")).equalsIgnoreCase("1")){
				System.out.println("Product code "+ScreenHelper.checkString(dataelement.attributeValue("productcode"))+"= "+products.size());
				if(products.size()>0) {
					continue;
				}
				categoryOptionComboUid=ScreenHelper.checkString(dataelement.attributeValue("option"));
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),categoryOptionComboUid,"["+dataelement.attributeValue("productcode")+"]",""));
			}
			else {
				Iterator iParameters = dataelement.elementIterator("parameter");
				while(iParameters.hasNext()) {
					int value=0;
					Element parameter = (Element)iParameters.next();
					String calculate=ScreenHelper.checkString(parameter.attributeValue("calculate"));
					categoryOptionComboUid=ScreenHelper.checkString(parameter.attributeValue("option"));
					dataElementUid=ScreenHelper.checkString(parameter.attributeValue("uid"));
					long t = new java.util.Date().getTime();
					if(calculate.equalsIgnoreCase("initialstock")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							if(initialquantities.get(product.getUid())!=null) {
								value+=((Double)initialquantities.get(product.getUid())).intValue();
							}
						}
					}
					else if(calculate.equalsIgnoreCase("quantityreceived")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							Vector<ProductStock> productStocks=ProductStock.find(MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode"), product.getUid(), "", "", "", "", "", "", "", "", "", "", "");	
							for(int p=0;p<productStocks.size();p++) {
								ProductStock stock = productStocks.elementAt(p);
								value+=stock.getTotalUnitsInForPeriod(begin, end);
							}
						}
					}
					else if(calculate.equalsIgnoreCase("quantitydispensed")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							if(consumptions.get(product.getUid())!=null) {
								value+=((Double)consumptions.get(product.getUid())).intValue();
							}
						}
					}
					else if(calculate.equalsIgnoreCase("finalstockmain")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							Vector<ProductStock> productStocks=ProductStock.find(MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode"), product.getUid(), "", "", "", "", "", "", "", "", "", "", "");	
							for(int p=0;p<productStocks.size();p++) {
								ProductStock stock = productStocks.elementAt(p);
								value+=stock.getLevel(end);
							}
						}
					}
					else if(calculate.equalsIgnoreCase("finalstockdispensing")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							Vector<ProductStock> productStocks=ProductStock.find("", product.getUid(), "", "", "", "", "", "", "", "", "", "", "");	
							for(int p=0;p<productStocks.size();p++) {
								ProductStock stock = productStocks.elementAt(p);
								if(!stock.getServiceStockUid().equalsIgnoreCase(MedwanQuery.getInstance().getConfigString("centralPharmacyServiceStockCode"))) {
									value+=stock.getCorrectedLevel(end);
								}
							}
						}
					}
					else if(calculate.equalsIgnoreCase("quantityexpired")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							Vector<String> batches = Batch.getActiveExpiringBatches(product.getUid(),begin, end);
							for(int b=0;b<batches.size();b++) {
								value+=Integer.parseInt((batches.elementAt(b)).split(";")[4]);
							}
						}
					}
					else if(calculate.equalsIgnoreCase("stockoutdays")) {
						if(products.size()>0) {
							int minvalue=-1;
							for(int n=0;n<products.size();n++) {
								Product product = products.elementAt(n);
								value=product.getDaysOutOfStock(begin, end, productoperations);
								if(minvalue==-1 || value<minvalue) {
									minvalue=value;
								}
							}
							if(minvalue==-1) {
								value=0;
							}
							else {
								value=minvalue;
							}
						}
						else {
							value=new Long((end.getTime()-begin.getTime())/ScreenHelper.getTimeDay()).intValue();
						}
					}
					else if(calculate.equalsIgnoreCase("quantitytoexpire")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							Vector<String> batches = Batch.getActiveExpiringBatches(product.getUid(),end, new java.util.Date(end.getTime()+ScreenHelper.getTimeDay()*Integer.parseInt(parameter.attributeValue("delay"))));
							for(int b=0;b<batches.size();b++) {
								value+=Integer.parseInt((batches.elementAt(b)).split(";")[4]);
							}
						}
					} 
					else if(calculate.equalsIgnoreCase("averageconsumption")) {
						for(int n=0;n<products.size();n++) {
							Product product = products.elementAt(n);
							if(averageconsumptions.get(product.getUid())!=null) {
								value+=((Double)averageconsumptions.get(product.getUid())).intValue();
							}
						}
					}
					dataValueSet.getDataValues().add(new DataValue(dataElementUid,categoryOptionComboUid,value+"",""));
				}
				if(products.size()==0) {
					dataValueSet.getDataValues().add(new DataValue(dataElementUid,categoryOptionComboUid,"0",""));
				}
			}
		}
	}
	
	private void exportLabDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Element dataelement = (Element)i.next();
			HashSet uniqueexams = new HashSet();
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(inArray(item.split(";")[3].toLowerCase(), dataelement.attributeValue("code").toLowerCase())){
					uniqueexams.add(item.split(";")[5]);
				}
			}
			if(MedwanQuery.getInstance().getConfigInt("cleanDHIS2DataSets",0)==0 && uniqueexams.size()>0){
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid,uniqueexams.size()+"",""));
			}
			else if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1) {
				System.out.println("adding empty "+dataelement.attributeValue("uid")+" - "+dataelement.attributeValue("categoryoptionuid"));
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid," ",""));
			}
		}
	}
	
	private void exportItemDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Hashtable uids = new Hashtable();
			Element dataelement = (Element)i.next();
			long uidcounter=0;
			for(int n=0;n<items.size();n++){
				String item = (String)items.elementAt(n);
				if(ScreenHelper.checkString(dataelement.attributeValue("minage")).length()>0){
					try{
						double minAge = Double.parseDouble(dataelement.attributeValue("minage"));
						long day = 24*3600*1000;
						double year = 365*day;
						Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
						if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year<minAge){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(ScreenHelper.checkString(dataelement.attributeValue("maxage")).length()>0){
					try{
						double maxAge = Double.parseDouble(dataelement.attributeValue("maxage"));
						long day = 24*3600*1000;
						double year = 365*day;
						Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
						if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=maxAge){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(ScreenHelper.checkString(dataelement.attributeValue("gender")).length()>0){
					if(!inArray(item.split(";")[2].toLowerCase(),dataelement.attributeValue("gender").toLowerCase())){
						continue;
					}
				}
				if(!bMortality || item.split(";")[5].startsWith("dead")){
					if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
						if(ScreenHelper.checkString(dataelement.attributeValue("itemvalue")).length()==0 || inArray(item.split(";")[8].toLowerCase(), dataelement.attributeValue("itemvalue").toLowerCase())){
							if(ScreenHelper.checkString(dataelement.attributeValue("itemtype")).length()==0 || inArray(item.split(";")[9].toLowerCase(), dataelement.attributeValue("itemtype").toLowerCase())){
								if(ScreenHelper.checkString(dataelement.attributeValue("outputtype")).equals("transactionItemValue")){
									String[] types=ScreenHelper.checkString(dataelement.attributeValue("outputid")).split(";");
									for(int tn=0;tn<types.length;tn++) {
										String type = types[tn];
										ItemVO tItem = MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), type);
										if(tItem==null || tItem.getValue()==null || tItem.getValue().length()==0){
											continue;
										}
										else{
											double value = 0;
											String minval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueMin"));
											String maxval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueMax"));
											String matchval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValue"));
											String matchvalin=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueIn"));
											if(matchvalin.length()>0){
												try{
													if(!inArray(tItem.getValue(),matchvalin)){
														continue;
													}
												}
												catch(Exception e){
													continue;
												}
											}
											else {
												if(matchval.length()==0){
													try{
														value=new Double(Double.parseDouble(tItem.getValue())).intValue();
													}
													catch(Exception e){
														e.printStackTrace();
													}
													if(value==0){
														continue;
													}
													if(minval.length()>0){
														try{
															if(value<Double.parseDouble(minval)){
																continue;
															}
														}
														catch(Exception e){
															continue;
														}
													}
													if(maxval.length()>0){
														try{
															if(value>Double.parseDouble(maxval)){
																continue;
															}
														}
														catch(Exception e){
															continue;
														}
													}
												}
												else if(!matchval.equalsIgnoreCase(tItem.getValue())){
													continue;
												}
											}
											if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).length()>0){
												//Evaluate conditions comparing to other items
												if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("equals;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[1]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value!=othervalue){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
												else if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("greaterthannotzero;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[1]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value<=othervalue || othervalue==0){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
												else if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("minusequals;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[2]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value-othervalue!=Double.parseDouble(dataelement.attributeValue("comparetoitem").split(";")[1])){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
											}
											if(ScreenHelper.checkString(dataelement.attributeValue("outputvalue")).equalsIgnoreCase("outputitemvalue")){
												value=Double.parseDouble(tItem.getValue());
											}
											else if(ScreenHelper.checkString(dataelement.attributeValue("value")).length()>0){
												value=Double.parseDouble(dataelement.attributeValue("value"));
											}
											else{
												value=1;
											}
											if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
												uids.put(item.split(";")[0],value);
											}
											else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
												uids.put(item.split(";")[1],value);
											}
											else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
												uids.put(item.split(";")[11],value);
												System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> item "+item.split(";")[11]+" - "+value);
												System.out.println(dataelement.asXML());
											}
											else {
												uidcounter+=value;
												Debug.println("patient = "+item.split(";")[0]+" / uidcounter="+uidcounter);
											}
										}
									}
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("admissionDays")){
									try{
										java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
										if(begin.before(this.begin)){
											begin=this.begin;
										}
										java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
										if(end.after(this.end)){
											end=new java.util.Date(this.end.getTime()-1000);
										}
										uidcounter+= ScreenHelper.nightsBetween(begin,end);
									}
									catch(Exception e){
										e.printStackTrace();
									}
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("totalAdmissionDays")){
									try{
										java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[13]);
										java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[14]);
										if(end.after(this.end)){
											end=new java.util.Date(this.end.getTime()-1000);
										}
										uidcounter+= ScreenHelper.nightsBetween(begin,end);
									}
									catch(Exception e){
										e.printStackTrace();
									}
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("totalAdmissionDaysPlus")){
									try{
										java.util.Date begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
										java.util.Date end = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
										if(end.after(this.end)){
											end=new java.util.Date(this.end.getTime()-1000);
										}
										uidcounter+= ScreenHelper.nightsBetween(begin,end)+1;
									}
									catch(Exception e){
										e.printStackTrace();
									}
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("itemCount")){
									int nNeeded=0;
									if(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")).length()>0){
										nNeeded=Integer.parseInt(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")));
									}
									int nFound=0;
									Iterator iItems = dataelement.elementIterator("item");
									while(iItems.hasNext()){
										Element itemelement = (Element)iItems.next();
										String sItemType=itemelement.attributeValue("itemtype");
										String sItemValue=ScreenHelper.checkString(itemelement.attributeValue("itemvalue"));
										//Now we look for the existence of this item
										boolean bExists=MedwanQuery.getInstance().hasItem(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1], sItemType, sItemValue);
										if(nNeeded==0 && !bExists){
											nFound=-1;
											break;
										}
										else if(nNeeded==0){
											nFound++;
										}
										else if(nNeeded>0 && bExists){
											nFound++;
											if(nFound>=nNeeded && !ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
												break;
											}
										}
									}
									if(nFound>=nNeeded){
										if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
											uids.put(item.split(";")[0],nFound);
										}
										else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
											uids.put(item.split(";")[1],nFound);
										}
										else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
											uids.put(item.split(";")[11],nFound);
										}
										else if(ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
											uidcounter+=nFound;
										}
										else{
											uidcounter++;
										}
									}										
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("missing")).equalsIgnoreCase("1")){
									boolean bExists = false;
									Iterator iItems = dataelement.elementIterator("item");
									while(iItems.hasNext() && !bExists){
										Element missingItem = (Element)iItems.next();
										Vector vItems=MedwanQuery.getInstance().getItemsLike(MedwanQuery.getInstance().getServerId(), Integer.parseInt(item.split(";")[11]), missingItem.attributeValue("itemtype"));
										if(vItems.size()>0){									
											bExists=true;
											break;
										}
									}
									if(bExists){
										continue;
									}
									if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
										uids.put(item.split(";")[0],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
										uids.put(item.split(";")[1],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
										uids.put(item.split(";")[11],1);
									}
									uidcounter++;
								}
								else if(ScreenHelper.checkString(dataelement.attributeValue("combine")).equalsIgnoreCase("1")){
									boolean bOK = false;
									Iterator iItemGroups = dataelement.elementIterator("itemgroup");
									while(iItemGroups.hasNext()){
										bOK = false;
										Element itemGroup = (Element)iItemGroups.next();
										if(ScreenHelper.checkString(itemGroup.attributeValue("calculate")).equalsIgnoreCase("itemCount")){
											int nNeeded=0;
											if(ScreenHelper.checkString(itemGroup.attributeValue("itemsneeded")).length()>0){
												nNeeded=Integer.parseInt(ScreenHelper.checkString(itemGroup.attributeValue("itemsneeded")));
											}
											int nFound=0;
											Iterator iItems = itemGroup.elementIterator("item");
											while(iItems.hasNext()){
												Element itemelement = (Element)iItems.next();
												String sItemType=itemelement.attributeValue("itemtype");
												String sItemValue=ScreenHelper.checkString(itemelement.attributeValue("itemvalue"));
												//Now we look for the existence of this item
												boolean bExists=MedwanQuery.getInstance().hasItem(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1], sItemType, sItemValue);
												if(nNeeded==0 && !bExists){
													break;
												}
												else if(nNeeded==0){
													bOK=true;
													break;
												}
												else if(nNeeded>0 && bExists){
													nFound++;
													if(nFound>=nNeeded){
														bOK=true;
														break;
													}
												}
											}
										}
										else if(ScreenHelper.checkString(itemGroup.attributeValue("missing")).equalsIgnoreCase("1")){
											boolean bExists = false;
											Iterator iItems = dataelement.elementIterator("item");
											while(iItems.hasNext() && !bExists){
												Element missingItem = (Element)iItems.next();
												Vector vItems=MedwanQuery.getInstance().getItemsLike(MedwanQuery.getInstance().getServerId(), Integer.parseInt(item.split(";")[11]), missingItem.attributeValue("itemtype"));
												if(vItems.size()>0){									
													bExists=true;
													break;
												}
											}
											if(bExists){
												continue;
											}
										}
										if(!bOK) {
											break;
										}
									}
									if(!bOK){
										continue;
									}
									if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
										uids.put(item.split(";")[0],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
										uids.put(item.split(";")[1],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
										uids.put(item.split(";")[11],1);
									}
									uidcounter++;
								}
								else{
									if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients")){
										uids.put(item.split(";")[0],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters")){
										uids.put(item.split(";")[1],1);
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
										uids.put(item.split(";")[11],1);
									}
									uidcounter++;
								}
							}
						}
					}
				}
			}
			if(ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("patients") || 
			   ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("encounters") ||
			   ScreenHelper.checkString(dataelement.attributeValue("unique")).equalsIgnoreCase("transactions")){
				if(ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
					uidcounter=0;
					Enumeration eUids = uids.keys();
					while(eUids.hasMoreElements()){
						String key = (String)eUids.nextElement();
						uidcounter+=(Integer)uids.get(key);
					}
				}
				else{
					uidcounter=uids.size();
				}
			}
			if(MedwanQuery.getInstance().getConfigInt("cleanDHIS2DataSets",0)==0 && uidcounter>0){
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid,uidcounter+"",""));
			}
			else if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1){
				dataValueSet.getDataValues().add(new DataValue(dataelement.attributeValue("uid"),dataelement.attributeValue("categoryoptionuid")!=null?dataelement.attributeValue("categoryoptionuid"):categoryOptionUid," ",""));
			}
		}
	}
	
	private int getBedCountForDepartment(String serviceUid){
		int bedcount=0;
		Connection conn = MedwanQuery.getInstance().getAdminConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("select sum(totalbeds) as total from services where inscode=(select inscode from services where serviceid=?)");
			ps.setString(1, serviceUid);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				bedcount=rs.getInt("total");
			}
			rs.close();
			ps.close();
			conn.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return bedcount;
	}
	
	private void exportEncounterDatasetSeriesRecords(Vector items,Element dataset,String dataelementuid){
		int uidcounter=0;
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		String sOutcome = ScreenHelper.checkString(dataset.attributeValue("outcome"));
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(ScreenHelper.checkString(dataset.attributeValue("newcase")).equals("1") && !Encounter.isNewCase(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1])){
				continue;
			}
			else if(ScreenHelper.checkString(dataset.attributeValue("newcase")).equals("0") && !Encounter.isOldCase(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1])){
				continue;
			}
			if(sOutcome.length()>0 && !sOutcome.equalsIgnoreCase(item.split(";")[5])){
				continue;
			}
			if(!bMortality || item.split(";")[5].startsWith("dead")){
				if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
					Iterator i = dataset.element("dataelements").elementIterator("dataelement");
					while(i.hasNext()){
						Element dataelement = (Element)i.next();
						if(ScreenHelper.checkString(dataelement.attributeValue("minage")).length()>0){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								double minAge = Double.parseDouble(dataelement.attributeValue("minage"));
								if(dateofbirth==null || (begin.getTime()-dateofbirth.getTime())/year<minAge){
									continue;
								}
							}
							catch(Exception e){
								continue;
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("maxage")).length()>0){
							long day = 24*3600*1000;
							double year = 365*day;
							try{
								Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
								double maxAge = Double.parseDouble(dataelement.attributeValue("maxage"));
								if(dateofbirth==null || (begin.getTime()-dateofbirth.getTime())/year>=maxAge){
									continue;
								}
							}
							catch(Exception e){
								continue;
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("gender")).length()>0){
							if(!inArray(item.split(";")[2].toLowerCase(),dataelement.attributeValue("gender").toLowerCase())){
								continue;
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("incoming")).equals("1")){
							try{
								java.util.Date begin = begin = new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[8]);
								if(begin.before(this.begin) || begin.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("outgoing")).equals("1")){
							try{
								java.util.Date end =  new SimpleDateFormat("yyyyMMddHHmm").parse(item.split(";")[9]);
								if(end.before(this.begin) || end.after(this.end)){
									continue;
								}
							}
							catch (Exception e){
								e.printStackTrace();
							}
						}
						if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("itemCount")){
							int nNeeded=0;
							if(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")).length()>0){
								nNeeded=Integer.parseInt(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")));
							}
							int nFound=0;
							Iterator iItems = dataelement.elementIterator("item");
							while(iItems.hasNext()){
								Element itemelement = (Element)iItems.next();
								String sItemType=itemelement.attributeValue("itemtype");
								String sItemValue=ScreenHelper.checkString(itemelement.attributeValue("itemvalue"));
								//Now we look for the existence of this item
								boolean bExists=MedwanQuery.getInstance().hasItem(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1], sItemType, sItemValue);
								if(nNeeded==0 && !bExists){
									nFound=-1;
									break;
								}
								else if(nNeeded>0 && bExists){
									nFound++;
									if(nFound>=nNeeded){
										break;
									}
								}
							}
							if(nFound<nNeeded){
								continue;
							}
						}
						if(dataelement.attributeValue("uid").equals(dataelementuid)){
							patientrecords.add(item.split(";")[0]);
						}
					}
				}
			}
		}
	}
	
	private void exportTechnicalActivityDatasetSeriesRecords(Vector items,Element dataset,String dataelementuid){
		int uidcounter=0;
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(!bMortality || item.split(";")[5].startsWith("dead")){
				if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
					Iterator i = dataset.element("dataelements").elementIterator("dataelement");
					while(i.hasNext()){
						Element dataelement = (Element)i.next();
						if(dataelement.attributeValue("uid").equals(dataelementuid)){
							if(!inArray(item.split(";")[8].toLowerCase(), dataelement.attributeValue("code").toLowerCase())){
								continue;
							}
							patientrecords.add(item.split(";")[0]);
						}
					}
				}
			}
		}
	}
	
	private void exportLabDatasetSeriesRecords(Vector items,Element dataset,String dataelementuid){
		int uidcounter=0;
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			Iterator i = dataset.element("dataelements").elementIterator("dataelement");
			while(i.hasNext()){
				Element dataelement = (Element)i.next();
				if(dataelement.attributeValue("uid").equals(dataelementuid)){
					if(!inArray(item.split(";")[3].toLowerCase(), dataelement.attributeValue("code").toLowerCase())){
						continue;
					}
					patientrecords.add(item.split(";")[0]);
				}
			}
		}
	}
	
	private void exportItemDatasetSeriesRecords(Vector items,Element dataset,String dataelementuid){
		int uidcounter=0;
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(!bMortality || item.split(";")[5].startsWith("dead")){
				if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[6]).equalsIgnoreCase(sEncounterType)){
					Iterator i = dataset.element("dataelements").elementIterator("dataelement");
					while(i.hasNext()){
						Element dataelement = (Element)i.next();
						if(dataelement.attributeValue("uid").equals(dataelementuid)){
							if(ScreenHelper.checkString(dataelement.attributeValue("minage")).length()>0){
								try{
									double minAge = Double.parseDouble(dataelement.attributeValue("minage"));
									long day = 24*3600*1000;
									double year = 365*day;
									Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
									if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year<minAge){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(ScreenHelper.checkString(dataelement.attributeValue("maxage")).length()>0){
								try{
									double maxAge = Double.parseDouble(dataelement.attributeValue("maxage"));
									long day = 24*3600*1000;
									double year = 365*day;
									Date dateofbirth = ScreenHelper.parseDate(item.split(";")[3]);
									if(dateofbirth!=null && (begin.getTime()-dateofbirth.getTime())/year>=maxAge){
										continue;
									}
								}
								catch(Exception e){
									continue;
								}
							}
							if(ScreenHelper.checkString(dataelement.attributeValue("gender")).length()>0){
								if(!inArray(item.split(";")[2].toLowerCase(),dataelement.attributeValue("gender").toLowerCase())){
									continue;
								}
							}
							if(ScreenHelper.checkString(dataelement.attributeValue("itemtype")).length()>0 && !inArray(item.split(";")[9].toLowerCase(), dataelement.attributeValue("itemtype").toLowerCase())){
								continue;
							}
							if(ScreenHelper.checkString(dataelement.attributeValue("itemvalue")).length()>0 && !inArray(item.split(";")[8].toLowerCase(), dataelement.attributeValue("itemvalue").toLowerCase())){
								continue;
							}
							if(ScreenHelper.checkString(dataelement.attributeValue("outputtype")).equals("transactionItemValue")){
								String[] types=ScreenHelper.checkString(dataelement.attributeValue("outputid")).split(";");
								for(int tn=0;tn<types.length;tn++) {
									String type = types[tn];
									ItemVO tItem = MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), type);
									if(tItem==null || tItem.getValue()==null || tItem.getValue().length()==0){
										continue;
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("outputItemValue")).length()>0){
										String matchval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValue"));
										if(!tItem.getValue().equalsIgnoreCase(matchval)){
											continue;
										}
									}
									else if(ScreenHelper.checkString(dataelement.attributeValue("outputItemValueIn")).length()>0){
										String matchvalin=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueIn"));
										if(matchvalin.length()>0){
											try{
												if(!inArray(tItem.getValue(),matchvalin)){
													continue;
												}
											}
											catch(Exception e){
												continue;
											}
										}
									}
									else{
										double value = 0;
										if(ScreenHelper.checkString(dataelement.attributeValue("value")).length()>0){
											value=new Double(Double.parseDouble(ScreenHelper.checkString(dataelement.attributeValue("value")))).intValue();
										}
										else{
											try{
												value=new Double(Double.parseDouble(tItem.getValue())).intValue();
											}
											catch(Exception e){
												e.printStackTrace();
											}
											if(value==0){
												continue;
											}
											String minval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueMin"));
											String maxval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValueMax"));
											String matchval=ScreenHelper.checkString(dataelement.attributeValue("outputItemValue"));
											if(minval.length()>0){
												try{
													if(value<Double.parseDouble(minval)){
														continue;
													}
												}
												catch(Exception e){
													continue;
												}
											}
											if(maxval.length()>0){
												try{
													if(value>Double.parseDouble(maxval)){
														continue;
													}
												}
												catch(Exception e){
													continue;
												}
											}
											if(matchval.length()>0){
												try{
													if(value!=Double.parseDouble(matchval)){
														continue;
													}
												}
												catch(Exception e){
													continue;
												}
											}
											if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).length()>0){
												//Evaluate conditions comparing to other items
												if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("equals;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[1]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value!=othervalue){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
												else if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("greaterthannotzero;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[1]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value<=othervalue || othervalue==0){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
												else if(ScreenHelper.checkString(dataelement.attributeValue("comparetoitem")).startsWith("minusequals;")){
													try{
														value=Double.parseDouble(tItem.getValue());
														ItemVO otheritem =MedwanQuery.getInstance().getItem(Integer.parseInt(item.split(";")[10]), Integer.parseInt(item.split(";")[11]), dataelement.attributeValue("comparetoitem").split(";")[2]);
														if(otheritem!=null){
															double othervalue=Double.parseDouble(otheritem.getValue());
															if(value-othervalue!=Double.parseDouble(dataelement.attributeValue("comparetoitem").split(";")[1])){
																continue;
															}
														}
														else{
															continue;
														}
													}
													catch(Exception r){
														r.printStackTrace();
														continue;
													}
												}
											}
										}
									}
								}
							}
							else if(ScreenHelper.checkString(dataelement.attributeValue("calculate")).equalsIgnoreCase("itemCount")){
								int nNeeded=0;
								if(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")).length()>0){
									nNeeded=Integer.parseInt(ScreenHelper.checkString(dataelement.attributeValue("itemsneeded")));
								}
								int nFound=0;
								Iterator iItems = dataelement.elementIterator("item");
								while(iItems.hasNext()){
									Element itemelement = (Element)iItems.next();
									String sItemType=itemelement.attributeValue("itemtype");
									String sItemValue=ScreenHelper.checkString(itemelement.attributeValue("itemvalue"));
									//Now we look for the existence of this item
									boolean bExists=MedwanQuery.getInstance().hasItem(MedwanQuery.getInstance().getConfigString("serverId")+"."+item.split(";")[1], sItemType, sItemValue);
									if(nNeeded==0 && !bExists){
										nFound=-1;
										break;
									}
									else if(nNeeded==0){
										nFound++;
									}
									else if(nNeeded>0 && bExists){
										nFound++;
										if(nFound>=nNeeded && !ScreenHelper.checkString(dataelement.attributeValue("countall")).equals("1")){
											break;
										}
									}
								}
								if(nFound<nNeeded){
									continue;
								}
							}
							else if(ScreenHelper.checkString(dataelement.attributeValue("missing")).equalsIgnoreCase("1")){
								boolean bExists = false;
								Iterator iItems = dataelement.elementIterator("item");
								while(iItems.hasNext() && !bExists){
									Element missingItem = (Element)iItems.next();
									Vector vItems=MedwanQuery.getInstance().getItemsLike(MedwanQuery.getInstance().getServerId(), Integer.parseInt(item.split(";")[11]), missingItem.attributeValue("itemtype"));
									if(vItems.size()>0){									
										bExists=true;
										break;
									}
								}
								if(bExists){
									continue;
								}
							}
							patientrecords.add(item.split(";")[0]);
						}
					}
				}
			}
		}
	}
	
	private void exportDiagnosisDatasetSeries(Vector items,Element dataset,String attributeOptionComboUid,String categoryOptionUid, DataValueSet dataValueSet){
		//Set diagnosis specific attributes
		//We already have the attributeOptionCombo uid and categoryOptionCombo uid
		//We only have to calculate the values now, based on the extra attributes
		//Now we must also match the code of each diagnosis on a dataelement code from the dataset
		Hashtable targetcodes = new Hashtable();
		Hashtable uidcounters = new Hashtable();
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Element dataelement = (Element)i.next();
			for(int n=0;n<dataelement.attributeValue("code").toLowerCase().split(",").length;n++){
				targetcodes.put(dataelement.attributeValue("code").toLowerCase().split(",")[n], dataelement.attributeValue("uid"));
			}
			if(MedwanQuery.getInstance().getConfigInt("sendFullDHIS2DataSets",0)==1){
				uidcounters.put(dataelement.attributeValue("uid"), new Double(0));
			}
		}
		boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
		boolean bNewcase = ScreenHelper.checkString(dataset.attributeValue("newcase")).equalsIgnoreCase("true");
		String sTransaction = ScreenHelper.checkString(dataset.attributeValue("transaction"));
		String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));

		HashSet encounterdiagnoses = new HashSet();
		HashSet patientdiagnoses = new HashSet();

		//We must calculate the total diagnosis weights of all diagnoses
		String classification = ScreenHelper.checkString(dataset.attributeValue("classification")).toLowerCase();
		Hashtable encounterbod = new Hashtable();
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(classification==null || classification.equalsIgnoreCase(item.split(";")[4])){
				if(encounterdiagnoses.contains(item.split(";")[1]+"."+item.split(";")[5])){
					continue;
				}
				else{
					encounterdiagnoses.add(item.split(";")[1]+"."+item.split(";")[5]);
				}
				if(!bMortality || item.split(";")[8].startsWith("dead")){
					if(bMortality){
						if(patientdiagnoses.contains(item.split(";")[0]+"."+item.split(";")[5])){
							continue;
						}
						else{
							patientdiagnoses.add(item.split(";")[0]+"."+item.split(";")[5]);
						}
					}
					if(!bNewcase || item.split(";")[9].equalsIgnoreCase("1")){
						if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[11]).equalsIgnoreCase(sEncounterType)){
							if(sTransaction.length()==0 || MedwanQuery.getInstance().getTransactionType(ScreenHelper.checkString(item.split(";")[12])).equalsIgnoreCase(sTransaction)){
								if(encounterbod.get(item.split(";")[1])==null){
									encounterbod.put(item.split(";")[1], Integer.parseInt(item.split(";")[10]));
								}
								else{
									encounterbod.put(item.split(";")[1],((Integer)encounterbod.get(item.split(";")[1]))+Integer.parseInt(item.split(";")[10]));
								}
							}
						}
					}
				}
			}
		}
		encounterdiagnoses = new HashSet();
		patientdiagnoses = new HashSet();
		for(int n=0;n<items.size();n++){
			String item = (String)items.elementAt(n);
			if(classification==null || classification.equalsIgnoreCase(item.split(";")[4])){
				if(encounterdiagnoses.contains(item.split(";")[1]+"."+item.split(";")[5])){
					continue;
				}
				else{
					encounterdiagnoses.add(item.split(";")[1]+"."+item.split(";")[5]);
				}
				if(!bMortality || item.split(";")[8].startsWith("dead")){
					if(bMortality){
						if(patientdiagnoses.contains(item.split(";")[0]+"."+item.split(";")[5])){
							continue;
						}
						else{
							patientdiagnoses.add(item.split(";")[0]+"."+item.split(";")[5]);
						}
					}
					if(!bNewcase || item.split(";")[9].equalsIgnoreCase("1")){
						if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[11]).equalsIgnoreCase(sEncounterType)){
							if(sTransaction.length()==0 || MedwanQuery.getInstance().getTransactionType(ScreenHelper.checkString(item.split(";")[12])).equalsIgnoreCase(sTransaction)){
								//First find a matching targetcode
								String code = item.split(";")[5].toLowerCase();
								String match=null;
								while(code.length()>0){
									match = (String)targetcodes.get(code);
									if(match!=null || code.length()==1){
										break;
									}
									code=code.substring(0,code.length()-1);	
								}
								if(match==null){
									match=(String)targetcodes.get("other");
								}
								if(match!=null){
									double value=1;
									if(bMortality){
										//******************************************
										//Mortality is distributed over all diagnoses according to their weight
										//******************************************
										double diagnosisweight=Double.parseDouble(item.split(";")[10]);
										double encounterweight=new Double((Integer)encounterbod.get(item.split(";")[1]));
										value=diagnosisweight/encounterweight;
									}
									if(uidcounters.get(match)==null){
										uidcounters.put(match, value);
									}
									else{
										uidcounters.put(match,(Double)uidcounters.get(match)+value);
									}
								}
							}
						}
					}
				}
			}
		}
		i = uidcounters.keySet().iterator();
		while(i.hasNext()){
			String uid=(String)i.next();
			if(MedwanQuery.getInstance().getConfigInt("cleanDHIS2DataSets",0)==0 && (Double)uidcounters.get(uid)>0){
				dataValueSet.getDataValues().add(new DataValue(uid,categoryOptionUid,new Double(Math.ceil((Double)uidcounters.get(uid))).intValue()+"",""));
			}
			else{
				System.out.println("adding empty "+uid+" - "+categoryOptionUid);
				dataValueSet.getDataValues().add(new DataValue(uid,categoryOptionUid," ",""));
			}
		}
	}
	
	private void exportDiagnosisDatasetSeriesRecords(Vector items,Element dataset,String dataelementuid){
		//Set diagnosis specific attributes
		//We already have the attributeOptionCombo uid and categoryOptionCombo uid
		//We only have to calculate the values now, based on the extra attributes
		//Now we must also match the code of each diagnosis on a dataelement code from the dataset
		Iterator i = dataset.element("dataelements").elementIterator("dataelement");
		while(i.hasNext()){
			Element dataelement = (Element)i.next();
			if(dataelement.attributeValue("uid").equals(dataelementuid)){
				Hashtable targetcodes = new Hashtable();
				Iterator id = dataset.element("dataelements").elementIterator("dataelement");
				while(id.hasNext()){
					Element de = (Element)id.next();
					if(de.attributeValue("uid").equals(dataelementuid)){
						for(int n=0;n<de.attributeValue("code").toLowerCase().split(",").length;n++){
							targetcodes.put(de.attributeValue("code").toLowerCase().split(",")[n], de.attributeValue("uid"));
						}
					}	
				}
				boolean bMortality = ScreenHelper.checkString(dataset.attributeValue("mortality")).equalsIgnoreCase("true");
				boolean bNewcase = ScreenHelper.checkString(dataset.attributeValue("newcase")).equalsIgnoreCase("true");
				String sTransaction = ScreenHelper.checkString(dataset.attributeValue("transaction"));
				String sEncounterType = ScreenHelper.checkString(dataset.attributeValue("encountertype"));
				String classification = ScreenHelper.checkString(dataset.attributeValue("classification")).toLowerCase();
				for(int n=0;n<items.size();n++){
					String item = (String)items.elementAt(n);
					if(classification==null || classification.equalsIgnoreCase(item.split(";")[4])){
						if(!bMortality || item.split(";")[8].startsWith("dead")){
							if(!bNewcase || item.split(";")[9].equalsIgnoreCase("1")){
								if(sEncounterType.length()==0 || ScreenHelper.checkString(item.split(";")[11]).equalsIgnoreCase(sEncounterType)){
									if(sTransaction.length()==0 || MedwanQuery.getInstance().getTransactionType(ScreenHelper.checkString(item.split(";")[12])).equalsIgnoreCase(sTransaction)){
										//First find a matching targetcode
										String code = item.split(";")[5].toLowerCase();
										String match=null;
										while(code.length()>0){
											match = (String)targetcodes.get(code);
											if(match!=null || code.length()==1){
												break;
											}
											code=code.substring(0,code.length()-1);	
										}
										if(match!=null){
											patientrecords.add(item.split(";")[0]);
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	private Vector loadDiagnoses(){
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select personid,oc_encounter_begindate,oc_encounter_enddate,oc_diagnosis_encounteruid,gender,dateofbirth,oc_diagnosis_codetype,oc_diagnosis_code,oc_diagnosis_serviceuid,oc_diagnosis_flags,oc_encounter_outcome,oc_diagnosis_nc,oc_diagnosis_gravity,oc_encounter_type,oc_diagnosis_referenceuid"
							+ " from adminview a,oc_encounters b,oc_diagnoses c"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " b.oc_encounter_serverid"+MedwanQuery.getInstance().concatSign()+"'.'"+MedwanQuery.getInstance().concatSign()+"b.oc_encounter_objectid=c.oc_diagnosis_encounteruid and"
							+ " (oc_encounter_enddate>=? and oc_encounter_begindate<?)";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				int gravity = Integer.parseInt(rs.getString("oc_diagnosis_gravity"));
				if(gravity==0){
					gravity=1;
				}
				try{
					String item = rs.getString("personid")+";"
							+rs.getString("oc_diagnosis_encounteruid")+";"
							+rs.getString("gender")+";"
							+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
							+rs.getString("oc_diagnosis_codetype")+";"
							+rs.getString("oc_diagnosis_code")+";"
							+(rs.getString("oc_diagnosis_serviceuid")+";").toLowerCase()
							+rs.getString("oc_diagnosis_flags")+";"
							+rs.getString("oc_encounter_outcome")+";"
							+rs.getString("oc_diagnosis_nc")+";"
							+gravity+";"
							+rs.getString("oc_encounter_type")+";"
							+rs.getString("oc_diagnosis_referenceuid")+";"
							+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_begindate"))+";"
							+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_enddate"))+";";
					Debug.println(item);
					items.add(item);
				}
				catch(Exception o){
					o.printStackTrace();
				}
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	private Vector loadEncounters(){
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select personid,gender,dateofbirth,oc_encounter_begindate,oc_encounter_enddate,oc_encounter_outcome,"
							+ " oc_encounter_type,oc_encounter_origin,oc_encounter_objectid,oc_encounter_serviceuid,oc_encounter_situation"
							+ " from adminview a,oc_encounters_view b"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " a.dateofbirth>'1900-01-01' and"
							+ " (oc_encounter_enddate>=? and oc_encounter_begindate<?)";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String item = rs.getString("personid")+";"
						+rs.getString("oc_encounter_objectid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+(rs.getString("oc_encounter_serviceuid")+";").toLowerCase()
						+rs.getString("oc_encounter_outcome")+";"
						+rs.getString("oc_encounter_type")+";"
						+rs.getString("oc_encounter_origin")+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_begindate"))+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_enddate"))+";"
						+rs.getString("oc_encounter_situation")+";"
						+"x;";
				Debug.println(item);
				items.add(item);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	
	private Vector loadLastEncounters(){
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select personid,gender,dateofbirth,oc_encounter_begindate,oc_encounter_enddate,oc_encounter_startdate,oc_encounter_outcome,"
							+ " oc_encounter_type,oc_encounter_origin,oc_encounter_objectid,oc_encounter_serviceuid,oc_encounter_situation"
							+ " from adminview a, (select * from oc_encounters_view a where oc_encounter_enddate>=? and oc_encounter_begindate<? and "
							+ " oc_encounter_begindate = (select max(oc_encounter_servicebegindate) from"
							+ " oc_encounter_services where oc_encounter_serverid=a.oc_encounter_serverid and oc_encounter_objectid=a.oc_encounter_objectid)"
							+ " ) b"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " a.dateofbirth>'1900-01-01'";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String item = rs.getString("personid")+";"
						+rs.getString("oc_encounter_objectid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+(rs.getString("oc_encounter_serviceuid")+";").toLowerCase()
						+rs.getString("oc_encounter_outcome")+";"
						+rs.getString("oc_encounter_type")+";"
						+rs.getString("oc_encounter_origin")+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_startdate"))+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_enddate"))+";"
						+rs.getString("oc_encounter_situation")+";";
				Debug.println(item);
				items.add(item);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	
	private Vector loadTechnicalActivities(){
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select personid,gender,dateofbirth,oc_encounter_begindate,oc_encounter_enddate,oc_encounter_outcome,"
							+ "oc_encounter_type,oc_encounter_origin,oc_encounter_objectid,oc_debet_serviceuid,oc_prestation_dhis2code"
							+ " from adminview a,oc_encounters b,oc_debets c,oc_prestations d"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " b.oc_encounter_objectid=replace(oc_debet_encounteruid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " (oc_debet_date>=? and oc_debet_date<?) and"
							+ " oc_prestation_objectid=replace(oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','') and"
							+ " oc_prestation_dhis2code is not null and"
							+ " oc_prestation_dhis2code<>''";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String item = rs.getString("personid")+";"
						+rs.getString("oc_encounter_objectid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+(rs.getString("oc_debet_serviceuid")+";").toLowerCase()
						+rs.getString("oc_encounter_outcome")+";"
						+rs.getString("oc_encounter_type")+";"
						+rs.getString("oc_encounter_origin")+";"
						+rs.getString("oc_prestation_dhis2code")+";";
				Debug.println(item);
				items.add(item);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	
	private Vector loadItems(Element dataset){
		String minval=ScreenHelper.checkString(dataset.attributeValue("itemValueMin"));
		String maxval=ScreenHelper.checkString(dataset.attributeValue("itemValueMax"));
		String matchval=ScreenHelper.checkString(dataset.attributeValue("itemValue"));
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select a.personid,gender,dateofbirth,oc_encounter_begindate,oc_encounter_enddate,oc_encounter_outcome,"
							+ " oc_encounter_type,oc_encounter_origin,oc_encounter_objectid,(select max(oc_encounter_serviceuid) from oc_encounters_view where oc_encounter_serverid=b.oc_encounter_serverid and oc_encounter_objectid=b.oc_encounter_objectid and convert(oc_encounter_startdate,date)<=convert(d.updatetime,date) and convert(oc_encounter_enddate,date)>=convert(d.updatetime,date)) as oc_encounter_serviceuid,e.value,e.type,e.serverid,"
							+ " e.transactionid,oc_encounter_situation,oc_encounter_begindate,oc_encounter_enddate"
							+ " from adminview a,oc_encounters b,healthrecord c,transactions d, items e, items f"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " (d.updatetime>=? and d.updatetime<?) and"
							+ " c.personid=b.oc_encounter_patientuid and"
							+ " c.healthrecordid=d.healthrecordid and"
							+ " d.transactiontype like ? and"
							+ " e.serverid=d.serverid and"
							+ " e.transactionid=d.transactionid and"
							+ " e.type like ? and"
							+ " f.serverid=d.serverid and"
							+ " f.transactionid=d.transactionid and"
							+ " f.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and"
							+ " b.oc_encounter_objectid=replace(f.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			if(ScreenHelper.checkString(dataset.attributeValue("exacttransactiontype")).equalsIgnoreCase("1")){
				ps.setString(3, ScreenHelper.checkString(dataset.attributeValue("transactiontype")));
			}
			else{
				ps.setString(3, ScreenHelper.checkString(dataset.attributeValue("transactiontype"))+"%");
			}
			if(ScreenHelper.checkString(dataset.attributeValue("exactitemtype")).equalsIgnoreCase("1")){
				ps.setString(4, ScreenHelper.checkString(dataset.attributeValue("itemtype")));
			}
			else{
				ps.setString(4, ScreenHelper.checkString(dataset.attributeValue("itemtype"))+"%");
			}
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String item = rs.getString("personid")+";"
						+rs.getString("oc_encounter_objectid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+(rs.getString("oc_encounter_serviceuid")+";").toLowerCase()
						+rs.getString("oc_encounter_outcome")+";"
						+rs.getString("oc_encounter_type")+";"
						+rs.getString("oc_encounter_origin")+";"
						+rs.getString("value").replaceAll(";", "{semicolon}")+";"
						+rs.getString("type")+";"
						+rs.getString("serverid")+";"
						+rs.getString("transactionid")+";"
						+rs.getString("oc_encounter_situation")+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_begindate"))+";"
						+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_enddate")==null?new java.util.Date():rs.getTimestamp("oc_encounter_enddate"))+";";
				Debug.println(item);
				if(minval.length()>0){
					try{
						if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])<Double.parseDouble(minval)){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(maxval.length()>0){
					try{
						if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])>Double.parseDouble(maxval)){
							continue;
						}
					}
					catch(Exception e){
						continue;
					}
				}
				if(matchval.length()>0 && !matchval.equalsIgnoreCase(item.split(";")[8])){
					continue;
				}
				items.add(item);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	
	private Vector loadLastTransactionItems(Element dataset){
		String minval=ScreenHelper.checkString(dataset.attributeValue("itemValueMin"));
		String maxval=ScreenHelper.checkString(dataset.attributeValue("itemValueMax"));
		String matchval=ScreenHelper.checkString(dataset.attributeValue("itemValue"));
		String transactionolderthandays = ScreenHelper.checkString(dataset.attributeValue("transactionolderthandays"));
		java.util.Date dTransactionsValidBefore=end;
		if(transactionolderthandays.length()>0) {
			dTransactionsValidBefore=new java.util.Date(dTransactionsValidBefore.getTime()-Integer.parseInt(transactionolderthandays)*ScreenHelper.getTimeDay());
		}
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
            String et = "'unknown'";
            String[] etypes = ScreenHelper.checkString(dataset.attributeValue("considertransactiontypes")).split(";");
            for(int n=0;n<etypes.length;n++) {
            	if(etypes[n].length()>0) {
            		et+=",'"+etypes[n]+"'";
            	}
            }
            String rt = "'unknown'";
            String[] rtypes = ScreenHelper.checkString(dataset.attributeValue("accepttransactiontypes")).split(";");
            for(int n=0;n<rtypes.length;n++) {
            	if(rtypes[n].length()>0) {
            		rt+=",'"+rtypes[n]+"'";
            	}
            }
			String sSql = 	"select a.personid,gender,dateofbirth,oc_encounter_begindate,oc_encounter_enddate,'dead' as oc_encounter_outcome,"
							+ " oc_encounter_type,oc_encounter_origin,oc_encounter_objectid,(select max(oc_encounter_serviceuid) from oc_encounters_view where oc_encounter_serverid=b.oc_encounter_serverid and oc_encounter_objectid=b.oc_encounter_objectid and convert(oc_encounter_startdate,date)<=convert(d.updatetime,date) and convert(oc_encounter_enddate,date)>=convert(d.updatetime,date)) as oc_encounter_serviceuid,e.value,e.type,e.serverid,"
							+ " e.transactionid,oc_encounter_situation,oc_encounter_begindate,oc_encounter_enddate,d.updatetime"
							+ " from adminview a,oc_encounters b,healthrecord c, items e, items f, ("
							+ " select t.serverid,t.transactionid,t.updatetime,t.healthrecordid from transactions t,("
							+ " select max(transactionid) transactionid,healthrecordid from transactions where updatetime<? and transactiontype in ("+et+")"
							+ " group by healthrecordid) q"
							+ " where t.transactionid=q.transactionid and t.healthrecordid=q.healthrecordid and transactiontype in ("+rt+")"
							+ " ) d"
							+ " where"
							+ " a.personid=b.oc_encounter_patientuid and"
							+ " c.personid=b.oc_encounter_patientuid and"
							+ " c.healthrecordid=d.healthrecordid and"
							+ " e.serverid=d.serverid and"
							+ " e.transactionid=d.transactionid and"
							+ " e.type like ? and"
							+ " f.serverid=d.serverid and"
							+ " f.transactionid=d.transactionid and"
							+ " f.type='be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID' and"
							+ " b.oc_encounter_objectid=replace(f.value,'"+MedwanQuery.getInstance().getConfigString("serverId")+".','')";
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(end.getTime()));
			if(ScreenHelper.checkString(dataset.attributeValue("exactitemtype")).equalsIgnoreCase("1")){
				ps.setString(2, ScreenHelper.checkString(dataset.attributeValue("itemtype")));
			}
			else{
				ps.setString(2, ScreenHelper.checkString(dataset.attributeValue("itemtype"))+"%");
			}
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				if(!rs.getTimestamp("updatetime").after(dTransactionsValidBefore)) {
					String item = rs.getString("personid")+";"
							+rs.getString("oc_encounter_objectid")+";"
							+rs.getString("gender")+";"
							+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
							+(rs.getString("oc_encounter_serviceuid")+";").toLowerCase()
							+rs.getString("oc_encounter_outcome")+";"
							+rs.getString("oc_encounter_type")+";"
							+rs.getString("oc_encounter_origin")+";"
							+rs.getString("value").replaceAll(";", "{semicolon}")+";"
							+rs.getString("type")+";"
							+rs.getString("serverid")+";"
							+rs.getString("transactionid")+";"
							+rs.getString("oc_encounter_situation")+";"
							+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_begindate"))+";"
							+new SimpleDateFormat("yyyyMMddHHmm").format(rs.getTimestamp("oc_encounter_enddate")==null?new java.util.Date():rs.getTimestamp("oc_encounter_enddate"))+";";
					Debug.println(item);
					if(minval.length()>0){
						try{
							if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])<Double.parseDouble(minval)){
								continue;
							}
						}
						catch(Exception e){
							continue;
						}
					}
					if(maxval.length()>0){
						try{
							if(item.split(";")[8].length()==0 || Double.parseDouble(item.split(";")[8])>Double.parseDouble(maxval)){
								continue;
							}
						}
						catch(Exception e){
							continue;
						}
					}
					if(matchval.length()>0 && !matchval.equalsIgnoreCase(item.split(";")[8])){
						continue;
					}
					items.add(item);
				}
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
	
	private Vector loadLab(Element dataset){
		String abnormal=ScreenHelper.checkString(dataset.attributeValue("abnormal"));
		String normal=ScreenHelper.checkString(dataset.attributeValue("normal"));
		Vector items = new Vector();
		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			String sSql = 	"select a.personid,gender,dateofbirth,c.dhis2code,b.serverid,b.transactionid"
							+ " from adminview a,requestedlabanalyses b,labanalysis c"
							+ " where"
							+ " a.personid=b.patientid and"
							+ " b.resultuserid is not null and"
							+ " (b.resultdate>=? and b.resultdate<?) and"
							+ " b.analysiscode=c.labcode and"
							+ " c.dhis2code is not null and"
							+ " c.dhis2code <> ''";
			if(abnormal.equals("1")){
				sSql+=	" and ((c.editor='numeric' and (b.resultvalue*1<b.resultrefmin*1 or b.resultvalue>b.resultrefmax*1))"
						+ " or b.resultvalue=c.alertvalue)";
			}
			else if(normal.equals("1")){
				sSql+=	" and (c.editor='numeric' and b.resultvalue*1>=b.resultrefmin*1 and b.resultvalue<=b.resultrefmax*1"
						+ " and b.resultvalue<>c.alertvalue)";
			}
			PreparedStatement ps = conn.prepareStatement(sSql);
			ps.setDate(1, new java.sql.Date(begin.getTime()));
			ps.setDate(2, new java.sql.Date(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String item = rs.getString("personid")+";"
						+rs.getString("gender")+";"
						+ScreenHelper.formatDate(rs.getDate("dateofbirth"))+";"
						+rs.getString("dhis2code")+";"
						+rs.getString("serverid")+";"
						+rs.getString("transactionid")+";";
				Debug.println(item);
				items.add(item);
			}
			rs.close();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			try{
				conn.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return items;
	}
}
