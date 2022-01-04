package be.mayele;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;

public class MayeleClient {

	public static String find(String url,HashMap<String,String> parameters) throws HttpException, IOException, DocumentException {
		HttpClient client = new HttpClient();
		PostMethod method = new PostMethod(url);
		Iterator<String> iKeys = parameters.keySet().iterator();
		while(iKeys.hasNext()) {
			String key = iKeys.next();
			method.addParameter(key, parameters.get(key));
		}
		client.executeMethod(method);
		return method.getResponseBodyAsString().trim();
	}
}
