package ocdhis2;

import java.io.File;
import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.SortedMap;
import java.util.TreeMap;

import javax.servlet.jsp.JspWriter;
import javax.ws.rs.core.Response;
import javax.xml.bind.JAXBException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.ScreenHelper;

public class DHIS2Helper {
	public static String activeDataSet="";
	public static String activeAttribute="";
	public static boolean bSuccess=true;
	public static String sError="";
	public static boolean bColumnsDrawn=false;

	
	public static void export(){
		export(new java.util.Date());
	}
	public static void export(java.util.Date date){
		//Exports dhis2 extracts for previous month
		export(ScreenHelper.getPreviousMonthBegin(date),ScreenHelper.getPreviousMonthEnd(date));
	}

	public static void export(java.util.Date begin, java.util.Date end){
		try{
			DHIS2Exporter exporter = new DHIS2Exporter();
			exporter.setBegin(begin);
			exporter.setEnd(end);
			exporter.setDhis2document(MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml"));
			exporter.export(MedwanQuery.getInstance().getConfigString("dhis2ExportTarget","dhis2server"));
		}
		catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static void sendToServer(DataValueSet dataValueSet,String dataSetName){
		sendToServer(dataValueSet,dataSetName,null);
	}
	
	public static DataValueSet cleanDataValueSet(DataValueSet dataValueSet) {
		ArrayList<DataValue> dataValues = dataValueSet.getDataValues();
		for(int n=0;n<dataValues.size();n++) {
			DataValue dataValue = dataValues.get(n);
			dataValue.setCategoryOptionComboID(dataValue.getCategoryOptionComboID().split(";")[0].split("-")[0]);
			dataValue.setDataElementID(dataValue.getDataElementID().split(";")[0].split("-")[0]);
		}
		return dataValueSet;
	}
	
	public static void sendToServer(DataValueSet dataValueSet,String dataSetName, JspWriter jspWriter){
		String DHIS2_SERVER_URI = MedwanQuery.getInstance().getConfigString("dhis2_server_uri","https://dhis.snis.bi");
		String DHIS2_SERVER_BASE_API = MedwanQuery.getInstance().getConfigString("dhis2_server_api","/api");
		String DHIS2_SERVER_PORT = MedwanQuery.getInstance().getConfigString("dhis2_server_port","443");
		String OC_DHIS2_USER_NAME = MedwanQuery.getInstance().getConfigString("dhis2_server_username","fverbeke");
		String OC_DHIS2_USER_PWD = MedwanQuery.getInstance().getConfigString("dhis2_server_pwd","nopass");
        DHIS2Server server = new DHIS2Server(DHIS2_SERVER_URI, DHIS2_SERVER_BASE_API, DHIS2_SERVER_PORT);
		try {
			if(jspWriter!=null){
				jspWriter.print("Transmitting <b>"+dataValueSet.toXMLString().length()+" bytes</b> for data set <b>["+dataSetName+"]</b> to "+DHIS2_SERVER_URI+"... <script>document.body.scrollTop = document.body.scrollHeight;</script>");
				jspWriter.flush();
			}
		} catch (IOException | JAXBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        server.setUserName(OC_DHIS2_USER_NAME);
        server.setUserPassword(OC_DHIS2_USER_PWD);
        
        try {
            System.out.println("Sending dataValueSet to DHIS2 server " + DHIS2_SERVER_URI);
            Response postResponse = server.sendToServer(cleanDataValueSet(dataValueSet));
            System.out.println("Status: " + postResponse.getStatus());
            System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
    		try {
    			if(jspWriter!=null){
	    			jspWriter.print("<b>"+postResponse.getStatusInfo().getReasonPhrase()+"</b><br/>");
	    			jspWriter.flush();
    			}
    		} catch (IOException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
            
            if(postResponse.hasEntity())
            {
                ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
                // elements of importSummary can also be read individually, and put on a feedback page for example
                // a feedback should be given especially if conflicts are reported
                System.out.println("Import summary: ");
                System.out.println(importSummary);
            }
            sError+="<p/><img src='"+MedwanQuery.getInstance().getConfigString("imageSource","")+"/_img/icons/icon_check.gif'> <b>"+dataSetName+": SUCCESS</b><br/>";
        }
        catch (Exception e)
        {
    		try {
    			if(jspWriter!=null){
	    			jspWriter.print("<b>ERROR</b><br/>");
	    			jspWriter.flush();
    			}
    		} catch (IOException e2) {
    			// TODO Auto-generated catch block
    			e2.printStackTrace();
    		}
            bSuccess=false;
            sError+="<p/><img onclick='if(document.getElementById(\"error."+dataValueSet.getDataSet()+"\").style.display==\"\"){document.getElementById(\"error."+dataValueSet.getDataSet()+"\").style.display=\"none\";}else{document.getElementById(\"error."+dataValueSet.getDataSet()+"\").style.display=\"\";};' src='"+MedwanQuery.getInstance().getConfigString("imageSource","")+"/_img/icons/icon_error.gif'> <b>"+dataSetName+": <font color='red'>"+e.getMessage()+" [<i>"+ScreenHelper.getTranNoLink("dhis2error",e.getMessage().hashCode()+"","en")+"</i>]</font></b><span id='error."+dataValueSet.getDataSet()+"' style='display:none'><br/>";
            StackTraceElement[] trace = e.getStackTrace();
            for(int n=0;n<trace.length;n++){
            	sError+="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+trace[n].toString()+"<br/>";
            }
            sError+="</span><br/>";
            e.printStackTrace();
        }
	}
	
	public static StringBuffer toHtml(DataValueSet dataValueSet,String type,String language,String dataSetLabel){
		MedwanQuery.getInstance().setConfigString("sendFullDHIS2DataSets", "0");
		StringBuffer html = new StringBuffer();
		if(type.equalsIgnoreCase("default")){
			HashSet hNoLinks = getDataElementNolinks();
			try {
				Document document = DocumentHelper.parseText(dataValueSet.toXMLString());
				Element root = document.getRootElement();
				List cols=getDataSetColumns(root.attributeValue("dataSet"),dataSetLabel);
				int columns = 0;
				if(cols!=null){
					columns = cols.size();
				}
				String dataSetType=getDataSetType(root.attributeValue("dataSet"),dataSetLabel);
				Debug.println("Dataset Type = "+dataSetType);
				String dataSetMissing=getDataSetMissing(root.attributeValue("dataSet"),dataSetLabel);
				Debug.println("Dataset Missing = "+dataSetMissing);
				//Verzamel alle datasets
				SortedMap results = new TreeMap();
				Iterator iCols=root.elementIterator("dataValue");
				while(iCols.hasNext()){
					Element r = (Element)iCols.next();
					String sLine="";
					if(dataSetType.equalsIgnoreCase("pharmacy") && !dataSetMissing.equalsIgnoreCase("1")) {
						sLine=getDataElementName(root.attributeValue("dataSet"), r.attributeValue("dataElement"), language,dataSetLabel)+";"+getDataElementCode(root.attributeValue("dataSet"), r.attributeValue("dataElement"), language,dataSetLabel)+";"+r.attributeValue("categoryOptionCombo");
					}
					else {
						sLine=getDataElementName(root.attributeValue("dataSet"), r.attributeValue("dataElement"), language,dataSetLabel)+";"+r.attributeValue("dataElement")+";"+r.attributeValue("categoryOptionCombo");
					}
					results.put(sLine, r.attributeValue("value"));
					Debug.println(sLine);
				}

				String attribute=getAttributeOptionComboName(root.attributeValue("dataSet"),root.attributeValue("attributeOptionCombo"),dataSetLabel);
				String title=getDataSetTitle(root.attributeValue("dataSet"),dataSetLabel)+"."+ScreenHelper.checkString(root.attributeValue("attributeOptionCombo"));
				Debug.println("dataSetLabel="+dataSetLabel);
				Debug.println("title="+title);
				Debug.println("activedataset="+activeDataSet);
				Debug.println("attribute="+attribute);
				Debug.println("activeattribute="+activeAttribute);
				if(!activeDataSet.equals(title) || !activeAttribute.equalsIgnoreCase(attribute)){
					Debug.println("title<>activeDataSet");
					if(html.toString().indexOf("table")>-1){
						html.append("</table><p/>");
					}
					if(!activeDataSet.startsWith(getDataSetTitle(root.attributeValue("dataSet"),dataSetLabel))){
						Debug.println("printing title");
						//Print titel en dienst
						html.append("<table width='100%'><tr class='admin'><td colspan='"+(1+columns)+"'>"+getDataSetTitle(root.attributeValue("dataSet"),dataSetLabel)+"</td></tr>");
						bColumnsDrawn=false;
					}
					if((!bColumnsDrawn || !activeAttribute.equalsIgnoreCase(attribute)) && results.size()>0){
						//Plaats de kolomtitels
						Debug.println("printing columns");
						html.append("<tr class='admin'><td>"+attribute+"</td>");
						if(cols!=null && cols.size()>0){
							Iterator ic = cols.iterator();
							while(ic.hasNext()){
								Element column = (Element)ic.next();
								html.append("<td><center>"+column.attributeValue("name")+"</center></td>");
							}
						}
						html.append("</tr>");
						bColumnsDrawn=true;
						activeAttribute=attribute;
					}
				}

				String activeDataElement = "";
				iCols = results.keySet().iterator();
				while(iCols.hasNext()){
					int n=0;
					String key = (String)iCols.next();
					if(!activeDataElement.equalsIgnoreCase(key.split(";")[1])){
						//Print dataElement name
						html.append("<tr><td"+(n==0?(!dataSetMissing.equalsIgnoreCase("1") && dataSetType.equalsIgnoreCase("pharmacy")?" width='20%' ":" style='max-width:150px;overflow: hidden' "):"")+" class='admin'>"+key.split(";")[0]+" </td>");
						n++;
						//Vul nu in met de colommen
						if(cols!=null && cols.size()>0){
							Iterator ico = cols.iterator();
							while(ico.hasNext()){
								Element column = (Element)ico.next();
								String val = (String)results.get(key.split(";")[0]+";"+key.split(";")[1]+";"+column.attributeValue("uid"));
								Debug.println("Searching for val "+key.split(";")[0]+";"+key.split(";")[1]+";"+column.attributeValue("uid"));
								if(hNoLinks.contains(key.split(";")[1])){
									Debug.println("Found nolink!");
									html.append("<td class='admin2'><center><b>"+(val==null?"":val)+"</b></center></td>");
								}
								else{
									Debug.println("Setting link");
									html.append("<td class='admin2'><center><b><a href=\"javascript:showRecords('"+root.attributeValue("dataSet")+"','"+key.split(";")[1]+"','"+column.attributeValue("uid")+"','"+root.attributeValue("attributeOptionCombo")+"')\">"+(val==null?"":val)+"</a></b></center></td>");
								}
							}
						}
						html.append("</tr>");
						activeDataElement=key.split(";")[1];
					}
				}
				if(title.split("\\.").length>0 &&  title.split("\\.")[0].length()>0 && !activeDataSet.equals(title)){
					activeDataSet=title;
				}
			} catch (DocumentException | JAXBException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(html.length()==0) {
			html.append("<table width='100%'><tr><td class='admin'>"+ScreenHelper.getTranNoLink("web","nodhis2data",language)+"</td></tr></table>");
		}
		return html;
	}
	
	public static String getDataSetTitle(String uid,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if((activeDataSet.length()==0 || !activeDataSet.startsWith(dataSetLabel.split("\\|")[0]) || dataset.attributeValue("notitle")==null) && dataset.attributeValue("uid").equals(uid) && dataset.attributeValue("label").startsWith(dataSetLabel)){
					return ScreenHelper.checkString(dataset.attributeValue("label").split("\\|")[0]);
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getDataSetType(String uid,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if((activeDataSet.length()==0 || !activeDataSet.startsWith(dataSetLabel.split("\\|")[0]) || dataset.attributeValue("notitle")==null) && dataset.attributeValue("uid").equals(uid) && dataset.attributeValue("label").startsWith(dataSetLabel)){
					return ScreenHelper.checkString(dataset.attributeValue("type"));
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getDataSetMissing(String uid,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if((activeDataSet.length()==0 || !activeDataSet.startsWith(dataSetLabel.split("\\|")[0]) || dataset.attributeValue("notitle")==null) && dataset.attributeValue("uid").equals(uid) && dataset.attributeValue("label").startsWith(dataSetLabel)){
					return ScreenHelper.checkString(dataset.attributeValue("missing"));
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getDataElementName(String datasetuid, String uid,String language,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(datasetuid) && dataset.attributeValue("label").equals(dataSetLabel)){
					//This is the right dataset
					Iterator dataElements = dataset.element("dataelements").elementIterator("dataelement");
					while(dataElements.hasNext()){
						Element dataElement = (Element)dataElements.next();
						if(!ScreenHelper.checkString(dataset.attributeValue("missing")).equalsIgnoreCase("1") && dataset.attributeValue("type").equalsIgnoreCase("pharmacy")){
							Iterator parameters = dataElement.elementIterator("parameter");
							while(parameters.hasNext()) {
								Element parameter = (Element)parameters.next();
								if(parameter.attributeValue("uid").equals(uid)) {
									String name = ScreenHelper.checkString(dataElement.attributeValue("label"));
									return name;
								}
							}
						}
						else {
							if(dataElement.attributeValue("uid").equals(uid)){
								String name = ScreenHelper.checkString(dataElement.attributeValue("label"));
								if(name.length()==0){
									String tokens = ScreenHelper.checkString(dataElement.attributeValue("code"));
									if(tokens.split(",").length>1){
										if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
											name = tokens.split(",")[0]+"<img src='"+MedwanQuery.getInstance().getConfigString("imageSource","http://localhost/openclinic")+"/_img/icons/icon_info.gif' title='"+MedwanQuery.getInstance().getCodeTran("icd10code"+tokens.split(",")[0], language).replaceAll("'", "´")+"'/> ["+tokens.replaceAll(tokens.split(",")[0]+",", "")+"]";
										}
										else{
											name = tokens.split(",")[0]+" ["+tokens.replaceAll(tokens.split(",")[0]+",", "")+"]";
										}
									}
									else{
										if(dataset.attributeValue("type").equalsIgnoreCase("diagnosis")){
											name = tokens+"<img src='"+MedwanQuery.getInstance().getConfigString("imageSource","http://localhost/openclinic")+"/_img/icons/icon_info.gif' title='"+MedwanQuery.getInstance().getCodeTran("icd10code"+tokens, language).replaceAll("'", "´")+"'/>";
										}
										else{
											name=tokens;
										}
									}
								}
								if(name.length()==0){
									String tokens = ScreenHelper.checkString(dataElement.attributeValue("itemvalue"));
									if(tokens.split(",").length>1){
										name = tokens.split(",")[0]+" ["+tokens.replaceAll(tokens.split(",")[0]+",", "")+"]";
									}
									else{
										name=tokens;
									}
								}
								if(name.length()==0){
									name = ScreenHelper.checkString(dataElement.attributeValue("uid"));
								}
								return name;
							}
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static String getDataElementCode(String datasetuid, String uid,String language,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(datasetuid) && dataset.attributeValue("label").equals(dataSetLabel)){
					//This is the right dataset
					Iterator dataElements = dataset.element("dataelements").elementIterator("dataelement");
					while(dataElements.hasNext()){
						Element dataElement = (Element)dataElements.next();
						if(dataset.attributeValue("type").equalsIgnoreCase("pharmacy")){
							if(ScreenHelper.checkString(dataset.attributeValue("missing")).equalsIgnoreCase("1") && dataElement.attributeValue("uid").equals(uid)) {
								return ScreenHelper.checkString(dataElement.attributeValue("productcode"));
							}
							else {
								Iterator parameters = dataElement.elementIterator("parameter");
								while(parameters.hasNext()) {
									Element parameter = (Element)parameters.next();
									if(parameter.attributeValue("uid").equals(uid)) {
										String name = ScreenHelper.checkString(dataElement.attributeValue("productcode"));
										return name;
									}
								}
							}
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static HashSet getDataElementNolinks(){
		HashSet hNoLinks=new HashSet();
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.element("dataelements")!=null){
					Iterator dataElements = dataset.element("dataelements").elementIterator("dataelement");
					while(dataElements.hasNext()){
						Element dataElement = (Element)dataElements.next();
						if(ScreenHelper.checkString(dataElement.attributeValue("nolink")).equals("1")){
							if(!ScreenHelper.checkString(dataset.attributeValue("missing")).equalsIgnoreCase("1") && dataset.attributeValue("type").equalsIgnoreCase("pharmacy")) {
								Debug.println("Setting productcode nolink "+dataElement.attributeValue("productcode"));
								hNoLinks.add(dataElement.attributeValue("productcode"));
							}
							else {
								Debug.println("Setting uid nolink "+dataElement.attributeValue("uid"));
								hNoLinks.add(dataElement.attributeValue("uid"));
							}
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return hNoLinks;
	}
	
	public static String getAttributeOptionComboName(String datasetuid, String uid, String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common_xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(datasetuid) && dataset.attributeValue("label").equals(dataSetLabel)){
					//This is the right dataset
					Element attributeOptionCombo = dataset.element("attributeOptionCombo");
					if(attributeOptionCombo!=null){
						Iterator options = attributeOptionCombo.elementIterator("option");
						while(options.hasNext()){
							Element option = (Element)options.next();
							if(option.attributeValue("uid").equals(uid)){
								return option.attributeValue("name");
							}
						}
					}
				}
			} 
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return "";
	}
	
	public static List getDataSetColumns(String uid,String dataSetLabel){
		String dhis2document=MedwanQuery.getInstance().getConfigString("templateDirectory","/var/tomcat/webapps/openclinic/_common/xml")+"/"+MedwanQuery.getInstance().getConfigString("dhis2document","dhis2.bi.xml");
        SAXReader reader = new SAXReader(false);
        Document document;
		try {
			document = reader.read(new File(dhis2document));
			Element root = document.getRootElement();
			Iterator i = root.elementIterator("dataset");
			while(i.hasNext()){
				Element dataset = (Element)i.next();
				if(dataset.attributeValue("uid").equals(uid) && dataset.attributeValue("label").equals(dataSetLabel)){
					Element combo = dataset.element("categoryOptionCombo");
					List j = combo.elements("option");
					return j;
				}
			}
		} catch (DocumentException e) {
			e.printStackTrace();
		}
		return null;
	}
}
