package be.mxs.common.util.broker;

import java.net.URL;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
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
import be.openclinic.reporting.LabresultsNotifier;
import be.openclinic.reporting.MessageNotifier;
import be.openclinic.reporting.PlanningNotifier;

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
