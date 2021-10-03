package be.openclinic.system;

import java.io.File;
import java.io.IOException;

import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.entity.mime.content.ByteArrayBody;
import org.apache.http.entity.mime.content.ContentBody;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;

public class OCHttpClient {
	MultipartEntityBuilder builder = MultipartEntityBuilder.create();
	
	public OCHttpClient() {
		builder.setMode(HttpMultipartMode.BROWSER_COMPATIBLE);
	}
	
	public void addStringParam(String sName, String sContent) {
		StringBody sb = new StringBody(sContent,ContentType.MULTIPART_FORM_DATA);
		builder.addPart(sName,sb);
	}
	
	public void addByteArrayParam(String sName, byte[] bContent) {
		ContentBody cb = new ByteArrayBody(bContent,SH.getRandomPassword(10)+".dat");
		builder.addPart(sName,cb);
	}
	
	public void addFileParam(String sName, File file) {
		FileBody fileBody = new FileBody(file, ContentType.DEFAULT_BINARY);
		builder.addPart(sName, fileBody);
	}
	
	public CloseableHttpResponse post(String url) throws ClientProtocolException, IOException {
		HttpEntity entity = builder.build();
		HttpPost post = new HttpPost(url);
		post.setEntity(entity);
		CloseableHttpClient client = HttpClients.createDefault(); 
		return client.execute(post);
	}
}
