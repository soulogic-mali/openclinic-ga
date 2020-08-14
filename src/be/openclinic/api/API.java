package be.openclinic.api;

import java.io.IOException;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.json.JSONObject;
import org.json.XML;

import be.openclinic.system.SH;

public abstract class API {
	HttpServletRequest request = null;
	Hashtable<String,String> instructions = null;
	
	public API(HttpServletRequest request) {
		this.request = request;
		getInstructions();
	}
	
	public void getInstructions() {
		instructions = new Hashtable<String,String>();
		if(request.getQueryString()!=null) {
			String[] i = request.getQueryString().split("&");
			for(int n=0;n<i.length;n++) {
				if(i[n].split("=").length>=2) {
					instructions.put(i[n].split("=")[0], i[n].split("=")[1]);
				}
				else if(i[n].length()>0) {
					instructions.put(i[n].split("=")[0], "");
				}
			}
		}
	}
	
	public void printInstructions() {
		Iterator<String> i = instructions.keySet().iterator();
		while(i.hasNext()) {
			String key=i.next();
			System.out.println(key+" = "+instructions.get(key));
		}
	}
	
	public boolean exists(String key) {
		return SH.c(instructions.get(key)).length()>0;
	}
	
	public String value(String key) {
		return SH.c(instructions.get(key));
	}
	
	public String value(String key,String defaultValue) {
		if(value(key).length()==0) {
			return defaultValue;
		}
		else {
			return value(key);
		}
	}
	
	public void getToServletStream(HttpServletResponse response) throws IOException {
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"openclinic_api_"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".api\"");
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = get().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	
	public void setToServletStream(HttpServletResponse response) throws IOException {
	    response.setContentType("application/octet-stream; charset=windows-1252");
	    response.setHeader("Content-Disposition", "Attachment;Filename=\"openclinic_api_"+new SimpleDateFormat("yyyyMMddHHmmss").format(new Date())+".api\"");
	    ServletOutputStream os = response.getOutputStream();
    	byte[] b = set().getBytes("ISO-8859-1");
        for(int n=0; n<b.length; n++){
            os.write(b[n]);
        }
        os.flush();
        os.close();
	}
	
	public static String prettyPrintXml(String xml) {

	    final StringWriter sw;

	    try {
	        final OutputFormat format = OutputFormat.createPrettyPrint();
	        format.setIndentSize(4);
	        final org.dom4j.Document document = DocumentHelper.parseText(xml);
	        sw = new StringWriter();
	        final XMLWriter writer = new XMLWriter(sw, format);
	        writer.write(document);
	    }
	    catch (Exception e) {
	        throw new RuntimeException("Error pretty printing xml:\n" + xml, e);
	    }
	    return sw.toString();
	}
	
	public String format(String s) {
		if(value("format","xml").equalsIgnoreCase("json")) {
			JSONObject xmlJSONObj = XML.toJSONObject(s);
			return xmlJSONObj.toString(4);
		}
		else if(value("format","xml").equalsIgnoreCase("htmljson")) {
			JSONObject xmlJSONObj = XML.toJSONObject(s);
			return "<pre><code>"+xmlJSONObj.toString(4).replaceAll("<", "&lt;")+"</code></pre>";
		}
		else if(value("format","xml").equalsIgnoreCase("htmlxml")) {
			return "<pre><code>"+prettyPrintXml(s).replaceAll("<", "&lt;")+"</code></pre>";
		}
		else {
			return prettyPrintXml(s);
		}
	}
	
	public abstract String get();

	public abstract String set();
}
