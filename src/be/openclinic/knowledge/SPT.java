package be.openclinic.knowledge;

import java.io.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.impl.client.BasicResponseHandler;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.Pointer;
import be.openclinic.system.OCHttpClient;
import be.openclinic.system.SH;
import net.admin.AdminPerson;

public class SPT {
	static class Sheet {
		String id;
		String href;
		String text;
	}
	
	static class Concept {
		String[] values;
		String text;
	}
	
	static class Treatment {
		String id;
		String document;
		String text;
		Vector sheets;
	}
	
	static String toTime(long l){
		long second=1000;
		long minute=60*second;
		long hour=60*minute;
		return l/hour+":"+(l%hour)/minute+":"+(l%minute/second);
	}
	
	static String checkString(String s) {
		if(s==null) {
			return "";
		}
		return s;
	}
	
	public static boolean hasSPTDataToPost() {
		java.util.Date end = new java.util.Date();
		java.util.Date lastSPTStatusPosted=new java.util.Date();
		try {
			lastSPTStatusPosted = new SimpleDateFormat("yyyyMMddHHmmss").parse(SH.cs("sptLastStatusPosted", "1900010100000000"));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		Document document = extractSigns(lastSPTStatusPosted, end);
		Element root = document.getRootElement();
		return root.elements("patient").size()>0;
	}
	
	public static boolean postSPTData() {
		boolean bSuccess = false;
		if(SH.isHostReachable(SH.cs("sptCentralHost", "cloud.hnrw.org"))) {
			java.util.Date end = new java.util.Date();
			java.util.Date lastSPTStatusPosted=new java.util.Date();
			try {
				lastSPTStatusPosted = new SimpleDateFormat("yyyyMMddHHmmss").parse(SH.cs("sptLastStatusPosted", "1900010100000000"));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			Document document = extractSigns(lastSPTStatusPosted, end);
			Element root = document.getRootElement();
			if(SH.c(root.attributeValue("server")).equalsIgnoreCase("-1")) {
				System.out.println("Warning: trying to post SPT data for unconfigured datacenterserverid (=-1)!");
			}
			if(root.elements("patient").size()>0) {
				OCHttpClient client = new OCHttpClient();
				client.addByteArrayParam("sptdata", document.asXML().getBytes());
				try {
					HttpResponse response = client.post(SH.cs("sptCentralHostPostURL", "http://cloud.hnrw.org/openclinic/ikirezi/postSPTData.jsp"));
					String responseMessage =new BasicResponseHandler().handleResponse(response);
					if(responseMessage.contains("<OK>")){
						bSuccess = true;
						MedwanQuery.getInstance().setConfigString("sptLastStatusPosted", new SimpleDateFormat("yyyyMMddHHmmss").format(end));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return bSuccess;
	}
	
	public static Document extractSigns(java.util.Date begin, java.util.Date end) {
		Connection conn = SH.getOpenclinicConnection();
		Document document = DocumentHelper.createDocument();
		try {
			String loc_sDoc = SH.cs("templateSource","") + "/"+SH.cs("clinicalPathwayFiles","pathways.bi.xml");
			SAXReader loc_reader = new SAXReader(false);
			Document loc_document = loc_reader.read(new URL(loc_sDoc));
			Element loc_root = loc_document.getRootElement();
			Element root = document.addElement("spt");
			root.addAttribute("server", SH.cs("datacenterServerId",""));
			root.addAttribute("version", loc_root.attributeValue("version"));
			String patientuid="";
			Element patient = null;
			PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_UPDATETIME>=? and SPT_SIGN_UPDATETIME<? order by SPT_SIGN_PATIENTUID,SPT_SIGN_UPDATETIME");
			ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
			ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
			ResultSet rs = ps.executeQuery();
			while(rs.next()){
				String puid = rs.getString("SPT_SIGN_PATIENTUID");
				String personid = Pointer.getPointer("sptreverseidentifier."+puid);
				if(personid.length()>0){
					if(!puid.equalsIgnoreCase(patientuid)){
						patient=root.addElement("patient");
						patient.addAttribute("id", puid);
						AdminPerson person = AdminPerson.get(personid);
						patient.addAttribute("ageinmonths", person.getAgeInMonths()+"");
						patient.addAttribute("gender", person.gender.toLowerCase());
						patientuid=puid;
					}
					Element status = patient.addElement("status");
					status.addAttribute("datetime", new SimpleDateFormat("yyyyMMddHHmmss").format(rs.getTimestamp("SPT_SIGN_UPDATETIME")));
					status.addAttribute("user", rs.getString("SPT_SIGN_UPDATEUID"));
					String treatment = rs.getString("SPT_SIGN_TREATMENT");
					if(treatment!=null){
						status.addAttribute("treatment", treatment);
					}
					status.setText(SH.c(rs.getString("SPT_SIGN_SIGNS")));
				}
			}
			rs.close();
			ps.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		finally {
			try {
				conn.close();
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}
		return document;
	}
	
	public static void logSigns(int personid,String signs,java.util.Date updatetime,int updateuid) {
		Connection conn = SH.getOpenclinicConnection();
		String patientuid = Pointer.getPointer("sptidentifier."+personid);
		if(patientuid.length()==0) {
			patientuid=new java.util.Date().getTime()+"";
			Pointer.storePointer("sptidentifier."+personid, patientuid);
		}
		if(Pointer.getPointer("sptreverseidentifier."+patientuid).length()==0) {
			Pointer.storePointer("sptreverseidentifier."+patientuid, personid+"");
		}
		SortedSet ss = new TreeSet();
		String s = "";
		String[] sptsigns = signs.split(";");
		for(int n=0;n<sptsigns.length;n++) {
			if(sptsigns[n].split("=").length>1) {
				ss.add(sptsigns[n]);
			}
		}
		Iterator<String> iss = ss.iterator();
		while(iss.hasNext()) {
			s+=iss.next()+";";
		}
		try{
			boolean bIsNew=false;
			PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_PATIENTUID=? ORDER BY SPT_SIGN_UPDATETIME DESC");
			ps.setLong(1, Long.parseLong(patientuid));
			ResultSet rs = ps.executeQuery();
			if(!rs.next()) {
				bIsNew=true;
			}
			else {
				bIsNew=!s.equalsIgnoreCase(rs.getString("SPT_SIGN_SIGNS"));
			}
			rs.close();
			ps.close();
			if(bIsNew) {
				ps = conn.prepareStatement("insert into SPT_SIGNS(SPT_SIGN_PATIENTUID, SPT_SIGN_SIGNS,SPT_SIGN_UPDATETIME,SPT_SIGN_UPDATEUID) value(?,?,?,?)");
				ps.setLong(1, Long.parseLong(patientuid));
				ps.setString(2, s);
				ps.setTimestamp(3, new java.sql.Timestamp(updatetime.getTime()));
				ps.setInt(4,updateuid);
				ps.execute();
				ps.close();
			}
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static void logTreatment(int personid,String treatment) {
		Connection conn = SH.getOpenclinicConnection();
		String patientuid = Pointer.getPointer("sptidentifier."+personid);
		if(patientuid.length()==0) {
			patientuid=new java.util.Date().getTime()+"";
			Pointer.storePointer("sptidentifier."+personid, patientuid);
		}
		if(Pointer.getPointer("sptreverseidentifier."+patientuid).length()==0) {
			Pointer.storePointer("sptreverseidentifier."+patientuid, personid+"");
		}
		try{
			boolean bIsNew=false;
			PreparedStatement ps = conn.prepareStatement("select * from SPT_SIGNS where SPT_SIGN_PATIENTUID=? ORDER BY SPT_SIGN_UPDATETIME DESC");
			ps.setLong(1, Long.parseLong(patientuid));
			ResultSet rs = ps.executeQuery();
			if(rs.next() && !treatment.equalsIgnoreCase(SH.c(rs.getString("SPT_SIGN_TREATMENT")))) {
				java.sql.Timestamp updatetime = rs.getTimestamp("SPT_SIGN_UPDATETIME");
				rs.close();
				ps.close();
				ps = conn.prepareStatement("update SPT_SIGNS set SPT_SIGN_TREATMENT=? where SPT_SIGN_PATIENTUID=? and SPT_SIGN_UPDATETIME=?");
				ps.setString(1, treatment);
				ps.setLong(2, Long.parseLong(patientuid));
				ps.setTimestamp(3, updatetime);
				ps.execute();
				ps.close();
			}
			else {
				rs.close();
				ps.close();
			}
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static void main(String[] args) throws Exception {
		java.util.Date begin = new SimpleDateFormat("dd/MM/yyyy").parse("01/01/1990");
		java.util.Date end = new java.util.Date();
		try{
			if(args.length>2){
				begin = new SimpleDateFormat("dd/MM/yyyy").parse(args[2]);
			}
			if(args.length>3){
				end = new SimpleDateFormat("dd/MM/yyyy").parse(args[3]);
			}
		}
		catch(Exception e){e.printStackTrace();}
	    Class.forName("com.mysql.jdbc.Driver");			
	    Connection conn =  DriverManager.getConnection(args[0]);
		PreparedStatement ps = conn.prepareStatement("select * from oc_pointers where oc_pointer_key like 'activespt.%' and oc_pointer_updatetime>=? and oc_pointer_updatetime<? order by oc_pointer_updatetime");
		ps.setTimestamp(1,new java.sql.Timestamp(begin.getTime()));
		ps.setTimestamp(2,new java.sql.Timestamp(end.getTime()));
		ResultSet rs = ps.executeQuery();
		StringBuffer s = new StringBuffer();
		s.append("CREATION_PATIENT;MISE_A_JOUR_PATIENT;MISE_A_JOUR_SPT;DUREE_SPT;UTILISATEUR;PATIENT;SIGNES_SPT;SORTIE_SPT\n");
		while(rs.next()){
			String userid=null,fullname="";
			java.util.Date patientcreatetime=null,patientendtime=null;
			String personid = rs.getString("oc_pointer_key").split("\\.")[1];
			PreparedStatement ps2 = conn.prepareStatement("select * from adminview where personid=?");
			ps2.setString(1,personid);
			ResultSet rs2 = ps2.executeQuery();
			if(rs2.next()){
				userid=rs2.getString("updateuserid");
				fullname=rs2.getString("lastname")+", "+rs2.getString("firstname"); 
				patientendtime=rs2.getTimestamp("updatetime");
			}
			rs2.close();
			ps2.close();
			ps2 = conn.prepareStatement("select min(updatetime) updatetime from ocadmin_dbo.adminhistory where personid=?");
			ps2.setString(1,personid);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				if(rs2.getTimestamp("updatetime")!=null){
					patientcreatetime=rs2.getTimestamp("updatetime");
				}
			}
			rs2.close();
			ps2.close();
			java.util.Date endtime=rs.getTimestamp("oc_pointer_updatetime");
			s.append((patientcreatetime==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm").format(patientcreatetime))+";");
			s.append((patientendtime==null?"":new SimpleDateFormat("dd/MM/yyyy HH:mm").format(patientendtime))+";");
			s.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(endtime)+";");
			s.append((endtime==null || patientcreatetime==null?"":toTime((endtime.getTime()-patientcreatetime.getTime())))+";");
			String username="";
			ps2 = conn.prepareStatement("select * from usersview u,adminview a where a.personid=u.personid and userid=?");
			ps2.setString(1,userid);
			rs2 = ps2.executeQuery();
			if(rs2.next()){
				username=rs2.getString("lastname")+", "+rs2.getString("firstname"); 
			}
			rs2.close();
			ps2.close();
			s.append(username+";");
			s.append(fullname+";");
			String sptexit=SPT.getSPTPath(rs.getString("oc_pointer_key"), "fr",args[1],conn).replaceAll("<br/>",", ");
			s.append(sptexit.split("@")[0]+";");
			s.append((sptexit.split("@").length==1?"":sptexit.split("@")[1])+";");
			s.append("\n");
		}
		rs.close();
		ps.close();
		conn.close();
		BufferedWriter writer = new BufferedWriter(new FileWriter(new File("SPT.csv")));
	    writer.write (s.toString());
	    writer.close();
	}
	
	static String getLabel(Element element, String language){
		String label = null;
		Iterator labels = element.elementIterator("label");
		while(labels.hasNext()){
			Element eLabel = (Element)labels.next();
			if(checkString(eLabel.attributeValue("language")).equalsIgnoreCase(language)){
				label=eLabel.getText();
			}
		}
		if(label == null){
			if(element.element("label")!=null){
				label = element.element("label").getText();
			}
			else{
				label = "";
			}
		}
		return label;
	}

	static boolean checkArguments(Element element, Hashtable signs){
		int nPositive=0;
		int nArgumentsTreated=0;
		int nTotalArguments=element.elements("argument").size()+element.elements("arguments").size();
		Iterator arguments = element.elementIterator();
		while(arguments.hasNext()){
			nArgumentsTreated++;
			Element e = (Element)arguments.next();
			if(e.getName().equalsIgnoreCase("arguments")){
				Element eArguments = e;
				boolean bCheck = checkArguments(eArguments,signs);
				if(bCheck){
					nPositive++;
					if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
						if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
							return true;
						}
						if(nTotalArguments-nArgumentsTreated<Integer.parseInt(element.attributeValue("select"))-nPositive){
							return false;
						}
					}
				}
				else {
					if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
						return false;
					}
					else if(element.getName().equalsIgnoreCase("arguments")){
						if(nTotalArguments-nArgumentsTreated<Integer.parseInt(element.attributeValue("select"))-nPositive){
							return false;
						}
					}
				}
			}
			else if(e.getName().equalsIgnoreCase("argument")){
				Element eArgument = e;
				boolean bCheck=false;
				if(eArgument.attributeValue("type").equalsIgnoreCase("ikirezi")){
					Hashtable hSigns = (Hashtable)signs.get("ikirezi");
					if(hSigns!=null){
						Integer iArgument = (Integer)(hSigns.get(Integer.parseInt(eArgument.attributeValue("id"))));
						bCheck = iArgument!=null && ((eArgument.attributeValue("value").equalsIgnoreCase("yes") && iArgument==1) || (eArgument.attributeValue("value").equalsIgnoreCase("no") && iArgument!=1));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("spt")){
					Hashtable hSigns = (Hashtable)signs.get("spt");
					if(hSigns!=null){
						String sArgument = (String)(hSigns.get(eArgument.attributeValue("id")));
						bCheck = sArgument!=null && sArgument.equalsIgnoreCase(eArgument.attributeValue("value"));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icpc2")){
					Hashtable hSigns = (Hashtable)signs.get("icpc2");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icd10")){
					Hashtable hSigns = (Hashtable)signs.get("icd10");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("ageinmonths")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
						if(ageinmonths!=null){
							if(eArgument.attributeValue("compare").equalsIgnoreCase("greaterthan")){
								bCheck = ageinmonths>Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("lessthan")){
								bCheck = ageinmonths<Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notlessthan")){
								bCheck = ageinmonths>=Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
								bCheck = ageinmonths<=Integer.parseInt(eArgument.attributeValue("value"));
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("gender")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						String gender = (String)hSigns.get("gender");
						if(gender!=null){
							bCheck = gender.equalsIgnoreCase(eArgument.attributeValue("value"));
						}
					}
				}
				if(bCheck){
					nPositive++;
					if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
						if(nPositive>=Integer.parseInt(element.attributeValue("select"))){
							return true;
						}
					}
				}
				else {
					if(!element.getName().equalsIgnoreCase("arguments") || element.attributeValue("select").equalsIgnoreCase("all")){
						return false;
					}
				}
			}
		}
		if(element.getName().equalsIgnoreCase("arguments") && !element.attributeValue("select").equalsIgnoreCase("all")){
			if(nPositive<Integer.parseInt(element.attributeValue("select"))){
				return false;
			}
		}
		return true;
	}

	static int checkPositiveArguments(Element element, Hashtable signs){
		int nPositive=0;
		Iterator arguments = element.elementIterator();
		while(arguments.hasNext()){
			Element e = (Element)arguments.next();
			if(e.getName().equalsIgnoreCase("arguments")){
				Element eArguments = e;
				boolean bCheck = checkArguments(eArguments,signs);
				if(bCheck){
					nPositive++;
				}
			}
			else if(e.getName().equalsIgnoreCase("argument")){
				Element eArgument = e;
				boolean bCheck=false;
				if(eArgument.attributeValue("type").equalsIgnoreCase("ikirezi")){
					Hashtable hSigns = (Hashtable)signs.get("ikirezi");
					if(hSigns!=null){
						Integer iArgument = (Integer)(hSigns.get(Integer.parseInt(eArgument.attributeValue("id"))));
						bCheck = iArgument!=null && ((eArgument.attributeValue("value").equalsIgnoreCase("yes") && iArgument==1) || (eArgument.attributeValue("value").equalsIgnoreCase("no") && iArgument!=1));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("spt")){
					Hashtable hSigns = (Hashtable)signs.get("spt");
					if(hSigns!=null){
						String sArgument = (String)(hSigns.get(eArgument.attributeValue("id")));
						bCheck = sArgument!=null && sArgument.equalsIgnoreCase(eArgument.attributeValue("value"));
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icpc2")){
					Hashtable hSigns = (Hashtable)signs.get("icpc2");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("icd10")){
					Hashtable hSigns = (Hashtable)signs.get("icd10");
					if(hSigns!=null){
						String[] codes = eArgument.attributeValue("id").split(",");
						for(int n=0;n<codes.length;n++){
							bCheck = hSigns.get(codes[n])!=null;
							if(bCheck){
								break;
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("ageinmonths")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
						if(ageinmonths!=null){
							if(eArgument.attributeValue("compare").equalsIgnoreCase("greaterthan")){
								bCheck = ageinmonths>Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("lessthan")){
								bCheck = ageinmonths<Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notlessthan")){
								bCheck = ageinmonths>=Integer.parseInt(eArgument.attributeValue("value"));
							}
							else if(eArgument.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
								bCheck = ageinmonths<=Integer.parseInt(eArgument.attributeValue("value"));
							}
						}
					}
				}
				else if(eArgument.attributeValue("type").equalsIgnoreCase("gender")){
					Hashtable hSigns = (Hashtable)signs.get("patient");
					if(hSigns!=null){
						String gender = (String)hSigns.get("gender");
						if(gender!=null){
							bCheck = gender.equalsIgnoreCase(eArgument.attributeValue("value"));
						}
					}
				}
				if(bCheck){
					nPositive++;
				}
			}
		}
		return nPositive;
	}

	static boolean isPathwayApplicable(Element pathway, Hashtable signs){
		Iterator rootNodes = pathway.elementIterator("node");
		while(rootNodes.hasNext()){
			Element rootNode = (Element)rootNodes.next();
			if(checkArguments(rootNode,signs)){
				return true;
			}
		}
		return false;
	}
	
	static Vector getMissingArguments(Element argumentsElement, Hashtable signs){
		Hashtable sptSigns = (Hashtable)signs.get("spt");
		Vector hInformation=new Vector();
		Iterator childArguments = argumentsElement.elementIterator("arguments");
		while(childArguments.hasNext()){
			Element childArgumentsElement = (Element)childArguments.next();
			Vector hSubInformation = getMissingArguments(childArgumentsElement,signs);
			Iterator iSubInformation = hSubInformation.iterator();
			while(iSubInformation.hasNext()){
				Object o = iSubInformation.next();
				if(!hInformation.contains(o)){
					hInformation.add(o);
				}
			}
		}
		Iterator childArgumentElements = argumentsElement.elementIterator("argument");
		while(childArgumentElements.hasNext()){
			Element childArgumentElement = (Element)childArgumentElements.next();
			if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && sptSigns!=null && sptSigns.get(childArgumentElement.attributeValue("id"))!=null){
				if((!argumentsElement.getName().equalsIgnoreCase("arguments") || argumentsElement.attributeValue("select").equalsIgnoreCase("all")) && !childArgumentElement.attributeValue("value").equalsIgnoreCase((String)sptSigns.get(childArgumentElement.attributeValue("id")))){
					return(new Vector());
				}
			}
			else if(childArgumentElement.attributeValue("type").equalsIgnoreCase("spt") && (sptSigns==null || sptSigns.get(childArgumentElement.attributeValue("id"))==null)){
				if(checkString(childArgumentElement.attributeValue("equivalent")).length()>0){
					//Check that equivalents do not exist
					String[] equivalents=childArgumentElement.attributeValue("equivalent").split(",");
					for(int n=0;n<equivalents.length;n++){
						Hashtable tSigns = (Hashtable)signs.get(equivalents[n].split(";")[0]);
						if(tSigns.get(equivalents[n].split(";")[1])==null){
							hInformation.add(childArgumentElement.attributeValue("id"));
							break;
						}
					}
				}
				else{
					hInformation.add(childArgumentElement.attributeValue("id"));
				}
			}
			else if(childArgumentElement.attributeValue("type").equalsIgnoreCase("ageinmonths")){
				Hashtable hSigns = (Hashtable)signs.get("patient");
				Integer ageinmonths = (Integer)hSigns.get("ageinmonths");
				boolean bCheck=true;
				if(ageinmonths!=null){
					if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("greaterthan")){
						bCheck = ageinmonths>Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("lessthan")){
						bCheck = ageinmonths<Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("notlessthan")){
						bCheck = ageinmonths>=Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
					else if(childArgumentElement.attributeValue("compare").equalsIgnoreCase("notgreaterthan")){
						bCheck = ageinmonths<=Integer.parseInt(childArgumentElement.attributeValue("value"));
					}
				}
				if(!bCheck){
					return(new Vector());
				}
			}
		}
		if(argumentsElement.getName().equalsIgnoreCase("arguments")){
			int nPositiveArguments = checkPositiveArguments(argumentsElement, signs);
			int nTotalArguments=argumentsElement.elements("argument").size()+argumentsElement.elements("arguments").size();
			int nNeededArguments = nTotalArguments;
			if(!argumentsElement.attributeValue("select").equalsIgnoreCase("all")){
				nNeededArguments=Integer.parseInt(argumentsElement.attributeValue("select"));
			}
			if(nNeededArguments>nPositiveArguments+hInformation.size()){
				return new Vector();
			}
		}
		return hInformation;
	}
	
	static Vector getNodePath(Element node,Hashtable signs,String language){
		Vector paths=new Vector();
		getNodePath(node,"",signs,paths,language);
		return paths;
	}

	static void getNodePath(Element node,String prefix, Hashtable signs,Vector paths,String language){
		if(checkArguments(node, signs)){
			if(prefix.length()>0){
				prefix+=">";
			}
			prefix+=getLabel(node, language);
			if(node.element("treatment")!=null){
				prefix+="$"+node.element("treatment").attributeValue("id");
			}
			Iterator nodes = node.elementIterator("node");
			if(nodes.hasNext()){
				while(nodes.hasNext()){
					Element childNode = (Element)nodes.next();
					getNodePath(childNode, prefix, signs, paths, language);
				}
			}
			else{
				paths.add(prefix+"|");
			}
		}
		else{
			Vector missingArguments = getMissingArguments(node, signs);
			String sMissingArguments="";
			Iterator iArguments = missingArguments.iterator();
			while(iArguments.hasNext()){
				if(sMissingArguments.length()>0){
					sMissingArguments+=";";
				}
				sMissingArguments+=iArguments.next();
			}
			paths.add(prefix+"|"+sMissingArguments);
		}
	}
	
	static String formatTitle(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				if(n<title.split(">").length-1){
					sTitle+=title.split(">")[n].split("\\$")[0];
				}
				else{
					sTitle+=title.split(">")[n].split("\\$")[0];
				}
			}
		}
		else{
			sTitle=title.split("\\$")[0];
		}
		return sTitle;
	}
	
	static String formatTitleNoBold(String title){
		String sTitle="";
		if(title.indexOf(">")>-1){
			for(int n=0;n<title.split(">").length;n++){
				if(n>0){
					sTitle+=">";
				}
				sTitle+=title.split(">")[n].split("\\$")[0];
			}
		}
		else{
			sTitle=title.split("\\$")[0];
		}
		return sTitle;
	}
	
	static boolean hasLaterNode(SortedMap hPaths,String path){
		Iterator iPaths = hPaths.keySet().iterator();
		while(iPaths.hasNext()){
			String iPath = (String)iPaths.next();
			if(iPath.startsWith(path+">")){
				return true;
			}
		}
		return false;
	}
	
	static String serializeSptSigns(Hashtable signs){
		String s="";
		Enumeration eS = signs.keys();
		while(eS.hasMoreElements()){
			String key = (String)eS.nextElement();
			s+=(key+"="+signs.get(key)+";");
		}
		return s;
	}
	
	static Hashtable unSerializeSigns(String signs){
		Hashtable st = new Hashtable();
		for(int n=0;n<signs.split(";").length;n++){
			if(signs.split(";")[n].split("=").length>1){
				st.put(signs.split(";")[n].split("=")[0],signs.split(";")[n].split("=")[1]);
			}
		}
		return st;
	}
	
	public static String getSPTPath(String pointer,String sWebLanguage,String pathwayFile) {
		String path="";
		try {
			Connection conn = SH.getOpenClinicConnection();
			path = getSPTPath(pointer,sWebLanguage,pathwayFile,conn);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return path;
	}
	public static String getSPTPath(String pointer,String sWebLanguage,String pathwayFile,Connection conn) {
		String path="";
		try {
			String sptPointer = Pointer.getPointer(pointer,conn);
			if(sptPointer.length()>0){
				Hashtable sptSigns=unSerializeSigns(sptPointer);
				Hashtable cleanedSptSigns = new Hashtable();
				Enumeration eSigns = sptSigns.keys();
				while(eSigns.hasMoreElements()){
					String key = (String)eSigns.nextElement();
					String value = (String)sptSigns.get(key);
					cleanedSptSigns.put(key,value.split(";")[0]);
				}
				Hashtable signs = new Hashtable();
				Hashtable ikireziSigns = new Hashtable();
				signs.put("ikirezi",ikireziSigns);
				Hashtable patientSigns = new Hashtable();
				int age=0;
				String gender="M";
				PreparedStatement ps = conn.prepareStatement("select * from adminview where personid=?");
				ps.setString(1,pointer.split("\\.")[1]);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					gender=rs.getString("gender");
					java.util.Date dateOfBirth = rs.getDate("dateofbirth");
			    	try{
				    	Calendar startCalendar = new GregorianCalendar();
				    	startCalendar.setTime(dateOfBirth);
				    	Calendar endCalendar = new GregorianCalendar();
				    	endCalendar.setTime(new java.util.Date());
				    	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
				    	int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
				    	age= diffMonth;
			    	}
			    	catch(Exception e){
			    		age= -1;
			    	}
				}
				rs.close();
				ps.close();
				patientSigns.put("ageinmonths",age);
				patientSigns.put("gender",gender);
				signs.put("patient",patientSigns);
				if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
					cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
				}
				if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
					cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
				}
				signs.put("spt",cleanedSptSigns);
				String sDoc = pathwayFile;
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				//Load documents, concepts and treatments
				Hashtable sheets = new Hashtable();
				if(root.element("documents")!=null){
					Iterator iSheets = root.element("documents").elementIterator("document");
					while(iSheets.hasNext()){
						Element sheet = (Element)iSheets.next();
						Sheet c = new Sheet();
						c.id = checkString(sheet.attributeValue("id"));
						c.href = checkString(sheet.attributeValue("href"));
						c.text = getLabel(sheet,sWebLanguage);
						sheets.put(c.id,c);
					}
				}
				Hashtable concepts = new Hashtable();
				if(root.element("concepts")!=null){
					Iterator iConcepts = root.element("concepts").elementIterator("concept");
					while(iConcepts.hasNext()){
						Element concept = (Element)iConcepts.next();
						Concept c = new Concept();
						c.values = checkString(concept.attributeValue("values")).split(",");
						c.text = getLabel(concept,sWebLanguage);
						concepts.put(concept.attributeValue("id"),c);
					}
				}
				Hashtable treatments = new Hashtable();
				if(root.element("treatments")!=null){
					Iterator iTreatments = root.element("treatments").elementIterator("treatment");
					while(iTreatments.hasNext()){
						Element treatment = (Element)iTreatments.next();
						Treatment t = new Treatment();
						if(treatment.element("document")!=null){
							t.document = checkString(treatment.element("document").attributeValue("href"));
						}
						t.text = getLabel(treatment,sWebLanguage);
						t.id = treatment.attributeValue("id");
						treatments.put(t.id,t);
						t.sheets = new Vector();
						Iterator iSheets = treatment.elementIterator("document");
						while(iSheets.hasNext()){
							t.sheets.add(checkString(((Element)iSheets.next()).attributeValue("id")));
						}
					}
				}
				Iterator pathways = root.elementIterator("pathway");
				while(pathways.hasNext()){
					Element pathway = (Element)pathways.next();
					if(isPathwayApplicable(pathway,signs)){
						sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
						boolean bSignsToExclude=false;
						boolean bCanceled=false;
						String sExcludeReason="";
						StringBuffer sExcludes = new StringBuffer();
						if(pathway.element("excludes")!=null){
							Iterator excludes = pathway.element("excludes").elementIterator("exclude");
							while(excludes.hasNext()){
								Element exclude=(Element)excludes.next();
								String excludeSpt=exclude.attributeValue("spt");
								if(sptSigns.get(excludeSpt)==null){
									String excludeSign=exclude.getText();
									boolean bMatch=true;
									//Check gender and age
									if(checkString(exclude.attributeValue("minage")).length()>0){
										if(age<Integer.parseInt(exclude.attributeValue("minage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("maxage")).length()>0){
										if(age>Integer.parseInt(exclude.attributeValue("maxage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("gender")).length()>0){
										if(!exclude.attributeValue("gender").toUpperCase().contains(gender.toUpperCase())){
											bMatch=false;
										}
									}
									if(bMatch){
										bSignsToExclude=true;
									}
								}
								else if(((String)sptSigns.get(excludeSpt)).equalsIgnoreCase("yes")){
									sExcludeReason=excludeSpt;
									bCanceled=true;
									break;
								}
							}
						}
						if(bCanceled){
							continue;
						}
						if(bSignsToExclude){
						}
						else{
							Iterator childNodes = pathway.elementIterator("node");
							while(childNodes.hasNext()){
								Element childNode = (Element)childNodes.next();
								SortedMap hPaths = new TreeMap();
								Vector paths = getNodePath(childNode, signs, sWebLanguage);
								for(int i=0;i<paths.size();i++){
									String title = ((String)paths.elementAt(i)).split("\\|")[0];
									if(hPaths.get(title)==null){
										hPaths.put(title,new TreeSet());
									}
									if(((String)paths.elementAt(i)).split("\\|").length>1){
										String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
										SortedSet hMissing = (SortedSet)hPaths.get(title);
										for(int j=0;j<1;j++){
											hMissing.add(missing[j]);
										}
										if(hMissing.size()>0){
											break;
										}
									}
								}
								boolean bHasTreatments = false;
								Iterator iPaths = hPaths.keySet().iterator();
								boolean bTitlePrinted=false;
								StringBuffer sPrintSigns = new StringBuffer();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									if(title.split("\\$").length>1){
										bHasTreatments=true;
									}
								}
								if(bHasTreatments){
									iPaths = hPaths.keySet().iterator();
									while(iPaths.hasNext()){
										String title = (String)iPaths.next();
										if(!hasLaterNode(hPaths, title)){
											String lastpart=title.split(">")[title.split(">").length-1];
											if(lastpart.split("\\$").length>1 && treatments.get(lastpart.split("\\$")[1])!=null){
												String sTreatment="";
												Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
												if(treatment!=null){
													sTreatment="@"+treatment.text;
													if(!treatment.id.contains(".")){
														sTreatment+=" ("+treatment.id.toUpperCase()+")";
													}
												}
												path+=formatTitle(title)+sTreatment;
											}
										}
										else{
											String lastpart=title.split(">")[title.split(">").length-1];
											if(lastpart.split("\\$").length>1){
												String sTreatment="";
												Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
												if(treatment!=null){
													sTreatment="@"+treatment.text;
												}
												path+=formatTitle(title)+sTreatment;
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
		catch(Exception e) {
			e.printStackTrace();
		}
		return path;
	}
	public static String getSPTPathForced(String pointer,String sWebLanguage,String pathwayFile) {
		String path="";
		try {
			Connection conn = SH.getOpenClinicConnection();
			path = getSPTPathForced(pointer,sWebLanguage,pathwayFile,conn);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return path;
	}
	public static String getSPTPathForced(String pointer,String sWebLanguage,String pathwayFile,Connection conn) {
		String path="";
		try {
			String sptPointer = Pointer.getPointer(pointer,conn);
			if(sptPointer.length()>0){
				Hashtable sptSigns=unSerializeSigns(sptPointer);
				Hashtable cleanedSptSigns = new Hashtable();
				Enumeration eSigns = sptSigns.keys();
				while(eSigns.hasMoreElements()){
					String key = (String)eSigns.nextElement();
					String value = (String)sptSigns.get(key);
					cleanedSptSigns.put(key,value.split(";")[0]);
				}
				Hashtable signs = new Hashtable();
				Hashtable ikireziSigns = new Hashtable();
				signs.put("ikirezi",ikireziSigns);
				Hashtable patientSigns = new Hashtable();
				int age=0;
				String gender="M";
				PreparedStatement ps = conn.prepareStatement("select * from adminview where personid=?");
				ps.setString(1,pointer.split("\\.")[1]);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					gender=rs.getString("gender");
					java.util.Date dateOfBirth = rs.getDate("dateofbirth");
			    	try{
				    	Calendar startCalendar = new GregorianCalendar();
				    	startCalendar.setTime(dateOfBirth);
				    	Calendar endCalendar = new GregorianCalendar();
				    	endCalendar.setTime(new java.util.Date());
				    	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
				    	int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
				    	age= diffMonth;
			    	}
			    	catch(Exception e){
			    		age= -1;
			    	}
				}
				rs.close();
				ps.close();
				patientSigns.put("ageinmonths",age);
				patientSigns.put("gender",gender);
				signs.put("patient",patientSigns);
				if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
					cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
				}
				if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
					cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
				}
				signs.put("spt",cleanedSptSigns);
				String sDoc = pathwayFile;
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				//Load documents, concepts and treatments
				Hashtable sheets = new Hashtable();
				if(root.element("documents")!=null){
					Iterator iSheets = root.element("documents").elementIterator("document");
					while(iSheets.hasNext()){
						Element sheet = (Element)iSheets.next();
						Sheet c = new Sheet();
						c.id = checkString(sheet.attributeValue("id"));
						c.href = checkString(sheet.attributeValue("href"));
						c.text = getLabel(sheet,sWebLanguage);
						sheets.put(c.id,c);
					}
				}
				Hashtable concepts = new Hashtable();
				if(root.element("concepts")!=null){
					Iterator iConcepts = root.element("concepts").elementIterator("concept");
					while(iConcepts.hasNext()){
						Element concept = (Element)iConcepts.next();
						Concept c = new Concept();
						c.values = checkString(concept.attributeValue("values")).split(",");
						c.text = getLabel(concept,sWebLanguage);
						concepts.put(concept.attributeValue("id"),c);
					}
				}
				Hashtable treatments = new Hashtable();
				if(root.element("treatments")!=null){
					Iterator iTreatments = root.element("treatments").elementIterator("treatment");
					while(iTreatments.hasNext()){
						Element treatment = (Element)iTreatments.next();
						Treatment t = new Treatment();
						if(treatment.element("document")!=null){
							t.document = checkString(treatment.element("document").attributeValue("href"));
						}
						t.text = getLabel(treatment,sWebLanguage);
						t.id = treatment.attributeValue("id");
						treatments.put(t.id,t);
						t.sheets = new Vector();
						Iterator iSheets = treatment.elementIterator("document");
						while(iSheets.hasNext()){
							t.sheets.add(checkString(((Element)iSheets.next()).attributeValue("id")));
						}
					}
				}
				Iterator pathways = root.elementIterator("pathway");
				while(pathways.hasNext()){
					Element pathway = (Element)pathways.next();
					if(isPathwayApplicable(pathway,signs)){
						sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
						boolean bSignsToExclude=false;
						boolean bCanceled=false;
						String sExcludeReason="";
						StringBuffer sExcludes = new StringBuffer();
						if(pathway.element("excludes")!=null){
							Iterator excludes = pathway.element("excludes").elementIterator("exclude");
							while(excludes.hasNext()){
								Element exclude=(Element)excludes.next();
								String excludeSpt=exclude.attributeValue("spt");
								if(sptSigns.get(excludeSpt)==null){
									String excludeSign=exclude.getText();
									boolean bMatch=true;
									//Check gender and age
									if(checkString(exclude.attributeValue("minage")).length()>0){
										if(age<Integer.parseInt(exclude.attributeValue("minage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("maxage")).length()>0){
										if(age>Integer.parseInt(exclude.attributeValue("maxage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("gender")).length()>0){
										if(!exclude.attributeValue("gender").toUpperCase().contains(gender.toUpperCase())){
											bMatch=false;
										}
									}
									if(bMatch){
										bSignsToExclude=true;
									}
								}
								else if(((String)sptSigns.get(excludeSpt)).equalsIgnoreCase("yes")){
									sExcludeReason=excludeSpt;
									bCanceled=true;
									break;
								}
							}
						}
						if(bCanceled){
							continue;
						}
						if(bSignsToExclude){
						}
						else{
							Iterator childNodes = pathway.elementIterator("node");
							while(childNodes.hasNext()){
								Element childNode = (Element)childNodes.next();
								SortedMap hPaths = new TreeMap();
								Vector paths = getNodePath(childNode, signs, sWebLanguage);
								for(int i=0;i<paths.size();i++){
									String title = ((String)paths.elementAt(i)).split("\\|")[0];
									if(hPaths.get(title)==null){
										hPaths.put(title,new TreeSet());
									}
									if(((String)paths.elementAt(i)).split("\\|").length>1){
										String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
										SortedSet hMissing = (SortedSet)hPaths.get(title);
										for(int j=0;j<1;j++){
											hMissing.add(missing[j]);
										}
										if(hMissing.size()>0){
											break;
										}
									}
								}
								boolean bHasTreatments = false;
								Iterator iPaths = hPaths.keySet().iterator();
								boolean bTitlePrinted=false;
								StringBuffer sPrintSigns = new StringBuffer();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									if(title.split("\\$").length>1){
										bHasTreatments=true;
									}
								}
								iPaths = hPaths.keySet().iterator();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									String lastpart=title.split(">")[title.split(">").length-1];
									path=formatTitle(title);
									if(bHasTreatments && lastpart.split("\\$").length>1){
										String sTreatment="";
										Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
										if(treatment!=null){
											path+="><b>"+treatment.text+"</b>";
										}
									}
								}
							}
						}
					}
				}
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return path;
	}
	public static String getSPTPathOpen(String pointer,String sWebLanguage,String pathwayFile) {
		String path="";
		try {
			Connection conn = SH.getOpenClinicConnection();
			path = getSPTPathOpen(pointer,sWebLanguage,pathwayFile,conn);
			conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return path;
	}
	public static String getSPTPathOpen(String pointer,String sWebLanguage,String pathwayFile,Connection conn) {
		String path="";
		try {
			String sptp = Pointer.getPointerWithDate(pointer,conn);
			String sptPointer =sptp.split("\\|")[0];
			String pointerupdate = null;
			if(sptp.split("\\|").length>1) {
				pointerupdate = sptp.split("\\|")[1];
			}
			if(sptPointer.length()>0){
				Hashtable sptSigns=unSerializeSigns(sptPointer);
				Hashtable cleanedSptSigns = new Hashtable();
				Enumeration eSigns = sptSigns.keys();
				while(eSigns.hasMoreElements()){
					String key = (String)eSigns.nextElement();
					String value = (String)sptSigns.get(key);
					cleanedSptSigns.put(key,value.split(";")[0]);
				}
				Hashtable signs = new Hashtable();
				Hashtable ikireziSigns = new Hashtable();
				signs.put("ikirezi",ikireziSigns);
				Hashtable patientSigns = new Hashtable();
				int age=0;
				String gender="M";
				PreparedStatement ps = conn.prepareStatement("select * from adminview where personid=?");
				ps.setString(1,pointer.split("\\.")[1]);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					gender=rs.getString("gender");
					java.util.Date dateOfBirth = rs.getDate("dateofbirth");
			    	try{
				    	Calendar startCalendar = new GregorianCalendar();
				    	startCalendar.setTime(dateOfBirth);
				    	Calendar endCalendar = new GregorianCalendar();
				    	endCalendar.setTime(new java.util.Date());
				    	int diffYear = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
				    	int diffMonth = diffYear * 12 + endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
				    	age= diffMonth;
			    	}
			    	catch(Exception e){
			    		age= -1;
			    	}
				}
				rs.close();
				ps.close();
				patientSigns.put("ageinmonths",age);
				patientSigns.put("gender",gender);
				signs.put("patient",patientSigns);
				if(cleanedSptSigns.get("drh.3")!=null && cleanedSptSigns.get("drhe.3")==null){
					cleanedSptSigns.put("drhe.3",sptSigns.get("drh.3"));
				}
				if(cleanedSptSigns.get("drhe.3")!=null && cleanedSptSigns.get("drh.3")==null){
					cleanedSptSigns.put("drh.3",cleanedSptSigns.get("drhe.3"));
				}
				signs.put("spt",cleanedSptSigns);
				String sDoc = pathwayFile;
				SAXReader reader = new SAXReader(false);
				Document document = reader.read(new URL(sDoc));
				Element root = document.getRootElement();
				//Load documents, concepts and treatments
				Hashtable sheets = new Hashtable();
				if(root.element("documents")!=null){
					Iterator iSheets = root.element("documents").elementIterator("document");
					while(iSheets.hasNext()){
						Element sheet = (Element)iSheets.next();
						Sheet c = new Sheet();
						c.id = checkString(sheet.attributeValue("id"));
						c.href = checkString(sheet.attributeValue("href"));
						c.text = getLabel(sheet,sWebLanguage);
						sheets.put(c.id,c);
					}
				}
				Hashtable concepts = new Hashtable();
				if(root.element("concepts")!=null){
					Iterator iConcepts = root.element("concepts").elementIterator("concept");
					while(iConcepts.hasNext()){
						Element concept = (Element)iConcepts.next();
						Concept c = new Concept();
						c.values = checkString(concept.attributeValue("values")).split(",");
						c.text = getLabel(concept,sWebLanguage);
						concepts.put(concept.attributeValue("id"),c);
					}
				}
				Hashtable treatments = new Hashtable();
				if(root.element("treatments")!=null){
					Iterator iTreatments = root.element("treatments").elementIterator("treatment");
					while(iTreatments.hasNext()){
						Element treatment = (Element)iTreatments.next();
						Treatment t = new Treatment();
						if(treatment.element("document")!=null){
							t.document = checkString(treatment.element("document").attributeValue("href"));
						}
						t.text = getLabel(treatment,sWebLanguage);
						t.id = treatment.attributeValue("id");
						treatments.put(t.id,t);
						t.sheets = new Vector();
						Iterator iSheets = treatment.elementIterator("document");
						while(iSheets.hasNext()){
							t.sheets.add(checkString(((Element)iSheets.next()).attributeValue("id")));
						}
					}
				}
				Iterator pathways = root.elementIterator("pathway");
				while(pathways.hasNext()){
					Element pathway = (Element)pathways.next();
					if(isPathwayApplicable(pathway,signs)){
						sptSigns.put(pathway.attributeValue("complaint"), pathway.attributeValue("value"));
						boolean bSignsToExclude=false;
						boolean bCanceled=false;
						String sExcludeReason="";
						StringBuffer sExcludes = new StringBuffer();
						if(pathway.element("excludes")!=null){
							Iterator excludes = pathway.element("excludes").elementIterator("exclude");
							while(excludes.hasNext()){
								Element exclude=(Element)excludes.next();
								String excludeSpt=exclude.attributeValue("spt");
								if(sptSigns.get(excludeSpt)==null){
									String excludeSign=exclude.getText();
									boolean bMatch=true;
									//Check gender and age
									if(checkString(exclude.attributeValue("minage")).length()>0){
										if(age<Integer.parseInt(exclude.attributeValue("minage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("maxage")).length()>0){
										if(age>Integer.parseInt(exclude.attributeValue("maxage"))){
											bMatch=false;
										}
									}
									if(checkString(exclude.attributeValue("gender")).length()>0){
										if(!exclude.attributeValue("gender").toUpperCase().contains(gender.toUpperCase())){
											bMatch=false;
										}
									}
									if(bMatch){
										bSignsToExclude=true;
									}
								}
								else if(((String)sptSigns.get(excludeSpt)).equalsIgnoreCase("yes")){
									sExcludeReason=excludeSpt;
									bCanceled=true;
									break;
								}
							}
						}
						if(bCanceled){
							continue;
						}
						if(bSignsToExclude){
						}
						else{
							Iterator childNodes = pathway.elementIterator("node");
							while(childNodes.hasNext()){
								Element childNode = (Element)childNodes.next();
								SortedMap hPaths = new TreeMap();
								Vector paths = getNodePath(childNode, signs, sWebLanguage);
								for(int i=0;i<paths.size();i++){
									String title = ((String)paths.elementAt(i)).split("\\|")[0];
									if(hPaths.get(title)==null){
										hPaths.put(title,new TreeSet());
									}
									if(((String)paths.elementAt(i)).split("\\|").length>1){
										String[] missing = ((String)paths.elementAt(i)).split("\\|")[1].split(";");
										SortedSet hMissing = (SortedSet)hPaths.get(title);
										for(int j=0;j<1;j++){
											hMissing.add(missing[j]);
										}
										if(hMissing.size()>0){
											break;
										}
									}
								}
								boolean bHasTreatments = false;
								Iterator iPaths = hPaths.keySet().iterator();
								boolean bTitlePrinted=false;
								StringBuffer sPrintSigns = new StringBuffer();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									if(title.split("\\$").length>1){
										bHasTreatments=true;
									}
								}
								iPaths = hPaths.keySet().iterator();
								while(iPaths.hasNext()){
									String title = (String)iPaths.next();
									String lastpart=title.split(">")[title.split(">").length-1];
									path="<b>["+SH.formatDate(SH.parseDate(pointerupdate, new SimpleDateFormat("dd/MM/yyyy HH:mm")))+"]</b> <b style='color: red'>"+pathway.attributeValue("complaint").split("\\.")[0].toUpperCase()+"</b> - "+formatTitle(title);
									if(bHasTreatments && lastpart.split("\\$").length>1){
										String sTreatment="";
										Treatment treatment = (Treatment)treatments.get(lastpart.split("\\$")[1]);
										if(treatment!=null){
											path+="><b>"+treatment.text+"</b>";
											if(!treatment.id.contains(".")){
												path+="><b style='color: red'>["+treatment.id.toUpperCase()+"]</b>";
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
		catch(Exception e) {
			e.printStackTrace();
		}
		return path;
	}

}
