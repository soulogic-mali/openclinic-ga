<%@page import="javax.imageio.*"%>
<%
	ImageIO.scanForPlugins();
	java.util.Iterator<ImageReader> iterator = ImageIO.getImageReadersByFormatName("DICOM");
	while(iterator.hasNext()){
		System.out.println(iterator.next().getClass());
	}

%>