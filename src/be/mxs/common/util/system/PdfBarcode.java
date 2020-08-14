package be.mxs.common.util.system;

import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.awt.image.BufferedImageOp;
import java.awt.image.DataBuffer;
import java.awt.image.DataBufferByte;
import java.awt.image.Kernel;
import java.awt.image.Raster;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.EnumSet;
import java.util.Hashtable;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

import be.mxs.common.util.db.MedwanQuery;
import be.mxs.common.util.io.BlobDemo;
import be.mxs.common.util.io.BlobFinder;
import be.mxs.common.util.io.BlobDemo.Coordinates;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.DecodeHintType;
import com.google.zxing.EncodeHintType;
import com.google.zxing.LuminanceSource;
import com.google.zxing.MultiFormatReader;
import com.google.zxing.Result;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.BufferedImageLuminanceSource;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.common.HybridBinarizer;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import com.itextpdf.text.BadElementException;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.Barcode39;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfWriter;

public class PdfBarcode {

    private static BufferedImage resize(BufferedImage img, int height, int width) {
        java.awt.Image tmp = img.getScaledInstance(width, height, java.awt.Image.SCALE_SMOOTH);
        BufferedImage resized = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
        Graphics2D g2d = resized.createGraphics();
        g2d.drawImage(tmp, 0, 0, null);
        g2d.dispose();
        return resized;
    }

    public static String decode(BufferedImage image, Map<DecodeHintType, Object> hints) throws Exception {
		if (image == null)
	        throw new IllegalArgumentException("Could not decode image.");
	    LuminanceSource source = new BufferedImageLuminanceSource(image);
	    BinaryBitmap bitmap = new BinaryBitmap(new HybridBinarizer(source));
	    MultiFormatReader barcodeReader = new MultiFormatReader();
	    Result result;
	    String finalResult="";
	    try {
	        if (hints != null && ! hints.isEmpty())
	            result = barcodeReader.decode(bitmap, hints);
	        else
	            result = barcodeReader.decode(bitmap);
	        // setting results.
	        finalResult = String.valueOf(result.getText());
	    } catch (Exception e) {
	    }
	    return finalResult;
	}
    
    public static String downscaleTest(BufferedImage img, Hashtable hints) throws Exception{
    	String sBarcode="";
	    for(int n=10;n<100;n+=10){
		    sBarcode=decode(resize(img, img.getHeight()*n/100, img.getWidth()*n/100),hints);
		    if(sBarcode.length()==11){
				break;		    	
		    }
	    }
    	return sBarcode;
    }

    public static String rotationTest(BufferedImage img, Hashtable hints) throws Exception{
    	String sBarcode="";
    	for(double d=-1;d<1;d+=0.1){
		    AffineTransform tx = new AffineTransform();
	        tx.rotate(d, img.getWidth() / 2, img.getHeight() / 2);

	        AffineTransformOp op = new AffineTransformOp(tx,
	            AffineTransformOp.TYPE_BILINEAR);
	        BufferedImage rotatedImage = op.filter(img, null);
	        sBarcode=decode(rotatedImage,hints);
		    if(sBarcode.length()==11){
				break;		    	
		    }
    	}
    	return sBarcode;
    }
    
    public static String blurTest(BufferedImage img, Hashtable hints) throws Exception{
    	float[] matrix = {
    	        0.111f, 0.111f, 0.111f, 
    	        0.111f, 0.111f, 0.111f, 
    	        0.111f, 0.111f, 0.111f, 
    	    };

	    BufferedImageOp op = new java.awt.image.ConvolveOp( new Kernel(3, 3, matrix) );
		BufferedImage blurredImage = op.filter(img, null);    	
		return decode(blurredImage,hints);
    }
    
