<%@page import="java.sql.*,java.io.*,java.util.*,javax.imageio.*,org.dcm4che2.imageio.plugins.dcm.*"%><%@page import="be.mxs.common.util.db.MedwanQuery"%><%@page import="be.openclinic.archiving.*"%><%
try{
	if(!ImageIO.getImageReadersByFormatName("DICOM").hasNext()){
    	ImageIO.scanForPlugins();
	}
	else{
    	Iterator<ImageReader>iterator = ImageIO.getImageReadersByFormatName("DICOM");
    	ImageReader reader = iterator.next();
        DicomImageReadParam param = (DicomImageReadParam) reader.getDefaultReadParam();
	}
}
catch(Exception e){
	ImageIO.scanForPlugins();
	e.printStackTrace();
}
	String uid = request.getParameter("uid");
	response.setContentType("image/jpeg");
	ServletOutputStream os = response.getOutputStream();
	Connection conn = MedwanQuery.getInstance(true).getOpenclinicConnection();
	PreparedStatement ps = conn.prepareStatement("select * from OC_PACS where OC_PACS_STUDYUID=? and OC_PACS_SERIES=? order by OC_PACS_SEQUENCE*1");
	ps.setString(1,uid.split(";")[0]);
	ps.setString(2,uid.split(";")[1]);
	ResultSet rs = ps.executeQuery();
	if(request.getParameter("skipImages")!=null){
		for(int n=0;n<Integer.parseInt(request.getParameter("skipImages"));n++){
			rs.next();
		}
	}
	if(rs.next()){
		String dicomfile=MedwanQuery.getInstance(true).getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+rs.getString("OC_PACS_FILENAME");
		try{
			Dcm2Jpg dcm2Jpg = new Dcm2Jpg();
			dcm2Jpg.convert(new File(dicomfile), os, session);
		}
		catch(Exception a){
			a.printStackTrace();
		}
	}
	rs.close();
	ps.close();
	conn.close();
    os.flush();
    os.close();
%>