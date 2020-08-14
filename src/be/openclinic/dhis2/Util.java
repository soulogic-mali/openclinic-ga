package be.openclinic.dhis2;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.security.KeyStore;
import java.security.MessageDigest;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateExpiredException;
import java.security.cert.X509Certificate;
import java.util.Enumeration;

import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLException;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.X509TrustManager;

import com.itextpdf.text.pdf.codec.Base64.OutputStream;

import be.mxs.common.util.system.Debug;

public class Util {
	/*
	 * Copyright 2006 Sun Microsystems, Inc.  All Rights Reserved.
	 *
	 * Redistribution and use in source and binary forms, with or without
	 * modification, are permitted provided that the following conditions
	 * are met:
	 *
	 *   - Redistributions of source code must retain the above copyright
	 *     notice, this list of conditions and the following disclaimer.
	 *
	 *   - Redistributions in binary form must reproduce the above copyright
	 *     notice, this list of conditions and the following disclaimer in the
	 *     documentation and/or other materials provided with the distribution.
	 *
	 *   - Neither the name of Sun Microsystems nor the names of its
	 *     contributors may be used to endorse or promote products derived
	 *     from this software without specific prior written permission.
	 *
	 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
	 * IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
	 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
	 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
	 */

    public static void importCertificate(String host, int port, String keystore, String password) throws Exception {
	  char[] passphrase = password.toCharArray();

	  File file = new File(keystore);
	  System.out.println("Loading KeyStore " + file + "...");
	  InputStream in = new FileInputStream(file);
	  KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
	  ks.load(in, passphrase);
	  in.close();

	  SSLContext context = SSLContext.getInstance("TLS");
	  TrustManagerFactory tmf =
	      TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());
	  tmf.init(ks);
	  X509TrustManager defaultTrustManager = (X509TrustManager)tmf.getTrustManagers()[0];
	  SavingTrustManager tm = new SavingTrustManager(defaultTrustManager);
	  context.init(null, new TrustManager[] {tm}, null);
	  SSLSocketFactory factory = context.getSocketFactory();

	  System.out.println("Opening connection to " + host + ":" + port + "...");
	  SSLSocket socket = (SSLSocket)factory.createSocket(host, port);
	  socket.setSoTimeout(10000);
	  try {
		  System.out.println("Starting SSL handshake...");
	      socket.startHandshake();
	      socket.close();
	      System.out.println("");
	      System.out.println("No errors, certificate is already trusted");
	  } catch (SSLException e) {
		  System.out.println("");
	      //e.printStackTrace(Debug);
	  }

	  X509Certificate[] chain = tm.chain;
	  if (chain == null) {
		  System.out.println("Could not obtain server certificate chain");
	      return;
	  }

	  BufferedReader reader =
	    new BufferedReader(new InputStreamReader(System.in));

	  System.out.println("");
	  System.out.println("Server sent " + chain.length + " certificate(s):");
	  System.out.println("");
	  MessageDigest sha1 = MessageDigest.getInstance("SHA1");
	  MessageDigest md5 = MessageDigest.getInstance("MD5");
	  for (int i = 0; i < chain.length; i++) {
	      X509Certificate cert = chain[i];
	      System.out.println
	        (" " + (i + 1) + " Subject " + cert.getSubjectDN());
	      System.out.println("   Issuer  " + cert.getIssuerDN());
	      sha1.update(cert.getEncoded());
	      System.out.println("   sha1    " + toHexString(sha1.digest()));
	      md5.update(cert.getEncoded());
	      System.out.println("   md5     " + toHexString(md5.digest()));
	      System.out.println("");
		  String alias = host + "-" + (i + 1);
		  //Check if this certificate already exists
		  boolean bExists = false;
		  Enumeration aliases = ks.aliases();
		  while(aliases.hasMoreElements()){
			  String activealias = (String)aliases.nextElement();
			  Certificate existingCert = ks.getCertificate(activealias);
			  if(existingCert instanceof X509Certificate){
				  if(existingCert!=null && existingCert.getPublicKey().equals(cert.getPublicKey())){
					  //The certificate already exists
					  if(((X509Certificate)existingCert).getNotAfter().before(cert.getNotAfter())){
						  //The existing certificate is older, delete it
						  ks.deleteEntry(activealias);
					  }
					  else{
						  //The existing certificate is more recent or equal, keep it
						  System.out.println("Certificate with public key "+existingCert.getPublicKey()+" already exists in "+keystore);
						  bExists=true;
					  }
				  }
			  }
		  }
		  if(!bExists){
			  if(ks.containsAlias(alias)){
				  ks.deleteEntry(alias);
			  }
			  ks.setCertificateEntry(alias, cert);
			  FileOutputStream out = new FileOutputStream(keystore);
			  ks.store(out, passphrase);
			  out.close();
			  System.out.println("");
			  System.out.println(cert+"");
			  System.out.println("");
			  System.out.println
			    ("Added certificate to keystore "+keystore+" using alias '"
			    + alias + "'");
		  }
	  }

    }

	    private static final char[] HEXDIGITS = "0123456789abcdef".toCharArray();

	    private static String toHexString(byte[] bytes) {
	  StringBuilder sb = new StringBuilder(bytes.length * 3);
	  for (int b : bytes) {
	      b &= 0xff;
	      sb.append(HEXDIGITS[b >> 4]);
	      sb.append(HEXDIGITS[b & 15]);
	      sb.append(' ');
	  }
	  return sb.toString();
	    }

	    private static class SavingTrustManager implements X509TrustManager {

	  private final X509TrustManager tm;
	  private X509Certificate[] chain;

	  SavingTrustManager(X509TrustManager tm) {
	      this.tm = tm;
	  }

	  public X509Certificate[] getAcceptedIssuers() {
	      throw new UnsupportedOperationException();
	  }

	  public void checkClientTrusted(X509Certificate[] chain, String authType)
	    throws CertificateException {
	      throw new UnsupportedOperationException();
	  }

	  public void checkServerTrusted(X509Certificate[] chain, String authType)
	    throws CertificateException {
	      this.chain = chain;
	      tm.checkServerTrusted(chain, authType);
	  }

	} 
}