    public static String rotationAndDownscaleTest(BufferedImage img, Hashtable hints) throws Exception{
    	String sBarcode="";
    	for(double d=-1;d<1;d+=0.1){
		    AffineTransform tx = new AffineTransform();
	        tx.rotate(d, img.getWidth() / 2, img.getHeight() / 2);

	        AffineTransformOp op = new AffineTransformOp(tx,
	            AffineTransformOp.TYPE_BILINEAR);
	        BufferedImage rotatedImage = op.filter(img, null);
	    	float[] matrix = {
	    	        0.111f, 0.111f, 0.111f, 
	    	        0.111f, 0.111f, 0.111f, 
	    	        0.111f, 0.111f, 0.111f, 
	    	    };

		    BufferedImageOp op2 = new java.awt.image.ConvolveOp( new Kernel(3, 3, matrix) );
			BufferedImage blurredImage = op2.filter(rotatedImage, null);    	
	        sBarcode=downscaleTest(blurredImage,hints);
		    if(sBarcode.length()==11){
				break;		    	
		    }
    	}
    	return sBarcode;
    }
    
    public static String rotationAndDownscaleAndBlurTest(BufferedImage img, Hashtable hints) throws Exception{
    	String sBarcode="";
    	for(double d=-1;d<1;d+=0.1){
		    AffineTransform tx = new AffineTransform();
	        tx.rotate(d, img.getWidth() / 2, img.getHeight() / 2);

	        AffineTransformOp op = new AffineTransformOp(tx,
	            AffineTransformOp.TYPE_BILINEAR);
	        BufferedImage rotatedImage = op.filter(img, null);
	        sBarcode=downscaleTest(rotatedImage,hints);
		    if(sBarcode.length()==11){
				break;		    	
		    }
    	}
    	return sBarcode;
    }
    
