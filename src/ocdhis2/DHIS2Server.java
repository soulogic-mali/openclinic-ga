/**
 * 
 */
package ocdhis2;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.net.ssl.SSLContext;
import javax.ws.rs.client.Client;
import javax.ws.rs.client.ClientBuilder;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.WebTarget;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import javax.xml.bind.JAXBException;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.impl.client.BasicResponseHandler;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.glassfish.jersey.SslConfigurator;
import org.glassfish.jersey.client.ClientProperties;
import org.glassfish.jersey.client.authentication.HttpAuthenticationFeature;

import be.mxs.common.util.db.MedwanQuery;
import be.openclinic.dhis2.Util;
import be.openclinic.system.OCHttpClient;
import be.openclinic.system.SH;

/**
 * @author loic
 * Stores information about the DHIS2 server.
 * One instance of OpenClinic might have to send information to several different
 * DHIS2 servers (national server and vertical programs, backup servers...).
 * The XML definition file will have to define for each dataset which server(s) 
 * has (have) to be contacted.
 */


public class DHIS2Server
{
   
    // Connection information
    
    private String baseURL;                             // ex: "https://dhis.snis.bi"
    private String baseAPI;                             // ex: "api"
    private String port;                                // ex: "80"

    
    // User information.  A specific user should be created on the DHIS2
    // instance for the Health Information System of the health structure.
    
    private String userName;                    // ex: "Hopital_Central_OpenClinic"
    private String userPassword;                // ex: "oJgUE9WuxHoNkt3"
    
    
    // User-friendly name internally given inside OC for this DHIS2 server.
    
    private String serverName;                  // ex: "DHIS2 Burundi"

    
    
    public String getUrl()
    {
        return this.baseURL + ":" + this.port + this.baseAPI;
    }
    
    /**
     * @param baseURL
     * @param baseAPI
     * @param port
     */
    public DHIS2Server(String baseURL, String baseAPI, String port)
    {
        super();
        this.baseURL = baseURL;
        this.baseAPI = baseAPI;
        this.port = port;
    }
    
    public DHIS2Server(){
        super();
        this.baseURL = SH.cs("dhis2_server_uri","");
        this.baseAPI = SH.cs("dhis2_server_api", "");
        this.port = SH.cs("dhis2_server_port","");
        this.userName = SH.cs("dhis2_server_username","");
        this.userPassword = SH.cs("dhis2_server_pwd","");
    }
    
    public String getBaseURL()
    {
        return baseURL;
    }

    public void setBaseURL(String baseURL)
    {
        this.baseURL = baseURL;
    }

    public String getBaseAPI()
    {
        return baseAPI;
    }

    public void setBaseAPI(String baseAPI)
    {
        this.baseAPI = baseAPI;
    }

    public String getPort()
    {
        return port;
    }

    public void setPort(String port)
    {
        this.port = port;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getUserPassword()
    {
        return userPassword;
    }

    public void setUserPassword(String userPassword)
    {
        this.userPassword = userPassword;
    }

    public String getServerName()
    {
        return serverName;
    }

    public void setServerName(String serverName)
    {
        this.serverName = serverName;
    }
    
    public String sendToServer(String query) throws NoSuchAlgorithmException, IOException
    {
    	URL url = new URL(getUrl()+query);
    	URLConnection conn = null;
    	if(SH.cs("proxyServer", "").length()>0) {
    		Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(SH.cs("proxyServer", "").split(":")[0], Integer.parseInt(SH.cs("proxyServer", "").split(":")[1])));
    		conn = url.openConnection(proxy);
    	}
    	else {
    		conn = url.openConnection();
    	}
    	conn.setDoOutput(true);
    	conn.setRequestProperty("Authorization", "Basic "+Base64.getEncoder().encodeToString((getUserName()+":"+getUserPassword()).getBytes()));
    	conn.setRequestProperty("Accept", "application/xml");
        return IOUtils.toString(conn.getInputStream(), StandardCharsets.UTF_8);
     
    	/*
    	//Make sure we've got all the certificates on board
    	String host = baseURL.replaceAll("https://", "").replaceAll("http://", "").split(":")[0].split("/")[0];
    	Client client = ClientBuilder.newBuilder().build();
    	if(baseURL.startsWith("https")) {
	    	try {
				Util.importCertificate(host, Integer.parseInt(port), MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"), MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
			} catch (Exception e) {
				e.printStackTrace();
			}
	     
	        // preparing the SSL connection
	        SslConfigurator sslConfig = SslConfigurator.newInstance();
	        sslConfig.trustStoreFile(MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"));
	        sslConfig.trustStorePassword(MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
	        sslConfig.keyStoreFile(MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"));
	        sslConfig.keyPassword(MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
	     
	        SSLContext sslContext = sslConfig.createSSLContext();
	        client = ClientBuilder.newBuilder().sslContext(sslContext).build();
    	}
        client.property(ClientProperties.CONNECT_TIMEOUT, 10000);
        client.property(ClientProperties.READ_TIMEOUT, 60000);
    	if(SH.cs("proxyServer", "").length()>0) {
            client.property(ClientProperties.PROXY_URI, SH.cs("proxyServer", ""));
    	}
        // authentication
        HttpAuthenticationFeature feature = HttpAuthenticationFeature.basic(this.getUserName(), this.getUserPassword());
        client.register(feature);
        String querybase = query.split("\\?")[0];
        WebTarget target = client.target(this.getUrl()).path(querybase);
        if(query.split("\\?").length>0) {
        	for(int i=0;i<query.split("\\?")[1].split("\\&").length;i++) {
        		target = target.queryParam(query.split("\\?")[1].split("\\&")[i].split("=")[0], query.split("\\?")[1].split("\\&")[i].split("=")[1]);
        	}
        }
        System.out.println("URL="+this.getUrl()+query);  // to check where it was sent
        
        // see stackoverflow.com/questions/27284046/

        Response getResponse = target.request(MediaType.APPLICATION_XML).get();
        
        return getResponse;
        */
    }
    
