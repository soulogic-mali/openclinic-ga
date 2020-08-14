package be.mxs.common.util.io;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Vector;

import org.apache.poi.util.DocumentHelper;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.finance.Debet;
import be.openclinic.finance.PatientCredit;
import be.openclinic.finance.PatientInvoice;

public class ExportAccounting {
	String delimiter="\"";
	String separator=";";
	boolean header = true;
	String newline="\n";
	Date start=null;
	
	public void export(Date start) throws DocumentException, IOException{
		this.start = start;
		SAXReader reader = new SAXReader(false);
        Document document = reader.read(new File(MedwanQuery.getInstance().getConfigString("accountingExportConfigFile","/var/tomcat/webapps/openclinic/_common/xml/accountingExport.xml")));
        Element root = document.getRootElement();
        Iterator exports = root.elementIterator("export");
        while(exports.hasNext()){
        	Element export = (Element)exports.next();
        	if(export.attributeValue("type").equalsIgnoreCase("patientsales")){
        		exportPatientSales(export);
        	}
        	else if(export.attributeValue("type").equalsIgnoreCase("patientpayments")){
        		exportPatientPayments(export);
        	}
        }
	}
	
	public BufferedWriter getWriter(Element export) throws IOException{
		Element file = export.element("format").element("file");
		String filename = 	file.elementText("folder")+"/"
							+file.element("name").elementText("prefix")
							+new SimpleDateFormat(file.element("name").elementText("format")).format(new java.util.Date())
							+file.element("name").elementText("suffix")
							+"."+file.elementText("extension");
		BufferedWriter bufferedWriter = new BufferedWriter(new FileWriter(filename));
		delimiter=export.element("format").elementText("delimiter");
		separator=export.element("format").elementText("separator");
		header=export.element("format").elementText("header").equalsIgnoreCase("true");
		newline="";
		if(export.element("format").element("newline").element("cr")!=null){
			newline+="\r";
		};
		if(export.element("format").element("newline").element("lf")!=null){
			newline+="\n";
		};
		return bufferedWriter;
	}
	
	public void writeHeader(BufferedWriter file,Element export) throws IOException{
		Element header = export.element("header");
		Iterator lines = header.elementIterator("line");
		while(lines.hasNext()){
			Element line = (Element)lines.next();
			Iterator columns = line.elementIterator("column");
			while(columns.hasNext()){
				Element column = (Element)columns.next();
				if(column.attributeValue("type").equalsIgnoreCase("label")){
					file.write(delimiter+column.getText()+delimiter+separator);
				}
			}
			file.write(newline);
		}
	}
	