	public static String getBarcodeFromDocument(File file){
		String barcode="";
		try{
			System.setProperty("org.apache.pdfbox.baseParser.pushBackSize", "10000000");
			PDDocument document = PDDocument.loadNonSeq(file, null);
			java.util.List<PDPage> pdPages = document.getDocumentCatalog().getAllPages();
			int mypage = 0;
			for (PDPage pdPage : pdPages)
			{ 
			    ++mypage;
		    	boolean bExit=false;
			    Debug.println("Analyzing page "+mypage);
			    BufferedImage bim = pdPage.convertToImage(BufferedImage.TYPE_BYTE_GRAY, 150);
			    Hashtable<DecodeHintType, Object> hints = new Hashtable<DecodeHintType, Object>();
			    //hints.put(DecodeHintType.TRY_HARDER, Boolean.TRUE);

			    barcode=decode(bim,hints);
			    if(barcode.length()==11){
			    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
					break;		    	
			    }
			    else {
			    	if(mypage==1){
			    		//Trying a lot harder on the first page
			    		//If using a frontpage with only 1 barcode, try to isolate it

			    		//Coordinates coordinates = getBlobZones("c:/tmp/image"+mypage+".jpg");
			    		Coordinates coordinates = getBlobZones(convertToARGB(bim));
			    		int x = new Long(Math.max(0, coordinates.x-bim.getWidth()/4)).intValue();
			    		int y = new Long(Math.max(0, coordinates.y-bim.getHeight()/8)).intValue();
			    		int w= Math.min(bim.getWidth()/2,bim.getWidth()-x);
			    		int h=Math.min(bim.getHeight()/4,bim.getHeight()-y);
			    		BufferedImage extractedImage = bim.getSubimage(x, y , w, h);
			    		Debug.println("Trying blurring...");
					    barcode=blurTest(extractedImage,hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    //Try downscaling
					    Debug.println("Trying downscaling...");
					    //Try downscaling
					    barcode=downscaleTest(extractedImage,hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying rotating...");
					    //Try rotating
					    barcode=rotationTest(extractedImage,hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying downscaling + rotating...");
					    //Try downscaling + rotating
					    barcode=rotationAndDownscaleTest(extractedImage, hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying downscaling + rotating + blurring...");
					    //Try downscaling + rotating
					    barcode=rotationAndDownscaleAndBlurTest(extractedImage, hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    //Analyze the whole page now, maybe we misidentified the barcode location
					    Debug.println("Trying downscaling full page...");
					    //Try downscaling
					    barcode=downscaleTest(bim,hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying rotating full page...");
					    //Try rotating
					    barcode=rotationTest(bim,hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying downscaling + rotating full page...");
					    //Try downscaling + rotating
					    barcode=rotationAndDownscaleTest(bim, hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
					    Debug.println("Trying downscaling + rotating + blurringfull page...");
					    //Try downscaling + rotating
					    barcode=rotationAndDownscaleAndBlurTest(bim, hints);
					    if(barcode.length()==11){
					    	Debug.println("Found barcode value "+barcode+" on page "+mypage+" (stage 1)");
							break;		    	
					    }
			    	}
			    }
			    if(bExit) break;
			}
			document.close();
		}
		catch(Exception e){
			Debug.println(e.getMessage());
		}
		return barcode;
	}

	public static Image getBarcode(String text, PdfWriter docWriter){
        if(MedwanQuery.getInstance().getConfigString("preferredBarcodeType","Code39").equalsIgnoreCase("QRCode")){
        	return getQRCode(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredQRCodeSize", 60));
        }
        else {
        	return getCode39(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredCode39TextSize", 8),MedwanQuery.getInstance().getConfigInt("preferredCode39Baseline", 10),MedwanQuery.getInstance().getConfigInt("preferredCode39Height", 20));
        }
	}
	
	public static Image getBarcode(String text, String alttext, PdfWriter docWriter){
        if(MedwanQuery.getInstance().getConfigString("preferredBarcodeType","Code39").equalsIgnoreCase("QRCode")){
        	return getQRCode(text, docWriter,MedwanQuery.getInstance().getConfigInt("preferredQRCodeSize", 60));
        }
        else {
        	return getCode39(text, alttext, docWriter,MedwanQuery.getInstance().getConfigInt("preferredCode39TextSize", 8),MedwanQuery.getInstance().getConfigInt("preferredCode39Baseline", 10),MedwanQuery.getInstance().getConfigInt("preferredCode39Height", 20));
        }
	}
	
	public static Image getCode39(String text, PdfWriter docWriter,int size, int baseline, int barheight){
        PdfContentByte cb = docWriter.getDirectContent();
        Barcode39 barcode39 = new Barcode39();
        barcode39.setCode(text);
        barcode39.setSize(size);
        barcode39.setBaseline(baseline);
        barcode39.setBarHeight(barheight);
        return barcode39.createImageWithBarcode(cb,null,null);
	}
	
	public static Image getQRCode(String text, PdfWriter docWriter,int size){
        Image image=null;
        try {
        	ErrorCorrectionLevel errorcorrection = ErrorCorrectionLevel.H;
        	if(MedwanQuery.getInstance().getConfigString("qrCodeErrorCorrectionLevel","H").equalsIgnoreCase("M")){
            	errorcorrection = ErrorCorrectionLevel.M;
        	}
        	else if(MedwanQuery.getInstance().getConfigString("qrCodeErrorCorrectionLevel","Q").equalsIgnoreCase("M")){
            	errorcorrection = ErrorCorrectionLevel.Q;
        	}
        	else if(MedwanQuery.getInstance().getConfigString("qrCodeErrorCorrectionLevel","L").equalsIgnoreCase("M")){
            	errorcorrection = ErrorCorrectionLevel.L;
        	}
            PdfContentByte cb = docWriter.getDirectContent();
            Hashtable<EncodeHintType, ErrorCorrectionLevel> hintMap = new Hashtable<EncodeHintType, ErrorCorrectionLevel>();
            hintMap.put(EncodeHintType.ERROR_CORRECTION, errorcorrection);
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix byteMatrix = qrCodeWriter.encode(text,BarcodeFormat.QR_CODE, size, size, hintMap);
            int CrunchifyWidth = byteMatrix.getWidth();
            BufferedImage bimage = new BufferedImage(CrunchifyWidth, CrunchifyWidth,
                    BufferedImage.TYPE_INT_RGB);
            bimage.createGraphics();
 
            Graphics2D graphics = (Graphics2D) bimage.getGraphics();
            graphics.setColor(Color.WHITE);
            graphics.fillRect(0, 0, CrunchifyWidth, CrunchifyWidth);
            graphics.setColor(Color.BLACK);
 
            for (int i = 0; i < CrunchifyWidth; i++) {
                for (int j = 0; j < CrunchifyWidth; j++) {
                    if (byteMatrix.get(i, j)) {
                        graphics.fillRect(i, j, 1, 1);
                    }
                }
            }
            image=Image.getInstance(cb, bimage, 1);
        } catch (Exception e) {
            e.printStackTrace();
		}
        return image;
	}
	
	public static Image getCode39(String text, String alttext, PdfWriter docWriter,int size, int baseline, int barheight){
        PdfContentByte cb = docWriter.getDirectContent();
        Barcode39 barcode39 = new Barcode39();
        barcode39.setCode(text);
        barcode39.setSize(size);
        barcode39.setBaseline(baseline);
        barcode39.setBarHeight(barheight);
        barcode39.setAltText(alttext);
        return barcode39.createImageWithBarcode(cb,null,null);
	}
	
	public static Coordinates getBlobZones(String filename)
	{
		// Load Source image
		BufferedImage srcImage = null;

		try
		{
			File imgFile = new File(filename);
			srcImage = javax.imageio.ImageIO.read(imgFile);
		}
		catch (IOException ioE)
		{
			System.err.println(ioE);
			return null;
		}

		return getBlobZones(srcImage);
	}
	public static class Coordinates{
		public long x=0,y=0;
	}
	public static Coordinates getBlobZones(BufferedImage srcImage)
	{
		int width = srcImage.getWidth();
		int height = srcImage.getHeight();

		// Get raw image data
		Raster raster = srcImage.getData();
		DataBuffer buffer = raster.getDataBuffer();

		int type = buffer.getDataType();
		if (type != DataBuffer.TYPE_BYTE)
		{
			System.err.println("Wrong image data type (datatype="+buffer.getDataType()+")");
			return null;
		}
		if (buffer.getNumBanks() != 1)
		{
			System.err.println("Wrong image data type (numbanks="+buffer.getNumBanks()+")");
			return null;
		}

		DataBufferByte byteBuffer = (DataBufferByte) buffer;
		byte[] srcData = byteBuffer.getData(0);

		// Sanity check image
		if (width * height * 3 != srcData.length) {
			System.err.println("Unexpected image data size. Should be RGB image");
			return null;
		}

		// Create Monochrome version - using basic threshold technique
		byte[] monoData = new byte[width * height];
		int srcPtr = 0;
		int monoPtr = 0;

		while (srcPtr < srcData.length)
		{
			int val = ((srcData[srcPtr]&0xFF) + (srcData[srcPtr+1]&0xFF) + (srcData[srcPtr+2]&0xFF)) / 3;
			monoData[monoPtr] = (val > 128) ? (byte) 0xFF : 0;

			srcPtr += 3;
			monoPtr += 1;
		}

		byte[] dstData = new byte[srcData.length];

		// Create Blob Finder
		BlobFinder finder = new BlobFinder(width, height);

		ArrayList<BlobFinder.Blob> blobList = new ArrayList<BlobFinder.Blob>();
		finder.detectBlobs(monoData, dstData, 0, -1, (byte)0, blobList);
		Coordinates coordinates = new Coordinates();
		// List Blobs
		long mass=0;
		for (BlobFinder.Blob blob : blobList) {
			mass+=blob.mass;
			coordinates.x+=(blob.xMin+blob.xMax)*blob.mass/2;
			coordinates.y+=(blob.yMin+blob.yMax)*blob.mass/2;
		}
		coordinates.x=coordinates.x/mass;
		coordinates.y=coordinates.y/mass;
		return coordinates;
	}
	
	  private static BufferedImage convertToARGB(BufferedImage srcImage) {
	    BufferedImage newImage = new BufferedImage(srcImage.getWidth(null),
	        srcImage.getHeight(null), BufferedImage.TYPE_3BYTE_BGR);
	    Graphics bg = newImage.getGraphics();
	    bg.drawImage(srcImage, 0, 0, null);
	    bg.dispose();
	    return newImage;
	  }

}
