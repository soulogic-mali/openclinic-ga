package be.openclinic.system;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.*;

public class Encryption {

	private KeyPairGenerator keyGen;
	private KeyPair pair;
	private PrivateKey privateKey;
	private PublicKey publicKey;

	public void createKeys() throws NoSuchAlgorithmException {
		this.keyGen = KeyPairGenerator.getInstance("RSA");
		this.keyGen.initialize(1024);
		this.pair = this.keyGen.generateKeyPair();
		this.privateKey = pair.getPrivate();
		this.publicKey = pair.getPublic();
	}
	
	public static String encryptTextWithPrivateKey(String msg, String key) throws NoSuchAlgorithmException, InvalidKeyException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, InvalidKeySpecException {
		PKCS8EncodedKeySpec  spec = new PKCS8EncodedKeySpec(Base64.decodeBase64(key));
		KeyFactory kf = KeyFactory.getInstance("RSA");
		return encryptTextWithPrivateKey(msg, kf.generatePrivate(spec));
	}
	
	public static String encryptTextWithPrivateKey(String msg, PrivateKey key) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.ENCRYPT_MODE, key);
		return Base64.encodeBase64String(cipher.doFinal(msg.getBytes("UTF-8")));
	}
	
	public static String encryptTextWithPublicKey(String msg, String key) throws NoSuchAlgorithmException, InvalidKeyException, NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, InvalidKeySpecException {
		X509EncodedKeySpec  spec = new X509EncodedKeySpec(Base64.decodeBase64(key));
		KeyFactory kf = KeyFactory.getInstance("RSA");
		return encryptTextWithPublicKey(msg, kf.generatePublic(spec));
	}
	
	public static String encryptTextWithPublicKey(String msg, PublicKey key) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException {
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.ENCRYPT_MODE, key);
		return Base64.encodeBase64String(cipher.doFinal(msg.getBytes("UTF-8")));
	}
	
	public static String decryptTextWithPublicKey(String msg, String key) throws NoSuchAlgorithmException, InvalidKeyException, NoSuchPaddingException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
		X509EncodedKeySpec spec = new X509EncodedKeySpec(Base64.decodeBase64(key));
		KeyFactory kf = KeyFactory.getInstance("RSA");
		return decryptTextWithPublicKey(msg, kf.generatePublic(spec));
	}

	public static String decryptTextWithPublicKey(String msg, PublicKey key) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException {
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.DECRYPT_MODE, key);
		return new String(cipher.doFinal(Base64.decodeBase64(msg)), "UTF-8");
	}

	public static String decryptTextWithPrivateKey(String msg, String key) throws NoSuchAlgorithmException, InvalidKeyException, NoSuchPaddingException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException, InvalidKeySpecException {
		PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(Base64.decodeBase64(key));
		KeyFactory kf = KeyFactory.getInstance("RSA");
		return decryptTextWithPrivateKey(msg, kf.generatePrivate(spec));
	}

	public static String decryptTextWithPrivateKey(String msg, PrivateKey key) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, UnsupportedEncodingException, IllegalBlockSizeException, BadPaddingException {
		Cipher cipher = Cipher.getInstance("RSA");
		cipher.init(Cipher.DECRYPT_MODE, key);
		return new String(cipher.doFinal(Base64.decodeBase64(msg)), "UTF-8");
	}
	
	public static String encryptTextSymmetric(String msg, String password) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
		SecretKeySpec sekretKey = new SecretKeySpec(password.getBytes(), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, sekretKey);
		return Base64.encodeBase64String(cipher.doFinal(msg.getBytes()));
	}

	public static String decryptTextSymmetric(String msg, String password) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
		SecretKeySpec sekretKey = new SecretKeySpec(password.getBytes(), "AES");
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.DECRYPT_MODE, sekretKey);
		return new String(cipher.doFinal(Base64.decodeBase64(msg)));
	}

	public PrivateKey getPrivateKey() {
		return this.privateKey;
	}

	public String getPrivateKeyBase64() {
		return Base64.encodeBase64String(this.privateKey.getEncoded());
	}

	public PublicKey getPublicKey() {
		return this.publicKey;
	}

	public String getPublicKeyBase64() {
		return Base64.encodeBase64String(this.publicKey.getEncoded());
	}
	
	public static String getToken(int nDiv) {
	 	java.security.SecureRandom random = new java.security.SecureRandom();	
	 	long longToken = Math.abs( random.nextLong() );
	    String sRandom = Long.toString( longToken, 16 );
	    while(sRandom.length()<nDiv) {
	    	sRandom+=sRandom;
	    }
	    return sRandom.replaceAll("l","m").replaceAll("1","x").substring(0,nDiv);
	}

	public void writeToFile(String path, byte[] key) throws IOException {
		File f = new File(path);
		f.getParentFile().mkdirs();

		FileOutputStream fos = new FileOutputStream(f);
		fos.write(key);
		fos.flush();
		fos.close();
	}
}