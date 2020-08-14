<%@ page import="org.apache.pdfbox.pdmodel.font.*,org.apache.pdfbox.util.*,org.apache.pdfbox.pdmodel.*,java.nio.channels.*,java.nio.*,java.awt.*,com.sun.pdfview.*,com.google.zxing.*,javax.imageio.*,com.google.zxing.client.j2se.*,com.google.zxing.common.*,java.io.*,java.util.*,java.awt.image.*" %>

<%!

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
	        e.printStackTrace();
	        //throw new BarcodeEngine().new BarcodeEngineException(e.getMessage());
	    }
	    return finalResult;
	}
%>
<%
	PDDocument document = PDDocument.loadNonSeq(new File("c:\\temp\\a.pdf"), null);
	java.util.List<PDPage> pdPages = document.getDocumentCatalog().getAllPages();
	int mypage = 0;
	for (PDPage pdPage : pdPages)
	{ 
	    ++mypage;
	    BufferedImage bim = pdPage.convertToImage(BufferedImage.TYPE_INT_RGB, 300);
	    String barcode=decode2(bim,null);
	    if(barcode.length()>0){
		    out.println(barcode);
			break;		    	
	    }
	    else {
		    for(int n=0;n<bim.getHeight()*9/10;n+=bim.getHeight()/10){
			    BufferedImage cropedImage = bim.getSubimage(0, n, bim.getWidth(), bim.getHeight()/10);
			    barcode=decode(cropedImage,null);
			    if(barcode.length()>0){
				    out.println(barcode);
					break;		    	
			    }
		    }
	    }
	}
	document.close();
%>