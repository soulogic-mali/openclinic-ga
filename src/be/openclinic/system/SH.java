package be.openclinic.system;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.text.RandomStringGenerator;

import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class SH extends ScreenHelper {
	
	public static String c(String s) {
		return checkString(s);
	}
	
	public static String c(String s, String defaultValue) {
		return checkString(s,defaultValue);
	}
	
	public static String p(HttpServletRequest request,String parameter) {
		return c(request.getParameter(parameter));
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
    
    public static int getServerId() {
    	return MedwanQuery.getInstance().getConfigInt("serverId",1);
    }
    
    public static String formatDouble(double d) {
    	return new DecimalFormat("#0.00",new DecimalFormatSymbols(Locale.getDefault())).format(d);
    }
}
