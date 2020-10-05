package be.openclinic.reporting;

import java.util.Date;
import java.util.Hashtable;
import java.util.Enumeration;
import java.util.Vector;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;

import java.text.*; 

import be.mxs.common.util.db.MedwanQuery;

import java.net.URLEncoder;
import java.sql.*;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;

import be.mxs.common.util.system.Debug;
import be.mxs.common.util.system.HTMLEntities;
import be.mxs.common.util.system.Pointer;
import be.mxs.common.util.system.ScreenHelper;
import net.admin.AdminPerson;
import be.mxs.common.util.tools.sendHtmlMail;
import be.mxs.common.util.tools.ProcessFiles;
import be.mxs.common.util.tools.SendSMS;
import be.openclinic.adt.Planning;
import be.openclinic.medical.*;
import be.openclinic.system.SH;
import be.openclinic.system.SystemInfo;
import be.mxs.common.model.vo.healthrecord.*;
import be.dpms.medwan.common.model.vo.administration.PersonVO;


public class MessageNotifier {
	
	private Date lastMessageCheck;
	
	public void setLastNotifiedMessage(Date date){		
		String sDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(date);
		MedwanQuery.getInstance().setConfigString("lastNotifiedMessage", sDate);			
	}
	
	public Date getLastNotifiedMessage(){
		String sDate = MedwanQuery.getInstance().getConfigString("lastNotifiedMessage"); 
		if (sDate == ""){
			sDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").format(new Date(new Date().getTime()-24*3600*1000));
		}
		
		Date dDate=null;
		try {
			try { 
				dDate = new SimpleDateFormat("yyyyMMddHHmmssSSS").parse(sDate);
			} catch (ParseException e) {
				dDate = new SimpleDateFormat("yyyyMMddHHmmss").parse(sDate);
			}		
			return dDate;
			
		} catch (ParseException e) {
			//e.printStackTrace();
			return new Date(new Date().getTime()-24*3600*1000);
		}		
	}
	
	public static String validateSMSValue(String sSMSValue){
		if (sSMSValue != null){
			if (!sSMSValue.matches("[+]?\\d+")){
				sSMSValue = null;
			}
		}
		return sSMSValue;
	}
	
	public static String validateEmailValue(String sEmailValue){
	   try {
	      InternetAddress emailAddr = new InternetAddress(sEmailValue);
	      emailAddr.validate();
	   } catch (AddressException ex) {
		   sEmailValue = null;
	   }
	   return sEmailValue;
	}
	
