package be.openclinic.datacenter;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.StringReader;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.UpdateSystem;
import be.openclinic.adt.Planning;
import be.openclinic.adt.Queue;
import be.openclinic.knowledge.Ikirezi;
import be.openclinic.sync.GHBNetwork;
import be.openclinic.system.SystemInfo;

public class Monitor implements Runnable{
	static Thread thread;
	long startTime=new java.util.Date().getTime();
	boolean stopped=false;
	
	public boolean isStopped() {
		return stopped;
	}

	public void setStopped(boolean stopped) {
		this.stopped = stopped;
	}

	public Monitor(){
		thread = new Thread(this);
		thread.start();
	}
	
	public boolean isActive(){
		boolean isActive=!isStopped();
		long day=24*3600*1000;
		isActive=isActive && (new java.util.Date().getTime()-startTime)<day;
		return isActive;
	}
	
	public static void runScheduler(){
		long second= 1000;
		long minute = 60*second;
		long hour=60*minute;
		long day=24*hour;
		// load scheduler config from XML
		String sDoc=null;
		SAXReader reader=null;
		Document document=null;
		Element root=null;
        Connection conn = null;
        PreparedStatement ps =null;
        ResultSet rs = null;
        try {
    		//Check if it's time to run the daily information monitor
    		Date lastMonitor = new SimpleDateFormat("yyyyMMdd").parse(MedwanQuery.getInstance().getConfigString("lastGlobalHealthBarometerMonitor","19000101"));
    		if(new java.util.Date().getTime()-lastMonitor.getTime()>=day){
    			//Yes, the last monitor run was yesterday
    			//Now check if we already registered a globalHealthBarometerUID
    			String uid=MedwanQuery.getInstance().getConfigString("globalHealthBarometerUID","");
    			if(uid.length()==0 || uid.split(";").length<2 ){
    				uid=java.util.UUID.randomUUID().getLeastSignificantBits()+";"+java.util.UUID.randomUUID().getMostSignificantBits();
    				MedwanQuery.getInstance().setConfigString("globalHealthBarometerUID", uid);
    				uid=MedwanQuery.getInstance().getConfigString("globalHealthBarometerUID","");
    			}
    			//Now create a vector with all parameters to extract in the form of NameValuePairs
    			//Send print instruction to JAVAPOS server
    			Debug.println("starting post");
    			HttpClient client = new HttpClient();
    			String url = MedwanQuery.getInstance().getConfigString("globalHealthBarometerURL","http://www.globalhealthbarometer.net/globalhealthbarometer/datacenter/postMonitor.jsp");
    			PostMethod method = new PostMethod(url);
    			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
    			Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
            	vNvp.add(new NameValuePair("centerUid",uid));
            	vNvp.add(new NameValuePair("centerName",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterName",""))));
            	vNvp.add(new NameValuePair("centerCountry",MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCountry","")));
            	vNvp.add(new NameValuePair("centerCity",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterCity",""))));
            	vNvp.add(new NameValuePair("centerContact",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterContact",""))));
            	vNvp.add(new NameValuePair("centerEmail",MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterEmail","")));
            	vNvp.add(new NameValuePair("centerType",MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterType","")));
            	vNvp.add(new NameValuePair("centerLevel",MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterLevel","")));
            	vNvp.add(new NameValuePair("centerBeds",MedwanQuery.getInstance().getConfigString("globalHealthBarometerCenterBeds","")));
            	vNvp.add(new NameValuePair("date",new SimpleDateFormat("yyyyMMdd").format(new java.util.Date())));
            	vNvp.add(new NameValuePair("softwareVersion",MedwanQuery.getInstance().getConfigString("updateVersion","")));
    			sDoc = MedwanQuery.getInstance().getConfigString("datacenterTemplateSource",MedwanQuery.getInstance().getConfigString("templateSource")) + "/globalhealthbarometer.xml";
	            reader = new SAXReader(false);
	            try{
	            	document = reader.read(new URL(sDoc));
	            }
	            catch(Exception t){
	            	Debug.print("URL="+sDoc);
	            	throw t;
	            }
	            root = document.getRootElement();
	            @SuppressWarnings("unchecked")
				Iterator<Element> elements = root.elementIterator("parameter");
	            Element parameter;
	            while (elements.hasNext()) {
	                parameter = elements.next();
	                String name = parameter.attributeValue("name");
	                Element sql = parameter.element("sql");
	                String database = sql.attributeValue("database");
	                if(database.equalsIgnoreCase("admin")){
	                	conn=MedwanQuery.getInstance().getAdminConnection();
	                }
	                else if(database.equalsIgnoreCase("openclinic")){
	                	conn=MedwanQuery.getInstance().getOpenclinicConnection();
	                }
	                ps=conn.prepareStatement(sql.getText());
	                rs=ps.executeQuery();
	                if(rs.next()){
	                	vNvp.add(new NameValuePair(name,rs.getString("result")));
	                }
	                rs.close();
	                ps.close();
	                conn.close();
	            }
    			NameValuePair[] nvp = new NameValuePair[vNvp.size()];
    			vNvp.copyInto(nvp);
    			method.setQueryString(nvp);
    			int statusCode = client.executeMethod(method);
    			String resultstring=method.getResponseBodyAsString();
    			if(resultstring.contains("<OK>")){
    				MedwanQuery.getInstance().setConfigString("lastGlobalHealthBarometerMonitor", new SimpleDateFormat("yyyyMMdd").format(new java.util.Date()));
    				Debug.println("lastGlobalHealthBarometerMonitor updated to "+MedwanQuery.getInstance().getConfigString("lastGlobalHealthBarometerMonitor","19000101"));
    			}

    			client = new HttpClient();
    			GetMethod getmethod = new GetMethod("http://www.hnrw.org/mxs/os.xml");
    			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
    			statusCode = client.executeMethod(getmethod);
    			resultstring=getmethod.getResponseBodyAsString();
    			if(resultstring.indexOf("<sites>")>-1){
    				BufferedReader br = new BufferedReader(new StringReader(resultstring));
    				reader=new SAXReader(false);
    				document=reader.read(br);
    				root = document.getRootElement();
    				Iterator iSites=root.elementIterator("site");
    				while (iSites.hasNext()){
    	    			client = new HttpClient();
    	    			String site=((Element)iSites.next()).getText();
    	    			getmethod = new GetMethod(site);
    	    			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
    	    			statusCode = client.executeMethod(getmethod);
    	    			String is =getmethod.getResponseBodyAsString();
    				}
    			}
    			
    		}
    		Date lastCouncilValidation = new SimpleDateFormat("yyyyMMdd").parse(MedwanQuery.getInstance().getConfigString("lastProfessionalCouncilValidation","19000101"));
    		if(new java.util.Date().getTime()-lastCouncilValidation.getTime()>=day){
				if(MedwanQuery.getInstance().getConfigInt("enableProfessionalCouncilRegistrationValidation",1)==1){
					UpdateSystem systemUpdate = new UpdateSystem();
					systemUpdate.validateCouncilRegistrations();
				}
    		}
    		Date lastPlanningMaintenance = new SimpleDateFormat("yyyyMMddHHmmss").parse(MedwanQuery.getInstance().getConfigString("lastPlanningMaintenance","19000101010000"));
    		if(new java.util.Date().getTime()-lastPlanningMaintenance.getTime()>=hour){
				if(MedwanQuery.getInstance().getConfigInt("enablePlanningMaintenance",1)==1){
					Planning.doMaintenance();
    				MedwanQuery.getInstance().setConfigString("lastPlanningMaintenance",new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
				}
    		}
    		Date lastGHBMessageSent = new SimpleDateFormat("yyyyMMddHHmmss").parse(MedwanQuery.getInstance().getConfigString("lastGHBMessageSent","19000101010000"));
    		if(MedwanQuery.getInstance().getConfigString("ghb_ref_serverid","").trim().length()>0 && new java.util.Date().getTime()-lastGHBMessageSent.getTime()>=1*minute){
				GHBNetwork.readMessages();
    			GHBNetwork.sendMessages();
   				MedwanQuery.getInstance().setConfigString("lastGHBMessageSent",new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
    		}
            //Waiting queue stats
            try {
    			Date dLastQueueStats = new SimpleDateFormat("yyyyMMddHHmmss").parse(MedwanQuery.getInstance().getConfigString("lastQueueStats","19000101010000"));
    			long interval = MedwanQuery.getInstance().getConfigInt("queueStatsInterval",24*3600*1000);
    			if(new java.util.Date().getTime()-dLastQueueStats.getTime()>interval){
    				Queue.calculateStats();
    				MedwanQuery.getInstance().setConfigString("lastQueueStats",new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
            //Clean ikirezitables
            try {
    			Date dLastIkireziClean = new SimpleDateFormat("yyyyMMddHHmmss").parse(MedwanQuery.getInstance().getConfigString("lastIkireziClean","19000101010000"));
    			long interval = MedwanQuery.getInstance().getConfigInt("ikireziCleanInterval",3600*1000); //default = once an hour
    			if(new java.util.Date().getTime()-dLastIkireziClean.getTime()>interval){
    				Ikirezi.purgeSessions();
    				MedwanQuery.getInstance().setConfigString("lastIkireziClean",new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
        }
        catch (Exception e) {
        	if(Debug.enabled){
        		e.printStackTrace();
        	}
        }
	}
	
	public void run() {
        try {
        	while(!isStopped()){
        		if(MedwanQuery.getInstance().getConfigInt("globalhealthbarometerEnabled",1)==1){
	        		Debug.println("Running monitor...");
        			runScheduler();
        		}
        		Thread.sleep(MedwanQuery.getInstance().getConfigInt("globalhealthbarometerMonitorInterval",200000));
        	}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
}