    public Document getXml(String query) throws DocumentException, IOException, NoSuchAlgorithmException {
		String response = sendToServer(query.replaceAll("\\[", "%5B").replaceAll("\\]", "%5D"));
    	Document document = DocumentHelper.parseText(response);
    	return document;
    }
    
    
    // Send data to the server, and obtain a Response from the server.
    // If the server gave a useful payload in its response (not a 404 or 500 case for example),
    // then the Response.Entity is processed and deserialized into an ImportSummary, 
    // which matches the type of answers from the DHIS2 server.
    public String sendToServer(DataValueSet dataValueSet) throws NoSuchAlgorithmException, JAXBException, ClientProtocolException, IOException
    {
    	URL url = new URL(getUrl()+"/dataValueSets");
    	URLConnection conn = null;
    	if(SH.cs("proxyServer", "").length()>0) {
    		Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(SH.cs("proxyServer", "").split(":")[0], Integer.parseInt(SH.cs("proxyServer", "").split(":")[1])));
    		conn = url.openConnection(proxy);
    	}
    	else {
    		conn = url.openConnection();;
    	}
    	conn.setDoOutput(true);
    	conn.setRequestProperty("Authorization", "Basic "+Base64.getEncoder().encodeToString((getUserName()+":"+getUserPassword()).getBytes()));
    	conn.setRequestProperty("Content-Type", "application/xml");
    	OutputStreamWriter writer = new OutputStreamWriter(conn.getOutputStream());
    	writer.write(dataValueSet.toXMLString());
    	writer.flush();
        return IOUtils.toString(conn.getInputStream(), StandardCharsets.UTF_8);
    	
    	/*
    	//Make sure we've got all the certificates on board
    	String host = baseURL.replaceAll("https://", "").replaceAll("http://", "").split(":")[0].split("/")[0];
    	Client client = ClientBuilder.newBuilder().build();
    	if(baseURL.startsWith("https")) {
	    	try {
				Util.importCertificate(host, Integer.parseInt(port), MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"), MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
			} catch (Exception e) {
				e.printStackTrace();
			}
	     
	        // preparing the SSL connection
	        SslConfigurator sslConfig = SslConfigurator.newInstance();
	        sslConfig.trustStoreFile(MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"));
	        sslConfig.trustStorePassword(MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
	        sslConfig.keyStoreFile(MedwanQuery.getInstance().getConfigString("dhis2_truststore","/temp/keystore"));
	        sslConfig.keyPassword(MedwanQuery.getInstance().getConfigString("dhis2_truststore_pass","changeme"));
	     
	        SSLContext sslContext = sslConfig.createSSLContext();
	        client = ClientBuilder.newBuilder().sslContext(sslContext).build();
    	}
        client.property(ClientProperties.CONNECT_TIMEOUT, 10000);
        client.property(ClientProperties.READ_TIMEOUT, 60000);
        
        // authentication
        // see jersey.java.net/apidocs/2.17/jersey/org/glassfish/jersey/client/authentication/HttpAuthenticationFeature.html
        HttpAuthenticationFeature feature = HttpAuthenticationFeature.basic(this.getUserName(), this.getUserPassword());
        client.register(feature);
        
        WebTarget target = client.target(this.getUrl()).path("dataValueSets");
        System.out.println("URL="+this.getUrl());  // to check where it was sent
        
        // see stackoverflow.com/questions/27284046/

        Response postResponse = target.request(MediaType.APPLICATION_XML).post(Entity.xml(dataValueSet));
        */
    }
    
}
