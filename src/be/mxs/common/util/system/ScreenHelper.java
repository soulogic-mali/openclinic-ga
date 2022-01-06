package be.mxs.common.util.system;

import be.dpms.medwan.common.model.vo.authentication.UserVO;
import be.dpms.medwan.common.model.vo.occupationalmedicine.ExaminationVO;
import be.dpms.medwan.webapp.wo.common.system.SessionContainerWO;
import be.mxs.common.model.vo.healthrecord.ItemVO;
import be.mxs.common.model.vo.healthrecord.TransactionVO;
import be.mxs.common.util.db.MedwanQuery;
import be.mxs.webapp.wl.exceptions.SessionContainerFactoryException;
import be.mxs.webapp.wl.session.SessionContainerFactory;
import be.openclinic.adt.Encounter;
import be.openclinic.common.OC_Object;
import be.openclinic.finance.Balance;
import be.openclinic.finance.Insurance;
import be.openclinic.finance.Prestation;
import be.openclinic.system.Application;
import be.openclinic.system.SH;
import net.admin.*;

import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.sql.Date;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.regex.Pattern;
import java.util.zip.Deflater;
import java.util.zip.DeflaterOutputStream;
import java.util.zip.Inflater;
import java.util.zip.InflaterOutputStream;

public class ScreenHelper {
    public static SimpleDateFormat hourFormat, stdDateFormat, fullDateFormat, fullDateFormatSS,timestampFormat=new SimpleDateFormat("yyyyMMddHHmmssSSS");
    public static SimpleDateFormat euDateFormat = new SimpleDateFormat(MedwanQuery.getInstance(false).getConfigString("euDateFormat","dd/MM/yyyy")); // used when storing dates in DB
    public static String ITEM_PREFIX = "be.mxs.common.model.vo.healthrecord.IConstants.";
    
    static{
    	reloadDateFormats();
    }
    
