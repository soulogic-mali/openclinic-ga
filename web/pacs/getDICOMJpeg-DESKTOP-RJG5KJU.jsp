<%@page import="java.sql.*,java.io.*,java.util.*,javax.imageio.*,org.dcm4che3.imageio.plugins.dcm.*"%><%@page import="be.mxs.common.util.db.MedwanQuery"%><%@page import="be.openclinic.archiving.*"%><%
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
			DicomUtils.exportToJpeg(dicomfile, os);
		}
		catch(Exception a){
			a.printStackTrace();
		}
	}
	rs.close();
	ps.close();
	conn.close();
    os.flush();
    os.close();%>