	public void sendSpooledMessages(){
    	if(MedwanQuery.getInstance().getConfigString("vpnDomain","").length()>0 &&
			MedwanQuery.getInstance().getConfigString("vpnName","").length()>0 &&
			MedwanQuery.getInstance().getConfigString("vpnAddress",SystemInfo.getVPNIpAddress()).length()>0) {
            try {
        		long second= 1000;
        		long minute = 60*second;
        		long hour=60*minute;
        		long day=24*hour;
    			Date dLastPingMonitor = new SimpleDateFormat("yyyyMMddHHmmss").parse(MedwanQuery.getInstance().getConfigString("lastPingMonitor","19000101010000"));
    			long interval = MedwanQuery.getInstance().getConfigLong("pingMonitorInterval",10*minute); //default = once every ten minutes
    			if(new java.util.Date().getTime()-dLastPingMonitor.getTime()>interval){
        			String uid=MedwanQuery.getInstance().getConfigString("globalHealthBarometerUID","");
        			if(uid.length()==0 || uid.split(";").length<2 ){
        				uid=java.util.UUID.randomUUID().getLeastSignificantBits()+";"+java.util.UUID.randomUUID().getMostSignificantBits();
        				MedwanQuery.getInstance().setConfigString("globalHealthBarometerUID", uid);
        				uid=MedwanQuery.getInstance().getConfigString("globalHealthBarometerUID","");
        			}
        			Debug.println("starting vpn ping post");
        			String url = MedwanQuery.getInstance().getConfigString("globalHealthBarometerURL","http://www.globalhealthbarometer.net/globalhealthbarometer/datacenter/postMonitor.jsp");
        			Debug.println("Sending vpn ping to "+url);
        			PostMethod method = new PostMethod(url);
        			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
        			Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
                	vNvp.add(new NameValuePair("messageType","systeminfo"));
                	vNvp.add(new NameValuePair("centerUid",uid));
                	vNvp.add(new NameValuePair("vpnDomain",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("vpnDomain",""))));
                	vNvp.add(new NameValuePair("vpnName",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("vpnName",""))));
                	vNvp.add(new NameValuePair("vpnAddress",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("vpnAddress",SystemInfo.getVPNIpAddress()))));
                	vNvp.add(new NameValuePair("vpnPort",HTMLEntities.htmlentities(MedwanQuery.getInstance().getConfigString("vpnPort","80"))));
                	vNvp.add(new NameValuePair("upTime",HTMLEntities.htmlentities(SystemInfo.getSystemUptime()+"")));
                	vNvp.add(new NameValuePair("diskSpace",HTMLEntities.htmlentities(SystemInfo.getSystemDiskSpace()+"")));
                	vNvp.add(new NameValuePair("usersConnected",HTMLEntities.htmlentities(SystemInfo.getActiveUserCount()+"")));
                	vNvp.add(new NameValuePair("openclinicVersion",HTMLEntities.htmlentities(SH.ci("updateVersion", 0)+"")));
        			NameValuePair[] nvp = new NameValuePair[vNvp.size()];
        			vNvp.copyInto(nvp);
        			method.setQueryString(nvp);
        			HttpClient client = new HttpClient();
        			int statusCode = client.executeMethod(method);
        			Debug.println("ping post to "+url+" ended (status="+statusCode+")");
        			String resultstring=method.getResponseBodyAsString();
        			if(resultstring.contains("<DUPLICATE>")){
        				MedwanQuery.getInstance().setConfigString("globalHealthBarometerUID", "");
        			}
        			else {
        				MedwanQuery.getInstance().setConfigString("lastPingMonitor",new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
        			}
    			}
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}
    	Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("SELECT * from OC_MESSAGES where OC_MESSAGE_SENTDATETIME IS NULL and OC_MESSAGE_CREATEDATETIME>? and OC_MESSAGE_SENDAFTER<?");
			long day = 24*3600*1000;
			long period = day * MedwanQuery.getInstance().getConfigInt("spoolnotifiermessagesfordays",7);
			ps.setTimestamp(1, new java.sql.Timestamp(new Date().getTime()-period));
			ps.setTimestamp(2, new java.sql.Timestamp(new Date().getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				int messageId = rs.getInt("OC_MESSAGE_MESSAGEID");
				String messageType = rs.getString("OC_MESSAGE_TYPE");
				String messageLanguage = rs.getString("OC_MESSAGE_LANGUAGE");
				String transport = rs.getString("OC_MESSAGE_TRANSPORT");
				String data = rs.getString("OC_MESSAGE_DATA");
				String sentto = ScreenHelper.checkString(rs.getString("OC_MESSAGE_SENTTO")).replace("+","");

				if(transport.equalsIgnoreCase("sms")){
					if(SendSMS.sendSMS(sentto, data)){
						Debug.println("SMS correctly sent messageid "+messageId+" to "+sentto);
						setSpoolMessageSent(messageId,transport);
					}
					else {
						Debug.println("Error sending SMS with messageid "+messageId+" to "+sentto);
					}
				}
				else if(transport.equalsIgnoreCase("simplemail")){
					String sMailTitle = ScreenHelper.getTranNoLink("messagetypes", messageType, messageLanguage);
					if(sendHtmlMail.sendSimpleMail(MedwanQuery.getInstance().getConfigString("PatientEdit.MailServer"), MedwanQuery.getInstance().getConfigString("messageNotifierEmailSender","frank.verbeke@post-factum.be"), sentto, sMailTitle, data)){
						Debug.println("E-mail correctly sent messageid "+messageId+" to "+sentto);
						setSpoolMessageSent(messageId,transport);
					}
					else {
						Debug.println("Error sending E-mail with messageid "+messageId+" to "+sentto);
					}
				}
				else if(transport.equalsIgnoreCase("smpp")){
					if(SendSMS.sendSMPP(sentto, data)){
						Debug.println("SMPP correctly sent messageid "+messageId+" to "+sentto);
						setSpoolMessageSent(messageId,transport);
					}
					else {
						Debug.println("Error sending SMPP with messageid "+messageId+" to "+sentto);
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch(Exception e2){
				e2.printStackTrace();
			}
		}

	}
	
	public void setSpoolMessageSent(int messageId, String transport){
		Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("UPDATE OC_MESSAGES set OC_MESSAGE_SENTDATETIME=? where OC_MESSAGE_MESSAGEID=? and OC_MESSAGE_TRANSPORT=? and OC_MESSAGE_SENTDATETIME IS NULL");
			ps.setTimestamp(1, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setInt(2, messageId);
			ps.setString(3, transport);
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}
	
	public static void SpoolMessage(int messageId, String transport, String data, String sentto, String type, String language){
		SpoolMessage(messageId, transport, data, sentto, type, language, new java.util.Date());
	}

	public static void SpoolMessage(int messageId, String transport, String data, String sentto, String type, String language, java.util.Date sendafter){
		Connection conn=MedwanQuery.getInstance().getOpenclinicConnection();
		try{
			PreparedStatement ps = conn.prepareStatement("SELECT * from OC_MESSAGES where OC_MESSAGE_MESSAGEID=? and OC_MESSAGE_TRANSPORT=? and OC_MESSAGE_SENTDATETIME IS NULL");
			ps.setInt(1, messageId);
			ps.setString(2, transport);
			ResultSet rs = ps.executeQuery();
			if(rs.next()){
				data+=rs.getString("OC_MESSAGE_DATA");
			}
			rs.close();
			ps.close();
			ps = conn.prepareStatement("DELETE from OC_MESSAGES where OC_MESSAGE_MESSAGEID=? and OC_MESSAGE_TRANSPORT=? and OC_MESSAGE_SENTDATETIME IS NULL");
			ps.setInt(1, messageId);
			ps.setString(2, transport);
			ps.execute();
			ps.close();
			ps = conn.prepareStatement("INSERT INTO OC_MESSAGES(OC_MESSAGE_MESSAGEID,OC_MESSAGE_TRANSPORT,OC_MESSAGE_DATA,OC_MESSAGE_CREATEDATETIME,OC_MESSAGE_SENTTO,OC_MESSAGE_SENDAFTER,OC_MESSAGE_TYPE,OC_MESSAGE_LANGUAGE) values(?,?,?,?,?,?,?,?)");
			ps.setInt(1, messageId);
			ps.setString(2, transport);
			ps.setString(3, data);
			ps.setTimestamp(4, new java.sql.Timestamp(new java.util.Date().getTime()));
			ps.setString(5, sentto);
			ps.setTimestamp(6, new java.sql.Timestamp(sendafter.getTime()));
			ps.setString(7, type);
			ps.setString(8, language);
			ps.execute();
			ps.close();
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			try{
				conn.close();
			}
			catch (Exception e2) {
				e2.printStackTrace();
			}
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