    public static void setSync(String name, String id) {
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from oc_sync where type=? and oldid=? and processed is null");
    		ps.setString(1, name);
    		ps.setString(2, id);
    		ResultSet rs = ps.executeQuery();
    		if(!rs.next()) {
    			rs.close();
    			ps.close();
	    		ps = conn.prepareStatement("insert into oc_sync(type,oldid,created) values(?,?,?)");
	    		ps.setString(1, name);
	    		ps.setString(2, id);
	    		ps.setTimestamp(3, getSQLTime());
	    		ps.execute();
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    public static boolean getSyncOpen(String name, String id) {
    	boolean bOpen=false;
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("select * from oc_sync where type=? and oldid=? and processed is null");
    		ps.setString(1, name);
    		ps.setString(2, id);
    		ResultSet rs = ps.executeQuery();
    		if(rs.next()) {
    			bOpen=true;
    		}
    		rs.close();
    		ps.close();
    		conn.close();
    	}
    	catch (Exception e) {
    		e.printStackTrace();
    	}
    	return bOpen;
    }
    public static void updateSync(String name, String oldid, String newid) {
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("update oc_sync set newid=?,processed=? where type=? and oldid=? and processed is null");
    		ps.setString(1, newid);
    		ps.setTimestamp(2, getSQLTime());
    		ps.setString(3, name);
    		ps.setString(4, oldid);
    		ps.execute();
    		ps.close();
    		conn.close();
    		MedwanQuery.getInstance().getObjectCache().removeObject(name, oldid);
    	}
    	catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    public static long getTimeSecond() {
    	return 1000;
    }
    
    public static long getTimeMinute() {
    	return 60*getTimeSecond();
    }
    
    public static long getTimeHour() {
    	return 60*getTimeMinute();
    }
    
    public static long getTimeDay() {
    	return 24*getTimeHour();
    }
    
    public static long getTimeYear() {
    	return 365*getTimeDay();
    }
    
    public static boolean isValidEmailAddress(String email) {
	   boolean result = true;
	   try {
	      InternetAddress emailAddr = new InternetAddress(email);
	      emailAddr.validate();
	   } catch (AddressException ex) {
	      result = false;
	   }
	   return result;
	}
    
    public static String getClientIpAddress(HttpServletRequest request) {
        return getRemoteAddr(request);
    }
    
    public static long nightsBetween(java.util.Date begin,java.util.Date end){
    	long nights = 0;
    	if(!formatDate(begin).equals(formatDate(end)) && end.after(begin)){
    		nights=TimeUnit.DAYS.convert(end.getTime()-begin.getTime(), TimeUnit.MILLISECONDS);
    	}
    	return nights;
    }
    
    public static java.util.Date getPreviousMonthBegin(){
    	return getPreviousMonthBegin(new java.util.Date());
    }
    public static java.util.Date getPreviousMonthBegin(java.util.Date date){
    	try{
	        String firstdayPreviousMonth="01/"+new SimpleDateFormat("MM/yyyy").format(new java.util.Date(ScreenHelper.parseDate("01/"+new SimpleDateFormat("MM/yyyy").format(date)).getTime()-100));
	        return new SimpleDateFormat("dd/MM/yyyy").parse(firstdayPreviousMonth);
    	}
    	catch(Exception e){
    		return null;
    	}
    }
    public static java.util.Date getPreviousMonthEnd(){
    	return getPreviousMonthEnd(new java.util.Date());
    }
    public static java.util.Date getPreviousMonthEnd(java.util.Date date){
    	try{
	    	String lastdayPreviousMonth=ScreenHelper.stdDateFormat.format(new java.util.Date(ScreenHelper.parseDate("01/"+new SimpleDateFormat("MM/yyyy").format(date)).getTime()-100));
	        return new SimpleDateFormat("dd/MM/yyyy").parse(lastdayPreviousMonth);
    	}
    	catch(Exception e){
    		return null;
    	}
    }
    
    public static boolean isAcceptableUploadFileExtension(String sFileName) {
    	String[] forbiddenExtensions = MedwanQuery.getInstance().getConfigString("forbiddentUploadFileExtensions",".html,.jsp,.htm,.js,.do").split(",");
    	for(int n=0;n<forbiddenExtensions.length;n++) {
    		if(sFileName.toLowerCase().endsWith(forbiddenExtensions[n].toLowerCase())) {
    			return false;
    		}
    	}
    	return true;
    }
    
    public static Connection getOpenclinicConnection() {
    	return MedwanQuery.getInstance().getOpenclinicConnection();
    }
    
    public static Connection getAdminConnection() {
    	return MedwanQuery.getInstance().getAdminConnection();
    }
    
    public static int addHashCounter(Hashtable h,String key, int value) {
    	if(h.get(key)==null) {
    		h.put(key, 0);
    	}
    	h.put(key, (Integer)h.get(key)+value);
    	return (Integer)h.get(key);
    }
    
    public static String getRemoteAddr(HttpServletRequest request) {
	   String ip = request.getHeader("x-forwarded-for");      
	   if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	       ip = request.getHeader("Proxy-Client-IP");      
	   }      
	   if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	       ip = request.getHeader("WL-Proxy-Client-IP");      
	   }      
	   if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {      
	       ip = request.getRemoteAddr();      
	   }      
	   return ip;      
    }
    
    public static String createDrawingDiv(HttpServletRequest request,String name, String itemtype, Object transaction,String image){
    	String sContextPath=request.getRequestURI().replaceAll(request.getServletPath(),"");
    	TransactionVO tran = (TransactionVO)transaction;
    	String s = "<script src='"+sContextPath+"/_common/_script/canvas.js'></script>";
    	s+="<table cellspacing='0' cellpadding='0'>";
    	s+="<tr><td>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_small.png' width='14px' onclick='canvasSetRadius(1)'/>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_normal.png' width='14px' onclick='canvasSetRadius(5)'/>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_big.png' width='14px' onclick='canvasSetRadius(10)'/>";
    	s+="</td><td>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/previous.jpg' width='14px' onclick='canvasReloadBaseImage()'/>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/erase.png' width='14px' onclick='canvasLoadImage(\""+sContextPath+image+"\")'/>";
    	s+="</td><td/></tr><tr><td colspan='2'>";
    	s+="<div id='"+name+"' onmouseover='this.style.cursor=\"hand\"'></div>";
    	s+="</td><td valign='top'><table cellspacing='0' cellpadding='0'>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_black.png' width='14px' onclick='canvasSetColor(\"black\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_white.png' width='14px' onclick='canvasSetColor(\"white\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_red.png' width='14px' onclick='canvasSetColor(\"red\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_blue.png' width='14px' onclick='canvasSetColor(\"blue\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_yellow.png' width='14px' onclick='canvasSetColor(\"yellow\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_green.png' width='14px' onclick='canvasSetColor(\"green\")'/></td></tr>";
    	s+="</table></td></tr></table>";
    	s+="<input type='hidden' name='drawingContent' id='drawingContent'/>";
    	s+="<input type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode="+tran.getItem(itemtype).hashCode()+"]>.value' value='drawingContent'/>";
    	s+="<script>";
    	String sDrawing=ScreenHelper.getDrawing(tran.getServerId(),tran.getTransactionId(),itemtype);
    	if(sDrawing.length()<10){
    		s+="context = initCanvas('"+name+"',100,100,'"+sContextPath+image+"');";
    	}
    	else {
    		s+="context = initCanvas('"+name+"',100,100,'"+sDrawing+"');";
    	}
    	s+="</script>";
    	return s;
    }
    
    public static String createDrawingDiv(HttpServletRequest request,String name, String itemtype, Object transaction,String image, String imageType){
    	String sContextPath=request.getRequestURI().replaceAll(request.getServletPath(),"");
    	TransactionVO tran = (TransactionVO)transaction;
    	String s = "<script src='"+sContextPath+"/_common/_script/canvas.js'></script>";
    	s+="<table cellspacing='0' cellpadding='0'>";
    	s+="<tr><td>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_small.png' width='14px' onclick='canvasSetRadius(1)'/>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_normal.png' width='14px' onclick='canvasSetRadius(5)'/>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/canvas_big.png' width='14px' onclick='canvasSetRadius(10)'/>";
    	s+="</td><td>";
    	s+="<img src='"+sContextPath+"/_img/themes/default/previous.jpg' width='14px' onclick='canvasReloadBaseImage()'/>";
    	//s+="<img src='"+sContextPath+"/_img/themes/default/erase.png' width='14px' onclick='updateDrawing()'/>";
    	s+="</td><td>";
    	s+="<select onchange='updateDrawing()' id='drawingtype' class='text'>"+writeSelect(request,imageType,"",((User)request.getSession().getAttribute("activeUser")).person.language)+"</select>";
    	s+="<img src='"+sContextPath+"/_img/icons/icon_default.gif' width='14px' onclick='updateDrawing()'/>";
    	s+="</td><td/></tr><tr><td colspan='3'>";
    	s+="<div id='"+name+"' onmouseover='this.style.cursor=\"hand\"'></div>";
    	s+="</td><td valign='top'><table cellspacing='0' cellpadding='0'>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_black.png' width='14px' onclick='canvasSetColor(\"black\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_white.png' width='14px' onclick='canvasSetColor(\"white\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_red.png' width='14px' onclick='canvasSetColor(\"red\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_blue.png' width='14px' onclick='canvasSetColor(\"blue\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_yellow.png' width='14px' onclick='canvasSetColor(\"yellow\")'/></td></tr>";
    	s+="<tr><td><img src='"+sContextPath+"/_img/themes/default/canvas_green.png' width='14px' onclick='canvasSetColor(\"green\")'/></td></tr>";
    	s+="</table></td></tr></table>";
    	s+="<input type='hidden' name='drawingContent' id='drawingContent'/>";
    	s+="<input type='hidden' id='"+name+"Drawing' name='currentTransactionVO.items.<ItemVO[hashCode="+tran.getItem(itemtype).hashCode()+"]>.value' value='drawingContent'/>";
    	s+="<script>";
    	String sDrawing=ScreenHelper.getDrawing(tran.getServerId(),tran.getTransactionId(),itemtype);
    	if(sDrawing.length()<10){
    		s+="context = initCanvas('"+name+"',100,100,'"+sContextPath+image+"');";
    	}
    	else {
    		s+="context = initCanvas('"+name+"',100,100,'"+sDrawing+"');";
    	}
    	s+="function updateDrawing(){";
    	s+="  drawingtype=document.getElementById('drawingtype').value.replace(new RegExp('<sl>', 'g'), '/');";
		s+="  canvasLoadImage('"+sContextPath+"'+drawingtype);";
		s+="}";
    	s+="</script>";
    	return s;
    }
    
    public static String createSignatureDiv(HttpServletRequest request,String name, String fieldname,String documentuid, String image){
    	String sContextPath=request.getRequestURI().replaceAll(request.getServletPath(),"");
    	String s = "<script src='"+sContextPath+"/_common/_script/canvas.js'></script>";
    	s+="<table cellspacing='0' cellpadding='0'>";
    	s+="<tr><td>";
    	s+="<div id='"+name+"' onmouseover='this.style.cursor=\"hand\"'></div>";
    	s+="</td></tr></table>";
    	s+="<input type='hidden' name='drawingContent' id='drawingContent'/>";
    	s+="<input type='hidden' name='"+fieldname+"' value='drawingContent'/>";
    	s+="<script>";
    	String sDrawing=ScreenHelper.getDrawing(Integer.parseInt(documentuid.split("\\.")[0]),Integer.parseInt(documentuid.split("\\.")[1]),documentuid.split("\\.")[2]);
    	if(sDrawing.length()<10){
    		s+="context = initCanvas('"+name+"',100,100,'"+sContextPath+image+"');";
    	}
    	else {
    		s+="context = initCanvas('"+name+"',100,100,'"+sDrawing+"');";
    	}
    	s+="</script>";
    	return s;
    }
    
    public static java.util.Date endOfDay(java.util.Date date){
    	if(date!=null){
    		try {
				return new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").parse(new SimpleDateFormat("dd/MM/yyyy").format(date)+" 23:59:59");
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
    	return date;
    }
    
    public static String getDrawing(int serverid, int transactionid, String itemtype){
    	String drawing="";
    	Connection conn=MedwanQuery.getInstance().getOpenclinicConnection(); 
    	PreparedStatement ps=null;
    	ResultSet rs=null;
    	try{
    		ps=conn.prepareStatement("select OC_DRAWING_DRAWING from OC_DRAWINGS where OC_DRAWING_SERVERID=? and OC_DRAWING_TRANSACTIONID=? and OC_DRAWING_ITEMTYPE=?");
    		ps.setInt(1, serverid);
    		ps.setInt(2, transactionid);
    		ps.setString(3, itemtype);
    		rs=ps.executeQuery();
    		if(rs.next()){
    			drawing=base64Decompress(rs.getBytes("OC_DRAWING_DRAWING"));
    		}
    	}
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }
    	return drawing;
    }
    
    //--- GET OBJECT ID ---------------------------------------------------------------------------
    public static String getObjectId(String sUIDorID){ 
    	String sObjectId = "";
    	
    	if(sUIDorID.indexOf(".") > 0){
    		sObjectId = sUIDorID.split("\\.")[1]; // seems to be a UID (serverid.objectid)
    	}
    	else{
    		sObjectId = sUIDorID; // seems to be just the objectid
    	}

    	return sObjectId;
    }
    
    public static String capitalize(String s){
    	if(s==null){
    		return null;
    	}
    	else if(s.length()==0){
    		return "";
    	}
    	else if(s.length()==1){
    		return s.toUpperCase();
    	}
    	else {
    		return s.substring(0,1).toUpperCase()+s.substring(1).toLowerCase();
    	}
    }
    
    public static String capitalizeFirst(String s){
    	if(s==null){
    		return null;
    	}
    	else if(s.length()==0){
    		return "";
    	}
    	else if(s.length()==1){
    		return s.toUpperCase();
    	}
    	else {
    		return s.substring(0,1).toUpperCase()+s.substring(1);
    	}
    }
    
    public static String capitalizeAllWords(String s){
    	if(s==null){
    		return null;
    	}
    	else if(s.length()==0){
    		return "";
    	}
    	else if(s.length()==1){
    		return s.toUpperCase();
    	}
    	else {
    		String s2="";
	    	for(int n=0;n<s.split(" ").length;n++) {
	    		for(int i=0;i<s.split(" ")[n].split("-").length;i++) {
	    			if(i>0) {
	    				s2+="-";
	    			}
	    			s2+=s.split(" ")[n].split("-")[i].substring(0,1).toUpperCase()+s.split(" ")[n].split("-")[i].substring(1).toLowerCase();
	    		}
	    		s2+=" ";
	    	}
	    	return s2.trim();
    	}
    }
    
    public static String sortedMap2String(SortedMap m){
    	String s="";
    	Iterator i = m.keySet().iterator();
    	while(i.hasNext()){
    		String key=(String)i.next();
    		String value=(String)m.get(key);
    		if(s.length()>0){
    			s+="|";
    		}
    		s+=key+"$"+value;
    	}
    	return s;
    }
    
    public static SortedMap string2SortedMap(String s){
    	String[] ss=s.split("\\|");
    	SortedMap m = new TreeMap();
    	for(int i=0;i<ss.length;i++){
    		if(ss[i].split("\\$").length>1){
	    		String key = ss[i].split("\\$")[0];
	    		String value = ss[i].split("\\$")[1];
	    		m.put(key, value);
    		}
    	}
    	return m;
    }
    
    //--- RELOAD DATE FORMATS ---------------------------------------------------------------------
    public static void reloadDateFormats(){
        hourFormat       = new SimpleDateFormat(MedwanQuery.getInstance().getConfigString("hourFormat","HH:mm"));
        stdDateFormat    = new SimpleDateFormat(MedwanQuery.getInstance().getConfigString("dateFormat","dd/MM/yyyy"));
        fullDateFormat   = new SimpleDateFormat(stdDateFormat.toPattern()+" "+hourFormat.toPattern());
        fullDateFormatSS = new SimpleDateFormat(stdDateFormat.toPattern()+" "+hourFormat.toPattern()+":ss");
        
        hourFormat.setLenient(false); // do not roll into the next year when passing the 12th month
	    stdDateFormat.setLenient(false);
	    fullDateFormat.setLenient(false);
	    fullDateFormatSS.setLenient(false);
    }
    
    //--- CONVERT TO EU DATE ----------------------------------------------------------------------
    public static String convertToEUDate(String sDate){    	
    	if(sDate.length() > 0){
	    	java.util.Date date = parseDate(sDate);
	    	
	    	try{
		    	sDate = ScreenHelper.euDateFormat.format(date); 
	    	}
	    	catch(Exception e){
	    		//e.printStackTrace();
	    	}
    	}
    	
    	return sDate;
    }
    
    public static String getDuration(java.util.Date begin, java.util.Date end){
    	String duration="?";
    	long minute = 60000;
    	long hour = 60*minute;
    	long day = 24*hour;
    	try{
    		long d = end.getTime()-begin.getTime();
    		int days = new Long(d/day).intValue();
    		d=d-days*day;
    		int hours = new Long(d/hour).intValue();
    		d=d-hours*hour;
    		int minutes = new Long(d/minute).intValue();
    		duration = minutes+"min";
    		if(hours>0 || days>0){
    			duration=hours+"h "+duration;
    		}
    		if(days>0){
    			duration=days+"d "+duration;
    		}
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    	return duration;
    }
    
    //--- CONVERT TO EU DATE CONCATINATED ---------------------------------------------------------
    public static String convertToEUDateConcatinated(String sConcatinatedValue){ 
    	if(sConcatinatedValue.length() > 0){    	    	
	    	// check for $ (row) in the value
	    	if(sConcatinatedValue.indexOf("$") > -1){
	            String sOrigValue = sConcatinatedValue;
	            boolean dateFound = false;
	            String sCell;
	            Vector rows = new Vector();

	            // run thru rows of the concatinated value
	            while(sConcatinatedValue.indexOf("$") > -1){
	            	// row by row
	            	String sRow = sConcatinatedValue.substring(0,sConcatinatedValue.indexOf("$")+1);

	                Vector cells = new Vector();
	                
	            	// cell by cell
	                while(sRow.indexOf("$") > 0){
	                	if(sRow.indexOf("£") > -1){
	                	    sCell = sRow.substring(0,sRow.indexOf("£"));
	                	}
	                	else{
	                	    sCell = sRow.substring(0,sRow.indexOf("$"));
	                	}
	                	
	                	// convert to EU date, which is the format to store dates in the DB
	                	if(ScreenHelper.isDateValue(sCell)){
	                		// convert to EU date
	                		sCell = ScreenHelper.convertToEUDate(sCell);
	                		dateFound = true;
	                	}
	                	cells.add(sCell);
	                	
	                	// trim-off treated cell
	                	if(sRow.indexOf("£") > -1){
                	        sRow = sRow.substring(sRow.indexOf("£")+1);
	                	}
	                	else{
                	        sRow = sRow.substring(sRow.indexOf("$"));
	                	}
	                	
	                    // treat next cell
	                }
	            	
	            	// trim-off treated row
	                sConcatinatedValue = sConcatinatedValue.substring(sConcatinatedValue.indexOf("$")+1);
	                
	                // compose row again
	            	sRow = "";            	
	            	for(int i=0; i<cells.size(); i++){
	            		sRow+= (String)cells.get(i)+"£"; // terminate cell
	            	}            	
	            	sRow = sRow.substring(0,sRow.length()-1); // trim-off £
	            	sRow+= "$"; // terminate row
	                
	                // save treated row in vector
	            	rows.add(sRow);
	                
	                // treat next row
	            }
	            
	            // reconstruct value from rows in vector
	            if(dateFound){
		            sConcatinatedValue = ""; // reset
		            for(int i=0; i<rows.size(); i++){
		            	sConcatinatedValue+= (String)rows.get(i);
		            }
		            
		            // trim-off last separator
	            }
	            else{
	            	sConcatinatedValue = sOrigValue;
	            }
	    	}
    	}

    	return sConcatinatedValue;
    }
    
    //--- CONVERT DATE ----------------------------------------------------------------------------
    // typically from EU (database) to EU or US (display)
    public static String convertDate(String sDate){
    	if(sDate.length() > 0){
	    	java.util.Date date = parseDate(sDate,euDateFormat);
	    	
	    	try{
		    	sDate = ScreenHelper.stdDateFormat.format(date); 
	    	}
	    	catch(Exception e){
	    		//e.printStackTrace();
	    	}
	    	
            return sDate;
    	}
    	else{
    		return "";
    	}
    }
    
    public static java.util.Date endOfDay(String sDate) throws ParseException{
    	java.util.Date date = null;
    	date = parseDate(sDate);
    	date = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").parse(new SimpleDateFormat("dd/MM/yyyy").format(date)+" 23:59:59");
    	return date;
    }
    
    //--- PARSE DATE ------------------------------------------------------------------------------
    public static java.util.Date parseDate(String sDate){
        return parseDate(sDate,stdDateFormat);
    }
    
    public static String getParam(String[] args,String name, String defaultValue) {
    	for(int n=0;n<args.length;n++) {
    		if(args[n].equals(name) && n<args.length-1) {
    			return args[n+1];
    		}
    	}
    	return defaultValue;
    }
    
    public static void updateTableColumn(String table, String column, String oldValue, String newValue) {
    	Connection conn = SH.getOpenClinicConnection();
    	try {
    		PreparedStatement ps = conn.prepareStatement("update "+table+" set "+column+"=? where "+column+"=?");
    		ps.setString(1, newValue);
    		ps.setString(2, oldValue);
    		ps.execute();
    		ps.close();
    		conn.close();
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public static void updateTableColumn(String table, String column, int oldValue, int newValue) throws SQLException {
    	Connection conn = SH.getOpenClinicConnection();
		PreparedStatement ps = conn.prepareStatement("update "+table+" set "+column+"=? where "+column+"=?");
		ps.setInt(1, newValue);
		ps.setInt(2, oldValue);
		ps.execute();
		ps.close();
		conn.close();
    }
    
    public static boolean updateEncounterUid(String oldUid, String newUid) {
    	boolean bSuccess = false;
    	Connection conn = SH.getOpenClinicConnection();
    	try {
    		Encounter encounter = Encounter.get(oldUid);
    		
    		//Update Encounters
    		String sSql="update oc_encounters set oc_encounter_objectid=? where oc_encounter_serverid=? and oc_encounter_objectid=?";
    		PreparedStatement ps = conn.prepareStatement(sSql);
    		ps.setInt(1, OC_Object.getObjectId(newUid));
    		ps.setInt(2, OC_Object.getServerId(oldUid));
    		ps.setInt(3, OC_Object.getObjectId(oldUid));
    		ps.execute();
    		ps.close();
    		conn.close();
    		
    		//Update Transactions
    		Vector<TransactionVO> transactions = MedwanQuery.getInstance().getTransactionsByEncounter(Integer.parseInt(encounter.getPatientUID()), encounter.getUid());
    		for(int n=0;n<transactions.size();n++) {
    			TransactionVO transaction = transactions.elementAt(n);
    			ItemVO item = transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_CONTEXT_ENCOUNTERUID");
    			item.updateValue(newUid);
    		}
    		
    		updateTableColumn("OC_CREDITS", "OC_CREDIT_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_DEBETS", "OC_DEBET_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_DIAGNOSES", "OC_DIAGNOSIS_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_DRUGSOUTLIST", "OC_LIST_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_IKIREZIACTIONS", "OC_ACTION_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_IKIREZISYMPTOMS", "OC_SYMPTOM_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_PATIENTCREDITS", "OC_PATIENTCREDIT_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_PRESTATIONDEBETS", "OC_DEBET_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_RFE", "OC_RFE_ENCOUNTERUID", oldUid, newUid);
    		updateTableColumn("OC_SNOMEDCT", "OC_SNOMEDCT_ENCOUNTERUID", oldUid, newUid);

    		bSuccess=true;
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return bSuccess;
    }
    
    public static boolean updateTransactionUid(String oldUid, String newUid) {
    	boolean bSuccess = false;
    	try {
    		updateTableColumn("Transactions", "transactionid", oldUid, newUid);
    		updateTableColumn("Items", "transactionid", oldUid, newUid);
    		updateTableColumn("OC_PLANNING", "OC_PLANNING_TRANSACTIONUID", oldUid, newUid);
    		updateTableColumn("Requestedlabanalyses", "transactionid", oldUid, newUid);

    		bSuccess=true;
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return bSuccess;
    }
    
    public static java.util.Date parseDate(String sDate, SimpleDateFormat dateFormat){
    	reloadDateFormats();
    	java.util.Date date = null;
				
		try{  
			date = dateFormat.parse(sDate);
		}
		catch(Exception e){   
			// try parsing with the other format		    
        	try{
			    if(stdDateFormat.toPattern().equals("dd/MM/yyyy")){
			    	// EU gave error --> try US
			    	date = new SimpleDateFormat("MM/dd/yyyy").parse((String)sDate);
	    		    sDate = dateFormat.format(date);	
			    }
			    else if(stdDateFormat.toPattern().equals("MM/dd/yyyy")){
			    	// US gave error --> try EU
			    	date = new SimpleDateFormat("dd/MM/yyyy").parse((String)sDate);
	    		    sDate = dateFormat.format(date);
			    }
        	}
        	catch(Exception e2){
        		//e2.printStackTrace();
        	}
		}
 
		return date;
    }
    
    public static java.util.Date parseDate(String sDate, String dateFormat){
    	reloadDateFormats();
    	java.util.Date date = null;
				
		try{  
			date = new SimpleDateFormat(dateFormat).parse(sDate);
		}
		catch(Exception e){   
			e.printStackTrace();
		}
 
		return date;
    }
    
    //--- IS DATE VALUE ---------------------------------------------------------------------------
    // recognises date-values
    public static boolean isDateValue(String sValue){
    	boolean isDateValue = false;
    	
    	if(parseDate(sValue)!=null){  
    		isDateValue = true;
    	}
    	
    	return isDateValue;
    }
    
    //--- GET TODAY -------------------------------------------------------------------------------
    public static java.util.Date getToday(){
    	Calendar cal = Calendar.getInstance();
    	cal.setTime(new java.util.Date()); // now
    	cal.set(Calendar.HOUR,0);
    	cal.set(Calendar.MINUTE,0);
    	cal.set(Calendar.SECOND,0);
    	cal.set(Calendar.MILLISECOND,0); 
    	
    	return cal.getTime(); // past midnight
    }
    
    //--- GET TOMORROW ----------------------------------------------------------------------------
    public static java.util.Date getTomorrow(){
    	Calendar cal = Calendar.getInstance();
    	cal.setTime(new java.util.Date()); // now
    	cal.set(Calendar.HOUR,0);
    	cal.set(Calendar.MINUTE,0);
    	cal.set(Calendar.SECOND,0);
    	cal.set(Calendar.MILLISECOND,0);
    	
    	cal.add(Calendar.DAY_OF_YEAR,1);
    	
    	return cal.getTime(); // next midnight
    }

    //--- GET LABEL -------------------------------------------------------------------------------
    public static String getLabel(String sType, String sID, String sLanguage, String sObject){
        return "<label for='"+sObject+"'>"+getTran(null,sType,sID,sLanguage)+"</label>";
    }
    
    //--- LEFT ------------------------------------------------------------------------------------
    public static String left(String s,int n){
    	if(s==null){
    		return "";
    	}
    	else if(s.length()<=n){
    		return s;
    	}
    	else{
    		return s.substring(0,n-3)+"...";
    	}
    }
    
    //--- UPPERCASE FIRST LETTER ------------------------------------------------------------------
    public static String uppercaseFirstLetter(String sValue){
        String sFirstLetter;
        if(sValue.length() > 0){
            sFirstLetter = sValue.substring(0,1).toUpperCase();
            sValue = sFirstLetter+sValue.substring(1);
        }
        
        return sValue;        
    }
    
    //--- BOLD FIRST LETTER -----------------------------------------------------------------------
    // html
    public static String boldFirstLetter(String sValue){
        String sFirstLetter;
        if(sValue.length() > 0){
            sFirstLetter = sValue.substring(0,1).toUpperCase();
            sValue = "<b>"+sFirstLetter+"</b>"+sValue.substring(1);
        }
        
        return sValue;        
    }
    
    //--- COUNT MATCHES IN STRING -----------------------------------------------------------------
    public static int countMatchesInString(String sText, String sTarget){
        int count = 0;

        while(sText.indexOf(sTarget) > -1){
            sText = sText.substring(sText.indexOf(sTarget)+sTarget.length());
            count++;
        }

        return count;
    }
    
    //--- GET PRICE FORMAT ------------------------------------------------------------------------
    public static String getPriceFormat(double value){
    	DecimalFormatSymbols formatSymbols = new DecimalFormatSymbols();
    	formatSymbols.setGroupingSeparator(MedwanQuery.getInstance().getConfigString("decimalThousandsSeparator"," ").toCharArray()[0]);
    	
    	return new DecimalFormat(MedwanQuery.getInstance().getConfigString("priceFormat"),formatSymbols).format(value);
    }

	//--- VECTOR TO STRING ------------------------------------------------------------------------
	public static String vectorToString(Vector vector, String sDelimeter){
	    return vectorToString(vector,sDelimeter,true);
	}
	
	public static String vectorToString(Vector vector, String sDelimeter, boolean addApostrophes){
		StringBuffer stringBuffer = new StringBuffer();
	    
	    for(int i=0; i<vector.size(); i++){
	    	if(addApostrophes) stringBuffer.append("'");
	        stringBuffer.append((String)vector.get(i));	        
	    	if(addApostrophes) stringBuffer.append("'");
	        
	        if(i<vector.size()-1){
	        	stringBuffer.append(sDelimeter);
	        }
	    }		    
	    
	    return stringBuffer.toString();
	}
    
    //--- CUSTOMER INCLUDE ------------------------------------------------------------------------
    public static String customerInclude(String fileName, String sAPPFULLDIR, String sAPPDIR){
        if(fileName.indexOf("?") > 0){
            fileName = fileName.substring(0,fileName.indexOf("?"));
        }

        if(new File((sAPPFULLDIR+"/"+sAPPDIR+"/"+fileName).replaceAll("//","/")).exists()){
            Debug.println("Customer file "+(sAPPFULLDIR+"/"+sAPPDIR+"/"+fileName).replaceAll("//","/")+" found");
            return ("/"+sAPPDIR+"/"+fileName).replaceAll("//","/");
        }
        else{
            Debug.println("Customer file "+(sAPPFULLDIR+"/"+sAPPDIR+"/"+fileName).replaceAll("//","/")+" not found, using "+("/"+fileName).replaceAll("//","/"));
            return ("/"+fileName).replaceAll("//","/");
        }
    }

    //--- GET TRAN --------------------------------------------------------------------------------
    public static String getTran(String sType, String sID, String sLanguage){
        return getTran(null,sType,sID,sLanguage,false);
    }

    public static String getTran(HttpServletRequest request,String sType, String sID, String sLanguage){
        return getTran(request,sType,sID,sLanguage,false);
    }
    
    public static boolean isTimeout(String sName, long intervalInSeconds) {
    	java.util.Date dLastValue = new java.util.Date();
    	try{
    		dLastValue=new SimpleDateFormat("yyyyMMddHHmmss").parse(SH.cs(sName,"19000101000000"));
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return new java.util.Date().getTime()-dLastValue.getTime()>1000*intervalInSeconds;
    }
    
    public static void setTimer(String sName) {
    	MedwanQuery.getInstance().setConfigString(sName, new SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date()));
    }

    public static String getTran(HttpServletRequest request,String sType, String sID, String sLanguage, boolean displaySimplePopup){
    	String labelValue = "";

        try{
            if(sLanguage==null || sLanguage.length()!=2){
                return sID;
            }

            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);

                if(labelValue.length()==0){
                    if(checkString(MedwanQuery.getInstance().getConfigString("showLinkNoTranslation")).equals("on")){
                        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";
                        return "<a href='#' onClick=javascript:openPopup('"+url+"');>"+sID+"</a>"; // onclick without parenthesis
                    }
                    else{
                        return sID;
                    }
                }
                else{
                    return labelValue.replaceAll("'", "´");
                }
            }
            else{
                Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
                if(langHashtable==null){
                    saveUnknownLabel(sType, sID, sLanguage);
                    return sID;
                }

                Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
                if(typeHashtable==null){
                	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
                		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
                		if(sLabel!=null){
                			return sLabel.replaceAll("'", "´");
                		}
                	}
                    if(checkString(MedwanQuery.getInstance().getConfigString("showLinkNoTranslation")).equals("on")){
                        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";
                        return "<a href='#' onClick=javascript:openPopup('"+url+"');>"+sID+"</a>"; // onclick without parenthesis
                    }
                    else{
                        return sID;
                    }
                }

                Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
                if(idHashtable==null){
                	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
                		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
                		if(sLabel!=null){
                			return sLabel.replaceAll("'", "´");
                		}
                	}
                    if(checkString(MedwanQuery.getInstance().getConfigString("showLinkNoTranslation")).equals("on")){
                        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";
                        return "<a href='#' onClick=javascript:openPopup('"+url+"');>"+sID+"</a>"; // onclick without parenthesis
                    }
                    else{
                        return sID;
                    }
                }

                Label label = (Label)idHashtable.get(sID.toLowerCase());
                if(label==null){
                	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
                		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
                		if(sLabel!=null){
                			return sLabel.replaceAll("'", "´");
                		}
                	}
                    if(checkString(MedwanQuery.getInstance().getConfigString("showLinkNoTranslation")).equals("on")){
                        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";
                        return "<a href='#' onClick=javascript:openPopup('"+url+"');>"+sID+"</a>"; // onclick without parenthesis
                    }
                    else{
                        return sID;
                    }
                }
                if(!label.value.contains("<NOREPLACE/>")) {
                	labelValue = label.value.replaceAll("'", "´");
                }
                else {
                	labelValue = label.value;
                }	
                
                // display link to label
                if(labelValue==null || labelValue.trim().length()==0){
                    if(label.showLink==null || label.showLink.equals("1")){
                        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";
                        return "<a href='#' onClick=javascript:openPopup('"+url+"');>"+sID+"</a>"; // onclick without parenthesis
                    }
                }
                else if(request!=null && request.getSession().getAttribute("editmode")!=null && ((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
                    String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select&Mode=mini";
                    return "<span style='cursor: pointer;color: white;background-color: black;font-weight: bold' onclick=\"openPopup('"+url+"',700,100,'Edit');return false;\">"+(labelValue.length()>0?labelValue.substring(0, 1):"")+"</span>"+(labelValue.length()>1?labelValue.substring(1):""); // onclick without parenthesis
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return labelValue.replaceAll("##CR##","\n").replaceAll("'", labelValue.contains("<NOREPLACE/>")?"'":"´");
    }

    //--- GET TRAN WITH LINK ----------------------------------------------------------------------
    public static String getTranWithLink(String sType, String sID, String sLanguage){
        return getTranWithLink(sType,sID,sLanguage,false);
    }

    public static String getTranWithLink(String sType, String sID, String sLanguage, boolean displaySimplePopup){
        String labelValue = "";
        String url = "system/"+(displaySimplePopup?"manageTranslationsPopupSimple":"manageTranslationsPopup")+".jsp&EditOldLabelID="+sID+"&EditOldLabelType="+sType+"&EditOldLabelLang="+sLanguage+"&Action=Select";

        try{
            if(sLanguage.length()!=2) throw new Exception("Language must be a two-letter notation.");

            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);

                if(labelValue.length()==0){
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }
                else{
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+labelValue+"</a>";
                }
            }
            else{
                Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
                if(langHashtable==null){
                    saveUnknownLabel(sType, sID, sLanguage);
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }

                Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
                if(typeHashtable==null){
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }

                Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
                if(idHashtable==null){
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }

                Label label = (Label)idHashtable.get(sID.toLowerCase());
                if(label==null){
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }

                labelValue = label.value;

                // display link to label
                if(labelValue==null || labelValue.trim().length()==0){
                    return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+sID+"</a>";
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return "<a href='#' onClick=\"javascript:openPopup('"+url+"');\">"+labelValue+"</a>";
    }

    //--- GET TRAN DB -----------------------------------------------------------------------------
    public static String getTranDb(String sType, String sID, String sLang){
        String labelValue = "";
        
        if(sType!=null && sID!=null && sLang!=null){
	        PreparedStatement ps = null;
	        ResultSet rs = null;
	        
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        try{
	            if(sLang.length()!=2) throw new Exception("Language must be a two-letter notation.");
	
	            // LOWER
	            String sSelect = "SELECT OC_LABEL_VALUE FROM OC_LABELS"+
	                             " WHERE OC_LABEL_TYPE=? AND OC_LABEL_ID=? AND OC_LABEL_LANGUAGE=?";
	            ps = oc_conn.prepareStatement(sSelect);
	            ps.setString(1,sType.toLowerCase());
	            ps.setString(2,sID.toLowerCase());
	            ps.setString(3,sLang.toLowerCase());
	
	            rs = ps.executeQuery();
	            if(rs.next()){
	                labelValue = checkString(rs.getString("OC_LABEL_VALUE"));
	            }
	            else{
	                labelValue = sID;
	            }
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                if(rs!=null) rs.close();
	                if(ps!=null) ps.close();
	                oc_conn.close();
	            }
	            catch(SQLException se){
	                se.printStackTrace();
	            }
	        }
        }
        
        return labelValue.replaceAll("##CR##","\n").replaceAll("'", "´");
    }

    //--- GET TRAN NO LINK ------------------------------------------------------------------------
    public static String getTranNoLink(String sType, String sID, String sLanguage){  
    	if(sType==null){
    		Debug.println("WARNING - getTranNoLink : sType is null for sID:"+sID+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	if(sID==null){
    		Debug.println("WARNING - getTranNoLink : sID is null for sType:"+sType+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	
        String labelValue = "";
        if(sLanguage!=null && sLanguage.equalsIgnoreCase("f")){
        	sLanguage = "fr";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("n")){
        	sLanguage = "nl";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("e")){
        	sLanguage = "en";
        }

        try{
            if(sLanguage!=null && sLanguage.length()==2){	
	            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
	                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);
	            }
	            else{
	                Hashtable labels = MedwanQuery.getInstance().getLabels();
	                if(labels==null){
	                    saveUnknownLabel(sType,sID,sLanguage);
	                    return sID;
	                }
	                else{
	                    Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
	                    if(langHashtable==null){
	                    	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
	                    		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
	                    		if(sLabel!=null){
	                    			return sLabel.replaceAll("'", "´");
	                    		}
	                    	}
	                        return sID;
	                    }
	
	                    Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
	                    if(typeHashtable==null){
	                    	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
	                    		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
	                    		if(sLabel!=null){
	                    			return sLabel.replaceAll("'", "´");
	                    		}
	                    	}
	                        return sID;
	                    }
	
	                    Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
	                    if(idHashtable==null){
	                    	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
	                    		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
	                    		if(sLabel!=null){
	                    			return sLabel.replaceAll("'", "´");
	                    		}
	                    	}
	                        return sID;
	                    }
	
	                    Label label = (Label)idHashtable.get(sID.toLowerCase());
	                    if(label==null){
	                    	if(MedwanQuery.getInstance().getConfigInt("enableAutoTranslate",0)==1){
	                    		String sLabel=Translate.translateLabel(sType,sID,MedwanQuery.getInstance().getConfigString("autoTranslateSourceLanguage","en"),sLanguage);
	                    		if(sLabel!=null){
	                    			return sLabel.replaceAll("'", "´");
	                    		}
	                    	}
	                        return sID;
	                    }
	
	                    labelValue = label.value.replaceAll("'", "´");
	
	                    // empty label : return id as labelValue
	                    if(labelValue==null || labelValue.trim().length()==0){
	                        return sID;
	                    }
	                }
	            }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return labelValue.replaceAll("##CR##","\n").replaceAll("'", "´");
    }
    public static String getTranNoLinkNoTranslate(String sType, String sID, String sLanguage){  
    	if(sType==null){
    		Debug.println("WARNING - getTranNoLink : sType is null for sID:"+sID+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	if(sID==null){
    		Debug.println("WARNING - getTranNoLink : sID is null for sType:"+sType+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	
        String labelValue = "";
        if(sLanguage!=null && sLanguage.equalsIgnoreCase("f")){
        	sLanguage = "fr";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("n")){
        	sLanguage = "nl";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("e")){
        	sLanguage = "en";
        }

        try{
            if(sLanguage!=null && sLanguage.length()==2){	
	            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
	                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);
	            }
	            else{
	                Hashtable labels = MedwanQuery.getInstance().getLabels();
	                if(labels==null){
	                    saveUnknownLabel(sType,sID,sLanguage);
	                    return sID;
	                }
	                else{
	                    Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
	                    if(langHashtable==null){
	                        return sID;
	                    }
	
	                    Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
	                    if(typeHashtable==null){
	                        return sID;
	                    }
	
	                    Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
	                    if(idHashtable==null){
	                        return sID;
	                    }
	
	                    Label label = (Label)idHashtable.get(sID.toLowerCase());
	                    if(label==null){
	                        return sID;
	                    }
	
	                    labelValue = label.value;
	
	                    // empty label : return id as labelValue
	                    if(labelValue==null || labelValue.trim().length()==0){
	                        return sID;
	                    }
	                }
	            }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return labelValue.replaceAll("##CR##","\n").replaceAll("'", "´");
    }
    
    //--- GET TRAN NO ID --------------------------------------------------------------------------
    public static String getTranNoId(String sType, String sID, String sLanguage){    	
    	if(sType==null){
    		Debug.println("WARNING - getTranNoLink : sType is null for sID:"+sID+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	if(sID==null){
    		Debug.println("WARNING - getTranNoLink : sID is null for sType:"+sType+" and sLanguage:"+sLanguage);
    		return "";
    	}
    	
        String labelValue = "";
        if(sLanguage!=null && sLanguage.equalsIgnoreCase("f")){
        	sLanguage = "fr";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("n")){
        	sLanguage = "nl";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("e")){
        	sLanguage = "en";
        }

        try{
            if(sLanguage!=null && sLanguage.length()==2){	
	            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
	                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);
	            }
	            else{
	                Hashtable labels = MedwanQuery.getInstance().getLabels();
	                if(labels==null){
	                    saveUnknownLabel(sType,sID,sLanguage);
	                    return "";
	                }
	                else{
	                    Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
	                    if(langHashtable==null){
	                        return "";
	                    }
	
	                    Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
	                    if(typeHashtable==null){
	                        return "";
	                    }
	
	                    Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
	                    if(idHashtable==null){
	                        return "";
	                    }
	
	                    Label label = (Label)idHashtable.get(sID.toLowerCase());
	                    if(label==null){
	                        return "";
	                    }
	
	                    labelValue = label.value;
	
	                    // empty label : return id as labelValue
	                    if(labelValue==null || labelValue.trim().length()==0){
	                        return "";
	                    }
	                }
	            }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return labelValue.replaceAll("##CR##","\n");
    }

    //--- GET TRAN NO LINK ------------------------------------------------------------------------
    public static String getTranExists(String sType, String sID, String sLanguage){
        String labelValue = "";
        if(sLanguage!=null && sLanguage.equalsIgnoreCase("f")){
        	sLanguage = "fr";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("n")){
        	sLanguage = "nl";
        }
        else if(sLanguage!=null && sLanguage.equalsIgnoreCase("e")){
        	sLanguage = "en";
        }

        try{
            if(sLanguage!=null && sLanguage.length()==2){
	
	            if(sType.equalsIgnoreCase("service") || sType.equalsIgnoreCase("function")){
	                labelValue = MedwanQuery.getInstance().getLabel(sType.toLowerCase(),sID.toLowerCase(),sLanguage);
	                if(labelValue==sID){
	                	return "";
	                }
	            }
	            else{
	                Hashtable labels = MedwanQuery.getInstance().getLabels();
	                if(labels==null){
	                    saveUnknownLabel(sType,sID,sLanguage);
	                    return "";
	                }
	                else{
	                    Hashtable langHashtable = MedwanQuery.getInstance().getLabels();
	                    if(langHashtable==null){
	                        return "";
	                    }
	
	                    Hashtable typeHashtable = (Hashtable)langHashtable.get(sLanguage.toLowerCase());
	                    if(typeHashtable==null){
	                        return "";
	                    }
	
	                    Hashtable idHashtable = (Hashtable)typeHashtable.get(sType.toLowerCase());
	                    if(idHashtable==null){
	                        return "";
	                    }
	
	                    Label label = (Label)idHashtable.get(sID.toLowerCase());
	                    if(label==null){
	                        return "";
	                    }
	
	                    labelValue = label.value;
	
	                    // empty label : return id as labelValue
	                    if(labelValue==null || labelValue.trim().length()==0){
	                        return "";
	                    }
	                }
	            }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return labelValue.replaceAll("##CR##","\n");
    }

    //--- CONVERT HTML CODE TO CHAR ---------------------------------------------------------------
    public static String convertHtmlCodeToChar(String text){
        text = text.replaceAll("&eacute;","é");
        text = text.replaceAll("&egrave;","è");
        text = text.replaceAll("&euml;","ë");
        text = text.replaceAll("&ouml;","ö");
        text = text.replaceAll("&agrave;","à");
        text = text.replaceAll("&#231;","ç");
        text = text.replaceAll("&#156;","œ");
        text = text.replaceAll("<br>","\r\n");
        text = text.replaceAll("&gt;",">");
        text = text.replaceAll("&lt;","<");

        return text;
    }

    //--- NORMALIZE SPECIAL CHARACTERS ------------------------------------------------------------
    public static String normalizeSpecialCharacters(String sTest){
        sTest = sTest.replaceAll("'","");
        sTest = sTest.replaceAll("´",""); // difference !
        sTest = sTest.replaceAll(" ","");
        sTest = sTest.replaceAll("-","");

        sTest = sTest.replaceAll("é","e");
        sTest = sTest.replaceAll("è","e");
        sTest = sTest.replaceAll("ë","e");
        sTest = sTest.replaceAll("ê","e");
        sTest = sTest.replaceAll("ï","i");
        sTest = sTest.replaceAll("í","i");
        sTest = sTest.replaceAll("ö","o");
        sTest = sTest.replaceAll("ô","o");
        sTest = sTest.replaceAll("ä","a");
        sTest = sTest.replaceAll("á","a");
        sTest = sTest.replaceAll("à","a");
        sTest = sTest.replaceAll("â","a");
        sTest = sTest.replaceAll("ñ","n");

        sTest = sTest.replaceAll("É","E");
        sTest = sTest.replaceAll("È","E");
        sTest = sTest.replaceAll("Ë","E");
        sTest = sTest.replaceAll("Ê","E");
        sTest = sTest.replaceAll("Ï","I");
        sTest = sTest.replaceAll("Ö","O");
        sTest = sTest.replaceAll("Ô","O");
        sTest = sTest.replaceAll("Ï","I");
        sTest = sTest.replaceAll("Í","I");
        sTest = sTest.replaceAll("Ó","O");
        sTest = sTest.replaceAll("Ä","A");
        sTest = sTest.replaceAll("Á","A");
        sTest = sTest.replaceAll("À","A");
        sTest = sTest.replaceAll("Â","A");
        sTest = sTest.replaceAll("Ñ","N");

        return sTest;
    }

public static String removeAccents(String sTest){
        sTest = sTest.replaceAll("é","e");
        sTest = sTest.replaceAll("è","e");
        sTest = sTest.replaceAll("ë","e");
        sTest = sTest.replaceAll("ê","e");
        sTest = sTest.replaceAll("ï","i");
        sTest = sTest.replaceAll("ö","o");
        sTest = sTest.replaceAll("ô","o");
        sTest = sTest.replaceAll("ä","a");
        sTest = sTest.replaceAll("á","a");
        sTest = sTest.replaceAll("à","a");
        sTest = sTest.replaceAll("â","a");
        sTest = sTest.replaceAll("ñ","n");

        sTest = sTest.replaceAll("É","E");
        sTest = sTest.replaceAll("È","E");
        sTest = sTest.replaceAll("Ë","E");
        sTest = sTest.replaceAll("Ê","E");
        sTest = sTest.replaceAll("Ï","I");
        sTest = sTest.replaceAll("Ö","O");
        sTest = sTest.replaceAll("Ô","O");
        sTest = sTest.replaceAll("Í","I");
        sTest = sTest.replaceAll("Ó","O");
        sTest = sTest.replaceAll("Ä","A");
        sTest = sTest.replaceAll("Á","A");
        sTest = sTest.replaceAll("À","A");
        sTest = sTest.replaceAll("Ñ","N");

        return sTest;
    }

    //--- GET CONFIG STRING -----------------------------------------------------------------------
    public static String getConfigString(String key, Connection conn){
        String cs = "";

        try{
            Statement st = conn.createStatement();
            ResultSet Configrs = st.executeQuery("SELECT oc_value FROM OC_Config WHERE oc_key like '"+key+"'"+
                                                 " AND deletetime IS NULL ORDER BY oc_key");
            while(Configrs.next()){
                cs+= Configrs.getString("oc_value");
            }
            Configrs.close();
            st.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }

        return cs;
    }

    //--- GET CONFIG PARAM ------------------------------------------------------------------------
    public static String getConfigParam(String key, String param, Connection conn){
        return getConfigString(key,conn).replaceAll("<param>",param);
    }

    //--- GET CONFIG PARAM ------------------------------------------------------------------------
    public static String getConfigParam(String key, String[] params, Connection conn){
        String result = getConfigString(key,conn);

        for(int i=0; i<params.length; i++){
            result = result.replaceAll("<param"+(i+1)+">",params[i]);
        }

        return result;
    }

    //--- SET ROW ---------------------------------------------------------------------------------
    public static String setRow(String sType, String sID, String sValue, String sLanguage){
        return "<tr><td class='admin'>"+getTran(null,sType,sID,sLanguage)+"</td><td class='admin2'>"+sValue+"</td></tr>";
    }

    public static String setRow(HttpServletRequest request,String sType, String sID, String sValue, String sLanguage){
        return "<tr><td class='admin'>"+getTran(request,sType,sID,sLanguage)+"</td><td class='admin2'>"+sValue+"</td></tr>";
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setMaliAdminPrivateContact(AdminPrivateContact apc, String sLanguage){
    	return setMaliAdminPrivateContact(null, apc, sLanguage);
    }
    public static String setMaliAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length() > 0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length() > 0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","region",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","district",apc.district,sLanguage)+
            setRow(request,"Web","community",apc.sector,sLanguage)+
            setRow(request,"Web","sector",apc.quarter,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","zipcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setCameroonAdminPrivateContact(AdminPrivateContact apc, String sLanguage){
    	return setCameroonAdminPrivateContact(null, apc, sLanguage);
    }
    public static String setCameroonAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","region",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","country.department",apc.district,sLanguage)+
            setRow(request,"Web","arrondissement",apc.sector,sLanguage)+
            setRow(request,"Web","sector",apc.quarter,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","postcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    public static String setBurkinaAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","region",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","province",apc.district,sLanguage)+
            setRow(request,"Web","country.department",apc.sector,sLanguage)+
            setRow(request,"Web","sector",apc.quarter,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","postcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    public static String setPeruAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","country.department",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","region",apc.district,sLanguage)+
            setRow(request,"Web","arrondissement",apc.sector,sLanguage)+
            setRow(request,"Web","postcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","municipality",apc.city,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setGuineaAdminPrivateContact(AdminPrivateContact apc, String sLanguage){
    	return setGuineaAdminPrivateContact(null, apc, sLanguage);
    }
    public static String setGuineaAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","region",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","prefecture",apc.district,sLanguage)+
            setRow(request,"Web","subprefecture",apc.sector,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","postcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setOpenclinicAdminPrivateContact(AdminPrivateContact apc, String sLanguage){
    	return setOpenclinicAdminPrivateContact(null, apc, sLanguage);
    }
    public static String setOpenclinicAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","region",apc.sanitarydistrict,sLanguage)+
            setRow(request,"Web","province",apc.province,sLanguage)+
            setRow(request,"Web","district",apc.district,sLanguage)+
            setRow(request,"Web","community",apc.sector,sLanguage)+
            setRow(request,"Web","sector",apc.quarter,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","zipcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setAdminPrivateContact(AdminPrivateContact apc, String sLanguage){
    	return setAdminPrivateContact(null, apc, sLanguage);
    }
	public static String setAdminPrivateContact(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        if(MedwanQuery.getInstance().getConfigInt("cnarEnabled",0)==1){
	        return(
		            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
		            setRow(request,"Web","country",sCountry,sLanguage)+
		            setRow(request,"Web","district",apc.district,sLanguage)+
		            setRow(request,"Web","zipcode",apc.zipcode,sLanguage)+
		            setRow(request,"Web","province",sProvince,sLanguage)+
		            setRow(request,"Web","city",apc.city,sLanguage)+
		            setRow(request,"Web","email",apc.email,sLanguage)+
		            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
		            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
		            setRow(request,"Web","comment",apc.comment,sLanguage)
	        );
        }
        else{
	        return(
	            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
	            setRow(request,"Web","address",apc.address,sLanguage)+
	            setRow(request,"Web","zipcode",apc.zipcode,sLanguage)+
	            setRow(request,"Web","country",sCountry,sLanguage)+
	            setRow(request,"Web","email",apc.email,sLanguage)+
	            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
	            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
	            setRow(request,"Web","province",sProvince,sLanguage)+
	            setRow(request,"Web","district",apc.district,sLanguage)+
	            setRow(request,"Web","sector",apc.sector,sLanguage)+
	            setRow(request,"Web","cell",apc.cell,sLanguage)+
	            setRow(request,"Web","city",apc.city,sLanguage)+
	            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
	            setRow(request,"Web","business",apc.business,sLanguage)+
	            setRow(request,"Web","comment",apc.comment,sLanguage)
  	        );
        }
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setAdminPrivateContactBurundi(AdminPrivateContact apc, String sLanguage){
    	return setAdminPrivateContactBurundi(null, apc, sLanguage);
    }
    public static String setAdminPrivateContactBurundi(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web.admin","addresschangesince",apc.begin,sLanguage)+
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","province",apc.district,sLanguage)+
            setRow(request,"Web","community",apc.sector,sLanguage)+
            setRow(request,"Web","hill_quarter",apc.city,sLanguage)+
            setRow(request,"Web","zipcode",apc.zipcode,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","email",apc.email,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","cell",apc.cell,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)+
            setRow(request,"Web","comment",apc.comment,sLanguage)
        );
    }

    //--- SET ADMIN PRIVATE CONTACT ---------------------------------------------------------------
    public static String setAdminPrivateContactCDO(AdminPrivateContact apc, String sLanguage){
    	return setAdminPrivateContactCDO(null, apc, sLanguage);
    }
    public static String setAdminPrivateContactCDO(HttpServletRequest request,AdminPrivateContact apc, String sLanguage){
        String sCountry = "&nbsp;";
        if(checkString(apc.country).trim().length()>0){
            sCountry = getTran(null,"Country",apc.country,sLanguage);
        }

        String sProvince = "&nbsp;";
        if(checkString(apc.province).trim().length()>0){
            sProvince = getTran(null,"province",apc.province,sLanguage);
        }
        
        return(
            setRow(request,"Web","address",apc.address,sLanguage)+
            setRow(request,"Web","country",sCountry,sLanguage)+
            setRow(request,"Web","telephone",apc.telephone,sLanguage)+
            setRow(request,"Web","mobile",apc.mobile,sLanguage)+
            setRow(request,"Web","province",apc.district,sLanguage)+
            setRow(request,"Web","community",apc.sector,sLanguage)+
            setRow(request,"Web","function",apc.businessfunction,sLanguage)+
            setRow(request,"Web","business",apc.business,sLanguage)
        );
    }

    //--- WRITE LOOSE DATE FIELD YEAR -------------------------------------------------------------
    public static String writeLooseDateFieldYear(String sName, String sForm, String sValue, 
    		                                     boolean allowPastDates, boolean allowFutureDates,
    		                                     String sWebLanguage, String sCONTEXTDIR){
        String gfPopType = "1"; // default        
        if(allowPastDates && allowFutureDates){
            gfPopType = "1";
        }
        else{
          if(allowFutureDates){ gfPopType = "3"; }
          else if(allowPastDates){ gfPopType = "2"; }
        }

        // datefield that ALSO accepts just a year
        return "<input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='12' onblur='if(!checkDateOnlyYearAllowed(this)){dateError(this);this.value=\"\";}'>" +"&nbsp;<img name='popcal' style='vertical-align:-1px;' onclick='gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a>"+
               "&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick='getToday(document."+sForm+"."+sName+");'>";
    }

    //--- WRITE DATE FIELD ------------------------------------------------------------------------
    public static String writeDateField(String sName, String sForm, String sValue, boolean allowPastDates,
    		                            boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR){
    	return writeDateField(sName,sForm,sValue,allowPastDates,allowFutureDates,sWebLanguage,sCONTEXTDIR,"");    	
    }
    
    public static String writeDateField(String sName, String sForm, String sValue, boolean allowPastDates, 
            boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR, String sExtraOnBlur){
		String gfPopType = "1"; // default        
		if(allowPastDates && allowFutureDates){
			gfPopType = "1";
		}
		else{
			if(allowFutureDates) gfPopType = "3";
			else if(allowPastDates) gfPopType = "2";
		}
		
		String sExtraCondition = "";
		if(!allowFutureDates){
			sExtraCondition = " || isForbiddenFutureDate(this,false)";
		}
		
		if(!allowPastDates){
			sExtraCondition = " || isForbiddenPastDate(this,false)";
		}
		
		return "<span style='white-space: nowrap'><input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='10' onblur='if(!checkDate(this)"+sExtraCondition+"){dateError(this);}else{"+sExtraOnBlur+"}'>"+
		"&nbsp;<img height='16px' name='popcal' style='vertical-align:middle;' onclick='gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a>"+
		"&nbsp;<img height='16px' style='vertical-align:middle;' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick='getToday(document."+sForm+"."+sName+");'></span>";
	}

    public static String writeDateFieldWithReadonly(String sName, String sForm, String sValue, boolean allowPastDates, 
            boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR, String sExtraOnBlur){
		String gfPopType = "1"; // default        
		if(allowPastDates && allowFutureDates){
			gfPopType = "1";
		}
		else{
			if(allowFutureDates) gfPopType = "3";
			else if(allowPastDates) gfPopType = "2";
		}
		
		String sExtraCondition = "";
		if(!allowFutureDates){
			sExtraCondition = " || isForbiddenFutureDate(this,false)";
		}
		
		if(!allowPastDates){
			sExtraCondition = " || isForbiddenPastDate(this,false)";
		}
		
		return "<span style='white-space: nowrap'><input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='10' onblur='if(!checkDate(this)"+sExtraCondition+"){dateError(this);}else{"+sExtraOnBlur+"}'>"+
		"&nbsp;<img height='16px' name='popcal' style='vertical-align:middle;' onclick='if(document.getElementById(\""+sName+"\").getAttribute(\"readonly\")){}else{gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;}' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a>"+
		"&nbsp;<img height='16px' style='vertical-align:middle;' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick='if(document.getElementById(\""+sName+"\").getAttribute(\"readonly\")){}else{getToday(document."+sForm+"."+sName+");}'></span>";
	}
	
    public static String writeDateFieldMPI(String sName, String sForm, String sValue, boolean allowPastDates, 
            boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR, String imageSize){
		String gfPopType = "1"; // default        
		if(allowPastDates && allowFutureDates){
		gfPopType = "1";
		}
		else{
		if(allowFutureDates) gfPopType = "3";
		else if(allowPastDates) gfPopType = "2";
		}
		
		String sExtraCondition = "";
		if(!allowFutureDates){
			sExtraCondition = " || isForbiddenFutureDate(this,false)";
		}
		
        if(!allowPastDates){
        	sExtraCondition = " || isForbiddenPastDate(this,false)";
        }
        
		return "<span style='white-space: nowrap'><input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='10' onblur='if(!checkDate(this)"+sExtraCondition+"){dateError(this);}else{}'>"+
		"&nbsp;<img height='"+imageSize+"' name='popcal' style='vertical-align:middle;' onclick='gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a>"+
		"&nbsp;<img height='"+imageSize+"' style='vertical-align:middle;' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick='getToday(document."+sForm+"."+sName+");'></span>";
	}
	
    //--- WRITE DATE FIELD WITH DELETE ------------------------------------------------------------
    public static String writeDateFieldWithDelete(String sName, String sForm, String sValue, boolean allowPastDates,
    		                                      boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR){
    	return writeDateFieldWithDelete(sName,sForm,sValue,allowPastDates,allowFutureDates,sWebLanguage,sCONTEXTDIR,"");    	
    }
    
    public static String writeDateFieldWithDelete(String sName, String sForm, String sValue, boolean allowPastDates, 
    		                                      boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR, String sExtraOnBlur){
        String gfPopType = "1"; // default        
        if(allowPastDates && allowFutureDates){
            gfPopType = "1";
        }
        else{
               if(allowFutureDates) gfPopType = "3";
          else if(allowPastDates) gfPopType = "2";
        }
        
        String sExtraCondition = "";
        if(!allowFutureDates){
        	sExtraCondition = " || isForbiddenFutureDate(this,false)";
        }
        
        if(!allowPastDates){
        	sExtraCondition = " || isForbiddenPastDate(this,false)";
        }
        
        return "<span style='white-space: nowrap'><input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='10' onblur='if(!checkDate(this)"+sExtraCondition+"){dateError(this);}else{"+sExtraOnBlur+"}'>"
              +"&nbsp;<img name='popcal' style='vertical-align:-1px;' onclick='gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("web","PutToday",sWebLanguage)+"' onclick='getToday(document."+sForm+"."+sName+");'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_delete.png' alt='"+getTranNoLink("web","clear",sWebLanguage)+"' onclick=\"document."+sForm+"."+sName+".value='';\"></span>";
    }

    //--- NEW WRITE DATE TIME FIELD ---------------------------------------------------------------
    public static String newWriteDateTimeField(String sName, java.util.Date dValue, String sWebLanguage, String sCONTEXTDIR){
        return "<span style='white-space: nowrap'><input id='"+sName+"' type='text' maxlength='10' class='text' name='"+sName+"' value='"+getSQLDate(dValue)+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";}'>"
              +"&nbsp;<img id='"+sName+"_popcal' name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"' onclick='gfPop1.fPopCalendar($(\""+sName+"\"));return false;'>"
              +"&nbsp;<img id='"+sName+"_today' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","putToday",sWebLanguage))+"' onclick=\"putTime($('"+sName+"Time'));getToday($('"+sName+"'));\">"
              +"&nbsp;"+writeTimeField(sName+"Time", formatSQLDate(dValue, "HH:mm"))
              +"&nbsp;"+getTran(null,"web.occup", "medwan.common.hour", sWebLanguage)+"</span>";
    }
    
    //--- NEW WRITE DATE TIME FIELD ---------------------------------------------------------------
    public static String newWriteDateField(String sName, java.util.Date dValue, String sWebLanguage, String sCONTEXTDIR){
        return "<span style='white-space: nowrap'><input id='"+sName+"' type='text' maxlength='10' class='text' name='"+sName+"' value='"+getSQLDate(dValue)+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";}'>"
              +"&nbsp;<img name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"' onclick='gfPop1.fPopCalendar($(\""+sName+"\"));return false;'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","putToday",sWebLanguage))+"' onclick=\"getToday($('"+sName+"'));\"></span>";
    }
    
    //--- NEW WRITE DATE TIME FIELD ---------------------------------------------------------------
    public static String newWriteDateField(String sName, java.util.Date dValue, String sWebLanguage, String sCONTEXTDIR, String onBlur){
        return "<span style='white-space: nowrap'><input id='"+sName+"' type='text' maxlength='10' class='text' name='"+sName+"' value='"+getSQLDate(dValue)+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";};"+onBlur+"' onfocus='"+onBlur+"'>"
              +"&nbsp;<img name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"' onclick='gfPop1.fPopCalendar($(\""+sName+"\"));return false;'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","putToday",sWebLanguage))+"' onclick=\"getToday($('"+sName+"'));\"></span>";
    }
    
    //--- PLANNING DATE TIME FIELD ----------------------------------------------------------------
    public static String planningDateTimeField(String sName, String dValue, String sWebLanguage, String sCONTEXTDIR){
        return "<span style='white-space: nowrap'><input id='"+sName+"' type='text' maxlength='10' class='text' name='"+sName+"' value='"+dValue+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";}'>"
              +"&nbsp;<img name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"' onclick='gfPop1.fPopCalendar($(\""+sName+"\"));return false;'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","putToday",sWebLanguage))+"' onclick=\"getToday($('"+sName+"'));\"></span>";
    }
    
    //--- WRITE DATEE FIELD WITHOUT TODAY ---------------------------------------------------------
    public static String writeDateFieldWithoutToday(String sName, String sForm, String sValue, boolean allowPastDates,
    		                                        boolean allowFutureDates, String sWebLanguage, String sCONTEXTDIR){
        String gfPopType = "1"; // default        
        if(allowPastDates && allowFutureDates){
            gfPopType = "1";
        }
        else{
               if(allowFutureDates) gfPopType = "3";
          else if(allowPastDates) gfPopType = "2";
        }

        return "<span style='white-space: nowrap'><input type='text' maxlength='10' class='text' id='"+sName+"' name='"+sName+"' value='"+sValue+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";}'>"
              +"&nbsp;<img name='popcal' style='vertical-align:-1px;' onclick='gfPop"+gfPopType+".fPopCalendar(document."+sForm+"."+sName+");return false;' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+HTMLEntities.htmlentities(getTran(null,"Web","Select",sWebLanguage))+"'></a></span>";
    }

    public static String checkPermission(HttpServletResponse response, String sScreen, String sPermission, User activeUser,
            boolean screenIsPopup, String sCONTEXTPATH){
    	String s = ScreenHelper.checkPermission(sScreen,sPermission,activeUser,false,sCONTEXTPATH);
    	if(s.length()>0) {
    		try {
				response.sendRedirect(sCONTEXTPATH+"/util/noaccess.jsp");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		return "<script>alert('"+sCONTEXTPATH+"/util/noaccess.jsp');</script>";
    	}
    	return s;
    }
    public static String checkPermissionNoSA(HttpServletResponse response, String sScreen, String sPermission, User activeUser,
            boolean screenIsPopup, String sCONTEXTPATH){
    	String s = ScreenHelper.checkPermissionNoSA(sScreen,sPermission,activeUser,false,sCONTEXTPATH);
    	if(s.length()>0) {
    		try {
				response.sendRedirect(sCONTEXTPATH+"/util/noaccess.jsp");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    		return "<script>alert('"+sCONTEXTPATH+"/util/noaccess.jsp');</script>";
    	}
    	return s;
    }
    //--- CHECK PERMISSION ------------------------------------------------------------------------
    public static String checkPermission(String sScreen, String sPermission, User activeUser,
                                         boolean screenIsPopup, String sAPPFULLDIR){
        sPermission = sPermission.toLowerCase();
        String jsAlert = "Error in checkPermission : no screen specified !";
        if(sScreen.trim().length() > 0){
            if(Application.isDisabled(sScreen)){
            	jsAlert = "Application is disabled : '"+sScreen+"'";
            }
            else if(activeUser!=null && activeUser.getParameter("sa")!=null && activeUser.getParameter("sa").length() > 0){
                jsAlert = "";
            }
            else{
                // screen and permission specified
                if(activeUser!=null && sPermission.length() > 0 && !sPermission.equals("all")){
                    if(sPermission.equals("none")){
                    	jsAlert = "";
                    }
                    else if(activeUser.getAccessRight(sScreen+"."+sPermission)){
                        jsAlert = "";
                    }
                }
                // no permission specified -> interprete as all permissions required
                // Managing a page, means you can add, edit and delete.
                else if(activeUser!=null && activeUser.getAccessRight(sScreen+".edit") &&
                         activeUser.getAccessRight(sScreen+".add") &&
                         activeUser.getAccessRight(sScreen+".delete")){
                    jsAlert = "";
                }

                if(jsAlert.length() > 0){
                    String sMessage = getTranNoLink("web","nopermission",activeUser==null || activeUser.person==null?"en":activeUser.person.language);
                    jsAlert = "<script>"+
                               "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;

                    // display permission when in Debug mode
                    if(Debug.enabled) jsAlert+= " --> "+sScreen+(sPermission.length()==0?"":"."+sPermission);

                    jsAlert+=  "';"+
                               "var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
                               "var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
                               (screenIsPopup?"window.close();":"window.history.go(-1);")+
                               "</script>";
                }
            }
        }

        return jsAlert;
    }

    //--- CHECK PERMISSION ------------------------------------------------------------------------
    public static String checkPermissionNoSA(String sScreen, String sPermission, User activeUser,
                                         boolean screenIsPopup, String sAPPFULLDIR){
        sPermission = sPermission.toLowerCase();
        String jsAlert = "Error in checkPermission : no screen specified !";
        if(sScreen.trim().length() > 0){
            if(Application.isDisabled(sScreen)){
            	jsAlert = "Application is disabled : '"+sScreen+"'";
            }
            else if(activeUser!=null && activeUser.getParameter("sa")!=null && activeUser.getParameter("sa").length() > 0){
                jsAlert = "";
            }
            else{
                // screen and permission specified
                if(activeUser!=null && sPermission.length() > 0 && !sPermission.equals("all")){
                    if(sPermission.equals("none")){
                    	jsAlert = "";
                    }
                    else if(activeUser.getAccessRightNoSA(sScreen+"."+sPermission)){
                        jsAlert = "";
                    }
                }
                // no permission specified -> interprete as all permissions required
                // Managing a page, means you can add, edit and delete.
                else if(activeUser!=null && activeUser.getAccessRightNoSA(sScreen+".edit") &&
                         activeUser.getAccessRightNoSA(sScreen+".add") &&
                         activeUser.getAccessRightNoSA(sScreen+".delete")){
                    jsAlert = "";
                }

                if(jsAlert.length() > 0){
                    String sMessage = getTranNoLink("web","nopermission",activeUser==null || activeUser.person==null?"en":activeUser.person.language);
                    jsAlert = "<script>"+
                               "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;

                    // display permission when in Debug mode
                    if(Debug.enabled) jsAlert+= " --> "+sScreen+(sPermission.length()==0?"":"."+sPermission);

                    jsAlert+=  "';"+
                               "var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
                               "var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
                               (screenIsPopup?"window.close();":"window.history.go(-1);")+
                               "</script>";
                }
            }
        }

        return jsAlert;
    }

    //--- CHECK TRANSACTION PERMISSION ------------------------------------------------------------
    static public String checkTransactionPermission(TransactionVO transaction, User activeUser, boolean screenIsPopup, String sAPPFULLDIR){
    	String jsAlert = "";
    	if(checkString(transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants.ITEM_TYPE_PRIVATETRANSACTION")).equalsIgnoreCase("1")){
    		try{
	    		if(!(transaction.getUser().getUserId()+"").equalsIgnoreCase(activeUser.userid)){
	                String sMessage = getTranNoLink("web","privatetransactionerror",activeUser.person.language);
	                jsAlert = "<script>"+(screenIsPopup?"window.confirm('"+sMessage+"');window.close();":"window.confirm('"+sMessage+"');window.history.go(-1);")+"</script>";
	            }
    		}
    		catch(Exception e){
    			e.printStackTrace();
    		}
        }

        return jsAlert;
    }
    public static boolean executeQuery(PreparedStatement ps) {
        try {
        	ps.execute();
        	return true;
        }
        catch(Exception e) {
        	return false;
        }
    }
    //--- CHECK PERMISSION ------------------------------------------------------------------------
    public static String checkPrestationToday(String sPersonId, String sAPPFULLDIR, boolean screenIsPopup,
    		                                  User activeUser, TransactionVO transaction){
        String jsAlert = "";
        String sMessage ="";
        String sEncounterUid="";
    	String sPrestationCode = MedwanQuery.getInstance().getConfigString(transaction.getTransactionType()+".requiredPrestation","");
    	String sPrestationClass = MedwanQuery.getInstance().getConfigString(transaction.getTransactionType()+".requiredPrestationClass","");
    	int nInvoicable = MedwanQuery.getInstance().getConfigInt(transaction.getTransactionType()+".requiredInvoicable",0);

    	if(transaction.getTransactionId()<0 && MedwanQuery.getInstance().getConfigInt("negativePatientBalanceAllowed",1)==0){
    		Balance balance = Balance.getActiveBalance(sPersonId);
    		double saldo = Balance.getPatientBalance(sPersonId);
    		if(saldo<balance.getMinimumBalance()){
    			sMessage = getTranNoLink("web","notpermittedwithnegativebalance",activeUser.person.language);
    		}
    	}
    	if(sMessage.length()==0) {
	        Encounter encounter = Encounter.getActiveEncounter(sPersonId);
	    	if(encounter!=null){
	    		sEncounterUid=encounter.getUid();
	    	}
	    	
	        if(sEncounterUid.length()>0 && sEncounterUid.split("\\.").length==2 && transaction.getTransactionId()<0 && MedwanQuery.getInstance().getConfigInt("activateOutpatientConsultationPrestationCheck",0)==1){
	        	if(checkString(sPrestationCode).length() > 0){
	    			Prestation prestation = Prestation.getByCode(sPrestationCode);
	    			if(prestation.getUid()!=null && prestation.getUid().split("\\.").length==2){
		        		try{
			        		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
			        		String sQuery = "select * from oc_debets"+
			        		                " where oc_debet_date>=? and oc_debet_encounteruid=? and oc_debet_prestationuid=?";
			        		if(MedwanQuery.getInstance().getConfigInt(transaction.getTransactionType()+".requiredPrestation.invoiced",0)==1){
			        			sQuery = "select * from oc_debets"+
			        		             " where oc_debet_date>=? and oc_debet_encounteruid=? and oc_debet_prestationuid=?"+
			        		             "  and oc_debet_patientinvoiceuid like '%.%'";
			        		}
			        		PreparedStatement ps = conn.prepareStatement(sQuery);
			        		ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(ScreenHelper.stdDateFormat.format(new java.util.Date())).getTime()));
			        		ps.setString(2,sEncounterUid);
			        		ps.setString(3,prestation.getUid());
			        		ResultSet rs = ps.executeQuery();
			        		if(!rs.next()){
			        			sMessage = getTranNoLink("web","noactiveprestation",activeUser.person.language)+" `"+prestation.getCode()+": "+prestation.getDescription()+"`";
			        		}
			        		rs.close();
			        		ps.close();
			        		conn.close();
		        		}
		        		catch(Exception e){
		        			e.printStackTrace();
		        		}
	    			}
	        	}
	        }
	        if(transaction.getTransactionId()<0) {
	        	if(nInvoicable==1){
	        		//Check if invoicing conditions have been met
	        		if(Encounter.getActiveEncounter(sPersonId)==null || Insurance.getMostInterestingInsuranceForPatient(sPersonId)==null){
	        			sMessage = getTranNoLink("web","notinvoicable",activeUser.person.language);
	        		}
	        	}
	        	
	            if(checkString(sPrestationClass).length() > 0){
	        		try{
		        		Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
		        		String sQuery = "select * from oc_debets a, oc_prestations b where a.oc_debet_date>=? and a.oc_debet_encounteruid=? and b.oc_prestation_objectid=replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') and b.oc_prestation_class=?";
		        		if(MedwanQuery.getInstance().getConfigInt(transaction.getTransactionType()+".requiredPrestationClass.invoiced",0)==1){
		        			sQuery = "select * from oc_debets a, oc_prestations b where a.oc_debet_date>=? and a.oc_debet_encounteruid=? and a.oc_debet_patientinvoiceuid like '%.%' and b.oc_prestation_objectid=replace(a.oc_debet_prestationuid,'"+MedwanQuery.getInstance().getConfigString("serverId","1")+".','') and b.oc_prestation_class=?";
		        		}
		        		PreparedStatement ps = conn.prepareStatement(sQuery);
		        		ps.setDate(1,new java.sql.Date(ScreenHelper.parseDate(ScreenHelper.stdDateFormat.format(new java.util.Date())).getTime()));
		        		ps.setString(2,sEncounterUid);
		        		ps.setString(3,sPrestationClass);
		        		ResultSet rs = ps.executeQuery();
		        		if(!rs.next()){
		        			sMessage = getTranNoLink("web","noactiveprestationclass",activeUser.person.language)+" `"+getTran(null,"prestation.class",sPrestationClass,activeUser.person.language)+"`";
		        		}
		        		rs.close();
		        		ps.close();
		        		conn.close();
	        		}
	        		catch(Exception e){
	        			e.printStackTrace();
	        		}
	        	}
	        }
    	}
    	if(checkString(sMessage).length()>0){
            jsAlert = "<script>"+
                      "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;

            jsAlert+= "';"+
                      " var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
                      " var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
                      (screenIsPopup?"window.close();":"window.history.go(-1);")+
                      "</script>";
    	}
        else if (transaction.getTransactionId()<0 && MedwanQuery.getInstance().getConfigInt("activateOutpatientConsultationPrestationCheck",0)==1 && sPrestationCode.length()>0){
			Prestation prestation = Prestation.getByCode(sPrestationCode);
			if(prestation!=null){
	        	sMessage = getTranNoLink("web","noactiveprestation",activeUser.person.language)+" `"+prestation.getCode()+": "+prestation.getDescription()+"`";
	            jsAlert = "<script>"+(screenIsPopup?"window.close();":"window.history.go(-1);")+
	                    "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;
	
				jsAlert+= "';"+
						" var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
						" var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
						"</script>";
			}
        }
        else if (transaction.getTransactionId()<0 && MedwanQuery.getInstance().getConfigInt("activateOutpatientConsultationPrestationCheck",0)==1 && sPrestationClass.length()>0){
			sMessage = getTranNoLink("web","noactiveprestationclass",activeUser.person.language)+" `"+getTran(null,"prestation.class",sPrestationClass,activeUser.person.language)+"`";
            jsAlert = "<script>"+(screenIsPopup?"window.close();":"window.history.go(-1);")+
                    "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;

			jsAlert+= "';"+
					" var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
					" var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
					"</script>";
        	
        }
        else if (transaction.getTransactionId()<0 && MedwanQuery.getInstance().getConfigInt("activateOutpatientConsultationPrestationCheck",0)==1 && nInvoicable==1){
			sMessage = getTranNoLink("web","notinvoicable",activeUser.person.language);
            jsAlert = "<script>"+(screenIsPopup?"window.close();":"window.history.go(-1);")+
                    "var popupUrl = '"+sAPPFULLDIR+"/_common/search/okPopup.jsp?ts="+getTs()+"&labelValue="+sMessage;

			jsAlert+= "';"+
					" var modalities = 'dialogWidth:266px;dialogHeight:143px;center:yes;scrollbars:no;resizable:no;status:no;location:no;';"+
					" var answer = (window.showModalDialog)?window.showModalDialog(popupUrl,\"\",modalities):window.confirm(\""+sMessage+"\");"+
					"</script>";
        	
        }

        return jsAlert;
    }

    //--- WRITE SEARCH BUTTON ---------------------------------------------------------------------
    public static String writeSearchButton(String sButtonName, String sLabelType, String sVarCode, String sVarText,
                                           String sShowID, String sWebLanguage, String sCONTEXTDIR){
        return "<img src='"+sCONTEXTDIR+"/_img/icons/icon_search.png' id='"+sButtonName+"' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"'"
              +"onclick='openPopup(\"_common/search/searchScreen.jsp&LabelType="+sLabelType+"&VarCode="+sVarCode+"&VarText="+sVarText+"&ShowID="+sShowID+"\");'>"
              +"&nbsp;<img src='"+sCONTEXTDIR+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick=\""+sVarCode+".value='';"+sVarText+".value='';\">";
    }

    public static String writeSearchButton(String sButtonName, String sLabelType, String sVarCode, String sVarText,
                                           String sShowID,String sWebLanguage, String defaultValue, String sCONTEXTDIR){
        return "<img src='"+sCONTEXTDIR+"/_img/icons/icon_search.png' id='"+sButtonName+"' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"'"
              +" onclick='openPopup(\"_common/search/searchScreen.jsp&LabelType="+sLabelType+"&VarCode="+sVarCode+"&VarText="+sVarText+"&ShowID="+sShowID+"&DefaultValue="+defaultValue+"\");'>"
              +"&nbsp;<img src='"+sCONTEXTDIR+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick=\""+sVarCode+".value='';"+sVarText+".value='';\">";
    }

    //--- WRITE SERVICE BUTTON --------------------------------------------------------------------
    public static String writeServiceButton(String sButtonName, String sVarCode, String sVarText,String sWebLanguage, String sCONTEXTDIR){
        return writeServiceButton(sButtonName,sVarCode,sVarText,false,sWebLanguage,sCONTEXTDIR);
    }

    public static String writeServiceButton(String sButtonName, String sVarCode, String sVarText,
                                            boolean onlySelectContractWithDivision, String sWebLanguage, String sCONTEXTDIR){
        return  "<img style='vertical-align: middle'  src='"+sCONTEXTDIR+"/_img/icons/icon_search.png' id='"+sButtonName+"' class='link' alt='"+getTranNoLink("Web","select",sWebLanguage)+"'"
              +"onclick='openPopup(\"_common/search/searchService.jsp&VarCode="+sVarCode+"&VarText="+sVarText+"&onlySelectContractWithDivision="+onlySelectContractWithDivision+"\");'>"
              +"&nbsp;<img style='vertical-align: middle' src='"+sCONTEXTDIR+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",sWebLanguage)+"' onclick=\"document.getElementsByName('"+sVarCode+"')[0].value='';document.getElementsByName('"+sVarText+"')[0].value='';\">";
    }
    
    public static void saveTransactionItemTranslation(String sItemTypeId,String sTranslationId) throws SQLException{
    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
    	PreparedStatement ps = conn.prepareStatement("select modifier from transactionitems where itemtypeid=?");
    	ps.setString(1, sItemTypeId);
    	ResultSet rs = ps.executeQuery();
    	if(!rs.next()){
    		String modifier = checkString(rs.getString("modifier"));
    		if(!modifier.contains(";"+sTranslationId)){
    			String[] modifierparts = modifier.split(";");
    			modifier="";
    			if(modifierparts.length>=2){
    				for(int n=0;n<modifierparts.length;n++){
    					if(n==0){
    						modifier+=modifierparts[0];
    					}
    					else if(n==1){
    						modifier+=";"+sTranslationId;
    					}
    					else {
    						modifier+=";"+modifierparts[n];
    					}
    				}
    			}
    			else{
    				modifier+=modifierparts[0]+";"+sTranslationId;
    			}
    			rs.close();
    			ps.close();
    			ps = conn.prepareStatement("update transactionitems set modifier=? where itemtypeid=?");
    			ps.setString(1, modifier);
    			ps.setString(2, sItemTypeId);
    			ps.execute();
    		}
    	}
    	rs.close();
    	ps.close();
    	conn.close();
    }
    
    public static void saveTransactionItemTranslation(String sTransactionTypeId, String sItemTypeId,String sTranslationId){
    	try{
	    	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
	    	PreparedStatement ps = conn.prepareStatement("select modifier from transactionitems where transactiontypeid=? and itemtypeid=?");
	    	ps.setString(1, sTransactionTypeId);
	    	ps.setString(2, sItemTypeId);
	    	ResultSet rs = ps.executeQuery();
	    	if(rs.next()){
		    	String modifier = checkString(rs.getString("modifier"));
	    		if(!modifier.contains(";"+sTranslationId)){
	    			String[] modifierparts = modifier.split(";");
	    			modifier="";
	    			if(modifierparts.length>=2){
	    				for(int n=0;n<modifierparts.length;n++){
	    					if(n==0){
	    						modifier+=modifierparts[0];
	    					}
	    					else if(n==1){
	    						modifier+=";"+sTranslationId;
	    					}
	    					else {
	    						modifier+=";"+modifierparts[n];
	    					}
	    				}
	    			}
	    			else{
	    				modifier+=modifierparts[0]+";"+sTranslationId;
	    			}
	    			rs.close();
	    			ps.close();
	    			ps = conn.prepareStatement("update transactionitems set modifier=? where transactiontypeid=? and itemtypeid=?");
	    			ps.setString(1, modifier);
	    			ps.setString(2, sTransactionTypeId);
	    			ps.setString(3, sItemTypeId);
	    			ps.execute();
	    		}
	    	}
	    	rs.close();
	    	ps.close();
	    	conn.close();
    	}
    	catch(Exception e){
    		e.printStackTrace();
    	}
    }
    
    public static String writeDefaultCheckBox(TransactionVO transaction,HttpServletRequest request,String sLabelType, String sName, String sWebLanguage, String sEvent){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else {
    		StringBuffer s = new StringBuffer();
    		s.append("<input "+setRightClickMini(request.getSession(), sName)+" "+sEvent+" type='checkbox' id='"+sName+"' value='1'");
	    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
            if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue().equalsIgnoreCase("1")){
                s.append(" checked");
            }
            s.append(">");
            return s.toString();
    	}
    }
    public static String writeDefaultCheckBox(TransactionVO transaction,HttpServletRequest request,String sValue, String sName, String sEvent){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else {
    		StringBuffer s = new StringBuffer();
    		s.append("<input "+setRightClickMini(request.getSession(), sName)+" "+sEvent+" type='checkbox' id='"+sName+"' value='"+sValue+"'");
	    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
            if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue().equalsIgnoreCase(sValue)){
                s.append(" checked");
            }
            s.append(">");
            return s.toString();
    	}
    }
    public static String writeDefaultCheckBoxes(TransactionVO transaction,HttpServletRequest request,String sLabelType, String sName, String sWebLanguage, boolean sorted){
    	return writeDefaultCheckBoxes(transaction, request, sLabelType, sName, sWebLanguage, sorted, "");
    }
    public static String writeDefaultCheckBoxes(TransactionVO transaction,HttpServletRequest request,String sLabelType, String sName, String sWebLanguage, boolean sorted, String sEvent){
    	return writeDefaultCheckBoxes(transaction, request, sLabelType, sName, sWebLanguage, sorted, sEvent,"");
    }
    public static String writeDefaultCheckBoxes(TransactionVO transaction,HttpServletRequest request,String sLabelType, String sName, String sWebLanguage, boolean sorted, String sEvent,String separator){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	String sSelected = transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue();
    		StringBuffer s = new StringBuffer();
    		s.append(writeDefaultHiddenInput(transaction, sName));
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, sLabelType);
	        	s.append("<img width='16' src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_plus.png' onclick='window.open(\""+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1\",\"popup\",\"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no\")'/>");
	        }

	    	Label label;
	        Iterator it;
	        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
	        if(labelTypes!=null){
	            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

	            if(labelIds!=null){
	                Enumeration idsEnum = labelIds.elements();
	                Hashtable hSelected = new Hashtable();

	                if(sorted){
	                    // sorted on value
	                    while(idsEnum.hasMoreElements()){
	                        label = (Label)idsEnum.nextElement();
	                        hSelected.put(label.value,label.id);
	                    }
	                }
	                else{
	                    // sorted on id
	                    while(idsEnum.hasMoreElements()){
	                        label = (Label)idsEnum.nextElement();
	                        hSelected.put(label.id,label.value);
	                    }
	                }

	                // sort on keys :
	                //  when sorted (on value), key = labelValue
	                //  when !sorted (sorted on id), key = labelID
	                Vector keys = new Vector(hSelected.keySet());
	                Collections.sort(keys);
	                it = keys.iterator();

	                // to html
	                String sLabelValue, sLabelID;
	                while(it.hasNext()){
	                    if(sorted){
	                        sLabelValue = (String)it.next();
	                        sLabelID = (String)hSelected.get(sLabelValue);
	                    }
	                    else{
	                        sLabelID = (String)it.next();
	                        sLabelValue = (String)hSelected.get(sLabelID);
	                    }

	                    s.append("<label style='display: inline-block;'><input "+setRightClickMini(request.getSession(), sName)+" "+(checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")?"title='"+sName+"' ":"")+sEvent+" onclick='updateMultiCheckbox(this,\""+sName+"\",\""+sLabelID+"\")' type='checkbox' name='"+sName+"."+sLabelID+"' id='"+sName+"."+sLabelID+"' value='"+sLabelID+"'");
	                    if(arrayContains(sSelected,sLabelID,";")){
	                        s.append(" checked");
	                    }

	                    s.append(">"+sLabelValue+"</label> "+(it.hasNext()?separator:""));
	                }
	            }
	        }
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultRadioButtons(TransactionVO transaction,HttpServletRequest request,String sLabelType, String sName, String sWebLanguage, boolean sorted, String sEvent, String separator){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	String sSelected = transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue();
    		StringBuffer s = new StringBuffer();
    		s.append(writeDefaultHiddenInput(transaction, sName));
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, sLabelType);
	        	s.append("<img width='16' src='"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/_img/icons/icon_plus.png' onclick='window.open(\""+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1\",\"popup\",\"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no\")'/>");
	        }

	    	Label label;
	        Iterator it;

	        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
	        if(labelTypes!=null){
	            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

	            if(labelIds!=null){
	                Enumeration idsEnum = labelIds.elements();
	                Hashtable hSelected = new Hashtable();

	                if(sorted){
	                    // sorted on value
	                    while(idsEnum.hasMoreElements()){
	                        label = (Label)idsEnum.nextElement();
	                        hSelected.put(label.value,label.id);
	                    }
	                }
	                else{
	                    // sorted on id
	                    while(idsEnum.hasMoreElements()){
	                        label = (Label)idsEnum.nextElement();
	                        hSelected.put(label.id,label.value);
	                    }
	                }

	                // sort on keys :
	                //  when sorted (on value), key = labelValue
	                //  when !sorted (sorted on id), key = labelID
	                Vector keys = new Vector(hSelected.keySet());
	                Collections.sort(keys);
	                it = keys.iterator();

	                // to html
	                String sLabelValue, sLabelID;
	                while(it.hasNext()){
	                    if(sorted){
	                        sLabelValue = (String)it.next();
	                        sLabelID = (String)hSelected.get(sLabelValue);
	                    }
	                    else{
	                        sLabelID = (String)it.next();
	                        sLabelValue = (String)hSelected.get(sLabelID);
	                    }

	                    s.append("<label style='display: inline-block;'><input "+setRightClickMini(request.getSession(), sName)+" "+sEvent+" ondblclick='uncheckRadio(this)' onclick='document.getElementById(\""+sName+"\").value=\""+sLabelID+";\";' type='radio' name='"+sName+".radio' id='"+sName+"."+sLabelID+"' value='"+sLabelID+"'");
	                    if(arrayContains(sSelected,sLabelID,";")){
	                        s.append(" checked");
	                    }

	                    s.append(">"+sLabelValue+"</label> "+separator);
	                }
	            }
	        }
	    	return s.toString();
    	}
    }
    

    public static String writeDefaultNomenclatureField(HttpSession session, TransactionVO transaction, String sName, String type, int cols,String language,String contextPath, String sEvent){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	        if(session!=null && checkString((String)session.getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, type);
	        }
    		String sItemValue=transaction.getItemValue("be.mxs.common.model.vo.healthrecord.IConstants."+sName);
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input class='text' "+setRightClick(session, sName)+" type='text' name='"+sName+"_text' id='"+sName+"_text' READONLY size='"+cols+"' title='"+getTranNoLink(type,sItemValue,language)+"' value='"+getTranNoLink(type,sItemValue,language)+"'>");
	    	s.append("<img src='"+contextPath+"/_img/icons/icon_search.png' class='link' alt='"+getTranNoLink("Web","select",language)+"' onclick='searchGeneralNomenclature(\""+sName+"_code\",\""+sName+"_text\",\""+type+"\");'>");
	    	s.append("<img src='"+contextPath+"/_img/icons/icon_delete.png' class='link' alt='"+getTranNoLink("Web","clear",language)+"' onclick='document.getElementById(\""+sName+"_code\").value=\"\";document.getElementById(\""+sName+"_text\").value=\"\";'>");
	    	s.append("<input  "+sEvent+" type='hidden' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' id='"+sName+"_code' value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"'>");
	    	return s.toString();
    	}
    }

    public static String writeDefaultTextArea(HttpSession session, TransactionVO transaction, String sName,int cols, int rows){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<textarea onkeyup='resizeTextarea(this,10);limitChars(this,5000);' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' cols='"+cols+"' rows='"+rows+"' id='"+sName+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'>");
	    	s.append(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"</textarea>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInput(HttpSession session, TransactionVO transaction, String sName,int cols){
    	return writeDefaultTextInput(session, transaction, sName, cols, "");
    }
    
    public static String writeDefaultTextInput(HttpSession session, TransactionVO transaction, String sName,int cols,String event){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' "+event+"/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInputNoClass(HttpSession session, TransactionVO transaction, String sName,int cols,String event){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(" size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' "+event+"/>");
	    	return s.toString();
    	}
    }
    
    public static java.util.Date getEndOfMonth(java.util.Date date){
    	try {
			java.util.Date newdate = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(date));
			newdate = new java.util.Date(newdate.getTime()+getTimeDay()*32);
			newdate = new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(newdate));
			newdate = new java.util.Date(newdate.getTime()-getTimeSecond());
			return newdate;
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return null;
    }

    public static java.util.Date getBeginOfMonth(java.util.Date date){
		try {
			return new SimpleDateFormat("dd/MM/yyyy").parse("01/"+new SimpleDateFormat("MM/yyyy").format(date));
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
    }

    public static java.util.Date getBeginOfNextMonth(java.util.Date date){
		return getBeginOfMonth(new java.util.Date(getBeginOfMonth(date).getTime()+32*getTimeDay()));
    }

    public static String writeDefaultTextInputSticky(HttpSession session, TransactionVO transaction, String sName,int cols){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
    		String sValue=transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue();
    		if(sValue.length()==0) {
    			AdminPerson activePatient = (AdminPerson)session.getAttribute("activePatient");
    			if(activePatient!=null) {
    				sValue=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants."+sName);
    			}
    		}
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+sValue+"'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInputSticky(HttpSession session, TransactionVO transaction, String sName,int cols,String onblur){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
    		String sValue=transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue();
    		if(sValue.length()==0) {
    			AdminPerson activePatient = (AdminPerson)session.getAttribute("activePatient");
    			if(activePatient!=null) {
    				sValue=MedwanQuery.getInstance().getLastItemValue(Integer.parseInt(activePatient.personid), "be.mxs.common.model.vo.healthrecord.IConstants."+sName);
    			}
    		}
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+sValue+"'"+(onblur.length()>0?" onblur=\""+onblur+"\"":"")+"/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInputCenter(HttpSession session, TransactionVO transaction, String sName,int cols){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClickCenter(session,sName));
	    	s.append(" class='textcenter' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInputReadonly(HttpSession session, TransactionVO transaction, String sName,int cols){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input readonly type='text' id='"+sName+"' ");
	    	//s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultTextInputReadonly(HttpSession session, TransactionVO transaction, String sName,int cols, String sOnEvent){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input readonly type='text' id='"+sName+"' ");
	    	//s.append(setRightClick(session,sName));
	    	s.append(" size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' "+sOnEvent+"/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultDateInput(HttpSession session, TransactionVO transaction, String sName, String language,String contextpath){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='12' maxlength='10' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" onblur='checkDate(this);' value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"'/>");
	    	s.append("<script>writeMyDate('"+sName+"', '"+contextpath+"/_img/icons/icon_agenda.png', '"+ScreenHelper.getTranNoLink("web","PutToday",language)+"');</script>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultDateInput(HttpSession session, TransactionVO transaction, String sName, String language,String contextpath, String event){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session,sName));
	    	s.append(" class='text' size='12' maxlength='10' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" onblur='checkDate(this);' "+event+" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"'/>");
	    	s.append("<script>writeMyDate('"+sName+"', '"+contextpath+"/_img/icons/icon_agenda.png', '"+ScreenHelper.getTranNoLink("web","PutToday",language)+"');</script>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultKeywordField(HttpSession session, TransactionVO transaction, String sName,String keywordstype, String keywordsdiv,String contextpath,String language, HttpServletRequest request){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName+"CODES")==null){
    		return("Unknown items: <br/>"+
    				"<a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"CODES\");'>"+sName+"CODES</a><br/>"+
    				"<a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"TEXT\");'>"+sName+"TEXT</a>"
    				);
    	}
    	else{
    		String sKeywords=getKeywordsHTML(transaction,ScreenHelper.ITEM_PREFIX+sName+"CODES",sName+"IDS",sName+"CODES",language,contextpath);
	    	StringBuffer s = new StringBuffer();
	    	s.append("<table width='100%' cellspacing='0' cellpadding='0'>");
	    	s.append("<tr onclick='selectKeywords(\""+sName+"CODES\",\""+sName+"IDS\",\""+keywordstype+"\",\""+keywordsdiv+"\",\"keywords_title_"+sName+"\",\"keywords_key_"+sName+"\",event.clientY)'>");
	    	s.append("<td>");
	    	s.append(writeDefaultTextArea(session, (TransactionVO)transaction, sName+"TEXT", 45, 1));
	    	s.append("</td>");
	    	s.append("<td width='40' nowrap style='text-align:center'>");
	    	s.append("<img width='16' id='keywords_key_"+sName+"' class='link' src='"+contextpath+"/_img/themes/default/keywords.jpg'/>");
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, keywordstype);
	        	s.append("<img width='16' src='"+contextpath+"/_img/icons/icon_plus.png' onclick='window.open(\""+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+keywordstype+"&find=1\",\"popup\",\"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no\")'/>");
	        }
	    	s.append("</td>");
	    	s.append("<td width='50%' style='vertical-align:top;'>");
	    	s.append("<div "+setRightClickMini(session, sName+"CODES")+" id='"+sName+"IDS'>"+(sKeywords.trim().length()==0?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":sKeywords)+"</div>");
	    	s.append(writeDefaultHiddenInput((TransactionVO)transaction, sName+"CODES"));
	    	s.append("</td>");
	    	s.append("</tr>");
	    	s.append("</table>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultHiddenInput(TransactionVO transaction, String sName){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='hidden' id='"+sName+"' ");
	    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue().replaceAll("'", "´")+"'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultSelect(HttpServletRequest request,TransactionVO transaction, String sName,String type, String language, String sEvent){
    	return writeDefaultSelect(request, transaction, sName, type, language, sEvent, "");
    }
    public static String writeDefaultSelect(HttpServletRequest request,TransactionVO transaction, String sName,String type, String language, String sEvent,String sDefault){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	String itemValue=checkString(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue());
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, type);
		    	s.append("<select style='vertical-align: top' title='"+sName+"' "+setRightClickMini(request.getSession(),sName)+" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' style='border:2px solid black; border-style: dotted' id='"+sName+"' onclick='window.open(\""+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+type+"&find=1\",\"popup\",\"toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no\")'>");
		    	s.append(" <option/>");
		    	s.append(writeSelect(request,type,itemValue.length()==0 && checkString(sDefault).length()>0?sDefault:itemValue,language));
		    	s.append("</select>");
	        }
	        else{
		    	s.append("<select style='vertical-align: top' "+(request==null?"":setRightClickNoClass(request.getSession(),sName)+" ")+sEvent+" class='text' id='"+sName+"' ");
		    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'>");
		    	s.append(" <option/>");
		    	s.append(writeSelect(request,type,itemValue.length()==0 && checkString(sDefault).length()>0?sDefault:itemValue,language));
		    	s.append(" </select>");
	        }
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultToggle(HttpServletRequest request,TransactionVO transaction, String sName,String type, String language, String sEvent){
    	return writeDefaultToggle(request, transaction, sName, type, language, sEvent, "");
    }
    public static String writeDefaultToggle(HttpServletRequest request,TransactionVO transaction, String sName,String type, String language, String sEvent,String sDefault){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	String itemValue=checkString(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue());
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
	    		saveTransactionItemTranslation(transaction.getTransactionType(), "be.mxs.common.model.vo.healthrecord.IConstants."+sName, type);
		    	s.append("<div class='switch-field'>");
		    	s.append(writeToggleMain(request,type,itemValue.length()==0 && checkString(sDefault).length()>0?sDefault:itemValue,language,"currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value",sName,sEvent));
		    	s.append("</div>");
	        }
	        else{
		    	s.append("<div class='switch-field'>");
		    	s.append(writeToggleMain(request,type,itemValue.length()==0 && checkString(sDefault).length()>0?sDefault:itemValue,language,"currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value",sName,sEvent));
		    	s.append("</div>");
	        }
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultSelect(HttpServletRequest request,TransactionVO transaction, String sName, String language, String sEvent,int min,int max){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
		    	s.append("<select style='vertical-align: top' title='"+sName+"' "+sEvent+" class='text' id='"+sName+"' "+setRightClickMini(request.getSession(),sName));
		    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'>");
		    	s.append(" <option/>");
		    	for(int n=min;n<=max;n++){
		    		s.append("<option value='"+n+"' "+(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue().equalsIgnoreCase(n+"")?"selected":"")+">"+n+"</option>");
		    	}
		    	s.append("</select>");
	        }
	        else{
		    	s.append("<select style='vertical-align: top' "+sEvent+" class='text' id='"+sName+"' title='"+setRightClick(request.getSession(),sName)+"' ");
		    	s.append(" name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value'>");
		    	s.append(" <option/>");
		    	for(int n=min;n<=max;n++){
		    		s.append("<option value='"+n+"' "+(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue().equalsIgnoreCase(n+"")?"selected":"")+">"+n+"</option>");
		    	}
		    	s.append(" </select>");
	        }
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,String language){
    	return writeDefaultNumericInput(session, transaction, sName, cols, language, "");
    }
    
    public static String writeDefaultNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,String language, String onChange){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session, sName,onChange));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='isNumber(this)'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultNumericInputReadonly(HttpSession session, TransactionVO transaction, String sName,int cols,String language, String onChange){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input readonly type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session, sName,onChange));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='isNumber(this)'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultVisualNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,String language,String contextpath){
    	return writeDefaultVisualNumericInput(session, transaction, sName, cols, language, contextpath, "");
    }
    
    public static String writeDefaultVisualNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,String language,String contextpath, String onChange){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<label style='display: inline-block;'><img onclick='document.getElementById(\""+sName+"\").value=document.getElementById(\""+sName+"\").value*1-1;document.getElementById(\""+sName+"\").onchange();' style='vertical-align:bottom;' src='"+contextpath+"/_img/icons/mobile/decrease.png' height='16px'/>");
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session, sName, onChange));
	    	s.append(" class='text' style='text-align: center;' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='isNumber(this)'/>");
	    	s.append("<img onclick='document.getElementById(\""+sName+"\").value=document.getElementById(\""+sName+"\").value*1+1;document.getElementById(\""+sName+"\").onchange();' style='vertical-align:top;' src='"+contextpath+"/_img/icons/mobile/increase.png' height='16px'/></label>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,double min,double max,String language){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session, sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='if(!this.value==\"\" && !isNumberLimited(this,"+min+","+max+")){this.value=\"\";alert(\""+getTranNoLink("web","valueoutofrange",language)+": "+min+" - "+max+"\");this.focus();}'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,double min,double max,String language, String sOnBlur){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(setRightClick(session, sName));
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='if(!this.value==\"\" && !isNumberLimited(this,"+min+","+max+")){this.value=\"\";alert(\""+getTranNoLink("web","valueoutofrange",language)+": "+min+" - "+max+"\");this.focus();}else{"+sOnBlur+";}'/>");
	    	return s.toString();
    	}
    }
    
    public static String writeDefaultNumericInput(HttpSession session, TransactionVO transaction, String sName,int cols,double min,double max,String language, String sOnBlur, String sOnEvent){
    	if(transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName)==null){
    		return("Unknown item: <a href='javascript:createTransactionItem(\""+transaction.getTransactionType()+"\",\"be.mxs.common.model.vo.healthrecord.IConstants."+sName+"\");'>"+sName+"</a>");
    	}
    	else{
	    	StringBuffer s = new StringBuffer();
	    	s.append("<input type='text' id='"+sName+"' ");
	    	s.append(" class='text' size='"+cols+"' name='currentTransactionVO.items.<ItemVO[hashCode="+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getItemId()+"]>.value' ");
	    	s.append(" value='"+transaction.getItem("be.mxs.common.model.vo.healthrecord.IConstants."+sName).getValue()+"' onblur='if(!this.value==\"\" && !isNumberLimited(this,"+min+","+max+")){this.value=\"\";alert(\""+getTranNoLink("web","valueoutofrange",language)+": "+min+" - "+max+"\");this.focus();}else{"+sOnBlur+";}' "+sOnEvent+"/>");
	    	return s.toString();
    	}
    }
    
	public static String getKeywordsHTML(TransactionVO transaction, String itemId, String textField,
            String idsField, String language, String contextpath){
		StringBuffer sHTML = new StringBuffer();
		ItemVO item = transaction.getItem(itemId);
		if(item!=null && item.getValue()!=null && item.getValue().length()>0){
			String[] ids = item.getValue().split(";");
			String keyword = "";
			
			for(int n=0; n<ids.length; n++){
				if(ids[n].split("\\$").length==2){
					keyword = getTran(null,ids[n].split("\\$")[0],ids[n].split("\\$")[1] , language);
					
					sHTML.append("<span style='white-space: nowrap;'><a href='javascript:deleteKeyword(\"").append(idsField).append("\",\"").append(textField).append("\",\"").append(ids[n]).append("\");'>")
					   .append("<img width='8' src='"+contextpath+"/_img/themes/default/erase.png' class='link' style='vertical-align:-1px'/>")
					  .append("</a>")
					  .append("&nbsp;<b>").append(keyword.startsWith("/")?keyword.substring(1):keyword).append("</b></span> | ");
				}
			}
		}
		
		String sHTMLValue = sHTML.toString();
		if(sHTMLValue.endsWith("| ")){
			sHTMLValue = sHTMLValue.substring(0,sHTMLValue.lastIndexOf("| "));
		}
		
		return sHTMLValue;
	}
    //--- WRITE SELECT (SORTED) -------------------------------------------------------------------
	   public static String writeSelect(HttpServletRequest request,String sLabelType, String sSelected,String sWebLanguage){
	       return writeSelect(request,sLabelType,sSelected,sWebLanguage,false,true);
	   }

	   public static String writeToggleMain(HttpServletRequest request,String sLabelType, String sSelected,String sWebLanguage,String sName,String sBaseName, String sEvent){
	       return writeToggle(request,sLabelType,sSelected,sWebLanguage,false,true,sName,sBaseName, sEvent);
	   }

	   public static String writeSelect(HttpServletRequest request,String sLabelType, String sSelected,String sWebLanguage,int maxSize){
	       return writeSelect(request,sLabelType,sSelected,sWebLanguage,false,true, maxSize);
	   }

   //--- WRITE SELECT (SORTED) -------------------------------------------------------------------
  public static String writeSelectWithStyle(HttpServletRequest request,String sLabelType, String sSelected,String sWebLanguage, String sStyle){
      return writeSelectWithStyle(request,sLabelType,sSelected,sWebLanguage,false,true,sStyle);
  }

    public static String writeSelect(HttpServletRequest request,String sLabelType, String sSelected,String sWebLanguage, boolean showLabelID){
        return writeSelect(request,sLabelType,sSelected,sWebLanguage,showLabelID,true);
    }

    //--- WRITE SELECT UNSORTED -------------------------------------------------------------------
    public static String writeSelectUnsorted(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage){
        return writeSelect(request,sLabelType,sSelected,sWebLanguage,false,false);
    }

    public static SortedSet<String> getLabelIds(String sLabelType, String sWebLanguage) {
    	TreeSet ids = new TreeSet();
        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());
            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                while(idsEnum.hasMoreElements()) {
                	ids.add(((Label)idsEnum.nextElement()).id);
                }
            }
        }
        return ids;
    }
    
    public static String writeCheckBoxes(HttpServletRequest request,String sLabelType, String name, String sSelected, String sWebLanguage, boolean sorted){
    	String sResult="";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sResult+= "<input type='checkbox' name='"+name+"."+sLabelID+"' id='"+name+"."+sLabelID+"' value='"+sLabelID+"'";
                    if(arrayContains(sSelected,sLabelID,";")){
                        sResult+= " checked";
                    }

                    sResult+= ">"+sLabelValue+" ";
                }
            }
        }
    	return sResult;
    }
    
    public static String makeArrayFromParameters(HttpServletRequest request,String name,String separator){
    	String array="";
    	Enumeration pars = request.getParameterNames();
    	while(pars.hasMoreElements()){
    		String par = (String)pars.nextElement();
    		if(par.startsWith(name+".")){
    			if(array.length()>0){
    				array+=separator;
    			}
    			array+=request.getParameter(par);
    		}
    	}
    	return array;
    }
    
    public static double dateDiffInDays(java.util.Date begin, java.util.Date end) {
    	return (end.getTime()-begin.getTime())/SH.getTimeDay();
    }
    
    public static boolean arrayContains(String array,String value,String separator){
    	String[] options = array.split(separator);
    	for(int n=0;n<options.length;n++){
    		if(options[n].equalsIgnoreCase(value)){
    			return true;
    		}
    	}
    	return false;
    }
    //--- WRITE SELECT ----------------------------------------------------------------------------
    public static String writeSelect(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage, boolean showLabelID, boolean sorted){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sOptions+= "<option value='"+sLabelID+"'";
                    if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                        sOptions+= " selected";
                    }

                    if(showLabelID){
                        sOptions+= ">"+sLabelValue+" ("+sLabelID+")</option>";
                    }
                    else{
                        sOptions+= ">"+sLabelValue+"</option>";
                    }
                }
            }
        }
        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }

        return sOptions;
    }

    public static String writeToggle(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage, boolean showLabelID, boolean sorted,String sName,String sBaseName, String sEvent){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sOptions+= "<input type='radio' name='"+sName+"' value='"+sLabelID+"' id='"+sBaseName+"-"+sLabelID+"' "+sEvent+" ";
                    if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                        sOptions+= " checked='checked'";
                    }
                    sOptions+= "/><label for='"+sBaseName+"-"+sLabelID+"'>"+sLabelValue+"</label>";
                }
            }
        }
        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }

        return sOptions;
    }

    public static String writeSelect(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage, boolean showLabelID, boolean sorted, int maxSize){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sOptions+= "<option value='"+sLabelID+"'";
                    if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                        sOptions+= " selected";
                    }
                    
                    String sTitle="";
                    if(sLabelValue.length()>maxSize){
                    	sTitle="title='"+sLabelValue+"'";
                    }
                    if(showLabelID){
                        sOptions+= " "+sTitle+">"+checkString(sLabelValue,maxSize)+" ("+sLabelID+")</option>";
                    }
                    else{
                        sOptions+= " "+sTitle+">"+checkString(sLabelValue,maxSize)+"</option>";
                    }
                }
            }
        }
        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }

        return sOptions;
    }

    public static String writeSelectWithStyle(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage, boolean showLabelID, boolean sorted, String sStyle){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sOptions+= "<option style='"+sStyle+"' value='"+sLabelID+"'";
                    if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                        sOptions+= " selected";
                    }

                    if(showLabelID){
                        sOptions+= ">"+sLabelValue+" ("+sLabelID+")</option>";
                    }
                    else{
                        sOptions+= ">"+sLabelValue+"</option>";
                    }
                }
            }
        }
        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }

        return sOptions;
    }

    public static String writeSelectUpperCase(String sLabelType, String sSelected, String sWebLanguage,
            boolean showLabelID, boolean sorted){
    	return writeSelectUpperCase(null, sLabelType, sSelected, sWebLanguage, showLabelID, sorted);
    }
    
    //--- WRITE SELECT ----------------------------------------------------------------------------
    public static String writeSelectUpperCase(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage,
    		                                  boolean showLabelID, boolean sorted){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value.toUpperCase(),label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value.toUpperCase());
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }

                    sOptions+= "<option value='"+sLabelID+"'";
                    if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                        sOptions+= " selected";
                    }

                    if(showLabelID){
                        sOptions+= ">"+sLabelID+" - "+sLabelValue+"</option>";
                    }
                    else{
                        sOptions+= ">"+sLabelValue+"</option>";
                    }
                }
            }
        }

        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }
        return sOptions;
    }

    public static String writeSelectExclude(String sLabelType, String sSelected, String sWebLanguage,
            boolean showLabelID, boolean sorted, String sExclude){
    	return writeSelectExclude(null, sLabelType, sSelected, sWebLanguage, showLabelID, sorted, sExclude);
    }
    //--- WRITE SELECT EXCLUDE --------------------------------------------------------------------
    public static String writeSelectExclude(HttpServletRequest request,String sLabelType, String sSelected, String sWebLanguage,
    		                                boolean showLabelID, boolean sorted, String sExclude){
        String sOptions = "";
        Label label;
        Iterator it;

        Hashtable labelTypes = (Hashtable)MedwanQuery.getInstance().getLabels().get(sWebLanguage.toLowerCase());
        if(labelTypes!=null){
            Hashtable labelIds = (Hashtable)labelTypes.get(sLabelType.toLowerCase());

            if(labelIds!=null){
                Enumeration idsEnum = labelIds.elements();
                Hashtable hSelected = new Hashtable();

                if(sorted){
                    // sorted on value
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.value,label.id);
                    }
                }
                else{
                    // sorted on id
                    while(idsEnum.hasMoreElements()){
                        label = (Label)idsEnum.nextElement();
                        hSelected.put(label.id,label.value);
                    }
                }

                // sort on keys :
                //  when sorted (on value), key = labelValue
                //  when !sorted (sorted on id), key = labelID
                Vector keys = new Vector(hSelected.keySet());
                Collections.sort(keys);
                it = keys.iterator();

                // to html
                String sLabelValue, sLabelID;
                while(it.hasNext()){
                    if(sorted){
                        sLabelValue = (String)it.next();
                        sLabelID = (String)hSelected.get(sLabelValue);
                    }
                    else{
                        sLabelID = (String)it.next();
                        sLabelValue = (String)hSelected.get(sLabelID);
                    }
                    if(sExclude.indexOf(sLabelID)<0){

                        sOptions+= "<option value='"+sLabelID+"'";
                        if(sLabelID.toLowerCase().equals(sSelected.toLowerCase())){
                            sOptions+= " selected";
                        }

                        if(showLabelID){
                            sOptions+= ">"+sLabelID+" - "+sLabelValue+"</option>";
                        }
                        else{
                            sOptions+= ">"+sLabelValue+"</option>";
                        }
                    }
                }
            }
        }

        if(request!=null && checkString((String)request.getSession().getAttribute("editmode")).equalsIgnoreCase("1")){
        	String optionUid = sLabelType+"."+new SimpleDateFormat("mmssSSS").format(new java.util.Date());
        	sOptions+="<option style='display: none' id='"+optionUid+"'>test</option>";
        	sOptions+="<script>";
        	sOptions+="myselect=document.getElementById('"+optionUid+"').parentElement;";
        	sOptions+="myselect.style='border:2px solid black; border-style: dotted';";
        	sOptions+="myselect.onclick=function(){window.open('"+request.getRequestURI().replaceAll(request.getServletPath(),"")+"/popup.jsp?Page=system/manageTranslations.jsp&FindLabelType="+sLabelType+"&find=1','popup','toolbar=no,status=yes,scrollbars=yes,resizable=yes,width=800,height=500,menubar=no');return false;};";
        	sOptions+="</script>";
        }
        return sOptions;
    }

    //--- SAVE UNKNOWN LABEL ----------------------------------------------------------------------
    public static void saveUnknownLabel(String sLabelType, String sLabelID, String sLabelLang){
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT OC_LABEL_TYPE FROM OC_UNKNOWNLABELS"+
                             " WHERE OC_LABEL_TYPE = ? AND OC_LABEL_ID = ? AND OC_LABEL_LANGUAGE = ?"+
                             "  AND OC_LABEL_UPDATEUSERID IS NULL";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,sLabelType.toLowerCase());
            ps.setString(2,sLabelID.toLowerCase());
            ps.setString(3,sLabelLang.toLowerCase());
            rs = ps.executeQuery();

            boolean bFound = false;
            if(rs.next()) bFound = true;
            if(rs!=null) rs.close();
            if(ps!=null) ps.close();

            if(!bFound){
                sSelect = "INSERT INTO OC_UNKNOWNLABELS (OC_LABEL_TYPE, OC_LABEL_ID, OC_LABEL_LANGUAGE,"+
                          "  OC_LABEL_VALUE, OC_LABEL_UNKNOWNDATETIME)"+
                          " VALUES (?,?,?,?)";
                ps = oc_conn.prepareStatement(sSelect);
                ps.setString(1,sLabelType.toLowerCase());
                ps.setString(2,sLabelID.toLowerCase());
                ps.setString(3,sLabelLang.toLowerCase());
                ps.setTimestamp(4,getSQLTime()); // NOW

                ps.execute();
                if(ps!=null) ps.close();
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    //--- CHECK STRING ----------------------------------------------------------------------------
    public static String checkString(String sString){
        // om geen 'null' weer te geven
        if((sString==null)||(sString.toLowerCase().equals("null"))){
            return "";
        }
        else{
            sString = sString.trim();
        }
        return sString;
    }

    public static String checkString(StringBuffer sString){
        // om geen 'null' weer te geven
    	String s="";
        if(sString!=null && !sString.toString().equalsIgnoreCase("null")){
             s = sString.toString().trim();
        }
        return s;
    }

    //--- CHECK STRING ----------------------------------------------------------------------------
    public static String checkString(String sString, int maxSize){
        // om geen 'null' weer te geven
        if((sString==null)||(sString.toLowerCase().equals("null"))){
            return "";
        }
        else{
            sString = sString.trim();
            if(sString.length()>maxSize){
            	sString=sString.substring(0,maxSize-3)+"...";
            }
        }
        return sString;
    }

    public static String checkString(String sString, String defaultValue){
        // om geen 'null' weer te geven
        if((sString==null)||(sString.toLowerCase().equals("null"))||sString.length()==0){
            return defaultValue;
        }
        else{
            sString = sString.trim();
        }
        return sString;
    }

    public static String checkString(String sString, String defaultValue, int maxSize){
        // om geen 'null' weer te geven
        if((sString==null)||(sString.toLowerCase().equals("null"))){
            return defaultValue;
        }
        else{
            sString = sString.trim();
            if(sString.length()>maxSize-3){
            	sString=sString.substring(0,maxSize-3)+"...";
            }
        }
        return sString;
    }

    //--- GET ACTIVE PRIVATE ----------------------------------------------------------------------
    public static AdminPrivateContact getActivePrivate(AdminPerson person){
        AdminPrivateContact apcActive = null;
        AdminPrivateContact apc;

        for(int i=0; i<person.privateContacts.size(); i++){
            apc = ((AdminPrivateContact)(person.privateContacts.elementAt(i)));
            if(apc.end==null || apc.end.trim().equals("")){
                if(apcActive==null || ScreenHelper.parseDate(apc.begin).after(ScreenHelper.parseDate(apcActive.begin))){
                    apcActive=apc;
                }
            }
        }

        return apcActive;
    }

    //--- REPLACE ---------------------------------------------------------------------------------
    public static String replace(String sValue, String sSearch, String sReplace){
        String sResult = "", sLeft = sValue;

        int iIndex = sLeft.indexOf(sSearch);
        if(iIndex > -1){
            while(iIndex > -1){
                sResult+= sLeft.substring(0,iIndex)+sReplace;
                sLeft = sLeft.substring(iIndex+1,sLeft.length());
                iIndex = sLeft.indexOf(sSearch);
            }
            sResult+= sLeft;
        }
        else{
            sResult = sValue;
        }

        return sResult;
    }

    //--- GET TS ----------------------------------------------------------------------------------
    public static String getTs(){
        return new java.util.Date().getTime()+"";
    }

    //--- GET DATE --------------------------------------------------------------------------------
    public static String getDate(){
        return stdDateFormat.format(new java.util.Date());
    }

    //--- GET DATE --------------------------------------------------------------------------------
    public static java.util.Date getDate(java.util.Date date) throws Exception{
        return ScreenHelper.parseDate(stdDateFormat.format(date));
    }

    //--- FORMAT DATE -----------------------------------------------------------------------------
    public static String formatDate(java.util.Date dDate){
        String sDate = "";
        if(dDate!=null){
            sDate = stdDateFormat.format(dDate);
        }
        return sDate;
    } 
    
    public static String formatDate(java.util.Date dDate, SimpleDateFormat dateFormat){
        String sDate = "";
        if(dDate!=null){
            sDate = dateFormat.format(dDate);
        }
        return sDate;
    }

    //--- WRITE TABLE FOOTER ----------------------------------------------------------------------
    public static String writeTblFooter(){
        return "</table></td></tr></td></tr></table>";
    }

    //--- WRITE TABLE HEADER ----------------------------------------------------------------------
    public static String writeTblHeader(String sHeader, String sCONTEXTDIR){
        return "<table border='0' cellspacing='0' cellpadding='0' class='menu' width='100%'>"+
                "<tr class='admin'><td width='100%'>&nbsp;&nbsp;"+sHeader+"&nbsp;&nbsp;</td></tr>"+
                "<tr>"+
                 "<td>"+
                  "<table width='100%' cellspacing='0'>";
    }

    //--- WRITE TABLE CHILD -----------------------------------------------------------------------
    public static String writeTblChild(String sPath, String sHeader, String sCONTEXTDIR){
        return writeTblChild(sPath,sHeader,sCONTEXTDIR,-1);	
    }
    
    public static String writeTblChild(String sPath, String sHeader, String sCONTEXTDIR, int rowIdx){
        return writeTblChild(sPath,sHeader,sCONTEXTDIR,rowIdx,false);
    }
    
    public static String writeTblChild(String sPath, String sHeader, String sCONTEXTDIR, int rowIdx, boolean smallRows){
        return "<tr"+(rowIdx>-1?(rowIdx%2==0?" class='list1'":" class='list'"):"")+(smallRows?" style='height:17px'":"")+">"+
                "<td class='arrow'><img src='"+sCONTEXTDIR+"/_img/themes/default/pijl.gif'></td>"+
                "<td width='99%' nowrap>"+
                 "<button class='buttoninvisible' accesskey='"+getAccessKey(sHeader)+"' onclick='window.location.href=\""+sCONTEXTDIR+"/"+sPath+"\"'></button><a href='"+sCONTEXTDIR+"/"+sPath+"' onMouseOver=\"window.status='';return true;\">"+sHeader+"</a>&nbsp;"+
                "</td>"+
               "</tr>";
    }

    //--- WRITE TABLE CHILD NO BUTTON -------------------------------------------------------------
    public static String writeTblChildNoButton(String sPath, String sHeader, String sCONTEXTDIR){
        return "<tr>"+
                "<td class='arrow'><img src='"+sCONTEXTDIR+"/_img/themes/default/pijl.gif'></td>"+
                "<td width='99%' nowrap>"+
                 "<a href='"+sCONTEXTDIR+"/"+sPath+"' onMouseOver=\"window.status='';return true;\">"+sHeader+"</a>&nbsp;"+
                "</td>"+
               "</tr>";
    }

    //--- WRITE TABLE CHILD WITH CODE -------------------------------------------------------------
    public static String writeTblChildWithCode(String sCommand, String sHeader, String sCONTEXTDIR){
        return writeTblChildWithCode(sCommand,sHeader,sCONTEXTDIR,-1);
    }
    
    public static String writeTblChildWithCode(String sCommand, String sHeader, String sCONTEXTDIR, int rowIdx){
        return writeTblChildWithCode(sCommand,sHeader,sCONTEXTDIR,rowIdx,false);
    }
    
    public static String writeTblChildWithCode(String sCommand, String sHeader, String sCONTEXTDIR, int rowIdx, boolean smallRows){
        return "<tr"+(rowIdx>-1?(rowIdx%2==0?" class='list1'":" class='list'"):"")+(smallRows?" style='height:17px'":"")+">"+
                "<td class='arrow'><img src='"+sCONTEXTDIR+"/_img/themes/default/pijl.gif'></td>"+
                "<td width='99%' nowrap>"+
                 "<button class='buttoninvisible' accesskey='"+getAccessKey(sHeader)+"' onclick='"+sCommand+"'></button>"+
                 "<a href='"+sCommand+"' onMouseOver=\"window.status='';return true;\">"+sHeader+"</a>&nbsp;"+
                "</td>"+
               "</tr>";
    }

    //--- WRITE TABLE CHILD WITH CODE NO BUTTON ---------------------------------------------------
    public static String writeTblChildWithCodeNoButton(String sCommand, String sHeader, String sCONTEXTDIR){
        return writeTblChildWithCodeNoButton(sCommand,sHeader,sCONTEXTDIR,-1);
    }
    
    public static String writeTblChildWithCodeNoButton(String sCommand, String sHeader, String sCONTEXTDIR, int rowIdx){
        return writeTblChildWithCodeNoButton(sCommand,sHeader,sCONTEXTDIR,rowIdx,false);
    }
    
    public static String writeTblChildWithCodeNoButton(String sCommand, String sHeader, String sCONTEXTDIR, int rowIdx, boolean smallRows){
        return "<tr"+(rowIdx>-1?(rowIdx%2==0?" class='list1'":" class='list'"):"")+(smallRows?" style='height:17px'":"")+">"+
                "<td class='arrow'><img src='"+sCONTEXTDIR+"/_img/themes/default/pijl.gif'></td>"+
                "<td width='99%' nowrap>"+
                 "<a href='"+sCommand+"' onMouseOver=\"window.status='';return true;\">"+sHeader+"</a>&nbsp;"+
                "</td>"+
               "</tr>";
    }

    //--- GET ACCESS KEY --------------------------------------------------------------------------
    public static String getAccessKey(String label){
        label=label.toLowerCase();
        if(label.indexOf("<u>")>-1 && label.indexOf("</u>")>-1){
            return label.substring(label.indexOf("<u>")+3,label.indexOf("</u>"));
        }
        return "";
    }

    //--- SET RIGHT CLICK -------------------------------------------------------------------------
    public static String setRightClick(String itemType){
    	return setRightClick(itemType, "");
    }
    public static String setRightClick(String itemType, String onChange){
        return "onclick='this.className=\"selected\"' "+
               //"onchange='"+onChange+"this.className=\"selected\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onkeydown='"+onChange+"this.className=\"selected\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
               "onmouseout=\"this.style.cursor='default';activeItem=false;\" ";
    }

    public static String setRightClick(HttpSession session,String itemType){
    	return setRightClick(session,itemType, "");
    }
    public static String setRightClick(HttpSession session,String itemType, String onChange){
        return "onclick='this.className=\"selected\"' "+
               //"onchange='"+onChange+"this.className=\"selected\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onkeydown='"+onChange+"this.className=\"selected\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
               "onmouseout=\"this.style.cursor='default';activeItem=false;\" "+
               (checkString((String)session.getAttribute("editmode")).equals("1")?"title='"+itemType+"' ":"");
    }

    public static String setRightClickNoClass(HttpSession session,String itemType){
    	return setRightClickNoClass(session,itemType, "");
    }
    public static String setRightClickNoClass(HttpSession session,String itemType, String onChange){
        return "onkeydown='setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
               "onmouseout=\"this.style.cursor='default';activeItem=false;\" "+
               (checkString((String)session.getAttribute("editmode")).equals("1")?"title='"+itemType+"' ":"");
    }

    public static String setRightClickCenter(HttpSession session,String itemType){
    	return setRightClickCenter(session,itemType, "");
    }
    public static String setRightClickCenter(HttpSession session,String itemType, String onChange){
        return "onclick='this.className=\"selectedcenter\"' "+
               //"onchange='"+onChange+"this.className=\"selectedcenter\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onkeydown='"+onChange+"this.className=\"selectedcenter\";setPopup(\"be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"\",this.value)' "+
               "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
               "onmouseout=\"this.style.cursor='default';activeItem=false;\" "+
               (checkString((String)session.getAttribute("editmode")).equals("1")?"title='"+itemType+"' ":"");
    }

    //--- SET RIGHT CLICK MINI --------------------------------------------------------------------
    public static String setRightClickMini(String itemType){
        return "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
                "onmouseout=\"this.style.cursor='default';activeItem=false;document.oncontextmenu=function(){return true};\" ";
    }
    public static String setRightClickMini(HttpSession session,String itemType){
        return "onmouseover=\"if(document.getElementById('clipboard')) document.getElementById('clipboard').innerHTML='"+itemType+"';this.style.cursor='help';setPopup('be.mxs.common.model.vo.healthrecord.IConstants."+itemType+"',this.value);activeItem=true;setItemsMenu(true);\" "+
               "onmouseout=\"this.style.cursor='default';activeItem=false;document.oncontextmenu=function(){return true};\" "+
               (checkString((String)session.getAttribute("editmode")).equals("1")?"title='"+itemType+"' ":"");
    }

    //--- GET DEFAULTS ----------------------------------------------------------------------------
    public static String getDefaults(HttpServletRequest request) throws SessionContainerFactoryException {
        // defaults
        String defaults = ((SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName())).getItemDefaultsHTML();
        defaults += "<script>function loadDefaults(){"
                    +"for(n=0;n<document.all.length;n++){"
                    +"if(document.getElementsByName('DefaultValue_'+document.all[n].name).length>0){"
                    +"if(document.all[n].type=='text'){document.all[n].value=document.getElementsByName('DefaultValue_'+document.all[n].name)[0].value;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='textarea'){document.all[n].value=document.getElementsByName('DefaultValue_'+document.all[n].name)[0].value;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='radio' && document.all[n].value==document.getElementsByName('DefaultValue_'+document.all[n].name)[0].value){document.all[n].checked=true;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='checkbox' && document.all[n].value==document.getElementsByName('DefaultValue_'+document.all[n].name)[0].value){document.all[n].checked=true;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='select-one'){for(m=0;m<document.all[n].options.length;m++){if(document.all[n].options[m].value==document.getElementsByName('DefaultValue_'+document.all[n].name)[0].value){document.all[n].selectedIndex=m;document.all[n].className='modified'}}}"
                    +"}"
                    +"}"
                    +"document.getElementById('ie5menu').style.visibility = 'hidden';}</script>";

        // previous
        defaults += ((SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName())).getItemPreviousHTML();
        String loadPreviousScript="<script>"+
					"function loadPrevious(){"+
					  "for(n=0;n<document.all.length;n++){"+
					    "if(document.getElementsByName('PreviousDivValue_'+document.all[n].name).length>0){"+
					      "var divcontent=document.getElementsByName('PreviousDivValue_'+document.all[n].name)[0].value;"+
					      "document.getElementById(document.getElementsByName('PreviousDivValue_'+document.all[n].name)[0].id.substring(3)).className='modified';"+
					      "document.getElementById(document.getElementsByName('PreviousDivValue_'+document.all[n].name)[0].id.substring(3)).innerHTML=divcontent;"+
					    "}"+
					    "if(document.getElementsByName('PreviousValue_'+document.all[n].name).length>0){"+
					      "if(document.all[n].type=='text'){"+
					        "document.all[n].value=document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value;"+
					        "document.all[n].className='modified';"+
					      "}"+
					      "else if(document.all[n].type=='hidden'){"+
					        "document.all[n].value=document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value;"+
						"valuesArray=document.all[n].value.split(';');"+
					        "for(q=0;q<valuesArray.length;q++){"+
						  "refElement = document.getElementById(document.getElementsByName('PreviousValue_'+document.all[n].name)[0].id.substring(3)+'.'+valuesArray[q]);"+
					          "if(refElement && (refElement.type=='checkbox' || refElement.type=='radio') && refElement.checked==false){"+
					            "refElement.checked=true;"+
					            "refElement.className='modified';"+
					          "}"+
					        "}"+
					        "refElement=document.getElementById('img_'+document.getElementsByName('PreviousValue_'+document.all[n].name)[0].id.substring(3));"+
						"if(refElement && refElement.onplay){"+
					          "window.setTimeout('refElement.onplay();',200);"+
					        "}"+
					      "}"+
					      "else if(document.all[n].type=='textarea'){"+
					        "document.all[n].value=document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value;"+
					        "document.all[n].className='modified';"+
					      "}"+
					      "else if(document.all[n].type=='radio' && document.all[n].value==document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value){"+
					        "document.all[n].checked=true;"+
					        "document.all[n].className='modified';"+
					      "}"+
					      "else if(document.all[n].type=='checkbox' && document.all[n].value==document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value){"+
					          "document.all[n].checked=true;"+
					          "document.all[n].className='modified';"+
					      "}"+
					      "else if(document.all[n].type=='select-one'){"+
					        "for(m=0;m<document.all[n].options.length;m++){"+
					          "if(document.all[n].options[m].value==document.getElementsByName('PreviousValue_'+document.all[n].name)[0].value){"+
					            "document.all[n].selectedIndex=m;document.all[n].className='modified';"+
					          "}"+
					        "}"+
					      "}"+
					    "}"+
					  "}"+
					  "document.getElementById('ie5menu').style.visibility = 'hidden';"+
					"}"+
					"</script>";

        defaults += MedwanQuery.getInstance().getConfigString("scriptLoadPrevious",loadPreviousScript);
        // previous context
        defaults += ((SessionContainerWO)SessionContainerFactory.getInstance().getSessionContainerWO( request , SessionContainerWO.class.getName())).getItemPreviousContextHTML();
        defaults += "<script>function loadPreviousContext(){"
                    +"for(n=0;n<document.all.length;n++){"
                    +"if(document.getElementsByName('PreviousContextValue_'+document.all[n].name).length>0){"
                    +"if(document.all[n].type=='text'){document.all[n].value=document.getElementsByName('PreviousContextValue_'+document.all[n].name)[0].value;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='textarea'){document.all[n].value=document.getElementsByName('PreviousContextValue_'+document.all[n].name)[0].value;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='radio' && document.all[n].value==document.getElementsByName('PreviousContextValue_'+document.all[n].name)[0].value){document.all[n].checked=true;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='checkbox' && document.all[n].value==document.getElementsByName('PreviousContextValue_'+document.all[n].name)[0].value){document.all[n].checked=true;document.all[n].className='modified'}"
                    +"if(document.all[n].type=='select-one'){for(m=0;m<document.all[n].options.length;m++){if(document.all[n].options[m].value==document.getElementsByName('PreviousContextValue_'+document.all[n].name)[0].value){document.all[n].selectedIndex=m;document.all[n].className='modified'}}}"
                    +"}"
                    +"}"
                    +"document.getElementById('ie5menu').style.visibility = 'hidden';}</script>";

        return defaults;
    }

    //--- FORMAT SQL DATE -------------------------------------------------------------------------
    public static String formatSQLDate(Date dDate, String sFormat){
        String sDate = "";
        if(dDate!=null){
            sDate = new SimpleDateFormat(sFormat).format(dDate);
        }
        return sDate;
    }

    public static String formatSQLDate(java.util.Date dDate, String sFormat){
        String sDate = "";
        if(dDate!=null){
            sDate = new SimpleDateFormat(sFormat).format(dDate);
        }
        return sDate;
    }

    //--- GET SQL STRING --------------------------------------------------------------------------
    public static String setSQLString(String sValue){
        if(sValue!=null && sValue.trim().length()>249){
            sValue = sValue.substring(0,249);
        }
        return sValue;
    }

    //--- GET SQL TIME ----------------------------------------------------------------------------
    public static String getSQLTime(Time tTime){
        String sTime = "";
        if(tTime!=null){
            sTime = tTime.toString();
            sTime = sTime.substring(0,sTime.lastIndexOf(":"));
        }
        return sTime;
    }

    //--- GET SQL TIME ----------------------------------------------------------------------------
    public static java.sql.Timestamp getSQLTime(){
        return new java.sql.Timestamp(new java.util.Date().getTime()); // now
    }

    public static java.sql.Timestamp getSQLTimestamp(String sTime){
        return new java.sql.Timestamp(parseDate(sTime).getTime()); // now
    }

    public static java.sql.Timestamp getSQLTimestamp(java.util.Date date){
        return new java.sql.Timestamp(date.getTime()); // now
    }

    //--- GET SQL TIME STAMP ----------------------------------------------------------------------
    public static String getSQLTimeStamp(java.sql.Timestamp timeStamp){
        String ts = "";
        if(timeStamp!=null){
            ts = fullDateFormat.format(new Date(timeStamp.getTime()));
        }
        return ts;
    }

    //--- GET SQL DATE ----------------------------------------------------------------------------
    public static String getSQLDate(java.sql.Date dDate){
        String sDate = "";
        if(dDate!=null){
            sDate = formatDate(dDate);
        }
        return sDate;
    }

    //--- GET SQL DATE ----------------------------------------------------------------------------
    public static String getSQLDate(java.util.Date dDate){
        String sDate = "";
        if(dDate!=null){
            sDate = formatDate(dDate);
        }
        return sDate;
    }

    //--- GET SQL DATE ----------------------------------------------------------------------------
    public static String getSQLDate(java.util.Date dDate, java.util.Date defaultDate){
        String sDate = getSQLDate(defaultDate);
        if(dDate!=null){
            sDate = formatDate(dDate);
        }
        return sDate;
    }

    //--- GET SQL DATE ----------------------------------------------------------------------------
    public static java.sql.Date getSQLDate(String sDate){
        try{
            if(sDate==null || sDate.trim().length()==0 || sDate.trim().length()<5 || sDate.equals("&nbsp;")){
                return null;
            }
            else{
                sDate = sDate.replaceAll("-","/");
                return new java.sql.Date(ScreenHelper.parseDate(sDate).getTime());
            }
        }
        catch(Exception e){
            return null;
        }
    }

    //--- GET DATE ADD ----------------------------------------------------------------------------
    public static String getDateAdd(String sDate, String sAdd){
        try{
            if(sDate==null || sDate.trim().length()==0 || sDate.trim().length()<5 || sDate.equals("&nbsp;")){
                return null;
            }
            else{
                sDate = sDate.replaceAll("-","/");
                java.util.Date d = ScreenHelper.parseDate(sDate);
                return ScreenHelper.stdDateFormat.format(new java.util.Date(d.getTime()+Long.parseLong(sAdd)*24*60*60000));
            }
        }
        catch(Exception e){
            return null;
        }
    }

    //--- WRITE JS BUTTONS ------------------------------------------------------------------------
    public static String writeJSButtons(String sMyForm, String sMyButton, String sCONTEXTDIR){
        return "<script>var myForm = document.getElementById('"+sMyForm+"'); var myButton = document.getElementById('"+sMyButton+"');</script>"+
               "<script src='"+sCONTEXTDIR+"/_common/_script/buttons.js'></script>";
    }

    //--- WRITE SAVE BUTTON -----------------------------------------------------------------------    
    public static String writeSaveButton(String sLanguage){
        return writeSaveButton("doSubmit();",sLanguage,-1);
    }
    
    public static String writeSaveButton(String sLanguage, int height){
        return writeSaveButton("doSubmit();",sLanguage,height);
    }
    
    public static String writeSaveButton(String sFunction, String sLanguage){
        return writeSaveButton(sFunction,sLanguage,-1);
    }
    
    public static String writeSaveButton(String sFunction, String sLanguage, int height){
        return "<input class='button' type='button' name='saveButton' id='saveButton' "+(height>0?"style='height:"+height+"px'":"")+" value='"+getTranNoLink("web","save",sLanguage)+"' onclick='"+sFunction+"'/>";
    }

    //--- WRITE SEARCH BUTTON ---------------------------------------------------------------------
    public static String writeSearchButton(String sLanguage){
        return writeSearchButton("doSearch();",sLanguage);
    }
    
    public static String writeSearchButton(String sFunction, String sLanguage){
        return "<input class='button' type='button' name='searchButton' id='searchButton' value='"+getTranNoLink("web","search",sLanguage)+"' onclick='"+sFunction+"'/>";
    }

    //--- WRITE BACK BUTTON -----------------------------------------------------------------------
    public static String writeBackButton(String sLanguage){
        return writeBackButton("doBack();",sLanguage);
    }
    
    public static String writeBackButton(String sFunction, String sLanguage){
        return "<input class='button' type='button' name='backButton' id='backButton' value='"+getTranNoLink("web","back",sLanguage)+"' onclick='doBack();'/>";
    }
    
    //--- WRITE PRINT BUTTON ----------------------------------------------------------------------
    public static String writePrintButton(String sLanguage){
        return writePrintButton("doPrint();",sLanguage);
    }
    
    public static String writePrintButton(String sFunction, String sLanguage){
        return "<input class='button' type='button' name='printButton' id='printButton' value='"+getTranNoLink("web","print",sLanguage)+"' onclick='doPrint();'/>";
    }
    
    //--- WRITE RESET BUTTON ----------------------------------------------------------------------
    public static String writeResetButton(String sLanguage){
    	return writeResetButton("transactionForm.reset()",sLanguage);
    }

    public static String writeResetButton(String sFunction, String sLanguage){
        // sFunction can be formName too
    	if(sFunction.toLowerCase().endsWith("form")){
            sFunction+= ".reset();";    		
    	}
    
        return "<input class='button' type='button' name='resetButton' id='resetButton' value='"+getTranNoLink("web","reset",sLanguage)+"' onclick='"+sFunction+"'/>";
    }    
    
    //--- WRITE CLOSE BUTTON ----------------------------------------------------------------------
    public static String writeCloseButton(String sLanguage){
        return writeCloseButton("window.close();",sLanguage);
    }
    
    public static String writeCloseButton(String sFunction, String sLanguage){
        return "<input class='button' type='button' name='closeButton' id='closeButton' value='"+getTranNoLink("web","close",sLanguage)+"' onclick='"+sFunction+"'/>";
    }

    //--- CLOSE QUIETLY ---------------------------------------------------------------------------
    public static void closeQuietly(Connection connection, Statement statement, ResultSet resultSet){
        if(resultSet!=null) try{ resultSet.close(); } catch (SQLException logOrIgnore){logOrIgnore.printStackTrace();}
        if(statement!=null) try{ statement.close(); } catch (SQLException logOrIgnore){logOrIgnore.printStackTrace();}
        if(connection!=null) try{ connection.close(); } catch (SQLException logOrIgnore){logOrIgnore.printStackTrace();}
    }
    
    //--- SET INCLUDE PAGE ------------------------------------------------------------------------
    public static void setIncludePage(String sPage, PageContext pageContext){
        // ? or &
        if(sPage.indexOf("?")<0){
            if(sPage.indexOf("&")>-1){
                sPage=sPage.substring(0,sPage.indexOf("&"))+"?"+sPage.substring(sPage.indexOf("&")+1);
                if(sPage.indexOf("ts=")<0){
                    sPage+= "&ts="+new java.util.Date().getTime();
                }
            }
            else{
                sPage+= "?ts="+new java.util.Date().getTime();
            }

        }
        else if(sPage.indexOf("ts=")<0){
            sPage+= "&ts="+new java.util.Date().getTime();
        }
        
        try{
        	if(!SH.isAcceptableUploadFileExtension(sPage.substring(0,sPage.indexOf("?")))) {
        		pageContext.include(sPage);
        	}
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //--- WRITE TIME FIELD ------------------------------------------------------------------------
    public static String writeTimeField(String sName, String sValue){
        return "<input id='"+sName+"' type='text' class='text' name='"+sName+"' value='"+sValue+"' onblur='checkTime(this)' size='5'>";
    }

    public static String writeTimeField(String sName, String sValue, String code){
        return "<input id='"+sName+"' type='text' class='text' name='"+sName+"' value='"+sValue+"' onblur='checkTime(this);"+checkString(code)+"' size='5' >";
    }

    //--- GET SQL TIME STAMP ----------------------------------------------------------------------
    public static void getSQLTimestamp(PreparedStatement ps, int iIndex, String sDate, String sTime){
        try{
            if(sDate==null || sDate.trim().length()==0){
                ps.setNull(iIndex,Types.TIMESTAMP);
            }
            else{
                if(sTime==null || sTime.trim().length()==0){
                    ps.setDate(iIndex,getSQLDate(sDate));
                }
                else{
                    ps.setTimestamp(iIndex,new Timestamp(fullDateFormat.parse(sDate+" "+sTime).getTime()));
                }
            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
        catch(ParseException e){
            e.printStackTrace();
        }
    }

    public static void getSQLTimestamp(PreparedStatement ps, int iIndex, java.util.Date date){
        try{
            if(date==null){
                ps.setNull(iIndex,Types.TIMESTAMP);
            }
            else{
                ps.setTimestamp(iIndex,new Timestamp(date.getTime()));
            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
    }

    //--- GET COOKIE ------------------------------------------------------------------------------
    public static String getCookie(String cookiename, HttpServletRequest request){
        Cookie cookies[] = request.getCookies();

        if(cookies!=null){
        	for(int i=0; i<cookies.length; i++){
        		if(cookies[i].getName().equals(cookiename)){
        			return cookies[i].getValue();
        		}
        	}
        }

        return null;
    }

    //--- SET COOKIE ------------------------------------------------------------------------------
    public static void setCookie(String cookiename, String value, HttpServletResponse response){
        Cookie cookie = new Cookie(cookiename,value);
        cookie.setMaxAge(365);
        response.addCookie(cookie);
    }

    //--- CHECK DB STRING -------------------------------------------------------------------------
    public static String checkDbString(String sString){
        sString = checkString(sString);
        if(sString.trim().length()>0){
            sString = sString.replaceAll("'","´");
        }
        
        return sString;
    }

    //--- ALIGN BUTTONS START ---------------------------------------------------------------------
    public static String alignButtonsStart(){
        return "<p align='center'>";
      }
   
    //--- ALIGN BUTTONS STOP ----------------------------------------------------------------------
    public static String alignButtonsStop(){
      return "</p>";
    }

    //--- SET FORMBUTTONS START -------------------------------------------------------------------
    public static String setFormButtonsStart(){
        return "<tr>"+
                   "<td class='admin'/>"+
                   "<td class='admin2'>";
    }

    //--- SET FORMBUTTONS STOP --------------------------------------------------------------------
    public static String setFormButtonsStop(){
        return      "</td>"+
                "</tr>";
    }

    //--- SET SEARCHFORM BUTTONS START ------------------------------------------------------------
    public static String setSearchFormButtonsStart(){
        return "<tr><td/><td>";
    }

    //--- SET SEARCHFORM BUTTONS STOP -------------------------------------------------------------
    public static String setSearchFormButtonsStop(){
        return "</td></tr>";
    }

    //--- GET FULL PERSON NAME (1) ----------------------------------------------------------------
    public static String getFullPersonName(String personId){
    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
    	String sName = getFullPersonName(personId,conn);
    	ScreenHelper.closeQuietly(conn,null,null);
    	
    	return sName;
    }

    //--- GET FULL PERSON NAME (2) ----------------------------------------------------------------
    public static String getFullPersonName(String personId, Connection dbConnection){
        String sReturn = "";

        if(checkString(personId).length() > 0){
            PreparedStatement ps = null;
            ResultSet rs = null;

            try{
                String sSelect = "SELECT lastname, firstname FROM Admin WHERE personid = ?";
                ps = dbConnection.prepareStatement(sSelect);
                ps.setInt(1,Integer.parseInt(personId));
                rs = ps.executeQuery();

                if(rs.next()){
                    sReturn = checkString(rs.getString("lastname"))+" "+checkString(rs.getString("firstname"));
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            finally{
                try{
                    if(rs!=null)rs.close();
                    if(ps!=null)ps.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
        
        return sReturn;
    }
    
    //--- GET PRESTATIONGROUP OPTIONS -------------------------------------------------------------
    public static String getPrestationGroupOptions(){
    	StringBuffer s = new StringBuffer();
    	
		Connection oc_conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		
		try{
			String sSql = "select * from oc_prestation_groups order by oc_group_description";
			oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
			ps = oc_conn.prepareStatement(sSql);
			rs = ps.executeQuery();
			while(rs.next()){
				s.append("<option value='"+rs.getInt("oc_group_serverid")+"."+rs.getInt("oc_group_objectid")+"'>"+rs.getString("oc_group_description")+"</option>");
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		closeQuietly(oc_conn,ps,rs);
		
		return s.toString();
    }
    
    //--- GET FULL USER NAME (1) ------------------------------------------------------------------
    // no connection specified 
    public static String getFullUserName(String userId){
    	String sName = "";
    	
    	try{
	    	Connection conn = MedwanQuery.getInstance().getAdminConnection();
	        sName = getFullUserName(userId,conn);
	    	closeQuietly(conn,null,null);
    	}
    	catch(Exception e){
    		Debug.printStackTrace(e);
    	}
    	
        return sName;
    }

    //--- GET FULL USER NAME (2) ------------------------------------------------------------------
    // connection specified 
    public static String getFullUserName(String userId, Connection conn){
        String fullName = "";
        
        if(userId!=null && userId.length() > 0){
        	PreparedStatement ps = null;
	        ResultSet rs = null;
	
	        String sSelect = "SELECT lastname,firstname FROM Users u, Admin a"+
	                         " WHERE u.userid = ?"+
	                         "  AND u.personid = a.personid";
	
	        try{
	            ps = conn.prepareStatement(sSelect);
	            ps.setInt(1,Integer.parseInt(userId));
	            rs = ps.executeQuery();
	
	            if(rs.next()){
	                fullName = checkString(rs.getString("lastname"))+" "+checkString(rs.getString("firstname"));
	            }
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                if(rs!=null) rs.close();
	                if(ps!=null) ps.close();
	            }
	            catch(Exception e){
	                e.printStackTrace();
	            }
	        }
        }
        
        return fullName;
    }

    //--- GET ACTIVE DIVISION ---------------------------------------------------------------------
    public static Service getActiveDivision(AdminPerson patient){
        return getActiveDivision(patient.personid);
    }

    public static Service getActiveDivision(String personId){
        Service patientDivision = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT b.OC_ENCOUNTER_SERVICEUID FROM OC_ENCOUNTERS a,OC_ENCOUNTER_SERVICES b"+
		                     " WHERE "+
		                     " a.OC_ENCOUNTER_PATIENTUID = ? AND"+
		                     " a.OC_ENCOUNTER_SERVERID=b.OC_ENCOUNTER_SERVERID AND"+
		                     " a.OC_ENCOUNTER_OBJECTID=b.OC_ENCOUNTER_OBJECTID AND"+
		                     " a.OC_ENCOUNTER_ENDDATE IS NULL AND"+
		                     " b.OC_ENCOUNTER_SERVICEENDDATE IS NULL";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,personId);

            rs = ps.executeQuery();

            // get data from DB
            if(rs.next()){
                patientDivision = Service.getService(rs.getString("OC_ENCOUNTER_SERVICEUID"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return patientDivision;
    }

    //--- IS PATIENT HOSPITALIZED -----------------------------------------------------------------
    public static boolean isPatientHospitalized(AdminPerson patient){
        Service activeDivision = getActiveDivision(patient);
        return (activeDivision!=null);
    }

    public static boolean isPatientHospitalized(String personId){
        Service activeDivision = getActiveDivision(personId);
        return (activeDivision!=null);
    }

    //--- TOKENIZE VECTOR -------------------------------------------------------------------------
    public static String tokenizeVector(Vector vector, String token, String aanhalingsteken){
        String values = "";

        // run thru vector
        for(int i=0; i<vector.size(); i++){
            values+= aanhalingsteken+vector.get(i)+aanhalingsteken+token;
        }

        // remove last token if any
        if(values.endsWith(token)){
            values = values.substring(0,values.length()-token.length());
        }

        if(values.length()==0) values = aanhalingsteken+aanhalingsteken;

        return values;
    }

    //--- CONTAINS LOWERCASE ----------------------------------------------------------------------
    public static boolean containsLowercase(String text){
        for(int i=0; i<text.length(); i++){
            if(Character.isLowerCase(text.charAt(i))){
                return true;
            }
        }
        return false;
    }

    //--- CONTAINS UPPERCASE ----------------------------------------------------------------------
    public static boolean containsUppercase(String text){
        for(int i=0; i<text.length(); i++){
            if(Character.isUpperCase(text.charAt(i))){
                return true;
            }
        }

        return false;
    }

    //--- CONTAINS LETTER -------------------------------------------------------------------------
    public static boolean containsLetter(String text){
        if(containsLowercase(text) || containsUppercase(text)){
            return true;
        }

        return false;
    }

    //--- CONTAINS NUMBER -------------------------------------------------------------------------
    public static boolean containsNumber(String text){
        for(int i=0; i<text.length(); i++){
            if(Character.isDigit(text.charAt(i))){
                return true;
            }
        }

        return false;
    }
    
    //--- CONTAINS ALFANUMERICS -------------------------------------------------------------------
    public static boolean containsAlfanumerics(String text){
        for(int i=0; i<text.length(); i++){
            if(!Character.isDigit(text.charAt(i)) && !Character.isLetter(text.charAt(i))){
                return true;
            }
        }

        return false;
    }
    
    //--- GET CONFIG STRING -----------------------------------------------------------------------
    public static String getConfigString(String key){
    	Connection conn = MedwanQuery.getInstance().getConfigConnection();
        String sValue = getConfigStringDB(key,conn);
        
        try{
			conn.close();
		}
        catch(SQLException e){
			e.printStackTrace();
		}
        
        return sValue;
    }

    //--- GET CONFIG STRING -----------------------------------------------------------------------
    public static String getConfigString(String key, String defaultValue){
        return MedwanQuery.getInstance().getConfigString(key, defaultValue);
    }

    //--- GET CONFIG STRING DB --------------------------------------------------------------------
    public static String getConfigStringDB(String key, Connection ConfigdbConnection){
        String cs = "";
        Statement st = null;
        ResultSet rs = null;

        try{
            st = ConfigdbConnection.createStatement();
            String sQuery = "SELECT oc_value FROM OC_Config" +
                            " WHERE oc_key LIKE '"+key+"' AND deletetime IS NULL"+
            		        "  ORDER BY oc_key";
            rs = st.executeQuery(sQuery);
            while(rs.next()){
                cs+= rs.getString("oc_value");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(st!=null) st.close();
            }
            catch(SQLException sqle){
                sqle.printStackTrace();
            }
        }

        return checkString(cs);
    }

    //--- GET CONFIG PARAM ------------------------------------------------------------------------
    public static String getConfigParam(String key, String param){
        return getConfigParamDB(key,param);
    }

    public static String getConfigParam(String key, String[] params){
        return getConfigParamDB(key,params);
    }

    //--- GET CONFIG PARAM DB ---------------------------------------------------------------------
    public static String getConfigParamDB(String key, String param){
        return getConfigString(key).replaceAll("<param>",param);
    }

    public static String getConfigParamDB(String key, String[] params){
        String result = getConfigString(key);

        for(int i=0; i<params.length; i++){
            result = result.replaceAll("<param"+(i+1)+">",params[i]);
        }

        return result;
    }

    //--- GET ALL SERVICE CODES -------------------------------------------------------------------
    public static Vector getAllServiceCodes(){
        Vector serviceCodes = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            sSelect = "SELECT DISTINCT serviceid FROM Services";
            ps = ad_conn.prepareStatement(sSelect);

            rs = ps.executeQuery();
            while(rs.next()){
                serviceCodes.add(rs.getString("serviceid"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();
            }
            catch(SQLException sqle){
                sqle.printStackTrace();
            }
        }

        return serviceCodes;
    }

    //--- GET EXAMINATIONS FOR SERVICE ------------------------------------------------------------
    public static Vector getExaminationsForService(String serviceId, String language){
    	Vector exams = (Vector)MedwanQuery.getInstance().getServiceexaminations().get(serviceId+"."+language); 
    	if(exams==null){
	        exams = new Vector();
	        
	        Service service = Service.getService(serviceId);
	        if(service!=null && service.comment.indexOf("NOEXAMS")<0){
		        PreparedStatement ps = null;
		        ResultSet rs = null;
		        String sSelect, examIds = "";
		        
		        //*** get examination ids of examinations linked to the service ***
		        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
		        try{
		            sSelect = "SELECT distinct examinationid FROM ServiceExaminations WHERE serviceid = ?";
		            ps = oc_conn.prepareStatement(sSelect);
		            ps.setString(1,serviceId);
		
		            rs = ps.executeQuery();
		            while(rs.next()){
		                examIds+= rs.getString("examinationid")+",";
		            }
		
		            // remove last comma
		            if(examIds.indexOf(",") > -1){
		                examIds = examIds.substring(0,examIds.lastIndexOf(","));
		            }
		        }
		        catch(Exception e){
		            e.printStackTrace();
		        }
		        finally{
		            try{
		                if(rs!=null) rs.close();
		                if(ps!=null) ps.close();
		                oc_conn.close();
		            }
		            catch(SQLException sqle){
		                sqle.printStackTrace();
		            }
		        }
		
		        //*** get examination objects ***
		        if(examIds.length() > 0){
		            oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
		            try{
		                sSelect = "SELECT * FROM Examinations WHERE id IN ("+examIds+") ORDER BY priority";
		                ps = oc_conn.prepareStatement(sSelect);
		                rs = ps.executeQuery();
		
		                while(rs.next()){
		                    exams.add(new ExaminationVO(new Integer(rs.getInt("id")),rs.getString("messageKey"),
		                    		                    new Integer(rs.getInt("priority")),rs.getBytes("data"),
		                    		                    rs.getString("transactionType"),"","",language));
		                }
		            }
		            catch(Exception e){
		                e.printStackTrace();
		            }
		            finally{
		                try{
		                    if(rs!=null) rs.close();
		                    if(ps!=null) ps.close();
		                    oc_conn.close();
		                }
		                catch(SQLException sqle){
		                    sqle.printStackTrace();
		                }
		            }
		        }
	        }
	        MedwanQuery.getInstance().getServiceexaminations().put(serviceId+"."+language,exams);
    	}

        return exams;
    }

    //--- GET EXAMINATIONS FOR SERVICE ------------------------------------------------------------
    public static Vector getExaminationsForServiceIncludingParents(String serviceId, String language){
    	Vector exams = (Vector)MedwanQuery.getInstance().getServiceexaminationsincludingparent().get(serviceId+"."+language); 
    	if(exams==null){
	    	exams = new Vector();
	        PreparedStatement ps = null;
	        ResultSet rs = null;
	        String sSelect, examIds = "", allserviceids = "'"+serviceId+"'";
	        
	        Vector serviceIds = Service.getParentIds(serviceId);
	        for(int n=0; n<serviceIds.size(); n++){
	        	String sv = (String)serviceIds.elementAt(n);
	        	Service service = Service.getService(sv);
	        	if(service!=null && checkString(service.comment).indexOf("NOEXAMS")<0){
	        		allserviceids+= ",'"+sv+"'";
	        	}
	        }
	        
	        //*** get examination ids of examinations linked to the service ***
	        Connection oc_conn = MedwanQuery.getInstance().getOpenclinicConnection();
	        try{
	            sSelect = "SELECT distinct examinationid FROM ServiceExaminations WHERE serviceid in ("+allserviceids+")";
	            ps = oc_conn.prepareStatement(sSelect);
	            rs = ps.executeQuery();
	            while(rs.next()){
	                examIds+= rs.getString("examinationid")+",";
	            }
	
	            // remove last comma
	            if(examIds.indexOf(",") > -1){
	                examIds = examIds.substring(0,examIds.lastIndexOf(","));
	            }
	        }
	        catch(Exception e){
	            e.printStackTrace();
	        }
	        finally{
	            try{
	                if(rs!=null) rs.close();
	                if(ps!=null) ps.close();
	                oc_conn.close();
	            }
	            catch(SQLException sqle){
	                sqle.printStackTrace();
	            }
	        }
	
	        //*** get examination objects ***
	        if(examIds.length() > 0){
	            oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
	            try{
	                sSelect = "SELECT * FROM Examinations WHERE id IN ("+examIds+") ORDER BY priority";
	                ps = oc_conn.prepareStatement(sSelect);
	                rs = ps.executeQuery();
	
	                while(rs.next()){
	                    exams.add(new ExaminationVO(new Integer(rs.getInt("id")),rs.getString("messageKey"),
	                    		                    new Integer(rs.getInt("priority")),rs.getBytes("data"),
	                    		                    rs.getString("transactionType"),"","",language));
	                }
	            }
	            catch(Exception e){
	                e.printStackTrace();
	            }
	            finally{
	                try{
	                    if(rs!=null) rs.close();
	                    if(ps!=null) ps.close();
	                    oc_conn.close();
	                }
	                catch(SQLException sqle){
	                    sqle.printStackTrace();
	                }
	            }
	        }
	        MedwanQuery.getInstance().getServiceexaminationsincludingparent().put(serviceId+"."+language,exams);
    	}
        return exams;
    }

    //--- GET OTHER EXAMINATIONS FOR SERVICE ------------------------------------------------------
    public static Vector getOtherExaminationsForService(String serviceId, String language){
        Vector otherExams = new Vector(),
               linkedExamIds = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect, otherExamIds = "";

        //*** get ids of examinations linked to the specified service ***
        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            sSelect = "SELECT examinationid FROM ServiceExaminations WHERE serviceid = ?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,serviceId);

            rs = ps.executeQuery();
            while(rs.next()){
                linkedExamIds.add(rs.getString("examinationid"));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
            }
            catch(SQLException sqle){
                sqle.printStackTrace();
            }
        }

        //*** get ids of all examinations minus the ids of the linked examinations ***
        try{
            sSelect = "SELECT id FROM Examinations";
            ps = oc_conn.prepareStatement(sSelect);

            String examId;
            rs = ps.executeQuery();
            while(rs.next()){
                examId = rs.getString("id");
                if(!linkedExamIds.contains(examId)){
                    otherExamIds+= examId+",";
                }
            }

            // remove last comma
            if(otherExamIds.indexOf(",") > -1){
                otherExamIds = otherExamIds.substring(0,otherExamIds.lastIndexOf(","));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
            }
            catch(SQLException sqle){
                sqle.printStackTrace();
            }
        }

        //*** get examination objects ***
        if(otherExamIds.length() > 0){
            try{
                sSelect = "SELECT * FROM Examinations WHERE id IN ("+otherExamIds+") ORDER BY priority";
                ps = oc_conn.prepareStatement(sSelect);
                rs = ps.executeQuery();

                while(rs.next()){
                    otherExams.add(new ExaminationVO(new Integer(rs.getInt("id")),rs.getString("messageKey"),
                    		                         new Integer(rs.getInt("priority")),rs.getBytes("data"),
                    		                         rs.getString("transactionType"),"","",language));
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            finally{
                try{
                    if(rs!=null) rs.close();
                    if(ps!=null) ps.close();
                }
                catch(SQLException sqle){
                    sqle.printStackTrace();
                }
            }
        }

        return otherExams;
    }

    //--- WRITE DATE TIME FIELD -------------------------------------------------------------------
    public static String writeDateTimeField(String sName, String sForm, java.util.Date dValue,
    		                                String sWebLanguage, String sCONTEXTDIR){        
        return "<input type='text' maxlength='10' class='text' name='"+sName+"' id='"+sName+"' value='"+getSQLDate(dValue)+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";}'>"
              +"&nbsp;<img name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+getTranNoLink("Web","Select",sWebLanguage)+"' onclick='gfPop1.fPopCalendar(document.getElementsByName(\""+sName+"\")[0]);return false;'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick=\"getToday(document.getElementsByName('"+sName+"')[0]);getTime(document.getElementsByName('"+sName+"Time')[0])\">"
              +"&nbsp;"+writeTimeField(sName+"Time", formatSQLDate(dValue,"HH:mm"))
              +"&nbsp;"+getTran(null,"web.occup","medwan.common.hour",sWebLanguage);
    }

    //--- WRITE DATE TIME FIELD -------------------------------------------------------------------
    public static String writeDateTimeField(String sName, String sForm, java.util.Date dValue,
    		                                String sWebLanguage, String sCONTEXTDIR,String code){        
        return "<input type='text' maxlength='10' class='text' name='"+sName+"' id='"+sName+"' value='"+getSQLDate(dValue)+"' size='12' onblur='if(!checkDate(this)){dateError(this);this.value=\"\";};"+checkString(code)+"'>"
              +"&nbsp;<img name='popcal' class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_agenda.png' alt='"+getTranNoLink("Web","Select",sWebLanguage)+"' onclick='gfPop1.fPopCalendar(document.getElementsByName(\""+sName+"\")[0]);return false;'>"
              +"&nbsp;<img class='link' src='"+sCONTEXTDIR+"/_img/icons/icon_compose.png' alt='"+getTranNoLink("Web","PutToday",sWebLanguage)+"' onclick=\"getToday(document.getElementsByName('"+sName+"')[0]);getTime(document.getElementsByName('"+sName+"Time')[0])\">"
              +"&nbsp;"+writeTimeField(sName+"Time", formatSQLDate(dValue,"HH:mm"),code)
              +"&nbsp;"+getTran(null,"web.occup","medwan.common.hour",sWebLanguage);
    }

    //--- GET SQL TIME ----------------------------------------------------------------------------
    public static java.util.Date getSQLTime(String sTime){
        java.util.Date date = null;

        if(sTime.length()>0){
            try{
                date = new SimpleDateFormat().parse(sTime);
            }
            catch(Exception e){
                date = null;
            }
        }
        
        return date;
    }

    //--- GET SQL TIME ----------------------------------------------------------------------------
    public static java.util.Date getSQLTime(String sTime, String sFormat){
        java.util.Date date = null;

        if(sTime.length()>0){
            try{
                date = new SimpleDateFormat(sFormat).parse(sTime);
            }
            catch(Exception e){
                date = null;
            }
        }
        
        return date;
    }

    //--- GET PRODUCT UNIT TYPES ------------------------------------------------------------------
    public static Vector getProductUnitTypes(String sLang){
        Vector unitTypes = new Vector();
        PreparedStatement ps = null;
        ResultSet rs = null;

        // LOWER
    	Connection co_conn = MedwanQuery.getInstance().getConfigConnection();
        String lcaseLabelType = getConfigParam("lowerCompare","OC_LABEL_TYPE",co_conn);
        String lcaseLabelLang = getConfigParam("lowerCompare","OC_LABEL_LANGUAGE",co_conn);

        Connection oc_conn=MedwanQuery.getInstance().getOpenclinicConnection();
        try{
            String sSelect = "SELECT OC_LABEL_ID FROM OC_LABELS"+
                             " WHERE "+lcaseLabelType+"=? AND "+lcaseLabelLang+"=?";
            ps = oc_conn.prepareStatement(sSelect);
            ps.setString(1,"product.unit");
            ps.setString(2,sLang.toLowerCase());

            rs = ps.executeQuery();
            while(rs.next()){
                unitTypes.add(checkString(rs.getString("OC_LABEL_ID")));
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                oc_conn.close();
                co_conn.close();
            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return unitTypes;
    }

    //--- CONVERT TO ALFABETICAL CODE -------------------------------------------------------------
    public static String convertToAlfabeticalCode(String numberString){
        String[] alfabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m",
                            "n","o","p","q","r","s","t","u","v","w","x","y","z"};

        String letters = "";
        int number = Integer.parseInt(numberString);
        while(number>0){
            number--;
            letters=alfabet[(number % alfabet.length)]+letters;
            number=number-(number % alfabet.length);
            number=number/alfabet.length;
        }
        return letters;
    }

    //--- CONVERT TO ALFABETICAL CODE -------------------------------------------------------------
    public static String convertToAlfabeticalCode(int n){
        String[] alfabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m",
                            "n","o","p","q","r","s","t","u","v","w","x","y","z"};

        String letters = "";
        int number = n;
        while(number>0){
            number--;
            letters=alfabet[(number % alfabet.length)]+letters;
            number=number-(number % alfabet.length);
            number=number/alfabet.length;
        }
        return letters;
    }
    
    //--- CONVERT TO ALFABETICAL CODE -------------------------------------------------------------
    public static String convertToAlfabeticalCode(long n){
        String[] alfabet = {"a","b","c","d","e","f","g","h","i","j","k","l","m",
                            "n","o","p","q","r","s","t","u","v","w","x","y","z"};

        String letters = "";
        long number = n;
        while(number>0){
            number--;
            letters=alfabet[((int)(number % alfabet.length))]+letters;
            number=number-(number % alfabet.length);
            number=number/alfabet.length;
        }
        return letters;
    }
    
    public static String convertToUUID(int n) {
    	return convertToAlfabeticalCode(n).toUpperCase()+"-"+(97-n%97);
    }

    public static String convertToUUID(long n) {
    	return convertToAlfabeticalCode(n).toUpperCase()+"-"+(97-n%97);
    }

    public static String convertToUUID(String n) {
    	if(n==null || n.length()==0) {
    		return "";
    	}
    	try {
    		int i = Integer.parseInt(n);
    	}
    	catch(Exception e) {
    		return "";
    	}
    	return convertToAlfabeticalCode(n).toUpperCase()+"-"+(97-Integer.parseInt(n)%97);
    }
    
    public static int convertFromUUID(String s) {
    	int number=-1;
    	try {
        	if(s.split("-").length==2) {
		    	number = convertFromAlfabeticalCode(s.split("-")[0]);
		    	if((97-number%97)!=Integer.parseInt(s.split("-")[1])) {
		    		return -1;
		    	}
        	}
    	}
    	catch(Exception e) {
    		e.printStackTrace();
    	}
    	return number;
    }

    //--- CONVERT FROM ALFABETICAL CODE -------------------------------------------------------------
    public static int convertFromAlfabeticalCode(String s){
    	String numberString=s.toLowerCase();
        String alfabet = "abcdefghijklmnopqrstuvwxyz";

        int value = 0;
        int counter = 0;
        for(int i=0; i<numberString.length(); i++){
            int number = alfabet.indexOf(numberString.substring(i,i+1))+1;
            for(int k=numberString.length()-i-1; k>0; k--){
            	number*= alfabet.length();
            }
            value+= number;
        }
        
        return value;
    }
    
    //--- IS USER A DOCTOR ------------------------------------------------------------------------
    public static boolean isUserADoctor(User user){
        return isUserADoctor(Integer.parseInt(user.personid));
    }

    public static boolean isUserADoctor(UserVO user){
        return isUserADoctor(user.getPersonVO().personId.intValue());
    }

    public static boolean isUserADoctor(int personId){
        boolean userIsADoctor = false;
        ResultSet rs = null;
        PreparedStatement ps = null;

        String sSelect = "SELECT p.value"+
                         " FROM UserParameters p, Admin a, Users u"+
                         "  WHERE "+getConfigParam("lowerCompare","parameter")+" = 'organisationid'"+
                         "   AND value LIKE '9__'"+
                         "   AND a.personid = ?"+
                         "   AND u.userid = p.userid"+
                         "   AND a.personid = u.personid";
    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            ps = ad_conn.prepareStatement(sSelect);
            ps.setInt(1,personId);
            rs = ps.executeQuery();

            if(rs.next()){
                // person who did the examination has a doctor code
                userIsADoctor = true;
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();

            }
            catch(SQLException se){
                se.printStackTrace();
            }
        }

        return userIsADoctor;
    }
    //--- CONTEXT FOOTER --------------------------------------------------------------------------
    public static String contextFooter(HttpServletRequest request){
        String result = "</div>";

        try{
            SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
            if(sessionContainerWO.getCurrentTransactionVO().getTransactionId().intValue() > 0
                    || checkString(request.getParameter("be.mxs.healthrecord.transaction_id")).equalsIgnoreCase("currentTransaction")
                    || MedwanQuery.getInstance().getConfigString("doNotAskForContext").equalsIgnoreCase("on")){
                result += "<script>show('content-details');hide('confirm');</script>";
                result+=getDefaults(request);
            }
        }
        catch(Exception e){
            // nothing
        }

        return result;
    }

    //--- GET LAST ITEM ---------------------------------------------------------------------------
    public static ItemVO getLastItem(HttpServletRequest request, String sType){
        try{
            SessionContainerWO sessionContainerWO = (SessionContainerWO) SessionContainerFactory.getInstance().getSessionContainerWO(request, SessionContainerWO.class.getName());
            if(sessionContainerWO.getHealthRecordVO()!=null && sessionContainerWO.getCurrentTransactionVO()!=null){
                ItemVO actualItem = sessionContainerWO.getCurrentTransactionVO().getItem(sType);
                if(actualItem==null || actualItem.getItemId().intValue() < 0){
                    ItemVO lastItem = MedwanQuery.getInstance().getLastItemVO(sessionContainerWO.getHealthRecordVO().getHealthRecordId().toString(), sType);
                    if(lastItem==null){
                        if(sessionContainerWO.getCurrentTransactionVO().getItem(sType)!=null){
                            return sessionContainerWO.getCurrentTransactionVO().getItem(sType);
                        }
                    } 
                    else{
                        return lastItem;
                    }
                } 
                else{
                    return actualItem;
                }
            }
        }
        catch (SessionContainerFactoryException e){
            e.printStackTrace();
        }

        // no last item found, so return a blank item
        return new ItemVO(null,"","",null,null);
    }
    
    //--- CHECK SPECIAL CHARACTERS ----------------------------------------------------------------
    // this function is used by DBSynchroniser and AdminPerson
    public static String checkSpecialCharacters(String sTest){
    	sTest = sTest.toLowerCase();
        sTest = sTest.replaceAll("'","");
        sTest = sTest.replaceAll(" ","");
        sTest = sTest.replaceAll("-","");
        sTest = sTest.replaceAll("é","e");
        sTest = sTest.replaceAll("è","e");
        sTest = sTest.replaceAll("ï","i");
        sTest = sTest.replaceAll("é","e");
        sTest = sTest.replaceAll("è","e");
        sTest = sTest.replaceAll("ë","e");
        sTest = sTest.replaceAll("ï","i");
        sTest = sTest.replaceAll("ö","o");
        sTest = sTest.replaceAll("ä","a");
        sTest = sTest.replaceAll("á","a");
        sTest = sTest.replaceAll("à","a");

        return sTest;
    }
    
    //--- SET SQL DATE ----------------------------------------------------------------------------
    public static void setSQLDate(PreparedStatement ps, int iIndex, String sDate){
        try{
            if(sDate==null || sDate.trim().length()==0){
                ps.setNull(iIndex,Types.DATE);
            }
            else{
                ps.setDate(iIndex,ScreenHelper.getSQLDate(sDate));
            }
        }
        catch (SQLException e){
            e.printStackTrace();
        }
    }
    
    //--- PAD LEFT --------------------------------------------------------------------------------
    public static String padLeft(String s, String padCharacter, int size){
        int i = s.length();
        for(int n = 0; n<size-i; n++){
            s = padCharacter+s;
        }
        
        return s;
    }

    //--- PAD RIGHT -------------------------------------------------------------------------------
    public static String padRight(String s, String padCharacter, int size){
        int i = s.length();
        for(int n = 0; n<size-i; n++){
            s = s+padCharacter;
        }
        
        return s;
    }

    //--- GET SERVICE CONTEXTS --------------------------------------------------------------------
    public static Hashtable getServiceContexts(){
        Hashtable serviceContexts = new Hashtable();
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sSelect;

    	Connection ad_conn = MedwanQuery.getInstance().getAdminConnection();
        try{
            sSelect = "SELECT DISTINCT serviceid,defaultcontext FROM Services";
            ps = ad_conn.prepareStatement(sSelect);

            rs = ps.executeQuery();
            while(rs.next()){
                serviceContexts.put(rs.getString("serviceid")+"",rs.getString("defaultcontext")+"");
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }
        finally{
            try{
                if(rs!=null) rs.close();
                if(ps!=null) ps.close();
                ad_conn.close();
            }
            catch(SQLException sqle){
                sqle.printStackTrace();
            }
        }

        return serviceContexts;
    }
    
    public static String base64Decompress(byte[] input){
    	String s = "";
    	ByteArrayOutputStream stream = new ByteArrayOutputStream();
        Inflater decompresser = new Inflater(true);
        InflaterOutputStream inflaterOutputStream = new InflaterOutputStream(stream, decompresser);
        try {
			inflaterOutputStream.write(input);
	        inflaterOutputStream.close();
	        s=new String(stream.toByteArray());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return s;
    }
    
    public static byte[] base64Compress(String s){
    	byte[] out = null;
    	ByteArrayOutputStream stream = new ByteArrayOutputStream();
    	Deflater compresser = new Deflater(Deflater.BEST_COMPRESSION, true);
    	DeflaterOutputStream deflaterOutputStream = new DeflaterOutputStream(stream, compresser);
    	try {
			deflaterOutputStream.write(s.getBytes());
	    	deflaterOutputStream.close();
	    	out=stream.toByteArray();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return out;
    }

    public static String removeLeadingZeros(String s){
    	for(int n=0;n<s.length();n++){
    		if(!s.substring(n).startsWith("0")){
    			return s.substring(n);
    		}
    	}
    	return"";
    }
    
    public static String writeAutocompleteLabelField(String sName, int nSize, String sLabelType, String sSelectFunction){
    	StringBuffer s = new StringBuffer();
    	s.append("<input type='hidden' name='"+sName+"id' id='"+sName+"id' value=''>\n");
    	s.append("<input type='text' class='text' name='"+sName+"' id='"+sName+"' size='"+nSize+"' value=''>\n");
    	s.append("<div id='autocomplete_"+sName+"' class='autocomple'></div>\n");
    	s.append("<script>\n");
    	s.append("  new Ajax.Autocompleter('"+sName+"','autocomplete_"+sName+"','util/getAutoLabels.jsp?labeltype="+sLabelType+"',{\n");
    	s.append("    minChars:1,\n");
    	s.append("    method:'post',");
    	s.append("    afterUpdateElement:afterAutoComplete,\n");
    	s.append("    callback:composeCallbackURL\n");
    	s.append("  });\n");
    	s.append("  function afterAutoComplete(field,item){\n");
    	s.append("    var name= item.innerHTML.substring(0,item.innerHTML.indexOf('<span'));\n");
    	s.append("    var id = item.innerHTML.substring(item.innerHTML.substring(item.innerHTML.indexOf('<span')));\n");
    	s.append("    id=id.substring(id.indexOf('>')+1);\n");
    	s.append("    id=id.substring(0,id.indexOf('-idcache'));\n");
    	s.append("    document.getElementById('"+sName+"id').value = id;\n");
    	s.append("    document.getElementById('"+sName+"').value=name;\n");
    	s.append("    "+sSelectFunction+";\n");
    	s.append("  }\n");
    	s.append("  function composeCallbackURL(field,item){\n");
    	s.append("    var url = '';\n");
    	s.append("    if(field.id=='"+sName+"'){\n");
    	s.append("      url = 'findcode='+field.value;\n");
    	s.append("    }\n");
    	s.append("    return url;\n");
    	s.append("  }\n");
    	s.append("</script>");
    	
    	return s.toString();
    }
    
    //--- IS LIKE ---------------------------------------------------------------------------------
    // SQL's LIKE-function with '_' representing any single char and '%' representing any group of chars
    public static boolean isLike(String sExpression, String sText){
    	String regex = "";
    	int len = sExpression.length();
    	if(len > 0){    	 
	        StringBuffer sb = new StringBuffer();
	    	for(int i=0; i<len; i++){
	    	    char c = sExpression.charAt(i);
	    	    if("[](){}.*+?$^|#\\".indexOf(c)!=-1){
	    	        sb.append("\\");
	    	    }
	    	    sb.append(c);
	    	}
	    	regex = sb.toString();
    	}
    	
    	regex = regex.replace("_",".")
    			     .replace("%",".*?");
    	Pattern p = Pattern.compile(regex,Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    	
    	return p.matcher(sText).matches();    	  	
    }
    
}
