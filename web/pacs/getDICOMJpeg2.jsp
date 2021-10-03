<%@page import="java.sql.*,java.io.*,java.util.*"%>
<%@page import="be.mxs.common.util.db.MedwanQuery"%>
<%@page import="be.openclinic.archiving.*"%><%
	String sFile=new java.util.Date().getTime()+"";
String sFilename=MedwanQuery.getInstance().getConfigString("mpiTempDirectory","/users/frank/google drive/projects/openclinicnew/web/mpi/temp")+"/"+sFile+".jpg";
String sFilename2=MedwanQuery.getInstance().getConfigString("mpiTempURL","http://localhost/openclinic/mpi/temp")+"/"+sFile+".jpg";
try{
	String uid = request.getParameter("uid");
	response.setContentType("application/octet-stream");
	Connection conn = MedwanQuery.getInstance().getOpenclinicConnection();
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
		File parent = new File(MedwanQuery.getInstance().getConfigString("mpiTempDirectory","/users/frank/google drive/projects/openclinicnew/web/mpi/temp"));
		if(!parent.exists()){
	parent.mkdirs();
		}
		String dicomfile=MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_basePath","/var/tomcat/webapps/openclinic/scan")+"/"+MedwanQuery.getInstance().getConfigString("scanDirectoryMonitor_dirTo","to")+"/"+rs.getString("OC_PACS_FILENAME");
		Thread.sleep(new Double(Math.random()*100).longValue());
		Dcm2Jpg dcm2Jpg = new Dcm2Jpg();
		dcm2Jpg.convert(new File(dicomfile), new File(sFilename));
		File outFile = new File(sFilename);
        String path = outFile.getParent();
        ScannableFileFilter fileFilter = new ScannableFileFilter(""); 
        File scanDir = new File(path);
    	File[] scannableFiles = scanDir.listFiles(fileFilter);
    	for(int n=0;n<scannableFiles.length;n++){
    		if(new java.util.Date().getTime()-scannableFiles[n].lastModified()>300000){
    			scannableFiles[n].delete();
    		}
    	}
	}
	rs.close();
	ps.close();
	conn.close();
}
catch(Exception e){
	e.printStackTrace();
}
%>
{ "filename" : "<%=sFilename2 %>"}
