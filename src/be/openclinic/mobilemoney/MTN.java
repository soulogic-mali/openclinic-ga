package be.openclinic.mobilemoney;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.sql.Date;
import java.text.DecimalFormat;
import java.util.Base64;
import java.util.UUID;

import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.ParseException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.system.SH;

public class MTN {
	private AuthorizationToken token=null, disbursementToken=null;
	private String lastEntity="";
		
	public String getLastEntity() {
		return lastEntity;
	}
	
	public void setLastEntity(HttpEntity entity) {
		lastEntity="";
		if(entity !=null) {
			try {
				lastEntity=EntityUtils.toString(entity);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public AuthorizationToken getDisbursementToken() {
		if(disbursementToken==null || disbursementToken.getExpires().before(new java.util.Date())) {
			//Create a new token
			setDisbursementToken(createDisbursementToken());
		}
		return disbursementToken;
	}

	public void setDisbursementToken(AuthorizationToken disbursementToken) {
		this.disbursementToken = disbursementToken;
	}

	public AuthorizationToken getToken() {
		if(token==null || token.getExpires().before(new java.util.Date())) {
			//Create a new token
			setToken(createCollectionToken());
		}
		return token;
	}

	public void setToken(AuthorizationToken token) {
		this.token = token;
	}

	public static String getUUID() {
		return UUID.randomUUID().toString();
	}
	
	public static String getCollectionSubscriptionKey() {
		return SH.cs("momo.collectionsubscriptionkey", "nil");
	}
	
	public static String getDisbursementSubscriptionKey() {
		return SH.cs("momo.disbursementsubscriptionkey", "nil");
	}
	
	public static String getApiUser() {
		return SH.cs("momo.apiuser", "nil");
	}
	
	public static String getApiKey() {
		return SH.cs("momo.apikey", "nil");
	}
	
	public static String getBasicAuthentication() {
		try {
			return Base64.getEncoder().encodeToString((getApiUser()+":"+getApiKey()).getBytes("utf-8" ));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String requestPayment(double amount, String currency, String invoiceId, String phoneNumber, String payerMessage, String payeeMessage,String patientUid, String userid) {
		String paymentTransactionId=null;
		try {
			paymentTransactionId=getUUID();
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.requesttopay.baseurl","https://sandbox.momodeveloper.mtn.com/collection/v1_0");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.requesttopay.baseurl","https://momo.mtn.com/collection/v1_0");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/requesttopay");
			URI uri = builder.build();
			HttpPost req = new HttpPost(uri);
		    req.setHeader("Authorization", "Bearer "+getToken().getToken());
		    req.setHeader("X-Reference-Id", paymentTransactionId);
		    req.setHeader("X-Target-Environment", SH.cs("momo.targetenvironment","mtnrwanda"));
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getCollectionSubscriptionKey());
		    String payload="{\"amount\": \""+new DecimalFormat(SH.cs("momo.decimalFormat", "#0")).format(amount)+"\", \"currency\": \""+currency+"\", \"externalId\": \""+invoiceId+"\", \"payer\": {\"partyIdType\": \"MSISDN\", \"partyId\": \""+phoneNumber+"\"}, \"payerMessage\": \""+payerMessage+"\", \"payeeNote\": \""+payeeMessage+"\"}";
		    StringEntity reqEntity = new StringEntity(payload);
		    req.setEntity(reqEntity);
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    setLastEntity(entity);
		    if (entity!=null && (resp.getStatusLine().getStatusCode()==202 || resp.getStatusLine().getStatusCode()==200)) 
		    {
		    	MobileMoney.createPaymentRequest(paymentTransactionId, invoiceId, patientUid, amount, currency, phoneNumber, payerMessage, payeeMessage, userid,"MTN");
		    	return paymentTransactionId;
		    }
		    else {
			    	System.out.println(resp.getStatusLine().toString());
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String disbursePayment(double amount, String currency, String invoiceId, String phoneNumber, String payerMessage, String payeeMessage,String patientUid, String userid, String originTransactionId) {
		String paymentTransactionId=null;
		try {
			paymentTransactionId=getUUID();
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.disbursement.baseurl","https://sandbox.momodeveloper.mtn.com/disbursement/v1_0");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.disbursement.baseurl","https://momo.mtn.com/disbursement/v1_0");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/transfer");
			URI uri = builder.build();
			HttpPost req = new HttpPost(uri);
		    req.setHeader("Authorization", "Bearer "+getDisbursementToken().getToken());
		    req.setHeader("X-Reference-Id", paymentTransactionId);
		    req.setHeader("X-Callback-Url", SH.cs("momo.callbackURL", "http://cloud.hnrw.org/openclinic/disbursePayment.jsp"));
		    req.setHeader("X-Target-Environment", SH.cs("momo.targetenvironment","mtnrwanda"));
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getDisbursementSubscriptionKey());
		    StringEntity reqEntity = new StringEntity("{\"amount\": \""+new DecimalFormat(SH.cs("momo.decimalFormat", "#0")).format(amount)+"\", \"currency\": \""+(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("sandbox")?"EUR":currency)+"\", \"externalId\": \""+invoiceId+"\", \"payee\": {\"partyIdType\": \"MSISDN\", \"partyId\": \""+phoneNumber+"\"}, \"payerMessage\": \""+payerMessage+"\", \"payeeNote\": \""+payeeMessage+"\"}");
		    req.setEntity(reqEntity);
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    setLastEntity(entity);
		    if (entity!=null && resp.getStatusLine().getStatusCode()==202) 
		    {
		    	MobileMoney.createDisbursement(paymentTransactionId, invoiceId, patientUid, -amount, currency, phoneNumber, payerMessage, payeeMessage, userid,"MTN", originTransactionId);
		    	return paymentTransactionId;
		    }
		    else {
		    	System.out.println(resp.getStatusLine().toString());
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String getPaymentStatus(String paymentTransactionId) {
		try {
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.requesttopay.baseurl","https://sandbox.momodeveloper.mtn.com/collection/v1_0");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.requesttopay.baseurl","https://momo.mtn.com/collection/v1_0");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/requesttopay/"+paymentTransactionId);
			URI uri = builder.build();
		    HttpGet req = new HttpGet(uri);
		    req.setHeader("Authorization", "Bearer "+getToken().getToken());
		    req.setHeader("X-Reference-Id", paymentTransactionId);
		    req.setHeader("X-Target-Environment", SH.cs("momo.targetenvironment","mtnrwanda"));
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getCollectionSubscriptionKey());
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    setLastEntity(entity);
		    if (entity!=null && resp.getStatusLine().getStatusCode()==200) 
		    {
		    	JsonReader jr = Json.createReader(new java.io.StringReader(getLastEntity()));
		    	JsonObject jo = jr.readObject();
		    	jr.close();
		    	if(jo.getString("status").equalsIgnoreCase("successful") || jo.getString("status").equalsIgnoreCase("failure")) {
		    		MobileMoney.updatePaymentStatus(paymentTransactionId, jo.getString("status"),jo.getString("financialTransactionId"));
		    	}
		    	return jo.getString("status");
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String getDisbursementStatus(String paymentTransactionId) {
		try {
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.production.disbursement.baseurl","https://sandbox.momodeveloper.mtn.com/disbursement/v1_0");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.disbursement.baseurl","https://momo.mtn.com/disbursement/v1_0");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/transfer/"+paymentTransactionId);
			URI uri = builder.build();
		    HttpGet req = new HttpGet(uri);
		    req.setHeader("Authorization", "Bearer "+getDisbursementToken().getToken());
		    req.setHeader("X-Reference-Id", paymentTransactionId);
		    req.setHeader("X-Target-Environment", SH.cs("momo.targetenvironment","mtnrwanda"));
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getDisbursementSubscriptionKey());
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    setLastEntity(entity);
		    if (entity!=null && resp.getStatusLine().getStatusCode()==200) 
		    {
		    	JsonReader jr = Json.createReader(new java.io.StringReader(getLastEntity()));
		    	JsonObject jo = jr.readObject();
		    	jr.close();
		    	if(jo.getString("status").equalsIgnoreCase("successful") || jo.getString("status").equalsIgnoreCase("failure")) {
		    		MobileMoney.updateDisbursementStatus(paymentTransactionId, jo.getString("status"),jo.getString("financialTransactionId"));
		    	}
		    	return jo.getString("status");
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public static AuthorizationToken createCollectionToken() {
		AuthorizationToken token =null;
		try {
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.token.baseurl","https://sandbox.momodeveloper.mtn.com/collection");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.token.baseurl","https://momo.mtn.com/collection");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/token/");
			URI uri = builder.build();
		    HttpPost req = new HttpPost(uri);
		    System.out.println("Basic "+getBasicAuthentication());
		    req.setHeader("Authorization", "Basic "+getBasicAuthentication());
		    req.setHeader("Ocp-Apim-Subscription-Key", getCollectionSubscriptionKey());
		    StringEntity reqEntity = new StringEntity("");
		    req.setEntity(reqEntity);
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    System.out.println("###################"+resp.getStatusLine().toString());
		    if (entity != null && resp.getStatusLine().getStatusCode()==200) 
		    {
		    	JsonReader jr = Json.createReader(new java.io.StringReader(EntityUtils.toString(entity)));
		    	JsonObject jo = jr.readObject();
		    	token = new AuthorizationToken(jo.getString("access_token"), new java.util.Date(new java.util.Date().getTime()+(jo.getInt("expires_in")-30)*1000));
		    	jr.close();
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return token;
	}
	
	public static AuthorizationToken createDisbursementToken() {
		AuthorizationToken token =null;
		try {
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.disbursementtoken.baseurl","https://sandbox.momodeveloper.mtn.com/disbursement");
			if(SH.cs("momo.targetsystem","sandbox").equalsIgnoreCase("production")) {
				baseurl=SH.cs("momo.production.disbursementtoken.baseurl","https://momo.mtn.com/disbursement");
			}
			URIBuilder builder = new URIBuilder(baseurl+"/token/");
			URI uri = builder.build();
		    HttpPost req = new HttpPost(uri);
		    req.setHeader("Authorization", "Basic "+getBasicAuthentication());
		    req.setHeader("Ocp-Apim-Subscription-Key", getDisbursementSubscriptionKey());
		    StringEntity reqEntity = new StringEntity("");
		    req.setEntity(reqEntity);
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    if (entity != null && resp.getStatusLine().getStatusCode()==200) 
		    {
		    	JsonReader jr = Json.createReader(new java.io.StringReader(EntityUtils.toString(entity)));
		    	JsonObject jo = jr.readObject();
		    	token = new AuthorizationToken(jo.getString("access_token"), new java.util.Date(new java.util.Date().getTime()+(jo.getInt("expires_in")-30)*1000));
		    	jr.close();
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return token;
	}
	
	public static boolean createSandBoxApiKey() {
		try {
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.createapikey.baseurl","https://sandbox.momodeveloper.mtn.com/v1_0");
			URIBuilder builder = new URIBuilder(baseurl+"/apiuser/"+getApiUser()+"/apikey");
			URI uri = builder.build();
		    HttpPost req = new HttpPost(uri);
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getCollectionSubscriptionKey());
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    if (entity != null && resp.getStatusLine().getStatusCode()==201) 
		    {
		    	JsonReader jr = Json.createReader(new java.io.StringReader(EntityUtils.toString(entity)));
		    	JsonObject jo = jr.readObject();
		    	MedwanQuery.getInstance().setConfigString("momo.apikey", jo.getString("apiKey"));
		    	jr.close();
		    	return true;
		    }
		    else {
		    	System.out.println(resp.getStatusLine().toString());
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	    return false;
	}
	
	public static boolean createSandBoxApiUser() {
		try {
			String apiuser=getUUID();
			HttpClient httpclient = HttpClients.createDefault();
			String baseurl=SH.cs("momo.sandbox.createapikey.baseurl","https://sandbox.momodeveloper.mtn.com/v1_0");
			URIBuilder builder = new URIBuilder(baseurl+"/apiuser");
			URI uri = builder.build();
		    HttpPost req = new HttpPost(uri);
		    req.setHeader("X-Reference-Id", apiuser);
		    req.setHeader("Content-Type", "application/json");
		    req.setHeader("Ocp-Apim-Subscription-Key", getCollectionSubscriptionKey());
	
		    // Request body
		    StringEntity reqEntity = new StringEntity("{\"providerCallbackHost\": \""+SH.cs("momo.callbackhost", "cloud.hnrw.org")+"\"}");
		    req.setEntity(reqEntity);
	
		    HttpResponse resp = httpclient.execute(req);
		    HttpEntity entity = resp.getEntity();
		    if (entity != null && resp.getStatusLine().getStatusCode()==201) 
		    {
		    	System.out.println("Created new API User "+apiuser);
		    	MedwanQuery.getInstance().setConfigString("momo.apiuser", apiuser);
		    	return createSandBoxApiKey();
		    }
		    else {
		    	System.out.println("ERROR creating new API User "+apiuser);
		    	System.out.println(resp.getStatusLine().toString());
		    }
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
}
