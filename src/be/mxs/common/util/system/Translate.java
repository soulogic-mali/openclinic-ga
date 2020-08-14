package be.mxs.common.util.system;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.Iterator;
import java.util.Vector;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.io.IOUtils;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.messync.Label;



public class Translate {

	public static String translate(String sourcelanguage,String targetlanguage,String text){
		return translate(sourcelanguage, targetlanguage, text, null);
	}
	
	public static String translate(String sourcelanguage,String targetlanguage,String text,String sErrorValue){
		//First test if target language is different from source language
		if(sourcelanguage.equalsIgnoreCase(targetlanguage)){
			return text;
		}
		//Then test if the requested translation has not been retrieved yet before
		String sTranslation = Pointer.getPointer((sourcelanguage+"."+targetlanguage+"."+text.hashCode()+"."+text.length()).toLowerCase());
		if(sTranslation.length()>0){
			return sTranslation;
		}
		String s=text;
		try{
			HttpClient client = new HttpClient();
			String url = MedwanQuery.getInstance().getConfigString("MyMemoryURL","http://api.mymemory.translated.net/get");
			GetMethod method = new GetMethod(url);
			method.setRequestHeader("Content-type","text/xml; charset=windows-1252");
			Vector<NameValuePair> vNvp = new Vector<NameValuePair>();
        	vNvp.add(new NameValuePair("de","frank@minf.be"));
        	vNvp.add(new NameValuePair("of","tmx"));
        	vNvp.add(new NameValuePair("key","51868268a07cc4216f68"));
        	vNvp.add(new NameValuePair("q",text));
        	vNvp.add(new NameValuePair("langpair",sourcelanguage+"|"+targetlanguage));
			NameValuePair[] nvp = new NameValuePair[vNvp.size()];
			vNvp.copyInto(nvp);
			method.setQueryString(nvp);		
			int statusCode = client.executeMethod(method);
			BufferedReader br = new BufferedReader(new StringReader(method.getResponseBodyAsString()));
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();
	        while (line != null) {
	        	if(line.indexOf("<!DOCTYPE")<0){
		            sb.append(line);
	        	}
	            line = br.readLine();
	        }
	        String everything = sb.toString();
	        br = new BufferedReader(new StringReader(everything));
	 		SAXReader reader=new SAXReader(false);
			org.dom4j.Document document=reader.read(br);
			Element root = document.getRootElement(); //tmx element
			if(root.getName().equalsIgnoreCase("tmx")){
				Element body=root.element("body");
				if(body!=null){
					Element translation=body.element("tu");
					Iterator languages = translation.elementIterator("tuv");
					while(languages.hasNext()){
							Element language=(Element)languages.next();
							if(language.attributeValue("lang").toLowerCase().startsWith(targetlanguage.toLowerCase())){
								sTranslation = language.elementText("seg");
								Pointer.storePointer((sourcelanguage+"."+targetlanguage+"."+text.hashCode()+"."+text.length()).toLowerCase(), sTranslation);
								return sTranslation;
							}
					}
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
			s=sErrorValue;
		}
		return s;
	}
	
	public static String translateLabel(String sType, String sID, String sSourceLanguage, String sTargetLanguage){
		return translateLabel(sType, sID, sSourceLanguage, sTargetLanguage,null);
	}
	
	public static String translateLabel(String sType, String sID, String sSourceLanguage, String sTargetLanguage,String sDefault){
		String sTranslatedLabel=sID;
		Debug.println("searching for "+sType+"/"+sID+"/"+sSourceLanguage+".........");
		if(!sSourceLanguage.equalsIgnoreCase(sTargetLanguage) && net.admin.Label.labelExists(sType, sID, sSourceLanguage)){
			Debug.println(sID+" exists");
			//First find translation of label
			sTranslatedLabel=translate(sSourceLanguage, sTargetLanguage, ScreenHelper.getTranNoLinkNoTranslate(sType, sID, sSourceLanguage));
			if(sTranslatedLabel!=null){
				Debug.println("sType          ="+sType);
				Debug.println("sID            ="+sID);
				Debug.println("sTargetLanguage="+sTargetLanguage);
				Debug.println("original label ="+ScreenHelper.getTranNoLinkNoTranslate(sType, sID, sSourceLanguage));
				Debug.println("translation    ="+sTranslatedLabel);
				net.admin.Label label = new net.admin.Label(sType, sID, sTargetLanguage, sTranslatedLabel, "1", "4");
				label.saveToDB();
			}
		}
		else if(!sSourceLanguage.equalsIgnoreCase("en") && net.admin.Label.labelExists(sType, sID, "en")){
			Debug.println(sID+" exists");
			//First find translation of label
			sTranslatedLabel=translate("en", sTargetLanguage, ScreenHelper.getTranNoLinkNoTranslate(sType, sID, "en"));
			if(sTranslatedLabel!=null){
				Debug.println("sType          ="+sType);
				Debug.println("sID            ="+sID);
				Debug.println("sTargetLanguage="+sTargetLanguage);
				Debug.println("original label ="+ScreenHelper.getTranNoLinkNoTranslate(sType, sID, sSourceLanguage));
				Debug.println("translation    ="+sTranslatedLabel);
				net.admin.Label label = new net.admin.Label(sType, sID, sTargetLanguage, sTranslatedLabel, "1", "4");
				label.saveToDB();
			}
			
		}
		return sDefault;
	}

}
