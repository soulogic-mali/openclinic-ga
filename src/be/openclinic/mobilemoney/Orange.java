package be.openclinic.mobilemoney;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Hex;

import be.openclinic.system.SH;

public class Orange {
	public static String sha256_HMAC_encode(String key, String data) {
	    try {
	        Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
	        SecretKeySpec secret_key = new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256");
	        sha256_HMAC.init(secret_key);
	        return new String(Hex.encodeHex(sha256_HMAC.doFinal(data.getBytes("UTF-8"))));
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return null;
	}
	
	public static String getAuthorization(String body) {
		String api_access_key = SH.cs("om_api_access_key","cv6AjDTBoESckuQOAuFvHhpO9UAyni8p");
		String api_secret_key = SH.cs("om_api_secret_key","JuMzdSoRrHYBiBGqY49P71Y6csas3yf4");
		String timestamp = new java.util.Date().getTime()+"";
		String version = "1";
		String signature = sha256_HMAC_encode(api_secret_key, api_access_key+":"+timestamp+":"+version+":"+body);
		return "AUTH "+api_access_key+":"+timestamp+":"+version+":"+signature;
	}
	
}
