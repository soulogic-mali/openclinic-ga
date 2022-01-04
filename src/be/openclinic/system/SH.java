package be.openclinic.system;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.text.RandomStringGenerator;

import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;
import be.openclinic.knowledge.SPT;

public class SH extends ScreenHelper {
	
	public static String getScanDirectoryFromPath() {
		String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
	    return SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirFrom","from");
	}
	
	public static String getScanDirectoryToPath() {
		String SCANDIR_BASE = MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan");
	    return SCANDIR_BASE+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to");
	}
	
	public static Hashtable getMultipartFormParameters(HttpServletRequest request) {
		Hashtable parameters = new Hashtable();
		if(ServletFileUpload.isMultipartContent(request)) {
		    FileItemFactory factory = new DiskFileItemFactory();
		    ServletFileUpload upload = new ServletFileUpload(factory);
		    List items = null;
		    try {
		        items = upload.parseRequest(request);
	        } catch (FileUploadException e) {
	             e.printStackTrace();
	        }
		    Iterator itr = items.iterator();
		    while (itr.hasNext()) {
		        FileItem item = (FileItem) itr.next();
		        if (item.isFormField()) {
		        	parameters.put(item.getFieldName(), item.getString());
		        } else {
		        	try {
		        		FormFile formFile =new FormFile();
		        		formFile.document=item.get();
		        		formFile.filename=FilenameUtils.getName(item.getName()); 
		        		parameters.put(item.getFieldName(), formFile);
		            } catch (Exception e) {
		                 e.printStackTrace();
		            }
		      	}
		    }    	
		}
		return parameters;
	}
	
	public static java.sql.Timestamp ts(java.util.Date date){
		if(date==null) {
			return null;
		}
		return new java.sql.Timestamp(date.getTime());
	}
	
	public static String c(String s) {
		return checkString(s);
	}
	
	public static String c(StringBuffer s) {
		return checkString(s);
	}
	
	public static String c(String s, String defaultValue) {
		return checkString(s,defaultValue);
	}
	
	public static String sid() {
		return SH.getConfigString("serverid");
	}
	
	public static String cx(String s) {
		return convertToXml(c(s));
	}
	
	public static String convertToXml(String s) {
		return s.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "glt;").replaceAll("\"", "&quot;").replaceAll("'", "&apos;");
	}
	
	public static String c(java.util.Date d) {
		return formatDate(d,SH.fullDateFormatSS);
	}
	
	public static String p(HttpServletRequest request, String parameter) {
		return c(request.getParameter(parameter));
	}
	
    public static int ci(String key, int defaultValue) {
    	return MedwanQuery.getInstance().getConfigInt(key,defaultValue);
    }

    public static String cs(String key, String defaultValue) {
    	return MedwanQuery.getInstance().getConfigString(key,defaultValue);
    }
    
    public static String getRandomPassword() {
		char [][] pairs = {{'a','z'},{'0','9'}};
    	return new RandomStringGenerator.Builder().withinRange(pairs).build().generate(SH.ci("mpiGeneratedPatientPasswordLength", 8));
    }

    public static String getRandomPassword(int length) {
		char [][] pairs = {{'a','z'},{'0','9'}};
    	return new RandomStringGenerator.Builder().withinRange(pairs).build().generate(length);
    }

    public static Connection getOpenClinicConnection() {
    	return MedwanQuery.getInstance().getOpenclinicConnection();
    }
    
    public static Connection getAdminConnection() {
    	return MedwanQuery.getInstance().getAdminConnection();
    }
    
    public static Connection getStatsConnection() {
    	return MedwanQuery.getInstance().getStatsConnection();
    }
    
    public static int getServerId() {
    	return MedwanQuery.getInstance().getConfigInt("serverId",1);
    }
    
    public static String formatDouble(double d) {
    	return new DecimalFormat("#0.00",new DecimalFormatSymbols(Locale.getDefault())).format(d);
    }
    
    public static boolean hasSPTDataToPost() {
    	return SPT.hasSPTDataToPost();
    }
    
    public static boolean isHostReachable(String host) {
    	try {
			return InetAddress.getByName(host).isReachable(2000);
		} catch (Exception e) {
			return false;
		}
    }
}
