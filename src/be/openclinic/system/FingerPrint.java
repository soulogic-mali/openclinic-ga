package be.openclinic.system;

import java.awt.Transparency;
import java.awt.color.ColorSpace;
import java.awt.image.*;


import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

import SecuGen.FDxSDKPro.jni.*;

public class FingerPrint {
	JSGFPLib sgfplib;
	String callId,url;
	long port=SGPPPortAddr.AUTO_DETECT;
	
	public static void main(String[] args) {
		FingerPrint fingerPrint = new FingerPrint();
		if(args.length>0){
			System.out.println("Command = "+args[0]);
			if(args[0].equalsIgnoreCase("checkReady")){
				if(args.length>2){
					fingerPrint.url = args[1];
					fingerPrint.callId = args[2];
					if(args.length>3){
						fingerPrint.port=Long.parseLong(args[3]);
					}
					fingerPrint.checkReady();
				}
				else{
					System.out.println("Syntax: FingerPrint checkReady <url> <call id>");
				}
			}
			else if(args[0].equalsIgnoreCase("getFingerPrint")){
				if(args.length>2){
					fingerPrint.url = args[1];
					fingerPrint.callId = args[2];
					System.out.println("url = "+fingerPrint.url);
					System.out.println("callId = "+fingerPrint.callId);
					if(args.length>3){
						fingerPrint.port=Long.parseLong(args[3]);
					}
					fingerPrint.getFingerPrint();
				}
				else{
					System.out.println("Syntax: FingerPrint checkReady <url> <call id>");
				}
			}
		}
	}
	
