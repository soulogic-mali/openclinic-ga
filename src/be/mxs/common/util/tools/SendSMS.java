package be.mxs.common.util.tools;

import java.net.InetAddress;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;
import org.smslib.AGateway.*;
import org.smslib.OutboundMessage.MessageStatuses;
import org.smslib.*;
import org.smslib.modem.*;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Debug;
import ie.omk.smpp.Address;
import ie.omk.smpp.Connection;
import ie.omk.smpp.message.BindResp;
import ie.omk.smpp.message.SMPPPacket;
import ie.omk.smpp.message.SubmitSM;
import ie.omk.smpp.message.SubmitSMResp;
import ie.omk.smpp.message.UnbindResp;
import ie.omk.smpp.net.TcpLink;
import ie.omk.smpp.util.Latin1Encoding;

public class SendSMS {
	public static boolean sendSMPP(String to, String message){
		boolean bSuccess=false;
		Debug.println("Trying to send message to "+to+" using SMPP gateway "+MedwanQuery.getInstance().getConfigString("smppgateway",""));
		if(MedwanQuery.getInstance().getConfigString("smppgateway","").equalsIgnoreCase("orangemali")){
		    bSuccess=true;
			try {
			    // First get the java.net.InetAddress for the SMSC:
			    //Orange SMSC can only be reached from ip 41.73.116.155 (ANTIM server)
			    //Create tunnel that maps 127.0.0.1:3339 onto 41.73.126.165:3339 (Orange SMSC)
			    InetAddress smscAddr = InetAddress.getByName(MedwanQuery.getInstance().getConfigString("smppsmscaddress","Orange SMSC"));    
			    TcpLink smscLink = new TcpLink(smscAddr, MedwanQuery.getInstance().getConfigInt("smppsmscport",3339));
			    smscLink.open();
			    Debug.println("Connection open<br/>");
			    Connection connection = new Connection(smscLink);
			    BindResp smppResponse = connection.bind(Connection.TRANSCEIVER,"RCV","Orange","SMPP",1,1,"3000");
			    if (smppResponse.getCommandStatus() == 0) {
			        Debug.println("Link established</br>");
			    }
			    else{
			    	Debug.println("Error: "+smppResponse.getCommandStatus()+"</br>");
				    bSuccess=false;
			    }
		        SubmitSM smppmessage = (SubmitSM) connection.newInstance(SMPPPacket.SUBMIT_SM);
		        if(MedwanQuery.getInstance().getConfigInt("enableSmppSource",0)==1){
		        	Debug.println("Setting source address = "+MedwanQuery.getInstance().getConfigString("smppSourceAddress","Orange"));
		        	smppmessage.setSource(new Address(MedwanQuery.getInstance().getConfigInt("smppSourceNPI",1), MedwanQuery.getInstance().getConfigInt("smppSourceTON",0), MedwanQuery.getInstance().getConfigString("smppSourceAddress","Orange")));
		        }
		        smppmessage.setDestination(new Address(1, 1, to));
		        smppmessage.setMessageText(message);
		        smppmessage.setAlphabet(new Latin1Encoding());
		        SubmitSMResp messageResponse = (SubmitSMResp) connection.sendRequest(smppmessage);
		        Debug.println("Submitted message ID: " + messageResponse.getMessageId()+"</br>");
		        // Unbind.
		        UnbindResp unbindResponse = connection.unbind();

		        if (unbindResponse.getCommandStatus() == 0) {
		            Debug.println("Successfully unbound from the SMSC</br>");
		        } else {
		            Debug.println("There was an error unbinding.</br>");
				    bSuccess=false;
		        }
			} catch(Exception ux) {
			    Debug.println(ux.getMessage());
			    bSuccess=false;
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smppgateway","").equalsIgnoreCase("smpp")){
		    bSuccess=true;
			try {
			    InetAddress smscAddr = InetAddress.getByName(MedwanQuery.getInstance().getConfigString("smppsmscaddress","smsc"));    
			    TcpLink smscLink = new TcpLink(smscAddr, MedwanQuery.getInstance().getConfigInt("smppsmscport",10501));
			    smscLink.open();
			    Debug.println("Connection open<br/>");
			    Connection connection = new Connection(smscLink);
			    BindResp smppResponse = connection.bind(Connection.TRANSCEIVER,MedwanQuery.getInstance().getConfigString("smppsmscusername","username"),MedwanQuery.getInstance().getConfigString("smppsmscpassword","password"),MedwanQuery.getInstance().getConfigString("smppsmscid","id"),1,1,null);
			    if (smppResponse.getCommandStatus() == 0) {
			        Debug.println("Link established</br>");
			    }
			    else{
			    	Debug.println("Error: "+smppResponse.getCommandStatus()+"</br>");
				    bSuccess=false;
			    }
		        SubmitSM smppmessage = (SubmitSM) connection.newInstance(SMPPPacket.SUBMIT_SM);
		        if(MedwanQuery.getInstance().getConfigInt("enableSmppSource",0)==1){
		        	Debug.println("Setting source address = "+MedwanQuery.getInstance().getConfigString("smppSourceAddress","source phone number"));
		        	Debug.println("Setting source NPI = "+MedwanQuery.getInstance().getConfigInt("smppSourceNPI",1));
		        	Debug.println("Setting source TON = "+MedwanQuery.getInstance().getConfigInt("smppSourceTON",1));
		        	smppmessage.setSource(new Address(MedwanQuery.getInstance().getConfigInt("smppSourceNPI",1), MedwanQuery.getInstance().getConfigInt("smppSourceTON",1), MedwanQuery.getInstance().getConfigString("smppSourceAddress","source phone number")));
		        }
	        	Debug.println("Setting destination address = "+to);
	        	Debug.println("Setting destination NPI = "+MedwanQuery.getInstance().getConfigInt("smppDestinationNPI",1));
	        	Debug.println("Setting destination TON = "+MedwanQuery.getInstance().getConfigInt("smppDestinationTON",1));
		        String sDestinationNumber = (to+"").replaceAll("\\+", "");
		        if(MedwanQuery.getInstance().getConfigInt("smppRemoveLeadingZero",0)==1){
		        	if(sDestinationNumber.startsWith("0")){
		        		sDestinationNumber=sDestinationNumber.substring(1);
		        	}
		        }
		        String countryPrefix=MedwanQuery.getInstance().getConfigString("smppForceCountryPrefix","-1");
		        if(!countryPrefix.equalsIgnoreCase("-1")){
		        	if(!sDestinationNumber.startsWith(countryPrefix)){
		        		sDestinationNumber=countryPrefix+sDestinationNumber;
		        	}
		        }
	        	Debug.println("Setting cleaned destination address = "+sDestinationNumber);
	        	smppmessage.setDestination(new Address(MedwanQuery.getInstance().getConfigInt("smppDestinationNPI",1), MedwanQuery.getInstance().getConfigInt("smppDestinationTON",1), sDestinationNumber));
		        smppmessage.setMessageText(message);
		        smppmessage.setAlphabet(new Latin1Encoding());
		        SubmitSMResp messageResponse = (SubmitSMResp) connection.sendRequest(smppmessage);
		        Debug.println("Submitted message ID: " + messageResponse.getMessageId()+"</br>");
		        Debug.println("Response message status: " + messageResponse.getMessageStatus()+"</br>");
		        Debug.println("Response message text: " + messageResponse.getMessageText()+"</br>");
		        Debug.println("Response error code: " + messageResponse.getErrorCode()+"</br>");
		        Debug.println("Response command status: " + messageResponse.getCommandStatus()+"</br>");
		        Debug.println("Response destination: " + messageResponse.getDestination()+"</br>");
		        Debug.println("Response delivery time: " + messageResponse.getDeliveryTime()+"</br>");
		        bSuccess=(messageResponse.getCommandStatus()==0);

		        // Unbind.
		        UnbindResp unbindResponse = connection.unbind();
		        if (unbindResponse.getCommandStatus() == 0) {
		            Debug.println("Successfully unbound from the SMSC</br>");
		        } else {
		            Debug.println("There was an error unbinding.</br>");
				    bSuccess=false;
		        }
			} catch(Exception ux) {
			    Debug.println(ux.getMessage());
			    bSuccess=false;
			}
		}
		return bSuccess;
	}
	
	public static boolean sendSMS(String to, String message){
		boolean bSuccess=false;
		//if country prefix already included, don't do anything
		if(!(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","").length()>0 && to.startsWith(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","")))){
			if(MedwanQuery.getInstance().getConfigInt("cellPhoneRemoveLeadingZero",0)==1){
				while(to.startsWith("0")){
					to=to.substring(1);
				}
			}
			if(MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","").length()>0){
				to=MedwanQuery.getInstance().getConfigString("cellPhoneCountryPrefix","")+to;
			}
		}
		Debug.println("Trying to send message to "+to+" using SMS gateway "+MedwanQuery.getInstance().getConfigString("smsgateway",""));
		if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("smsglobal")){
			try {						
				HttpClient client = new HttpClient();
				PostMethod method = new PostMethod(MedwanQuery.getInstance().getConfigString("smsglobal.url","http://www.smsglobal.com/http-api.php"));
				Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
				vNvp.add(new NameValuePair("action","sendsms"));
				vNvp.add(new NameValuePair("user",MedwanQuery.getInstance().getConfigString("smsglobal.user","")));
				vNvp.add(new NameValuePair("password",MedwanQuery.getInstance().getConfigString("smsglobal.password","")));
				vNvp.add(new NameValuePair("from",MedwanQuery.getInstance().getConfigString("smsglobal.from","")));
				vNvp.add(new NameValuePair("to",to));
				vNvp.add(new NameValuePair("text",URLEncoder.encode(message,"utf-8")));
				NameValuePair[] nvp = new NameValuePair[vNvp.size()];
				vNvp.copyInto(nvp);
				method.setQueryString(nvp);
				client.executeMethod(method);
				String sResponse=method.getResponseBodyAsString();
				if(sResponse.contains("OK: 0")){
					bSuccess=true;
				}
			} catch (Exception e) {				
				e.printStackTrace();
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("hqsms")){
			try {						
				HttpClient client = new HttpClient();
				PostMethod method = new PostMethod(MedwanQuery.getInstance().getConfigString("hqsms.url","https://api2.smsapi.com/sms.do"));
				Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
				vNvp.add(new NameValuePair("normalize","1"));
				vNvp.add(new NameValuePair("username",MedwanQuery.getInstance().getConfigString("hqsms.user","frank.verbeke@post-factum.be")));
				vNvp.add(new NameValuePair("password",MedwanQuery.getInstance().getConfigString("hqsms.password","MD5 password from http://ssl.smsapi.com")));
				vNvp.add(new NameValuePair("from",MedwanQuery.getInstance().getConfigString("hqsms.from","Frank")));
				vNvp.add(new NameValuePair("to",to));
				vNvp.add(new NameValuePair("message",message));
				NameValuePair[] nvp = new NameValuePair[vNvp.size()];
				vNvp.copyInto(nvp);
				method.setQueryString(nvp);
				client.executeMethod(method);
				String sResponse=method.getResponseBodyAsString();
				if(sResponse.contains("OK:")){
					bSuccess=true;
				}
			} catch (Exception e) {				
				e.printStackTrace();
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("nokia")){
			try{
				String sPinCode = MedwanQuery.getInstance().getConfigString("smsPincode","0000"); 
				String sPort= MedwanQuery.getInstance().getConfigString("smsDevicePort","/dev/ttyS20");
				int nBaudrate=MedwanQuery.getInstance().getConfigInt("smsBaudrate",115200);
				System.setProperty("smslib.serial.polling", MedwanQuery.getInstance().getConfigString("smsPolling","false"));
				SendSMS sendSMS = new SendSMS();				
				if (message.length() > 160){ 					
					Vector vSMSs = new Vector();
					vSMSs = splitSMSText(message);
					Enumeration<String> eSMSs = vSMSs.elements();
					String sSMS;
					while (eSMSs.hasMoreElements()){
						sSMS = eSMSs.nextElement();
						sendSMS.send("modem.nokia",sPort, nBaudrate, "Nokia", "2690", sPinCode, to, sSMS);
					}
				}
				else { 
					sendSMS.send("modem.nokia", sPort, nBaudrate, "Nokia", "2690", sPinCode, to, message);
				}			
				bSuccess=true;
			}
			catch(Exception m){
				
			}
		}
		else if(MedwanQuery.getInstance().getConfigString("smsgateway","").equalsIgnoreCase("ccbrt-tigo")){
			try{
				//**************************************
				//TODO: CCBRT Tigo communication code  *
				//**************************************
			}
			catch(Exception m){
				
			}
		}
		else {
			Debug.println("NO SMS GATEWAY DEFINED!");
		}
		return bSuccess;
	}

	public void send(String portname,String port,int baud,String brand,String model,String pin,String destination,String message) throws Exception
	{
		OutboundNotification outboundNotification = new OutboundNotification();
		SerialModemGateway gateway = new SerialModemGateway(portname, port, baud, brand,model);
		gateway.setInbound(true);
		gateway.setOutbound(true);
		gateway.setProtocol(Protocols.PDU);
		gateway.setSimPin(pin);
		Service.getInstance().setOutboundMessageNotification(outboundNotification);
		Service.getInstance().addGateway(gateway);
		Service.getInstance().startService();
		OutboundMessage msg = new OutboundMessage(destination, message);
		Service.getInstance().sendMessage(msg);
		gateway.stopGateway();
		Service.getInstance().stopService();
		Service.getInstance().removeGateway(gateway);
	}

	public class OutboundNotification implements IOutboundMessageNotification
	{
		public void process(AGateway gateway, OutboundMessage msg)
		{
		}
	}
	
	public static Vector<String> splitSMSText(String sResult){
		Vector<String> vSMSs = new Vector<String>();		
		String[] aLines = sResult.split("\n");
		
		if (aLines[0].length() < 160) {
			int iMsgsSend = 1;
			String sMsgToSend = aLines[0]+" (" + iMsgsSend + ")";
			int iLabLineToAdd = 1;
			int iLabLinesSent = 0;			
			String sNextLabLine;
			while (iLabLinesSent < aLines.length - 1) { // eg from 0 to 2
				sNextLabLine = aLines[iLabLineToAdd];
				if (sMsgToSend.length() + sNextLabLine.length() <= 160) {					
					sMsgToSend = sMsgToSend + "\n" + sNextLabLine;
					iLabLineToAdd = iLabLineToAdd + 1;
					iLabLinesSent = iLabLinesSent + 1;
					if (iLabLinesSent == aLines.length - 1){ // last line
						vSMSs.add(sMsgToSend);						
					}
				}
				else { // Longer than 160 ==>> Send earlier one									
					vSMSs.add(sMsgToSend);						
					iMsgsSend = iMsgsSend + 1;
					sMsgToSend = aLines[0]+" (" + iMsgsSend + ")";
				}								
			}			
		}
		return vSMSs;
	}
}
