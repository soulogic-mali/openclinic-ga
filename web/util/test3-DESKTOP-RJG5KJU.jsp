<%@page import="be.openclinic.archiving.*,com.pixelmed.dicom.AttributeList,com.pixelmed.display.*,ij.*,ij.io.*,java.awt.image.*,java.awt.*,javax.imageio.*,java.io.*,be.mxs.common.util.system.*,be.openclinic.finance.*,be.mxs.common.util.db.MedwanQuery,java.sql.*,java.util.*,be.openclinic.knowledge.*"%>
<%
	String dicomfile="/temp/00000342963.dcm";
	Dcm2JpgOld dcm2Jpg = new Dcm2JpgOld();
	dcm2Jpg.convert(new File(dicomfile), new File("/temp/test.jpg"));
	//ConsumerFormatImageMaker.convertFileToEightBitImage(dicomfile,"/temp/test.png","png",0,0,0,0,20,null);
%>
