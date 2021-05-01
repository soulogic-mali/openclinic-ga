package be.mxs.common.util.broker;

import java.net.URL;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import be.openclinic.adt.Planning;
import be.openclinic.pharmacy.RemotePharmacy;
import be.openclinic.pharmacy.ServiceStock;
import be.openclinic.reporting.LabresultsNotifier;
import be.openclinic.reporting.MessageNotifier;
import be.openclinic.reporting.PlanningNotifier;
import be.openclinic.system.SH;

public class BrokerScheduler implements Runnable{
	static MessageNotifier msNotifier = new MessageNotifier();
	static LabresultsNotifier lrNotifier = new LabresultsNotifier();
	static PlanningNotifier plNotifier = new PlanningNotifier();
	Thread thread;
	boolean stopped=false;
	
	public boolean isStopped() {
		return stopped;
	}

	public void setStopped(boolean stopped) {
		this.stopped = stopped;
	}

	public BrokerScheduler(){
		thread = new Thread(this);
		thread.start();
	}
	
	public static void runScheduler(){
		if(lrNotifier==null){
			lrNotifier = new LabresultsNotifier();
		}
		if(msNotifier==null){
			msNotifier = new MessageNotifier();
		}
		if(plNotifier==null){
			plNotifier=new PlanningNotifier();
		}
		Debug.println("Generating new lab messages");
		lrNotifier.sendNewLabs();
		Debug.println("Generating new planning messages");
		plNotifier.sendPlanningReminders();
		Debug.println("Running message spooler");
		msNotifier.sendSpooledMessages();
        try {
            Debug.println("Starting scheduler for remote pharmacies synchronization");
            //Before running through all serviceStocks, first check if anything has changed
            int lastCentralOperationId=RemotePharmacy.getLastPharmacyOperation();
            if(lastCentralOperationId>-1 && lastCentralOperationId>SH.ci("lastCentralPharmacyOperationId", -1)) {
            	//Now make a list of all remote uids for which something has changed. We only want to get updates for those
                Debug.println("Looking for new uids > "+SH.ci("lastCentralPharmacyOperationId", -1));
            	HashSet newuids = new HashSet();
            	Element ni = RemotePharmacy.getLastPharmacyOperationsUids(SH.ci("lastCentralPharmacyOperationId", -1)+"");
            	Iterator<Element> iNewuids = ni.elementIterator("message");
            	while(iNewuids.hasNext()) {
            		Element message = iNewuids.next();
            		if(message.attributeValue("uid")!=null) {
                        Debug.println("Found "+message.attributeValue("uid"));
            			newuids.add(message.attributeValue("uid"));
            		}
            	}
            	if(newuids.size()>0) {
		            Vector<ServiceStock> servicestocks = ServiceStock.findAll();
		            for(int n=0; n< servicestocks.size(); n++) {
		            	ServiceStock serviceStock = servicestocks.elementAt(n);
		            	if(serviceStock.getNosync()==0 && SH.cs("remoteSyncId."+serviceStock.getUid(),"").length()>0 && newuids.contains(SH.cs("remoteSyncId."+serviceStock.getUid(),""))) {
		                    Debug.println("Synchronizing "+serviceStock.getName());
		            		RemotePharmacy.getPharmacyOperations(serviceStock,SH.cs("defaultPharmaSyncUser", "4"));
		                    Debug.println("Done");
		            	}
		            }
		            MedwanQuery.getInstance().setConfigString("lastCentralPharmacyOperationId", lastCentralOperationId+"");
            	}
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
}
	
	public void run() {
        try {
        	while(!isStopped()){
        		runScheduler();
        		thread.sleep(MedwanQuery.getInstance().getConfigInt("brokerScheduleInterval",20000));
        	}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}