	public void exportPatientPayments(Element export) throws IOException{
		Date maxdate = start;
		BufferedWriter file = getWriter(export);
		if(header){
			writeHeader(file,export);
		}
		java.sql.Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_patientcredits where oc_patientcredit_updatetime>? and oc_patientcredit_invoiceuid like '%.%' order by oc_patientcredit_updatetime");
			ps.setTimestamp(1, new java.sql.Timestamp(start.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				maxdate = rs.getTimestamp("oc_patientcredit_updatetime");
				PatientCredit credit = PatientCredit.get(rs.getInt("oc_patientcredit_serverid")+"."+rs.getInt("oc_patientcredit_objectid"));
				if(credit.getAmount()!=0){
					Element body = export.element("body");
					Iterator lines = body.elementIterator("line");
					while(lines.hasNext()){
						Element line = (Element)lines.next();
						
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		file.flush();
		file.close();
	}
	
	public void exportPatientSales(Element export) throws IOException{
		Date maxdate = start;
		BufferedWriter file = getWriter(export);
		if(header){
			writeHeader(file,export);
		}
		java.sql.Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("select * from oc_patientinvoices where oc_patientinvoice_updatetime>? and oc_patientinvoice_status='closed' order by oc_patientinvoice_updatetime");
			ps.setTimestamp(1, new java.sql.Timestamp(start.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				maxdate = rs.getTimestamp("oc_patientinvoice_updatetime");
				PatientInvoice invoice = PatientInvoice.get(rs.getInt("oc_patientinvoice_serverid")+"."+rs.getInt("oc_patientinvoice_objectid"));
				if((invoice.getPatientAmount()-invoice.getExtraInsurarAmount2())==0){
					continue;
				}
				Element body = export.element("body");
				Iterator lines = body.elementIterator("line");
				while(lines.hasNext()){
					Element line = (Element)lines.next();
					if(line.attributeValue("type").equalsIgnoreCase("patient")){
						Iterator columns = line.elementIterator("column");
						while(columns.hasNext()){
							Element column = (Element)columns.next();
							if(column.attributeValue("type").equalsIgnoreCase("label")){
								file.write(delimiter+column.getText()+delimiter+separator);
							}
							else if(column.attributeValue("type").equalsIgnoreCase("config")){
								if(column.attributeValue("datatype").equalsIgnoreCase("string")){
									file.write(delimiter+MedwanQuery.getInstance().getConfigString(column.getText(),column.attributeValue("default"))+delimiter+separator);
								}
							}
							else if(column.attributeValue("type").equalsIgnoreCase("object")){
								if(column.attributeValue("datatype").equalsIgnoreCase("date")){
									Date d = null;
									if(column.getText().equalsIgnoreCase("date")){
										d=invoice.getDate();
									}
									if(column.getText().equalsIgnoreCase("invoiceduedate")){
										long day = 24*3600*1000;
										int paymentdays = MedwanQuery.getInstance().getConfigInt("defaultPatientInvoiceCreditPeriod",30);
										d=new java.util.Date(invoice.getDate().getTime()+paymentdays*day);
									}
									file.write(delimiter+new SimpleDateFormat(column.attributeValue("format")).format(d)+delimiter+separator);
								}
								else if(column.attributeValue("datatype").equalsIgnoreCase("string")){
									if(column.getText().equalsIgnoreCase("invoiceuid")){
										file.write(delimiter+invoice.getUid()+delimiter+separator);
									}
									else if(column.getText().equalsIgnoreCase("invoiceamount")){
										file.write(delimiter+invoice.getPatientOwnAmount()+delimiter+separator);
									}
								}
							}
						}
						file.write(newline);
					}
					else if(line.attributeValue("type").equalsIgnoreCase("costcenter")){
						//Separate income in costcenters
						SortedMap invoicegroups = new TreeMap();
						Vector debets = invoice.getDebets();
						for(int n=0; n< debets.size(); n++){
							Debet debet = (Debet)debets.elementAt(n);
							if(debet.getAmount()!=0 || ScreenHelper.checkString(debet.getExtraInsurarUid2()).length()==0){
								if(invoicegroups.get(ScreenHelper.checkString(debet.getPrestation().getInvoiceGroup()))==null){
									invoicegroups.put(ScreenHelper.checkString(debet.getPrestation().getInvoiceGroup()), new Double(0));
								}
								invoicegroups.put(ScreenHelper.checkString(debet.getPrestation().getInvoiceGroup()), debet.getAmount()+(Double)invoicegroups.get(ScreenHelper.checkString(debet.getPrestation().getInvoiceGroup())));
							}
						}
						Iterator iInvoiceGroups = invoicegroups.keySet().iterator();
						while(iInvoiceGroups.hasNext()){
							String key = (String)iInvoiceGroups.next();
							if((Double)invoicegroups.get(key)!=0){
								Iterator columns = line.elementIterator("column");
								while(columns.hasNext()){
									Element column = (Element)columns.next();
									if(column.attributeValue("type").equalsIgnoreCase("label")){
										file.write(delimiter+column.getText()+delimiter+separator);
									}
									else if(column.attributeValue("type").equalsIgnoreCase("config")){
										if(column.attributeValue("datatype").equalsIgnoreCase("string")){
											file.write(delimiter+MedwanQuery.getInstance().getConfigString(column.getText(),column.attributeValue("default"))+delimiter+separator);
										}
									}
									else if(column.attributeValue("type").equalsIgnoreCase("object")){
										if(column.attributeValue("datatype").equalsIgnoreCase("date")){
											Date d = null;
											if(column.getText().equalsIgnoreCase("date")){
												d=invoice.getDate();
											}
											if(column.getText().equalsIgnoreCase("invoiceduedate")){
												long day = 24*3600*1000;
												int paymentdays = MedwanQuery.getInstance().getConfigInt("defaultPatientInvoiceCreditPeriod",30);
												d=new java.util.Date(invoice.getDate().getTime()+paymentdays*day);
											}
											file.write(delimiter+new SimpleDateFormat(column.attributeValue("format")).format(d)+delimiter+separator);
										}
										else if(column.attributeValue("datatype").equalsIgnoreCase("string")){
											if(column.getText().equalsIgnoreCase("invoiceuid")){
												file.write(delimiter+invoice.getUid()+delimiter+separator);
											}
											else if(column.getText().equalsIgnoreCase("invoicepartcostcenter")){
												file.write(delimiter+key+delimiter+separator);
											}
											else if(column.getText().equalsIgnoreCase("invoicepartcostcentername")){
												file.write(delimiter+ScreenHelper.getTranNoLink("accounting.invoicegroup",key,MedwanQuery.getInstance().getConfigString("defaultLanguage","fr"))+delimiter+separator);
											}
											else if(column.getText().equalsIgnoreCase("invoicepartamount")){
												file.write(delimiter+invoicegroups.get(key)+delimiter+separator);
											}
										}
									}
								}
								file.write(newline);
							}
						}
					}
				}
			}
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		file.flush();
		file.close();
	}
}
