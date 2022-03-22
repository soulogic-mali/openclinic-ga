package be.openclinic.datacenter;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import javax.mail.*;
import javax.mail.internet.*;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;

public class HTTPSender extends Sender {

	public void send() {
		
        try{
        	if(MedwanQuery.getInstance().getConfigInt("datacenterServerId",-1)>0 && MedwanQuery.getInstance().getConfigString("datacenterHTTPKey","").length()>0) {
				String lastHTTPSenderActivity = MedwanQuery.getInstance().getConfigString("lastDatacenterHTTPSenderActivity","0");
				Debug.println("Checking HTTP Datacenter deadline ...: "+lastHTTPSenderActivity+" < "+getDeadline());
				if(lastHTTPSenderActivity.equalsIgnoreCase("0") || new SimpleDateFormat("yyyyMMddHHmmss").parse(lastHTTPSenderActivity).before(getDeadline())){
			 		loadMessages();
			 		if(messages.size()>0){
				 		String url = MedwanQuery.getInstance().getConfigString("datacenterHTTPURL","http://www.globalhealthbarometer.net/globalhealthbarometer/datacenter/postMessage.jsp");
				        String key = MedwanQuery.getInstance().getConfigString("datacenterHTTPKey","");
				        String datacenterServerId=MedwanQuery.getInstance().getConfigString("datacenterServerId","");
				        String msgid=new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date());
				 		//Compose message payload
				        Date sentDateTime=new Date();
				 		String messageContent="<?xml version='1.0' encoding='UTF-8'?><message type='datacenter.content' id='"+msgid+"'>";
						for (int n=0;n<messages.size();n++){
							ExportMessage exportMessage = (ExportMessage) messages.elementAt(n);
					        exportMessage.setServerId(Integer.parseInt(datacenterServerId));
					        exportMessage.setSentDateTime(sentDateTime);
					        messageContent=messageContent+exportMessage.asXML();
						}
						messageContent=messageContent+"</message>";
						boolean bMessageSent = false;
						//Send payload
						HttpClient client = new HttpClient();
						PostMethod method = new PostMethod(url);
						method.addParameter("key",key);
						method.addParameter("type","post");
						method.addParameter("message",messageContent);
						try {
							client.executeMethod(method);
							bMessageSent = method.getResponseBodyAsString().contains("<OK>");
						} catch (Exception e) {
							e.printStackTrace();
						}
						if(bMessageSent) {
							for (int n=0;n<messages.size();n++){
								ExportMessage exportMessage = (ExportMessage) messages.elementAt(n);
						        exportMessage.updateSentDateTime(sentDateTime);
						        //This automatically implies a SENTACK
						        ExportMessage.updateAckDateTime(exportMessage.getObjectId(), new java.util.Date());
							}
					        Debug.println("-- Message successfully sent");
					        Debug.println("------------------------------------------------------------------------------------------");
					        
						}
						else {
					        Debug.println("-- Message could not be sent");
					        Debug.println("-- Received: "+method.getResponseBodyAsString().trim());
					        Debug.println("------------------------------------------------------------------------------------------");
						}
			 		}
			        MedwanQuery.getInstance().setConfigString("lastDatacenterHTTPSenderActivity",new SimpleDateFormat("yyyyMMddHHmmss").format(new Date()));
				}
        	}
        } catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	public static boolean sendImportAckMessage(String messageContent, String to, String msgid) {
		return true;
	}

	public static boolean sendImportAckMessage(ImportMessage importMessage) {
		return true;
	}

	public static boolean sendSysadminMessage(String s, DatacenterMessage msg) {
    	if(MedwanQuery.getInstance().getConfigString("datacenterHTTPKey","").length()>0) {
	 		String url = MedwanQuery.getInstance().getConfigString("datacenterHTTPURL","http://www.globalhealthbarometer.net/globalhealthbarometer/datacenter/postMessage.jsp");
	        String key = MedwanQuery.getInstance().getConfigString("datacenterHTTPKey","");
	        //Create message content
			HttpClient client = new HttpClient();
			PostMethod method = new PostMethod(url);
			method.addParameter("key",key);
			method.addParameter("type","sysadmin");
			method.addParameter("message",s);
			try {
				client.executeMethod(method);
				return method.getResponseBodyAsString().contains("<OK>");
			} catch (Exception e) {
				e.printStackTrace();
			}
    	}
		return false;
	}

}
