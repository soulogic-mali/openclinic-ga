package be.openclinic.system;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.text.RandomStringGenerator;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.system.ScreenHelper;

public class SH extends ScreenHelper {
	
	public static String c(String s) {
		return checkString(s);
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

}