	public void getFingerPrint(){
		try{
			if(isReady()){
				Element eFingerPrint = DocumentHelper.createElement("fingerprint");
				eFingerPrint.addAttribute("command", "getFingerPrint");
				setLedOn(true);
				eFingerPrint.add(read());
				setLedOn(false);
			    CloseableHttpClient client = HttpClients.createDefault();
			    HttpPost httpPost = new HttpPost(url);
			    MultipartEntityBuilder builder = MultipartEntityBuilder.create();
			    builder.addTextBody("data", eFingerPrint.asXML(), ContentType.TEXT_PLAIN);
			    HttpEntity multipart = builder.build();
			    httpPost.setEntity(multipart);
				try {
					System.out.println("posting: "+url);
				    CloseableHttpResponse response = client.execute(httpPost);
					System.out.println("checkReady status code: "+response.getStatusLine().getStatusCode());
					System.out.println("checkReady response: "+response.getStatusLine().getReasonPhrase());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			closeLib();
		}
	}
	
    public static BufferedImage toImage(byte[] data, int w, int h) {
        DataBuffer buffer = new DataBufferByte(data, data.length);
        WritableRaster raster = Raster.createInterleavedRaster(buffer,
            w, h, w, 1, new int[]{0}, null);
        ColorSpace cs = ColorSpace.getInstance(ColorSpace.CS_GRAY);
        ColorModel cm = new ComponentColorModel(cs, false, true,Transparency.OPAQUE, DataBuffer.TYPE_BYTE);
        return new BufferedImage(cm, raster, false, null);
    }

	public Element read(){
		Element eFingerPrintInfo = DocumentHelper.createElement("fingerPrintInfo");
		eFingerPrintInfo.addAttribute("callId", callId);
        SGDeviceInfoParam deviceInfo = new SGDeviceInfoParam();
        sgfplib.GetDeviceInfo(deviceInfo);
        byte[] imageBuffer = new byte[deviceInfo.imageHeight*deviceInfo.imageWidth];
        System.out.println("Call GetImage()");
        long err = sgfplib.GetImageEx(imageBuffer,10000,0,50);
    	if(err == SGFDxErrorCode.SGFDX_ERROR_NONE){
    		System.out.println("Fingerprint captured");
            int[] quality = new int[1];
            int[] maxSize = new int[1];
            int[] size = new int[1];
            
            SGFingerInfo fingerInfo = new SGFingerInfo();
            fingerInfo.FingerNumber = SGFingerPosition.SG_FINGPOS_LI;
            fingerInfo.ImageQuality = quality[0];
            fingerInfo.ImpressionType = SGImpressionType.SG_IMPTYPE_LP;
            fingerInfo.ViewNumber = 1;
            ///////////////////////////////////////////////
            // Set Template format ISO19794
            System.out.println("Call SetTemplateFormat(ISO19794)");
            err = sgfplib.SetTemplateFormat(SGFDxTemplateFormat.TEMPLATE_FORMAT_ISO19794);
            System.out.println("SetTemplateFormat returned : [" + err + "]");

            ///////////////////////////////////////////////
            // Get Max Template Size for ISO19794
            System.out.println("Call GetMaxTemplateSize()");
            err = sgfplib.GetMaxTemplateSize(maxSize);
            System.out.println("GetMaxTemplateSize returned : [" + err + "]");
            System.out.println("Max ISO19794 Template Size is : [" + maxSize[0] + "]");

            ///////////////////////////////////////////////
            // Create ISO19794 Template for Finger1
            byte[] ISOminutiaeBuffer = new byte[maxSize[0]];
            System.out.println("Call CreateTemplate()");
            err = sgfplib.CreateTemplate(fingerInfo, imageBuffer, ISOminutiaeBuffer);
            System.out.println("CreateTemplate returned : [" + err + "]");
            err = sgfplib.GetTemplateSize(ISOminutiaeBuffer, size);
            System.out.println("GetTemplateSize returned : [" + err + "]");
            System.out.println("ISO19794 Template Size is : [" + size[0] + "]");

            eFingerPrintInfo.addElement("iso").setText(org.apache.commons.codec.binary.Base64.encodeBase64String(ISOminutiaeBuffer));
            eFingerPrintInfo.addElement("raw").setText(org.apache.commons.codec.binary.Base64.encodeBase64String(imageBuffer));
            eFingerPrintInfo.addElement("width").setText(deviceInfo.imageWidth+"");
            eFingerPrintInfo.addElement("height").setText(deviceInfo.imageHeight+"");
                        
    	}
    	else{
            eFingerPrintInfo.addElement("iso").setText("0");
    	}
        System.out.println("Error = "+err);

		return eFingerPrintInfo;
	}
	
	public int matchISO(byte[] ISOminutiaeBuffer1, byte[] ISOminutiaeBuffer2){
        int[] score = new int[1];
        int[] maxSize = new int[1];
        int[] size = new int[1];
        boolean[] matched = new boolean[1];
		System.out.println("Performing ISO match");
        ///////////////////////////////////////////////
        // Set Template format ISO19794
        System.out.println("Call SetTemplateFormat(ISO19794)");
        long err = sgfplib.SetTemplateFormat(SGFDxTemplateFormat.TEMPLATE_FORMAT_ISO19794);
        System.out.println("SetTemplateFormat returned : [" + err + "]");

        ///////////////////////////////////////////////
        // Get Max Template Size for ISO19794
        System.out.println("Call GetMaxTemplateSize()");
        err = sgfplib.GetMaxTemplateSize(maxSize);
        System.out.println("GetMaxTemplateSize returned : [" + err + "]");
        System.out.println("Max ISO19794 Template Size is : [" + maxSize[0] + "]");

        System.out.println("Call MatchIsoTemplates()");
        err = sgfplib.MatchIsoTemplate(ISOminutiaeBuffer1, 0, ISOminutiaeBuffer2, 0, SGFDxSecurityLevel.SL_NORMAL, matched);
        System.out.println("MatchISOTemplates returned : [" + err + "]");
        System.out.println("ISO-1 <> ISO-2 Match Result : [" + matched[0] + "]");
        System.out.println("Call GetIsoMatchingScore()");
        err = sgfplib.GetIsoMatchingScore(ISOminutiaeBuffer1, 0, ISOminutiaeBuffer2, 0, score);
        System.out.println("GetIsoMatchingScore returned : [" + err + "]");
        System.out.println("ISO-1  <> ISO-2 Match Score : [" + score[0] + "]");

		return score[0];
	}
	
	public void checkReady(){
		try{
			if(isReady()){
				Element eFingerPrint = DocumentHelper.createElement("fingerprint");
				eFingerPrint.addAttribute("command", "checkReady");
				eFingerPrint.add(getDeviceInfo());
			    CloseableHttpClient client = HttpClients.createDefault();
			    HttpPost httpPost = new HttpPost(url);
			    MultipartEntityBuilder builder = MultipartEntityBuilder.create();
			    builder.addTextBody("data", eFingerPrint.asXML(), ContentType.TEXT_PLAIN);
			    HttpEntity multipart = builder.build();
			    httpPost.setEntity(multipart);

				try {
					System.out.println("posting: "+url);
				    CloseableHttpResponse response = client.execute(httpPost);
					System.out.println("checkReady status code: "+response.getStatusLine().getStatusCode());
					System.out.println("checkReady response: "+response.getStatusLine().getReasonPhrase());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			closeLib();
		}
	}
	
	public boolean initLib(){
        System.out.println("Instantiate JSGFPLib Object");
		sgfplib = new JSGFPLib();
        if ((sgfplib != null) && (sgfplib.jniLoadStatus != SGFDxErrorCode.SGFDX_ERROR_JNI_DLLLOAD_FAILED))
        {
        	System.out.println("jniLoadStatus="+sgfplib.jniLoadStatus);
            System.out.println(sgfplib);
            return true;
        }
        else
        {
            System.out.println("An error occurred while loading JSGFPLIB.DLL JNI Wrapper");
            return false;
        }
	}
	
	public boolean initDevice(){
        System.out.println("Call Init(SGFDxDeviceName.SG_DEV_AUTO)");
        long err = sgfplib.Init(SGFDxDeviceName.SG_DEV_AUTO);
        System.out.println("Init returned : [" + err + "]");
        if(err == SGFDxErrorCode.SGFDX_ERROR_NONE){
        	return true;
        }
        else{
        	return false;
        }
	}
	
	public boolean openDevice(){
        System.out.println("Call OpenDevice("+port+")");
        long err = sgfplib.OpenDevice(port);
        System.out.println("OpenDevice returned : [" + err + "]");
        if(err == SGFDxErrorCode.SGFDX_ERROR_NONE){
        	return true;
        }
        else{
        	for(int n=0;n<5;n++){
                err = sgfplib.OpenDevice(n);
                System.out.println("OpenDevice returned : [" + err + "]");
                if(err == SGFDxErrorCode.SGFDX_ERROR_NONE){
                	port=n;
                	return true;
                }
        	}
        	return false;
        }
	}
	
	public boolean isReady(){
		if(initLib() && initDevice() && openDevice()){
			return true;
		}
		else{
			return false;
		}
	}

	public Element getDeviceInfo(){
		Element eDeviceInfo = DocumentHelper.createElement("deviceInfo");
		eDeviceInfo.addAttribute("callId", callId);
        System.out.println("Call GetDeviceInfo()");
        SGDeviceInfoParam deviceInfo = new SGDeviceInfoParam();
        long err = sgfplib.GetDeviceInfo(deviceInfo);
        if(err == SGFDxErrorCode.SGFDX_ERROR_NONE){
        	eDeviceInfo.addElement("DeviceSN").setText(new String(deviceInfo.deviceSN()).trim());
        	eDeviceInfo.addElement("ComPort").setText(deviceInfo.comPort+"");
        	eDeviceInfo.addElement("ComSpeed").setText(deviceInfo.comSpeed+"");
        	eDeviceInfo.addElement("DeviceID").setText(deviceInfo.deviceID+"");
        	eDeviceInfo.addElement("FWVersion").setText(deviceInfo.FWVersion+"");
        }
        else{
        	eDeviceInfo.addElement("Error").setText(err+"");
        }
        return eDeviceInfo;
	}
	
	public void setLedOn(boolean bOn){
        long err = sgfplib.SetLedOn(bOn);
        System.out.println("SetLedOn returned : [" + err + "]");
	}
	
	public void closeLib(){
		sgfplib.CloseDevice();
        System.out.println("Closing JSGFPLib");
		long err = sgfplib.Close();
        System.out.println("Close returned : [" + err + "]");
	}

}
