package be.mxs.common.util.io;

import java.io.File;
import java.net.SocketTimeoutException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;

import javax.ws.rs.core.Response;

import ocdhis2.DHIS2Server;
import ocdhis2.DataValue;
import ocdhis2.DataValueSet;
import ocdhis2.ImportSummary;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class ExportDHIS2CausesOfDeath {

	public static void run(String[] args,String entity){
		try{
		    Class.forName("com.mysql.jdbc.Driver");	
		    Connection conn =  DriverManager.getConnection("jdbc:mysql://localhost:3306/ocstats_dbo?"+args[0]);
		    Connection connconf =  DriverManager.getConnection("jdbc:mysql://localhost:3306/openclinic_dbo?"+args[0]);
		    HashSet agesdataset = new HashSet();
		    HashSet gendersdataset = new HashSet();
		    //System.out.println("\n>>>>>>>>>>>>>>>>>>>> Sending Causes of Death per Age for entity "+entity);
		    sendAgesDataValueSet(args, agesdataset,entity);
		    //System.out.println("\n>>>>>>>>>>>>>>>>>>>> Sending Causes of Death per Gender for entity "+entity);
		    sendGenderDataValueSet(args, gendersdataset,entity);
		    
		    //Update dc_dhis2deathdiagnosisvalues table for the period of active dataset
		    Iterator iAges = agesdataset.iterator();
            while(iAges.hasNext()){
            	String activedataset = (String)iAges.next();
            	if(gendersdataset.contains(activedataset)){
	                PreparedStatement ps = conn.prepareStatement("update dc_dhis2deathdiagnosisvalues set dc_diagnosisvalue_dhis2exportdatetime=? where dc_diagnosisvalue_serverid=? and dc_diagnosisvalue_year=? and dc_diagnosisvalue_month=? and dc_diagnosisvalue_serviceuid=?");
	                ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
	    		    ps.setString(2, entity.split(";")[0]);
	    		    ps.setString(3, entity.split(";")[1]);
	    		    ps.setString(4, entity.split(";")[2]);
	    		    ps.setString(5, entity.split(";")[3]);
	                ps.execute();
	                ps.close();
            	}
            }

		    conn.close();
			connconf.close();

		} catch (Exception e) {
			e.printStackTrace();
		}		

	}

	public static void sendAgesDataValueSet(String[] args, HashSet ds,String entity){
		//Find date of last export
		try {
			StringBuffer exportfile = new StringBuffer();
			// This will load the MySQL driver, each DB has its own driver
		    Class.forName("com.mysql.jdbc.Driver");			
		    Connection conn =  DriverManager.getConnection("jdbc:mysql://localhost:3306/ocstats_dbo?"+args[0]);
		    Connection connconf =  DriverManager.getConnection("jdbc:mysql://localhost:3306/openclinic_dbo?"+args[0]);
		    
		    //**********************************
		    //Export causes of death (diagnoses)
		    //**********************************
		    
		    String sql = "select * from dc_dhis2deathdiagnosisvalues where dc_diagnosisvalue_dhis2exportdatetime is null and dc_diagnosisvalue_serverid=? and dc_diagnosisvalue_year=? and dc_diagnosisvalue_month=? and dc_diagnosisvalue_serviceuid=?";
		    PreparedStatement ps = conn.prepareStatement(sql);
		    ps.setString(1, entity.split(";")[0]);
		    ps.setString(2, entity.split(";")[1]);
		    ps.setString(3, entity.split(";")[2]);
		    ps.setString(4, entity.split(";")[3]);
		    ResultSet rs =ps.executeQuery();
		    String activedataset ="", dataset="";
		    
		    //Active DHIS2 configuration
		    //**************************
		    String dhis2_uri="";
		    String dhis2_api="";
		    String dhis2_port="";
		    String dhis2_user="";
		    String dhis2_password="";
		    String dhis2_datasetuid="";
		    Hashtable dhis2_agecategories=new Hashtable();
		    Hashtable dhis2_departments=new Hashtable();
		    Hashtable dhis2_diagnoses=new Hashtable();
		    Hashtable agesvalues = new Hashtable();
	        DataValueSet dataValueSet = new DataValueSet();


		    while(rs.next()){
		    	String month=rs.getString("dc_diagnosisvalue_month");
		    	if(month.length()<2){
		    		month="0"+month;
		    	}
		    	dataset = rs.getString("dc_diagnosisvalue_serverid")+"."+rs.getString("dc_diagnosisvalue_year")+"."+month+"."+rs.getString("dc_diagnosisvalue_serviceuid");
		    	if(!activedataset.equalsIgnoreCase(dataset)){
		    		if(activedataset.length()>0 && !getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop").equalsIgnoreCase("noop")){
		    			boolean bOk=true;
		    			//Prepare ages dataset for DHIS2-server
		    	        dataValueSet = new DataValueSet();
		    			dataValueSet.setDataSet(dhis2_datasetuid);
		    			dataValueSet.setOrgUnit(getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop"));
		    			dataValueSet.setPeriod(activedataset.split("\\.")[1]+activedataset.split("\\.")[2]);
		    			dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
		    			System.out.println("Sending data to DHIS2 server");
		    			System.out.println("orgunit = "+dataValueSet.getOrgUnit());
		    			System.out.println("Creating Ages CoC Data Set");
		    			System.out.println("activedataset = "+activedataset);
		    			System.out.println("departmentuid = "+checkString(activedataset.split("\\.")[3]));

		    			String departmentuid = (String)dhis2_departments.get(checkString(activedataset.split("\\.")[3]).toLowerCase());
		                if(departmentuid==null || departmentuid.length()==0){
		                	departmentuid=checkString((String)dhis2_departments.get("oth"));
		                }
		                dataValueSet.setAttributeOptionCombo(departmentuid);
		                //Add ages datavalues here
		                Enumeration datavalues = agesvalues.keys();
		                while(datavalues.hasMoreElements()){
		                	String key = (String)datavalues.nextElement();
		                    dataValueSet.getDataValues().add(new DataValue(key.split(";")[0],key.split(";")[1],(Integer)agesvalues.get(key)+"",""));
		                }
		                //Send ages dataset to DHIS2 server
		                DHIS2Server server = new DHIS2Server(dhis2_uri, dhis2_api, dhis2_port);
		                server.setUserName(dhis2_user);
		                server.setUserPassword(dhis2_password);
		                try {
		                	System.out.println("Sending dataset...");
		                	System.out.println("Payload: "+dataValueSet.toXMLString());
		                    Response postResponse = server.sendToServer(dataValueSet);
		                    System.out.println("Status: " + postResponse.getStatus());
		                    System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
		                    
		                    if(postResponse.hasEntity())
		                    {
		                        ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
		                        // elements of importSummary can also be read individually, and put on a feedback page for example
		                        // a feedback should be given especially if conflicts are reported
		                        System.out.println("Import summary: ");
		                        System.out.println(importSummary);
		                    }
		                    
		                }
		                catch (SocketTimeoutException e)
		                {
		                	bOk=false;
		                    e.printStackTrace();
		                }
		                if(bOk){
		                	ds.add(activedataset);
		                }
		    		}
		    		if(!activedataset.split("\\.")[0].equalsIgnoreCase(dataset.split("\\.")[0])){
		    			//Load DHIS2 configuration file for active orgunit
		    			String dhis2_configfile = getConfigValue(connconf, "datacenterDHIS2ConfigFile."+dataset.split("\\.")[0], "");
		    			if(dhis2_configfile.length()>0){
			    			System.out.println("Loading DHIS2 config file "+dhis2_configfile);
		    	            SAXReader reader = new SAXReader(false);
		    	            Document document = reader.read(new File(dhis2_configfile));
		    	            Element root = document.getRootElement();
		    	            Element config = root.element("config");
		    	            dhis2_uri=config.elementText("uri");
		    	            dhis2_api=config.elementText("api");
		    	            dhis2_port=config.elementText("port");
		    	            dhis2_user=config.elementText("user");
		    	            dhis2_password=config.elementText("password");

		    			    dhis2_agecategories=new Hashtable();
		    			    dhis2_departments=new Hashtable();
		    			    dhis2_diagnoses=new Hashtable();
		    			    Iterator datasets = root.elementIterator("dataset");
		    			    while(datasets.hasNext()){
			    			    Element dhis2_dataset = (Element)datasets.next();
			    			    if(dhis2_dataset.attributeValue("type").equalsIgnoreCase("deathdiagnosesbyage")){
			    			    	System.out.println("Loading dataset deathdiagnosesbyage");
				    			    dhis2_datasetuid = dhis2_dataset.attributeValue("uid");
				    	            Iterator categories = dhis2_dataset.elementIterator("category");
				    	            while (categories.hasNext()){
				    	            	Element category = (Element)categories.next();
				    	            	if(category.attributeValue("type").equalsIgnoreCase("age")){
					    			    	System.out.println("Loading CoC Ages");
				    	            		Iterator ages = category.elementIterator("option");
				    	            		while(ages.hasNext()){
				    	            			Element option = (Element)ages.next();
				    	            			dhis2_agecategories.put(option.attributeValue("min")+";"+option.attributeValue("max"), option.attributeValue("uid"));
				    	            		}
					    			    	System.out.println(dhis2_agecategories.size()+" CoC Ages loaded");
				    	            	}
				    	            	else if(category.attributeValue("type").equalsIgnoreCase("department")){
					    			    	System.out.println("Loading CoC Departments");
				    	            		Iterator departments = category.elementIterator("option");
				    	            		while(departments.hasNext()){
				    	            			Element option = (Element)departments.next();
				    	            			dhis2_departments.put(option.attributeValue("value"), option.attributeValue("uid"));
				    	            		}
					    			    	System.out.println(dhis2_departments.size()+" CoC Departments loaded");
				    	            	}
				    	            }
			    	            	Element dataelements = dhis2_dataset.element("dataelements");
			    	            	Iterator diagnoses = dataelements.elementIterator("dataelement");
			    	            	while(diagnoses.hasNext()){
			    	            		Element diagnosis = (Element)diagnoses.next();
			    	            		dhis2_diagnoses.put(diagnosis.attributeValue("code"),diagnosis.attributeValue("uid"));
			    	            	}
			    	            	break;
			    			    }
		    			    }
		    			}
		    		}
		    		activedataset = dataset;
				    agesvalues = new Hashtable();
		    	}
		    	//Find diagnosis uid
		    	String s=rs.getString("dc_diagnosisvalue_code");
		    	String diagnosis=checkString(s).toUpperCase();
		    	String diagnosisuid = (String)dhis2_diagnoses.get(diagnosis);
		    	while(diagnosisuid==null && diagnosis.length()>1){
		    		diagnosis=diagnosis.substring(0,diagnosis.length()-1);
		    		diagnosisuid = (String)dhis2_diagnoses.get(s);
		    	}
		    	if(diagnosisuid==null){
		    		diagnosis="000";
		    		diagnosisuid = (String)dhis2_diagnoses.get("000");
		    		logUnknownDiagnosis(conn, activedataset.split("\\.")[0], s, dataValueSet);
		    	}
		    	if(diagnosisuid!=null){
    				System.out.println("Found diagnosis code = "+diagnosisuid+ " ("+s+" -> "+diagnosis+")");
		    		int count = rs.getInt("dc_diagnosisvalue_count");
		    		//Find the correct AgeCategory
		    		int age = rs.getInt("dc_diagnosisvalue_age");
		    		String ageuid="";
		    		Enumeration enumAges = dhis2_agecategories.keys();
		    		System.out.println("Age = "+age);
		    		while(enumAges.hasMoreElements()){
		    			String agecategory = (String)enumAges.nextElement();
		    			System.out.println("Evaluating "+agecategory.split(";")[0]+" <= "+age+" < "+agecategory.split(";")[1]);
		    			if(age>=Integer.parseInt(agecategory.split(";")[0]) && age<Integer.parseInt(agecategory.split(";")[1])){
		    				ageuid=(String)dhis2_agecategories.get(agecategory);
		    				System.out.println("Found Age category = "+ageuid);
		    				break;
		    			}
		    		}
		    		if(ageuid.length()>0){
		    			int existingvalue = 0;
		    			if(agesvalues.get(diagnosisuid+";"+ageuid)!=null){
		    				existingvalue=(Integer)agesvalues.get(diagnosisuid+";"+ageuid);
		    			}
		    			agesvalues.put(diagnosisuid+";"+ageuid, existingvalue+count);
		    		}
		    	}
		    }
		    rs.close();
		    ps.close();
    		if(activedataset.length()>0 && !getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop").equalsIgnoreCase("noop")){
    			boolean bOk=true;
    			//Prepare ages dataset for DHIS2-server
    	        dataValueSet = new DataValueSet();
    			dataValueSet.setDataSet(dhis2_datasetuid);
    			dataValueSet.setOrgUnit(getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop"));
    			dataValueSet.setPeriod(activedataset.split("\\.")[1]+activedataset.split("\\.")[2]);
    			dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
    			System.out.println("Sending data to DHIS2 server");
    			System.out.println("orgunit = "+dataValueSet.getOrgUnit());
    			System.out.println("Creating Ages CoC Data Set");
    			System.out.println("activedataset = "+activedataset);
    			System.out.println("departmentuid = "+checkString(activedataset.split("\\.")[3]));

    			String departmentuid = (String)dhis2_departments.get(checkString(activedataset.split("\\.")[3]).toLowerCase());
                if(departmentuid==null || departmentuid.length()==0){
                	departmentuid=checkString((String)dhis2_departments.get("oth"));
                }
                dataValueSet.setAttributeOptionCombo(departmentuid);
                //Add ages datavalues here
                Enumeration datavalues = agesvalues.keys();
                while(datavalues.hasMoreElements()){
                	String key = (String)datavalues.nextElement();
                    dataValueSet.getDataValues().add(new DataValue(key.split(";")[0],key.split(";")[1],(Integer)agesvalues.get(key)+"",""));
                }
                //Send ages dataset to DHIS2 server
                DHIS2Server server = new DHIS2Server(dhis2_uri, dhis2_api, dhis2_port);
                server.setUserName(dhis2_user);
                server.setUserPassword(dhis2_password);
                try {
                	System.out.println("Sending dataset...");
                	System.out.println("Payload: "+dataValueSet.toXMLString());
                    Response postResponse = server.sendToServer(dataValueSet);
                    System.out.println("Status: " + postResponse.getStatus());
                    System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
                    
                    if(postResponse.hasEntity())
                    {
                        ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
                        // elements of importSummary can also be read individually, and put on a feedback page for example
                        // a feedback should be given especially if conflicts are reported
                        System.out.println("Import summary: ");
                        System.out.println(importSummary);
                   
                    }
                    
                }
                catch (SocketTimeoutException e)
                {
                	bOk=false;
                    e.printStackTrace();
                }
                if(bOk){
                	ds.add(activedataset);
                }
    		}
			conn.close();
			connconf.close();

		} catch (Exception e) {
			e.printStackTrace();
		}		
	}

	public static void sendGenderDataValueSet(String[] args, HashSet ds,String entity){
		//Find date of last export
		try {
			StringBuffer exportfile = new StringBuffer();
			// This will load the MySQL driver, each DB has its own driver
		    Class.forName("com.mysql.jdbc.Driver");			
		    Connection conn =  DriverManager.getConnection("jdbc:mysql://localhost:3306/ocstats_dbo?"+args[0]);
		    Connection connconf =  DriverManager.getConnection("jdbc:mysql://localhost:3306/openclinic_dbo?"+args[0]);
		    
		    //**********************************
		    //Export causes of death (diagnoses)
		    //**********************************
		    
		    String sql = "select * from dc_dhis2deathdiagnosisvalues where dc_diagnosisvalue_dhis2exportdatetime is null and dc_diagnosisvalue_serverid=? and dc_diagnosisvalue_year=? and dc_diagnosisvalue_month=? and dc_diagnosisvalue_serviceuid=?";
		    PreparedStatement ps = conn.prepareStatement(sql);
		    ps.setString(1, entity.split(";")[0]);
		    ps.setString(2, entity.split(";")[1]);
		    ps.setString(3, entity.split(";")[2]);
		    ps.setString(4, entity.split(";")[3]);
		    ResultSet rs =ps.executeQuery();
		    String activedataset ="", dataset="";
		    
		    //Active DHIS2 configuration
		    //**************************
		    String dhis2_uri="";
		    String dhis2_api="";
		    String dhis2_port="";
		    String dhis2_user="";
		    String dhis2_password="";
		    String dhis2_datasetuid="";
		    Hashtable dhis2_genders=new Hashtable();
		    Hashtable dhis2_departments=new Hashtable();
		    Hashtable dhis2_diagnoses=new Hashtable();
		    Hashtable gendervalues = new Hashtable();
	        DataValueSet dataValueSet = new DataValueSet();


		    while(rs.next()){
		    	String month=rs.getString("dc_diagnosisvalue_month");
		    	if(month.length()<2){
		    		month="0"+month;
		    	}
		    	dataset = rs.getString("dc_diagnosisvalue_serverid")+"."+rs.getString("dc_diagnosisvalue_year")+"."+month+"."+rs.getString("dc_diagnosisvalue_serviceuid");
		    	if(!activedataset.equalsIgnoreCase(dataset)){
		    		if(activedataset.length()>0 && !getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop").equalsIgnoreCase("noop")){
		    			boolean bOk=true;
		    			//Prepare genders dataset for DHIS2-server
		    	        dataValueSet = new DataValueSet();
		    			dataValueSet.setDataSet(dhis2_datasetuid);
		    			dataValueSet.setOrgUnit(getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop"));
		    			dataValueSet.setPeriod(activedataset.split("\\.")[1]+activedataset.split("\\.")[2]);
		    			dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
		                String departmentuid = (String)dhis2_departments.get(checkString(activedataset.split("\\.")[3]).toLowerCase());
		                if(departmentuid==null || departmentuid.length()==0){
		                	departmentuid=checkString((String)dhis2_departments.get("oth"));
		                }
		                dataValueSet.setAttributeOptionCombo(departmentuid);
		                //Add gender datavalues here
		                Enumeration datavalues = gendervalues.keys();
		                while(datavalues.hasMoreElements()){
		                	String key = (String)datavalues.nextElement();
		                    dataValueSet.getDataValues().add(new DataValue(key.split(";")[0],key.split(";")[1],(Integer)gendervalues.get(key)+"",""));
		                }
		                //Send gnders dataset to DHIS2 server
		                DHIS2Server server = new DHIS2Server(dhis2_uri, dhis2_api, dhis2_port);
		                server.setUserName(dhis2_user);
		                server.setUserPassword(dhis2_password);
		                try {
		                	System.out.println("Sending dataset...");
		                	System.out.println("Payload: "+dataValueSet.toXMLString());
		                    Response postResponse = server.sendToServer(dataValueSet);
		                    System.out.println("Status: " + postResponse.getStatus());
		                    System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
		                    
		                    if(postResponse.hasEntity())
		                    {
		                        ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
		                        // elements of importSummary can also be read individually, and put on a feedback page for example
		                        // a feedback should be given especially if conflicts are reported
		                        System.out.println("Import summary: ");
		                        System.out.println(importSummary);
		                    }
		                    
		                }
		                catch (SocketTimeoutException e)
		                {
		                	bOk=false;
		                    e.printStackTrace();
		                }
		                if(bOk){
		                	ds.add(activedataset);
		                }
		    		}
		    		if(!activedataset.split("\\.")[0].equalsIgnoreCase(dataset.split("\\.")[0])){
		    			//Load DHIS2 configuration file for active orgunit
		    			String dhis2_configfile = getConfigValue(connconf, "datacenterDHIS2ConfigFile."+dataset.split("\\.")[0], "");
		    			if(dhis2_configfile.length()>0){
			    			System.out.println("Loading DHIS2 config file "+dhis2_configfile);
		    	            SAXReader reader = new SAXReader(false);
		    	            Document document = reader.read(new File(dhis2_configfile));
		    	            Element root = document.getRootElement();
		    	            Element config = root.element("config");
		    	            dhis2_uri=config.elementText("uri");
		    	            dhis2_api=config.elementText("api");
		    	            dhis2_port=config.elementText("port");
		    	            dhis2_user=config.elementText("user");
		    	            dhis2_password=config.elementText("password");

		    			    dhis2_genders=new Hashtable();
		    			    dhis2_departments=new Hashtable();
		    			    dhis2_diagnoses=new Hashtable();
		    			    Iterator datasets = root.elementIterator("dataset");
		    			    while(datasets.hasNext()){
			    			    Element dhis2_dataset = (Element)datasets.next();
			    			    if(dhis2_dataset.attributeValue("type").equalsIgnoreCase("deathdiagnosesbygender")){
			    			    	System.out.println("Loading dataset deathdiagnosesbygender");
				    			    dhis2_datasetuid = dhis2_dataset.attributeValue("uid");
				    	            Iterator categories = dhis2_dataset.elementIterator("category");
				    	            while (categories.hasNext()){
				    	            	Element category = (Element)categories.next();
				    	            	if(category.attributeValue("type").equalsIgnoreCase("gender")){
					    			    	System.out.println("Loading CoC Genders");
				    	            		Iterator genders = category.elementIterator("option");
				    	            		while(genders.hasNext()){
				    	            			Element option = (Element)genders.next();
				    	            			dhis2_genders.put(option.attributeValue("value"), option.attributeValue("uid"));
				    	            		}
					    			    	System.out.println(dhis2_genders.size()+" CoC Genders loaded");
				    	            	}
				    	            	else if(category.attributeValue("type").equalsIgnoreCase("department")){
					    			    	System.out.println("Loading CoC Departments");
				    	            		Iterator departments = category.elementIterator("option");
				    	            		while(departments.hasNext()){
				    	            			Element option = (Element)departments.next();
				    	            			dhis2_departments.put(option.attributeValue("value"), option.attributeValue("uid"));
				    	            		}
					    			    	System.out.println(dhis2_departments.size()+" CoC Departments loaded");
				    	            	}
				    	            }
			    	            	Element dataelements = dhis2_dataset.element("dataelements");
			    	            	Iterator diagnoses = dataelements.elementIterator("dataelement");
			    	            	while(diagnoses.hasNext()){
			    	            		Element diagnosis = (Element)diagnoses.next();
			    	            		dhis2_diagnoses.put(diagnosis.attributeValue("code"),diagnosis.attributeValue("uid"));
			    	            	}
			    	            	break;
			    			    }
		    			    }
		    			}
		    		}
		    		activedataset = dataset;
				    gendervalues = new Hashtable();
		    	}
		    	//Find diagnosis uid
		    	String s=rs.getString("dc_diagnosisvalue_code");
		    	String diagnosis=checkString(s).toUpperCase();
		    	String diagnosisuid = (String)dhis2_diagnoses.get(diagnosis);
		    	while(diagnosisuid==null && diagnosis.length()>1){
		    		diagnosis=diagnosis.substring(0,diagnosis.length()-1);
		    		diagnosisuid = (String)dhis2_diagnoses.get(diagnosis);
		    	}
		    	if(diagnosisuid==null){
		    		diagnosis="000";
		    		diagnosisuid = (String)dhis2_diagnoses.get("000");
		    		logUnknownDiagnosis(conn, activedataset.split("\\.")[0], s, dataValueSet);
		    	}
		    	if(diagnosisuid!=null){
    				System.out.println("Found diagnosis code = "+diagnosisuid+ " ("+s+" -> "+diagnosis+")");
		    		int count = rs.getInt("dc_diagnosisvalue_count");
		    		//Find the correct GenderCategory
		    		String genderuid= (String)dhis2_genders.get(rs.getString("dc_diagnosisvalue_gender").toLowerCase());
		    		if(genderuid!=null){
	    				System.out.println("Found Gender category = "+genderuid);
		    			int existingvalue = 0;
		    			if(gendervalues.get(diagnosisuid+";"+genderuid)!=null){
		    				existingvalue=(Integer)gendervalues.get(diagnosisuid+";"+genderuid);
		    			}
		    			gendervalues.put(diagnosisuid+";"+genderuid, existingvalue+count);
		    		}
		    	}
		    }
		    rs.close();
		    ps.close();
    		if(activedataset.length()>0 && !getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop").equalsIgnoreCase("noop")){
    			boolean bOk=true;
    			//Prepare genders dataset for DHIS2-server
    	        dataValueSet = new DataValueSet();
    			dataValueSet.setDataSet(dhis2_datasetuid);
    			dataValueSet.setOrgUnit(getConfigValue(connconf, "datacenterDHIS2OrgUnit."+activedataset.split("\\.")[0], "noop"));
    			dataValueSet.setPeriod(activedataset.split("\\.")[1]+activedataset.split("\\.")[2]);
    			dataValueSet.setCompleteDate(new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()));
                String departmentuid = (String)dhis2_departments.get(checkString(activedataset.split("\\.")[3]).toLowerCase());
                if(departmentuid==null || departmentuid.length()==0){
                	departmentuid=checkString((String)dhis2_departments.get("oth"));
                }
                dataValueSet.setAttributeOptionCombo(departmentuid);
                //Add gender datavalues here
                Enumeration datavalues = gendervalues.keys();
                while(datavalues.hasMoreElements()){
                	String key = (String)datavalues.nextElement();
                    dataValueSet.getDataValues().add(new DataValue(key.split(";")[0],key.split(";")[1],(Integer)gendervalues.get(key)+"",""));
                }
                //Send gnders dataset to DHIS2 server
                DHIS2Server server = new DHIS2Server(dhis2_uri, dhis2_api, dhis2_port);
                server.setUserName(dhis2_user);
                server.setUserPassword(dhis2_password);
                try {
                	System.out.println("Sending dataset...");
                	System.out.println("Payload: "+dataValueSet.toXMLString());
                    Response postResponse = server.sendToServer(dataValueSet);
                    System.out.println("Status: " + postResponse.getStatus());
                    System.out.println("Content: " + postResponse.getStatusInfo().getReasonPhrase());
                    
                    if(postResponse.hasEntity())
                    {
                        ImportSummary importSummary = postResponse.readEntity(ImportSummary.class);
                        // elements of importSummary can also be read individually, and put on a feedback page for example
                        // a feedback should be given especially if conflicts are reported
                        System.out.println("Import summary: ");
                        System.out.println(importSummary);
                    }
                    
                }
                catch (SocketTimeoutException e)
                {
                	bOk=false;
                    e.printStackTrace();
                }
                if(bOk){
                	ds.add(activedataset);
                }    		}
			conn.close();
			connconf.close();

		} catch (Exception e) {
			e.printStackTrace();
		}		
	}

	private static String getConfigValue(Connection conn, String key, String defaultValue) throws SQLException{
		String result=defaultValue;
		PreparedStatement ps = conn.prepareStatement("select oc_value from oc_config where oc_key=?");
		ps.setString(1,key);
		ResultSet rs = ps.executeQuery();
		if(rs.next()){
			result=rs.getString("oc_value");
		}
		rs.close();
		ps.close();
		return result;
	}
	
	private static String checkString(String s){
		if(s==null){
			return "";
		}
		return s;
	}
	
	private static void logUnknownDiagnosis(Connection conn,String serverid, String diagnosis,DataValueSet dataValueSet) throws SQLException{
		PreparedStatement ps = conn.prepareStatement("insert into DC_UNKNOWNDIAGNOSES(dc_unknowndiagnosis_serverid,dc_unknowndiagnosis_datasetuid,dc_unknowndiagnosis_code) values (?,?,?)");
		ps.setString(1,serverid);
		ps.setString(2,dataValueSet.getDataSet());
		ps.setString(3,diagnosis);
		ps.execute();
		ps.close();
	}

}
